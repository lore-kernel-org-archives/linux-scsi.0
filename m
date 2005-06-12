From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] convert ch to use scsi_execute_req
Date: Sun, 12 Jun 2005 12:37:10 -0500
Message-ID: <1118597830.4967.17.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:26331 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262660AbVFLRhY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Jun 2005 13:37:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Gerd Knorr <kraxel@bytesex.org>, Jens Axboe <axboe@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

I also tinkered with it's sense recognition routines to make them take
scsi_sense_hdr structures instead of raw sense data.

James
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -31,7 +31,7 @@
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
-#include <scsi/scsi_request.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_dbg.h>
 
 #define CH_DT_MAX       16
@@ -181,17 +181,17 @@ static struct {
 
 /* -------------------------------------------------------------------
*/
 
-static int ch_find_errno(unsigned char *sense_buffer)
+static int ch_find_errno(struct scsi_sense_hdr *sshdr)
 {
 	int i,errno = 0;
 
 	/* Check to see if additional sense information is available */
-	if (sense_buffer[7]  > 5 &&
-	    sense_buffer[12] != 0) {
+	if (scsi_sense_valid(sshdr) &&
+	    sshdr->asc != 0) {
 		for (i = 0; err[i].errno != 0; i++) {
-			if (err[i].sense == sense_buffer[ 2] &&
-			    err[i].asc   == sense_buffer[12] &&
-			    err[i].ascq  == sense_buffer[13]) {
+			if (err[i].sense == sshdr->sense_key &&
+			    err[i].asc   == sshdr->asc &&
+			    err[i].ascq  == sshdr->ascq) {
 				errno = -err[i].errno;
 				break;
 			}
@@ -207,13 +207,9 @@ ch_do_scsi(scsi_changer *ch, unsigned ch
 	   void *buffer, unsigned buflength,
 	   enum dma_data_direction direction)
 {
-	int errno, retries = 0, timeout;
-	struct scsi_request *sr;
+	int errno, retries = 0, timeout, result;
+	struct scsi_sense_hdr sshdr;
 	
-	sr = scsi_allocate_request(ch->device, GFP_KERNEL);
-	if (NULL == sr)
-		return -ENOMEM;
-
 	timeout = (cmd[0] == INITIALIZE_ELEMENT_STATUS)
 		? timeout_init : timeout_move;
 
@@ -224,16 +220,17 @@ ch_do_scsi(scsi_changer *ch, unsigned ch
 		__scsi_print_command(cmd);
 	}
 
-        scsi_wait_req(sr, cmd, buffer, buflength,
-		      timeout * HZ, MAX_RETRIES);
+        result = scsi_execute_req(ch->device, cmd, direction, buffer,
+				  buflength, &sshdr, timeout * HZ,
+				  MAX_RETRIES);
 
-	dprintk("result: 0x%x\n",sr->sr_result);
-	if (driver_byte(sr->sr_result) & DRIVER_SENSE) {
+	dprintk("result: 0x%x\n",result);
+	if (driver_byte(result) & DRIVER_SENSE) {
 		if (debug)
-			scsi_print_req_sense(ch->name, sr);
-		errno = ch_find_errno(sr->sr_sense_buffer);
+			scsi_print_sense_hdr(ch->name, &sshdr);
+		errno = ch_find_errno(&sshdr);
 
-		switch(sr->sr_sense_buffer[2] & 0xf) {
+		switch(sshdr.sense_key) {
 		case UNIT_ATTENTION:
 			ch->unit_attention = 1;
 			if (retries++ < 3)
@@ -241,7 +238,6 @@ ch_do_scsi(scsi_changer *ch, unsigned ch
 			break;
 		}
 	}
-	scsi_release_request(sr);
 	return errno;
 }
 




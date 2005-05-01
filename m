From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] fix command retries in spi_transport class
Date: Sun, 01 May 2005 18:58:15 -0500
Message-ID: <1114991896.4788.44.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:42634 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261402AbVEAX6Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 May 2005 19:58:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "K.R. Foley" <kr@cybsft.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This will likely fix the adaptec domain validation problem.  However,
it's not a true fix if the mid-layer is losing commands, it just makes
it far less likely to get into that situation.

The premise is that domain validation is likely to trigger errors which
it wants to know about, so the only time it should be retrying them is
when it gets a unit attention (likely as the result of a previous bus or
device reset).  Ironically, the previous coding retried three times in
all cases except those of unit attention.  The attached fixes this to do
the right thing.

James

--- k/drivers/scsi/scsi_transport_spi.c  (mode:100644)
+++ l/drivers/scsi/scsi_transport_spi.c  (mode:100644)
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/workqueue.h>
+#include <linux/blkdev.h>
 #include <asm/semaphore.h>
 #include <scsi/scsi.h>
 #include "scsi_priv.h"
@@ -41,6 +42,11 @@
 
 #define SPI_MAX_ECHO_BUFFER_SIZE	4096
 
+#define DV_LOOPS	3
+#define DV_TIMEOUT	(10*HZ)
+#define DV_RETRIES	3	/* should only need at most 
+				 * two cc/ua clears */
+
 /* Private data accessors (keep these out of the header file) */
 #define spi_dv_pending(x) (((struct spi_transport_attrs *)&(x)->starget_data)->dv_pending)
 #define spi_dv_sem(x) (((struct spi_transport_attrs *)&(x)->starget_data)->dv_sem)
@@ -100,6 +106,29 @@ static int sprint_frac(char *dest, int v
 	return result;
 }
 
+/* Modification of scsi_wait_req that will clear UNIT ATTENTION conditions
+ * resulting from (likely) bus and device resets */
+static void spi_wait_req(struct scsi_request *sreq, const void *cmd,
+			 void *buffer, unsigned bufflen)
+{
+	int i;
+
+	for(i = 0; i < DV_RETRIES; i++) {
+		sreq->sr_request->flags |= REQ_FAILFAST;
+
+		scsi_wait_req(sreq, cmd, buffer, bufflen,
+			      DV_TIMEOUT, /* retries */ 1);
+		if (sreq->sr_result & DRIVER_SENSE) {
+			struct scsi_sense_hdr sshdr;
+
+			if (scsi_request_normalize_sense(sreq, &sshdr)
+			    && sshdr.sense_key == UNIT_ATTENTION)
+				continue;
+		}
+		break;
+	}
+}
+
 static struct {
 	enum spi_signal_type	value;
 	char			*name;
@@ -378,11 +407,6 @@ static CLASS_DEVICE_ATTR(signalling, S_I
 	if(i->f->set_##x)		\
 		i->f->set_##x(sdev->sdev_target, y)
 
-#define DV_LOOPS	3
-#define DV_TIMEOUT	(10*HZ)
-#define DV_RETRIES	3	/* should only need at most 
-				 * two cc/ua clears */
-
 enum spi_compare_returns {
 	SPI_COMPARE_SUCCESS,
 	SPI_COMPARE_FAILURE,
@@ -446,8 +470,7 @@ spi_dv_device_echo_buffer(struct scsi_re
 	for (r = 0; r < retries; r++) {
 		sreq->sr_cmd_len = 0;	/* wait_req to fill in */
 		sreq->sr_data_direction = DMA_TO_DEVICE;
-		scsi_wait_req(sreq, spi_write_buffer, buffer, len,
-			      DV_TIMEOUT, DV_RETRIES);
+		spi_wait_req(sreq, spi_write_buffer, buffer, len);
 		if(sreq->sr_result || !scsi_device_online(sdev)) {
 			struct scsi_sense_hdr sshdr;
 
@@ -471,8 +494,7 @@ spi_dv_device_echo_buffer(struct scsi_re
 		memset(ptr, 0, len);
 		sreq->sr_cmd_len = 0;	/* wait_req to fill in */
 		sreq->sr_data_direction = DMA_FROM_DEVICE;
-		scsi_wait_req(sreq, spi_read_buffer, ptr, len,
-			      DV_TIMEOUT, DV_RETRIES);
+		spi_wait_req(sreq, spi_read_buffer, ptr, len);
 		scsi_device_set_state(sdev, SDEV_QUIESCE);
 
 		if (memcmp(buffer, ptr, len) != 0)
@@ -500,8 +522,7 @@ spi_dv_device_compare_inquiry(struct scs
 
 		memset(ptr, 0, len);
 
-		scsi_wait_req(sreq, spi_inquiry, ptr, len,
-			      DV_TIMEOUT, DV_RETRIES);
+		spi_wait_req(sreq, spi_inquiry, ptr, len);
 		
 		if(sreq->sr_result || !scsi_device_online(sdev)) {
 			scsi_device_set_state(sdev, SDEV_QUIESCE);
@@ -593,8 +614,7 @@ spi_dv_device_get_echo_buffer(struct scs
 	 * (reservation conflict, device not ready, etc) just
 	 * skip the write tests */
 	for (l = 0; ; l++) {
-		scsi_wait_req(sreq, spi_test_unit_ready, NULL, 0,
-			      DV_TIMEOUT, DV_RETRIES);
+		spi_wait_req(sreq, spi_test_unit_ready, NULL, 0);
 
 		if(sreq->sr_result) {
 			if(l >= 3)
@@ -608,8 +628,7 @@ spi_dv_device_get_echo_buffer(struct scs
 	sreq->sr_cmd_len = 0;
 	sreq->sr_data_direction = DMA_FROM_DEVICE;
 
-	scsi_wait_req(sreq, spi_read_buffer_descriptor, buffer, 4,
-		      DV_TIMEOUT, DV_RETRIES);
+	spi_wait_req(sreq, spi_read_buffer_descriptor, buffer, 4);
 
 	if (sreq->sr_result)
 		/* Device has no echo buffer */



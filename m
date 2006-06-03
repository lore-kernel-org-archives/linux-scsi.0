From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] sbp2: remove broken inquiry mangling
Date: Sat, 3 Jun 2006 13:35:49 +0200
Message-ID: <20060603113549.GA17297@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:63447 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1750827AbWFCLfv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Jun 2006 07:35:51 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stefanr@s5r6.in-berlin.de
Cc: linux-scsi@vger.kernel.org

scsi_cmnd.request_buffer is always a scatterlist these days.  Checking
random bites into it and then mangling the data in
sbp2_check_sbp2_response will cause really bad memory corruption when
you're not lucky enough to have the check not trigger by luck.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/ieee1394/sbp2.c
===================================================================
--- scsi-misc-2.6.orig/drivers/ieee1394/sbp2.c	2006-06-02 18:20:18.000000000 +0200
+++ scsi-misc-2.6/drivers/ieee1394/sbp2.c	2006-06-03 13:28:23.000000000 +0200
@@ -2038,33 +2038,6 @@
 }
 
 /*
- * This function is called after a command is completed, in order to do any necessary SBP-2
- * response data translations for the SCSI stack
- */
-static void sbp2_check_sbp2_response(struct scsi_id_instance_data *scsi_id,
-				     struct scsi_cmnd *SCpnt)
-{
-	u8 *scsi_buf = SCpnt->request_buffer;
-
-	SBP2_DEBUG_ENTER();
-
-	if (SCpnt->cmnd[0] == INQUIRY && (SCpnt->cmnd[1] & 3) == 0) {
-		/*
-		 * Make sure data length is ok. Minimum length is 36 bytes
-		 */
-		if (scsi_buf[4] == 0) {
-			scsi_buf[4] = 36 - 5;
-		}
-
-		/*
-		 * Fix ansi revision and response data format
-		 */
-		scsi_buf[2] |= 2;
-		scsi_buf[3] = (scsi_buf[3] & 0xf0) | 2;
-	}
-}
-
-/*
  * This function deals with status writes from the SBP-2 device
  */
 static int sbp2_handle_status_write(struct hpsb_host *host, int nodeid, int destid,
@@ -2403,13 +2376,6 @@
 	}
 
 	/*
-	 * Take care of any sbp2 response data mucking here (RBC stuff, etc.)
-	 */
-	if (SCpnt->result == DID_OK << 16) {
-		sbp2_check_sbp2_response(scsi_id, SCpnt);
-	}
-
-	/*
 	 * If a bus reset is in progress and there was an error, complete
 	 * the command as busy so that it will get retried.
 	 */
Index: scsi-misc-2.6/drivers/ieee1394/sbp2.h
===================================================================
--- scsi-misc-2.6.orig/drivers/ieee1394/sbp2.h	2006-06-02 18:20:18.000000000 +0200
+++ scsi-misc-2.6/drivers/ieee1394/sbp2.h	2006-06-03 13:33:08.000000000 +0200
@@ -398,8 +398,6 @@
 			     struct scsi_cmnd *SCpnt,
 			     void (*done)(struct scsi_cmnd *));
 static unsigned int sbp2_status_to_sense_data(unchar *sbp2_status, unchar *sense_data);
-static void sbp2_check_sbp2_response(struct scsi_id_instance_data *scsi_id,
-				     struct scsi_cmnd *SCpnt);
 static void sbp2_parse_unit_directory(struct scsi_id_instance_data *scsi_id,
 				      struct unit_directory *ud);
 static int sbp2_set_busy_timeout(struct scsi_id_instance_data *scsi_id);

From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [RFC PATCH] sbp2: remove manipulation of inquiry response
Date: Sat, 8 Apr 2006 20:45:24 +0200 (CEST)
Message-ID: <tkrat.d3b4470a9a767dd4@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:52356 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S965038AbWDHSqq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Apr 2006 14:46:46 -0400
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux1394-devel@lists.sourceforge.net

This code became ineffective a few Linux releases ago and is
apparently not required anyway.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Index: linux-2.6.17-rc1/drivers/ieee1394/sbp2.c
===================================================================
--- linux-2.6.17-rc1.orig/drivers/ieee1394/sbp2.c	2006-04-08 09:43:33.000000000 +0200
+++ linux-2.6.17-rc1/drivers/ieee1394/sbp2.c	2006-04-08 20:40:00.000000000 +0200
@@ -2079,33 +2079,6 @@ static unsigned int sbp2_status_to_sense
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
@@ -2444,13 +2417,6 @@ static void sbp2scsi_complete_command(st
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
Index: linux-2.6.17-rc1/drivers/ieee1394/sbp2.h
===================================================================
--- linux-2.6.17-rc1.orig/drivers/ieee1394/sbp2.h	2006-04-08 09:43:32.000000000 +0200
+++ linux-2.6.17-rc1/drivers/ieee1394/sbp2.h	2006-04-08 20:40:00.000000000 +0200
@@ -394,9 +394,8 @@ static int sbp2_link_orb_command(struct 
 static int sbp2_send_command(struct scsi_id_instance_data *scsi_id,
 			     struct scsi_cmnd *SCpnt,
 			     void (*done)(struct scsi_cmnd *));
-static unsigned int sbp2_status_to_sense_data(unchar *sbp2_status, unchar *sense_data);
-static void sbp2_check_sbp2_response(struct scsi_id_instance_data *scsi_id,
-				     struct scsi_cmnd *SCpnt);
+static unsigned int sbp2_status_to_sense_data(unchar *sbp2_status,
+					      unchar *sense_data);
 static void sbp2_parse_unit_directory(struct scsi_id_instance_data *scsi_id,
 				      struct unit_directory *ud);
 static int sbp2_set_busy_timeout(struct scsi_id_instance_data *scsi_id);



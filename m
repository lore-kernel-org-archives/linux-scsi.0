From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: sbp2: pass REQUEST_SENSE through to the target
Date: Thu, 28 Dec 2006 19:57:49 +0100 (CET)
Message-ID: <tkrat.9e24970727f8c664@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:47463 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926AbWL1S54 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Dec 2006 13:57:56 -0500
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org

Delete some incorrect code, left over from the initial driver submission
in March 2001.

SBP-2 targets should provide sense data via the SBP-2 status block
(autosense).  We have to pass the REQUEST_SENSE command through to
targets which don't implement autosense, if there are any.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -1880,16 +1880,6 @@ static int sbp2scsi_queuecommand(struct 
 	if (unlikely(SCpnt->device->lun))
 		goto done;
 
-	/* handle the request sense command here (auto-request sense) */
-	if (SCpnt->cmnd[0] == REQUEST_SENSE) {
-		memcpy(SCpnt->request_buffer, SCpnt->sense_buffer,
-		       SCpnt->request_bufflen);
-		memset(SCpnt->sense_buffer, 0, sizeof(SCpnt->sense_buffer));
-		sbp2scsi_complete_command(lu, SBP2_SCSI_STATUS_GOOD, SCpnt,
-					  done);
-		return 0;
-	}
-
 	if (unlikely(!hpsb_node_entry_valid(lu->ne))) {
 		SBP2_ERR("Bus reset in progress - rejecting command");
 		result = DID_BUS_BUSY << 16;

-- 
Stefan Richter
-=====-=-==- ==-- ===--
http://arcgraph.de/sr/


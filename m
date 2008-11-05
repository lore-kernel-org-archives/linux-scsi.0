From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi: clean up scsi_times_out
Date: Wed, 5 Nov 2008 15:03:15 +0100
Message-ID: <20081105140315.GA5012@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:52857 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbYKEODV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Nov 2008 09:03:21 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

Make sure the control flow in scsi_times_out makes sense.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_error.c	2008-10-11 09:55:27.000000000 +0200
+++ linux-2.6/drivers/scsi/scsi_error.c	2008-10-11 09:59:11.000000000 +0200
@@ -124,33 +124,22 @@ int scsi_eh_scmd_add(struct scsi_cmnd *s
 enum blk_eh_timer_return scsi_times_out(struct request *req)
 {
 	struct scsi_cmnd *scmd = req->special;
-	enum blk_eh_timer_return (*eh_timed_out)(struct scsi_cmnd *);
 	enum blk_eh_timer_return rtn = BLK_EH_NOT_HANDLED;
 
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
 
 	if (scmd->device->host->transportt->eh_timed_out)
-		eh_timed_out = scmd->device->host->transportt->eh_timed_out;
+		rtn = scmd->device->host->transportt->eh_timed_out(scmd);
 	else if (scmd->device->host->hostt->eh_timed_out)
-		eh_timed_out = scmd->device->host->hostt->eh_timed_out;
-	else
-		eh_timed_out = NULL;
+		rtn = scmd->device->host->hostt->eh_timed_out(scmd);
 
-	if (eh_timed_out)
-		rtn = eh_timed_out(scmd);
-		switch (rtn) {
-		case BLK_EH_NOT_HANDLED:
-			break;
-		default:
-			return rtn;
-		}
-
-	if (unlikely(!scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))) {
+	if (unlikely(rtn == BLK_EH_NOT_HANDLED &&
+		     !scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))) {
 		scmd->result |= DID_TIME_OUT << 16;
-		return BLK_EH_HANDLED;
+		rtn = BLK_EH_HANDLED;
 	}
 
-	return BLK_EH_NOT_HANDLED;
+	return rtn;
 }
 
 /**

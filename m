From: michaelc@cs.wisc.edu
Subject: [PATCH 6/6] libiscsi: Use SCSI_MLQUEUE_TARGET_BUSY
Date: Sun, 17 Aug 2008 15:24:43 -0500
Message-ID: <1219004683-6468-7-git-send-email-michaelc@cs.wisc.edu>
References: <1219004683-6468-1-git-send-email-michaelc@cs.wisc.edu>
 <1219004683-6468-2-git-send-email-michaelc@cs.wisc.edu>
 <1219004683-6468-3-git-send-email-michaelc@cs.wisc.edu>
 <1219004683-6468-4-git-send-email-michaelc@cs.wisc.edu>
 <1219004683-6468-5-git-send-email-michaelc@cs.wisc.edu>
 <1219004683-6468-6-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47582 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbYHQUZ0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Aug 2008 16:25:26 -0400
In-Reply-To: <1219004683-6468-6-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

For the conditions below we do not want the queuecommand
function to call us right back, so return SCSI_MLQUEUE_TARGET_BUSY.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 299e075..fcb0de9 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1194,12 +1194,10 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 		switch (session->state) {
 		case ISCSI_STATE_IN_RECOVERY:
 			reason = FAILURE_SESSION_IN_RECOVERY;
-			sc->result = DID_IMM_RETRY << 16;
-			break;
+			goto reject;
 		case ISCSI_STATE_LOGGING_OUT:
 			reason = FAILURE_SESSION_LOGGING_OUT;
-			sc->result = DID_IMM_RETRY << 16;
-			break;
+			goto reject;
 		case ISCSI_STATE_RECOVERY_FAILED:
 			reason = FAILURE_SESSION_RECOVERY_TIMEOUT;
 			sc->result = DID_NO_CONNECT << 16;
@@ -1267,7 +1265,7 @@ reject:
 	spin_unlock(&session->lock);
 	debug_scsi("cmd 0x%x rejected (%d)\n", sc->cmnd[0], reason);
 	spin_lock(host->host_lock);
-	return SCSI_MLQUEUE_HOST_BUSY;
+	return SCSI_MLQUEUE_TARGET_BUSY;
 
 fault:
 	spin_unlock(&session->lock);
-- 
1.5.4.1


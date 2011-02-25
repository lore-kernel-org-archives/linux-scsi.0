From: michaelc@cs.wisc.edu
Subject: [PATCH 2/2] lpfc: block target when port queueing limit is hit
Date: Fri, 25 Feb 2011 14:04:28 -0600
Message-ID: <1298664268-12967-3-git-send-email-michaelc@cs.wisc.edu>
References: <1298664268-12967-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932920Ab1BYUEr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 15:04:47 -0500
In-Reply-To: <1298664268-12967-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.smart@emulex.com, Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Instead of blocking the entire host when the port's
queueing limit is hit, we should only block the port's
target. This will allow IO to other ports to execute.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/lpfc/lpfc_scsi.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index af5aaaa..63a81a4 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3008,7 +3008,7 @@ lpfc_queuecommand_lck(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 		goto out_fail_command;
 	}
 	if (atomic_read(&ndlp->cmd_pending) >= ndlp->cmd_qdepth)
-		goto out_host_busy;
+		goto out_tgt_busy;
 
 	lpfc_cmd = lpfc_get_scsi_buf(phba, ndlp);
 	if (lpfc_cmd == NULL) {
@@ -3125,6 +3125,9 @@ lpfc_queuecommand_lck(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
  out_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
 
+ out_tgt_busy:
+	return SCSI_MLQUEUE_TARGET_BUSY;
+
  out_fail_command:
 	done(cmnd);
 	return 0;
-- 
1.7.2.3


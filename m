From: michaelc@cs.wisc.edu
Subject: [PATCH 1/2] lpfc: force retry in queuecommand when port is transitioning
Date: Fri, 25 Feb 2011 14:04:27 -0600
Message-ID: <1298664268-12967-2-git-send-email-michaelc@cs.wisc.edu>
References: <1298664268-12967-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932920Ab1BYUEm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 15:04:42 -0500
In-Reply-To: <1298664268-12967-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.smart@emulex.com, Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If the port takes a while to transition we could exhaust
the retries when using DID_TRANSPORT_DISRUPTED. For this
case we do not want to use any of the cmd's
retries, because if the command was running then when
it got failed the retry counter was already incremented.
And if this is the first time we are seeing the command,
(it got queued because it slipped through during the race)
then it should not have its retries incremented. The
fc class will decide the correct handling later.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/lpfc/lpfc_scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index c97751c..af5aaaa 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3004,7 +3004,7 @@ lpfc_queuecommand_lck(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 	 * transport is still transitioning.
 	 */
 	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
-		cmnd->result = ScsiResult(DID_TRANSPORT_DISRUPTED, 0);
+		cmnd->result = ScsiResult(DID_IMM_RETRY, 0);
 		goto out_fail_command;
 	}
 	if (atomic_read(&ndlp->cmd_pending) >= ndlp->cmd_qdepth)
-- 
1.7.2.3


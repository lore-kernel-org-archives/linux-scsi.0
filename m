From: Roland Dreier <roland@kernel.org>
Subject: [PATCH] qla2xxx: Fix sign of FCP_RESID field for status with RESID_OVER
Date: Thu, 23 Feb 2012 12:14:02 -0800
Message-ID: <1330028042-15599-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog109.obsmtp.com ([74.125.245.86]:48573 "HELO
	na3sys010aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755057Ab2BWUOK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Feb 2012 15:14:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

We don't need to change the sign of our prm->residual field; the target
core sets a flag to distinguish overflow and underflow, but
se_cmd->residual_count is always positive.  The existing code seems to
be a carryover from the port from scst, which uses the sign of the
residual field to distinguish overflow and underflow.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/qla2xxx/qla_target.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 9282014..b12fb84 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1808,7 +1808,6 @@ static int qla_tgt_pre_xmit_response(struct qla_tgt_cmd *cmd, struct qla_tgt_prm
 			se_cmd->t_task_cdb ? se_cmd->t_task_cdb[0] : 0,
 			cmd->bufflen, prm->rq_result);
 		prm->rq_result |= SS_RESIDUAL_OVER;
-		prm->residual = -prm->residual;
 	}
 
 	if (xmit_type & QLA_TGT_XMIT_STATUS) {
-- 
1.7.9


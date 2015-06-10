From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 6/9] qla2xxx: Remove msleep in qlt_send_term_exchange
Date: Wed, 10 Jun 2015 11:05:22 -0400
Message-ID: <1433948725-4073-7-git-send-email-himanshu.madhani@qlogic.com>
References: <1433948725-4073-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:29850 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965985AbbFJPtK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2015 11:49:10 -0400
In-Reply-To: <1433948725-4073-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Remove unnecessary msleep from qlt_send_term_exchange as it
adds latency of 250 msec while sending terminate exchange to
an aborted task.

Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 2477602..b72cda6 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2715,7 +2715,7 @@ static int __qlt_send_term_exchange(struct scsi_qla_host *vha,
 static void qlt_send_term_exchange(struct scsi_qla_host *vha,
 	struct qla_tgt_cmd *cmd, struct atio_from_isp *atio, int ha_locked)
 {
-	unsigned long flags;
+	unsigned long flags = 0;
 	int rc;
 
 	if (qlt_issue_marker(vha, ha_locked) < 0)
@@ -2731,17 +2731,18 @@ static void qlt_send_term_exchange(struct scsi_qla_host *vha,
 	rc = __qlt_send_term_exchange(vha, cmd, atio);
 	if (rc == -ENOMEM)
 		qlt_alloc_qfull_cmd(vha, atio, 0, 0);
-	spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
 
 done:
 	if (cmd && ((cmd->state != QLA_TGT_STATE_ABORTED) ||
 	    !cmd->cmd_sent_to_fw)) {
-		if (!ha_locked && !in_interrupt())
-			msleep(250); /* just in case */
-
-		qlt_unmap_sg(vha, cmd);
+		if (cmd->sg_mapped)
+			qlt_unmap_sg(vha, cmd);
 		vha->hw->tgt.tgt_ops->free_cmd(cmd);
 	}
+
+	if (!ha_locked)
+		spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
+
 	return;
 }
 
-- 
1.7.7


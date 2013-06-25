From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 02/16] qla2xxx: Set the index in outstanding command array to NULL when cmd is aborted when the request timeout.
Date: Tue, 25 Jun 2013 11:27:17 -0400
Message-ID: <1372174051-4211-3-git-send-email-saurav.kashyap@qlogic.com>
References: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:53832 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752204Ab3FYPxy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jun 2013 11:53:54 -0400
Received: from mail227-tx2 (localhost [127.0.0.1])	by
 mail227-tx2-R.bigfish.com (Postfix) with ESMTP id 9D95CAC01A6	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:51 +0000 (UTC)
Received: from TX2EHSMHS027.bigfish.com (unknown [10.9.14.244])	by
 mail227-tx2.bigfish.com (Postfix) with ESMTP id 3424332006C	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:49 +0000 (UTC)
In-Reply-To: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Call the generic BSG free routine to unmap the DMA buffers.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 39719f8..5ba0cc1 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2153,6 +2153,7 @@ qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
 					(sp->type == SRB_ELS_CMD_HST) ||
 					(sp->type == SRB_FXIOCB_BCMD))
 					&& (sp->u.bsg_job == bsg_job)) {
+					req->outstanding_cmds[cnt] = NULL;
 					spin_unlock_irqrestore(&ha->hardware_lock, flags);
 					if (ha->isp_ops->abort_command(sp)) {
 						ql_log(ql_log_warn, vha, 0x7089,
@@ -2180,8 +2181,6 @@ qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
 
 done:
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	if (bsg_job->request->msgcode == FC_BSG_HST_CT)
-		kfree(sp->fcport);
-	qla2x00_rel_sp(vha, sp);
+	sp->free(vha, sp);
 	return 0;
 }
-- 
1.7.7



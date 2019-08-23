Return-Path: <SRS0=qm3h=WT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51AB3C3A5A2
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 13:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EA9222CEC
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 13:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388524AbfHWNQw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Aug 2019 09:16:52 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5647 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388042AbfHWNQv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Aug 2019 09:16:51 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 035A8D7C1A689CEC07D8;
        Fri, 23 Aug 2019 21:16:34 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Fri, 23 Aug 2019
 21:16:23 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <QLogic-Storage-Upstream@qlogic.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH 3/3] scsi: bnx2fc: remove set but not used variables 'task','port','orig_task'
Date:   Fri, 23 Aug 2019 21:22:53 +0800
Message-ID: <1566566573-49300-4-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566566573-49300-1-git-send-email-zhengbin13@huawei.com>
References: <1566566573-49300-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/bnx2fc/bnx2fc_hwi.c: In function bnx2fc_process_unsol_compl:
drivers/scsi/bnx2fc/bnx2fc_hwi.c:636:30: warning: variable task set but not used [-Wunused-but-set-variable]
drivers/scsi/bnx2fc/bnx2fc_hwi.c: In function bnx2fc_process_ofld_cmpl:
drivers/scsi/bnx2fc/bnx2fc_hwi.c:1125:21: warning: variable port set but not used [-Wunused-but-set-variable]
drivers/scsi/bnx2fc/bnx2fc_hwi.c: In function bnx2fc_init_seq_cleanup_task:
drivers/scsi/bnx2fc/bnx2fc_hwi.c:1468:30: warning: variable orig_task set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 747f019..f069e09 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -633,7 +633,6 @@ static void bnx2fc_process_unsol_compl(struct bnx2fc_rport *tgt, u16 wqe)
 	u16 xid;
 	u32 frame_len, len;
 	struct bnx2fc_cmd *io_req = NULL;
-	struct fcoe_task_ctx_entry *task, *task_page;
 	struct bnx2fc_interface *interface = tgt->port->priv;
 	struct bnx2fc_hba *hba = interface->hba;
 	int task_idx, index;
@@ -711,9 +710,6 @@ static void bnx2fc_process_unsol_compl(struct bnx2fc_rport *tgt, u16 wqe)

 		task_idx = xid / BNX2FC_TASKS_PER_PAGE;
 		index = xid % BNX2FC_TASKS_PER_PAGE;
-		task_page = (struct fcoe_task_ctx_entry *)
-					hba->task_ctx[task_idx];
-		task = &(task_page[index]);

 		io_req = (struct bnx2fc_cmd *)hba->cmd_mgr->cmds[xid];
 		if (!io_req)
@@ -839,9 +835,6 @@ static void bnx2fc_process_unsol_compl(struct bnx2fc_rport *tgt, u16 wqe)

 		task_idx = xid / BNX2FC_TASKS_PER_PAGE;
 		index = xid % BNX2FC_TASKS_PER_PAGE;
-		task_page = (struct fcoe_task_ctx_entry *)
-			     interface->hba->task_ctx[task_idx];
-		task = &(task_page[index]);
 		io_req = (struct bnx2fc_cmd *)hba->cmd_mgr->cmds[xid];
 		if (!io_req)
 			goto ret_warn_rqe;
@@ -1122,7 +1115,6 @@ static void bnx2fc_process_ofld_cmpl(struct bnx2fc_hba *hba,
 					struct fcoe_kcqe *ofld_kcqe)
 {
 	struct bnx2fc_rport		*tgt;
-	struct fcoe_port		*port;
 	struct bnx2fc_interface		*interface;
 	u32				conn_id;
 	u32				context_id;
@@ -1136,7 +1128,6 @@ static void bnx2fc_process_ofld_cmpl(struct bnx2fc_hba *hba,
 	}
 	BNX2FC_TGT_DBG(tgt, "Entered ofld compl - context_id = 0x%x\n",
 		ofld_kcqe->fcoe_conn_context_id);
-	port = tgt->port;
 	interface = tgt->port->priv;
 	if (hba != interface->hba) {
 		printk(KERN_ERR PFX "ERROR:ofld_cmpl: HBA mis-match\n");
@@ -1463,10 +1454,7 @@ void bnx2fc_init_seq_cleanup_task(struct bnx2fc_cmd *seq_clnp_req,
 {
 	struct scsi_cmnd *sc_cmd = orig_io_req->sc_cmd;
 	struct bnx2fc_rport *tgt = seq_clnp_req->tgt;
-	struct bnx2fc_interface *interface = tgt->port->priv;
 	struct fcoe_bd_ctx *bd = orig_io_req->bd_tbl->bd_tbl;
-	struct fcoe_task_ctx_entry *orig_task;
-	struct fcoe_task_ctx_entry *task_page;
 	struct fcoe_ext_mul_sges_ctx *sgl;
 	u8 task_type = FCOE_TASK_TYPE_SEQUENCE_CLEANUP;
 	u8 orig_task_type;
@@ -1528,10 +1516,6 @@ void bnx2fc_init_seq_cleanup_task(struct bnx2fc_cmd *seq_clnp_req,
 		orig_task_idx = orig_xid / BNX2FC_TASKS_PER_PAGE;
 		index = orig_xid % BNX2FC_TASKS_PER_PAGE;

-		task_page = (struct fcoe_task_ctx_entry *)
-			     interface->hba->task_ctx[orig_task_idx];
-		orig_task = &(task_page[index]);
-
 		/* Multiple SGEs were used for this IO */
 		sgl = &task->rxwr_only.union_ctx.read_info.sgl_ctx.sgl;
 		sgl->mul_sgl.cur_sge_addr.lo = (u32)phys_addr;
--
2.7.4


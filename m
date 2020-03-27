Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84CFFC2D0ED
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 05:48:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 522E320716
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 05:48:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="tNBdFJ0n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgC0Fs5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 01:48:57 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14080 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725942AbgC0Fs4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 01:48:56 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02R5jMHg032486
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2020 22:48:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=IpIWEW/rzCYr+wM9v14pdSfrHgpj+jo1yvEUxUJe2BA=;
 b=tNBdFJ0nWMFsMDISdlGLa2+3V/19DtS/SUFuFOBE+KK5fW7/kBbHiYpELmXv9pKqoOLJ
 hEYhbn3lzdQgG+hy9np2S91FrwcMctSC9rC8F0DMf3q+GWTjolWmzJKw+mXlJb6Pfqyi
 r48WdPfZx7j8ktEdnDwZc1cpN9RqPS20p1Lzcg6dkDjjaeMWq/2rR/nB9A0uN8ujWjEo
 v8xMzOuZQkVRgQCO/6ebE7Rr0ruOJ0F+xAZWj/P91mxzIhC//egFv7hgpbqXRNxzw8S4
 WIJEH1LutKiQEFfFtxvnigiolh75jf/PMpkVxUt7u9YY/GLo3jgiw+MPjNV44foB+CAF /w== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 300bpcyqnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2020 22:48:55 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Mar
 2020 22:48:53 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Mar 2020 22:48:53 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 35E333F703F;
        Thu, 26 Mar 2020 22:48:53 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02R5mrln015986;
        Thu, 26 Mar 2020 22:48:53 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02R5mqBX015985;
        Thu, 26 Mar 2020 22:48:52 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH 1/3] bnx2fc: Process the RQE with CQE in interrupt context.
Date:   Thu, 26 Mar 2020 22:48:47 -0700
Message-ID: <20200327054849.15947-2-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200327054849.15947-1-skashyap@marvell.com>
References: <20200327054849.15947-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-26_14:2020-03-26,2020-03-26 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Javed Hasan <jhasan@marvell.com>

Filesystem goes to read-only after continuous error injection because RQE
was handled in deferred context, leading to mismatch between CQE and RQE.

Specifically, this patch:

-Process the RQE with CQE in interrupt context, before putting it
into the work queue while in the interrupt context.

-Producer and consumer indices are also updated in the interrupt context.
  to gaurantee the the order of processing.

Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h      |  11 ++--
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   8 ++-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c  | 103 +++++++++++++++++++++++++++-----------
 drivers/scsi/bnx2fc/bnx2fc_io.c   |  28 +++--------
 4 files changed, 96 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 3b84db8..15fa8e2 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -482,7 +482,10 @@ struct io_bdt {
 struct bnx2fc_work {
 	struct list_head list;
 	struct bnx2fc_rport *tgt;
+	struct fcoe_task_ctx_entry *task;
+	unsigned char rq_data[BNX2FC_RQ_BUF_SZ];
 	u16 wqe;
+	u8 num_rq;
 };
 struct bnx2fc_unsol_els {
 	struct fc_lport *lport;
@@ -550,7 +553,7 @@ void bnx2fc_rport_event_handler(struct fc_lport *lport,
 				enum fc_rport_event event);
 void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 				   struct fcoe_task_ctx_entry *task,
-				   u8 num_rq);
+				   u8 num_rq, unsigned char *rq_data);
 void bnx2fc_process_cleanup_compl(struct bnx2fc_cmd *io_req,
 			       struct fcoe_task_ctx_entry *task,
 			       u8 num_rq);
@@ -559,7 +562,7 @@ void bnx2fc_process_abts_compl(struct bnx2fc_cmd *io_req,
 			       u8 num_rq);
 void bnx2fc_process_tm_compl(struct bnx2fc_cmd *io_req,
 			     struct fcoe_task_ctx_entry *task,
-			     u8 num_rq);
+			     u8 num_rq, unsigned char *rq_data);
 void bnx2fc_process_els_compl(struct bnx2fc_cmd *els_req,
 			      struct fcoe_task_ctx_entry *task,
 			      u8 num_rq);
@@ -577,7 +580,9 @@ struct fc_seq *bnx2fc_elsct_send(struct fc_lport *lport, u32 did,
 				      void *arg, u32 timeout);
 void bnx2fc_arm_cq(struct bnx2fc_rport *tgt);
 int bnx2fc_process_new_cqes(struct bnx2fc_rport *tgt);
-void bnx2fc_process_cq_compl(struct bnx2fc_rport *tgt, u16 wqe);
+void bnx2fc_process_cq_compl(struct bnx2fc_rport *tgt, u16 wqe,
+			     unsigned char *rq_data, u8 num_rq,
+			     struct fcoe_task_ctx_entry *task);
 struct bnx2fc_rport *bnx2fc_tgt_lookup(struct fcoe_port *port,
 					     u32 port_id);
 void bnx2fc_process_l2_frame_compl(struct bnx2fc_rport *tgt,
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index b4bfab5..1cbb431 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -660,7 +660,10 @@ static int bnx2fc_percpu_io_thread(void *arg)
 
 			list_for_each_entry_safe(work, tmp, &work_list, list) {
 				list_del_init(&work->list);
-				bnx2fc_process_cq_compl(work->tgt, work->wqe);
+				bnx2fc_process_cq_compl(work->tgt, work->wqe,
+							work->rq_data,
+							work->num_rq,
+							work->task);
 				kfree(work);
 			}
 
@@ -2655,7 +2658,8 @@ static int bnx2fc_cpu_offline(unsigned int cpu)
 	/* Free all work in the list */
 	list_for_each_entry_safe(work, tmp, &p->work_list, list) {
 		list_del_init(&work->list);
-		bnx2fc_process_cq_compl(work->tgt, work->wqe);
+		bnx2fc_process_cq_compl(work->tgt, work->wqe, work->rq_data,
+					work->num_rq, work->task);
 		kfree(work);
 	}
 
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 6f8335d..d696617 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -863,36 +863,22 @@ static void bnx2fc_process_unsol_compl(struct bnx2fc_rport *tgt, u16 wqe)
 	}
 }
 
-void bnx2fc_process_cq_compl(struct bnx2fc_rport *tgt, u16 wqe)
+void bnx2fc_process_cq_compl(struct bnx2fc_rport *tgt, u16 wqe,
+			     unsigned char *rq_data, u8 num_rq,
+			     struct fcoe_task_ctx_entry *task)
 {
-	struct fcoe_task_ctx_entry *task;
-	struct fcoe_task_ctx_entry *task_page;
 	struct fcoe_port *port = tgt->port;
 	struct bnx2fc_interface *interface = port->priv;
 	struct bnx2fc_hba *hba = interface->hba;
 	struct bnx2fc_cmd *io_req;
-	int task_idx, index;
+
 	u16 xid;
 	u8  cmd_type;
 	u8 rx_state = 0;
-	u8 num_rq;
 
 	spin_lock_bh(&tgt->tgt_lock);
-	xid = wqe & FCOE_PEND_WQ_CQE_TASK_ID;
-	if (xid >= hba->max_tasks) {
-		printk(KERN_ERR PFX "ERROR:xid out of range\n");
-		spin_unlock_bh(&tgt->tgt_lock);
-		return;
-	}
-	task_idx = xid / BNX2FC_TASKS_PER_PAGE;
-	index = xid % BNX2FC_TASKS_PER_PAGE;
-	task_page = (struct fcoe_task_ctx_entry *)hba->task_ctx[task_idx];
-	task = &(task_page[index]);
-
-	num_rq = ((task->rxwr_txrd.var_ctx.rx_flags &
-		   FCOE_TCE_RX_WR_TX_RD_VAR_NUM_RQ_WQE) >>
-		   FCOE_TCE_RX_WR_TX_RD_VAR_NUM_RQ_WQE_SHIFT);
 
+	xid = wqe & FCOE_PEND_WQ_CQE_TASK_ID;
 	io_req = (struct bnx2fc_cmd *)hba->cmd_mgr->cmds[xid];
 
 	if (io_req == NULL) {
@@ -912,7 +898,8 @@ void bnx2fc_process_cq_compl(struct bnx2fc_rport *tgt, u16 wqe)
 	switch (cmd_type) {
 	case BNX2FC_SCSI_CMD:
 		if (rx_state == FCOE_TASK_RX_STATE_COMPLETED) {
-			bnx2fc_process_scsi_cmd_compl(io_req, task, num_rq);
+			bnx2fc_process_scsi_cmd_compl(io_req, task, num_rq,
+						      rq_data);
 			spin_unlock_bh(&tgt->tgt_lock);
 			return;
 		}
@@ -929,7 +916,7 @@ void bnx2fc_process_cq_compl(struct bnx2fc_rport *tgt, u16 wqe)
 
 	case BNX2FC_TASK_MGMT_CMD:
 		BNX2FC_IO_DBG(io_req, "Processing TM complete\n");
-		bnx2fc_process_tm_compl(io_req, task, num_rq);
+		bnx2fc_process_tm_compl(io_req, task, num_rq, rq_data);
 		break;
 
 	case BNX2FC_ABTS:
@@ -987,7 +974,9 @@ void bnx2fc_arm_cq(struct bnx2fc_rport *tgt)
 
 }
 
-static struct bnx2fc_work *bnx2fc_alloc_work(struct bnx2fc_rport *tgt, u16 wqe)
+static struct bnx2fc_work *bnx2fc_alloc_work(struct bnx2fc_rport *tgt, u16 wqe,
+					     unsigned char *rq_data, u8 num_rq,
+					     struct fcoe_task_ctx_entry *task)
 {
 	struct bnx2fc_work *work;
 	work = kzalloc(sizeof(struct bnx2fc_work), GFP_ATOMIC);
@@ -997,29 +986,87 @@ static struct bnx2fc_work *bnx2fc_alloc_work(struct bnx2fc_rport *tgt, u16 wqe)
 	INIT_LIST_HEAD(&work->list);
 	work->tgt = tgt;
 	work->wqe = wqe;
+	work->num_rq = num_rq;
+	work->task = task;
+	if (rq_data)
+		memcpy(work->rq_data, rq_data, BNX2FC_RQ_BUF_SZ);
+
 	return work;
 }
 
 /* Pending work request completion */
-static void bnx2fc_pending_work(struct bnx2fc_rport *tgt, unsigned int wqe)
+static bool bnx2fc_pending_work(struct bnx2fc_rport *tgt, unsigned int wqe)
 {
 	unsigned int cpu = wqe % num_possible_cpus();
 	struct bnx2fc_percpu_s *fps;
 	struct bnx2fc_work *work;
+	struct fcoe_task_ctx_entry *task;
+	struct fcoe_task_ctx_entry *task_page;
+	struct fcoe_port *port = tgt->port;
+	struct bnx2fc_interface *interface = port->priv;
+	struct bnx2fc_hba *hba = interface->hba;
+	unsigned char *rq_data = NULL;
+	unsigned char rq_data_buff[BNX2FC_RQ_BUF_SZ];
+	int task_idx, index;
+	unsigned char *dummy;
+	u16 xid;
+	u8 num_rq;
+	int i;
+
+	xid = wqe & FCOE_PEND_WQ_CQE_TASK_ID;
+	if (xid >= hba->max_tasks) {
+		pr_err(PFX "ERROR:xid out of range\n");
+		return 0;
+	}
+
+	task_idx = xid / BNX2FC_TASKS_PER_PAGE;
+	index = xid % BNX2FC_TASKS_PER_PAGE;
+	task_page = (struct fcoe_task_ctx_entry *)hba->task_ctx[task_idx];
+	task = &task_page[index];
+
+	num_rq = ((task->rxwr_txrd.var_ctx.rx_flags &
+	FCOE_TCE_RX_WR_TX_RD_VAR_NUM_RQ_WQE) >>
+	FCOE_TCE_RX_WR_TX_RD_VAR_NUM_RQ_WQE_SHIFT);
+
+	memset(rq_data_buff, 0, BNX2FC_RQ_BUF_SZ);
+
+	if (!num_rq)
+		goto num_rq_zero;
+
+	rq_data = bnx2fc_get_next_rqe(tgt, 1);
+
+	if (num_rq > 1) {
+		/* We do not need extra sense data */
+		for (i = 1; i < num_rq; i++)
+			dummy = bnx2fc_get_next_rqe(tgt, 1);
+		}
+
+	if (rq_data)
+		memcpy(rq_data_buff, rq_data, BNX2FC_RQ_BUF_SZ);
+
+	/* return RQ entries */
+	for (i = 0; i < num_rq; i++)
+		bnx2fc_return_rqe(tgt, 1);
+
+num_rq_zero:
 
 	fps = &per_cpu(bnx2fc_percpu, cpu);
 	spin_lock_bh(&fps->fp_work_lock);
 	if (fps->iothread) {
-		work = bnx2fc_alloc_work(tgt, wqe);
+		work = bnx2fc_alloc_work(tgt, wqe, rq_data_buff,
+					 num_rq, task);
 		if (work) {
 			list_add_tail(&work->list, &fps->work_list);
 			wake_up_process(fps->iothread);
 			spin_unlock_bh(&fps->fp_work_lock);
-			return;
+			return 1;
 		}
 	}
 	spin_unlock_bh(&fps->fp_work_lock);
-	bnx2fc_process_cq_compl(tgt, wqe);
+	bnx2fc_process_cq_compl(tgt, wqe,
+				rq_data_buff, num_rq, task);
+
+return 1;
 }
 
 int bnx2fc_process_new_cqes(struct bnx2fc_rport *tgt)
@@ -1056,8 +1103,8 @@ int bnx2fc_process_new_cqes(struct bnx2fc_rport *tgt)
 			/* Unsolicited event notification */
 			bnx2fc_process_unsol_compl(tgt, wqe);
 		} else {
-			bnx2fc_pending_work(tgt, wqe);
-			num_free_sqes++;
+			if (bnx2fc_pending_work(tgt, wqe))
+				num_free_sqes++;
 		}
 		cqe++;
 		tgt->cq_cons_idx++;
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 4c8122a..9ab9152 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -24,7 +24,7 @@ static int bnx2fc_split_bd(struct bnx2fc_cmd *io_req, u64 addr, int sg_len,
 static void bnx2fc_free_mp_resc(struct bnx2fc_cmd *io_req);
 static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
 				 struct fcoe_fcp_rsp_payload *fcp_rsp,
-				 u8 num_rq);
+				 u8 num_rq, unsigned char *rq_data);
 
 void bnx2fc_cmd_timer_set(struct bnx2fc_cmd *io_req,
 			  unsigned int timer_msec)
@@ -1518,7 +1518,8 @@ static void bnx2fc_tgt_reset_cmpl(struct bnx2fc_cmd *io_req)
 }
 
 void bnx2fc_process_tm_compl(struct bnx2fc_cmd *io_req,
-			     struct fcoe_task_ctx_entry *task, u8 num_rq)
+			     struct fcoe_task_ctx_entry *task, u8 num_rq,
+				  unsigned char *rq_data)
 {
 	struct bnx2fc_mp_req *tm_req;
 	struct fc_frame_header *fc_hdr;
@@ -1557,7 +1558,7 @@ void bnx2fc_process_tm_compl(struct bnx2fc_cmd *io_req,
 	if (fc_hdr->fh_r_ctl == FC_RCTL_DD_CMD_STATUS) {
 		bnx2fc_parse_fcp_rsp(io_req,
 				     (struct fcoe_fcp_rsp_payload *)
-				     rsp_buf, num_rq);
+				     rsp_buf, num_rq, rq_data);
 		if (io_req->fcp_rsp_code == 0) {
 			/* TM successful */
 			if (tm_req->tm_flags & FCP_TMF_LUN_RESET)
@@ -1755,15 +1756,11 @@ void bnx2fc_build_fcp_cmnd(struct bnx2fc_cmd *io_req,
 
 static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
 				 struct fcoe_fcp_rsp_payload *fcp_rsp,
-				 u8 num_rq)
+				 u8 num_rq, unsigned char *rq_data)
 {
 	struct scsi_cmnd *sc_cmd = io_req->sc_cmd;
-	struct bnx2fc_rport *tgt = io_req->tgt;
 	u8 rsp_flags = fcp_rsp->fcp_flags.flags;
 	u32 rq_buff_len = 0;
-	int i;
-	unsigned char *rq_data;
-	unsigned char *dummy;
 	int fcp_sns_len = 0;
 	int fcp_rsp_len = 0;
 
@@ -1809,14 +1806,6 @@ static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
 			rq_buff_len =  num_rq * BNX2FC_RQ_BUF_SZ;
 		}
 
-		rq_data = bnx2fc_get_next_rqe(tgt, 1);
-
-		if (num_rq > 1) {
-			/* We do not need extra sense data */
-			for (i = 1; i < num_rq; i++)
-				dummy = bnx2fc_get_next_rqe(tgt, 1);
-		}
-
 		/* fetch fcp_rsp_code */
 		if ((fcp_rsp_len == 4) || (fcp_rsp_len == 8)) {
 			/* Only for task management function */
@@ -1837,9 +1826,6 @@ static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
 		if (fcp_sns_len)
 			memcpy(sc_cmd->sense_buffer, rq_data, fcp_sns_len);
 
-		/* return RQ entries */
-		for (i = 0; i < num_rq; i++)
-			bnx2fc_return_rqe(tgt, 1);
 	}
 }
 
@@ -1918,7 +1904,7 @@ int bnx2fc_queuecommand(struct Scsi_Host *host,
 
 void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 				   struct fcoe_task_ctx_entry *task,
-				   u8 num_rq)
+				   u8 num_rq, unsigned char *rq_data)
 {
 	struct fcoe_fcp_rsp_payload *fcp_rsp;
 	struct bnx2fc_rport *tgt = io_req->tgt;
@@ -1950,7 +1936,7 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 		   &(task->rxwr_only.union_ctx.comp_info.fcp_rsp.payload);
 
 	/* parse fcp_rsp and obtain sense data from RQ if available */
-	bnx2fc_parse_fcp_rsp(io_req, fcp_rsp, num_rq);
+	bnx2fc_parse_fcp_rsp(io_req, fcp_rsp, num_rq, rq_data);
 
 	if (!sc_cmd->SCp.ptr) {
 		printk(KERN_ERR PFX "SCp.ptr is NULL\n");
-- 
1.8.3.1


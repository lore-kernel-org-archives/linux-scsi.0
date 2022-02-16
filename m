Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B04FC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234076AbiBPVES (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:04:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbiBPVEA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:04:00 -0500
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8429E2B0486
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:39 -0800 (PST)
Received: by mail-pj1-f49.google.com with SMTP id v5-20020a17090a4ec500b001b8b702df57so7571663pjl.2
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cPWm6i0GNUtIFBB1216hnt9s+p4BUsaGwwaR3/UbOic=;
        b=UGsQg5Nayrf8y74DSGRoGabRlOSIUVaA7iUIIWrveSB81Bvzj/tp5lmPCs/4FGKHf2
         /EgW01OyVwgaLkBeci9JoBrx56Byt9j0Gzgu5UBRlJ4X6uQ38Z6JN5YjxQwgOIF8Nl+p
         CtewG5FWU72lklYb884n8d+irC8nBuMI4lCke9ofgxH+DPm8d81p2pGckEfYsBkvVj98
         mEJ7Crk46QzHMRCW8jldagwbdfPqtuMVAc3tstyl/SaPN0TwHWBDs8C2MG5bOdroNi5M
         xzTEDwFnzpVyMPfd0PJayxiDLnVbnhK9GFTIE6Sq9CKtyxKXwzf+5T+nGXPZNri5lXJe
         eTpw==
X-Gm-Message-State: AOAM5300ZJLUX8E7k1HYXAOInVPVGlHmWdAjN2E8nuVHK42jfm67NBwh
        yvnMBdIWYBumd78kzPc8qYM=
X-Google-Smtp-Source: ABdhPJwuI8NVNsJpi1iBqHCYwT/2ObUzWYwf+n2nK3zgLXkQ189NZOSlDyUL1XBouw4/Ic9nvIRENQ==
X-Received: by 2002:a17:902:ce91:b0:14e:d9a9:5d7c with SMTP id f17-20020a170902ce9100b0014ed9a95d7cmr4397698plg.40.1645045418810;
        Wed, 16 Feb 2022 13:03:38 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:03:38 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Lee Duncan <lduncan@suse.com>, Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Chris Leech <cleech@redhat.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Karen Xie <kxie@chelsio.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        GR-QLogic-Storage-Upstream@marvell.com
Subject: [PATCH v4 26/50] scsi: iscsi: Stop using the SCSI pointer
Date:   Wed, 16 Feb 2022 13:02:09 -0800
Message-Id: <20220216210233.28774-27-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of storing the iSCSI task pointer and the session age in the SCSI
pointer, use command-private variables. This patch prepares for removal of
the SCSI pointer from struct scsi_cmnd.

The list of iSCSI drivers has been obtained as follows:
$ git grep -lw iscsi_host_alloc
drivers/infiniband/ulp/iser/iscsi_iser.c
drivers/scsi/be2iscsi/be_main.c
drivers/scsi/bnx2i/bnx2i_iscsi.c
drivers/scsi/cxgbi/libcxgbi.c
drivers/scsi/iscsi_tcp.c
drivers/scsi/libiscsi.c
drivers/scsi/qedi/qedi_main.c
drivers/scsi/qla4xxx/ql4_os.c
include/scsi/libiscsi.h

Note: it is not clear to me how the qla4xxx driver can work without this
patch since it uses the scsi_cmnd::SCp.ptr member for two different
purposes:
- The qla4xxx driver uses this member to store a struct srb pointer.
- libiscsi uses this member to store a struct iscsi_task pointer.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Chris Leech <cleech@redhat.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Manish Rangankar <mrangankar@marvell.com>
Cc: Karen Xie <kxie@chelsio.com>
Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>

iscsi
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |  1 +
 drivers/scsi/be2iscsi/be_main.c          |  3 ++-
 drivers/scsi/bnx2i/bnx2i_iscsi.c         |  1 +
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c       |  1 +
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c       |  1 +
 drivers/scsi/iscsi_tcp.c                 |  1 +
 drivers/scsi/libiscsi.c                  | 20 ++++++++++----------
 drivers/scsi/qedi/qedi_fw.c              |  4 ++--
 drivers/scsi/qedi/qedi_iscsi.c           |  1 +
 drivers/scsi/qla4xxx/ql4_def.h           | 16 +++++++++++++---
 drivers/scsi/qla4xxx/ql4_os.c            | 13 +++++++------
 include/scsi/libiscsi.h                  | 12 ++++++++++++
 12 files changed, 52 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 07e47021a71f..f8d0bab4424c 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -971,6 +971,7 @@ static struct scsi_host_template iscsi_iser_sht = {
 	.proc_name              = "iscsi_iser",
 	.this_id                = -1,
 	.track_queue_depth	= 1,
+	.cmd_size		= sizeof(struct iscsi_cmd),
 };
 
 static struct iscsi_transport iscsi_iser_transport = {
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index ab55681145f8..3bb0adefbe06 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -218,7 +218,7 @@ static char const *cqe_desc[] = {
 
 static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 {
-	struct iscsi_task *abrt_task = (struct iscsi_task *)sc->SCp.ptr;
+	struct iscsi_task *abrt_task = iscsi_cmd(sc)->task;
 	struct iscsi_cls_session *cls_session;
 	struct beiscsi_io_task *abrt_io_task;
 	struct beiscsi_conn *beiscsi_conn;
@@ -403,6 +403,7 @@ static struct scsi_host_template beiscsi_sht = {
 	.cmd_per_lun = BEISCSI_CMD_PER_LUN,
 	.vendor_id = SCSI_NL_VID_TYPE_PCI | BE_VENDOR_ID,
 	.track_queue_depth = 1,
+	.cmd_size = sizeof(struct iscsi_cmd),
 };
 
 static struct scsi_transport_template *beiscsi_scsi_transport;
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index e21b053b4f3e..fe86fd61a995 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2268,6 +2268,7 @@ static struct scsi_host_template bnx2i_host_template = {
 	.sg_tablesize		= ISCSI_MAX_BDS_PER_CMD,
 	.shost_groups		= bnx2i_dev_groups,
 	.track_queue_depth	= 1,
+	.cmd_size		= sizeof(struct iscsi_cmd),
 };
 
 struct iscsi_transport bnx2i_iscsi_transport = {
diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index f949a4e00783..ff9d4287937a 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -98,6 +98,7 @@ static struct scsi_host_template cxgb3i_host_template = {
 	.dma_boundary	= PAGE_SIZE - 1,
 	.this_id	= -1,
 	.track_queue_depth = 1,
+	.cmd_size	= sizeof(struct iscsi_cmd),
 };
 
 static struct iscsi_transport cxgb3i_iscsi_transport = {
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index efb3e2b3398e..53d91bf9c12a 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -116,6 +116,7 @@ static struct scsi_host_template cxgb4i_host_template = {
 	.dma_boundary	= PAGE_SIZE - 1,
 	.this_id	= -1,
 	.track_queue_depth = 1,
+	.cmd_size	= sizeof(struct iscsi_cmd),
 };
 
 static struct iscsi_transport cxgb4i_iscsi_transport = {
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 1bc37593c88f..9fee70d6434a 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1007,6 +1007,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
 	.track_queue_depth	= 1,
+	.cmd_size		= sizeof(struct iscsi_cmd),
 };
 
 static struct iscsi_transport iscsi_sw_tcp_transport = {
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 059dae8909ee..d69203d19f2c 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -462,7 +462,7 @@ static void iscsi_free_task(struct iscsi_task *task)
 
 	if (sc) {
 		/* SCSI eh reuses commands to verify us */
-		sc->SCp.ptr = NULL;
+		iscsi_cmd(sc)->task = NULL;
 		/*
 		 * queue command may call this to free the task, so
 		 * it will decide how to return sc to scsi-ml.
@@ -1344,10 +1344,10 @@ struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_conn *conn, itt_t itt)
 	if (!task || !task->sc)
 		return NULL;
 
-	if (task->sc->SCp.phase != conn->session->age) {
+	if (iscsi_cmd(task->sc)->age != conn->session->age) {
 		iscsi_session_printk(KERN_ERR, conn->session,
 				  "task's session age %d, expected %d\n",
-				  task->sc->SCp.phase, conn->session->age);
+				  iscsi_cmd(task->sc)->age, conn->session->age);
 		return NULL;
 	}
 
@@ -1645,8 +1645,8 @@ static inline struct iscsi_task *iscsi_alloc_task(struct iscsi_conn *conn,
 			 (void *) &task, sizeof(void *)))
 		return NULL;
 
-	sc->SCp.phase = conn->session->age;
-	sc->SCp.ptr = (char *) task;
+	iscsi_cmd(sc)->age = conn->session->age;
+	iscsi_cmd(sc)->task = task;
 
 	refcount_set(&task->refcount, 1);
 	task->state = ISCSI_TASK_PENDING;
@@ -1683,7 +1683,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	struct iscsi_task *task = NULL;
 
 	sc->result = 0;
-	sc->SCp.ptr = NULL;
+	iscsi_cmd(sc)->task = NULL;
 
 	ihost = shost_priv(host);
 
@@ -1997,7 +1997,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 
 	spin_lock_bh(&session->frwd_lock);
 	spin_lock(&session->back_lock);
-	task = (struct iscsi_task *)sc->SCp.ptr;
+	task = iscsi_cmd(sc)->task;
 	if (!task) {
 		/*
 		 * Raced with completion. Blk layer has taken ownership
@@ -2260,7 +2260,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	 * if session was ISCSI_STATE_IN_RECOVERY then we may not have
 	 * got the command.
 	 */
-	if (!sc->SCp.ptr) {
+	if (!iscsi_cmd(sc)->task) {
 		ISCSI_DBG_EH(session, "sc never reached iscsi layer or "
 				      "it completed.\n");
 		spin_unlock_bh(&session->frwd_lock);
@@ -2273,7 +2273,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	 * then let the host reset code handle this
 	 */
 	if (!session->leadconn || session->state != ISCSI_STATE_LOGGED_IN ||
-	    sc->SCp.phase != session->age) {
+	    iscsi_cmd(sc)->age != session->age) {
 		spin_unlock_bh(&session->frwd_lock);
 		mutex_unlock(&session->eh_mutex);
 		ISCSI_DBG_EH(session, "failing abort due to dropped "
@@ -2282,7 +2282,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	}
 
 	spin_lock(&session->back_lock);
-	task = (struct iscsi_task *)sc->SCp.ptr;
+	task = iscsi_cmd(sc)->task;
 	if (!task || !task->sc) {
 		/* task completed before time out */
 		ISCSI_DBG_EH(session, "sc completed while abort in progress\n");
diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 5916ed7662d5..4e99508ff95d 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -603,9 +603,9 @@ static void qedi_scsi_completion(struct qedi_ctx *qedi,
 		goto error;
 	}
 
-	if (!sc_cmd->SCp.ptr) {
+	if (!iscsi_cmd(sc_cmd)->task) {
 		QEDI_WARN(&qedi->dbg_ctx,
-			  "SCp.ptr is NULL, returned in another context.\n");
+			  "NULL task pointer, returned in another context.\n");
 		goto error;
 	}
 
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 282ecb4e39bb..8196f89f404e 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -59,6 +59,7 @@ struct scsi_host_template qedi_host_template = {
 	.dma_boundary = QEDI_HW_DMA_BOUNDARY,
 	.cmd_per_lun = 128,
 	.shost_groups = qedi_shost_groups,
+	.cmd_size = sizeof(struct iscsi_cmd),
 };
 
 static void qedi_conn_free_login_resources(struct qedi_ctx *qedi,
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 69a590546bf9..5f82c8afd5e0 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -216,11 +216,21 @@
 #define IDC_COMP_TOV			5
 #define LINK_UP_COMP_TOV		30
 
-#define CMD_SP(Cmnd)			((Cmnd)->SCp.ptr)
+/*
+ * Note: the data structure below does not have a struct iscsi_cmd member since
+ * the qla4xxx driver does not use libiscsi for SCSI I/O.
+ */
+struct qla4xxx_cmd_priv {
+	struct srb *srb;
+};
+
+static inline struct qla4xxx_cmd_priv *qla4xxx_cmd_priv(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
 
 /*
- * SCSI Request Block structure	 (srb)	that is placed
- * on cmd->SCp location of every I/O	 [We have 22 bytes available]
+ * SCSI Request Block structure (srb) that is associated with each scsi_cmnd.
  */
 struct srb {
 	struct list_head list;	/* (8)	 */
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 0ae936d839f1..d64eda961412 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -226,6 +226,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.name			= DRIVER_NAME,
 	.proc_name		= DRIVER_NAME,
 	.queuecommand		= qla4xxx_queuecommand,
+	.cmd_size		= sizeof(struct qla4xxx_cmd_priv),
 
 	.eh_abort_handler	= qla4xxx_eh_abort,
 	.eh_device_reset_handler = qla4xxx_eh_device_reset,
@@ -4054,7 +4055,7 @@ static struct srb* qla4xxx_get_new_srb(struct scsi_qla_host *ha,
 	srb->ddb = ddb_entry;
 	srb->cmd = cmd;
 	srb->flags = 0;
-	CMD_SP(cmd) = (void *)srb;
+	qla4xxx_cmd_priv(cmd)->srb = srb;
 
 	return srb;
 }
@@ -4067,7 +4068,7 @@ static void qla4xxx_srb_free_dma(struct scsi_qla_host *ha, struct srb *srb)
 		scsi_dma_unmap(cmd);
 		srb->flags &= ~SRB_DMA_VALID;
 	}
-	CMD_SP(cmd) = NULL;
+	qla4xxx_cmd_priv(cmd)->srb = NULL;
 }
 
 void qla4xxx_srb_compl(struct kref *ref)
@@ -4640,7 +4641,7 @@ static int qla4xxx_cmd_wait(struct scsi_qla_host *ha)
 			 * the scsi/block layer is going to prevent
 			 * the tag from being released.
 			 */
-			if (cmd != NULL && CMD_SP(cmd))
+			if (cmd != NULL && qla4xxx_cmd_priv(cmd)->srb)
 				break;
 		}
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -9079,7 +9080,7 @@ struct srb *qla4xxx_del_from_active_array(struct scsi_qla_host *ha,
 	if (!cmd)
 		return srb;
 
-	srb = (struct srb *)CMD_SP(cmd);
+	srb = qla4xxx_cmd_priv(cmd)->srb;
 	if (!srb)
 		return srb;
 
@@ -9121,7 +9122,7 @@ static int qla4xxx_eh_wait_on_command(struct scsi_qla_host *ha,
 
 	do {
 		/* Checking to see if its returned to OS */
-		rp = (struct srb *) CMD_SP(cmd);
+		rp = qla4xxx_cmd_priv(cmd)->srb;
 		if (rp == NULL) {
 			done++;
 			break;
@@ -9215,7 +9216,7 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
 	}
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	srb = (struct srb *) CMD_SP(cmd);
+	srb = qla4xxx_cmd_priv(cmd)->srb;
 	if (!srb) {
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		ql4_printk(KERN_INFO, ha, "scsi%ld:%d:%llu: Specified command has already completed.\n",
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 4ee233e5a6ff..cb805ed9cbf1 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -19,6 +19,7 @@
 #include <linux/refcount.h>
 #include <scsi/iscsi_proto.h>
 #include <scsi/iscsi_if.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_transport_iscsi.h>
 
 struct scsi_transport_template;
@@ -152,6 +153,17 @@ static inline bool iscsi_task_is_completed(struct iscsi_task *task)
 	       task->state == ISCSI_TASK_ABRT_SESS_RECOV;
 }
 
+/* Private data associated with struct scsi_cmnd. */
+struct iscsi_cmd {
+	struct iscsi_task	*task;
+	int			age;
+};
+
+static inline struct iscsi_cmd *iscsi_cmd(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
+
 /* Connection's states */
 enum {
 	ISCSI_CONN_INITIAL_STAGE,

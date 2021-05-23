Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF859C47080
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 11:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A42576109E
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 11:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhEWLEO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 07:04:14 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:38567 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbhEWLEN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 07:04:13 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d83 with ME
        id 8B2m2500321Fzsu03B2mvL; Sun, 23 May 2021 13:02:46 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 23 May 2021 13:02:46 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     skashyap@marvell.com, jhasan@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, chad.dupuis@cavium.com,
        arun.easi@cavium.com, nilesh.javali@cavium.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 3/3] scsi: qedf: Axe a few useless lines of code
Date:   Sun, 23 May 2021 13:02:46 +0200
Message-Id: <7b3469d65dad1a4a187533b0dab101c66e8f61d5.1621765056.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1621765056.git.christophe.jaillet@wanadoo.fr>
References: <cover.1621765056.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Simplify a bit this file a remove a few lines of code:
   - keep function parameters on the same line
   - remove unneeded return at the end of a function that return void
   - remove duplicated and useless empty lines
   - remove unneeded {} when there is only one statement
   - remove a few () around 'qedf->dbg_ctx' so that we can...
   - ... merge a few messages that were split on 2 lines

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Many more clean-up could be done to improve readability in this file.
The above few steps have the advantage to also reduce the number of LoC.
Anyway, that's mostly a matter of taste.
---
 drivers/scsi/qedf/qedf_main.c | 44 +++++++++++------------------------
 1 file changed, 14 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 3b80d4298f15..0fb5b89fa4a2 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -304,9 +304,7 @@ static void qedf_flogi_resp(struct fc_seq *seq, struct fc_frame *fp,
 
 static struct fc_seq *qedf_elsct_send(struct fc_lport *lport, u32 did,
 	struct fc_frame *fp, unsigned int op,
-	void (*resp)(struct fc_seq *,
-	struct fc_frame *,
-	void *),
+	void (*resp)(struct fc_seq *, struct fc_frame *, void *),
 	void *arg, u32 timeout)
 {
 	struct qedf_ctx *qedf = lport_priv(lport);
@@ -630,7 +628,6 @@ static void qedf_link_update(void *dev, struct qed_link_output *link)
 	}
 }
 
-
 static void qedf_dcbx_handler(void *dev, struct qed_dcbx_get *get, u32 mib_type)
 {
 	struct qedf_ctx *qedf = (struct qedf_ctx *)dev;
@@ -739,7 +736,6 @@ static int qedf_eh_abort(struct scsi_cmnd *sc_cmd)
 		goto out;
 	}
 
-
 	io_req = (struct qedf_ioreq *)sc_cmd->SCp.ptr;
 	if (!io_req) {
 		QEDF_ERR(&qedf->dbg_ctx,
@@ -972,9 +968,8 @@ static int qedf_eh_host_reset(struct scsi_cmnd *sc_cmd)
 
 static int qedf_slave_configure(struct scsi_device *sdev)
 {
-	if (qedf_queue_depth) {
+	if (qedf_queue_depth)
 		scsi_change_queue_depth(sdev, qedf_queue_depth);
-	}
 
 	return 0;
 }
@@ -1181,7 +1176,6 @@ static int qedf_xmit(struct fc_lport *lport, struct fc_frame *fp)
 		cp = NULL;
 	}
 
-
 	/* adjust skb network/transport offsets to match mac/fcoe/port */
 	skb_push(skb, elen + hlen);
 	skb_reset_mac_header(skb);
@@ -1899,7 +1893,6 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
 	fc_disc_init(vn_port);
 	fc_disc_config(vn_port, vn_port);
 
-
 	/* Allocate the exchange manager */
 	shost = vport_to_shost(vport);
 	n_port = shost_priv(shost);
@@ -2000,8 +1993,7 @@ static void qedf_wait_for_vport_destroy(struct qedf_ctx *qedf)
 {
 	struct fc_host_attrs *fc_host = shost_to_fc_host(qedf->lport->host);
 
-	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_NPIV,
-	    "Entered.\n");
+	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_NPIV, "Entered.\n");
 	while (fc_host->npiv_vports_inuse > 0) {
 		QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_NPIV,
 		    "Waiting for all vports to be reaped.\n");
@@ -2289,7 +2281,6 @@ static bool qedf_process_completions(struct qedf_fastpath *fp)
 	return true;
 }
 
-
 /* MSI-X fastpath handler code */
 static irqreturn_t qedf_msix_handler(int irq, void *dev_id)
 {
@@ -2623,7 +2614,6 @@ static void qedf_ll2_process_skb(struct work_struct *work)
 	kfree_skb(skb);
 out:
 	kfree(skb_work);
-	return;
 }
 
 static int qedf_ll2_rx(void *cookie, struct sk_buff *skb,
@@ -2746,8 +2736,7 @@ static int qedf_prepare_sb(struct qedf_ctx *qedf)
 		GFP_KERNEL);
 
 	if (!qedf->fp_array) {
-		QEDF_ERR(&(qedf->dbg_ctx), "fastpath array allocation "
-			  "failed.\n");
+		QEDF_ERR(&qedf->dbg_ctx, "fastpath array allocation failed.\n");
 		return -ENOMEM;
 	}
 
@@ -2768,9 +2757,8 @@ static int qedf_prepare_sb(struct qedf_ctx *qedf)
 		}
 		fp->sb_id = id;
 		fp->qedf = qedf;
-		fp->cq_num_entries =
-		    qedf->global_queues[id]->cq_mem_size /
-		    sizeof(struct fcoe_cqe);
+		fp->cq_num_entries = qedf->global_queues[id]->cq_mem_size /
+				     sizeof(struct fcoe_cqe);
 	}
 err:
 	return 0;
@@ -2815,7 +2803,6 @@ void qedf_process_cqe(struct qedf_ctx *qedf, struct fcoe_cqe *cqe)
 		return;
 	}
 
-
 	switch (comp_type) {
 	case FCOE_GOOD_COMPLETION_CQE_TYPE:
 		atomic_inc(&fcport->free_sqes);
@@ -3154,8 +3141,7 @@ static int qedf_set_fcoe_pf_param(struct qedf_ctx *qedf)
 
 	rval = qedf_alloc_global_queues(qedf);
 	if (rval) {
-		QEDF_ERR(&(qedf->dbg_ctx), "Global queue allocation "
-			  "failed.\n");
+		QEDF_ERR(&qedf->dbg_ctx, "Global queue allocation failed.\n");
 		return 1;
 	}
 
@@ -3326,8 +3312,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_INFO, "qedf->io_mempool=%p.\n",
 	    qedf->io_mempool);
 
-	sprintf(host_buf, "qedf_%u_link",
-	    qedf->lport->host->host_no);
+	sprintf(host_buf, "qedf_%u_link", qedf->lport->host->host_no);
 	qedf->link_update_wq = create_workqueue(host_buf);
 	INIT_DELAYED_WORK(&qedf->link_update, qedf_handle_link_update);
 	INIT_DELAYED_WORK(&qedf->link_recovery, qedf_link_recovery);
@@ -3581,8 +3566,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	qedf->timer_work_queue =
 		create_workqueue(host_buf);
 	if (!qedf->timer_work_queue) {
-		QEDF_ERR(&(qedf->dbg_ctx), "Failed to start timer "
-			  "workqueue.\n");
+		QEDF_ERR(&qedf->dbg_ctx, "Failed to start timer workqueue.\n");
 		rc = -ENOMEM;
 		goto err7;
 	}
@@ -3826,13 +3810,13 @@ void qedf_schedule_hw_err_handler(void *dev, enum qed_hw_err_type err_type)
 {
 	struct qedf_ctx *qedf = dev;
 
-	QEDF_ERR(&(qedf->dbg_ctx),
-			"Hardware error handler scheduled, event=%d.\n",
-			err_type);
+	QEDF_ERR(&qedf->dbg_ctx,
+		 "Hardware error handler scheduled, event=%d.\n",
+		 err_type);
 
 	if (test_bit(QEDF_IN_RECOVERY, &qedf->flags)) {
-		QEDF_ERR(&(qedf->dbg_ctx),
-				"Already in recovery, not scheduling board disable work.\n");
+		QEDF_ERR(&qedf->dbg_ctx,
+			 "Already in recovery, not scheduling board disable work.\n");
 		return;
 	}
 
-- 
2.30.2


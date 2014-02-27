From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v1 12/13] IB/iser: Implement check_protection
Date: Thu, 27 Feb 2014 13:13:08 +0200
Message-ID: <1393499589-15633-13-git-send-email-sagig@mellanox.com>
References: <1393499589-15633-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:36034 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752706AbaB0LNW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Feb 2014 06:13:22 -0500
In-Reply-To: <1393499589-15633-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: roland@kernel.org, nab@linux-iscsi.org
Cc: oren@mellanox.com, martin.petersen@oracle.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org

Once the iSCSI transaction is completed we must
imeplement check_protection in order to notify
on DIF errors that may have occured.

The routine boils down to calling ib_check_mr_status
to get the signature status of the transaction.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Alex Tabachnik <alext@mellanox.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |   13 ++++++++
 drivers/infiniband/ulp/iser/iscsi_iser.h |    2 +
 drivers/infiniband/ulp/iser/iser_verbs.c |   45 ++++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index a64b878..f13d7e9 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -306,6 +306,18 @@ static void iscsi_iser_cleanup_task(struct iscsi_task *task)
 	}
 }
 
+static u8 iscsi_iser_check_protection(struct iscsi_task *task, sector_t *sector)
+{
+	struct iscsi_iser_task *iser_task = task->dd_data;
+
+	if (iser_task->dir[ISER_DIR_IN])
+		return iser_check_task_pi_status(iser_task, ISER_DIR_IN,
+						 sector);
+	else
+		return iser_check_task_pi_status(iser_task, ISER_DIR_OUT,
+						 sector);
+}
+
 static struct iscsi_cls_conn *
 iscsi_iser_conn_create(struct iscsi_cls_session *cls_session, uint32_t conn_idx)
 {
@@ -742,6 +754,7 @@ static struct iscsi_transport iscsi_iser_transport = {
 	.xmit_task		= iscsi_iser_task_xmit,
 	.cleanup_task		= iscsi_iser_cleanup_task,
 	.alloc_pdu		= iscsi_iser_pdu_alloc,
+	.check_protection	= iscsi_iser_check_protection,
 	/* recovery */
 	.session_recovery_timedout = iscsi_session_recovery_timedout,
 
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index fce5409..95f291f 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -483,4 +483,6 @@ int iser_create_fmr_pool(struct iser_conn *ib_conn, unsigned cmds_max);
 void iser_free_fmr_pool(struct iser_conn *ib_conn);
 int iser_create_fastreg_pool(struct iser_conn *ib_conn, unsigned cmds_max);
 void iser_free_fastreg_pool(struct iser_conn *ib_conn);
+u8 iser_check_task_pi_status(struct iscsi_iser_task *iser_task,
+			     enum iser_data_dir cmd_dir, sector_t *sector);
 #endif
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 0404c71..617d490 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -1153,3 +1153,48 @@ static void iser_cq_callback(struct ib_cq *cq, void *cq_context)
 
 	tasklet_schedule(&device->cq_tasklet[cq_index]);
 }
+
+u8 iser_check_task_pi_status(struct iscsi_iser_task *iser_task,
+			     enum iser_data_dir cmd_dir, sector_t *sector)
+{
+	struct iser_mem_reg *reg = &iser_task->rdma_regd[cmd_dir].reg;
+	struct fast_reg_descriptor *desc = reg->mem_h;
+	unsigned long sector_size = iser_task->sc->device->sector_size;
+	struct ib_mr_status mr_status;
+	int ret;
+
+	if (desc && desc->reg_indicators & ISER_FASTREG_PROTECTED) {
+		desc->reg_indicators &= ~ISER_FASTREG_PROTECTED;
+		ret = ib_check_mr_status(desc->pi_ctx->sig_mr,
+					 IB_MR_CHECK_SIG_STATUS, &mr_status);
+		if (ret) {
+			pr_err("ib_check_mr_status failed, ret %d\n", ret);
+			goto err;
+		}
+
+		if (mr_status.fail_status & IB_MR_CHECK_SIG_STATUS) {
+			*sector = mr_status.sig_err.sig_err_offset;
+
+			do_div(*sector, sector_size + 8);
+			pr_err("PI error found type %d at sector %lx "
+			       "expected %x vs actual %x\n",
+			       mr_status.sig_err.err_type, *sector,
+			       mr_status.sig_err.expected,
+			       mr_status.sig_err.actual);
+
+			switch (mr_status.sig_err.err_type) {
+			case IB_SIG_BAD_GUARD:
+				return 0x1;
+			case IB_SIG_BAD_REFTAG:
+				return 0x3;
+			case IB_SIG_BAD_APPTAG:
+				return 0x2;
+			}
+		}
+	}
+
+	return 0;
+err:
+	/* Not alot we can do here, return ambiguous guard error */
+	return 0x1;
+}
-- 
1.7.1


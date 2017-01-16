From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 05/12] qla2xxx: Fix wrong argument in sp done callback.
Date: Mon, 16 Jan 2017 12:35:17 -0800
Message-ID: <1484598924-29066-6-git-send-email-himanshu.madhani@cavium.com>
References: <1484598924-29066-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1484598924-29066-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Callback for sp->done expects scsi_qla_host is passed in as argument,
Instead qla_hw_data is passed in.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 8 ++++----
 drivers/scsi/qla2xxx/qla_mr.c  | 6 +++---
 drivers/scsi/qla2xxx/qla_os.c  | 2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 0c6bd93..87b57bf 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1216,7 +1216,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 		req->outstanding_cmds[index] = NULL;
 
 		/* Save ISP completion status */
-		sp->done(ha, sp, DID_OK << 16);
+		sp->done(vha, sp, DID_OK << 16);
 	} else {
 		ql_log(ql_log_warn, vha, 0x3016, "Invalid SCSI SRB.\n");
 
@@ -2409,7 +2409,7 @@ struct scsi_dif_tuple {
 		    resid_len, fw_resid_len, sp, cp);
 
 	if (rsp->status_srb == NULL)
-		sp->done(ha, sp, res);
+		sp->done(vha, sp, res);
 }
 
 /**
@@ -2466,7 +2466,7 @@ struct scsi_dif_tuple {
 	/* Place command on done queue. */
 	if (sense_len == 0) {
 		rsp->status_srb = NULL;
-		sp->done(ha, sp, cp->result);
+		sp->done(vha, sp, cp->result);
 	}
 }
 
@@ -2502,7 +2502,7 @@ struct scsi_dif_tuple {
 
 	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
 	if (sp) {
-		sp->done(ha, sp, res);
+		sp->done(vha, sp, res);
 		return;
 	}
 fatal:
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 02f1de1..d38bc64 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2537,7 +2537,7 @@
 		    par_sense_len, rsp_info_len);
 
 	if (rsp->status_srb == NULL)
-		sp->done(ha, sp, res);
+		sp->done(vha, sp, res);
 }
 
 /**
@@ -2614,7 +2614,7 @@
 	/* Place command on done queue. */
 	if (sense_len == 0) {
 		rsp->status_srb = NULL;
-		sp->done(ha, sp, cp->result);
+		sp->done(vha, sp, cp->result);
 	}
 }
 
@@ -2695,7 +2695,7 @@
 
 	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
 	if (sp) {
-		sp->done(ha, sp, res);
+		sp->done(vha, sp, res);
 		return;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 074dcca..65eca89 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1203,7 +1203,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	}
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	sp->done(ha, sp, 0);
+	sp->done(vha, sp, 0);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	/* Did the command return during mailbox execution? */
-- 
1.8.3.1

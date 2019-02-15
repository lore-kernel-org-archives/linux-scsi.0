From: Colin King <colin.king@canonical.com>
Subject: [PATCH][V2] scsi: qla2xxx: remove redundant null check on pointer sess
Date: Fri, 15 Feb 2019 09:52:32 +0000
Message-ID: <20190215095232.28852-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The null check on pointer sess and the subsequent call is redundant
as sess is null on all the the paths that lead to the out_term2 label.
Hence the null check and the call can be removed.  Also remove the
redundant setting of sess to NULL as this is not required now.

Detected by CoverityScan, CID#1420663 ("Logically dead code")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---

V2: Remove the redundant settings of sess to NULL, thanks to
Dan Carpenter for spotting this.

---
 drivers/scsi/qla2xxx/qla_target.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 6b8c655d9eb4..33131446b327 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6343,7 +6343,7 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 	struct atio_from_isp *a = &prm->tm_iocb2;
 	struct scsi_qla_host *vha = tgt->vha;
 	struct qla_hw_data *ha = vha->hw;
-	struct fc_port *sess = NULL;
+	struct fc_port *sess;
 	unsigned long flags;
 	uint8_t *s_id = NULL; /* to hide compiler warnings */
 	int rc;
@@ -6369,7 +6369,6 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 			goto out_term2;
 	} else {
 		if (sess->deleted) {
-			sess = NULL;
 			goto out_term2;
 		}
 
@@ -6377,7 +6376,6 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 			ql_dbg(ql_dbg_tgt_tmr, vha, 0xf020,
 			    "%s: kref_get fail %8phC\n",
 			     __func__, sess->port_name);
-			sess = NULL;
 			goto out_term2;
 		}
 	}
@@ -6396,8 +6394,6 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 	return;
 
 out_term2:
-	if (sess)
-		ha->tgt.tgt_ops->put_sess(sess);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 out_term:
 	qlt_send_term_exchange(ha->base_qpair, NULL, &prm->tm_iocb2, 1, 0);
-- 
2.20.1

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH] scsi: qedf: Limit number of CQs
Date: Thu, 13 Jul 2017 18:19:21 +0200
Message-ID: <20170713165951.61190508094@solo.franken.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

FCOE offloading on qedf devices fails with:

[qed_sp_fcoe_func_start:150(sp-0-3b:00.02)]Cannot satisfy CQ amount. CQs
		 requested 8, CQs available 6. Aborting function start
[qed_fcoe_start:821()]Failed to start fcoe
[__qedf_probe:3041]:6: Cannot start FCoE function.

The reason is a newly introduced check in the qed main part. This change
also provides the information about how many CQs are available, so we
simply limit the number of requested CQs.

Fixes: 3c5da9427802 qed: Share additional information with qedf
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/scsi/qedf/qedf_main.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index b58bba4604e8..5778218734fa 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2765,6 +2765,8 @@ static int qedf_set_fcoe_pf_param(struct qedf_ctx *qedf)
 	 */
 	qedf->num_queues = min((unsigned int)QEDF_MAX_NUM_CQS,
 	    num_online_cpus());
+	/* limit to acutal available CQs */
+	qedf->num_queues = min(qedf->num_queues, qedf->dev_info.num_cqs);
 
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC, "Number of CQs is %d.\n",
 		   qedf->num_queues);
@@ -2962,6 +2964,13 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 		goto err1;
 	}
 
+	/* Learn information crucial for qedf to progress */
+	rc = qed_ops->fill_dev_info(qedf->cdev, &qedf->dev_info);
+	if (rc) {
+		QEDF_ERR(&(qedf->dbg_ctx), "Failed to dev info.\n");
+		goto err1;
+	}
+
 	/* queue allocation code should come here
 	 * order should be
 	 * 	slowpath_start
@@ -2977,13 +2986,6 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	}
 	qed_ops->common->update_pf_params(qedf->cdev, &qedf->pf_params);
 
-	/* Learn information crucial for qedf to progress */
-	rc = qed_ops->fill_dev_info(qedf->cdev, &qedf->dev_info);
-	if (rc) {
-		QEDF_ERR(&(qedf->dbg_ctx), "Failed to dev info.\n");
-		goto err1;
-	}
-
 	/* Record BDQ producer doorbell addresses */
 	qedf->bdq_primary_prod = qedf->dev_info.primary_dbq_rq_addr;
 	qedf->bdq_secondary_prod = qedf->dev_info.secondary_bdq_rq_addr;
-- 
2.12.3

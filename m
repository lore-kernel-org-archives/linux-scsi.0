From: Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH net-next 10/10] qedf: Use hwfns and affin_hwfn_idx to get MSI-X vector index to use
Date: Wed, 1 May 2019 12:57:22 +0300
Message-ID: <20190501095722.6902-11-michal.kalderon@marvell.com>
References: <20190501095722.6902-1-michal.kalderon@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190501095722.6902-1-michal.kalderon@marvell.com>
Sender: netdev-owner@vger.kernel.org
To: michal.kalderon@marvell.com, ariel.elior@marvell.com, davem@davemloft.net
Cc: jgg@ziepe.ca, dledford@redhat.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-scsi@vger.kernel.org, Chad Dupuis <cdupuis@marvell.com>, Saurav Kashyap <skashyap@marvell.com>
List-Id: linux-scsi@vger.kernel.org

From: Chad Dupuis <cdupuis@marvell.com>

MSI-X vector index is determined using qed device information and
affinity to use.

Signed-off-by: Chad Dupuis <cdupuis@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 9f9431a4cc0e..dc4cad1d5dcc 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2086,16 +2086,21 @@ static void qedf_simd_int_handler(void *cookie)
 static void qedf_sync_free_irqs(struct qedf_ctx *qedf)
 {
 	int i;
+	u16 vector_idx = 0;
+	u32 vector;
 
 	if (qedf->int_info.msix_cnt) {
 		for (i = 0; i < qedf->int_info.used_cnt; i++) {
-			synchronize_irq(qedf->int_info.msix[i].vector);
-			irq_set_affinity_hint(qedf->int_info.msix[i].vector,
-			    NULL);
-			irq_set_affinity_notifier(qedf->int_info.msix[i].vector,
-			    NULL);
-			free_irq(qedf->int_info.msix[i].vector,
-			    &qedf->fp_array[i]);
+			vector_idx = i * qedf->dev_info.common.num_hwfns +
+				qed_ops->common->get_affin_hwfn_idx(qedf->cdev);
+			QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC,
+				  "Freeing IRQ #%d vector_idx=%d.\n",
+				  i, vector_idx);
+			vector = qedf->int_info.msix[vector_idx].vector;
+			synchronize_irq(vector);
+			irq_set_affinity_hint(vector, NULL);
+			irq_set_affinity_notifier(vector, NULL);
+			free_irq(vector, &qedf->fp_array[i]);
 		}
 	} else
 		qed_ops->common->simd_handler_clean(qedf->cdev,
@@ -2108,11 +2113,19 @@ static void qedf_sync_free_irqs(struct qedf_ctx *qedf)
 static int qedf_request_msix_irq(struct qedf_ctx *qedf)
 {
 	int i, rc, cpu;
+	u16 vector_idx = 0;
+	u32 vector;
 
 	cpu = cpumask_first(cpu_online_mask);
 	for (i = 0; i < qedf->num_queues; i++) {
-		rc = request_irq(qedf->int_info.msix[i].vector,
-		    qedf_msix_handler, 0, "qedf", &qedf->fp_array[i]);
+		vector_idx = i * qedf->dev_info.common.num_hwfns +
+			qed_ops->common->get_affin_hwfn_idx(qedf->cdev);
+		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC,
+			  "Requesting IRQ #%d vector_idx=%d.\n",
+			  i, vector_idx);
+		vector = qedf->int_info.msix[vector_idx].vector;
+		rc = request_irq(vector, qedf_msix_handler, 0, "qedf",
+				 &qedf->fp_array[i]);
 
 		if (rc) {
 			QEDF_WARN(&(qedf->dbg_ctx), "request_irq failed.\n");
@@ -2121,8 +2134,7 @@ static int qedf_request_msix_irq(struct qedf_ctx *qedf)
 		}
 
 		qedf->int_info.used_cnt++;
-		rc = irq_set_affinity_hint(qedf->int_info.msix[i].vector,
-		    get_cpu_mask(cpu));
+		rc = irq_set_affinity_hint(vector, get_cpu_mask(cpu));
 		cpu = cpumask_next(cpu, cpu_online_mask);
 	}
 
@@ -3068,6 +3080,11 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 		goto err1;
 	}
 
+	QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC,
+		  "dev_info: num_hwfns=%d affin_hwfn_idx=%d.\n",
+		  qedf->dev_info.common.num_hwfns,
+		  qed_ops->common->get_affin_hwfn_idx(qedf->cdev));
+
 	/* queue allocation code should come here
 	 * order should be
 	 * 	slowpath_start
-- 
2.14.5

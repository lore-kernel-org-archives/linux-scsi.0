From: Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH net-next 09/10] qedi: Use hwfns and affin_hwfn_idx to get MSI-X vector index
Date: Wed, 1 May 2019 12:57:21 +0300
Message-ID: <20190501095722.6902-10-michal.kalderon@marvell.com>
References: <20190501095722.6902-1-michal.kalderon@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190501095722.6902-1-michal.kalderon@marvell.com>
Sender: netdev-owner@vger.kernel.org
To: michal.kalderon@marvell.com, ariel.elior@marvell.com, davem@davemloft.net
Cc: jgg@ziepe.ca, dledford@redhat.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-scsi@vger.kernel.org, Manish Rangankar <mrangankar@marvell.com>
List-Id: linux-scsi@vger.kernel.org

From: Manish Rangankar <mrangankar@marvell.com>

MSI-X vector index is determined using qed device information and
affinity to use.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/scsi/qedi/qedi_main.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index f07e0814a657..1a62ab0867ef 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1313,13 +1313,20 @@ static void qedi_simd_int_handler(void *cookie)
 static void qedi_sync_free_irqs(struct qedi_ctx *qedi)
 {
 	int i;
+	u16 idx;
 
 	if (qedi->int_info.msix_cnt) {
 		for (i = 0; i < qedi->int_info.used_cnt; i++) {
-			synchronize_irq(qedi->int_info.msix[i].vector);
-			irq_set_affinity_hint(qedi->int_info.msix[i].vector,
+			idx = i * qedi->dev_info.common.num_hwfns +
+			qedi_ops->common->get_affin_hwfn_idx(qedi->cdev);
+
+			QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
+				  "Freeing IRQ #%d vector_idx=%d.\n", i, idx);
+
+			synchronize_irq(qedi->int_info.msix[idx].vector);
+			irq_set_affinity_hint(qedi->int_info.msix[idx].vector,
 					      NULL);
-			free_irq(qedi->int_info.msix[i].vector,
+			free_irq(qedi->int_info.msix[idx].vector,
 				 &qedi->fp_array[i]);
 		}
 	} else {
@@ -1334,20 +1341,28 @@ static void qedi_sync_free_irqs(struct qedi_ctx *qedi)
 static int qedi_request_msix_irq(struct qedi_ctx *qedi)
 {
 	int i, rc, cpu;
+	u16 idx;
 
 	cpu = cpumask_first(cpu_online_mask);
 	for (i = 0; i < MIN_NUM_CPUS_MSIX(qedi); i++) {
-		rc = request_irq(qedi->int_info.msix[i].vector,
+		idx = i * qedi->dev_info.common.num_hwfns +
+			  qedi_ops->common->get_affin_hwfn_idx(qedi->cdev);
+
+		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
+			  "dev_info: num_hwfns=%d affin_hwfn_idx=%d.\n",
+			  qedi->dev_info.common.num_hwfns,
+			  qedi_ops->common->get_affin_hwfn_idx(qedi->cdev));
+
+		rc = request_irq(qedi->int_info.msix[idx].vector,
 				 qedi_msix_handler, 0, "qedi",
 				 &qedi->fp_array[i]);
-
 		if (rc) {
 			QEDI_WARN(&qedi->dbg_ctx, "request_irq failed.\n");
 			qedi_sync_free_irqs(qedi);
 			return rc;
 		}
 		qedi->int_info.used_cnt++;
-		rc = irq_set_affinity_hint(qedi->int_info.msix[i].vector,
+		rc = irq_set_affinity_hint(qedi->int_info.msix[idx].vector,
 					   get_cpu_mask(cpu));
 		cpu = cpumask_next(cpu, cpu_online_mask);
 	}
@@ -2415,6 +2430,11 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 	if (rc)
 		goto free_host;
 
+	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
+		  "dev_info: num_hwfns=%d affin_hwfn_idx=%d.\n",
+		  qedi->dev_info.common.num_hwfns,
+		  qedi_ops->common->get_affin_hwfn_idx(qedi->cdev));
+
 	if (mode != QEDI_MODE_RECOVERY) {
 		rc = qedi_set_iscsi_pf_param(qedi);
 		if (rc) {
-- 
2.14.5

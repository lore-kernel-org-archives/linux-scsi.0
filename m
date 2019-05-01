From: Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH net-next 05/10] qedr: Change the MSI-X vectors selection to be based on affined engine
Date: Wed, 1 May 2019 12:57:17 +0300
Message-ID: <20190501095722.6902-6-michal.kalderon@marvell.com>
References: <20190501095722.6902-1-michal.kalderon@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190501095722.6902-1-michal.kalderon@marvell.com>
Sender: netdev-owner@vger.kernel.org
To: michal.kalderon@marvell.com, ariel.elior@marvell.com, davem@davemloft.net
Cc: jgg@ziepe.ca, dledford@redhat.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use the msix vectors of the affined hwfn and not the
leading one.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/infiniband/hw/qedr/main.c         | 9 +++++++--
 drivers/infiniband/hw/qedr/qedr.h         | 2 ++
 drivers/net/ethernet/qlogic/qed/qed_ll2.c | 4 ++--
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index fd94100ee03a..d93c8a893a89 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -520,11 +520,13 @@ static irqreturn_t qedr_irq_handler(int irq, void *handle)
 static void qedr_sync_free_irqs(struct qedr_dev *dev)
 {
 	u32 vector;
+	u16 idx;
 	int i;
 
 	for (i = 0; i < dev->int_info.used_cnt; i++) {
 		if (dev->int_info.msix_cnt) {
-			vector = dev->int_info.msix[i * dev->num_hwfns].vector;
+			idx = i * dev->num_hwfns + dev->affin_hwfn_idx;
+			vector = dev->int_info.msix[idx].vector;
 			synchronize_irq(vector);
 			free_irq(vector, &dev->cnq_array[i]);
 		}
@@ -536,6 +538,7 @@ static void qedr_sync_free_irqs(struct qedr_dev *dev)
 static int qedr_req_msix_irqs(struct qedr_dev *dev)
 {
 	int i, rc = 0;
+	u16 idx;
 
 	if (dev->num_cnq > dev->int_info.msix_cnt) {
 		DP_ERR(dev,
@@ -545,7 +548,8 @@ static int qedr_req_msix_irqs(struct qedr_dev *dev)
 	}
 
 	for (i = 0; i < dev->num_cnq; i++) {
-		rc = request_irq(dev->int_info.msix[i * dev->num_hwfns].vector,
+		idx = i * dev->num_hwfns + dev->affin_hwfn_idx;
+		rc = request_irq(dev->int_info.msix[idx].vector,
 				 qedr_irq_handler, 0, dev->cnq_array[i].name,
 				 &dev->cnq_array[i]);
 		if (rc) {
@@ -882,6 +886,7 @@ static struct qedr_dev *qedr_add(struct qed_dev *cdev, struct pci_dev *pdev,
 	dev->user_dpm_enabled = dev_info.user_dpm_enabled;
 	dev->rdma_type = dev_info.rdma_type;
 	dev->num_hwfns = dev_info.common.num_hwfns;
+	dev->affin_hwfn_idx = dev->ops->common->get_affin_hwfn_idx(cdev);
 	dev->rdma_ctx = dev->ops->rdma_get_rdma_ctx(cdev);
 
 	dev->num_cnq = dev->ops->rdma_get_min_cnq_msix(cdev);
diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index 53bbe6b4e6e6..18778694f652 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -162,6 +162,8 @@ struct qedr_dev {
 	u32			dp_module;
 	u8			dp_level;
 	u8			num_hwfns;
+#define QEDR_IS_CMT(dev)        ((dev)->num_hwfns > 1)
+	u8			affin_hwfn_idx;
 	u8			gsi_ll2_handle;
 
 	uint			wq_multiplier;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index dcff69aa8613..19a1a58d60f8 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -2156,8 +2156,8 @@ static void _qed_ll2_get_pstats(struct qed_hwfn *p_hwfn,
 	p_stats->sent_bcast_pkts += HILO_64_REGPAIR(pstats.sent_bcast_pkts);
 }
 
-int __qed_ll2_get_stats(void *cxt,
-			u8 connection_handle, struct qed_ll2_stats *p_stats)
+static int __qed_ll2_get_stats(void *cxt, u8 connection_handle,
+			       struct qed_ll2_stats *p_stats)
 {
 	struct qed_hwfn *p_hwfn = cxt;
 	struct qed_ll2_info *p_ll2_conn = NULL;
-- 
2.14.5

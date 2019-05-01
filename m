From: Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH net-next 06/10] qed: Set the doorbell address correctly
Date: Wed, 1 May 2019 12:57:18 +0300
Message-ID: <20190501095722.6902-7-michal.kalderon@marvell.com>
References: <20190501095722.6902-1-michal.kalderon@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190501095722.6902-1-michal.kalderon@marvell.com>
Sender: netdev-owner@vger.kernel.org
To: michal.kalderon@marvell.com, ariel.elior@marvell.com, davem@davemloft.net
Cc: jgg@ziepe.ca, dledford@redhat.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-scsi@vger.kernel.org, Denis Bolotin <denis.bolotin@marvell.com>
List-Id: linux-scsi@vger.kernel.org

In 100g mode the doorbell bar is united for both engines. Set
the correct offset in the hwfn so that the doorbell returned
for RoCE is in the affined hwfn.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Denis Bolotin <denis.bolotin@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c  | 29 ++++++++++++++++++-----------
 drivers/net/ethernet/qlogic/qed/qed_rdma.c |  2 +-
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index c2b91d0adf1f..6b3968eaa0e5 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -4426,6 +4426,7 @@ static void qed_nvm_info_free(struct qed_hwfn *p_hwfn)
 static int qed_hw_prepare_single(struct qed_hwfn *p_hwfn,
 				 void __iomem *p_regview,
 				 void __iomem *p_doorbells,
+				 u64 db_phys_addr,
 				 enum qed_pci_personality personality)
 {
 	struct qed_dev *cdev = p_hwfn->cdev;
@@ -4434,6 +4435,7 @@ static int qed_hw_prepare_single(struct qed_hwfn *p_hwfn,
 	/* Split PCI bars evenly between hwfns */
 	p_hwfn->regview = p_regview;
 	p_hwfn->doorbells = p_doorbells;
+	p_hwfn->db_phys_addr = db_phys_addr;
 
 	if (IS_VF(p_hwfn->cdev))
 		return qed_vf_hw_prepare(p_hwfn);
@@ -4529,7 +4531,9 @@ int qed_hw_prepare(struct qed_dev *cdev,
 	/* Initialize the first hwfn - will learn number of hwfns */
 	rc = qed_hw_prepare_single(p_hwfn,
 				   cdev->regview,
-				   cdev->doorbells, personality);
+				   cdev->doorbells,
+				   cdev->db_phys_addr,
+				   personality);
 	if (rc)
 		return rc;
 
@@ -4538,22 +4542,25 @@ int qed_hw_prepare(struct qed_dev *cdev,
 	/* Initialize the rest of the hwfns */
 	if (cdev->num_hwfns > 1) {
 		void __iomem *p_regview, *p_doorbell;
-		u8 __iomem *addr;
+		u64 db_phys_addr;
+		u32 offset;
 
 		/* adjust bar offset for second engine */
-		addr = cdev->regview +
-		       qed_hw_bar_size(p_hwfn, p_hwfn->p_main_ptt,
-				       BAR_ID_0) / 2;
-		p_regview = addr;
+		offset = qed_hw_bar_size(p_hwfn, p_hwfn->p_main_ptt,
+					 BAR_ID_0) / 2;
+		p_regview = cdev->regview + offset;
 
-		addr = cdev->doorbells +
-		       qed_hw_bar_size(p_hwfn, p_hwfn->p_main_ptt,
-				       BAR_ID_1) / 2;
-		p_doorbell = addr;
+		offset = qed_hw_bar_size(p_hwfn, p_hwfn->p_main_ptt,
+					 BAR_ID_1) / 2;
+
+		p_doorbell = cdev->doorbells + offset;
+
+		db_phys_addr = cdev->db_phys_addr + offset;
 
 		/* prepare second hw function */
 		rc = qed_hw_prepare_single(&cdev->hwfns[1], p_regview,
-					   p_doorbell, personality);
+					   p_doorbell, db_phys_addr,
+					   personality);
 
 		/* in case of error, need to free the previously
 		 * initiliazed hwfn 0.
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 4284374daa4f..e4d63359864e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -803,7 +803,7 @@ static int qed_rdma_add_user(void *rdma_cxt,
 				     dpi_start_offset +
 				     ((out_params->dpi) * p_hwfn->dpi_size));
 
-	out_params->dpi_phys_addr = p_hwfn->cdev->db_phys_addr +
+	out_params->dpi_phys_addr = p_hwfn->db_phys_addr +
 				    dpi_start_offset +
 				    ((out_params->dpi) * p_hwfn->dpi_size);
 
-- 
2.14.5

From: John Garry <john.garry@huawei.com>
Subject: [PATCH 6/6] scsi: hisi_sas: controller reset for multi-bits ECC and AXI fatal errors
Date: Mon, 10 Apr 2017 21:22:01 +0800
Message-ID: <1491830521-21437-7-git-send-email-john.garry@huawei.com>
References: <1491830521-21437-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1491830521-21437-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

For 1 bit ECC errors, those errors can be recovered by hw. But for
multi-bits ECC and AXI errors, there are something wrong with whole
module or system, so try reset the controller to recover those errors
instead of calling panic().

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 93 ++++++++++++++++++++--------------
 1 file changed, 56 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index cc5675b..89d0959 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2918,94 +2918,105 @@ static void multi_bit_ecc_error_process_v2_hw(struct hisi_hba *hisi_hba,
 
 	if (irq_value & BIT(SAS_ECC_INTR_DQE_ECC_MB_OFF)) {
 		reg_val = hisi_sas_read32(hisi_hba, HGC_DQE_ECC_ADDR);
-		panic("%s: hgc_dqe_accbad_intr (0x%x) found: \
+		dev_warn(dev, "hgc_dqe_accbad_intr (0x%x) found: \
 		       Ram address is 0x%08X\n",
-		      dev_name(dev), irq_value,
+		      irq_value,
 		      (reg_val & HGC_DQE_ECC_MB_ADDR_MSK) >>
 		      HGC_DQE_ECC_MB_ADDR_OFF);
+		queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 	}
 
 	if (irq_value & BIT(SAS_ECC_INTR_IOST_ECC_MB_OFF)) {
 		reg_val = hisi_sas_read32(hisi_hba, HGC_IOST_ECC_ADDR);
-		panic("%s: hgc_iost_accbad_intr (0x%x) found: \
+		dev_warn(dev, "hgc_iost_accbad_intr (0x%x) found: \
 		       Ram address is 0x%08X\n",
-		      dev_name(dev), irq_value,
+		      irq_value,
 		      (reg_val & HGC_IOST_ECC_MB_ADDR_MSK) >>
 		      HGC_IOST_ECC_MB_ADDR_OFF);
+		queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 	}
 
 	if (irq_value & BIT(SAS_ECC_INTR_ITCT_ECC_MB_OFF)) {
 		reg_val = hisi_sas_read32(hisi_hba, HGC_ITCT_ECC_ADDR);
-		panic("%s: hgc_itct_accbad_intr (0x%x) found: \
+		dev_warn(dev,"hgc_itct_accbad_intr (0x%x) found: \
 		       Ram address is 0x%08X\n",
-		      dev_name(dev), irq_value,
+		      irq_value,
 		      (reg_val & HGC_ITCT_ECC_MB_ADDR_MSK) >>
 		      HGC_ITCT_ECC_MB_ADDR_OFF);
+		queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 	}
 
 	if (irq_value & BIT(SAS_ECC_INTR_IOSTLIST_ECC_MB_OFF)) {
 		reg_val = hisi_sas_read32(hisi_hba, HGC_LM_DFX_STATUS2);
-		panic("%s: hgc_iostl_accbad_intr (0x%x) found: \
+		dev_warn(dev, "hgc_iostl_accbad_intr (0x%x) found: \
 		       memory address is 0x%08X\n",
-		      dev_name(dev), irq_value,
+		      irq_value,
 		      (reg_val & HGC_LM_DFX_STATUS2_IOSTLIST_MSK) >>
 		      HGC_LM_DFX_STATUS2_IOSTLIST_OFF);
+		queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 	}
 
 	if (irq_value & BIT(SAS_ECC_INTR_ITCTLIST_ECC_MB_OFF)) {
 		reg_val = hisi_sas_read32(hisi_hba, HGC_LM_DFX_STATUS2);
-		panic("%s: hgc_itctl_accbad_intr (0x%x) found: \
+		dev_warn(dev, "hgc_itctl_accbad_intr (0x%x) found: \
 		       memory address is 0x%08X\n",
-		      dev_name(dev), irq_value,
+		      irq_value,
 		      (reg_val & HGC_LM_DFX_STATUS2_ITCTLIST_MSK) >>
 		      HGC_LM_DFX_STATUS2_ITCTLIST_OFF);
+		queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 	}
 
 	if (irq_value & BIT(SAS_ECC_INTR_CQE_ECC_MB_OFF)) {
 		reg_val = hisi_sas_read32(hisi_hba, HGC_CQE_ECC_ADDR);
-		panic("%s: hgc_cqe_accbad_intr (0x%x) found: \
+		dev_warn(dev, "hgc_cqe_accbad_intr (0x%x) found: \
 		       Ram address is 0x%08X\n",
-		      dev_name(dev), irq_value,
+		      irq_value,
 		      (reg_val & HGC_CQE_ECC_MB_ADDR_MSK) >>
 		      HGC_CQE_ECC_MB_ADDR_OFF);
+		queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 	}
 
 	if (irq_value & BIT(SAS_ECC_INTR_NCQ_MEM0_ECC_MB_OFF)) {
 		reg_val = hisi_sas_read32(hisi_hba, HGC_RXM_DFX_STATUS14);
-		panic("%s: rxm_mem0_accbad_intr (0x%x) found: \
+		dev_warn(dev, "rxm_mem0_accbad_intr (0x%x) found: \
 		       memory address is 0x%08X\n",
-		      dev_name(dev), irq_value,
+		      irq_value,
 		      (reg_val & HGC_RXM_DFX_STATUS14_MEM0_MSK) >>
 		      HGC_RXM_DFX_STATUS14_MEM0_OFF);
+		queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 	}
 
 	if (irq_value & BIT(SAS_ECC_INTR_NCQ_MEM1_ECC_MB_OFF)) {
 		reg_val = hisi_sas_read32(hisi_hba, HGC_RXM_DFX_STATUS14);
-		panic("%s: rxm_mem1_accbad_intr (0x%x) found: \
+		dev_warn(dev, "rxm_mem1_accbad_intr (0x%x) found: \
 		       memory address is 0x%08X\n",
-		      dev_name(dev), irq_value,
+		      irq_value,
 		      (reg_val & HGC_RXM_DFX_STATUS14_MEM1_MSK) >>
 		      HGC_RXM_DFX_STATUS14_MEM1_OFF);
+		queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 	}
 
 	if (irq_value & BIT(SAS_ECC_INTR_NCQ_MEM2_ECC_MB_OFF)) {
 		reg_val = hisi_sas_read32(hisi_hba, HGC_RXM_DFX_STATUS14);
-		panic("%s: rxm_mem2_accbad_intr (0x%x) found: \
+		dev_warn(dev, "rxm_mem2_accbad_intr (0x%x) found: \
 		       memory address is 0x%08X\n",
-		      dev_name(dev), irq_value,
+		      irq_value,
 		      (reg_val & HGC_RXM_DFX_STATUS14_MEM2_MSK) >>
 		      HGC_RXM_DFX_STATUS14_MEM2_OFF);
+		queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 	}
 
 	if (irq_value & BIT(SAS_ECC_INTR_NCQ_MEM3_ECC_MB_OFF)) {
 		reg_val = hisi_sas_read32(hisi_hba, HGC_RXM_DFX_STATUS15);
-		panic("%s: rxm_mem3_accbad_intr (0x%x) found: \
+		dev_warn(dev, "rxm_mem3_accbad_intr (0x%x) found: \
 		       memory address is 0x%08X\n",
-		      dev_name(dev), irq_value,
+		      irq_value,
 		      (reg_val & HGC_RXM_DFX_STATUS15_MEM3_MSK) >>
 		      HGC_RXM_DFX_STATUS15_MEM3_OFF);
+		queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 	}
 
+	return;
 }
 
 static irqreturn_t fatal_ecc_int_v2_hw(int irq_no, void *p)
@@ -3063,23 +3074,27 @@ static irqreturn_t fatal_axi_int_v2_hw(int irq_no, void *p)
 		if (irq_value & BIT(ENT_INT_SRC3_WP_DEPTH_OFF)) {
 			hisi_sas_write32(hisi_hba, ENT_INT_SRC3,
 					1 << ENT_INT_SRC3_WP_DEPTH_OFF);
-			panic("%s: write pointer and depth error (0x%x) \
+			dev_warn(dev, "write pointer and depth error (0x%x) \
 			       found!\n",
-			      dev_name(dev), irq_value);
+			       irq_value);
+			queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 		}
 
 		if (irq_value & BIT(ENT_INT_SRC3_IPTT_SLOT_NOMATCH_OFF)) {
 			hisi_sas_write32(hisi_hba, ENT_INT_SRC3,
 					 1 <<
 					 ENT_INT_SRC3_IPTT_SLOT_NOMATCH_OFF);
-			panic("%s: iptt no match slot error (0x%x) found!\n",
-			      dev_name(dev), irq_value);
+			dev_warn(dev, "iptt no match slot error (0x%x) found!\n",
+			      irq_value);
+			queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 		}
 
-		if (irq_value & BIT(ENT_INT_SRC3_RP_DEPTH_OFF))
-			panic("%s: read pointer and depth error (0x%x) \
+		if (irq_value & BIT(ENT_INT_SRC3_RP_DEPTH_OFF)) {
+			dev_warn(dev, "read pointer and depth error (0x%x) \
 			       found!\n",
-			      dev_name(dev), irq_value);
+			       irq_value);
+			queue_work(hisi_hba->wq, &hisi_hba->rst_work);
+		}
 
 		if (irq_value & BIT(ENT_INT_SRC3_AXI_OFF)) {
 			int i;
@@ -3090,10 +3105,11 @@ static irqreturn_t fatal_axi_int_v2_hw(int irq_no, void *p)
 						    HGC_AXI_FIFO_ERR_INFO);
 
 			for (i = 0; i < AXI_ERR_NR; i++) {
-				if (err_value & BIT(i))
-					panic("%s: %s (0x%x) found!\n",
-					       dev_name(dev),
+				if (err_value & BIT(i)) {
+					dev_warn(dev, "%s (0x%x) found!\n",
 					      axi_err_info[i], irq_value);
+					queue_work(hisi_hba->wq, &hisi_hba->rst_work);
+				}
 			}
 		}
 
@@ -3106,10 +3122,11 @@ static irqreturn_t fatal_axi_int_v2_hw(int irq_no, void *p)
 						    HGC_AXI_FIFO_ERR_INFO);
 
 			for (i = 0; i < FIFO_ERR_NR; i++) {
-				if (err_value & BIT(AXI_ERR_NR + i))
-					panic("%s: %s (0x%x) found!\n",
-					      dev_name(dev),
+				if (err_value & BIT(AXI_ERR_NR + i)) {
+					dev_warn(dev, "%s (0x%x) found!\n",
 					      fifo_err_info[i], irq_value);
+					queue_work(hisi_hba->wq, &hisi_hba->rst_work);
+				}
 			}
 
 		}
@@ -3117,15 +3134,17 @@ static irqreturn_t fatal_axi_int_v2_hw(int irq_no, void *p)
 		if (irq_value & BIT(ENT_INT_SRC3_LM_OFF)) {
 			hisi_sas_write32(hisi_hba, ENT_INT_SRC3,
 					1 << ENT_INT_SRC3_LM_OFF);
-			panic("%s: LM add/fetch list error (0x%x) found!\n",
-			      dev_name(dev), irq_value);
+			dev_warn(dev, "LM add/fetch list error (0x%x) found!\n",
+			      irq_value);
+			queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 		}
 
 		if (irq_value & BIT(ENT_INT_SRC3_ABT_OFF)) {
 			hisi_sas_write32(hisi_hba, ENT_INT_SRC3,
 					1 << ENT_INT_SRC3_ABT_OFF);
-			panic("%s: SAS_HGC_ABT fetch LM list error (0x%x) found!\n",
-			      dev_name(dev), irq_value);
+			dev_warn(dev, "SAS_HGC_ABT fetch LM list error (0x%x) found!\n",
+			      irq_value);
+			queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 		}
 	}
 
-- 
1.9.1

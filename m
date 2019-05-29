From: John Garry <john.garry@huawei.com>
Subject: [PATCH 2/6] scsi: hisi_sas: Fix the issue of argument mismatch of printing ecc errors
Date: Wed, 29 May 2019 17:58:43 +0800
Message-ID: <1559123927-160502-3-git-send-email-john.garry@huawei.com>
References: <1559123927-160502-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1559123927-160502-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

The argument of dev_err() called by multi_bit_ecc_error_process_v3_hw()
is not right. We pass two arguments, but there is only one printk format
specifier in the string.

Besides, move the print format string to dev_err(). Then compiler can
find such issue in earlier stage.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 46 ++++++++++++++------------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 25 +++++++-------
 2 files changed, 37 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index d4650bed8274..b8c0ba778293 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -427,70 +427,70 @@ static const struct hisi_sas_hw_error one_bit_ecc_errors[] = {
 		.irq_msk = BIT(SAS_ECC_INTR_DQE_ECC_1B_OFF),
 		.msk = HGC_DQE_ECC_1B_ADDR_MSK,
 		.shift = HGC_DQE_ECC_1B_ADDR_OFF,
-		.msg = "hgc_dqe_acc1b_intr found: Ram address is 0x%08X\n",
+		.msg = "hgc_dqe_ecc1b_intr",
 		.reg = HGC_DQE_ECC_ADDR,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_IOST_ECC_1B_OFF),
 		.msk = HGC_IOST_ECC_1B_ADDR_MSK,
 		.shift = HGC_IOST_ECC_1B_ADDR_OFF,
-		.msg = "hgc_iost_acc1b_intr found: Ram address is 0x%08X\n",
+		.msg = "hgc_iost_ecc1b_intr",
 		.reg = HGC_IOST_ECC_ADDR,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_ITCT_ECC_1B_OFF),
 		.msk = HGC_ITCT_ECC_1B_ADDR_MSK,
 		.shift = HGC_ITCT_ECC_1B_ADDR_OFF,
-		.msg = "hgc_itct_acc1b_intr found: am address is 0x%08X\n",
+		.msg = "hgc_itct_ecc1b_intr",
 		.reg = HGC_ITCT_ECC_ADDR,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_IOSTLIST_ECC_1B_OFF),
 		.msk = HGC_LM_DFX_STATUS2_IOSTLIST_MSK,
 		.shift = HGC_LM_DFX_STATUS2_IOSTLIST_OFF,
-		.msg = "hgc_iostl_acc1b_intr found: memory address is 0x%08X\n",
+		.msg = "hgc_iostl_ecc1b_intr",
 		.reg = HGC_LM_DFX_STATUS2,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_ITCTLIST_ECC_1B_OFF),
 		.msk = HGC_LM_DFX_STATUS2_ITCTLIST_MSK,
 		.shift = HGC_LM_DFX_STATUS2_ITCTLIST_OFF,
-		.msg = "hgc_itctl_acc1b_intr found: memory address is 0x%08X\n",
+		.msg = "hgc_itctl_ecc1b_intr",
 		.reg = HGC_LM_DFX_STATUS2,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_CQE_ECC_1B_OFF),
 		.msk = HGC_CQE_ECC_1B_ADDR_MSK,
 		.shift = HGC_CQE_ECC_1B_ADDR_OFF,
-		.msg = "hgc_cqe_acc1b_intr found: Ram address is 0x%08X\n",
+		.msg = "hgc_cqe_ecc1b_intr",
 		.reg = HGC_CQE_ECC_ADDR,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_NCQ_MEM0_ECC_1B_OFF),
 		.msk = HGC_RXM_DFX_STATUS14_MEM0_MSK,
 		.shift = HGC_RXM_DFX_STATUS14_MEM0_OFF,
-		.msg = "rxm_mem0_acc1b_intr found: memory address is 0x%08X\n",
+		.msg = "rxm_mem0_ecc1b_intr",
 		.reg = HGC_RXM_DFX_STATUS14,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_NCQ_MEM1_ECC_1B_OFF),
 		.msk = HGC_RXM_DFX_STATUS14_MEM1_MSK,
 		.shift = HGC_RXM_DFX_STATUS14_MEM1_OFF,
-		.msg = "rxm_mem1_acc1b_intr found: memory address is 0x%08X\n",
+		.msg = "rxm_mem1_ecc1b_intr",
 		.reg = HGC_RXM_DFX_STATUS14,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_NCQ_MEM2_ECC_1B_OFF),
 		.msk = HGC_RXM_DFX_STATUS14_MEM2_MSK,
 		.shift = HGC_RXM_DFX_STATUS14_MEM2_OFF,
-		.msg = "rxm_mem2_acc1b_intr found: memory address is 0x%08X\n",
+		.msg = "rxm_mem2_ecc1b_intr",
 		.reg = HGC_RXM_DFX_STATUS14,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_NCQ_MEM3_ECC_1B_OFF),
 		.msk = HGC_RXM_DFX_STATUS15_MEM3_MSK,
 		.shift = HGC_RXM_DFX_STATUS15_MEM3_OFF,
-		.msg = "rxm_mem3_acc1b_intr found: memory address is 0x%08X\n",
+		.msg = "rxm_mem3_ecc1b_intr",
 		.reg = HGC_RXM_DFX_STATUS15,
 	},
 };
@@ -500,70 +500,70 @@ static const struct hisi_sas_hw_error multi_bit_ecc_errors[] = {
 		.irq_msk = BIT(SAS_ECC_INTR_DQE_ECC_MB_OFF),
 		.msk = HGC_DQE_ECC_MB_ADDR_MSK,
 		.shift = HGC_DQE_ECC_MB_ADDR_OFF,
-		.msg = "hgc_dqe_accbad_intr (0x%x) found: Ram address is 0x%08X\n",
+		.msg = "hgc_dqe_eccbad_intr",
 		.reg = HGC_DQE_ECC_ADDR,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_IOST_ECC_MB_OFF),
 		.msk = HGC_IOST_ECC_MB_ADDR_MSK,
 		.shift = HGC_IOST_ECC_MB_ADDR_OFF,
-		.msg = "hgc_iost_accbad_intr (0x%x) found: Ram address is 0x%08X\n",
+		.msg = "hgc_iost_eccbad_intr",
 		.reg = HGC_IOST_ECC_ADDR,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_ITCT_ECC_MB_OFF),
 		.msk = HGC_ITCT_ECC_MB_ADDR_MSK,
 		.shift = HGC_ITCT_ECC_MB_ADDR_OFF,
-		.msg = "hgc_itct_accbad_intr (0x%x) found: Ram address is 0x%08X\n",
+		.msg = "hgc_itct_eccbad_intr",
 		.reg = HGC_ITCT_ECC_ADDR,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_IOSTLIST_ECC_MB_OFF),
 		.msk = HGC_LM_DFX_STATUS2_IOSTLIST_MSK,
 		.shift = HGC_LM_DFX_STATUS2_IOSTLIST_OFF,
-		.msg = "hgc_iostl_accbad_intr (0x%x) found: memory address is 0x%08X\n",
+		.msg = "hgc_iostl_eccbad_intr",
 		.reg = HGC_LM_DFX_STATUS2,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_ITCTLIST_ECC_MB_OFF),
 		.msk = HGC_LM_DFX_STATUS2_ITCTLIST_MSK,
 		.shift = HGC_LM_DFX_STATUS2_ITCTLIST_OFF,
-		.msg = "hgc_itctl_accbad_intr (0x%x) found: memory address is 0x%08X\n",
+		.msg = "hgc_itctl_eccbad_intr",
 		.reg = HGC_LM_DFX_STATUS2,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_CQE_ECC_MB_OFF),
 		.msk = HGC_CQE_ECC_MB_ADDR_MSK,
 		.shift = HGC_CQE_ECC_MB_ADDR_OFF,
-		.msg = "hgc_cqe_accbad_intr (0x%x) found: Ram address is 0x%08X\n",
+		.msg = "hgc_cqe_eccbad_intr",
 		.reg = HGC_CQE_ECC_ADDR,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_NCQ_MEM0_ECC_MB_OFF),
 		.msk = HGC_RXM_DFX_STATUS14_MEM0_MSK,
 		.shift = HGC_RXM_DFX_STATUS14_MEM0_OFF,
-		.msg = "rxm_mem0_accbad_intr (0x%x) found: memory address is 0x%08X\n",
+		.msg = "rxm_mem0_eccbad_intr",
 		.reg = HGC_RXM_DFX_STATUS14,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_NCQ_MEM1_ECC_MB_OFF),
 		.msk = HGC_RXM_DFX_STATUS14_MEM1_MSK,
 		.shift = HGC_RXM_DFX_STATUS14_MEM1_OFF,
-		.msg = "rxm_mem1_accbad_intr (0x%x) found: memory address is 0x%08X\n",
+		.msg = "rxm_mem1_eccbad_intr",
 		.reg = HGC_RXM_DFX_STATUS14,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_NCQ_MEM2_ECC_MB_OFF),
 		.msk = HGC_RXM_DFX_STATUS14_MEM2_MSK,
 		.shift = HGC_RXM_DFX_STATUS14_MEM2_OFF,
-		.msg = "rxm_mem2_accbad_intr (0x%x) found: memory address is 0x%08X\n",
+		.msg = "rxm_mem2_eccbad_intr",
 		.reg = HGC_RXM_DFX_STATUS14,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_NCQ_MEM3_ECC_MB_OFF),
 		.msk = HGC_RXM_DFX_STATUS15_MEM3_MSK,
 		.shift = HGC_RXM_DFX_STATUS15_MEM3_OFF,
-		.msg = "rxm_mem3_accbad_intr (0x%x) found: memory address is 0x%08X\n",
+		.msg = "rxm_mem3_eccbad_intr",
 		.reg = HGC_RXM_DFX_STATUS15,
 	},
 };
@@ -2978,7 +2978,8 @@ one_bit_ecc_error_process_v2_hw(struct hisi_hba *hisi_hba, u32 irq_value)
 			val = hisi_sas_read32(hisi_hba, ecc_error->reg);
 			val &= ecc_error->msk;
 			val >>= ecc_error->shift;
-			dev_warn(dev, ecc_error->msg, val);
+			dev_warn(dev, "%s found: mem addr is 0x%08X\n",
+				 ecc_error->msg, val);
 		}
 	}
 }
@@ -2997,7 +2998,8 @@ static void multi_bit_ecc_error_process_v2_hw(struct hisi_hba *hisi_hba,
 			val = hisi_sas_read32(hisi_hba, ecc_error->reg);
 			val &= ecc_error->msk;
 			val >>= ecc_error->shift;
-			dev_err(dev, ecc_error->msg, irq_value, val);
+			dev_err(dev, "%s (0x%x) found: mem addr is 0x%08X\n",
+				ecc_error->msg, irq_value, val);
 			queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 		}
 	}
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 49620c2411df..3efb1e72bdab 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1831,77 +1831,77 @@ static const struct hisi_sas_hw_error multi_bit_ecc_errors[] = {
 		.irq_msk = BIT(SAS_ECC_INTR_DQE_ECC_MB_OFF),
 		.msk = HGC_DQE_ECC_MB_ADDR_MSK,
 		.shift = HGC_DQE_ECC_MB_ADDR_OFF,
-		.msg = "hgc_dqe_eccbad_intr found: ram addr is 0x%08X\n",
+		.msg = "hgc_dqe_eccbad_intr",
 		.reg = HGC_DQE_ECC_ADDR,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_IOST_ECC_MB_OFF),
 		.msk = HGC_IOST_ECC_MB_ADDR_MSK,
 		.shift = HGC_IOST_ECC_MB_ADDR_OFF,
-		.msg = "hgc_iost_eccbad_intr found: ram addr is 0x%08X\n",
+		.msg = "hgc_iost_eccbad_intr",
 		.reg = HGC_IOST_ECC_ADDR,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_ITCT_ECC_MB_OFF),
 		.msk = HGC_ITCT_ECC_MB_ADDR_MSK,
 		.shift = HGC_ITCT_ECC_MB_ADDR_OFF,
-		.msg = "hgc_itct_eccbad_intr found: ram addr is 0x%08X\n",
+		.msg = "hgc_itct_eccbad_intr",
 		.reg = HGC_ITCT_ECC_ADDR,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_IOSTLIST_ECC_MB_OFF),
 		.msk = HGC_LM_DFX_STATUS2_IOSTLIST_MSK,
 		.shift = HGC_LM_DFX_STATUS2_IOSTLIST_OFF,
-		.msg = "hgc_iostl_eccbad_intr found: mem addr is 0x%08X\n",
+		.msg = "hgc_iostl_eccbad_intr",
 		.reg = HGC_LM_DFX_STATUS2,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_ITCTLIST_ECC_MB_OFF),
 		.msk = HGC_LM_DFX_STATUS2_ITCTLIST_MSK,
 		.shift = HGC_LM_DFX_STATUS2_ITCTLIST_OFF,
-		.msg = "hgc_itctl_eccbad_intr found: mem addr is 0x%08X\n",
+		.msg = "hgc_itctl_eccbad_intr",
 		.reg = HGC_LM_DFX_STATUS2,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_CQE_ECC_MB_OFF),
 		.msk = HGC_CQE_ECC_MB_ADDR_MSK,
 		.shift = HGC_CQE_ECC_MB_ADDR_OFF,
-		.msg = "hgc_cqe_eccbad_intr found: ram address is 0x%08X\n",
+		.msg = "hgc_cqe_eccbad_intr",
 		.reg = HGC_CQE_ECC_ADDR,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_NCQ_MEM0_ECC_MB_OFF),
 		.msk = HGC_RXM_DFX_STATUS14_MEM0_MSK,
 		.shift = HGC_RXM_DFX_STATUS14_MEM0_OFF,
-		.msg = "rxm_mem0_eccbad_intr found: mem addr is 0x%08X\n",
+		.msg = "rxm_mem0_eccbad_intr",
 		.reg = HGC_RXM_DFX_STATUS14,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_NCQ_MEM1_ECC_MB_OFF),
 		.msk = HGC_RXM_DFX_STATUS14_MEM1_MSK,
 		.shift = HGC_RXM_DFX_STATUS14_MEM1_OFF,
-		.msg = "rxm_mem1_eccbad_intr found: mem addr is 0x%08X\n",
+		.msg = "rxm_mem1_eccbad_intr",
 		.reg = HGC_RXM_DFX_STATUS14,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_NCQ_MEM2_ECC_MB_OFF),
 		.msk = HGC_RXM_DFX_STATUS14_MEM2_MSK,
 		.shift = HGC_RXM_DFX_STATUS14_MEM2_OFF,
-		.msg = "rxm_mem2_eccbad_intr found: mem addr is 0x%08X\n",
+		.msg = "rxm_mem2_eccbad_intr",
 		.reg = HGC_RXM_DFX_STATUS14,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_NCQ_MEM3_ECC_MB_OFF),
 		.msk = HGC_RXM_DFX_STATUS15_MEM3_MSK,
 		.shift = HGC_RXM_DFX_STATUS15_MEM3_OFF,
-		.msg = "rxm_mem3_eccbad_intr found: mem addr is 0x%08X\n",
+		.msg = "rxm_mem3_eccbad_intr",
 		.reg = HGC_RXM_DFX_STATUS15,
 	},
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_OOO_RAM_ECC_MB_OFF),
 		.msk = AM_ROB_ECC_ERR_ADDR_MSK,
 		.shift = AM_ROB_ECC_ERR_ADDR_OFF,
-		.msg = "ooo_ram_eccbad_intr found: ROB_ECC_ERR_ADDR=0x%08X\n",
+		.msg = "ooo_ram_eccbad_intr",
 		.reg = AM_ROB_ECC_ERR_ADDR,
 	},
 };
@@ -1920,7 +1920,8 @@ static void multi_bit_ecc_error_process_v3_hw(struct hisi_hba *hisi_hba,
 			val = hisi_sas_read32(hisi_hba, ecc_error->reg);
 			val &= ecc_error->msk;
 			val >>= ecc_error->shift;
-			dev_err(dev, ecc_error->msg, irq_value, val);
+			dev_err(dev, "%s (0x%x) found: mem addr is 0x%08X\n",
+				ecc_error->msg, irq_value, val);
 			queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 		}
 	}
-- 
2.17.1

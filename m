From: Bharat Uppal <bharat.uppal@samsung.com>
Subject: [PATCH V3] scsi: ufs: Add specific callback for setting DMA mask
Date: Sun, 20 May 2018 07:41:02 +0530
Message-ID: <1526782262-9808-1-git-send-email-bharat.uppal@samsung.com>
References: <CGME20180520022321epcas1p4b0084a15aca3e5aea02700e272149ef3@epcas1p4.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, subhashj@codeaurora.org, vinholikatti@gmail.com, shaik.ameer@samsung.com, alim.akhtar@samsung.com
List-Id: linux-scsi@vger.kernel.org

From: Alim Akhtar <alim.akhtar@samsung.com>

Currently DMA mask for UFS HCI is set by reading CAP register's
[64AS] bit. Some HCI controller like Exynos support 36-bit bus address.
This works perfectly fine with DMA mask set as 64 in case there is no
IOMMU attached to HCI.
In case if HCI is behind an IOMMU, setting DMA mask as 64 bit won't
work as HCI has only 36bit addressing and SMMU has created mapping of
64 bit and as the device truncates the address, its mapping will not
be found by iommu.
To resolve such issues, let the variant driver sets its own DMA mask.

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 drivers/scsi/ufs/ufshcd.h | 2 ++
 2 files changed, 5 insertions(+)

I am not sure if there are other ways available to handle such cases.
The IOMMU I am talking about is arm-smmu and it DT binding does not
give much idea about handling such cases.
Have tested this patch with HCI controller with IOMMU attached.

Changes Since V1: 
	- Fixed build issue as reported by Kbuild test robot.

Changes Since V2: 
	- Remove RFC tag as suggested by Subhash.

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a355d98..9a1374e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7781,6 +7781,9 @@ EXPORT_SYMBOL_GPL(ufshcd_dealloc_host);
  */
 static int ufshcd_set_dma_mask(struct ufs_hba *hba)
 {
+	if (hba->vops && hba->vops->set_dma_mask)
+		return hba->vops->set_dma_mask(hba);
+
 	if (hba->capabilities & MASK_64_ADDRESSING_SUPPORT) {
 		if (!dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(64)))
 			return 0;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 1332e54..89c6dae 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -297,6 +297,7 @@ struct ufs_pwr_mode_info {
  * @resume: called during host controller PM callback
  * @dbg_register_dump: used to dump controller debug information
  * @phy_initialization: used to initialize phys
+ * @set_dma_mask: used to set variant specific DMA mask
  */
 struct ufs_hba_variant_ops {
 	const char *name;
@@ -325,6 +326,7 @@ struct ufs_hba_variant_ops {
 	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
 	void	(*dbg_register_dump)(struct ufs_hba *hba);
 	int	(*phy_initialization)(struct ufs_hba *);
+	int	(*set_dma_mask)(struct ufs_hba *hba);
 };
 
 /* clock gating state  */
-- 
2.7.4

From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v4 14/14] mpt3sas: Fix sparse warning
Date: Mon, 21 Aug 2017 19:02:24 +0530
Message-ID: <1503322344-5900-15-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1503322344-5900-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503322344-5900-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, martin.p^Cersen@oracle.com, linux-nvme@lists.infradead.org, root <root@dhcp-135-24-192-103.dhcp.avagotech.net>
List-Id: linux-scsi@vger.kernel.org

From: root <root@dhcp-135-24-192-103.dhcp.avagotech.net>

1) Used data type __le64/__le32 whichever required in
building NVME PRP, which is passed to LE Controller.
2) Remove unused function, Declared functions which are used only
in mpt3sas_scsih.c as static.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 23 +++++++++++-----------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 37 +++++-------------------------------
 2 files changed, 16 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 3e571ef..9ec7f0e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1437,8 +1437,8 @@ _base_build_nvme_prp(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 	size_t data_in_sz)
 {
 	int		prp_size = NVME_PRP_SIZE;
-	u64		*prp_entry, *prp1_entry, *prp2_entry, *prp_entry_phys;
-	u64		*prp_page, *prp_page_phys;
+	__le64		*prp_entry, *prp1_entry, *prp2_entry, *prp_entry_phys;
+	__le64		*prp_page, *prp_page_phys;
 	u32		offset, entry_len;
 	u32		page_mask_result, page_mask;
 	dma_addr_t	paddr;
@@ -1455,17 +1455,17 @@ _base_build_nvme_prp(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 	 * PRP1 is located at a 24 byte offset from the start of the NVMe
 	 * command.  Then set the current PRP entry pointer to PRP1.
 	 */
-	prp1_entry = (u64 *)(nvme_encap_request->NVMe_Command +
+	prp1_entry = (__le64 *)(nvme_encap_request->NVMe_Command +
 	    NVME_CMD_PRP1_OFFSET);
-	prp2_entry = (u64 *)(nvme_encap_request->NVMe_Command +
+	prp2_entry = (__le64 *)(nvme_encap_request->NVMe_Command +
 	    NVME_CMD_PRP2_OFFSET);
 	prp_entry = prp1_entry;
 	/*
 	 * For the PRP entries, use the specially allocated buffer of
 	 * contiguous memory.
 	 */
-	prp_page = (u64 *)mpt3sas_base_get_pcie_sgl(ioc, smid);
-	prp_page_phys = (u64 *)mpt3sas_base_get_pcie_sgl_dma(ioc, smid);
+	prp_page = (__le64 *)mpt3sas_base_get_pcie_sgl(ioc, smid);
+	prp_page_phys = (__le64 *)mpt3sas_base_get_pcie_sgl_dma(ioc, smid);
 
 	/*
 	 * Check if we are within 1 entry of a page boundary we don't
@@ -1475,8 +1475,8 @@ _base_build_nvme_prp(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 	page_mask_result = (uintptr_t)((u8 *)prp_page + prp_size) & page_mask;
 	if (!page_mask_result) {
 		/* Bump up to next page boundary. */
-		prp_page = (u64 *)((u8 *)prp_page + prp_size);
-		prp_page_phys = (u64 *)((u8 *)prp_page_phys + prp_size);
+		prp_page = (__le64 *)((u8 *)prp_page + prp_size);
+		prp_page_phys = (__le64 *)((u8 *)prp_page_phys + prp_size);
 	}
 
 	/*
@@ -1604,7 +1604,7 @@ _base_build_nvme_prp(struct MPT3SAS_ADAPTER *ioc, u16 smid,
  * Returns:		true: PRPs are built
  *			false: IEEE SGLs needs to be built
  */
-void
+static void
 base_make_prp_nvme(struct MPT3SAS_ADAPTER *ioc,
 		struct scsi_cmnd *scmd,
 		Mpi25SCSIIORequest_t *mpi_request,
@@ -1612,7 +1612,7 @@ base_make_prp_nvme(struct MPT3SAS_ADAPTER *ioc,
 {
 	int sge_len, offset, num_prp_in_chain = 0;
 	Mpi25IeeeSgeChain64_t *main_chain_element, *ptr_first_sgl;
-	u64 *curr_buff;
+	__le64 *curr_buff;
 	dma_addr_t msg_phys;
 	u64 sge_addr;
 	u32 page_mask, page_mask_result;
@@ -1736,7 +1736,6 @@ static bool
 base_is_prp_possible(struct MPT3SAS_ADAPTER *ioc,
 	struct _pcie_device *pcie_device, struct scsi_cmnd *scmd, int sge_count)
 {
-	u32 i;
 	u32 data_length = 0;
 	struct scatterlist *sg_scmd;
 	bool build_prp = false;
@@ -1746,7 +1745,7 @@ base_is_prp_possible(struct MPT3SAS_ADAPTER *ioc,
 
 	nvme_pg_size = max_t(u32, ioc->page_size,
 			NVME_PRP_PAGE_SIZE);
-	data_length = cpu_to_le32(scsi_bufflen(scmd));
+	data_length = scsi_bufflen(scmd);
 	sg_scmd = scsi_sglist(scmd);
 
 	/* Create page_mask (to get offset within page) */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 49e1943..f8990d9 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -600,7 +600,7 @@ __mpt3sas_get_pdev_from_target(struct MPT3SAS_ADAPTER *ioc,
  *
  * This searches for pcie_device from target, then return pcie_device object.
  */
-struct _pcie_device *
+static struct _pcie_device *
 mpt3sas_get_pdev_from_target(struct MPT3SAS_ADAPTER *ioc,
 	struct MPT3SAS_TARGET *tgt_priv)
 {
@@ -908,7 +908,7 @@ _scsih_sas_device_init_add(struct MPT3SAS_ADAPTER *ioc,
 }
 
 
-struct _pcie_device *
+static struct _pcie_device *
 __mpt3sas_get_pdev_by_wwid(struct MPT3SAS_ADAPTER *ioc, u64 wwid)
 {
 	struct _pcie_device *pcie_device;
@@ -941,7 +941,7 @@ found_device:
  *
  * This searches for pcie_device based on wwid, then return pcie_device object.
  */
-struct _pcie_device *
+static struct _pcie_device *
 mpt3sas_get_pdev_by_wwid(struct MPT3SAS_ADAPTER *ioc, u64 wwid)
 {
 	struct _pcie_device *pcie_device;
@@ -955,7 +955,7 @@ mpt3sas_get_pdev_by_wwid(struct MPT3SAS_ADAPTER *ioc, u64 wwid)
 }
 
 
-struct _pcie_device *
+static struct _pcie_device *
 __mpt3sas_get_pdev_by_idchannel(struct MPT3SAS_ADAPTER *ioc, int id,
 	int channel)
 {
@@ -978,34 +978,7 @@ found_device:
 	return pcie_device;
 }
 
-
-/**
- * mpt3sas_get_pdev_by_idchannel - pcie device search
- * @ioc: per adapter object
- * @id: Target ID
- * @channel: Channel ID
- *
- * Context: This function will acquire ioc->pcie_device_lock and will release
- * before returning the pcie_device object.
- *
- * This searches for pcie_device based on id and channel, then return
- * pcie_device object.
- */
-struct _pcie_device *
-mpt3sas_get_pdev_by_idchannel(struct MPT3SAS_ADAPTER *ioc, int id, int channel)
-{
-	struct _pcie_device *pcie_device;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ioc->pcie_device_lock, flags);
-	pcie_device = __mpt3sas_get_pdev_by_idchannel(ioc, id, channel);
-	spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
-
-	return pcie_device;
-}
-
-
-struct _pcie_device *
+static struct _pcie_device *
 __mpt3sas_get_pdev_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 {
 	struct _pcie_device *pcie_device;
-- 
2.5.5

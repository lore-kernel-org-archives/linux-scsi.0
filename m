From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 01/24] bfa: enable new hardware
Date: Thu, 8 Jul 2010 19:45:20 -0700
Message-ID: <1278643520-27148-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:55476 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753676Ab0GICp0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2010 22:45:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: kgudipat@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

This patch enables support of new mezzanine cards for HP and IBM blade server.

- Add new pciids for HP and IBM mezzanine card.
- Add a new firmware image for HP mezzanine card, which is running in
  FC only mode. Rename firmware image to reflect the difference. Change the
  firmware download code accordingly for the above changes.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_core.c                  |    1 +
 drivers/scsi/bfa/bfa_fwimg_priv.h            |   25 +++++++--
 drivers/scsi/bfa/bfa_ioc.c                   |   33 ++++++------
 drivers/scsi/bfa/bfa_ioc.h                   |    7 ++-
 drivers/scsi/bfa/bfa_ioc_cb.c                |   36 ++++---------
 drivers/scsi/bfa/bfa_ioc_ct.c                |   46 ++++++----------
 drivers/scsi/bfa/bfa_iocfc.c                 |    6 +-
 drivers/scsi/bfa/bfad.c                      |    8 +++
 drivers/scsi/bfa/bfad_fwimg.c                |   76 +++++++++++++++++++-------
 drivers/scsi/bfa/bfad_im_compat.h            |   13 ++---
 drivers/scsi/bfa/bfad_intr.c                 |    4 +-
 drivers/scsi/bfa/include/bfi/bfi_ioc.h       |    1 +
 drivers/scsi/bfa/include/defs/bfa_defs_mfg.h |    3 +
 drivers/scsi/bfa/include/defs/bfa_defs_pci.h |   11 +++-
 14 files changed, 155 insertions(+), 115 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 3a7b3f8..bef7092 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -333,6 +333,7 @@ bfa_get_pciids(struct bfa_pciid_s **pciids, int *npciids)
 		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_FC_8G2P},
 		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_FC_8G1P},
 		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_CT},
+		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_CT_FC},
 	};
 
 	*npciids = sizeof(__pciids) / sizeof(__pciids[0]);
diff --git a/drivers/scsi/bfa/bfa_fwimg_priv.h b/drivers/scsi/bfa/bfa_fwimg_priv.h
index 1ec1355..d33e19e 100644
--- a/drivers/scsi/bfa/bfa_fwimg_priv.h
+++ b/drivers/scsi/bfa/bfa_fwimg_priv.h
@@ -21,11 +21,24 @@
 #define	BFI_FLASH_CHUNK_SZ		256	/*  Flash chunk size */
 #define	BFI_FLASH_CHUNK_SZ_WORDS	(BFI_FLASH_CHUNK_SZ/sizeof(u32))
 
-extern u32 *bfi_image_ct_get_chunk(u32 off);
-extern u32 bfi_image_ct_size;
-extern u32 *bfi_image_cb_get_chunk(u32 off);
-extern u32 bfi_image_cb_size;
-extern u32 *bfi_image_cb;
-extern u32 *bfi_image_ct;
+/**
+ * BFI FW image type
+ */
+enum {
+	BFI_IMAGE_CB_FC,
+	BFI_IMAGE_CT_FC,
+	BFI_IMAGE_CT_CNA,
+	BFI_IMAGE_MAX,
+};
+
+extern u32 *bfi_image_get_chunk(int type, uint32_t off);
+extern u32 bfi_image_get_size(int type);
+extern u32 bfi_image_ct_fc_size;
+extern u32 bfi_image_ct_cna_size;
+extern u32 bfi_image_cb_fc_size;
+extern u32 *bfi_image_ct_fc;
+extern u32 *bfi_image_ct_cna;
+extern u32 *bfi_image_cb_fc;
+
 
 #endif /* __BFA_FWIMG_PRIV_H__ */
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index e038bc9..ef3b3fe 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -59,14 +59,12 @@ BFA_TRC_FILE(CNA, IOC);
 			((__ioc)->ioc_hwif->ioc_firmware_lock(__ioc))
 #define bfa_ioc_firmware_unlock(__ioc)                  \
 			((__ioc)->ioc_hwif->ioc_firmware_unlock(__ioc))
-#define bfa_ioc_fwimg_get_chunk(__ioc, __off)           \
-			((__ioc)->ioc_hwif->ioc_fwimg_get_chunk(__ioc, __off))
-#define bfa_ioc_fwimg_get_size(__ioc)                   \
-			((__ioc)->ioc_hwif->ioc_fwimg_get_size(__ioc))
 #define bfa_ioc_reg_init(__ioc) ((__ioc)->ioc_hwif->ioc_reg_init(__ioc))
 #define bfa_ioc_map_port(__ioc) ((__ioc)->ioc_hwif->ioc_map_port(__ioc))
 #define bfa_ioc_notify_hbfail(__ioc)                    \
 			((__ioc)->ioc_hwif->ioc_notify_hbfail(__ioc))
+#define bfa_ioc_is_optrom(__ioc)        \
+	(bfi_image_get_size(BFA_IOC_FWIMG_TYPE(__ioc)) < BFA_IOC_FWIMG_MINSZ)
 
 bfa_boolean_t   bfa_auto_recover = BFA_TRUE;
 
@@ -879,8 +877,8 @@ bfa_ioc_fwver_cmp(struct bfa_ioc_s *ioc, struct bfi_ioc_image_hdr_s *fwhdr)
 	struct bfi_ioc_image_hdr_s *drv_fwhdr;
 	int             i;
 
-	drv_fwhdr =
-		(struct bfi_ioc_image_hdr_s *)bfa_ioc_fwimg_get_chunk(ioc, 0);
+	drv_fwhdr = (struct bfi_ioc_image_hdr_s *)
+			bfi_image_get_chunk(BFA_IOC_FWIMG_TYPE(ioc), 0);
 
 	for (i = 0; i < BFI_IOC_MD5SUM_SZ; i++) {
 		if (fwhdr->md5sum[i] != drv_fwhdr->md5sum[i]) {
@@ -907,12 +905,13 @@ bfa_ioc_fwver_valid(struct bfa_ioc_s *ioc)
 	/**
 	 * If bios/efi boot (flash based) -- return true
 	 */
-	if (bfa_ioc_fwimg_get_size(ioc) < BFA_IOC_FWIMG_MINSZ)
+	if (bfa_ioc_is_optrom(ioc))
 		return BFA_TRUE;
 
 	bfa_ioc_fwver_get(ioc, &fwhdr);
-	drv_fwhdr =
-		(struct bfi_ioc_image_hdr_s *)bfa_ioc_fwimg_get_chunk(ioc, 0);
+	drv_fwhdr = (struct bfi_ioc_image_hdr_s *)
+			bfi_image_get_chunk(BFA_IOC_FWIMG_TYPE(ioc), 0);
+
 
 	if (fwhdr.signature != drv_fwhdr->signature) {
 		bfa_trc(ioc, fwhdr.signature);
@@ -1125,21 +1124,22 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 	/**
 	 * Flash based firmware boot
 	 */
-	bfa_trc(ioc, bfa_ioc_fwimg_get_size(ioc));
-	if (bfa_ioc_fwimg_get_size(ioc) < BFA_IOC_FWIMG_MINSZ)
+	bfa_trc(ioc, bfi_image_get_size(BFA_IOC_FWIMG_TYPE(ioc)));
+	if (bfa_ioc_is_optrom(ioc))
 		boot_type = BFI_BOOT_TYPE_FLASH;
-	fwimg = bfa_ioc_fwimg_get_chunk(ioc, chunkno);
+	fwimg = bfi_image_get_chunk(BFA_IOC_FWIMG_TYPE(ioc), chunkno);
+
 
 	pgnum = bfa_ioc_smem_pgnum(ioc, loff);
 	pgoff = bfa_ioc_smem_pgoff(ioc, loff);
 
 	bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
 
-	for (i = 0; i < bfa_ioc_fwimg_get_size(ioc); i++) {
+	for (i = 0; i < bfi_image_get_size(BFA_IOC_FWIMG_TYPE(ioc)); i++) {
 
 		if (BFA_IOC_FLASH_CHUNK_NO(i) != chunkno) {
 			chunkno = BFA_IOC_FLASH_CHUNK_NO(i);
-			fwimg = bfa_ioc_fwimg_get_chunk(ioc,
+			fwimg = bfi_image_get_chunk(BFA_IOC_FWIMG_TYPE(ioc),
 					BFA_IOC_FLASH_CHUNK_ADDR(chunkno));
 		}
 
@@ -1188,6 +1188,7 @@ bfa_ioc_getattr_reply(struct bfa_ioc_s *ioc)
 	struct bfi_ioc_attr_s *attr = ioc->attr;
 
 	attr->adapter_prop = bfa_os_ntohl(attr->adapter_prop);
+	attr->card_type     = bfa_os_ntohl(attr->card_type);
 	attr->maxfrsize = bfa_os_ntohs(attr->maxfrsize);
 
 	bfa_fsm_send_event(ioc, IOC_E_FWRSP_GETATTR);
@@ -1416,7 +1417,7 @@ bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct bfa_pcidev_s *pcidev,
 {
 	ioc->ioc_mc = mc;
 	ioc->pcidev = *pcidev;
-	ioc->ctdev = (ioc->pcidev.device_id == BFA_PCI_DEVICE_ID_CT);
+	ioc->ctdev  = bfa_asic_id_ct(ioc->pcidev.device_id);
 	ioc->cna = ioc->ctdev && !ioc->fcmode;
 
 	/**
@@ -1916,7 +1917,7 @@ bfa_ioc_set_fcmode(struct bfa_ioc_s *ioc)
 bfa_boolean_t
 bfa_ioc_get_fcmode(struct bfa_ioc_s *ioc)
 {
-	return ioc->fcmode || (ioc->pcidev.device_id != BFA_PCI_DEVICE_ID_CT);
+	return ioc->fcmode || !bfa_asic_id_ct(ioc->pcidev.device_id);
 }
 
 /**
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index d080440..2fbb6b2 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -186,9 +186,6 @@ struct bfa_ioc_hwif_s {
 	bfa_status_t    (*ioc_pll_init) (struct bfa_ioc_s *ioc);
 	bfa_boolean_t   (*ioc_firmware_lock)    (struct bfa_ioc_s *ioc);
 	void            (*ioc_firmware_unlock)  (struct bfa_ioc_s *ioc);
-	u32 *   	(*ioc_fwimg_get_chunk)  (struct bfa_ioc_s *ioc,
-						u32 off);
-	u32		(*ioc_fwimg_get_size)   (struct bfa_ioc_s *ioc);
 	void		(*ioc_reg_init) (struct bfa_ioc_s *ioc);
 	void		(*ioc_map_port) (struct bfa_ioc_s *ioc);
 	void		(*ioc_isr_mode_set)     (struct bfa_ioc_s *ioc,
@@ -214,6 +211,10 @@ struct bfa_ioc_hwif_s {
 
 #define bfa_ioc_stats(_ioc, _stats)     ((_ioc)->stats._stats++)
 #define BFA_IOC_FWIMG_MINSZ     (16 * 1024)
+#define BFA_IOC_FWIMG_TYPE(__ioc)                                       \
+	(((__ioc)->ctdev) ?                                             \
+	 (((__ioc)->fcmode) ? BFI_IMAGE_CT_FC : BFI_IMAGE_CT_CNA) :     \
+	 BFI_IMAGE_CB_FC)
 
 #define BFA_IOC_FLASH_CHUNK_NO(off)             (off / BFI_FLASH_CHUNK_SZ_WORDS)
 #define BFA_IOC_FLASH_OFFSET_IN_CHUNK(off)      (off % BFI_FLASH_CHUNK_SZ_WORDS)
diff --git a/drivers/scsi/bfa/bfa_ioc_cb.c b/drivers/scsi/bfa/bfa_ioc_cb.c
index 3ce8531..324bdde 100644
--- a/drivers/scsi/bfa/bfa_ioc_cb.c
+++ b/drivers/scsi/bfa/bfa_ioc_cb.c
@@ -33,26 +33,13 @@ BFA_TRC_FILE(CNA, IOC_CB);
 static bfa_status_t bfa_ioc_cb_pll_init(struct bfa_ioc_s *ioc);
 static bfa_boolean_t bfa_ioc_cb_firmware_lock(struct bfa_ioc_s *ioc);
 static void bfa_ioc_cb_firmware_unlock(struct bfa_ioc_s *ioc);
-static u32  *bfa_ioc_cb_fwimg_get_chunk(struct bfa_ioc_s *ioc, u32 off);
-static u32 bfa_ioc_cb_fwimg_get_size(struct bfa_ioc_s *ioc);
 static void bfa_ioc_cb_reg_init(struct bfa_ioc_s *ioc);
 static void bfa_ioc_cb_map_port(struct bfa_ioc_s *ioc);
 static void bfa_ioc_cb_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix);
 static void bfa_ioc_cb_notify_hbfail(struct bfa_ioc_s *ioc);
 static void bfa_ioc_cb_ownership_reset(struct bfa_ioc_s *ioc);
 
-struct bfa_ioc_hwif_s hwif_cb = {
-	bfa_ioc_cb_pll_init,
-	bfa_ioc_cb_firmware_lock,
-	bfa_ioc_cb_firmware_unlock,
-	bfa_ioc_cb_fwimg_get_chunk,
-	bfa_ioc_cb_fwimg_get_size,
-	bfa_ioc_cb_reg_init,
-	bfa_ioc_cb_map_port,
-	bfa_ioc_cb_isr_mode_set,
-	bfa_ioc_cb_notify_hbfail,
-	bfa_ioc_cb_ownership_reset,
-};
+struct bfa_ioc_hwif_s hwif_cb;
 
 /**
  * Called from bfa_ioc_attach() to map asic specific calls.
@@ -60,19 +47,16 @@ struct bfa_ioc_hwif_s hwif_cb = {
 void
 bfa_ioc_set_cb_hwif(struct bfa_ioc_s *ioc)
 {
-	ioc->ioc_hwif = &hwif_cb;
-}
-
-static u32 *
-bfa_ioc_cb_fwimg_get_chunk(struct bfa_ioc_s *ioc, u32 off)
-{
-	return bfi_image_cb_get_chunk(off);
-}
+	hwif_cb.ioc_pll_init = bfa_ioc_cb_pll_init;
+	hwif_cb.ioc_firmware_lock = bfa_ioc_cb_firmware_lock;
+	hwif_cb.ioc_firmware_unlock = bfa_ioc_cb_firmware_unlock;
+	hwif_cb.ioc_reg_init = bfa_ioc_cb_reg_init;
+	hwif_cb.ioc_map_port = bfa_ioc_cb_map_port;
+	hwif_cb.ioc_isr_mode_set = bfa_ioc_cb_isr_mode_set;
+	hwif_cb.ioc_notify_hbfail = bfa_ioc_cb_notify_hbfail;
+	hwif_cb.ioc_ownership_reset = bfa_ioc_cb_ownership_reset;
 
-static u32
-bfa_ioc_cb_fwimg_get_size(struct bfa_ioc_s *ioc)
-{
-	return bfi_image_cb_size;
+	ioc->ioc_hwif = &hwif_cb;
 }
 
 /**
diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index 20b58ad..17bd151 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -33,27 +33,13 @@ BFA_TRC_FILE(CNA, IOC_CT);
 static bfa_status_t bfa_ioc_ct_pll_init(struct bfa_ioc_s *ioc);
 static bfa_boolean_t bfa_ioc_ct_firmware_lock(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_firmware_unlock(struct bfa_ioc_s *ioc);
-static u32* bfa_ioc_ct_fwimg_get_chunk(struct bfa_ioc_s *ioc,
-					u32 off);
-static u32 bfa_ioc_ct_fwimg_get_size(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_reg_init(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_map_port(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix);
 static void bfa_ioc_ct_notify_hbfail(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_ownership_reset(struct bfa_ioc_s *ioc);
 
-struct bfa_ioc_hwif_s hwif_ct = {
-	bfa_ioc_ct_pll_init,
-	bfa_ioc_ct_firmware_lock,
-	bfa_ioc_ct_firmware_unlock,
-	bfa_ioc_ct_fwimg_get_chunk,
-	bfa_ioc_ct_fwimg_get_size,
-	bfa_ioc_ct_reg_init,
-	bfa_ioc_ct_map_port,
-	bfa_ioc_ct_isr_mode_set,
-	bfa_ioc_ct_notify_hbfail,
-	bfa_ioc_ct_ownership_reset,
-};
+struct bfa_ioc_hwif_s hwif_ct;
 
 /**
  * Called from bfa_ioc_attach() to map asic specific calls.
@@ -61,19 +47,16 @@ struct bfa_ioc_hwif_s hwif_ct = {
 void
 bfa_ioc_set_ct_hwif(struct bfa_ioc_s *ioc)
 {
-	ioc->ioc_hwif = &hwif_ct;
-}
+	hwif_ct.ioc_pll_init = bfa_ioc_ct_pll_init;
+	hwif_ct.ioc_firmware_lock = bfa_ioc_ct_firmware_lock;
+	hwif_ct.ioc_firmware_unlock = bfa_ioc_ct_firmware_unlock;
+	hwif_ct.ioc_reg_init = bfa_ioc_ct_reg_init;
+	hwif_ct.ioc_map_port = bfa_ioc_ct_map_port;
+	hwif_ct.ioc_isr_mode_set = bfa_ioc_ct_isr_mode_set;
+	hwif_ct.ioc_notify_hbfail = bfa_ioc_ct_notify_hbfail;
+	hwif_ct.ioc_ownership_reset = bfa_ioc_ct_ownership_reset;
 
-static u32*
-bfa_ioc_ct_fwimg_get_chunk(struct bfa_ioc_s *ioc, u32 off)
-{
-	return bfi_image_ct_get_chunk(off);
-}
-
-static u32
-bfa_ioc_ct_fwimg_get_size(struct bfa_ioc_s *ioc)
-{
-	return bfi_image_ct_size;
+	ioc->ioc_hwif = &hwif_ct;
 }
 
 /**
@@ -95,7 +78,7 @@ bfa_ioc_ct_firmware_lock(struct bfa_ioc_s *ioc)
 	/**
 	 * If bios boot (flash based) -- do not increment usage count
 	 */
-	if (bfa_ioc_ct_fwimg_get_size(ioc) < BFA_IOC_FWIMG_MINSZ)
+	if (bfi_image_get_size(BFA_IOC_FWIMG_TYPE(ioc)) < BFA_IOC_FWIMG_MINSZ)
 		return BFA_TRUE;
 
 	bfa_ioc_sem_get(ioc->ioc_regs.ioc_usage_sem_reg);
@@ -146,9 +129,14 @@ bfa_ioc_ct_firmware_unlock(struct bfa_ioc_s *ioc)
 
 	/**
 	 * Firmware lock is relevant only for CNA.
+	 */
+	if (!ioc->cna)
+		return;
+
+	/**
 	 * If bios boot (flash based) -- do not decrement usage count
 	 */
-	if (!ioc->cna || bfa_ioc_ct_fwimg_get_size(ioc) < BFA_IOC_FWIMG_MINSZ)
+	if (bfi_image_get_size(BFA_IOC_FWIMG_TYPE(ioc)) < BFA_IOC_FWIMG_MINSZ)
 		return;
 
 	/**
diff --git a/drivers/scsi/bfa/bfa_iocfc.c b/drivers/scsi/bfa/bfa_iocfc.c
index a76de26..273ecec 100644
--- a/drivers/scsi/bfa/bfa_iocfc.c
+++ b/drivers/scsi/bfa/bfa_iocfc.c
@@ -170,7 +170,7 @@ bfa_iocfc_init_mem(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	/**
 	 * Initialize chip specific handlers.
 	 */
-	if (bfa_ioc_devid(&bfa->ioc) == BFA_PCI_DEVICE_ID_CT) {
+	if (bfa_asic_id_ct(bfa_ioc_devid(&bfa->ioc))) {
 		iocfc->hwif.hw_reginit = bfa_hwct_reginit;
 		iocfc->hwif.hw_reqq_ack = bfa_hwct_reqq_ack;
 		iocfc->hwif.hw_rspq_ack = bfa_hwct_rspq_ack;
@@ -625,9 +625,9 @@ bfa_iocfc_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 		bfa->trcmod, bfa->aen, bfa->logm);
 
 	/**
-	 * Choose FC (ssid: 0x1C) v/s FCoE (ssid: 0x14) mode.
+	 * Set FC mode for BFA_PCI_DEVICE_ID_CT_FC.
 	 */
-	if (0)
+	if (pcidev->device_id == BFA_PCI_DEVICE_ID_CT_FC)
 		bfa_ioc_set_fcmode(&bfa->ioc);
 
 	bfa_ioc_pci_init(&bfa->ioc, pcidev, BFI_MC_IOCFC);
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index d4fc428..1b869ad 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1172,6 +1172,14 @@ static struct pci_device_id bfad_id_table[] = {
 	 .class = (PCI_CLASS_SERIAL_FIBER << 8),
 	 .class_mask = ~0,
 	 },
+	{
+	 .vendor = BFA_PCI_VENDOR_ID_BROCADE,
+	 .device = BFA_PCI_DEVICE_ID_CT_FC,
+	 .subvendor = PCI_ANY_ID,
+	 .subdevice = PCI_ANY_ID,
+	 .class = (PCI_CLASS_SERIAL_FIBER << 8),
+	 .class_mask = ~0,
+	},
 
 	{0, 0},
 };
diff --git a/drivers/scsi/bfa/bfad_fwimg.c b/drivers/scsi/bfa/bfad_fwimg.c
index 2ad65f2..1baca1a 100644
--- a/drivers/scsi/bfa/bfad_fwimg.c
+++ b/drivers/scsi/bfa/bfad_fwimg.c
@@ -33,16 +33,20 @@
 #include <bfa_fwimg_priv.h>
 #include <bfa.h>
 
-u32 bfi_image_ct_size;
-u32 bfi_image_cb_size;
-u32 *bfi_image_ct;
-u32 *bfi_image_cb;
+u32 bfi_image_ct_fc_size;
+u32 bfi_image_ct_cna_size;
+u32 bfi_image_cb_fc_size;
+u32 *bfi_image_ct_fc;
+u32 *bfi_image_ct_cna;
+u32 *bfi_image_cb_fc;
 
 
-#define	BFAD_FW_FILE_CT	"ctfw.bin"
-#define	BFAD_FW_FILE_CB	"cbfw.bin"
-MODULE_FIRMWARE(BFAD_FW_FILE_CT);
-MODULE_FIRMWARE(BFAD_FW_FILE_CB);
+#define	BFAD_FW_FILE_CT_FC	"ctfw_fc.bin"
+#define	BFAD_FW_FILE_CT_CNA	"ctfw_cna.bin"
+#define	BFAD_FW_FILE_CB_FC	"cbfw_fc.bin"
+MODULE_FIRMWARE(BFAD_FW_FILE_CT_FC);
+MODULE_FIRMWARE(BFAD_FW_FILE_CT_CNA);
+MODULE_FIRMWARE(BFAD_FW_FILE_CB_FC);
 
 u32 *
 bfad_read_firmware(struct pci_dev *pdev, u32 **bfi_image,
@@ -74,24 +78,54 @@ error:
 u32 *
 bfad_get_firmware_buf(struct pci_dev *pdev)
 {
-	if (pdev->device == BFA_PCI_DEVICE_ID_CT) {
-		if (bfi_image_ct_size == 0)
-			bfad_read_firmware(pdev, &bfi_image_ct,
-				&bfi_image_ct_size, BFAD_FW_FILE_CT);
-		return bfi_image_ct;
+	if (pdev->device == BFA_PCI_DEVICE_ID_CT_FC) {
+		if (bfi_image_ct_fc_size == 0)
+			bfad_read_firmware(pdev, &bfi_image_ct_fc,
+				&bfi_image_ct_fc_size, BFAD_FW_FILE_CT_FC);
+		return bfi_image_ct_fc;
+	} else if (pdev->device == BFA_PCI_DEVICE_ID_CT) {
+		if (bfi_image_ct_cna_size == 0)
+			bfad_read_firmware(pdev, &bfi_image_ct_cna,
+				&bfi_image_ct_cna_size, BFAD_FW_FILE_CT_CNA);
+		return bfi_image_ct_cna;
 	} else {
-		if (bfi_image_cb_size == 0)
-			bfad_read_firmware(pdev, &bfi_image_cb,
-				&bfi_image_cb_size, BFAD_FW_FILE_CB);
-		return bfi_image_cb;
+		if (bfi_image_cb_fc_size == 0)
+			bfad_read_firmware(pdev, &bfi_image_cb_fc,
+				&bfi_image_cb_fc_size, BFAD_FW_FILE_CB_FC);
+		return bfi_image_cb_fc;
 	}
 }
 
 u32 *
-bfi_image_ct_get_chunk(u32 off)
-{ return (u32 *)(bfi_image_ct + off); }
+bfi_image_ct_fc_get_chunk(u32 off)
+{ return (u32 *)(bfi_image_ct_fc + off); }
 
 u32 *
-bfi_image_cb_get_chunk(u32 off)
-{ return (u32 *)(bfi_image_cb + off); }
+bfi_image_ct_cna_get_chunk(u32 off)
+{ return (u32 *)(bfi_image_ct_cna + off); }
 
+u32 *
+bfi_image_cb_fc_get_chunk(u32 off)
+{ return (u32 *)(bfi_image_cb_fc + off); }
+
+uint32_t *
+bfi_image_get_chunk(int type, uint32_t off)
+{
+	switch (type) {
+	case BFI_IMAGE_CT_FC: return bfi_image_ct_fc_get_chunk(off); break;
+	case BFI_IMAGE_CT_CNA: return bfi_image_ct_cna_get_chunk(off); break;
+	case BFI_IMAGE_CB_FC: return bfi_image_cb_fc_get_chunk(off); break;
+	default: return 0; break;
+	}
+}
+
+uint32_t
+bfi_image_get_size(int type)
+{
+	switch (type) {
+	case BFI_IMAGE_CT_FC: return bfi_image_ct_fc_size; break;
+	case BFI_IMAGE_CT_CNA: return bfi_image_ct_cna_size; break;
+	case BFI_IMAGE_CB_FC: return bfi_image_cb_fc_size; break;
+	default: return 0; break;
+	}
+}
diff --git a/drivers/scsi/bfa/bfad_im_compat.h b/drivers/scsi/bfa/bfad_im_compat.h
index b36be15..0a122ab 100644
--- a/drivers/scsi/bfa/bfad_im_compat.h
+++ b/drivers/scsi/bfa/bfad_im_compat.h
@@ -18,9 +18,6 @@
 #ifndef __BFAD_IM_COMPAT_H__
 #define __BFAD_IM_COMPAT_H__
 
-extern u32 *bfi_image_buf;
-extern u32 bfi_image_size;
-
 extern struct device_attribute *bfad_im_host_attrs[];
 extern struct device_attribute *bfad_im_vport_attrs[];
 
@@ -37,10 +34,12 @@ bfad_load_fwimg(struct pci_dev *pdev)
 static inline void
 bfad_free_fwimg(void)
 {
-	if (bfi_image_ct_size && bfi_image_ct)
-		vfree(bfi_image_ct);
-	if (bfi_image_cb_size && bfi_image_cb)
-		vfree(bfi_image_cb);
+	if (bfi_image_ct_fc_size && bfi_image_ct_fc)
+		vfree(bfi_image_ct_fc);
+	if (bfi_image_ct_cna_size && bfi_image_ct_cna)
+		vfree(bfi_image_ct_cna);
+	if (bfi_image_cb_fc_size && bfi_image_cb_fc)
+		vfree(bfi_image_cb_fc);
 }
 
 #endif
diff --git a/drivers/scsi/bfa/bfad_intr.c b/drivers/scsi/bfa/bfad_intr.c
index 2b7dbec..fed27d1 100644
--- a/drivers/scsi/bfa/bfad_intr.c
+++ b/drivers/scsi/bfa/bfad_intr.c
@@ -151,8 +151,8 @@ bfad_setup_intr(struct bfad_s *bfad)
 	/* Set up the msix entry table */
 	bfad_init_msix_entry(bfad, msix_entries, mask, max_bit);
 
-	if ((pdev->device == BFA_PCI_DEVICE_ID_CT && !msix_disable_ct) ||
-	    (pdev->device != BFA_PCI_DEVICE_ID_CT && !msix_disable_cb)) {
+	if ((bfa_asic_id_ct(pdev->device) && !msix_disable_ct) ||
+		(!bfa_asic_id_ct(pdev->device) && !msix_disable_cb)) {
 
 		error = pci_enable_msix(bfad->pcidev, msix_entries, bfad->nvec);
 		if (error) {
diff --git a/drivers/scsi/bfa/include/bfi/bfi_ioc.h b/drivers/scsi/bfa/include/bfi/bfi_ioc.h
index a0158aa..03a9c94 100644
--- a/drivers/scsi/bfa/include/bfi/bfi_ioc.h
+++ b/drivers/scsi/bfa/include/bfi/bfi_ioc.h
@@ -63,6 +63,7 @@ struct bfi_ioc_attr_s {
 	char            fw_version[BFA_VERSION_LEN];
 	char            optrom_version[BFA_VERSION_LEN];
 	struct bfa_mfg_vpd_s	vpd;
+	uint32_t        card_type;	/* card type */
 };
 
 /**
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h b/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h
index c5bd9c3..bfb50eb 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h
@@ -86,6 +86,9 @@ enum {
 	BFA_MFG_TYPE_FC4P1   = 415,      /*  4G 1port FC card		*/
 	BFA_MFG_TYPE_CNA10P2 = 1020,     /*  10G 2port CNA card	*/
 	BFA_MFG_TYPE_CNA10P1 = 1010,     /*  10G 1port CNA card	*/
+	BFA_MFG_TYPE_JAYHAWK = 804,      /*  Jayhawk mezz card */
+	BFA_MFG_TYPE_WANCHESE = 1007,    /*  Wanchese mezz card */
+	BFA_MFG_TYPE_INVALID = 0,        /*  Invalid card type */
 };
 
 #pragma pack(1)
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_pci.h b/drivers/scsi/bfa/include/defs/bfa_defs_pci.h
index c9b8332..ea7d89b 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_pci.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_pci.h
@@ -26,8 +26,13 @@ enum {
 	BFA_PCI_DEVICE_ID_FC_8G2P	= 0x13,
 	BFA_PCI_DEVICE_ID_FC_8G1P	= 0x17,
 	BFA_PCI_DEVICE_ID_CT		= 0x14,
+	BFA_PCI_DEVICE_ID_CT_FC         = 0x21,
 };
 
+#define bfa_asic_id_ct(devid)                   \
+	((devid) == BFA_PCI_DEVICE_ID_CT ||     \
+	 (devid) == BFA_PCI_DEVICE_ID_CT_FC)
+
 /**
  * PCI sub-system device and vendor ID information
  */
@@ -35,7 +40,9 @@ enum {
 	BFA_PCI_FCOE_SSDEVICE_ID	= 0x14,
 };
 
-#define BFA_PCI_ACCESS_RANGES 1	/* Maximum number of device address ranges
-				 * mapped through different BAR(s). */
+/**
+ * Maximum number of device address ranges mapped through different BAR(s)
+ */
+#define BFA_PCI_ACCESS_RANGES 1
 
 #endif /* __BFA_DEFS_PCI_H__ */
-- 
1.6.5.2


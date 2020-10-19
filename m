Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 874A7C433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 12:18:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EBE422268
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 12:18:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgJSMSB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 08:18:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:49274 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726588AbgJSMSA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Oct 2020 08:18:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EFBA7B1A3;
        Mon, 19 Oct 2020 12:17:57 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/4] bfa: remove bfa_pcidev_s
Date:   Mon, 19 Oct 2020 14:17:55 +0200
Message-Id: <20201019121756.74644-4-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20201019121756.74644-1-hare@suse.de>
References: <20201019121756.74644-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace the internal PCI abstraction in struct bfa_pcidev_s by
using the generic struct pci_dev.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/bfa/bfa.h        |  5 ++---
 drivers/scsi/bfa/bfa_core.c   | 27 ++++++++++-----------------
 drivers/scsi/bfa/bfa_ioc.c    | 15 +++++++--------
 drivers/scsi/bfa/bfa_ioc.h    | 22 +++++-----------------
 drivers/scsi/bfa/bfa_ioc_ct.c |  8 ++++----
 drivers/scsi/bfa/bfa_svc.c    |  8 ++++----
 drivers/scsi/bfa/bfad.c       | 13 +++----------
 drivers/scsi/bfa/bfad_drv.h   |  1 -
 8 files changed, 35 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/bfa/bfa.h b/drivers/scsi/bfa/bfa.h
index 901e77b9c650..e77c42f35a10 100644
--- a/drivers/scsi/bfa/bfa.h
+++ b/drivers/scsi/bfa/bfa.h
@@ -17,6 +17,7 @@
 #include "bfi.h"
 #include "bfa_ioc.h"
 
+struct bfad_s;
 struct bfa_s;
 
 typedef void (*bfa_isr_func_t) (struct bfa_s *bfa, struct bfi_msg_s *m);
@@ -393,9 +394,7 @@ void bfa_cfg_get_min(struct bfa_iocfc_cfg_s *cfg);
 void bfa_cfg_get_meminfo(struct bfa_iocfc_cfg_s *cfg,
 			struct bfa_meminfo_s *meminfo,
 			struct bfa_s *bfa);
-void bfa_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
-		struct bfa_meminfo_s *meminfo,
-		struct bfa_pcidev_s *pcidev);
+void bfa_attach(struct bfa_s *bfa, struct bfad_s *bfad);
 void bfa_detach(struct bfa_s *bfa);
 void bfa_cb_init(void *bfad, bfa_status_t status);
 void bfa_cb_updateq(void *bfad, bfa_status_t status);
diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index aa726fc7f7e1..f70377a03434 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -851,7 +851,7 @@ bfa_isr_enable(struct bfa_s *bfa)
 
 	bfa_msix_ctrl_install(bfa);
 
-	if (bfa_asic_id_ct2(bfa->ioc.pcidev.device_id)) {
+	if (bfa_asic_id_ct2(bfa_ioc_devid(&bfa->ioc))) {
 		umsk = __HFN_INT_ERR_MASK_CT2;
 		umsk |= port_id == 0 ?
 			__HFN_INT_FN0_MASK_CT2 : __HFN_INT_FN1_MASK_CT2;
@@ -910,14 +910,14 @@ bfa_msix_lpu_err(struct bfa_s *bfa, int vec)
 
 	intr = readl(bfa->iocfc.bfa_regs.intr_status);
 
-	if (bfa_asic_id_ct2(bfa->ioc.pcidev.device_id)) {
+	if (bfa_asic_id_ct2(bfa_ioc_devid(&bfa->ioc))) {
 		halt_isr = intr & __HFN_INT_CPQ_HALT_CT2;
 		pss_isr  = intr & __HFN_INT_ERR_PSS_CT2;
 		lpu_isr  = intr & (__HFN_INT_MBOX_LPU0_CT2 |
 				   __HFN_INT_MBOX_LPU1_CT2);
 		intr    &= __HFN_INT_ERR_MASK_CT2;
 	} else {
-		halt_isr = bfa_asic_id_ct(bfa->ioc.pcidev.device_id) ?
+		halt_isr = bfa_asic_id_ct(bfa_ioc_devid(&bfa->ioc)) ?
 					  (intr & __HFN_INT_LL_HALT) : 0;
 		pss_isr  = intr & __HFN_INT_ERR_PSS;
 		lpu_isr  = intr & (__HFN_INT_MBOX_LPU0 | __HFN_INT_MBOX_LPU1);
@@ -1033,8 +1033,7 @@ bfa_iocfc_send_cfg(void *bfa_arg)
 }
 
 static void
-bfa_iocfc_init_mem(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg,
-		   struct bfa_pcidev_s *pcidev)
+bfa_iocfc_init_mem(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg)
 {
 	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
 
@@ -1514,7 +1513,7 @@ bfa_iocfc_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *meminfo,
  */
 static void
 bfa_iocfc_attach(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg,
-		 struct bfa_pcidev_s *pcidev)
+		 struct pci_dev *pcidev)
 {
 	int		i;
 	struct bfa_ioc_s *ioc = &bfa->ioc;
@@ -1530,7 +1529,7 @@ bfa_iocfc_attach(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg,
 	bfa_ioc_pci_init(&bfa->ioc, pcidev, BFI_PCIFN_CLASS_FC);
 	bfa_ioc_mbox_register(&bfa->ioc, bfa_mbox_isrs);
 
-	bfa_iocfc_init_mem(bfa, cfg, pcidev);
+	bfa_iocfc_init_mem(bfa, cfg);
 	bfa_iocfc_mem_claim(bfa, cfg);
 	INIT_LIST_HEAD(&bfa->timer_mod.timer_q);
 
@@ -1807,13 +1806,6 @@ bfa_cfg_get_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *meminfo,
  *
  * @param[out]	bfa	Pointer to bfa_t.
  * @param[in]	bfad	Opaque handle back to the driver's IOC structure
- * @param[in]	cfg	Pointer to bfa_ioc_cfg_t. Should be same structure
- *			that was used in bfa_cfg_get_meminfo().
- * @param[in]	meminfo	Pointer to bfa_meminfo_t. The driver should
- *			use the bfa_cfg_get_meminfo() call to
- *			find the memory blocks required, allocate the
- *			required memory and provide the starting addresses.
- * @param[in]	pcidev	pointer to struct bfa_pcidev_s
  *
  * @return
  * void
@@ -1824,9 +1816,10 @@ bfa_cfg_get_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *meminfo,
  *
  */
 void
-bfa_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
-	       struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
+bfa_attach(struct bfa_s *bfa, struct bfad_s *bfad)
 {
+	struct bfa_iocfc_cfg_s *cfg = &bfad->ioc_cfg;
+	struct bfa_meminfo_s *meminfo = &bfad->meminfo;
 	struct bfa_mem_dma_s *dma_info, *dma_elem;
 	struct bfa_mem_kva_s *kva_info, *kva_elem;
 	struct list_head *dm_qe, *km_qe;
@@ -1855,7 +1848,7 @@ bfa_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 		kva_elem->kva_curp = kva_elem->kva;
 	}
 
-	bfa_iocfc_attach(bfa, cfg, pcidev);
+	bfa_iocfc_attach(bfa, cfg, bfad->pcidev);
 	bfa_fcdiag_attach(bfa, cfg);
 	bfa_sgpg_attach(bfa, cfg);
 	bfa_fcport_attach(bfa, cfg);
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index b2ba89c81c65..dc518a4678a9 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -1628,7 +1628,7 @@ bfa_status_t
 bfa_ioc_flash_img_get_chnk(struct bfa_ioc_s *ioc, u32 off,
 				u32 *fwimg)
 {
-	return bfa_flash_raw_read(ioc->pcidev.pci_bar_kva,
+	return bfa_flash_raw_read(bfa_ioc_bar0(ioc),
 			BFA_FLASH_PART_FWIMG_ADDR + (off * sizeof(u32)),
 			(char *)fwimg, BFI_FLASH_CHUNK_SZ);
 }
@@ -2388,11 +2388,10 @@ bfa_ioc_detach(struct bfa_ioc_s *ioc)
  * @param[in]	pcidev	PCI device information for this IOC
  */
 void
-bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct bfa_pcidev_s *pcidev,
+bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct pci_dev *pcidev,
 		enum bfi_pcifn_class clscode)
 {
 	ioc->clscode	= clscode;
-	ioc->pcidev	= *pcidev;
 
 	/*
 	 * Initialize IOC and device personality
@@ -2400,7 +2399,7 @@ bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct bfa_pcidev_s *pcidev,
 	ioc->port0_mode = ioc->port1_mode = BFI_PORT_MODE_FC;
 	ioc->asic_mode  = BFI_ASIC_MODE_FC;
 
-	switch (pcidev->device_id) {
+	switch (pcidev->device) {
 	case BFA_PCI_DEVICE_ID_FC_8G1P:
 	case BFA_PCI_DEVICE_ID_FC_8G2P:
 		ioc->asic_gen = BFI_ASIC_GEN_CB;
@@ -2428,7 +2427,7 @@ bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct bfa_pcidev_s *pcidev,
 	case BFA_PCI_DEVICE_ID_CT2_QUAD:
 		ioc->asic_gen = BFI_ASIC_GEN_CT2;
 		if (clscode == BFI_PCIFN_CLASS_FC &&
-		    pcidev->ssid == BFA_PCI_CT2_SSID_FC) {
+		    pcidev->subsystem_device == BFA_PCI_CT2_SSID_FC) {
 			ioc->asic_mode  = BFI_ASIC_MODE_FC16;
 			ioc->fcmode = BFA_TRUE;
 			ioc->port_mode = ioc->port_mode_cfg = BFA_MODE_HBA;
@@ -2436,7 +2435,7 @@ bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct bfa_pcidev_s *pcidev,
 		} else {
 			ioc->port0_mode = ioc->port1_mode = BFI_PORT_MODE_ETH;
 			ioc->asic_mode  = BFI_ASIC_MODE_ETH;
-			if (pcidev->ssid == BFA_PCI_CT2_SSID_FCoE) {
+			if (pcidev->subsystem_device == BFA_PCI_CT2_SSID_FCoE) {
 				ioc->port_mode =
 				ioc->port_mode_cfg = BFA_MODE_CNA;
 				ioc->ad_cap_bm = BFA_CM_CNA;
@@ -2664,7 +2663,7 @@ bfa_ioc_adapter_is_disabled(struct bfa_ioc_s *ioc)
 	if (!bfa_ioc_state_disabled(ioc_state))
 		return BFA_FALSE;
 
-	if (ioc->pcidev.device_id != BFA_PCI_DEVICE_ID_FC_8G1P) {
+	if (bfa_ioc_devid(ioc) != BFA_PCI_DEVICE_ID_FC_8G1P) {
 		ioc_state = bfa_ioc_get_cur_ioc_fwstate(ioc);
 		if (!bfa_ioc_state_disabled(ioc_state))
 			return BFA_FALSE;
@@ -2802,7 +2801,7 @@ bfa_ioc_get_adapter_model(struct bfa_ioc_s *ioc, char *model)
 
 	ioc_attr = ioc->attr;
 
-	if (bfa_asic_id_ct2(ioc->pcidev.device_id) &&
+	if (bfa_asic_id_ct2(bfa_ioc_devid(ioc)) &&
 		(!bfa_mfg_is_mezz(ioc_attr->card_type)))
 		snprintf(model, BFA_ADAPTER_MODEL_NAME_LEN, "%s-%u-%u%s",
 			BFA_MFG_NAME, ioc_attr->card_type, nports, "p");
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 402f7b6a3df4..9419aae67092 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -143,17 +143,6 @@ static inline void bfa_mem_kva_setup(struct bfa_meminfo_s *meminfo,
 	((_mod)->dma_seg[BFI_MEM_SEG_FROM_TAG(_tag, _rqsz)].dma_curp +	\
 	 BFI_MEM_SEG_REQ_OFFSET(_tag, _rqsz) * (_rqsz))
 
-/*
- * PCI device information required by IOC
- */
-struct bfa_pcidev_s {
-	int		pci_slot;
-	u8		pci_func;
-	u16		device_id;
-	u16		ssid;
-	void __iomem	*pci_bar_kva;
-};
-
 /*
  * Structure used to remember the DMA-able memory block's KVA and Physical
  * Address
@@ -293,7 +282,6 @@ struct bfa_iocpf_s {
 struct bfa_ioc_s {
 	bfa_fsm_t		fsm;
 	struct bfa_s		*bfa;
-	struct bfa_pcidev_s	pcidev;
 	struct bfa_timer_mod_s	*timer_mod;
 	struct bfa_timer_s	ioc_timer;
 	struct bfa_timer_s	sem_timer;
@@ -803,9 +791,9 @@ bfa_status_t	bfa_dconf_update(struct bfa_s *bfa);
 /*
  *	IOC specfic macros
  */
-#define bfa_ioc_pcifn(__ioc)		((__ioc)->pcidev.pci_func)
-#define bfa_ioc_devid(__ioc)		((__ioc)->pcidev.device_id)
-#define bfa_ioc_bar0(__ioc)		((__ioc)->pcidev.pci_bar_kva)
+#define bfa_ioc_pcifn(__ioc)		(PCI_FUNC((__ioc)->bfa->bfad->pcidev->devfn))
+#define bfa_ioc_devid(__ioc)		((__ioc)->bfa->bfad->pcidev->device)
+#define bfa_ioc_bar0(__ioc)		((__ioc)->bfa->bfad->pci_bar0_kva)
 #define bfa_ioc_portid(__ioc)		((__ioc)->port_id)
 #define bfa_ioc_asic_gen(__ioc)		((__ioc)->asic_gen)
 #define bfa_ioc_is_cna(__ioc)	\
@@ -849,7 +837,7 @@ void bfa_ioc_mbox_regisr(struct bfa_ioc_s *ioc, enum bfi_mclass mc,
  */
 
 #define bfa_ioc_pll_init_asic(__ioc) \
-	((__ioc)->ioc_hwif->ioc_pll_init((__ioc)->pcidev.pci_bar_kva, \
+	((__ioc)->ioc_hwif->ioc_pll_init(bfa_ioc_bar0(__ioc), \
 			   (__ioc)->asic_mode))
 
 bfa_status_t bfa_ioc_pll_init(struct bfa_ioc_s *ioc);
@@ -879,7 +867,7 @@ void bfa_ioc_attach(struct bfa_ioc_s *ioc, void *bfa,
 void bfa_ioc_auto_recover(bfa_boolean_t auto_recover);
 void bfa_ioc_detach(struct bfa_ioc_s *ioc);
 void bfa_ioc_suspend(struct bfa_ioc_s *ioc);
-void bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct bfa_pcidev_s *pcidev,
+void bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct pci_dev *pcidev,
 		enum bfi_pcifn_class clscode);
 void bfa_ioc_mem_claim(struct bfa_ioc_s *ioc,  u8 *dm_kva, u64 dm_pa);
 void bfa_ioc_enable(struct bfa_ioc_s *ioc);
diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index fb748291676b..699452d5b45a 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -304,7 +304,7 @@ bfa_ioc_ct2_reg_init(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_ct_map_port(struct bfa_ioc_s *ioc)
 {
-	void __iomem *rb = ioc->pcidev.pci_bar_kva;
+	void __iomem *rb = bfa_ioc_bar0(ioc);
 	u32	r32;
 
 	/*
@@ -321,7 +321,7 @@ bfa_ioc_ct_map_port(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_ct2_map_port(struct bfa_ioc_s *ioc)
 {
-	void __iomem	*rb = ioc->pcidev.pci_bar_kva;
+	void __iomem	*rb = bfa_ioc_bar0(ioc);
 	u32	r32;
 
 	r32 = readl(rb + CT2_HOSTFN_PERSONALITY0);
@@ -337,7 +337,7 @@ bfa_ioc_ct2_map_port(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_ct_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix)
 {
-	void __iomem *rb = ioc->pcidev.pci_bar_kva;
+	void __iomem *rb = bfa_ioc_bar0(ioc);
 	u32	r32, mode;
 
 	r32 = readl(rb + FNC_PERS_REG);
@@ -561,7 +561,7 @@ bfa_ioc_set_ct2_hwif(struct bfa_ioc_s *ioc)
 void
 bfa_ioc_ct2_poweron(struct bfa_ioc_s *ioc)
 {
-	void __iomem *rb = ioc->pcidev.pci_bar_kva;
+	void __iomem *rb = bfa_ioc_bar0(ioc);
 	u32	r32;
 
 	r32 = readl(rb + HOSTFN_MSIX_VT_OFST_NUMVT);
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index c47c7e45b733..c40bffa42ca1 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -3747,7 +3747,7 @@ bfa_fcport_cfg_speed(struct bfa_s *bfa, enum bfa_port_speed speed)
 	if (bfa_ioc_get_type(&fcport->bfa->ioc) == BFA_IOC_TYPE_FC) {
 		/* For CT2, 1G is not supported */
 		if ((speed == BFA_PORT_SPEED_1GBPS) &&
-		    (bfa_asic_id_ct2(bfa->ioc.pcidev.device_id)))
+		    (bfa_asic_id_ct2(bfa_ioc_devid(&bfa->ioc))))
 			return BFA_STATUS_UNSUPP_SPEED;
 
 		/* Already checked for Auto Speed and Max Speed supp */
@@ -5983,7 +5983,7 @@ bfa_fcdiag_loopback(struct bfa_s *bfa, enum bfa_port_opmode opmode,
 	 * For CT2, 1G is not supported
 	 */
 	if ((speed == BFA_PORT_SPEED_1GBPS) &&
-	    (bfa_asic_id_ct2(bfa->ioc.pcidev.device_id))) {
+	    (bfa_asic_id_ct2(bfa_ioc_devid(&bfa->ioc)))) {
 		bfa_trc(fcdiag, speed);
 		return BFA_STATUS_UNSUPP_SPEED;
 	}
@@ -6644,8 +6644,8 @@ bfa_dport_enable(struct bfa_s *bfa, u32 lpcnt, u32 pat,
 	/*
 	 * Dport is supported in CT2 or above
 	 */
-	if (!(bfa_asic_id_ct2(dport->bfa->ioc.pcidev.device_id))) {
-		bfa_trc(dport->bfa, dport->bfa->ioc.pcidev.device_id);
+	if (!(bfa_asic_id_ct2(bfa_ioc_devid(&dport->bfa->ioc)))) {
+		bfa_trc(dport->bfa, bfa_ioc_devid(&dport->bfa->ioc));
 		return BFA_STATUS_FEATURE_NOT_SUPPORTED;
 	}
 
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index f350f3154e52..0e2b81d74692 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -748,11 +748,6 @@ bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
 		goto out_release_region;
 	}
 
-	bfad->hal_pcidev.pci_slot = PCI_SLOT(pdev->devfn);
-	bfad->hal_pcidev.pci_func = PCI_FUNC(pdev->devfn);
-	bfad->hal_pcidev.pci_bar_kva = bfad->pci_bar0_kva;
-	bfad->hal_pcidev.device_id = pdev->device;
-	bfad->hal_pcidev.ssid = pdev->subsystem_device;
 	bfad->pci_name = pci_name(pdev);
 
 	bfad->pci_attr.vendor_id = pdev->vendor;
@@ -828,8 +823,7 @@ bfad_drv_init(struct bfad_s *bfad)
 	bfa_plog_str(&bfad->plog_buf, BFA_PL_MID_DRVR, BFA_PL_EID_DRIVER_START,
 		     0, "Driver Attach");
 
-	bfa_attach(&bfad->bfa, bfad, &bfad->ioc_cfg, &bfad->meminfo,
-		   &bfad->hal_pcidev);
+	bfa_attach(&bfad->bfa, bfad);
 
 	/* FCS INIT */
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
@@ -1163,7 +1157,7 @@ bfad_install_msix_handler(struct bfad_s *bfad)
 	for (i = 0; i < bfad->nvec; i++) {
 		sprintf(bfad->msix_tab[i].name, "bfa-%s-%s",
 				bfad->pci_name,
-				((bfa_asic_id_cb(bfad->hal_pcidev.device_id)) ?
+				((bfa_asic_id_cb(bfad->pcidev->device)) ?
 				msix_name_cb[i] : msix_name_ct[i]));
 
 		error = request_irq(bfad->msix_tab[i].msix.vector,
@@ -1484,8 +1478,7 @@ static int restart_bfa(struct bfad_s *bfad)
 	unsigned long flags;
 	struct pci_dev *pdev = bfad->pcidev;
 
-	bfa_attach(&bfad->bfa, bfad, &bfad->ioc_cfg,
-		   &bfad->meminfo, &bfad->hal_pcidev);
+	bfa_attach(&bfad->bfa, bfad);
 
 	/* Enable Interrupt and wait bfa_init completion */
 	if (bfad_setup_intr(bfad)) {
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 619a7e47553b..708f83f2632e 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -186,7 +186,6 @@ struct bfad_s {
 	struct bfa_fcs_s bfa_fcs;
 	struct pci_dev *pcidev;
 	const char *pci_name;
-	struct bfa_pcidev_s hal_pcidev;
 	struct bfa_ioc_pci_attr_s pci_attr;
 	void __iomem   *pci_bar0_kva;
 	void __iomem   *pci_bar2_kva;
-- 
2.16.4


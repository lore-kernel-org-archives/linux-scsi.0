From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v2 3/3] cxlflash: Virtual LUN support
Date: Thu, 16 Jul 2015 18:26:57 -0500
Message-ID: <1437089217-52200-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:51170 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbbGPX12 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2015 19:27:28 -0400
Received: from /spool/local
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 16 Jul 2015 19:27:27 -0400
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 023F338C8046
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2015 19:27:25 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t6GNROR965929386
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2015 23:27:24 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t6GNRNZV009084
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2015 19:27:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com
Cc: hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Add support for physical LUN segmentation (virtual LUNs) to device
driver supporting the IBM CXL Flash adapter. This patch allows user
space applications to virtually segment a physical LUN into N virtual
LUNs, taking advantage of the translation features provided by this
adapter.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/Makefile     |    2 +-
 drivers/scsi/cxlflash/common.h     |    3 +
 drivers/scsi/cxlflash/main.c       |   12 +
 drivers/scsi/cxlflash/sislite.h    |    3 +
 drivers/scsi/cxlflash/superpipe.c  |   56 ++
 drivers/scsi/cxlflash/superpipe.h  |   50 +-
 drivers/scsi/cxlflash/vlun.c       | 1187 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/vlun.h       |   68 +++
 include/uapi/scsi/cxlflash_ioctl.h |   29 +
 9 files changed, 1408 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/cxlflash/vlun.c
 create mode 100644 drivers/scsi/cxlflash/vlun.h

diff --git a/drivers/scsi/cxlflash/Makefile b/drivers/scsi/cxlflash/Makefile
index 3de309c..fac300b 100644
--- a/drivers/scsi/cxlflash/Makefile
+++ b/drivers/scsi/cxlflash/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_CXLFLASH) += cxlflash.o
-cxlflash-y += main.o superpipe.o
+cxlflash-y += main.o superpipe.o vlun.o
diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 3b16857..12bfbac 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -114,6 +114,9 @@ struct cxlflash_cfg {
 
 	atomic_t num_user_contexts;
 
+	/* Parameters that are LUN table related */
+	int last_lun_index[CXLFLASH_NUM_FC_PORTS];
+	int promote_lun_index;
 	struct list_head lluns; /* list of llun_info structs */
 	spinlock_t slock;
 
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index b87964b..1ac9a0f 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -848,6 +848,8 @@ static void cxlflash_remove(struct pci_dev *pdev)
 						    !cfg->tmf_active);
 	spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
 
+	cxlflash_stop_term_user_contexts(cfg);
+
 	switch (cfg->init_state) {
 	case INIT_STATE_SCSI:
 		cxlflash_term_luns(cfg);
@@ -2241,6 +2243,16 @@ static int cxlflash_probe(struct pci_dev *pdev,
 
 	cfg->init_state = INIT_STATE_NONE;
 	cfg->dev = pdev;
+
+	/* The promoted LUNs move to the top of the LUN table. The rest stay
+	 * on the bottom half. The bottom half grows from the end
+	 * (index = 255), whereas the top half grows from the beginning
+	 * (index = 0).
+	 */
+	cfg->promote_lun_index  = 0;
+	cfg->last_lun_index[0] = CXLFLASH_NUM_VLUNS/2 - 1;
+	cfg->last_lun_index[1] = CXLFLASH_NUM_VLUNS/2 - 1;
+
 	cfg->dev_id = (struct pci_device_id *)dev_id;
 	cfg->eeh_active = EEH_STATE_NONE;
 
diff --git a/drivers/scsi/cxlflash/sislite.h b/drivers/scsi/cxlflash/sislite.h
index bf5d399..e599e7f 100644
--- a/drivers/scsi/cxlflash/sislite.h
+++ b/drivers/scsi/cxlflash/sislite.h
@@ -462,4 +462,7 @@ struct sisl_rht_entry_f1 {
 #define TMF_LUN_RESET  0x1U
 #define TMF_CLEAR_ACA  0x2U
 
+
+#define SISLITE_MAX_WS_BLOCKS 512
+
 #endif /* _SISLITE_H */
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 631cc6b..97affc5 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -26,11 +26,25 @@
 
 #include "sislite.h"
 #include "common.h"
+#include "vlun.h"
 #include "superpipe.h"
 
 static struct cxlflash_global global;
 
 /**
+ * marshal_rele_to_resize() - translate release to resize structure
+ * @rele:	Source structure from which to translate/copy.
+ * @resize:	Destination structure for the translate/copy.
+ */
+static void marshal_rele_to_resize(struct dk_cxlflash_release *release,
+				   struct dk_cxlflash_resize *resize)
+{
+	resize->hdr = release->hdr;
+	resize->context_id = release->context_id;
+	resize->rsrc_handle = release->rsrc_handle;
+}
+
+/**
  * marshal_det_to_rele() - translate detach to release structure
  * @detach:	Destination structure for the translate/copy.
  * @rele:	Source structure from which to translate/copy.
@@ -237,6 +251,7 @@ void cxlflash_list_terminate(void)
 	spin_lock_irqsave(&global.slock, flags);
 	list_for_each_entry_safe(gli, temp, &global.gluns, list) {
 		list_del(&gli->list);
+		cxlflash_ba_terminate(&gli->blka.ba_lun);
 		kfree(gli);
 	}
 
@@ -649,6 +664,9 @@ void cxlflash_lun_detach(struct glun_info *gli)
  * @ctxi:	Context owning resources.
  * @release:	Release ioctl data structure.
  *
+ * For LUN's in virtual mode, the virtual lun associated with the specified
+ * resource handle is resized to 0 prior to releasing the RHTE.
+ *
  * Return: 0 on success, -errno on failure
  */
 int _cxlflash_disk_release(struct scsi_device *sdev,
@@ -661,6 +679,7 @@ int _cxlflash_disk_release(struct scsi_device *sdev,
 	struct afu *afu = cfg->afu;
 	bool unlock_ctx = false;
 
+	struct dk_cxlflash_resize size;
 	res_hndl_t rhndl = release->rsrc_handle;
 
 	int rc = 0;
@@ -691,7 +710,24 @@ int _cxlflash_disk_release(struct scsi_device *sdev,
 		goto out;
 	}
 
+	/*
+	 * Resize to 0 for virtual LUNS by setting the size
+	 * to 0. This will clear LXT_START and LXT_CNT fields
+	 * in the RHT entry and properly sync with the AFU.
+	 *
+	 * Afterwards we clear the remaining fields.
+	 */
 	switch (gli->mode) {
+	case MODE_VIRTUAL:
+		marshal_rele_to_resize(release, &size);
+		size.req_size = 0;
+		rc = _cxlflash_vlun_resize(sdev, ctxi, &size);
+		if (rc) {
+			pr_err("%s: resize failed rc %d\n", __func__, rc);
+			goto out;
+		}
+
+		break;
 	case MODE_PHYSICAL:
 		/*
 		 * Clear the Format 1 RHT entry for direct access
@@ -1800,6 +1836,11 @@ static int cxlflash_disk_verify(struct scsi_device *sdev,
 	case MODE_PHYSICAL:
 		last_lba = gli->max_lba;
 		break;
+	case MODE_VIRTUAL:
+		last_lba = (rhte->lxt_cnt * MC_CHUNK_SIZE * gli->blk_len);
+		last_lba /= CXLFLASH_BLOCK_SIZE;
+		last_lba--;
+		break;
 	default:
 		BUG();
 	}
@@ -1827,12 +1868,18 @@ static char *decode_ioctl(int cmd)
 		return __stringify_1(DK_CXLFLASH_ATTACH);
 	case DK_CXLFLASH_USER_DIRECT:
 		return __stringify_1(DK_CXLFLASH_USER_DIRECT);
+	case DK_CXLFLASH_USER_VIRTUAL:
+		return __stringify_1(DK_CXLFLASH_USER_VIRTUAL);
+	case DK_CXLFLASH_VLUN_RESIZE:
+		return __stringify_1(DK_CXLFLASH_VLUN_RESIZE);
 	case DK_CXLFLASH_RELEASE:
 		return __stringify_1(DK_CXLFLASH_RELEASE);
 	case DK_CXLFLASH_DETACH:
 		return __stringify_1(DK_CXLFLASH_DETACH);
 	case DK_CXLFLASH_VERIFY:
 		return __stringify_1(DK_CXLFLASH_VERIFY);
+	case DK_CXLFLASH_CLONE:
+		return __stringify_1(DK_CXLFLASH_CLONE);
 	case DK_CXLFLASH_RECOVER_AFU:
 		return __stringify_1(DK_CXLFLASH_RECOVER_AFU);
 	case DK_CXLFLASH_MANAGE_LUN:
@@ -1985,9 +2032,12 @@ int cxlflash_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 	} ioctl_tbl[] = {	/* NOTE: order matters here */
 	{sizeof(struct dk_cxlflash_attach), (sioctl)cxlflash_disk_attach},
 	{sizeof(struct dk_cxlflash_udirect), cxlflash_disk_direct_open},
+	{sizeof(struct dk_cxlflash_uvirtual), cxlflash_disk_virtual_open},
+	{sizeof(struct dk_cxlflash_resize), (sioctl)cxlflash_vlun_resize},
 	{sizeof(struct dk_cxlflash_release), (sioctl)cxlflash_disk_release},
 	{sizeof(struct dk_cxlflash_detach), (sioctl)cxlflash_disk_detach},
 	{sizeof(struct dk_cxlflash_verify), (sioctl)cxlflash_disk_verify},
+	{sizeof(struct dk_cxlflash_clone), (sioctl)cxlflash_disk_clone},
 	{sizeof(struct dk_cxlflash_recover_afu), (sioctl)cxlflash_afu_recover},
 	{sizeof(struct dk_cxlflash_manage_lun), (sioctl)cxlflash_manage_lun},
 	};
@@ -1995,7 +2045,10 @@ int cxlflash_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 	/* Restrict command set to physical support only for internal LUN */
 	if (afu->internal_lun)
 		switch (cmd) {
+		case DK_CXLFLASH_USER_VIRTUAL:
+		case DK_CXLFLASH_VLUN_RESIZE:
 		case DK_CXLFLASH_RELEASE:
+		case DK_CXLFLASH_CLONE:
 			pr_err("%s: %s not supported for lun_mode=%d\n",
 			       __func__, decode_ioctl(cmd), afu->internal_lun);
 			rc = -EINVAL;
@@ -2005,9 +2058,12 @@ int cxlflash_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 	switch (cmd) {
 	case DK_CXLFLASH_ATTACH:
 	case DK_CXLFLASH_USER_DIRECT:
+	case DK_CXLFLASH_USER_VIRTUAL:
+	case DK_CXLFLASH_VLUN_RESIZE:
 	case DK_CXLFLASH_RELEASE:
 	case DK_CXLFLASH_DETACH:
 	case DK_CXLFLASH_VERIFY:
+	case DK_CXLFLASH_CLONE:
 	case DK_CXLFLASH_RECOVER_AFU:
 		pr_debug("%s: %s (%08X) on dev(%d/%d/%d/%llu)\n", __func__,
 			 decode_ioctl(cmd), cmd, shost->host_no, sdev->channel,
diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
index 6166527..0f9537c 100644
--- a/drivers/scsi/cxlflash/superpipe.h
+++ b/drivers/scsi/cxlflash/superpipe.h
@@ -15,6 +15,41 @@
 #ifndef _CXLFLASH_SUPERPIPE_H
 #define _CXLFLASH_SUPERPIPE_H
 
+/*----------------------------------------------------------------------------*/
+/* Types                                                                      */
+/*----------------------------------------------------------------------------*/
+
+#define MAX_AUN_CLONE_CNT    0xFF
+
+/*
+ * Terminology: use afu (and not adapter) to refer to the HW.
+ * Adapter is the entire slot and includes PSL out of which
+ * only the AFU is visible to user space.
+ */
+
+/* Chunk size parms: note sislite minimum chunk size is
+   0x10000 LBAs corresponding to a NMASK or 16.
+*/
+#define MC_RHT_NMASK      16	/* in bits */
+#define MC_CHUNK_SIZE     (1 << MC_RHT_NMASK)	/* in LBAs, see mclient.h */
+#define MC_CHUNK_SHIFT    MC_RHT_NMASK	/* shift to go from LBA to chunk# */
+#define LXT_LUNIDX_SHIFT  8	/* LXT entry, shift for LUN index */
+#define LXT_PERM_SHIFT    4	/* LXT entry, shift for permission bits */
+
+/* LXT tables are allocated dynamically in groups. This is done to
+   avoid a malloc/free overhead each time the LXT has to grow
+   or shrink.
+
+   Based on the current lxt_cnt (used), it is always possible to
+   know how many are allocated (used+free). The number of allocated
+   entries is not stored anywhere.
+
+   The LXT table is re-allocated whenever it needs to cross into
+   another group.
+*/
+#define LXT_GROUP_SIZE          8
+#define LXT_NUM_GROUPS(lxt_cnt) (((lxt_cnt) + 7)/8)	/* alloc'ed groups */
+
 #define MC_DISCOVERY_TIMEOUT 5  /* 5 secs */
 
 #define CHAN2PORT(_x)	((_x) + 1)
@@ -22,6 +57,7 @@
 
 enum lun_mode {
 	MODE_NONE = 0,
+	MODE_VIRTUAL,
 	MODE_PHYSICAL
 };
 
@@ -54,19 +90,21 @@ struct request_sense_data  {
 struct glun_info {
 	u64 max_lba;		/* from read cap(16) */
 	u32 blk_len;		/* from read cap(16) */
-	enum lun_mode mode;	/* NONE, PHYSICAL */
+	enum lun_mode mode;	/* NONE, VIRTUAL, PHYSICAL */
 	int users;		/* Number of users w/ references to LUN */
 
 	u8 wwid[16];
 
 	spinlock_t slock;
 
+	struct blka blka;
 	struct list_head list;
 };
 
 /* Local (per-adapter) lun_info structure */
 struct llun_info {
 	u64 lun_id[CXLFLASH_NUM_FC_PORTS]; /* from REPORT_LUNS */
+	u32 lun_index;		/* Index in the lun table */
 	u32 host_no;		/* host_no from Scsi_host */
 	u32 port_sel;		/* What port to use for this LUN */
 	bool newly_created;	/* Whether the LUN was just discovered */
@@ -124,10 +162,18 @@ struct cxlflash_global {
 };
 
 
+int cxlflash_vlun_resize(struct scsi_device *, struct dk_cxlflash_resize *);
+int _cxlflash_vlun_resize(struct scsi_device *, struct ctx_info *,
+			  struct dk_cxlflash_resize *);
+
 int cxlflash_disk_release(struct scsi_device *, struct dk_cxlflash_release *);
 int _cxlflash_disk_release(struct scsi_device *, struct ctx_info *,
 			   struct dk_cxlflash_release *);
 
+int cxlflash_disk_clone(struct scsi_device *, struct dk_cxlflash_clone *);
+
+int cxlflash_disk_virtual_open(struct scsi_device *, void *);
+
 int cxlflash_lun_attach(struct glun_info *, enum lun_mode);
 void cxlflash_lun_detach(struct glun_info *);
 
@@ -139,4 +185,6 @@ struct sisl_rht_entry *get_rhte(struct ctx_info *, res_hndl_t,
 struct sisl_rht_entry *rhte_checkout(struct ctx_info *, struct llun_info *);
 void rhte_checkin(struct ctx_info *, struct sisl_rht_entry *);
 
+void cxlflash_ba_terminate(struct ba_lun *);
+
 #endif /* ifndef _CXLFLASH_SUPERPIPE_H */
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
new file mode 100644
index 0000000..a3d3e6e
--- /dev/null
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -0,0 +1,1187 @@
+/*
+ * CXL Flash Device Driver
+ *
+ * Written by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>, IBM Corporation
+ *             Matthew R. Ochs <mrochs@linux.vnet.ibm.com>, IBM Corporation
+ *
+ * Copyright (C) 2015 IBM Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/delay.h>
+#include <linux/file.h>
+#include <linux/moduleparam.h>
+#include <linux/syscalls.h>
+#include <misc/cxl.h>
+#include <asm/unaligned.h>
+
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_host.h>
+#include <uapi/scsi/cxlflash_ioctl.h>
+
+#include "sislite.h"
+#include "common.h"
+#include "vlun.h"
+#include "superpipe.h"
+
+/**
+ * marshal_virt_to_resize() - translate uvirtual to resize structure
+ * @virt:	Source structure from which to translate/copy.
+ * @resize:	Destination structure for the translate/copy.
+ */
+static void marshal_virt_to_resize(struct dk_cxlflash_uvirtual *virt,
+				   struct dk_cxlflash_resize *resize)
+{
+	resize->hdr = virt->hdr;
+	resize->context_id = virt->context_id;
+	resize->rsrc_handle = virt->rsrc_handle;
+	resize->req_size = virt->lun_size;
+	resize->last_lba = virt->last_lba;
+}
+
+/**
+ * marshal_clone_to_rele() - translate clone to release structure
+ * @clone:	Source structure from which to translate/copy.
+ * @rele:	Destination structure for the translate/copy.
+ */
+static void marshal_clone_to_rele(struct dk_cxlflash_clone *clone,
+				  struct dk_cxlflash_release *release)
+{
+	release->hdr = clone->hdr;
+	release->context_id = clone->context_id_dst;
+}
+
+/**
+ * ba_init() - initializes a block allocator
+ * @ba_lun:	Block allocator to initialize.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int ba_init(struct ba_lun *ba_lun)
+{
+	struct ba_lun_info *lun_info = NULL;
+	int lun_size_au = 0, i = 0;
+	int last_word_underflow = 0;
+	u64 *lam;
+
+	pr_debug("%s: Initializing LUN: lun_id = %llX, "
+		 "ba_lun->lsize = %lX, ba_lun->au_size = %lX\n",
+		__func__, ba_lun->lun_id, ba_lun->lsize, ba_lun->au_size);
+
+	/* Calculate bit map size */
+	lun_size_au = ba_lun->lsize / ba_lun->au_size;
+	if (lun_size_au == 0) {
+		pr_err("%s: Requested LUN size of 0!\n", __func__);
+		return -EINVAL;
+	}
+
+	/* Allocate lun information container */
+	lun_info = kzalloc(sizeof(struct ba_lun_info), GFP_KERNEL);
+	if (unlikely(!lun_info)) {
+		pr_err("%s: Failed to allocate lun_info for lun_id %llX\n",
+		       __func__, ba_lun->lun_id);
+		return -ENOMEM;
+	}
+
+	lun_info->total_aus = lun_size_au;
+	lun_info->lun_bmap_size = lun_size_au / 64;
+
+	if (lun_size_au % 64)
+		lun_info->lun_bmap_size++;
+
+	/* Allocate bitmap space */
+	lun_info->lun_alloc_map = kzalloc((lun_info->lun_bmap_size *
+					   sizeof(u64)), GFP_KERNEL);
+	if (unlikely(!lun_info->lun_alloc_map)) {
+		pr_err("%s: Failed to allocate lun allocation map: "
+		       "lun_id = %llX\n", __func__, ba_lun->lun_id);
+		kfree(lun_info);
+		return -ENOMEM;
+	}
+
+	/* Initialize the bit map size and set all bits to '1' */
+	lun_info->free_aun_cnt = lun_size_au;
+
+	for (i = 0; i < lun_info->lun_bmap_size; i++)
+		lun_info->lun_alloc_map[i] = 0xFFFFFFFFFFFFFFFFULL;
+
+	/* If the last word not fully utilized, mark extra bits as allocated */
+	last_word_underflow = (lun_info->lun_bmap_size * 64) -
+	    lun_info->free_aun_cnt;
+	if (last_word_underflow > 0) {
+		lam = &lun_info->lun_alloc_map[lun_info->lun_bmap_size - 1];
+		for (i = (63 - last_word_underflow + 1); i < 64; i++)
+			clear_bit(i, (ulong *)lam);
+	}
+
+	/* Initialize high elevator index, low/curr already at 0 from kzalloc */
+	lun_info->free_high_idx = lun_info->lun_bmap_size;
+
+	/* Allocate clone map */
+	lun_info->aun_clone_map = kzalloc((lun_info->total_aus *
+					   sizeof(u8)), GFP_KERNEL);
+	if (unlikely(!lun_info->aun_clone_map)) {
+		pr_err("%s: Failed to allocate clone map: lun_id = %llX\n",
+		       __func__, ba_lun->lun_id);
+		kfree(lun_info->lun_alloc_map);
+		kfree(lun_info);
+		return -ENOMEM;
+	}
+
+	/* Pass the allocated lun info as a handle to the user */
+	ba_lun->ba_lun_handle = (void *)lun_info;
+
+	pr_debug("%s: Successfully initialized the LUN: "
+		 "lun_id = %llX, bitmap size = %X, free_aun_cnt = %llX\n",
+		__func__, ba_lun->lun_id, lun_info->lun_bmap_size,
+		lun_info->free_aun_cnt);
+	return 0;
+}
+
+/**
+ * find_free_range() - locates a free bit within the block allocator
+ * @low:	First word in block allocator to start search.
+ * @high:	Last word in block allocator to search.
+ * @lun_info:	LUN information structure owning the block allocator to search.
+ * @bit_word:	Passes back the word in the block allocator owning the free bit.
+ *
+ * Return: The bit position within the passed back word, -1 on failure
+ */
+static int find_free_range(u32 low,
+			   u32 high,
+			   struct ba_lun_info *lun_info, int *bit_word)
+{
+	int i;
+	u64 bit_pos = -1;
+	ulong *lam, num_bits;
+
+	for (i = low; i < high; i++)
+		if (lun_info->lun_alloc_map[i] != 0) {
+			lam = (ulong *)&lun_info->lun_alloc_map[i];
+			num_bits = (sizeof(*lam) * BITS_PER_BYTE);
+			bit_pos = find_first_bit(lam, num_bits);
+
+			pr_devel("%s: Found free bit %llX in lun "
+				 "map entry %llX at bitmap index = %X\n",
+				 __func__, bit_pos, lun_info->lun_alloc_map[i],
+				 i);
+
+			*bit_word = i;
+			lun_info->free_aun_cnt--;
+			clear_bit(bit_pos, lam);
+			break;
+		}
+
+	return bit_pos;
+}
+
+/**
+ * ba_alloc() - allocates a block from the block allocator
+ * @ba_lun:	Block allocator from which to allocate a block.
+ *
+ * Return: The allocated block, -1 on failure
+ */
+static u64 ba_alloc(struct ba_lun *ba_lun)
+{
+	u64 bit_pos = -1;
+	int bit_word = 0;
+	struct ba_lun_info *lun_info = NULL;
+
+	lun_info = (struct ba_lun_info *)ba_lun->ba_lun_handle;
+
+	pr_debug("%s: Received block allocation request: "
+		 "lun_id = %llX, free_aun_cnt = %llX\n",
+		 __func__, ba_lun->lun_id, lun_info->free_aun_cnt);
+
+	if (lun_info->free_aun_cnt == 0) {
+		pr_err("%s: No space left on LUN: lun_id = %llX\n",
+		       __func__, ba_lun->lun_id);
+		return -1ULL;
+	}
+
+	/* Search to find a free entry, curr->high then low->curr */
+	bit_pos = find_free_range(lun_info->free_curr_idx,
+				  lun_info->free_high_idx, lun_info, &bit_word);
+	if (bit_pos == -1) {
+		bit_pos = find_free_range(lun_info->free_low_idx,
+					  lun_info->free_curr_idx,
+					  lun_info, &bit_word);
+		if (bit_pos == -1) {
+			pr_err("%s: Could not find an allocation unit on LUN: "
+			       "lun_id = %llX\n", __func__, ba_lun->lun_id);
+			return -1ULL;
+		}
+	}
+
+	/* Update the free_curr_idx */
+	if (bit_pos == 63)
+		lun_info->free_curr_idx = bit_word + 1;
+	else
+		lun_info->free_curr_idx = bit_word;
+
+	pr_debug("%s: Allocating AU number %llX, on lun_id %llX, "
+		 "free_aun_cnt = %llX\n", __func__,
+		 ((bit_word * 64) + bit_pos), ba_lun->lun_id,
+		 lun_info->free_aun_cnt);
+
+	return (u64) ((bit_word * 64) + bit_pos);
+}
+
+/**
+ * validate_alloc() - validates the specified block has been allocated
+ * @ba_lun_info:	LUN info owning the block allocator.
+ * @aun:		Block to validate.
+ *
+ * Return: 0 on success, -1 on failure
+ */
+static int validate_alloc(struct ba_lun_info *lun_info, u64 aun)
+{
+	int idx = 0, bit_pos = 0;
+
+	idx = aun / 64;
+	bit_pos = aun % 64;
+
+	if (test_bit(bit_pos, (ulong *)&lun_info->lun_alloc_map[idx]))
+		return -1;
+
+	return 0;
+}
+
+/**
+ * ba_free() - frees a block from the block allocator
+ * @ba_lun:	Block allocator from which to allocate a block.
+ * @to_free:	Block to free.
+ *
+ * Return: 0 on success, -1 on failure
+ */
+static int ba_free(struct ba_lun *ba_lun, u64 to_free)
+{
+	int idx = 0, bit_pos = 0;
+	struct ba_lun_info *lun_info = NULL;
+
+	lun_info = (struct ba_lun_info *)ba_lun->ba_lun_handle;
+
+	if (validate_alloc(lun_info, to_free)) {
+		pr_err("%s: The AUN %llX is not allocated on lun_id %llX\n",
+		       __func__, to_free, ba_lun->lun_id);
+		return -1;
+	}
+
+	pr_debug("%s: Received a request to free AU %llX on lun_id %llX, "
+		 "free_aun_cnt = %llX\n", __func__, to_free, ba_lun->lun_id,
+		 lun_info->free_aun_cnt);
+
+	if (lun_info->aun_clone_map[to_free] > 0) {
+		pr_debug("%s: AUN %llX on lun_id %llX has been cloned. Clone "
+			 "count = %X\n", __func__, to_free, ba_lun->lun_id,
+			 lun_info->aun_clone_map[to_free]);
+		lun_info->aun_clone_map[to_free]--;
+		return 0;
+	}
+
+	idx = to_free / 64;
+	bit_pos = to_free % 64;
+
+	set_bit(bit_pos, (ulong *)&lun_info->lun_alloc_map[idx]);
+	lun_info->free_aun_cnt++;
+
+	if (idx < lun_info->free_low_idx)
+		lun_info->free_low_idx = idx;
+	else if (idx > lun_info->free_high_idx)
+		lun_info->free_high_idx = idx;
+
+	pr_debug("%s: Successfully freed AU at bit_pos %X, bit map index %X on "
+		 "lun_id %llX, free_aun_cnt = %llX\n", __func__, bit_pos, idx,
+		 ba_lun->lun_id, lun_info->free_aun_cnt);
+
+	return 0;
+}
+
+/**
+ * ba_clone() - frees a block from the block allocator
+ * @ba_lun:	Block allocator from which to allocate a block.
+ * @to_free:	Block to free.
+ *
+ * Return: 0 on success, -1 on failure
+ */
+static int ba_clone(struct ba_lun *ba_lun, u64 to_clone)
+{
+	struct ba_lun_info *lun_info =
+	    (struct ba_lun_info *)ba_lun->ba_lun_handle;
+
+	if (validate_alloc(lun_info, to_clone)) {
+		pr_err("%s: AUN %llX is not allocated on lun_id %llX\n",
+		       __func__, to_clone, ba_lun->lun_id);
+		return -1;
+	}
+
+	pr_debug("%s: Received a request to clone AUN %llX on lun_id %llX\n",
+		 __func__, to_clone, ba_lun->lun_id);
+
+	if (lun_info->aun_clone_map[to_clone] == MAX_AUN_CLONE_CNT) {
+		pr_err("%s: AUN %llX on lun_id %llX hit max clones already\n",
+		       __func__, to_clone, ba_lun->lun_id);
+		return -1;
+	}
+
+	lun_info->aun_clone_map[to_clone]++;
+
+	return 0;
+}
+
+/**
+ * ba_space() - returns the amount of free space left in the block allocator
+ * @ba_lun:	Block allocator.
+ *
+ * Return: Amount of free space in block allocator
+ */
+static u64 ba_space(struct ba_lun *ba_lun)
+{
+	struct ba_lun_info *lun_info =
+	    (struct ba_lun_info *)ba_lun->ba_lun_handle;
+
+	return lun_info->free_aun_cnt;
+}
+
+/**
+ * cxlflash_ba_terminate() - frees resources associated with the block allocator
+ * @ba_lun:	Block allocator.
+ *
+ * Safe to call in a partially allocated state.
+ */
+void cxlflash_ba_terminate(struct ba_lun *ba_lun)
+{
+	struct ba_lun_info *lun_info =
+	    (struct ba_lun_info *)ba_lun->ba_lun_handle;
+
+	if (lun_info) {
+		kfree(lun_info->aun_clone_map);
+		kfree(lun_info->lun_alloc_map);
+		kfree(lun_info);
+		ba_lun->ba_lun_handle = NULL;
+	}
+}
+
+/**
+ * init_ba() - initializes and allocates a block allocator
+ * @lun_info:	LUN information structure that owns the block allocator.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int init_ba(struct llun_info *lli)
+{
+	int rc = 0;
+	struct glun_info *gli = lli->parent;
+	struct blka *blka = &gli->blka;
+
+	memset(blka, 0, sizeof(*blka));
+	mutex_init(&blka->mutex);
+
+	/* LUN IDs are unique per port, save the index instead */
+	blka->ba_lun.lun_id = lli->lun_index;
+	blka->ba_lun.lsize = gli->max_lba + 1;
+	blka->ba_lun.lba_size = gli->blk_len;
+
+	blka->ba_lun.au_size = MC_CHUNK_SIZE;
+	blka->nchunk = blka->ba_lun.lsize / MC_CHUNK_SIZE;
+
+	rc = ba_init(&blka->ba_lun);
+	if (rc) {
+		pr_err("%s: cannot init block_alloc, rc=%d\n", __func__, rc);
+		goto init_ba_exit;
+	}
+
+init_ba_exit:
+	pr_debug("%s: returning rc=%d lli=%p\n", __func__, rc, lli);
+	return rc;
+}
+
+/**
+ * write_same16() - sends a SCSI WRITE_SAME16 (0) command to specified LUN
+ * @sdev:	SCSI device associated with LUN.
+ * @lba:	Logical block address to start write same.
+ * @nblks:	Number of logical blocks to write same.
+ *
+ * Return: 0 on success, -1 on failure
+ */
+static int write_same16(struct scsi_device *sdev,
+			u64 lba,
+			u32 nblks)
+{
+	u8 scsi_cmd[MAX_COMMAND_SIZE];
+	u8 *cmd_buf = NULL;
+	u8 *sense_buf = NULL;
+	int rc = 0;
+	int result = 0;
+	int ws_limit = SISLITE_MAX_WS_BLOCKS;
+	u64 offset = lba;
+	int left = nblks;
+
+	memset(scsi_cmd, 0, sizeof(scsi_cmd));
+	cmd_buf = kzalloc(CMD_BUFSIZE, GFP_KERNEL);
+	sense_buf = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_NOIO);
+	if (!cmd_buf || !sense_buf) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	while (left > 0) {
+
+		scsi_cmd[0] = WRITE_SAME_16;
+		put_unaligned_be64(offset, &scsi_cmd[2]);
+		put_unaligned_be32(ws_limit < left ? ws_limit : left,
+				   &scsi_cmd[10]);
+
+		left -= ws_limit;
+		offset += ws_limit;
+
+		result = scsi_execute(sdev, scsi_cmd, DMA_TO_DEVICE, cmd_buf,
+				      CMD_BUFSIZE, sense_buf,
+				      (MC_DISCOVERY_TIMEOUT*HZ), 5, 0, NULL);
+
+		if (result) {
+			pr_err("%s: command failed for offset %lld"
+			      " result=0x%x\n", __func__, offset, result);
+			rc = -EIO;
+			goto out;
+		}
+	}
+
+out:
+	pr_debug("%s: returning rc=%d\n", __func__, rc);
+	return rc;
+}
+
+/**
+ * grow_lxt() - expands the translation table associated with the specified RHTE
+ * @afu:	AFU associated with the host.
+ * @sdev:	SCSI device associated with LUN.
+ * @ctxid:	Context ID of context owning the RHTE.
+ * @rhndl:	Resource handle associated with the RHTE.
+ * @rhte:	Resource handle entry (RHTE).
+ * @new_size:	Number of translation entries associated with RHTE.
+ * @port_sel:	Port selection mask.
+ *
+ * By design, this routine employs a 'best attempt' allocation and will
+ * truncate the requested size down if there is not sufficient space in
+ * the block allocator to satisfy the request but there does exist some
+ * amount of space. The user is made aware of this by returning the size
+ * allocated.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int grow_lxt(struct afu *afu,
+		    struct scsi_device *sdev,
+		    ctx_hndl_t ctxid,
+		    res_hndl_t rhndl,
+		    struct sisl_rht_entry *rhte,
+		    u64 *new_size)
+{
+	struct sisl_lxt_entry *lxt = NULL, *lxt_old = NULL;
+	struct llun_info *lli = sdev->hostdata;
+	struct glun_info *gli = lli->parent;
+	struct blka *blka = &gli->blka;
+	u32 av_size;
+	u32 ngrps, ngrps_old;
+	u64 aun;		/* chunk# allocated by block allocator */
+	u64 delta = *new_size - rhte->lxt_cnt;
+	u64 my_new_size;
+	int i, rc = 0;
+
+	/*
+	 * Check what is available in the block allocator before re-allocating
+	 * LXT array. This is done up front under the mutex which must not be
+	 * released until after allocation is complete.
+	 */
+	mutex_lock(&blka->mutex);
+	av_size = ba_space(&blka->ba_lun);
+	if (unlikely(av_size <= 0)) {
+		pr_err("%s: ba_space error: av_size %d\n", __func__, av_size);
+		mutex_unlock(&blka->mutex);
+		rc = -ENOSPC;
+		goto out;
+	}
+
+	if (av_size < delta)
+		delta = av_size;
+
+	lxt_old = rhte->lxt_start;
+	ngrps_old = LXT_NUM_GROUPS(rhte->lxt_cnt);
+	ngrps = LXT_NUM_GROUPS(rhte->lxt_cnt + delta);
+
+	if (ngrps != ngrps_old) {
+		/* reallocate to fit new size */
+		lxt = kzalloc((sizeof(*lxt) * LXT_GROUP_SIZE * ngrps),
+			      GFP_KERNEL);
+		if (unlikely(!lxt)) {
+			mutex_unlock(&blka->mutex);
+			rc = -ENOMEM;
+			goto out;
+		}
+
+		/* copy over all old entries */
+		memcpy(lxt, lxt_old, (sizeof(*lxt) * rhte->lxt_cnt));
+	} else
+		lxt = lxt_old;
+
+	/* nothing can fail from now on */
+	my_new_size = rhte->lxt_cnt + delta;
+
+	/* add new entries to the end */
+	for (i = rhte->lxt_cnt; i < my_new_size; i++) {
+		/*
+		 * Due to the earlier check of available space, ba_alloc
+		 * cannot fail here. If it did due to internal error,
+		 * leave a rlba_base of -1u which will likely be a
+		 * invalid LUN (too large).
+		 */
+		aun = ba_alloc(&blka->ba_lun);
+		if ((aun == -1ULL) || (aun >= blka->nchunk))
+			pr_err("%s: ba_alloc error: allocated chunk# %llX, "
+			       "max %llX\n", __func__, aun, blka->nchunk - 1);
+
+		/* select both ports, use r/w perms from RHT */
+		lxt[i].rlba_base = ((aun << MC_CHUNK_SHIFT) |
+				    (lli->lun_index << LXT_LUNIDX_SHIFT) |
+				    (RHT_PERM_RW << LXT_PERM_SHIFT |
+				     lli->port_sel));
+	}
+
+	mutex_unlock(&blka->mutex);
+
+	/*
+	 * The following sequence is prescribed in the SISlite spec
+	 * for syncing up with the AFU when adding LXT entries.
+	 */
+	dma_wmb(); /* Make LXT updates are visible */
+
+	rhte->lxt_start = lxt;
+	dma_wmb(); /* Make RHT entry's LXT table update visible */
+
+	rhte->lxt_cnt = my_new_size;
+	dma_wmb(); /* Make RHT entry's LXT table size update visible */
+
+	cxlflash_afu_sync(afu, ctxid, rhndl, AFU_LW_SYNC);
+
+	/* free old lxt if reallocated */
+	if (lxt != lxt_old)
+		kfree(lxt_old);
+	*new_size = my_new_size;
+out:
+	pr_debug("%s: returning rc=%d\n", __func__, rc);
+	return rc;
+}
+
+/**
+ * shrink_lxt() - reduces translation table associated with the specified RHTE
+ * @afu:	AFU associated with the host.
+ * @sdev:	SCSI device associated with LUN.
+ * @ctxid:	Context ID of context owning the RHTE.
+ * @rhndl:	Resource handle associated with the RHTE.
+ * @rhte:	Resource handle entry (RHTE).
+ * @new_size:	Number of translation entries associated with RHTE.
+ * @port_sel:	Port selection mask.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int shrink_lxt(struct afu *afu,
+		      struct scsi_device *sdev,
+		      ctx_hndl_t ctxid,
+		      res_hndl_t rhndl,
+		      struct sisl_rht_entry *rhte,
+		      u64 *new_size)
+{
+	struct sisl_lxt_entry *lxt, *lxt_old;
+	struct llun_info *lli = sdev->hostdata;
+	struct glun_info *gli = lli->parent;
+	struct blka *blka = &gli->blka;
+	u32 ngrps, ngrps_old;
+	u64 aun;		/* chunk# allocated by block allocator */
+	u64 delta = rhte->lxt_cnt - *new_size;
+	u64 my_new_size;
+	int i, rc = 0;
+
+	lxt_old = rhte->lxt_start;
+	ngrps_old = LXT_NUM_GROUPS(rhte->lxt_cnt);
+	ngrps = LXT_NUM_GROUPS(rhte->lxt_cnt - delta);
+
+	if (ngrps != ngrps_old) {
+		/* reallocate to fit new size unless new size is 0 */
+		if (ngrps) {
+			lxt = kzalloc((sizeof(*lxt) * LXT_GROUP_SIZE * ngrps),
+				      GFP_KERNEL);
+			if (unlikely(!lxt)) {
+				rc = -ENOMEM;
+				goto out;
+			}
+
+			/* copy over old entries that will remain */
+			memcpy(lxt, lxt_old,
+			       (sizeof(*lxt) * (rhte->lxt_cnt - delta)));
+		} else
+			lxt = NULL;
+	} else
+		lxt = lxt_old;
+
+	/* nothing can fail from now on */
+	my_new_size = rhte->lxt_cnt - delta;
+
+	/*
+	 * The following sequence is prescribed in the SISlite spec
+	 * for syncing up with the AFU when removing LXT entries.
+	 */
+	rhte->lxt_cnt = my_new_size;
+	dma_wmb(); /* Make RHT entry's LXT table size update visible */
+
+	rhte->lxt_start = lxt;
+	dma_wmb(); /* Make RHT entry's LXT table update visible */
+
+	cxlflash_afu_sync(afu, ctxid, rhndl, AFU_HW_SYNC);
+
+	/* free LBAs allocated to freed chunks */
+	mutex_lock(&blka->mutex);
+	for (i = delta - 1; i >= 0; i--) {
+		/* Mask the higher 48 bits before shifting, even though
+		 * it is a noop
+		 */
+		aun = (lxt_old[my_new_size + i].rlba_base & SISL_ASTATUS_MASK);
+		aun = (aun >> MC_CHUNK_SHIFT);
+		write_same16(sdev, aun, MC_CHUNK_SIZE);
+		ba_free(&blka->ba_lun, aun);
+	}
+	mutex_unlock(&blka->mutex);
+
+	/* free old lxt if reallocated */
+	if (lxt != lxt_old)
+		kfree(lxt_old);
+	*new_size = my_new_size;
+out:
+	pr_debug("%s: returning rc=%d\n", __func__, rc);
+	return rc;
+}
+
+/**
+ * _cxlflash_vlun_resize() - changes the size of a virtual lun
+ * @sdev:	SCSI device associated with LUN owning virtual LUN.
+ * @ctxi:	Context owning resources.
+ * @resize:	Resize ioctl data structure.
+ *
+ * On successful return, the user is informed of the new size (in blocks)
+ * of the virtual lun in last LBA format. When the size of the virtual
+ * lun is zero, the last LBA is reflected as -1.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int _cxlflash_vlun_resize(struct scsi_device *sdev,
+			  struct ctx_info *ctxi,
+			  struct dk_cxlflash_resize *resize)
+{
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
+	struct llun_info *lli = sdev->hostdata;
+	struct glun_info *gli = lli->parent;
+	struct afu *afu = cfg->afu;
+	bool unlock_ctx = false;
+
+	res_hndl_t rhndl = resize->rsrc_handle;
+	u64 new_size;
+	u64 nsectors;
+	u64 ctxid = DECODE_CTXID(resize->context_id),
+	    rctxid = resize->context_id;
+
+	struct sisl_rht_entry *rhte;
+
+	int rc = 0;
+
+	/* req_size is always assumed to be in 4k blocks. So we have to convert
+	 * it from 4k to chunk size
+	 */
+	nsectors = (resize->req_size * CXLFLASH_BLOCK_SIZE) / gli->blk_len;
+	new_size = (nsectors + MC_CHUNK_SIZE - 1) / MC_CHUNK_SIZE;
+
+	pr_debug("%s: ctxid=%llu rhndl=0x%llx, req_size=0x%llx,"
+		 "new_size=%llx\n", __func__, ctxid, resize->rsrc_handle,
+		 resize->req_size, new_size);
+
+	if (unlikely(gli->mode != MODE_VIRTUAL)) {
+		pr_err("%s: LUN mode does not support resize! (%d)\n",
+		       __func__, gli->mode);
+		rc = -EINVAL;
+		goto out;
+
+	}
+
+	if (!ctxi) {
+		ctxi = get_context(cfg, rctxid, lli, CTX_CTRL_ERR_FALLBACK);
+		if (unlikely(!ctxi)) {
+			pr_err("%s: Bad context! (%llu)\n", __func__, ctxid);
+			rc = -EINVAL;
+			goto out;
+		}
+
+		unlock_ctx = true;
+	}
+
+	rhte = get_rhte(ctxi, rhndl, lli);
+	if (unlikely(!rhte)) {
+		pr_err("%s: Bad resource handle! (%u)\n", __func__, rhndl);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if (new_size > rhte->lxt_cnt)
+		rc = grow_lxt(afu,
+			      sdev,
+			      ctxid,
+			      rhndl,
+			      rhte,
+			      &new_size);
+	else if (new_size < rhte->lxt_cnt)
+		rc = shrink_lxt(afu,
+				sdev,
+				ctxid,
+				rhndl,
+				rhte,
+				&new_size);
+
+	resize->hdr.return_flags = 0;
+	resize->last_lba = (new_size * MC_CHUNK_SIZE * gli->blk_len);
+	resize->last_lba /= CXLFLASH_BLOCK_SIZE;
+	resize->last_lba--;
+
+out:
+	if (unlock_ctx)
+		mutex_unlock(&ctxi->mutex);
+	pr_debug("%s: resized to %lld returning rc=%d\n",
+		 __func__, resize->last_lba, rc);
+	return rc;
+}
+
+int cxlflash_vlun_resize(struct scsi_device *sdev,
+			 struct dk_cxlflash_resize *resize)
+{
+	return _cxlflash_vlun_resize(sdev, NULL, resize);
+}
+
+/**
+ * init_lun_table() - write an entry in the LUN table
+ * @cfg:        Internal structure associated with the host.
+ * @lli:	Per adapter LUN information structure.
+ *
+ * On successful return, a LUN table entry is created.
+ * At the top for LUNs visible on both ports.
+ * At the bottom for LUNs visible only on one port.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int init_lun_table(struct cxlflash_cfg *cfg, struct llun_info *lli)
+{
+	u32 chan;
+	int rc = 0;
+	struct afu *afu = cfg->afu;
+
+	if (lli->in_table)
+		goto out;
+
+	if (lli->port_sel == BOTH_PORTS) {
+		/*
+		 * If this LUN is visible from both ports, we will put
+		 * it in the top half of the LUN table.
+		 */
+		if ((cfg->promote_lun_index == cfg->last_lun_index[0]) ||
+		    (cfg->promote_lun_index == cfg->last_lun_index[1])) {
+			rc = -ENOSPC;
+			goto out;
+		}
+
+		lli->lun_index = cfg->promote_lun_index;
+		writeq_be(lli->lun_id[0],
+			  &afu->afu_map->global.fc_port[0]
+			  [cfg->promote_lun_index]);
+		writeq_be(lli->lun_id[1],
+			  &afu->afu_map->global.fc_port[1]
+			  [cfg->promote_lun_index]);
+		cfg->promote_lun_index++;
+		pr_debug("%s: Virtual LUN on slot %d  id0=%llx, id1=%llx\n",
+			 __func__, lli->lun_index, lli->lun_id[0],
+			 lli->lun_id[1]);
+	} else {
+		/*
+		 * If this LUN is visible only from one port, we will put
+		 * it in the bottom half of the LUN table.
+		 */
+		chan = PORT2CHAN(lli->port_sel);
+		if (cfg->promote_lun_index == cfg->last_lun_index[chan]) {
+			rc = -ENOSPC;
+			goto out;
+		}
+
+		lli->lun_index = cfg->last_lun_index[chan];
+		writeq_be(lli->lun_id[chan],
+			  &afu->afu_map->global.fc_port[chan]
+			  [cfg->last_lun_index[chan]]);
+		cfg->last_lun_index[chan]--;
+		pr_debug("%s: Virtual LUN on slot %d  chan=%d, id=%llx\n",
+			 __func__, lli->lun_index, chan, lli->lun_id[chan]);
+	}
+
+	lli->in_table = true;
+out:
+	pr_debug("%s: returning rc=%d\n", __func__, rc);
+	return rc;
+}
+
+/**
+ * cxlflash_disk_virtual_open() - open a virtual disk of specified size
+ * @sdev:	SCSI device associated with LUN owning virtual LUN.
+ * @arg:	UVirtual ioctl data structure.
+ *
+ * On successful return, the user is informed of the resource handle
+ * to be used to identify the virtual lun and the size (in blocks) of
+ * the virtual lun in last LBA format. When the size of the virtual lun
+ * is zero, the last LBA is reflected as -1.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int cxlflash_disk_virtual_open(struct scsi_device *sdev, void *arg)
+{
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
+	struct llun_info *lli = sdev->hostdata;
+	struct glun_info *gli = lli->parent;
+
+	struct dk_cxlflash_uvirtual *virt = (struct dk_cxlflash_uvirtual *)arg;
+	struct dk_cxlflash_resize resize;
+
+	u64 ctxid = DECODE_CTXID(virt->context_id),
+	    rctxid = virt->context_id;
+	u64 lun_size = virt->lun_size;
+	u64 last_lba = 0;
+	u64 rsrc_handle = -1;
+
+	int rc = 0;
+
+	struct ctx_info *ctxi = NULL;
+	struct sisl_rht_entry *rhte = NULL;
+
+	pr_debug("%s: ctxid=%llu ls=0x%llx\n", __func__, ctxid, lun_size);
+
+	if (gli->mode == MODE_NONE) {
+		/* Setup the LUN table on the first call */
+		rc = init_lun_table(cfg, lli);
+		if (rc) {
+			pr_err("%s: call to init_lun_table failed rc=%d!\n",
+			       __func__, rc);
+			goto out;
+		}
+
+		rc = init_ba(lli);
+		if (rc) {
+			pr_err("%s: call to init_ba failed rc=%d!\n",
+			       __func__, rc);
+			rc = -ENOMEM;
+			goto out;
+		}
+	}
+
+	rc = cxlflash_lun_attach(gli, MODE_VIRTUAL);
+	if (unlikely(rc)) {
+		pr_err("%s: Failed to attach to LUN! (VIRTUAL)\n", __func__);
+		goto out;
+	}
+
+	ctxi = get_context(cfg, rctxid, lli, 0);
+	if (unlikely(!ctxi)) {
+		pr_err("%s: Bad context! (%llu)\n", __func__, ctxid);
+		rc = -EINVAL;
+		goto err1;
+	}
+
+	rhte = rhte_checkout(ctxi, lli);
+	if (unlikely(!rhte)) {
+		pr_err("%s: too many opens for this context\n", __func__);
+		rc = -EMFILE;	/* too many opens  */
+		goto err1;
+	}
+
+	rsrc_handle = (rhte - ctxi->rht_start);
+
+	rhte->nmask = MC_RHT_NMASK;
+	rhte->fp = SISL_RHT_FP(0U, ctxi->rht_perms);
+	/* format 0 & perms */
+
+	/* Resize even if requested size is 0 */
+	marshal_virt_to_resize(virt, &resize);
+	resize.rsrc_handle = rsrc_handle;
+	rc = _cxlflash_vlun_resize(sdev, ctxi, &resize);
+	if (rc) {
+		pr_err("%s: resize failed rc %d\n", __func__, rc);
+		goto err2;
+	}
+	last_lba = resize.last_lba;
+
+	virt->hdr.return_flags = 0;
+	virt->last_lba = last_lba;
+	virt->rsrc_handle = rsrc_handle;
+
+out:
+	if (likely(ctxi))
+		mutex_unlock(&ctxi->mutex);
+	pr_debug("%s: returning handle 0x%llx rc=%d llba %lld\n",
+		 __func__, rsrc_handle, rc, last_lba);
+	return rc;
+
+err2:
+	rhte_checkin(ctxi, rhte);
+err1:
+	cxlflash_lun_detach(gli);
+	goto out;
+}
+
+/**
+ * clone_lxt() - copies translation tables from source to destination RHTE
+ * @afu:	AFU associated with the host.
+ * @blka:	Block allocator associated with LUN.
+ * @ctxid:	Context ID of context owning the RHTE.
+ * @rhndl:	Resource handle associated with the RHTE.
+ * @rhte:	Destination resource handle entry (RHTE).
+ * @rhte_src:	Source resource handle entry (RHTE).
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int clone_lxt(struct afu *afu,
+		     struct blka *blka,
+		     ctx_hndl_t ctxid,
+		     res_hndl_t rhndl,
+		     struct sisl_rht_entry *rhte,
+		     struct sisl_rht_entry *rhte_src)
+{
+	struct sisl_lxt_entry *lxt;
+	u32 ngrps;
+	u64 aun;		/* chunk# allocated by block allocator */
+	int i, j;
+
+	ngrps = LXT_NUM_GROUPS(rhte_src->lxt_cnt);
+
+	if (ngrps) {
+		/* allocate new LXTs for clone */
+		lxt = kzalloc((sizeof(*lxt) * LXT_GROUP_SIZE * ngrps),
+				GFP_KERNEL);
+		if (unlikely(!lxt))
+			return -ENOMEM;
+
+		/* copy over */
+		memcpy(lxt, rhte_src->lxt_start,
+		       (sizeof(*lxt) * rhte_src->lxt_cnt));
+
+		/* clone the LBAs in block allocator via ref_cnt */
+		mutex_lock(&blka->mutex);
+		for (i = 0; i < rhte_src->lxt_cnt; i++) {
+			aun = (lxt[i].rlba_base >> MC_CHUNK_SHIFT);
+			if (ba_clone(&blka->ba_lun, aun) == -1ULL) {
+				/* free the clones already made */
+				for (j = 0; j < i; j++) {
+					aun = (lxt[j].rlba_base >>
+					       MC_CHUNK_SHIFT);
+					ba_free(&blka->ba_lun, aun);
+				}
+
+				mutex_unlock(&blka->mutex);
+				kfree(lxt);
+				return -EIO;
+			}
+		}
+		mutex_unlock(&blka->mutex);
+	} else {
+		lxt = NULL;
+	}
+
+	/*
+	 * The following sequence is prescribed in the SISlite spec
+	 * for syncing up with the AFU when adding LXT entries.
+	 */
+	dma_wmb(); /* Make LXT updates are visible */
+
+	rhte->lxt_start = lxt;
+	dma_wmb(); /* Make RHT entry's LXT table update visible */
+
+	rhte->lxt_cnt = rhte_src->lxt_cnt;
+	dma_wmb(); /* Make RHT entry's LXT table size update visible */
+
+	cxlflash_afu_sync(afu, ctxid, rhndl, AFU_LW_SYNC);
+
+	pr_debug("%s: returning\n", __func__);
+	return 0;
+}
+
+/**
+ * cxlflash_disk_clone() - clone a context by making snapshot of another
+ * @sdev:	SCSI device associated with LUN owning virtual LUN.
+ * @clone:	Clone ioctl data structure.
+ *
+ * This routine effectively performs cxlflash_disk_open operation for each
+ * in-use virtual resource in the source context. Note that the destination
+ * context must be in pristine state and cannot have any resource handles
+ * open at the time of the clone.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int cxlflash_disk_clone(struct scsi_device *sdev,
+			struct dk_cxlflash_clone *clone)
+{
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
+	struct llun_info *lli = sdev->hostdata;
+	struct glun_info *gli = lli->parent;
+	struct blka *blka = &gli->blka;
+	struct afu *afu = cfg->afu;
+	struct dk_cxlflash_release release = { { 0 }, 0 };
+
+	struct ctx_info *ctxi_src = NULL,
+			*ctxi_dst = NULL;
+	struct lun_access *lun_access_src, *lun_access_dst;
+	u32 perms;
+	u64 ctxid_src = DECODE_CTXID(clone->context_id_src),
+	    ctxid_dst = DECODE_CTXID(clone->context_id_dst),
+	    rctxid_src = clone->context_id_src,
+	    rctxid_dst = clone->context_id_dst;
+	int adap_fd_src = clone->adap_fd_src;
+	int i, j;
+	int rc = 0;
+	bool found;
+	LIST_HEAD(sidecar);
+
+	pr_debug("%s: ctxid_src=%llu ctxid_dst=%llu adap_fd_src=%d\n",
+		 __func__, ctxid_src, ctxid_dst, adap_fd_src);
+
+	/* Do not clone yourself */
+	if (unlikely(rctxid_src == rctxid_dst)) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if (unlikely(gli->mode != MODE_VIRTUAL)) {
+		rc = -EINVAL;
+		pr_err("%s: Clone not supported on physical LUNs! (%d)\n",
+		       __func__, gli->mode);
+		goto out;
+	}
+
+	ctxi_src = get_context(cfg, rctxid_src, lli, CTX_CTRL_CLONE);
+	ctxi_dst = get_context(cfg, rctxid_dst, lli, 0);
+	if (unlikely(!ctxi_src || !ctxi_dst)) {
+		pr_err("%s: Bad context! (%llu,%llu)\n", __func__,
+		       ctxid_src, ctxid_dst);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if (unlikely(adap_fd_src != ctxi_src->lfd)) {
+		pr_err("%s: Invalid source adapter fd! (%d)\n",
+		       __func__, adap_fd_src);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	/* Verify there is no open resource handle in the destination context */
+	for (i = 0; i < MAX_RHT_PER_CONTEXT; i++)
+		if (ctxi_dst->rht_start[i].nmask != 0) {
+			rc = -EINVAL;
+			goto out;
+		}
+
+	/* Clone LUN access list */
+	list_for_each_entry(lun_access_src, &ctxi_src->luns, list) {
+		found = false;
+		list_for_each_entry(lun_access_dst, &ctxi_dst->luns, list)
+			if (lun_access_dst->sdev == lun_access_src->sdev) {
+				found = true;
+				break;
+			}
+
+		if (!found) {
+			lun_access_dst = kzalloc(sizeof(*lun_access_dst),
+						 GFP_KERNEL);
+			if (unlikely(!lun_access_dst)) {
+				pr_err("%s: Unable to allocate lun_access!\n",
+				       __func__);
+				rc = -ENOMEM;
+				goto out;
+			}
+
+			*lun_access_dst = *lun_access_src;
+			list_add(&lun_access_dst->list, &sidecar);
+		}
+	}
+
+	if (unlikely(!ctxi_src->rht_out)) {
+		pr_err("%s: Nothing to clone!\n", __func__);
+		goto out_success;
+	}
+
+	/* User specified permission on attach */
+	perms = ctxi_dst->rht_perms;
+
+	/*
+	 * Copy over checked-out RHT (and their associated LXT) entries by
+	 * hand, stopping after we've copied all outstanding entries and
+	 * cleaning up if the clone fails.
+	 *
+	 * Note: This loop is equivalent to performing cxlflash_disk_open and
+	 * cxlflash_vlun_resize. As such, LUN accounting needs to be taken into
+	 * account by attaching after each successful RHT entry clone. In the
+	 * event that a clone failure is experienced, the LUN detach is handled
+	 * via the cleanup performed by _cxlflash_disk_release.
+	 */
+	for (i = 0; i < MAX_RHT_PER_CONTEXT; i++) {
+		if (ctxi_src->rht_out == ctxi_dst->rht_out)
+			break;
+		if (ctxi_src->rht_start[i].nmask == 0)
+			continue;
+
+		/* Consume a destination RHT entry */
+		ctxi_dst->rht_out++;
+		ctxi_dst->rht_start[i].nmask = ctxi_src->rht_start[i].nmask;
+		ctxi_dst->rht_start[i].fp =
+		    SISL_RHT_FP_CLONE(ctxi_src->rht_start[i].fp, perms);
+		ctxi_dst->rht_lun[i] = ctxi_src->rht_lun[i];
+
+		rc = clone_lxt(afu, blka, ctxid_dst, i,
+			       &ctxi_dst->rht_start[i],
+			       &ctxi_src->rht_start[i]);
+		if (rc) {
+			marshal_clone_to_rele(clone, &release);
+			for (j = 0; j < i; j++) {
+				release.rsrc_handle = j;
+				_cxlflash_disk_release(sdev, ctxi_dst,
+						       &release);
+			}
+
+			/* Put back the one we failed on */
+			rhte_checkin(ctxi_dst, &ctxi_dst->rht_start[i]);
+			goto err;
+		}
+
+		cxlflash_lun_attach(gli, gli->mode);
+	}
+
+out_success:
+	list_splice(&sidecar, &ctxi_dst->luns);
+	sys_close(adap_fd_src);
+
+	/* fall through */
+out:
+	if (ctxi_src)
+		mutex_unlock(&ctxi_src->mutex);
+	if (ctxi_dst)
+		mutex_unlock(&ctxi_dst->mutex);
+	pr_debug("%s: returning rc=%d\n", __func__, rc);
+	return rc;
+
+err:
+	list_for_each_entry_safe(lun_access_src, lun_access_dst, &sidecar, list)
+		kfree(lun_access_src);
+	goto out;
+}
+
diff --git a/drivers/scsi/cxlflash/vlun.h b/drivers/scsi/cxlflash/vlun.h
new file mode 100644
index 0000000..9000493
--- /dev/null
+++ b/drivers/scsi/cxlflash/vlun.h
@@ -0,0 +1,68 @@
+/*
+ * CXL Flash Device Driver
+ *
+ * Written by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>, IBM Corporation
+ *             Matthew R. Ochs <mrochs@linux.vnet.ibm.com>, IBM Corporation
+ *
+ * Copyright (C) 2015 IBM Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _CXLFLASH_VLUN_H
+#define _CXLFLASH_VLUN_H
+
+#define MC_RHT_NMASK      16	/* in bits */
+#define MC_CHUNK_SHIFT    MC_RHT_NMASK	/* shift to go from LBA to chunk# */
+#define LXT_LUNIDX_SHIFT  8	/* LXT entry, shift for LUN index */
+#define LXT_PERM_SHIFT    4	/* LXT entry, shift for permission bits */
+
+/* LXT tables are allocated dynamically in groups. This is done to
+   avoid a malloc/free overhead each time the LXT has to grow
+   or shrink.
+
+   Based on the current lxt_cnt (used), it is always possible to
+   know how many are allocated (used+free). The number of allocated
+   entries is not stored anywhere.
+
+   The LXT table is re-allocated whenever it needs to cross into
+   another group.
+*/
+#define LXT_GROUP_SIZE          8
+#define LXT_NUM_GROUPS(lxt_cnt) (((lxt_cnt) + 7)/8)	/* alloc'ed groups */
+
+struct ba_lun {
+	u64 lun_id;
+	u64 wwpn;
+	size_t lsize;		/* LUN size in number of LBAs             */
+	size_t lba_size;	/* LBA size in number of bytes            */
+	size_t au_size;		/* Allocation Unit size in number of LBAs */
+	void *ba_lun_handle;
+};
+
+struct ba_lun_info {
+	u64 *lun_alloc_map;
+	u32 lun_bmap_size;
+	u32 total_aus;
+	u64 free_aun_cnt;
+
+	/* indices to be used for elevator lookup of free map */
+	u32 free_low_idx;
+	u32 free_curr_idx;
+	u32 free_high_idx;
+
+	u8 *aun_clone_map;
+};
+
+/* Block Allocator */
+struct blka {
+	struct ba_lun ba_lun;
+	u64 nchunk;		/* number of chunks */
+	struct mutex mutex;
+};
+
+#endif /* ifndef _CXLFLASH_SUPERPIPE_H */
+
diff --git a/include/uapi/scsi/cxlflash_ioctl.h b/include/uapi/scsi/cxlflash_ioctl.h
index bdaae75..a581ff8 100644
--- a/include/uapi/scsi/cxlflash_ioctl.h
+++ b/include/uapi/scsi/cxlflash_ioctl.h
@@ -66,12 +66,35 @@ struct dk_cxlflash_udirect {
 	__u64 last_lba;			/* Returned last LBA on the device */
 };
 
+struct dk_cxlflash_uvirtual {
+	struct dk_cxlflash_hdr hdr;	/* Common fields */
+	__u64 context_id;		/* Context to own virtual resources */
+	__u64 lun_size;			/* Requested size, in 4K blocks */
+	__u64 rsrc_handle;		/* Returned resource handle */
+	__u64 last_lba;			/* Returned last LBA of LUN */
+};
+
 struct dk_cxlflash_release {
 	struct dk_cxlflash_hdr hdr;	/* Common fields */
 	__u64 context_id;		/* Context owning resources */
 	__u64 rsrc_handle;		/* Resource handle to release */
 };
 
+struct dk_cxlflash_resize {
+	struct dk_cxlflash_hdr hdr;	/* Common fields */
+	__u64 context_id;		/* Context owning resources */
+	__u64 rsrc_handle;		/* Resource handle of LUN to resize */
+	__u64 req_size;			/* New requested size, in 4K blocks */
+	__u64 last_lba;			/* Returned last LBA of LUN */
+};
+
+struct dk_cxlflash_clone {
+	struct dk_cxlflash_hdr hdr;	/* Common fields */
+	__u64 context_id_src;		/* Context to clone from */
+	__u64 context_id_dst;		/* Context to clone to */
+	__u64 adap_fd_src;		/* Source context adapter fd */
+};
+
 #define DK_CXLFLASH_VERIFY_SENSE_LEN	18
 #define DK_CXLFLASH_VERIFY_HINT_SENSE	0x8000000000000000ULL
 
@@ -109,7 +132,10 @@ union cxlflash_ioctls {
 	struct dk_cxlflash_attach attach;
 	struct dk_cxlflash_detach detach;
 	struct dk_cxlflash_udirect udirect;
+	struct dk_cxlflash_uvirtual uvirtual;
 	struct dk_cxlflash_release release;
+	struct dk_cxlflash_resize resize;
+	struct dk_cxlflash_clone clone;
 	struct dk_cxlflash_verify verify;
 	struct dk_cxlflash_recover_afu recover_afu;
 	struct dk_cxlflash_manage_lun manage_lun;
@@ -123,9 +149,12 @@ union cxlflash_ioctls {
 
 #define DK_CXLFLASH_ATTACH		CXL_IOW(0x80, dk_cxlflash_attach)
 #define DK_CXLFLASH_USER_DIRECT		CXL_IOW(0x81, dk_cxlflash_udirect)
+#define DK_CXLFLASH_USER_VIRTUAL	CXL_IOW(0x82, dk_cxlflash_uvirtual)
+#define DK_CXLFLASH_VLUN_RESIZE		CXL_IOW(0x83, dk_cxlflash_resize)
 #define DK_CXLFLASH_RELEASE		CXL_IOW(0x84, dk_cxlflash_release)
 #define DK_CXLFLASH_DETACH		CXL_IOW(0x85, dk_cxlflash_detach)
 #define DK_CXLFLASH_VERIFY		CXL_IOW(0x86, dk_cxlflash_verify)
+#define DK_CXLFLASH_CLONE		CXL_IOW(0x87, dk_cxlflash_clone)
 #define DK_CXLFLASH_RECOVER_AFU		CXL_IOW(0x88, dk_cxlflash_recover_afu)
 #define DK_CXLFLASH_MANAGE_LUN		CXL_IOW(0x89, dk_cxlflash_manage_lun)
 
-- 
2.1.0


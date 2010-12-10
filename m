From: Maggie Zhang <xmzhang@brocade.com>
Subject: [PATCH 3/7] bfa: remove a file with small size
Date: Thu, 9 Dec 2010 19:09:26 -0800
Message-ID: <1291950566-12813-1-git-send-email-xmzhang@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:44624 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193Ab0LJDJb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2010 22:09:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@blc-10-10.brocade.com, Maggie Zhang <xmzhang@brocade.com>, Jing Huang <huangj@brocade.com>

Removed bfa_drv.c, merged it to bfa_core.c and modified Makefile.

Signed-off-by: Maggie Zhang <xmzhang@brocade.com>
Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/Makefile      |    2 +-
 drivers/scsi/bfa/bfa.h         |    1 -
 drivers/scsi/bfa/bfa_core.c    |   87 ++++++++++++++++++++++++++++++++
 drivers/scsi/bfa/bfa_drv.c     |  107 ----------------------------------------
 drivers/scsi/bfa/bfa_modules.h |    3 -
 5 files changed, 88 insertions(+), 112 deletions(-)
 delete mode 100644 drivers/scsi/bfa/bfa_drv.c

diff --git a/drivers/scsi/bfa/Makefile b/drivers/scsi/bfa/Makefile
index d2eefd3..ed26a6a 100644
--- a/drivers/scsi/bfa/Makefile
+++ b/drivers/scsi/bfa/Makefile
@@ -3,6 +3,6 @@ obj-$(CONFIG_SCSI_BFA_FC) := bfa.o
 bfa-y := bfad.o bfad_im.o bfad_attr.o bfad_debugfs.o
 bfa-y += bfa_ioc.o bfa_ioc_cb.o bfa_ioc_ct.o bfa_hw_cb.o bfa_hw_ct.o
 bfa-y += bfa_fcs.o bfa_fcs_lport.o bfa_fcs_rport.o bfa_fcs_fcpim.o bfa_fcbuild.o
-bfa-y += bfa_port.o bfa_fcpim.o bfa_core.o bfa_drv.o bfa_svc.o
+bfa-y += bfa_port.o bfa_fcpim.o bfa_core.o bfa_svc.o
 
 ccflags-y := -DBFA_PERF_BUILD
diff --git a/drivers/scsi/bfa/bfa.h b/drivers/scsi/bfa/bfa.h
index 6231e5a..8f17186 100644
--- a/drivers/scsi/bfa/bfa.h
+++ b/drivers/scsi/bfa/bfa.h
@@ -331,7 +331,6 @@ void bfa_hwct_msix_getvecs(struct bfa_s *bfa, u32 *vecmap, u32 *nvecs,
 			   u32 *maxvec);
 void bfa_hwct_msix_get_rme_range(struct bfa_s *bfa, u32 *start,
 				 u32 *end);
-void bfa_com_port_attach(struct bfa_s *bfa, struct bfa_meminfo_s *mi);
 void bfa_iocfc_get_bootwwns(struct bfa_s *bfa, u8 *nwwns, wwn_t *wwns);
 wwn_t bfa_iocfc_get_pwwn(struct bfa_s *bfa);
 wwn_t bfa_iocfc_get_nwwn(struct bfa_s *bfa);
diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 002907c..d417864 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -22,6 +22,93 @@
 BFA_TRC_FILE(HAL, CORE);
 
 /*
+ * BFA module list terminated by NULL
+ */
+static struct bfa_module_s *hal_mods[] = {
+	&hal_mod_sgpg,
+	&hal_mod_fcport,
+	&hal_mod_fcxp,
+	&hal_mod_lps,
+	&hal_mod_uf,
+	&hal_mod_rport,
+	&hal_mod_fcpim,
+	NULL
+};
+
+/*
+ * Message handlers for various modules.
+ */
+static bfa_isr_func_t  bfa_isrs[BFI_MC_MAX] = {
+	bfa_isr_unhandled,	/* NONE */
+	bfa_isr_unhandled,	/* BFI_MC_IOC */
+	bfa_isr_unhandled,	/* BFI_MC_DIAG */
+	bfa_isr_unhandled,	/* BFI_MC_FLASH */
+	bfa_isr_unhandled,	/* BFI_MC_CEE */
+	bfa_fcport_isr,		/* BFI_MC_FCPORT */
+	bfa_isr_unhandled,	/* BFI_MC_IOCFC */
+	bfa_isr_unhandled,	/* BFI_MC_LL */
+	bfa_uf_isr,		/* BFI_MC_UF */
+	bfa_fcxp_isr,		/* BFI_MC_FCXP */
+	bfa_lps_isr,		/* BFI_MC_LPS */
+	bfa_rport_isr,		/* BFI_MC_RPORT */
+	bfa_itnim_isr,		/* BFI_MC_ITNIM */
+	bfa_isr_unhandled,	/* BFI_MC_IOIM_READ */
+	bfa_isr_unhandled,	/* BFI_MC_IOIM_WRITE */
+	bfa_isr_unhandled,	/* BFI_MC_IOIM_IO */
+	bfa_ioim_isr,		/* BFI_MC_IOIM */
+	bfa_ioim_good_comp_isr,	/* BFI_MC_IOIM_IOCOM */
+	bfa_tskim_isr,		/* BFI_MC_TSKIM */
+	bfa_isr_unhandled,	/* BFI_MC_SBOOT */
+	bfa_isr_unhandled,	/* BFI_MC_IPFC */
+	bfa_isr_unhandled,	/* BFI_MC_PORT */
+	bfa_isr_unhandled,	/* --------- */
+	bfa_isr_unhandled,	/* --------- */
+	bfa_isr_unhandled,	/* --------- */
+	bfa_isr_unhandled,	/* --------- */
+	bfa_isr_unhandled,	/* --------- */
+	bfa_isr_unhandled,	/* --------- */
+	bfa_isr_unhandled,	/* --------- */
+	bfa_isr_unhandled,	/* --------- */
+	bfa_isr_unhandled,	/* --------- */
+	bfa_isr_unhandled,	/* --------- */
+};
+/*
+ * Message handlers for mailbox command classes
+ */
+static bfa_ioc_mbox_mcfunc_t  bfa_mbox_isrs[BFI_MC_MAX] = {
+	NULL,
+	NULL,		/* BFI_MC_IOC   */
+	NULL,		/* BFI_MC_DIAG  */
+	NULL,		/* BFI_MC_FLASH */
+	NULL,		/* BFI_MC_CEE   */
+	NULL,		/* BFI_MC_PORT  */
+	bfa_iocfc_isr,	/* BFI_MC_IOCFC */
+	NULL,
+};
+
+
+
+static void
+bfa_com_port_attach(struct bfa_s *bfa, struct bfa_meminfo_s *mi)
+{
+	struct bfa_port_s	*port = &bfa->modules.port;
+	u32			dm_len;
+	u8			*dm_kva;
+	u64			dm_pa;
+
+	dm_len = bfa_port_meminfo();
+	dm_kva = bfa_meminfo_dma_virt(mi);
+	dm_pa  = bfa_meminfo_dma_phys(mi);
+
+	memset(port, 0, sizeof(struct bfa_port_s));
+	bfa_port_attach(port, &bfa->ioc, bfa, bfa->trcmod);
+	bfa_port_mem_claim(port, dm_kva, dm_pa);
+
+	bfa_meminfo_dma_virt(mi) = dm_kva + dm_len;
+	bfa_meminfo_dma_phys(mi) = dm_pa + dm_len;
+}
+
+/*
  * BFA IOC FC related definitions
  */
 
diff --git a/drivers/scsi/bfa/bfa_drv.c b/drivers/scsi/bfa/bfa_drv.c
deleted file mode 100644
index 0222d7c..0000000
--- a/drivers/scsi/bfa/bfa_drv.c
+++ /dev/null
@@ -1,107 +0,0 @@
-/*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
- * All rights reserved
- * www.brocade.com
- *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License (GPL) Version 2 as
- * published by the Free Software Foundation
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-
-#include "bfa_modules.h"
-
-/*
- * BFA module list terminated by NULL
- */
-struct bfa_module_s *hal_mods[] = {
-	&hal_mod_sgpg,
-	&hal_mod_fcport,
-	&hal_mod_fcxp,
-	&hal_mod_lps,
-	&hal_mod_uf,
-	&hal_mod_rport,
-	&hal_mod_fcpim,
-	NULL
-};
-
-/*
- * Message handlers for various modules.
- */
-bfa_isr_func_t  bfa_isrs[BFI_MC_MAX] = {
-	bfa_isr_unhandled,	/* NONE */
-	bfa_isr_unhandled,	/* BFI_MC_IOC */
-	bfa_isr_unhandled,	/* BFI_MC_DIAG */
-	bfa_isr_unhandled,	/* BFI_MC_FLASH */
-	bfa_isr_unhandled,	/* BFI_MC_CEE */
-	bfa_fcport_isr,		/* BFI_MC_FCPORT */
-	bfa_isr_unhandled,	/* BFI_MC_IOCFC */
-	bfa_isr_unhandled,	/* BFI_MC_LL */
-	bfa_uf_isr,		/* BFI_MC_UF */
-	bfa_fcxp_isr,		/* BFI_MC_FCXP */
-	bfa_lps_isr,		/* BFI_MC_LPS */
-	bfa_rport_isr,		/* BFI_MC_RPORT */
-	bfa_itnim_isr,		/* BFI_MC_ITNIM */
-	bfa_isr_unhandled,	/* BFI_MC_IOIM_READ */
-	bfa_isr_unhandled,	/* BFI_MC_IOIM_WRITE */
-	bfa_isr_unhandled,	/* BFI_MC_IOIM_IO */
-	bfa_ioim_isr,		/* BFI_MC_IOIM */
-	bfa_ioim_good_comp_isr,	/* BFI_MC_IOIM_IOCOM */
-	bfa_tskim_isr,		/* BFI_MC_TSKIM */
-	bfa_isr_unhandled,	/* BFI_MC_SBOOT */
-	bfa_isr_unhandled,	/* BFI_MC_IPFC */
-	bfa_isr_unhandled,	/* BFI_MC_PORT */
-	bfa_isr_unhandled,	/* --------- */
-	bfa_isr_unhandled,	/* --------- */
-	bfa_isr_unhandled,	/* --------- */
-	bfa_isr_unhandled,	/* --------- */
-	bfa_isr_unhandled,	/* --------- */
-	bfa_isr_unhandled,	/* --------- */
-	bfa_isr_unhandled,	/* --------- */
-	bfa_isr_unhandled,	/* --------- */
-	bfa_isr_unhandled,	/* --------- */
-	bfa_isr_unhandled,	/* --------- */
-};
-
-
-/*
- * Message handlers for mailbox command classes
- */
-bfa_ioc_mbox_mcfunc_t  bfa_mbox_isrs[BFI_MC_MAX] = {
-	NULL,
-	NULL,			/* BFI_MC_IOC   */
-	NULL,			/* BFI_MC_DIAG  */
-	NULL,		/* BFI_MC_FLASH */
-	NULL,			/* BFI_MC_CEE   */
-	NULL,			/* BFI_MC_PORT  */
-	bfa_iocfc_isr,		/* BFI_MC_IOCFC */
-	NULL,
-};
-
-
-
-void
-bfa_com_port_attach(struct bfa_s *bfa, struct bfa_meminfo_s *mi)
-{
-	struct bfa_port_s	*port = &bfa->modules.port;
-	u32		dm_len;
-	u8			*dm_kva;
-	u64		dm_pa;
-
-	dm_len = bfa_port_meminfo();
-	dm_kva = bfa_meminfo_dma_virt(mi);
-	dm_pa  = bfa_meminfo_dma_phys(mi);
-
-	memset(port, 0, sizeof(struct bfa_port_s));
-	bfa_port_attach(port, &bfa->ioc, bfa, bfa->trcmod);
-	bfa_port_mem_claim(port, dm_kva, dm_pa);
-
-	bfa_meminfo_dma_virt(mi) = dm_kva + dm_len;
-	bfa_meminfo_dma_phys(mi) = dm_pa + dm_len;
-}
diff --git a/drivers/scsi/bfa/bfa_modules.h b/drivers/scsi/bfa/bfa_modules.h
index 15407ab..ab79ff6 100644
--- a/drivers/scsi/bfa/bfa_modules.h
+++ b/drivers/scsi/bfa/bfa_modules.h
@@ -99,7 +99,6 @@ struct bfa_module_s {
 	void (*iocdisable) (struct bfa_s *bfa);
 };
 
-extern struct bfa_module_s *hal_mods[];
 
 struct bfa_s {
 	void			*bfad;		/*  BFA driver instance    */
@@ -116,8 +115,6 @@ struct bfa_s {
 	struct bfa_msix_s	msix;
 };
 
-extern bfa_isr_func_t bfa_isrs[BFI_MC_MAX];
-extern bfa_ioc_mbox_mcfunc_t  bfa_mbox_isrs[];
 extern bfa_boolean_t bfa_auto_recover;
 extern struct bfa_module_s hal_mod_sgpg;
 extern struct bfa_module_s hal_mod_fcport;
-- 
1.7.2.1


From: <kgudipat@brocade.com>
Subject: [PATCH 14/33] bfa: (Cleanup Patch) BFAD header file consolidation / cleanup.
Date: Wed, 15 Sep 2010 12:06:55 -0700
Message-ID: <1284577615-18541-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:34294 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753314Ab0IOTIE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2010 15:08:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- This patch is part of the BFA cleanup.
	- bfad_ipfc.h, bfad_tm.h code will be removed.
	- bfad_im_compat.h and bfad_trcmod.h cleaned up code will be
	  merged to bfad_im.h and bfad_drv.h in the patchset.
	- Removing bfad_attr.h will not be using anymore.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfad_attr.h      |   56 -----------------------------------
 drivers/scsi/bfa/bfad_im_compat.h |   45 ----------------------------
 drivers/scsi/bfa/bfad_ipfc.h      |   42 --------------------------
 drivers/scsi/bfa/bfad_tm.h        |   59 -------------------------------------
 drivers/scsi/bfa/bfad_trcmod.h    |   52 --------------------------------
 5 files changed, 0 insertions(+), 254 deletions(-)
 delete mode 100644 drivers/scsi/bfa/bfad_attr.h
 delete mode 100644 drivers/scsi/bfa/bfad_im_compat.h
 delete mode 100644 drivers/scsi/bfa/bfad_ipfc.h
 delete mode 100644 drivers/scsi/bfa/bfad_tm.h
 delete mode 100644 drivers/scsi/bfa/bfad_trcmod.h

diff --git a/drivers/scsi/bfa/bfad_attr.h b/drivers/scsi/bfa/bfad_attr.h
deleted file mode 100644
index bf01020..0000000
--- a/drivers/scsi/bfa/bfad_attr.h
+++ /dev/null
@@ -1,56 +0,0 @@
-/*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
-#ifndef __BFAD_ATTR_H__
-#define __BFAD_ATTR_H__
-
-/**
- *  FC_transport_template FC transport template
- */
-
-struct Scsi_Host*
-bfad_os_dev_to_shost(struct scsi_target *starget);
-
-/**
- * FC transport template entry, get SCSI target port ID.
- */
-void
-bfad_im_get_starget_port_id(struct scsi_target *starget);
-
-/**
- * FC transport template entry, get SCSI target nwwn.
- */
-void
-bfad_im_get_starget_node_name(struct scsi_target *starget);
-
-/**
- * FC transport template entry, get SCSI target pwwn.
- */
-void
-bfad_im_get_starget_port_name(struct scsi_target *starget);
-
-/**
- * FC transport template entry, get SCSI host port ID.
- */
-void
-bfad_im_get_host_port_id(struct Scsi_Host *shost);
-
-struct Scsi_Host*
-bfad_os_starget_to_shost(struct scsi_target *starget);
-
-
-#endif /*  __BFAD_ATTR_H__ */
diff --git a/drivers/scsi/bfa/bfad_im_compat.h b/drivers/scsi/bfa/bfad_im_compat.h
deleted file mode 100644
index 0a122ab..0000000
--- a/drivers/scsi/bfa/bfad_im_compat.h
+++ /dev/null
@@ -1,45 +0,0 @@
-/*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
-#ifndef __BFAD_IM_COMPAT_H__
-#define __BFAD_IM_COMPAT_H__
-
-extern struct device_attribute *bfad_im_host_attrs[];
-extern struct device_attribute *bfad_im_vport_attrs[];
-
-u32 *bfad_get_firmware_buf(struct pci_dev *pdev);
-u32 *bfad_read_firmware(struct pci_dev *pdev, u32 **bfi_image,
-			u32 *bfi_image_size, char *fw_name);
-
-static inline u32 *
-bfad_load_fwimg(struct pci_dev *pdev)
-{
-	return bfad_get_firmware_buf(pdev);
-}
-
-static inline void
-bfad_free_fwimg(void)
-{
-	if (bfi_image_ct_fc_size && bfi_image_ct_fc)
-		vfree(bfi_image_ct_fc);
-	if (bfi_image_ct_cna_size && bfi_image_ct_cna)
-		vfree(bfi_image_ct_cna);
-	if (bfi_image_cb_fc_size && bfi_image_cb_fc)
-		vfree(bfi_image_cb_fc);
-}
-
-#endif
diff --git a/drivers/scsi/bfa/bfad_ipfc.h b/drivers/scsi/bfa/bfad_ipfc.h
deleted file mode 100644
index 718bc52..0000000
--- a/drivers/scsi/bfa/bfad_ipfc.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
-#ifndef __BFA_DRV_IPFC_H__
-#define __BFA_DRV_IPFC_H__
-
-
-#define IPFC_NAME ""
-
-#define bfad_ipfc_module_init(x) do {} while (0)
-#define bfad_ipfc_module_exit(x) do {} while (0)
-#define bfad_ipfc_probe(x) do {} while (0)
-#define bfad_ipfc_probe_undo(x) do {} while (0)
-#define bfad_ipfc_port_config(x, y) BFA_STATUS_OK
-#define bfad_ipfc_port_unconfig(x, y) do {} while (0)
-
-#define bfad_ipfc_probe_post(x) do {} while (0)
-#define bfad_ipfc_port_new(x, y, z) BFA_STATUS_OK
-#define bfad_ipfc_port_delete(x, y) do {} while (0)
-#define bfad_ipfc_port_online(x, y) do {} while (0)
-#define bfad_ipfc_port_offline(x, y) do {} while (0)
-
-#define bfad_ip_get_attr(x) BFA_STATUS_FAILED
-#define bfad_ip_reset_drv_stats(x) BFA_STATUS_FAILED
-#define bfad_ip_get_drv_stats(x, y) BFA_STATUS_FAILED
-#define bfad_ip_enable_ipfc(x, y, z) BFA_STATUS_FAILED
-
-
-#endif
diff --git a/drivers/scsi/bfa/bfad_tm.h b/drivers/scsi/bfa/bfad_tm.h
deleted file mode 100644
index 4901b1b..0000000
--- a/drivers/scsi/bfa/bfad_tm.h
+++ /dev/null
@@ -1,59 +0,0 @@
-/*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
-/*
- * Brocade Fibre Channel HBA Linux Target Mode Driver
- */
-
-/**
- *  tm/dummy/bfad_tm.h BFA callback dummy header file for BFA Linux target mode PCI interface module.
- */
-
-#ifndef __BFAD_TM_H__
-#define __BFAD_TM_H__
-
-#include <defs/bfa_defs_status.h>
-
-#define FCPT_NAME 		""
-
-/*
- * Called from base Linux driver on (De)Init events
- */
-
-/* attach tgt template with scst */
-#define bfad_tm_module_init()	do {} while (0)
-
-/* detach/release tgt template */
-#define bfad_tm_module_exit()	do {} while (0)
-
-#define bfad_tm_probe(x)	do {} while (0)
-#define bfad_tm_probe_undo(x)	do {} while (0)
-#define bfad_tm_probe_post(x)	do {} while (0)
-
-/*
- * Called by base Linux driver but triggered by BFA FCS on config events
- */
-#define bfad_tm_port_new(x, y)		BFA_STATUS_OK
-#define bfad_tm_port_delete(x, y)	do {} while (0)
-
-/*
- * Called by base Linux driver but triggered by BFA FCS on PLOGI/O events
- */
-#define bfad_tm_port_online(x, y)	do {} while (0)
-#define bfad_tm_port_offline(x, y)	do {} while (0)
-
-#endif
diff --git a/drivers/scsi/bfa/bfad_trcmod.h b/drivers/scsi/bfa/bfad_trcmod.h
deleted file mode 100644
index 2827b2a..0000000
--- a/drivers/scsi/bfa/bfad_trcmod.h
+++ /dev/null
@@ -1,52 +0,0 @@
-/*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
-/**
- *  bfad_trcmod.h Linux driver trace modules
- */
-
-
-#ifndef __BFAD_TRCMOD_H__
-#define __BFAD_TRCMOD_H__
-
-#include <cs/bfa_trc.h>
-
-/*
- * !!! Only append to the enums defined here to avoid any versioning
- * !!! needed between trace utility and driver version
- */
-enum {
-	/* 2.6 Driver */
-	BFA_TRC_LDRV_BFAD		= 1,
-	BFA_TRC_LDRV_BFAD_2_6		= 2,
-	BFA_TRC_LDRV_BFAD_2_6_9		= 3,
-	BFA_TRC_LDRV_BFAD_2_6_10	= 4,
-	BFA_TRC_LDRV_INTR		= 5,
-	BFA_TRC_LDRV_IOCTL		= 6,
-	BFA_TRC_LDRV_OS			= 7,
-	BFA_TRC_LDRV_IM			= 8,
-	BFA_TRC_LDRV_IM_2_6		= 9,
-	BFA_TRC_LDRV_IM_2_6_9		= 10,
-	BFA_TRC_LDRV_IM_2_6_10		= 11,
-	BFA_TRC_LDRV_TM			= 12,
-	BFA_TRC_LDRV_IPFC		= 13,
-	BFA_TRC_LDRV_IM_2_4		= 14,
-	BFA_TRC_LDRV_IM_VMW		= 15,
-	BFA_TRC_LDRV_IM_LT_2_6_10	= 16,
-};
-
-#endif /* __BFAD_TRCMOD_H__ */
-- 
1.7.3.rc1


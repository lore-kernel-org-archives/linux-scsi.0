From: <kgudipat@brocade.com>
Subject: [PATCH 31/32] bfa: Remove unused header files and did some cleanup.
Date: Wed, 3 Mar 2010 17:48:28 -0800
Message-ID: <1267667308-29126-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:47699 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab0CDBsj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2010 20:48:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:

	- Remove unused header files and cleanup unused functions.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_fcport.c                      |    4 +-
 drivers/scsi/bfa/bfa_ioc_cb.c                      |   12 ++--
 drivers/scsi/bfa/bfa_ioc_ct.c                      |   28 ++++----
 drivers/scsi/bfa/bfad_attr.h                       |    9 ---
 drivers/scsi/bfa/bfad_drv.h                        |   10 ---
 drivers/scsi/bfa/bfad_im.c                         |   10 ---
 drivers/scsi/bfa/bfad_im.h                         |    5 --
 drivers/scsi/bfa/fcpim.c                           |    1 -
 drivers/scsi/bfa/include/defs/bfa_defs_driver.h    |    3 +-
 drivers/scsi/bfa/include/defs/bfa_defs_im_common.h |   32 --------
 drivers/scsi/bfa/include/defs/bfa_defs_im_team.h   |   72 -------------------
 drivers/scsi/bfa/include/fcb/bfa_fcb_fcpim.h       |    1 -
 drivers/scsi/bfa/include/protocol/pcifw.h          |   75 --------------------
 13 files changed, 24 insertions(+), 238 deletions(-)
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_im_common.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_im_team.h
 delete mode 100644 drivers/scsi/bfa/include/protocol/pcifw.h

diff --git a/drivers/scsi/bfa/bfa_fcport.c b/drivers/scsi/bfa/bfa_fcport.c
index cfd3022..3daae73 100644
--- a/drivers/scsi/bfa/bfa_fcport.c
+++ b/drivers/scsi/bfa/bfa_fcport.c
@@ -851,9 +851,9 @@ bfa_fcport_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len,
 static void
 bfa_fcport_qresume(void *cbarg)
 {
-	struct bfa_fcport_s *port = cbarg;
+	struct bfa_fcport_s *fcport = cbarg;
 
-	bfa_sm_send_event(port, BFA_FCPORT_SM_QRESUME);
+	bfa_sm_send_event(fcport, BFA_FCPORT_SM_QRESUME);
 }
 
 static void
diff --git a/drivers/scsi/bfa/bfa_ioc_cb.c b/drivers/scsi/bfa/bfa_ioc_cb.c
index e76448f..0a1f210 100644
--- a/drivers/scsi/bfa/bfa_ioc_cb.c
+++ b/drivers/scsi/bfa/bfa_ioc_cb.c
@@ -63,13 +63,13 @@ bfa_ioc_set_cb_hwif(struct bfa_ioc_s *ioc)
 	ioc->ioc_hwif = &hwif_cb;
 }
 
-static uint32_t *
-bfa_ioc_cb_fwimg_get_chunk(struct bfa_ioc_s *ioc, uint32_t off)
+static u32 *
+bfa_ioc_cb_fwimg_get_chunk(struct bfa_ioc_s *ioc, u32 off)
 {
 	return bfi_image_cb_get_chunk(off);
 }
 	
-static uint32_t
+static u32
 bfa_ioc_cb_fwimg_get_size(struct bfa_ioc_s *ioc)
 {
 	return bfi_image_cb_size;
@@ -102,7 +102,7 @@ bfa_ioc_cb_notify_hbfail(struct bfa_ioc_s *ioc)
 /**
  * Host to LPU mailbox message addresses
  */
-static struct { uint32_t hfn_mbox, lpu_mbox, hfn_pgn; } iocreg_fnreg[] = {
+static struct { u32 hfn_mbox, lpu_mbox, hfn_pgn; } iocreg_fnreg[] = {
 	{ HOSTFN0_LPU_MBOX0_0, LPU_HOSTFN0_MBOX0_0, HOST_PAGE_NUM_FN0 },
 	{ HOSTFN1_LPU_MBOX0_8, LPU_HOSTFN1_MBOX0_8, HOST_PAGE_NUM_FN1 }
 };
@@ -110,7 +110,7 @@ static struct { uint32_t hfn_mbox, lpu_mbox, hfn_pgn; } iocreg_fnreg[] = {
 /**
  * Host <-> LPU mailbox command/status registers
  */
-static struct { uint32_t hfn, lpu; } iocreg_mbcmd[] = {
+static struct { u32 hfn, lpu; } iocreg_mbcmd[] = {
 	{ HOSTFN0_LPU0_CMD_STAT, LPU0_HOSTFN0_CMD_STAT },
 	{ HOSTFN1_LPU1_CMD_STAT, LPU1_HOSTFN1_CMD_STAT }
 };
@@ -192,7 +192,7 @@ static bfa_status_t
 bfa_ioc_cb_pll_init(struct bfa_ioc_s *ioc)
 {
 	bfa_os_addr_t	rb = ioc->pcidev.pci_bar_kva;
-	uint32_t	pll_sclk, pll_fclk;
+	u32	pll_sclk, pll_fclk;
 
 	/*
 	 *  Hold semaphore so that nobody can access the chip during init.
diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index 639aa5e..23c39e6 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -33,9 +33,9 @@ BFA_TRC_FILE(CNA, IOC_CT);
 static bfa_status_t bfa_ioc_ct_pll_init(struct bfa_ioc_s *ioc);
 static bfa_boolean_t bfa_ioc_ct_firmware_lock(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_firmware_unlock(struct bfa_ioc_s *ioc);
-static uint32_t * bfa_ioc_ct_fwimg_get_chunk(struct bfa_ioc_s *ioc,
-					uint32_t off);
-static uint32_t bfa_ioc_ct_fwimg_get_size(struct bfa_ioc_s *ioc);
+static u32 * bfa_ioc_ct_fwimg_get_chunk(struct bfa_ioc_s *ioc,
+					u32 off);
+static u32 bfa_ioc_ct_fwimg_get_size(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_reg_init(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_map_port(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix);
@@ -64,13 +64,13 @@ bfa_ioc_set_ct_hwif(struct bfa_ioc_s *ioc)
 	ioc->ioc_hwif = &hwif_ct;
 }
 
-static uint32_t *
-bfa_ioc_ct_fwimg_get_chunk(struct bfa_ioc_s *ioc, uint32_t off)
+static u32 *
+bfa_ioc_ct_fwimg_get_chunk(struct bfa_ioc_s *ioc, u32 off)
 {
 	return bfi_image_ct_get_chunk(off);
 }
 
-static uint32_t
+static u32
 bfa_ioc_ct_fwimg_get_size(struct bfa_ioc_s *ioc)
 {
 	return bfi_image_ct_size;
@@ -83,7 +83,7 @@ static bfa_boolean_t
 bfa_ioc_ct_firmware_lock(struct bfa_ioc_s *ioc)
 {
 	enum bfi_ioc_state ioc_fwstate;
-	uint32_t usecnt;
+	u32 usecnt;
 	struct bfi_ioc_image_hdr_s fwhdr;
 
 	/**
@@ -143,7 +143,7 @@ bfa_ioc_ct_firmware_lock(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_ct_firmware_unlock(struct bfa_ioc_s *ioc)
 {
-	uint32_t usecnt;
+	u32 usecnt;
 
 	/**
 	 * Firmware lock is relevant only for CNA.
@@ -185,7 +185,7 @@ bfa_ioc_ct_notify_hbfail(struct bfa_ioc_s *ioc)
 /**
  * Host to LPU mailbox message addresses
  */
-static struct { uint32_t hfn_mbox, lpu_mbox, hfn_pgn; } iocreg_fnreg[] = {
+static struct { u32 hfn_mbox, lpu_mbox, hfn_pgn; } iocreg_fnreg[] = {
 	{ HOSTFN0_LPU_MBOX0_0, LPU_HOSTFN0_MBOX0_0, HOST_PAGE_NUM_FN0 },
 	{ HOSTFN1_LPU_MBOX0_8, LPU_HOSTFN1_MBOX0_8, HOST_PAGE_NUM_FN1 },
 	{ HOSTFN2_LPU_MBOX0_0, LPU_HOSTFN2_MBOX0_0, HOST_PAGE_NUM_FN2 },
@@ -195,7 +195,7 @@ static struct { uint32_t hfn_mbox, lpu_mbox, hfn_pgn; } iocreg_fnreg[] = {
 /**
  * Host <-> LPU mailbox command/status registers - port 0
  */
-static struct { uint32_t hfn, lpu; } iocreg_mbcmd_p0[] = {
+static struct { u32 hfn, lpu; } iocreg_mbcmd_p0[] = {
 	{ HOSTFN0_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN0_MBOX0_CMD_STAT },
 	{ HOSTFN1_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN1_MBOX0_CMD_STAT },
 	{ HOSTFN2_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN2_MBOX0_CMD_STAT },
@@ -205,7 +205,7 @@ static struct { uint32_t hfn, lpu; } iocreg_mbcmd_p0[] = {
 /**
  * Host <-> LPU mailbox command/status registers - port 1
  */
-static struct { uint32_t hfn, lpu; } iocreg_mbcmd_p1[] = {
+static struct { u32 hfn, lpu; } iocreg_mbcmd_p1[] = {
 	{ HOSTFN0_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN0_MBOX0_CMD_STAT },
 	{ HOSTFN1_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN1_MBOX0_CMD_STAT },
 	{ HOSTFN2_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN2_MBOX0_CMD_STAT },
@@ -275,7 +275,7 @@ static void
 bfa_ioc_ct_map_port(struct bfa_ioc_s *ioc)
 {
 	bfa_os_addr_t	rb = ioc->pcidev.pci_bar_kva;
-	uint32_t	r32;
+	u32	r32;
 
 	/**
 	 * For catapult, base port id on personality register and IOC type
@@ -295,7 +295,7 @@ static void
 bfa_ioc_ct_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix)
 {
 	bfa_os_addr_t	rb = ioc->pcidev.pci_bar_kva;
-	uint32_t	r32, mode;
+	u32	r32, mode;
 
 	r32 = bfa_reg_read(rb + FNC_PERS_REG);
 	bfa_trc(ioc, r32);
@@ -325,7 +325,7 @@ static bfa_status_t
 bfa_ioc_ct_pll_init(struct bfa_ioc_s *ioc)
 {
 	bfa_os_addr_t	rb = ioc->pcidev.pci_bar_kva;
-	uint32_t	pll_sclk, pll_fclk, r32;
+	u32	pll_sclk, pll_fclk, r32;
 
 	/*
 	 *  Hold semaphore so that nobody can access the chip during init.
diff --git a/drivers/scsi/bfa/bfad_attr.h b/drivers/scsi/bfa/bfad_attr.h
index 4d3312d..bf01020 100644
--- a/drivers/scsi/bfa/bfad_attr.h
+++ b/drivers/scsi/bfa/bfad_attr.h
@@ -17,9 +17,6 @@
 
 #ifndef __BFAD_ATTR_H__
 #define __BFAD_ATTR_H__
-/**
- *  bfad_attr.h VMware driver configuration interface module.
- */
 
 /**
  *  FC_transport_template FC transport template
@@ -52,12 +49,6 @@ bfad_im_get_starget_port_name(struct scsi_target *starget);
 void
 bfad_im_get_host_port_id(struct Scsi_Host *shost);
 
-/**
- * FC transport template entry, issue a LIP.
- */
-int
-bfad_im_issue_fc_host_lip(struct Scsi_Host *shost);
-
 struct Scsi_Host*
 bfad_os_starget_to_shost(struct scsi_target *starget);
 
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index d9390e5..107848c 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -196,11 +196,6 @@ struct bfad_s {
 	bfa_boolean_t	ipfc_enabled;
 	union bfad_tmp_buf tmp_buf;
 	struct fc_host_statistics link_stats;
-
-	struct kobject *bfa_kobj;
-	struct kobject *ioc_kobj;
-	struct kobject *pport_kobj;
-	struct kobject *lport_kobj;
 };
 
 /*
@@ -286,11 +281,6 @@ void		bfad_drv_uninit(struct bfad_s *bfad);
 void		bfad_drv_log_level_set(struct bfad_s *bfad);
 bfa_status_t	bfad_fc4_module_init(void);
 void		bfad_fc4_module_exit(void);
-
-bfa_status_t	bfad_os_kthread_create(struct bfad_s *bfad);
-void		bfad_os_kthread_stop(struct bfad_s *bfad);
-void		bfad_os_kthread_wakeup(struct bfad_s *bfad);
-int		bfad_os_kthread_should_stop(void);
 int		bfad_worker (void *ptr);
 
 void bfad_pci_remove(struct pci_dev *pdev);
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index fb7aefa..f9fc67a 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -509,16 +509,6 @@ void bfa_fcb_itnim_tov(struct bfad_itnim_s *itnim)
 }
 
 /**
- * Path TOV processing begin notification -- dummy for linux
- */
-void
-bfa_fcb_itnim_tov_begin(struct bfad_itnim_s *itnim)
-{
-}
-
-
-
-/**
  * Allocate a Scsi_Host for a port.
  */
 int
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index 189a5b2..85ab2da 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -23,7 +23,6 @@
 
 #define FCPI_NAME " fcpim"
 
-void bfad_flags_set(struct bfad_s *bfad, u32 flags);
 bfa_status_t bfad_im_module_init(void);
 void bfad_im_module_exit(void);
 bfa_status_t bfad_im_probe(struct bfad_s *bfad);
@@ -126,7 +125,6 @@ bfa_status_t bfad_os_thread_workq(struct bfad_s *bfad);
 void bfad_os_destroy_workq(struct bfad_im_s *im);
 void bfad_os_itnim_process(struct bfad_itnim_s *itnim_drv);
 void bfad_os_fc_host_init(struct bfad_im_port_s *im_port);
-void bfad_os_init_work(struct bfad_im_port_s *im_port);
 void bfad_os_scsi_host_free(struct bfad_s *bfad,
 				 struct bfad_im_port_s *im_port);
 void bfad_os_ramp_up_qdepth(struct bfad_itnim_s *itnim,
@@ -136,9 +134,6 @@ struct bfad_itnim_s *bfad_os_get_itnim(struct bfad_im_port_s *im_port, int id);
 int bfad_os_scsi_add_host(struct Scsi_Host *shost,
 		struct bfad_im_port_s *im_port, struct bfad_s *bfad);
 
-/*
- * scsi_host_template entries
- */
 void bfad_im_itnim_unmap(struct bfad_im_port_s  *im_port,
 			 struct bfad_itnim_s *itnim);
 
diff --git a/drivers/scsi/bfa/fcpim.c b/drivers/scsi/bfa/fcpim.c
index ef50ec2..8ae4a2c 100644
--- a/drivers/scsi/bfa/fcpim.c
+++ b/drivers/scsi/bfa/fcpim.c
@@ -678,7 +678,6 @@ bfa_cb_itnim_tov_begin(void *cb_arg)
 	struct bfa_fcs_itnim_s *itnim = (struct bfa_fcs_itnim_s *)cb_arg;
 
 	bfa_trc(itnim->fcs, itnim->rport->pwwn);
-	bfa_fcb_itnim_tov_begin(itnim->itnim_drv);
 }
 
 /**
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_driver.h b/drivers/scsi/bfa/include/defs/bfa_defs_driver.h
index 5704980..50382dd 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_driver.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_driver.h
@@ -21,6 +21,7 @@
 /**
  * Driver statistics
  */
+struct bfa_driver_stats_s {
 	u16    tm_io_abort;
     u16    tm_io_abort_comp;
     u16    tm_lun_reset;
@@ -34,7 +35,7 @@
     u64    output_req;
     u64    input_words;
     u64    output_words;
-} bfa_driver_stats_t;
+};
 
 
 #endif /* __BFA_DEFS_DRIVER_H__ */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_im_common.h b/drivers/scsi/bfa/include/defs/bfa_defs_im_common.h
deleted file mode 100644
index 9ccf53b..0000000
--- a/drivers/scsi/bfa/include/defs/bfa_defs_im_common.h
+++ /dev/null
@@ -1,32 +0,0 @@
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
-#ifndef __BFA_DEFS_IM_COMMON_H__
-#define __BFA_DEFS_IM_COMMON_H__
-
-#define	BFA_ADAPTER_NAME_LEN	256
-#define BFA_ADAPTER_GUID_LEN    256
-#define RESERVED_VLAN_NAME      L"PORT VLAN"
-#define PASSTHRU_VLAN_NAME      L"PASSTHRU VLAN"
-
-	u64	tx_pkt_cnt;
-	u64	rx_pkt_cnt;
-	u32	duration;
-	u8		status;
-} bfa_im_stats_t, *pbfa_im_stats_t;
-
-#endif /* __BFA_DEFS_IM_COMMON_H__ */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_im_team.h b/drivers/scsi/bfa/include/defs/bfa_defs_im_team.h
deleted file mode 100644
index a486a7e..0000000
--- a/drivers/scsi/bfa/include/defs/bfa_defs_im_team.h
+++ /dev/null
@@ -1,72 +0,0 @@
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
-#ifndef __BFA_DEFS_IM_TEAM_H__
-#define __BFA_DEFS_IM_TEAM_H__
-
-#include <protocol/types.h>
-
-#define	BFA_TEAM_MAX_PORTS	8
-#define	BFA_TEAM_NAME_LEN	256
-#define BFA_MAX_NUM_TEAMS	16
-#define BFA_TEAM_INVALID_DELAY -1
-
-	BFA_LACP_RATE_SLOW = 1,
-	BFA_LACP_RATE_FAST
-} bfa_im_lacp_rate_t;
-
-	BFA_TEAM_MODE_FAIL_OVER = 1,
-	BFA_TEAM_MODE_FAIL_BACK,
-	BFA_TEAM_MODE_LACP,
-	BFA_TEAM_MODE_NONE
-} bfa_im_team_mode_t;
-
-	BFA_XMIT_POLICY_L2 = 1,
-	BFA_XMIT_POLICY_L3_L4
-} bfa_im_xmit_policy_t;
-
-	bfa_im_team_mode_t     team_mode;
-	bfa_im_lacp_rate_t     lacp_rate;
-	bfa_im_xmit_policy_t   xmit_policy;
-	int   	          delay;
-	wchar_t    	  primary[BFA_ADAPTER_NAME_LEN];
-	wchar_t        	  preferred_primary[BFA_ADAPTER_NAME_LEN];
-	mac_t	          mac;
-	u16       	  num_ports;
-	u16          num_vlans;
-	u16 vlan_list[BFA_MAX_VLANS_PER_PORT];
-	wchar_t	 team_guid_list[BFA_TEAM_MAX_PORTS][BFA_ADAPTER_GUID_LEN];
-	wchar_t	 ioc_name_list[BFA_TEAM_MAX_PORTS][BFA_ADAPTER_NAME_LEN];
-} bfa_im_team_attr_t;
-
-	wchar_t		             team_name[BFA_TEAM_NAME_LEN];
-	bfa_im_xmit_policy_t	 xmit_policy;
-	int                 	 delay;
-	wchar_t                	 primary[BFA_ADAPTER_NAME_LEN];
-	wchar_t               	 preferred_primary[BFA_ADAPTER_NAME_LEN];
-} bfa_im_team_edit_t, *pbfa_im_team_edit_t;
-
-	wchar_t					team_name[BFA_TEAM_NAME_LEN];
-	bfa_im_team_mode_t      team_mode;
-	mac_t	               	mac;
-} bfa_im_team_info_t;
-
-	bfa_im_team_info_t 		team_info[BFA_MAX_NUM_TEAMS];
-	u16 				num_teams;
-} bfa_im_team_list_t, *pbfa_im_team_list_t;
-
-#endif /* __BFA_DEFS_IM_TEAM_H__ */
diff --git a/drivers/scsi/bfa/include/fcb/bfa_fcb_fcpim.h b/drivers/scsi/bfa/include/fcb/bfa_fcb_fcpim.h
index a6c70ae..52585d3 100644
--- a/drivers/scsi/bfa/include/fcb/bfa_fcb_fcpim.h
+++ b/drivers/scsi/bfa/include/fcb/bfa_fcb_fcpim.h
@@ -70,7 +70,6 @@ void            bfa_fcb_itnim_online(struct bfad_itnim_s *itnim_drv);
  */
 void            bfa_fcb_itnim_offline(struct bfad_itnim_s *itnim_drv);
 
-void            bfa_fcb_itnim_tov_begin(struct bfad_itnim_s *itnim_drv);
 void            bfa_fcb_itnim_tov(struct bfad_itnim_s *itnim_drv);
 
 #endif /* __BFAD_FCB_FCPIM_H__ */
diff --git a/drivers/scsi/bfa/include/protocol/pcifw.h b/drivers/scsi/bfa/include/protocol/pcifw.h
deleted file mode 100644
index 6830dc3..0000000
--- a/drivers/scsi/bfa/include/protocol/pcifw.h
+++ /dev/null
@@ -1,75 +0,0 @@
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
- *  pcifw.h PCI FW related headers
- */
-
-#ifndef __PCIFW_H__
-#define __PCIFW_H__
-
-#pragma pack(1)
-
-struct pnp_hdr_s{
-  u32	signature;	/* "$PnP" */
-  u8	rev;		/* Struct revision */
-  u8 	len;		/* Header structure len in multiples
-				 * of 16 bytes */
-  u16  off;		/* Offset to next header 00 if none */
-  u8	rsvd;		/* Reserved byte */
-  u8	cksum;		/* 8-bit checksum for this header */
-  u32	pnp_dev_id;	/* PnP Device Id */
-  u16  mfstr;		/* Pointer to manufacturer string */
-  u16	prstr;		/* Pointer to product string */
-  u8	devtype[3];	/* Device Type Code */
-  u8	devind;		/* Device Indicator */
-  u16	bcventr;	/* Bootstrap entry vector */
-  u16	rsvd2;		/* Reserved */
-  u16  sriv;		/* Static resource information vector */
-};
-
-struct pci_3_0_ds_s{
- u32	sig;   		/* Signature "PCIR" */
- u16	vendid;		/* Vendor ID */
- u16	devid;		/* Device ID */
- u16	devlistoff;	/* Device List Offset */
- u16	len;		/* PCI Data Structure Length */
- u8	rev;		/* PCI Data Structure Revision */
- u8	clcode[3];	/* Class Code */
- u16	imglen;		/* Code image length in multiples of
-				 * 512 bytes */
- u16	coderev;	/* Revision level of code/data */
- u8	codetype;	/* Code type 0x00 - BIOS */
- u8	indr;		/* Last image indicator */
- u16	mrtimglen;	/* Max Run Time Image Length */
- u16	cuoff;		/* Config Utility Code Header Offset */
- u16	dmtfclp;	/* DMTF CLP entry point offset */
-};
-
-struct pci_optrom_hdr_s{
- u16	sig;		/* Signature 0x55AA */
- u8	len;		/* Option ROM length in units of 512 bytes */
- u8	inivec[3];	/* Initialization vector */
- u8	rsvd[16];	/* Reserved field */
- u16	verptr;		/* Pointer to version string - private */
- u16	pcids;		/* Pointer to PCI data structure */
- u16	pnphdr;		/* Pointer to PnP expansion header */
-};
-
-#pragma pack()
-
-#endif
-- 
1.6.5.3


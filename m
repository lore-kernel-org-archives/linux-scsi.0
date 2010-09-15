From: <kgudipat@brocade.com>
Subject: [PATCH 12/33] bfa: (Cleanup Patch) BFA FCS header file consolidation / cleanup.
Date: Wed, 15 Sep 2010 12:05:10 -0700
Message-ID: <1284577510-17953-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:57210 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753453Ab0IOTGN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2010 15:06:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- This patch is part of the BFA cleanup.
	- All BFA FCS header files will be merged into bfa_fcs.h in the subsequent patch.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/fcs.h        |   30 ----------
 drivers/scsi/bfa/fcs_auth.h   |   37 -------------
 drivers/scsi/bfa/fcs_fabric.h |   68 -----------------------
 drivers/scsi/bfa/fcs_fcpim.h  |   39 -------------
 drivers/scsi/bfa/fcs_fcptm.h  |   45 ----------------
 drivers/scsi/bfa/fcs_fcxp.h   |   29 ----------
 drivers/scsi/bfa/fcs_lport.h  |  118 -----------------------------------------
 drivers/scsi/bfa/fcs_ms.h     |   35 ------------
 drivers/scsi/bfa/fcs_port.h   |   31 -----------
 drivers/scsi/bfa/fcs_rport.h  |   61 ---------------------
 drivers/scsi/bfa/fcs_trcmod.h |   56 -------------------
 drivers/scsi/bfa/fcs_uf.h     |   31 -----------
 drivers/scsi/bfa/fcs_vport.h  |   32 -----------
 drivers/scsi/bfa/lport_priv.h |   82 ----------------------------
 14 files changed, 0 insertions(+), 694 deletions(-)
 delete mode 100644 drivers/scsi/bfa/fcs.h
 delete mode 100644 drivers/scsi/bfa/fcs_auth.h
 delete mode 100644 drivers/scsi/bfa/fcs_fabric.h
 delete mode 100644 drivers/scsi/bfa/fcs_fcpim.h
 delete mode 100644 drivers/scsi/bfa/fcs_fcptm.h
 delete mode 100644 drivers/scsi/bfa/fcs_fcxp.h
 delete mode 100644 drivers/scsi/bfa/fcs_lport.h
 delete mode 100644 drivers/scsi/bfa/fcs_ms.h
 delete mode 100644 drivers/scsi/bfa/fcs_port.h
 delete mode 100644 drivers/scsi/bfa/fcs_rport.h
 delete mode 100644 drivers/scsi/bfa/fcs_trcmod.h
 delete mode 100644 drivers/scsi/bfa/fcs_uf.h
 delete mode 100644 drivers/scsi/bfa/fcs_vport.h
 delete mode 100644 drivers/scsi/bfa/lport_priv.h

diff --git a/drivers/scsi/bfa/fcs.h b/drivers/scsi/bfa/fcs.h
deleted file mode 100644
index 8d08230..0000000
--- a/drivers/scsi/bfa/fcs.h
+++ /dev/null
@@ -1,30 +0,0 @@
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
- *  fcs.h FCS module functions
- */
-
-
-#ifndef __FCS_H__
-#define __FCS_H__
-
-#define __fcs_min_cfg(__fcs)       ((__fcs)->min_cfg)
-
-void bfa_fcs_modexit_comp(struct bfa_fcs_s *fcs);
-
-#endif /* __FCS_H__ */
diff --git a/drivers/scsi/bfa/fcs_auth.h b/drivers/scsi/bfa/fcs_auth.h
deleted file mode 100644
index 65d155f..0000000
--- a/drivers/scsi/bfa/fcs_auth.h
+++ /dev/null
@@ -1,37 +0,0 @@
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
- *  fcs_uf.h FCS unsolicited frame receive
- */
-
-
-#ifndef __FCS_AUTH_H__
-#define __FCS_AUTH_H__
-
-#include <fcs/bfa_fcs.h>
-#include <fcs/bfa_fcs_vport.h>
-#include <fcs/bfa_fcs_lport.h>
-
-/*
- * fcs friend functions: only between fcs modules
- */
-void bfa_fcs_auth_uf_recv(struct bfa_fcs_fabric_s *fabric, int len);
-void bfa_fcs_auth_start(struct bfa_fcs_fabric_s *fabric);
-void bfa_fcs_auth_stop(struct bfa_fcs_fabric_s *fabric);
-
-#endif /* __FCS_UF_H__ */
diff --git a/drivers/scsi/bfa/fcs_fabric.h b/drivers/scsi/bfa/fcs_fabric.h
deleted file mode 100644
index 432ab8a..0000000
--- a/drivers/scsi/bfa/fcs_fabric.h
+++ /dev/null
@@ -1,68 +0,0 @@
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
- *  fcs_lport.h FCS logical port interfaces
- */
-
-#ifndef __FCS_FABRIC_H__
-#define __FCS_FABRIC_H__
-
-#include <fcs/bfa_fcs.h>
-#include <fcs/bfa_fcs_vport.h>
-#include <fcs/bfa_fcs_lport.h>
-
-#define BFA_FCS_BRCD_SWITCH_OUI  0x051e
-
-/*
-* fcs friend functions: only between fcs modules
- */
-void		bfa_fcs_fabric_attach(struct bfa_fcs_s *fcs);
-void            bfa_fcs_fabric_modinit(struct bfa_fcs_s *fcs);
-void            bfa_fcs_fabric_modexit(struct bfa_fcs_s *fcs);
-void            bfa_fcs_fabric_modsusp(struct bfa_fcs_s *fcs);
-void            bfa_fcs_fabric_link_up(struct bfa_fcs_fabric_s *fabric);
-void            bfa_fcs_fabric_link_down(struct bfa_fcs_fabric_s *fabric);
-void            bfa_fcs_fabric_addvport(struct bfa_fcs_fabric_s *fabric,
-					struct bfa_fcs_vport_s *vport);
-void            bfa_fcs_fabric_delvport(struct bfa_fcs_fabric_s *fabric,
-					struct bfa_fcs_vport_s *vport);
-int             bfa_fcs_fabric_is_online(struct bfa_fcs_fabric_s *fabric);
-struct bfa_fcs_vport_s *bfa_fcs_fabric_vport_lookup(
-			struct bfa_fcs_fabric_s *fabric, wwn_t pwwn);
-void            bfa_fcs_fabric_modstart(struct bfa_fcs_s *fcs);
-void            bfa_fcs_fabric_uf_recv(struct bfa_fcs_fabric_s *fabric,
-			struct fchs_s *fchs, u16 len);
-u16        bfa_fcs_fabric_vport_count(struct bfa_fcs_fabric_s *fabric);
-bfa_boolean_t   bfa_fcs_fabric_is_loopback(struct bfa_fcs_fabric_s *fabric);
-bfa_boolean_t	bfa_fcs_fabric_is_auth_failed(struct bfa_fcs_fabric_s *fabric);
-enum bfa_pport_type bfa_fcs_fabric_port_type(struct bfa_fcs_fabric_s *fabric);
-void     	bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric);
-void bfa_fcs_fabric_port_delete_comp(struct bfa_fcs_fabric_s *fabric);
-
-bfa_status_t bfa_fcs_fabric_addvf(struct bfa_fcs_fabric_s *vf,
-			struct bfa_fcs_s *fcs, struct bfa_port_cfg_s *port_cfg,
-			struct bfad_vf_s *vf_drv);
-void bfa_fcs_auth_finished(struct bfa_fcs_fabric_s *fabric,
-			enum auth_status status);
-
-void bfa_fcs_fabric_set_fabric_name(struct bfa_fcs_fabric_s *fabric,
-			wwn_t fabric_name);
-u16 bfa_fcs_fabric_get_switch_oui(struct bfa_fcs_fabric_s *fabric);
-void bfa_fcs_get_sym_name(const struct bfa_fcs_s *fcs, char *node_symname);
-
-#endif /* __FCS_FABRIC_H__ */
diff --git a/drivers/scsi/bfa/fcs_fcpim.h b/drivers/scsi/bfa/fcs_fcpim.h
deleted file mode 100644
index 11e6e7b..0000000
--- a/drivers/scsi/bfa/fcs_fcpim.h
+++ /dev/null
@@ -1,39 +0,0 @@
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
-#ifndef __FCS_FCPIM_H__
-#define __FCS_FCPIM_H__
-
-#include <defs/bfa_defs_port.h>
-#include <fcs/bfa_fcs_lport.h>
-#include <fcs/bfa_fcs_rport.h>
-
-/*
- * Following routines are from FCPIM and will be called by rport.
- */
-struct bfa_fcs_itnim_s *bfa_fcs_itnim_create(struct bfa_fcs_rport_s *rport);
-void bfa_fcs_itnim_delete(struct bfa_fcs_itnim_s *itnim);
-void bfa_fcs_itnim_rport_offline(struct bfa_fcs_itnim_s *itnim);
-void bfa_fcs_itnim_rport_online(struct bfa_fcs_itnim_s *itnim);
-bfa_status_t bfa_fcs_itnim_get_online_state(struct bfa_fcs_itnim_s *itnim);
-
-void bfa_fcs_itnim_is_initiator(struct bfa_fcs_itnim_s *itnim);
-void bfa_fcs_itnim_pause(struct bfa_fcs_itnim_s *itnim);
-void bfa_fcs_itnim_resume(struct bfa_fcs_itnim_s *itnim);
-
-void bfa_fcs_fcpim_uf_recv(struct bfa_fcs_itnim_s *itnim, struct fchs_s *fchs,
-			u16 len);
-#endif /* __FCS_FCPIM_H__ */
diff --git a/drivers/scsi/bfa/fcs_fcptm.h b/drivers/scsi/bfa/fcs_fcptm.h
deleted file mode 100644
index ffff082..0000000
--- a/drivers/scsi/bfa/fcs_fcptm.h
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
-#ifndef __FCS_FCPTM_H__
-#define __FCS_FCPTM_H__
-
-#include <defs/bfa_defs_port.h>
-#include <fcs/bfa_fcs_lport.h>
-#include <fcs/bfa_fcs_rport.h>
-
-/*
- * Following routines are from FCPTM and will be called by rport.
- */
-struct bfa_fcs_tin_s *bfa_fcs_tin_create(struct bfa_fcs_rport_s *rport);
-void bfa_fcs_tin_rport_offline(struct bfa_fcs_tin_s *tin);
-void bfa_fcs_tin_rport_online(struct bfa_fcs_tin_s *tin);
-void bfa_fcs_tin_delete(struct bfa_fcs_tin_s *tin);
-void bfa_fcs_tin_rx_prli(struct bfa_fcs_tin_s *tin, struct fchs_s *fchs,
-			u16 len);
-void bfa_fcs_tin_pause(struct bfa_fcs_tin_s *tin);
-void bfa_fcs_tin_resume(struct bfa_fcs_tin_s *tin);
-
-/*
- * Modudle init/cleanup routines.
- */
-void bfa_fcs_fcptm_modinit(struct bfa_fcs_s *fcs);
-void bfa_fcs_fcptm_modexit(struct bfa_fcs_s *fcs);
-void bfa_fcs_fcptm_uf_recv(struct bfa_fcs_tin_s *tin, struct fchs_s *fchs,
-			u16 len);
-
-#endif /* __FCS_FCPTM_H__ */
diff --git a/drivers/scsi/bfa/fcs_fcxp.h b/drivers/scsi/bfa/fcs_fcxp.h
deleted file mode 100644
index 8277fe9..0000000
--- a/drivers/scsi/bfa/fcs_fcxp.h
+++ /dev/null
@@ -1,29 +0,0 @@
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
- *  fcs_fcxp.h FCXP helper macros for FCS
- */
-
-
-#ifndef __FCS_FCXP_H__
-#define __FCS_FCXP_H__
-
-#define bfa_fcs_fcxp_alloc(__fcs)	\
-	bfa_fcxp_alloc(NULL, (__fcs)->bfa, 0, 0, NULL, NULL, NULL, NULL)
-
-#endif /* __FCS_FCXP_H__ */
diff --git a/drivers/scsi/bfa/fcs_lport.h b/drivers/scsi/bfa/fcs_lport.h
deleted file mode 100644
index a6508c8..0000000
--- a/drivers/scsi/bfa/fcs_lport.h
+++ /dev/null
@@ -1,118 +0,0 @@
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
- *  fcs_lport.h FCS logical port interfaces
- */
-
-#ifndef __FCS_LPORT_H__
-#define __FCS_LPORT_H__
-
-#define __VPORT_H__
-#include <defs/bfa_defs_port.h>
-#include <bfa_svc.h>
-#include <fcs/bfa_fcs_lport.h>
-#include <fcs/bfa_fcs_rport.h>
-#include <fcs/bfa_fcs_vport.h>
-#include <fcs_fabric.h>
-#include <fcs_ms.h>
-#include <cs/bfa_q.h>
-#include <fcbuild.h>
-
-/*
- * PID used in P2P/N2N ( In Big Endian)
- */
-#define N2N_LOCAL_PID	    0x010000
-#define N2N_REMOTE_PID		0x020000
-
-/*
- * Misc Timeouts
- */
-/*
- * To be used when spawning a timer before retrying a failed command. Milli
- * Secs.
- */
-#define	BFA_FCS_RETRY_TIMEOUT 2000
-
-/*
- * Check for Port/Vport Mode/Role
- */
-#define	BFA_FCS_VPORT_IS_INITIATOR_MODE(port) \
-		(port->port_cfg.roles & BFA_PORT_ROLE_FCP_IM)
-
-#define	BFA_FCS_VPORT_IS_TARGET_MODE(port) \
-		(port->port_cfg.roles & BFA_PORT_ROLE_FCP_TM)
-
-#define	BFA_FCS_VPORT_IS_IPFC_MODE(port) \
-		(port->port_cfg.roles & BFA_PORT_ROLE_FCP_IPFC)
-
-/*
- * Is this a Well Known Address
- */
-#define BFA_FCS_PID_IS_WKA(pid)  ((bfa_os_ntoh3b(pid) > 0xFFF000) ?  1 : 0)
-
-/*
- * Pointer to elements within Port
- */
-#define BFA_FCS_GET_HAL_FROM_PORT(port)  (port->fcs->bfa)
-#define BFA_FCS_GET_NS_FROM_PORT(port)  (&port->port_topo.pfab.ns)
-#define BFA_FCS_GET_SCN_FROM_PORT(port)  (&port->port_topo.pfab.scn)
-#define BFA_FCS_GET_MS_FROM_PORT(port)  (&port->port_topo.pfab.ms)
-#define BFA_FCS_GET_FDMI_FROM_PORT(port)  (&port->port_topo.pfab.ms.fdmi)
-
-/*
- * handler for unsolicied frames
- */
-void bfa_fcs_port_uf_recv(struct bfa_fcs_port_s *lport, struct fchs_s *fchs,
-			u16 len);
-
-/*
- * Following routines will be called by Fabric to indicate port
- * online/offline to vport.
- */
-void bfa_fcs_lport_attach(struct bfa_fcs_port_s *lport, struct bfa_fcs_s *fcs,
-			uint16_t vf_id, struct bfa_fcs_vport_s *vport);
-void bfa_fcs_lport_init(struct bfa_fcs_port_s *lport,
-			struct bfa_port_cfg_s *port_cfg);
-void bfa_fcs_port_online(struct bfa_fcs_port_s *port);
-void bfa_fcs_port_offline(struct bfa_fcs_port_s *port);
-void bfa_fcs_port_delete(struct bfa_fcs_port_s *port);
-bfa_boolean_t   bfa_fcs_port_is_online(struct bfa_fcs_port_s *port);
-
-/*
- * Lookup rport based on PID
- */
-struct bfa_fcs_rport_s *bfa_fcs_port_get_rport_by_pid(
-			struct bfa_fcs_port_s *port, u32 pid);
-
-/*
- * Lookup rport based on PWWN
- */
-struct bfa_fcs_rport_s *bfa_fcs_port_get_rport_by_pwwn(
-			struct bfa_fcs_port_s *port, wwn_t pwwn);
-struct bfa_fcs_rport_s *bfa_fcs_port_get_rport_by_nwwn(
-			struct bfa_fcs_port_s *port, wwn_t nwwn);
-void bfa_fcs_port_add_rport(struct bfa_fcs_port_s *port,
-			struct bfa_fcs_rport_s *rport);
-void bfa_fcs_port_del_rport(struct bfa_fcs_port_s *port,
-			struct bfa_fcs_rport_s *rport);
-
-void bfa_fcs_port_modinit(struct bfa_fcs_s *fcs);
-void bfa_fcs_port_modexit(struct bfa_fcs_s *fcs);
-void bfa_fcs_port_lip(struct bfa_fcs_port_s *port);
-
-#endif /* __FCS_LPORT_H__ */
diff --git a/drivers/scsi/bfa/fcs_ms.h b/drivers/scsi/bfa/fcs_ms.h
deleted file mode 100644
index b6a8c12..0000000
--- a/drivers/scsi/bfa/fcs_ms.h
+++ /dev/null
@@ -1,35 +0,0 @@
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
- *  fcs_ms.h FCS ms interfaces
- */
-#ifndef __FCS_MS_H__
-#define __FCS_MS_H__
-
-/* MS FCS routines */
-void bfa_fcs_port_ms_init(struct bfa_fcs_port_s *port);
-void bfa_fcs_port_ms_offline(struct bfa_fcs_port_s *port);
-void bfa_fcs_port_ms_online(struct bfa_fcs_port_s *port);
-void bfa_fcs_port_ms_fabric_rscn(struct bfa_fcs_port_s *port);
-
-/* FDMI FCS routines */
-void bfa_fcs_port_fdmi_init(struct bfa_fcs_port_ms_s *ms);
-void bfa_fcs_port_fdmi_offline(struct bfa_fcs_port_ms_s *ms);
-void bfa_fcs_port_fdmi_online(struct bfa_fcs_port_ms_s *ms);
-
-#endif
diff --git a/drivers/scsi/bfa/fcs_port.h b/drivers/scsi/bfa/fcs_port.h
deleted file mode 100644
index 408c06a..0000000
--- a/drivers/scsi/bfa/fcs_port.h
+++ /dev/null
@@ -1,31 +0,0 @@
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
- *  fcs_pport.h FCS physical port interfaces
- */
-
-
-#ifndef __FCS_PPORT_H__
-#define __FCS_PPORT_H__
-
-/*
- * fcs friend functions: only between fcs modules
- */
-void bfa_fcs_pport_attach(struct bfa_fcs_s *fcs);
-
-#endif /* __FCS_PPORT_H__ */
diff --git a/drivers/scsi/bfa/fcs_rport.h b/drivers/scsi/bfa/fcs_rport.h
deleted file mode 100644
index e634fb7..0000000
--- a/drivers/scsi/bfa/fcs_rport.h
+++ /dev/null
@@ -1,61 +0,0 @@
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
- *  fcs_rport.h FCS rport interfaces and defines
- */
-
-#ifndef __FCS_RPORT_H__
-#define __FCS_RPORT_H__
-
-#include <fcs/bfa_fcs_rport.h>
-
-#define BFA_FCS_RPORT_MAX_RETRIES               (5)
-
-void bfa_fcs_rport_uf_recv(struct bfa_fcs_rport_s *rport, struct fchs_s *fchs,
-			u16 len);
-void bfa_fcs_rport_scn(struct bfa_fcs_rport_s *rport);
-
-struct bfa_fcs_rport_s *bfa_fcs_rport_create(struct bfa_fcs_port_s *port,
-			u32 pid);
-void bfa_fcs_rport_delete(struct bfa_fcs_rport_s *rport);
-void bfa_fcs_rport_online(struct bfa_fcs_rport_s *rport);
-void bfa_fcs_rport_offline(struct bfa_fcs_rport_s *rport);
-void bfa_fcs_rport_start(struct bfa_fcs_port_s *port, struct fchs_s *rx_fchs,
-			struct fc_logi_s *plogi_rsp);
-void bfa_fcs_rport_plogi_create(struct bfa_fcs_port_s *port,
-			struct fchs_s *rx_fchs,
-			struct fc_logi_s *plogi);
-void bfa_fcs_rport_plogi(struct bfa_fcs_rport_s *rport, struct fchs_s *fchs,
-			struct fc_logi_s *plogi);
-void bfa_fcs_rport_logo_imp(struct bfa_fcs_rport_s *rport);
-void bfa_fcs_rport_prlo(struct bfa_fcs_rport_s *rport, uint16_t ox_id);
-void bfa_fcs_rport_itnim_ack(struct bfa_fcs_rport_s *rport);
-void bfa_fcs_rport_itntm_ack(struct bfa_fcs_rport_s *rport);
-void bfa_fcs_rport_tin_ack(struct bfa_fcs_rport_s *rport);
-void bfa_fcs_rport_fcptm_offline_done(struct bfa_fcs_rport_s *rport);
-int  bfa_fcs_rport_get_state(struct bfa_fcs_rport_s *rport);
-struct bfa_fcs_rport_s *bfa_fcs_rport_create_by_wwn(struct bfa_fcs_port_s *port,
-			wwn_t wwn);
-
-
-/* Rport Features */
-void  bfa_fcs_rpf_init(struct bfa_fcs_rport_s *rport);
-void  bfa_fcs_rpf_rport_online(struct bfa_fcs_rport_s *rport);
-void  bfa_fcs_rpf_rport_offline(struct bfa_fcs_rport_s *rport);
-
-#endif /* __FCS_RPORT_H__ */
diff --git a/drivers/scsi/bfa/fcs_trcmod.h b/drivers/scsi/bfa/fcs_trcmod.h
deleted file mode 100644
index 41b5ae8..0000000
--- a/drivers/scsi/bfa/fcs_trcmod.h
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
-/**
- *  fcs_trcmod.h BFA FCS trace modules
- */
-
-#ifndef __FCS_TRCMOD_H__
-#define __FCS_TRCMOD_H__
-
-#include <cs/bfa_trc.h>
-
-/*
- * !!! Only append to the enums defined here to avoid any versioning
- * !!! needed between trace utility and driver version
- */
-enum {
-	BFA_TRC_FCS_FABRIC		= 1,
-	BFA_TRC_FCS_VFAPI		= 2,
-	BFA_TRC_FCS_PORT		= 3,
-	BFA_TRC_FCS_VPORT		= 4,
-	BFA_TRC_FCS_VP_API		= 5,
-	BFA_TRC_FCS_VPS			= 6,
-	BFA_TRC_FCS_RPORT		= 7,
-	BFA_TRC_FCS_FCPIM		= 8,
-	BFA_TRC_FCS_FCPTM		= 9,
-	BFA_TRC_FCS_NS			= 10,
-	BFA_TRC_FCS_SCN			= 11,
-	BFA_TRC_FCS_LOOP		= 12,
-	BFA_TRC_FCS_UF			= 13,
-	BFA_TRC_FCS_PPORT		= 14,
-	BFA_TRC_FCS_FCPIP		= 15,
-	BFA_TRC_FCS_PORT_API	= 16,
-	BFA_TRC_FCS_RPORT_API	= 17,
-	BFA_TRC_FCS_AUTH		= 18,
-	BFA_TRC_FCS_N2N			= 19,
-	BFA_TRC_FCS_MS			= 20,
-	BFA_TRC_FCS_FDMI		= 21,
-	BFA_TRC_FCS_RPORT_FTRS	= 22,
-};
-
-#endif /* __FCS_TRCMOD_H__ */
diff --git a/drivers/scsi/bfa/fcs_uf.h b/drivers/scsi/bfa/fcs_uf.h
deleted file mode 100644
index f591072..0000000
--- a/drivers/scsi/bfa/fcs_uf.h
+++ /dev/null
@@ -1,31 +0,0 @@
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
- *  fcs_uf.h FCS unsolicited frame receive
- */
-
-
-#ifndef __FCS_UF_H__
-#define __FCS_UF_H__
-
-/*
- * fcs friend functions: only between fcs modules
- */
-void bfa_fcs_uf_attach(struct bfa_fcs_s *fcs);
-
-#endif /* __FCS_UF_H__ */
diff --git a/drivers/scsi/bfa/fcs_vport.h b/drivers/scsi/bfa/fcs_vport.h
deleted file mode 100644
index bb647a4..0000000
--- a/drivers/scsi/bfa/fcs_vport.h
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
-#ifndef __FCS_VPORT_H__
-#define __FCS_VPORT_H__
-
-#include <fcs/bfa_fcs_lport.h>
-#include <fcs/bfa_fcs_vport.h>
-#include <defs/bfa_defs_pci.h>
-
-void bfa_fcs_vport_cleanup(struct bfa_fcs_vport_s *vport);
-void bfa_fcs_vport_online(struct bfa_fcs_vport_s *vport);
-void bfa_fcs_vport_offline(struct bfa_fcs_vport_s *vport);
-void bfa_fcs_vport_delete_comp(struct bfa_fcs_vport_s *vport);
-void bfa_fcs_vport_fcs_delete(struct bfa_fcs_vport_s *vport);
-
-#endif /* __FCS_VPORT_H__ */
-
diff --git a/drivers/scsi/bfa/lport_priv.h b/drivers/scsi/bfa/lport_priv.h
deleted file mode 100644
index dbae370..0000000
--- a/drivers/scsi/bfa/lport_priv.h
+++ /dev/null
@@ -1,82 +0,0 @@
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
-#ifndef __VP_PRIV_H__
-#define __VP_PRIV_H__
-
-#include <fcs/bfa_fcs_lport.h>
-#include <fcs/bfa_fcs_vport.h>
-
-/*
- * Functions exported by vps
- */
-void            bfa_fcs_vport_init(struct bfa_fcs_vport_s *vport);
-
-/*
- * Functions exported by vps
- */
-void            bfa_fcs_vps_online(struct bfa_fcs_port_s *port);
-void            bfa_fcs_vps_offline(struct bfa_fcs_port_s *port);
-void            bfa_fcs_vps_lip(struct bfa_fcs_port_s *port);
-
-/*
- * Functions exported by port_fab
- */
-void            bfa_fcs_port_fab_init(struct bfa_fcs_port_s *vport);
-void            bfa_fcs_port_fab_online(struct bfa_fcs_port_s *vport);
-void            bfa_fcs_port_fab_offline(struct bfa_fcs_port_s *vport);
-void            bfa_fcs_port_fab_rx_frame(struct bfa_fcs_port_s *port,
-					  u8 *rx_frame, u32 len);
-
-/*
- * Functions exported by VP-NS.
- */
-void            bfa_fcs_port_ns_init(struct bfa_fcs_port_s *vport);
-void            bfa_fcs_port_ns_offline(struct bfa_fcs_port_s *vport);
-void            bfa_fcs_port_ns_online(struct bfa_fcs_port_s *vport);
-void            bfa_fcs_port_ns_query(struct bfa_fcs_port_s *port);
-
-/*
- * Functions exported by VP-SCN
- */
-void            bfa_fcs_port_scn_init(struct bfa_fcs_port_s *vport);
-void            bfa_fcs_port_scn_offline(struct bfa_fcs_port_s *vport);
-void            bfa_fcs_port_scn_online(struct bfa_fcs_port_s *vport);
-void            bfa_fcs_port_scn_process_rscn(struct bfa_fcs_port_s *port,
-					      struct fchs_s *rx_frame, u32 len);
-
-/*
- * Functions exported by VP-N2N
- */
-
-void            bfa_fcs_port_n2n_init(struct bfa_fcs_port_s *port);
-void            bfa_fcs_port_n2n_online(struct bfa_fcs_port_s *port);
-void            bfa_fcs_port_n2n_offline(struct bfa_fcs_port_s *port);
-void            bfa_fcs_port_n2n_rx_frame(struct bfa_fcs_port_s *port,
-					  u8 *rx_frame, u32 len);
-
-/*
- * Functions exported by VP-LOOP
- */
-void            bfa_fcs_port_loop_init(struct bfa_fcs_port_s *port);
-void            bfa_fcs_port_loop_online(struct bfa_fcs_port_s *port);
-void            bfa_fcs_port_loop_offline(struct bfa_fcs_port_s *port);
-void            bfa_fcs_port_loop_lip(struct bfa_fcs_port_s *port);
-void            bfa_fcs_port_loop_rx_frame(struct bfa_fcs_port_s *port,
-					   u8 *rx_frame, u32 len);
-
-#endif /* __VP_PRIV_H__ */
-- 
1.7.3.rc1


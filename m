From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 12/14] bfa: Brocade BFA FC SCSI driver (include part3)
Date: Thu, 20 Aug 2009 00:20:07 -0700
Message-ID: <200908200720.n7K7K7JU008155@swe57.brocade.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx30.brocade.com ([144.49.194.4]:23205 "EHLO mx30.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810AbZHTHUJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2009 03:20:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This patch contains common header files for linux driver,
hardware/firmeare interface, and FC state machines. part-3

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 fcs/bfa_fcs.h       |   73 ++
 fcs/bfa_fcs_fcpim.h |  131 ++++
 fcs/bfa_fcs_fdmi.h  |   63 +
 fcs/bfa_fcs_lport.h |  226 +++++++
 fcs/bfa_fcs_rport.h |  104 +++
 fcs/bfa_fcs_vport.h |   63 +
 log/bfa_log_fcs.h   |   28 
 log/bfa_log_hal.h   |   30 
 log/bfa_log_linux.h |   44 +
 log/bfa_log_wdrv.h  |   36 +
 protocol/ct.h       |  492 +++++++++++++++
 protocol/fc.h       | 1105 ++++++++++++++++++++++++++++++++++
 protocol/fc_sp.h    |  224 +++++++
 protocol/fcp.h      |  186 +++++
 protocol/fdmi.h     |  163 +++++
 protocol/pcifw.h    |   75 ++
 protocol/scsi.h     | 1648 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 protocol/types.h    |   42 +
 18 files changed, 4733 insertions(+)

diff -urpN orig/drivers/scsi/bfa/include/fcs/bfa_fcs_fcpim.h patch/drivers/scsi/bfa/include/fcs/bfa_fcs_fcpim.h
--- orig/drivers/scsi/bfa/include/fcs/bfa_fcs_fcpim.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/fcs/bfa_fcs_fcpim.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,131 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_fcs_fcpim.h BFA FCS FCP Initiator Mode interfaces/defines.
+ */
+
+#ifndef __BFA_FCS_FCPIM_H__
+#define __BFA_FCS_FCPIM_H__
+
+#include <defs/bfa_defs_status.h>
+#include <defs/bfa_defs_itnim.h>
+#include <fcs/bfa_fcs.h>
+#include <fcs/bfa_fcs_rport.h>
+#include <fcs/bfa_fcs_lport.h>
+#include <bfa_fcpim.h>
+
+/*
+ * forward declarations
+ */
+struct bfad_itnim_s;
+
+struct bfa_fcs_itnim_s {
+	bfa_sm_t		sm;		/*  state machine */
+	struct bfa_fcs_rport_s 	*rport;		/*  parent remote rport  */
+	struct bfad_itnim_s   	*itnim_drv;	/*  driver peer instance */
+	struct bfa_fcs_s      	*fcs;		/*  fcs instance         */
+	struct bfa_timer_s 	timer;		/*  timer functions      */
+	struct bfa_itnim_s 	*bfa_itnim;	/*  BFA itnim struct     */
+	bfa_boolean_t	 	seq_rec;	/*  seq recovery support */
+	bfa_boolean_t	 	rec_support;	/*  REC supported        */
+	bfa_boolean_t	 	conf_comp;	/*  FCP_CONF     support */
+	bfa_boolean_t	 	task_retry_id;	/*  task retry id supp   */
+	struct bfa_fcxp_wqe_s 	fcxp_wqe;	/*  wait qelem for fcxp  */
+	struct bfa_fcxp_s *fcxp;		/*  FCXP in use          */
+	struct bfa_itnim_stats_s 	stats;	/*  itn statistics       */
+};
+
+
+static inline struct bfad_port_s *
+bfa_fcs_itnim_get_drvport(struct bfa_fcs_itnim_s *itnim)
+{
+	return itnim->rport->port->bfad_port;
+}
+
+
+static inline struct bfa_fcs_port_s *
+bfa_fcs_itnim_get_port(struct bfa_fcs_itnim_s *itnim)
+{
+	return itnim->rport->port;
+}
+
+
+static inline wwn_t
+bfa_fcs_itnim_get_nwwn(struct bfa_fcs_itnim_s *itnim)
+{
+	return itnim->rport->nwwn;
+}
+
+
+static inline wwn_t
+bfa_fcs_itnim_get_pwwn(struct bfa_fcs_itnim_s *itnim)
+{
+	return itnim->rport->pwwn;
+}
+
+
+static inline u32
+bfa_fcs_itnim_get_fcid(struct bfa_fcs_itnim_s *itnim)
+{
+	return itnim->rport->pid;
+}
+
+
+static inline   u32
+bfa_fcs_itnim_get_maxfrsize(struct bfa_fcs_itnim_s *itnim)
+{
+	return itnim->rport->maxfrsize;
+}
+
+
+static inline   enum fc_cos
+bfa_fcs_itnim_get_cos(struct bfa_fcs_itnim_s *itnim)
+{
+	return itnim->rport->fc_cos;
+}
+
+
+static inline struct bfad_itnim_s *
+bfa_fcs_itnim_get_drvitn(struct bfa_fcs_itnim_s *itnim)
+{
+	return itnim->itnim_drv;
+}
+
+
+static inline struct bfa_itnim_s *
+bfa_fcs_itnim_get_halitn(struct bfa_fcs_itnim_s *itnim)
+{
+	return itnim->bfa_itnim;
+}
+
+/**
+ * bfa fcs FCP Initiator mode API functions
+ */
+void bfa_fcs_itnim_get_attr(struct bfa_fcs_itnim_s *itnim,
+			struct bfa_itnim_attr_s *attr);
+void bfa_fcs_itnim_get_stats(struct bfa_fcs_itnim_s *itnim,
+			struct bfa_itnim_stats_s *stats);
+struct bfa_fcs_itnim_s *bfa_fcs_itnim_lookup(struct bfa_fcs_port_s *port,
+			wwn_t rpwwn);
+bfa_status_t bfa_fcs_itnim_attr_get(struct bfa_fcs_port_s *port, wwn_t rpwwn,
+			struct bfa_itnim_attr_s *attr);
+bfa_status_t bfa_fcs_itnim_stats_get(struct bfa_fcs_port_s *port, wwn_t rpwwn,
+			struct bfa_itnim_stats_s *stats);
+bfa_status_t bfa_fcs_itnim_stats_clear(struct bfa_fcs_port_s *port,
+			wwn_t rpwwn);
+#endif /* __BFA_FCS_FCPIM_H__ */
diff -urpN orig/drivers/scsi/bfa/include/fcs/bfa_fcs_fdmi.h patch/drivers/scsi/bfa/include/fcs/bfa_fcs_fdmi.h
--- orig/drivers/scsi/bfa/include/fcs/bfa_fcs_fdmi.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/fcs/bfa_fcs_fdmi.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,63 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_fcs_fdmi.h BFA fcs fdmi module public interface
+ */
+
+#ifndef __BFA_FCS_FDMI_H__
+#define __BFA_FCS_FDMI_H__
+#include <bfa_os_inc.h>
+#include <protocol/fdmi.h>
+
+#define	BFA_FCS_FDMI_SUPORTED_SPEEDS  (FDMI_TRANS_SPEED_1G  | \
+					FDMI_TRANS_SPEED_2G | \
+					FDMI_TRANS_SPEED_4G | \
+					FDMI_TRANS_SPEED_8G)
+
+/*
+* HBA Attribute Block : BFA internal representation. Note : Some variable
+* sizes have been trimmed to suit BFA For Ex : Model will be "Brocade". Based
+ * on this the size has been reduced to 16 bytes from the standard's 64 bytes.
+ */
+struct bfa_fcs_fdmi_hba_attr_s {
+	wwn_t           node_name;
+	u8         manufacturer[64];
+	u8         serial_num[64];
+	u8         model[16];
+	u8         model_desc[256];
+	u8         hw_version[8];
+	u8         driver_version[8];
+	u8         option_rom_ver[BFA_VERSION_LEN];
+	u8         fw_version[8];
+	u8         os_name[256];
+	u32        max_ct_pyld;
+};
+
+/*
+ * Port Attribute Block
+ */
+struct bfa_fcs_fdmi_port_attr_s {
+	u8         supp_fc4_types[32];	/* supported FC4 types */
+	u32        supp_speed;	/* supported speed */
+	u32        curr_speed;	/* current Speed */
+	u32        max_frm_size;	/* max frame size */
+	u8         os_device_name[256];	/* OS device Name */
+	u8         host_name[256];	/* host name */
+};
+
+#endif /* __BFA_FCS_FDMI_H__ */
diff -urpN orig/drivers/scsi/bfa/include/fcs/bfa_fcs.h patch/drivers/scsi/bfa/include/fcs/bfa_fcs.h
--- orig/drivers/scsi/bfa/include/fcs/bfa_fcs.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/fcs/bfa_fcs.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,73 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_FCS_H__
+#define __BFA_FCS_H__
+
+#include <cs/bfa_debug.h>
+#include <defs/bfa_defs_status.h>
+#include <defs/bfa_defs_version.h>
+#include <bfa.h>
+#include <fcs/bfa_fcs_fabric.h>
+
+#define BFA_FCS_OS_STR_LEN  		64
+
+struct bfa_fcs_stats_s {
+	struct {
+		u32        untagged; /*  untagged receive frames */
+		u32        tagged;	/*  tagged receive frames */
+		u32        vfid_unknown;	/*  VF id is unknown */
+	} uf;
+};
+
+struct bfa_fcs_driver_info_s {
+	u8  version[BFA_VERSION_LEN];		/*  Driver Version */
+	u8  host_machine_name[BFA_FCS_OS_STR_LEN];
+	u8  host_os_name[BFA_FCS_OS_STR_LEN]; /*  OS name and version */
+	u8  host_os_patch[BFA_FCS_OS_STR_LEN];/*  patch or service pack */
+	u8  os_device_name[BFA_FCS_OS_STR_LEN]; /*  Driver Device Name */
+};
+
+struct bfa_fcs_s {
+	struct bfa_s      *bfa;	/*  corresponding BFA bfa instance */
+	struct bfad_s         *bfad; /*  corresponding BDA driver instance */
+	struct bfa_log_mod_s  *logm;	/*  driver logging module instance */
+	struct bfa_trc_mod_s  *trcmod;	/*  tracing module */
+	struct bfa_aen_s      *aen;	/*  aen component */
+	bfa_boolean_t   vf_enabled;	/*  VF mode is enabled */
+	bfa_boolean_t min_cfg;		/* min cfg enabled/disabled */
+	u16        port_vfid;	/*  port default VF ID */
+	struct bfa_fcs_driver_info_s driver_info;
+	struct bfa_fcs_fabric_s fabric; /*  base fabric state machine */
+	struct bfa_fcs_stats_s	stats;	/*  FCS statistics */
+	struct bfa_wc_s       	wc;	/*  waiting counter */
+};
+
+/*
+ * bfa fcs API functions
+ */
+void bfa_fcs_init(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
+			bfa_boolean_t min_cfg);
+void bfa_fcs_driver_info_init(struct bfa_fcs_s *fcs,
+			struct bfa_fcs_driver_info_s *driver_info);
+void bfa_fcs_exit(struct bfa_fcs_s *fcs);
+void bfa_fcs_trc_init(struct bfa_fcs_s *fcs, struct bfa_trc_mod_s *trcmod);
+void bfa_fcs_log_init(struct bfa_fcs_s *fcs, struct bfa_log_mod_s *logmod);
+void bfa_fcs_aen_init(struct bfa_fcs_s *fcs, struct bfa_aen_s *aen);
+void 	  	bfa_fcs_start(struct bfa_fcs_s *fcs);
+
+#endif /* __BFA_FCS_H__ */
diff -urpN orig/drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h patch/drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h
--- orig/drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,226 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_fcs_port.h BFA fcs port module public interface
+ */
+
+#ifndef __BFA_FCS_PORT_H__
+#define __BFA_FCS_PORT_H__
+
+#include <defs/bfa_defs_status.h>
+#include <defs/bfa_defs_port.h>
+#include <defs/bfa_defs_pport.h>
+#include <defs/bfa_defs_rport.h>
+#include <cs/bfa_q.h>
+#include <bfa_svc.h>
+#include <cs/bfa_wc.h>
+
+struct bfa_fcs_s;
+struct bfa_fcs_fabric_s;
+
+/*
+* @todo : need to move to a global config file.
+ * Maximum Vports supported per physical port or vf.
+ */
+#define BFA_FCS_MAX_VPORTS_SUPP_CB  255
+#define BFA_FCS_MAX_VPORTS_SUPP_CT  191
+
+/*
+* @todo : need to move to a global config file.
+ * Maximum Rports supported per port (physical/logical).
+ */
+#define BFA_FCS_MAX_RPORTS_SUPP  256	/* @todo : tentative value */
+
+
+struct bfa_fcs_port_ns_s {
+	bfa_sm_t        sm;		/*  state machine */
+	struct bfa_timer_s timer;
+	struct bfa_fcs_port_s *port;	/*  parent port */
+	struct bfa_fcxp_s *fcxp;
+	struct bfa_fcxp_wqe_s fcxp_wqe;
+};
+
+
+struct bfa_fcs_port_scn_s {
+	bfa_sm_t        sm;		/*  state machine */
+	struct bfa_timer_s timer;
+	struct bfa_fcs_port_s *port;	/*  parent port */
+	struct bfa_fcxp_s *fcxp;
+	struct bfa_fcxp_wqe_s fcxp_wqe;
+};
+
+
+struct bfa_fcs_port_fdmi_s {
+	bfa_sm_t        sm;		/*  state machine */
+	struct bfa_timer_s timer;
+	struct bfa_fcs_port_ms_s *ms;	/*  parent ms */
+	struct bfa_fcxp_s *fcxp;
+	struct bfa_fcxp_wqe_s fcxp_wqe;
+	u8         retry_cnt;	/*  retry count */
+	u8	 	   rsvd[3];
+};
+
+
+struct bfa_fcs_port_ms_s {
+	bfa_sm_t        sm;		/*  state machine */
+	struct bfa_timer_s timer;
+	struct bfa_fcs_port_s *port;	/*  parent port */
+	struct bfa_fcxp_s *fcxp;
+	struct bfa_fcxp_wqe_s fcxp_wqe;
+	struct bfa_fcs_port_fdmi_s fdmi;	/*  FDMI component of MS */
+	u8         retry_cnt;	/*  retry count */
+	u8	 	   rsvd[3];
+};
+
+
+struct bfa_fcs_port_fab_s {
+	struct bfa_fcs_port_ns_s ns;	/*  NS component of port */
+	struct bfa_fcs_port_scn_s scn;	/*  scn component of port */
+	struct bfa_fcs_port_ms_s ms;	/*  MS component of port */
+};
+
+
+
+#define 	MAX_ALPA_COUNT 		127
+
+struct bfa_fcs_port_loop_s {
+	u8         num_alpa;	/*  Num of ALPA entries in the map */
+	u8         alpa_pos_map[MAX_ALPA_COUNT];	/*  ALPA Positional
+							 *Map */
+	struct bfa_fcs_port_s *port;	/*  parent port */
+};
+
+
+
+struct bfa_fcs_port_n2n_s {
+	u32        rsvd;
+	u16        reply_oxid;	/*  ox_id from the req flogi to be
+					 *used in flogi acc */
+	wwn_t           rem_port_wwn;	/*  Attached port's wwn */
+};
+
+
+union bfa_fcs_port_topo_u {
+	struct bfa_fcs_port_fab_s pfab;
+	struct bfa_fcs_port_loop_s ploop;
+	struct bfa_fcs_port_n2n_s pn2n;
+};
+
+
+struct bfa_fcs_port_s {
+	struct list_head         qe;	/*  used by port/vport */
+	bfa_sm_t               sm;	/*  state machine */
+	struct bfa_fcs_fabric_s *fabric;	/*  parent fabric */
+	struct bfa_port_cfg_s  port_cfg;	/*  port configuration */
+	struct bfa_timer_s link_timer;	/*  timer for link offline */
+	u32        pid : 24;	/*  FC address */
+	u8         lp_tag;		/*  lport tag */
+	u16        num_rports;	/*  Num of r-ports */
+	struct list_head rport_q;	/*  queue of discovered r-ports */
+	struct bfa_fcs_s *fcs;	/*  FCS instance */
+	union bfa_fcs_port_topo_u port_topo;	/*  fabric/loop/n2n details */
+	struct bfad_port_s *bfad_port;	/*  driver peer instance */
+	struct bfa_fcs_vport_s *vport;	/*  NULL for base ports */
+	struct bfa_fcxp_s *fcxp;
+	struct bfa_fcxp_wqe_s fcxp_wqe;
+	struct bfa_port_stats_s stats;
+	struct bfa_wc_s        wc;	/*  waiting counter for events */
+};
+
+#define bfa_fcs_lport_t struct bfa_fcs_port_s
+
+/**
+ * Symbolic Name related defines
+ *  Total bytes 255.
+ *  Physical Port's symbolic name 128 bytes.
+ *  For Vports, Vport's symbolic name is appended to the Physical port's
+ *  Symbolic Name.
+ *
+ *  Physical Port's symbolic name Format : (Total 128 bytes)
+ *  Adapter Model number/name : 12 bytes
+ *  Driver Version     : 10 bytes
+ *  Host Machine Name  : 30 bytes
+ * 	Host OS Info	   : 48 bytes
+ * 	Host OS PATCH Info : 16 bytes
+ *  ( remaining 12 bytes reserved to be used for separator)
+ */
+#define BFA_FCS_PORT_SYMBNAME_SEPARATOR 		" | "
+
+#define BFA_FCS_PORT_SYMBNAME_MODEL_SZ			12
+#define BFA_FCS_PORT_SYMBNAME_VERSION_SZ 		10
+#define BFA_FCS_PORT_SYMBNAME_MACHINENAME_SZ 	30
+#define BFA_FCS_PORT_SYMBNAME_OSINFO_SZ			48
+#define BFA_FCS_PORT_SYMBNAME_OSPATCH_SZ		16
+
+/**
+ * Get FC port ID for a logical port.
+ */
+#define bfa_fcs_port_get_fcid(_lport)	((_lport)->pid)
+#define bfa_fcs_port_get_pwwn(_lport)	((_lport)->port_cfg.pwwn)
+#define bfa_fcs_port_get_nwwn(_lport)	((_lport)->port_cfg.nwwn)
+#define bfa_fcs_port_get_psym_name(_lport)	((_lport)->port_cfg.sym_name)
+#define bfa_fcs_port_is_initiator(_lport)	\
+			((_lport)->port_cfg.roles & BFA_PORT_ROLE_FCP_IM)
+#define bfa_fcs_port_is_target(_lport)	\
+			((_lport)->port_cfg.roles & BFA_PORT_ROLE_FCP_TM)
+#define bfa_fcs_port_get_nrports(_lport)	\
+			((_lport) ? (_lport)->num_rports : 0)
+
+static inline struct bfad_port_s *
+bfa_fcs_port_get_drvport(struct bfa_fcs_port_s *port)
+{
+	return port->bfad_port;
+}
+
+
+#define bfa_fcs_port_get_opertype(_lport)	(_lport)->fabric->oper_type
+
+
+#define bfa_fcs_port_get_fabric_name(_lport)	(_lport)->fabric->fabric_name
+
+
+#define bfa_fcs_port_get_fabric_ipaddr(_lport)	(_lport)->fabric->fabric_ip_addr
+
+/**
+ * bfa fcs port public functions
+ */
+void bfa_fcs_cfg_base_port(struct bfa_fcs_s *fcs,
+			struct bfa_port_cfg_s *port_cfg);
+struct bfa_fcs_port_s *bfa_fcs_get_base_port(struct bfa_fcs_s *fcs);
+void bfa_fcs_port_get_rports(struct bfa_fcs_port_s *port,
+			wwn_t rport_wwns[], int *nrports);
+
+wwn_t bfa_fcs_port_get_rport(struct bfa_fcs_port_s *port, wwn_t wwn,
+			int index, int nrports, bfa_boolean_t bwwn);
+
+struct bfa_fcs_port_s *bfa_fcs_lookup_port(struct bfa_fcs_s *fcs,
+			u16 vf_id, wwn_t lpwwn);
+
+void bfa_fcs_port_get_info(struct bfa_fcs_port_s *port,
+			struct bfa_port_info_s *port_info);
+void bfa_fcs_port_get_attr(struct bfa_fcs_port_s *port,
+			struct bfa_port_attr_s *port_attr);
+void bfa_fcs_port_get_stats(struct bfa_fcs_port_s *fcs_port,
+			struct bfa_port_stats_s *port_stats);
+void bfa_fcs_port_clear_stats(struct bfa_fcs_port_s *fcs_port);
+enum bfa_pport_speed bfa_fcs_port_get_rport_max_speed(
+			struct bfa_fcs_port_s *port);
+void bfa_fcs_port_enable_ipfc_roles(struct bfa_fcs_port_s *fcs_port);
+void bfa_fcs_port_disable_ipfc_roles(struct bfa_fcs_port_s *fcs_port);
+
+#endif /* __BFA_FCS_PORT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h patch/drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h
--- orig/drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,104 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_FCS_RPORT_H__
+#define __BFA_FCS_RPORT_H__
+
+#include <defs/bfa_defs_status.h>
+#include <cs/bfa_q.h>
+#include <fcs/bfa_fcs.h>
+#include <defs/bfa_defs_rport.h>
+
+#define BFA_FCS_RPORT_DEF_DEL_TIMEOUT 	90 	/* in secs */
+/*
+ * forward declarations
+ */
+struct bfad_rport_s;
+
+struct bfa_fcs_itnim_s;
+struct bfa_fcs_tin_s;
+struct bfa_fcs_iprp_s;
+
+/* Rport Features (RPF) */
+struct bfa_fcs_rpf_s {
+	bfa_sm_t               sm;	/*  state machine */
+	struct bfa_fcs_rport_s *rport;	/*  parent rport */
+	struct bfa_timer_s 	timer;	/*  general purpose timer */
+	struct bfa_fcxp_s 	*fcxp;	/*  FCXP needed for discarding */
+	struct bfa_fcxp_wqe_s 	fcxp_wqe;	/*  fcxp wait queue element */
+	int             	rpsc_retries;	/*  max RPSC retry attempts */
+	enum bfa_pport_speed 	rpsc_speed;	/* Current Speed from RPSC.
+						 * O if RPSC fails */
+	enum bfa_pport_speed	assigned_speed;	/* Speed assigned by the user.
+						 * will be used if RPSC is not
+						 * supported by the rport */
+};
+
+struct bfa_fcs_rport_s {
+	struct list_head         qe;	/*  used by port/vport */
+	struct bfa_fcs_port_s *port;	/*  parent FCS port */
+	struct bfa_fcs_s      *fcs;	/*  fcs instance */
+	struct bfad_rport_s   *rp_drv;	/*  driver peer instance */
+	u32        pid;	/*  port ID of rport */
+	u16        maxfrsize;	/*  maximum frame size */
+	u16        reply_oxid;	/*  OX_ID of inbound requests */
+	enum fc_cos        fc_cos;	/*  FC classes of service supp */
+	bfa_boolean_t   cisc;	/*  CISC capable device */
+	wwn_t           pwwn;	/*  port wwn of rport */
+	wwn_t           nwwn;	/*  node wwn of rport */
+	struct bfa_rport_symname_s psym_name; /*  port symbolic name  */
+	bfa_sm_t        sm;		/*  state machine */
+	struct bfa_timer_s timer;	/*  general purpose timer */
+	struct bfa_fcs_itnim_s *itnim;	/*  ITN initiator mode role */
+	struct bfa_fcs_tin_s *tin;	/*  ITN initiator mode role */
+	struct bfa_fcs_iprp_s *iprp;	/*  IP/FC role */
+	struct bfa_rport_s *bfa_rport;	/*  BFA Rport */
+	struct bfa_fcxp_s *fcxp;	/*  FCXP needed for discarding */
+	int             plogi_retries;	/*  max plogi retry attempts */
+	int             ns_retries;	/*  max NS query retry attempts */
+	struct bfa_fcxp_wqe_s 	fcxp_wqe; /*  fcxp wait queue element */
+	struct bfa_rport_stats_s stats;	/*  rport stats */
+	enum bfa_rport_function	scsi_function;  /*  Initiator/Target */
+	struct bfa_fcs_rpf_s rpf; 	/* Rport features module */
+};
+
+static inline struct bfa_rport_s *
+bfa_fcs_rport_get_halrport(struct bfa_fcs_rport_s *rport)
+{
+	return rport->bfa_rport;
+}
+
+/**
+ * bfa fcs rport API functions
+ */
+bfa_status_t bfa_fcs_rport_add(struct bfa_fcs_port_s *port, wwn_t *pwwn,
+			struct bfa_fcs_rport_s *rport,
+			struct bfad_rport_s *rport_drv);
+bfa_status_t bfa_fcs_rport_remove(struct bfa_fcs_rport_s *rport);
+void bfa_fcs_rport_get_attr(struct bfa_fcs_rport_s *rport,
+			struct bfa_rport_attr_s *attr);
+void bfa_fcs_rport_get_stats(struct bfa_fcs_rport_s *rport,
+			struct bfa_rport_stats_s *stats);
+void bfa_fcs_rport_clear_stats(struct bfa_fcs_rport_s *rport);
+struct bfa_fcs_rport_s *bfa_fcs_rport_lookup(struct bfa_fcs_port_s *port,
+			wwn_t rpwwn);
+struct bfa_fcs_rport_s *bfa_fcs_rport_lookup_by_nwwn(
+			struct bfa_fcs_port_s *port, wwn_t rnwwn);
+void bfa_fcs_rport_set_del_timeout(u8 rport_tmo);
+void bfa_fcs_rport_set_speed(struct bfa_fcs_rport_s *rport,
+			enum bfa_pport_speed speed);
+#endif /* __BFA_FCS_RPORT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h patch/drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h
--- orig/drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,63 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_fcs_vport.h BFA fcs vport module public interface
+ */
+
+#ifndef __BFA_FCS_VPORT_H__
+#define __BFA_FCS_VPORT_H__
+
+#include <defs/bfa_defs_status.h>
+#include <defs/bfa_defs_port.h>
+#include <defs/bfa_defs_vport.h>
+#include <fcs/bfa_fcs.h>
+#include <fcb/bfa_fcb_vport.h>
+
+struct bfa_fcs_vport_s {
+	struct list_head		qe;		/*  queue elem	 */
+	bfa_sm_t		sm;		/*  state machine	*/
+	bfa_fcs_lport_t		lport;		/*  logical port	*/
+	struct bfa_timer_s	timer;		/*  general purpose timer */
+	struct bfad_vport_s	*vport_drv;	/*  Driver private	*/
+	struct bfa_vport_stats_s vport_stats;	/*  vport statistics	*/
+	struct bfa_lps_s	*lps;		/*  Lport login service */
+	int			fdisc_retries;
+};
+
+#define bfa_fcs_vport_get_port(vport) \
+			((struct bfa_fcs_port_s  *)(&vport->port))
+
+/**
+ * bfa fcs vport public functions
+ */
+bfa_status_t bfa_fcs_vport_create(struct bfa_fcs_vport_s *vport,
+			struct bfa_fcs_s *fcs, u16 vf_id,
+			struct bfa_port_cfg_s *port_cfg,
+			struct bfad_vport_s *vport_drv);
+bfa_status_t bfa_fcs_vport_delete(struct bfa_fcs_vport_s *vport);
+bfa_status_t bfa_fcs_vport_start(struct bfa_fcs_vport_s *vport);
+bfa_status_t bfa_fcs_vport_stop(struct bfa_fcs_vport_s *vport);
+void bfa_fcs_vport_get_attr(struct bfa_fcs_vport_s *vport,
+			struct bfa_vport_attr_s *vport_attr);
+void bfa_fcs_vport_get_stats(struct bfa_fcs_vport_s *vport,
+			struct bfa_vport_stats_s *vport_stats);
+void bfa_fcs_vport_clr_stats(struct bfa_fcs_vport_s *vport);
+struct bfa_fcs_vport_s *bfa_fcs_vport_lookup(struct bfa_fcs_s *fcs,
+			u16 vf_id, wwn_t vpwwn);
+
+#endif /* __BFA_FCS_VPORT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/log/bfa_log_fcs.h patch/drivers/scsi/bfa/include/log/bfa_log_fcs.h
--- orig/drivers/scsi/bfa/include/log/bfa_log_fcs.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/log/bfa_log_fcs.h	2009-08-19 17:47:58.000000000 -0700
@@ -0,0 +1,28 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/*
+ * messages define for FCS Module
+ */
+#ifndef	__BFA_LOG_FCS_H__
+#define	__BFA_LOG_FCS_H__
+#include  <cs/bfa_log.h>
+#define BFA_LOG_FCS_FABRIC_NOSWITCH 	\
+	(((u32) BFA_LOG_FCS_ID << BFA_LOG_MODID_OFFSET) | 1)
+#define BFA_LOG_FCS_FABRIC_ISOLATED 	\
+	(((u32) BFA_LOG_FCS_ID << BFA_LOG_MODID_OFFSET) | 2)
+#endif
diff -urpN orig/drivers/scsi/bfa/include/log/bfa_log_hal.h patch/drivers/scsi/bfa/include/log/bfa_log_hal.h
--- orig/drivers/scsi/bfa/include/log/bfa_log_hal.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/log/bfa_log_hal.h	2009-08-19 17:47:58.000000000 -0700
@@ -0,0 +1,30 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* messages define for HAL Module */
+#ifndef	__BFA_LOG_HAL_H__
+#define	__BFA_LOG_HAL_H__
+#include  <cs/bfa_log.h>
+#define BFA_LOG_HAL_ASSERT \
+	(((u32) BFA_LOG_HAL_ID << BFA_LOG_MODID_OFFSET) | 1)
+#define BFA_LOG_HAL_HEARTBEAT_FAILURE \
+	(((u32) BFA_LOG_HAL_ID << BFA_LOG_MODID_OFFSET) | 2)
+#define BFA_LOG_HAL_FCPIM_PARM_INVALID \
+	(((u32) BFA_LOG_HAL_ID << BFA_LOG_MODID_OFFSET) | 3)
+#define BFA_LOG_HAL_SM_ASSERT \
+	(((u32) BFA_LOG_HAL_ID << BFA_LOG_MODID_OFFSET) | 4)
+#endif
diff -urpN orig/drivers/scsi/bfa/include/log/bfa_log_linux.h patch/drivers/scsi/bfa/include/log/bfa_log_linux.h
--- orig/drivers/scsi/bfa/include/log/bfa_log_linux.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/log/bfa_log_linux.h	2009-08-19 17:47:58.000000000 -0700
@@ -0,0 +1,44 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* messages define for LINUX Module */
+#ifndef	__BFA_LOG_LINUX_H__
+#define	__BFA_LOG_LINUX_H__
+#include  <cs/bfa_log.h>
+#define BFA_LOG_LINUX_DEVICE_CLAIMED \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 1)
+#define BFA_LOG_LINUX_HASH_INIT_FAILED \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 2)
+#define BFA_LOG_LINUX_SYSFS_FAILED \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 3)
+#define BFA_LOG_LINUX_MEM_ALLOC_FAILED \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 4)
+#define BFA_LOG_LINUX_DRIVER_REGISTRATION_FAILED \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 5)
+#define BFA_LOG_LINUX_ITNIM_FREE \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 6)
+#define BFA_LOG_LINUX_ITNIM_ONLINE \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 7)
+#define BFA_LOG_LINUX_ITNIM_OFFLINE \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 8)
+#define BFA_LOG_LINUX_SCSI_HOST_FREE \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 9)
+#define BFA_LOG_LINUX_SCSI_ABORT \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 10)
+#define BFA_LOG_LINUX_SCSI_ABORT_COMP \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 11)
+#endif
diff -urpN orig/drivers/scsi/bfa/include/log/bfa_log_wdrv.h patch/drivers/scsi/bfa/include/log/bfa_log_wdrv.h
--- orig/drivers/scsi/bfa/include/log/bfa_log_wdrv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/log/bfa_log_wdrv.h	2009-08-19 17:47:58.000000000 -0700
@@ -0,0 +1,36 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/*
+ * messages define for WDRV Module
+ */
+#ifndef	__BFA_LOG_WDRV_H__
+#define	__BFA_LOG_WDRV_H__
+#include  <cs/bfa_log.h>
+#define BFA_LOG_WDRV_IOC_INIT_ERROR 	\
+	(((u32) BFA_LOG_WDRV_ID << BFA_LOG_MODID_OFFSET) | 1)
+#define BFA_LOG_WDRV_IOC_INTERNAL_ERROR \
+	(((u32) BFA_LOG_WDRV_ID << BFA_LOG_MODID_OFFSET) | 2)
+#define BFA_LOG_WDRV_IOC_START_ERROR 	\
+	(((u32) BFA_LOG_WDRV_ID << BFA_LOG_MODID_OFFSET) | 3)
+#define BFA_LOG_WDRV_IOC_STOP_ERROR 	\
+	(((u32) BFA_LOG_WDRV_ID << BFA_LOG_MODID_OFFSET) | 4)
+#define BFA_LOG_WDRV_INSUFFICIENT_RESOURCES \
+	(((u32) BFA_LOG_WDRV_ID << BFA_LOG_MODID_OFFSET) | 5)
+#define BFA_LOG_WDRV_BASE_ADDRESS_MAP_ERROR \
+	(((u32) BFA_LOG_WDRV_ID << BFA_LOG_MODID_OFFSET) | 6)
+#endif
diff -urpN orig/drivers/scsi/bfa/include/protocol/ct.h patch/drivers/scsi/bfa/include/protocol/ct.h
--- orig/drivers/scsi/bfa/include/protocol/ct.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/protocol/ct.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,492 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __CT_H__
+#define __CT_H__
+
+#include <protocol/types.h>
+
+#pragma pack(1)
+
+struct ct_hdr_s{
+	u32	rev_id:8;	/* Revision of the CT */
+	u32	in_id:24;	/* Initiator Id */
+	u32	gs_type:8;	/* Generic service Type */
+	u32	gs_sub_type:8;	/* Generic service sub type */
+	u32	options:8;	/* options */
+	u32	rsvrd:8;	/* reserved */
+	u32	cmd_rsp_code:16;/* ct command/response code */
+	u32	max_res_size:16;/* maximum/residual size */
+	u32	frag_id:8;	/* fragment ID */
+	u32	reason_code:8;	/* reason code */
+	u32	exp_code:8;	/* explanation code */
+	u32	vendor_unq:8;	/* vendor unique */
+};
+
+/*
+ * defines for the Revision
+ */
+enum {
+	CT_GS3_REVISION = 0x01,
+};
+
+/*
+ * defines for gs_type
+ */
+enum {
+	CT_GSTYPE_KEYSERVICE	= 0xF7,
+	CT_GSTYPE_ALIASSERVICE	= 0xF8,
+	CT_GSTYPE_MGMTSERVICE	= 0xFA,
+	CT_GSTYPE_TIMESERVICE	= 0xFB,
+	CT_GSTYPE_DIRSERVICE	= 0xFC,
+};
+
+/*
+ * defines for gs_sub_type for gs type directory service
+ */
+enum {
+	CT_GSSUBTYPE_NAMESERVER = 0x02,
+};
+
+/*
+ * defines for gs_sub_type for gs type management service
+ */
+enum {
+	CT_GSSUBTYPE_CFGSERVER	= 0x01,
+	CT_GSSUBTYPE_UNZONED_NS = 0x02,
+	CT_GSSUBTYPE_ZONESERVER = 0x03,
+	CT_GSSUBTYPE_LOCKSERVER = 0x04,
+	CT_GSSUBTYPE_HBA_MGMTSERVER = 0x10,	/* for FDMI */
+};
+
+/*
+ * defines for CT response code field
+ */
+enum {
+	CT_RSP_REJECT = 0x8001,
+	CT_RSP_ACCEPT = 0x8002,
+};
+
+/*
+ * defintions for CT reason code
+ */
+enum {
+	CT_RSN_INV_CMD		= 0x01,
+	CT_RSN_INV_VER		= 0x02,
+	CT_RSN_LOGIC_ERR	= 0x03,
+	CT_RSN_INV_SIZE		= 0x04,
+	CT_RSN_LOGICAL_BUSY	= 0x05,
+	CT_RSN_PROTO_ERR	= 0x07,
+	CT_RSN_UNABLE_TO_PERF	= 0x09,
+	CT_RSN_NOT_SUPP			= 0x0B,
+	CT_RSN_SERVER_NOT_AVBL  = 0x0D,
+	CT_RSN_SESSION_COULD_NOT_BE_ESTBD = 0x0E,
+	CT_RSN_VENDOR_SPECIFIC  = 0xFF,
+
+};
+
+/*
+ * definitions for explanations code for Name server
+ */
+enum {
+	CT_NS_EXP_NOADDITIONAL	= 0x00,
+	CT_NS_EXP_ID_NOT_REG	= 0x01,
+	CT_NS_EXP_PN_NOT_REG	= 0x02,
+	CT_NS_EXP_NN_NOT_REG	= 0x03,
+	CT_NS_EXP_CS_NOT_REG	= 0x04,
+	CT_NS_EXP_IPN_NOT_REG	= 0x05,
+	CT_NS_EXP_IPA_NOT_REG	= 0x06,
+	CT_NS_EXP_FT_NOT_REG	= 0x07,
+	CT_NS_EXP_SPN_NOT_REG	= 0x08,
+	CT_NS_EXP_SNN_NOT_REG	= 0x09,
+	CT_NS_EXP_PT_NOT_REG	= 0x0A,
+	CT_NS_EXP_IPP_NOT_REG	= 0x0B,
+	CT_NS_EXP_FPN_NOT_REG	= 0x0C,
+	CT_NS_EXP_HA_NOT_REG	= 0x0D,
+	CT_NS_EXP_FD_NOT_REG	= 0x0E,
+	CT_NS_EXP_FF_NOT_REG	= 0x0F,
+	CT_NS_EXP_ACCESSDENIED	= 0x10,
+	CT_NS_EXP_UNACCEPTABLE_ID = 0x11,
+	CT_NS_EXP_DATABASEEMPTY			= 0x12,
+	CT_NS_EXP_NOT_REG_IN_SCOPE 		= 0x13,
+	CT_NS_EXP_DOM_ID_NOT_PRESENT 	= 0x14,
+	CT_NS_EXP_PORT_NUM_NOT_PRESENT  = 0x15,
+	CT_NS_EXP_NO_DEVICE_ATTACHED 	= 0x16
+};
+
+/*
+ * defintions for the explanation code for all servers
+ */
+enum {
+	CT_EXP_AUTH_EXCEPTION			= 0xF1,
+	CT_EXP_DB_FULL					= 0xF2,
+	CT_EXP_DB_EMPTY					= 0xF3,
+	CT_EXP_PROCESSING_REQ			= 0xF4,
+	CT_EXP_UNABLE_TO_VERIFY_CONN	= 0xF5,
+	CT_EXP_DEVICES_NOT_IN_CMN_ZONE  = 0xF6
+};
+
+/*
+ * Command codes for Name server
+ */
+enum {
+	GS_GID_PN	= 0x0121,	/* Get Id on port name */
+	GS_GPN_ID	= 0x0112,	/* Get port name on ID */
+	GS_GNN_ID	= 0x0113,	/* Get node name on ID */
+	GS_GID_FT	= 0x0171,	/* Get Id on FC4 type */
+	GS_GSPN_ID	= 0x0118,	/* Get symbolic PN on ID */
+	GS_RFT_ID	= 0x0217,	/* Register fc4type on ID */
+	GS_RSPN_ID	= 0x0218,	/* Register symbolic PN on ID */
+	GS_RPN_ID	= 0x0212,	/* Register port name */
+	GS_RNN_ID	= 0x0213,	/* Register node name */
+	GS_RCS_ID	= 0x0214,	/* Register class of service */
+	GS_RPT_ID	= 0x021A,	/* Register port type */
+	GS_GA_NXT	= 0x0100,	/* Get all next */
+	GS_RFF_ID	= 0x021F,	/* Register FC4 Feature		*/
+};
+
+struct fcgs_id_req_s{
+	u32	rsvd:8;
+	u32	dap:24;	/* port identifier */
+};
+#define fcgs_gpnid_req_t struct fcgs_id_req_s
+#define fcgs_gnnid_req_t struct fcgs_id_req_s
+#define fcgs_gspnid_req_t struct fcgs_id_req_s
+
+struct fcgs_gidpn_req_s{
+	wwn_t	port_name;	/* port wwn */
+};
+
+struct fcgs_gidpn_resp_s{
+	u32	rsvd:8;
+	u32	dap:24;	/* port identifier */
+};
+
+/**
+ * RFT_ID
+ */
+struct fcgs_rftid_req_s {
+	u32	rsvd:8;
+	u32	dap:24;		/* port identifier */
+	u32	fc4_type[8];	/* fc4 types */
+};
+
+/**
+ * RFF_ID : Register FC4 features.
+ */
+
+#define FC_GS_FCP_FC4_FEATURE_INITIATOR  0x02
+#define FC_GS_FCP_FC4_FEATURE_TARGET	 0x01
+
+struct fcgs_rffid_req_s{
+    u32    rsvd          :8;
+    u32    dap        	  :24;		/* port identifier	*/
+    u32    rsvd1         :16;
+    u32    fc4ftr_bits   :8;		/* fc4 feature bits	*/
+    u32    fc4_type      :8;		/* corresponding FC4 Type */
+};
+
+/**
+ * GID_FT Request
+ */
+struct fcgs_gidft_req_s{
+	u8	reserved;
+	u8	domain_id;	/* domain, 0 - all fabric */
+	u8	area_id;	/* area, 0 - whole domain */
+	u8	fc4_type;	/* FC_TYPE_FCP for SCSI devices */
+};				/* GID_FT Request */
+
+/**
+ * GID_FT Response
+ */
+struct fcgs_gidft_resp_s {
+	u8		last:1;	/* last port identifier flag */
+	u8		reserved:7;
+	u32	pid:24;	/* port identifier */
+};				/* GID_FT Response */
+
+/**
+ * RSPN_ID
+ */
+struct fcgs_rspnid_req_s{
+	u32	rsvd:8;
+	u32	dap:24;		/* port identifier */
+	u8		spn_len;	/* symbolic port name length */
+	u8		spn[256];	/* symbolic port name */
+};
+
+/**
+ * RPN_ID
+ */
+struct fcgs_rpnid_req_s{
+	u32	rsvd:8;
+	u32	port_id:24;
+	wwn_t		port_name;
+};
+
+/**
+ * RNN_ID
+ */
+struct fcgs_rnnid_req_s{
+	u32	rsvd:8;
+	u32	port_id:24;
+	wwn_t		node_name;
+};
+
+/**
+ * RCS_ID
+ */
+struct fcgs_rcsid_req_s{
+	u32	rsvd:8;
+	u32	port_id:24;
+	u32	cos;
+};
+
+/**
+ * RPT_ID
+ */
+struct fcgs_rptid_req_s{
+	u32	rsvd:8;
+	u32	port_id:24;
+	u32	port_type:8;
+	u32	rsvd1:24;
+};
+
+/**
+ * GA_NXT Request
+ */
+struct fcgs_ganxt_req_s{
+	u32	rsvd:8;
+	u32	port_id:24;
+};
+
+/**
+ * GA_NXT Response
+ */
+struct fcgs_ganxt_rsp_s{
+	u32	port_type:8;	/* Port Type */
+	u32	port_id:24;	/* Port Identifier */
+	wwn_t		port_name;	/* Port Name */
+	u8		spn_len;	/* Length of Symbolic Port Name */
+	char		spn[255];	/* Symbolic Port Name */
+	wwn_t		node_name;	/* Node Name */
+	u8		snn_len;	/* Length of Symbolic Node Name */
+	char		snn[255];	/* Symbolic Node Name */
+	u8		ipa[8];		/* Initial Process Associator */
+	u8		ip[16];		/* IP Address */
+	u32	cos;		/* Class of Service */
+	u32	fc4types[8];	/* FC-4 TYPEs */
+	wwn_t		fabric_port_name;
+					/* Fabric Port Name */
+	u32	rsvd:8;		/* Reserved */
+	u32	hard_addr:24;	/* Hard Address */
+};
+
+/*
+ * Fabric Config Server
+ */
+
+/*
+ * Command codes for Fabric Configuration Server
+ */
+enum {
+	GS_FC_GFN_CMD	= 0x0114,	/* GS FC Get Fabric Name  */
+	GS_FC_GMAL_CMD	= 0x0116,	/* GS FC GMAL  */
+	GS_FC_TRACE_CMD	= 0x0400,	/* GS FC Trace Route */
+	GS_FC_PING_CMD	= 0x0401,	/* GS FC Ping */
+};
+
+/*
+ * Source or Destination Port Tags.
+ */
+enum {
+	GS_FTRACE_TAG_NPORT_ID		= 1,
+	GS_FTRACE_TAG_NPORT_NAME	= 2,
+};
+
+/*
+* Port Value : Could be a Port id or wwn
+ */
+union fcgs_port_val_u{
+	u32	nport_id;
+	wwn_t		nport_wwn;
+};
+
+#define GS_FTRACE_MAX_HOP_COUNT	20
+#define GS_FTRACE_REVISION	1
+
+/*
+ * Ftrace Related Structures.
+ */
+
+/*
+ * STR (Switch Trace) Reject Reason Codes. From FC-SW.
+ */
+enum {
+	GS_FTRACE_STR_CMD_COMPLETED_SUCC	= 0,
+	GS_FTRACE_STR_CMD_NOT_SUPP_IN_NEXT_SWITCH,
+	GS_FTRACE_STR_NO_RESP_FROM_NEXT_SWITCH,
+	GS_FTRACE_STR_MAX_HOP_CNT_REACHED,
+	GS_FTRACE_STR_SRC_PORT_NOT_FOUND,
+	GS_FTRACE_STR_DST_PORT_NOT_FOUND,
+	GS_FTRACE_STR_DEVICES_NOT_IN_COMMON_ZONE,
+	GS_FTRACE_STR_NO_ROUTE_BW_PORTS,
+	GS_FTRACE_STR_NO_ADDL_EXPLN,
+	GS_FTRACE_STR_FABRIC_BUSY,
+	GS_FTRACE_STR_FABRIC_BUILD_IN_PROGRESS,
+	GS_FTRACE_STR_VENDOR_SPECIFIC_ERR_START = 0xf0,
+	GS_FTRACE_STR_VENDOR_SPECIFIC_ERR_END = 0xff,
+};
+
+/*
+ * Ftrace Request
+ */
+struct fcgs_ftrace_req_s{
+	u32	revision;
+	u16	src_port_tag;	/* Source Port tag */
+	u16	src_port_len;	/* Source Port len */
+	union fcgs_port_val_u src_port_val;	/* Source Port value */
+	u16	dst_port_tag;	/* Destination Port tag */
+	u16	dst_port_len;	/* Destination Port len */
+	union fcgs_port_val_u dst_port_val;	/* Destination Port value */
+	u32	token;
+	u8		vendor_id[8];	/* T10 Vendor Identifier */
+	u8		vendor_info[8];	/* Vendor specific Info */
+	u32	max_hop_cnt;	/* Max Hop Count */
+};
+
+/*
+ * Path info structure
+ */
+struct fcgs_ftrace_path_info_s{
+	wwn_t		switch_name;		/* Switch WWN */
+	u32	domain_id;
+	wwn_t		ingress_port_name;	/* Ingress ports wwn */
+	u32	ingress_phys_port_num;	/* Ingress ports physical port
+						 * number
+						 */
+	wwn_t		egress_port_name;	/* Ingress ports wwn */
+	u32	egress_phys_port_num;	/* Ingress ports physical port
+						 * number
+						 */
+};
+
+/*
+ * Ftrace Acc Response
+ */
+struct fcgs_ftrace_resp_s{
+	u32	revision;
+	u32	token;
+	u8		vendor_id[8];		/* T10 Vendor Identifier */
+	u8		vendor_info[8];		/* Vendor specific Info */
+	u32	str_rej_reason_code;	/* STR Reject Reason Code */
+	u32	num_path_info_entries;	/* No. of path info entries */
+	/*
+	 * path info entry/entries.
+	 */
+	struct fcgs_ftrace_path_info_s path_info[1];
+
+};
+
+/*
+* Fabric Config Server : FCPing
+ */
+
+/*
+ * FC Ping Request
+ */
+struct fcgs_fcping_req_s{
+	u32	revision;
+	u16	port_tag;
+	u16	port_len;	/* Port len */
+	union fcgs_port_val_u port_val;	/* Port value */
+	u32	token;
+};
+
+/*
+ * FC Ping Response
+ */
+struct fcgs_fcping_resp_s{
+	u32	token;
+};
+
+/*
+ * Command codes for zone server query.
+ */
+enum {
+	ZS_GZME = 0x0124,	/* Get zone member extended */
+};
+
+/*
+ * ZS GZME request
+ */
+#define ZS_GZME_ZNAMELEN	32
+struct zs_gzme_req_s{
+	u8	znamelen;
+	u8	rsvd[3];
+	u8	zname[ZS_GZME_ZNAMELEN];
+};
+
+enum zs_mbr_type{
+	ZS_MBR_TYPE_PWWN	= 1,
+	ZS_MBR_TYPE_DOMPORT	= 2,
+	ZS_MBR_TYPE_PORTID	= 3,
+	ZS_MBR_TYPE_NWWN	= 4,
+};
+
+struct zs_mbr_wwn_s{
+	u8	mbr_type;
+	u8	rsvd[3];
+	wwn_t	wwn;
+};
+
+struct zs_query_resp_s{
+	u32	nmbrs;	/*  number of zone members */
+	struct zs_mbr_wwn_s	mbr[1];
+};
+
+/*
+ * GMAL Command ( Get ( interconnect Element) Management Address List)
+ * To retrieve the IP Address of a Switch.
+ */
+
+#define CT_GMAL_RESP_PREFIX_TELNET	 "telnet://"
+#define CT_GMAL_RESP_PREFIX_HTTP	 "http://"
+
+/*  GMAL/GFN request */
+struct fcgs_req_s {
+	wwn_t    wwn; 	/* PWWN/NWWN */
+};
+
+#define fcgs_gmal_req_t struct fcgs_req_s
+#define fcgs_gfn_req_t struct fcgs_req_s
+
+/* Accept Response to GMAL */
+struct fcgs_gmal_resp_s {
+	u32 		ms_len;   /* Num of entries */
+	u8     	ms_ma[256];
+};
+
+struct fc_gmal_entry_s {
+	u8  len;
+	u8  prefix[7]; /* like "http://" */
+	u8  ip_addr[248];
+};
+
+#pragma pack()
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/protocol/fc.h patch/drivers/scsi/bfa/include/protocol/fc.h
--- orig/drivers/scsi/bfa/include/protocol/fc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/protocol/fc.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,1105 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __FC_H__
+#define __FC_H__
+
+#include <protocol/types.h>
+
+#pragma pack(1)
+
+/*
+ * Fibre Channel Header Structure (FCHS) definition
+ */
+struct fchs_s {
+#ifdef __BIGENDIAN
+	u32        routing:4;	/* routing bits */
+	u32        cat_info:4;	/* category info */
+#else
+	u32        cat_info:4;	/* category info */
+	u32        routing:4;	/* routing bits */
+#endif
+	u32        d_id:24;	/* destination identifier */
+
+	u32        cs_ctl:8;	/* class specific control */
+	u32        s_id:24;	/* source identifier */
+
+	u32        type:8;		/* data structure type */
+	u32        f_ctl:24;	/* initial frame control */
+
+	u8         seq_id;		/* sequence identifier */
+	u8         df_ctl;		/* data field control */
+	u16        seq_cnt;	/* sequence count */
+
+	u16        ox_id;		/* originator exchange ID */
+	u16        rx_id;		/* responder exchange ID */
+
+	u32        ro;		/* relative offset */
+};
+/*
+ * Fibre Channel BB_E Header Structure
+ */
+struct fcbbehs_s {
+	u16	ver_rsvd;
+	u32	rsvd[2];
+	u32	rsvd__sof;
+};
+
+#define FC_SEQ_ID_MAX		256
+
+/*
+ * routing bit definitions
+ */
+enum {
+	FC_RTG_FC4_DEV_DATA	= 0x0,	/* FC-4 Device Data */
+	FC_RTG_EXT_LINK		= 0x2,	/* Extended Link Data */
+	FC_RTG_FC4_LINK_DATA	= 0x3,	/* FC-4 Link Data */
+	FC_RTG_VIDEO_DATA	= 0x4,	/* Video Data */
+	FC_RTG_EXT_HDR		= 0x5,	/* VFT, IFR or Encapsuled */
+	FC_RTG_BASIC_LINK	= 0x8,	/* Basic Link data */
+	FC_RTG_LINK_CTRL	= 0xC,	/* Link Control */
+};
+
+/*
+ * information category for extended link data and FC-4 Link Data
+ */
+enum {
+	FC_CAT_LD_REQUEST	= 0x2,	/* Request */
+	FC_CAT_LD_REPLY		= 0x3,	/* Reply */
+	FC_CAT_LD_DIAG		= 0xF,	/* for DIAG use only */
+};
+
+/*
+ * information category for extended headers (VFT, IFR or encapsulation)
+ */
+enum {
+	FC_CAT_VFT_HDR = 0x0,	/* Virtual fabric tagging header */
+	FC_CAT_IFR_HDR = 0x1,	/* Inter-Fabric routing header */
+	FC_CAT_ENC_HDR = 0x2,	/* Encapsulation header */
+};
+
+/*
+ * information category for FC-4 device data
+ */
+enum {
+	FC_CAT_UNCATEG_INFO	= 0x0,	/* Uncategorized information */
+	FC_CAT_SOLICIT_DATA	= 0x1,	/* Solicited Data */
+	FC_CAT_UNSOLICIT_CTRL	= 0x2,	/* Unsolicited Control */
+	FC_CAT_SOLICIT_CTRL	= 0x3,	/* Solicited Control */
+	FC_CAT_UNSOLICIT_DATA	= 0x4,	/* Unsolicited Data */
+	FC_CAT_DATA_DESC	= 0x5,	/* Data Descriptor */
+	FC_CAT_UNSOLICIT_CMD	= 0x6,	/* Unsolicited Command */
+	FC_CAT_CMD_STATUS	= 0x7,	/* Command Status */
+};
+
+/*
+ * information category for Link Control
+ */
+enum {
+	FC_CAT_ACK_1		= 0x00,
+	FC_CAT_ACK_0_N		= 0x01,
+	FC_CAT_P_RJT		= 0x02,
+	FC_CAT_F_RJT		= 0x03,
+	FC_CAT_P_BSY		= 0x04,
+	FC_CAT_F_BSY_DATA	= 0x05,
+	FC_CAT_F_BSY_LINK_CTL	= 0x06,
+	FC_CAT_F_LCR		= 0x07,
+	FC_CAT_NTY		= 0x08,
+	FC_CAT_END		= 0x09,
+};
+
+/*
+ * Type Field Definitions. FC-PH Section 18.5 pg. 165
+ */
+enum {
+	FC_TYPE_BLS		= 0x0,	/* Basic Link Service */
+	FC_TYPE_ELS		= 0x1,	/* Extended Link Service */
+	FC_TYPE_IP		= 0x5,	/* IP */
+	FC_TYPE_FCP		= 0x8,	/* SCSI-FCP */
+	FC_TYPE_GPP		= 0x9,	/* SCSI_GPP */
+	FC_TYPE_SERVICES	= 0x20,	/* Fibre Channel Services */
+	FC_TYPE_FC_FSS		= 0x22,	/* Fabric Switch Services */
+	FC_TYPE_FC_AL		= 0x23,	/* FC-AL */
+	FC_TYPE_FC_SNMP		= 0x24,	/* FC-SNMP */
+	FC_TYPE_MAX		= 256,	/* 256 FC-4 types */
+};
+
+struct fc_fc4types_s{
+	u8         bits[FC_TYPE_MAX / 8];
+};
+
+/*
+ * Frame Control Definitions. FC-PH Table-45. pg. 168
+ */
+enum {
+	FCTL_EC_ORIG = 0x000000,	/* exchange originator */
+	FCTL_EC_RESP = 0x800000,	/* exchange responder */
+	FCTL_SEQ_INI = 0x000000,	/* sequence initiator */
+	FCTL_SEQ_REC = 0x400000,	/* sequence recipient */
+	FCTL_FS_EXCH = 0x200000,	/* first sequence of xchg */
+	FCTL_LS_EXCH = 0x100000,	/* last sequence of xchg */
+	FCTL_END_SEQ = 0x080000,	/* last frame of sequence */
+	FCTL_SI_XFER = 0x010000,	/* seq initiative transfer */
+	FCTL_RO_PRESENT = 0x000008,	/* relative offset present */
+	FCTL_FILLBYTE_MASK = 0x000003	/* , fill byte mask */
+};
+
+/*
+ * Fabric Well Known Addresses
+ */
+enum {
+	FC_MIN_WELL_KNOWN_ADDR		= 0xFFFFF0,
+	FC_DOMAIN_CONTROLLER_MASK 	= 0xFFFC00,
+	FC_ALIAS_SERVER			= 0xFFFFF8,
+	FC_MGMT_SERVER			= 0xFFFFFA,
+	FC_TIME_SERVER			= 0xFFFFFB,
+	FC_NAME_SERVER			= 0xFFFFFC,
+	FC_FABRIC_CONTROLLER		= 0xFFFFFD,
+	FC_FABRIC_PORT			= 0xFFFFFE,
+	FC_BROADCAST_SERVER		= 0xFFFFFF
+};
+
+/*
+ * domain/area/port defines
+ */
+#define FC_DOMAIN_MASK  0xFF0000
+#define FC_DOMAIN_SHIFT 16
+#define FC_AREA_MASK    0x00FF00
+#define FC_AREA_SHIFT   8
+#define FC_PORT_MASK    0x0000FF
+#define FC_PORT_SHIFT   0
+
+#define FC_GET_DOMAIN(p)	(((p) & FC_DOMAIN_MASK) >> FC_DOMAIN_SHIFT)
+#define FC_GET_AREA(p)		(((p) & FC_AREA_MASK) >> FC_AREA_SHIFT)
+#define FC_GET_PORT(p)		(((p) & FC_PORT_MASK) >> FC_PORT_SHIFT)
+
+#define FC_DOMAIN_CTRLR(p)	(FC_DOMAIN_CONTROLLER_MASK | (FC_GET_DOMAIN(p)))
+
+enum {
+	FC_RXID_ANY = 0xFFFFU,
+};
+
+/*
+ * generic ELS command
+ */
+struct fc_els_cmd_s{
+	u32        els_code:8;	/* ELS Command Code */
+	u32        reserved:24;
+};
+
+/*
+ * ELS Command Codes. FC-PH Table-75. pg. 223
+ */
+enum {
+	FC_ELS_LS_RJT = 0x1,	/* Link Service Reject. */
+	FC_ELS_ACC = 0x02,	/* Accept */
+	FC_ELS_PLOGI = 0x03,	/* N_Port Login. */
+	FC_ELS_FLOGI = 0x04,	/* F_Port Login. */
+	FC_ELS_LOGO = 0x05,	/* Logout. */
+	FC_ELS_ABTX = 0x06,	/* Abort Exchange */
+	FC_ELS_RES = 0x08,	/* Read Exchange status */
+	FC_ELS_RSS = 0x09,	/* Read sequence status block */
+	FC_ELS_RSI = 0x0A,	/* Request Sequence Initiative */
+	FC_ELS_ESTC = 0x0C,	/* Estimate Credit. */
+	FC_ELS_RTV = 0x0E,	/* Read Timeout Value. */
+	FC_ELS_RLS = 0x0F,	/* Read Link Status. */
+	FC_ELS_ECHO = 0x10,	/* Echo */
+	FC_ELS_TEST = 0x11,	/* Test */
+	FC_ELS_RRQ = 0x12,	/* Reinstate Recovery Qualifier. */
+	FC_ELS_REC = 0x13,	/* Add this for TAPE support in FCR */
+	FC_ELS_PRLI = 0x20,	/* Process Login */
+	FC_ELS_PRLO = 0x21,	/* Process Logout. */
+	FC_ELS_SCN = 0x22,	/* State Change Notification. */
+	FC_ELS_TPRLO = 0x24,	/* Third Party Process Logout. */
+	FC_ELS_PDISC = 0x50,	/* Discover N_Port Parameters. */
+	FC_ELS_FDISC = 0x51,	/* Discover F_Port Parameters. */
+	FC_ELS_ADISC = 0x52,	/* Discover Address. */
+	FC_ELS_FAN = 0x60,	/* Fabric Address Notification */
+	FC_ELS_RSCN = 0x61,	/* Reg State Change Notification */
+	FC_ELS_SCR = 0x62,	/* State Change Registration. */
+	FC_ELS_RTIN = 0x77,	/* Mangement server request */
+	FC_ELS_RNID = 0x78,	/* Mangement server request */
+	FC_ELS_RLIR = 0x79,	/* Registered Link Incident Record */
+
+	FC_ELS_RPSC = 0x7D,	/* Report Port Speed Capabilities */
+	FC_ELS_QSA = 0x7E,	/* Query Security Attributes. Ref FC-SP */
+	FC_ELS_E2E_LBEACON = 0x81,
+				/* End-to-End Link Beacon */
+	FC_ELS_AUTH = 0x90,	/* Authentication. Ref FC-SP */
+	FC_ELS_RFCN = 0x97,	/* Request Fabric Change Notification. Ref
+				 *FC-SP */
+
+};
+
+/*
+ *  Version numbers for FC-PH standards,
+ *  used in login to indicate what port
+ *  supports. See FC-PH-X table 158.
+ */
+enum {
+	FC_PH_VER_4_3 = 0x09,
+	FC_PH_VER_PH_3 = 0x20,
+};
+
+/*
+ * PDU size defines
+ */
+enum {
+	FC_MIN_PDUSZ = 512,
+	FC_MAX_PDUSZ = 2112,
+};
+
+/*
+ * N_Port PLOGI Common Service Parameters.
+ * FC-PH-x. Figure-76. pg. 308.
+ */
+struct fc_plogi_csp_s{
+	u8         verhi;	/* FC-PH high version */
+	u8         verlo;	/* FC-PH low version */
+	u16        bbcred;	/* BB_Credit */
+
+#ifdef __BIGENDIAN
+	u8         ciro:1,		/* continuously increasing RO */
+			rro:1,		/* random relative offset */
+			npiv_supp:1,	/* NPIV supported */
+			port_type:1,	/* N_Port/F_port */
+			altbbcred:1,	/* alternate BB_Credit */
+			resolution:1,	/* ms/ns ED_TOV resolution */
+			vvl_info:1,	/* VVL Info included */
+			reserved1:1;
+
+	u8         hg_supp:1,
+			query_dbc:1,
+			security:1,
+			sync_cap:1,
+			r_t_tov:1,
+			dh_dup_supp:1,
+			cisc:1,		/* continuously increasing seq count */
+			payload:1;
+#else
+	u8         reserved2:2,
+			resolution:1,	/* ms/ns ED_TOV resolution */
+			altbbcred:1,	/* alternate BB_Credit */
+			port_type:1,	/* N_Port/F_port */
+			npiv_supp:1,	/* NPIV supported */
+			rro:1,		/* random relative offset */
+			ciro:1;		/* continuously increasing RO */
+
+	u8         payload:1,
+			cisc:1,		/* continuously increasing seq count */
+			dh_dup_supp:1,
+			r_t_tov:1,
+			sync_cap:1,
+			security:1,
+			query_dbc:1,
+			hg_supp:1;
+#endif
+
+	u16        rxsz;		/* recieve data_field size */
+
+	u16        conseq;
+	u16        ro_bitmap;
+
+	u32        e_d_tov;
+};
+
+/*
+ * N_Port PLOGI Class Specific Parameters.
+ * FC-PH-x. Figure 78. pg. 318.
+ */
+struct fc_plogi_clp_s{
+#ifdef __BIGENDIAN
+	u32        class_valid:1;
+	u32        intermix:1;	/* class intermix supported if set =1.
+					 * valid only for class1. Reserved for
+					 * class2 & class3
+					 */
+	u32        reserved1:2;
+	u32        sequential:1;
+	u32        reserved2:3;
+#else
+	u32        reserved2:3;
+	u32        sequential:1;
+	u32        reserved1:2;
+	u32        intermix:1;	/* class intermix supported if set =1.
+					 * valid only for class1. Reserved for
+					 * class2 & class3
+					 */
+	u32        class_valid:1;
+#endif
+
+	u32        reserved3:24;
+
+	u32        reserved4:16;
+	u32        rxsz:16;	/* Receive data_field size */
+
+	u32        reserved5:8;
+	u32        conseq:8;
+	u32        e2e_credit:16;	/* end to end credit */
+
+	u32        reserved7:8;
+	u32        ospx:8;
+	u32        reserved8:16;
+};
+
+#define FLOGI_VVL_BRCD    0x42524344 /* ASCII value for each character in
+				      * string "BRCD" */
+
+/*
+ * PLOGI els command and reply payload
+ */
+struct fc_logi_s{
+	struct fc_els_cmd_s els_cmd;	/* ELS command code */
+	struct fc_plogi_csp_s  csp;		/* common service params */
+	wwn_t           port_name;
+	wwn_t           node_name;
+	struct fc_plogi_clp_s  class1;		/* class 1 service parameters */
+	struct fc_plogi_clp_s  class2;		/* class 2 service parameters */
+	struct fc_plogi_clp_s  class3;		/* class 3 service parameters */
+	struct fc_plogi_clp_s  class4;		/* class 4 service parameters */
+	u8         vvl[16];	/* vendor version level */
+};
+
+/*
+ * LOGO els command payload
+ */
+struct fc_logo_s{
+	struct fc_els_cmd_s    els_cmd;	/* ELS command code */
+	u32        res1:8;
+	u32        nport_id:24;	/* N_Port identifier of source */
+	wwn_t           orig_port_name;	/* Port name of the LOGO originator */
+};
+
+/*
+ * ADISC els command payload
+ */
+struct fc_adisc_s {
+	struct fc_els_cmd_s    els_cmd;	/* ELS command code */
+	u32        res1:8;
+	u32        orig_HA:24;	/* originator hard address */
+	wwn_t           orig_port_name;	/* originator port name */
+	wwn_t           orig_node_name;	/* originator node name */
+	u32        res2:8;
+	u32        nport_id:24;	/* originator NPortID */
+};
+
+/*
+ * Exchange status block
+ */
+struct fc_exch_status_blk_s{
+	u32        oxid:16;
+	u32        rxid:16;
+	u32        res1:8;
+	u32        orig_np:24;	/* originator NPortID */
+	u32        res2:8;
+	u32        resp_np:24;	/* responder NPortID */
+	u32        es_bits;
+	u32        res3;
+	/*
+	 * un modified section of the fields
+	 */
+};
+
+/*
+ * RES els command payload
+ */
+struct fc_res_s {
+	struct fc_els_cmd_s    els_cmd;	/* ELS command code */
+	u32        res1:8;
+	u32        nport_id:24;	/* N_Port identifier of source */
+	u32        oxid:16;
+	u32        rxid:16;
+	u8         assoc_hdr[32];
+};
+
+/*
+ * RES els accept payload
+ */
+struct fc_res_acc_s{
+	struct fc_els_cmd_s els_cmd;	/* ELS command code */
+	struct fc_exch_status_blk_s fc_exch_blk; /* Exchange status block */
+};
+
+/*
+ * REC els command payload
+ */
+struct fc_rec_s {
+	struct fc_els_cmd_s    els_cmd;	/* ELS command code */
+	u32        res1:8;
+	u32        nport_id:24;	/* N_Port identifier of source */
+	u32        oxid:16;
+	u32        rxid:16;
+};
+
+#define FC_REC_ESB_OWN_RSP	0x80000000	/* responder owns */
+#define FC_REC_ESB_SI		0x40000000	/* SI is owned 	*/
+#define FC_REC_ESB_COMP		0x20000000	/* exchange is complete	*/
+#define FC_REC_ESB_ENDCOND_ABN	0x10000000	/* abnormal ending 	*/
+#define FC_REC_ESB_RQACT	0x04000000	/* recovery qual active	*/
+#define FC_REC_ESB_ERRP_MSK	0x03000000
+#define FC_REC_ESB_OXID_INV	0x00800000	/* invalid OXID		*/
+#define FC_REC_ESB_RXID_INV	0x00400000	/* invalid RXID		*/
+#define FC_REC_ESB_PRIO_INUSE	0x00200000
+
+/*
+ * REC els accept payload
+ */
+struct fc_rec_acc_s {
+	struct fc_els_cmd_s    els_cmd;	/* ELS command code */
+	u32        oxid:16;
+	u32        rxid:16;
+	u32        res1:8;
+	u32        orig_id:24;	/* N_Port id of exchange originator */
+	u32        res2:8;
+	u32        resp_id:24;	/* N_Port id of exchange responder */
+	u32        count;		/* data transfer count */
+	u32        e_stat;		/* exchange status */
+};
+
+/*
+ * RSI els payload
+ */
+struct fc_rsi_s {
+	struct fc_els_cmd_s    els_cmd;
+	u32        res1:8;
+	u32        orig_sid:24;
+	u32        oxid:16;
+	u32        rxid:16;
+};
+
+/*
+ * structure for PRLI paramater pages, both request & response
+ * see FC-PH-X table 113 & 115 for explanation also FCP table 8
+ */
+struct fc_prli_params_s{
+	u32        reserved: 16;
+#ifdef __BIGENDIAN
+	u32        reserved1: 5;
+	u32        rec_support : 1;
+	u32        task_retry_id : 1;
+	u32        retry : 1;
+
+	u32        confirm : 1;
+	u32        doverlay:1;
+	u32        initiator:1;
+	u32        target:1;
+	u32        cdmix:1;
+	u32        drmix:1;
+	u32        rxrdisab:1;
+	u32        wxrdisab:1;
+#else
+	u32        retry : 1;
+	u32        task_retry_id : 1;
+	u32        rec_support : 1;
+	u32        reserved1: 5;
+
+	u32        wxrdisab:1;
+	u32        rxrdisab:1;
+	u32        drmix:1;
+	u32        cdmix:1;
+	u32        target:1;
+	u32        initiator:1;
+	u32        doverlay:1;
+	u32        confirm : 1;
+#endif
+};
+
+/*
+ * valid values for rspcode in PRLI ACC payload
+ */
+enum {
+	FC_PRLI_ACC_XQTD = 0x1,		/* request executed */
+	FC_PRLI_ACC_PREDEF_IMG = 0x5,	/* predefined image - no prli needed */
+};
+
+struct fc_prli_params_page_s{
+	u32        type:8;
+	u32        codext:8;
+#ifdef __BIGENDIAN
+	u32        origprocasv:1;
+	u32        rsppav:1;
+	u32        imagepair:1;
+	u32        reserved1:1;
+	u32        rspcode:4;
+#else
+	u32        rspcode:4;
+	u32        reserved1:1;
+	u32        imagepair:1;
+	u32        rsppav:1;
+	u32        origprocasv:1;
+#endif
+	u32        reserved2:8;
+
+	u32        origprocas;
+	u32        rspprocas;
+	struct fc_prli_params_s  servparams;
+};
+
+/*
+ * PRLI request and accept payload, FC-PH-X tables 112 & 114
+ */
+struct fc_prli_s{
+	u32        command:8;
+	u32        pglen:8;
+	u32        pagebytes:16;
+	struct fc_prli_params_page_s parampage;
+};
+
+/*
+ * PRLO logout params page
+ */
+struct fc_prlo_params_page_s{
+	u32        type:8;
+	u32        type_ext:8;
+#ifdef __BIGENDIAN
+	u32        opa_valid:1;	/* originator process associator
+					 * valid
+					 */
+	u32        rpa_valid:1;	/* responder process associator valid */
+	u32        res1:14;
+#else
+	u32        res1:14;
+	u32        rpa_valid:1;	/* responder process associator valid */
+	u32        opa_valid:1;	/* originator process associator
+					 * valid
+					 */
+#endif
+	u32        orig_process_assc;
+	u32        resp_process_assc;
+
+	u32        res2;
+};
+
+/*
+ * PRLO els command payload
+ */
+struct fc_prlo_s{
+	u32        	command:8;
+	u32        	page_len:8;
+	u32        	payload_len:16;
+	struct fc_prlo_params_page_s 	prlo_params[1];
+};
+
+/*
+ * PRLO Logout response parameter page
+ */
+struct fc_prlo_acc_params_page_s{
+	u32        type:8;
+	u32        type_ext:8;
+
+#ifdef __BIGENDIAN
+	u32        opa_valid:1;	/* originator process associator
+					 * valid
+					 */
+	u32        rpa_valid:1;	/* responder process associator valid */
+	u32        res1:14;
+#else
+	u32        res1:14;
+	u32        rpa_valid:1;	/* responder process associator valid */
+	u32        opa_valid:1;	/* originator process associator
+					 * valid
+					 */
+#endif
+	u32        orig_process_assc;
+	u32        resp_process_assc;
+
+	u32        fc4type_csp;
+};
+
+/*
+ * PRLO els command ACC payload
+ */
+struct fc_prlo_acc_s{
+	u32        command:8;
+	u32        page_len:8;
+	u32        payload_len:16;
+	struct fc_prlo_acc_params_page_s prlo_acc_params[1];
+};
+
+/*
+ * SCR els command payload
+ */
+enum {
+	FC_SCR_REG_FUNC_FABRIC_DETECTED = 0x01,
+	FC_SCR_REG_FUNC_N_PORT_DETECTED = 0x02,
+	FC_SCR_REG_FUNC_FULL = 0x03,
+	FC_SCR_REG_FUNC_CLEAR_REG = 0xFF,
+};
+
+/* SCR VU registrations */
+enum {
+	FC_VU_SCR_REG_FUNC_FABRIC_NAME_CHANGE = 0x01
+};
+
+struct fc_scr_s{
+	u32 command:8;
+	u32 res:24;
+	u32 vu_reg_func:8; /* Vendor Unique Registrations */
+	u32 res1:16;
+	u32 reg_func:8;
+};
+
+/*
+ * Information category for Basic link data
+ */
+enum {
+	FC_CAT_NOP	= 0x0,
+	FC_CAT_ABTS	= 0x1,
+	FC_CAT_RMC	= 0x2,
+	FC_CAT_BA_ACC	= 0x4,
+	FC_CAT_BA_RJT	= 0x5,
+	FC_CAT_PRMT	= 0x6,
+};
+
+/*
+ * LS_RJT els reply payload
+ */
+struct fc_ls_rjt_s {
+	struct fc_els_cmd_s    els_cmd;		/* ELS command code */
+	u32        res1:8;
+	u32        reason_code:8;		/* Reason code for reject */
+	u32        reason_code_expl:8;	/* Reason code explanation */
+	u32        vendor_unique:8;	/* Vendor specific */
+};
+
+/*
+ * LS_RJT reason codes
+ */
+enum {
+	FC_LS_RJT_RSN_INV_CMD_CODE	= 0x01,
+	FC_LS_RJT_RSN_LOGICAL_ERROR	= 0x03,
+	FC_LS_RJT_RSN_LOGICAL_BUSY	= 0x05,
+	FC_LS_RJT_RSN_PROTOCOL_ERROR	= 0x07,
+	FC_LS_RJT_RSN_UNABLE_TO_PERF_CMD = 0x09,
+	FC_LS_RJT_RSN_CMD_NOT_SUPP	= 0x0B,
+};
+
+/*
+ * LS_RJT reason code explanation
+ */
+enum {
+	FC_LS_RJT_EXP_NO_ADDL_INFO		= 0x00,
+	FC_LS_RJT_EXP_SPARMS_ERR_OPTIONS	= 0x01,
+	FC_LS_RJT_EXP_SPARMS_ERR_INI_CTL	= 0x03,
+	FC_LS_RJT_EXP_SPARMS_ERR_REC_CTL	= 0x05,
+	FC_LS_RJT_EXP_SPARMS_ERR_RXSZ		= 0x07,
+	FC_LS_RJT_EXP_SPARMS_ERR_CONSEQ		= 0x09,
+	FC_LS_RJT_EXP_SPARMS_ERR_CREDIT		= 0x0B,
+	FC_LS_RJT_EXP_INV_PORT_NAME		= 0x0D,
+	FC_LS_RJT_EXP_INV_NODE_FABRIC_NAME	= 0x0E,
+	FC_LS_RJT_EXP_INV_CSP			= 0x0F,
+	FC_LS_RJT_EXP_INV_ASSOC_HDR		= 0x11,
+	FC_LS_RJT_EXP_ASSOC_HDR_REQD		= 0x13,
+	FC_LS_RJT_EXP_INV_ORIG_S_ID		= 0x15,
+	FC_LS_RJT_EXP_INV_OXID_RXID_COMB	= 0x17,
+	FC_LS_RJT_EXP_CMD_ALREADY_IN_PROG	= 0x19,
+	FC_LS_RJT_EXP_LOGIN_REQUIRED		= 0x1E,
+	FC_LS_RJT_EXP_INVALID_NPORT_ID		= 0x1F,
+	FC_LS_RJT_EXP_INSUFF_RES		= 0x29,
+	FC_LS_RJT_EXP_CMD_NOT_SUPP		= 0x2C,
+	FC_LS_RJT_EXP_INV_PAYLOAD_LEN		= 0x2D,
+};
+
+/*
+ * RRQ els command payload
+ */
+struct fc_rrq_s{
+	struct fc_els_cmd_s    els_cmd;	/* ELS command code */
+	u32        res1:8;
+	u32        s_id:24;	/* exchange originator S_ID */
+
+	u32        ox_id:16;	/* originator exchange ID */
+	u32        rx_id:16;	/* responder exchange ID */
+
+	u32        res2[8];	/* optional association header */
+};
+
+/*
+ * ABTS BA_ACC reply payload
+ */
+struct fc_ba_acc_s{
+	u32        seq_id_valid:8;	/* set to 0x00 for Abort Exchange */
+	u32        seq_id:8;	/* invalid for Abort Exchange */
+	u32        res2:16;
+	u32        ox_id:16;	/* OX_ID from ABTS frame */
+	u32        rx_id:16;	/* RX_ID from ABTS frame */
+	u32        low_seq_cnt:16;	/* set to 0x0000 for Abort Exchange */
+	u32        high_seq_cnt:16;/* set to 0xFFFF for Abort Exchange */
+};
+
+/*
+ * ABTS BA_RJT reject payload
+ */
+struct fc_ba_rjt_s{
+	u32        res1:8;		/* Reserved */
+	u32        reason_code:8;	/* reason code for reject */
+	u32        reason_expl:8;	/* reason code explanation */
+	u32        vendor_unique:8;/* vendor unique reason code,set to 0 */
+};
+
+/*
+ * TPRLO logout parameter page
+ */
+struct fc_tprlo_params_page_s{
+	u32        type:8;
+	u32        type_ext:8;
+
+#ifdef __BIGENDIAN
+	u32        opa_valid:1;
+	u32        rpa_valid:1;
+	u32        tpo_nport_valid:1;
+	u32        global_process_logout:1;
+	u32        res1:12;
+#else
+	u32        res1:12;
+	u32        global_process_logout:1;
+	u32        tpo_nport_valid:1;
+	u32        rpa_valid:1;
+	u32        opa_valid:1;
+#endif
+
+	u32        orig_process_assc;
+	u32        resp_process_assc;
+
+	u32        res2:8;
+	u32        tpo_nport_id;
+};
+
+/*
+ * TPRLO ELS command payload
+ */
+struct fc_tprlo_s{
+	u32        command:8;
+	u32        page_len:8;
+	u32        payload_len:16;
+
+	struct fc_tprlo_params_page_s tprlo_params[1];
+};
+
+enum fc_tprlo_type{
+	FC_GLOBAL_LOGO = 1,
+	FC_TPR_LOGO
+};
+
+/*
+ * TPRLO els command ACC payload
+ */
+struct fc_tprlo_acc_s{
+	u32	command:8;
+	u32	page_len:8;
+	u32	payload_len:16;
+	struct fc_prlo_acc_params_page_s tprlo_acc_params[1];
+};
+
+/*
+ * RSCN els command req payload
+ */
+#define FC_RSCN_PGLEN	0x4
+
+enum fc_rscn_format{
+	FC_RSCN_FORMAT_PORTID	= 0x0,
+	FC_RSCN_FORMAT_AREA	= 0x1,
+	FC_RSCN_FORMAT_DOMAIN	= 0x2,
+	FC_RSCN_FORMAT_FABRIC	= 0x3,
+};
+
+struct fc_rscn_event_s{
+	u32        format:2;
+	u32        qualifier:4;
+	u32        resvd:2;
+	u32        portid:24;
+};
+
+struct fc_rscn_pl_s{
+	u8         command;
+	u8         pagelen;
+	u16        payldlen;
+	struct fc_rscn_event_s event[1];
+};
+
+/*
+ * ECHO els command req payload
+ */
+struct fc_echo_s {
+	struct fc_els_cmd_s    els_cmd;
+};
+
+/*
+ * RNID els command
+ */
+
+#define RNID_NODEID_DATA_FORMAT_COMMON    		 0x00
+#define RNID_NODEID_DATA_FORMAT_FCP3        		 0x08
+#define RNID_NODEID_DATA_FORMAT_DISCOVERY     		0xDF
+
+#define RNID_ASSOCIATED_TYPE_UNKNOWN                    0x00000001
+#define RNID_ASSOCIATED_TYPE_OTHER                      0x00000002
+#define RNID_ASSOCIATED_TYPE_HUB                        0x00000003
+#define RNID_ASSOCIATED_TYPE_SWITCH                     0x00000004
+#define RNID_ASSOCIATED_TYPE_GATEWAY                    0x00000005
+#define RNID_ASSOCIATED_TYPE_STORAGE_DEVICE             0x00000009
+#define RNID_ASSOCIATED_TYPE_HOST                       0x0000000A
+#define RNID_ASSOCIATED_TYPE_STORAGE_SUBSYSTEM          0x0000000B
+#define RNID_ASSOCIATED_TYPE_STORAGE_ACCESS_DEVICE      0x0000000E
+#define RNID_ASSOCIATED_TYPE_NAS_SERVER                 0x00000011
+#define RNID_ASSOCIATED_TYPE_BRIDGE                     0x00000002
+#define RNID_ASSOCIATED_TYPE_VIRTUALIZATION_DEVICE      0x00000003
+#define RNID_ASSOCIATED_TYPE_MULTI_FUNCTION_DEVICE      0x000000FF
+
+/*
+ * RNID els command payload
+ */
+struct fc_rnid_cmd_s{
+	struct fc_els_cmd_s    els_cmd;
+	u32        node_id_data_format:8;
+	u32        reserved:24;
+};
+
+/*
+ * RNID els response payload
+ */
+
+struct fc_rnid_common_id_data_s{
+	wwn_t           port_name;
+	wwn_t           node_name;
+};
+
+struct fc_rnid_general_topology_data_s{
+	u32        vendor_unique[4];
+	u32        asso_type;
+	u32        phy_port_num;
+	u32        num_attached_nodes;
+	u32        node_mgmt:8;
+	u32        ip_version:8;
+	u32        udp_tcp_port_num:16;
+	u32        ip_address[4];
+	u32        reserved:16;
+	u32        vendor_specific:16;
+};
+
+struct fc_rnid_acc_s{
+	struct fc_els_cmd_s    els_cmd;
+	u32        node_id_data_format:8;
+	u32        common_id_data_length:8;
+	u32        reserved:8;
+	u32        specific_id_data_length:8;
+	struct fc_rnid_common_id_data_s common_id_data;
+	struct fc_rnid_general_topology_data_s gen_topology_data;
+};
+
+#define RNID_ASSOCIATED_TYPE_UNKNOWN                    0x00000001
+#define RNID_ASSOCIATED_TYPE_OTHER                      0x00000002
+#define RNID_ASSOCIATED_TYPE_HUB                        0x00000003
+#define RNID_ASSOCIATED_TYPE_SWITCH                     0x00000004
+#define RNID_ASSOCIATED_TYPE_GATEWAY                    0x00000005
+#define RNID_ASSOCIATED_TYPE_STORAGE_DEVICE             0x00000009
+#define RNID_ASSOCIATED_TYPE_HOST                       0x0000000A
+#define RNID_ASSOCIATED_TYPE_STORAGE_SUBSYSTEM          0x0000000B
+#define RNID_ASSOCIATED_TYPE_STORAGE_ACCESS_DEVICE      0x0000000E
+#define RNID_ASSOCIATED_TYPE_NAS_SERVER                 0x00000011
+#define RNID_ASSOCIATED_TYPE_BRIDGE                     0x00000002
+#define RNID_ASSOCIATED_TYPE_VIRTUALIZATION_DEVICE      0x00000003
+#define RNID_ASSOCIATED_TYPE_MULTI_FUNCTION_DEVICE      0x000000FF
+
+enum fc_rpsc_speed_cap{
+	RPSC_SPEED_CAP_1G = 0x8000,
+	RPSC_SPEED_CAP_2G = 0x4000,
+	RPSC_SPEED_CAP_4G = 0x2000,
+	RPSC_SPEED_CAP_10G = 0x1000,
+	RPSC_SPEED_CAP_8G = 0x0800,
+	RPSC_SPEED_CAP_16G = 0x0400,
+
+	RPSC_SPEED_CAP_UNKNOWN = 0x0001,
+};
+
+enum fc_rpsc_op_speed_s{
+	RPSC_OP_SPEED_1G = 0x8000,
+	RPSC_OP_SPEED_2G = 0x4000,
+	RPSC_OP_SPEED_4G = 0x2000,
+	RPSC_OP_SPEED_10G = 0x1000,
+	RPSC_OP_SPEED_8G = 0x0800,
+	RPSC_OP_SPEED_16G = 0x0400,
+
+	RPSC_OP_SPEED_NOT_EST = 0x0001,	/*! speed not established */
+};
+
+struct fc_rpsc_speed_info_s{
+	u16        port_speed_cap;	/*! see fc_rpsc_speed_cap_t */
+	u16        port_op_speed;	/*! see fc_rpsc_op_speed_t */
+};
+
+enum link_e2e_beacon_subcmd{
+	LINK_E2E_BEACON_ON = 1,
+	LINK_E2E_BEACON_OFF = 2
+};
+
+enum beacon_type{
+	BEACON_TYPE_NORMAL	= 1,	/*! Normal Beaconing. Green */
+	BEACON_TYPE_WARN	= 2,	/*! Warning Beaconing. Yellow/Amber */
+	BEACON_TYPE_CRITICAL	= 3	/*! Critical Beaconing. Red */
+};
+
+struct link_e2e_beacon_param_s {
+	u8         beacon_type;	/* Beacon Type. See beacon_type_t */
+	u8         beacon_frequency;
+					/* Beacon frequency. Number of blinks
+					 * per 10 seconds
+					 */
+	u16        beacon_duration;/* Beacon duration (in Seconds). The
+					 * command operation should be
+					 * terminated at the end of this
+					 * timeout value.
+					 *
+					 * Ignored if diag_sub_cmd is
+					 * LINK_E2E_BEACON_OFF.
+					 *
+					 * If 0, beaconing will continue till a
+					 * BEACON OFF request is received
+					 */
+};
+
+/*
+ * Link E2E beacon request/good response format. For LS_RJTs use fc_ls_rjt_t
+ */
+struct link_e2e_beacon_req_s{
+	u32        ls_code;	/*! FC_ELS_E2E_LBEACON in requests *
+					 *or FC_ELS_ACC in good replies */
+	u32        ls_sub_cmd;	/*! See link_e2e_beacon_subcmd_t */
+	struct link_e2e_beacon_param_s beacon_parm;
+};
+
+/**
+ * If RPSC request is sent to the Domain Controller, the request is for
+ * all the ports within that domain (TODO - I don't think FOS implements
+ * this...).
+ */
+struct fc_rpsc_cmd_s{
+	struct fc_els_cmd_s    els_cmd;
+};
+
+/*
+ * RPSC Acc
+ */
+struct fc_rpsc_acc_s{
+	u32        command:8;
+	u32        rsvd:8;
+	u32        num_entries:16;
+
+	struct fc_rpsc_speed_info_s speed_info[1];
+};
+
+/**
+ * If RPSC2 request is sent to the Domain Controller,
+ */
+#define FC_BRCD_TOKEN    0x42524344
+
+struct fc_rpsc2_cmd_s{
+	struct fc_els_cmd_s    els_cmd;
+	u32       	token;
+	u16     	resvd;
+	u16     	num_pids;       /* Number of pids in the request */
+	struct  {
+		u32	rsvd1:8;
+		u32	pid:24;	/* port identifier */
+	} pid_list[1];
+};
+
+enum fc_rpsc2_port_type{
+	RPSC2_PORT_TYPE_UNKNOWN = 0,
+	RPSC2_PORT_TYPE_NPORT   = 1,
+	RPSC2_PORT_TYPE_NLPORT  = 2,
+	RPSC2_PORT_TYPE_NPIV_PORT  = 0x5f,
+	RPSC2_PORT_TYPE_NPORT_TRUNK  = 0x6f,
+};
+
+/*
+ * RPSC2 portInfo entry structure
+ */
+struct fc_rpsc2_port_info_s{
+    u32    pid;        /* PID */
+    u16    resvd1;
+    u16    index;      /* port number / index */
+    u8     resvd2;
+    u8    	type;        /* port type N/NL/... */
+    u16    speed;      /* port Operating Speed */
+};
+
+/*
+ * RPSC2 Accept payload
+ */
+struct fc_rpsc2_acc_s{
+	u8        els_cmd;
+	u8        resvd;
+	u16       num_pids;  /* Number of pids in the request */
+	struct fc_rpsc2_port_info_s  port_info[1];    /* port information */
+};
+
+/**
+ * bit fields so that multiple classes can be specified
+ */
+enum fc_cos{
+	FC_CLASS_2	= 0x04,
+	FC_CLASS_3	= 0x08,
+	FC_CLASS_2_3	= 0x0C,
+};
+
+/*
+ * symbolic name
+ */
+struct fc_symname_s{
+	u8         symname[FC_SYMNAME_MAX];
+};
+
+struct fc_alpabm_s{
+	u8         alpa_bm[FC_ALPA_MAX / 8];
+};
+
+/*
+ * protocol default timeout values
+ */
+#define FC_ED_TOV		2
+#define FC_REC_TOV		(FC_ED_TOV + 1)
+#define FC_RA_TOV		10
+#define FC_ELS_TOV		(2 * FC_RA_TOV)
+
+/*
+ * virtual fabric related defines
+ */
+#define FC_VF_ID_NULL    0	/*  must not be used as VF_ID */
+#define FC_VF_ID_MIN     1
+#define FC_VF_ID_MAX     0xEFF
+#define FC_VF_ID_CTL     0xFEF	/*  control VF_ID */
+
+/**
+ * Virtual Fabric Tagging header format
+ * @caution This is defined only in BIG ENDIAN format.
+ */
+struct fc_vft_s{
+	u32        r_ctl:8;
+	u32        ver:2;
+	u32        type:4;
+	u32        res_a:2;
+	u32        priority:3;
+	u32        vf_id:12;
+	u32        res_b:1;
+	u32        hopct:8;
+	u32        res_c:24;
+};
+
+#pragma pack()
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/protocol/fcp.h patch/drivers/scsi/bfa/include/protocol/fcp.h
--- orig/drivers/scsi/bfa/include/protocol/fcp.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/protocol/fcp.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,186 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __FCPPROTO_H__
+#define __FCPPROTO_H__
+
+#include <protocol/scsi.h>
+
+#pragma pack(1)
+
+enum {
+	FCP_RJT		= 0x01000000,	/* SRR reject */
+	FCP_SRR_ACCEPT	= 0x02000000,	/* SRR accept */
+	FCP_SRR		= 0x14000000,	/* Sequence Retransmission Request */
+};
+
+/*
+ * SRR FC-4 LS payload
+ */
+struct fc_srr_s{
+	u32	ls_cmd;
+	u32        ox_id:16;	/* ox-id */
+	u32        rx_id:16;	/* rx-id */
+	u32        ro;		/* relative offset */
+	u32        r_ctl:8;		/* R_CTL for I.U. */
+	u32        res:24;
+};
+
+
+/*
+ * FCP_CMND definitions
+ */
+#define FCP_CMND_CDB_LEN    16
+#define FCP_CMND_LUN_LEN    8
+
+struct fcp_cmnd_s{
+	lun_t           lun;		/* 64-bit LU number */
+	u8         crn;		/* command reference number */
+#ifdef __BIGENDIAN
+	u8         resvd:1,
+			priority:4,	/* FCP-3: SAM-3 priority */
+			taskattr:3;	/* scsi task attribute */
+#else
+	u8         taskattr:3,	/* scsi task attribute */
+			priority:4,	/* FCP-3: SAM-3 priority */
+			resvd:1;
+#endif
+	u8         tm_flags;	/* task management flags */
+#ifdef __BIGENDIAN
+	u8         addl_cdb_len:6,	/* additional CDB length words */
+			iodir:2;	/* read/write FCP_DATA IUs */
+#else
+	u8         iodir:2,	/* read/write FCP_DATA IUs */
+			addl_cdb_len:6;	/* additional CDB length */
+#endif
+	struct scsi_cdb_s      cdb;
+
+	/*
+	 * !!! additional cdb bytes follows here!!!
+	 */
+	u32        fcp_dl;	/* bytes to be transferred */
+};
+
+#define fcp_cmnd_cdb_len(_cmnd) ((_cmnd)->addl_cdb_len * 4 + FCP_CMND_CDB_LEN)
+#define fcp_cmnd_fcpdl(_cmnd)	((&(_cmnd)->fcp_dl)[(_cmnd)->addl_cdb_len])
+
+/*
+ * fcp_cmnd_t.iodir field values
+ */
+enum fcp_iodir{
+	FCP_IODIR_NONE	= 0,
+	FCP_IODIR_WRITE = 1,
+	FCP_IODIR_READ	= 2,
+	FCP_IODIR_RW	= 3,
+};
+
+/*
+ * Task attribute field
+ */
+enum {
+	FCP_TASK_ATTR_SIMPLE	= 0,
+	FCP_TASK_ATTR_HOQ	= 1,
+	FCP_TASK_ATTR_ORDERED	= 2,
+	FCP_TASK_ATTR_ACA	= 4,
+	FCP_TASK_ATTR_UNTAGGED	= 5,	/* obsolete in FCP-3 */
+};
+
+/*
+ * Task management flags field - only one bit shall be set
+ */
+#ifndef BIT
+#define BIT(_x)	(1 << (_x))
+#endif
+enum fcp_tm_cmnd{
+	FCP_TM_ABORT_TASK_SET	= BIT(1),
+	FCP_TM_CLEAR_TASK_SET	= BIT(2),
+	FCP_TM_LUN_RESET	= BIT(4),
+	FCP_TM_TARGET_RESET	= BIT(5),	/* obsolete in FCP-3 */
+	FCP_TM_CLEAR_ACA	= BIT(6),
+};
+
+/*
+ * FCP_XFER_RDY IU defines
+ */
+struct fcp_xfer_rdy_s{
+	u32        data_ro;
+	u32        burst_len;
+	u32        reserved;
+};
+
+/*
+ * FCP_RSP residue flags
+ */
+enum fcp_residue{
+	FCP_NO_RESIDUE = 0,	/* no residue */
+	FCP_RESID_OVER = 1,	/* more data left that was not sent */
+	FCP_RESID_UNDER = 2,	/* less data than requested */
+};
+
+enum {
+	FCP_RSPINFO_GOOD = 0,
+	FCP_RSPINFO_DATALEN_MISMATCH = 1,
+	FCP_RSPINFO_CMND_INVALID = 2,
+	FCP_RSPINFO_ROLEN_MISMATCH = 3,
+	FCP_RSPINFO_TM_NOT_SUPP = 4,
+	FCP_RSPINFO_TM_FAILED = 5,
+};
+
+struct fcp_rspinfo_s{
+	u32        res0:24;
+	u32        rsp_code:8;	/* response code (as above) */
+	u32        res1;
+};
+
+struct fcp_resp_s{
+	u32        reserved[2];	/* 2 words reserved */
+	u16        reserved2;
+#ifdef __BIGENDIAN
+	u8         reserved3:3;
+	u8         fcp_conf_req:1;	/* FCP_CONF is requested */
+	u8         resid_flags:2;	/* underflow/overflow */
+	u8         sns_len_valid:1;/* sense len is valid */
+	u8         rsp_len_valid:1;/* response len is valid */
+#else
+	u8         rsp_len_valid:1;/* response len is valid */
+	u8         sns_len_valid:1;/* sense len is valid */
+	u8         resid_flags:2;	/* underflow/overflow */
+	u8         fcp_conf_req:1;	/* FCP_CONF is requested */
+	u8         reserved3:3;
+#endif
+	u8         scsi_status;	/* one byte SCSI status */
+	u32        residue;	/* residual data bytes */
+	u32        sns_len;	/* length od sense info */
+	u32        rsp_len;	/* length of response info */
+};
+
+#define fcp_snslen(__fcprsp)	((__fcprsp)->sns_len_valid ? 		\
+					(__fcprsp)->sns_len : 0)
+#define fcp_rsplen(__fcprsp)	((__fcprsp)->rsp_len_valid ? 		\
+					(__fcprsp)->rsp_len : 0)
+#define fcp_rspinfo(__fcprsp)	((struct fcp_rspinfo_s *)((__fcprsp) + 1))
+#define fcp_snsinfo(__fcprsp)	(((u8 *)fcp_rspinfo(__fcprsp)) + 	\
+						fcp_rsplen(__fcprsp))
+
+struct fcp_cmnd_fr_s{
+	struct fchs_s          fchs;
+	struct fcp_cmnd_s      fcp;
+};
+
+#pragma pack()
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/protocol/fc_sp.h patch/drivers/scsi/bfa/include/protocol/fc_sp.h
--- orig/drivers/scsi/bfa/include/protocol/fc_sp.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/protocol/fc_sp.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,224 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __FC_SP_H__
+#define __FC_SP_H__
+
+#include <protocol/types.h>
+
+#pragma pack(1)
+
+enum auth_els_flags{
+	FC_AUTH_ELS_MORE_FRAGS_FLAG 	= 0x80,	/*! bit-7. More Fragments
+						 * Follow
+						 */
+	FC_AUTH_ELS_CONCAT_FLAG 	= 0x40,	/*! bit-6. Concatenation Flag */
+	FC_AUTH_ELS_SEQ_NUM_FLAG 	= 0x01 	/*! bit-0. Sequence Number */
+};
+
+enum auth_msg_codes{
+	FC_AUTH_MC_AUTH_RJT		= 0x0A,	/*! Auth Reject */
+	FC_AUTH_MC_AUTH_NEG 		= 0x0B, /*! Auth Negotiate */
+	FC_AUTH_MC_AUTH_DONE 		= 0x0C, /*! Auth Done */
+
+	FC_AUTH_MC_DHCHAP_CHAL 		= 0x10, /*! DHCHAP Challenge */
+	FC_AUTH_MC_DHCHAP_REPLY 	= 0x11, /*! DHCHAP Reply */
+	FC_AUTH_MC_DHCHAP_SUCC 		= 0x12, /*! DHCHAP Success */
+
+	FC_AUTH_MC_FCAP_REQ 		= 0x13, /*! FCAP Request */
+	FC_AUTH_MC_FCAP_ACK 		= 0x14, /*! FCAP Acknowledge */
+	FC_AUTH_MC_FCAP_CONF 		= 0x15, /*! FCAP Confirm */
+
+	FC_AUTH_MC_FCPAP_INIT 		= 0x16, /*! FCPAP Init */
+	FC_AUTH_MC_FCPAP_ACC 		= 0x17, /*! FCPAP Accept */
+	FC_AUTH_MC_FCPAP_COMP 		= 0x18, /*! FCPAP Complete */
+
+	FC_AUTH_MC_IKE_SA_INIT 		= 0x22, /*! IKE SA INIT */
+	FC_AUTH_MC_IKE_SA_AUTH 		= 0x23, /*! IKE SA Auth */
+	FC_AUTH_MC_IKE_CREATE_CHILD_SA	= 0x24, /*! IKE Create Child SA */
+	FC_AUTH_MC_IKE_INFO 		= 0x25, /*! IKE informational */
+};
+
+enum auth_proto_version{
+	FC_AUTH_PROTO_VER_1 	= 1,	/*! Protocol Version 1 */
+};
+
+enum {
+	FC_AUTH_ELS_COMMAND_CODE = 0x90,/*! Authentication ELS Command code  */
+	FC_AUTH_PROTO_PARAM_LEN_SZ = 4,	/*! Size of Proto Parameter Len Field */
+	FC_AUTH_PROTO_PARAM_VAL_SZ = 4,	/*! Size of Proto Parameter Val Field */
+	FC_MAX_AUTH_SECRET_LEN     = 256,
+					/*! Maximum secret string length */
+	FC_AUTH_NUM_USABLE_PROTO_LEN_SZ = 4,
+					/*! Size of usable protocols field */
+	FC_AUTH_RESP_VALUE_LEN_SZ	= 4,
+					/*! Size of response value length */
+	FC_MAX_CHAP_KEY_LEN	= 256,	/*! Maximum md5 digest length */
+	FC_MAX_AUTH_RETRIES     = 3,	/*! Maximum number of retries */
+	FC_MD5_DIGEST_LEN       = 16,	/*! MD5 digest length */
+	FC_SHA1_DIGEST_LEN      = 20,	/*! SHA1 digest length */
+	FC_MAX_DHG_SUPPORTED    = 1,	/*! Maximum DH Groups supported */
+	FC_MAX_ALG_SUPPORTED    = 1,	/*! Maximum algorithms supported */
+	FC_MAX_PROTO_SUPPORTED  = 1,	/*! Maximum protocols supported */
+	FC_START_TXN_ID         = 2,	/*! Starting transaction ID */
+};
+
+enum auth_proto_id{
+	FC_AUTH_PROTO_DHCHAP		= 0x00000001,
+	FC_AUTH_PROTO_FCAP 		= 0x00000002,
+	FC_AUTH_PROTO_FCPAP 		= 0x00000003,
+	FC_AUTH_PROTO_IKEv2 		= 0x00000004,
+	FC_AUTH_PROTO_IKEv2_AUTH 	= 0x00000005,
+};
+
+struct auth_name_s{
+	u16	name_tag;	/*! Name Tag = 1 for Authentication */
+	u16	name_len;	/*! Name Length = 8 for Authentication
+					 */
+	wwn_t		name;  		/*! Name. TODO - is this PWWN */
+};
+
+
+enum auth_hash_func{
+	FC_AUTH_HASH_FUNC_MD5 		= 0x00000005,
+	FC_AUTH_HASH_FUNC_SHA_1 	= 0x00000006,
+};
+
+enum auth_dh_gid{
+	FC_AUTH_DH_GID_0_DHG_NULL	= 0x00000000,
+	FC_AUTH_DH_GID_1_DHG_1024	= 0x00000001,
+	FC_AUTH_DH_GID_2_DHG_1280	= 0x00000002,
+	FC_AUTH_DH_GID_3_DHG_1536	= 0x00000003,
+	FC_AUTH_DH_GID_4_DHG_2048	= 0x00000004,
+	FC_AUTH_DH_GID_6_DHG_3072	= 0x00000006,
+	FC_AUTH_DH_GID_7_DHG_4096	= 0x00000007,
+	FC_AUTH_DH_GID_8_DHG_6144	= 0x00000008,
+	FC_AUTH_DH_GID_9_DHG_8192	= 0x00000009,
+};
+
+struct auth_els_msg_s {
+	u8		auth_els_code;	/*  Authentication ELS Code (0x90) */
+	u8 	auth_els_flag; 	/*  Authentication ELS Flags */
+	u8 	auth_msg_code; 	/*  Authentication Message Code */
+	u8 	proto_version; 	/*  Protocol Version */
+	u32	msg_len; 	/*  Message Length */
+	u32	trans_id; 	/*  Transaction Identifier (T_ID) */
+
+	/* Msg payload follows... */
+};
+
+
+enum auth_neg_param_tags {
+	FC_AUTH_NEG_DHCHAP_HASHLIST 	= 0x0001,
+	FC_AUTH_NEG_DHCHAP_DHG_ID_LIST 	= 0x0002,
+};
+
+
+struct dhchap_param_format_s {
+	u16	tag;		/*! Parameter Tag. See
+					 * auth_neg_param_tags_t
+					 */
+	u16	word_cnt;
+
+	/* followed by variable length parameter value... */
+};
+
+struct auth_proto_params_s {
+	u32	proto_param_len;
+	u32	proto_id;
+
+	/*
+	 * Followed by variable length Protocol specific parameters. DH-CHAP
+	 * uses dhchap_param_format_t
+	 */
+};
+
+struct auth_neg_msg_s {
+	struct auth_name_s	auth_ini_name;
+	u32		usable_auth_protos;
+	struct auth_proto_params_s proto_params[1]; /*! (1..usable_auth_proto)
+						     * protocol params
+						     */
+};
+
+struct auth_dh_val_s {
+	u32 dh_val_len;
+	u32 dh_val[1];
+};
+
+struct auth_dhchap_chal_msg_s {
+	struct auth_els_msg_s	hdr;
+	struct auth_name_s auth_responder_name;	/* TODO VRK - is auth_name_t
+						 * type OK?
+						 */
+	u32 	hash_id;
+	u32 	dh_grp_id;
+	u32 	chal_val_len;
+	char		chal_val[1];
+
+	/* ...followed by variable Challenge length/value and DH length/value */
+};
+
+
+enum auth_rjt_codes {
+	FC_AUTH_RJT_CODE_AUTH_FAILURE 	= 0x01,
+	FC_AUTH_RJT_CODE_LOGICAL_ERR	= 0x02,
+};
+
+enum auth_rjt_code_exps {
+	FC_AUTH_CEXP_AUTH_MECH_NOT_USABLE	= 0x01,
+	FC_AUTH_CEXP_DH_GROUP_NOT_USABLE 	= 0x02,
+	FC_AUTH_CEXP_HASH_FUNC_NOT_USABLE 	= 0x03,
+	FC_AUTH_CEXP_AUTH_XACT_STARTED		= 0x04,
+	FC_AUTH_CEXP_AUTH_FAILED 		= 0x05,
+	FC_AUTH_CEXP_INCORRECT_PLD 		= 0x06,
+	FC_AUTH_CEXP_INCORRECT_PROTO_MSG 	= 0x07,
+	FC_AUTH_CEXP_RESTART_AUTH_PROTO 	= 0x08,
+	FC_AUTH_CEXP_AUTH_CONCAT_NOT_SUPP 	= 0x09,
+	FC_AUTH_CEXP_PROTO_VER_NOT_SUPP 	= 0x0A,
+};
+
+enum auth_status {
+	FC_AUTH_STATE_INPROGRESS = 0, 	/*! authentication in progress 	*/
+	FC_AUTH_STATE_FAILED	= 1, 	/*! authentication failed */
+	FC_AUTH_STATE_SUCCESS	= 2 	/*! authentication successful	*/
+};
+
+struct auth_rjt_msg_s {
+	struct auth_els_msg_s	hdr;
+	u8		reason_code;
+	u8		reason_code_exp;
+	u8		rsvd[2];
+};
+
+
+struct auth_dhchap_neg_msg_s {
+	struct auth_els_msg_s hdr;
+	struct auth_neg_msg_s nego;
+};
+
+struct auth_dhchap_reply_msg_s {
+	struct auth_els_msg_s	hdr;
+
+	/*
+	 * followed by response value length & Value + DH Value Length & Value
+	 */
+};
+
+#pragma pack()
+
+#endif /* __FC_SP_H__ */
diff -urpN orig/drivers/scsi/bfa/include/protocol/fdmi.h patch/drivers/scsi/bfa/include/protocol/fdmi.h
--- orig/drivers/scsi/bfa/include/protocol/fdmi.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/protocol/fdmi.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,163 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __FDMI_H__
+#define __FDMI_H__
+
+#include <protocol/types.h>
+#include <protocol/fc.h>
+#include <protocol/ct.h>
+
+#pragma pack(1)
+
+/*
+ * FDMI Command Codes
+ */
+#define	FDMI_GRHL		0x0100
+#define	FDMI_GHAT		0x0101
+#define	FDMI_GRPL		0x0102
+#define	FDMI_GPAT		0x0110
+#define	FDMI_RHBA		0x0200
+#define	FDMI_RHAT		0x0201
+#define	FDMI_RPRT		0x0210
+#define	FDMI_RPA		0x0211
+#define	FDMI_DHBA		0x0300
+#define	FDMI_DPRT		0x0310
+
+/*
+ * FDMI reason codes
+ */
+#define	FDMI_NO_ADDITIONAL_EXP		0x00
+#define	FDMI_HBA_ALREADY_REG		0x10
+#define	FDMI_HBA_ATTRIB_NOT_REG		0x11
+#define	FDMI_HBA_ATTRIB_MULTIPLE	0x12
+#define	FDMI_HBA_ATTRIB_LENGTH_INVALID	0x13
+#define	FDMI_HBA_ATTRIB_NOT_PRESENT	0x14
+#define	FDMI_PORT_ORIG_NOT_IN_LIST	0x15
+#define	FDMI_PORT_HBA_NOT_IN_LIST	0x16
+#define	FDMI_PORT_ATTRIB_NOT_REG	0x20
+#define	FDMI_PORT_NOT_REG		0x21
+#define	FDMI_PORT_ATTRIB_MULTIPLE	0x22
+#define	FDMI_PORT_ATTRIB_LENGTH_INVALID	0x23
+#define	FDMI_PORT_ALREADY_REGISTEREED	0x24
+
+/*
+ * FDMI Transmission Speed Mask values
+ */
+#define	FDMI_TRANS_SPEED_1G		0x00000001
+#define	FDMI_TRANS_SPEED_2G		0x00000002
+#define	FDMI_TRANS_SPEED_10G		0x00000004
+#define	FDMI_TRANS_SPEED_4G		0x00000008
+#define	FDMI_TRANS_SPEED_8G		0x00000010
+#define	FDMI_TRANS_SPEED_16G		0x00000020
+#define	FDMI_TRANS_SPEED_UNKNOWN	0x00008000
+
+/*
+ * FDMI HBA attribute types
+ */
+enum fdmi_hba_attribute_type {
+	FDMI_HBA_ATTRIB_NODENAME = 1,	/* 0x0001 */
+	FDMI_HBA_ATTRIB_MANUFACTURER,	/* 0x0002 */
+	FDMI_HBA_ATTRIB_SERIALNUM,	/* 0x0003 */
+	FDMI_HBA_ATTRIB_MODEL,		/* 0x0004 */
+	FDMI_HBA_ATTRIB_MODEL_DESC,	/* 0x0005 */
+	FDMI_HBA_ATTRIB_HW_VERSION,	/* 0x0006 */
+	FDMI_HBA_ATTRIB_DRIVER_VERSION,	/* 0x0007 */
+	FDMI_HBA_ATTRIB_ROM_VERSION,	/* 0x0008 */
+	FDMI_HBA_ATTRIB_FW_VERSION,	/* 0x0009 */
+	FDMI_HBA_ATTRIB_OS_NAME,	/* 0x000A */
+	FDMI_HBA_ATTRIB_MAX_CT,		/* 0x000B */
+
+	FDMI_HBA_ATTRIB_MAX_TYPE
+};
+
+/*
+ * FDMI Port attribute types
+ */
+enum fdmi_port_attribute_type {
+	FDMI_PORT_ATTRIB_FC4_TYPES = 1,	/* 0x0001 */
+	FDMI_PORT_ATTRIB_SUPP_SPEED,	/* 0x0002 */
+	FDMI_PORT_ATTRIB_PORT_SPEED,	/* 0x0003 */
+	FDMI_PORT_ATTRIB_FRAME_SIZE,	/* 0x0004 */
+	FDMI_PORT_ATTRIB_DEV_NAME,	/* 0x0005 */
+	FDMI_PORT_ATTRIB_HOST_NAME,	/* 0x0006 */
+
+	FDMI_PORT_ATTR_MAX_TYPE
+};
+
+/*
+ * FDMI attribute
+ */
+struct fdmi_attr_s {
+	u16        type;
+	u16        len;
+	u8         value[1];
+};
+
+/*
+ * HBA Attribute Block
+ */
+struct fdmi_hba_attr_s {
+	u32        attr_count;	/* # of attributes */
+	struct fdmi_attr_s     hba_attr;	/* n attributes */
+};
+
+/*
+ * Registered Port List
+ */
+struct fdmi_port_list_s {
+	u32        num_ports;	/* number Of Port Entries */
+	wwn_t           port_entry;	/* one or more */
+};
+
+/*
+ * Port Attribute Block
+ */
+struct fdmi_port_attr_s {
+	u32        attr_count;	/* # of attributes */
+	struct fdmi_attr_s     port_attr;	/* n attributes */
+};
+
+/*
+ * FDMI Register HBA Attributes
+ */
+struct fdmi_rhba_s {
+	wwn_t           hba_id;		/* HBA Identifier */
+	struct fdmi_port_list_s port_list;	/* Registered Port List */
+	struct fdmi_hba_attr_s hba_attr_blk;	/* HBA attribute block */
+};
+
+/*
+ * FDMI Register Port
+ */
+struct fdmi_rprt_s {
+	wwn_t           hba_id;		/* HBA Identifier */
+	wwn_t           port_name;	/* Port wwn */
+	struct fdmi_port_attr_s port_attr_blk;	/* Port Attr Block */
+};
+
+/*
+ * FDMI Register Port Attributes
+ */
+struct fdmi_rpa_s {
+	wwn_t           port_name;	/* port wwn */
+	struct fdmi_port_attr_s port_attr_blk;	/* Port Attr Block */
+};
+
+#pragma pack()
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/protocol/pcifw.h patch/drivers/scsi/bfa/include/protocol/pcifw.h
--- orig/drivers/scsi/bfa/include/protocol/pcifw.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/protocol/pcifw.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,75 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  pcifw.h PCI FW related headers
+ */
+
+#ifndef __PCIFW_H__
+#define __PCIFW_H__
+
+#pragma pack(1)
+
+struct pnp_hdr_s{
+  u32	signature;	/* "$PnP" */
+  u8	rev;		/* Struct revision */
+  u8 	len;		/* Header structure len in multiples
+				 * of 16 bytes */
+  u16  off;		/* Offset to next header 00 if none */
+  u8	rsvd;		/* Reserved byte */
+  u8	cksum;		/* 8-bit checksum for this header */
+  u32	pnp_dev_id;	/* PnP Device Id */
+  u16  mfstr;		/* Pointer to manufacturer string */
+  u16	prstr;		/* Pointer to product string */
+  u8	devtype[3];	/* Device Type Code */
+  u8	devind;		/* Device Indicator */
+  u16	bcventr;	/* Bootstrap entry vector */
+  u16	rsvd2;		/* Reserved */
+  u16  sriv;		/* Static resource information vector */
+};
+
+struct pci_3_0_ds_s{
+ u32	sig;   		/* Signature "PCIR" */
+ u16	vendid;		/* Vendor ID */
+ u16	devid;		/* Device ID */
+ u16	devlistoff;	/* Device List Offset */
+ u16	len;		/* PCI Data Structure Length */
+ u8	rev;		/* PCI Data Structure Revision */
+ u8	clcode[3];	/* Class Code */
+ u16	imglen;		/* Code image length in multiples of
+				 * 512 bytes */
+ u16	coderev;	/* Revision level of code/data */
+ u8	codetype;	/* Code type 0x00 - BIOS */
+ u8	indr;		/* Last image indicator */
+ u16	mrtimglen;	/* Max Run Time Image Length */
+ u16	cuoff;		/* Config Utility Code Header Offset */
+ u16	dmtfclp;	/* DMTF CLP entry point offset */
+};
+
+struct pci_optrom_hdr_s{
+ u16	sig;		/* Signature 0x55AA */
+ u8	len;		/* Option ROM length in units of 512 bytes */
+ u8	inivec[3];	/* Initialization vector */
+ u8	rsvd[16];	/* Reserved field */
+ u16	verptr;		/* Pointer to version string - private */
+ u16	pcids;		/* Pointer to PCI data structure */
+ u16	pnphdr;		/* Pointer to PnP expansion header */
+};
+
+#pragma pack()
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/protocol/scsi.h patch/drivers/scsi/bfa/include/protocol/scsi.h
--- orig/drivers/scsi/bfa/include/protocol/scsi.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/protocol/scsi.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,1648 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __SCSI_H__
+#define __SCSI_H__
+
+#include <protocol/types.h>
+
+#pragma pack(1)
+
+/*
+ * generic SCSI cdb definition
+ */
+#define SCSI_MAX_CDBLEN     16
+struct scsi_cdb_s{
+	u8         scsi_cdb[SCSI_MAX_CDBLEN];
+};
+
+/*
+ * scsi lun serial number definition
+ */
+#define SCSI_LUN_SN_LEN     32
+struct scsi_lun_sn_s{
+	u8         lun_sn[SCSI_LUN_SN_LEN];
+};
+
+/*
+ * SCSI Direct Access Commands
+ */
+enum {
+	SCSI_OP_TEST_UNIT_READY		= 0x00,
+	SCSI_OP_REQUEST_SENSE		= 0x03,
+	SCSI_OP_FORMAT_UNIT		= 0x04,
+	SCSI_OP_READ6			= 0x08,
+	SCSI_OP_WRITE6			= 0x0A,
+	SCSI_OP_WRITE_FILEMARKS		= 0x10,
+	SCSI_OP_INQUIRY			= 0x12,
+	SCSI_OP_MODE_SELECT6		= 0x15,
+	SCSI_OP_RESERVE6		= 0x16,
+	SCSI_OP_RELEASE6		= 0x17,
+	SCSI_OP_MODE_SENSE6		= 0x1A,
+	SCSI_OP_START_STOP_UNIT		= 0x1B,
+	SCSI_OP_SEND_DIAGNOSTIC		= 0x1D,
+	SCSI_OP_READ_CAPACITY		= 0x25,
+	SCSI_OP_READ10			= 0x28,
+	SCSI_OP_WRITE10			= 0x2A,
+	SCSI_OP_VERIFY10		= 0x2F,
+	SCSI_OP_READ_DEFECT_DATA	= 0x37,
+	SCSI_OP_LOG_SELECT		= 0x4C,
+	SCSI_OP_LOG_SENSE		= 0x4D,
+	SCSI_OP_MODE_SELECT10		= 0x55,
+	SCSI_OP_RESERVE10		= 0x56,
+	SCSI_OP_RELEASE10		= 0x57,
+	SCSI_OP_MODE_SENSE10		= 0x5A,
+	SCSI_OP_PER_RESERVE_IN		= 0x5E,
+	SCSI_OP_PER_RESERVE_OUR		= 0x5E,
+	SCSI_OP_READ16			= 0x88,
+	SCSI_OP_WRITE16			= 0x8A,
+	SCSI_OP_VERIFY16		= 0x8F,
+	SCSI_OP_READ_CAPACITY16		= 0x9E,
+	SCSI_OP_REPORT_LUNS		= 0xA0,
+	SCSI_OP_READ12			= 0xA8,
+	SCSI_OP_WRITE12			= 0xAA,
+	SCSI_OP_UNDEF			= 0xFF,
+};
+
+/*
+ * SCSI START_STOP_UNIT command
+ */
+struct scsi_start_stop_unit_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         lun:3;
+	u8         reserved1:4;
+	u8         immed:1;
+#else
+	u8         immed:1;
+	u8         reserved1:4;
+	u8         lun:3;
+#endif
+	u8         reserved2;
+	u8         reserved3;
+#ifdef __BIGENDIAN
+	u8         power_conditions:4;
+	u8         reserved4:2;
+	u8         loEj:1;
+	u8         start:1;
+#else
+	u8         start:1;
+	u8         loEj:1;
+	u8         reserved4:2;
+	u8         power_conditions:4;
+#endif
+	u8         control;
+};
+
+/*
+ * SCSI SEND_DIAGNOSTIC command
+ */
+struct scsi_send_diagnostic_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         self_test_code:3;
+	u8         pf:1;
+	u8         reserved1:1;
+	u8         self_test:1;
+	u8         dev_offl:1;
+	u8         unit_offl:1;
+#else
+	u8         unit_offl:1;
+	u8         dev_offl:1;
+	u8         self_test:1;
+	u8         reserved1:1;
+	u8         pf:1;
+	u8         self_test_code:3;
+#endif
+	u8         reserved2;
+
+	u8         param_list_length[2];	/* MSB first */
+	u8         control;
+
+};
+
+/*
+ * SCSI READ10/WRITE10 commands
+ */
+struct scsi_rw10_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         lun:3;
+	u8         dpo:1;	/* Disable Page Out */
+	u8         fua:1;	/* Force Unit Access */
+	u8         reserved1:2;
+	u8         rel_adr:1;	/* relative address */
+#else
+	u8         rel_adr:1;
+	u8         reserved1:2;
+	u8         fua:1;
+	u8         dpo:1;
+	u8         lun:3;
+#endif
+	u8         lba0;	/* logical block address - MSB */
+	u8         lba1;
+	u8         lba2;
+	u8         lba3;	/* LSB */
+	u8         reserved3;
+	u8         xfer_length0;	/* transfer length in blocks - MSB */
+	u8         xfer_length1;	/* LSB */
+	u8         control;
+};
+
+#define SCSI_CDB10_GET_LBA(cdb)                     \
+    (((cdb)->lba0 << 24) | ((cdb)->lba1 << 16) |    \
+     ((cdb)->lba2 << 8) | (cdb)->lba3)
+
+#define SCSI_CDB10_SET_LBA(cdb, lba) {      \
+    (cdb)->lba0 = lba >> 24;            \
+    (cdb)->lba1 = (lba >> 16) & 0xFF;   \
+    (cdb)->lba2 = (lba >> 8) & 0xFF;    \
+    (cdb)->lba3 = lba & 0xFF;           \
+}
+
+#define SCSI_CDB10_GET_TL(cdb)  \
+    ((cdb)->xfer_length0 << 8 | (cdb)->xfer_length1)
+#define SCSI_CDB10_SET_TL(cdb, tl) {      \
+    (cdb)->xfer_length0 = tl >> 8;       \
+    (cdb)->xfer_length1 = tl & 0xFF;     \
+}
+
+/*
+ * SCSI READ6/WRITE6 commands
+ */
+struct scsi_rw6_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         lun:3;
+	u8         lba0:5;		/* MSb */
+#else
+	u8         lba0:5;		/* MSb */
+	u8         lun:3;
+#endif
+	u8         lba1;
+	u8         lba2;		/* LSB */
+	u8         xfer_length;
+	u8         control;
+};
+
+#define SCSI_TAPE_CDB6_GET_TL(cdb)              \
+    (((cdb)->tl0 << 16) | ((cdb)->tl1 << 8) | (cdb)->tl2)
+
+#define SCSI_TAPE_CDB6_SET_TL(cdb, tl) {      \
+    (cdb)->tl0 = tl >> 16;            \
+    (cdb)->tl1 = (tl >> 8) & 0xFF;    \
+    (cdb)->tl2 = tl & 0xFF;           \
+}
+
+/*
+ * SCSI sequential (TAPE) wrtie command
+ */
+struct scsi_tape_wr_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         rsvd:7;
+	u8         fixed:1;	/* MSb */
+#else
+	u8         fixed:1;	/* MSb */
+	u8         rsvd:7;
+#endif
+	u8         tl0;		/* Msb */
+	u8         tl1;
+	u8         tl2;		/* Lsb */
+
+	u8         control;
+};
+
+#define SCSI_CDB6_GET_LBA(cdb)              \
+    (((cdb)->lba0 << 16) | ((cdb)->lba1 << 8) | (cdb)->lba2)
+
+#define SCSI_CDB6_SET_LBA(cdb, lba) {      \
+    (cdb)->lba0 = lba >> 16;            \
+    (cdb)->lba1 = (lba >> 8) & 0xFF;    \
+    (cdb)->lba2 = lba & 0xFF;           \
+}
+
+#define SCSI_CDB6_GET_TL(cdb) ((cdb)->xfer_length)
+#define SCSI_CDB6_SET_TL(cdb, tl) {      \
+    (cdb)->xfer_length = tl;         \
+}
+
+/*
+ * SCSI sense data format
+ */
+struct scsi_sense_s{
+#ifdef __BIGENDIAN
+	u8         valid:1;
+	u8         rsp_code:7;
+#else
+	u8         rsp_code:7;
+	u8         valid:1;
+#endif
+	u8         seg_num;
+#ifdef __BIGENDIAN
+	u8         file_mark:1;
+	u8         eom:1;		/* end of media */
+	u8         ili:1;		/* incorrect length indicator */
+	u8         reserved:1;
+	u8         sense_key:4;
+#else
+	u8         sense_key:4;
+	u8         reserved:1;
+	u8         ili:1;		/* incorrect length indicator */
+	u8         eom:1;		/* end of media */
+	u8         file_mark:1;
+#endif
+	u8         information[4];	/* device-type or command specific info
+					 */
+	u8         add_sense_length;
+					/* additional sense length */
+	u8         command_info[4];/* command specific information
+						 */
+	u8         asc;		/* additional sense code */
+	u8         ascq;		/* additional sense code qualifier */
+	u8         fru_code;	/* field replaceable unit code */
+#ifdef __BIGENDIAN
+	u8         sksv:1;		/* sense key specific valid */
+	u8         c_d:1;		/* command/data bit */
+	u8         res1:2;
+	u8         bpv:1;		/* bit pointer valid */
+	u8         bpointer:3;	/* bit pointer */
+#else
+	u8         bpointer:3;	/* bit pointer */
+	u8         bpv:1;		/* bit pointer valid */
+	u8         res1:2;
+	u8         c_d:1;		/* command/data bit */
+	u8         sksv:1;		/* sense key specific valid */
+#endif
+	u8         fpointer[2];	/* field pointer */
+};
+
+#define SCSI_SENSE_CUR_ERR          0x70
+#define SCSI_SENSE_DEF_ERR          0x71
+
+/*
+ * SCSI sense key values
+ */
+#define SCSI_SK_NO_SENSE        0x0
+#define SCSI_SK_REC_ERR         0x1	/* recovered error */
+#define SCSI_SK_NOT_READY       0x2
+#define SCSI_SK_MED_ERR         0x3	/* medium error */
+#define SCSI_SK_HW_ERR          0x4	/* hardware error */
+#define SCSI_SK_ILLEGAL_REQ     0x5
+#define SCSI_SK_UNIT_ATT        0x6	/* unit attention */
+#define SCSI_SK_DATA_PROTECT    0x7
+#define SCSI_SK_BLANK_CHECK     0x8
+#define SCSI_SK_VENDOR_SPEC     0x9
+#define SCSI_SK_COPY_ABORTED    0xA
+#define SCSI_SK_ABORTED_CMND    0xB
+#define SCSI_SK_VOL_OVERFLOW    0xD
+#define SCSI_SK_MISCOMPARE      0xE
+
+/*
+ * SCSI additional sense codes
+ */
+#define SCSI_ASC_NO_ADD_SENSE           0x00
+#define SCSI_ASC_LUN_NOT_READY          0x04
+#define SCSI_ASC_LUN_COMMUNICATION      0x08
+#define SCSI_ASC_WRITE_ERROR            0x0C
+#define SCSI_ASC_INVALID_CMND_CODE      0x20
+#define SCSI_ASC_BAD_LBA                0x21
+#define SCSI_ASC_INVALID_FIELD_IN_CDB   0x24
+#define SCSI_ASC_LUN_NOT_SUPPORTED      0x25
+#define SCSI_ASC_LUN_WRITE_PROTECT      0x27
+#define SCSI_ASC_POWERON_BDR            0x29	/* power on reset, bus reset,
+						 * bus device reset
+						 */
+#define SCSI_ASC_PARAMS_CHANGED         0x2A
+#define SCSI_ASC_CMND_CLEARED_BY_A_I    0x2F
+#define SCSI_ASC_SAVING_PARAM_NOTSUPP   0x39
+#define SCSI_ASC_TOCC                   0x3F	/* target operating condtions
+						 * changed
+						 */
+#define SCSI_ASC_PARITY_ERROR           0x47
+#define SCSI_ASC_CMND_PHASE_ERROR       0x4A
+#define SCSI_ASC_DATA_PHASE_ERROR       0x4B
+#define SCSI_ASC_VENDOR_SPEC            0x7F
+
+/*
+ * SCSI additional sense code qualifiers
+ */
+#define SCSI_ASCQ_CAUSE_NOT_REPORT      0x00
+#define SCSI_ASCQ_BECOMING_READY        0x01
+#define SCSI_ASCQ_INIT_CMD_REQ          0x02
+#define SCSI_ASCQ_FORMAT_IN_PROGRESS    0x04
+#define SCSI_ASCQ_OPERATION_IN_PROGRESS 0x07
+#define SCSI_ASCQ_SELF_TEST_IN_PROGRESS 0x09
+#define SCSI_ASCQ_WR_UNEXP_UNSOL_DATA   0x0C
+#define SCSI_ASCQ_WR_NOTENG_UNSOL_DATA  0x0D
+
+#define SCSI_ASCQ_LBA_OUT_OF_RANGE      0x00
+#define SCSI_ASCQ_INVALID_ELEMENT_ADDR  0x01
+
+#define SCSI_ASCQ_LUN_WRITE_PROTECTED       0x00
+#define SCSI_ASCQ_LUN_HW_WRITE_PROTECTED    0x01
+#define SCSI_ASCQ_LUN_SW_WRITE_PROTECTED    0x02
+
+#define SCSI_ASCQ_POR   0x01	/* power on reset */
+#define SCSI_ASCQ_SBR   0x02	/* scsi bus reset */
+#define SCSI_ASCQ_BDR   0x03	/* bus device reset */
+#define SCSI_ASCQ_DIR   0x04	/* device internal reset */
+
+#define SCSI_ASCQ_MODE_PARAMS_CHANGED       0x01
+#define SCSI_ASCQ_LOG_PARAMS_CHANGED        0x02
+#define SCSI_ASCQ_RESERVATIONS_PREEMPTED    0x03
+#define SCSI_ASCQ_RESERVATIONS_RELEASED     0x04
+#define SCSI_ASCQ_REGISTRATIONS_PREEMPTED   0x05
+
+#define SCSI_ASCQ_MICROCODE_CHANGED 0x01
+#define SCSI_ASCQ_CHANGED_OPER_COND 0x02
+#define SCSI_ASCQ_INQ_CHANGED       0x03	/* inquiry data changed */
+#define SCSI_ASCQ_DI_CHANGED        0x05	/* device id changed */
+#define SCSI_ASCQ_RL_DATA_CHANGED   0x0E	/* report luns data changed */
+
+#define SCSI_ASCQ_DP_CRC_ERR            0x01	/* data phase crc error */
+#define SCSI_ASCQ_DP_SCSI_PARITY_ERR    0x02	/* data phase scsi parity error
+						 */
+#define SCSI_ASCQ_IU_CRC_ERR            0x03	/* information unit crc error */
+#define SCSI_ASCQ_PROTO_SERV_CRC_ERR    0x05
+
+#define SCSI_ASCQ_LUN_TIME_OUT          0x01
+
+/* ------------------------------------------------------------
+ * SCSI INQUIRY
+ * ------------------------------------------------------------*/
+
+struct scsi_inquiry_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         lun:3;
+	u8         reserved1:3;
+	u8         cmd_dt:1;
+	u8         evpd:1;
+#else
+	u8         evpd:1;
+	u8         cmd_dt:1;
+	u8         reserved1:3;
+	u8         lun:3;
+#endif
+	u8         page_code;
+	u8         reserved2;
+	u8         alloc_length;
+	u8         control;
+};
+
+struct scsi_inquiry_vendor_s{
+	u8         vendor_id[8];
+};
+
+struct scsi_inquiry_prodid_s{
+	u8         product_id[16];
+};
+
+struct scsi_inquiry_prodrev_s{
+	u8         product_rev[4];
+};
+
+struct scsi_inquiry_data_s{
+#ifdef __BIGENDIAN
+	u8         peripheral_qual:3;	/* peripheral qualifier */
+	u8         device_type:5;		/* peripheral device type */
+
+	u8         rmb:1;			/* removable medium bit */
+	u8         device_type_mod:7;	/* device type modifier */
+
+	u8         version;
+
+	u8         aenc:1;		/* async event notification capability
+					 */
+	u8         trm_iop:1;	/* terminate I/O process */
+	u8         norm_aca:1;	/* normal ACA supported */
+	u8         hi_support:1;	/* SCSI-3: supports REPORT LUNS */
+	u8         rsp_data_format:4;
+
+	u8         additional_len;
+	u8         sccs:1;
+	u8         reserved1:7;
+
+	u8         reserved2:1;
+	u8         enc_serv:1;	/* enclosure service component */
+	u8         reserved3:1;
+	u8         multi_port:1;	/* multi-port device */
+	u8         m_chngr:1;	/* device in medium transport element */
+	u8         ack_req_q:1;	/* SIP specific bit */
+	u8         addr32:1;	/* SIP specific bit */
+	u8         addr16:1;	/* SIP specific bit */
+
+	u8         rel_adr:1;	/* relative address */
+	u8         w_bus32:1;
+	u8         w_bus16:1;
+	u8         synchronous:1;
+	u8         linked_commands:1;
+	u8         trans_dis:1;
+	u8         cmd_queue:1;	/* command queueing supported */
+	u8         soft_reset:1;	/* soft reset alternative (VS) */
+#else
+	u8         device_type:5;	/* peripheral device type */
+	u8         peripheral_qual:3;
+					/* peripheral qualifier */
+
+	u8         device_type_mod:7;
+					/* device type modifier */
+	u8         rmb:1;		/* removable medium bit */
+
+	u8         version;
+
+	u8         rsp_data_format:4;
+	u8         hi_support:1;	/* SCSI-3: supports REPORT LUNS */
+	u8         norm_aca:1;	/* normal ACA supported */
+	u8         terminate_iop:1;/* terminate I/O process */
+	u8         aenc:1;		/* async event notification capability
+					 */
+
+	u8         additional_len;
+	u8         reserved1:7;
+	u8         sccs:1;
+
+	u8         addr16:1;	/* SIP specific bit */
+	u8         addr32:1;	/* SIP specific bit */
+	u8         ack_req_q:1;	/* SIP specific bit */
+	u8         m_chngr:1;	/* device in medium transport element */
+	u8         multi_port:1;	/* multi-port device */
+	u8         reserved3:1;	/* TBD - Vendor Specific */
+	u8         enc_serv:1;	/* enclosure service component */
+	u8         reserved2:1;
+
+	u8         soft_seset:1;	/* soft reset alternative (VS) */
+	u8         cmd_queue:1;	/* command queueing supported */
+	u8         trans_dis:1;
+	u8         linked_commands:1;
+	u8         synchronous:1;
+	u8         w_bus16:1;
+	u8         w_bus32:1;
+	u8         rel_adr:1;	/* relative address */
+#endif
+	struct scsi_inquiry_vendor_s vendor_id;
+	struct scsi_inquiry_prodid_s product_id;
+	struct scsi_inquiry_prodrev_s product_rev;
+	u8         vendor_specific[20];
+	u8         reserved4[40];
+};
+
+/*
+ * inquiry.peripheral_qual field values
+ */
+#define SCSI_DEVQUAL_DEFAULT        0
+#define SCSI_DEVQUAL_NOT_CONNECTED  1
+#define SCSI_DEVQUAL_NOT_SUPPORTED  3
+
+/*
+ * inquiry.device_type field values
+ */
+#define SCSI_DEVICE_DIRECT_ACCESS       0x00
+#define SCSI_DEVICE_SEQ_ACCESS          0x01
+#define SCSI_DEVICE_ARRAY_CONTROLLER    0x0C
+#define SCSI_DEVICE_UNKNOWN             0x1F
+
+/*
+ * inquiry.version
+ */
+#define SCSI_VERSION_ANSI_X3131     2	/* ANSI X3.131 SCSI-2 */
+#define SCSI_VERSION_SPC            3	/* SPC (SCSI-3), ANSI X3.301:1997 */
+#define SCSI_VERSION_SPC_2          4	/* SPC-2 */
+
+/*
+ * response data format
+ */
+#define SCSI_RSP_DATA_FORMAT        2	/* SCSI-2 & SPC */
+
+/*
+ * SCSI inquiry page codes
+ */
+#define SCSI_INQ_PAGE_VPD_PAGES     0x00	/* supported vpd pages */
+#define SCSI_INQ_PAGE_USN_PAGE      0x80	/* unit serial number page */
+#define SCSI_INQ_PAGE_DEV_IDENT     0x83	/* device indentification page
+						 */
+#define SCSI_INQ_PAGES_MAX          3
+
+/*
+ * supported vital product data pages
+ */
+struct scsi_inq_page_vpd_pages_s{
+#ifdef __BIGENDIAN
+	u8         peripheral_qual:3;
+	u8         device_type:5;
+#else
+	u8         device_type:5;
+	u8         peripheral_qual:3;
+#endif
+	u8         page_code;
+	u8         reserved;
+	u8         page_length;
+	u8         pages[SCSI_INQ_PAGES_MAX];
+};
+
+/*
+ * Unit serial number page
+ */
+#define SCSI_INQ_USN_LEN 32
+
+struct scsi_inq_usn_s{
+	char            usn[SCSI_INQ_USN_LEN];
+};
+
+struct scsi_inq_page_usn_s{
+#ifdef __BIGENDIAN
+	u8         peripheral_qual:3;
+	u8         device_type:5;
+#else
+	u8         device_type:5;
+	u8         peripheral_qual:3;
+#endif
+	u8         page_code;
+	u8         reserved1;
+	u8         page_length;
+	struct scsi_inq_usn_s  usn;
+};
+
+enum {
+	SCSI_INQ_DIP_CODE_BINARY = 1,	/* identifier has binary value */
+	SCSI_INQ_DIP_CODE_ASCII = 2,	/* identifier has ascii value */
+};
+
+enum {
+	SCSI_INQ_DIP_ASSOC_LUN = 0,	/* id is associated with device */
+	SCSI_INQ_DIP_ASSOC_PORT = 1,	/* id is associated with port that
+					 * received the request
+					 */
+};
+
+enum {
+	SCSI_INQ_ID_TYPE_VENDOR = 1,
+	SCSI_INQ_ID_TYPE_IEEE = 2,
+	SCSI_INQ_ID_TYPE_FC_FS = 3,
+	SCSI_INQ_ID_TYPE_OTHER = 4,
+};
+
+struct scsi_inq_dip_desc_s{
+#ifdef __BIGENDIAN
+	u8         res0:4;
+	u8         code_set:4;
+	u8         res1:2;
+	u8         association:2;
+	u8         id_type:4;
+#else
+	u8         code_set:4;
+	u8         res0:4;
+	u8         id_type:4;
+	u8         association:2;
+	u8         res1:2;
+#endif
+	u8         res2;
+	u8         id_len;
+	struct scsi_lun_sn_s   id;
+};
+
+/*
+ * Device indentification page
+ */
+struct scsi_inq_page_dev_ident_s{
+#ifdef __BIGENDIAN
+	u8         peripheral_qual:3;
+	u8         device_type:5;
+#else
+	u8         device_type:5;
+	u8         peripheral_qual:3;
+#endif
+	u8         page_code;
+	u8         reserved1;
+	u8         page_length;
+	struct scsi_inq_dip_desc_s desc;
+};
+
+/* ------------------------------------------------------------
+ * READ CAPACITY
+ * ------------------------------------------------------------
+ */
+
+struct scsi_read_capacity_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         lun:3;
+	u8         reserved1:4;
+	u8         rel_adr:1;
+#else
+	u8         rel_adr:1;
+	u8         reserved1:4;
+	u8         lun:3;
+#endif
+	u8         lba0;	/* MSB */
+	u8         lba1;
+	u8         lba2;
+	u8         lba3;	/* LSB */
+	u8         reserved2;
+	u8         reserved3;
+#ifdef __BIGENDIAN
+	u8         reserved4:7;
+	u8         pmi:1;	/* partial medium indicator */
+#else
+	u8         pmi:1;	/* partial medium indicator */
+	u8         reserved4:7;
+#endif
+	u8         control;
+};
+
+struct scsi_read_capacity_data_s{
+	u32        max_lba;	/* maximum LBA available */
+	u32        block_length;	/* in bytes */
+};
+
+struct scsi_read_capacity16_data_s{
+	u64        lba;	/* maximum LBA available */
+	u32        block_length;	/* in bytes */
+#ifdef __BIGENDIAN
+	u8         reserved1:4,
+			p_type:3,
+			prot_en:1;
+	u8		reserved2:4,
+			lb_pbe:4;	/* logical blocks per physical block
+					 * exponent */
+	u16	reserved3:2,
+			lba_align:14;	/* lowest aligned logical block
+					 * address */
+#else
+	u16	lba_align:14,	/* lowest aligned logical block
+					 * address */
+			reserved3:2;
+	u8		lb_pbe:4,	/* logical blocks per physical block
+					 * exponent */
+			reserved2:4;
+	u8		prot_en:1,
+			p_type:3,
+			reserved1:4;
+#endif
+	u64	reserved4;
+	u64	reserved5;
+};
+
+/* ------------------------------------------------------------
+ * REPORT LUNS command
+ * ------------------------------------------------------------
+ */
+
+struct scsi_report_luns_s{
+	u8         opcode;		/* A0h - REPORT LUNS opCode */
+	u8         reserved1[5];
+	u8         alloc_length[4];/* allocation length MSB first */
+	u8         reserved2;
+	u8         control;
+};
+
+#define SCSI_REPORT_LUN_ALLOC_LENGTH(rl)                		\
+    ((rl->alloc_length[0] << 24) | (rl->alloc_length[1] << 16) | 	\
+     (rl->alloc_length[2] << 8) | (rl->alloc_length[3]))
+
+#define SCSI_REPORT_LUNS_SET_ALLOCLEN(rl, alloc_len) {      \
+    (rl)->alloc_length[0] = (alloc_len) >> 24;      			\
+    (rl)->alloc_length[1] = ((alloc_len) >> 16) & 0xFF; 		\
+    (rl)->alloc_length[2] = ((alloc_len) >> 8) & 0xFF;  		\
+    (rl)->alloc_length[3] = (alloc_len) & 0xFF;     			\
+}
+
+struct scsi_report_luns_data_s{
+	u32        lun_list_length;	/* length of LUN list length */
+	u32        reserved;
+	lun_t           lun[1];			/* first LUN in lun list */
+};
+
+/* -------------------------------------------------------------
+ * SCSI mode  parameters
+ * -----------------------------------------------------------
+ */
+enum {
+	SCSI_DA_MEDIUM_DEF = 0,	/* direct access default medium type */
+	SCSI_DA_MEDIUM_SS = 1,	/* direct access single sided */
+	SCSI_DA_MEDIUM_DS = 2,	/* direct access double sided */
+};
+
+/*
+ * SCSI Mode Select(6) cdb
+ */
+struct scsi_mode_select6_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         reserved1:3;
+	u8         pf:1;		/* page format */
+	u8         reserved2:3;
+	u8         sp:1;		/* save pages if set to 1 */
+#else
+	u8         sp:1;	/* save pages if set to 1 */
+	u8         reserved2:3;
+	u8         pf:1;	/* page format */
+	u8         reserved1:3;
+#endif
+	u8         reserved3[2];
+	u8         alloc_len;
+	u8         control;
+};
+
+/*
+ * SCSI Mode Select(10) cdb
+ */
+struct scsi_mode_select10_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         reserved1:3;
+	u8         pf:1;	/* page format */
+	u8         reserved2:3;
+	u8         sp:1;	/* save pages if set to 1 */
+#else
+	u8         sp:1;	/* save pages if set to 1 */
+	u8         reserved2:3;
+	u8         pf:1;	/* page format */
+	u8         reserved1:3;
+#endif
+	u8         reserved3[5];
+	u8         alloc_len_msb;
+	u8         alloc_len_lsb;
+	u8         control;
+};
+
+/*
+ * SCSI Mode Sense(6) cdb
+ */
+struct scsi_mode_sense6_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         reserved1:4;
+	u8         dbd:1;	/* disable block discriptors if set to 1 */
+	u8         reserved2:3;
+
+	u8         pc:2;	/* page control */
+	u8         page_code:6;
+#else
+	u8         reserved2:3;
+	u8         dbd:1;	/* disable block descriptors if set to 1 */
+	u8         reserved1:4;
+
+	u8         page_code:6;
+	u8         pc:2;	/* page control */
+#endif
+	u8         reserved3;
+	u8         alloc_len;
+	u8         control;
+};
+
+/*
+ * SCSI Mode Sense(10) cdb
+ */
+struct scsi_mode_sense10_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         reserved1:3;
+	u8         LLBAA:1;	/* long LBA accepted if set to 1 */
+	u8         dbd:1;		/* disable block descriptors if set
+					 * to 1
+					 */
+	u8         reserved2:3;
+
+	u8         pc:2;		/* page control */
+	u8         page_code:6;
+#else
+	u8         reserved2:3;
+	u8         dbd:1;		/* disable block descriptors if set to
+					 * 1
+					 */
+	u8         LLBAA:1;	/* long LBA accepted if set to 1 */
+	u8         reserved1:3;
+
+	u8         page_code:6;
+	u8         pc:2;		/* page control */
+#endif
+	u8         reserved3[4];
+	u8         alloc_len_msb;
+	u8         alloc_len_lsb;
+	u8         control;
+};
+
+#define SCSI_CDB10_GET_AL(cdb)  					\
+    ((cdb)->alloc_len_msb << 8 | (cdb)->alloc_len_lsb)
+
+#define SCSI_CDB10_SET_AL(cdb, al) {      \
+    (cdb)->alloc_len_msb = al >> 8;       				\
+    (cdb)->alloc_len_lsb = al & 0xFF;     				\
+}
+
+#define SCSI_CDB6_GET_AL(cdb) ((cdb)->alloc_len)
+
+#define SCSI_CDB6_SET_AL(cdb, al) {      \
+    (cdb)->alloc_len = al;         					\
+}
+
+/*
+ * page control field values
+ */
+#define SCSI_PC_CURRENT_VALUES       0x0
+#define SCSI_PC_CHANGEABLE_VALUES    0x1
+#define SCSI_PC_DEFAULT_VALUES       0x2
+#define SCSI_PC_SAVED_VALUES         0x3
+
+/*
+ * SCSI mode page codes
+ */
+#define SCSI_MP_VENDOR_SPEC     0x00
+#define SCSI_MP_DISC_RECN       0x02	/* disconnect-reconnect page */
+#define SCSI_MP_FORMAT_DEVICE   0x03
+#define SCSI_MP_RDG             0x04	/* rigid disk geometry page */
+#define SCSI_MP_FDP             0x05	/* flexible disk page */
+#define SCSI_MP_CACHING         0x08	/* caching page */
+#define SCSI_MP_CONTROL         0x0A	/* control mode page */
+#define SCSI_MP_MED_TYPES_SUP   0x0B	/* medium types supported page */
+#define SCSI_MP_INFO_EXCP_CNTL  0x1C	/* informational exception control */
+#define SCSI_MP_ALL             0x3F	/* return all pages - mode sense only */
+
+/*
+ * mode parameter header
+ */
+struct scsi_mode_param_header6_s{
+	u8         mode_datalen;
+	u8         medium_type;
+
+	/*
+	 * device specific parameters expanded for direct access devices
+	 */
+#ifdef __BIGENDIAN
+	u32        wp:1;		/* write protected */
+	u32        reserved1:2;
+	u32        dpofua:1;	/* disable page out + force unit access
+					 */
+	u32        reserved2:4;
+#else
+	u32        reserved2:4;
+	u32        dpofua:1;	/* disable page out + force unit access
+					 */
+	u32        reserved1:2;
+	u32        wp:1;		/* write protected */
+#endif
+
+	u8         block_desclen;
+};
+
+struct scsi_mode_param_header10_s{
+	u32        mode_datalen:16;
+	u32        medium_type:8;
+
+	/*
+	 * device specific parameters expanded for direct access devices
+	 */
+#ifdef __BIGENDIAN
+	u32        wp:1;		/* write protected */
+	u32        reserved1:2;
+	u32        dpofua:1;	/* disable page out + force unit access
+					 */
+	u32        reserved2:4;
+#else
+	u32        reserved2:4;
+	u32        dpofua:1;	/* disable page out + force unit access
+					 */
+	u32        reserved1:2;
+	u32        wp:1;		/* write protected */
+#endif
+
+#ifdef __BIGENDIAN
+	u32        reserved3:7;
+	u32        longlba:1;
+#else
+	u32        longlba:1;
+	u32        reserved3:7;
+#endif
+	u32        reserved4:8;
+	u32        block_desclen:16;
+};
+
+/*
+ * mode parameter block descriptor
+ */
+struct scsi_mode_param_desc_s{
+	u32        nblks;
+	u32        density_code:8;
+	u32        block_length:24;
+};
+
+/*
+ * Disconnect-reconnect mode page format
+ */
+struct scsi_mp_disc_recn_s{
+#ifdef __BIGENDIAN
+	u8         ps:1;
+	u8         reserved1:1;
+	u8         page_code:6;
+#else
+	u8         page_code:6;
+	u8         reserved1:1;
+	u8         ps:1;
+#endif
+	u8         page_len;
+	u8         buf_full_ratio;
+	u8         buf_empty_ratio;
+
+	u8         bil_msb;	/* bus inactivity limit -MSB */
+	u8         bil_lsb;	/* bus inactivity limit -LSB */
+
+	u8         dtl_msb;	/* disconnect time limit - MSB */
+	u8         dtl_lsb;	/* disconnect time limit - LSB */
+
+	u8         ctl_msb;	/* connect time limit - MSB */
+	u8         ctl_lsb;	/* connect time limit - LSB */
+
+	u8         max_burst_len_msb;
+	u8         max_burst_len_lsb;
+#ifdef __BIGENDIAN
+	u8         emdp:1;	/* enable modify data pointers */
+	u8         fa:3;	/* fair arbitration */
+	u8         dimm:1;	/* disconnect immediate */
+	u8         dtdc:3;	/* data transfer disconnect control */
+#else
+	u8         dtdc:3;	/* data transfer disconnect control */
+	u8         dimm:1;	/* disconnect immediate */
+	u8         fa:3;	/* fair arbitration */
+	u8         emdp:1;	/* enable modify data pointers */
+#endif
+
+	u8         reserved3;
+
+	u8         first_burst_len_msb;
+	u8         first_burst_len_lsb;
+};
+
+/*
+ * SCSI format device mode page
+ */
+struct scsi_mp_format_device_s{
+#ifdef __BIGENDIAN
+	u32        ps:1;
+	u32        reserved1:1;
+	u32        page_code:6;
+#else
+	u32        page_code:6;
+	u32        reserved1:1;
+	u32        ps:1;
+#endif
+	u32        page_len:8;
+	u32        tracks_per_zone:16;
+
+	u32        a_sec_per_zone:16;
+	u32        a_tracks_per_zone:16;
+
+	u32        a_tracks_per_lun:16;	/* alternate tracks/lun-MSB */
+	u32        sec_per_track:16;	/* sectors/track-MSB */
+
+	u32        bytes_per_sector:16;
+	u32        interleave:16;
+
+	u32        tsf:16;			/* track skew factor-MSB */
+	u32        csf:16;			/* cylinder skew factor-MSB */
+
+#ifdef __BIGENDIAN
+	u32        ssec:1;	/* soft sector formatting */
+	u32        hsec:1;	/* hard sector formatting */
+	u32        rmb:1;	/* removable media */
+	u32        surf:1;	/* surface */
+	u32        reserved2:4;
+#else
+	u32        reserved2:4;
+	u32        surf:1;	/* surface */
+	u32        rmb:1;	/* removable media */
+	u32        hsec:1;	/* hard sector formatting */
+	u32        ssec:1;	/* soft sector formatting */
+#endif
+	u32        reserved3:24;
+};
+
+/*
+ * SCSI rigid disk device geometry page
+ */
+struct scsi_mp_rigid_device_geometry_s{
+#ifdef __BIGENDIAN
+	u32        ps:1;
+	u32        reserved1:1;
+	u32        page_code:6;
+#else
+	u32        page_code:6;
+	u32        reserved1:1;
+	u32        ps:1;
+#endif
+	u32        page_len:8;
+	u32        num_cylinders0:8;
+	u32        num_cylinders1:8;
+
+	u32        num_cylinders2:8;
+	u32        num_heads:8;
+	u32        scwp0:8;
+	u32        scwp1:8;
+
+	u32        scwp2:8;
+	u32        scrwc0:8;
+	u32        scrwc1:8;
+	u32        scrwc2:8;
+
+	u32        dsr:16;
+	u32        lscyl0:8;
+	u32        lscyl1:8;
+
+	u32        lscyl2:8;
+#ifdef __BIGENDIAN
+	u32        reserved2:6;
+	u32        rpl:2;	/* rotational position locking */
+#else
+	u32        rpl:2;	/* rotational position locking */
+	u32        reserved2:6;
+#endif
+	u32        rot_off:8;
+	u32        reserved3:8;
+
+	u32        med_rot_rate:16;
+	u32        reserved4:16;
+};
+
+/*
+ * SCSI caching mode page
+ */
+struct scsi_mp_caching_s{
+#ifdef __BIGENDIAN
+	u8         ps:1;
+	u8         res1:1;
+	u8         page_code:6;
+#else
+	u8         page_code:6;
+	u8         res1:1;
+	u8         ps:1;
+#endif
+	u8         page_len;
+#ifdef __BIGENDIAN
+	u8         ic:1;	/* initiator control */
+	u8         abpf:1;	/* abort pre-fetch */
+	u8         cap:1;	/* caching analysis permitted */
+	u8         disc:1;	/* discontinuity */
+	u8         size:1;	/* size enable */
+	u8         wce:1;	/* write cache enable */
+	u8         mf:1;	/* multiplication factor */
+	u8         rcd:1;	/* read cache disable */
+
+	u8         drrp:4;	/* demand read retention priority */
+	u8         wrp:4;	/* write retention priority */
+#else
+	u8         rcd:1;	/* read cache disable */
+	u8         mf:1;	/* multiplication factor */
+	u8         wce:1;	/* write cache enable */
+	u8         size:1;	/* size enable */
+	u8         disc:1;	/* discontinuity */
+	u8         cap:1;	/* caching analysis permitted */
+	u8         abpf:1;	/* abort pre-fetch */
+	u8         ic:1;	/* initiator control */
+
+	u8         wrp:4;	/* write retention priority */
+	u8         drrp:4;	/* demand read retention priority */
+#endif
+	u8         dptl[2];/* disable pre-fetch transfer length */
+	u8         min_prefetch[2];
+	u8         max_prefetch[2];
+	u8         max_prefetch_limit[2];
+#ifdef __BIGENDIAN
+	u8         fsw:1;	/* force sequential write */
+	u8         lbcss:1;/* logical block cache segment size */
+	u8         dra:1;	/* disable read ahead */
+	u8         vs:2;	/* vendor specific */
+	u8         res2:3;
+#else
+	u8         res2:3;
+	u8         vs:2;	/* vendor specific */
+	u8         dra:1;	/* disable read ahead */
+	u8         lbcss:1;/* logical block cache segment size */
+	u8         fsw:1;	/* force sequential write */
+#endif
+	u8         num_cache_segs;
+
+	u8         cache_seg_size[2];
+	u8         res3;
+	u8         non_cache_seg_size[3];
+};
+
+/*
+ * SCSI control mode page
+ */
+struct scsi_mp_control_page_s{
+#ifdef __BIGENDIAN
+u8         ps:1;
+u8         reserved1:1;
+u8         page_code:6;
+#else
+u8         page_code:6;
+u8         reserved1:1;
+u8         ps:1;
+#endif
+	u8         page_len;
+#ifdef __BIGENDIAN
+	u8         tst:3;		/* task set type */
+	u8         reserved3:3;
+	u8         gltsd:1;	/* global logging target save disable */
+	u8         rlec:1;		/* report log exception condition */
+
+	u8         qalgo_mod:4;	/* queue alogorithm modifier */
+	u8         reserved4:1;
+	u8         qerr:2;		/* queue error management */
+	u8         dque:1;		/* disable queuing */
+
+	u8         reserved5:1;
+	u8         rac:1;		/* report a check */
+	u8         reserved6:2;
+	u8         swp:1;		/* software write protect */
+	u8         raerp:1;	/* ready AER permission */
+	u8         uaaerp:1;	/* unit attenstion AER permission */
+	u8         eaerp:1;	/* error AER permission */
+
+	u8         reserved7:5;
+	u8         autoload_mod:3;
+#else
+	u8         rlec:1;		/* report log exception condition */
+	u8         gltsd:1;	/* global logging target save disable */
+	u8         reserved3:3;
+	u8         tst:3;		/* task set type */
+
+	u8         dque:1;		/* disable queuing */
+	u8         qerr:2;		/* queue error management */
+	u8         reserved4:1;
+	u8         qalgo_mod:4;	/* queue alogorithm modifier */
+
+	u8         eaerp:1;	/* error AER permission */
+	u8         uaaerp:1;	/* unit attenstion AER permission */
+	u8         raerp:1;	/* ready AER permission */
+	u8         swp:1;		/* software write protect */
+	u8         reserved6:2;
+	u8         rac:1;		/* report a check */
+	u8         reserved5:1;
+
+	u8         autoload_mod:3;
+	u8         reserved7:5;
+#endif
+	u8         rahp_msb;	/* ready AER holdoff period - MSB */
+	u8         rahp_lsb;	/* ready AER holdoff period - LSB */
+
+	u8         busy_timeout_period_msb;
+	u8         busy_timeout_period_lsb;
+
+	u8         ext_selftest_compl_time_msb;
+	u8         ext_selftest_compl_time_lsb;
+};
+
+/*
+ * SCSI medium types supported mode page
+ */
+struct scsi_mp_medium_types_sup_s{
+#ifdef __BIGENDIAN
+	u8         ps:1;
+	u8         reserved1:1;
+	u8         page_code:6;
+#else
+	u8         page_code:6;
+	u8         reserved1:1;
+	u8         ps:1;
+#endif
+	u8         page_len;
+
+	u8         reserved3[2];
+	u8         med_type1_sup;	/* medium type one supported */
+	u8         med_type2_sup;	/* medium type two supported */
+	u8         med_type3_sup;	/* medium type three supported */
+	u8         med_type4_sup;	/* medium type four supported */
+};
+
+/*
+ * SCSI informational exception control mode page
+ */
+struct scsi_mp_info_excpt_cntl_s{
+#ifdef __BIGENDIAN
+	u8         ps:1;
+	u8         reserved1:1;
+	u8         page_code:6;
+#else
+	u8         page_code:6;
+	u8         reserved1:1;
+	u8         ps:1;
+#endif
+	u8         page_len;
+#ifdef __BIGENDIAN
+	u8         perf:1;		/* performance */
+	u8         reserved3:1;
+	u8         ebf:1;		/* enable background fucntion */
+	u8         ewasc:1;	/* enable warning */
+	u8         dexcpt:1;	/* disable exception control */
+	u8         test:1;		/* enable test device failure
+					 * notification
+					 */
+	u8         reserved4:1;
+	u8         log_error:1;
+
+	u8         reserved5:4;
+	u8         mrie:4;		/* method of reporting info
+					 * exceptions
+					 */
+#else
+	u8         log_error:1;
+	u8         reserved4:1;
+	u8         test:1;		/* enable test device failure
+					 * notification
+					 */
+	u8         dexcpt:1;	/* disable exception control */
+	u8         ewasc:1;	/* enable warning */
+	u8         ebf:1;		/* enable background fucntion */
+	u8         reserved3:1;
+	u8         perf:1;		/* performance */
+
+	u8         mrie:4;		/* method of reporting info
+					 * exceptions
+					 */
+	u8         reserved5:4;
+#endif
+	u8         interval_timer_msb;
+	u8         interval_timer_lsb;
+
+	u8         report_count_msb;
+	u8         report_count_lsb;
+};
+
+/*
+ * Methods of reporting informational exceptions
+ */
+#define SCSI_MP_IEC_NO_REPORT       0x0	/* no reporting of exceptions */
+#define SCSI_MP_IEC_AER             0x1	/* async event reporting */
+#define SCSI_MP_IEC_UNIT_ATTN       0x2	/* generate unit attenstion */
+#define SCSI_MO_IEC_COND_REC_ERR    0x3	/* conditionally generate recovered
+					 * error
+					 */
+#define SCSI_MP_IEC_UNCOND_REC_ERR  0x4	/* unconditionally generate recovered
+					 * error
+					 */
+#define SCSI_MP_IEC_NO_SENSE        0x5	/* generate no sense */
+#define SCSI_MP_IEC_ON_REQUEST      0x6	/* only report exceptions on request */
+
+/*
+ * SCSI flexible disk page
+ */
+struct scsi_mp_flexible_disk_s{
+#ifdef __BIGENDIAN
+	u8         ps:1;
+	u8         reserved1:1;
+	u8         page_code:6;
+#else
+	u8         page_code:6;
+	u8         reserved1:1;
+	u8         ps:1;
+#endif
+	u8         page_len;
+
+	u8         transfer_rate_msb;
+	u8         transfer_rate_lsb;
+
+	u8         num_heads;
+	u8         num_sectors;
+
+	u8         bytes_per_sector_msb;
+	u8         bytes_per_sector_lsb;
+
+	u8         num_cylinders_msb;
+	u8         num_cylinders_lsb;
+
+	u8         sc_wpc_msb;	/* starting cylinder-write
+					 * precompensation msb
+					 */
+	u8         sc_wpc_lsb;	/* starting cylinder-write
+					 * precompensation lsb
+					 */
+	u8         sc_rwc_msb;	/* starting cylinder-reduced write
+					 * current msb
+					 */
+	u8         sc_rwc_lsb;	/* starting cylinder-reduced write
+					 * current lsb
+					 */
+
+	u8         dev_step_rate_msb;
+	u8         dev_step_rate_lsb;
+
+	u8         dev_step_pulse_width;
+
+	u8         head_sd_msb;	/* head settle delay msb */
+	u8         head_sd_lsb;	/* head settle delay lsb */
+
+	u8         motor_on_delay;
+	u8         motor_off_delay;
+#ifdef __BIGENDIAN
+	u8         trdy:1;		/* true ready bit */
+	u8         ssn:1;		/* start sector number bit */
+	u8         mo:1;		/* motor on bit */
+	u8         reserved3:5;
+
+	u8         reserved4:4;
+	u8         spc:4;		/* step pulse per cylinder */
+#else
+	u8         reserved3:5;
+	u8         mo:1;		/* motor on bit */
+	u8         ssn:1;		/* start sector number bit */
+	u8         trdy:1;		/* true ready bit */
+
+	u8         spc:4;		/* step pulse per cylinder */
+	u8         reserved4:4;
+#endif
+	u8         write_comp;
+	u8         head_load_delay;
+	u8         head_unload_delay;
+#ifdef __BIGENDIAN
+	u8         pin34:4;	/* pin34 usage */
+	u8         pin2:4;		/* pin2 usage */
+
+	u8         pin4:4;		/* pin4 usage */
+	u8         pin1:4;		/* pin1 usage */
+#else
+	u8         pin2:4;		/* pin2 usage */
+	u8         pin34:4;	/* pin34 usage */
+
+	u8         pin1:4;		/* pin1 usage */
+	u8         pin4:4;		/* pin4 usage */
+#endif
+	u8         med_rot_rate_msb;
+	u8         med_rot_rate_lsb;
+
+	u8         reserved5[2];
+};
+
+struct scsi_mode_page_format_data6_s{
+	struct scsi_mode_param_header6_s mph;	/* mode page header */
+	struct scsi_mode_param_desc_s desc;	/* block descriptor */
+	struct scsi_mp_format_device_s format;	/* format device data */
+};
+
+struct scsi_mode_page_format_data10_s{
+	struct scsi_mode_param_header10_s mph;	/* mode page header */
+	struct scsi_mode_param_desc_s desc;	/* block descriptor */
+	struct scsi_mp_format_device_s format;	/* format device data */
+};
+
+struct scsi_mode_page_rdg_data6_s{
+	struct scsi_mode_param_header6_s mph;	/* mode page header */
+	struct scsi_mode_param_desc_s desc;	/* block descriptor */
+	struct scsi_mp_rigid_device_geometry_s rdg;
+					/* rigid geometry data */
+};
+
+struct scsi_mode_page_rdg_data10_s{
+	struct scsi_mode_param_header10_s mph;	/* mode page header */
+	struct scsi_mode_param_desc_s desc;	/* block descriptor */
+	struct scsi_mp_rigid_device_geometry_s rdg;
+					/* rigid geometry data */
+};
+
+struct scsi_mode_page_cache6_s{
+	struct scsi_mode_param_header6_s mph;	/* mode page header */
+	struct scsi_mode_param_desc_s desc;	/* block descriptor */
+	struct scsi_mp_caching_s cache;	/* cache page data */
+};
+
+struct scsi_mode_page_cache10_s{
+	struct scsi_mode_param_header10_s mph;	/* mode page header */
+	struct scsi_mode_param_desc_s desc;	/* block descriptor */
+	struct scsi_mp_caching_s cache;	/* cache page data */
+};
+
+/* --------------------------------------------------------------
+ * Format Unit command
+ * ------------------------------------------------------------
+ */
+
+/*
+ * Format Unit CDB
+ */
+struct scsi_format_unit_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         res1:3;
+	u8         fmtdata:1;	/* if set, data out phase has format
+					 * data
+					 */
+	u8         cmplst:1;	/* if set, defect list is complete */
+	u8         def_list:3;	/* format of defect descriptor is
+					 * fmtdata =1
+					 */
+#else
+	u8         def_list:3;	/* format of defect descriptor is
+					 * fmtdata = 1
+					 */
+	u8         cmplst:1;	/* if set, defect list is complete */
+	u8         fmtdata:1;	/* if set, data out phase has format
+					 * data
+					 */
+	u8         res1:3;
+#endif
+	u8         interleave_msb;
+	u8         interleave_lsb;
+	u8         vendor_spec;
+	u8         control;
+};
+
+/*
+ * h
+ */
+struct scsi_reserve6_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         reserved:3;
+	u8         obsolete:4;
+	u8         extent:1;
+#else
+	u8         extent:1;
+	u8         obsolete:4;
+	u8         reserved:3;
+#endif
+	u8         reservation_id;
+	u16        param_list_len;
+	u8         control;
+};
+
+/*
+ * h
+ */
+struct scsi_release6_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         reserved1:3;
+	u8         obsolete:4;
+	u8         extent:1;
+#else
+	u8         extent:1;
+	u8         obsolete:4;
+	u8         reserved1:3;
+#endif
+	u8         reservation_id;
+	u16        reserved2;
+	u8         control;
+};
+
+/*
+ * h
+ */
+struct scsi_reserve10_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         reserved1:3;
+	u8         third_party:1;
+	u8         reserved2:2;
+	u8         long_id:1;
+	u8         extent:1;
+#else
+	u8         extent:1;
+	u8         long_id:1;
+	u8         reserved2:2;
+	u8         third_party:1;
+	u8         reserved1:3;
+#endif
+	u8         reservation_id;
+	u8         third_pty_dev_id;
+	u8         reserved3;
+	u8         reserved4;
+	u8         reserved5;
+	u16        param_list_len;
+	u8         control;
+};
+
+struct scsi_release10_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         reserved1:3;
+	u8         third_party:1;
+	u8         reserved2:2;
+	u8         long_id:1;
+	u8         extent:1;
+#else
+	u8         extent:1;
+	u8         long_id:1;
+	u8         reserved2:2;
+	u8         third_party:1;
+	u8         reserved1:3;
+#endif
+	u8         reservation_id;
+	u8         third_pty_dev_id;
+	u8         reserved3;
+	u8         reserved4;
+	u8         reserved5;
+	u16        param_list_len;
+	u8         control;
+};
+
+struct scsi_verify10_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         lun:3;
+	u8         dpo:1;
+	u8         reserved:2;
+	u8         bytchk:1;
+	u8         reladdr:1;
+#else
+	u8         reladdr:1;
+	u8         bytchk:1;
+	u8         reserved:2;
+	u8         dpo:1;
+	u8         lun:3;
+#endif
+	u8         lba0;
+	u8         lba1;
+	u8         lba2;
+	u8         lba3;
+	u8         reserved1;
+	u8         verification_len0;
+	u8         verification_len1;
+	u8         control_byte;
+};
+
+struct scsi_request_sense_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         lun:3;
+	u8         reserved:5;
+#else
+	u8         reserved:5;
+	u8         lun:3;
+#endif
+	u8         reserved0;
+	u8         reserved1;
+	u8         alloc_len;
+	u8         control_byte;
+};
+
+/* ------------------------------------------------------------
+ * SCSI status byte values
+ * ------------------------------------------------------------
+ */
+#define SCSI_STATUS_GOOD                   0x00
+#define SCSI_STATUS_CHECK_CONDITION        0x02
+#define SCSI_STATUS_CONDITION_MET          0x04
+#define SCSI_STATUS_BUSY                   0x08
+#define SCSI_STATUS_INTERMEDIATE           0x10
+#define SCSI_STATUS_ICM                    0x14	/* intermediate condition met */
+#define SCSI_STATUS_RESERVATION_CONFLICT   0x18
+#define SCSI_STATUS_COMMAND_TERMINATED     0x22
+#define SCSI_STATUS_QUEUE_FULL             0x28
+#define SCSI_STATUS_ACA_ACTIVE             0x30
+
+#define SCSI_MAX_ALLOC_LEN		0xFF	/* maximum allocarion length
+						 * in CDBs
+						 */
+
+#define SCSI_OP_WRITE_VERIFY10      0x2E
+#define SCSI_OP_WRITE_VERIFY12      0xAE
+#define SCSI_OP_UNDEF               0xFF
+
+/*
+ * SCSI WRITE-VERIFY(10) command
+ */
+struct scsi_write_verify10_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         reserved1:3;
+	u8         dpo:1;		/* Disable Page Out */
+	u8         reserved2:1;
+	u8         ebp:1;		/* erse by-pass */
+	u8         bytchk:1;	/* byte check */
+	u8         rel_adr:1;	/* relative address */
+#else
+	u8         rel_adr:1;	/* relative address */
+	u8         bytchk:1;	/* byte check */
+	u8         ebp:1;		/* erse by-pass */
+	u8         reserved2:1;
+	u8         dpo:1;		/* Disable Page Out */
+	u8         reserved1:3;
+#endif
+	u8         lba0;		/* logical block address - MSB */
+	u8         lba1;
+	u8         lba2;
+	u8         lba3;		/* LSB */
+	u8         reserved3;
+	u8         xfer_length0;	/* transfer length in blocks - MSB */
+	u8         xfer_length1;	/* LSB */
+	u8         control;
+};
+
+#pragma pack()
+
+#endif /* __SCSI_H__ */
diff -urpN orig/drivers/scsi/bfa/include/protocol/types.h patch/drivers/scsi/bfa/include/protocol/types.h
--- orig/drivers/scsi/bfa/include/protocol/types.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/protocol/types.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,42 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  types.h Protocol defined base types
+ */
+
+#ifndef __TYPES_H__
+#define __TYPES_H__
+
+#include <bfa_os_inc.h>
+
+#define wwn_t u64
+#define lun_t u64
+
+#define WWN_NULL	(0)
+#define FC_SYMNAME_MAX	256	/*  max name server symbolic name size */
+#define FC_ALPA_MAX	128
+
+#pragma pack(1)
+
+#define MAC_ADDRLEN	(6)
+struct mac_s { u8 mac[MAC_ADDRLEN]; };
+#define mac_t struct mac_s
+
+#pragma pack()
+
+#endif

From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 5/14] bfa: Brocade BFA FC SCSI driver (bfa part4)
Date: Thu, 20 Aug 2009 00:05:44 -0700
Message-ID: <200908200705.n7K75iOW007017@swe57.brocade.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx10.brocade.com ([208.185.105.18]:7408 "EHLO mx10.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbZHTHFo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2009 03:05:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This patch contains code to access Brocade Fibre channel HBA
firmware/hardware, part-4

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 bfa_lps_priv.h     |   38 ++
 bfa_module.c       |   90 +++++
 bfa_modules_priv.h |   43 ++
 bfa_os_inc.h       |  196 +++++++++++
 bfa_port.c         |  460 ++++++++++++++++++++++++++
 bfa_port_priv.h    |   90 +++++
 bfa_priv.h         |  113 ++++++
 bfa_rport.c        |  911 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 bfa_rport_priv.h   |   45 ++
 bfa_sgpg.c         |  231 +++++++++++++
 bfa_sgpg_priv.h    |   79 ++++
 bfa_sm.c           |   38 ++
 bfa_timer.c        |   90 +++++
 bfa_trcmod_priv.h  |   66 +++
 bfa_tskim.c        |  689 ++++++++++++++++++++++++++++++++++++++++
 bfa_uf.c           |  345 ++++++++++++++++++++
 bfa_uf_priv.h      |   47 ++
 17 files changed, 3571 insertions(+)

diff -urpN orig/drivers/scsi/bfa/bfa_lps_priv.h patch/drivers/scsi/bfa/bfa_lps_priv.h
--- orig/drivers/scsi/bfa/bfa_lps_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_lps_priv.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,38 @@
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
+#ifndef __BFA_LPS_PRIV_H__
+#define __BFA_LPS_PRIV_H__
+
+#include <bfa_svc.h>
+
+struct bfa_lps_mod_s {
+	struct list_head		lps_free_q;
+	struct list_head		lps_active_q;
+	struct bfa_lps_s	*lps_arr;
+	int			num_lps;
+};
+
+#define BFA_LPS_MOD(__bfa)		(&(__bfa)->modules.lps_mod)
+#define BFA_LPS_FROM_TAG(__mod, __tag)	(&(__mod)->lps_arr[__tag])
+
+/*
+ * external functions
+ */
+void	bfa_lps_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
+
+#endif /* __BFA_LPS_PRIV_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_module.c patch/drivers/scsi/bfa/bfa_module.c
--- orig/drivers/scsi/bfa/bfa_module.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_module.c	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,90 @@
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
+#include <bfa.h>
+#include <defs/bfa_defs_pci.h>
+#include <cs/bfa_debug.h>
+#include <bfa_iocfc.h>
+
+/**
+ * BFA module list terminated by NULL
+ */
+struct bfa_module_s *hal_mods[] = {
+	&hal_mod_sgpg,
+	&hal_mod_pport,
+	&hal_mod_fcxp,
+	&hal_mod_lps,
+	&hal_mod_uf,
+	&hal_mod_rport,
+	&hal_mod_fcpim,
+#ifdef BFA_CFG_PBIND
+	&hal_mod_pbind,
+#endif
+	NULL
+};
+
+/**
+ * Message handlers for various modules.
+ */
+bfa_isr_func_t  bfa_isrs[BFI_MC_MAX] = {
+	bfa_isr_unhandled,	/* NONE */
+	bfa_isr_unhandled,	/* BFI_MC_IOC */
+	bfa_isr_unhandled,	/* BFI_MC_DIAG */
+	bfa_isr_unhandled,	/* BFI_MC_FLASH */
+	bfa_isr_unhandled,	/* BFI_MC_CEE */
+	bfa_pport_isr,		/* BFI_MC_PORT */
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
+
+/**
+ * Message handlers for mailbox command classes
+ */
+bfa_ioc_mbox_mcfunc_t  bfa_mbox_isrs[BFI_MC_MAX] = {
+	NULL,
+	NULL,			/* BFI_MC_IOC	*/
+	NULL,			/* BFI_MC_DIAG	*/
+	NULL,		/* BFI_MC_FLASH */
+	NULL,			/* BFI_MC_CEE	*/
+	NULL,			/* BFI_MC_PORT	*/
+	bfa_iocfc_isr,		/* BFI_MC_IOCFC */
+	NULL,
+};
+
diff -urpN orig/drivers/scsi/bfa/bfa_modules_priv.h patch/drivers/scsi/bfa/bfa_modules_priv.h
--- orig/drivers/scsi/bfa/bfa_modules_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_modules_priv.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,43 @@
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
+#ifndef __BFA_MODULES_PRIV_H__
+#define __BFA_MODULES_PRIV_H__
+
+#include "bfa_uf_priv.h"
+#include "bfa_port_priv.h"
+#include "bfa_rport_priv.h"
+#include "bfa_fcxp_priv.h"
+#include "bfa_lps_priv.h"
+#include "bfa_fcpim_priv.h"
+#include <cee/bfa_cee.h>
+#include <port/bfa_port.h>
+
+
+struct bfa_modules_s {
+	struct bfa_pport_s	pport;	/*  physical port module	*/
+	struct bfa_fcxp_mod_s fcxp_mod; /*  fcxp module		*/
+	struct bfa_lps_mod_s lps_mod;   /*  fcxp module		*/
+	struct bfa_uf_mod_s uf_mod;	/*  unsolicited frame module	*/
+	struct bfa_rport_mod_s rport_mod; /*  remote port module	*/
+	struct bfa_fcpim_mod_s fcpim_mod; /*  FCP initiator module	*/
+	struct bfa_sgpg_mod_s sgpg_mod; /*  SG page module		*/
+	struct bfa_cee_s cee;   	/*  CEE Module                 */
+	struct bfa_port_s port;		/*  Physical port module	*/
+};
+
+#endif /* __BFA_MODULES_PRIV_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_os_inc.h patch/drivers/scsi/bfa/bfa_os_inc.h
--- orig/drivers/scsi/bfa/bfa_os_inc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_os_inc.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,196 @@
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
+ * Contains declarations all OS Specific files needed for BFA layer
+ */
+
+#ifndef __BFA_OS_INC_H__
+#define __BFA_OS_INC_H__
+
+#ifndef __KERNEL__
+#include <stdint.h>
+#else
+#include <linux/types.h>
+
+#include <linux/version.h>
+#include <linux/pci.h>
+
+#include <linux/dma-mapping.h>
+#define SET_MODULE_VERSION(VER)
+
+#include <linux/idr.h>
+
+#include <linux/interrupt.h>
+#include <linux/cdev.h>
+#include <linux/fs.h>
+#include <linux/delay.h>
+#include <linux/vmalloc.h>
+
+#include <linux/workqueue.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsi_transport_fc.h>
+#include <scsi/scsi_transport.h>
+
+#define BFA_ERR			KERN_ERR
+#define BFA_WARNING		KERN_WARNING
+#define BFA_NOTICE		KERN_NOTICE
+#define BFA_INFO		KERN_INFO
+#define BFA_DEBUG		KERN_DEBUG
+
+#define LOG_BFAD_INIT		0x00000001
+#define LOG_FCP_IO		0x00000002
+
+#ifdef DEBUG
+#define BFA_LOG_TRACE(bfad, level, mask, fmt, arg...)			\
+		BFA_LOG(bfad, level, mask, fmt, ## arg)
+#define BFA_DEV_TRACE(bfad, level, fmt, arg...)				\
+		BFA_DEV_PRINTF(bfad, level, fmt, ## arg)
+#define BFA_TRACE(level, fmt, arg...)					\
+		BFA_PRINTF(level, fmt, ## arg)
+#else
+#define BFA_LOG_TRACE(bfad, level, mask, fmt, arg...)
+#define BFA_DEV_TRACE(bfad, level, fmt, arg...)
+#define BFA_TRACE(level, fmt, arg...)
+#endif
+
+#define BFA_ASSERT(p) do {						\
+	if (!(p)) {      \
+		printk(KERN_ERR "assert(%s) failed at %s:%d\n",		\
+		#p, __FILE__, __LINE__);      \
+		BUG();      \
+	}								\
+} while (0)
+
+
+#define BFA_LOG(bfad, level, mask, fmt, arg...)				\
+do { 									\
+	if (((mask) & (((struct bfad_s *)(bfad))->			\
+		cfg_data[cfg_log_mask])) || (level[1] <= '3'))		\
+		dev_printk(level, &(((struct bfad_s *)			\
+			(bfad))->pcidev->dev), fmt, ##arg);      \
+} while (0)
+
+#ifndef BFA_DEV_PRINTF
+#define BFA_DEV_PRINTF(bfad, level, fmt, arg...)			\
+		dev_printk(level, &(((struct bfad_s *)			\
+			(bfad))->pcidev->dev), fmt, ##arg);
+#endif
+
+#define BFA_PRINTF(level, fmt, arg...)					\
+		printk(level fmt, ##arg);
+
+int bfa_os_MWB(void *);
+
+#define bfa_os_mmiowb()		mmiowb()
+
+#define bfa_swap_3b(_x)				\
+	((((_x) & 0xff) << 16) |		\
+	((_x) & 0x00ff00) |			\
+	(((_x) & 0xff0000) >> 16))
+
+#define bfa_swap_8b(_x) 				\
+     ((((_x) & 0xff00000000000000ull) >> 56)		\
+      | (((_x) & 0x00ff000000000000ull) >> 40)		\
+      | (((_x) & 0x0000ff0000000000ull) >> 24)		\
+      | (((_x) & 0x000000ff00000000ull) >> 8)		\
+      | (((_x) & 0x00000000ff000000ull) << 8)		\
+      | (((_x) & 0x0000000000ff0000ull) << 24)		\
+      | (((_x) & 0x000000000000ff00ull) << 40)		\
+      | (((_x) & 0x00000000000000ffull) << 56))
+
+#define bfa_os_swap32(_x) 			\
+	((((_x) & 0xff) << 24) 		|	\
+	(((_x) & 0x0000ff00) << 8)	|	\
+	(((_x) & 0x00ff0000) >> 8)	|	\
+	(((_x) & 0xff000000) >> 24))
+
+
+#ifndef __BIGENDIAN
+#define bfa_os_htons(_x) ((u16)((((_x) & 0xff00) >> 8) | \
+				 (((_x) & 0x00ff) << 8)))
+
+#define bfa_os_htonl(_x)	bfa_os_swap32(_x)
+#define bfa_os_htonll(_x)	bfa_swap_8b(_x)
+#define bfa_os_hton3b(_x)	bfa_swap_3b(_x)
+
+#define bfa_os_wtole(_x)   (_x)
+
+#else
+
+#define bfa_os_htons(_x)   (_x)
+#define bfa_os_htonl(_x)   (_x)
+#define bfa_os_hton3b(_x)  (_x)
+#define bfa_os_htonll(_x)  (_x)
+#define bfa_os_wtole(_x)   bfa_os_swap32(_x)
+
+#endif
+
+#define bfa_os_ntohs(_x)   bfa_os_htons(_x)
+#define bfa_os_ntohl(_x)   bfa_os_htonl(_x)
+#define bfa_os_ntohll(_x)  bfa_os_htonll(_x)
+#define bfa_os_ntoh3b(_x)  bfa_os_hton3b(_x)
+
+#define bfa_os_u32(__pa64) ((__pa64) >> 32)
+
+#define bfa_os_memset	memset
+#define bfa_os_memcpy	memcpy
+#define bfa_os_udelay	udelay
+#define bfa_os_vsprintf vsprintf
+
+#define bfa_os_assign(__t, __s) __t = __s
+
+#define bfa_os_addr_t char __iomem *
+#define bfa_os_panic()
+
+#define bfa_os_reg_read(_raddr) bfa_os_wtole(readl(_raddr))
+#define bfa_os_reg_write(_raddr, _val) writel(bfa_os_wtole((_val)), (_raddr))
+#define bfa_os_mem_read(_raddr, _off)                                   \
+	bfa_os_ntohl(readl(((_raddr) + (_off))))
+#define bfa_os_mem_write(_raddr, _off, _val)                            \
+	writel(bfa_os_htonl((_val)), ((_raddr) + (_off)))
+
+#define BFA_TRC_TS(_trcm)						\
+			({						\
+				struct timeval tv;			\
+									\
+				do_gettimeofday(&tv);      \
+				(tv.tv_sec*1000000+tv.tv_usec);      \
+			 })
+
+struct bfa_log_mod_s;
+void bfa_os_printf(struct bfa_log_mod_s *log_mod, u32 msg_id,
+			const char *fmt, ...);
+#endif
+
+#define boolean_t int
+
+/**
+ * For current time stamp, OS API will fill-in
+ */
+struct bfa_timeval_s {
+	u32	tv_sec;		/*  seconds        */
+	u32	tv_usec;	/*  microseconds   */
+};
+
+void bfa_os_gettimeofday(struct bfa_timeval_s *tv);
+
+#endif /* __BFA_OS_INC_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_port.c patch/drivers/scsi/bfa/bfa_port.c
--- orig/drivers/scsi/bfa/bfa_port.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_port.c	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,460 @@
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
+#include <defs/bfa_defs_port.h>
+#include <cs/bfa_trc.h>
+#include <cs/bfa_log.h>
+#include <cs/bfa_debug.h>
+#include <port/bfa_port.h>
+#include <bfi/bfi.h>
+#include <bfi/bfi_port.h>
+#include <bfa_ioc.h>
+#include <cna/bfa_cna_trcmod.h>
+
+BFA_TRC_FILE(CNA, PORT);
+
+#define bfa_ioc_portid(__ioc) ((__ioc)->port_id)
+#define bfa_lpuid(__arg) bfa_ioc_portid(&(__arg)->ioc)
+
+static void
+bfa_port_stats_swap(struct bfa_port_s *port, union bfa_pport_stats_u *stats)
+{
+	u32       *dip = (u32 *) stats;
+	u32        t0, t1;
+	int             i;
+
+	for (i = 0; i < sizeof(union bfa_pport_stats_u) / sizeof(u32);
+	     i += 2) {
+		t0 = dip[i];
+		t1 = dip[i + 1];
+#ifdef __BIGENDIAN
+		dip[i] = bfa_os_ntohl(t0);
+		dip[i + 1] = bfa_os_ntohl(t1);
+#else
+		dip[i] = bfa_os_ntohl(t1);
+		dip[i + 1] = bfa_os_ntohl(t0);
+#endif
+	}
+
+    /** todo
+     * QoS stats r also swapped as 64bit; that structure also
+     * has to use 64 bit counters
+     */
+}
+
+/**
+ * bfa_port_enable_isr()
+ *
+ *
+ * @param[in] port - Pointer to the port module
+ *            status - Return status from the f/w
+ *
+ * @return void
+ */
+static void
+bfa_port_enable_isr(struct bfa_port_s *port, bfa_status_t status)
+{
+	bfa_assert(0);
+}
+
+/**
+ * bfa_port_disable_isr()
+ *
+ *
+ * @param[in] port - Pointer to the port module
+ *            status - Return status from the f/w
+ *
+ * @return void
+ */
+static void
+bfa_port_disable_isr(struct bfa_port_s *port, bfa_status_t status)
+{
+	bfa_assert(0);
+}
+
+/**
+ * bfa_port_get_stats_isr()
+ *
+ *
+ * @param[in] port - Pointer to the Port module
+ *            status - Return status from the f/w
+ *
+ * @return void
+ */
+static void
+bfa_port_get_stats_isr(struct bfa_port_s *port, bfa_status_t status)
+{
+	port->stats_status = status;
+	port->stats_busy = BFA_FALSE;
+
+	if (status == BFA_STATUS_OK) {
+		memcpy(port->stats, port->stats_dma.kva,
+		       sizeof(union bfa_pport_stats_u));
+		bfa_port_stats_swap(port, port->stats);
+	}
+
+	if (port->stats_cbfn) {
+		port->stats_cbfn(port->stats_cbarg, status);
+		port->stats_cbfn = NULL;
+	}
+}
+
+/**
+ * bfa_port_clear_stats_isr()
+ *
+ *
+ * @param[in] port - Pointer to the Port module
+ *            status - Return status from the f/w
+ *
+ * @return void
+ */
+static void
+bfa_port_clear_stats_isr(struct bfa_port_s *port, bfa_status_t status)
+{
+	port->stats_status = status;
+	port->stats_busy = BFA_FALSE;
+
+	if (port->stats_cbfn) {
+		port->stats_cbfn(port->stats_cbarg, status);
+		port->stats_cbfn = NULL;
+	}
+}
+
+/**
+ * bfa_port_isr()
+ *
+ *
+ * @param[in] Pointer to the Port module data structure.
+ *
+ * @return void
+ */
+static void
+bfa_port_isr(void *cbarg, struct bfi_mbmsg_s *m)
+{
+	struct bfa_port_s *port = (struct bfa_port_s *)cbarg;
+	union bfi_port_i2h_msg_u *i2hmsg;
+
+	i2hmsg = (union bfi_port_i2h_msg_u *)m;
+	bfa_trc(port, m->mh.msg_id);
+
+	switch (m->mh.msg_id) {
+	case BFI_PORT_I2H_ENABLE_RSP:
+		if (port->endis_pending == BFA_FALSE)
+			break;
+		bfa_port_enable_isr(port, i2hmsg->enable_rsp.status);
+		break;
+
+	case BFI_PORT_I2H_DISABLE_RSP:
+		if (port->endis_pending == BFA_FALSE)
+			break;
+		bfa_port_disable_isr(port, i2hmsg->disable_rsp.status);
+		break;
+
+	case BFI_PORT_I2H_GET_STATS_RSP:
+		/*
+		 * Stats busy flag is still set? (may be cmd timed out)
+		 */
+		if (port->stats_busy == BFA_FALSE)
+			break;
+		bfa_port_get_stats_isr(port, i2hmsg->getstats_rsp.status);
+		break;
+
+	case BFI_PORT_I2H_CLEAR_STATS_RSP:
+		if (port->stats_busy == BFA_FALSE)
+			break;
+		bfa_port_clear_stats_isr(port, i2hmsg->clearstats_rsp.status);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * bfa_port_meminfo()
+ *
+ *
+ * @param[in] void
+ *
+ * @return Size of DMA region
+ */
+u32
+bfa_port_meminfo(void)
+{
+	return BFA_ROUNDUP(sizeof(union bfa_pport_stats_u), BFA_DMA_ALIGN_SZ);
+}
+
+/**
+ * bfa_port_mem_claim()
+ *
+ *
+ * @param[in] port Port module pointer
+ * 	      dma_kva Kernel Virtual Address of Port DMA Memory
+ * 	      dma_pa  Physical Address of Port DMA Memory
+ *
+ * @return void
+ */
+void
+bfa_port_mem_claim(struct bfa_port_s *port, u8 *dma_kva, u64 dma_pa)
+{
+	port->stats_dma.kva = dma_kva;
+	port->stats_dma.pa = dma_pa;
+}
+
+/**
+ * bfa_port_enable()
+ *
+ *   Send the Port enable request to the f/w
+ *
+ * @param[in] Pointer to the Port module data structure.
+ *
+ * @return Status
+ */
+bfa_status_t
+bfa_port_enable(struct bfa_port_s *port, bfa_port_endis_cbfn_t cbfn,
+		void *cbarg)
+{
+	struct bfi_port_generic_req_s *m;
+
+	/** todo Not implemented */
+	bfa_assert(0);
+
+	if (!bfa_ioc_is_operational(port->ioc)) {
+		bfa_trc(port, BFA_STATUS_IOC_FAILURE);
+		return BFA_STATUS_IOC_FAILURE;
+	}
+
+	if (port->endis_pending) {
+		bfa_trc(port, BFA_STATUS_DEVBUSY);
+		return BFA_STATUS_DEVBUSY;
+	}
+
+	m = (struct bfi_port_generic_req_s *)port->endis_mb.msg;
+
+	port->msgtag++;
+	port->endis_cbfn = cbfn;
+	port->endis_cbarg = cbarg;
+	port->endis_pending = BFA_TRUE;
+
+	bfi_h2i_set(m->mh, BFI_MC_PORT, BFI_PORT_H2I_ENABLE_REQ,
+		    bfa_ioc_portid(port->ioc));
+	bfa_ioc_mbox_queue(port->ioc, &port->endis_mb);
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ * bfa_port_disable()
+ *
+ *   Send the Port disable request to the f/w
+ *
+ * @param[in] Pointer to the Port module data structure.
+ *
+ * @return Status
+ */
+bfa_status_t
+bfa_port_disable(struct bfa_port_s *port, bfa_port_endis_cbfn_t cbfn,
+		 void *cbarg)
+{
+	struct bfi_port_generic_req_s *m;
+
+	/** todo Not implemented */
+	bfa_assert(0);
+
+	if (!bfa_ioc_is_operational(port->ioc)) {
+		bfa_trc(port, BFA_STATUS_IOC_FAILURE);
+		return BFA_STATUS_IOC_FAILURE;
+	}
+
+	if (port->endis_pending) {
+		bfa_trc(port, BFA_STATUS_DEVBUSY);
+		return BFA_STATUS_DEVBUSY;
+	}
+
+	m = (struct bfi_port_generic_req_s *)port->endis_mb.msg;
+
+	port->msgtag++;
+	port->endis_cbfn = cbfn;
+	port->endis_cbarg = cbarg;
+	port->endis_pending = BFA_TRUE;
+
+	bfi_h2i_set(m->mh, BFI_MC_PORT, BFI_PORT_H2I_DISABLE_REQ,
+		    bfa_ioc_portid(port->ioc));
+	bfa_ioc_mbox_queue(port->ioc, &port->endis_mb);
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ * bfa_port_get_stats()
+ *
+ *   Send the request to the f/w to fetch Port statistics.
+ *
+ * @param[in] Pointer to the Port module data structure.
+ *
+ * @return Status
+ */
+bfa_status_t
+bfa_port_get_stats(struct bfa_port_s *port, union bfa_pport_stats_u *stats,
+		   bfa_port_stats_cbfn_t cbfn, void *cbarg)
+{
+	struct bfi_port_get_stats_req_s *m;
+
+	if (!bfa_ioc_is_operational(port->ioc)) {
+		bfa_trc(port, BFA_STATUS_IOC_FAILURE);
+		return BFA_STATUS_IOC_FAILURE;
+	}
+
+	if (port->stats_busy) {
+		bfa_trc(port, BFA_STATUS_DEVBUSY);
+		return BFA_STATUS_DEVBUSY;
+	}
+
+	m = (struct bfi_port_get_stats_req_s *)port->stats_mb.msg;
+
+	port->stats = stats;
+	port->stats_cbfn = cbfn;
+	port->stats_cbarg = cbarg;
+	port->stats_busy = BFA_TRUE;
+	bfa_dma_be_addr_set(m->dma_addr, port->stats_dma.pa);
+
+	bfi_h2i_set(m->mh, BFI_MC_PORT, BFI_PORT_H2I_GET_STATS_REQ,
+		    bfa_ioc_portid(port->ioc));
+	bfa_ioc_mbox_queue(port->ioc, &port->stats_mb);
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ * bfa_port_clear_stats()
+ *
+ *
+ * @param[in] Pointer to the Port module data structure.
+ *
+ * @return Status
+ */
+bfa_status_t
+bfa_port_clear_stats(struct bfa_port_s *port, bfa_port_stats_cbfn_t cbfn,
+		     void *cbarg)
+{
+	struct bfi_port_generic_req_s *m;
+
+	if (!bfa_ioc_is_operational(port->ioc)) {
+		bfa_trc(port, BFA_STATUS_IOC_FAILURE);
+		return BFA_STATUS_IOC_FAILURE;
+	}
+
+	if (port->stats_busy) {
+		bfa_trc(port, BFA_STATUS_DEVBUSY);
+		return BFA_STATUS_DEVBUSY;
+	}
+
+	m = (struct bfi_port_generic_req_s *)port->stats_mb.msg;
+
+	port->stats_cbfn = cbfn;
+	port->stats_cbarg = cbarg;
+	port->stats_busy = BFA_TRUE;
+
+	bfi_h2i_set(m->mh, BFI_MC_PORT, BFI_PORT_H2I_CLEAR_STATS_REQ,
+		    bfa_ioc_portid(port->ioc));
+	bfa_ioc_mbox_queue(port->ioc, &port->stats_mb);
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ * bfa_port_hbfail()
+ *
+ *
+ * @param[in] Pointer to the Port module data structure.
+ *
+ * @return void
+ */
+void
+bfa_port_hbfail(void *arg)
+{
+	struct bfa_port_s *port = (struct bfa_port_s *)arg;
+
+	/*
+	 * Fail any pending get_stats/clear_stats requests
+	 */
+	if (port->stats_busy) {
+		if (port->stats_cbfn)
+			port->stats_cbfn(port->dev, BFA_STATUS_FAILED);
+		port->stats_cbfn = NULL;
+		port->stats_busy = BFA_FALSE;
+	}
+
+	/*
+	 * Clear any enable/disable is pending
+	 */
+	if (port->endis_pending) {
+		if (port->endis_cbfn)
+			port->endis_cbfn(port->dev, BFA_STATUS_FAILED);
+		port->endis_cbfn = NULL;
+		port->endis_pending = BFA_FALSE;
+	}
+}
+
+/**
+ * bfa_port_attach()
+ *
+ *
+ * @param[in] port - Pointer to the Port module data structure
+ *            ioc  - Pointer to the ioc module data structure
+ *            dev  - Pointer to the device driver module data structure
+ *                   The device driver specific mbox ISR functions have
+ *                   this pointer as one of the parameters.
+ *            trcmod -
+ *            logmod -
+ *
+ * @return void
+ */
+void
+bfa_port_attach(struct bfa_port_s *port, struct bfa_ioc_s *ioc, void *dev,
+		struct bfa_trc_mod_s *trcmod, struct bfa_log_mod_s *logmod)
+{
+	bfa_assert(port);
+
+	port->dev = dev;
+	port->ioc = ioc;
+	port->trcmod = trcmod;
+	port->logmod = logmod;
+
+	port->stats_busy = port->endis_pending = BFA_FALSE;
+	port->stats_cbfn = port->endis_cbfn = NULL;
+
+	bfa_ioc_mbox_regisr(port->ioc, BFI_MC_PORT, bfa_port_isr, port);
+	bfa_ioc_hbfail_init(&port->hbfail, bfa_port_hbfail, port);
+	bfa_ioc_hbfail_register(port->ioc, &port->hbfail);
+
+	bfa_trc(port, 0);
+}
+
+/**
+ * bfa_port_detach()
+ *
+ *
+ * @param[in] port - Pointer to the Port module data structure
+ *
+ * @return void
+ */
+void
+bfa_port_detach(struct bfa_port_s *port)
+{
+	bfa_trc(port, 0);
+}
diff -urpN orig/drivers/scsi/bfa/bfa_port_priv.h patch/drivers/scsi/bfa/bfa_port_priv.h
--- orig/drivers/scsi/bfa/bfa_port_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_port_priv.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,90 @@
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
+#ifndef __BFA_PORT_PRIV_H__
+#define __BFA_PORT_PRIV_H__
+
+#include <defs/bfa_defs_pport.h>
+#include <bfi/bfi_pport.h>
+#include "bfa_intr_priv.h"
+
+/**
+ * BFA physical port data structure
+ */
+struct bfa_pport_s {
+	struct bfa_s 		*bfa;	/*  parent BFA instance */
+	bfa_sm_t		sm;	/*  port state machine */
+	wwn_t			nwwn;	/*  node wwn of physical port */
+	wwn_t			pwwn;	/*  port wwn of physical oprt */
+	enum bfa_pport_speed speed_sup;
+					/*  supported speeds */
+	enum bfa_pport_speed speed;	/*  current speed */
+	enum bfa_pport_topology topology;	/*  current topology */
+	u8			myalpa;	/*  my ALPA in LOOP topology */
+	u8			rsvd[3];
+	struct bfa_pport_cfg_s	cfg;	/*  current port configuration */
+	struct bfa_qos_attr_s  qos_attr;   /* QoS Attributes */
+	struct bfa_qos_vc_attr_s qos_vc_attr;  /*  VC info from ELP */
+	struct bfa_reqq_wait_s	reqq_wait;
+					/*  to wait for room in reqq */
+	struct bfa_reqq_wait_s	svcreq_wait;
+					/*  to wait for room in reqq */
+	struct bfa_reqq_wait_s	stats_reqq_wait;
+					/*  to wait for room in reqq (stats) */
+	void			*event_cbarg;
+	void			(*event_cbfn) (void *cbarg,
+						bfa_pport_event_t event);
+	union {
+		union bfi_pport_i2h_msg_u i2hmsg;
+	} event_arg;
+	void			*bfad;	/*  BFA driver handle */
+	struct bfa_cb_qe_s		hcb_qe;	/*  BFA callback queue elem */
+	enum bfa_pport_linkstate	hcb_event;
+					/*  link event for callback */
+	u32		msgtag;	/*  fimrware msg tag for reply */
+	u8			*stats_kva;
+	u64		stats_pa;
+	union bfa_pport_stats_u *stats;	/*  pport stats */
+	u32		mypid : 24;
+	u32		rsvd_b : 8;
+	struct bfa_timer_s 	timer;	/*  timer */
+	union bfa_pport_stats_u 	*stats_ret;
+					/*  driver stats location */
+	bfa_status_t		stats_status;
+					/*  stats/statsclr status */
+	bfa_boolean_t   	stats_busy;
+					/*  outstanding stats/statsclr */
+	bfa_boolean_t   	stats_qfull;
+	bfa_boolean_t   	diag_busy;
+					/*  diag busy status */
+	bfa_boolean_t   	beacon;
+					/*  port beacon status */
+	bfa_boolean_t   	link_e2e_beacon;
+					/*  link beacon status */
+	bfa_cb_pport_t		stats_cbfn;
+					/*  driver callback function */
+	void			*stats_cbarg;
+					/* *!< user callback arg */
+};
+
+#define BFA_PORT_MOD(__bfa)	(&(__bfa)->modules.pport)
+
+/*
+ * public functions
+ */
+void	bfa_pport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
+#endif /* __BFA_PORT_PRIV_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_priv.h patch/drivers/scsi/bfa/bfa_priv.h
--- orig/drivers/scsi/bfa/bfa_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_priv.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,113 @@
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
+#ifndef __BFA_PRIV_H__
+#define __BFA_PRIV_H__
+
+#include "bfa_iocfc.h"
+#include "bfa_intr_priv.h"
+#include "bfa_trcmod_priv.h"
+#include "bfa_modules_priv.h"
+#include "bfa_fwimg_priv.h"
+#include <cs/bfa_log.h>
+#include <bfa_timer.h>
+
+/**
+ * Macro to define a new BFA module
+ */
+#define BFA_MODULE(__mod) 						\
+	static void bfa_ ## __mod ## _meminfo(				\
+			struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len,	\
+			u32 *dm_len);      \
+	static void bfa_ ## __mod ## _attach(struct bfa_s *bfa,		\
+			void *bfad, struct bfa_iocfc_cfg_s *cfg, 	\
+			struct bfa_meminfo_s *meminfo,			\
+			struct bfa_pcidev_s *pcidev);      \
+	static void bfa_ ## __mod ## _initdone(struct bfa_s *bfa);      \
+	static void bfa_ ## __mod ## _detach(struct bfa_s *bfa);      \
+	static void bfa_ ## __mod ## _start(struct bfa_s *bfa);      \
+	static void bfa_ ## __mod ## _stop(struct bfa_s *bfa);      \
+	static void bfa_ ## __mod ## _iocdisable(struct bfa_s *bfa);      \
+									\
+	extern struct bfa_module_s hal_mod_ ## __mod;			\
+	struct bfa_module_s hal_mod_ ## __mod = {			\
+		bfa_ ## __mod ## _meminfo,				\
+		bfa_ ## __mod ## _attach,				\
+		bfa_ ## __mod ## _initdone,				\
+		bfa_ ## __mod ## _detach,				\
+		bfa_ ## __mod ## _start,				\
+		bfa_ ## __mod ## _stop,					\
+		bfa_ ## __mod ## _iocdisable,				\
+	}
+
+#define BFA_CACHELINE_SZ	(256)
+
+/**
+ * Structure used to interact between different BFA sub modules
+ *
+ * Each sub module needs to implement only the entry points relevant to it (and
+ * can leave entry points as NULL)
+ */
+struct bfa_module_s {
+	void (*meminfo) (struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
+			u32 *dm_len);
+	void (*attach) (struct bfa_s *bfa, void *bfad,
+			struct bfa_iocfc_cfg_s *cfg,
+			struct bfa_meminfo_s *meminfo,
+			struct bfa_pcidev_s *pcidev);
+	void (*initdone) (struct bfa_s *bfa);
+	void (*detach) (struct bfa_s *bfa);
+	void (*start) (struct bfa_s *bfa);
+	void (*stop) (struct bfa_s *bfa);
+	void (*iocdisable) (struct bfa_s *bfa);
+};
+
+extern struct bfa_module_s *hal_mods[];
+
+struct bfa_s {
+	void			*bfad;		/*  BFA driver instance    */
+	struct bfa_aen_s	*aen;		/*  AEN module		    */
+	struct bfa_plog_s	*plog;		/*  portlog buffer	    */
+	struct bfa_log_mod_s	*logm;		/*  driver logging modulen */
+	struct bfa_trc_mod_s	*trcmod;	/*  driver tracing	    */
+	struct bfa_ioc_s	ioc;		/*  IOC module		    */
+	struct bfa_iocfc_s	iocfc;		/*  IOCFC module	    */
+	struct bfa_timer_mod_s	timer_mod;	/*  timer module	    */
+	struct bfa_modules_s	modules;	/*  BFA modules	    */
+	struct list_head	comp_q;		/*  pending completions    */
+	bfa_boolean_t		rme_process;	/*  RME processing enabled */
+	struct list_head		reqq_waitq[BFI_IOC_MAX_CQS];
+	bfa_boolean_t		fcs;		/*  FCS is attached to BFA */
+	struct bfa_msix_s	msix;
+};
+
+extern bfa_isr_func_t bfa_isrs[BFI_MC_MAX];
+extern bfa_ioc_mbox_mcfunc_t  bfa_mbox_isrs[];
+extern bfa_boolean_t bfa_auto_recover;
+extern struct bfa_module_s hal_mod_flash;
+extern struct bfa_module_s hal_mod_fcdiag;
+extern struct bfa_module_s hal_mod_sgpg;
+extern struct bfa_module_s hal_mod_pport;
+extern struct bfa_module_s hal_mod_fcxp;
+extern struct bfa_module_s hal_mod_lps;
+extern struct bfa_module_s hal_mod_uf;
+extern struct bfa_module_s hal_mod_rport;
+extern struct bfa_module_s hal_mod_fcpim;
+extern struct bfa_module_s hal_mod_pbind;
+
+#endif /* __BFA_PRIV_H__ */
+
diff -urpN orig/drivers/scsi/bfa/bfa_rport.c patch/drivers/scsi/bfa/bfa_rport.c
--- orig/drivers/scsi/bfa/bfa_rport.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_rport.c	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,911 @@
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
+#include <bfa.h>
+#include <bfa_svc.h>
+#include <cs/bfa_debug.h>
+#include <bfi/bfi_rport.h>
+#include "bfa_intr_priv.h"
+
+BFA_TRC_FILE(HAL, RPORT);
+BFA_MODULE(rport);
+
+#define bfa_rport_offline_cb(__rp) do {				\
+	if ((__rp)->bfa->fcs)						\
+		bfa_cb_rport_offline((__rp)->rport_drv);      \
+	else {								\
+		bfa_cb_queue((__rp)->bfa, &(__rp)->hcb_qe,		\
+				__bfa_cb_rport_offline, (__rp));      \
+	}								\
+} while (0)
+
+#define bfa_rport_online_cb(__rp) do {				\
+	if ((__rp)->bfa->fcs)						\
+		bfa_cb_rport_online((__rp)->rport_drv);      \
+	else {								\
+		bfa_cb_queue((__rp)->bfa, &(__rp)->hcb_qe,		\
+				  __bfa_cb_rport_online, (__rp));      \
+		}							\
+} while (0)
+
+/*
+ * forward declarations
+ */
+static struct bfa_rport_s *bfa_rport_alloc(struct bfa_rport_mod_s *rp_mod);
+static void bfa_rport_free(struct bfa_rport_s *rport);
+static bfa_boolean_t bfa_rport_send_fwcreate(struct bfa_rport_s *rp);
+static bfa_boolean_t bfa_rport_send_fwdelete(struct bfa_rport_s *rp);
+static bfa_boolean_t bfa_rport_send_fwspeed(struct bfa_rport_s *rp);
+static void __bfa_cb_rport_online(void *cbarg, bfa_boolean_t complete);
+static void __bfa_cb_rport_offline(void *cbarg, bfa_boolean_t complete);
+
+/**
+ *  bfa_rport_sm BFA rport state machine
+ */
+
+
+enum bfa_rport_event {
+	BFA_RPORT_SM_CREATE	= 1,	/*  rport create event		*/
+	BFA_RPORT_SM_DELETE	= 2,	/*  deleting an existing rport */
+	BFA_RPORT_SM_ONLINE	= 3,	/*  rport is online		*/
+	BFA_RPORT_SM_OFFLINE	= 4,	/*  rport is offline		*/
+	BFA_RPORT_SM_FWRSP	= 5,	/*  firmware response		*/
+	BFA_RPORT_SM_HWFAIL	= 6,	/*  IOC h/w failure		*/
+	BFA_RPORT_SM_QOS_SCN	= 7,	/*  QoS SCN from firmware	*/
+	BFA_RPORT_SM_SET_SPEED	= 8,	/*  Set Rport Speed 		*/
+	BFA_RPORT_SM_QRESUME	= 9,	/*  space in requeue queue	*/
+};
+
+static void	bfa_rport_sm_uninit(struct bfa_rport_s *rp,
+					enum bfa_rport_event event);
+static void	bfa_rport_sm_created(struct bfa_rport_s *rp,
+					 enum bfa_rport_event event);
+static void	bfa_rport_sm_fwcreate(struct bfa_rport_s *rp,
+					  enum bfa_rport_event event);
+static void	bfa_rport_sm_online(struct bfa_rport_s *rp,
+					enum bfa_rport_event event);
+static void	bfa_rport_sm_fwdelete(struct bfa_rport_s *rp,
+					  enum bfa_rport_event event);
+static void	bfa_rport_sm_offline(struct bfa_rport_s *rp,
+					 enum bfa_rport_event event);
+static void	bfa_rport_sm_deleting(struct bfa_rport_s *rp,
+					  enum bfa_rport_event event);
+static void	bfa_rport_sm_offline_pending(struct bfa_rport_s *rp,
+					  enum bfa_rport_event event);
+static void	bfa_rport_sm_delete_pending(struct bfa_rport_s *rp,
+					  enum bfa_rport_event event);
+static void	bfa_rport_sm_iocdisable(struct bfa_rport_s *rp,
+					    enum bfa_rport_event event);
+static void	bfa_rport_sm_fwcreate_qfull(struct bfa_rport_s *rp,
+					  enum bfa_rport_event event);
+static void	bfa_rport_sm_fwdelete_qfull(struct bfa_rport_s *rp,
+					  enum bfa_rport_event event);
+static void	bfa_rport_sm_deleting_qfull(struct bfa_rport_s *rp,
+					  enum bfa_rport_event event);
+
+/**
+ * Beginning state, only online event expected.
+ */
+static void
+bfa_rport_sm_uninit(struct bfa_rport_s *rp, enum bfa_rport_event event)
+{
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+	case BFA_RPORT_SM_CREATE:
+		bfa_stats(rp, sm_un_cr);
+		bfa_sm_set_state(rp, bfa_rport_sm_created);
+		break;
+
+	default:
+		bfa_stats(rp, sm_un_unexp);
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_rport_sm_created(struct bfa_rport_s *rp, enum bfa_rport_event event)
+{
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+	case BFA_RPORT_SM_ONLINE:
+		bfa_stats(rp, sm_cr_on);
+		if (bfa_rport_send_fwcreate(rp))
+			bfa_sm_set_state(rp, bfa_rport_sm_fwcreate);
+		else
+			bfa_sm_set_state(rp, bfa_rport_sm_fwcreate_qfull);
+		break;
+
+	case BFA_RPORT_SM_DELETE:
+		bfa_stats(rp, sm_cr_del);
+		bfa_sm_set_state(rp, bfa_rport_sm_uninit);
+		bfa_rport_free(rp);
+		break;
+
+	case BFA_RPORT_SM_HWFAIL:
+		bfa_stats(rp, sm_cr_hwf);
+		bfa_sm_set_state(rp, bfa_rport_sm_iocdisable);
+		break;
+
+	default:
+		bfa_stats(rp, sm_cr_unexp);
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Waiting for rport create response from firmware.
+ */
+static void
+bfa_rport_sm_fwcreate(struct bfa_rport_s *rp, enum bfa_rport_event event)
+{
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+	case BFA_RPORT_SM_FWRSP:
+		bfa_stats(rp, sm_fwc_rsp);
+		bfa_sm_set_state(rp, bfa_rport_sm_online);
+		bfa_rport_online_cb(rp);
+		break;
+
+	case BFA_RPORT_SM_DELETE:
+		bfa_stats(rp, sm_fwc_del);
+		bfa_sm_set_state(rp, bfa_rport_sm_delete_pending);
+		break;
+
+	case BFA_RPORT_SM_OFFLINE:
+		bfa_stats(rp, sm_fwc_off);
+		bfa_sm_set_state(rp, bfa_rport_sm_offline_pending);
+		break;
+
+	case BFA_RPORT_SM_HWFAIL:
+		bfa_stats(rp, sm_fwc_hwf);
+		bfa_sm_set_state(rp, bfa_rport_sm_iocdisable);
+		break;
+
+	default:
+		bfa_stats(rp, sm_fwc_unexp);
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Request queue is full, awaiting queue resume to send create request.
+ */
+static void
+bfa_rport_sm_fwcreate_qfull(struct bfa_rport_s *rp, enum bfa_rport_event event)
+{
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+	case BFA_RPORT_SM_QRESUME:
+		bfa_sm_set_state(rp, bfa_rport_sm_fwcreate);
+		bfa_rport_send_fwcreate(rp);
+		break;
+
+	case BFA_RPORT_SM_DELETE:
+		bfa_stats(rp, sm_fwc_del);
+		bfa_sm_set_state(rp, bfa_rport_sm_uninit);
+		bfa_reqq_wcancel(&rp->reqq_wait);
+		bfa_rport_free(rp);
+		break;
+
+	case BFA_RPORT_SM_OFFLINE:
+		bfa_stats(rp, sm_fwc_off);
+		bfa_sm_set_state(rp, bfa_rport_sm_offline);
+		bfa_reqq_wcancel(&rp->reqq_wait);
+		bfa_rport_offline_cb(rp);
+		break;
+
+	case BFA_RPORT_SM_HWFAIL:
+		bfa_stats(rp, sm_fwc_hwf);
+		bfa_sm_set_state(rp, bfa_rport_sm_iocdisable);
+		bfa_reqq_wcancel(&rp->reqq_wait);
+		break;
+
+	default:
+		bfa_stats(rp, sm_fwc_unexp);
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Online state - normal parking state.
+ */
+static void
+bfa_rport_sm_online(struct bfa_rport_s *rp, enum bfa_rport_event event)
+{
+	struct bfi_rport_qos_scn_s *qos_scn;
+
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+	case BFA_RPORT_SM_OFFLINE:
+		bfa_stats(rp, sm_on_off);
+		if (bfa_rport_send_fwdelete(rp))
+			bfa_sm_set_state(rp, bfa_rport_sm_fwdelete);
+		else
+			bfa_sm_set_state(rp, bfa_rport_sm_fwdelete_qfull);
+		break;
+
+	case BFA_RPORT_SM_DELETE:
+		bfa_stats(rp, sm_on_del);
+		if (bfa_rport_send_fwdelete(rp))
+			bfa_sm_set_state(rp, bfa_rport_sm_deleting);
+		else
+			bfa_sm_set_state(rp, bfa_rport_sm_deleting_qfull);
+		break;
+
+	case BFA_RPORT_SM_HWFAIL:
+		bfa_stats(rp, sm_on_hwf);
+		bfa_sm_set_state(rp, bfa_rport_sm_iocdisable);
+		break;
+
+	case BFA_RPORT_SM_SET_SPEED:
+		bfa_rport_send_fwspeed(rp);
+		break;
+
+	case BFA_RPORT_SM_QOS_SCN:
+		qos_scn = (struct bfi_rport_qos_scn_s *) rp->event_arg.fw_msg;
+		rp->qos_attr = qos_scn->new_qos_attr;
+		bfa_trc(rp->bfa, qos_scn->old_qos_attr.qos_flow_id);
+		bfa_trc(rp->bfa, qos_scn->new_qos_attr.qos_flow_id);
+		bfa_trc(rp->bfa, qos_scn->old_qos_attr.qos_priority);
+		bfa_trc(rp->bfa, qos_scn->new_qos_attr.qos_priority);
+
+		qos_scn->old_qos_attr.qos_flow_id  =
+			bfa_os_ntohl(qos_scn->old_qos_attr.qos_flow_id);
+		qos_scn->new_qos_attr.qos_flow_id  =
+			bfa_os_ntohl(qos_scn->new_qos_attr.qos_flow_id);
+		qos_scn->old_qos_attr.qos_priority =
+			bfa_os_ntohl(qos_scn->old_qos_attr.qos_priority);
+		qos_scn->new_qos_attr.qos_priority =
+			bfa_os_ntohl(qos_scn->new_qos_attr.qos_priority);
+
+		if (qos_scn->old_qos_attr.qos_flow_id !=
+			qos_scn->new_qos_attr.qos_flow_id)
+			bfa_cb_rport_qos_scn_flowid(rp->rport_drv,
+						    qos_scn->old_qos_attr,
+						    qos_scn->new_qos_attr);
+		if (qos_scn->old_qos_attr.qos_priority !=
+			qos_scn->new_qos_attr.qos_priority)
+			bfa_cb_rport_qos_scn_prio(rp->rport_drv,
+						  qos_scn->old_qos_attr,
+						  qos_scn->new_qos_attr);
+		break;
+
+	default:
+		bfa_stats(rp, sm_on_unexp);
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Firmware rport is being deleted - awaiting f/w response.
+ */
+static void
+bfa_rport_sm_fwdelete(struct bfa_rport_s *rp, enum bfa_rport_event event)
+{
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+	case BFA_RPORT_SM_FWRSP:
+		bfa_stats(rp, sm_fwd_rsp);
+		bfa_sm_set_state(rp, bfa_rport_sm_offline);
+		bfa_rport_offline_cb(rp);
+		break;
+
+	case BFA_RPORT_SM_DELETE:
+		bfa_stats(rp, sm_fwd_del);
+		bfa_sm_set_state(rp, bfa_rport_sm_deleting);
+		break;
+
+	case BFA_RPORT_SM_HWFAIL:
+		bfa_stats(rp, sm_fwd_hwf);
+		bfa_sm_set_state(rp, bfa_rport_sm_iocdisable);
+		bfa_rport_offline_cb(rp);
+		break;
+
+	default:
+		bfa_stats(rp, sm_fwd_unexp);
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_rport_sm_fwdelete_qfull(struct bfa_rport_s *rp, enum bfa_rport_event event)
+{
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+	case BFA_RPORT_SM_QRESUME:
+		bfa_sm_set_state(rp, bfa_rport_sm_fwdelete);
+		bfa_rport_send_fwdelete(rp);
+		break;
+
+	case BFA_RPORT_SM_DELETE:
+		bfa_stats(rp, sm_fwd_del);
+		bfa_sm_set_state(rp, bfa_rport_sm_deleting_qfull);
+		break;
+
+	case BFA_RPORT_SM_HWFAIL:
+		bfa_stats(rp, sm_fwd_hwf);
+		bfa_sm_set_state(rp, bfa_rport_sm_iocdisable);
+		bfa_reqq_wcancel(&rp->reqq_wait);
+		bfa_rport_offline_cb(rp);
+		break;
+
+	default:
+		bfa_stats(rp, sm_fwd_unexp);
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Offline state.
+ */
+static void
+bfa_rport_sm_offline(struct bfa_rport_s *rp, enum bfa_rport_event event)
+{
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+	case BFA_RPORT_SM_DELETE:
+		bfa_stats(rp, sm_off_del);
+		bfa_sm_set_state(rp, bfa_rport_sm_uninit);
+		bfa_rport_free(rp);
+		break;
+
+	case BFA_RPORT_SM_ONLINE:
+		bfa_stats(rp, sm_off_on);
+		if (bfa_rport_send_fwcreate(rp))
+			bfa_sm_set_state(rp, bfa_rport_sm_fwcreate);
+		else
+			bfa_sm_set_state(rp, bfa_rport_sm_fwcreate_qfull);
+		break;
+
+	case BFA_RPORT_SM_HWFAIL:
+		bfa_stats(rp, sm_off_hwf);
+		bfa_sm_set_state(rp, bfa_rport_sm_iocdisable);
+		break;
+
+	default:
+		bfa_stats(rp, sm_off_unexp);
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Rport is deleted, waiting for firmware response to delete.
+ */
+static void
+bfa_rport_sm_deleting(struct bfa_rport_s *rp, enum bfa_rport_event event)
+{
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+	case BFA_RPORT_SM_FWRSP:
+		bfa_stats(rp, sm_del_fwrsp);
+		bfa_sm_set_state(rp, bfa_rport_sm_uninit);
+		bfa_rport_free(rp);
+		break;
+
+	case BFA_RPORT_SM_HWFAIL:
+		bfa_stats(rp, sm_del_hwf);
+		bfa_sm_set_state(rp, bfa_rport_sm_uninit);
+		bfa_rport_free(rp);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_rport_sm_deleting_qfull(struct bfa_rport_s *rp, enum bfa_rport_event event)
+{
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+	case BFA_RPORT_SM_QRESUME:
+		bfa_stats(rp, sm_del_fwrsp);
+		bfa_sm_set_state(rp, bfa_rport_sm_deleting);
+		bfa_rport_send_fwdelete(rp);
+		break;
+
+	case BFA_RPORT_SM_HWFAIL:
+		bfa_stats(rp, sm_del_hwf);
+		bfa_sm_set_state(rp, bfa_rport_sm_uninit);
+		bfa_reqq_wcancel(&rp->reqq_wait);
+		bfa_rport_free(rp);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Waiting for rport create response from firmware. A delete is pending.
+ */
+static void
+bfa_rport_sm_delete_pending(struct bfa_rport_s *rp,
+				enum bfa_rport_event event)
+{
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+	case BFA_RPORT_SM_FWRSP:
+		bfa_stats(rp, sm_delp_fwrsp);
+		if (bfa_rport_send_fwdelete(rp))
+			bfa_sm_set_state(rp, bfa_rport_sm_deleting);
+		else
+			bfa_sm_set_state(rp, bfa_rport_sm_deleting_qfull);
+		break;
+
+	case BFA_RPORT_SM_HWFAIL:
+		bfa_stats(rp, sm_delp_hwf);
+		bfa_sm_set_state(rp, bfa_rport_sm_uninit);
+		bfa_rport_free(rp);
+		break;
+
+	default:
+		bfa_stats(rp, sm_delp_unexp);
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Waiting for rport create response from firmware. Rport offline is pending.
+ */
+static void
+bfa_rport_sm_offline_pending(struct bfa_rport_s *rp,
+				 enum bfa_rport_event event)
+{
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+	case BFA_RPORT_SM_FWRSP:
+		bfa_stats(rp, sm_offp_fwrsp);
+		if (bfa_rport_send_fwdelete(rp))
+			bfa_sm_set_state(rp, bfa_rport_sm_fwdelete);
+		else
+			bfa_sm_set_state(rp, bfa_rport_sm_fwdelete_qfull);
+		break;
+
+	case BFA_RPORT_SM_DELETE:
+		bfa_stats(rp, sm_offp_del);
+		bfa_sm_set_state(rp, bfa_rport_sm_delete_pending);
+		break;
+
+	case BFA_RPORT_SM_HWFAIL:
+		bfa_stats(rp, sm_offp_hwf);
+		bfa_sm_set_state(rp, bfa_rport_sm_iocdisable);
+		break;
+
+	default:
+		bfa_stats(rp, sm_offp_unexp);
+		bfa_assert(0);
+	}
+}
+
+/**
+ * IOC h/w failed.
+ */
+static void
+bfa_rport_sm_iocdisable(struct bfa_rport_s *rp, enum bfa_rport_event event)
+{
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+	case BFA_RPORT_SM_OFFLINE:
+		bfa_stats(rp, sm_iocd_off);
+		bfa_rport_offline_cb(rp);
+		break;
+
+	case BFA_RPORT_SM_DELETE:
+		bfa_stats(rp, sm_iocd_del);
+		bfa_sm_set_state(rp, bfa_rport_sm_uninit);
+		bfa_rport_free(rp);
+		break;
+
+	case BFA_RPORT_SM_ONLINE:
+		bfa_stats(rp, sm_iocd_on);
+		if (bfa_rport_send_fwcreate(rp))
+			bfa_sm_set_state(rp, bfa_rport_sm_fwcreate);
+		else
+			bfa_sm_set_state(rp, bfa_rport_sm_fwcreate_qfull);
+		break;
+
+	case BFA_RPORT_SM_HWFAIL:
+		break;
+
+	default:
+		bfa_stats(rp, sm_iocd_unexp);
+		bfa_assert(0);
+	}
+}
+
+
+
+/**
+ *  bfa_rport_private BFA rport private functions
+ */
+
+static void
+__bfa_cb_rport_online(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_rport_s *rp = cbarg;
+
+	if (complete)
+		bfa_cb_rport_online(rp->rport_drv);
+}
+
+static void
+__bfa_cb_rport_offline(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_rport_s *rp = cbarg;
+
+	if (complete)
+		bfa_cb_rport_offline(rp->rport_drv);
+}
+
+static void
+bfa_rport_qresume(void *cbarg)
+{
+	struct bfa_rport_s	*rp = cbarg;
+
+	bfa_sm_send_event(rp, BFA_RPORT_SM_QRESUME);
+}
+
+static void
+bfa_rport_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
+		u32 *dm_len)
+{
+	if (cfg->fwcfg.num_rports < BFA_RPORT_MIN)
+		cfg->fwcfg.num_rports = BFA_RPORT_MIN;
+
+	*km_len += cfg->fwcfg.num_rports * sizeof(struct bfa_rport_s);
+}
+
+static void
+bfa_rport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+		     struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
+{
+	struct bfa_rport_mod_s *mod = BFA_RPORT_MOD(bfa);
+	struct bfa_rport_s *rp;
+	u16        i;
+
+	INIT_LIST_HEAD(&mod->rp_free_q);
+	INIT_LIST_HEAD(&mod->rp_active_q);
+
+	rp = (struct bfa_rport_s *) bfa_meminfo_kva(meminfo);
+	mod->rps_list = rp;
+	mod->num_rports = cfg->fwcfg.num_rports;
+
+	bfa_assert(mod->num_rports
+		   && !(mod->num_rports & (mod->num_rports - 1)));
+
+	for (i = 0; i < mod->num_rports; i++, rp++) {
+		bfa_os_memset(rp, 0, sizeof(struct bfa_rport_s));
+		rp->bfa = bfa;
+		rp->rport_tag = i;
+		bfa_sm_set_state(rp, bfa_rport_sm_uninit);
+
+		/**
+		 *  - is unused
+		 */
+		if (i)
+			list_add_tail(&rp->qe, &mod->rp_free_q);
+
+		bfa_reqq_winit(&rp->reqq_wait, bfa_rport_qresume, rp);
+	}
+
+	/**
+	 * consume memory
+	 */
+	bfa_meminfo_kva(meminfo) = (u8 *) rp;
+}
+
+static void
+bfa_rport_initdone(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_rport_detach(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_rport_start(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_rport_stop(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_rport_iocdisable(struct bfa_s *bfa)
+{
+	struct bfa_rport_mod_s *mod = BFA_RPORT_MOD(bfa);
+	struct bfa_rport_s *rport;
+	struct list_head        *qe, *qen;
+
+	list_for_each_safe(qe, qen, &mod->rp_active_q) {
+		rport = (struct bfa_rport_s *) qe;
+		bfa_sm_send_event(rport, BFA_RPORT_SM_HWFAIL);
+	}
+}
+
+static struct bfa_rport_s *
+bfa_rport_alloc(struct bfa_rport_mod_s *mod)
+{
+	struct bfa_rport_s *rport;
+
+	bfa_q_deq(&mod->rp_free_q, &rport);
+	if (rport)
+		list_add_tail(&rport->qe, &mod->rp_active_q);
+
+	return (rport);
+}
+
+static void
+bfa_rport_free(struct bfa_rport_s *rport)
+{
+	struct bfa_rport_mod_s *mod = BFA_RPORT_MOD(rport->bfa);
+
+	bfa_assert(bfa_q_is_on_q(&mod->rp_active_q, rport));
+	list_del(&rport->qe);
+	list_add_tail(&rport->qe, &mod->rp_free_q);
+}
+
+static bfa_boolean_t
+bfa_rport_send_fwcreate(struct bfa_rport_s *rp)
+{
+	struct bfi_rport_create_req_s *m;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(rp->bfa, BFA_REQQ_RPORT);
+	if (!m) {
+		bfa_reqq_wait(rp->bfa, BFA_REQQ_RPORT, &rp->reqq_wait);
+		return BFA_FALSE;
+	}
+
+	bfi_h2i_set(m->mh, BFI_MC_RPORT, BFI_RPORT_H2I_CREATE_REQ,
+			bfa_lpuid(rp->bfa));
+	m->bfa_handle = rp->rport_tag;
+	m->max_frmsz = bfa_os_htons(rp->rport_info.max_frmsz);
+	m->pid = rp->rport_info.pid;
+	m->lp_tag = rp->rport_info.lp_tag;
+	m->local_pid = rp->rport_info.local_pid;
+	m->fc_class = rp->rport_info.fc_class;
+	m->vf_en = rp->rport_info.vf_en;
+	m->vf_id = rp->rport_info.vf_id;
+	m->cisc = rp->rport_info.cisc;
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(rp->bfa, BFA_REQQ_RPORT);
+	return BFA_TRUE;
+}
+
+static bfa_boolean_t
+bfa_rport_send_fwdelete(struct bfa_rport_s *rp)
+{
+	struct bfi_rport_delete_req_s *m;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(rp->bfa, BFA_REQQ_RPORT);
+	if (!m) {
+		bfa_reqq_wait(rp->bfa, BFA_REQQ_RPORT, &rp->reqq_wait);
+		return BFA_FALSE;
+	}
+
+	bfi_h2i_set(m->mh, BFI_MC_RPORT, BFI_RPORT_H2I_DELETE_REQ,
+			bfa_lpuid(rp->bfa));
+	m->fw_handle = rp->fw_handle;
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(rp->bfa, BFA_REQQ_RPORT);
+	return BFA_TRUE;
+}
+
+static bfa_boolean_t
+bfa_rport_send_fwspeed(struct bfa_rport_s *rp)
+{
+	struct bfa_rport_speed_req_s *m;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(rp->bfa, BFA_REQQ_RPORT);
+	if (!m) {
+		bfa_trc(rp->bfa, rp->rport_info.speed);
+		return BFA_FALSE;
+	}
+
+	bfi_h2i_set(m->mh, BFI_MC_RPORT, BFI_RPORT_H2I_SET_SPEED_REQ,
+			bfa_lpuid(rp->bfa));
+	m->fw_handle = rp->fw_handle;
+	m->speed = (u8)rp->rport_info.speed;
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(rp->bfa, BFA_REQQ_RPORT);
+	return BFA_TRUE;
+}
+
+
+
+/**
+ *  bfa_rport_public
+ */
+
+/**
+ * 		Rport interrupt processing.
+ */
+void
+bfa_rport_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
+{
+	union bfi_rport_i2h_msg_u msg;
+	struct bfa_rport_s *rp;
+
+	bfa_trc(bfa, m->mhdr.msg_id);
+
+	msg.msg = m;
+
+	switch (m->mhdr.msg_id) {
+	case BFI_RPORT_I2H_CREATE_RSP:
+		rp = BFA_RPORT_FROM_TAG(bfa, msg.create_rsp->bfa_handle);
+		rp->fw_handle = msg.create_rsp->fw_handle;
+		rp->qos_attr = msg.create_rsp->qos_attr;
+		bfa_assert(msg.create_rsp->status == BFA_STATUS_OK);
+		bfa_sm_send_event(rp, BFA_RPORT_SM_FWRSP);
+		break;
+
+	case BFI_RPORT_I2H_DELETE_RSP:
+		rp = BFA_RPORT_FROM_TAG(bfa, msg.delete_rsp->bfa_handle);
+		bfa_assert(msg.delete_rsp->status == BFA_STATUS_OK);
+		bfa_sm_send_event(rp, BFA_RPORT_SM_FWRSP);
+		break;
+
+	case BFI_RPORT_I2H_QOS_SCN:
+		rp = BFA_RPORT_FROM_TAG(bfa, msg.qos_scn_evt->bfa_handle);
+		rp->event_arg.fw_msg = msg.qos_scn_evt;
+		bfa_sm_send_event(rp, BFA_RPORT_SM_QOS_SCN);
+		break;
+
+	default:
+		bfa_trc(bfa, m->mhdr.msg_id);
+		bfa_assert(0);
+	}
+}
+
+
+
+/**
+ *  bfa_rport_api
+ */
+
+struct bfa_rport_s *
+bfa_rport_create(struct bfa_s *bfa, void *rport_drv)
+{
+	struct bfa_rport_s *rp;
+
+	rp = bfa_rport_alloc(BFA_RPORT_MOD(bfa));
+
+	if (rp == NULL)
+		return (NULL);
+
+	rp->bfa = bfa;
+	rp->rport_drv = rport_drv;
+	bfa_rport_clear_stats(rp);
+
+	bfa_assert(bfa_sm_cmp_state(rp, bfa_rport_sm_uninit));
+	bfa_sm_send_event(rp, BFA_RPORT_SM_CREATE);
+
+	return (rp);
+}
+
+void
+bfa_rport_delete(struct bfa_rport_s *rport)
+{
+	bfa_sm_send_event(rport, BFA_RPORT_SM_DELETE);
+}
+
+void
+bfa_rport_online(struct bfa_rport_s *rport, struct bfa_rport_info_s *rport_info)
+{
+	bfa_assert(rport_info->max_frmsz != 0);
+
+	/**
+	 * Some JBODs are seen to be not setting PDU size correctly in PLOGI
+	 * responses. Default to minimum size.
+	 */
+	if (rport_info->max_frmsz == 0) {
+		bfa_trc(rport->bfa, rport->rport_tag);
+		rport_info->max_frmsz = FC_MIN_PDUSZ;
+	}
+
+	bfa_os_assign(rport->rport_info, *rport_info);
+	bfa_sm_send_event(rport, BFA_RPORT_SM_ONLINE);
+}
+
+void
+bfa_rport_offline(struct bfa_rport_s *rport)
+{
+	bfa_sm_send_event(rport, BFA_RPORT_SM_OFFLINE);
+}
+
+void
+bfa_rport_speed(struct bfa_rport_s *rport, enum bfa_pport_speed speed)
+{
+	bfa_assert(speed != 0);
+	bfa_assert(speed != BFA_PPORT_SPEED_AUTO);
+
+	rport->rport_info.speed = speed;
+	bfa_sm_send_event(rport, BFA_RPORT_SM_SET_SPEED);
+}
+
+void
+bfa_rport_get_stats(struct bfa_rport_s *rport,
+	struct bfa_rport_hal_stats_s *stats)
+{
+	*stats = rport->stats;
+}
+
+void
+bfa_rport_get_qos_attr(struct bfa_rport_s *rport,
+					struct bfa_rport_qos_attr_s *qos_attr)
+{
+	qos_attr->qos_priority  = bfa_os_ntohl(rport->qos_attr.qos_priority);
+	qos_attr->qos_flow_id  = bfa_os_ntohl(rport->qos_attr.qos_flow_id);
+
+}
+
+void
+bfa_rport_clear_stats(struct bfa_rport_s *rport)
+{
+	bfa_os_memset(&rport->stats, 0, sizeof(rport->stats));
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_rport_priv.h patch/drivers/scsi/bfa/bfa_rport_priv.h
--- orig/drivers/scsi/bfa/bfa_rport_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_rport_priv.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,45 @@
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
+#ifndef __BFA_RPORT_PRIV_H__
+#define __BFA_RPORT_PRIV_H__
+
+#include <bfa_svc.h>
+
+#define BFA_RPORT_MIN	4
+
+struct bfa_rport_mod_s {
+	struct bfa_rport_s *rps_list;	/*  list of rports	*/
+	struct list_head 	rp_free_q;	/*  free bfa_rports	*/
+	struct list_head 	rp_active_q;	/*  free bfa_rports 	*/
+	u16	num_rports;	/*  number of rports	*/
+};
+
+#define BFA_RPORT_MOD(__bfa)	(&(__bfa)->modules.rport_mod)
+
+/**
+ * Convert rport tag to RPORT
+ */
+#define BFA_RPORT_FROM_TAG(__bfa, _tag)				\
+	(BFA_RPORT_MOD(__bfa)->rps_list +				\
+	 ((_tag) & (BFA_RPORT_MOD(__bfa)->num_rports - 1)))
+
+/*
+ * external functions
+ */
+void	bfa_rport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
+#endif /* __BFA_RPORT_PRIV_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_sgpg.c patch/drivers/scsi/bfa/bfa_sgpg.c
--- orig/drivers/scsi/bfa/bfa_sgpg.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_sgpg.c	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,231 @@
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
+#include <bfa.h>
+
+BFA_TRC_FILE(HAL, SGPG);
+BFA_MODULE(sgpg);
+
+/**
+ *  bfa_sgpg_mod BFA SGPG Mode module
+ */
+
+/**
+ * Compute and return memory needed by FCP(im) module.
+ */
+static void
+bfa_sgpg_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
+		u32 *dm_len)
+{
+	if (cfg->drvcfg.num_sgpgs < BFA_SGPG_MIN)
+		cfg->drvcfg.num_sgpgs = BFA_SGPG_MIN;
+
+	*km_len += (cfg->drvcfg.num_sgpgs + 1) * sizeof(struct bfa_sgpg_s);
+	*dm_len += (cfg->drvcfg.num_sgpgs + 1) * sizeof(struct bfi_sgpg_s);
+}
+
+
+static void
+bfa_sgpg_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+		    struct bfa_meminfo_s *minfo, struct bfa_pcidev_s *pcidev)
+{
+	struct bfa_sgpg_mod_s	*mod = BFA_SGPG_MOD(bfa);
+	int				i;
+	struct bfa_sgpg_s		*hsgpg;
+	struct bfi_sgpg_s 	*sgpg;
+	u64		align_len;
+
+	union {
+		u64        pa;
+		union bfi_addr_u      addr;
+	} sgpg_pa;
+
+	INIT_LIST_HEAD(&mod->sgpg_q);
+	INIT_LIST_HEAD(&mod->sgpg_wait_q);
+
+	bfa_trc(bfa, cfg->drvcfg.num_sgpgs);
+
+	mod->num_sgpgs = cfg->drvcfg.num_sgpgs;
+	mod->sgpg_arr_pa = bfa_meminfo_dma_phys(minfo);
+	align_len = (BFA_SGPG_ROUNDUP(mod->sgpg_arr_pa) - mod->sgpg_arr_pa);
+	mod->sgpg_arr_pa += align_len;
+	mod->hsgpg_arr = (struct bfa_sgpg_s *) (bfa_meminfo_kva(minfo) +
+						align_len);
+	mod->sgpg_arr = (struct bfi_sgpg_s *) (bfa_meminfo_dma_virt(minfo) +
+						align_len);
+
+	hsgpg = mod->hsgpg_arr;
+	sgpg = mod->sgpg_arr;
+	sgpg_pa.pa = mod->sgpg_arr_pa;
+	mod->free_sgpgs = mod->num_sgpgs;
+
+	bfa_assert(!(sgpg_pa.pa & (sizeof(struct bfi_sgpg_s) - 1)));
+
+	for (i = 0; i < mod->num_sgpgs; i++) {
+		bfa_os_memset(hsgpg, 0, sizeof(*hsgpg));
+		bfa_os_memset(sgpg, 0, sizeof(*sgpg));
+
+		hsgpg->sgpg = sgpg;
+		hsgpg->sgpg_pa = sgpg_pa.addr;
+		list_add_tail(&hsgpg->qe, &mod->sgpg_q);
+
+		hsgpg++;
+		sgpg++;
+		sgpg_pa.pa += sizeof(struct bfi_sgpg_s);
+	}
+
+	bfa_meminfo_kva(minfo) = (u8 *) hsgpg;
+	bfa_meminfo_dma_virt(minfo) = (u8 *) sgpg;
+	bfa_meminfo_dma_phys(minfo) = sgpg_pa.pa;
+}
+
+static void
+bfa_sgpg_initdone(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_sgpg_detach(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_sgpg_start(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_sgpg_stop(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_sgpg_iocdisable(struct bfa_s *bfa)
+{
+}
+
+
+
+/**
+ *  bfa_sgpg_public BFA SGPG public functions
+ */
+
+bfa_status_t
+bfa_sgpg_malloc(struct bfa_s *bfa, struct list_head *sgpg_q, int nsgpgs)
+{
+	struct bfa_sgpg_mod_s *mod = BFA_SGPG_MOD(bfa);
+	struct bfa_sgpg_s *hsgpg;
+	int             i;
+
+	bfa_trc_fp(bfa, nsgpgs);
+
+	if (mod->free_sgpgs < nsgpgs)
+		return BFA_STATUS_ENOMEM;
+
+	for (i = 0; i < nsgpgs; i++) {
+		bfa_q_deq(&mod->sgpg_q, &hsgpg);
+		bfa_assert(hsgpg);
+		list_add_tail(&hsgpg->qe, sgpg_q);
+	}
+
+	mod->free_sgpgs -= nsgpgs;
+	return BFA_STATUS_OK;
+}
+
+void
+bfa_sgpg_mfree(struct bfa_s *bfa, struct list_head *sgpg_q, int nsgpg)
+{
+	struct bfa_sgpg_mod_s *mod = BFA_SGPG_MOD(bfa);
+	struct bfa_sgpg_wqe_s *wqe;
+
+	bfa_trc_fp(bfa, nsgpg);
+
+	mod->free_sgpgs += nsgpg;
+	bfa_assert(mod->free_sgpgs <= mod->num_sgpgs);
+
+	list_splice_tail_init(sgpg_q, &mod->sgpg_q);
+
+	if (list_empty(&mod->sgpg_wait_q))
+		return;
+
+	/**
+	 * satisfy as many waiting requests as possible
+	 */
+	do {
+		wqe = bfa_q_first(&mod->sgpg_wait_q);
+		if (mod->free_sgpgs < wqe->nsgpg)
+			nsgpg = mod->free_sgpgs;
+		else
+			nsgpg = wqe->nsgpg;
+		bfa_sgpg_malloc(bfa, &wqe->sgpg_q, nsgpg);
+		wqe->nsgpg -= nsgpg;
+		if (wqe->nsgpg == 0) {
+			list_del(&wqe->qe);
+			wqe->cbfn(wqe->cbarg);
+		}
+	} while (mod->free_sgpgs && !list_empty(&mod->sgpg_wait_q));
+}
+
+void
+bfa_sgpg_wait(struct bfa_s *bfa, struct bfa_sgpg_wqe_s *wqe, int nsgpg)
+{
+	struct bfa_sgpg_mod_s *mod = BFA_SGPG_MOD(bfa);
+
+	bfa_assert(nsgpg > 0);
+	bfa_assert(nsgpg > mod->free_sgpgs);
+
+	wqe->nsgpg_total = wqe->nsgpg = nsgpg;
+
+	/**
+	 * allocate any left to this one first
+	 */
+	if (mod->free_sgpgs) {
+		/**
+		 * no one else is waiting for SGPG
+		 */
+		bfa_assert(list_empty(&mod->sgpg_wait_q));
+		list_splice_tail_init(&mod->sgpg_q, &wqe->sgpg_q);
+		wqe->nsgpg -= mod->free_sgpgs;
+		mod->free_sgpgs = 0;
+	}
+
+	list_add_tail(&wqe->qe, &mod->sgpg_wait_q);
+}
+
+void
+bfa_sgpg_wcancel(struct bfa_s *bfa, struct bfa_sgpg_wqe_s *wqe)
+{
+	struct bfa_sgpg_mod_s *mod = BFA_SGPG_MOD(bfa);
+
+	bfa_assert(bfa_q_is_on_q(&mod->sgpg_wait_q, wqe));
+	list_del(&wqe->qe);
+
+	if (wqe->nsgpg_total != wqe->nsgpg)
+		bfa_sgpg_mfree(bfa, &wqe->sgpg_q,
+				   wqe->nsgpg_total - wqe->nsgpg);
+}
+
+void
+bfa_sgpg_winit(struct bfa_sgpg_wqe_s *wqe, void (*cbfn) (void *cbarg),
+		   void *cbarg)
+{
+	INIT_LIST_HEAD(&wqe->sgpg_q);
+	wqe->cbfn = cbfn;
+	wqe->cbarg = cbarg;
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_sgpg_priv.h patch/drivers/scsi/bfa/bfa_sgpg_priv.h
--- orig/drivers/scsi/bfa/bfa_sgpg_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_sgpg_priv.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,79 @@
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
+ *  hal_sgpg.h BFA SG page module
+ */
+
+#ifndef __BFA_SGPG_PRIV_H__
+#define __BFA_SGPG_PRIV_H__
+
+#include <cs/bfa_q.h>
+
+#define BFA_SGPG_MIN	(16)
+
+/**
+ * Alignment macro for SG page allocation
+ */
+#define BFA_SGPG_ROUNDUP(_l) (((_l) + (sizeof(struct bfi_sgpg_s) - 1)) \
+			& ~(sizeof(struct bfi_sgpg_s) - 1))
+
+struct bfa_sgpg_wqe_s {
+	struct list_head qe;	/*  queue sg page element	*/
+	int	nsgpg;		/*  pages to be allocated	*/
+	int	nsgpg_total;	/*  total pages required	*/
+	void	(*cbfn) (void *cbarg);
+				/*  callback function		*/
+	void	*cbarg;		/*  callback arg		*/
+	struct list_head sgpg_q;	/*  queue of alloced sgpgs	*/
+};
+
+struct bfa_sgpg_s {
+	struct list_head 	qe;	/*  queue sg page element	*/
+	struct bfi_sgpg_s *sgpg; /*  va of SG page		*/
+	union bfi_addr_u sgpg_pa;/*  pa of SG page		*/
+};
+
+/**
+ * Given number of SG elements, BFA_SGPG_NPAGE() returns the number of
+ * SG pages required.
+ */
+#define BFA_SGPG_NPAGE(_nsges)  (((_nsges) / BFI_SGPG_DATA_SGES) + 1)
+
+struct bfa_sgpg_mod_s {
+	struct bfa_s *bfa;
+	int		num_sgpgs;	/*  number of SG pages		*/
+	int		free_sgpgs;	/*  number of free SG pages	*/
+	struct bfa_sgpg_s *hsgpg_arr;	/*  BFA SG page array	*/
+	struct bfi_sgpg_s *sgpg_arr;	/*  actual SG page array	*/
+	u64	sgpg_arr_pa;	/*  SG page array DMA addr	*/
+	struct list_head sgpg_q;	/*  queue of free SG pages	*/
+	struct list_head sgpg_wait_q; /*  wait queue for SG pages	*/
+};
+#define BFA_SGPG_MOD(__bfa)	(&(__bfa)->modules.sgpg_mod)
+
+bfa_status_t	bfa_sgpg_malloc(struct bfa_s *bfa, struct list_head *sgpg_q,
+								int nsgpgs);
+void		bfa_sgpg_mfree(struct bfa_s *bfa, struct list_head *sgpg_q,
+								int nsgpgs);
+void		bfa_sgpg_winit(struct bfa_sgpg_wqe_s *wqe,
+				   void (*cbfn) (void *cbarg), void *cbarg);
+void		bfa_sgpg_wait(struct bfa_s *bfa, struct bfa_sgpg_wqe_s *wqe,
+								int nsgpgs);
+void		bfa_sgpg_wcancel(struct bfa_s *bfa, struct bfa_sgpg_wqe_s *wqe);
+
+#endif /* __BFA_SGPG_PRIV_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_sm.c patch/drivers/scsi/bfa/bfa_sm.c
--- orig/drivers/scsi/bfa/bfa_sm.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_sm.c	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,38 @@
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
+ *  bfasm.c BFA State machine utility functions
+ */
+
+#include <cs/bfa_sm.h>
+
+/**
+ *  cs_sm_api
+ */
+
+int
+bfa_sm_to_state(struct bfa_sm_table_s *smt, bfa_sm_t sm)
+{
+	int             i = 0;
+
+	while (smt[i].sm && smt[i].sm != sm)
+		i++;
+	return smt[i].state;
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_timer.c patch/drivers/scsi/bfa/bfa_timer.c
--- orig/drivers/scsi/bfa/bfa_timer.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_timer.c	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,90 @@
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
+#include <bfa_timer.h>
+#include <cs/bfa_debug.h>
+
+void
+bfa_timer_init(struct bfa_timer_mod_s *mod)
+{
+	INIT_LIST_HEAD(&mod->timer_q);
+}
+
+void
+bfa_timer_beat(struct bfa_timer_mod_s *mod)
+{
+	struct list_head        *qh = &mod->timer_q;
+	struct list_head        *qe, *qe_next;
+	struct bfa_timer_s *elem;
+	struct list_head         timedout_q;
+
+	INIT_LIST_HEAD(&timedout_q);
+
+	qe = bfa_q_next(qh);
+
+	while (qe != qh) {
+		qe_next = bfa_q_next(qe);
+
+		elem = (struct bfa_timer_s *) qe;
+		if (elem->timeout <= BFA_TIMER_FREQ) {
+			elem->timeout = 0;
+			list_del(&elem->qe);
+			list_add_tail(&elem->qe, &timedout_q);
+		} else {
+			elem->timeout -= BFA_TIMER_FREQ;
+		}
+
+		qe = qe_next;	/* go to next elem */
+	}
+
+	/*
+	 * Pop all the timeout entries
+	 */
+	while (!list_empty(&timedout_q)) {
+		bfa_q_deq(&timedout_q, &elem);
+		elem->timercb(elem->arg);
+	}
+}
+
+/**
+ * Should be called with lock protection
+ */
+void
+bfa_timer_begin(struct bfa_timer_mod_s *mod, struct bfa_timer_s *timer,
+		    void (*timercb) (void *), void *arg, unsigned int timeout)
+{
+
+	bfa_assert(timercb != NULL);
+	bfa_assert(!bfa_q_is_on_q(&mod->timer_q, timer));
+
+	timer->timeout = timeout;
+	timer->timercb = timercb;
+	timer->arg = arg;
+
+	list_add_tail(&timer->qe, &mod->timer_q);
+}
+
+/**
+ * Should be called with lock protection
+ */
+void
+bfa_timer_stop(struct bfa_timer_s *timer)
+{
+	bfa_assert(!list_empty(&timer->qe));
+
+	list_del(&timer->qe);
+}
diff -urpN orig/drivers/scsi/bfa/bfa_trcmod_priv.h patch/drivers/scsi/bfa/bfa_trcmod_priv.h
--- orig/drivers/scsi/bfa/bfa_trcmod_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_trcmod_priv.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,66 @@
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
+ *  hal_trcmod.h BFA trace modules
+ */
+
+#ifndef __BFA_TRCMOD_PRIV_H__
+#define __BFA_TRCMOD_PRIV_H__
+
+#include <cs/bfa_trc.h>
+
+/*
+ * !!! Only append to the enums defined here to avoid any versioning
+ * !!! needed between trace utility and driver version
+ */
+enum {
+	BFA_TRC_HAL_IOC		= 1,
+	BFA_TRC_HAL_INTR	= 2,
+	BFA_TRC_HAL_FCXP	= 3,
+	BFA_TRC_HAL_UF		= 4,
+	BFA_TRC_HAL_DIAG	= 5,
+	BFA_TRC_HAL_RPORT	= 6,
+	BFA_TRC_HAL_FCPIM	= 7,
+	BFA_TRC_HAL_IOIM	= 8,
+	BFA_TRC_HAL_TSKIM	= 9,
+	BFA_TRC_HAL_ITNIM	= 10,
+	BFA_TRC_HAL_PPORT	= 11,
+	BFA_TRC_HAL_SGPG	= 12,
+	BFA_TRC_HAL_FLASH	= 13,
+	BFA_TRC_HAL_DEBUG	= 14,
+	BFA_TRC_HAL_WWN		= 15,
+	BFA_TRC_HAL_FLASH_RAW	= 16,
+	BFA_TRC_HAL_SBOOT	= 17,
+	BFA_TRC_HAL_SBOOT_IO	= 18,
+	BFA_TRC_HAL_SBOOT_INTR	= 19,
+	BFA_TRC_HAL_SBTEST	= 20,
+	BFA_TRC_HAL_IPFC	= 21,
+	BFA_TRC_HAL_IOCFC	= 22,
+	BFA_TRC_HAL_FCPTM	= 23,
+	BFA_TRC_HAL_IOTM	= 24,
+	BFA_TRC_HAL_TSKTM	= 25,
+	BFA_TRC_HAL_TIN		= 26,
+	BFA_TRC_HAL_LPS		= 27,
+	BFA_TRC_HAL_FCDIAG	= 28,
+	BFA_TRC_HAL_PBIND	= 29,
+	BFA_TRC_HAL_IOCFC_CT	= 30,
+	BFA_TRC_HAL_IOCFC_CB	= 31,
+	BFA_TRC_HAL_IOCFC_Q	= 32,
+};
+
+#endif /* __BFA_TRCMOD_PRIV_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_tskim.c patch/drivers/scsi/bfa/bfa_tskim.c
--- orig/drivers/scsi/bfa/bfa_tskim.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_tskim.c	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,689 @@
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
+#include <bfa.h>
+#include <bfa_cb_ioim_macros.h>
+
+BFA_TRC_FILE(HAL, TSKIM);
+
+/**
+ * task management completion handling
+ */
+#define bfa_tskim_qcomp(__tskim, __cbfn) do {			     \
+	bfa_cb_queue((__tskim)->bfa, &(__tskim)->hcb_qe, __cbfn, (__tskim)); \
+	bfa_tskim_notify_comp(__tskim);      \
+} while (0)
+
+#define bfa_tskim_notify_comp(__tskim) do {				     \
+	if ((__tskim)->notify)					     	     \
+		bfa_itnim_tskdone((__tskim)->itnim);      \
+} while (0)
+
+/*
+ * forward declarations
+ */
+static void     __bfa_cb_tskim_done(void *cbarg, bfa_boolean_t complete);
+static void     __bfa_cb_tskim_failed(void *cbarg, bfa_boolean_t complete);
+static bfa_boolean_t bfa_tskim_match_scope(struct bfa_tskim_s *tskim,
+					       lun_t lun);
+static void     bfa_tskim_gather_ios(struct bfa_tskim_s *tskim);
+static void     bfa_tskim_cleanp_comp(void *tskim_cbarg);
+static void     bfa_tskim_cleanup_ios(struct bfa_tskim_s *tskim);
+static bfa_boolean_t bfa_tskim_send(struct bfa_tskim_s *tskim);
+static bfa_boolean_t bfa_tskim_send_abort(struct bfa_tskim_s *tskim);
+static void     bfa_tskim_iocdisable_ios(struct bfa_tskim_s *tskim);
+
+/**
+ *  bfa_tskim_sm
+ */
+
+enum bfa_tskim_event {
+	BFA_TSKIM_SM_START        = 1,  /*  TM command start            */
+	BFA_TSKIM_SM_DONE         = 2,  /*  TM completion               */
+	BFA_TSKIM_SM_QRESUME      = 3,  /*  resume after qfull          */
+	BFA_TSKIM_SM_HWFAIL       = 5,  /*  IOC h/w failure event       */
+	BFA_TSKIM_SM_HCB          = 6,  /*  BFA callback completion     */
+	BFA_TSKIM_SM_IOS_DONE     = 7,  /*  IO and sub TM completions   */
+	BFA_TSKIM_SM_CLEANUP      = 8,  /*  TM cleanup on ITN offline   */
+	BFA_TSKIM_SM_CLEANUP_DONE = 9,  /*  TM abort completion         */
+};
+
+static void     bfa_tskim_sm_uninit(struct bfa_tskim_s *tskim,
+					enum bfa_tskim_event event);
+static void     bfa_tskim_sm_active(struct bfa_tskim_s *tskim,
+					enum bfa_tskim_event event);
+static void     bfa_tskim_sm_cleanup(struct bfa_tskim_s *tskim,
+					 enum bfa_tskim_event event);
+static void     bfa_tskim_sm_iocleanup(struct bfa_tskim_s *tskim,
+					 enum bfa_tskim_event event);
+static void     bfa_tskim_sm_qfull(struct bfa_tskim_s *tskim,
+				       enum bfa_tskim_event event);
+static void     bfa_tskim_sm_cleanup_qfull(struct bfa_tskim_s *tskim,
+				       enum bfa_tskim_event event);
+static void     bfa_tskim_sm_hcb(struct bfa_tskim_s *tskim,
+				     enum bfa_tskim_event event);
+
+/**
+ *      Task management command beginning state.
+ */
+static void
+bfa_tskim_sm_uninit(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
+{
+	bfa_trc(tskim->bfa, event);
+
+	switch (event) {
+	case BFA_TSKIM_SM_START:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_active);
+		bfa_tskim_gather_ios(tskim);
+
+		/**
+		 * If device is offline, do not send TM on wire. Just cleanup
+		 * any pending IO requests and complete TM request.
+		 */
+		if (!bfa_itnim_is_online(tskim->itnim)) {
+			bfa_sm_set_state(tskim, bfa_tskim_sm_iocleanup);
+			tskim->tsk_status = BFI_TSKIM_STS_OK;
+			bfa_tskim_cleanup_ios(tskim);
+			return;
+		}
+
+		if (!bfa_tskim_send(tskim)) {
+			bfa_sm_set_state(tskim, bfa_tskim_sm_qfull);
+			bfa_reqq_wait(tskim->bfa, tskim->itnim->reqq,
+					  &tskim->reqq_wait);
+		}
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * brief
+ *	TM command is active, awaiting completion from firmware to
+ *	cleanup IO requests in TM scope.
+ */
+static void
+bfa_tskim_sm_active(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
+{
+	bfa_trc(tskim->bfa, event);
+
+	switch (event) {
+	case BFA_TSKIM_SM_DONE:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_iocleanup);
+		bfa_tskim_cleanup_ios(tskim);
+		break;
+
+	case BFA_TSKIM_SM_CLEANUP:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_cleanup);
+		if (!bfa_tskim_send_abort(tskim)) {
+			bfa_sm_set_state(tskim, bfa_tskim_sm_cleanup_qfull);
+			bfa_reqq_wait(tskim->bfa, tskim->itnim->reqq,
+				&tskim->reqq_wait);
+		}
+		break;
+
+	case BFA_TSKIM_SM_HWFAIL:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_hcb);
+		bfa_tskim_iocdisable_ios(tskim);
+		bfa_tskim_qcomp(tskim, __bfa_cb_tskim_failed);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ *	An active TM is being cleaned up since ITN is offline. Awaiting cleanup
+ *	completion event from firmware.
+ */
+static void
+bfa_tskim_sm_cleanup(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
+{
+	bfa_trc(tskim->bfa, event);
+
+	switch (event) {
+	case BFA_TSKIM_SM_DONE:
+		/**
+		 * Ignore and wait for ABORT completion from firmware.
+		 */
+		break;
+
+	case BFA_TSKIM_SM_CLEANUP_DONE:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_iocleanup);
+		bfa_tskim_cleanup_ios(tskim);
+		break;
+
+	case BFA_TSKIM_SM_HWFAIL:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_hcb);
+		bfa_tskim_iocdisable_ios(tskim);
+		bfa_tskim_qcomp(tskim, __bfa_cb_tskim_failed);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_tskim_sm_iocleanup(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
+{
+	bfa_trc(tskim->bfa, event);
+
+	switch (event) {
+	case BFA_TSKIM_SM_IOS_DONE:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_hcb);
+		bfa_tskim_qcomp(tskim, __bfa_cb_tskim_done);
+		break;
+
+	case BFA_TSKIM_SM_CLEANUP:
+		/**
+		 * Ignore, TM command completed on wire.
+		 * Notify TM conmpletion on IO cleanup completion.
+		 */
+		break;
+
+	case BFA_TSKIM_SM_HWFAIL:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_hcb);
+		bfa_tskim_iocdisable_ios(tskim);
+		bfa_tskim_qcomp(tskim, __bfa_cb_tskim_failed);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ *      Task management command is waiting for room in request CQ
+ */
+static void
+bfa_tskim_sm_qfull(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
+{
+	bfa_trc(tskim->bfa, event);
+
+	switch (event) {
+	case BFA_TSKIM_SM_QRESUME:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_active);
+		bfa_tskim_send(tskim);
+		break;
+
+	case BFA_TSKIM_SM_CLEANUP:
+		/**
+		 * No need to send TM on wire since ITN is offline.
+		 */
+		bfa_sm_set_state(tskim, bfa_tskim_sm_iocleanup);
+		bfa_reqq_wcancel(&tskim->reqq_wait);
+		bfa_tskim_cleanup_ios(tskim);
+		break;
+
+	case BFA_TSKIM_SM_HWFAIL:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_hcb);
+		bfa_reqq_wcancel(&tskim->reqq_wait);
+		bfa_tskim_iocdisable_ios(tskim);
+		bfa_tskim_qcomp(tskim, __bfa_cb_tskim_failed);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ *      Task management command is active, awaiting for room in request CQ
+ *	to send clean up request.
+ */
+static void
+bfa_tskim_sm_cleanup_qfull(struct bfa_tskim_s *tskim,
+		enum bfa_tskim_event event)
+{
+	bfa_trc(tskim->bfa, event);
+
+	switch (event) {
+	case BFA_TSKIM_SM_DONE:
+		bfa_reqq_wcancel(&tskim->reqq_wait);
+		/**
+		 *
+		 * Fall through !!!
+		 */
+
+	case BFA_TSKIM_SM_QRESUME:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_cleanup);
+		bfa_tskim_send_abort(tskim);
+		break;
+
+	case BFA_TSKIM_SM_HWFAIL:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_hcb);
+		bfa_reqq_wcancel(&tskim->reqq_wait);
+		bfa_tskim_iocdisable_ios(tskim);
+		bfa_tskim_qcomp(tskim, __bfa_cb_tskim_failed);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ *      BFA callback is pending
+ */
+static void
+bfa_tskim_sm_hcb(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
+{
+	bfa_trc(tskim->bfa, event);
+
+	switch (event) {
+	case BFA_TSKIM_SM_HCB:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_uninit);
+		bfa_tskim_free(tskim);
+		break;
+
+	case BFA_TSKIM_SM_CLEANUP:
+		bfa_tskim_notify_comp(tskim);
+		break;
+
+	case BFA_TSKIM_SM_HWFAIL:
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+
+
+/**
+ *  bfa_tskim_private
+ */
+
+static void
+__bfa_cb_tskim_done(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_tskim_s *tskim = cbarg;
+
+	if (!complete) {
+		bfa_sm_send_event(tskim, BFA_TSKIM_SM_HCB);
+		return;
+	}
+
+	bfa_stats(tskim->itnim, tm_success);
+	bfa_cb_tskim_done(tskim->bfa->bfad, tskim->dtsk, tskim->tsk_status);
+}
+
+static void
+__bfa_cb_tskim_failed(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_tskim_s *tskim = cbarg;
+
+	if (!complete) {
+		bfa_sm_send_event(tskim, BFA_TSKIM_SM_HCB);
+		return;
+	}
+
+	bfa_stats(tskim->itnim, tm_failures);
+	bfa_cb_tskim_done(tskim->bfa->bfad, tskim->dtsk,
+			   BFI_TSKIM_STS_FAILED);
+}
+
+static          bfa_boolean_t
+bfa_tskim_match_scope(struct bfa_tskim_s *tskim, lun_t lun)
+{
+	switch (tskim->tm_cmnd) {
+	case FCP_TM_TARGET_RESET:
+		return BFA_TRUE;
+
+	case FCP_TM_ABORT_TASK_SET:
+	case FCP_TM_CLEAR_TASK_SET:
+	case FCP_TM_LUN_RESET:
+	case FCP_TM_CLEAR_ACA:
+		return (tskim->lun == lun);
+
+	default:
+		bfa_assert(0);
+	}
+
+	return BFA_FALSE;
+}
+
+/**
+ *      Gather affected IO requests and task management commands.
+ */
+static void
+bfa_tskim_gather_ios(struct bfa_tskim_s *tskim)
+{
+	struct bfa_itnim_s *itnim = tskim->itnim;
+	struct bfa_ioim_s *ioim;
+	struct list_head        *qe, *qen;
+
+	INIT_LIST_HEAD(&tskim->io_q);
+
+	/**
+	 * Gather any active IO requests first.
+	 */
+	list_for_each_safe(qe, qen, &itnim->io_q) {
+		ioim = (struct bfa_ioim_s *) qe;
+		if (bfa_tskim_match_scope
+		    (tskim, bfa_cb_ioim_get_lun(ioim->dio))) {
+			list_del(&ioim->qe);
+			list_add_tail(&ioim->qe, &tskim->io_q);
+		}
+	}
+
+	/**
+	 * Failback any pending IO requests immediately.
+	 */
+	list_for_each_safe(qe, qen, &itnim->pending_q) {
+		ioim = (struct bfa_ioim_s *) qe;
+		if (bfa_tskim_match_scope
+		    (tskim, bfa_cb_ioim_get_lun(ioim->dio))) {
+			list_del(&ioim->qe);
+			list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
+			bfa_ioim_tov(ioim);
+		}
+	}
+}
+
+/**
+ * 		IO cleanup completion
+ */
+static void
+bfa_tskim_cleanp_comp(void *tskim_cbarg)
+{
+	struct bfa_tskim_s *tskim = tskim_cbarg;
+
+	bfa_stats(tskim->itnim, tm_io_comps);
+	bfa_sm_send_event(tskim, BFA_TSKIM_SM_IOS_DONE);
+}
+
+/**
+ *      Gather affected IO requests and task management commands.
+ */
+static void
+bfa_tskim_cleanup_ios(struct bfa_tskim_s *tskim)
+{
+	struct bfa_ioim_s *ioim;
+	struct list_head        *qe, *qen;
+
+	bfa_wc_init(&tskim->wc, bfa_tskim_cleanp_comp, tskim);
+
+	list_for_each_safe(qe, qen, &tskim->io_q) {
+		ioim = (struct bfa_ioim_s *) qe;
+		bfa_wc_up(&tskim->wc);
+		bfa_ioim_cleanup_tm(ioim, tskim);
+	}
+
+	bfa_wc_wait(&tskim->wc);
+}
+
+/**
+ *      Send task management request to firmware.
+ */
+static bfa_boolean_t
+bfa_tskim_send(struct bfa_tskim_s *tskim)
+{
+	struct bfa_itnim_s *itnim = tskim->itnim;
+	struct bfi_tskim_req_s *m;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(tskim->bfa, itnim->reqq);
+	if (!m)
+		return BFA_FALSE;
+
+	/**
+	 * build i/o request message next
+	 */
+	bfi_h2i_set(m->mh, BFI_MC_TSKIM, BFI_TSKIM_H2I_TM_REQ,
+			bfa_lpuid(tskim->bfa));
+
+	m->tsk_tag = bfa_os_htons(tskim->tsk_tag);
+	m->itn_fhdl = tskim->itnim->rport->fw_handle;
+	m->t_secs = tskim->tsecs;
+	m->lun = tskim->lun;
+	m->tm_flags = tskim->tm_cmnd;
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(tskim->bfa, itnim->reqq);
+	return BFA_TRUE;
+}
+
+/**
+ *      Send abort request to cleanup an active TM to firmware.
+ */
+static bfa_boolean_t
+bfa_tskim_send_abort(struct bfa_tskim_s *tskim)
+{
+	struct bfa_itnim_s             *itnim = tskim->itnim;
+	struct bfi_tskim_abortreq_s    *m;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(tskim->bfa, itnim->reqq);
+	if (!m)
+		return BFA_FALSE;
+
+	/**
+	 * build i/o request message next
+	 */
+	bfi_h2i_set(m->mh, BFI_MC_TSKIM, BFI_TSKIM_H2I_ABORT_REQ,
+			bfa_lpuid(tskim->bfa));
+
+	m->tsk_tag  = bfa_os_htons(tskim->tsk_tag);
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(tskim->bfa, itnim->reqq);
+	return BFA_TRUE;
+}
+
+/**
+ *      Call to resume task management cmnd waiting for room in request queue.
+ */
+static void
+bfa_tskim_qresume(void *cbarg)
+{
+	struct bfa_tskim_s *tskim = cbarg;
+
+	bfa_fcpim_stats(tskim->fcpim, qresumes);
+	bfa_stats(tskim->itnim, tm_qresumes);
+	bfa_sm_send_event(tskim, BFA_TSKIM_SM_QRESUME);
+}
+
+/**
+ * Cleanup IOs associated with a task mangement command on IOC failures.
+ */
+static void
+bfa_tskim_iocdisable_ios(struct bfa_tskim_s *tskim)
+{
+	struct bfa_ioim_s *ioim;
+	struct list_head        *qe, *qen;
+
+	list_for_each_safe(qe, qen, &tskim->io_q) {
+		ioim = (struct bfa_ioim_s *) qe;
+		bfa_ioim_iocdisable(ioim);
+	}
+}
+
+
+
+/**
+ *  bfa_tskim_friend
+ */
+
+/**
+ * Notification on completions from related ioim.
+ */
+void
+bfa_tskim_iodone(struct bfa_tskim_s *tskim)
+{
+	bfa_wc_down(&tskim->wc);
+}
+
+/**
+ * Handle IOC h/w failure notification from itnim.
+ */
+void
+bfa_tskim_iocdisable(struct bfa_tskim_s *tskim)
+{
+	tskim->notify = BFA_FALSE;
+	bfa_stats(tskim->itnim, tm_iocdowns);
+	bfa_sm_send_event(tskim, BFA_TSKIM_SM_HWFAIL);
+}
+
+/**
+ * Cleanup TM command and associated IOs as part of ITNIM offline.
+ */
+void
+bfa_tskim_cleanup(struct bfa_tskim_s *tskim)
+{
+	tskim->notify = BFA_TRUE;
+	bfa_stats(tskim->itnim, tm_cleanups);
+	bfa_sm_send_event(tskim, BFA_TSKIM_SM_CLEANUP);
+}
+
+/**
+ *      Memory allocation and initialization.
+ */
+void
+bfa_tskim_attach(struct bfa_fcpim_mod_s *fcpim, struct bfa_meminfo_s *minfo)
+{
+	struct bfa_tskim_s *tskim;
+	u16        i;
+
+	INIT_LIST_HEAD(&fcpim->tskim_free_q);
+
+	tskim = (struct bfa_tskim_s *) bfa_meminfo_kva(minfo);
+	fcpim->tskim_arr = tskim;
+
+	for (i = 0; i < fcpim->num_tskim_reqs; i++, tskim++) {
+		/*
+		 * initialize TSKIM
+		 */
+		bfa_os_memset(tskim, 0, sizeof(struct bfa_tskim_s));
+		tskim->tsk_tag = i;
+		tskim->bfa     = fcpim->bfa;
+		tskim->fcpim   = fcpim;
+		tskim->notify  = BFA_FALSE;
+		bfa_reqq_winit(&tskim->reqq_wait, bfa_tskim_qresume,
+				   tskim);
+		bfa_sm_set_state(tskim, bfa_tskim_sm_uninit);
+
+		list_add_tail(&tskim->qe, &fcpim->tskim_free_q);
+	}
+
+	bfa_meminfo_kva(minfo) = (u8 *) tskim;
+}
+
+void
+bfa_tskim_detach(struct bfa_fcpim_mod_s *fcpim)
+{
+    /**
+     * @todo
+     */
+}
+
+void
+bfa_tskim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+	struct bfi_tskim_rsp_s *rsp = (struct bfi_tskim_rsp_s *) m;
+	struct bfa_tskim_s *tskim;
+	u16        tsk_tag = bfa_os_ntohs(rsp->tsk_tag);
+
+	tskim = BFA_TSKIM_FROM_TAG(fcpim, tsk_tag);
+	bfa_assert(tskim->tsk_tag == tsk_tag);
+
+	tskim->tsk_status = rsp->tsk_status;
+
+	/**
+	 * Firmware sends BFI_TSKIM_STS_ABORTED status for abort
+	 * requests. All other statuses are for normal completions.
+	 */
+	if (rsp->tsk_status == BFI_TSKIM_STS_ABORTED) {
+		bfa_stats(tskim->itnim, tm_cleanup_comps);
+		bfa_sm_send_event(tskim, BFA_TSKIM_SM_CLEANUP_DONE);
+	} else {
+		bfa_stats(tskim->itnim, tm_fw_rsps);
+		bfa_sm_send_event(tskim, BFA_TSKIM_SM_DONE);
+	}
+}
+
+
+
+/**
+ *  bfa_tskim_api
+ */
+
+
+struct bfa_tskim_s *
+bfa_tskim_alloc(struct bfa_s *bfa, struct bfad_tskim_s *dtsk)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+	struct bfa_tskim_s *tskim;
+
+	bfa_q_deq(&fcpim->tskim_free_q, &tskim);
+
+	if (!tskim)
+		bfa_fcpim_stats(fcpim, no_tskims);
+	else
+		tskim->dtsk = dtsk;
+
+	return tskim;
+}
+
+void
+bfa_tskim_free(struct bfa_tskim_s *tskim)
+{
+	bfa_assert(bfa_q_is_on_q_func(&tskim->itnim->tsk_q, &tskim->qe));
+	list_del(&tskim->qe);
+	list_add_tail(&tskim->qe, &tskim->fcpim->tskim_free_q);
+}
+
+/**
+ *      Start a task management command.
+ *
+ * @param[in]       tskim       BFA task management command instance
+ * @param[in]       itnim       i-t nexus for the task management command
+ * @param[in]       lun         lun, if applicable
+ * @param[in]       tm_cmnd     Task management command code.
+ * @param[in]       t_secs      Timeout in seconds
+ *
+ * @return None.
+ */
+void
+bfa_tskim_start(struct bfa_tskim_s *tskim, struct bfa_itnim_s *itnim, lun_t lun,
+		    enum fcp_tm_cmnd tm_cmnd, u8 tsecs)
+{
+	tskim->itnim   = itnim;
+	tskim->lun     = lun;
+	tskim->tm_cmnd = tm_cmnd;
+	tskim->tsecs   = tsecs;
+	tskim->notify  = BFA_FALSE;
+	bfa_stats(itnim, tm_cmnds);
+
+	list_add_tail(&tskim->qe, &itnim->tsk_q);
+	bfa_sm_send_event(tskim, BFA_TSKIM_SM_START);
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_uf.c patch/drivers/scsi/bfa/bfa_uf.c
--- orig/drivers/scsi/bfa/bfa_uf.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_uf.c	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,345 @@
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
+ *  bfa_uf.c BFA unsolicited frame receive implementation
+ */
+
+#include <bfa.h>
+#include <bfa_svc.h>
+#include <bfi/bfi_uf.h>
+#include <cs/bfa_debug.h>
+
+BFA_TRC_FILE(HAL, UF);
+BFA_MODULE(uf);
+
+/*
+ *****************************************************************************
+ * Internal functions
+ *****************************************************************************
+ */
+static void
+__bfa_cb_uf_recv(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_uf_s   *uf = cbarg;
+	struct bfa_uf_mod_s *ufm = BFA_UF_MOD(uf->bfa);
+
+	if (complete)
+		ufm->ufrecv(ufm->cbarg, uf);
+}
+
+static void
+claim_uf_pbs(struct bfa_uf_mod_s *ufm, struct bfa_meminfo_s *mi)
+{
+	u32        uf_pb_tot_sz;
+
+	ufm->uf_pbs_kva = (struct bfa_uf_buf_s *) bfa_meminfo_dma_virt(mi);
+	ufm->uf_pbs_pa = bfa_meminfo_dma_phys(mi);
+	uf_pb_tot_sz = BFA_ROUNDUP((sizeof(struct bfa_uf_buf_s) * ufm->num_ufs),
+							BFA_DMA_ALIGN_SZ);
+
+	bfa_meminfo_dma_virt(mi) += uf_pb_tot_sz;
+	bfa_meminfo_dma_phys(mi) += uf_pb_tot_sz;
+
+	bfa_os_memset((void *)ufm->uf_pbs_kva, 0, uf_pb_tot_sz);
+}
+
+static void
+claim_uf_post_msgs(struct bfa_uf_mod_s *ufm, struct bfa_meminfo_s *mi)
+{
+	struct bfi_uf_buf_post_s *uf_bp_msg;
+	struct bfi_sge_s      *sge;
+	union bfi_addr_u      sga_zero = { {0} };
+	u16        i;
+	u16        buf_len;
+
+	ufm->uf_buf_posts = (struct bfi_uf_buf_post_s *) bfa_meminfo_kva(mi);
+	uf_bp_msg = ufm->uf_buf_posts;
+
+	for (i = 0, uf_bp_msg = ufm->uf_buf_posts; i < ufm->num_ufs;
+	     i++, uf_bp_msg++) {
+		bfa_os_memset(uf_bp_msg, 0, sizeof(struct bfi_uf_buf_post_s));
+
+		uf_bp_msg->buf_tag = i;
+		buf_len = sizeof(struct bfa_uf_buf_s);
+		uf_bp_msg->buf_len = bfa_os_htons(buf_len);
+		bfi_h2i_set(uf_bp_msg->mh, BFI_MC_UF, BFI_UF_H2I_BUF_POST,
+			    bfa_lpuid(ufm->bfa));
+
+		sge = uf_bp_msg->sge;
+		sge[0].sg_len = buf_len;
+		sge[0].flags = BFI_SGE_DATA_LAST;
+		bfa_dma_addr_set(sge[0].sga, ufm_pbs_pa(ufm, i));
+		bfa_sge_to_be(sge);
+
+		sge[1].sg_len = buf_len;
+		sge[1].flags = BFI_SGE_PGDLEN;
+		sge[1].sga = sga_zero;
+		bfa_sge_to_be(&sge[1]);
+	}
+
+	/**
+	 * advance pointer beyond consumed memory
+	 */
+	bfa_meminfo_kva(mi) = (u8 *) uf_bp_msg;
+}
+
+static void
+claim_ufs(struct bfa_uf_mod_s *ufm, struct bfa_meminfo_s *mi)
+{
+	u16        i;
+	struct bfa_uf_s   *uf;
+
+	/*
+	 * Claim block of memory for UF list
+	 */
+	ufm->uf_list = (struct bfa_uf_s *) bfa_meminfo_kva(mi);
+
+	/*
+	 * Initialize UFs and queue it in UF free queue
+	 */
+	for (i = 0, uf = ufm->uf_list; i < ufm->num_ufs; i++, uf++) {
+		bfa_os_memset(uf, 0, sizeof(struct bfa_uf_s));
+		uf->bfa = ufm->bfa;
+		uf->uf_tag = i;
+		uf->pb_len = sizeof(struct bfa_uf_buf_s);
+		uf->buf_kva = (void *)&ufm->uf_pbs_kva[i];
+		uf->buf_pa = ufm_pbs_pa(ufm, i);
+		list_add_tail(&uf->qe, &ufm->uf_free_q);
+	}
+
+	/**
+	 * advance memory pointer
+	 */
+	bfa_meminfo_kva(mi) = (u8 *) uf;
+}
+
+static void
+uf_mem_claim(struct bfa_uf_mod_s *ufm, struct bfa_meminfo_s *mi)
+{
+	claim_uf_pbs(ufm, mi);
+	claim_ufs(ufm, mi);
+	claim_uf_post_msgs(ufm, mi);
+}
+
+static void
+bfa_uf_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len, u32 *dm_len)
+{
+	u32        num_ufs = cfg->fwcfg.num_uf_bufs;
+
+	/*
+	 * dma-able memory for UF posted bufs
+	 */
+	*dm_len += BFA_ROUNDUP((sizeof(struct bfa_uf_buf_s) * num_ufs),
+							BFA_DMA_ALIGN_SZ);
+
+	/*
+	 * kernel Virtual memory for UFs and UF buf post msg copies
+	 */
+	*ndm_len += sizeof(struct bfa_uf_s) * num_ufs;
+	*ndm_len += sizeof(struct bfi_uf_buf_post_s) * num_ufs;
+}
+
+static void
+bfa_uf_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+		  struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
+{
+	struct bfa_uf_mod_s *ufm = BFA_UF_MOD(bfa);
+
+	bfa_os_memset(ufm, 0, sizeof(struct bfa_uf_mod_s));
+	ufm->bfa = bfa;
+	ufm->num_ufs = cfg->fwcfg.num_uf_bufs;
+	INIT_LIST_HEAD(&ufm->uf_free_q);
+	INIT_LIST_HEAD(&ufm->uf_posted_q);
+
+	uf_mem_claim(ufm, meminfo);
+}
+
+static void
+bfa_uf_initdone(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_uf_detach(struct bfa_s *bfa)
+{
+}
+
+static struct bfa_uf_s *
+bfa_uf_get(struct bfa_uf_mod_s *uf_mod)
+{
+	struct bfa_uf_s   *uf;
+
+	bfa_q_deq(&uf_mod->uf_free_q, &uf);
+	return (uf);
+}
+
+static void
+bfa_uf_put(struct bfa_uf_mod_s *uf_mod, struct bfa_uf_s *uf)
+{
+	list_add_tail(&uf->qe, &uf_mod->uf_free_q);
+}
+
+static bfa_status_t
+bfa_uf_post(struct bfa_uf_mod_s *ufm, struct bfa_uf_s *uf)
+{
+	struct bfi_uf_buf_post_s *uf_post_msg;
+
+	uf_post_msg = bfa_reqq_next(ufm->bfa, BFA_REQQ_FCXP);
+	if (!uf_post_msg)
+		return BFA_STATUS_FAILED;
+
+	bfa_os_memcpy(uf_post_msg, &ufm->uf_buf_posts[uf->uf_tag],
+		      sizeof(struct bfi_uf_buf_post_s));
+	bfa_reqq_produce(ufm->bfa, BFA_REQQ_FCXP);
+
+	bfa_trc(ufm->bfa, uf->uf_tag);
+
+	list_add_tail(&uf->qe, &ufm->uf_posted_q);
+	return BFA_STATUS_OK;
+}
+
+static void
+bfa_uf_post_all(struct bfa_uf_mod_s *uf_mod)
+{
+	struct bfa_uf_s   *uf;
+
+	while ((uf = bfa_uf_get(uf_mod)) != NULL) {
+		if (bfa_uf_post(uf_mod, uf) != BFA_STATUS_OK)
+			break;
+	}
+}
+
+static void
+uf_recv(struct bfa_s *bfa, struct bfi_uf_frm_rcvd_s *m)
+{
+	struct bfa_uf_mod_s *ufm = BFA_UF_MOD(bfa);
+	u16        uf_tag = m->buf_tag;
+	struct bfa_uf_buf_s *uf_buf = &ufm->uf_pbs_kva[uf_tag];
+	struct bfa_uf_s   *uf = &ufm->uf_list[uf_tag];
+	u8        *buf = &uf_buf->d[0];
+	struct fchs_s         *fchs;
+
+	m->frm_len = bfa_os_ntohs(m->frm_len);
+	m->xfr_len = bfa_os_ntohs(m->xfr_len);
+
+	fchs = (struct fchs_s *) uf_buf;
+
+	list_del(&uf->qe);	/* dequeue from posted queue */
+
+	uf->data_ptr = buf;
+	uf->data_len = m->xfr_len;
+
+	bfa_assert(uf->data_len >= sizeof(struct fchs_s));
+
+	if (uf->data_len == sizeof(struct fchs_s)) {
+		bfa_plog_fchdr(bfa->plog, BFA_PL_MID_HAL_UF, BFA_PL_EID_RX,
+			       uf->data_len, (struct fchs_s *) buf);
+	} else {
+		u32        pld_w0 = *((u32 *) (buf + sizeof(struct fchs_s)));
+		bfa_plog_fchdr_and_pl(bfa->plog, BFA_PL_MID_HAL_UF,
+				      BFA_PL_EID_RX, uf->data_len,
+				      (struct fchs_s *) buf, pld_w0);
+	}
+
+	bfa_cb_queue(bfa, &uf->hcb_qe, __bfa_cb_uf_recv, uf);
+}
+
+static void
+bfa_uf_stop(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_uf_iocdisable(struct bfa_s *bfa)
+{
+	struct bfa_uf_mod_s *ufm = BFA_UF_MOD(bfa);
+	struct bfa_uf_s   *uf;
+	struct list_head        *qe, *qen;
+
+	list_for_each_safe(qe, qen, &ufm->uf_posted_q) {
+		uf = (struct bfa_uf_s *) qe;
+		list_del(&uf->qe);
+		bfa_uf_put(ufm, uf);
+	}
+}
+
+static void
+bfa_uf_start(struct bfa_s *bfa)
+{
+	bfa_uf_post_all(BFA_UF_MOD(bfa));
+}
+
+
+
+/**
+ *  bfa_uf_api
+ */
+
+/**
+ * 		Register handler for all unsolicted recieve frames.
+ *
+ * @param[in]	bfa		BFA instance
+ * @param[in]	ufrecv	receive handler function
+ * @param[in]	cbarg	receive handler arg
+ */
+void
+bfa_uf_recv_register(struct bfa_s *bfa, bfa_cb_uf_recv_t ufrecv, void *cbarg)
+{
+	struct bfa_uf_mod_s *ufm = BFA_UF_MOD(bfa);
+
+	ufm->ufrecv = ufrecv;
+	ufm->cbarg = cbarg;
+}
+
+/**
+ * 		Free an unsolicited frame back to BFA.
+ *
+ * @param[in]		uf		unsolicited frame to be freed
+ *
+ * @return None
+ */
+void
+bfa_uf_free(struct bfa_uf_s *uf)
+{
+	bfa_uf_put(BFA_UF_MOD(uf->bfa), uf);
+	bfa_uf_post_all(BFA_UF_MOD(uf->bfa));
+}
+
+
+
+/**
+ *  uf_pub BFA uf module public functions
+ */
+
+void
+bfa_uf_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
+{
+	bfa_trc(bfa, msg->mhdr.msg_id);
+
+	switch (msg->mhdr.msg_id) {
+	case BFI_UF_I2H_FRM_RCVD:
+		uf_recv(bfa, (struct bfi_uf_frm_rcvd_s *) msg);
+		break;
+
+	default:
+		bfa_trc(bfa, msg->mhdr.msg_id);
+		bfa_assert(0);
+	}
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_uf_priv.h patch/drivers/scsi/bfa/bfa_uf_priv.h
--- orig/drivers/scsi/bfa/bfa_uf_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_uf_priv.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,47 @@
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
+#ifndef __BFA_UF_PRIV_H__
+#define __BFA_UF_PRIV_H__
+
+#include <cs/bfa_sm.h>
+#include <bfa_svc.h>
+#include <bfi/bfi_uf.h>
+
+#define BFA_UF_MIN	(4)
+
+struct bfa_uf_mod_s {
+	struct bfa_s *bfa;		/*  back pointer to BFA */
+	struct bfa_uf_s *uf_list;	/*  array of UFs */
+	u16	num_ufs;	/*  num unsolicited rx frames */
+	struct list_head 	uf_free_q;	/*  free UFs */
+	struct list_head 	uf_posted_q;	/*  UFs posted to IOC */
+	struct bfa_uf_buf_s *uf_pbs_kva;	/*  list UF bufs request pld */
+	u64	uf_pbs_pa;	/*  phy addr for UF bufs */
+	struct bfi_uf_buf_post_s *uf_buf_posts;
+					/*  pre-built UF post msgs */
+	bfa_cb_uf_recv_t ufrecv;	/*  uf recv handler function */
+	void		*cbarg;		/*  uf receive handler arg */
+};
+
+#define BFA_UF_MOD(__bfa)	(&(__bfa)->modules.uf_mod)
+
+#define ufm_pbs_pa(_ufmod, _uftag)	\
+	((_ufmod)->uf_pbs_pa + sizeof(struct bfa_uf_buf_s) * (_uftag))
+
+void	bfa_uf_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
+
+#endif /* __BFA_UF_PRIV_H__ */

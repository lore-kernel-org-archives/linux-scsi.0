From: Krishna Gudipati <kgudipat@brocade.com>
Subject: [PATCH 3/5] bfa: Brocade BFA FC SCSI driver (include)
Date: Mon, 23 Mar 2009 17:11:47 -0700
Message-ID: <200903240011.n2O0BllR013985@blc-10-2.brocade.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx30.brocade.com ([144.49.194.4]:33213 "EHLO mx30.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207AbZCXAV2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Mar 2009 20:21:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: huangj@brocade.com, kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Krishna Chaitanya Gudipati <kgudipat@brocade.com>

This patch contains common header files for linux driver and
hardware/firmware interface.

Signed-off-by: Krishna Chaitanya Gudipati <kgudipat@brocade.com>
---
 aen/bfa_aen.h             |   80 ++++++
 aen/bfa_aen_adapter.h     |   29 ++
 aen/bfa_aen_audit.h       |   29 ++
 aen/bfa_aen_ethport.h     |   31 ++
 aen/bfa_aen_ioc.h         |   31 ++
 aen/bfa_aen_itnim.h       |   30 ++
 aen/bfa_aen_lport.h       |   39 ++
 aen/bfa_aen_port.h        |   39 ++
 aen/bfa_aen_rport.h       |   32 ++
 bfa.h                     |  199 +++++++++++++++
 bfa_fcpim.h               |   21 +
 bfa_svc.h                 |  260 +++++++++++++++++++
 bfa_timer.h               |   53 ++++
 bfi/bfi.h                 |  183 +++++++++++++
 bfi/bfi_boot.h            |   34 ++
 bfi/bfi_cbreg.h           |  303 +++++++++++++++++++++++
 bfi/bfi_cee.h             |  119 +++++++++
 bfi/bfi_ctreg.h           |  604 ++++++++++++++++++++++++++++++++++++++++++++++
 bfi/bfi_fabric.h          |  113 ++++++++
 bfi/bfi_fcpim.h           |  360 +++++++++++++++++++++++++++
 bfi/bfi_fcxp.h            |   71 +++++
 bfi/bfi_ioc.h             |  193 ++++++++++++++
 bfi/bfi_iocfc.h           |  150 +++++++++++
 bfi/bfi_lport.h           |   71 +++++
 bfi/bfi_lps.h             |   95 +++++++
 bfi/bfi_pport.h           |  184 ++++++++++++++
 bfi/bfi_rport.h           |  177 +++++++++++++
 bfi/bfi_uf.h              |   52 +++
 bfi/bfi_vport.h           |   67 +++++
 cna/pstats/ethport_defs.h |   36 ++
 cna/pstats/phyport_defs.h |  197 +++++++++++++++
 cs/bfa_checksum.h         |   60 ++++
 cs/bfa_debug.h            |   38 ++
 cs/bfa_log.h              |  183 +++++++++++++
 cs/bfa_perf.h             |   34 ++
 cs/bfa_plog.h             |  162 ++++++++++++
 cs/bfa_q.h                |   97 +++++++
 cs/bfa_sm.h               |   69 +++++
 cs/bfa_trc.h              |  174 +++++++++++++
 cs/bfa_wc.h               |   68 +++++
 defs/bfa_defs_adapter.h   |   82 ++++++
 defs/bfa_defs_aen.h       |   72 +++++
 defs/bfa_defs_audit.h     |   38 ++
 defs/bfa_defs_auth.h      |  112 ++++++++
 defs/bfa_defs_ethport.h   |  102 +++++++
 defs/bfa_defs_ioc.h       |  149 +++++++++++
 defs/bfa_defs_iocfc.h     |  312 +++++++++++++++++++++++
 defs/bfa_defs_ipfc.h      |   70 +++++
 defs/bfa_defs_itnim.h     |  124 +++++++++
 defs/bfa_defs_itntm.h     |  118 ++++++++
 defs/bfa_defs_lport.h     |   68 +++++
 defs/bfa_defs_mfg.h       |   58 ++++
 defs/bfa_defs_pci.h       |   41 +++
 defs/bfa_defs_pm.h        |   33 ++
 defs/bfa_defs_port.h      |  234 +++++++++++++++++
 defs/bfa_defs_pport.h     |  342 ++++++++++++++++++++++++++
 defs/bfa_defs_qos.h       |   99 +++++++
 defs/bfa_defs_rport.h     |  199 +++++++++++++++
 defs/bfa_defs_status.h    |  160 ++++++++++++
 defs/bfa_defs_types.h     |   30 ++
 defs/bfa_defs_version.h   |   22 +
 defs/bfa_defs_vf.h        |   74 +++++
 defs/bfa_defs_vport.h     |   91 ++++++
 log/bfa_log_fcs.h         |   28 ++
 log/bfa_log_hal.h         |   28 ++
 log/bfa_log_linux.h       |   44 +++
 log/bfa_log_wdrv.h        |   36 ++
 protocol/bfa_protocol.h   |  245 ++++++++++++++++++
 protocol/types.h          |   41 +++
 69 files changed, 7819 insertions(+)

diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen.h patch/drivers/scsi/bfa/include/aen/bfa_aen.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen.h	2009-03-23 15:33:14.206945000 -0700
@@ -0,0 +1,80 @@
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
+#ifndef __BFA_AEN_H__
+#define __BFA_AEN_H__
+
+#include "defs/bfa_defs_aen.h"
+
+#define BFA_AEN_MAX_ENTRY   512
+
+extern s32 bfa_aen_max_cfg_entry;
+struct bfa_aen_s {
+	void		*bfad;
+	s32		max_entry;
+	s32		write_index;
+	s32		read_index;
+	u32	bfad_num;
+	void		(*aen_cb_notify)(void *bfad);
+	void		(*gettimeofday)(struct bfa_timeval_s *tv);
+	struct bfa_trc_mod_s 	*trcmod;
+	struct bfa_aen_entry_s	list[BFA_AEN_MAX_ENTRY]; /* Must be the last */
+};
+
+
+/**
+ * Public APIs
+ */
+static inline void
+bfa_aen_set_max_cfg_entry(int max_entry)
+{
+	bfa_aen_max_cfg_entry = max_entry;
+}
+
+static inline s32
+bfa_aen_get_max_cfg_entry(void)
+{
+	return bfa_aen_max_cfg_entry;
+}
+
+static inline s32
+bfa_aen_get_meminfo(void)
+{
+	return (sizeof(struct bfa_aen_entry_s) * bfa_aen_get_max_cfg_entry());
+}
+
+static inline s32
+bfa_aen_fetch_count(struct bfa_aen_s *aen)
+{
+	return ((aen->write_index + aen->max_entry) - aen->read_index)
+		% aen->max_entry;
+}
+
+s32 bfa_aen_init(struct bfa_aen_s *aen, struct bfa_trc_mod_s *trcmod,
+		void *bfad, u32 inst_id, void (*aen_cb_notify)(void *),
+		void (*gettimeofday)(struct bfa_timeval_s *));
+
+s32 bfa_aen_post(struct bfa_aen_s *aen, enum bfa_aen_category aen_category,
+		     int aen_type, union bfa_aen_data_u *aen_data);
+
+s32 bfa_aen_fetch(struct bfa_aen_s *aen, struct bfa_aen_entry_s *aen_entry,
+		      s32 entry_space);
+
+s32 bfa_aen_get_inst(struct bfa_aen_s *aen);
+
+char *wwn2str(char *buf, int bufsize, u64 wwn);
+
+#endif /* __BFA_AEN_H__ */
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_adapter.h patch/drivers/scsi/bfa/include/aen/bfa_aen_adapter.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_adapter.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_adapter.h	2009-03-23 15:33:14.221875000 -0700
@@ -0,0 +1,29 @@
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
+/* messages define for BFA_AEN_CAT_ADAPTER Module */
+#ifndef	__bfa_aen_adapter_h__
+#define	__bfa_aen_adapter_h__
+
+#include  <cs/bfa_log.h>
+#include  <defs/bfa_defs_aen.h>
+
+#define BFA_AEN_ADAPTER_ADD  BFA_LOG_CREATE_ID(BFA_AEN_CAT_ADAPTER, BFA_ADAPTER_AEN_ADD)
+#define BFA_AEN_ADAPTER_REMOVE  BFA_LOG_CREATE_ID(BFA_AEN_CAT_ADAPTER, BFA_ADAPTER_AEN_REMOVE)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_audit.h patch/drivers/scsi/bfa/include/aen/bfa_aen_audit.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_audit.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_audit.h	2009-03-23 15:33:14.229081000 -0700
@@ -0,0 +1,29 @@
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
+/* messages define for BFA_AEN_CAT_AUDIT Module */
+#ifndef	__bfa_aen_audit_h__
+#define	__bfa_aen_audit_h__
+
+#include  <cs/bfa_log.h>
+#include  <defs/bfa_defs_aen.h>
+
+#define BFA_AEN_AUDIT_AUTH_ENABLE  BFA_LOG_CREATE_ID(BFA_AEN_CAT_AUDIT, BFA_AUDIT_AEN_AUTH_ENABLE)
+#define BFA_AEN_AUDIT_AUTH_DISABLE  BFA_LOG_CREATE_ID(BFA_AEN_CAT_AUDIT, BFA_AUDIT_AEN_AUTH_DISABLE)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_ethport.h patch/drivers/scsi/bfa/include/aen/bfa_aen_ethport.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_ethport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_ethport.h	2009-03-23 15:33:14.265700000 -0700
@@ -0,0 +1,31 @@
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
+/* messages define for BFA_AEN_CAT_ETHPORT Module */
+#ifndef	__bfa_aen_ethport_h__
+#define	__bfa_aen_ethport_h__
+
+#include  <cs/bfa_log.h>
+#include  <defs/bfa_defs_aen.h>
+
+#define BFA_AEN_ETHPORT_LINKUP  BFA_LOG_CREATE_ID(BFA_AEN_CAT_ETHPORT, BFA_ETHPORT_AEN_LINKUP)
+#define BFA_AEN_ETHPORT_LINKDOWN  BFA_LOG_CREATE_ID(BFA_AEN_CAT_ETHPORT, BFA_ETHPORT_AEN_LINKDOWN)
+#define BFA_AEN_ETHPORT_ENABLE  BFA_LOG_CREATE_ID(BFA_AEN_CAT_ETHPORT, BFA_ETHPORT_AEN_ENABLE)
+#define BFA_AEN_ETHPORT_DISABLE  BFA_LOG_CREATE_ID(BFA_AEN_CAT_ETHPORT, BFA_ETHPORT_AEN_DISABLE)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_ioc.h patch/drivers/scsi/bfa/include/aen/bfa_aen_ioc.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_ioc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_ioc.h	2009-03-23 15:33:14.214461000 -0700
@@ -0,0 +1,31 @@
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
+/* messages define for BFA_AEN_CAT_IOC Module */
+#ifndef	__bfa_aen_ioc_h__
+#define	__bfa_aen_ioc_h__
+
+#include  <cs/bfa_log.h>
+#include  <defs/bfa_defs_aen.h>
+
+#define BFA_AEN_IOC_HBGOOD  BFA_LOG_CREATE_ID(BFA_AEN_CAT_IOC, BFA_IOC_AEN_HBGOOD)
+#define BFA_AEN_IOC_HBFAIL  BFA_LOG_CREATE_ID(BFA_AEN_CAT_IOC, BFA_IOC_AEN_HBFAIL)
+#define BFA_AEN_IOC_ENABLE  BFA_LOG_CREATE_ID(BFA_AEN_CAT_IOC, BFA_IOC_AEN_ENABLE)
+#define BFA_AEN_IOC_DISABLE  BFA_LOG_CREATE_ID(BFA_AEN_CAT_IOC, BFA_IOC_AEN_DISABLE)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_itnim.h patch/drivers/scsi/bfa/include/aen/bfa_aen_itnim.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_itnim.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_itnim.h	2009-03-23 15:33:14.243613000 -0700
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
+/* messages define for BFA_AEN_CAT_ITNIM Module */
+#ifndef	__bfa_aen_itnim_h__
+#define	__bfa_aen_itnim_h__
+
+#include  <cs/bfa_log.h>
+#include  <defs/bfa_defs_aen.h>
+
+#define BFA_AEN_ITNIM_ONLINE  BFA_LOG_CREATE_ID(BFA_AEN_CAT_ITNIM, BFA_ITNIM_AEN_ONLINE)
+#define BFA_AEN_ITNIM_OFFLINE  BFA_LOG_CREATE_ID(BFA_AEN_CAT_ITNIM, BFA_ITNIM_AEN_OFFLINE)
+#define BFA_AEN_ITNIM_DISCONNECT  BFA_LOG_CREATE_ID(BFA_AEN_CAT_ITNIM, BFA_ITNIM_AEN_DISCONNECT)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_lport.h patch/drivers/scsi/bfa/include/aen/bfa_aen_lport.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_lport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_lport.h	2009-03-23 15:33:14.236317000 -0700
@@ -0,0 +1,39 @@
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
+/* messages define for BFA_AEN_CAT_LPORT Module */
+#ifndef	__bfa_aen_lport_h__
+#define	__bfa_aen_lport_h__
+
+#include  <cs/bfa_log.h>
+#include  <defs/bfa_defs_aen.h>
+
+#define BFA_AEN_LPORT_NEW  BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_NEW)
+#define BFA_AEN_LPORT_DELETE  BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_DELETE)
+#define BFA_AEN_LPORT_ONLINE  BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_ONLINE)
+#define BFA_AEN_LPORT_OFFLINE  BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_OFFLINE)
+#define BFA_AEN_LPORT_DISCONNECT  BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_DISCONNECT)
+#define BFA_AEN_LPORT_NEW_PROP  BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_NEW_PROP)
+#define BFA_AEN_LPORT_DELETE_PROP  BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_DELETE_PROP)
+#define BFA_AEN_LPORT_NEW_STANDARD  BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_NEW_STANDARD)
+#define BFA_AEN_LPORT_DELETE_STANDARD  BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_DELETE_STANDARD)
+#define BFA_AEN_LPORT_NPIV_DUP_WWN  BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_NPIV_DUP_WWN)
+#define BFA_AEN_LPORT_NPIV_FABRIC_MAX  BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_NPIV_FABRIC_MAX)
+#define BFA_AEN_LPORT_NPIV_UNKNOWN  BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_NPIV_UNKNOWN)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_port.h patch/drivers/scsi/bfa/include/aen/bfa_aen_port.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_port.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_port.h	2009-03-23 15:33:14.258321000 -0700
@@ -0,0 +1,39 @@
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
+/* messages define for BFA_AEN_CAT_PORT Module */
+#ifndef	__bfa_aen_port_h__
+#define	__bfa_aen_port_h__
+
+#include  <cs/bfa_log.h>
+#include  <defs/bfa_defs_aen.h>
+
+#define BFA_AEN_PORT_ONLINE  BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_ONLINE)
+#define BFA_AEN_PORT_OFFLINE  BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_OFFLINE)
+#define BFA_AEN_PORT_RLIR  BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_RLIR)
+#define BFA_AEN_PORT_SFP_INSERT  BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_SFP_INSERT)
+#define BFA_AEN_PORT_SFP_REMOVE  BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_SFP_REMOVE)
+#define BFA_AEN_PORT_SFP_POM  BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_SFP_POM)
+#define BFA_AEN_PORT_ENABLE  BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_ENABLE)
+#define BFA_AEN_PORT_DISABLE  BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_DISABLE)
+#define BFA_AEN_PORT_AUTH_ON  BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_AUTH_ON)
+#define BFA_AEN_PORT_AUTH_OFF  BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_AUTH_OFF)
+#define BFA_AEN_PORT_DISCONNECT  BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_DISCONNECT)
+#define BFA_AEN_PORT_QOS_NEG  BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_QOS_NEG)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_rport.h patch/drivers/scsi/bfa/include/aen/bfa_aen_rport.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_rport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_rport.h	2009-03-23 15:33:14.250927000 -0700
@@ -0,0 +1,32 @@
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
+/* messages define for BFA_AEN_CAT_RPORT Module */
+#ifndef	__bfa_aen_rport_h__
+#define	__bfa_aen_rport_h__
+
+#include  <cs/bfa_log.h>
+#include  <defs/bfa_defs_aen.h>
+
+#define BFA_AEN_RPORT_ONLINE  BFA_LOG_CREATE_ID(BFA_AEN_CAT_RPORT, BFA_RPORT_AEN_ONLINE)
+#define BFA_AEN_RPORT_OFFLINE  BFA_LOG_CREATE_ID(BFA_AEN_CAT_RPORT, BFA_RPORT_AEN_OFFLINE)
+#define BFA_AEN_RPORT_DISCONNECT  BFA_LOG_CREATE_ID(BFA_AEN_CAT_RPORT, BFA_RPORT_AEN_DISCONNECT)
+#define BFA_AEN_RPORT_QOS_PRIO  BFA_LOG_CREATE_ID(BFA_AEN_CAT_RPORT, BFA_RPORT_AEN_QOS_PRIO)
+#define BFA_AEN_RPORT_QOS_FLOWID  BFA_LOG_CREATE_ID(BFA_AEN_CAT_RPORT, BFA_RPORT_AEN_QOS_FLOWID)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/bfa.h patch/drivers/scsi/bfa/include/bfa.h
--- orig/drivers/scsi/bfa/include/bfa.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfa.h	2009-03-23 15:33:14.294858000 -0700
@@ -0,0 +1,199 @@
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
+#ifndef __BFA_H__
+#define __BFA_H__
+
+#include <bfa_os_inc.h>
+#include <cs/bfa_debug.h>
+#include <cs/bfa_q.h>
+#include <cs/bfa_trc.h>
+#include <cs/bfa_log.h>
+#include <cs/bfa_plog.h>
+#include <defs/bfa_defs_status.h>
+#include <defs/bfa_defs_ioc.h>
+#include <defs/bfa_defs_iocfc.h>
+#include <aen/bfa_aen.h>
+#include <bfi/bfi.h>
+
+struct bfa_s;
+#include <bfa_intr_priv.h>
+
+/**
+ * BFA interrupt return enums
+ */
+enum bfa_isr_status {
+	BFA_ISR_NOTCLAIMED = 1,		/*  interrupt not ours */
+	BFA_ISR_CLAIMED_COMP = 2,	/*  claimed; completions pending */
+	BFA_ISR_CLAIMED_NO_COMP = 3,	/*  claimed; no completions */
+};
+
+struct bfa_pcidev_s;
+
+/**
+ * PCI devices supported by the current BFA
+ */
+struct bfa_pciid_s {
+	u16        device_id;
+	u16        vendor_id;
+};
+
+extern char     bfa_version[];
+
+/**
+ * BFA Power Mgmt Commands
+ */
+enum bfa_pm_cmd {
+	BFA_PM_CTL_D0 = 0,
+	BFA_PM_CTL_D1 = 1,
+	BFA_PM_CTL_D2 = 2,
+	BFA_PM_CTL_D3 = 3,
+};
+
+/**
+ * BFA memory resources
+ */
+enum bfa_mem_type {
+	BFA_MEM_TYPE_KVA = 1,	/*! Kernel Virtual Memory *(non-dma-able) */
+	BFA_MEM_TYPE_DMA = 2,	/*! DMA-able memory */
+	BFA_MEM_TYPE_MAX = BFA_MEM_TYPE_DMA,
+};
+
+struct bfa_mem_elem_s {
+	enum bfa_mem_type mem_type;	/*  see enum bfa_mem_type 	*/
+	u32        mem_len;	/*  Total Length in Bytes	*/
+	u8       	*kva;		/*  kernel virtual address	*/
+	u64        dma;		/*  dma address if DMA memory	*/
+	u8       	*kva_curp;	/*  kva allocation cursor	*/
+	u64        dma_curp;	/*  dma allocation cursor	*/
+};
+#define BFA_OS_STR_LEN 64
+struct bfa_driver_info_s {
+    u8  version[BFA_VERSION_LEN];      /*  Driver Version */
+    u8  host_machine_name[BFA_OS_STR_LEN];
+    u8  host_os_name[BFA_OS_STR_LEN]; /*  OS name and version */
+    u8  host_os_patch[BFA_OS_STR_LEN];/*  patch or service pack */
+    u8  os_device_name[BFA_OS_STR_LEN]; /*  Driver Device Name */
+};
+
+
+struct bfa_meminfo_s {
+	struct bfa_mem_elem_s meminfo[BFA_MEM_TYPE_MAX];
+};
+#define bfa_meminfo_kva(_m)	\
+	(_m)->meminfo[BFA_MEM_TYPE_KVA - 1].kva_curp
+#define bfa_meminfo_dma_virt(_m)	\
+	(_m)->meminfo[BFA_MEM_TYPE_DMA - 1].kva_curp
+#define bfa_meminfo_dma_phys(_m)	\
+	(_m)->meminfo[BFA_MEM_TYPE_DMA - 1].dma_curp
+
+/**
+ * Generic Scatter Gather Element used by driver
+ */
+struct bfa_sge_s {
+	u32        sg_len;
+	void           *sg_addr;
+};
+
+#define bfa_sge_to_be(__sge) do {                                          \
+	((u32 *)(__sge))[0] = bfa_os_htonl(((u32 *)(__sge))[0]);      \
+	((u32 *)(__sge))[1] = bfa_os_htonl(((u32 *)(__sge))[1]);      \
+	((u32 *)(__sge))[2] = bfa_os_htonl(((u32 *)(__sge))[2]);      \
+} while (0)
+
+
+/*
+ * bfa stats interfaces
+ */
+#define bfa_stats(_mod, _stats)	(_mod)->stats._stats ++
+
+#define bfa_ioc_get_stats(__bfa, __ioc_stats)	\
+	bfa_ioc_fetch_stats(&(__bfa)->ioc, __ioc_stats)
+#define bfa_ioc_clear_stats(__bfa)	\
+	bfa_ioc_clr_stats(&(__bfa)->ioc)
+
+/*
+ * bfa API functions
+ */
+void bfa_get_pciids(struct bfa_pciid_s **pciids, int *npciids);
+void bfa_cfg_get_default(struct bfa_iocfc_cfg_s *cfg);
+void bfa_cfg_get_min(struct bfa_iocfc_cfg_s *cfg);
+void bfa_cfg_get_meminfo(struct bfa_iocfc_cfg_s *cfg,
+			struct bfa_meminfo_s *meminfo);
+void bfa_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+			struct bfa_meminfo_s *meminfo,
+			struct bfa_pcidev_s *pcidev);
+void bfa_init_trc(struct bfa_s *bfa, struct bfa_trc_mod_s *trcmod);
+void bfa_init_log(struct bfa_s *bfa, struct bfa_log_mod_s *logmod);
+void bfa_init_aen(struct bfa_s *bfa, struct bfa_aen_s *aen);
+void bfa_init_plog(struct bfa_s *bfa, struct bfa_plog_s *plog);
+void bfa_detach(struct bfa_s *bfa);
+void bfa_init(struct bfa_s *bfa);
+void bfa_start(struct bfa_s *bfa);
+void bfa_stop(struct bfa_s *bfa);
+void bfa_cb_init(void *bfad, bfa_status_t status);
+void bfa_cb_stop(void *bfad, bfa_status_t status);
+
+void bfa_msix_getvecs(struct bfa_s *bfa, u32 *msix_vecs_bmap,
+			u32 *num_vecs, u32 *max_vec_bit);
+enum bfa_isr_status bfa_intx(struct bfa_s *bfa);
+enum bfa_isr_status bfa_msix_reqq(struct bfa_s *bfa, int qid);
+enum bfa_isr_status bfa_msix_rspq(struct bfa_s *bfa, int qid);
+enum bfa_isr_status bfa_msix_lpu(struct bfa_s *bfa);
+enum bfa_isr_status bfa_msix_errint(struct bfa_s *bfa);
+void bfa_isr_enable(struct bfa_s *bfa);
+void bfa_isr_disable(struct bfa_s *bfa);
+
+void bfa_comp_deq(struct bfa_s *bfa, struct list_head *comp_q);
+void bfa_comp_process(struct bfa_s *bfa, struct list_head *comp_q);
+void bfa_comp_free(struct bfa_s *bfa, struct list_head *comp_q);
+
+typedef void (*bfa_cb_ioc_t) (void *cbarg, enum bfa_status status);
+void bfa_iocfc_get_attr(struct bfa_s *bfa, struct bfa_iocfc_attr_s *attr);
+bfa_status_t bfa_iocfc_get_stats(struct bfa_s *bfa,
+			struct bfa_iocfc_stats_s *stats,
+			bfa_cb_ioc_t cbfn, void *cbarg);
+bfa_status_t bfa_iocfc_clear_stats(struct bfa_s *bfa,
+			bfa_cb_ioc_t cbfn, void *cbarg);
+void bfa_get_attr(struct bfa_s *bfa, struct bfa_ioc_attr_s *ioc_attr);
+
+void bfa_adapter_get_attr(struct bfa_s *bfa,
+			struct bfa_adapter_attr_s *ad_attr);
+u64 bfa_adapter_get_id(struct bfa_s *bfa);
+
+bfa_status_t bfa_iocfc_israttr_set(struct bfa_s *bfa,
+			struct bfa_iocfc_intr_attr_s *attr);
+
+bfa_status_t bfa_iocfc_enable(struct bfa_s *bfa);
+void bfa_iocfc_disable(struct bfa_s *bfa);
+void bfa_ioc_auto_recover(bfa_boolean_t auto_recover);
+void bfa_cb_ioc_disable(void *bfad);
+void bfa_timer_tick(struct bfa_s *bfa);
+void bfa_driver_info_init(struct bfa_s *bfa,
+			struct bfa_driver_info_s *driver_info);
+
+#define bfa_timer_start(_bfa, _timer, _timercb, _arg, _timeout)	\
+	bfa_timer_begin(&(_bfa)->timer_mod, _timer, _timercb, _arg, _timeout)
+
+/*
+ * BFA debug API functions
+ */
+bfa_status_t bfa_debug_fwtrc(struct bfa_s *bfa, void *trcdata, int *trclen);
+bfa_status_t bfa_debug_fwsave(struct bfa_s *bfa, void *trcdata, int *trclen);
+
+#include "bfa_priv.h"
+
+#endif /* __BFA_H__ */
diff -urpN orig/drivers/scsi/bfa/include/bfa_fcpim.h patch/drivers/scsi/bfa/include/bfa_fcpim.h
--- orig/drivers/scsi/bfa/include/bfa_fcpim.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfa_fcpim.h	2009-03-23 15:33:14.302908000 -0700
@@ -0,0 +1,21 @@
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
+ *  Contents moved to /src/bfa/include/bfa_fcpim.h header file
+ *  We'll have one header file per module
+ */
diff -urpN orig/drivers/scsi/bfa/include/bfa_svc.h patch/drivers/scsi/bfa/include/bfa_svc.h
--- orig/drivers/scsi/bfa/include/bfa_svc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfa_svc.h	2009-03-23 15:33:14.310387000 -0700
@@ -0,0 +1,260 @@
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
+#ifndef __BFA_SVC_H__
+#define __BFA_SVC_H__
+
+/*
+ * forward declarations
+ */
+struct bfa_fcxp_s;
+
+#include <defs/bfa_defs_status.h>
+#include <defs/bfa_defs_pport.h>
+#include <defs/bfa_defs_rport.h>
+#include <defs/bfa_defs_qos.h>
+#include <cs/bfa_sm.h>
+#include <bfa.h>
+
+/**
+ * Send completion callback.
+ */
+typedef void (*bfa_cb_fcxp_send_t) (void *bfad_fcxp, struct bfa_fcxp_s *fcxp,
+			void *cbarg, enum bfa_status req_status,
+			u32 rsp_len, u32 resid_len,
+			struct fchs_s *rsp_fchs);
+
+/**
+ * BFA fcxp allocation (asynchronous)
+ */
+typedef void (*bfa_fcxp_alloc_cbfn_t) (void *cbarg, struct bfa_fcxp_s *fcxp);
+
+struct bfa_fcxp_wqe_s {
+	struct list_head         qe;
+	bfa_fcxp_alloc_cbfn_t  alloc_cbfn;
+	void           *alloc_cbarg;
+};
+
+typedef u64 (*bfa_fcxp_get_sgaddr_t) (void *bfad_fcxp, int sgeid);
+typedef u32 (*bfa_fcxp_get_sglen_t) (void *bfad_fcxp, int sgeid);
+
+#define BFA_UF_BUFSZ	(2 * 1024 + 256)
+
+/**
+ * @todo private
+ */
+struct bfa_uf_buf_s {
+	u8         d[BFA_UF_BUFSZ];
+};
+
+
+struct bfa_uf_s {
+	struct list_head         qe;		/*  queue element	  */
+	struct bfa_s      	*bfa;		/*  bfa instance	  */
+	u16        uf_tag;		/*  identifying tag f/w messages */
+	u16        vf_id;
+	u16        src_rport_handle;
+	u16        rsvd;
+	u8        	*data_ptr;
+	u16        data_len;	/*  actual receive length	  */
+	u16        pb_len;		/*  posted buffer length	  */
+	void           	*buf_kva;	/*  buffer virtual address	  */
+	u64        buf_pa;		/*  buffer physical address	  */
+	struct bfa_cb_qe_s    hcb_qe;	/*  comp: BFA comp qelem	  */
+	struct bfa_sge_s   	sges[BFI_SGE_INLINE_MAX];
+};
+
+typedef void (*bfa_cb_pport_t) (void *cbarg, enum bfa_status status);
+
+/**
+ * bfa lport login/logout service interface
+ */
+struct bfa_lps_s {
+	struct list_head  qe;		/*  queue element		*/
+	struct bfa_s	*bfa;		/*  parent bfa instance	*/
+	bfa_sm_t	sm;		/*  finite state machine	*/
+	u8		lp_tag;		/*  lport tag			*/
+	u8		reqq;		/*  lport request queue	*/
+	u8		alpa;		/*  ALPA for loop topologies	*/
+	u32	lp_pid;		/*  lport port ID		*/
+	bfa_boolean_t	fdisc;		/*  send FDISC instead of FLOGI*/
+	bfa_boolean_t	auth_en;	/*  enable authentication	*/
+	bfa_boolean_t	auth_req;	/*  authentication required	*/
+	bfa_boolean_t	npiv_en;	/*  NPIV is allowed by peer	*/
+	bfa_boolean_t	fport;		/*  attached peer is F_PORT	*/
+	bfa_boolean_t	brcd_switch;/*  attached peer is brcd switch	*/
+	bfa_status_t	status;		/*  login status		*/
+	u16	pdusz;		/*  max receive PDU size 	*/
+	u16	pr_bbcred;	/*  BB_CREDIT from peer 	*/
+	u8		lsrjt_rsn;	/*  LSRJT reason		*/
+	u8		lsrjt_expl;	/*  LSRJT explanation		*/
+	wwn_t		pwwn;		/*  port wwn of lport		*/
+	wwn_t		nwwn;		/*  node wwn of lport		*/
+	wwn_t		pr_pwwn;	/*  port wwn of lport peer	*/
+	wwn_t		pr_nwwn;	/*  node wwn of lport peer	*/
+	struct mac_s	lp_mac;		/*  fpma/spma MAC for lport	*/
+	struct mac_s	fcf_mac;	/*  FCF MAC of lport		*/
+	struct bfa_reqq_wait_s	wqe;	/*  request wait queue element	*/
+	void		*uarg;		/*  user callback arg		*/
+	struct bfa_cb_qe_s hcb_qe;	/*  comp: callback qelem	*/
+	struct bfi_lps_login_rsp_s *loginrsp;
+};
+
+/*
+ * bfa pport API functions
+ */
+bfa_status_t bfa_pport_enable(struct bfa_s *bfa);
+bfa_status_t bfa_pport_disable(struct bfa_s *bfa);
+bfa_status_t bfa_pport_cfg_speed(struct bfa_s *bfa,
+			enum bfa_pport_speed speed);
+enum bfa_pport_speed bfa_pport_get_speed(struct bfa_s *bfa);
+bfa_status_t bfa_pport_cfg_topology(struct bfa_s *bfa,
+			enum bfa_pport_topology topo);
+enum bfa_pport_topology bfa_pport_get_topology(struct bfa_s *bfa);
+bfa_status_t bfa_pport_cfg_hardalpa(struct bfa_s *bfa, u8 alpa);
+bfa_boolean_t bfa_pport_get_hardalpa(struct bfa_s *bfa, u8 *alpa);
+u8 bfa_pport_get_myalpa(struct bfa_s *bfa);
+bfa_status_t bfa_pport_clr_hardalpa(struct bfa_s *bfa);
+bfa_status_t bfa_pport_cfg_maxfrsize(struct bfa_s *bfa, u16 maxsize);
+u16 bfa_pport_get_maxfrsize(struct bfa_s *bfa);
+u32 bfa_pport_mypid(struct bfa_s *bfa);
+u8 bfa_pport_get_rx_bbcredit(struct bfa_s *bfa);
+bfa_status_t bfa_pport_trunk_enable(struct bfa_s *bfa, u8 bitmap);
+bfa_status_t bfa_pport_trunk_disable(struct bfa_s *bfa);
+bfa_boolean_t bfa_pport_trunk_query(struct bfa_s *bfa, u32 *bitmap);
+void bfa_pport_get_attr(struct bfa_s *bfa, struct bfa_pport_attr_s *attr);
+wwn_t bfa_pport_get_wwn(struct bfa_s *bfa, bfa_boolean_t node);
+bfa_status_t bfa_pport_get_stats(struct bfa_s *bfa,
+			struct bfa_pport_stats_s *stats,
+			bfa_cb_pport_t cbfn, void *cbarg);
+bfa_status_t bfa_pport_clear_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn,
+			void *cbarg);
+void bfa_pport_event_register(struct bfa_s *bfa,
+			void (*event_cbfn) (void *cbarg,
+			bfa_pport_event_t event), void *event_cbarg);
+bfa_boolean_t bfa_pport_is_disabled(struct bfa_s *bfa);
+void bfa_pport_cfg_qos(struct bfa_s *bfa, bfa_boolean_t on_off);
+void bfa_pport_cfg_ratelim(struct bfa_s *bfa, bfa_boolean_t on_off);
+bfa_status_t bfa_pport_cfg_ratelim_speed(struct bfa_s *bfa,
+			enum bfa_pport_speed speed);
+enum bfa_pport_speed bfa_pport_get_ratelim_speed(struct bfa_s *bfa);
+
+void bfa_pport_set_tx_bbcredit(struct bfa_s *bfa, u16 tx_bbcredit);
+void bfa_pport_busy(struct bfa_s *bfa, bfa_boolean_t status);
+void bfa_pport_beacon(struct bfa_s *bfa, bfa_boolean_t beacon,
+			bfa_boolean_t link_e2e_beacon);
+void bfa_cb_pport_event(void *cbarg, bfa_pport_event_t event);
+void bfa_pport_qos_get_attr(struct bfa_s *bfa, struct bfa_qos_attr_s *qos_attr);
+void bfa_pport_qos_get_vc_attr(struct bfa_s *bfa,
+			struct bfa_qos_vc_attr_s *qos_vc_attr);
+bfa_status_t bfa_pport_get_qos_stats(struct bfa_s *bfa,
+			struct bfa_pport_stats_s *stats,
+			bfa_cb_pport_t cbfn, void *cbarg);
+bfa_status_t bfa_pport_clear_qos_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn,
+			void *cbarg);
+bfa_boolean_t     bfa_pport_is_ratelim(struct bfa_s *bfa);
+
+/*
+ * bfa fcxp API functions
+ */
+struct bfa_fcxp_s *bfa_fcxp_alloc(void *bfad_fcxp, struct bfa_s *bfa,
+			int nreq_sgles, int nrsp_sgles,
+			bfa_fcxp_get_sgaddr_t get_req_sga,
+			bfa_fcxp_get_sglen_t get_req_sglen,
+			bfa_fcxp_get_sgaddr_t get_rsp_sga,
+			bfa_fcxp_get_sglen_t get_rsp_sglen);
+void bfa_fcxp_alloc_wait(struct bfa_s *bfa, struct bfa_fcxp_wqe_s *wqe,
+			bfa_fcxp_alloc_cbfn_t alloc_cbfn, void *cbarg);
+void bfa_fcxp_walloc_cancel(struct bfa_s *bfa,
+			struct bfa_fcxp_wqe_s *wqe);
+void bfa_fcxp_discard(struct bfa_fcxp_s *fcxp);
+
+void *bfa_fcxp_get_reqbuf(struct bfa_fcxp_s *fcxp);
+void *bfa_fcxp_get_rspbuf(struct bfa_fcxp_s *fcxp);
+
+void bfa_fcxp_free(struct bfa_fcxp_s *fcxp);
+#include <bfa_rport.h>
+void bfa_fcxp_send(struct bfa_fcxp_s *fcxp,
+			struct bfa_rport_s *rport, u16 vf_id,
+			bfa_boolean_t cts, enum fc_cos cos,
+			u32 reqlen, struct fchs_s *fchs,
+			bfa_cb_fcxp_send_t cbfn,
+			void *cbarg,
+			u32 rsp_maxlen, u8 rsp_timeout);
+bfa_status_t bfa_fcxp_abort(struct bfa_fcxp_s *fcxp);
+u32        bfa_fcxp_get_reqbufsz(struct bfa_fcxp_s *fcxp);
+u32	bfa_fcxp_get_maxrsp(struct bfa_s *bfa);
+
+static inline void *
+bfa_uf_get_frmbuf(struct bfa_uf_s *uf)
+{
+	return uf->data_ptr;
+}
+
+static inline   u16
+bfa_uf_get_frmlen(struct bfa_uf_s *uf)
+{
+	return uf->data_len;
+}
+
+/**
+ *      Callback prototype for unsolicited frame receive handler.
+ *
+ * @param[in]           cbarg           callback arg for receive handler
+ * @param[in]           uf              unsolicited frame descriptor
+ *
+ * @return None
+ */
+typedef void (*bfa_cb_uf_recv_t) (void *cbarg, struct bfa_uf_s *uf);
+
+/*
+ * bfa uf API functions
+ */
+void bfa_uf_recv_register(struct bfa_s *bfa, bfa_cb_uf_recv_t ufrecv,
+			void *cbarg);
+void bfa_uf_free(struct bfa_uf_s *uf);
+
+/**
+ * bfa lport service api
+ */
+
+struct bfa_lps_s *bfa_lps_alloc(struct bfa_s *bfa);
+void bfa_lps_delete(struct bfa_lps_s *lps);
+void bfa_lps_discard(struct bfa_lps_s *lps);
+void bfa_lps_flogi(struct bfa_lps_s *lps, void *uarg, u8 alpa, u16 pdusz,
+		   wwn_t pwwn, wwn_t nwwn, bfa_boolean_t auth_en);
+void bfa_lps_fdisc(struct bfa_lps_s *lps, void *uarg, u16 pdusz, wwn_t pwwn,
+		   wwn_t nwwn);
+void bfa_lps_flogo(struct bfa_lps_s *lps);
+void bfa_lps_fdisclogo(struct bfa_lps_s *lps);
+u8 bfa_lps_get_tag(struct bfa_lps_s *lps);
+bfa_boolean_t bfa_lps_is_npiv_en(struct bfa_lps_s *lps);
+bfa_boolean_t bfa_lps_is_fport(struct bfa_lps_s *lps);
+bfa_boolean_t bfa_lps_is_brcd_fabric(struct bfa_lps_s *lps);
+bfa_boolean_t bfa_lps_is_authreq(struct bfa_lps_s *lps);
+u32 bfa_lps_get_pid(struct bfa_lps_s *lps);
+u16 bfa_lps_get_peer_bbcredit(struct bfa_lps_s *lps);
+wwn_t bfa_lps_get_peer_pwwn(struct bfa_lps_s *lps);
+wwn_t bfa_lps_get_peer_nwwn(struct bfa_lps_s *lps);
+u8 bfa_lps_get_lsrjt_rsn(struct bfa_lps_s *lps);
+u8 bfa_lps_get_lsrjt_expl(struct bfa_lps_s *lps);
+void bfa_cb_lps_flogi_comp(void *bfad, void *uarg, bfa_status_t status);
+void bfa_cb_lps_flogo_comp(void *bfad, void *uarg);
+void bfa_cb_lps_fdisc_comp(void *bfad, void *uarg, bfa_status_t status);
+void bfa_cb_lps_fdisclogo_comp(void *bfad, void *uarg);
+
+#endif /* __BFA_SVC_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfa_timer.h patch/drivers/scsi/bfa/include/bfa_timer.h
--- orig/drivers/scsi/bfa/include/bfa_timer.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfa_timer.h	2009-03-23 15:33:14.317877000 -0700
@@ -0,0 +1,53 @@
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
+#ifndef __BFA_TIMER_H__
+#define __BFA_TIMER_H__
+
+#include <bfa_os_inc.h>
+#include <cs/bfa_q.h>
+
+struct bfa_s;
+
+typedef void (*bfa_timer_cbfn_t)(void *);
+
+/**
+ * BFA timer data structure
+ */
+struct bfa_timer_s {
+	struct list_head	qe;
+	bfa_timer_cbfn_t timercb;
+	void            *arg;
+	int             timeout;	/**< in millisecs. */
+};
+
+/**
+ * Timer module structure
+ */
+struct bfa_timer_mod_s {
+	struct list_head timer_q;
+};
+
+#define BFA_TIMER_FREQ 500 /**< specified in millisecs */
+
+void bfa_timer_beat(struct bfa_timer_mod_s *mod);
+void bfa_timer_init(struct bfa_timer_mod_s *mod);
+void bfa_timer_begin(struct bfa_timer_mod_s *mod, struct bfa_timer_s *timer,
+			bfa_timer_cbfn_t timercb, void *arg,
+			unsigned int timeout);
+void bfa_timer_stop(struct bfa_timer_s *timer);
+
+#endif /* __BFA_TIMER_H__ */
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi.h patch/drivers/scsi/bfa/include/bfi/bfi.h
--- orig/drivers/scsi/bfa/include/bfi/bfi.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi.h	2009-03-23 15:33:14.033795000 -0700
@@ -0,0 +1,183 @@
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
+#ifndef __BFI_H__
+#define __BFI_H__
+
+#include <bfa_os_inc.h>
+#include <defs/bfa_defs_status.h>
+
+#pragma pack(1)
+
+/**
+ * Msg header common to all msgs
+ */
+struct bfi_mhdr_s {
+	u8         msg_class;	/*  @ref bfi_mclass_t	    */
+	u8         msg_id;		/*  msg opcode with in the class   */
+	union {
+		struct {
+			u8         rsvd;
+			u8         lpu_id;	/*  msg destination	    */
+		} h2i;
+		u16        i2htok;	/*  token in msgs to host	    */
+	} mtag;
+};
+
+#define bfi_h2i_set(_mh, _mc, _op, _lpuid) do {		\
+	(_mh).msg_class 		= (_mc);      \
+	(_mh).msg_id			= (_op);      \
+	(_mh).mtag.h2i.lpu_id	= (_lpuid);      \
+} while (0)
+
+#define bfi_i2h_set(_mh, _mc, _op, _i2htok) do {		\
+	(_mh).msg_class 		= (_mc);      \
+	(_mh).msg_id			= (_op);      \
+	(_mh).mtag.i2htok		= (_i2htok);      \
+} while (0)
+
+/*
+ * Message opcodes: 0-127 to firmware, 128-255 to host
+ */
+#define BFI_I2H_OPCODE_BASE	128
+#define BFA_I2HM(_x) 			((_x) + BFI_I2H_OPCODE_BASE)
+
+/**
+ ****************************************************************************
+ *
+ * Scatter Gather Element and Page definition
+ *
+ ****************************************************************************
+ */
+
+#define BFI_SGE_INLINE	1
+#define BFI_SGE_INLINE_MAX	(BFI_SGE_INLINE + 1)
+
+/**
+ * SG Flags
+ */
+enum {
+	BFI_SGE_DATA	= 0,	/*  data address, not last	     */
+	BFI_SGE_DATA_CPL	= 1,	/*  data addr, last in current page */
+	BFI_SGE_DATA_LAST	= 3,	/*  data address, last		     */
+	BFI_SGE_LINK	= 2,	/*  link address		     */
+	BFI_SGE_PGDLEN	= 2,	/*  cumulative data length for page */
+};
+
+/**
+ * DMA addresses
+ */
+union bfi_addr_u {
+	struct {
+		u32        addr_lo;
+		u32        addr_hi;
+	} a32;
+};
+
+/**
+ * Scatter Gather Element
+ */
+struct bfi_sge_s {
+#ifdef __BIGENDIAN
+	u32        flags	: 2,
+			rsvd	: 2,
+			sg_len	: 28;
+#else
+	u32        sg_len	: 28,
+			rsvd	: 2,
+			flags	: 2;
+#endif
+	union bfi_addr_u sga;
+};
+
+/**
+ * Scatter Gather Page
+ */
+#define BFI_SGPG_DATA_SGES		7
+#define BFI_SGPG_SGES_MAX		(BFI_SGPG_DATA_SGES + 1)
+#define BFI_SGPG_RSVD_WD_LEN	8
+struct bfi_sgpg_s {
+	struct bfi_sge_s sges[BFI_SGPG_SGES_MAX];
+	u32	rsvd[BFI_SGPG_RSVD_WD_LEN];
+};
+
+/*
+ * Large Message structure - 128 Bytes size Msgs
+ */
+#define BFI_LMSG_SZ		128
+#define BFI_LMSG_PL_WSZ	\
+			((BFI_LMSG_SZ - sizeof(struct bfi_mhdr_s)) / 4)
+
+struct bfi_msg_s {
+	struct bfi_mhdr_s mhdr;
+	u32	pl[BFI_LMSG_PL_WSZ];
+};
+
+/**
+ * Mailbox message structure
+ */
+#define BFI_MBMSG_SZ		7
+struct bfi_mbmsg_s {
+	struct bfi_mhdr_s	mh;
+	u32		pl[BFI_MBMSG_SZ];
+};
+
+/**
+ * Message Classes
+ */
+enum bfi_mclass {
+	BFI_MC_IOC		= 1,	/*  IO Controller (IOC)	    */
+	BFI_MC_DIAG		= 2,	/*  Diagnostic Msgs		    */
+	BFI_MC_FLASH		= 3,	/*  Flash message class	    */
+	BFI_MC_CEE		= 4,
+	BFI_MC_FC_PORT		= 5,	/*  FC port		   	    */
+	BFI_MC_IOCFC		= 6,	/*  FC - IO Controller (IOC)	    */
+	BFI_MC_LL		= 7,	/*  Link Layer		 	    */
+	BFI_MC_UF		= 8,	/*  Unsolicited frame receive	    */
+	BFI_MC_FCXP		= 9,	/*  FC Transport		    */
+	BFI_MC_LPS		= 10,	/*  lport fc login services	    */
+	BFI_MC_RPORT		= 11,	/*  Remote port		    */
+	BFI_MC_ITNIM		= 12,	/*  I-T nexus (Initiator mode)	    */
+	BFI_MC_IOIM_READ	= 13,	/*  read IO (Initiator mode)	    */
+	BFI_MC_IOIM_WRITE	= 14,	/*  write IO (Initiator mode)	    */
+	BFI_MC_IOIM_IO		= 15,	/*  IO (Initiator mode)	    */
+	BFI_MC_IOIM		= 16,	/*  IO (Initiator mode)	    */
+	BFI_MC_IOIM_IOCOM	= 17,	/*  good IO completion		    */
+	BFI_MC_TSKIM		= 18,	/*  Initiator Task management	    */
+	BFI_MC_SBOOT		= 19,	/*  SAN boot services		    */
+	BFI_MC_IPFC		= 20,	/*  IP over FC Msgs		    */
+	BFI_MC_FABRIC		= 21,	/*  fabric services		    */
+	BFI_MC_LPORT		= 22,	/*  logical port services	    */
+	BFI_MC_ITNTM		= 23,	/*  I-T nexus (Target mode)	    */
+	BFI_MC_IOTM_READ	= 24,	/*  read IO (Target mode)	    */
+	BFI_MC_IOTM_WRITE	= 25,	/*  write IO (Target mode)	    */
+	BFI_MC_IOTM_IO		= 26,	/*  IO (Target mode)	            */
+	BFI_MC_IOTM_IOCOM	= 27,	/*  Good IO completion (Tgt Mode)  */
+	BFI_MC_IOTM		= 28,	/*  IO (Target mode)	            */
+	BFI_MC_TSKTM		= 29,	/*  Target Task management	    */
+	BFI_MC_SB		= 30,	/*  Single Byte Command Code Set   */
+	BFI_MC_VPORT		= 31,
+	BFI_MC_MAX		= 32,
+};
+
+#define BFI_IOC_MAX_CQS		4
+#define BFI_IOC_MSGLEN_MAX	32	/* 32 bytes */
+
+#pragma pack()
+
+#endif /* __BFI_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_boot.h patch/drivers/scsi/bfa/include/bfi/bfi_boot.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_boot.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_boot.h	2009-03-23 15:33:14.042673000 -0700
@@ -0,0 +1,34 @@
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
+/*
+ * bfi_boot.h
+ */
+
+#ifndef __BFI_BOOT_H__
+#define __BFI_BOOT_H__
+
+#define BFI_BOOT_TYPE_OFF		8
+#define BFI_BOOT_PARAM_OFF		12
+
+#define BFI_BOOT_TYPE_NORMAL 		0	/* param is device id */
+#define	BFI_BOOT_TYPE_FLASH		1
+#define	BFI_BOOT_TYPE_MEMTEST		2
+
+#define BFI_BOOT_MEMTEST_RES_ADDR   0x900
+#define BFI_BOOT_MEMTEST_RES_SIG    0xA0A1A2A3
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_cbreg.h patch/drivers/scsi/bfa/include/bfi/bfi_cbreg.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_cbreg.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_cbreg.h	2009-03-23 15:33:14.051331000 -0700
@@ -0,0 +1,303 @@
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
+ * bfi_cbreg.h crossbow host block register definitions
+ *
+ * !!! Do not edit. Auto generated. !!!
+ */
+
+#ifndef __BFI_CBREG_H__
+#define __BFI_CBREG_H__
+
+
+#define HOSTFN0_INT_STATUS               0x00014000
+#define __HOSTFN0_INT_STATUS_LVL_MK      0x00f00000
+#define __HOSTFN0_INT_STATUS_LVL_SH      20
+#define __HOSTFN0_INT_STATUS_LVL(_v)     ((_v) << __HOSTFN0_INT_STATUS_LVL_SH)
+#define __HOSTFN0_INT_STATUS_P           0x000fffff
+#define HOSTFN0_INT_MSK                  0x00014004
+#define HOST_PAGE_NUM_FN0                0x00014008
+#define __HOST_PAGE_NUM_FN               0x000001ff
+#define HOSTFN1_INT_STATUS               0x00014100
+#define __HOSTFN1_INT_STAT_LVL_MK        0x00f00000
+#define __HOSTFN1_INT_STAT_LVL_SH        20
+#define __HOSTFN1_INT_STAT_LVL(_v)       ((_v) << __HOSTFN1_INT_STAT_LVL_SH)
+#define __HOSTFN1_INT_STAT_P             0x000fffff
+#define HOSTFN1_INT_MSK                  0x00014104
+#define HOST_PAGE_NUM_FN1                0x00014108
+#define APP_PLL_400_CTL_REG              0x00014204
+#define __P_400_PLL_LOCK                 0x80000000
+#define __APP_PLL_400_SRAM_USE_100MHZ    0x00100000
+#define __APP_PLL_400_RESET_TIMER_MK     0x000e0000
+#define __APP_PLL_400_RESET_TIMER_SH     17
+#define __APP_PLL_400_RESET_TIMER(_v)    ((_v) << __APP_PLL_400_RESET_TIMER_SH)
+#define __APP_PLL_400_LOGIC_SOFT_RESET   0x00010000
+#define __APP_PLL_400_CNTLMT0_1_MK       0x0000c000
+#define __APP_PLL_400_CNTLMT0_1_SH       14
+#define __APP_PLL_400_CNTLMT0_1(_v)      ((_v) << __APP_PLL_400_CNTLMT0_1_SH)
+#define __APP_PLL_400_JITLMT0_1_MK       0x00003000
+#define __APP_PLL_400_JITLMT0_1_SH       12
+#define __APP_PLL_400_JITLMT0_1(_v)      ((_v) << __APP_PLL_400_JITLMT0_1_SH)
+#define __APP_PLL_400_HREF               0x00000800
+#define __APP_PLL_400_HDIV               0x00000400
+#define __APP_PLL_400_P0_1_MK            0x00000300
+#define __APP_PLL_400_P0_1_SH            8
+#define __APP_PLL_400_P0_1(_v)           ((_v) << __APP_PLL_400_P0_1_SH)
+#define __APP_PLL_400_Z0_2_MK            0x000000e0
+#define __APP_PLL_400_Z0_2_SH            5
+#define __APP_PLL_400_Z0_2(_v)           ((_v) << __APP_PLL_400_Z0_2_SH)
+#define __APP_PLL_400_RSEL200500         0x00000010
+#define __APP_PLL_400_ENARST             0x00000008
+#define __APP_PLL_400_BYPASS             0x00000004
+#define __APP_PLL_400_LRESETN            0x00000002
+#define __APP_PLL_400_ENABLE             0x00000001
+#define APP_PLL_212_CTL_REG              0x00014208
+#define __P_212_PLL_LOCK                 0x80000000
+#define __APP_PLL_212_RESET_TIMER_MK     0x000e0000
+#define __APP_PLL_212_RESET_TIMER_SH     17
+#define __APP_PLL_212_RESET_TIMER(_v)    ((_v) << __APP_PLL_212_RESET_TIMER_SH)
+#define __APP_PLL_212_LOGIC_SOFT_RESET   0x00010000
+#define __APP_PLL_212_CNTLMT0_1_MK       0x0000c000
+#define __APP_PLL_212_CNTLMT0_1_SH       14
+#define __APP_PLL_212_CNTLMT0_1(_v)      ((_v) << __APP_PLL_212_CNTLMT0_1_SH)
+#define __APP_PLL_212_JITLMT0_1_MK       0x00003000
+#define __APP_PLL_212_JITLMT0_1_SH       12
+#define __APP_PLL_212_JITLMT0_1(_v)      ((_v) << __APP_PLL_212_JITLMT0_1_SH)
+#define __APP_PLL_212_HREF               0x00000800
+#define __APP_PLL_212_HDIV               0x00000400
+#define __APP_PLL_212_P0_1_MK            0x00000300
+#define __APP_PLL_212_P0_1_SH            8
+#define __APP_PLL_212_P0_1(_v)           ((_v) << __APP_PLL_212_P0_1_SH)
+#define __APP_PLL_212_Z0_2_MK            0x000000e0
+#define __APP_PLL_212_Z0_2_SH            5
+#define __APP_PLL_212_Z0_2(_v)           ((_v) << __APP_PLL_212_Z0_2_SH)
+#define __APP_PLL_212_RSEL200500         0x00000010
+#define __APP_PLL_212_ENARST             0x00000008
+#define __APP_PLL_212_BYPASS             0x00000004
+#define __APP_PLL_212_LRESETN            0x00000002
+#define __APP_PLL_212_ENABLE             0x00000001
+#define HOST_SEM0_REG                    0x00014230
+#define __HOST_SEMAPHORE                 0x00000001
+#define HOST_SEM1_REG                    0x00014234
+#define HOST_SEM2_REG                    0x00014238
+#define HOST_SEM3_REG                    0x0001423c
+#define HOST_SEM0_INFO_REG               0x00014240
+#define HOST_SEM1_INFO_REG               0x00014244
+#define HOST_SEM2_INFO_REG               0x00014248
+#define HOST_SEM3_INFO_REG               0x0001424c
+#define HOSTFN0_LPU0_CMD_STAT            0x00019000
+#define __HOSTFN0_LPU0_MBOX_INFO_MK      0xfffffffe
+#define __HOSTFN0_LPU0_MBOX_INFO_SH      1
+#define __HOSTFN0_LPU0_MBOX_INFO(_v)     ((_v) << __HOSTFN0_LPU0_MBOX_INFO_SH)
+#define __HOSTFN0_LPU0_MBOX_CMD_STATUS   0x00000001
+#define LPU0_HOSTFN0_CMD_STAT            0x00019008
+#define __LPU0_HOSTFN0_MBOX_INFO_MK      0xfffffffe
+#define __LPU0_HOSTFN0_MBOX_INFO_SH      1
+#define __LPU0_HOSTFN0_MBOX_INFO(_v)     ((_v) << __LPU0_HOSTFN0_MBOX_INFO_SH)
+#define __LPU0_HOSTFN0_MBOX_CMD_STATUS   0x00000001
+#define HOSTFN1_LPU1_CMD_STAT            0x00019014
+#define __HOSTFN1_LPU1_MBOX_INFO_MK      0xfffffffe
+#define __HOSTFN1_LPU1_MBOX_INFO_SH      1
+#define __HOSTFN1_LPU1_MBOX_INFO(_v)     ((_v) << __HOSTFN1_LPU1_MBOX_INFO_SH)
+#define __HOSTFN1_LPU1_MBOX_CMD_STATUS   0x00000001
+#define LPU1_HOSTFN1_CMD_STAT            0x0001901c
+#define __LPU1_HOSTFN1_MBOX_INFO_MK      0xfffffffe
+#define __LPU1_HOSTFN1_MBOX_INFO_SH      1
+#define __LPU1_HOSTFN1_MBOX_INFO(_v)     ((_v) << __LPU1_HOSTFN1_MBOX_INFO_SH)
+#define __LPU1_HOSTFN1_MBOX_CMD_STATUS   0x00000001
+#define CPE_Q0_DEPTH                     0x00010014
+#define CPE_Q0_PI                        0x0001001c
+#define CPE_Q0_CI                        0x00010020
+#define CPE_Q1_DEPTH                     0x00010034
+#define CPE_Q1_PI                        0x0001003c
+#define CPE_Q1_CI                        0x00010040
+#define CPE_Q2_DEPTH                     0x00010054
+#define CPE_Q2_PI                        0x0001005c
+#define CPE_Q2_CI                        0x00010060
+#define CPE_Q3_DEPTH                     0x00010074
+#define CPE_Q3_PI                        0x0001007c
+#define CPE_Q3_CI                        0x00010080
+#define CPE_Q4_DEPTH                     0x00010094
+#define CPE_Q4_PI                        0x0001009c
+#define CPE_Q4_CI                        0x000100a0
+#define CPE_Q5_DEPTH                     0x000100b4
+#define CPE_Q5_PI                        0x000100bc
+#define CPE_Q5_CI                        0x000100c0
+#define CPE_Q6_DEPTH                     0x000100d4
+#define CPE_Q6_PI                        0x000100dc
+#define CPE_Q6_CI                        0x000100e0
+#define CPE_Q7_DEPTH                     0x000100f4
+#define CPE_Q7_PI                        0x000100fc
+#define CPE_Q7_CI                        0x00010100
+#define RME_Q0_DEPTH                     0x00011014
+#define RME_Q0_PI                        0x0001101c
+#define RME_Q0_CI                        0x00011020
+#define RME_Q1_DEPTH                     0x00011034
+#define RME_Q1_PI                        0x0001103c
+#define RME_Q1_CI                        0x00011040
+#define RME_Q2_DEPTH                     0x00011054
+#define RME_Q2_PI                        0x0001105c
+#define RME_Q2_CI                        0x00011060
+#define RME_Q3_DEPTH                     0x00011074
+#define RME_Q3_PI                        0x0001107c
+#define RME_Q3_CI                        0x00011080
+#define RME_Q4_DEPTH                     0x00011094
+#define RME_Q4_PI                        0x0001109c
+#define RME_Q4_CI                        0x000110a0
+#define RME_Q5_DEPTH                     0x000110b4
+#define RME_Q5_PI                        0x000110bc
+#define RME_Q5_CI                        0x000110c0
+#define RME_Q6_DEPTH                     0x000110d4
+#define RME_Q6_PI                        0x000110dc
+#define RME_Q6_CI                        0x000110e0
+#define RME_Q7_DEPTH                     0x000110f4
+#define RME_Q7_PI                        0x000110fc
+#define RME_Q7_CI                        0x00011100
+#define PSS_CTL_REG                      0x00018800
+#define __PSS_I2C_CLK_DIV_MK             0x00030000
+#define __PSS_I2C_CLK_DIV_SH             16
+#define __PSS_I2C_CLK_DIV(_v)            ((_v) << __PSS_I2C_CLK_DIV_SH)
+#define __PSS_LMEM_INIT_DONE             0x00001000
+#define __PSS_LMEM_RESET                 0x00000200
+#define __PSS_LMEM_INIT_EN               0x00000100
+#define __PSS_LPU1_RESET                 0x00000002
+#define __PSS_LPU0_RESET                 0x00000001
+
+
+/*
+ * These definitions are either in error/missing in spec. Its auto-generated
+ * from hard coded values in regparse.pl.
+ */
+#define __EMPHPOST_AT_4G_MK_FIX          0x0000001c
+#define __EMPHPOST_AT_4G_SH_FIX          0x00000002
+#define __EMPHPRE_AT_4G_FIX              0x00000003
+#define __SFP_TXRATE_EN_FIX              0x00000100
+#define __SFP_RXRATE_EN_FIX              0x00000080
+
+
+/*
+ * These register definitions are auto-generated from hard coded values
+ * in regparse.pl.
+ */
+#define HOSTFN0_LPU_MBOX0_0              0x00019200
+#define HOSTFN1_LPU_MBOX0_8              0x00019260
+#define LPU_HOSTFN0_MBOX0_0              0x00019280
+#define LPU_HOSTFN1_MBOX0_8              0x000192e0
+
+
+/*
+ * These register mapping definitions are auto-generated from mapping tables
+ * in regparse.pl.
+ */
+#define BFA_IOC0_HBEAT_REG               HOST_SEM0_INFO_REG
+#define BFA_IOC0_STATE_REG               HOST_SEM1_INFO_REG
+#define BFA_IOC1_HBEAT_REG               HOST_SEM2_INFO_REG
+#define BFA_IOC1_STATE_REG               HOST_SEM3_INFO_REG
+
+#define CPE_Q_DEPTH(__n) \
+	(CPE_Q0_DEPTH + (__n) * (CPE_Q1_DEPTH - CPE_Q0_DEPTH))
+#define CPE_Q_PI(__n) \
+	(CPE_Q0_PI + (__n) * (CPE_Q1_PI - CPE_Q0_PI))
+#define CPE_Q_CI(__n) \
+	(CPE_Q0_CI + (__n) * (CPE_Q1_CI - CPE_Q0_CI))
+#define RME_Q_DEPTH(__n) \
+	(RME_Q0_DEPTH + (__n) * (RME_Q1_DEPTH - RME_Q0_DEPTH))
+#define RME_Q_PI(__n) \
+	(RME_Q0_PI + (__n) * (RME_Q1_PI - RME_Q0_PI))
+#define RME_Q_CI(__n) \
+	(RME_Q0_CI + (__n) * (RME_Q1_CI - RME_Q0_CI))
+
+#define CPE_Q_NUM(__fn, __q)  (((__fn) << 2) + (__q))
+#define RME_Q_NUM(__fn, __q)  (((__fn) << 2) + (__q))
+#define CPE_Q_MASK(__q)  ((__q) & 0x3)
+#define RME_Q_MASK(__q)  ((__q) & 0x3)
+
+
+/*
+ * PCI MSI-X vector defines
+ */
+enum {
+    HFN_MSIX_CPE_Q0      = 0,
+    HFN_MSIX_CPE_Q1      = 1,
+    HFN_MSIX_CPE_Q2      = 2,
+    HFN_MSIX_CPE_Q3      = 3,
+    HFN_MSIX_CPE_Q4      = 4,
+    HFN_MSIX_CPE_Q5      = 5,
+    HFN_MSIX_CPE_Q6      = 6,
+    HFN_MSIX_CPE_Q7      = 7,
+    HFN_MSIX_RME_Q0      = 8,
+    HFN_MSIX_RME_Q1      = 9,
+    HFN_MSIX_RME_Q2      = 10,
+    HFN_MSIX_RME_Q3      = 11,
+    HFN_MSIX_RME_Q4      = 12,
+    HFN_MSIX_RME_Q5      = 13,
+    HFN_MSIX_RME_Q6      = 14,
+    HFN_MSIX_RME_Q7      = 15,
+    HFN_MSIX_ERR_EMC     = 16,
+    HFN_MSIX_ERR_LPU0    = 17,
+    HFN_MSIX_ERR_LPU1    = 18,
+    HFN_MSIX_ERR_PSS     = 19,
+    HFN_MSIX_MBOX_LPU0   = 20,
+    HFN_MSIX_MBOX_LPU1   = 21,
+    HFN_MSIX_GP_LPU0     = 22,
+    HFN_MSIX_GP_LPU1     = 23,
+};
+
+/*
+ * And corresponding host interrupt status bit field defines
+ */
+#define __HFN_INT_CPE_Q0                   0x00000001U
+#define __HFN_INT_CPE_Q1                   0x00000002U
+#define __HFN_INT_CPE_Q2                   0x00000004U
+#define __HFN_INT_CPE_Q3                   0x00000008U
+#define __HFN_INT_CPE_Q4                   0x00000010U
+#define __HFN_INT_CPE_Q5                   0x00000020U
+#define __HFN_INT_CPE_Q6                   0x00000040U
+#define __HFN_INT_CPE_Q7                   0x00000080U
+#define __HFN_INT_RME_Q0                   0x00000100U
+#define __HFN_INT_RME_Q1                   0x00000200U
+#define __HFN_INT_RME_Q2                   0x00000400U
+#define __HFN_INT_RME_Q3                   0x00000800U
+#define __HFN_INT_RME_Q4                   0x00001000U
+#define __HFN_INT_RME_Q5                   0x00002000U
+#define __HFN_INT_RME_Q6                   0x00004000U
+#define __HFN_INT_RME_Q7                   0x00008000U
+#define __HFN_INT_ERR_EMC                  0x00010000U
+#define __HFN_INT_ERR_LPU0                 0x00020000U
+#define __HFN_INT_ERR_LPU1                 0x00040000U
+#define __HFN_INT_ERR_PSS                  0x00080000U
+#define __HFN_INT_MBOX_LPU0                0x00100000U
+#define __HFN_INT_MBOX_LPU1                0x00200000U
+#define __HFN_INT_GP_LPU0                  0x00400000U
+#define __HFN_INT_GP_LPU1                  0x00800000U
+
+
+/*
+ * crossbow memory map.
+ */
+#define PSS_SMEM_PAGE_START	0x8000
+#define PSS_SMEM_PGNUM(_pg0, _ma)	((_pg0) + ((_ma) >> 15))
+#define PSS_SMEM_PGOFF(_ma)	((_ma) & 0x7fff)
+
+/*
+ * End of crossbow memory map
+ */
+
+
+#endif /* __BFI_CBREG_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_cee.h patch/drivers/scsi/bfa/include/bfi/bfi_cee.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_cee.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_cee.h	2009-03-23 15:33:14.139925000 -0700
@@ -0,0 +1,119 @@
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
+/**
+ *  Copyright (c) 2006-2009 Brocade Communications Systems, Inc.
+ *  All rights reserved.
+ *
+ *  bfi_dcbx.h BFI Interface (Mailbox commands and related structures)
+ * between host driver and DCBX/LLDP firmware module.
+ *
+**/
+
+#ifndef __BFI_CEE_H__
+#define __BFI_CEE_H__
+
+#include <bfi/bfi.h>
+
+#pragma pack(1)
+
+
+enum bfi_cee_h2i_msgs_e {
+	BFI_CEE_H2I_GET_CFG_REQ = 1,
+	BFI_CEE_H2I_RESET_STATS = 2,
+	BFI_CEE_H2I_GET_STATS_REQ = 3,
+};
+
+
+enum bfi_cee_i2h_msgs_e {
+	BFI_CEE_I2H_GET_CFG_RSP = BFA_I2HM(1),
+	BFI_CEE_I2H_RESET_STATS_RSP = BFA_I2HM(2),
+	BFI_CEE_I2H_GET_STATS_RSP = BFA_I2HM(3),
+};
+
+
+/* Data structures */
+
+/*
+ * BFI_CEE_H2I_RESET_STATS
+ */
+struct bfi_lldp_reset_stats_s {
+	struct bfi_mhdr_s  mh;
+};
+
+/*
+ * BFI_CEE_H2I_RESET_STATS
+ */
+struct bfi_cee_reset_stats_s {
+	struct bfi_mhdr_s  mh;
+};
+
+/*
+ * BFI_CEE_H2I_GET_CFG_REQ
+ */
+struct bfi_cee_get_req_s {
+	struct bfi_mhdr_s  mh;
+	union bfi_addr_u   dma_addr;
+};
+
+
+/*
+ * BFI_CEE_I2H_GET_CFG_RSP
+ */
+struct bfi_cee_get_rsp_s {
+	struct bfi_mhdr_s  mh;
+	u8            cmd_status;
+	u8            rsvd[3];
+};
+
+/*
+ * BFI_CEE_H2I_GET_STATS_REQ
+ */
+struct bfi_cee_stats_req_s {
+	struct bfi_mhdr_s  mh;
+	union bfi_addr_u   dma_addr;
+};
+
+
+/*
+ * BFI_CEE_I2H_GET_STATS_RSP
+ */
+struct bfi_cee_stats_rsp_s {
+	struct bfi_mhdr_s  mh;
+	u8 		   cmd_status;
+	u8 		   rsvd[3];
+};
+
+
+
+union bfi_cee_h2i_msg_u {
+	struct bfi_mhdr_s           mh;
+	struct bfi_cee_get_req_s   get_req;
+	struct bfi_cee_stats_req_s stats_req;
+};
+
+
+union bfi_cee_i2h_msg_u {
+	struct bfi_mhdr_s         mh;
+	struct bfi_cee_get_rsp_s  get_rsp;
+	struct bfi_cee_stats_rsp_s stats_rsp;
+};
+
+#pragma pack()
+
+
+#endif /* __BFI_CEE_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_ctreg.h patch/drivers/scsi/bfa/include/bfi/bfi_ctreg.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_ctreg.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_ctreg.h	2009-03-23 15:33:14.131036000 -0700
@@ -0,0 +1,604 @@
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
+ * bfi_ctreg.h catapult host block register definitions
+ *
+ * !!! Do not edit. Auto generated. !!!
+ */
+
+#ifndef __BFI_CTREG_H__
+#define __BFI_CTREG_H__
+
+
+#define HOSTFN0_LPU_MBOX0_0              0x00019200
+#define HOSTFN1_LPU_MBOX0_8              0x00019260
+#define LPU_HOSTFN0_MBOX0_0              0x00019280
+#define LPU_HOSTFN1_MBOX0_8              0x000192e0
+#define HOSTFN2_LPU_MBOX0_0              0x00019400
+#define HOSTFN3_LPU_MBOX0_8              0x00019460
+#define LPU_HOSTFN2_MBOX0_0              0x00019480
+#define LPU_HOSTFN3_MBOX0_8              0x000194e0
+#define HOSTFN0_INT_STATUS               0x00014000
+#define __HOSTFN0_HALT_OCCURRED          0x01000000
+#define __HOSTFN0_INT_STATUS_LVL_MK      0x00f00000
+#define __HOSTFN0_INT_STATUS_LVL_SH      20
+#define __HOSTFN0_INT_STATUS_LVL(_v)     ((_v) << __HOSTFN0_INT_STATUS_LVL_SH)
+#define __HOSTFN0_INT_STATUS_P_MK        0x000f0000
+#define __HOSTFN0_INT_STATUS_P_SH        16
+#define __HOSTFN0_INT_STATUS_P(_v)       ((_v) << __HOSTFN0_INT_STATUS_P_SH)
+#define __HOSTFN0_INT_STATUS_F           0x0000ffff
+#define HOSTFN0_INT_MSK                  0x00014004
+#define HOST_PAGE_NUM_FN0                0x00014008
+#define __HOST_PAGE_NUM_FN               0x000001ff
+#define HOST_MSIX_ERR_INDEX_FN0          0x0001400c
+#define __MSIX_ERR_INDEX_FN              0x000001ff
+#define HOSTFN1_INT_STATUS               0x00014100
+#define __HOSTFN1_HALT_OCCURRED          0x01000000
+#define __HOSTFN1_INT_STATUS_LVL_MK      0x00f00000
+#define __HOSTFN1_INT_STATUS_LVL_SH      20
+#define __HOSTFN1_INT_STATUS_LVL(_v)     ((_v) << __HOSTFN1_INT_STATUS_LVL_SH)
+#define __HOSTFN1_INT_STATUS_P_MK        0x000f0000
+#define __HOSTFN1_INT_STATUS_P_SH        16
+#define __HOSTFN1_INT_STATUS_P(_v)       ((_v) << __HOSTFN1_INT_STATUS_P_SH)
+#define __HOSTFN1_INT_STATUS_F           0x0000ffff
+#define HOSTFN1_INT_MSK                  0x00014104
+#define HOST_PAGE_NUM_FN1                0x00014108
+#define HOST_MSIX_ERR_INDEX_FN1          0x0001410c
+#define APP_PLL_425_CTL_REG              0x00014204
+#define __P_425_PLL_LOCK                 0x80000000
+#define __APP_PLL_425_SRAM_USE_100MHZ    0x00100000
+#define __APP_PLL_425_RESET_TIMER_MK     0x000e0000
+#define __APP_PLL_425_RESET_TIMER_SH     17
+#define __APP_PLL_425_RESET_TIMER(_v)    ((_v) << __APP_PLL_425_RESET_TIMER_SH)
+#define __APP_PLL_425_LOGIC_SOFT_RESET   0x00010000
+#define __APP_PLL_425_CNTLMT0_1_MK       0x0000c000
+#define __APP_PLL_425_CNTLMT0_1_SH       14
+#define __APP_PLL_425_CNTLMT0_1(_v)      ((_v) << __APP_PLL_425_CNTLMT0_1_SH)
+#define __APP_PLL_425_JITLMT0_1_MK       0x00003000
+#define __APP_PLL_425_JITLMT0_1_SH       12
+#define __APP_PLL_425_JITLMT0_1(_v)      ((_v) << __APP_PLL_425_JITLMT0_1_SH)
+#define __APP_PLL_425_HREF               0x00000800
+#define __APP_PLL_425_HDIV               0x00000400
+#define __APP_PLL_425_P0_1_MK            0x00000300
+#define __APP_PLL_425_P0_1_SH            8
+#define __APP_PLL_425_P0_1(_v)           ((_v) << __APP_PLL_425_P0_1_SH)
+#define __APP_PLL_425_Z0_2_MK            0x000000e0
+#define __APP_PLL_425_Z0_2_SH            5
+#define __APP_PLL_425_Z0_2(_v)           ((_v) << __APP_PLL_425_Z0_2_SH)
+#define __APP_PLL_425_RSEL200500         0x00000010
+#define __APP_PLL_425_ENARST             0x00000008
+#define __APP_PLL_425_BYPASS             0x00000004
+#define __APP_PLL_425_LRESETN            0x00000002
+#define __APP_PLL_425_ENABLE             0x00000001
+#define APP_PLL_312_CTL_REG              0x00014208
+#define __P_312_PLL_LOCK                 0x80000000
+#define __ENABLE_MAC_AHB_1               0x00800000
+#define __ENABLE_MAC_AHB_0               0x00400000
+#define __ENABLE_MAC_1                   0x00200000
+#define __ENABLE_MAC_0                   0x00100000
+#define __APP_PLL_312_RESET_TIMER_MK     0x000e0000
+#define __APP_PLL_312_RESET_TIMER_SH     17
+#define __APP_PLL_312_RESET_TIMER(_v)    ((_v) << __APP_PLL_312_RESET_TIMER_SH)
+#define __APP_PLL_312_LOGIC_SOFT_RESET   0x00010000
+#define __APP_PLL_312_CNTLMT0_1_MK       0x0000c000
+#define __APP_PLL_312_CNTLMT0_1_SH       14
+#define __APP_PLL_312_CNTLMT0_1(_v)      ((_v) << __APP_PLL_312_CNTLMT0_1_SH)
+#define __APP_PLL_312_JITLMT0_1_MK       0x00003000
+#define __APP_PLL_312_JITLMT0_1_SH       12
+#define __APP_PLL_312_JITLMT0_1(_v)      ((_v) << __APP_PLL_312_JITLMT0_1_SH)
+#define __APP_PLL_312_HREF               0x00000800
+#define __APP_PLL_312_HDIV               0x00000400
+#define __APP_PLL_312_P0_1_MK            0x00000300
+#define __APP_PLL_312_P0_1_SH            8
+#define __APP_PLL_312_P0_1(_v)           ((_v) << __APP_PLL_312_P0_1_SH)
+#define __APP_PLL_312_Z0_2_MK            0x000000e0
+#define __APP_PLL_312_Z0_2_SH            5
+#define __APP_PLL_312_Z0_2(_v)           ((_v) << __APP_PLL_312_Z0_2_SH)
+#define __APP_PLL_312_RSEL200500         0x00000010
+#define __APP_PLL_312_ENARST             0x00000008
+#define __APP_PLL_312_BYPASS             0x00000004
+#define __APP_PLL_312_LRESETN            0x00000002
+#define __APP_PLL_312_ENABLE             0x00000001
+#define MBIST_CTL_REG                    0x00014220
+#define __EDRAM_BISTR_START              0x00000004
+#define __MBIST_RESET                    0x00000002
+#define __MBIST_START                    0x00000001
+#define MBIST_STAT_REG                   0x00014224
+#define __EDRAM_BISTR_STATUS             0x00000008
+#define __EDRAM_BISTR_DONE               0x00000004
+#define __MEM_BIT_STATUS                 0x00000002
+#define __MBIST_DONE                     0x00000001
+#define HOST_SEM0_REG                    0x00014230
+#define __HOST_SEMAPHORE                 0x00000001
+#define HOST_SEM1_REG                    0x00014234
+#define HOST_SEM2_REG                    0x00014238
+#define HOST_SEM3_REG                    0x0001423c
+#define HOST_SEM0_INFO_REG               0x00014240
+#define HOST_SEM1_INFO_REG               0x00014244
+#define HOST_SEM2_INFO_REG               0x00014248
+#define HOST_SEM3_INFO_REG               0x0001424c
+#define ETH_MAC_SER_REG                  0x00014288
+#define __APP_EMS_CKBUFAMPIN             0x00000020
+#define __APP_EMS_REFCLKSEL              0x00000010
+#define __APP_EMS_CMLCKSEL               0x00000008
+#define __APP_EMS_REFCKBUFEN2            0x00000004
+#define __APP_EMS_REFCKBUFEN1            0x00000002
+#define __APP_EMS_CHANNEL_SEL            0x00000001
+#define HOSTFN2_INT_STATUS               0x00014300
+#define __HOSTFN2_HALT_OCCURRED          0x01000000
+#define __HOSTFN2_INT_STATUS_LVL_MK      0x00f00000
+#define __HOSTFN2_INT_STATUS_LVL_SH      20
+#define __HOSTFN2_INT_STATUS_LVL(_v)     ((_v) << __HOSTFN2_INT_STATUS_LVL_SH)
+#define __HOSTFN2_INT_STATUS_P_MK        0x000f0000
+#define __HOSTFN2_INT_STATUS_P_SH        16
+#define __HOSTFN2_INT_STATUS_P(_v)       ((_v) << __HOSTFN2_INT_STATUS_P_SH)
+#define __HOSTFN2_INT_STATUS_F           0x0000ffff
+#define HOSTFN2_INT_MSK                  0x00014304
+#define HOST_PAGE_NUM_FN2                0x00014308
+#define HOST_MSIX_ERR_INDEX_FN2          0x0001430c
+#define HOSTFN3_INT_STATUS               0x00014400
+#define __HALT_OCCURRED                  0x01000000
+#define __HOSTFN3_INT_STATUS_LVL_MK      0x00f00000
+#define __HOSTFN3_INT_STATUS_LVL_SH      20
+#define __HOSTFN3_INT_STATUS_LVL(_v)     ((_v) << __HOSTFN3_INT_STATUS_LVL_SH)
+#define __HOSTFN3_INT_STATUS_P_MK        0x000f0000
+#define __HOSTFN3_INT_STATUS_P_SH        16
+#define __HOSTFN3_INT_STATUS_P(_v)       ((_v) << __HOSTFN3_INT_STATUS_P_SH)
+#define __HOSTFN3_INT_STATUS_F           0x0000ffff
+#define HOSTFN3_INT_MSK                  0x00014404
+#define HOST_PAGE_NUM_FN3                0x00014408
+#define HOST_MSIX_ERR_INDEX_FN3          0x0001440c
+#define FNC_ID_REG                       0x00014600
+#define __FUNCTION_NUMBER                0x00000007
+#define FNC_PERS_REG                     0x00014604
+#define __F3_FUNCTION_ACTIVE             0x80000000
+#define __F3_FUNCTION_MODE               0x40000000
+#define __F3_PORT_MAP_MK                 0x30000000
+#define __F3_PORT_MAP_SH                 28
+#define __F3_PORT_MAP(_v)                ((_v) << __F3_PORT_MAP_SH)
+#define __F3_VM_MODE                     0x08000000
+#define __F3_INTX_STATUS_MK              0x07000000
+#define __F3_INTX_STATUS_SH              24
+#define __F3_INTX_STATUS(_v)             ((_v) << __F3_INTX_STATUS_SH)
+#define __F2_FUNCTION_ACTIVE             0x00800000
+#define __F2_FUNCTION_MODE               0x00400000
+#define __F2_PORT_MAP_MK                 0x00300000
+#define __F2_PORT_MAP_SH                 20
+#define __F2_PORT_MAP(_v)                ((_v) << __F2_PORT_MAP_SH)
+#define __F2_VM_MODE                     0x00080000
+#define __F2_INTX_STATUS_MK              0x00070000
+#define __F2_INTX_STATUS_SH              16
+#define __F2_INTX_STATUS(_v)             ((_v) << __F2_INTX_STATUS_SH)
+#define __F1_FUNCTION_ACTIVE             0x00008000
+#define __F1_FUNCTION_MODE               0x00004000
+#define __F1_PORT_MAP_MK                 0x00003000
+#define __F1_PORT_MAP_SH                 12
+#define __F1_PORT_MAP(_v)                ((_v) << __F1_PORT_MAP_SH)
+#define __F1_VM_MODE                     0x00000800
+#define __F1_INTX_STATUS_MK              0x00000700
+#define __F1_INTX_STATUS_SH              8
+#define __F1_INTX_STATUS(_v)             ((_v) << __F1_INTX_STATUS_SH)
+#define __F0_FUNCTION_ACTIVE             0x00000080
+#define __F0_FUNCTION_MODE               0x00000040
+#define __F0_PORT_MAP_MK                 0x00000030
+#define __F0_PORT_MAP_SH                 4
+#define __F0_PORT_MAP(_v)                ((_v) << __F0_PORT_MAP_SH)
+#define __F0_VM_MODE                     0x00000008
+#define __F0_INTX_STATUS                 0x00000007
+#define OP_MODE                          0x0001460c
+#define __APP_ETH_CLK_LOWSPEED           0x00000004
+#define __GLOBAL_CORECLK_HALFSPEED       0x00000002
+#define __GLOBAL_FCOE_MODE               0x00000001
+#define HOST_SEM4_REG                    0x00014610
+#define HOST_SEM5_REG                    0x00014614
+#define HOST_SEM6_REG                    0x00014618
+#define HOST_SEM7_REG                    0x0001461c
+#define HOST_SEM4_INFO_REG               0x00014620
+#define HOST_SEM5_INFO_REG               0x00014624
+#define HOST_SEM6_INFO_REG               0x00014628
+#define HOST_SEM7_INFO_REG               0x0001462c
+#define HOSTFN0_LPU0_MBOX0_CMD_STAT      0x00019000
+#define __HOSTFN0_LPU0_MBOX0_INFO_MK     0xfffffffe
+#define __HOSTFN0_LPU0_MBOX0_INFO_SH     1
+#define __HOSTFN0_LPU0_MBOX0_INFO(_v)    ((_v) << __HOSTFN0_LPU0_MBOX0_INFO_SH)
+#define __HOSTFN0_LPU0_MBOX0_CMD_STATUS  0x00000001
+#define HOSTFN0_LPU1_MBOX0_CMD_STAT      0x00019004
+#define __HOSTFN0_LPU1_MBOX0_INFO_MK     0xfffffffe
+#define __HOSTFN0_LPU1_MBOX0_INFO_SH     1
+#define __HOSTFN0_LPU1_MBOX0_INFO(_v)    ((_v) << __HOSTFN0_LPU1_MBOX0_INFO_SH)
+#define __HOSTFN0_LPU1_MBOX0_CMD_STATUS  0x00000001
+#define LPU0_HOSTFN0_MBOX0_CMD_STAT      0x00019008
+#define __LPU0_HOSTFN0_MBOX0_INFO_MK     0xfffffffe
+#define __LPU0_HOSTFN0_MBOX0_INFO_SH     1
+#define __LPU0_HOSTFN0_MBOX0_INFO(_v)    ((_v) << __LPU0_HOSTFN0_MBOX0_INFO_SH)
+#define __LPU0_HOSTFN0_MBOX0_CMD_STATUS  0x00000001
+#define LPU1_HOSTFN0_MBOX0_CMD_STAT      0x0001900c
+#define __LPU1_HOSTFN0_MBOX0_INFO_MK     0xfffffffe
+#define __LPU1_HOSTFN0_MBOX0_INFO_SH     1
+#define __LPU1_HOSTFN0_MBOX0_INFO(_v)    ((_v) << __LPU1_HOSTFN0_MBOX0_INFO_SH)
+#define __LPU1_HOSTFN0_MBOX0_CMD_STATUS  0x00000001
+#define HOSTFN1_LPU0_MBOX0_CMD_STAT      0x00019010
+#define __HOSTFN1_LPU0_MBOX0_INFO_MK     0xfffffffe
+#define __HOSTFN1_LPU0_MBOX0_INFO_SH     1
+#define __HOSTFN1_LPU0_MBOX0_INFO(_v)    ((_v) << __HOSTFN1_LPU0_MBOX0_INFO_SH)
+#define __HOSTFN1_LPU0_MBOX0_CMD_STATUS  0x00000001
+#define HOSTFN1_LPU1_MBOX0_CMD_STAT      0x00019014
+#define __HOSTFN1_LPU1_MBOX0_INFO_MK     0xfffffffe
+#define __HOSTFN1_LPU1_MBOX0_INFO_SH     1
+#define __HOSTFN1_LPU1_MBOX0_INFO(_v)    ((_v) << __HOSTFN1_LPU1_MBOX0_INFO_SH)
+#define __HOSTFN1_LPU1_MBOX0_CMD_STATUS  0x00000001
+#define LPU0_HOSTFN1_MBOX0_CMD_STAT      0x00019018
+#define __LPU0_HOSTFN1_MBOX0_INFO_MK     0xfffffffe
+#define __LPU0_HOSTFN1_MBOX0_INFO_SH     1
+#define __LPU0_HOSTFN1_MBOX0_INFO(_v)    ((_v) << __LPU0_HOSTFN1_MBOX0_INFO_SH)
+#define __LPU0_HOSTFN1_MBOX0_CMD_STATUS  0x00000001
+#define LPU1_HOSTFN1_MBOX0_CMD_STAT      0x0001901c
+#define __LPU1_HOSTFN1_MBOX0_INFO_MK     0xfffffffe
+#define __LPU1_HOSTFN1_MBOX0_INFO_SH     1
+#define __LPU1_HOSTFN1_MBOX0_INFO(_v)    ((_v) << __LPU1_HOSTFN1_MBOX0_INFO_SH)
+#define __LPU1_HOSTFN1_MBOX0_CMD_STATUS  0x00000001
+#define HOSTFN2_LPU0_MBOX0_CMD_STAT      0x00019150
+#define __HOSTFN2_LPU0_MBOX0_INFO_MK     0xfffffffe
+#define __HOSTFN2_LPU0_MBOX0_INFO_SH     1
+#define __HOSTFN2_LPU0_MBOX0_INFO(_v)    ((_v) << __HOSTFN2_LPU0_MBOX0_INFO_SH)
+#define __HOSTFN2_LPU0_MBOX0_CMD_STATUS  0x00000001
+#define HOSTFN2_LPU1_MBOX0_CMD_STAT      0x00019154
+#define __HOSTFN2_LPU1_MBOX0_INFO_MK     0xfffffffe
+#define __HOSTFN2_LPU1_MBOX0_INFO_SH     1
+#define __HOSTFN2_LPU1_MBOX0_INFO(_v)    ((_v) << __HOSTFN2_LPU1_MBOX0_INFO_SH)
+#define __HOSTFN2_LPU1_MBOX0BOX0_CMD_STATUS 0x00000001
+#define LPU0_HOSTFN2_MBOX0_CMD_STAT      0x00019158
+#define __LPU0_HOSTFN2_MBOX0_INFO_MK     0xfffffffe
+#define __LPU0_HOSTFN2_MBOX0_INFO_SH     1
+#define __LPU0_HOSTFN2_MBOX0_INFO(_v)    ((_v) << __LPU0_HOSTFN2_MBOX0_INFO_SH)
+#define __LPU0_HOSTFN2_MBOX0_CMD_STATUS  0x00000001
+#define LPU1_HOSTFN2_MBOX0_CMD_STAT      0x0001915c
+#define __LPU1_HOSTFN2_MBOX0_INFO_MK     0xfffffffe
+#define __LPU1_HOSTFN2_MBOX0_INFO_SH     1
+#define __LPU1_HOSTFN2_MBOX0_INFO(_v)    ((_v) << __LPU1_HOSTFN2_MBOX0_INFO_SH)
+#define __LPU1_HOSTFN2_MBOX0_CMD_STATUS  0x00000001
+#define HOSTFN3_LPU0_MBOX0_CMD_STAT      0x00019160
+#define __HOSTFN3_LPU0_MBOX0_INFO_MK     0xfffffffe
+#define __HOSTFN3_LPU0_MBOX0_INFO_SH     1
+#define __HOSTFN3_LPU0_MBOX0_INFO(_v)    ((_v) << __HOSTFN3_LPU0_MBOX0_INFO_SH)
+#define __HOSTFN3_LPU0_MBOX0_CMD_STATUS  0x00000001
+#define HOSTFN3_LPU1_MBOX0_CMD_STAT      0x00019164
+#define __HOSTFN3_LPU1_MBOX0_INFO_MK     0xfffffffe
+#define __HOSTFN3_LPU1_MBOX0_INFO_SH     1
+#define __HOSTFN3_LPU1_MBOX0_INFO(_v)    ((_v) << __HOSTFN3_LPU1_MBOX0_INFO_SH)
+#define __HOSTFN3_LPU1_MBOX0_CMD_STATUS  0x00000001
+#define LPU0_HOSTFN3_MBOX0_CMD_STAT      0x00019168
+#define __LPU0_HOSTFN3_MBOX0_INFO_MK     0xfffffffe
+#define __LPU0_HOSTFN3_MBOX0_INFO_SH     1
+#define __LPU0_HOSTFN3_MBOX0_INFO(_v)    ((_v) << __LPU0_HOSTFN3_MBOX0_INFO_SH)
+#define __LPU0_HOSTFN3_MBOX0_CMD_STATUS  0x00000001
+#define LPU1_HOSTFN3_MBOX0_CMD_STAT      0x0001916c
+#define __LPU1_HOSTFN3_MBOX0_INFO_MK     0xfffffffe
+#define __LPU1_HOSTFN3_MBOX0_INFO_SH     1
+#define __LPU1_HOSTFN3_MBOX0_INFO(_v)    ((_v) << __LPU1_HOSTFN3_MBOX0_INFO_SH)
+#define __LPU1_HOSTFN3_MBOX0_CMD_STATUS  0x00000001
+#define CPE_PI_PTR_Q0                    0x00038000
+#define __CPE_PI_UNUSED_MK               0xffff0000
+#define __CPE_PI_UNUSED_SH               16
+#define __CPE_PI_UNUSED(_v)              ((_v) << __CPE_PI_UNUSED_SH)
+#define __CPE_PI_PTR                     0x0000ffff
+#define CPE_PI_PTR_Q1                    0x00038040
+#define CPE_CI_PTR_Q0                    0x00038004
+#define __CPE_CI_UNUSED_MK               0xffff0000
+#define __CPE_CI_UNUSED_SH               16
+#define __CPE_CI_UNUSED(_v)              ((_v) << __CPE_CI_UNUSED_SH)
+#define __CPE_CI_PTR                     0x0000ffff
+#define CPE_CI_PTR_Q1                    0x00038044
+#define CPE_DEPTH_Q0                     0x00038008
+#define __CPE_DEPTH_UNUSED_MK            0xf8000000
+#define __CPE_DEPTH_UNUSED_SH            27
+#define __CPE_DEPTH_UNUSED(_v)           ((_v) << __CPE_DEPTH_UNUSED_SH)
+#define __CPE_MSIX_VEC_INDEX_MK          0x07ff0000
+#define __CPE_MSIX_VEC_INDEX_SH          16
+#define __CPE_MSIX_VEC_INDEX(_v)         ((_v) << __CPE_MSIX_VEC_INDEX_SH)
+#define __CPE_DEPTH                      0x0000ffff
+#define CPE_DEPTH_Q1                     0x00038048
+#define CPE_QCTRL_Q0                     0x0003800c
+#define __CPE_CTRL_UNUSED30_MK           0xfc000000
+#define __CPE_CTRL_UNUSED30_SH           26
+#define __CPE_CTRL_UNUSED30(_v)          ((_v) << __CPE_CTRL_UNUSED30_SH)
+#define __CPE_FUNC_INT_CTRL_MK           0x03000000
+#define __CPE_FUNC_INT_CTRL_SH           24
+#define __CPE_FUNC_INT_CTRL(_v)          ((_v) << __CPE_FUNC_INT_CTRL_SH)
+enum {
+    __CPE_FUNC_INT_CTRL_DISABLE      = 0x0,
+    __CPE_FUNC_INT_CTRL_F2NF         = 0x1,
+    __CPE_FUNC_INT_CTRL_3QUART       = 0x2,
+    __CPE_FUNC_INT_CTRL_HALF         = 0x3,
+};
+#define __CPE_CTRL_UNUSED20_MK           0x00f00000
+#define __CPE_CTRL_UNUSED20_SH           20
+#define __CPE_CTRL_UNUSED20(_v)          ((_v) << __CPE_CTRL_UNUSED20_SH)
+#define __CPE_SCI_TH_MK                  0x000f0000
+#define __CPE_SCI_TH_SH                  16
+#define __CPE_SCI_TH(_v)                 ((_v) << __CPE_SCI_TH_SH)
+#define __CPE_CTRL_UNUSED10_MK           0x0000c000
+#define __CPE_CTRL_UNUSED10_SH           14
+#define __CPE_CTRL_UNUSED10(_v)          ((_v) << __CPE_CTRL_UNUSED10_SH)
+#define __CPE_ACK_PENDING                0x00002000
+#define __CPE_CTRL_UNUSED40_MK           0x00001c00
+#define __CPE_CTRL_UNUSED40_SH           10
+#define __CPE_CTRL_UNUSED40(_v)          ((_v) << __CPE_CTRL_UNUSED40_SH)
+#define __CPE_PCIEID_MK                  0x00000300
+#define __CPE_PCIEID_SH                  8
+#define __CPE_PCIEID(_v)                 ((_v) << __CPE_PCIEID_SH)
+#define __CPE_CTRL_UNUSED00_MK           0x000000fe
+#define __CPE_CTRL_UNUSED00_SH           1
+#define __CPE_CTRL_UNUSED00(_v)          ((_v) << __CPE_CTRL_UNUSED00_SH)
+#define __CPE_ESIZE                      0x00000001
+#define CPE_QCTRL_Q1                     0x0003804c
+#define __CPE_CTRL_UNUSED31_MK           0xfc000000
+#define __CPE_CTRL_UNUSED31_SH           26
+#define __CPE_CTRL_UNUSED31(_v)          ((_v) << __CPE_CTRL_UNUSED31_SH)
+#define __CPE_CTRL_UNUSED21_MK           0x00f00000
+#define __CPE_CTRL_UNUSED21_SH           20
+#define __CPE_CTRL_UNUSED21(_v)          ((_v) << __CPE_CTRL_UNUSED21_SH)
+#define __CPE_CTRL_UNUSED11_MK           0x0000c000
+#define __CPE_CTRL_UNUSED11_SH           14
+#define __CPE_CTRL_UNUSED11(_v)          ((_v) << __CPE_CTRL_UNUSED11_SH)
+#define __CPE_CTRL_UNUSED41_MK           0x00001c00
+#define __CPE_CTRL_UNUSED41_SH           10
+#define __CPE_CTRL_UNUSED41(_v)          ((_v) << __CPE_CTRL_UNUSED41_SH)
+#define __CPE_CTRL_UNUSED01_MK           0x000000fe
+#define __CPE_CTRL_UNUSED01_SH           1
+#define __CPE_CTRL_UNUSED01(_v)          ((_v) << __CPE_CTRL_UNUSED01_SH)
+#define RME_PI_PTR_Q0                    0x00038020
+#define __LATENCY_TIME_STAMP_MK          0xffff0000
+#define __LATENCY_TIME_STAMP_SH          16
+#define __LATENCY_TIME_STAMP(_v)         ((_v) << __LATENCY_TIME_STAMP_SH)
+#define __RME_PI_PTR                     0x0000ffff
+#define RME_PI_PTR_Q1                    0x00038060
+#define RME_CI_PTR_Q0                    0x00038024
+#define __DELAY_TIME_STAMP_MK            0xffff0000
+#define __DELAY_TIME_STAMP_SH            16
+#define __DELAY_TIME_STAMP(_v)           ((_v) << __DELAY_TIME_STAMP_SH)
+#define __RME_CI_PTR                     0x0000ffff
+#define RME_CI_PTR_Q1                    0x00038064
+#define RME_DEPTH_Q0                     0x00038028
+#define __RME_DEPTH_UNUSED_MK            0xf8000000
+#define __RME_DEPTH_UNUSED_SH            27
+#define __RME_DEPTH_UNUSED(_v)           ((_v) << __RME_DEPTH_UNUSED_SH)
+#define __RME_MSIX_VEC_INDEX_MK          0x07ff0000
+#define __RME_MSIX_VEC_INDEX_SH          16
+#define __RME_MSIX_VEC_INDEX(_v)         ((_v) << __RME_MSIX_VEC_INDEX_SH)
+#define __RME_DEPTH                      0x0000ffff
+#define RME_DEPTH_Q1                     0x00038068
+#define RME_QCTRL_Q0                     0x0003802c
+#define __RME_INT_LATENCY_TIMER_MK       0xff000000
+#define __RME_INT_LATENCY_TIMER_SH       24
+#define __RME_INT_LATENCY_TIMER(_v)      ((_v) << __RME_INT_LATENCY_TIMER_SH)
+#define __RME_INT_DELAY_TIMER_MK         0x00ff0000
+#define __RME_INT_DELAY_TIMER_SH         16
+#define __RME_INT_DELAY_TIMER(_v)        ((_v) << __RME_INT_DELAY_TIMER_SH)
+#define __RME_INT_DELAY_DISABLE          0x00008000
+#define __RME_DLY_DELAY_DISABLE          0x00004000
+#define __RME_ACK_PENDING                0x00002000
+#define __RME_FULL_INTERRUPT_DISABLE     0x00001000
+#define __RME_CTRL_UNUSED10_MK           0x00000c00
+#define __RME_CTRL_UNUSED10_SH           10
+#define __RME_CTRL_UNUSED10(_v)          ((_v) << __RME_CTRL_UNUSED10_SH)
+#define __RME_PCIEID_MK                  0x00000300
+#define __RME_PCIEID_SH                  8
+#define __RME_PCIEID(_v)                 ((_v) << __RME_PCIEID_SH)
+#define __RME_CTRL_UNUSED00_MK           0x000000fe
+#define __RME_CTRL_UNUSED00_SH           1
+#define __RME_CTRL_UNUSED00(_v)          ((_v) << __RME_CTRL_UNUSED00_SH)
+#define __RME_ESIZE                      0x00000001
+#define RME_QCTRL_Q1                     0x0003806c
+#define __RME_CTRL_UNUSED11_MK           0x00000c00
+#define __RME_CTRL_UNUSED11_SH           10
+#define __RME_CTRL_UNUSED11(_v)          ((_v) << __RME_CTRL_UNUSED11_SH)
+#define __RME_CTRL_UNUSED01_MK           0x000000fe
+#define __RME_CTRL_UNUSED01_SH           1
+#define __RME_CTRL_UNUSED01(_v)          ((_v) << __RME_CTRL_UNUSED01_SH)
+#define PSS_CTL_REG                      0x00018800
+#define __PSS_I2C_CLK_DIV_MK             0x007f0000
+#define __PSS_I2C_CLK_DIV_SH             16
+#define __PSS_I2C_CLK_DIV(_v)            ((_v) << __PSS_I2C_CLK_DIV_SH)
+#define __PSS_LMEM_INIT_DONE             0x00001000
+#define __PSS_LMEM_RESET                 0x00000200
+#define __PSS_LMEM_INIT_EN               0x00000100
+#define __PSS_LPU1_RESET                 0x00000002
+#define __PSS_LPU0_RESET                 0x00000001
+#define HQM_QSET0_RXQ_DRBL_P0            0x00038000
+#define __RXQ0_ADD_VECTORS_P             0x80000000
+#define __RXQ0_STOP_P                    0x40000000
+#define __RXQ0_PRD_PTR_P                 0x0000ffff
+#define HQM_QSET1_RXQ_DRBL_P0            0x00038080
+#define __RXQ1_ADD_VECTORS_P             0x80000000
+#define __RXQ1_STOP_P                    0x40000000
+#define __RXQ1_PRD_PTR_P                 0x0000ffff
+#define HQM_QSET0_RXQ_DRBL_P1            0x0003c000
+#define HQM_QSET1_RXQ_DRBL_P1            0x0003c080
+#define HQM_QSET0_TXQ_DRBL_P0            0x00038020
+#define __TXQ0_ADD_VECTORS_P             0x80000000
+#define __TXQ0_STOP_P                    0x40000000
+#define __TXQ0_PRD_PTR_P                 0x0000ffff
+#define HQM_QSET1_TXQ_DRBL_P0            0x000380a0
+#define __TXQ1_ADD_VECTORS_P             0x80000000
+#define __TXQ1_STOP_P                    0x40000000
+#define __TXQ1_PRD_PTR_P                 0x0000ffff
+#define HQM_QSET0_TXQ_DRBL_P1            0x0003c020
+#define HQM_QSET1_TXQ_DRBL_P1            0x0003c0a0
+#define HQM_QSET0_IB_DRBL_1_P0           0x00038040
+#define __IB1_0_ACK_P                    0x80000000
+#define __IB1_0_DISABLE_P                0x40000000
+#define __IB1_0_NUM_OF_ACKED_EVENTS_P    0x0000ffff
+#define HQM_QSET1_IB_DRBL_1_P0           0x000380c0
+#define __IB1_1_ACK_P                    0x80000000
+#define __IB1_1_DISABLE_P                0x40000000
+#define __IB1_1_NUM_OF_ACKED_EVENTS_P    0x0000ffff
+#define HQM_QSET0_IB_DRBL_1_P1           0x0003c040
+#define HQM_QSET1_IB_DRBL_1_P1           0x0003c0c0
+#define HQM_QSET0_IB_DRBL_2_P0           0x00038060
+#define __IB2_0_ACK_P                    0x80000000
+#define __IB2_0_DISABLE_P                0x40000000
+#define __IB2_0_NUM_OF_ACKED_EVENTS_P    0x0000ffff
+#define HQM_QSET1_IB_DRBL_2_P0           0x000380e0
+#define __IB2_1_ACK_P                    0x80000000
+#define __IB2_1_DISABLE_P                0x40000000
+#define __IB2_1_NUM_OF_ACKED_EVENTS_P    0x0000ffff
+#define HQM_QSET0_IB_DRBL_2_P1           0x0003c060
+#define HQM_QSET1_IB_DRBL_2_P1           0x0003c0e0
+
+
+/*
+ * These definitions are either in error/missing in spec. Its auto-generated 
+ * from hard coded values in regparse.pl.
+ */
+#define __EMPHPOST_AT_4G_MK_FIX          0x0000001c
+#define __EMPHPOST_AT_4G_SH_FIX          0x00000002
+#define __EMPHPRE_AT_4G_FIX              0x00000003
+#define __SFP_TXRATE_EN_FIX              0x00000100
+#define __SFP_RXRATE_EN_FIX              0x00000080
+
+
+/*
+ * These register definitions are auto-generated from hard coded values
+ * in regparse.pl.
+ */
+
+
+/*
+ * These register mapping definitions are auto-generated from mapping tables
+ * in regparse.pl.
+ */
+#define BFA_IOC0_HBEAT_REG               HOST_SEM0_INFO_REG              
+#define BFA_IOC0_STATE_REG               HOST_SEM1_INFO_REG              
+#define BFA_IOC1_HBEAT_REG               HOST_SEM2_INFO_REG              
+#define BFA_IOC1_STATE_REG               HOST_SEM3_INFO_REG              
+
+#define CPE_DEPTH_Q(__n) \
+	(CPE_DEPTH_Q0 + (__n) * (CPE_DEPTH_Q1 - CPE_DEPTH_Q0))
+#define CPE_QCTRL_Q(__n) \
+	(CPE_QCTRL_Q0 + (__n) * (CPE_QCTRL_Q1 - CPE_QCTRL_Q0))
+#define CPE_PI_PTR_Q(__n) \
+	(CPE_PI_PTR_Q0 + (__n) * (CPE_PI_PTR_Q1 - CPE_PI_PTR_Q0))
+#define CPE_CI_PTR_Q(__n) \
+	(CPE_CI_PTR_Q0 + (__n) * (CPE_CI_PTR_Q1 - CPE_CI_PTR_Q0))
+#define RME_DEPTH_Q(__n) \
+	(RME_DEPTH_Q0 + (__n) * (RME_DEPTH_Q1 - RME_DEPTH_Q0))
+#define RME_QCTRL_Q(__n) \
+	(RME_QCTRL_Q0 + (__n) * (RME_QCTRL_Q1 - RME_QCTRL_Q0))
+#define RME_PI_PTR_Q(__n) \
+	(RME_PI_PTR_Q0 + (__n) * (RME_PI_PTR_Q1 - RME_PI_PTR_Q0))
+#define RME_CI_PTR_Q(__n) \
+	(RME_CI_PTR_Q0 + (__n) * (RME_CI_PTR_Q1 - RME_CI_PTR_Q0))
+#define HQM_QSET_RXQ_DRBL_P0(__n) \
+	(HQM_QSET0_RXQ_DRBL_P0 + (__n) * (HQM_QSET1_RXQ_DRBL_P0 - HQM_QSET0_RXQ_DRBL_P0))
+#define HQM_QSET_TXQ_DRBL_P0(__n) \
+	(HQM_QSET0_TXQ_DRBL_P0 + (__n) * (HQM_QSET1_TXQ_DRBL_P0 - HQM_QSET0_TXQ_DRBL_P0))
+#define HQM_QSET_IB_DRBL_1_P0(__n) \
+	(HQM_QSET0_IB_DRBL_1_P0 + (__n) * (HQM_QSET1_IB_DRBL_1_P0 - HQM_QSET0_IB_DRBL_1_P0))
+#define HQM_QSET_IB_DRBL_2_P0(__n) \
+	(HQM_QSET0_IB_DRBL_2_P0 + (__n) * (HQM_QSET1_IB_DRBL_2_P0 - HQM_QSET0_IB_DRBL_2_P0))
+#define HQM_QSET_RXQ_DRBL_P1(__n) \
+	(HQM_QSET0_RXQ_DRBL_P1 + (__n) * (HQM_QSET1_RXQ_DRBL_P1 - HQM_QSET0_RXQ_DRBL_P1))
+#define HQM_QSET_TXQ_DRBL_P1(__n) \
+	(HQM_QSET0_TXQ_DRBL_P1 + (__n) * (HQM_QSET1_TXQ_DRBL_P1 - HQM_QSET0_TXQ_DRBL_P1))
+#define HQM_QSET_IB_DRBL_1_P1(__n) \
+	(HQM_QSET0_IB_DRBL_1_P1 + (__n) * (HQM_QSET1_IB_DRBL_1_P1 - HQM_QSET0_IB_DRBL_1_P1))
+#define HQM_QSET_IB_DRBL_2_P1(__n) \
+	(HQM_QSET0_IB_DRBL_2_P1 + (__n) * (HQM_QSET1_IB_DRBL_2_P1 - HQM_QSET0_IB_DRBL_2_P1))
+
+#define CPE_Q_NUM(__fn, __q)  (((__fn) << 2) + (__q))
+#define RME_Q_NUM(__fn, __q)  (((__fn) << 2) + (__q))
+#define CPE_Q_MASK(__q)  ((__q) & 0x3)
+#define RME_Q_MASK(__q)  ((__q) & 0x3)
+
+
+/*
+ * PCI MSI-X vector defines
+ */
+enum {
+    HFN_MSIX_CPE_Q0      = 0,
+    HFN_MSIX_CPE_Q1      = 1,
+    HFN_MSIX_CPE_Q2      = 2,
+    HFN_MSIX_CPE_Q3      = 3,
+    HFN_MSIX_CPE_Q4      = 4,
+    HFN_MSIX_CPE_Q5      = 5,
+    HFN_MSIX_CPE_Q6      = 6,
+    HFN_MSIX_CPE_Q7      = 7,
+    HFN_MSIX_RME_Q0      = 8,
+    HFN_MSIX_RME_Q1      = 9,
+    HFN_MSIX_RME_Q2      = 10,
+    HFN_MSIX_RME_Q3      = 11,
+    HFN_MSIX_RME_Q4      = 12,
+    HFN_MSIX_RME_Q5      = 13,
+    HFN_MSIX_RME_Q6      = 14,
+    HFN_MSIX_RME_Q7      = 15,
+    HFN_MSIX_ERR_EMC     = 16,
+    HFN_MSIX_ERR_LPU0    = 17,
+    HFN_MSIX_ERR_LPU1    = 18,
+    HFN_MSIX_ERR_PSS     = 19,
+    HFN_MSIX_MBOX_LPU0   = 20,
+    HFN_MSIX_MBOX_LPU1   = 21,
+    HFN_MSIX_GP_LPU0     = 22,
+    HFN_MSIX_GP_LPU1     = 23,
+};
+
+/*
+ * And corresponding host interrupt status bit field defines
+ */
+#define __HFN_INT_CPE_Q0                   0x00000001U
+#define __HFN_INT_CPE_Q1                   0x00000002U
+#define __HFN_INT_CPE_Q2                   0x00000004U
+#define __HFN_INT_CPE_Q3                   0x00000008U
+#define __HFN_INT_CPE_Q4                   0x00000010U
+#define __HFN_INT_CPE_Q5                   0x00000020U
+#define __HFN_INT_CPE_Q6                   0x00000040U
+#define __HFN_INT_CPE_Q7                   0x00000080U
+#define __HFN_INT_RME_Q0                   0x00000100U
+#define __HFN_INT_RME_Q1                   0x00000200U
+#define __HFN_INT_RME_Q2                   0x00000400U
+#define __HFN_INT_RME_Q3                   0x00000800U
+#define __HFN_INT_RME_Q4                   0x00001000U
+#define __HFN_INT_RME_Q5                   0x00002000U
+#define __HFN_INT_RME_Q6                   0x00004000U
+#define __HFN_INT_RME_Q7                   0x00008000U
+#define __HFN_INT_ERR_EMC                  0x00010000U
+#define __HFN_INT_ERR_LPU0                 0x00020000U
+#define __HFN_INT_ERR_LPU1                 0x00040000U
+#define __HFN_INT_ERR_PSS                  0x00080000U
+#define __HFN_INT_MBOX_LPU0                0x00100000U
+#define __HFN_INT_MBOX_LPU1                0x00200000U
+#define __HFN_INT_GP_LPU0                  0x00400000U
+#define __HFN_INT_GP_LPU1                  0x00800000U
+
+
+/*
+ * catapult memory map.
+ */
+#define LL_PGN_HQM0                      0x0096
+#define LL_PGN_HQM1                      0x0097
+#define PSS_SMEM_PAGE_START	0x8000
+#define PSS_SMEM_PGNUM(_pg0, _ma)	((_pg0) + ((_ma) >> 15))
+#define PSS_SMEM_PGOFF(_ma)	((_ma) & 0x7fff)
+
+/*
+ * End of catapult memory map
+ */
+
+
+#endif /* __BFI_CTREG_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_fabric.h patch/drivers/scsi/bfa/include/bfi/bfi_fabric.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_fabric.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_fabric.h	2009-03-23 15:33:14.114623000 -0700
@@ -0,0 +1,113 @@
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
+#ifndef __BFI_FABRIC_H__
+#define __BFI_FABRIC_H__
+
+#include <bfi/bfi.h>
+
+#pragma pack(1)
+
+enum bfi_fabric_h2i_msgs {
+	BFI_FABRIC_H2I_START_REQ	= 1,
+	BFI_FABRIC_H2I_STOP_REQ		= 2,
+	BFI_FABRIC_H2I_SETAUTH		= 3,
+	BFI_FABRIC_H2I_AUTH_START	= 4,
+};
+
+enum bfa_fabric_type{
+    FABRIC_UNKNOWN 	= 0,
+    FABRIC_SWITCHED = 1,
+    FABRIC_PLOOP 	= 2,
+    FABRIC_N2N 		= 3,
+    FABRIC_LOOPBACK = 4,
+};
+
+enum bfi_fabric_i2h_msgs {
+	BFI_FABRIC_I2H_AUTH_START_RSP	= BFA_I2HM(3),
+	BFI_FABRIC_I2H_ONLINE			= BFA_I2HM(4),
+	BFI_FABRIC_I2H_OFFLINE			= BFA_I2HM(5),
+};
+
+struct bfi_fabric_start_req_s {
+	struct bfi_mhdr_s	mh;	/*  common msg header		*/
+	u8         vf_en;		/*  virtual fabric enable	*/
+	u8         rsvd;
+	u16        vf_id;		/*  virtual fabric ID		*/
+	wwn_t		pwwn;		/*  port name			*/
+	wwn_t		nwwn;		/*  node name			*/
+};
+
+
+struct bfi_fabric_stop_req_s {
+	struct bfi_mhdr_s	mh;	/*  common msg header		*/
+	u16        vf_id;	/*  firmware fabric handle	*/
+	u16        rsvd;
+};
+
+struct bfi_fabric_port_status_s {
+	struct bfi_mhdr_s  mh;     /*  common msg header      */
+	u16        fw_handle;  /*  firmware fabric handle */
+	u8        status;	   /* enum bfa_fabric_type online
+				    * / offline/ loopback/ no fabric */
+	u8 rsvd;
+	wwn_t fabric_name;
+};
+
+#define BFI_FABRIC_AUTHSECRET_LEN	64
+struct bfi_fabric_setauth_req_s {
+	struct bfi_mhdr_s	mh;	/*  common msg header		*/
+	u16        fw_handle;	/*  f/w handle of fabric	*/
+	u8		algo;
+	u8		group;
+	u8		policy;
+	u8		secret_len;
+	u8 rsvd[2];
+	u8		secret[BFI_FABRIC_AUTHSECRET_LEN];
+};
+
+struct bfi_fabric_auth_start_req_s {
+	struct bfi_mhdr_s	mh;	/*  common msg header		*/
+	u16        fw_handle;	/*  f/w handle of fabric	*/
+};
+
+struct bfi_fabric_auth_start_rsp_s {
+	struct bfi_mhdr_s	mh;		/*  common msg header	*/
+	u16        fw_handle;	/*  f/w handle of fabric	*/
+	u8		status;
+	u8		algo;
+	u8		group;
+	u8 rsvd[3];
+};
+
+union bfi_fabric_h2i_msg_u {
+	struct bfi_msg_s		*msg;
+	struct bfi_fabric_start_req_s	*start_req;
+	struct bfi_fabric_stop_req_s	*stop_req;
+	struct bfi_fabric_setauth_req_s	*auth_req;
+};
+
+union bfi_fabric_i2h_msg_u {
+	struct bfi_msg_s		*msg;
+	struct bfi_fabric_port_status_s	*status_rsp;
+	struct bfi_fabric_auth_start_rsp_s	*auth_rsp;
+};
+
+#pragma pack()
+
+#endif /* __BFI_FABRIC_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_fcpim.h patch/drivers/scsi/bfa/include/bfi/bfi_fcpim.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_fcpim.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_fcpim.h	2009-03-23 15:33:14.060790000 -0700
@@ -0,0 +1,360 @@
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
+#ifndef __BFI_FCPIM_H__
+#define __BFI_FCPIM_H__
+
+#include "bfi.h"
+#include <protocol/bfa_protocol.h>
+
+#pragma pack(1)
+
+/*
+ * Initiator mode I-T nexus interface defines.
+ */
+
+enum bfi_itnim_h2i {
+	BFI_ITNIM_H2I_CREATE_REQ = 1,	/*  i-t nexus creation */
+	BFI_ITNIM_H2I_DELETE_REQ = 2,	/*  i-t nexus deletion */
+
+	/*
+	 * These following messages are added as part of FCS
+	 * functionality in f/w
+	 */
+	BFI_ITNIM_H2I_PRLO_RSP = 3,	/*  bfa response to PRLO handling */
+};
+
+enum bfi_itnim_i2h {
+	BFI_ITNIM_I2H_CREATE_RSP = BFA_I2HM(1),
+	BFI_ITNIM_I2H_DELETE_RSP = BFA_I2HM(2),
+	BFI_ITNIM_I2H_SLER_EVENT = BFA_I2HM(3),
+
+	/*
+	 * These following messages are added as part of FCS
+	 * functionality in f/w
+	 */
+	BFI_ITNIM_I2H_UP        = BFA_I2HM(4),
+	BFI_ITNIM_I2H_DOWN	= BFA_I2HM(5),
+	BFI_ITNIM_I2H_PRLO	= BFA_I2HM(6),
+};
+
+struct bfi_itnim_create_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		 */
+	u16        itnim_tag;	/*  itnim tag	 		*/
+	u8         class;		/*  FC class for IO		 */
+	u8         seq_rec;	/*  sequence recovery support	 */
+	u8         msg_no;		/*  seq id of the msg		 */
+	u8 rsvd[3];
+};
+
+struct bfi_itnim_create_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		 */
+	u16        itnim_tag;	/*  itnim tag	 		 */
+	u8         status;		/*  fcp request status		 */
+	u8         seq_id;		/*  seq id of the msg		 */
+};
+
+struct bfi_itnim_delete_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		 */
+	u16        itnim_tag;	/*  itnim tag		 	 */
+	u8         seq_id;		/*  seq id of the msg		 */
+	u8         rsvd;
+};
+
+struct bfi_itnim_delete_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		 */
+	u16        itnim_tag;	/*  itnim tag	 		*/
+	u8         status;		/*  fcp request status		 */
+	u8         seq_id;		/*  seq id of the msg		 */
+};
+
+struct bfi_itnim_sler_event_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		 */
+	u16        itnim_tag;	/*  itnim tag	 		*/
+	u16        rsvd;
+};
+
+union bfi_itnim_h2i_msg_u {
+	struct bfi_itnim_create_req_s *create_req;
+	struct bfi_itnim_delete_req_s *delete_req;
+	struct bfi_itnim_prlo_rsp_s	*prlo_rsp;
+	struct bfi_msg_s      *msg;
+};
+
+union bfi_itnim_i2h_msg_u {
+	struct bfi_itnim_create_rsp_s *create_rsp;
+	struct bfi_itnim_delete_rsp_s *delete_rsp;
+	struct bfi_itnim_sler_event_s *sler_event;
+	struct bfi_itnim_add_event_s	*add_event;
+	struct bfi_itnim_remove_event_s *remove_event;
+	struct bfi_itnim_prlo_event_s	*prlo_event;
+	struct bfi_msg_s      *msg;
+};
+
+struct bfi_itnim_add_event_s {
+	struct 		bfi_mhdr_s  mh;	/*  common msg header		*/
+	u16        itnim_tag;	/*  itnim tag	 		*/
+	u8         class;		/*  FC class for IO		*/
+	u8         seq_rec;	/*  sequence recovery support	*/
+	u8         rec_support;	/*  REC support	*/
+	u8         task_retry_id;	/*  task retry support	*/
+	u8         confirm;	/*  fcp confirmation supp	*/
+	u8         msg_no;		/*  seq id of the msg		*/
+};
+
+struct bfi_itnim_remove_event_s {
+	struct		bfi_mhdr_s  mh;	/*  common msg header		 */
+	u16        itnim_tag;	/*  itnim tag	 		*/
+	u16        rsvd;
+};
+
+struct bfi_itnim_prlo_event_s {
+	struct		bfi_mhdr_s  mh;	/*  common msg header		 */
+	u16        itnim_tag;	/*  itnim tag	 		*/
+	u16        rsvd;
+};
+
+struct bfi_itnim_prlo_rsp_s {
+	struct		bfi_mhdr_s  mh;	/*  common msg header		 */
+	u16        itnim_tag;	/*  itnim tag	 		*/
+	u16        rsvd;
+};
+
+/*
+ * Initiator mode IO interface defines.
+ */
+enum bfi_ioim_h2i {
+	BFI_IOIM_H2I_IOABORT_REQ = 1,	/*  IO abort request	 */
+	BFI_IOIM_H2I_IOCLEANUP_REQ = 2,	/*  IO cleanup request	 */
+};
+
+enum bfi_ioim_i2h {
+	BFI_IOIM_I2H_IO_RSP = BFA_I2HM(1),	/*  non-fp IO response	 */
+	BFI_IOIM_I2H_IOABORT_RSP = BFA_I2HM(2),/*  ABORT rsp	 */
+};
+
+/**
+ * IO command DIF info
+ */
+struct bfi_ioim_dif_s {
+	u32	dif_info[4];
+};
+
+/**
+ * FCP IO messages overview
+ *
+ * @note
+ * - Max CDB length supported is 64 bytes.
+ * - SCSI Linked commands and SCSI bi-directional Commands not
+ * 	 supported.
+ *
+ */
+struct bfi_ioim_req_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header		 */
+	u16        io_tag;		/*  I/O tag			 */
+	u16        rport_hdl;	/*  itnim/rport firmware handle */
+	struct fcp_cmnd_s      cmnd;	/*  IO request info		 */
+
+	/**
+	 * SG elements array within the IO request must be double word
+	 * aligned. This aligment is required to optimize SGM setup for the IO.
+	 */
+	struct bfi_sge_s   sges[BFI_SGE_INLINE_MAX];
+	u8         io_timeout;
+	u8         dif_en;
+	u8         rsvd_a[2];
+	struct bfi_ioim_dif_s  dif;
+};
+
+/**
+ * 	This table shows various IO status codes from firmware and their
+ *	meaning. Host driver can use these status codes to further process
+ *	IO completions.
+ *
+ * 	BFI_IOIM_STS_OK		: IO completed with error free SCSI &
+ *					   transport status.
+ * 					   - io-tag can be reused.
+ *
+ * 	BFA_IOIM_STS_SCSI_ERR		: IO completed with scsi error.
+ * 					  - io-tag can be reused.
+ *
+ * 	BFI_IOIM_STS_HOST_ABORTED	: IO was aborted successfully due to
+ *					   host request.
+ * 					   - io-tag cannot be reused yet.
+ *
+ * 	BFI_IOIM_STS_ABORTED		: IO was aborted successfully
+ *					   internally by f/w.
+ * 					   - io-tag cannot be reused yet.
+ *
+ * 	BFI_IOIM_STS_TIMEDOUT	: IO timedout and ABTS/RRQ is happening
+ *					   in the firmware and
+ * 					   - io-tag cannot be reused yet.
+ *
+ * 	BFI_IOIM_STS_SQER_NEEDED	: Firmware could not recover the IO
+ *					  with sequence level error
+ * 					  logic and hence host needs to retry
+ *					  this IO with a different IO tag
+ * 					  - io-tag cannot be used yet.
+ *
+ * 	BFI_IOIM_STS_NEXUS_ABORT	: Second Level Error Recovery from host
+ *					  is required because 2 consecutive ABTS
+ *					  timedout and host needs logout and
+ *					  re-login with the target
+ * 					  - io-tag cannot be used yet.
+ *
+ * 	BFI_IOIM_STS_UNDERRUN	: IO completed with SCSI status good,
+ *					  but the data tranferred is less than
+ *					  the fcp data length in the command.
+ *					  ex. SCSI INQUIRY where transferred
+ *					  data length and residue count in FCP
+ *					  response accounts for total fcp-dl
+ * 					  - io-tag can be reused.
+ *
+ * 	BFI_IOIM_STS_OVERRUN	: IO completed with SCSI status good,
+ *					  but the data transerred is more than
+ *					  fcp data length in the command. ex.
+ *					  TAPE IOs where blocks can of unequal
+ *					  lengths.
+ * 					  - io-tag can be reused.
+ *
+ * 	BFI_IOIM_STS_RES_FREE	: Firmware has completed using io-tag
+ *					  during abort process
+ * 					  - io-tag can be reused.
+ *
+ * 	BFI_IOIM_STS_PROTO_ERR	: Firmware detected a protocol error.
+ *					  ex target sent more data than
+ *					  requested, or there was data frame
+ *					  loss and other reasons
+ * 					  - io-tag cannot be used yet.
+ *
+ * 	BFI_IOIM_STS_DIF_ERR	: Firwmare detected DIF error. ex: DIF
+ * 					  CRC err or Ref Tag err or App tag err.
+ * 					  - io-tag can be reused.
+ *
+ * 	BFA_IOIM_STS_TSK_MGT_ABORT	: IO was aborted because of Task
+ *					  Management command from the host
+ * 					  - io-tag can be reused.
+ *
+ * 	BFI_IOIM_STS_UTAG		: Firmware does not know about this
+ *					  io_tag.
+ * 					  - io-tag can be reused.
+ */
+enum bfi_ioim_status {
+	BFI_IOIM_STS_OK = 0,
+	BFI_IOIM_STS_HOST_ABORTED = 1,
+	BFI_IOIM_STS_ABORTED = 2,
+	BFI_IOIM_STS_TIMEDOUT = 3,
+	BFI_IOIM_STS_RES_FREE = 4,
+	BFI_IOIM_STS_SQER_NEEDED = 5,
+	BFI_IOIM_STS_PROTO_ERR = 6,
+	BFI_IOIM_STS_UTAG = 7,
+	BFI_IOIM_STS_PATHTOV = 8,
+};
+
+struct bfi_ioim_rsp_info_s {
+	u16        io_tag;		/*  completed IO tag		 */
+	u16        bfa_rport_hndl;	/*  releated rport handle	 */
+	u8         io_status;	/*  IO completion status	 */
+	u8         reuse_io_tag;	/*  IO tag can be reused        */
+	u16	abort_tag;	/*  host abort request tag      */
+};
+
+#define BFI_IOIM_RSP_PAD					\
+	((sizeof(struct fchs_s) - sizeof(struct bfi_mhdr_s) -		\
+	  sizeof(struct bfi_ioim_rsp_info_s)) / sizeof(u32))
+#define BFI_IOIM_SNSLEN	(256)
+
+/**
+ * I/O response message
+ */
+struct bfi_ioim_rsp_s {
+	struct bfi_mhdr_s  mh;          /*  common msg header           */
+	u16        io_tag;         /*  completed IO tag            */
+	u16        bfa_rport_hndl; /*  releated rport handle       */
+	u8         io_status;      /*  IO completion status        */
+	u8         reuse_io_tag;   /*  IO tag can be reused        */
+	u16        abort_tag;      /*  host abort request tag      */
+	u8         scsi_status;    /*  scsi status from target     */
+	u8         sns_len;        /*  scsi sense length           */
+	u8         resid_flags;    /*  IO residue flags            */
+	u8         rsvd_a;
+	u32        residue;        /*  IO residual length in bytes */
+	u32        rsvd_b[3];
+};
+
+struct bfi_ioim_abort_req_s {
+	struct bfi_mhdr_s  mh;          /*  Common msg header  */
+	u16        io_tag;         /*  I/O tag            */
+	u16        abort_tag;      /*  unique request tag */
+};
+
+/*
+ * Initiator mode task management command interface defines.
+ */
+
+enum bfi_tskim_h2i {
+	BFI_TSKIM_H2I_TM_REQ    = 1, /*  task-mgmt command         */
+	BFI_TSKIM_H2I_ABORT_REQ = 2, /*  task-mgmt command         */
+};
+
+enum bfi_tskim_i2h {
+	BFI_TSKIM_I2H_TM_RSP = BFA_I2HM(1),
+};
+
+struct bfi_tskim_req_s {
+	struct bfi_mhdr_s  mh;             /*  Common msg header          */
+	u16        tsk_tag;        /*  task management tag        */
+	u16        itn_fhdl;       /*  itn firmware handle        */
+	lun_t           lun;            /*  LU number                  */
+	u8         tm_flags;       /*  see fcp_tm_cmnd_t          */
+	u8         t_secs;         /*  Timeout value in seconds   */
+	u8         rsvd[2];
+};
+
+struct bfi_tskim_abortreq_s {
+	struct bfi_mhdr_s  mh;             /*  Common msg header          */
+	u16        tsk_tag;        /*  task management tag        */
+	u16        rsvd;
+};
+
+enum bfi_tskim_status {
+	/*
+	 * Following are FCP-4 spec defined status codes,
+	 * **DO NOT CHANGE THEM **
+	 */
+	BFI_TSKIM_STS_OK       = 0,
+	BFI_TSKIM_STS_NOT_SUPP = 4,
+	BFI_TSKIM_STS_FAILED   = 5,
+
+	/**
+	 * Defined by BFA
+	 */
+	BFI_TSKIM_STS_TIMEOUT  = 10,    /*  TM request timedout     */
+	BFI_TSKIM_STS_ABORTED  = 11,    /*  Aborted on host request */
+};
+
+struct bfi_tskim_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header		 */
+	u16        tsk_tag;	/*  task mgmt cmnd tag		 */
+	u8         tsk_status;	/*  @ref bfi_tskim_status */
+	u8         rsvd;
+};
+
+#pragma pack()
+
+#endif /* __BFI_FCPIM_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_fcxp.h patch/drivers/scsi/bfa/include/bfi/bfi_fcxp.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_fcxp.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_fcxp.h	2009-03-23 15:33:14.071114000 -0700
@@ -0,0 +1,71 @@
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
+#ifndef __BFI_FCXP_H__
+#define __BFI_FCXP_H__
+
+#include "bfi.h"
+
+#pragma pack(1)
+
+enum bfi_fcxp_h2i {
+	BFI_FCXP_H2I_SEND_REQ = 1,
+};
+
+enum bfi_fcxp_i2h {
+	BFI_FCXP_I2H_SEND_RSP = BFA_I2HM(1),
+};
+
+#define BFA_FCXP_MAX_SGES	2
+
+/**
+ * FCXP send request structure
+ */
+struct bfi_fcxp_send_req_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header		    */
+	u16        fcxp_tag;	/*  driver request tag		    */
+	u16        max_frmsz;	/*  max send frame size	    */
+	u16        vf_id;		/*  vsan tag if applicable	    */
+	u16        rport_fw_hndl;	/*  FW Handle for the remote port  */
+	u8         class;		/*  FC class used for req/rsp	    */
+	u8         rsp_timeout;	/*  timeout in secs, 0-no response */
+	u8         cts;		/*  continue sequence		    */
+	u8         rsvd;
+	struct fchs_s   fchs;		/*  request FC header structure    */
+	u32        req_len;	/*  request payload length	    */
+	u32        rsp_maxlen;	/*  max response length expected   */
+	struct bfi_sge_s   req_sge[BFA_FCXP_MAX_SGES];	/*  request buf    */
+	struct bfi_sge_s   rsp_sge[BFA_FCXP_MAX_SGES];	/*  response buf   */
+};
+
+/**
+ * FCXP send response structure
+ */
+struct bfi_fcxp_send_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header		    */
+	u16        fcxp_tag;	/*  send request tag		    */
+	u8         req_status;	/*  request status		    */
+	u8         rsvd;
+	u32        rsp_len;	/*  actual response length	    */
+	u32        residue_len;	/*  residual response length	    */
+	struct fchs_s   fchs;		/*  response FC header structure   */
+};
+
+#pragma pack()
+
+#endif /* __BFI_FCXP_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_ioc.h patch/drivers/scsi/bfa/include/bfi/bfi_ioc.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_ioc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_ioc.h	2009-03-23 15:33:14.079187000 -0700
@@ -0,0 +1,193 @@
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
+#ifndef __BFI_IOC_H__
+#define __BFI_IOC_H__
+
+#include "bfi.h"
+#include <defs/bfa_defs_ioc.h>
+
+#pragma pack(1)
+
+enum bfi_ioc_h2i_msgs {
+	BFI_IOC_H2I_ENABLE_REQ 		= 1,
+	BFI_IOC_H2I_DISABLE_REQ 	= 2,
+	BFI_IOC_H2I_GETATTR_REQ 	= 3,
+	BFI_IOC_H2I_DBG_SYNC	 	= 4,
+	BFI_IOC_H2I_DBG_DUMP	 	= 5,
+};
+
+enum bfi_ioc_i2h_msgs {
+	BFI_IOC_I2H_ENABLE_REPLY	= BFA_I2HM(1),
+	BFI_IOC_I2H_DISABLE_REPLY 	= BFA_I2HM(2),
+	BFI_IOC_I2H_GETATTR_REPLY 	= BFA_I2HM(3),
+	BFI_IOC_I2H_READY_EVENT 	= BFA_I2HM(4),
+};
+
+/**
+ * BFI_IOC_H2I_GETATTR_REQ message
+ */
+struct bfi_ioc_getattr_req_s {
+	struct bfi_mhdr_s	mh;
+	union bfi_addr_u	attr_addr;
+};
+
+struct bfi_ioc_attr_s {
+	wwn_t           mfg_wwn;
+	struct mac_s	mfg_mac;
+	u16	rsvd_a;
+	char            brcd_serialnum[STRSZ(BFA_MFG_SERIALNUM_SIZE)];
+	u8         pcie_gen;
+	u8         pcie_lanes_orig;
+	u8         pcie_lanes;
+	u8         rx_bbcredit;	/*  receive buffer credits */
+	u32        adapter_prop;	/*  adapter properties     */
+	u16        maxfrsize;	/*  max receive frame size */
+	char         	asic_rev;
+	u8         rsvd_b;
+	char            fw_version[BFA_VERSION_LEN];
+	char            optrom_version[BFA_VERSION_LEN];
+	struct bfa_mfg_vpd_s	vpd;
+};
+
+/**
+ * BFI_IOC_I2H_GETATTR_REPLY message
+ */
+struct bfi_ioc_getattr_reply_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header          */
+	u8		status;	/*  cfg reply status           */
+	u8		rsvd[3];
+};
+
+/**
+ * Firmware memory page offsets
+ */
+#define BFI_IOC_SMEM_PG0_CB	(0x40)
+#define BFI_IOC_SMEM_PG0_CT	(0x180)
+
+/**
+ * Firmware trace offset
+ */
+#define BFI_IOC_TRC_OFF		(0x4b00)
+#define BFI_IOC_TRC_ENTS	128
+
+#define BFI_IOC_FW_SIGNATURE	(0xbfadbfad)
+struct bfi_ioc_image_hdr_s {
+	u32        signature;	/*  constant signature */
+	u32        cksum;		/*  firmware checksum  */
+	u32        exec;		/*  exec vector        */
+	u32        param;		/*  parameters         */
+};
+
+/**
+ *  BFI_IOC_I2H_READY_EVENT message
+ */
+struct bfi_ioc_rdy_event_s {
+	struct bfi_mhdr_s  mh;			/*  common msg header */
+	u8         init_status;	/*  init event status */
+	u8         rsvd[3];
+};
+
+/**
+ * IOC hardware/firmware state
+ */
+enum bfi_ioc_state {
+	BFI_IOC_UNINIT 	 = 0,		/*  not initialized                 */
+	BFI_IOC_INITING 	 = 1,	/*  h/w is being initialized        */
+	BFI_IOC_HWINIT 	 = 2,		/*  h/w is initialized              */
+	BFI_IOC_CFG 	 = 3,		/*  IOC configuration in progress   */
+	BFI_IOC_OP 		 = 4,	/*  IOC is operational              */
+	BFI_IOC_DISABLING 	 = 5,	/*  IOC is being disabled           */
+	BFI_IOC_DISABLED 	 = 6,	/*  IOC is disabled                 */
+	BFI_IOC_CFG_DISABLED = 7,	/*  IOC is being disabled;transient */
+	BFI_IOC_HBFAIL       = 8,	/*  IOC heart-beat failure          */
+	BFI_IOC_MEMTEST      = 9,	/*  IOC is doing memtest            */
+};
+
+#define BFI_IOC_ENDIAN_SIG  0x12345678
+
+enum {
+	BFI_ADAPTER_TYPE_FC   = 0x01,		/*  FC adapters           */
+	BFI_ADAPTER_TYPE_MK   = 0x0f0000,	/*  adapter type mask     */
+	BFI_ADAPTER_TYPE_SH   = 16,	        /*  adapter type shift    */
+	BFI_ADAPTER_NPORTS_MK = 0xff00,		/*  number of ports mask  */
+	BFI_ADAPTER_NPORTS_SH = 8,	        /*  number of ports shift */
+	BFI_ADAPTER_SPEED_MK  = 0xff,		/*  adapter speed mask    */
+	BFI_ADAPTER_SPEED_SH  = 0,	        /*  adapter speed shift   */
+	BFI_ADAPTER_PROTO     = 0x100000,	/*  prototype adapaters   */
+	BFI_ADAPTER_TTV       = 0x200000,	/*  TTV debug capable     */
+	BFI_ADAPTER_UNSUPP    = 0x400000,	/*  unknown adapter type  */
+};
+
+#define BFI_ADAPTER_GETP(__prop,__adap_prop)          		\
+    (((__adap_prop) & BFI_ADAPTER_ ## __prop ## _MK) >>         \
+     BFI_ADAPTER_ ## __prop ## _SH)
+#define BFI_ADAPTER_SETP(__prop, __val)         		\
+    ((__val) << BFI_ADAPTER_ ## __prop ## _SH)
+#define BFI_ADAPTER_IS_PROTO(__adap_type)   			\
+    ((__adap_type) & BFI_ADAPTER_PROTO)
+#define BFI_ADAPTER_IS_TTV(__adap_type)     			\
+    ((__adap_type) & BFI_ADAPTER_TTV)
+#define BFI_ADAPTER_IS_UNSUPP(__adap_type)  			\
+    ((__adap_type) & BFI_ADAPTER_UNSUPP)
+#define BFI_ADAPTER_IS_SPECIAL(__adap_type)                     \
+    ((__adap_type) & (BFI_ADAPTER_TTV | BFI_ADAPTER_PROTO |     \
+			BFI_ADAPTER_UNSUPP))
+
+/**
+ * BFI_IOC_H2I_ENABLE_REQ & BFI_IOC_H2I_DISABLE_REQ messages
+ */
+struct bfi_ioc_ctrl_req_s {
+	struct bfi_mhdr_s	mh;
+	u8			ioc_class;
+	u8         	rsvd[3];
+};
+
+/**
+ * BFI_IOC_I2H_ENABLE_REPLY & BFI_IOC_I2H_DISABLE_REPLY messages
+ */
+struct bfi_ioc_ctrl_reply_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header     */
+	u8         status;		/*  enable/disable status */
+	u8         rsvd[3];
+};
+
+#define BFI_IOC_MSGSZ   8
+/**
+ * H2I Messages
+ */
+union bfi_ioc_h2i_msg_u {
+	struct bfi_mhdr_s 	mh;
+	struct bfi_ioc_ctrl_req_s enable_req;
+	struct bfi_ioc_ctrl_req_s disable_req;
+	struct bfi_ioc_getattr_req_s getattr_req;
+	u32       		mboxmsg[BFI_IOC_MSGSZ];
+};
+
+/**
+ * I2H Messages
+ */
+union bfi_ioc_i2h_msg_u {
+	struct bfi_mhdr_s      	mh;
+	struct bfi_ioc_rdy_event_s 	rdy_event;
+	u32       		mboxmsg[BFI_IOC_MSGSZ];
+};
+
+#pragma pack()
+
+#endif /* __BFI_IOC_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_iocfc.h patch/drivers/scsi/bfa/include/bfi/bfi_iocfc.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_iocfc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_iocfc.h	2009-03-23 15:33:14.087139000 -0700
@@ -0,0 +1,150 @@
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
+#ifndef __BFI_IOCFC_H__
+#define __BFI_IOCFC_H__
+
+#include "bfi.h"
+#include <defs/bfa_defs_ioc.h>
+#include <defs/bfa_defs_iocfc.h>
+#include <defs/bfa_defs_port.h>
+
+#pragma pack(1)
+
+enum bfi_iocfc_h2i_msgs {
+	BFI_IOCFC_H2I_CFG_REQ 		= 1,
+	BFI_IOCFC_H2I_GET_STATS_REQ 	= 2,
+	BFI_IOCFC_H2I_CLEAR_STATS_REQ	= 3,
+	BFI_IOCFC_H2I_SET_INTR_REQ 	= 4,
+};
+
+enum bfi_iocfc_i2h_msgs {
+	BFI_IOCFC_I2H_CFG_REPLY		= BFA_I2HM(1),
+	BFI_IOCFC_I2H_GET_STATS_RSP 	= BFA_I2HM(2),
+	BFI_IOCFC_I2H_CLEAR_STATS_RSP	= BFA_I2HM(3),
+};
+
+struct bfi_iocfc_cfg_s {
+	u8         num_cqs; 	/*  Number of CQs to be used     */
+	u8         sense_buf_len;	/*  SCSI sense length            */
+	u8         trunk_enabled;	/*  port trunking enabled        */
+	u8         trunk_ports;	/*  trunk ports bit map          */
+	u8		fw_disc_enabled;/*  f/w device discovery mode
+					 * 1 - f/w disc enabled
+					 * 0 - f/w disc not enabled
+					 */
+	u8		rport_del_tov;	/* rport delete timeout in secs	  */
+	u8		bport_role;	/* base port operating mode	  */
+	u8		rsvd;
+	u8	bport_sym_name[BFA_SYMNAME_MAXLEN];/* bport symbolic name */
+	u32 	endian_sig;	/*  endian signature of host     */
+
+	/**
+	 * Request and response circular queue base addresses, size and
+	 * shadow index pointers.
+	 */
+	union bfi_addr_u  req_cq_ba[BFI_IOC_MAX_CQS];
+	union bfi_addr_u  req_shadow_ci[BFI_IOC_MAX_CQS];
+	u16    req_cq_elems[BFI_IOC_MAX_CQS];
+	union bfi_addr_u  rsp_cq_ba[BFI_IOC_MAX_CQS];
+	union bfi_addr_u  rsp_shadow_pi[BFI_IOC_MAX_CQS];
+	u16    rsp_cq_elems[BFI_IOC_MAX_CQS];
+
+	union bfi_addr_u  stats_addr;	/*  DMA-able address for stats	  */
+	union bfi_addr_u  cfgrsp_addr;	/*  config response dma address  */
+	union bfi_addr_u  ioim_snsbase;  /*  IO sense buffer base address */
+	struct bfa_iocfc_intr_attr_s intr_attr; /*  IOC interrupt attributes */
+};
+
+struct bfi_iocfc_cfgrsp_s {
+	struct bfa_iocfc_fwcfg_s	fwcfg;
+	struct bfa_iocfc_intr_attr_s	intr_attr;
+};
+
+/**
+ * BFI_IOCFC_H2I_CFG_REQ message
+ */
+struct bfi_iocfc_cfg_req_s {
+	struct bfi_mhdr_s      mh;
+	union bfi_addr_u      ioc_cfg_dma_addr;
+};
+
+/**
+ * BFI_IOCFC_I2H_CFG_REPLY message
+ */
+struct bfi_iocfc_cfg_reply_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header          */
+	u8         cfg_success;	/*  cfg reply status           */
+	u8         lpu_bm;		/*  LPUs assigned for this IOC */
+	u8         rsvd[2];
+};
+
+/**
+ *  BFI_IOCFC_H2I_GET_STATS_REQ & BFI_IOCFC_H2I_CLEAR_STATS_REQ messages
+ */
+struct bfi_iocfc_stats_req_s {
+	struct bfi_mhdr_s mh;		/*  msg header            */
+	u32        msgtag;		/*  msgtag for reply      */
+};
+
+/**
+ * BFI_IOCFC_I2H_GET_STATS_RSP & BFI_IOCFC_I2H_CLEAR_STATS_RSP messages
+ */
+struct bfi_iocfc_stats_rsp_s {
+	struct bfi_mhdr_s mh;		/*  common msg header     */
+	u8         status;		/*  reply status          */
+	u8         rsvd[3];
+	u32        msgtag;		/*  msgtag for reply      */
+};
+
+/**
+ * BFI_IOCFC_H2I_SET_INTR_REQ message
+ */
+struct bfi_iocfc_set_intr_req_s {
+	struct bfi_mhdr_s mh;		/*  common msg header     */
+	u8		coalesce;	/*  enable intr coalescing*/
+	u8         rsvd[3];
+	u16	delay;		/*  delay timer 0..1125us  */
+	u16	latency;	/*  latency timer 0..225us */
+};
+
+/**
+ * H2I Messages
+ */
+union bfi_iocfc_h2i_msg_u {
+	struct bfi_mhdr_s 		mh;
+	struct bfi_iocfc_cfg_req_s 	cfg_req;
+	struct bfi_iocfc_stats_req_s stats_get;
+	struct bfi_iocfc_stats_req_s stats_clr;
+	u32       			mboxmsg[BFI_IOC_MSGSZ];
+};
+
+/**
+ * I2H Messages
+ */
+union bfi_iocfc_i2h_msg_u {
+	struct bfi_mhdr_s      		mh;
+	struct bfi_iocfc_cfg_reply_s 		cfg_reply;
+	struct bfi_iocfc_stats_rsp_s stats_get_rsp;
+	struct bfi_iocfc_stats_rsp_s stats_clr_rsp;
+	u32       			mboxmsg[BFI_IOC_MSGSZ];
+};
+
+#pragma pack()
+
+#endif /* __BFI_IOCFC_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_lport.h patch/drivers/scsi/bfa/include/bfi/bfi_lport.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_lport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_lport.h	2009-03-23 15:33:14.122808000 -0700
@@ -0,0 +1,71 @@
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
+#ifndef __BFI_LPORT_H__
+#define __BFI_LPORT_H__
+
+#include <protocol/types.h>
+#include <defs/bfa_defs_port.h>
+#include <bfi/bfi.h>
+
+#pragma pack(1)
+
+/*
+enum bfi_lport_h2i_msgs {
+};
+*/
+
+enum bfi_lport_i2h_msgs {
+	BFI_LPORT_I2H_EVENT = BFA_I2HM(1)
+};
+
+enum bfi_lport_state_e {
+	BFI_LPORT_ONLINE = 1,
+	BFI_LPORT_OFFLINE = 2,
+	BFI_LPORT_DELETE = 3
+};
+
+struct bfi_lport_event_s {
+	struct bfi_mhdr_s	mh;	/*  common msg header	*/
+	u32 pid:24,
+			 lport_state:8;	/* see bfi_lport_state */
+	u16	fabric_tag;
+	u16	lport_tag;
+};
+
+union bfi_lport_h2i_msg_u {
+	struct bfi_msg_s		*msg;
+};
+
+union bfi_lport_i2h_msg_u {
+	struct bfi_msg_s		*msg;
+	struct bfi_lport_event_s	*event;
+};
+
+struct bfi_lport_cfg_s  {
+	wwn_t	pwwn;	/*  port wwn */
+	wwn_t	nwwn;	/*  node wwn */
+	u8	roles;	/*  port roles - see bfa_port_role */
+	u8 rsvd[3];
+};
+
+#define BFI_LPORT_PSNLEN	(128)	/* Length of Port Symbolic Name */
+
+#pragma pack()
+
+#endif /* __BFI_LPORT_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_lps.h patch/drivers/scsi/bfa/include/bfi/bfi_lps.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_lps.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_lps.h	2009-03-23 15:33:14.156497000 -0700
@@ -0,0 +1,95 @@
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
+#ifndef __BFI_LPS_H__
+#define __BFI_LPS_H__
+
+#include <bfi/bfi.h>
+
+#pragma pack(1)
+
+enum bfi_lps_h2i_msgs {
+	BFI_LPS_H2I_LOGIN_REQ	= 1,
+	BFI_LPS_H2I_LOGOUT_REQ	= 2,
+};
+
+enum bfi_lps_i2h_msgs {
+	BFI_LPS_H2I_LOGIN_RSP	= BFA_I2HM(1),
+	BFI_LPS_H2I_LOGOUT_RSP	= BFA_I2HM(2),
+};
+
+struct bfi_lps_login_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u8		lp_tag;
+	u8		alpa;
+	u16	pdu_size;
+	wwn_t		pwwn;
+	wwn_t		nwwn;
+	u8		fdisc;
+	u8		auth_en;
+	u8		rsvd[2];
+};
+
+struct bfi_lps_login_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u8		lp_tag;
+	u8		status;
+	u8		lsrjt_rsn;
+	u8		lsrjt_expl;
+	u16	bb_credit;
+	u8		f_port;
+	u8  	brcd_switch;/*  attached peer is brcd switch	*/
+	u8		npiv_en;
+	u32	lp_pid : 24;
+	u32	auth_req : 8;
+	wwn_t		port_name;
+	wwn_t		node_name;
+	struct mac_s	lp_mac;
+	struct mac_s	fcf_mac;
+};
+
+struct bfi_lps_logout_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u8		lp_tag;
+	u8		rsvd[3];
+	wwn_t		port_name;
+};
+
+struct bfi_lps_logout_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u8		lp_tag;
+	u8		status;
+	u8		rsvd[2];
+};
+
+union bfi_lps_h2i_msg_u {
+	struct bfi_mhdr_s		*msg;
+	struct bfi_lps_login_req_s	*login_req;
+	struct bfi_lps_logout_req_s	*logout_req;
+};
+
+union bfi_lps_i2h_msg_u {
+	struct bfi_msg_s		*msg;
+	struct bfi_lps_login_rsp_s	*login_rsp;
+	struct bfi_lps_logout_rsp_s	*logout_rsp;
+};
+
+#pragma pack()
+
+#endif /* __BFI_LPS_H__ */
+
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_pport.h patch/drivers/scsi/bfa/include/bfi/bfi_pport.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_pport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_pport.h	2009-03-23 15:33:14.164514000 -0700
@@ -0,0 +1,184 @@
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
+#ifndef __BFI_PPORT_H__
+#define __BFI_PPORT_H__
+
+#include <bfi/bfi.h>
+#include <defs/bfa_defs_pport.h>
+
+#pragma pack(1)
+
+enum bfi_pport_h2i {
+	BFI_PPORT_H2I_ENABLE_REQ		= (1),
+	BFI_PPORT_H2I_DISABLE_REQ		= (2),
+	BFI_PPORT_H2I_GET_STATS_REQ		= (3),
+	BFI_PPORT_H2I_CLEAR_STATS_REQ	= (4),
+	BFI_PPORT_H2I_SET_SVC_PARAMS_REQ	= (5),
+	BFI_PPORT_H2I_ENABLE_RX_VF_TAG_REQ	= (6),
+	BFI_PPORT_H2I_ENABLE_TX_VF_TAG_REQ	= (7),
+	BFI_PPORT_H2I_GET_QOS_STATS_REQ		= (8),
+	BFI_PPORT_H2I_CLEAR_QOS_STATS_REQ	= (9),
+};
+
+enum bfi_pport_i2h {
+	BFI_PPORT_I2H_ENABLE_RSP		= BFA_I2HM(1),
+	BFI_PPORT_I2H_DISABLE_RSP		= BFA_I2HM(2),
+	BFI_PPORT_I2H_GET_STATS_RSP		= BFA_I2HM(3),
+	BFI_PPORT_I2H_CLEAR_STATS_RSP	= BFA_I2HM(4),
+	BFI_PPORT_I2H_SET_SVC_PARAMS_RSP	= BFA_I2HM(5),
+	BFI_PPORT_I2H_ENABLE_RX_VF_TAG_RSP	= BFA_I2HM(6),
+	BFI_PPORT_I2H_ENABLE_TX_VF_TAG_RSP	= BFA_I2HM(7),
+	BFI_PPORT_I2H_EVENT			= BFA_I2HM(8),
+	BFI_PPORT_I2H_GET_QOS_STATS_RSP		= BFA_I2HM(9),
+	BFI_PPORT_I2H_CLEAR_QOS_STATS_RSP	= BFA_I2HM(10),
+};
+
+/**
+ * Generic REQ type
+ */
+struct bfi_pport_generic_req_s {
+	struct bfi_mhdr_s  mh;		/*  msg header			    */
+	u32        msgtag;		/*  msgtag for reply		    */
+};
+
+/**
+ * Generic RSP type
+ */
+struct bfi_pport_generic_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		    */
+	u8         status;		/*  port enable status		    */
+	u8         rsvd[3];
+	u32        msgtag;		/*  msgtag for reply		    */
+};
+
+/**
+ * BFI_PPORT_H2I_ENABLE_REQ
+ */
+struct bfi_pport_enable_req_s {
+	struct bfi_mhdr_s  mh;		/*  msg header			    */
+	u32        rsvd1;
+	wwn_t           nwwn;		/*  node wwn of physical port	    */
+	wwn_t           pwwn;		/*  port wwn of physical port	    */
+	struct bfa_pport_cfg_s port_cfg;	/*  port configuration	    */
+	union bfi_addr_u  stats_dma_addr;	/*  DMA address for stats  */
+	u32        msgtag;		/*  msgtag for reply		    */
+	u32        rsvd2;
+};
+
+/**
+ * BFI_PPORT_I2H_ENABLE_RSP
+ */
+#define bfi_pport_enable_rsp_t struct bfi_pport_generic_rsp_s
+
+/**
+ * BFI_PPORT_H2I_DISABLE_REQ
+ */
+#define bfi_pport_disable_req_t struct bfi_pport_generic_req_s
+
+/**
+ * BFI_PPORT_I2H_DISABLE_RSP
+ */
+#define bfi_pport_disable_rsp_t struct bfi_pport_generic_rsp_s
+
+/**
+ * BFI_PPORT_H2I_GET_STATS_REQ
+ */
+#define bfi_pport_get_stats_req_t struct bfi_pport_generic_req_s
+
+/**
+ * BFI_PPORT_I2H_GET_STATS_RSP
+ */
+#define bfi_pport_get_stats_rsp_t struct bfi_pport_generic_rsp_s
+
+/**
+ * BFI_PPORT_H2I_CLEAR_STATS_REQ
+ */
+#define bfi_pport_clear_stats_req_t struct bfi_pport_generic_req_s
+
+/**
+ * BFI_PPORT_I2H_CLEAR_STATS_RSP
+ */
+#define bfi_pport_clear_stats_rsp_t struct bfi_pport_generic_rsp_s
+
+/**
+ * BFI_PPORT_H2I_GET_QOS_STATS_REQ
+ */
+#define bfi_pport_get_qos_stats_req_t struct bfi_pport_generic_req_s
+
+/**
+ * BFI_PPORT_H2I_GET_QOS_STATS_RSP
+ */
+#define bfi_pport_get_qos_stats_rsp_t struct bfi_pport_generic_rsp_s
+
+/**
+ * BFI_PPORT_H2I_CLEAR_QOS_STATS_REQ
+ */
+#define bfi_pport_clear_qos_stats_req_t struct bfi_pport_generic_req_s
+
+/**
+ * BFI_PPORT_H2I_CLEAR_QOS_STATS_RSP
+ */
+#define bfi_pport_clear_qos_stats_rsp_t struct bfi_pport_generic_rsp_s
+
+/**
+ * BFI_PPORT_H2I_SET_SVC_PARAMS_REQ
+ */
+struct bfi_pport_set_svc_params_req_s {
+	struct bfi_mhdr_s  mh;		/*  msg header */
+	u16        tx_bbcredit;	/*  Tx credits */
+	u16        rsvd;
+};
+
+/**
+ * BFI_PPORT_I2H_SET_SVC_PARAMS_RSP
+ */
+
+/**
+ * BFI_PPORT_I2H_EVENT
+ */
+struct bfi_pport_event_s {
+	struct bfi_mhdr_s 	mh;	/*  common msg header */
+	struct bfa_pport_link_s	link_state;
+};
+
+union bfi_pport_h2i_msg_u {
+	struct bfi_mhdr_s			*mhdr;
+	struct bfi_pport_enable_req_s		*penable;
+	struct bfi_pport_generic_req_s		*pdisable;
+	struct bfi_pport_generic_req_s		*pgetstats;
+	struct bfi_pport_generic_req_s		*pclearstats;
+	struct bfi_pport_set_svc_params_req_s	*psetsvcparams;
+	struct bfi_pport_get_qos_stats_req_s	*pgetqosstats;
+	struct bfi_pport_generic_req_s		*pclearqosstats;
+};
+
+union bfi_pport_i2h_msg_u {
+	struct bfi_msg_s			*msg;
+	struct bfi_pport_generic_rsp_s		*enable_rsp;
+	struct bfi_pport_disable_rsp_s		*disable_rsp;
+	struct bfi_pport_generic_rsp_s		*getstats_rsp;
+	struct bfi_pport_clear_stats_rsp_s	*clearstats_rsp;
+	struct bfi_pport_set_svc_params_rsp_s	*setsvcparasm_rsp;
+	struct bfi_pport_get_qos_stats_rsp_s	*getqosstats_rsp;
+	struct bfi_pport_clear_qos_stats_rsp_s	*clearqosstats_rsp;
+	struct bfi_pport_event_s		*event;
+};
+
+#pragma pack()
+
+#endif /* __BFI_PPORT_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_rport.h patch/drivers/scsi/bfa/include/bfi/bfi_rport.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_rport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_rport.h	2009-03-23 15:33:14.095398000 -0700
@@ -0,0 +1,177 @@
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
+#ifndef __BFI_RPORT_H__
+#define __BFI_RPORT_H__
+
+#include <bfi/bfi.h>
+
+#pragma pack(1)
+
+enum bfi_rport_h2i_msgs {
+	BFI_RPORT_H2I_CREATE_REQ = 1,
+	BFI_RPORT_H2I_DELETE_REQ = 2,
+	BFI_RPORT_H2I_SET_SPEED_REQ  = 3,
+
+	/*
+	 * These following messages are added as part of FCS
+	 * functionality in f/w
+	 */
+	BFI_RPORT_H2I_OFFLINE_RSP  = 4,
+};
+
+enum bfi_rport_i2h_msgs {
+	BFI_RPORT_I2H_CREATE_RSP = BFA_I2HM(1),
+	BFI_RPORT_I2H_DELETE_RSP = BFA_I2HM(2),
+	BFI_RPORT_I2H_QOS_SCN    = BFA_I2HM(3),
+
+	/*
+	 * These following messages are added as part of FCS
+	 * functionality in f/w
+	 */
+	BFI_RPORT_I2H_ADD	 = BFA_I2HM(4),
+	BFI_RPORT_I2H_REMOVE	 = BFA_I2HM(5),
+	BFI_RPORT_I2H_OFFLINE	 = BFA_I2HM(6),
+	BFI_RPORT_I2H_ONLINE	 = BFA_I2HM(7),
+
+};
+
+struct bfi_rport_create_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u16        rport_tag;	/*  rport tag			*/
+	u16        max_frmsz;	/*  max rcv pdu size		*/
+	u32        pid       : 24,	/*  remote port ID		*/
+			lp_tag    : 8;	/*  local port tag		*/
+	u32        local_pid : 24,	/*  local port ID		*/
+			cisc      : 8;
+	u8         fc_class;	/*  supported FC classes	*/
+	u8         vf_en;		/*  virtual fabric enable	*/
+	u16        vf_id;		/*  virtual fabric ID		*/
+};
+
+struct bfi_rport_create_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u8         status;		/*  rport creation status	*/
+	u8         rsvd[1];
+	u16        rport_tag;	/*   rport tag	*/
+	struct bfa_rport_qos_attr_s qos_attr;  /* QoS Attributes */
+};
+
+struct bfi_rport_speed_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u16        rport_tag;	/*  rport tag	*/
+	u8		speed;		/*  rport's speed via RPSC  */
+	u8		rsvd;
+};
+
+struct bfi_rport_delete_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u16        rport_tag;	/*  rport tag */
+	u16        rsvd;
+};
+
+struct bfi_rport_offline_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u16        rport_tag;	/*  rport tag */
+	u16        rsvd;
+};
+
+struct bfi_rport_delete_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u16        rport_tag;	/*  rport tag		*/
+	u8         status;		/*  rport deletion status	*/
+	u8         rsvd;
+};
+
+struct bfi_rport_qos_scn_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u16        rport_tag;	/*  rport tag		*/
+	u16        rsvd;
+	struct bfa_rport_qos_attr_s old_qos_attr;  /* Old QoS Attributes */
+	struct bfa_rport_qos_attr_s new_qos_attr;  /* New QoS Attributes */
+};
+
+union bfi_rport_h2i_msg_u {
+	struct bfi_msg_s 		*msg;
+	struct bfi_rport_create_req_s	*create_req;
+	struct bfi_rport_delete_req_s	*delete_req;
+	struct bfi_rport_speed_req_s	*speed_req;
+	struct bfi_rport_offline_rsp_s	*offline_rsp;
+};
+
+union bfi_rport_i2h_msg_u {
+	struct bfi_msg_s 		*msg;
+	struct bfi_rport_create_rsp_s	*create_rsp;
+	struct bfi_rport_delete_rsp_s	*delete_rsp;
+	struct bfi_rport_qos_scn_s	*qos_scn_evt;
+
+	/**
+	 * FCS functionality related messages
+	 */
+	struct bfi_rport_add_s		*add;
+	struct bfi_rport_remove_s	*remove;
+	struct bfi_rport_offline_s	*offline;
+	struct bfi_rport_online_s	*online;
+};
+
+
+/**
+ * Message structures for Rport Add,Remove,offline & online from firmware to BFA
+ * Note: These messages do not have corresponding responses from BFA to f/w.
+ */
+struct bfi_rport_add_s {
+	struct 		bfi_mhdr_s  mh;	/*  common msg header		*/
+	wwn_t		pwwn;		/*  rport pwwn 		*/
+	wwn_t		nwwn;		/*  rport pwwn 		*/
+	u32        rpid      : 24,	/*  remote port ID		*/
+			lport_tag : 8;	/*  parent lport's tag 	*/
+	u32        local_pid : 24,	/*  local port ID		*/
+			cisc      : 8;
+	u16        rport_tag;	/*  rport tag			*/
+	u16        max_frmsz;	/*  max rcv pdu size		*/
+	u16        vf_id;		/*  virtual fabric ID		*/
+	u8         type;		/*  rport type - ob/ib		*/
+	u8         fc_class;	/*  supported FC classes	*/
+	u8         vf_en;		/*  virtual fabric enable	*/
+	u8         rpsc_speed;	/*  rpsc rport speed		*/
+	u8         assigned_speed;	/*  assigned rport speed	*/
+	u8		scsi_function;	/*  scsi function 		*/
+};
+
+struct bfi_rport_remove_s {
+	struct		bfi_mhdr_s  mh;	/*  common msg header		*/
+	u16        rport_tag;	/*  rport tag			*/
+	u16        rsvd;
+};
+
+struct bfi_rport_offline_s {
+	struct		bfi_mhdr_s  mh;	/*  common msg header		*/
+	u16        rport_tag;	/*  rport tag			*/
+	u16        rsvd;
+};
+
+struct bfi_rport_online_s {
+	struct		bfi_mhdr_s  mh;	/*  common msg header		*/
+	u16        rport_tag;	/*  rport tag			*/
+	u16        rsvd;
+};
+
+
+#pragma pack()
+
+#endif /* __BFI_RPORT_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_uf.h patch/drivers/scsi/bfa/include/bfi/bfi_uf.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_uf.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_uf.h	2009-03-23 15:33:14.104176000 -0700
@@ -0,0 +1,52 @@
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
+#ifndef __BFI_UF_H__
+#define __BFI_UF_H__
+
+#include "bfi.h"
+
+#pragma pack(1)
+
+enum bfi_uf_h2i {
+	BFI_UF_H2I_BUF_POST = 1,
+};
+
+enum bfi_uf_i2h {
+	BFI_UF_I2H_FRM_RCVD = BFA_I2HM(1),
+};
+
+#define BFA_UF_MAX_SGES	2
+
+struct bfi_uf_buf_post_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header		*/
+	u16        buf_tag;	/*  buffer tag			*/
+	u16        buf_len;	/*  total buffer length	*/
+	struct bfi_sge_s   sge[BFA_UF_MAX_SGES]; /*  buffer DMA SGEs	*/
+};
+
+struct bfi_uf_frm_rcvd_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header		*/
+	u16        buf_tag;	/*  buffer tag			*/
+	u16        rsvd;
+	u16        frm_len;	/*  received frame length 	*/
+	u16        xfr_len;	/*  tranferred length		*/
+};
+
+#pragma pack()
+
+#endif /* __BFI_UF_H__ */
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_vport.h patch/drivers/scsi/bfa/include/bfi/bfi_vport.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_vport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_vport.h	2009-03-23 15:33:14.148214000 -0700
@@ -0,0 +1,67 @@
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
+#ifndef __BFI_VPORT_H__
+#define __BFI_VPORT_H__
+
+#include <bfi/bfi.h>
+#include <bfi/bfi_lport.h>
+
+#pragma pack(1)
+
+enum bfi_vport_h2i_msgs {
+	BFI_VPORT_H2I_CREATE_REQ = 1,
+	BFI_VPORT_H2I_DELETE_REQ = 2,
+};
+
+enum bfi_vport_i2h_msgs {
+	BFI_VPORT_I2H_DELETE_RSP = BFA_I2HM(1)
+};
+
+struct bfi_vport_create_req_s {
+	struct bfi_mhdr_s	mh;		/*  common msg header	*/
+	union bfi_addr_u	psn_addr;	/*  port symbolic name addr */
+	u16 		fabric_tag;	/*  fabric tag		*/
+	u16 		vport_tag;	/*  vport tag		*/
+	struct bfi_lport_cfg_s	lport_cfg;	/*  lport config	*/
+};
+
+struct bfi_vport_delete_req_s {
+	struct 	bfi_mhdr_s	mh;		/*  common msg header	*/
+	u16 		fabric_tag;	/*  fabric tag		*/
+	u16 		vport_tag;	/*  vport tag		*/
+};
+
+union bfi_vport_h2i_msg_u {
+	struct bfi_mhdr_s           *mhdr;
+	struct bfi_vport_create_req_s   *create_req;
+	struct bfi_vport_delete_req_s   *delete_req;
+};
+
+struct bfi_vport_delete_rsp_s {
+	struct bfi_mhdr_s	mh;		/*  common msg header	   */
+	u16 		fabric_tag;	/*  fabric tag		   */
+	u16 		vport_tag;	/*  vport tag		   */
+	u8			status;		/*  vport deletion status */
+	u8			rsvd[3];
+};
+
+union bfi_vport_i2h_msg_u {
+	struct bfi_msg_s		*msg;
+	struct bfi_vport_delete_rsp_s	*delete_rsp;
+};
+#endif
diff -urpN orig/drivers/scsi/bfa/include/cna/pstats/ethport_defs.h patch/drivers/scsi/bfa/include/cna/pstats/ethport_defs.h
--- orig/drivers/scsi/bfa/include/cna/pstats/ethport_defs.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cna/pstats/ethport_defs.h	2009-03-23 15:33:14.286138000 -0700
@@ -0,0 +1,36 @@
+/*
+ * Copyright (c) 2006-2008 Brocade Communications Systems, Inc.
+ * All rights reserved.
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
+#ifndef __ETHPORT_DEFS_H__
+#define __ETHPORT_DEFS_H__
+
+struct bnad_drv_stats {
+	u64 netif_queue_stop;
+	u64 netif_queue_wakeup;
+	u64 tso4;
+	u64 tso6;
+	u64 tso_err;
+	u64 tcpcsum_offload;
+	u64 udpcsum_offload;
+	u64 csum_help;
+	u64 csum_help_err;
+
+	u64 hw_stats_updates;
+	u64 netif_rx_schedule;
+	u64 netif_rx_complete;
+	u64 netif_rx_dropped;
+};
+#endif
diff -urpN orig/drivers/scsi/bfa/include/cna/pstats/phyport_defs.h patch/drivers/scsi/bfa/include/cna/pstats/phyport_defs.h
--- orig/drivers/scsi/bfa/include/cna/pstats/phyport_defs.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cna/pstats/phyport_defs.h	2009-03-23 15:33:14.277818000 -0700
@@ -0,0 +1,197 @@
+/*
+ * Copyright (c) 2006-2008 Brocade Communications Systems, Inc.
+ * All rights reserved.
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
+#ifndef __PHYPORT_DEFS_H__
+#define __PHYPORT_DEFS_H__
+
+#define BNA_TXF_ID_MAX  	64
+#define BNA_RXF_ID_MAX  	64
+
+/* Statistics */
+
+/* TxF Frame Statistics */
+struct bna_stats_txf {
+	u64 ucast_octets;
+	u64 ucast;
+	u64 ucast_vlan;
+	u64 mcast_octets;
+	u64 mcast;
+	u64 mcast_vlan;
+	u64 bcast_octets;
+	u64 bcast;
+	u64 bcast_vlan;
+	u64 errors;
+	u64 filter_vlan;      /* frames filtered due to VLAN */
+	u64 filter_mac_sa;    /* frames filtered due to SA check */
+};
+
+
+/* RxF Frame Statistics */
+struct bna_stats_rxf {
+	u64 ucast_octets;
+	u64 ucast;
+	u64 ucast_vlan;
+	u64 mcast_octets;
+	u64 mcast;
+	u64 mcast_vlan;
+	u64 bcast_octets;
+	u64 bcast;
+	u64 bcast_vlan;
+	u64 frame_drops;
+};
+
+
+/* FC Tx Frame Statistics */
+struct bna_stats_fc_tx {
+	u64 txf_ucast_octets;
+	u64 txf_ucast;
+	u64 txf_ucast_vlan;
+
+	u64 txf_mcast_octets;
+	u64 txf_mcast;
+	u64 txf_mcast_vlan;
+
+	u64 txf_bcast_octets;
+	u64 txf_bcast;
+	u64 txf_bcast_vlan;
+
+	u64 txf_parity_errors;
+	u64 txf_timeout;
+	u64 txf_fid_parity_errors;
+};
+
+
+/* FC Rx Frame Statistics */
+struct bna_stats_fc_rx {
+	u64 rxf_ucast_octets;
+	u64 rxf_ucast;
+	u64 rxf_ucast_vlan;
+
+	u64 rxf_mcast_octets;
+	u64 rxf_mcast;
+	u64 rxf_mcast_vlan;
+
+	u64 rxf_bcast_octets;
+	u64 rxf_bcast;
+	u64 rxf_bcast_vlan;
+};
+
+
+/* RAD Frame Statistics */
+struct cna_stats_rad {
+	u64 rx_frames;
+	u64 rx_octets;
+	u64 rx_vlan_frames;
+
+	u64 rx_ucast;
+	u64 rx_ucast_octets;
+	u64 rx_ucast_vlan;
+
+	u64 rx_mcast;
+	u64 rx_mcast_octets;
+	u64 rx_mcast_vlan;
+
+	u64 rx_bcast;
+	u64 rx_bcast_octets;
+	u64 rx_bcast_vlan;
+
+	u64 rx_drops;
+};
+
+
+/* BPC Tx Registers */
+struct cna_stats_bpc_tx {
+	u64 tx_pause[8];
+	u64 tx_zero_pause[8]; /*  Pause cancellation */
+	u64 tx_first_pause[8];/*  Pause initiation rather than retention*/
+};
+
+
+/* BPC Rx Registers */
+struct cna_stats_bpc_rx {
+	u64 rx_pause[8];
+	u64 rx_zero_pause[8]; /*  Pause cancellation */
+	u64 rx_first_pause[8];/*  Pause initiation rather than retention*/
+};
+
+
+/* MAC Rx Statistics */
+struct cna_stats_mac_rx {
+	u64 frame_64;		/* both rx and tx counter */
+	u64 frame_65_127;		/* both rx and tx counter */
+	u64 frame_128_255;		/* both rx and tx counter */
+	u64 frame_256_511;		/* both rx and tx counter */
+	u64 frame_512_1023;	/* both rx and tx counter */
+	u64 frame_1024_1518;	/* both rx and tx counter */
+	u64 frame_1518_1522;	/* both rx and tx counter */
+	u64 rx_bytes;
+	u64 rx_packets;
+	u64 rx_fcs_error;
+	u64 rx_multicast;
+	u64 rx_broadcast;
+	u64 rx_control_frames;
+	u64 rx_pause;
+	u64 rx_unknown_opcode;
+	u64 rx_alignment_error;
+	u64 rx_frame_length_error;
+	u64 rx_code_error;
+	u64 rx_carrier_sense_error;
+	u64 rx_undersize;
+	u64 rx_oversize;
+	u64 rx_fragments;
+	u64 rx_jabber;
+	u64 rx_drop;
+};
+
+
+/* MAC Tx Statistics */
+struct cna_stats_mac_tx {
+	u64 tx_bytes;
+	u64 tx_packets;
+	u64 tx_multicast;
+	u64 tx_broadcast;
+	u64 tx_pause;
+	u64 tx_deferral;
+	u64 tx_excessive_deferral;
+	u64 tx_single_collision;
+	u64 tx_muliple_collision;
+	u64 tx_late_collision;
+	u64 tx_excessive_collision;
+	u64 tx_total_collision;
+	u64 tx_pause_honored;
+	u64 tx_drop;
+	u64 tx_jabber;
+	u64 tx_fcs_error;
+	u64 tx_control_frame;
+	u64 tx_oversize;
+	u64 tx_undersize;
+	u64 tx_fragments;
+};
+
+/* Complete statistics */
+struct bna_stats {
+	struct cna_stats_mac_rx	mac_rx_stats;
+	struct cna_stats_bpc_rx	bpc_rx_stats;
+	struct cna_stats_rad	rad_stats;
+	struct bna_stats_fc_rx	fc_rx_stats;
+	struct cna_stats_mac_tx	mac_tx_stats;
+	struct cna_stats_bpc_tx	bpc_tx_stats;
+	struct bna_stats_fc_tx	fc_tx_stats;
+	struct bna_stats_rxf	rxf_stats[BNA_TXF_ID_MAX];
+	struct bna_stats_txf	txf_stats[BNA_RXF_ID_MAX];
+};
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/cs/bfa_checksum.h patch/drivers/scsi/bfa/include/cs/bfa_checksum.h
--- orig/drivers/scsi/bfa/include/cs/bfa_checksum.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cs/bfa_checksum.h	2009-03-23 15:33:13.796562000 -0700
@@ -0,0 +1,60 @@
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
+ *  bfa_checksum.h BFA checksum utilities
+ */
+
+#ifndef __BFA_CHECKSUM_H__
+#define __BFA_CHECKSUM_H__
+
+static inline u32
+bfa_checksum_u32(u32 *buf, int sz)
+{
+	int		i, m = sz >> 2;
+	u32	sum = 0;
+
+	for (i = 0; i < m; i++)
+		sum ^= buf[i];
+
+	return (sum);
+}
+
+static inline u16
+bfa_checksum_u16(u16 *buf, int sz)
+{
+	int             i, m = sz >> 1;
+	u16        sum = 0;
+
+	for (i = 0; i < m; i++)
+		sum ^= buf[i];
+
+	return (sum);
+}
+
+static inline u8
+bfa_checksum_u8(u8 *buf, int sz)
+{
+	int             i;
+	u8         sum = 0;
+
+	for (i = 0; i < sz; i++)
+		sum ^= buf[i];
+
+	return (sum);
+}
+#endif
diff -urpN orig/drivers/scsi/bfa/include/cs/bfa_debug.h patch/drivers/scsi/bfa/include/cs/bfa_debug.h
--- orig/drivers/scsi/bfa/include/cs/bfa_debug.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cs/bfa_debug.h	2009-03-23 15:33:13.781978000 -0700
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
+ *  bfa_debug.h BFA debug interfaces
+ */
+
+#ifndef __BFA_DEBUG_H__
+#define __BFA_DEBUG_H__
+
+#define bfa_assert(__cond)	do {					\
+	if (!(__cond)) 							\
+		bfa_panic(__LINE__, __FILE__, #__cond);      \
+} while (0)
+
+#ifndef BFA_PERF_BUILD
+#define bfa_assert_fp(__cond)	bfa_assert(__cond)
+#else
+#define bfa_assert_fp(__cond)
+#endif
+
+void bfa_panic(int line, char *file, char *panicstr);
+
+#endif /* __BFA_DEBUG_H__ */
diff -urpN orig/drivers/scsi/bfa/include/cs/bfa_log.h patch/drivers/scsi/bfa/include/cs/bfa_log.h
--- orig/drivers/scsi/bfa/include/cs/bfa_log.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cs/bfa_log.h	2009-03-23 15:33:13.772872000 -0700
@@ -0,0 +1,183 @@
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
+ *  bfa_log.h BFA log library data structure and function definition
+ */
+
+#ifndef __BFA_LOG_H__
+#define __BFA_LOG_H__
+
+#include <bfa_os_inc.h>
+#include <defs/bfa_defs_status.h>
+#include <defs/bfa_defs_aen.h>
+
+/*
+ * BFA log module definition
+ *
+ * To create a new module id:
+ * Add a #define at the end of the list below. Select a value for your
+ * definition so that it is one (1) greater than the previous
+ * definition. Modify the definition of BFA_LOG_MODULE_ID_MAX to become
+ * your new definition.
+ * Should have no gaps in between the values because this is used in arrays.
+ * IMPORTANT: AEN_IDs must be at the begining, otherwise update bfa_defs_aen.h
+ */
+
+enum bfa_log_module_id {
+	BFA_LOG_UNUSED_ID	= 0,
+
+	/* AEN defs begin */
+	BFA_LOG_AEN_MIN		= BFA_LOG_UNUSED_ID,
+
+	BFA_LOG_AEN_ID_ADAPTER 	= BFA_LOG_AEN_MIN + BFA_AEN_CAT_ADAPTER,/* 1 */
+	BFA_LOG_AEN_ID_PORT 	= BFA_LOG_AEN_MIN + BFA_AEN_CAT_PORT,	/* 2 */
+	BFA_LOG_AEN_ID_LPORT 	= BFA_LOG_AEN_MIN + BFA_AEN_CAT_LPORT,	/* 3 */
+	BFA_LOG_AEN_ID_RPORT 	= BFA_LOG_AEN_MIN + BFA_AEN_CAT_RPORT,	/* 4 */
+	BFA_LOG_AEN_ID_ITNIM 	= BFA_LOG_AEN_MIN + BFA_AEN_CAT_ITNIM,	/* 5 */
+	BFA_LOG_AEN_ID_ITNTM 	= BFA_LOG_AEN_MIN + BFA_AEN_CAT_ITNTM,	/* 6 */
+	BFA_LOG_AEN_ID_IPFC 	= BFA_LOG_AEN_MIN + BFA_AEN_CAT_IPFC,	/* 7 */
+	BFA_LOG_AEN_ID_AUDIT 	= BFA_LOG_AEN_MIN + BFA_AEN_CAT_AUDIT,	/* 8 */
+	BFA_LOG_AEN_ID_IOC	= BFA_LOG_AEN_MIN + BFA_AEN_CAT_IOC,	/* 9 */
+	BFA_LOG_AEN_ID_ETHPORT	= BFA_LOG_AEN_MIN + BFA_AEN_CAT_ETHPORT,/* 10 */
+
+	BFA_LOG_AEN_MAX		= BFA_LOG_AEN_ID_ETHPORT,
+	/* AEN defs end */
+
+	BFA_LOG_MODULE_ID_MIN	= BFA_LOG_AEN_MAX,
+
+	BFA_LOG_FW_ID		= BFA_LOG_MODULE_ID_MIN + 1,
+	BFA_LOG_HAL_ID		= BFA_LOG_MODULE_ID_MIN + 2,
+	BFA_LOG_FCS_ID		= BFA_LOG_MODULE_ID_MIN + 3,
+	BFA_LOG_WDRV_ID		= BFA_LOG_MODULE_ID_MIN + 4,
+	BFA_LOG_LINUX_ID	= BFA_LOG_MODULE_ID_MIN + 5,
+	BFA_LOG_SOLARIS_ID	= BFA_LOG_MODULE_ID_MIN + 6,
+
+	BFA_LOG_MODULE_ID_MAX 	= BFA_LOG_SOLARIS_ID,
+
+	/* Not part of any arrays */
+	BFA_LOG_MODULE_ID_ALL 	= BFA_LOG_MODULE_ID_MAX + 1,
+	BFA_LOG_AEN_ALL 	= BFA_LOG_MODULE_ID_MAX + 2,
+	BFA_LOG_DRV_ALL		= BFA_LOG_MODULE_ID_MAX + 3,
+};
+
+/*
+ * BFA log catalog name
+ */
+#define BFA_LOG_CAT_NAME	"BFA"
+
+/*
+ * bfa log severity values
+ */
+enum bfa_log_severity {
+	BFA_LOG_INVALID = 0,
+	BFA_LOG_CRITICAL = 1,
+	BFA_LOG_ERROR = 2,
+	BFA_LOG_WARNING = 3,
+	BFA_LOG_INFO = 4,
+	BFA_LOG_LEVEL_MAX = BFA_LOG_INFO
+};
+
+#define BFA_LOG_MODID_OFFSET		16
+
+
+struct bfa_log_msgdef_s {
+	u32	msg_id;		/*  message id */
+	int		attributes;	/*  attributes */
+	int		severity;	/*  severity level */
+	char		*msg_value;
+					/*  msg string */
+	char		*message;
+					/*  msg format string */
+	int		arg_type;	/*  argument type */
+	int		arg_num;	/*  number of argument */
+};
+
+/*
+ * supported argument type
+ */
+enum bfa_log_arg_type {
+	BFA_LOG_S = 0,		/*  string */
+	BFA_LOG_D,		/*  decimal */
+	BFA_LOG_I,		/*  integer */
+	BFA_LOG_O,		/*  oct number */
+	BFA_LOG_U,		/*  unsigned integer */
+	BFA_LOG_X,		/*  hex number */
+	BFA_LOG_F,		/*  floating */
+	BFA_LOG_C,		/*  character */
+	BFA_LOG_L,		/*  double */
+	BFA_LOG_P		/*  pointer */
+};
+
+#define BFA_LOG_ARG_TYPE	2
+#define BFA_LOG_ARG0		(0 * BFA_LOG_ARG_TYPE)
+#define BFA_LOG_ARG1		(1 * BFA_LOG_ARG_TYPE)
+#define BFA_LOG_ARG2		(2 * BFA_LOG_ARG_TYPE)
+#define BFA_LOG_ARG3		(3 * BFA_LOG_ARG_TYPE)
+
+#define BFA_LOG_GET_MOD_ID(msgid) ((msgid >> BFA_LOG_MODID_OFFSET) & 0xff)
+#define BFA_LOG_GET_MSG_IDX(msgid) (msgid & 0xffff)
+#define BFA_LOG_GET_MSG_ID(msgdef) ((msgdef)->msg_id)
+#define BFA_LOG_GET_MSG_FMT_STRING(msgdef) ((msgdef)->message)
+#define BFA_LOG_GET_SEVERITY(msgdef) ((msgdef)->severity)
+
+/*
+ * Event attributes
+ */
+#define BFA_LOG_ATTR_NONE	0
+#define BFA_LOG_ATTR_AUDIT	1
+#define BFA_LOG_ATTR_LOG	2
+#define BFA_LOG_ATTR_FFDC	4
+
+#define BFA_LOG_CREATE_ID(msw, lsw) \
+	(((u32)msw << BFA_LOG_MODID_OFFSET) | lsw)
+
+struct bfa_log_mod_s;
+
+/**
+ * callback function
+ */
+typedef void (*bfa_log_cb_t)(struct bfa_log_mod_s *log_mod, u32 msg_id,
+			const char *format, ...);
+
+
+struct bfa_log_mod_s {
+	char		instance_info[16];	/*  instance info */
+	int		log_level[BFA_LOG_MODULE_ID_MAX + 1];
+						/*  log level for modules */
+	bfa_log_cb_t	cbfn; 			/*  callback function */
+};
+
+extern int bfa_log_init(struct bfa_log_mod_s *log_mod,
+			char *instance_name, bfa_log_cb_t cbfn);
+extern int bfa_log(struct bfa_log_mod_s *log_mod, u32 msg_id, ...);
+extern bfa_status_t bfa_log_set_level(struct bfa_log_mod_s *log_mod,
+			int mod_id, enum bfa_log_severity log_level);
+extern bfa_status_t bfa_log_set_level_all(struct bfa_log_mod_s *log_mod,
+			enum bfa_log_severity log_level);
+extern bfa_status_t bfa_log_set_level_aen(struct bfa_log_mod_s *log_mod,
+			enum bfa_log_severity log_level);
+extern enum bfa_log_severity bfa_log_get_level(struct bfa_log_mod_s *log_mod,
+			int mod_id);
+extern enum bfa_log_severity bfa_log_get_msg_level(
+			struct bfa_log_mod_s *log_mod, u32 msg_id);
+/*
+ * array of messages generated from xml files
+ */
+extern struct bfa_log_msgdef_s bfa_log_msg_array[];
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/cs/bfa_perf.h patch/drivers/scsi/bfa/include/cs/bfa_perf.h
--- orig/drivers/scsi/bfa/include/cs/bfa_perf.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cs/bfa_perf.h	2009-03-23 15:33:13.803897000 -0700
@@ -0,0 +1,34 @@
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
+#ifndef __BFAD_PERF_H__
+#define __BFAD_PERF_H__
+
+#ifdef BFAD_PERF_BUILD
+
+#undef bfa_trc
+#undef bfa_trc32
+#undef bfa_assert
+#undef BFA_TRC_FILE
+
+#define bfa_trc(_trcp, _data)
+#define bfa_trc32(_trcp, _data)
+#define bfa_assert(__cond)
+#define BFA_TRC_FILE(__mod, __submod)
+
+#endif
+
+#endif /* __BFAD_PERF_H__ */
diff -urpN orig/drivers/scsi/bfa/include/cs/bfa_plog.h patch/drivers/scsi/bfa/include/cs/bfa_plog.h
--- orig/drivers/scsi/bfa/include/cs/bfa_plog.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cs/bfa_plog.h	2009-03-23 15:33:13.811911000 -0700
@@ -0,0 +1,162 @@
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
+#ifndef __BFA_PORTLOG_H__
+#define __BFA_PORTLOG_H__
+
+#include <protocol/bfa_protocol.h>
+#include <defs/bfa_defs_types.h>
+
+#define BFA_PL_NLOG_ENTS 256
+#define BFA_PL_LOG_REC_INCR(_x) ((_x)++, (_x) %= BFA_PL_NLOG_ENTS)
+
+#define BFA_PL_STRING_LOG_SZ   32   /* number of chars in string log */
+#define BFA_PL_INT_LOG_SZ      8    /* number of integers in the integer log */
+
+enum bfa_plog_log_type {
+	BFA_PL_LOG_TYPE_INVALID = 0,
+	BFA_PL_LOG_TYPE_INT 	= 1,
+	BFA_PL_LOG_TYPE_STRING 	= 2,
+};
+
+/*
+ * the (fixed size) record format for each entry in the portlog
+ */
+struct bfa_plog_rec_s {
+	u32        tv;	/* Filled by the portlog driver when the *
+				 * entry is added to the circular log.   */
+	u8         port;	/* Source port that logged this entry. CM
+				 * entities will use 0xFF */
+	u8         mid;	/* Integer value to be used by all entities *
+				 * while logging. The module id to string   *
+				 * conversion will be done by BFAL. See
+				 * enum bfa_plog_mid */
+	u8         eid;	/* indicates Rx, Tx, IOCTL, etc. See
+				 * enum bfa_plog_eid */
+	u8         log_type; /* indicates string log or integer log.
+				   * see bfa_plog_log_type_t */
+	u8         log_num_ints;
+	/*
+	 * interpreted only if log_type is INT_LOG. indicates number of
+	 * integers in the int_log[] (0-PL_INT_LOG_SZ).
+	 */
+	u8         rsvd;
+	u16        misc;	/* can be used to indicate fc frame length,
+				 *etc.. */
+	union {
+		char            string_log[BFA_PL_STRING_LOG_SZ];
+		u32        int_log[BFA_PL_INT_LOG_SZ];
+	} log_entry;
+
+};
+
+/*
+ * the following #defines will be used by the logging entities to indicate
+ * their module id. BFAL will convert the integer value to string format
+ *
+* process to be used while changing the following #defines:
+ *  - Always add new entries at the end
+ *  - define corresponding string in BFAL
+ *  - Do not remove any entry or rearrange the order.
+ */
+enum bfa_plog_mid {
+	BFA_PL_MID_INVALID 	= 0,
+	BFA_PL_MID_DEBUG 	= 1,
+	BFA_PL_MID_DRVR 	= 2,
+	BFA_PL_MID_HAL 		= 3,
+	BFA_PL_MID_HAL_FCXP 	= 4,
+	BFA_PL_MID_HAL_UF 	= 5,
+	BFA_PL_MID_FCS 		= 6,
+	BFA_PL_MID_MAX 		= 7
+};
+
+#define BFA_PL_MID_STRLEN    8
+struct bfa_plog_mid_strings_s {
+	char            m_str[BFA_PL_MID_STRLEN];
+};
+
+/*
+ * the following #defines will be used by the logging entities to indicate
+ * their event type. BFAL will convert the integer value to string format
+ *
+* process to be used while changing the following #defines:
+ *  - Always add new entries at the end
+ *  - define corresponding string in BFAL
+ *  - Do not remove any entry or rearrange the order.
+ */
+enum bfa_plog_eid {
+	BFA_PL_EID_INVALID 		= 0,
+	BFA_PL_EID_IOC_DISABLE 		= 1,
+	BFA_PL_EID_IOC_ENABLE 		= 2,
+	BFA_PL_EID_PORT_DISABLE 	= 3,
+	BFA_PL_EID_PORT_ENABLE 		= 4,
+	BFA_PL_EID_PORT_ST_CHANGE 	= 5,
+	BFA_PL_EID_TX 			= 6,
+	BFA_PL_EID_TX_ACK1 		= 7,
+	BFA_PL_EID_TX_RJT 		= 8,
+	BFA_PL_EID_TX_BSY 		= 9,
+	BFA_PL_EID_RX 			= 10,
+	BFA_PL_EID_RX_ACK1 		= 11,
+	BFA_PL_EID_RX_RJT 		= 12,
+	BFA_PL_EID_RX_BSY 		= 13,
+	BFA_PL_EID_CT_IN 		= 14,
+	BFA_PL_EID_CT_OUT 		= 15,
+	BFA_PL_EID_DRIVER_START 	= 16,
+	BFA_PL_EID_RSCN 		= 17,
+	BFA_PL_EID_DEBUG 		= 18,
+	BFA_PL_EID_MISC 		= 19,
+	BFA_PL_EID_MAX 			= 20
+};
+
+#define BFA_PL_ENAME_STRLEN    	8
+struct bfa_plog_eid_strings_s {
+	char            e_str[BFA_PL_ENAME_STRLEN];
+};
+
+#define BFA_PL_SIG_LEN	8
+#define BFA_PL_SIG_STR  "12pl123"
+
+/*
+ * per port circular log buffer
+ */
+struct bfa_plog_s {
+	char            plog_sig[BFA_PL_SIG_LEN];	/* Start signature */
+	u8         plog_enabled;
+	u8         rsvd[7];
+	u32        ticks;
+	u16        head;
+	u16        tail;
+	struct bfa_plog_rec_s  plog_recs[BFA_PL_NLOG_ENTS];
+};
+
+void bfa_plog_init(struct bfa_plog_s *plog);
+void bfa_plog_str(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
+			enum bfa_plog_eid event, u16 misc, char *log_str);
+void bfa_plog_intarr(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
+			enum bfa_plog_eid event, u16 misc,
+			u32 *intarr, u32 num_ints);
+void bfa_plog_fchdr(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
+			enum bfa_plog_eid event, u16 misc,
+			struct fchs_s *fchdr);
+void bfa_plog_fchdr_and_pl(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
+			enum bfa_plog_eid event, u16 misc,
+			struct fchs_s *fchdr, u32 pld_w0);
+void bfa_plog_clear(struct bfa_plog_s *plog);
+void bfa_plog_enable(struct bfa_plog_s *plog);
+void bfa_plog_disable(struct bfa_plog_s *plog);
+bfa_boolean_t	bfa_plog_get_setting(struct bfa_plog_s *plog);
+
+#endif /* __BFA_PORTLOG_H__ */
diff -urpN orig/drivers/scsi/bfa/include/cs/bfa_q.h patch/drivers/scsi/bfa/include/cs/bfa_q.h
--- orig/drivers/scsi/bfa/include/cs/bfa_q.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cs/bfa_q.h	2009-03-23 15:33:13.819922000 -0700
@@ -0,0 +1,97 @@
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
+ *  bfa_q.h Circular queue definitions.
+ */
+
+#ifndef __BFA_Q_H__
+#define __BFA_Q_H__
+
+#define bfa_q_first(_q) ((void *)(((struct list_head *) (_q))->next))
+#define bfa_q_next(_qe)	(((struct list_head *) (_qe))->next)
+#define bfa_q_prev(_qe) (((struct list_head *) (_qe))->prev)
+
+/*
+ * bfa_q_qe_init - to initialize a queue element
+ */
+#define bfa_q_qe_init(_qe) {						\
+	bfa_q_next(_qe) = (struct list_head *) NULL;			\
+	bfa_q_prev(_qe) = (struct list_head *) NULL;			\
+}
+
+/*
+ * bfa_q_deq - dequeue an element from head of the queue
+ */
+#define bfa_q_deq(_q, _qe) {						\
+	if (!list_empty(_q)) {					\
+		(*((struct list_head **) (_qe))) = bfa_q_next(_q);	\
+		bfa_q_prev(bfa_q_next(*((struct list_head **) _qe))) =	\
+						(struct list_head *) (_q); \
+		bfa_q_next(_q) = bfa_q_next(*((struct list_head **) _qe)); \
+		BFA_Q_DBG_INIT(*((struct list_head **) _qe));		\
+	} else {							\
+		*((struct list_head **) (_qe)) = (struct list_head *) NULL; \
+	}								\
+}
+
+/*
+ * bfa_q_deq_tail - dequeue an element from tail of the queue
+ */
+#define bfa_q_deq_tail(_q, _qe) {					    \
+	if (!list_empty(_q)) {					            \
+		*((struct list_head **) (_qe)) = bfa_q_prev(_q);	    \
+		bfa_q_next(bfa_q_prev(*((struct list_head **) _qe))) = 	    \
+						(struct list_head *) (_q);  \
+		bfa_q_prev(_q) = bfa_q_prev(*(struct list_head **) _qe);    \
+		BFA_Q_DBG_INIT(*((struct list_head **) _qe));		    \
+	} else {							    \
+		*((struct list_head **) (_qe)) = (struct list_head *) NULL; \
+	}								    \
+}
+
+/*
+ * #ifdef BFA_DEBUG (Using bfa_assert to check for debug_build is not
+ * consistent across modules)
+ */
+#ifndef BFA_PERF_BUILD
+#define BFA_Q_DBG_INIT(_qe)	bfa_q_qe_init(_qe)
+#else
+#define BFA_Q_DBG_INIT(_qe)
+#endif
+
+#define bfa_q_is_on_q(_q, _qe)		\
+	bfa_q_is_on_q_func(_q, (struct list_head *)(_qe))
+extern int bfa_q_is_on_q_func(struct list_head *q, struct list_head *qe);
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/cs/bfa_sm.h patch/drivers/scsi/bfa/include/cs/bfa_sm.h
--- orig/drivers/scsi/bfa/include/cs/bfa_sm.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cs/bfa_sm.h	2009-03-23 15:33:13.757156000 -0700
@@ -0,0 +1,69 @@
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
+ *  bfasm.h State machine defines
+ */
+
+#ifndef __BFA_SM_H__
+#define __BFA_SM_H__
+
+typedef void (*bfa_sm_t)(void *sm, int event);
+
+#define bfa_sm_set_state(_sm, _state)	(_sm)->sm = (bfa_sm_t)(_state)
+#define bfa_sm_send_event(_sm, _event)	(_sm)->sm((_sm), (_event))
+#define bfa_sm_get_state(_sm)		((_sm)->sm)
+#define bfa_sm_cmp_state(_sm, _state)	((_sm)->sm == (bfa_sm_t)(_state))
+
+/**
+ * For converting from state machine function to state encoding.
+ */
+struct bfa_sm_table_s {
+	bfa_sm_t	sm;	/*  state machine function	*/
+	int		state;	/*  state machine encoding	*/
+	char		*name;	/*  state name for display	*/
+};
+#define BFA_SM(_sm)	((bfa_sm_t)(_sm))
+
+int bfa_sm_to_state(struct bfa_sm_table_s *smt, bfa_sm_t sm);
+
+/**
+ * State machine with entry actions.
+ */
+typedef void (*bfa_fsm_t)(void *fsm, int event);
+
+/**
+ * oc - object class eg. bfa_ioc
+ * st - state, eg. reset
+ * otype - object type, eg. struct bfa_ioc_s
+ * etype - object type, eg. enum ioc_event
+ */
+#define bfa_fsm_state_decl(oc, st, otype, etype)		\
+	static void oc ## _sm_ ## st(otype * fsm, etype event);      \
+	static void oc ## _sm_ ## st ## _entry(otype * fsm);
+
+#define bfa_fsm_set_state(_fsm, _state) do {	\
+	(_fsm)->fsm = (bfa_fsm_t)(_state);      \
+	_state ## _entry(_fsm);      \
+} while (0)
+
+#define bfa_fsm_send_event(_fsm, _event)	\
+	(_fsm)->fsm((_fsm), (_event))
+#define bfa_fsm_cmp_state(_fsm, _state)		\
+	((_fsm)->fsm == (bfa_fsm_t)(_state))
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/cs/bfa_trc.h patch/drivers/scsi/bfa/include/cs/bfa_trc.h
--- orig/drivers/scsi/bfa/include/cs/bfa_trc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cs/bfa_trc.h	2009-03-23 15:33:13.764956000 -0700
@@ -0,0 +1,174 @@
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
+#ifndef __BFA_TRC_H__
+#define __BFA_TRC_H__
+
+#include <bfa_os_inc.h>
+
+#ifndef BFA_TRC_MAX
+#define BFA_TRC_MAX	(4 * 1024)
+#endif
+
+#ifndef BFA_TRC_TS
+#define BFA_TRC_TS(_trcm)	((_trcm)->ticks ++)
+#endif
+
+struct bfa_trc_s {
+#ifdef __BIGENDIAN
+	u16	fileno;
+	u16	line;
+#else
+	u16	line;
+	u16	fileno;
+#endif
+	u32	timestamp;
+	union {
+		struct {
+			u32	rsvd;
+			u32	u32;
+		} u32;
+		u64	u64;
+	} data;
+};
+
+
+struct bfa_trc_mod_s {
+	u32	head;
+	u32	tail;
+	u32	ntrc;
+	u32	stopped;
+	u32	ticks;
+	u32	rsvd[3];
+	struct bfa_trc_s trc[BFA_TRC_MAX];
+};
+
+
+enum {
+	BFA_TRC_FW   = 1,	/*  firmware modules */
+	BFA_TRC_HAL  = 2,	/*  BFA modules */
+	BFA_TRC_FCS  = 3,	/*  BFA FCS modules */
+	BFA_TRC_LDRV = 4,	/*  Linux driver modules */
+	BFA_TRC_SDRV = 5,	/*  Solaris driver modules */
+	BFA_TRC_VDRV = 6,	/*  vmware driver modules */
+	BFA_TRC_WDRV = 7,	/*  windows driver modules */
+	BFA_TRC_AEN  = 8,	/*  AEN module */
+	BFA_TRC_BIOS = 9,	/*  bios driver modules */
+	BFA_TRC_EFI  = 10,	/*  EFI driver modules */
+	BNA_TRC_WDRV = 11,	/*  BNA windows driver modules */
+	BNA_TRC_VDRV = 12,	/*  BNA vmware driver modules */
+	BNA_TRC_SDRV = 13,	/*  BNA Solaris driver modules */
+	BNA_TRC_LDRV = 14,	/*  BNA Linux driver modules */
+	BNA_TRC_HAL  = 15,	/*  BNA modules */
+};
+#define BFA_TRC_MOD_SH	12
+#define BFA_TRC_MOD(__mod)	((BFA_TRC_ ## __mod) << BFA_TRC_MOD_SH)
+
+/**
+ * Define a new tracing file (module). Module should match one defined above.
+ */
+#define BFA_TRC_FILE(__mod, __submod)					\
+	static int __trc_fileno = ((BFA_TRC_ ## __mod ## _ ## __submod) | \
+						 BFA_TRC_MOD(__mod))
+
+
+#define bfa_trc32(_trcp, _data)	\
+	__bfa_trc((_trcp)->trcmod, __trc_fileno, __LINE__, (u32)_data)
+
+
+#ifndef BFA_BOOT_BUILD
+#define bfa_trc(_trcp, _data)	\
+	__bfa_trc((_trcp)->trcmod, __trc_fileno, __LINE__, (u64)_data)
+#else
+void bfa_boot_trc(struct bfa_trc_mod_s *trcmod, u16 fileno,
+			u16 line, u32 data);
+#define bfa_trc(_trcp, _data)	\
+	bfa_boot_trc((_trcp)->trcmod, __trc_fileno, __LINE__, (u32)_data)
+#endif
+
+
+static inline void
+bfa_trc_init(struct bfa_trc_mod_s *trcm)
+{
+	trcm->head = trcm->tail = trcm->stopped = 0;
+	trcm->ntrc = BFA_TRC_MAX;
+}
+
+
+static inline void
+bfa_trc_stop(struct bfa_trc_mod_s *trcm)
+{
+	trcm->stopped = 1;
+}
+
+#ifdef CBFW
+extern void dc_flush(void *data);
+#else
+#define dc_flush(data)
+#endif
+
+
+static inline void
+__bfa_trc(struct bfa_trc_mod_s *trcm, int fileno, int line, u64 data)
+{
+	int		tail = trcm->tail;
+	struct bfa_trc_s 	*trc = &trcm->trc[tail];
+
+	if (trcm->stopped)
+		return;
+
+	trc->fileno = (u16) fileno;
+	trc->line = (u16) line;
+	trc->data.u64 = data;
+	trc->timestamp = BFA_TRC_TS(trcm);
+	dc_flush(trc);
+
+	trcm->tail = (trcm->tail + 1) & (BFA_TRC_MAX - 1);
+	if (trcm->tail == trcm->head)
+		trcm->head = (trcm->head + 1) & (BFA_TRC_MAX - 1);
+	dc_flush(trcm);
+}
+
+
+static inline void
+__bfa_trc32(struct bfa_trc_mod_s *trcm, int fileno, int line, u32 data)
+{
+	int		tail = trcm->tail;
+	struct bfa_trc_s *trc = &trcm->trc[tail];
+
+	if (trcm->stopped)
+		return;
+
+	trc->fileno = (u16) fileno;
+	trc->line = (u16) line;
+	trc->data.u32.u32 = data;
+	trc->timestamp = BFA_TRC_TS(trcm);
+	dc_flush(trc);
+
+	trcm->tail = (trcm->tail + 1) & (BFA_TRC_MAX - 1);
+	if (trcm->tail == trcm->head)
+		trcm->head = (trcm->head + 1) & (BFA_TRC_MAX - 1);
+	dc_flush(trcm);
+}
+
+#ifndef BFA_PERF_BUILD
+#define bfa_trc_fp(_trcp, _data)	bfa_trc(_trcp, _data)
+#else
+#define bfa_trc_fp(_trcp, _data)
+#endif
+
+#endif /* __BFA_TRC_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/cs/bfa_wc.h patch/drivers/scsi/bfa/include/cs/bfa_wc.h
--- orig/drivers/scsi/bfa/include/cs/bfa_wc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cs/bfa_wc.h	2009-03-23 15:33:13.789182000 -0700
@@ -0,0 +1,68 @@
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
+ *  bfa_wc.h Generic wait counter.
+ */
+
+#ifndef __BFA_WC_H__
+#define __BFA_WC_H__
+
+typedef void (*bfa_wc_resume_t) (void *cbarg);
+
+struct bfa_wc_s {
+	bfa_wc_resume_t wc_resume;
+	void		*wc_cbarg;
+	int		wc_count;
+};
+
+static inline void
+bfa_wc_up(struct bfa_wc_s *wc)
+{
+	wc->wc_count++;
+}
+
+static inline void
+bfa_wc_down(struct bfa_wc_s *wc)
+{
+	wc->wc_count--;
+	if (wc->wc_count == 0)
+		wc->wc_resume(wc->wc_cbarg);
+}
+
+/**
+ * Initialize a waiting counter.
+ */
+static inline void
+bfa_wc_init(struct bfa_wc_s *wc, bfa_wc_resume_t wc_resume, void *wc_cbarg)
+{
+	wc->wc_resume = wc_resume;
+	wc->wc_cbarg = wc_cbarg;
+	wc->wc_count = 0;
+	bfa_wc_up(wc);
+}
+
+/**
+ * Wait for counter to reach zero
+ */
+static inline void
+bfa_wc_wait(struct bfa_wc_s *wc)
+{
+	bfa_wc_down(wc);
+}
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_adapter.h patch/drivers/scsi/bfa/include/defs/bfa_defs_adapter.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_adapter.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_adapter.h	2009-03-23 15:33:13.919364000 -0700
@@ -0,0 +1,82 @@
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
+#ifndef __BFA_DEFS_ADAPTER_H__
+#define __BFA_DEFS_ADAPTER_H__
+
+#include <protocol/types.h>
+#include <defs/bfa_defs_version.h>
+#include <defs/bfa_defs_mfg.h>
+
+/**
+ * BFA adapter level attributes.
+ */
+enum {
+	BFA_ADAPTER_SERIAL_NUM_LEN = STRSZ(BFA_MFG_SERIALNUM_SIZE),
+					/*
+					 *!< adapter serial num length
+					 */
+	BFA_ADAPTER_MODEL_NAME_LEN  = 16,  /*  model name length */
+	BFA_ADAPTER_MODEL_DESCR_LEN = 128, /*  model description length */
+	BFA_ADAPTER_MFG_NAME_LEN    = 8,   /*  manufacturer name length */
+	BFA_ADAPTER_SYM_NAME_LEN    = 64,  /*  adapter symbolic name length */
+	BFA_ADAPTER_OS_TYPE_LEN	    = 64,  /*  adapter os type length */
+};
+
+struct bfa_adapter_attr_s {
+	char            manufacturer[BFA_ADAPTER_MFG_NAME_LEN];
+	char            serial_num[BFA_ADAPTER_SERIAL_NUM_LEN];
+	u32	rsvd1;
+	char            model[BFA_ADAPTER_MODEL_NAME_LEN];
+	char            model_descr[BFA_ADAPTER_MODEL_DESCR_LEN];
+	wwn_t           pwwn;
+	char            node_symname[FC_SYMNAME_MAX];
+	char            hw_ver[BFA_VERSION_LEN];
+	char            fw_ver[BFA_VERSION_LEN];
+	char            optrom_ver[BFA_VERSION_LEN];
+	char            os_type[BFA_ADAPTER_OS_TYPE_LEN];
+	struct bfa_mfg_vpd_s	vpd;
+	struct mac_s	mac;
+
+	u8		nports;
+	u8		max_speed;
+	u8		prototype;
+	char	        asic_rev;
+
+	u8         pcie_gen;
+	u8         pcie_lanes_orig;
+	u8         pcie_lanes;
+	u8	        cna_capable;
+};
+
+/**
+ * BFA adapter level events
+ * Arguments below are in BFAL context from Mgmt
+ * BFA_PORT_AEN_ADD:        [in]: None     [out]: serial_num, pwwn, nports
+ * BFA_PORT_AEN_REMOVE:     [in]: pwwn     [out]: serial_num, pwwn, nports
+ */
+enum bfa_adapter_aen_event {
+	BFA_ADAPTER_AEN_ADD 	= 1,	/*  New Adapter found event */
+	BFA_ADAPTER_AEN_REMOVE 	= 2,	/*  Adapter removed event */
+};
+
+struct bfa_adapter_aen_data_s {
+	char            serial_num[BFA_ADAPTER_SERIAL_NUM_LEN];
+	u32        nports;	/*  Number of NPorts */
+	wwn_t           pwwn;	/*  WWN of one of its physical port */
+};
+
+#endif /* __BFA_DEFS_ADAPTER_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_aen.h patch/drivers/scsi/bfa/include/defs/bfa_defs_aen.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_aen.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_aen.h	2009-03-23 15:33:14.023433000 -0700
@@ -0,0 +1,72 @@
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
+#ifndef __BFA_DEFS_AEN_H__
+#define __BFA_DEFS_AEN_H__
+
+#include <defs/bfa_defs_types.h>
+#include <defs/bfa_defs_ioc.h>
+#include <defs/bfa_defs_adapter.h>
+#include <defs/bfa_defs_port.h>
+#include <defs/bfa_defs_lport.h>
+#include <defs/bfa_defs_rport.h>
+#include <defs/bfa_defs_itnim.h>
+/* #include <defs/bfa_defs_itntm.h> */
+#include <defs/bfa_defs_ipfc.h>
+#include <defs/bfa_defs_audit.h>
+#include <defs/bfa_defs_ethport.h>
+
+enum bfa_aen_category {
+	BFA_AEN_CAT_ADAPTER	= 1,
+	BFA_AEN_CAT_PORT 	= 2,
+	BFA_AEN_CAT_LPORT 	= 3,
+	BFA_AEN_CAT_RPORT 	= 4,
+	BFA_AEN_CAT_ITNIM 	= 5,
+	BFA_AEN_CAT_ITNTM 	= 6,
+	BFA_AEN_CAT_IPFC 	= 7,
+	BFA_AEN_CAT_AUDIT 	= 8,
+	BFA_AEN_CAT_IOC 	= 9,
+	BFA_AEN_CAT_ETHPORT = 10,
+	BFA_AEN_MAX_CAT 	= 10
+};
+
+#pragma pack(1)
+union bfa_aen_data_u {
+	struct bfa_adapter_aen_data_s 	adapter;
+	struct bfa_port_aen_data_s 	port;
+	struct bfa_lport_aen_data_s 	lport;
+	struct bfa_rport_aen_data_s 	rport;
+	struct bfa_itnim_aen_data_s 	itnim;
+	struct bfa_audit_aen_data_s 	audit;
+	struct bfa_ioc_aen_data_s 	ioc;
+	struct bfa_ethport_aen_data_s   ethport;
+};
+
+struct bfa_aen_entry_s {
+	enum bfa_aen_category 	aen_category;
+	int			aen_type;
+	union bfa_aen_data_u  	aen_data;
+	struct bfa_timeval_s   	aen_tv;
+	s32         	bfad_num;
+	s32         	rsvd[1];
+};
+
+#pragma pack()
+
+#define bfa_aen_event_t int
+
+#endif /* __BFA_DEFS_AEN_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_audit.h patch/drivers/scsi/bfa/include/defs/bfa_defs_audit.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_audit.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_audit.h	2009-03-23 15:33:13.927021000 -0700
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
+#ifndef __BFA_DEFS_AUDIT_H__
+#define __BFA_DEFS_AUDIT_H__
+
+#include <bfa_os_inc.h>
+
+/**
+ * BFA audit events
+ */
+enum bfa_audit_aen_event {
+	BFA_AUDIT_AEN_AUTH_ENABLE 	= 1,
+	BFA_AUDIT_AEN_AUTH_DISABLE 	= 2,
+};
+
+/**
+ * audit event data
+ */
+struct bfa_audit_aen_data_s {
+	wwn_t           pwwn;
+};
+
+#endif /* __BFA_DEFS_AUDIT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_auth.h patch/drivers/scsi/bfa/include/defs/bfa_defs_auth.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_auth.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_auth.h	2009-03-23 15:33:13.934907000 -0700
@@ -0,0 +1,112 @@
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
+#ifndef __BFA_DEFS_AUTH_H__
+#define __BFA_DEFS_AUTH_H__
+
+#include <defs/bfa_defs_types.h>
+
+#define PUBLIC_KEY			15409
+#define PRIVATE_KEY			19009
+#define KEY_LEN				32399
+#define BFA_AUTH_SECRET_STRING_LEN	256
+#define BFA_AUTH_FAIL_TIMEOUT		0xFF
+
+/**
+ * Authentication status
+ */
+enum bfa_auth_status {
+	BFA_AUTH_STATUS_NONE 	= 0,	/*  no authentication */
+	BFA_AUTH_UNINIT 	= 1,	/*  state - uninit */
+	BFA_AUTH_NEG_SEND 	= 2,	/*  state - negotiate send */
+	BFA_AUTH_CHAL_WAIT 	= 3,	/*  state - challenge wait */
+	BFA_AUTH_NEG_RETRY 	= 4,	/*  state - negotiate retry */
+	BFA_AUTH_REPLY_SEND 	= 5,	/*  state - reply send */
+	BFA_AUTH_STATUS_WAIT 	= 6,	/*  state - status wait */
+	BFA_AUTH_SUCCESS 	= 7,	/*  state - success */
+	BFA_AUTH_FAILED 	= 8,	/*  state - failed */
+	BFA_AUTH_STATUS_UNKNOWN = 9,	/*  authentication status unknown */
+};
+
+struct auth_proto_stats_s {
+	u32        auth_rjts;
+	u32        auth_negs;
+	u32        auth_dones;
+
+	u32        dhchap_challenges;
+	u32        dhchap_replies;
+	u32        dhchap_successes;
+};
+
+/**
+ * Authentication related statistics
+ */
+struct bfa_auth_stats_s {
+	u32           auth_failures;	/*  authentication failures */
+	u32           auth_successes;	/*  authentication successes*/
+	struct auth_proto_stats_s auth_rx_stats; /*  Rx protocol stats */
+	struct auth_proto_stats_s auth_tx_stats; /*  Tx protocol stats */
+};
+
+/**
+ * Authentication hash function algorithms
+ */
+enum bfa_auth_algo {
+	BFA_AUTH_ALGO_MD5 	= 1,	/*  Message-Digest algorithm 5 */
+	BFA_AUTH_ALGO_SHA1 	= 2,	/*  Secure Hash Algorithm 1 */
+	BFA_AUTH_ALGO_MS 	= 3,	/*  MD5, then SHA-1 */
+	BFA_AUTH_ALGO_SM 	= 4,	/*  SHA-1, then MD5 */
+};
+
+/**
+ * DH Groups
+ *
+ * Current value could be combination of one or more of the following values
+ */
+enum bfa_auth_group {
+	BFA_AUTH_GROUP_DHNULL 	= 0,	/*  DH NULL (value == 0) */
+	BFA_AUTH_GROUP_DH768 	= 1,	/*  DH group 768 (value == 1) */
+	BFA_AUTH_GROUP_DH1024 	= 2,	/*  DH group 1024 (value == 2) */
+	BFA_AUTH_GROUP_DH1280 	= 4,	/*  DH group 1280 (value == 3) */
+	BFA_AUTH_GROUP_DH1536 	= 8,	/*  DH group 1536 (value == 4) */
+
+	BFA_AUTH_GROUP_ALL 	= 256	/*  Use default DH group order
+					 *    0, 1, 2, 3, 4 */
+};
+
+/**
+ * Authentication secret sources
+ */
+enum bfa_auth_secretsource {
+	BFA_AUTH_SECSRC_LOCAL 	= 1,	/*  locally configured */
+	BFA_AUTH_SECSRC_RADIUS 	= 2,	/*  use radius server */
+	BFA_AUTH_SECSRC_TACACS 	= 3,	/*  TACACS server */
+};
+
+/**
+ * Authentication attributes
+ */
+struct bfa_auth_attr_s {
+	enum bfa_auth_status 	status;
+	enum bfa_auth_algo 	algo;
+	enum bfa_auth_group 	dh_grp;
+	u16		rjt_code;
+	u16		rjt_code_exp;
+	u8			secret_set;
+	u8			resv[7];
+};
+
+#endif /* __BFA_DEFS_AUTH_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_ethport.h patch/drivers/scsi/bfa/include/defs/bfa_defs_ethport.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_ethport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_ethport.h	2009-03-23 15:33:13.981175000 -0700
@@ -0,0 +1,102 @@
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
+#ifndef __BFA_DEFS_ETHPORT_H__
+#define __BFA_DEFS_ETHPORT_H__
+
+#include <defs/bfa_defs_status.h>
+#include <protocol/types.h>
+#include <cna/pstats/phyport_defs.h>
+#include <cna/pstats/ethport_defs.h>
+
+struct bna_tx_info_s {
+	u32    miniport_state;
+	u32    adapter_state;
+	u64    tx_count;
+	u64    tx_wi;
+	u64    tx_sg;
+	u64    tx_tcp_chksum;
+	u64    tx_udp_chksum;
+	u64    tx_ip_chksum;
+	u64    tx_lsov1;
+	u64    tx_lsov2;
+	u64    tx_max_sg_len ;
+};
+
+
+struct bna_rx_queue_info_s {
+	u16    q_id ;
+	u16    buf_size ;
+	u16    buf_count ;
+	u16    rsvd ;
+	u64    rx_count ;
+	u64    rx_dropped ;
+	u64    rx_unsupported ;
+	u64    rx_internal_err ;
+	u64    rss_count ;
+	u64    vlan_count ;
+	u64    rx_tcp_chksum ;
+	u64    rx_udp_chksum ;
+	u64    rx_ip_chksum ;
+	u64    rx_hds ;
+};
+
+
+struct bna_rx_q_set_s {
+	u16    q_set_type;
+	u32    miniport_state;
+	u32    adapter_state;
+	struct bna_rx_queue_info_s    rx_queue[2];
+};
+
+
+struct bna_port_stats_s {
+	struct bna_tx_info_s   tx_stats;
+	u16        qset_count ;
+	struct bna_rx_q_set_s  rx_qset[8];
+};
+
+
+struct bfa_ethport_stats_s {
+	struct bna_stats_txf	txf_stats[1];
+	struct bna_stats_rxf	rxf_stats[1];
+	struct bnad_drv_stats drv_stats;
+};
+
+/**
+ * Ethernet port events
+ * Arguments below are in BFAL context from Mgmt
+ * BFA_PORT_AEN_ETH_LINKUP:    [in]: mac [out]: mac
+ * BFA_PORT_AEN_ETH_LINKDOWN:  [in]: mac [out]: mac
+ * BFA_PORT_AEN_ETH_ENABLE:  [in]: mac [out]: mac
+ * BFA_PORT_AEN_ETH_DISABLE:  [in]: mac [out]: mac
+ *
+ */
+enum bfa_ethport_aen_event {
+	BFA_ETHPORT_AEN_LINKUP = 1, /*  Base Port Ethernet link up event */
+	BFA_ETHPORT_AEN_LINKDOWN = 2, /*  Base Port Ethernet link down event */
+	BFA_ETHPORT_AEN_ENABLE = 3, /*  Base Port Ethernet link enable event */
+	BFA_ETHPORT_AEN_DISABLE = 4, /*  Base Port Ethernet link disable
+					 event */
+};
+
+struct bfa_ethport_aen_data_s {
+	struct mac_s mac;	/*  MAC address of the physical port */
+};
+
+
+#endif /* __BFA_DEFS_ETHPORT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h patch/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h	2009-03-23 15:33:13.847017000 -0700
@@ -0,0 +1,149 @@
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
+#ifndef __BFA_DEFS_IOC_H__
+#define __BFA_DEFS_IOC_H__
+
+#include <protocol/types.h>
+#include <defs/bfa_defs_types.h>
+#include <defs/bfa_defs_version.h>
+#include <defs/bfa_defs_adapter.h>
+#include <defs/bfa_defs_pm.h>
+
+enum {
+	BFA_IOC_DRIVER_LEN	= 16,
+	BFA_IOC_CHIP_REV_LEN 	= 8,
+};
+
+/**
+ * Driver and firmware versions.
+ */
+struct bfa_ioc_driver_attr_s {
+	char            driver[BFA_IOC_DRIVER_LEN];	/*  driver name */
+	char            driver_ver[BFA_VERSION_LEN];	/*  driver version */
+	char            fw_ver[BFA_VERSION_LEN];	/*  firmware version*/
+	char            bios_ver[BFA_VERSION_LEN];	/*  bios version */
+	char            efi_ver[BFA_VERSION_LEN];	/*  EFI version */
+	char            ob_ver[BFA_VERSION_LEN];	/*  openboot version*/
+};
+
+/**
+ * IOC PCI device attributes
+ */
+struct bfa_ioc_pci_attr_s {
+	u16        vendor_id;	/*  PCI vendor ID */
+	u16        device_id;	/*  PCI device ID */
+	u16        ssid;		/*  subsystem ID */
+	u16        ssvid;		/*  subsystem vendor ID */
+	u32        pcifn;		/*  PCI device function */
+	u32        rsvd;		/* padding */
+	u8         chip_rev[BFA_IOC_CHIP_REV_LEN];	 /*  chip revision */
+};
+
+/**
+ * IOC states
+ */
+enum bfa_ioc_state {
+	BFA_IOC_RESET       = 1,  /*  IOC is in reset state */
+	BFA_IOC_SEMWAIT     = 2,  /*  Waiting for IOC hardware semaphore */
+	BFA_IOC_HWINIT 	    = 3,  /*  IOC hardware is being initialized */
+	BFA_IOC_GETATTR     = 4,  /*  IOC is being configured */
+	BFA_IOC_OPERATIONAL = 5,  /*  IOC is operational */
+	BFA_IOC_INITFAIL    = 6,  /*  IOC hardware failure */
+	BFA_IOC_HBFAIL      = 7,  /*  IOC heart-beat failure */
+	BFA_IOC_DISABLING   = 8,  /*  IOC is being disabled */
+	BFA_IOC_DISABLED    = 9,  /*  IOC is disabled */
+};
+
+/**
+ * IOC firmware stats
+ */
+struct bfa_fw_ioc_stats_s {
+	u32        hb_count;
+	u32        cfg_reqs;
+	u32        enable_reqs;
+	u32        disable_reqs;
+	u32        stats_reqs;
+	u32        clrstats_reqs;
+	u32        unknown_reqs;
+	u32        ic_reqs;		/*  interrupt coalesce reqs */
+};
+
+/**
+ * IOC driver stats
+ */
+struct bfa_ioc_drv_stats_s {
+	u32	ioc_isrs;
+	u32	ioc_enables;
+	u32	ioc_disables;
+	u32	ioc_hbfails;
+	u32	ioc_boots;
+	u32	stats_tmos;
+	u32        hb_count;
+	u32        disable_reqs;
+	u32        enable_reqs;
+	u32        disable_replies;
+	u32        enable_replies;
+};
+
+/**
+ * IOC statistics
+ */
+struct bfa_ioc_stats_s {
+	struct bfa_ioc_drv_stats_s	drv_stats; /*  driver IOC stats */
+	struct bfa_fw_ioc_stats_s 	fw_stats;  /*  firmware IOC stats */
+};
+
+
+enum bfa_ioc_type_e {
+	BFA_IOC_TYPE_FC	  = 1,
+	BFA_IOC_TYPE_FCoE = 2,
+	BFA_IOC_TYPE_LL	  = 3,
+};
+
+/**
+ * IOC attributes returned in queries
+ */
+struct bfa_ioc_attr_s {
+	enum bfa_ioc_type_e		ioc_type;
+	enum bfa_ioc_state 		state;		/*  IOC state      */
+	struct bfa_adapter_attr_s	adapter_attr;	/*  HBA attributes */
+	struct bfa_ioc_driver_attr_s 	driver_attr;	/*  driver attr    */
+	struct bfa_ioc_pci_attr_s	pci_attr;
+	u8				port_id;	/*  port number    */
+};
+
+/**
+ * BFA IOC level events
+ */
+enum bfa_ioc_aen_event {
+	BFA_IOC_AEN_HBGOOD  = 1,	/*  Heart Beat restore event */
+	BFA_IOC_AEN_HBFAIL  = 2,	/*  Heart Beat failure event */
+	BFA_IOC_AEN_ENABLE  = 3,	/*  IOC enabled event */
+	BFA_IOC_AEN_DISABLE = 4,	/*  IOC disabled event */
+};
+
+/**
+ * BFA IOC level event data, now just a place holder
+ */
+struct bfa_ioc_aen_data_s {
+	wwn_t	pwwn;
+	struct mac_s mac;
+};
+
+#endif /* __BFA_DEFS_IOC_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h patch/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h	2009-03-23 15:33:13.972825000 -0700
@@ -0,0 +1,312 @@
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
+#ifndef __BFA_DEFS_IOCFC_H__
+#define __BFA_DEFS_IOCFC_H__
+
+#include <protocol/types.h>
+#include <defs/bfa_defs_types.h>
+#include <defs/bfa_defs_version.h>
+#include <defs/bfa_defs_adapter.h>
+#include <defs/bfa_defs_pm.h>
+
+#define BFA_IOCFC_INTR_DELAY	1125
+#define BFA_IOCFC_INTR_LATENCY	225
+#define	BFA_BPORT_SYM_NAME	128
+
+/**
+ * Interrupt coalescing configuration.
+ */
+struct bfa_iocfc_intr_attr_s {
+	bfa_boolean_t	coalesce;	/*  enable/disable coalescing */
+	u16	latency;	/*  latency in microseconds   */
+	u16	delay;		/*  delay in microseconds     */
+};
+
+/**
+ * IOC firmware configuraton
+ */
+struct bfa_iocfc_fwcfg_s {
+	u16        num_fabrics;	/*  number of fabrics		*/
+	u16        num_lports;	/*  number of local lports	*/
+	u16        num_rports;	/*  number of remote ports	*/
+	u16        num_ioim_reqs;	/*  number of IO reqs		*/
+	u16        num_tskim_reqs;	/*  task management requests	*/
+	u16        num_iotm_reqs;	/*  number of TM IO reqs	*/
+	u16        num_tsktm_reqs;	/*  TM task management requests*/
+	u16        num_fcxp_reqs;	/*  unassisted FC exchanges	*/
+	u16        num_uf_bufs;	/*  unsolicited recv buffers	*/
+	u8		num_cqs;
+	u8		rsvd;
+};
+
+struct bfa_iocfc_drvcfg_s {
+	u16        num_reqq_elems;	/*  number of req queue elements */
+	u16        num_rspq_elems;	/*  number of rsp queue elements */
+	u16        num_sgpgs;	/*  number of total SG pages	  */
+	u16        num_sboot_tgts;	/*  number of SAN boot targets	  */
+	u16        num_sboot_luns;	/*  number of SAN boot luns	  */
+	u16	    ioc_recover;	/*  IOC recovery mode		  */
+	u16	    min_cfg;	/*  minimum configuration	  */
+	u16        path_tov;	/*  device path timeout	  */
+	bfa_boolean_t   delay_comp; /*  delay completion of
+							failed inflight IOs */
+	u8		fw_disc_enabled;/*  f/w device discovery mode
+					 * 1 - f/w disc enabled
+					 * 0 - f/w disc not enabled
+					 */
+	u8		rport_del_tov;	/* rport delete timeout in secs   */
+	u8		bport_role;	/*  Base port operating mode
+					 * 0 - Target mode
+					 * 1 - Initiator mode
+					 */
+	u16	rsvd;
+};
+/**
+ * IOC configuration
+ */
+struct bfa_iocfc_cfg_s {
+	struct bfa_iocfc_fwcfg_s	fwcfg;	/*  firmware side config */
+	struct bfa_iocfc_drvcfg_s	drvcfg;	/*  driver side config	  */
+};
+
+/**
+ * IOC firmware IO stats
+ */
+struct bfa_fw_io_stats_s {
+	u32	host_abort;		/*  IO aborted by host driver*/
+	u32	host_cleanup;		/*  IO clean up by host driver */
+
+	u32	fw_io_timeout;		/*  IOs timedout */
+	u32	fw_frm_parse;		/*  frame parsed by f/w */
+	u32	fw_frm_data;		/*  fcp_data frame parsed by f/w */
+	u32	fw_frm_rsp;		/*  fcp_rsp frame parsed by f/w */
+	u32	fw_frm_xfer_rdy;	/*  xfer_rdy frame parsed by f/w */
+	u32	fw_frm_bls_acc;		/*  BLS ACC  frame parsed by f/w */
+	u32	fw_frm_tgt_abort;	/*  target ABTS parsed by f/w */
+	u32	fw_frm_unknown;		/*  unknown parsed by f/w */
+	u32	fw_data_dma;		/*  f/w DMA'ed the data frame */
+	u32	fw_frm_drop;		/*  f/w drop the frame */
+
+	u32	rec_timeout;		/*  FW rec timed out */
+	u32	error_rec;			/*  FW sending rec on
+							* an error condition*/
+	u32	wait_for_si;		/*  FW wait for SI */
+	u32	rec_rsp_inval;		/*  REC rsp invalid */
+	u32	seqr_io_abort;		/*  target does not know cmd so abort */
+	u32	seqr_io_retry;		/*  SEQR failed so retry IO */
+
+	u32	itn_cisc_upd_rsp;	/*  ITN cisc updated on fcp_rsp */
+	u32	itn_cisc_upd_data;	/*  ITN cisc updated on fcp_data */
+	u32	itn_cisc_upd_xfer_rdy;	/*  ITN cisc updated on fcp_data */
+
+	u32	fcp_data_lost;		/*  fcp data lost */
+
+	u32	ro_set_in_xfer_rdy;	/*  Target set RO in Xfer_rdy frame */
+	u32	xfer_rdy_ooo_err;	/*  Out of order Xfer_rdy received */
+	u32	xfer_rdy_unknown_err;	/*  unknown error in xfer_rdy frame */
+
+	u32	io_abort_timeout;	/*  ABTS timedout  */
+	u32	sler_initiated;		/*  SLER initiated */
+
+	u32	unexp_fcp_rsp;		/*  fcp response in wrong state */
+
+	u32	fcp_rsp_under_run;	/*  fcp rsp IO underrun */
+	u32	fcp_rsp_under_run_err;	/*  fcp rsp IO underrun error */
+	u32	fcp_rsp_over_run;	/*  fcp rsp IO overrun */
+	u32	fcp_rsp_over_run_err;	/*  fcp rsp IO overrun error */
+	u32	fcp_rsp_proto_err;	/*  protocol error in fcp rsp */
+	u32	fcp_rsp_sense_err;	/*  error in sense info in fcp rsp */
+	u32	fcp_conf_req;		/*  FCP conf requested */
+
+	u32	tgt_aborted_io;		/*  target initiated abort */
+
+	u32	ioh_edtov_timeout_event;/*  IOH edtov timer popped */
+	u32	ioh_fcp_rsp_excp_event;	/*  IOH FCP_RSP exception */
+	u32	ioh_fcp_conf_event;	/*  IOH FCP_CONF */
+	u32	ioh_mult_frm_rsp_event;	/*  IOH multi_frame FCP_RSP */
+	u32	ioh_hit_class2_event;	/*  IOH hit class2 */
+	u32	ioh_miss_other_event;	/*  IOH miss other */
+	u32	ioh_seq_cnt_err_event;	/*  IOH seq cnt error */
+	u32	ioh_len_err_event;		/*  IOH len error - fcp_dl !=
+							* bytes xfered */
+	u32	ioh_seq_len_err_event;	/*  IOH seq len error */
+	u32	ioh_data_oor_event;	/*  Data out of range */
+	u32	ioh_ro_ooo_event;	/*  Relative offset out of range */
+	u32	ioh_cpu_owned_event;	/*  IOH hit -iost owned by f/w */
+	u32	ioh_unexp_frame_event;	/*  unexpected frame recieved
+						 *   count */
+	u32	ioh_err_int;		/*  IOH error int during data-phase
+						 *   for scsi write
+						 */
+};
+
+/**
+ * IOC port firmware stats
+ */
+
+struct bfa_fw_port_fpg_stats_s {
+    u32    intr_evt;
+    u32    intr;
+    u32    intr_excess;
+    u32    intr_cause0;
+    u32    intr_other;
+    u32    intr_other_ign;
+    u32    sig_lost;
+    u32    sig_regained;
+    u32    sync_lost;
+    u32    sync_to;
+    u32    sync_regained;
+    u32    div2_overflow;
+    u32    div2_underflow;
+    u32    efifo_overflow;
+    u32    efifo_underflow;
+    u32    idle_rx;
+    u32    lrr_rx;
+    u32    lr_rx;
+    u32    ols_rx;
+    u32    nos_rx;
+    u32    lip_rx;
+    u32    arbf0_rx;
+    u32    mrk_rx;
+    u32    const_mrk_rx;
+    u32    prim_unknown;
+    u32    rsvd;
+};
+
+
+struct bfa_fw_port_lksm_stats_s {
+    u32    hwsm_success;       /*  hwsm state machine success          */
+    u32    hwsm_fails;         /*  hwsm fails                          */
+    u32    hwsm_wdtov;         /*  hwsm timed out                      */
+    u32    swsm_success;       /*  swsm success                        */
+    u32    swsm_fails;         /*  swsm fails                          */
+    u32    swsm_wdtov;         /*  swsm timed out                      */
+    u32    busybufs;           /*  link init failed due to busybuf     */
+    u32    buf_waits;          /*  bufwait state entries               */
+    u32    link_fails;         /*  link failures                       */
+    u32    psp_errors;         /*  primitive sequence protocol errors  */
+    u32    lr_unexp;           /*  No. of times LR rx-ed unexpectedly  */
+    u32    lrr_unexp;          /*  No. of times LRR rx-ed unexpectedly */
+    u32    lr_tx;              /*  No. of times LR tx started          */
+    u32    lrr_tx;             /*  No. of times LRR tx started         */
+    u32    ols_tx;             /*  No. of times OLS tx started         */
+    u32    nos_tx;             /*  No. of times NOS tx started         */
+};
+
+
+struct bfa_fw_port_snsm_stats_s {
+    u32    hwsm_success;       /*  Successful hwsm terminations        */
+    u32    hwsm_fails;         /*  hwsm fail count                     */
+    u32    hwsm_wdtov;         /*  hwsm timed out                      */
+    u32    swsm_success;       /*  swsm success                        */
+    u32    swsm_wdtov;         /*  swsm timed out                      */
+    u32    error_resets;       /*  error resets initiated by upsm      */
+    u32    sync_lost;          /*  Sync loss count                     */
+    u32    sig_lost;           /*  Signal loss count                   */
+};
+
+
+struct bfa_fw_port_physm_stats_s {
+    u32    module_inserts;     /*  Module insert count                 */
+    u32    module_xtracts;     /*  Module extracts count               */
+    u32    module_invalids;    /*  Invalid module inserted count       */
+    u32    module_read_ign;    /*  Module validation status ignored    */
+    u32    laser_faults;       /*  Laser fault count                   */
+    u32    rsvd;
+};
+
+
+struct bfa_fw_fip_stats_s {
+    u32    disc_req;           /*  Discovery solicit requests          */
+    u32    disc_rsp;           /*  Discovery solicit response          */
+    u32    disc_err;           /*  Discovery advt. parse errors        */
+    u32    disc_unsol;         /*  Discovery unsolicited               */
+    u32    disc_timeouts;      /*  Discovery timeouts                  */
+    u32    linksvc_unsupp;     /*  Unsupported link service req        */
+    u32    linksvc_err;        /*  Parse error in link service req     */
+    u32    logo_req;           /*  Number of FIP logos received        */
+    u32    clrvlink_req;       /*  Clear virtual link req              */
+    u32    op_unsupp;          /*  Unsupported FIP operation           */
+    u32    untagged;           /*  Untagged frames (ignored)           */
+    u32    rsvd;
+};
+
+
+struct bfa_fw_fcoe_stats_s {
+    u32    cee_linkups;        /*  CEE link up count                   */
+    u32    cee_linkdns;        /*  CEE link down count                 */
+    u32    fip_linkups;        /*  FIP link up count                   */
+    u32    fip_linkdns;        /*  FIP link up count                   */
+    u32    fip_fails;          /*  FIP fail count                      */
+    u32    rsvd;
+};
+
+/**
+ * IOC firmware FCoE port stats
+ */
+struct bfa_fw_fcoe_port_stats_s {
+    struct bfa_fw_fcoe_stats_s  fcoe_stats;
+    struct bfa_fw_fip_stats_s   fip_stats;
+};
+
+/**
+ * IOC firmware FC port stats
+ */
+struct bfa_fw_fc_port_stats_s {
+	struct bfa_fw_port_fpg_stats_s		fpg_stats;
+	struct bfa_fw_port_physm_stats_s	physm_stats;
+	struct bfa_fw_port_snsm_stats_s		snsm_stats;
+	struct bfa_fw_port_lksm_stats_s		lksm_stats;
+};
+
+/**
+ * IOC firmware FC port stats
+ */
+union bfa_fw_port_stats_s {
+	struct bfa_fw_fc_port_stats_s	fc_stats;
+	struct bfa_fw_fcoe_port_stats_s	fcoe_stats;
+};
+
+/**
+ * IOC firmware stats
+ */
+struct bfa_fw_stats_s {
+	struct bfa_fw_ioc_stats_s	ioc_stats;
+	struct bfa_fw_io_stats_s	io_stats;
+	union  bfa_fw_port_stats_s	port_stats;
+};
+
+/**
+ * IOC statistics
+ */
+struct bfa_iocfc_stats_s {
+	struct bfa_fw_stats_s 	fw_stats;	/*  firmware IOC stats      */
+};
+
+/**
+ * IOC attributes returned in queries
+ */
+struct bfa_iocfc_attr_s {
+	struct bfa_iocfc_cfg_s		config;		/*  IOCFC config   */
+	struct bfa_iocfc_intr_attr_s	intr_attr;	/*  interrupt attr */
+};
+
+#define BFA_IOCFC_PATHTOV_MAX	60
+#define BFA_IOCFC_QDEPTH_MAX	2000
+
+#endif /* __BFA_DEFS_IOC_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_ipfc.h patch/drivers/scsi/bfa/include/defs/bfa_defs_ipfc.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_ipfc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_ipfc.h	2009-03-23 15:33:13.855097000 -0700
@@ -0,0 +1,70 @@
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
+#ifndef __BFA_DEFS_IPFC_H__
+#define __BFA_DEFS_IPFC_H__
+
+#include <bfa_os_inc.h>
+#include <protocol/types.h>
+#include <defs/bfa_defs_types.h>
+
+/**
+ * FCS ip remote port states
+ */
+enum bfa_iprp_state {
+	BFA_IPRP_UNINIT  = 0,	/*  PORT is not yet initialized */
+	BFA_IPRP_ONLINE  = 1,	/*  process login is complete */
+	BFA_IPRP_OFFLINE = 2,	/*  iprp is offline */
+};
+
+/**
+ * FCS remote port statistics
+ */
+struct bfa_iprp_stats_s {
+	u32        offlines;
+	u32        onlines;
+	u32        rscns;
+	u32        plogis;
+	u32        logos;
+	u32        plogi_timeouts;
+	u32        plogi_rejects;
+};
+
+/**
+ * FCS iprp attribute returned in queries
+ */
+struct bfa_iprp_attr_s {
+	enum bfa_iprp_state state;
+};
+
+struct bfa_ipfc_stats_s {
+	u32 arp_sent;
+	u32 arp_recv;
+	u32 arp_reply_sent;
+	u32 arp_reply_recv;
+	u32 farp_sent;
+	u32 farp_recv;
+	u32 farp_reply_sent;
+	u32 farp_reply_recv;
+	u32 farp_reject_sent;
+	u32 farp_reject_recv;
+};
+
+struct bfa_ipfc_attr_s {
+	bfa_boolean_t enabled;
+};
+
+#endif /* __BFA_DEFS_IPFC_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_itnim.h patch/drivers/scsi/bfa/include/defs/bfa_defs_itnim.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_itnim.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_itnim.h	2009-03-23 15:33:13.863589000 -0700
@@ -0,0 +1,124 @@
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
+#ifndef __BFA_DEFS_ITNIM_H__
+#define __BFA_DEFS_ITNIM_H__
+
+#include <bfa_os_inc.h>
+#include <protocol/types.h>
+
+/**
+ * FCS itnim states
+ */
+enum bfa_itnim_state {
+	BFA_ITNIM_OFFLINE 	= 0,	/*  offline */
+	BFA_ITNIM_PRLI_SEND 	= 1,	/*  prli send */
+	BFA_ITNIM_PRLI_SENT 	= 2,	/*  prli sent */
+	BFA_ITNIM_PRLI_RETRY 	= 3,	/*  prli retry */
+	BFA_ITNIM_HCB_ONLINE 	= 4,	/*  online callback */
+	BFA_ITNIM_ONLINE 	= 5,	/*  online */
+	BFA_ITNIM_HCB_OFFLINE 	= 6,	/*  offline callback */
+	BFA_ITNIM_INITIATIOR 	= 7,	/*  initiator */
+};
+
+struct bfa_itnim_hal_stats_s {
+	u32	onlines;	/*  ITN nexus onlines (PRLI done) */
+	u32	offlines;	/*  ITN Nexus offlines 	*/
+	u32	creates;	/*  ITN create requests 	*/
+	u32	deletes;	/*  ITN delete requests 	*/
+	u32	create_comps;	/*  ITN create completions 	*/
+	u32	delete_comps;	/*  ITN delete completions 	*/
+	u32	sler_events;	/*  SLER (sequence level error
+					 * recovery) events */
+	u32	ioc_disabled;	/*  Num IOC disables		*/
+	u32	cleanup_comps;	/*  ITN cleanup completions */
+	u32	tm_cmnds;	/*  task management(TM) cmnds sent */
+	u32	tm_fw_rsps;	/*  TM cmds firmware responses */
+	u32	tm_success;	/*  TM successes */
+	u32	tm_failures;	/*  TM failures */
+	u32	tm_io_comps;	/*  TM IO completions */
+	u32	tm_qresumes;	/*  TM queue resumes (after waiting
+					 * for resources)
+					 */
+	u32	tm_iocdowns;	/*  TM cmnds affected by IOC down */
+	u32	tm_cleanups;	/*  TM cleanups */
+	u32	tm_cleanup_comps;
+					/*  TM cleanup completions */
+	u32	ios;		/*  IO requests */
+	u32	io_comps;	/*  IO completions */
+};
+
+/**
+ * FCS remote port statistics
+ */
+struct bfa_itnim_stats_s {
+	u32        onlines;	/*  num rport online */
+	u32        offlines;	/*  num rport offline */
+	u32        prli_sent;	/*  num prli sent out */
+	u32        fcxp_alloc_wait;/*  num fcxp alloc waits */
+	u32        prli_rsp_err;	/*  num prli rsp errors */
+	u32        prli_rsp_acc;	/*  num prli rsp accepts */
+	u32        initiator;	/*  rport is an initiator */
+	u32        prli_rsp_parse_err;	/*  prli rsp parsing errors */
+	u32        prli_rsp_rjt;	/*  num prli rsp rejects */
+	u32        timeout;	/*  num timeouts detected */
+	u32        sler;		/*  num sler notification from BFA */
+	u32	rsvd;
+	struct bfa_itnim_hal_stats_s	hal_stats;
+};
+
+/**
+ * FCS itnim attributes returned in queries
+ */
+struct bfa_itnim_attr_s {
+	enum bfa_itnim_state state; /*  FCS itnim state        */
+	u8 retry;		/*  data retransmision support */
+	u8	task_retry_id;  /*  task retry ident support   */
+	u8 rec_support;    /*  REC supported              */
+	u8 conf_comp;      /*  confirmed completion supp  */
+};
+
+/**
+ * BFA ITNIM events.
+ * Arguments below are in BFAL context from Mgmt
+ * BFA_ITNIM_AEN_NEW:       [in]: None  [out]: vf_id, lpwwn
+ * BFA_ITNIM_AEN_DELETE:    [in]: vf_id, lpwwn, rpwwn (0 = all fcp4 targets),
+ *				  [out]: vf_id, ppwwn, lpwwn, rpwwn
+ * BFA_ITNIM_AEN_ONLINE:    [in]: vf_id, lpwwn, rpwwn (0 = all fcp4 targets),
+ *				  [out]: vf_id, ppwwn, lpwwn, rpwwn
+ * BFA_ITNIM_AEN_OFFLINE:   [in]: vf_id, lpwwn, rpwwn (0 = all fcp4 targets),
+ *				  [out]: vf_id, ppwwn, lpwwn, rpwwn
+ * BFA_ITNIM_AEN_DISCONNECT:[in]: vf_id, lpwwn, rpwwn (0 = all fcp4 targets),
+ *				  [out]: vf_id, ppwwn, lpwwn, rpwwn
+ */
+enum bfa_itnim_aen_event {
+	BFA_ITNIM_AEN_ONLINE 	= 1,	/*  Target online */
+	BFA_ITNIM_AEN_OFFLINE 	= 2,	/*  Target offline */
+	BFA_ITNIM_AEN_DISCONNECT = 3,	/*  Target disconnected */
+};
+
+/**
+ * BFA ITNIM event data structure.
+ */
+struct bfa_itnim_aen_data_s {
+	u16        vf_id;	/*  vf_id of the IT nexus */
+	u16        rsvd[3];
+	wwn_t           ppwwn;	/*  WWN of its physical port */
+	wwn_t           lpwwn;	/*  WWN of logical port */
+	wwn_t           rpwwn;	/*  WWN of remote(target) port */
+};
+
+#endif /* __BFA_DEFS_ITNIM_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_itntm.h patch/drivers/scsi/bfa/include/defs/bfa_defs_itntm.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_itntm.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_itntm.h	2009-03-23 15:33:13.989223000 -0700
@@ -0,0 +1,118 @@
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
+#ifndef __BFA_DEFS_ITNTM_H__
+#define __BFA_DEFS_ITNTM_H__
+
+#include <protocol/types.h>
+#include <protocol/bfa_protocol.h>
+
+/**
+ * FCS itntm states
+ */
+enum bfa_itntm_state_e {
+	BFA_ITNTM_SM_OFFLINE = 0,	/*  itntm is offline */
+	BFA_ITNTM_SM_WOS_LOGIN = 1,	/*  Waiting PRLI ACC/RJT from ULP */
+	BFA_ITNTM_SM_WFW_ONLINE = 2,	/*  Waiting ACK to PRLI ACC from FW */
+	BFA_ITNTM_SM_ONLINE = 3,	/*  itntm login is complete */
+	BFA_ITNTM_SM_WIO_RELOGIN = 4,	/*  itntm relogin is in progress */
+	BFA_ITNTM_SM_WIO_LOGOUT = 5,	/*  Processing of PRLO req from
+					 *   Initiator is in progress
+					 */
+	BFA_ITNTM_SM_WOS_LOGOUT = 6,	/*  Processing of PRLO req from
+					 *   Initiator is in progress
+					 */
+	BFA_ITNTM_SM_WIO_CLEAN = 7,	/*  Waiting for IO cleanup before itntm
+					 *   is offline. This can be triggered
+					 *   by RPORT LOGO (rcvd/sent) or by
+					 *   PRLO (rcvd/sent)
+					 */
+};
+
+struct bfa_prli_req_s {
+	struct fchs_s fchs;
+	void *prli_payload;
+};
+
+struct bfa_prlo_req_s {
+	struct fchs_s fchs;
+	void *prlo_payload;
+};
+
+void bfa_itntm_send_login_rsp(void *bfa_itntm, u32 login_rsp,
+				fc_ls_rjt_t rjt_payload);
+void bfa_itntm_send_logout_rsp(void *bfa_itntm, u32 logout_rsp,
+				fc_ls_rjt_t rjt_payload);
+/**
+ * FCS target port statistics
+ */
+struct bfa_itntm_stats_s {
+	u32 onlines;	/*  I-T Nexus onlines (PRLI done) */
+	u32 offlines;	/*  I-T Nexus offlines 	*/
+	u32 prli_req_parse_err;	/*  prli req parsing errors */
+	u32 prli_rsp_rjt;	/*  num prli rsp rejects sent */
+	u32 prli_rsp_acc;	/*  num prli rsp accepts sent */
+	u32 cleanup_comps;	/*  I-T Nexus cleanup completions */
+};
+
+/**
+ * FCS itntm attributes returned in queries
+ */
+struct bfa_itntm_attr_s {
+	enum bfa_itntm_state_e state;
+	u8	seq_retry;    /*  Sequence retry supported      */
+	u8	rsvd[3];
+};
+
+/**
+ * BFA ITNTM async event data structure for BFAL
+ */
+enum bfa_itntm_aen_event {
+	BFA_ITNTM_AEN_ONLINE 	= 1,	/*  Target online */
+	BFA_ITNTM_AEN_OFFLINE 	= 2,	/*  Target offline */
+	BFA_ITNTM_AEN_DISCONNECT	= 3,	/*  Target disconnected */
+};
+
+/**
+ * BFA ITNTM event data structure.
+ */
+struct bfa_itntm_aen_data_s {
+	u16 vf_id;	/*  vf_id of the IT nexus */
+	u16 rsvd[3];
+	wwn_t lpwwn;	/*  WWN of logical port */
+	wwn_t rpwwn;	/*  WWN of remote(target) port */
+};
+
+/**
+ * Below APIs are needed from BFA driver
+ * Move these to BFA driver public header file?
+ */
+/*  ITNTM rcvd new PRLI & gets bfad_itntm_t ptr from driver this callback */
+void *bfad_itntm_rcvd_login_req(void *bfad_tm_port, void *bfa_itntm,
+				wwn_t rp_wwn, u32 rp_fcid,
+				struct bfa_prli_req_s prli_req);
+/*  ITNTM rcvd new PRLO */
+void bfad_itntm_rcvd_logout_req(void *bfad_itntm, wwn_t rp_wwn,
+			 u32 rp_fcid, struct bfa_prlo_req_s prlo_req);
+/*  ITNTM is online and ready for IO */
+void bfad_itntm_online(void *bfad_itntm);
+/*  ITNTM is offline and BFA driver can shutdown its upper stack */
+void bfad_itntm_offline(void *bfad_itntm);
+/*  ITNTM does not need this BFA driver itntm tag anymore, so can be freed */
+void bfad_itntm_res_free(void *bfad_itntm);
+
+#endif /* __BFA_DEFS_ITNTM_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_lport.h patch/drivers/scsi/bfa/include/defs/bfa_defs_lport.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_lport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_lport.h	2009-03-23 15:33:13.942645000 -0700
@@ -0,0 +1,68 @@
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
+#ifndef __BFA_DEFS_LPORT_H__
+#define __BFA_DEFS_LPORT_H__
+
+#include <defs/bfa_defs_types.h>
+#include <defs/bfa_defs_port.h>
+
+/**
+ * BFA AEN logical port events.
+ * Arguments below are in BFAL context from Mgmt
+ * BFA_LPORT_AEN_NEW:       [in]: None         [out]: vf_id, ppwwn, lpwwn, roles
+ * BFA_LPORT_AEN_DELETE:    [in]: lpwwn        [out]: vf_id, ppwwn. lpwwn, roles
+ * BFA_LPORT_AEN_ONLINE:    [in]: lpwwn        [out]: vf_id, ppwwn. lpwwn, roles
+ * BFA_LPORT_AEN_OFFLINE:   [in]: lpwwn        [out]: vf_id, ppwwn. lpwwn, roles
+ * BFA_LPORT_AEN_DISCONNECT:[in]: lpwwn        [out]: vf_id, ppwwn. lpwwn, roles
+ * BFA_LPORT_AEN_NEW_PROP:  [in]: None         [out]: vf_id, ppwwn. lpwwn, roles
+ * BFA_LPORT_AEN_DELETE_PROP:     [in]: lpwwn  [out]: vf_id, ppwwn. lpwwn, roles
+ * BFA_LPORT_AEN_NEW_STANDARD:    [in]: None   [out]: vf_id, ppwwn. lpwwn, roles
+ * BFA_LPORT_AEN_DELETE_STANDARD: [in]: lpwwn  [out]: vf_id, ppwwn. lpwwn, roles
+ * BFA_LPORT_AEN_NPIV_DUP_WWN:    [in]: lpwwn  [out]: vf_id, ppwwn. lpwwn, roles
+ * BFA_LPORT_AEN_NPIV_FABRIC_MAX: [in]: lpwwn  [out]: vf_id, ppwwn. lpwwn, roles
+ * BFA_LPORT_AEN_NPIV_UNKNOWN:    [in]: lpwwn  [out]: vf_id, ppwwn. lpwwn, roles
+ */
+enum bfa_lport_aen_event {
+	BFA_LPORT_AEN_NEW	= 1,	/*  LPort created event */
+	BFA_LPORT_AEN_DELETE	= 2,	/*  LPort deleted event */
+	BFA_LPORT_AEN_ONLINE	= 3,	/*  LPort online event */
+	BFA_LPORT_AEN_OFFLINE	= 4,	/*  LPort offline event */
+	BFA_LPORT_AEN_DISCONNECT = 5,	/*  LPort disconnect event */
+	BFA_LPORT_AEN_NEW_PROP	= 6,	/*  VPort created event */
+	BFA_LPORT_AEN_DELETE_PROP = 7,	/*  VPort deleted event */
+	BFA_LPORT_AEN_NEW_STANDARD = 8,	/*  VPort created event */
+	BFA_LPORT_AEN_DELETE_STANDARD = 9,  /*  VPort deleted event */
+	BFA_LPORT_AEN_NPIV_DUP_WWN = 10,    /*  VPort configured with
+					     *   duplicate WWN event
+						 */
+	BFA_LPORT_AEN_NPIV_FABRIC_MAX = 11, /*  Max NPIV in fabric/fport */
+	BFA_LPORT_AEN_NPIV_UNKNOWN = 12, /*  Unknown NPIV Error code event */
+};
+
+/**
+ * BFA AEN event data structure
+ */
+struct bfa_lport_aen_data_s {
+	u16        vf_id;	/*  vf_id of this logical port */
+	u16        rsvd;
+	enum bfa_port_role roles;	/*  Logical port mode,IM/TM/IP etc */
+	wwn_t           ppwwn;	/*  WWN of its physical port */
+	wwn_t           lpwwn;	/*  WWN of this logical port */
+};
+
+#endif /* __BFA_DEFS_LPORT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h patch/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h	2009-03-23 15:33:13.996655000 -0700
@@ -0,0 +1,58 @@
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
+#ifndef __BFA_DEFS_MFG_H__
+#define __BFA_DEFS_MFG_H__
+
+#include <bfa_os_inc.h>
+
+/**
+ * Manufacturing block version
+ */
+#define BFA_MFG_VERSION				1
+
+/**
+ * Manufacturing block format
+ */
+#define BFA_MFG_SERIALNUM_SIZE			11
+#define BFA_MFG_PARTNUM_SIZE			14
+#define BFA_MFG_SUPPLIER_ID_SIZE		10
+#define BFA_MFG_SUPPLIER_PARTNUM_SIZE	20
+#define BFA_MFG_SUPPLIER_SERIALNUM_SIZE	20
+#define BFA_MFG_SUPPLIER_REVISION_SIZE	4
+#define STRSZ(_n)	(((_n) + 4) & ~3)
+
+/**
+ * VPD data length
+ */
+#define BFA_MFG_VPD_LEN     256
+
+/**
+ * All numerical fields are in big-endian format.
+ */
+struct bfa_mfg_vpd_s {
+    u8     version;    /*  vpd data version */
+    u8     vpd_sig[3]; /*  characters 'V', 'P', 'D' */
+    u8     chksum;     /*  u8 checksum */
+    u8     vendor;     /*  vendor */
+    u8     len;        /*  vpd data length excluding header */
+    u8     rsv;
+    u8     data[BFA_MFG_VPD_LEN];  /*  vpd data */
+};
+
+#pragma pack(1)
+
+#endif /* __BFA_DEFS_MFG_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_pci.h patch/drivers/scsi/bfa/include/defs/bfa_defs_pci.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_pci.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_pci.h	2009-03-23 15:33:13.950135000 -0700
@@ -0,0 +1,41 @@
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
+#ifndef __BFA_DEFS_PCI_H__
+#define __BFA_DEFS_PCI_H__
+
+/**
+ * PCI device and vendor ID information
+ */
+enum {
+	BFA_PCI_VENDOR_ID_BROCADE	= 0x1657,
+	BFA_PCI_DEVICE_ID_FC_8G2P	= 0x13,
+	BFA_PCI_DEVICE_ID_FC_8G1P	= 0x17,
+	BFA_PCI_DEVICE_ID_CT		= 0x14,
+};
+
+/**
+ * PCI sub-system device and vendor ID information
+ */
+enum {
+	BFA_PCI_FCOE_SSDEVICE_ID	= 0x14,
+};
+
+#define BFA_PCI_ACCESS_RANGES 1	/* Maximum number of device address ranges
+				 * mapped through different BAR(s). */
+
+#endif /* __BFA_DEFS_PCI_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_pm.h patch/drivers/scsi/bfa/include/defs/bfa_defs_pm.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_pm.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_pm.h	2009-03-23 15:33:13.871571000 -0700
@@ -0,0 +1,33 @@
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
+#ifndef __BFA_DEFS_PM_H__
+#define __BFA_DEFS_PM_H__
+
+#include <bfa_os_inc.h>
+
+/**
+ * BFA power management device states
+ */
+enum bfa_pm_ds {
+	BFA_PM_DS_D0 = 0,	/*  full power mode */
+	BFA_PM_DS_D1 = 1,	/*  power save state 1 */
+	BFA_PM_DS_D2 = 2,	/*  power save state 2 */
+	BFA_PM_DS_D3 = 3,	/*  power off state */
+};
+
+#endif /* __BFA_DEFS_PM_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_port.h patch/drivers/scsi/bfa/include/defs/bfa_defs_port.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_port.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_port.h	2009-03-23 15:33:13.879771000 -0700
@@ -0,0 +1,234 @@
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
+#ifndef __BFA_DEFS_PORT_H__
+#define __BFA_DEFS_PORT_H__
+
+#include <bfa_os_inc.h>
+#include <protocol/types.h>
+#include <defs/bfa_defs_pport.h>
+
+#define BFA_FCS_FABRIC_IPADDR_SZ  16
+
+/**
+ * symbolic names for base port/virtual port
+ */
+#define BFA_SYMNAME_MAXLEN	128	/* vmware/windows uses 128 bytes */
+struct bfa_port_symname_s {
+	char            symname[BFA_SYMNAME_MAXLEN];
+};
+
+/**
+* Roles of FCS port:
+ *     - FCP IM and FCP TM roles cannot be enabled together for a FCS port
+ *     - Create multiple ports if both IM and TM functions required.
+ *     - Atleast one role must be specified.
+ */
+enum bfa_port_role {
+	BFA_PORT_ROLE_FCP_IM 	= 0x01,	/*  FCP initiator role */
+	BFA_PORT_ROLE_FCP_TM 	= 0x02,	/*  FCP target role */
+	BFA_PORT_ROLE_FCP_IPFC 	= 0x04,	/*  IP over FC role */
+	BFA_PORT_ROLE_FCP_MAX 	= BFA_PORT_ROLE_FCP_IPFC | BFA_PORT_ROLE_FCP_IM
+};
+
+/**
+ * FCS port configuration.
+ */
+struct bfa_port_cfg_s {
+    wwn_t               pwwn;       /*  port wwn */
+    wwn_t               nwwn;       /*  node wwn */
+    enum bfa_port_role     roles;      /*  FCS port roles */
+    struct bfa_port_symname_s  sym_name;   /*  vm port symbolic name */
+    u8             tag[16];	/*  opaque tag from application */
+};
+
+/**
+ * FCS port states
+ */
+enum bfa_port_state {
+	BFA_PORT_UNINIT  = 0,	/*  PORT is not yet initialized */
+	BFA_PORT_FDISC   = 1,	/*  FDISC is in progress */
+	BFA_PORT_ONLINE  = 2,	/*  login to fabric is complete */
+	BFA_PORT_OFFLINE = 3,	/*  No login to fabric */
+};
+
+/**
+ * FCS port type. Required for VmWare.
+ */
+enum bfa_port_type {
+	BFA_PORT_TYPE_PHYSICAL = 0,
+	BFA_PORT_TYPE_VIRTUAL,
+};
+
+/**
+ * FCS port offline reason. Required for VmWare.
+ */
+enum bfa_port_offline_reason {
+	BFA_PORT_OFFLINE_UNKNOWN = 0,
+	BFA_PORT_OFFLINE_LINKDOWN,
+	BFA_PORT_OFFLINE_FAB_UNSUPPORTED,	/*  NPIV not supported by the
+						 *    fabric */
+	BFA_PORT_OFFLINE_FAB_NORESOURCES,
+	BFA_PORT_OFFLINE_FAB_LOGOUT,
+};
+
+/**
+ * FCS lport info. Required for VmWare.
+ */
+struct bfa_port_info_s {
+	u8         port_type;	/* bfa_port_type_t : physical or
+					 * virtual */
+	u8         port_state;	/* one of bfa_port_state values */
+	u8         offline_reason;	/* one of bfa_port_offline_reason_t
+					 * values */
+	wwn_t           port_wwn;
+	wwn_t           node_wwn;
+
+	/*
+	 * following 4 feilds are valid for Physical Ports only
+	 */
+	u32        max_vports_supp;	/* Max supported vports */
+	u32        num_vports_inuse;	/* Num of in use vports */
+	u32        max_rports_supp;	/* Max supported rports */
+	u32        num_rports_inuse;	/* Num of doscovered rports */
+
+};
+
+/**
+ * FCS port statistics
+ */
+struct bfa_port_stats_s {
+	u32        ns_plogi_sent;
+	u32        ns_plogi_rsp_err;
+	u32        ns_plogi_acc_err;
+	u32        ns_plogi_accepts;
+	u32        ns_rejects;	/* NS command rejects */
+	u32        ns_plogi_unknown_rsp;
+	u32        ns_plogi_alloc_wait;
+
+	u32        ns_retries;	/* NS command retries */
+	u32        ns_timeouts;	/* NS command timeouts */
+
+	u32        ns_rspnid_sent;
+	u32        ns_rspnid_accepts;
+	u32        ns_rspnid_rsp_err;
+	u32        ns_rspnid_rejects;
+	u32        ns_rspnid_alloc_wait;
+
+	u32        ns_rftid_sent;
+	u32        ns_rftid_accepts;
+	u32        ns_rftid_rsp_err;
+	u32        ns_rftid_rejects;
+	u32        ns_rftid_alloc_wait;
+
+	u32	ns_rffid_sent;
+	u32	ns_rffid_accepts;
+	u32	ns_rffid_rsp_err;
+	u32	ns_rffid_rejects;
+	u32	ns_rffid_alloc_wait;
+
+	u32        ns_gidft_sent;
+	u32        ns_gidft_accepts;
+	u32        ns_gidft_rsp_err;
+	u32        ns_gidft_rejects;
+	u32        ns_gidft_unknown_rsp;
+	u32        ns_gidft_alloc_wait;
+
+	/*
+	 * Mgmt Server stats
+	 */
+	u32        ms_retries;	/* MS command retries */
+	u32        ms_timeouts;	/* MS command timeouts */
+	u32        ms_plogi_sent;
+	u32        ms_plogi_rsp_err;
+	u32        ms_plogi_acc_err;
+	u32        ms_plogi_accepts;
+	u32        ms_rejects;	/* NS command rejects */
+	u32        ms_plogi_unknown_rsp;
+	u32        ms_plogi_alloc_wait;
+
+	u32        num_rscn;	/* Num of RSCN received */
+	u32        num_portid_rscn;/* Num portid format RSCN
+								* received */
+
+	u32	uf_recvs; 	/* unsolicited recv frames      */
+	u32	uf_recv_drops; 	/* dropped received frames	*/
+
+	u32	rsvd; 		/* padding for 64 bit alignment */
+};
+
+/**
+ * BFA port attribute returned in queries
+ */
+struct bfa_port_attr_s {
+	enum bfa_port_state state;		/*  port state */
+	u32         pid;		/*  port ID */
+	struct bfa_port_cfg_s   port_cfg;	/*  port configuration */
+	enum bfa_pport_type port_type;	/*  current topology */
+	u32         loopback;	/*  cable is externally looped back */
+	wwn_t		fabric_name; /*  attached switch's nwwn */
+	u8		fabric_ip_addr[BFA_FCS_FABRIC_IPADDR_SZ]; /*  attached
+							* fabric's ip addr */
+};
+
+/**
+ * BFA physical port Level events
+ * Arguments below are in BFAL context from Mgmt
+ * BFA_PORT_AEN_ONLINE:     [in]: pwwn	[out]: pwwn
+ * BFA_PORT_AEN_OFFLINE:    [in]: pwwn	[out]: pwwn
+ * BFA_PORT_AEN_RLIR:       [in]: None	[out]: pwwn, rlir_data, rlir_len
+ * BFA_PORT_AEN_SFP_INSERT: [in]: pwwn	[out]: port_id, pwwn
+ * BFA_PORT_AEN_SFP_REMOVE: [in]: pwwn	[out]: port_id, pwwn
+ * BFA_PORT_AEN_SFP_POM:    [in]: pwwn	[out]: level, port_id, pwwn
+ * BFA_PORT_AEN_ENABLE:     [in]: pwwn	[out]: pwwn
+ * BFA_PORT_AEN_DISABLE:    [in]: pwwn	[out]: pwwn
+ * BFA_PORT_AEN_AUTH_ON:    [in]: pwwn	[out]: pwwn
+ * BFA_PORT_AEN_AUTH_OFF:   [in]: pwwn	[out]: pwwn
+ * BFA_PORT_AEN_DISCONNECT: [in]: pwwn	[out]: pwwn
+ * BFA_PORT_AEN_QOS_NEG:    [in]: pwwn	[out]: pwwn
+ *
+ */
+enum bfa_port_aen_event {
+	BFA_PORT_AEN_ONLINE     = 1,	/*  Physical Port online event */
+	BFA_PORT_AEN_OFFLINE    = 2,	/*  Physical Port offline event */
+	BFA_PORT_AEN_RLIR       = 3,	/*  RLIR event, not supported */
+	BFA_PORT_AEN_SFP_INSERT = 4,	/*  SFP inserted event */
+	BFA_PORT_AEN_SFP_REMOVE = 5,	/*  SFP removed event */
+	BFA_PORT_AEN_SFP_POM    = 6,	/*  SFP POM event */
+	BFA_PORT_AEN_ENABLE     = 7,	/*  Physical Port enable event */
+	BFA_PORT_AEN_DISABLE    = 8,	/*  Physical Port disable event */
+	BFA_PORT_AEN_AUTH_ON    = 9,	/*  Physical Port auth success event */
+	BFA_PORT_AEN_AUTH_OFF   = 10,	/*  Physical Port auth fail event */
+	BFA_PORT_AEN_DISCONNECT = 11,	/*  Physical Port disconnect event */
+	BFA_PORT_AEN_QOS_NEG    = 12,  	/*  Base Port QOS negotiation event */
+};
+
+enum bfa_port_aen_sfp_pom {
+	BFA_PORT_AEN_SFP_POM_GREEN = 1,	/*  Normal */
+	BFA_PORT_AEN_SFP_POM_AMBER = 2,	/*  Warning */
+	BFA_PORT_AEN_SFP_POM_RED   = 3,	/*  Critical */
+	BFA_PORT_AEN_SFP_POM_MAX   = BFA_PORT_AEN_SFP_POM_RED
+};
+
+struct bfa_port_aen_data_s {
+	wwn_t           pwwn;	      /*  WWN of the physical port */
+	int             phy_port_num; /*! For SFP related events */
+	enum bfa_port_aen_sfp_pom level; /*  Only transitions will
+					  * be informed */
+};
+
+#endif /* __BFA_DEFS_PORT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_pport.h patch/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_pport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_pport.h	2009-03-23 15:33:13.887841000 -0700
@@ -0,0 +1,342 @@
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
+#ifndef __BFA_DEFS_PPORT_H__
+#define __BFA_DEFS_PPORT_H__
+
+#include <bfa_os_inc.h>
+#include <protocol/bfa_protocol.h>
+#include <defs/bfa_defs_types.h>
+#include <defs/bfa_defs_qos.h>
+#include <cna/pstats/phyport_defs.h>
+
+/* Modify char* port_stt[] in bfal_port.c if a new state was added */
+enum bfa_pport_states {
+	BFA_PPORT_ST_UNINIT 		= 1,
+	BFA_PPORT_ST_ENABLING_QWAIT 	= 2,
+	BFA_PPORT_ST_ENABLING 		= 3,
+	BFA_PPORT_ST_LINKDOWN 		= 4,
+	BFA_PPORT_ST_LINKUP 		= 5,
+	BFA_PPORT_ST_DISABLING_QWAIT 	= 6,
+	BFA_PPORT_ST_DISABLING		= 7,
+	BFA_PPORT_ST_DISABLED 		= 8,
+	BFA_PPORT_ST_STOPPED 		= 9,
+	BFA_PPORT_ST_IOCDOWN 		= 10,
+	BFA_PPORT_ST_IOCDIS 		= 11,
+	BFA_PPORT_ST_MAX_STATE,
+};
+
+/**
+ * 	Port speed settings. Each specific speed is a bit field. Use multiple
+ *      bits to specify speeds to be selected for auto-negotiation.
+ */
+enum bfa_pport_speed {
+	BFA_PPORT_SPEED_UNKNOWN = 0,
+	BFA_PPORT_SPEED_1GBPS 	= 1,
+	BFA_PPORT_SPEED_2GBPS 	= 2,
+	BFA_PPORT_SPEED_4GBPS 	= 4,
+	BFA_PPORT_SPEED_8GBPS 	= 8,
+	BFA_PPORT_SPEED_10GBPS 	= 10,
+	BFA_PPORT_SPEED_AUTO =
+		(BFA_PPORT_SPEED_1GBPS | BFA_PPORT_SPEED_2GBPS |
+		 BFA_PPORT_SPEED_4GBPS | BFA_PPORT_SPEED_8GBPS),
+};
+
+/**
+ * 		Port operational type (in sync with SNIA port type).
+ */
+enum bfa_pport_type {
+	BFA_PPORT_TYPE_UNKNOWN = 1,	/*  port type is unkown */
+	BFA_PPORT_TYPE_TRUNKED = 2,	/*  Trunked mode */
+	BFA_PPORT_TYPE_NPORT   = 5,	/*  P2P with switched fabric */
+	BFA_PPORT_TYPE_NLPORT  = 6,	/*  public loop */
+	BFA_PPORT_TYPE_LPORT   = 20,	/*  private loop */
+	BFA_PPORT_TYPE_P2P     = 21,	/*  P2P with no switched fabric */
+	BFA_PPORT_TYPE_VPORT   = 22,	/*  NPIV - virtual port */
+};
+
+/**
+ * 		Port topology setting. A port's topology and fabric login status
+ * 		determine its operational type.
+ */
+enum bfa_pport_topology {
+	BFA_PPORT_TOPOLOGY_NONE = 0,	/*  No valid topology */
+	BFA_PPORT_TOPOLOGY_P2P  = 1,	/*  P2P only */
+	BFA_PPORT_TOPOLOGY_LOOP = 2,	/*  LOOP topology */
+	BFA_PPORT_TOPOLOGY_AUTO = 3,	/*  auto topology selection */
+};
+
+/**
+ * 		Physical port loopback types.
+ */
+enum bfa_pport_opmode {
+	BFA_PPORT_OPMODE_NORMAL   = 0x00, /*  normal non-loopback mode */
+	BFA_PPORT_OPMODE_LB_INT   = 0x01, /*  internal loop back */
+	BFA_PPORT_OPMODE_LB_SLW   = 0x02, /*  serial link wrapback (serdes) */
+	BFA_PPORT_OPMODE_LB_EXT   = 0x04, /*  external loop back (serdes) */
+	BFA_PPORT_OPMODE_LB_CBL   = 0x08, /*  cabled loop back */
+	BFA_PPORT_OPMODE_LB_NLINT = 0x20, /*  NL_Port internal loopback */
+};
+
+#define BFA_PPORT_OPMODE_LB_HARD(_mode)			\
+	((_mode == BFA_PPORT_OPMODE_LB_INT) ||		\
+     (_mode == BFA_PPORT_OPMODE_LB_SLW) ||		\
+     (_mode == BFA_PPORT_OPMODE_LB_EXT))
+
+/**
+		Port State (in sync with SNIA port state).
+ */
+enum bfa_pport_snia_state {
+	BFA_PPORT_STATE_UNKNOWN  = 1,	/*  port is not initialized */
+	BFA_PPORT_STATE_ONLINE   = 2,	/*  port is ONLINE */
+	BFA_PPORT_STATE_DISABLED = 3,	/*  port is disabled by user */
+	BFA_PPORT_STATE_BYPASSED = 4,	/*  port is bypassed (in LOOP) */
+	BFA_PPORT_STATE_DIAG     = 5,	/*  port diagnostics is active */
+	BFA_PPORT_STATE_LINKDOWN = 6,	/*  link is down */
+	BFA_PPORT_STATE_LOOPBACK = 8,	/*  port is looped back */
+};
+
+/**
+ * 		Port link state
+ */
+enum bfa_pport_linkstate {
+	BFA_PPORT_LINKUP 	 = 1,	/*  Physical port/Trunk link up */
+	BFA_PPORT_LINKDOWN 	 = 2,	/*  Physical port/Trunk link down */
+	BFA_PPORT_TRUNK_LINKDOWN = 3,	/*  Trunk link down (new tmaster) */
+};
+
+/**
+ * 		Port link state event
+ */
+#define bfa_pport_event_t enum bfa_pport_linkstate
+
+/**
+ * 		Port link state reason code
+ */
+enum bfa_pport_linkstate_rsn {
+	BFA_PPORT_LINKSTATE_RSN_NONE		= 0,
+	BFA_PPORT_LINKSTATE_RSN_DISABLED 	= 1,
+	BFA_PPORT_LINKSTATE_RSN_RX_NOS 		= 2,
+	BFA_PPORT_LINKSTATE_RSN_RX_OLS 		= 3,
+	BFA_PPORT_LINKSTATE_RSN_RX_LIP 		= 4,
+	BFA_PPORT_LINKSTATE_RSN_RX_LIPF7 	= 5,
+	BFA_PPORT_LINKSTATE_RSN_SFP_REMOVED 	= 6,
+	BFA_PPORT_LINKSTATE_RSN_PORT_FAULT 	= 7,
+
+
+	/* CEE related reason codes/errors */
+	CEE_LLDP_INFO_AGED_OUT       = 20,
+	CEE_LLDP_SHUTDOWN_TLV_RCVD   = 21,
+	CEE_PEER_NOT_ADVERTISE_DCBX  = 22,
+	CEE_PEER_NOT_ADVERTISE_PG    = 23,
+	CEE_PEER_NOT_ADVERTISE_PFC   = 24,
+	CEE_PEER_NOT_ADVERTISE_FCOE  = 25,
+	CEE_PG_NOT_COMPATIBLE        = 26,
+	CEE_PFC_NOT_COMPATIBLE       = 27,
+	CEE_FCOE_NOT_COMPATIBLE      = 28,
+	CEE_BAD_PG_RCVD              = 29,
+	CEE_BAD_BW_RCVD              = 30,
+	CEE_BAD_PFC_RCVD             = 31,
+	CEE_BAD_FCOE_PRI_RCVD        = 32,
+	CEE_FCOE_PRI_PFC_OFF         = 33,
+	CEE_DUP_CONTROL_TLV_RCVD     = 34,
+	CEE_DUP_FEAT_TLV_RCVD        = 35,
+	CEE_APPLY_NEW_CFG            = 36,	/* reason, not an error */
+	CEE_PROTOCOL_INIT            = 37,  /* reason, not an error */
+	CEE_PHY_LINK_DOWN            = 38,
+};
+
+/**
+ *      Default Target Rate Limiting Speed.
+ */
+#define BFA_PPORT_DEF_TRL_SPEED  BFA_PPORT_SPEED_1GBPS
+
+/**
+ *      Physical port configuration
+ */
+struct bfa_pport_cfg_s {
+	u8         topology;	/*  bfa_pport_topology		*/
+	u8         speed;		/*  enum bfa_pport_speed	*/
+	u8         trunked;	/*  trunked or not		*/
+	u8         qos_enabled;	/*  qos enabled or not		*/
+	u8         trunk_ports;	/*  bitmap of trunked ports	*/
+	u8         cfg_hardalpa;	/*  is hard alpa configured	*/
+	u16        maxfrsize;	/*  maximum frame size		*/
+	u8         hardalpa;	/*  configured hard alpa	*/
+	u8         rx_bbcredit;	/*  receive buffer credits	*/
+	u8         tx_bbcredit;	/*  transmit buffer credits	*/
+	u8         ratelimit;	/*  ratelimit enabled or not	*/
+	u8         trl_def_speed;	/*  ratelimit default speed	*/
+	u8		rsvd[3];
+	u16   	path_tov;	/*  device path timeout	*/
+	u16   	q_depth;	/*  SCSI Queue depth		*/
+};
+
+/**
+ * 		Port attribute values.
+ */
+struct bfa_pport_attr_s {
+	/*
+	 * Static fields
+	 */
+	wwn_t           nwwn;		/*  node wwn */
+	wwn_t           pwwn;		/*  port wwn */
+	enum fc_cos     cos_supported;	/*  supported class of services */
+	u32        rsvd;
+	struct fc_symname_s    port_symname;	/*  port symbolic name */
+	enum bfa_pport_speed speed_supported; /*  supported speeds */
+	bfa_boolean_t   pbind_enabled;	/*  Will be set if Persistent binding
+					 *   enabled. Relevant only in Windows
+					 */
+
+	/*
+	 * Configured values
+	 */
+	struct bfa_pport_cfg_s pport_cfg;	/*  pport cfg */
+
+	/*
+	 * Dynamic field - info from BFA
+	 */
+	enum bfa_pport_states 	port_state;	/*  current port state */
+	enum bfa_pport_speed 	speed;		/*  current speed */
+	enum bfa_pport_topology 	topology;	/*  current topology */
+	bfa_boolean_t		beacon;		/*  current beacon status */
+	bfa_boolean_t		link_e2e_beacon;/*  set if link beacon on */
+	bfa_boolean_t		plog_enabled;	/*  set if portlog is enabled*/
+
+	/*
+	 * Dynamic field - info from FCS
+	 */
+	u32        	pid;		/*  port ID */
+	enum bfa_pport_type 	port_type;	/*  current topology */
+	u32        	loopback;	/*  external loopback */
+	u32		rsvd1;
+	u32		rsvd2;		/*  padding for 64 bit */
+};
+
+/**
+ * 		Port statistics.
+ */
+struct bfa_pport_stats_s {
+	u64        secs_since_reset;
+					/*  seconds since stats is reset */
+	u64        tx_frames;	/*  transmitted frames */
+	u64        tx_words;	/*  transmitted words */
+	u64        rx_frames;	/*  received frames */
+	u64        rx_words;	/*  received words */
+	u64        lip_count;	/*  LIPs seen */
+	u64        nos_count;	/*  NOS count */
+	u64        error_frames;	/*  errored frames (sent?) */
+	u64        dropped_frames;	/*  dropped frames */
+	u64        link_failures;	/*  link failure count */
+	u64        loss_of_syncs;	/*  loss of sync count */
+	u64        loss_of_signals;/*  loss of signal count */
+	u64        primseq_errs;	/*  primitive sequence protocol
+					 *   errors
+					 */
+	u64        bad_os_count;	 /*  invalid ordered set */
+	u64        err_enc_out;	 /*  Encoding error outside frame */
+	u64        invalid_crcs;	/*  frames received with invalid CRC*/
+	u64	undersized_frm; /*  undersized frames */
+	u64	oversized_frm;	/*  oversized frames */
+	u64	bad_eof_frm;	/*  frames with bad EOF */
+	struct bfa_qos_stats_s	qos_stats;	/*  QoS statistics */
+};
+
+
+/**
+ *              Port FC4 statistics.
+ */
+struct bfa_pport_fc4stats_s {
+	u64        input_requests;
+	u64        output_requests;
+	u64        control_requests;
+	u64       	input_megabytes;
+	u64        output_megabytes;
+};
+
+/**
+ *              Port FCP mappings.
+ */
+struct bfa_pport_fcpmap_s {
+	char		osdevname[256];
+	u32	bus;
+	u32        target;
+	u32        oslun;
+	u32        fcid;
+	wwn_t           nwwn;
+	wwn_t           pwwn;
+	u64        fcplun;
+};
+
+/**
+ *              Port RNID info.
+ */
+struct bfa_pport_rnid_s {
+	wwn_t             wwn;
+	u32          unittype;
+	u32          portid;
+	u32          attached_nodes_num;
+	u16          ip_version;
+	u16          udp_port;
+	u8           ipaddr[16];
+	u16          rsvd;
+	u16          topologydiscoveryflags;
+};
+
+/**
+ * 		Link state information
+ */
+struct bfa_pport_link_s {
+	u8         linkstate;	/*  Link state bfa_pport_linkstate */
+	u8         linkstate_rsn;	/*  bfa_pport_linkstate_rsn_t */
+	u8         topology;	/*  P2P/LOOP bfa_pport_topology */
+	u8         speed;		/*  Link speed (1/2/4/8 G) */
+	u32        linkstate_opt;	/*  Linkstate optional data (debug) */
+	u8         trunked;	/*  Trunked or not (1 or 0) */
+	u8         resvd[3];
+	struct bfa_qos_attr_s  qos_attr;   /* QoS Attributes */
+	struct bfa_qos_vc_attr_s qos_vc_attr;  /*  VC info from ELP */
+	union {
+		struct {
+			u8         tmaster;/*  Trunk Master or
+						 *    not (1 or 0) */
+			u8         tlinks;	/*  Trunk links bitmap
+						 *    (linkup) */
+			u8         resv1;	/*  Reserved */
+		} trunk_info;
+
+		struct {
+			u8         myalpa;	   /*  alpa claimed */
+			u8         login_req; /*  Login required or
+						    *    not (1 or 0) */
+			u8         alpabm_val;/*  alpa bitmap valid
+						    *    or not (1 or 0) */
+			struct fc_alpabm_s     alpabm;	   /*  alpa bitmap */
+		} loop_info;
+	} tl;
+};
+
+struct bfa_phy_port_stats_s {
+	struct cna_stats_mac_rx	mac_rx_stats;
+	struct cna_stats_bpc_rx	bpc_rx_stats;
+	struct cna_stats_rad	rad_stats;
+	struct cna_stats_mac_tx	mac_tx_stats;
+	struct cna_stats_bpc_tx	 bpc_tx_stats;
+};
+
+#endif /* __BFA_DEFS_PPORT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_qos.h patch/drivers/scsi/bfa/include/defs/bfa_defs_qos.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_qos.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_qos.h	2009-03-23 15:33:13.965289000 -0700
@@ -0,0 +1,99 @@
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
+#ifndef __BFA_DEFS_QOS_H__
+#define __BFA_DEFS_QOS_H__
+
+/**
+ * QoS states
+ */
+enum bfa_qos_state {
+	BFA_QOS_ONLINE = 1,		/*  QoS is online */
+	BFA_QOS_OFFLINE = 2,		/*  QoS is offline */
+};
+
+
+/**
+ * QoS  Priority levels.
+ */
+enum bfa_qos_priority {
+	BFA_QOS_UNKNOWN = 0,
+	BFA_QOS_HIGH  = 1,	/*  QoS Priority Level High */
+	BFA_QOS_MED  =  2,	/*  QoS Priority Level Medium */
+	BFA_QOS_LOW  =  3,	/*  QoS Priority Level Low */
+};
+
+
+/**
+ * QoS  bandwidth allocation for each priority level
+ */
+enum bfa_qos_bw_alloc {
+	BFA_QOS_BW_HIGH  = 60,	/*  bandwidth allocation for High */
+	BFA_QOS_BW_MED  =  30,	/*  bandwidth allocation for Medium */
+	BFA_QOS_BW_LOW  =  10,	/*  bandwidth allocation for Low */
+};
+
+/**
+ * QoS attribute returned in QoS Query
+ */
+struct bfa_qos_attr_s {
+	enum bfa_qos_state state;		/*  QoS current state */
+	u32  total_bb_cr;  	 	/*  Total BB Credits */
+};
+
+/**
+ * These fields should be displayed only from the CLI.
+ * There will be a separate BFAL API (get_qos_vc_attr ?)
+ * to retrieve this.
+ *
+ */
+#define  BFA_QOS_MAX_VC  16
+
+struct bfa_qos_vc_info_s {
+	u8 vc_credit;
+	u8 borrow_credit;
+	u8 priority;
+	u8 resvd;
+};
+
+struct bfa_qos_vc_attr_s {
+	u16  total_vc_count;                    /*  Total VC Count */
+	u16  shared_credit;
+	u32  elp_opmode_flags;
+	struct bfa_qos_vc_info_s vc_info[BFA_QOS_MAX_VC];  /*   as many as
+							    * total_vc_count */
+};
+
+/**
+ * QoS statistics
+ */
+struct bfa_qos_stats_s {
+	u32	flogi_sent; 		/*  QoS Flogi sent */
+	u32	flogi_acc_recvd;	/*  QoS Flogi Acc received */
+	u32	flogi_rjt_recvd; /*  QoS Flogi rejects received */
+	u32	flogi_retries;		/*  QoS Flogi retries */
+
+	u32	elp_recvd; 	   	/*  QoS ELP received */
+	u32	elp_accepted;       /*  QoS ELP Accepted */
+	u32	elp_rejected;       /*  QoS ELP rejected */
+	u32	elp_dropped;        /*  QoS ELP dropped  */
+
+	u32	qos_rscn_recvd;     /*  QoS RSCN received */
+	u32	rsvd; 		/* padding for 64 bit alignment */
+};
+
+#endif /* __BFA_DEFS_QOS_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_rport.h patch/drivers/scsi/bfa/include/defs/bfa_defs_rport.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_rport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_rport.h	2009-03-23 15:33:13.895746000 -0700
@@ -0,0 +1,199 @@
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
+#ifndef __BFA_DEFS_RPORT_H__
+#define __BFA_DEFS_RPORT_H__
+
+#include <bfa_os_inc.h>
+#include <protocol/types.h>
+#include <defs/bfa_defs_pport.h>
+#include <defs/bfa_defs_port.h>
+#include <defs/bfa_defs_qos.h>
+
+/**
+ * FCS remote port states
+ */
+enum bfa_rport_state {
+	BFA_RPORT_UNINIT 	= 0,	/*  PORT is not yet initialized */
+	BFA_RPORT_OFFLINE 	= 1,	/*  rport is offline */
+	BFA_RPORT_PLOGI 	= 2,	/*  PLOGI to rport is in progress */
+	BFA_RPORT_ONLINE 	= 3,	/*  login to rport is complete */
+	BFA_RPORT_PLOGI_RETRY 	= 4,	/*  retrying login to rport */
+	BFA_RPORT_NSQUERY 	= 5,	/*  nameserver query */
+	BFA_RPORT_ADISC 	= 6,	/*  ADISC authentication */
+	BFA_RPORT_LOGO 		= 7,	/*  logging out with rport */
+	BFA_RPORT_LOGORCV 	= 8,	/*  handling LOGO from rport */
+	BFA_RPORT_NSDISC 	= 9,	/*  re-discover rport */
+};
+
+/**
+ *  Rport Scsi Function : Initiator/Target.
+ */
+enum bfa_rport_function {
+	BFA_RPORT_INITIATOR 	= 0x01,	/*  SCSI Initiator	*/
+	BFA_RPORT_TARGET 	= 0x02,	/*  SCSI Target	*/
+};
+
+/**
+ * port/node symbolic names for rport
+ */
+#define BFA_RPORT_SYMNAME_MAXLEN	255
+struct bfa_rport_symname_s {
+	char            symname[BFA_RPORT_SYMNAME_MAXLEN];
+};
+
+struct bfa_rport_hal_stats_s {
+	u32        sm_un_cr;	    /*  uninit: create events      */
+	u32        sm_un_unexp;	    /*  uninit: exception events   */
+	u32        sm_cr_on;	    /*  created: online events     */
+	u32        sm_cr_del;	    /*  created: delete events     */
+	u32        sm_cr_hwf;	    /*  created: IOC down          */
+	u32        sm_cr_unexp;	    /*  created: exception events  */
+	u32        sm_fwc_rsp;	    /*  fw create: f/w responses   */
+	u32        sm_fwc_del;	    /*  fw create: delete events   */
+	u32        sm_fwc_off;	    /*  fw create: offline events  */
+	u32        sm_fwc_hwf;	    /*  fw create: IOC down        */
+	u32        sm_fwc_unexp;	    /*  fw create: exception events*/
+	u32        sm_on_off;	    /*  online: offline events     */
+	u32        sm_on_del;	    /*  online: delete events      */
+	u32        sm_on_hwf;	    /*  online: IOC down events    */
+	u32        sm_on_unexp;	    /*  online: exception events   */
+	u32        sm_fwd_rsp;	    /*  fw delete: fw responses    */
+	u32        sm_fwd_del;	    /*  fw delete: delete events   */
+	u32        sm_fwd_hwf;	    /*  fw delete: IOC down events */
+	u32        sm_fwd_unexp;	    /*  fw delete: exception events*/
+	u32        sm_off_del;	    /*  offline: delete events     */
+	u32        sm_off_on;	    /*  offline: online events     */
+	u32        sm_off_hwf;	    /*  offline: IOC down events   */
+	u32        sm_off_unexp;	    /*  offline: exception events  */
+	u32        sm_del_fwrsp;	    /*  delete: fw responses       */
+	u32        sm_del_hwf;	    /*  delete: IOC down events    */
+	u32        sm_del_unexp;	    /*  delete: exception events   */
+	u32        sm_delp_fwrsp;	    /*  delete pend: fw responses  */
+	u32        sm_delp_hwf;	    /*  delete pend: IOC downs     */
+	u32        sm_delp_unexp;	    /*  delete pend: exceptions    */
+	u32        sm_offp_fwrsp;	    /*  off-pending: fw responses  */
+	u32        sm_offp_del;	    /*  off-pending: deletes       */
+	u32        sm_offp_hwf;	    /*  off-pending: IOC downs     */
+	u32        sm_offp_unexp;	    /*  off-pending: exceptions    */
+	u32        sm_iocd_off;	    /*  IOC down: offline events   */
+	u32        sm_iocd_del;	    /*  IOC down: delete events    */
+	u32        sm_iocd_on;	    /*  IOC down: online events    */
+	u32        sm_iocd_unexp;	    /*  IOC down: exceptions       */
+	u32        rsvd;
+};
+
+/**
+ * FCS remote port statistics
+ */
+struct bfa_rport_stats_s {
+	u32        offlines;           /*  remote port offline count  */
+	u32        onlines;            /*  remote port online count   */
+	u32        rscns;              /*  RSCN affecting rport       */
+	u32        plogis;		    /*  plogis sent                */
+	u32        plogi_accs;	    /*  plogi accepts              */
+	u32        plogi_timeouts;	    /*  plogi timeouts             */
+	u32        plogi_rejects;	    /*  rcvd plogi rejects         */
+	u32        plogi_failed;	    /*  local failure              */
+	u32        plogi_rcvd;	    /*  plogis rcvd                */
+	u32        prli_rcvd;          /*  inbound PRLIs              */
+	u32        adisc_rcvd;         /*  ADISCs received            */
+	u32        adisc_rejects;      /*  recvd  ADISC rejects       */
+	u32        adisc_sent;         /*  ADISC requests sent        */
+	u32        adisc_accs;         /*  ADISC accepted by rport    */
+	u32        adisc_failed;       /*  ADISC failed (no response) */
+	u32        adisc_rejected;     /*  ADISC rejected by us    */
+	u32        logos;              /*  logos sent                 */
+	u32        logo_accs;          /*  LOGO accepts from rport    */
+	u32        logo_failed;        /*  LOGO failures              */
+	u32        logo_rejected;      /*  LOGO rejects from rport    */
+	u32        logo_rcvd;          /*  LOGO from remote port      */
+
+	u32        rpsc_rcvd;         /*  RPSC received            */
+	u32        rpsc_rejects;      /*  recvd  RPSC rejects       */
+	u32        rpsc_sent;         /*  RPSC requests sent        */
+	u32        rpsc_accs;         /*  RPSC accepted by rport    */
+	u32        rpsc_failed;       /*  RPSC failed (no response) */
+	u32        rpsc_rejected;     /*  RPSC rejected by us    */
+
+	u32        rsvd;
+	struct bfa_rport_hal_stats_s	hal_stats;  /*  BFA rport stats    */
+};
+
+/**
+ *  Rport's QoS attributes
+ */
+struct bfa_rport_qos_attr_s {
+	enum bfa_qos_priority qos_priority;  /*  rport's QoS priority   */
+	u32	       qos_flow_id;	  /*  QoS flow Id	 */
+};
+
+/**
+ * FCS remote port attributes returned in queries
+ */
+struct bfa_rport_attr_s {
+	wwn_t           	nwwn;	/*  node wwn */
+	wwn_t           	pwwn;	/*  port wwn */
+	enum fc_cos      cos_supported;	/*  supported class of services */
+	u32        	pid;	/*  port ID */
+	u32        	df_sz;	/*  Max payload size */
+	enum bfa_rport_state 	state;	/*  Rport State machine state */
+	enum fc_cos        	fc_cos;	/*  FC classes of services */
+	bfa_boolean_t   	cisc;	/*  CISC capable device */
+	struct bfa_rport_symname_s symname; /*  Symbolic Name */
+	enum bfa_rport_function	scsi_function; /*  Initiator/Target */
+	struct bfa_rport_qos_attr_s qos_attr; /*  qos attributes  */
+	enum bfa_pport_speed curr_speed;   /*  operating speed got from
+					    * RPSC ELS. UNKNOWN, if RPSC
+					    * is not supported */
+	bfa_boolean_t 	trl_enforced;	/*  TRL enforced ? TRUE/FALSE */
+	enum bfa_pport_speed	assigned_speed;	/* Speed assigned by the user.
+						 * will be used if RPSC is not
+						 * supported by the rport */
+};
+
+#define bfa_rport_aen_qos_data_t struct bfa_rport_qos_attr_s
+
+/**
+ * BFA remote port events
+ * Arguments below are in BFAL context from Mgmt
+ * BFA_RPORT_AEN_ONLINE:    [in]: lpwwn	[out]: vf_id, lpwwn, rpwwn
+ * BFA_RPORT_AEN_OFFLINE:   [in]: lpwwn [out]: vf_id, lpwwn, rpwwn
+ * BFA_RPORT_AEN_DISCONNECT:[in]: lpwwn [out]: vf_id, lpwwn, rpwwn
+ * BFA_RPORT_AEN_QOS_PRIO:  [in]: lpwwn [out]: vf_id, lpwwn, rpwwn, prio
+ * BFA_RPORT_AEN_QOS_FLOWID:[in]: lpwwn [out]: vf_id, lpwwn, rpwwn, flow_id
+ */
+enum bfa_rport_aen_event {
+	BFA_RPORT_AEN_ONLINE      = 1,	/*  RPort online event */
+	BFA_RPORT_AEN_OFFLINE     = 2,	/*  RPort offline event */
+	BFA_RPORT_AEN_DISCONNECT  = 3,	/*  RPort disconnect event */
+	BFA_RPORT_AEN_QOS_PRIO    = 4,	/*  QOS priority change event */
+	BFA_RPORT_AEN_QOS_FLOWID  = 5,	/*  QOS flow Id change event */
+};
+
+struct bfa_rport_aen_data_s {
+	u16        vf_id;	/*  vf_id of this logical port */
+	u16        rsvd[3];
+	wwn_t           ppwwn;	/*  WWN of its physical port */
+	wwn_t           lpwwn;	/*  WWN of this logical port */
+	wwn_t           rpwwn;	/*  WWN of this remote port */
+	union {
+		bfa_rport_aen_qos_data_t qos;
+	} priv;
+};
+
+#endif /* __BFA_DEFS_RPORT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_status.h patch/drivers/scsi/bfa/include/defs/bfa_defs_status.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_status.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_status.h	2009-03-23 15:33:14.004993000 -0700
@@ -0,0 +1,160 @@
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
+#ifndef __BFA_DEFS_STATUS_H__
+#define __BFA_DEFS_STATUS_H__
+
+/**
+ * API status return values
+ *
+ * NOTE: The error msgs are auto generated from the comments. Only singe line
+ * comments are supported
+ */
+enum bfa_status {
+	BFA_STATUS_OK 		= 0,	/*  Success */
+	BFA_STATUS_FAILED 	= 1,	/*  Operation failed */
+	BFA_STATUS_EINVAL 	= 2,	/*  Invalid params Check input parameters */
+	BFA_STATUS_ENOMEM 	= 3,	/*  Out of resources */
+	BFA_STATUS_ENOSYS 	= 4,	/*  Function not implemented */
+	BFA_STATUS_ETIMER 	= 5,	/*  Timer expired - Retry, if persists, contact support */
+	BFA_STATUS_EPROTOCOL 	= 6,	/*  Protocol error */
+	BFA_STATUS_ENOFCPORTS 	= 7,	/*  No FC ports resources */
+	BFA_STATUS_NOFLASH 	= 8,	/*  Flash not present */
+	BFA_STATUS_BADFLASH 	= 9,	/*  Flash is corrupted or bad */
+	BFA_STATUS_SFP_UNSUPP 	= 10,	/*  Unsupported SFP - Replace SFP */
+	BFA_STATUS_UNKNOWN_VFID = 11,	/*  VF_ID not found */
+	BFA_STATUS_DATACORRUPTED = 12,	/*  Diag returned data corrupted contact support */
+	BFA_STATUS_DEVBUSY 	= 13,	/*  Device busy - Retry operation */
+	BFA_STATUS_ABORTED 	= 14,	/*  Operation aborted */
+	BFA_STATUS_NODEV 	= 15,	/*  Dev is not present */
+	BFA_STATUS_HDMA_FAILED 	= 16,	/*  Host dma failed contact support */
+	BFA_STATUS_FLASH_BAD_LEN = 17,	/*  Flash bad length */
+	BFA_STATUS_UNKNOWN_LWWN = 18,	/*  LPORT PWWN not found */
+	BFA_STATUS_UNKNOWN_RWWN = 19,	/*  RPORT PWWN not found */
+	BFA_STATUS_FCPT_LS_RJT 	= 20,	/*  Got LS_RJT for FC Pass through Req */
+	BFA_STATUS_VPORT_EXISTS = 21,	/*  VPORT already exists */
+	BFA_STATUS_VPORT_MAX 	= 22,	/*  Reached max VPORT supported limit */
+	BFA_STATUS_UNSUPP_SPEED = 23,	/*  Invalid Speed Check speed setting */
+	BFA_STATUS_INVLD_DFSZ 	= 24,	/*  Invalid Max data field size */
+	BFA_STATUS_CNFG_FAILED 	= 25,	/*  Setting can not be persisted */
+	BFA_STATUS_CMD_NOTSUPP 	= 26,	/*  Command/API not supported */
+	BFA_STATUS_NO_ADAPTER 	= 27,	/*  No Brocade Adapter Found */
+	BFA_STATUS_LINKDOWN 	= 28,	/*  Link is down - Check or replace SFP/cable */
+	BFA_STATUS_FABRIC_RJT 	= 29,	/*  Reject from attached fabric */
+	BFA_STATUS_UNKNOWN_VWWN = 30,	/*  VPORT PWWN not found */
+	BFA_STATUS_NSLOGIN_FAILED = 31,	/*  Nameserver login failed */
+	BFA_STATUS_NO_RPORTS 	= 32,	/*  No remote ports found */
+	BFA_STATUS_NSQUERY_FAILED = 33,	/*  Nameserver query failed */
+	BFA_STATUS_PORT_OFFLINE = 34,	/*  Port is not online */
+	BFA_STATUS_RPORT_OFFLINE = 35,	/*  RPORT is not online */
+	BFA_STATUS_TGTOPEN_FAILED = 36,	/*  Remote SCSI target open failed */
+	BFA_STATUS_BAD_LUNS 	= 37,	/*  No valid LUNs found */
+	BFA_STATUS_IO_FAILURE 	= 38,	/*  SCSI target IO failure */
+	BFA_STATUS_NO_FABRIC 	= 39,	/*  No switched fabric present */
+	BFA_STATUS_EBADF 	= 40,	/*  Bad file descriptor */
+	BFA_STATUS_EINTR 	= 41,	/*  A signal was caught during ioctl */
+	BFA_STATUS_EIO 		= 42,	/*  I/O error */
+	BFA_STATUS_ENOTTY 	= 43,	/*  Inappropriate I/O control operation */
+	BFA_STATUS_ENXIO 	= 44,	/*  No such device or address */
+	BFA_STATUS_EFOPEN 	= 45,	/*  Failed to open file */
+	BFA_STATUS_VPORT_WWN_BP = 46,	/*  WWN is same as base port's WWN */
+	BFA_STATUS_PORT_NOT_DISABLED = 47, /*  Port not disabled disable port first */
+	BFA_STATUS_BADFRMHDR 	= 48,	/*  Bad frame header */
+	BFA_STATUS_BADFRMSZ 	= 49,	/*  Bad frame size check and replace SFP/cable */
+	BFA_STATUS_MISSINGFRM 	= 50,	/*  Missing frame check and replace SFP/cable */
+	BFA_STATUS_LINKTIMEOUT 	= 51,	/*  Link timeout check and replace SFP/cable */
+	BFA_STATUS_NO_FCPIM_NEXUS = 52,	/*  No FCP Nexus exists with the  rport */
+	BFA_STATUS_CHECKSUM_FAIL = 53,	/*  checksum failure */
+	BFA_STATUS_GZME_FAILED 	= 54,	/*  Get zone member query failed */
+	BFA_STATUS_SCSISTART_REQD = 55,	/*  SCSI disk require START command */
+	BFA_STATUS_IOC_FAILURE 	= 56,	/*  IOC failure - Retry, if persists contact support */
+	BFA_STATUS_INVALID_WWN 	= 57,	/*  Invalid WWN */
+	BFA_STATUS_MISMATCH 	= 58,	/*  Version mismatch */
+	BFA_STATUS_IOC_ENABLED 	= 59,	/*  IOC is already enabled */
+	BFA_STATUS_ADAPTER_ENABLED = 60, /*  Adapter is not disabled disable adapter first */
+	BFA_STATUS_IOC_NON_OP 	= 61,	/*  IOC is not operational. Enable IOC and if it still fails, contact support */
+	BFA_STATUS_ADDR_MAP_FAILURE = 62, /*  PCI base address not mapped in OS */
+	BFA_STATUS_SAME_NAME 	= 63,	/*  Name exists! use a different name */
+	BFA_STATUS_PENDING      = 64,   /*  API completes asynchronously */
+	BFA_STATUS_8G_SPD	= 65,	/*  Speed setting not valid for 8G HBA */
+	BFA_STATUS_4G_SPD	= 66,	/*  Speed setting not valid for 4G HBA */
+	BFA_STATUS_AD_IS_ENABLE = 67,	/*  Adapter is already enabled */
+	BFA_STATUS_EINVAL_TOV 	= 68,	/*  Invalid path failover TOV */
+	BFA_STATUS_EINVAL_QDEPTH = 69,	/*  Invalid queue depth value */
+	BFA_STATUS_VERSION_FAIL = 70,	/*  Application/Driver version mismatch */
+	BFA_STATUS_DIAG_BUSY    = 71,	/*  diag busy */
+	BFA_STATUS_BEACON_ON	= 72,	/*  Port Beacon already on */
+	BFA_STATUS_BEACON_OFF	= 73,	/*  Port Beacon already off */
+	BFA_STATUS_LBEACON_ON   = 74,	/*  Link End-to-End Beacon already on */
+	BFA_STATUS_LBEACON_OFF	= 75,	/*  Link End-to-End Beacon already off */
+	BFA_STATUS_PORT_NOT_INITED = 76, /*  Port not initialized */
+	BFA_STATUS_RPSC_ENABLED = 77, /*  Target has a valid speed */
+	BFA_STATUS_ENOFSAVE 	= 78,	/*  No saved firmware trace */
+	BFA_STATUS_BAD_FILE		= 79,	/*  Not a valid Brocade Boot Code file */
+	BFA_STATUS_RLIM_EN		= 80,	/*  Target rate limiting is already enabled */
+	BFA_STATUS_RLIM_DIS		= 81,  /*  Target rate limiting is already disabled */
+	BFA_STATUS_IOC_DISABLED  = 82,   /*  IOC is already disabled */
+	BFA_STATUS_ADAPTER_DISABLED  = 83,   /*  Adapter is already disabled */
+	BFA_STATUS_BIOS_DISABLED  = 84,   /*  Bios is already disabled */
+	BFA_STATUS_AUTH_ENABLED  = 85,   /*  Authentication is already enabled */
+	BFA_STATUS_AUTH_DISABLED  = 86,   /*  Authentication is already disabled */
+	BFA_STATUS_ERROR_TRL_ENABLED  = 87,   /*  Target rate limiting is enabled */
+	BFA_STATUS_ERROR_QOS_ENABLED  = 88,   /*  QoS is enabled */
+	BFA_STATUS_NO_SFP_DEV = 89,     /*  No SFP device check or replace SFP */
+	BFA_STATUS_MEMTEST_FAILED = 90,	/*  Memory test failed contact support */
+	BFA_STATUS_INVALID_DEVID = 91,	/*  Invalid device id provided */
+	BFA_STATUS_QOS_ENABLED = 92, /*  QOS is already enabled */
+	BFA_STATUS_QOS_DISABLED = 93, /*  QOS is already disabled */
+	BFA_STATUS_INCORRECT_DRV_CONFIG = 94, /*  Check configuration key/value pair */
+	BFA_STATUS_REG_FAIL = 95, /*  Can't read windows registry */
+	BFA_STATUS_IM_INV_CODE = 96, /*  Invalid IOCTL code */
+	BFA_STATUS_IM_INV_VLAN = 97, /*  Invalid VLAN ID */
+	BFA_STATUS_IM_INV_ADAPT_NAME = 98, /*  Invalid adapter name */
+	BFA_STATUS_IM_LOW_RESOURCES = 99, /*  Memory allocation failure in driver */
+	BFA_STATUS_IM_VLANID_IS_PVID = 100, /*  Given VLAN id same as PVID */
+	BFA_STATUS_IM_VLANID_EXISTS = 101, /*  Given VLAN id already exists */
+	BFA_STATUS_IM_FW_UPDATE_FAIL = 102, /*  Updating firmware with new VLAN ID failed */
+	BFA_STATUS_PORTLOG_ENABLED = 103, /*  Port Log is already enabled */
+	BFA_STATUS_PORTLOG_DISABLED = 104, /*  Port Log is already disabled */
+	BFA_STATUS_FILE_NOT_FOUND = 105, /*  Specified file could not be found */
+	BFA_STATUS_QOS_FC_ONLY = 106, /*  QOS can be enabled for FC mode only */
+	BFA_STATUS_RLIM_FC_ONLY = 107, /*  RATELIM can be enabled for FC mode only */
+	BFA_STATUS_CT_SPD = 108, /*  Invalid speed selection for Catapult. */
+	BFA_STATUS_LEDTEST_OP = 109, /*  LED test is operating */
+	BFA_STATUS_CEE_NOT_DN = 110, /*  eth port is not at down state, please bring down first */
+	BFA_STATUS_10G_SPD = 111, /*  Speed setting not valid for 10G HBA */
+	BFA_STATUS_IM_INV_TEAM_NAME = 112, /*  Invalid team name */
+	BFA_STATUS_IM_DUP_TEAM_NAME = 113, /*  Given team name already exists */
+	BFA_STATUS_IM_ADAPT_ALREADY_IN_TEAM = 114, /*  Given adapter is part of another team */
+	BFA_STATUS_IM_ADAPT_HAS_VLANS = 115, /*  Adapter has VLANs configured. Delete all VLANs before creating team */
+	BFA_STATUS_IM_PVID_MISMATCH = 116, /*  Mismatching PVIDs configured for adapters */
+	BFA_STATUS_IM_LINK_SPEED_MISMATCH = 117, /*  Mismatching link speeds configured for adapters */
+	BFA_STATUS_IM_MTU_MISMATCH = 118, /*  Mismatching MTUs configured for adapters */
+	BFA_STATUS_IM_RSS_MISMATCH = 119, /*  Mismatching RSS parameters configured for adapters */
+	BFA_STATUS_IM_HDS_MISMATCH = 120, /*  Mismatching HDS parameters configured for adapters */
+	BFA_STATUS_IM_OFFLOAD_MISMATCH = 121, /*  Mismatching offload parameters configured for adapters */
+	BFA_STATUS_IM_PORT_PARAMS = 122, /*  Error setting port parameters */
+	BFA_STATUS_IM_PORT_NOT_IN_TEAM = 123, /*  Port is not part of team */
+	BFA_STATUS_IM_CANNOT_REM_PRI = 124, /*  Primary adapter cannot be removed. Change primary before removing */
+	BFA_STATUS_IM_MAX_PORTS_REACHED = 125, /*  Exceeding maximum ports per team */
+	BFA_STATUS_IM_LAST_PORT_DELETE = 126, /*  Last port in team being deleted */
+	BFA_STATUS_IM_NO_DRIVER = 127, /*  IM driver is not installed */
+	BFA_STATUS_IM_MAX_VLANS_REACHED = 128, /*  Exceeding maximum VLANs per port */
+	BFA_STATUS_MAX_VAL		/*  Unknown error code */
+};
+#define bfa_status_t enum bfa_status
+
+#endif /* __BFA_DEFS_STATUS_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_types.h patch/drivers/scsi/bfa/include/defs/bfa_defs_types.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_types.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_types.h	2009-03-23 15:33:14.015759000 -0700
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
+#ifndef __BFA_DEFS_TYPES_H__
+#define __BFA_DEFS_TYPES_H__
+
+#include <bfa_os_inc.h>
+
+enum bfa_boolean {
+	BFA_FALSE = 0,
+	BFA_TRUE  = 1
+};
+#define bfa_boolean_t enum bfa_boolean
+
+#define BFA_STRING_32	32
+
+#endif /* __BFA_DEFS_TYPES_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_version.h patch/drivers/scsi/bfa/include/defs/bfa_defs_version.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_version.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_version.h	2009-03-23 15:33:13.957434000 -0700
@@ -0,0 +1,22 @@
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
+#ifndef __BFA_DEFS_VERSION_H__
+#define __BFA_DEFS_VERSION_H__
+
+#define BFA_VERSION_LEN		64
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_vf.h patch/drivers/scsi/bfa/include/defs/bfa_defs_vf.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_vf.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_vf.h	2009-03-23 15:33:13.903556000 -0700
@@ -0,0 +1,74 @@
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
+#ifndef __BFA_DEFS_VF_H__
+#define __BFA_DEFS_VF_H__
+
+#include <bfa_os_inc.h>
+#include <defs/bfa_defs_port.h>
+#include <protocol/types.h>
+
+/**
+ * VF states
+ */
+enum bfa_vf_state {
+	BFA_VF_UNINIT    = 0,	/*  fabric is not yet initialized */
+	BFA_VF_LINK_DOWN = 1,	/*  link is down */
+	BFA_VF_FLOGI     = 2,	/*  flogi is in progress */
+	BFA_VF_AUTH      = 3,	/*  authentication in progress */
+	BFA_VF_NOFABRIC  = 4,	/*  fabric is not present */
+	BFA_VF_ONLINE    = 5,	/*  login to fabric is complete */
+	BFA_VF_EVFP      = 6,	/*  EVFP is in progress */
+	BFA_VF_ISOLATED  = 7,	/*  port isolated due to vf_id mismatch */
+};
+
+/**
+ * VF statistics
+ */
+struct bfa_vf_stats_s {
+	u32        flogi_sent;	/*  Num FLOGIs sent 		*/
+	u32        flogi_rsp_err;	/*  FLOGI response errors 	*/
+	u32        flogi_acc_err;	/*  FLOGI accept errors 	*/
+	u32        flogi_accepts;	/*  FLOGI accepts received 	*/
+	u32        flogi_rejects;	/*  FLOGI rejects received 	*/
+	u32        flogi_unknown_rsp; /*  Unknown responses for FLOGI */
+	u32        flogi_alloc_wait; /*  Allocation waits prior to
+					   * sending FLOGI
+					   */
+	u32        flogi_rcvd;	/*  FLOGIs received */
+	u32        flogi_rejected;	/*  Incoming FLOGIs rejected */
+	u32        fabric_onlines;	/*  Internal fabric online
+					 * notification sent to other
+					 * modules
+					 */
+	u32        fabric_offlines; /*  Internal fabric offline
+					  * notification sent to other
+					  * modules
+					  */
+	u32        resvd;
+};
+
+/**
+ * VF attributes returned in queries
+ */
+struct bfa_vf_attr_s {
+	enum bfa_vf_state  state;		/*  VF state */
+	u32        rsvd;
+	wwn_t           fabric_name;	/*  fabric name */
+};
+
+#endif /* __BFA_DEFS_VF_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_vport.h patch/drivers/scsi/bfa/include/defs/bfa_defs_vport.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_vport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_vport.h	2009-03-23 15:33:13.911283000 -0700
@@ -0,0 +1,91 @@
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
+#ifndef __BFA_DEFS_VPORT_H__
+#define __BFA_DEFS_VPORT_H__
+
+#include <bfa_os_inc.h>
+#include <defs/bfa_defs_port.h>
+#include <protocol/types.h>
+
+/**
+ * VPORT states
+ */
+enum bfa_vport_state {
+	BFA_FCS_VPORT_UNINIT 		= 0,
+	BFA_FCS_VPORT_CREATED 		= 1,
+	BFA_FCS_VPORT_OFFLINE 		= 1,
+	BFA_FCS_VPORT_FDISC_SEND 	= 2,
+	BFA_FCS_VPORT_FDISC 		= 3,
+	BFA_FCS_VPORT_FDISC_RETRY 	= 4,
+	BFA_FCS_VPORT_ONLINE 		= 5,
+	BFA_FCS_VPORT_DELETING 		= 6,
+	BFA_FCS_VPORT_CLEANUP 		= 6,
+	BFA_FCS_VPORT_LOGO_SEND 	= 7,
+	BFA_FCS_VPORT_LOGO 			= 8,
+	BFA_FCS_VPORT_ERROR			= 9,
+	BFA_FCS_VPORT_MAX_STATE,
+};
+
+/**
+ * vport statistics
+ */
+struct bfa_vport_stats_s {
+	struct bfa_port_stats_s port_stats;	/*  base class (port) stats */
+	/*
+	 * TODO - remove
+	 */
+
+	u32        fdisc_sent;	/*  num fdisc sent */
+	u32        fdisc_accepts;	/*  fdisc accepts */
+	u32        fdisc_retries;	/*  fdisc retries */
+	u32        fdisc_timeouts;	/*  fdisc timeouts */
+	u32        fdisc_rsp_err;	/*  fdisc response error */
+	u32        fdisc_acc_bad;	/*  bad fdisc accepts */
+	u32        fdisc_rejects;	/*  fdisc rejects */
+	u32        fdisc_unknown_rsp;
+	/*
+	 *!< fdisc rsp unknown error
+	 */
+	u32        fdisc_alloc_wait;/*  fdisc req (fcxp)alloc wait */
+
+	u32        logo_alloc_wait;/*  logo req (fcxp) alloc wait */
+	u32        logo_sent;	/*  logo sent */
+	u32        logo_accepts;	/*  logo accepts */
+	u32        logo_rejects;	/*  logo rejects */
+	u32        logo_rsp_err;	/*  logo rsp errors */
+	u32        logo_unknown_rsp;
+			/*  logo rsp unknown errors */
+
+	u32        fab_no_npiv;	/*  fabric does not support npiv */
+
+	u32        fab_offline;	/*  offline events from fab SM */
+	u32        fab_online;	/*  online events from fab SM */
+	u32        fab_cleanup;	/*  cleanup request from fab SM */
+	u32        rsvd;
+};
+
+/**
+ * BFA vport attribute returned in queries
+ */
+struct bfa_vport_attr_s {
+	struct bfa_port_attr_s   port_attr; /*  base class (port) attributes */
+	enum bfa_vport_state vport_state; /*  vport state */
+	u32          rsvd;
+};
+
+#endif /* __BFA_DEFS_VPORT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/log/bfa_log_fcs.h patch/drivers/scsi/bfa/include/log/bfa_log_fcs.h
--- orig/drivers/scsi/bfa/include/log/bfa_log_fcs.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/log/bfa_log_fcs.h	2009-03-23 15:33:14.174138000 -0700
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
+++ patch/drivers/scsi/bfa/include/log/bfa_log_hal.h	2009-03-23 15:33:14.181775000 -0700
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
+#endif
diff -urpN orig/drivers/scsi/bfa/include/log/bfa_log_linux.h patch/drivers/scsi/bfa/include/log/bfa_log_linux.h
--- orig/drivers/scsi/bfa/include/log/bfa_log_linux.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/log/bfa_log_linux.h	2009-03-23 15:33:14.189428000 -0700
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
+++ patch/drivers/scsi/bfa/include/log/bfa_log_wdrv.h	2009-03-23 15:33:14.196840000 -0700
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
diff -urpN orig/drivers/scsi/bfa/include/protocol/bfa_protocol.h patch/drivers/scsi/bfa/include/protocol/bfa_protocol.h
--- orig/drivers/scsi/bfa/include/protocol/bfa_protocol.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/protocol/bfa_protocol.h	2009-03-23 15:33:13.829896000 -0700
@@ -0,0 +1,245 @@
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
+#ifndef __BFA_PROTOCOL_H__
+#define __BFA_PROTOCOL_H__
+
+#include <protocol/types.h>
+
+#pragma pack(1)
+
+/*
+ * scsi definition
+ */
+
+/*
+ * generic SCSI cdb definition
+ */
+#define SCSI_MAX_CDBLEN     16
+struct scsi_cdb_s{
+	u8         scsi_cdb[SCSI_MAX_CDBLEN];
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
+/*
+ * fc definition
+ */
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
+ * generic ELS command
+ */
+struct fc_els_cmd_s{
+	u32        els_code:8;	/* ELS Command Code */
+	u32        reserved:24;
+};
+/*
+ * PDU size defines
+ */
+enum {
+	FC_MIN_PDUSZ = 512,
+	FC_MAX_PDUSZ = 2112,
+};
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
+ * virtual fabric related defines
+ */
+#define FC_VF_ID_NULL    0	/*  must not be used as VF_ID */
+#define FC_VF_ID_MIN     1
+#define FC_VF_ID_MAX     0xEFF
+#define FC_VF_ID_CTL     0xFEF	/*  control VF_ID */
+
+/*
+ * fcp definition
+ */
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
+/*
+ * FCP_RSP residue flags
+ */
+enum fcp_residue{
+	FCP_NO_RESIDUE = 0,	/* no residue */
+	FCP_RESID_OVER = 1,	/* more data left that was not sent */
+	FCP_RESID_UNDER = 2,	/* less data than requested */
+};
+
+/*
+ * fcp_cmnd_t.iodir field values
+ */
+enum fcp_iodir {
+	FCP_IODIR_NONE	= 0,
+	FCP_IODIR_WRITE = 1,
+	FCP_IODIR_READ	= 2,
+	FCP_IODIR_RW	= 3,
+};
+
+/*
+ * Task management flags field - only one bit shall be set
+ */
+#ifndef BIT
+#define BIT(_x)	(1 << (_x))
+#endif
+enum fcp_tm_cmnd {
+	FCP_TM_ABORT_TASK_SET	= BIT(1),
+	FCP_TM_CLEAR_TASK_SET	= BIT(2),
+	FCP_TM_LUN_RESET	= BIT(4),
+	FCP_TM_TARGET_RESET	= BIT(5),	/* obsolete in FCP-3 */
+	FCP_TM_CLEAR_ACA	= BIT(6),
+};
+
+/*
+ * fc_sp definition
+ */
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
+	FC_AUTH_CEXP_AUTH_FAILED 			= 0x05,
+	FC_AUTH_CEXP_INCORRECT_PLD 		= 0x06,
+	FC_AUTH_CEXP_INCORRECT_PROTO_MSG 	= 0x07,
+	FC_AUTH_CEXP_RESTART_AUTH_PROTO 	= 0x08,
+	FC_AUTH_CEXP_AUTH_CONCAT_NOT_SUPP 	= 0x09,
+	FC_AUTH_CEXP_PROTO_VER_NOT_SUPP 	= 0x0A,
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
+enum auth_status {
+	FC_AUTH_STATE_INPROGRESS = 0, 	/*! authentication in progress 	*/
+	FC_AUTH_STATE_FAILED	= 1, 	/*! authentication failed */
+	FC_AUTH_STATE_SUCCESS	= 2 	/*! authentication successful	*/
+};
+
+#pragma pack()
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/protocol/types.h patch/drivers/scsi/bfa/include/protocol/types.h
--- orig/drivers/scsi/bfa/include/protocol/types.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/protocol/types.h	2009-03-23 15:33:13.837351000 -0700
@@ -0,0 +1,41 @@
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
+
+#pragma pack()
+
+#endif

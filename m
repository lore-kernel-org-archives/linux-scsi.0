From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 10/14] bfa: Brocade BFA FC SCSI driver (include part1)
Date: Fri, 28 Aug 2009 01:17:09 -0700
Message-ID: <200908280817.n7S8H9Ti003478@blc-10-6.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752327AbZH1IRY@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com
List-Id: linux-scsi@vger.kernel.org

From: Jing Huang <huangj@brocade.com>

This patch contains common header files for linux driver,
hardware/firmeare interface, and FC state machines. part-1

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 aen/bfa_aen.h             |  106 +++++++
 aen/bfa_aen_adapter.h     |   31 ++
 aen/bfa_aen_audit.h       |   31 ++
 aen/bfa_aen_ethport.h     |   35 ++
 aen/bfa_aen_ioc.h         |   37 ++
 aen/bfa_aen_itnim.h       |   33 ++
 aen/bfa_aen_lport.h       |   51 +++
 aen/bfa_aen_port.h        |   57 ++++
 aen/bfa_aen_rport.h       |   37 ++
 bfa.h                     |  177 +++++++++++++
 bfa_fcpim.h               |  159 +++++++++++
 bfa_fcptm.h               |   47 +++
 bfa_svc.h                 |  324 ++++++++++++++++++++++++
 bfa_timer.h               |   53 +++
 bfi/bfi.h                 |  174 +++++++++++++
 bfi/bfi_boot.h            |   34 ++
 bfi/bfi_cbreg.h           |  305 ++++++++++++++++++++++
 bfi/bfi_cee.h             |  119 ++++++++
 bfi/bfi_ctreg.h           |  611 ++++++++++++++++++++++++++++++++++++++++++++++
 bfi/bfi_fabric.h          |   92 ++++++
 bfi/bfi_fcpim.h           |  301 ++++++++++++++++++++++
 bfi/bfi_fcxp.h            |   71 +++++
 bfi/bfi_ioc.h             |  202 +++++++++++++++
 bfi/bfi_iocfc.h           |  177 +++++++++++++
 bfi/bfi_lport.h           |   89 ++++++
 bfi/bfi_lps.h             |   96 +++++++
 bfi/bfi_port.h            |  115 ++++++++
 bfi/bfi_pport.h           |  184 +++++++++++++
 bfi/bfi_rport.h           |  104 +++++++
 bfi/bfi_uf.h              |   52 +++
 cna/bfa_cna_trcmod.h      |   36 ++
 cna/cee/bfa_cee.h         |   77 +++++
 cna/port/bfa_port.h       |   69 +++++
 cna/pstats/ethport_defs.h |   36 ++
 cna/pstats/phyport_defs.h |  218 ++++++++++++++++
 cs/bfa_checksum.h         |   60 ++++
 cs/bfa_debug.h            |   44 +++
 37 files changed, 4444 insertions(+)

diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen.h patch/drivers/scsi/bfa/include/aen/bfa_aen.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,106 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+	u32	seq_num;
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
+bfa_aen_get_wi(struct bfa_aen_s *aen)
+{
+	return aen->write_index;
+}
+
+static inline s32
+bfa_aen_get_ri(struct bfa_aen_s *aen)
+{
+	return aen->read_index;
+}
+
+static inline s32
+bfa_aen_fetch_count(struct bfa_aen_s *aen, s32 read_index)
+{
+	return ((aen->write_index + aen->max_entry) - read_index)
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
+		      s32 entry_space, s32 rii, s32 *ri_arr,
+		      s32 ri_arr_cnt);
+
+s32 bfa_aen_get_inst(struct bfa_aen_s *aen);
+
+static inline void
+wwn2str(char *wwn_str, u64 wwn)
+{
+	union {
+		u64 wwn;
+		u8 byte[8];
+	} w;
+
+	w.wwn = wwn;
+	sprintf(wwn_str, "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x", w.byte[0],
+		w.byte[1], w.byte[2], w.byte[3], w.byte[4], w.byte[5],
+		w.byte[6], w.byte[7]);
+}
+
+#endif /* __BFA_AEN_H__ */
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_adapter.h patch/drivers/scsi/bfa/include/aen/bfa_aen_adapter.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_adapter.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_adapter.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,31 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+#define BFA_AEN_ADAPTER_ADD \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_ADAPTER, BFA_ADAPTER_AEN_ADD)
+#define BFA_AEN_ADAPTER_REMOVE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_ADAPTER, BFA_ADAPTER_AEN_REMOVE)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_audit.h patch/drivers/scsi/bfa/include/aen/bfa_aen_audit.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_audit.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_audit.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,31 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+#define BFA_AEN_AUDIT_AUTH_ENABLE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_AUDIT, BFA_AUDIT_AEN_AUTH_ENABLE)
+#define BFA_AEN_AUDIT_AUTH_DISABLE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_AUDIT, BFA_AUDIT_AEN_AUTH_DISABLE)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_ethport.h patch/drivers/scsi/bfa/include/aen/bfa_aen_ethport.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_ethport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_ethport.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,35 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+#define BFA_AEN_ETHPORT_LINKUP \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_ETHPORT, BFA_ETHPORT_AEN_LINKUP)
+#define BFA_AEN_ETHPORT_LINKDOWN \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_ETHPORT, BFA_ETHPORT_AEN_LINKDOWN)
+#define BFA_AEN_ETHPORT_ENABLE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_ETHPORT, BFA_ETHPORT_AEN_ENABLE)
+#define BFA_AEN_ETHPORT_DISABLE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_ETHPORT, BFA_ETHPORT_AEN_DISABLE)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_ioc.h patch/drivers/scsi/bfa/include/aen/bfa_aen_ioc.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_ioc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_ioc.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,37 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+#define BFA_AEN_IOC_HBGOOD \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_IOC, BFA_IOC_AEN_HBGOOD)
+#define BFA_AEN_IOC_HBFAIL \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_IOC, BFA_IOC_AEN_HBFAIL)
+#define BFA_AEN_IOC_ENABLE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_IOC, BFA_IOC_AEN_ENABLE)
+#define BFA_AEN_IOC_DISABLE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_IOC, BFA_IOC_AEN_DISABLE)
+#define BFA_AEN_IOC_FWMISMATCH \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_IOC, BFA_IOC_AEN_FWMISMATCH)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_itnim.h patch/drivers/scsi/bfa/include/aen/bfa_aen_itnim.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_itnim.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_itnim.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,33 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+#define BFA_AEN_ITNIM_ONLINE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_ITNIM, BFA_ITNIM_AEN_ONLINE)
+#define BFA_AEN_ITNIM_OFFLINE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_ITNIM, BFA_ITNIM_AEN_OFFLINE)
+#define BFA_AEN_ITNIM_DISCONNECT \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_ITNIM, BFA_ITNIM_AEN_DISCONNECT)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_lport.h patch/drivers/scsi/bfa/include/aen/bfa_aen_lport.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_lport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_lport.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,51 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+#define BFA_AEN_LPORT_NEW \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_NEW)
+#define BFA_AEN_LPORT_DELETE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_DELETE)
+#define BFA_AEN_LPORT_ONLINE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_ONLINE)
+#define BFA_AEN_LPORT_OFFLINE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_OFFLINE)
+#define BFA_AEN_LPORT_DISCONNECT \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_DISCONNECT)
+#define BFA_AEN_LPORT_NEW_PROP \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_NEW_PROP)
+#define BFA_AEN_LPORT_DELETE_PROP \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_DELETE_PROP)
+#define BFA_AEN_LPORT_NEW_STANDARD \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_NEW_STANDARD)
+#define BFA_AEN_LPORT_DELETE_STANDARD \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_DELETE_STANDARD)
+#define BFA_AEN_LPORT_NPIV_DUP_WWN \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_NPIV_DUP_WWN)
+#define BFA_AEN_LPORT_NPIV_FABRIC_MAX \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_NPIV_FABRIC_MAX)
+#define BFA_AEN_LPORT_NPIV_UNKNOWN \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_NPIV_UNKNOWN)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_port.h patch/drivers/scsi/bfa/include/aen/bfa_aen_port.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_port.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_port.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,57 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+#define BFA_AEN_PORT_ONLINE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_ONLINE)
+#define BFA_AEN_PORT_OFFLINE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_OFFLINE)
+#define BFA_AEN_PORT_RLIR \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_RLIR)
+#define BFA_AEN_PORT_SFP_INSERT \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_SFP_INSERT)
+#define BFA_AEN_PORT_SFP_REMOVE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_SFP_REMOVE)
+#define BFA_AEN_PORT_SFP_POM \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_SFP_POM)
+#define BFA_AEN_PORT_ENABLE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_ENABLE)
+#define BFA_AEN_PORT_DISABLE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_DISABLE)
+#define BFA_AEN_PORT_AUTH_ON \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_AUTH_ON)
+#define BFA_AEN_PORT_AUTH_OFF \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_AUTH_OFF)
+#define BFA_AEN_PORT_DISCONNECT \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_DISCONNECT)
+#define BFA_AEN_PORT_QOS_NEG \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_QOS_NEG)
+#define BFA_AEN_PORT_FABRIC_NAME_CHANGE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_FABRIC_NAME_CHANGE)
+#define BFA_AEN_PORT_SFP_ACCESS_ERROR \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_SFP_ACCESS_ERROR)
+#define BFA_AEN_PORT_SFP_UNSUPPORT \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_SFP_UNSUPPORT)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_rport.h patch/drivers/scsi/bfa/include/aen/bfa_aen_rport.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_rport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_rport.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,37 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+#define BFA_AEN_RPORT_ONLINE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_RPORT, BFA_RPORT_AEN_ONLINE)
+#define BFA_AEN_RPORT_OFFLINE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_RPORT, BFA_RPORT_AEN_OFFLINE)
+#define BFA_AEN_RPORT_DISCONNECT \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_RPORT, BFA_RPORT_AEN_DISCONNECT)
+#define BFA_AEN_RPORT_QOS_PRIO \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_RPORT, BFA_RPORT_AEN_QOS_PRIO)
+#define BFA_AEN_RPORT_QOS_FLOWID \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_RPORT, BFA_RPORT_AEN_QOS_FLOWID)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/bfa.h patch/drivers/scsi/bfa/include/bfa.h
--- orig/drivers/scsi/bfa/include/bfa.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfa.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,177 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+void bfa_attach_fcs(struct bfa_s *bfa);
+void bfa_cb_init(void *bfad, bfa_status_t status);
+void bfa_cb_stop(void *bfad, bfa_status_t status);
+void bfa_cb_updateq(void *bfad, bfa_status_t status);
+
+bfa_boolean_t bfa_intx(struct bfa_s *bfa);
+void bfa_isr_enable(struct bfa_s *bfa);
+void bfa_isr_disable(struct bfa_s *bfa);
+void bfa_msix_getvecs(struct bfa_s *bfa, u32 *msix_vecs_bmap,
+			u32 *num_vecs, u32 *max_vec_bit);
+#define bfa_msix(__bfa, __vec) (__bfa)->msix.handler[__vec](__bfa, __vec)
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
+void bfa_iocfc_enable(struct bfa_s *bfa);
+void bfa_iocfc_disable(struct bfa_s *bfa);
+void bfa_ioc_auto_recover(bfa_boolean_t auto_recover);
+void bfa_cb_ioc_disable(void *bfad);
+void bfa_timer_tick(struct bfa_s *bfa);
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
+++ patch/drivers/scsi/bfa/include/bfa_fcpim.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,159 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+#ifndef __BFA_FCPIM_H__
+#define __BFA_FCPIM_H__
+
+#include <bfa.h>
+#include <bfa_svc.h>
+#include <bfi/bfi_fcpim.h>
+#include <defs/bfa_defs_fcpim.h>
+
+/*
+ * forward declarations
+ */
+struct bfa_itnim_s;
+struct bfa_ioim_s;
+struct bfa_tskim_s;
+struct bfad_ioim_s;
+struct bfad_tskim_s;
+
+/*
+ * bfa fcpim module API functions
+ */
+void		bfa_fcpim_path_tov_set(struct bfa_s *bfa, u16 path_tov);
+u16	bfa_fcpim_path_tov_get(struct bfa_s *bfa);
+void		bfa_fcpim_qdepth_set(struct bfa_s *bfa, u16 q_depth);
+u16	bfa_fcpim_qdepth_get(struct bfa_s *bfa);
+bfa_status_t bfa_fcpim_get_modstats(struct bfa_s *bfa,
+			struct bfa_fcpim_stats_s *modstats);
+bfa_status_t bfa_fcpim_clr_modstats(struct bfa_s *bfa);
+
+/*
+ * bfa itnim API functions
+ */
+struct bfa_itnim_s *bfa_itnim_create(struct bfa_s *bfa,
+					struct bfa_rport_s *rport, void *itnim);
+void		bfa_itnim_delete(struct bfa_itnim_s *itnim);
+void		bfa_itnim_online(struct bfa_itnim_s *itnim,
+				 bfa_boolean_t seq_rec);
+void		bfa_itnim_offline(struct bfa_itnim_s *itnim);
+void		bfa_itnim_get_stats(struct bfa_itnim_s *itnim,
+			struct bfa_itnim_hal_stats_s *stats);
+void		bfa_itnim_clear_stats(struct bfa_itnim_s *itnim);
+
+
+/**
+ * 		BFA completion callback for bfa_itnim_online().
+ *
+ * @param[in]		itnim		FCS or driver itnim instance
+ *
+ * return None
+ */
+void            bfa_cb_itnim_online(void *itnim);
+
+/**
+ * 		BFA completion callback for bfa_itnim_offline().
+ *
+ * @param[in]		itnim		FCS or driver itnim instance
+ *
+ * return None
+ */
+void            bfa_cb_itnim_offline(void *itnim);
+void            bfa_cb_itnim_tov_begin(void *itnim);
+void            bfa_cb_itnim_tov(void *itnim);
+
+/**
+ * 		BFA notification to FCS/driver for second level error recovery.
+ *
+ * Atleast one I/O request has timedout and target is unresponsive to
+ * repeated abort requests. Second level error recovery should be initiated
+ * by starting implicit logout and recovery procedures.
+ *
+ * @param[in]		itnim		FCS or driver itnim instance
+ *
+ * return None
+ */
+void            bfa_cb_itnim_sler(void *itnim);
+
+/*
+ * bfa ioim API functions
+ */
+struct bfa_ioim_s	*bfa_ioim_alloc(struct bfa_s *bfa,
+					struct bfad_ioim_s *dio,
+					struct bfa_itnim_s *itnim,
+					u16 nsgles);
+
+void		bfa_ioim_free(struct bfa_ioim_s *ioim);
+void		bfa_ioim_start(struct bfa_ioim_s *ioim);
+void		bfa_ioim_abort(struct bfa_ioim_s *ioim);
+void 		bfa_ioim_delayed_comp(struct bfa_ioim_s *ioim,
+				      bfa_boolean_t iotov);
+
+
+/**
+ * 		I/O completion notification.
+ *
+ * @param[in]		dio			driver IO structure
+ * @param[in]		io_status		IO completion status
+ * @param[in]		scsi_status		SCSI status returned by target
+ * @param[in]		sns_len			SCSI sense length, 0 if none
+ * @param[in]		sns_info		SCSI sense data, if any
+ * @param[in]		residue			Residual length
+ *
+ * @return None
+ */
+void            bfa_cb_ioim_done(void *bfad, struct bfad_ioim_s *dio,
+				  enum bfi_ioim_status io_status,
+				  u8 scsi_status, int sns_len,
+				  u8 *sns_info, s32 residue);
+
+/**
+ * 		I/O good completion notification.
+ *
+ * @param[in]		dio			driver IO structure
+ *
+ * @return None
+ */
+void            bfa_cb_ioim_good_comp(void *bfad, struct bfad_ioim_s *dio);
+
+/**
+ * 		I/O abort completion notification
+ *
+ * @param[in]		dio			driver IO that was aborted
+ *
+ * @return None
+ */
+void            bfa_cb_ioim_abort(void *bfad, struct bfad_ioim_s *dio);
+void		bfa_cb_ioim_resfree(void *hcb_bfad);
+
+void 			bfa_cb_ioim_resfree(void *hcb_bfad);
+
+/*
+ * bfa tskim API functions
+ */
+struct bfa_tskim_s	*bfa_tskim_alloc(struct bfa_s *bfa,
+					struct bfad_tskim_s *dtsk);
+void		bfa_tskim_free(struct bfa_tskim_s *tskim);
+void		bfa_tskim_start(struct bfa_tskim_s *tskim,
+				struct bfa_itnim_s *itnim, lun_t lun,
+				enum fcp_tm_cmnd tm, u8 t_secs);
+void		bfa_cb_tskim_done(void *bfad, struct bfad_tskim_s *dtsk,
+				  enum bfi_tskim_status tsk_status);
+
+#endif /* __BFA_FCPIM_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfa_fcptm.h patch/drivers/scsi/bfa/include/bfa_fcptm.h
--- orig/drivers/scsi/bfa/include/bfa_fcptm.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfa_fcptm.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,47 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+#ifndef __BFA_FCPTM_H__
+#define __BFA_FCPTM_H__
+
+#include <bfa.h>
+#include <bfa_svc.h>
+#include <bfi/bfi_fcptm.h>
+
+/*
+ * forward declarations
+ */
+struct bfa_tin_s;
+struct bfa_iotm_s;
+struct bfa_tsktm_s;
+
+/*
+ * bfa fcptm module API functions
+ */
+void bfa_fcptm_path_tov_set(struct bfa_s *bfa, u16 path_tov);
+u16 bfa_fcptm_path_tov_get(struct bfa_s *bfa);
+void bfa_fcptm_qdepth_set(struct bfa_s *bfa, u16 q_depth);
+u16 bfa_fcptm_qdepth_get(struct bfa_s *bfa);
+
+/*
+ * bfa tin API functions
+ */
+void bfa_tin_get_stats(struct bfa_tin_s *tin, struct bfa_tin_stats_s *stats);
+void bfa_tin_clear_stats(struct bfa_tin_s *tin);
+
+#endif /* __BFA_FCPTM_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfa_svc.h patch/drivers/scsi/bfa/include/bfa_svc.h
--- orig/drivers/scsi/bfa/include/bfa_svc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfa_svc.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,324 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+ * 		BFA rport information.
+ */
+struct bfa_rport_info_s {
+	u16        max_frmsz;	/*  max rcv pdu size               */
+	u32        pid : 24,	/*  remote port ID                 */
+			lp_tag : 8;
+	u32        local_pid : 24,	/*  local port ID		    */
+			cisc : 8;	/*  CIRO supported		    */
+	u8         fc_class;	/*  supported FC classes. enum fc_cos */
+	u8         vf_en;		/*  virtual fabric enable          */
+	u16        vf_id;		/*  virtual fabric ID              */
+	enum bfa_pport_speed speed;	/*  Rport's current speed	    */
+};
+
+/**
+ * BFA rport data structure
+ */
+struct bfa_rport_s {
+	struct list_head        qe;	  /*  queue element */
+	bfa_sm_t	      sm; 	  /*  state machine */
+	struct bfa_s          *bfa;	  /*  backpointer to BFA */
+	void                  *rport_drv; /*  fcs/driver rport object */
+	u16              fw_handle; /*  firmware rport handle */
+	u16              rport_tag; /*  BFA rport tag */
+	struct bfa_rport_info_s rport_info; /*  rport info from *fcs/driver */
+	struct bfa_reqq_wait_s reqq_wait; /*  to wait for room in reqq */
+	struct bfa_cb_qe_s    hcb_qe;	 /*  BFA callback qelem */
+	struct bfa_rport_hal_stats_s stats; /*  BFA rport statistics  */
+	struct bfa_rport_qos_attr_s  qos_attr;
+	union a {
+		bfa_status_t    status;	 /*  f/w status */
+		void            *fw_msg; /*  QoS scn event */
+	} event_arg;
+};
+#define BFA_RPORT_FC_COS(_rport)	((_rport)->rport_info.fc_class)
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
+	struct list_head	qe;		/*  queue element	  */
+	struct bfa_s	*bfa;		/*  bfa instance	  */
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
+	struct list_head	qe;		/*  queue element */
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
+	mac_t		lp_mac;		/*  fpma/spma MAC for lport	*/
+	mac_t		fcf_mac;	/*  FCF MAC of lport		*/
+	struct bfa_reqq_wait_s	wqe;	/*  request wait queue element	*/
+	void		*uarg;		/*  user callback arg		*/
+	struct bfa_cb_qe_s hcb_qe;	/*  comp: callback qelem	*/
+	struct bfi_lps_login_rsp_s *loginrsp;
+	bfa_eproto_status_t	ext_status;
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
+			union bfa_pport_stats_u *stats,
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
+			union bfa_pport_stats_u *stats,
+			bfa_cb_pport_t cbfn, void *cbarg);
+bfa_status_t bfa_pport_clear_qos_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn,
+			void *cbarg);
+bfa_boolean_t     bfa_pport_is_ratelim(struct bfa_s *bfa);
+bfa_boolean_t	bfa_pport_is_linkup(struct bfa_s *bfa);
+
+/*
+ * bfa rport API functions
+ */
+struct bfa_rport_s *bfa_rport_create(struct bfa_s *bfa, void *rport_drv);
+void bfa_rport_delete(struct bfa_rport_s *rport);
+void bfa_rport_online(struct bfa_rport_s *rport,
+			struct bfa_rport_info_s *rport_info);
+void bfa_rport_offline(struct bfa_rport_s *rport);
+void bfa_rport_speed(struct bfa_rport_s *rport, enum bfa_pport_speed speed);
+void bfa_rport_get_stats(struct bfa_rport_s *rport,
+			struct bfa_rport_hal_stats_s *stats);
+void bfa_rport_clear_stats(struct bfa_rport_s *rport);
+void bfa_cb_rport_online(void *rport);
+void bfa_cb_rport_offline(void *rport);
+void bfa_cb_rport_qos_scn_flowid(void *rport,
+			struct bfa_rport_qos_attr_s old_qos_attr,
+			struct bfa_rport_qos_attr_s new_qos_attr);
+void bfa_cb_rport_qos_scn_prio(void *rport,
+			struct bfa_rport_qos_attr_s old_qos_attr,
+			struct bfa_rport_qos_attr_s new_qos_attr);
+void bfa_rport_get_qos_attr(struct bfa_rport_s *rport,
+			struct bfa_rport_qos_attr_s *qos_attr);
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
+
+void bfa_fcxp_send(struct bfa_fcxp_s *fcxp,
+			struct bfa_rport_s *rport, u16 vf_id, u8 lp_tag,
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
+bfa_eproto_status_t bfa_lps_get_extstatus(struct bfa_lps_s *lps);
+u32 bfa_lps_get_pid(struct bfa_lps_s *lps);
+u8 bfa_lps_get_tag_from_pid(struct bfa_s *bfa, u32 pid);
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
+++ patch/drivers/scsi/bfa/include/bfa_timer.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,53 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+++ patch/drivers/scsi/bfa/include/bfi/bfi.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,174 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+	BFI_MC_PORT		= 21,	/*  Physical port		    */
+	BFI_MC_MAX		= 32
+};
+
+#define BFI_IOC_MAX_CQS		4
+#define BFI_IOC_MAX_CQS_ASIC	8
+#define BFI_IOC_MSGLEN_MAX	32	/* 32 bytes */
+
+#pragma pack()
+
+#endif /* __BFI_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_boot.h patch/drivers/scsi/bfa/include/bfi/bfi_boot.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_boot.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_boot.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,34 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+++ patch/drivers/scsi/bfa/include/bfi/bfi_cbreg.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,305 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+#define BFA_FW_USE_COUNT                 HOST_SEM4_INFO_REG
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
+    BFA_MSIX_CPE_Q0 = 0,
+    BFA_MSIX_CPE_Q1 = 1,
+    BFA_MSIX_CPE_Q2 = 2,
+    BFA_MSIX_CPE_Q3 = 3,
+    BFA_MSIX_CPE_Q4 = 4,
+    BFA_MSIX_CPE_Q5 = 5,
+    BFA_MSIX_CPE_Q6 = 6,
+    BFA_MSIX_CPE_Q7 = 7,
+    BFA_MSIX_RME_Q0 = 8,
+    BFA_MSIX_RME_Q1 = 9,
+    BFA_MSIX_RME_Q2 = 10,
+    BFA_MSIX_RME_Q3 = 11,
+    BFA_MSIX_RME_Q4 = 12,
+    BFA_MSIX_RME_Q5 = 13,
+    BFA_MSIX_RME_Q6 = 14,
+    BFA_MSIX_RME_Q7 = 15,
+    BFA_MSIX_ERR_EMC = 16,
+    BFA_MSIX_ERR_LPU0 = 17,
+    BFA_MSIX_ERR_LPU1 = 18,
+    BFA_MSIX_ERR_PSS = 19,
+    BFA_MSIX_MBOX_LPU0 = 20,
+    BFA_MSIX_MBOX_LPU1 = 21,
+    BFA_MSIX_CB_MAX = 22,
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
+#define __HFN_INT_MBOX1_LPU0               0x00400000U
+#define __HFN_INT_MBOX1_LPU1               0x00800000U
+#define __HFN_INT_CPE_MASK                 0x000000ffU
+#define __HFN_INT_RME_MASK                 0x0000ff00U
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
+++ patch/drivers/scsi/bfa/include/bfi/bfi_cee.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,119 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+++ patch/drivers/scsi/bfa/include/bfi/bfi_ctreg.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,611 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+enum {
+    __F0_INTX_STATUS_MSIX            = 0x0,
+    __F0_INTX_STATUS_INTA            = 0x1,
+    __F0_INTX_STATUS_INTB            = 0x2,
+    __F0_INTX_STATUS_INTC            = 0x3,
+    __F0_INTX_STATUS_INTD            = 0x4,
+};
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
+#define FW_INIT_HALT_P0                  0x000191ac
+#define __FW_INIT_HALT_P                 0x00000001
+#define FW_INIT_HALT_P1                  0x000191bc
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
+#define BFA_FW_USE_COUNT                 HOST_SEM4_INFO_REG
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
+	(HQM_QSET0_RXQ_DRBL_P0 + (__n) * (HQM_QSET1_RXQ_DRBL_P0 - \
+	HQM_QSET0_RXQ_DRBL_P0))
+#define HQM_QSET_TXQ_DRBL_P0(__n) \
+	(HQM_QSET0_TXQ_DRBL_P0 + (__n) * (HQM_QSET1_TXQ_DRBL_P0 - \
+	HQM_QSET0_TXQ_DRBL_P0))
+#define HQM_QSET_IB_DRBL_1_P0(__n) \
+	(HQM_QSET0_IB_DRBL_1_P0 + (__n) * (HQM_QSET1_IB_DRBL_1_P0 - \
+	HQM_QSET0_IB_DRBL_1_P0))
+#define HQM_QSET_IB_DRBL_2_P0(__n) \
+	(HQM_QSET0_IB_DRBL_2_P0 + (__n) * (HQM_QSET1_IB_DRBL_2_P0 - \
+	HQM_QSET0_IB_DRBL_2_P0))
+#define HQM_QSET_RXQ_DRBL_P1(__n) \
+	(HQM_QSET0_RXQ_DRBL_P1 + (__n) * (HQM_QSET1_RXQ_DRBL_P1 - \
+	HQM_QSET0_RXQ_DRBL_P1))
+#define HQM_QSET_TXQ_DRBL_P1(__n) \
+	(HQM_QSET0_TXQ_DRBL_P1 + (__n) * (HQM_QSET1_TXQ_DRBL_P1 - \
+	HQM_QSET0_TXQ_DRBL_P1))
+#define HQM_QSET_IB_DRBL_1_P1(__n) \
+	(HQM_QSET0_IB_DRBL_1_P1 + (__n) * (HQM_QSET1_IB_DRBL_1_P1 - \
+	HQM_QSET0_IB_DRBL_1_P1))
+#define HQM_QSET_IB_DRBL_2_P1(__n) \
+	(HQM_QSET0_IB_DRBL_2_P1 + (__n) * (HQM_QSET1_IB_DRBL_2_P1 - \
+	HQM_QSET0_IB_DRBL_2_P1))
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
+    BFA_MSIX_CPE_Q0 = 0,
+    BFA_MSIX_CPE_Q1 = 1,
+    BFA_MSIX_CPE_Q2 = 2,
+    BFA_MSIX_CPE_Q3 = 3,
+    BFA_MSIX_RME_Q0 = 4,
+    BFA_MSIX_RME_Q1 = 5,
+    BFA_MSIX_RME_Q2 = 6,
+    BFA_MSIX_RME_Q3 = 7,
+    BFA_MSIX_LPU_ERR = 8,
+    BFA_MSIX_CT_MAX = 9,
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
+#define __HFN_INT_MBOX1_LPU0               0x00400000U
+#define __HFN_INT_MBOX1_LPU1               0x00800000U
+#define __HFN_INT_CPE_MASK                 0x000000ffU
+#define __HFN_INT_RME_MASK                 0x0000ff00U
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
+++ patch/drivers/scsi/bfa/include/bfi/bfi_fabric.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,92 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+	BFI_FABRIC_H2I_CREATE_REQ	= 1,
+	BFI_FABRIC_H2I_DELETE_REQ	= 2,
+	BFI_FABRIC_H2I_SETAUTH		= 3,
+};
+
+enum bfi_fabric_i2h_msgs {
+	BFI_FABRIC_I2H_CREATE_RSP	= BFA_I2HM(1),
+	BFI_FABRIC_I2H_DELETE_RSP	= BFA_I2HM(2),
+	BFI_FABRIC_I2H_SETAUTH_RSP	= BFA_I2HM(3),
+	BFI_FABRIC_I2H_ONLINE		= BFA_I2HM(4),
+	BFI_FABRIC_I2H_OFFLINE		= BFA_I2HM(5),
+};
+
+struct bfi_fabric_create_req_s {
+	bfi_mhdr_t	mh;		/*  common msg header		*/
+	u8         vf_en;		/*  virtual fabric enable	*/
+	u8         rsvd;
+	u16        vf_id;		/*  virtual fabric ID		*/
+	wwn_t		pwwn;		/*  port name			*/
+	wwn_t		nwwn;		/*  node name			*/
+};
+
+struct bfi_fabric_create_rsp_s {
+	bfi_mhdr_t	mh;		/*  common msg header		*/
+	u16        bfa_handle;	/*  host fabric handle		*/
+	u8         status;		/*  fabric create status	*/
+	u8         rsvd;
+};
+
+struct bfi_fabric_delete_req_s {
+	bfi_mhdr_t	mh;		/*  common msg header		*/
+	u16        fw_handle;	/*  firmware fabric handle	*/
+	u16        rsvd;
+};
+
+struct bfi_fabric_delete_rsp_s {
+	bfi_mhdr_t	mh;		/*  common msg header		*/
+	u16        bfa_handle;	/*  host fabric handle		*/
+	u8         status;		/*  fabric deletion status	*/
+	u8         rsvd;
+};
+
+#define BFI_FABRIC_AUTHSECRET_LEN	64
+struct bfi_fabric_setauth_req_s {
+	bfi_mhdr_t	mh;		/*  common msg header		*/
+	u16        fw_handle;	/*  f/w handle of fabric	*/
+	u8		algorithm;
+	u8		group;
+	u8		secret[BFI_FABRIC_AUTHSECRET_LEN];
+};
+
+union bfi_fabric_h2i_msg_u {
+	bfi_msg_t		*msg;
+	struct bfi_fabric_create_req_s	*create_req;
+	struct bfi_fabric_delete_req_s	*delete_req;
+};
+
+union bfi_fabric_i2h_msg_u {
+	bfi_msg_t		*msg;
+	struct bfi_fabric_create_rsp_s	*create_rsp;
+	struct bfi_fabric_delete_rsp_s	*delete_rsp;
+};
+
+#pragma pack()
+
+#endif /* __BFI_FABRIC_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_fcpim.h patch/drivers/scsi/bfa/include/bfi/bfi_fcpim.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_fcpim.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_fcpim.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,301 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+#include <protocol/fcp.h>
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
+};
+
+enum bfi_itnim_i2h {
+	BFI_ITNIM_I2H_CREATE_RSP = BFA_I2HM(1),
+	BFI_ITNIM_I2H_DELETE_RSP = BFA_I2HM(2),
+	BFI_ITNIM_I2H_SLER_EVENT = BFA_I2HM(3),
+};
+
+struct bfi_itnim_create_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		 */
+	u16        fw_handle;	/*  f/w handle for itnim	 */
+	u8         class;		/*  FC class for IO		 */
+	u8         seq_rec;	/*  sequence recovery support	 */
+	u8         msg_no;		/*  seq id of the msg		 */
+};
+
+struct bfi_itnim_create_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		 */
+	u16        bfa_handle;	/*  bfa handle for itnim	 */
+	u8         status;		/*  fcp request status		 */
+	u8         seq_id;		/*  seq id of the msg		 */
+};
+
+struct bfi_itnim_delete_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		 */
+	u16        fw_handle;	/*  f/w itnim handle		 */
+	u8         seq_id;		/*  seq id of the msg		 */
+	u8         rsvd;
+};
+
+struct bfi_itnim_delete_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		 */
+	u16        bfa_handle;	/*  bfa handle for itnim	 */
+	u8         status;		/*  fcp request status		 */
+	u8         seq_id;		/*  seq id of the msg		 */
+};
+
+struct bfi_itnim_sler_event_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		 */
+	u16        bfa_handle;	/*  bfa handle for itnim	 */
+	u16        rsvd;
+};
+
+union bfi_itnim_h2i_msg_u {
+	struct bfi_itnim_create_req_s *create_req;
+	struct bfi_itnim_delete_req_s *delete_req;
+	struct bfi_msg_s      *msg;
+};
+
+union bfi_itnim_i2h_msg_u {
+	struct bfi_itnim_create_rsp_s *create_rsp;
+	struct bfi_itnim_delete_rsp_s *delete_rsp;
+	struct bfi_itnim_sler_event_s *sler_event;
+	struct bfi_msg_s      *msg;
+};
+
+/*
+ * Initiator mode IO interface defines.
+ */
+
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
+	struct fcp_cmnd_s cmnd;		/*  IO request info		 */
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
+#define BFI_IOIM_SNSLEN	(256)
+/**
+ * I/O response message
+ */
+struct bfi_ioim_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header	 	 */
+	u16        io_tag;		/*  completed IO tag		 */
+	u16        bfa_rport_hndl;	/*  releated rport handle	 */
+	u8         io_status;	/*  IO completion status	 */
+	u8         reuse_io_tag;	/*  IO tag can be reused        */
+	u16	abort_tag;	/*  host abort request tag      */
+	u8		scsi_status;	/*  scsi status from target	 */
+	u8		sns_len;	/*  scsi sense length		 */
+	u8		resid_flags;	/*  IO residue flags		 */
+	u8		rsvd_a;
+	u32	residue;	/*  IO residual length in bytes */
+	u32	rsvd_b[3];
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
+++ patch/drivers/scsi/bfa/include/bfi/bfi_fcxp.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,71 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+	u8         lp_tag;		/*  lport tag			    */
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
+++ patch/drivers/scsi/bfa/include/bfi/bfi_ioc.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,202 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+	BFI_IOC_I2H_HBEAT		= BFA_I2HM(5),
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
+	mac_t		mfg_mac;
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
+#define BFI_IOC_TRC_ENTS	256
+
+#define BFI_IOC_FW_SIGNATURE	(0xbfadbfad)
+#define BFI_IOC_MD5SUM_SZ	4
+struct bfi_ioc_image_hdr_s {
+	u32        signature;	/*  constant signature */
+	u32        rsvd_a;
+	u32        exec;		/*  exec vector        */
+	u32        param;		/*  parameters         */
+	u32        rsvd_b[4];
+	u32        md5sum[BFI_IOC_MD5SUM_SZ];
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
+struct bfi_ioc_hbeat_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u32	   hb_count;	/*  current heart beat count	*/
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
+++ patch/drivers/scsi/bfa/include/bfi/bfi_iocfc.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,177 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+#include <defs/bfa_defs_boot.h>
+
+#pragma pack(1)
+
+enum bfi_iocfc_h2i_msgs {
+	BFI_IOCFC_H2I_CFG_REQ 		= 1,
+	BFI_IOCFC_H2I_GET_STATS_REQ 	= 2,
+	BFI_IOCFC_H2I_CLEAR_STATS_REQ	= 3,
+	BFI_IOCFC_H2I_SET_INTR_REQ 	= 4,
+	BFI_IOCFC_H2I_UPDATEQ_REQ = 5,
+};
+
+enum bfi_iocfc_i2h_msgs {
+	BFI_IOCFC_I2H_CFG_REPLY		= BFA_I2HM(1),
+	BFI_IOCFC_I2H_GET_STATS_RSP 	= BFA_I2HM(2),
+	BFI_IOCFC_I2H_CLEAR_STATS_RSP	= BFA_I2HM(3),
+	BFI_IOCFC_I2H_UPDATEQ_RSP = BFA_I2HM(5),
+};
+
+struct bfi_iocfc_cfg_s {
+	u8         num_cqs; 	/*  Number of CQs to be used     */
+	u8         sense_buf_len;	/*  SCSI sense length            */
+	u8         trunk_enabled;	/*  port trunking enabled        */
+	u8         trunk_ports;	/*  trunk ports bit map          */
+	u32        endian_sig;	/*  endian signature of host     */
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
+/**
+ * Boot target wwn information for this port. This contains either the stored
+ * or discovered boot target port wwns for the port.
+ */
+struct bfi_iocfc_bootwwns {
+	wwn_t		wwn[BFA_BOOT_BOOTLUN_MAX];
+	u8		nwwns;
+	u8		rsvd[7];
+};
+
+struct bfi_iocfc_cfgrsp_s {
+	struct bfa_iocfc_fwcfg_s	fwcfg;
+	struct bfa_iocfc_intr_attr_s	intr_attr;
+	struct bfi_iocfc_bootwwns	bootwwns;
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
+ * BFI_IOCFC_H2I_UPDATEQ_REQ message
+ */
+struct bfi_iocfc_updateq_req_s {
+	struct bfi_mhdr_s mh;		/*  common msg header     */
+	u32 reqq_ba;			/*  reqq base addr        */
+	u32 rspq_ba;			/*  rspq base addr        */
+	u32 reqq_sci;			/*  reqq shadow ci        */
+	u32 rspq_spi;			/*  rspq shadow pi        */
+};
+
+/**
+ * BFI_IOCFC_I2H_UPDATEQ_RSP message
+ */
+struct bfi_iocfc_updateq_rsp_s {
+	struct bfi_mhdr_s mh;		/*  common msg header     */
+	u8         status;		/*  updateq  status       */
+	u8         rsvd[3];
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
+	struct bfi_iocfc_updateq_req_s updateq_req;
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
+	struct bfi_iocfc_updateq_rsp_s updateq_rsp;
+	u32       			mboxmsg[BFI_IOC_MSGSZ];
+};
+
+#pragma pack()
+
+#endif /* __BFI_IOCFC_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_lport.h patch/drivers/scsi/bfa/include/bfi/bfi_lport.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_lport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_lport.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,89 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+#include <bfi/bfi.h>
+
+#pragma pack(1)
+
+enum bfi_lport_h2i_msgs {
+	BFI_LPORT_H2I_CREATE_REQ = 1,
+	BFI_LPORT_H2I_DELETE_REQ = 2,
+};
+
+enum bfi_lport_i2h_msgs {
+	BFI_LPORT_I2H_CREATE_RSP = BFA_I2HM(1),
+	BFI_LPORT_I2H_DELETE_RSP = BFA_I2HM(2),
+	BFI_LPORT_I2H_ONLINE	  = BFA_I2HM(3),
+	BFI_LPORT_I2H_OFFLINE	  = BFA_I2HM(4),
+};
+
+#define BFI_LPORT_MAX_SYNNAME	64
+
+enum bfi_lport_role_e {
+	BFI_LPORT_ROLE_FCPIM	= 1,
+	BFI_LPORT_ROLE_FCPTM	= 2,
+	BFI_LPORT_ROLE_IPFC	= 4,
+};
+
+struct bfi_lport_create_req_s {
+	bfi_mhdr_t	mh;		/*  common msg header		*/
+	u16	fabric_fwhdl;	/*  parent fabric instance	*/
+	u8		roles;		/*  lport FC-4 roles		*/
+	u8		rsvd;
+	wwn_t		pwwn;		/*  port name			*/
+	wwn_t		nwwn;		/*  node name			*/
+	u8		symname[BFI_LPORT_MAX_SYNNAME];
+};
+
+struct bfi_lport_create_rsp_s {
+	bfi_mhdr_t	mh;		/*  common msg header		*/
+	u8         status;		/*  lport creation status	*/
+	u8         rsvd[3];
+};
+
+struct bfi_lport_delete_req_s {
+	bfi_mhdr_t	mh;		/*  common msg header		*/
+	u16        fw_handle;	/*  firmware lport handle	*/
+	u16        rsvd;
+};
+
+struct bfi_lport_delete_rsp_s {
+	bfi_mhdr_t	mh;		/*  common msg header		*/
+	u16        bfa_handle;	/*  host lport handle		*/
+	u8         status;		/*  lport deletion status	*/
+	u8         rsvd;
+};
+
+union bfi_lport_h2i_msg_u {
+	bfi_msg_t		*msg;
+	struct bfi_lport_create_req_s	*create_req;
+	struct bfi_lport_delete_req_s	*delete_req;
+};
+
+union bfi_lport_i2h_msg_u {
+	bfi_msg_t		*msg;
+	struct bfi_lport_create_rsp_s	*create_rsp;
+	struct bfi_lport_delete_rsp_s	*delete_rsp;
+};
+
+#pragma pack()
+
+#endif /* __BFI_LPORT_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_lps.h patch/drivers/scsi/bfa/include/bfi/bfi_lps.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_lps.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_lps.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,96 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+	wwn_t		port_name;
+	wwn_t		node_name;
+	u16	bb_credit;
+	u8		f_port;
+	u8		npiv_en;
+	u32	lp_pid : 24;
+	u32	auth_req : 8;
+	mac_t		lp_mac;
+	mac_t		fcf_mac;
+	u8		ext_status;
+	u8  	brcd_switch;/*  attached peer is brcd switch	*/
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
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_port.h patch/drivers/scsi/bfa/include/bfi/bfi_port.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_port.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_port.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,115 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+#ifndef __BFI_PORT_H__
+#define __BFI_PORT_H__
+
+#include <bfi/bfi.h>
+#include <defs/bfa_defs_pport.h>
+
+#pragma pack(1)
+
+enum bfi_port_h2i {
+	BFI_PORT_H2I_ENABLE_REQ		= (1),
+	BFI_PORT_H2I_DISABLE_REQ	= (2),
+	BFI_PORT_H2I_GET_STATS_REQ	= (3),
+	BFI_PORT_H2I_CLEAR_STATS_REQ	= (4),
+};
+
+enum bfi_port_i2h {
+	BFI_PORT_I2H_ENABLE_RSP		= BFA_I2HM(1),
+	BFI_PORT_I2H_DISABLE_RSP	= BFA_I2HM(2),
+	BFI_PORT_I2H_GET_STATS_RSP	= BFA_I2HM(3),
+	BFI_PORT_I2H_CLEAR_STATS_RSP	= BFA_I2HM(4),
+};
+
+/**
+ * Generic REQ type
+ */
+struct bfi_port_generic_req_s {
+	struct bfi_mhdr_s  mh;		/*  msg header			    */
+	u32        msgtag;		/*  msgtag for reply		    */
+	u32	rsvd;
+};
+
+/**
+ * Generic RSP type
+ */
+struct bfi_port_generic_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		    */
+	u8         status;		/*  port enable status		    */
+	u8         rsvd[3];
+	u32        msgtag;		/*  msgtag for reply		    */
+};
+
+/**
+ * @todo
+ * BFI_PORT_H2I_ENABLE_REQ
+ */
+
+/**
+ * @todo
+ * BFI_PORT_I2H_ENABLE_RSP
+ */
+
+/**
+ * BFI_PORT_H2I_DISABLE_REQ
+ */
+
+/**
+ * BFI_PORT_I2H_DISABLE_RSP
+ */
+
+/**
+ * BFI_PORT_H2I_GET_STATS_REQ
+ */
+struct bfi_port_get_stats_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		    */
+	union bfi_addr_u   dma_addr;
+};
+
+/**
+ * BFI_PORT_I2H_GET_STATS_RSP
+ */
+
+/**
+ * BFI_PORT_H2I_CLEAR_STATS_REQ
+ */
+
+/**
+ * BFI_PORT_I2H_CLEAR_STATS_RSP
+ */
+
+union bfi_port_h2i_msg_u {
+	struct bfi_mhdr_s		mh;
+	struct bfi_port_generic_req_s	enable_req;
+	struct bfi_port_generic_req_s	disable_req;
+	struct bfi_port_get_stats_req_s	getstats_req;
+	struct bfi_port_generic_req_s	clearstats_req;
+};
+
+union bfi_port_i2h_msg_u {
+	struct bfi_mhdr_s         	mh;
+	struct bfi_port_generic_rsp_s	enable_rsp;
+	struct bfi_port_generic_rsp_s	disable_rsp;
+	struct bfi_port_generic_rsp_s	getstats_rsp;
+	struct bfi_port_generic_rsp_s	clearstats_rsp;
+};
+
+#pragma pack()
+
+#endif /* __BFI_PORT_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_pport.h patch/drivers/scsi/bfa/include/bfi/bfi_pport.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_pport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_pport.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,184 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+++ patch/drivers/scsi/bfa/include/bfi/bfi_rport.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,104 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+};
+
+enum bfi_rport_i2h_msgs {
+	BFI_RPORT_I2H_CREATE_RSP = BFA_I2HM(1),
+	BFI_RPORT_I2H_DELETE_RSP = BFA_I2HM(2),
+	BFI_RPORT_I2H_QOS_SCN    = BFA_I2HM(3),
+};
+
+struct bfi_rport_create_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u16        bfa_handle;	/*  host rport handle		*/
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
+	u8         rsvd[3];
+	u16        bfa_handle;	/*  host rport handle		*/
+	u16        fw_handle;	/*  firmware rport handle	*/
+	struct bfa_rport_qos_attr_s qos_attr;  /* QoS Attributes */
+};
+
+struct bfa_rport_speed_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u16        fw_handle;	/*  firmware rport handle	*/
+	u8		speed;		/*! rport's speed via RPSC  */
+	u8		rsvd;
+};
+
+struct bfi_rport_delete_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u16        fw_handle;	/*  firmware rport handle	*/
+	u16        rsvd;
+};
+
+struct bfi_rport_delete_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u16        bfa_handle;	/*  host rport handle		*/
+	u8         status;		/*  rport deletion status	*/
+	u8         rsvd;
+};
+
+struct bfi_rport_qos_scn_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u16        bfa_handle;	/*  host rport handle		*/
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
+};
+
+union bfi_rport_i2h_msg_u {
+	struct bfi_msg_s 		*msg;
+	struct bfi_rport_create_rsp_s	*create_rsp;
+	struct bfi_rport_delete_rsp_s	*delete_rsp;
+	struct bfi_rport_qos_scn_s	*qos_scn_evt;
+};
+
+#pragma pack()
+
+#endif /* __BFI_RPORT_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_uf.h patch/drivers/scsi/bfa/include/bfi/bfi_uf.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_uf.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_uf.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,52 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
diff -urpN orig/drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h patch/drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h
--- orig/drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,36 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+ *  bfa_cna_trcmod.h CNA trace modules
+ */
+
+#ifndef __BFA_CNA_TRCMOD_H__
+#define __BFA_CNA_TRCMOD_H__
+
+#include <cs/bfa_trc.h>
+
+/*
+ * !!! Only append to the enums defined here to avoid any versioning
+ * !!! needed between trace utility and driver version
+ */
+enum {
+	BFA_TRC_CNA_CEE		= 1,
+	BFA_TRC_CNA_PORT	= 2,
+};
+
+#endif /* __BFA_CNA_TRCMOD_H__ */
diff -urpN orig/drivers/scsi/bfa/include/cna/cee/bfa_cee.h patch/drivers/scsi/bfa/include/cna/cee/bfa_cee.h
--- orig/drivers/scsi/bfa/include/cna/cee/bfa_cee.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cna/cee/bfa_cee.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,77 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+#ifndef __BFA_CEE_H__
+#define __BFA_CEE_H__
+
+#include <defs/bfa_defs_cee.h>
+#include <bfa_ioc.h>
+#include <cs/bfa_trc.h>
+#include <cs/bfa_log.h>
+
+typedef void (*bfa_cee_get_attr_cbfn_t) (void *dev, bfa_status_t status);
+typedef void (*bfa_cee_get_stats_cbfn_t) (void *dev, bfa_status_t status);
+typedef void (*bfa_cee_reset_stats_cbfn_t) (void *dev, bfa_status_t status);
+typedef void (*bfa_cee_hbfail_cbfn_t) (void *dev, bfa_status_t status);
+
+struct bfa_cee_cbfn_s {
+	bfa_cee_get_attr_cbfn_t    get_attr_cbfn;
+	void *get_attr_cbarg;
+	bfa_cee_get_stats_cbfn_t   get_stats_cbfn;
+	void *get_stats_cbarg;
+	bfa_cee_reset_stats_cbfn_t reset_stats_cbfn;
+	void *reset_stats_cbarg;
+};
+
+struct bfa_cee_s {
+	void *dev;
+	bfa_boolean_t get_attr_pending;
+	bfa_boolean_t get_stats_pending;
+	bfa_boolean_t reset_stats_pending;
+	bfa_status_t get_attr_status;
+	bfa_status_t get_stats_status;
+	bfa_status_t reset_stats_status;
+	struct bfa_cee_cbfn_s cbfn;
+	struct bfa_ioc_hbfail_notify_s hbfail;
+	struct bfa_trc_mod_s *trcmod;
+	struct bfa_log_mod_s *logmod;
+	struct bfa_cee_attr_s *attr;
+	struct bfa_cee_stats_s *stats;
+	struct bfa_dma_s attr_dma;
+	struct bfa_dma_s stats_dma;
+	struct bfa_ioc_s *ioc;
+	struct bfa_mbox_cmd_s get_cfg_mb;
+	struct bfa_mbox_cmd_s get_stats_mb;
+	struct bfa_mbox_cmd_s reset_stats_mb;
+};
+
+u32 bfa_cee_meminfo(void);
+void bfa_cee_mem_claim(struct bfa_cee_s *cee, u8 *dma_kva,
+			 u64 dma_pa);
+void bfa_cee_attach(struct bfa_cee_s *cee, struct bfa_ioc_s *ioc, void *dev,
+			struct bfa_trc_mod_s *trcmod,
+			struct bfa_log_mod_s *logmod);
+void bfa_cee_detach(struct bfa_cee_s *cee);
+bfa_status_t bfa_cee_get_attr(struct bfa_cee_s *cee,
+			 struct bfa_cee_attr_s *attr,
+			bfa_cee_get_attr_cbfn_t cbfn, void *cbarg);
+bfa_status_t bfa_cee_get_stats(struct bfa_cee_s *cee,
+			struct bfa_cee_stats_s *stats,
+			bfa_cee_get_stats_cbfn_t cbfn, void *cbarg);
+bfa_status_t bfa_cee_reset_stats(struct bfa_cee_s *cee,
+			bfa_cee_reset_stats_cbfn_t cbfn, void *cbarg);
+#endif /* __BFA_CEE_H__ */
diff -urpN orig/drivers/scsi/bfa/include/cna/port/bfa_port.h patch/drivers/scsi/bfa/include/cna/port/bfa_port.h
--- orig/drivers/scsi/bfa/include/cna/port/bfa_port.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cna/port/bfa_port.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,69 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+#ifndef __BFA_PORT_H__
+#define __BFA_PORT_H__
+
+#include <defs/bfa_defs_port.h>
+#include <bfa_ioc.h>
+#include <cs/bfa_trc.h>
+#include <cs/bfa_log.h>
+
+typedef void    (*bfa_port_stats_cbfn_t) (void *dev, bfa_status_t status);
+typedef void    (*bfa_port_endis_cbfn_t) (void *dev, bfa_status_t status);
+
+struct bfa_port_s {
+	void           *dev;
+	struct bfa_ioc_s *ioc;
+	struct bfa_trc_mod_s *trcmod;
+	struct bfa_log_mod_s *logmod;
+	u32        msgtag;
+	bfa_boolean_t   stats_busy;
+	struct bfa_mbox_cmd_s stats_mb;
+	bfa_port_stats_cbfn_t stats_cbfn;
+	void           *stats_cbarg;
+	bfa_status_t    stats_status;
+	union bfa_pport_stats_u *stats;
+	struct bfa_dma_s stats_dma;
+	bfa_boolean_t   endis_pending;
+	struct bfa_mbox_cmd_s endis_mb;
+	bfa_port_endis_cbfn_t endis_cbfn;
+	void           *endis_cbarg;
+	bfa_status_t    endis_status;
+	struct bfa_ioc_hbfail_notify_s hbfail;
+};
+
+void            bfa_port_attach(struct bfa_port_s *port, struct bfa_ioc_s *ioc,
+				void *dev, struct bfa_trc_mod_s *trcmod,
+				struct bfa_log_mod_s *logmod);
+void            bfa_port_detach(struct bfa_port_s *port);
+void            bfa_port_hbfail(void *arg);
+
+bfa_status_t    bfa_port_get_stats(struct bfa_port_s *port,
+				   union bfa_pport_stats_u *stats,
+				   bfa_port_stats_cbfn_t cbfn, void *cbarg);
+bfa_status_t    bfa_port_clear_stats(struct bfa_port_s *port,
+				     bfa_port_stats_cbfn_t cbfn, void *cbarg);
+bfa_status_t    bfa_port_enable(struct bfa_port_s *port,
+				bfa_port_endis_cbfn_t cbfn, void *cbarg);
+bfa_status_t    bfa_port_disable(struct bfa_port_s *port,
+				 bfa_port_endis_cbfn_t cbfn, void *cbarg);
+u32        bfa_port_meminfo(void);
+void            bfa_port_mem_claim(struct bfa_port_s *port, u8 *dma_kva,
+				   u64 dma_pa);
+
+#endif /* __BFA_PORT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/cna/pstats/ethport_defs.h patch/drivers/scsi/bfa/include/cna/pstats/ethport_defs.h
--- orig/drivers/scsi/bfa/include/cna/pstats/ethport_defs.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cna/pstats/ethport_defs.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,36 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+++ patch/drivers/scsi/bfa/include/cna/pstats/phyport_defs.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,218 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+/*
+ * Statistics
+ */
+
+/*
+ * TxF Frame Statistics
+ */
+struct bna_stats_txf {
+	u64        ucast_octets;
+	u64        ucast;
+	u64        ucast_vlan;
+
+	u64        mcast_octets;
+	u64        mcast;
+	u64        mcast_vlan;
+
+	u64        bcast_octets;
+	u64        bcast;
+	u64        bcast_vlan;
+
+	u64        errors;
+	u64        filter_vlan;	/* frames filtered due to VLAN */
+	u64        filter_mac_sa;	/* frames filtered due to SA check */
+};
+
+/*
+ * RxF Frame Statistics
+ */
+struct bna_stats_rxf {
+	u64        ucast_octets;
+	u64        ucast;
+	u64        ucast_vlan;
+
+	u64        mcast_octets;
+	u64        mcast;
+	u64        mcast_vlan;
+
+	u64        bcast_octets;
+	u64        bcast;
+	u64        bcast_vlan;
+	u64        frame_drops;
+};
+
+/*
+ * FC Tx Frame Statistics
+ */
+struct bna_stats_fc_tx {
+	u64        txf_ucast_octets;
+	u64        txf_ucast;
+	u64        txf_ucast_vlan;
+
+	u64        txf_mcast_octets;
+	u64        txf_mcast;
+	u64        txf_mcast_vlan;
+
+	u64        txf_bcast_octets;
+	u64        txf_bcast;
+	u64        txf_bcast_vlan;
+
+	u64        txf_parity_errors;
+	u64        txf_timeout;
+	u64        txf_fid_parity_errors;
+};
+
+/*
+ * FC Rx Frame Statistics
+ */
+struct bna_stats_fc_rx {
+	u64        rxf_ucast_octets;
+	u64        rxf_ucast;
+	u64        rxf_ucast_vlan;
+
+	u64        rxf_mcast_octets;
+	u64        rxf_mcast;
+	u64        rxf_mcast_vlan;
+
+	u64        rxf_bcast_octets;
+	u64        rxf_bcast;
+	u64        rxf_bcast_vlan;
+};
+
+/*
+ * RAD Frame Statistics
+ */
+struct cna_stats_rad {
+	u64        rx_frames;
+	u64        rx_octets;
+	u64        rx_vlan_frames;
+
+	u64        rx_ucast;
+	u64        rx_ucast_octets;
+	u64        rx_ucast_vlan;
+
+	u64        rx_mcast;
+	u64        rx_mcast_octets;
+	u64        rx_mcast_vlan;
+
+	u64        rx_bcast;
+	u64        rx_bcast_octets;
+	u64        rx_bcast_vlan;
+
+	u64        rx_drops;
+};
+
+/*
+ * BPC Tx Registers
+ */
+struct cna_stats_bpc_tx {
+	u64        tx_pause[8];
+	u64        tx_zero_pause[8];	/*  Pause cancellation */
+	u64        tx_first_pause[8];	/*  Pause initiation rather
+						 *than retention */
+};
+
+/*
+ * BPC Rx Registers
+ */
+struct cna_stats_bpc_rx {
+	u64        rx_pause[8];
+	u64        rx_zero_pause[8];	/*  Pause cancellation */
+	u64        rx_first_pause[8];	/*  Pause initiation rather
+						 *than retention */
+};
+
+/*
+ * MAC Rx Statistics
+ */
+struct cna_stats_mac_rx {
+	u64        frame_64;	/* both rx and tx counter */
+	u64        frame_65_127;	/* both rx and tx counter */
+	u64        frame_128_255;	/* both rx and tx counter */
+	u64        frame_256_511;	/* both rx and tx counter */
+	u64        frame_512_1023;	/* both rx and tx counter */
+	u64        frame_1024_1518;	/* both rx and tx counter */
+	u64        frame_1518_1522;	/* both rx and tx counter */
+	u64        rx_bytes;
+	u64        rx_packets;
+	u64        rx_fcs_error;
+	u64        rx_multicast;
+	u64        rx_broadcast;
+	u64        rx_control_frames;
+	u64        rx_pause;
+	u64        rx_unknown_opcode;
+	u64        rx_alignment_error;
+	u64        rx_frame_length_error;
+	u64        rx_code_error;
+	u64        rx_carrier_sense_error;
+	u64        rx_undersize;
+	u64        rx_oversize;
+	u64        rx_fragments;
+	u64        rx_jabber;
+	u64        rx_drop;
+};
+
+/*
+ * MAC Tx Statistics
+ */
+struct cna_stats_mac_tx {
+	u64        tx_bytes;
+	u64        tx_packets;
+	u64        tx_multicast;
+	u64        tx_broadcast;
+	u64        tx_pause;
+	u64        tx_deferral;
+	u64        tx_excessive_deferral;
+	u64        tx_single_collision;
+	u64        tx_muliple_collision;
+	u64        tx_late_collision;
+	u64        tx_excessive_collision;
+	u64        tx_total_collision;
+	u64        tx_pause_honored;
+	u64        tx_drop;
+	u64        tx_jabber;
+	u64        tx_fcs_error;
+	u64        tx_control_frame;
+	u64        tx_oversize;
+	u64        tx_undersize;
+	u64        tx_fragments;
+};
+
+/*
+ * Complete statistics
+ */
+struct bna_stats {
+	struct cna_stats_mac_rx mac_rx_stats;
+	struct cna_stats_bpc_rx bpc_rx_stats;
+	struct cna_stats_rad rad_stats;
+	struct bna_stats_fc_rx fc_rx_stats;
+	struct cna_stats_mac_tx mac_tx_stats;
+	struct cna_stats_bpc_tx bpc_tx_stats;
+	struct bna_stats_fc_tx fc_tx_stats;
+	struct bna_stats_rxf rxf_stats[BNA_TXF_ID_MAX];
+	struct bna_stats_txf txf_stats[BNA_RXF_ID_MAX];
+};
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/cs/bfa_checksum.h patch/drivers/scsi/bfa/include/cs/bfa_checksum.h
--- orig/drivers/scsi/bfa/include/cs/bfa_checksum.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cs/bfa_checksum.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,60 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+++ patch/drivers/scsi/bfa/include/cs/bfa_debug.h	2009-08-27 19:41:59.000000000 -0700
@@ -0,0 +1,44 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
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
+#define bfa_sm_fault(__mod, __event)	do {				\
+	bfa_sm_panic((__mod)->logm, __LINE__, __FILE__, __event);      \
+} while (0)
+
+#ifndef BFA_PERF_BUILD
+#define bfa_assert_fp(__cond)	bfa_assert(__cond)
+#else
+#define bfa_assert_fp(__cond)
+#endif
+
+struct bfa_log_mod_s;
+void bfa_panic(int line, char *file, char *panicstr);
+void bfa_sm_panic(struct bfa_log_mod_s *logm, int line, char *file, int event);
+
+#endif /* __BFA_DEBUG_H__ */

From: Jayamohan Kalickal <JayamohanKalickal-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Subject: [PATCH 2/4] RFC: beiscsi driver
Date: Sun, 26 Jul 2009 20:12:14 -0700
Message-ID: <20090727031214.GH4550@localhost.localdomain>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="9UV9rz0O2dU/yYYn"
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


--9UV9rz0O2dU/yYYn
Content-Type: text/plain


--~--~---------~--~----~------------~-------~--~----~
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi
-~----------~----~----~----~------~----~------~--~---


--9UV9rz0O2dU/yYYn
Content-Type: text/plain
Content-Disposition: attachment;
	filename="0002-RFC-beiscsi-driver.patch"

>From 6af7e4634baf55573c9fc746c60361a7460393a4 Mon Sep 17 00:00:00 2001
From: Jayamohan Kallickal <jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org>
Date: Sun, 26 Jul 2009 19:03:00 -0700
Subject: [PATCH 2/4] RFC: beiscsi driver

   The  open-iscsi based storage driver for ServerEngines
10 Gbps Adapter. The Adapter is Multi-Function device
that provides NIC/iSCSI/FCOE Functionality.

   The driver works in Full Hardware Offload mode utilizing
the hooks provided by open-iscsi layer.

Signed-off-by: Jayamohan Kallickal <jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org>
---
 drivers/scsi/beiscsi/Kconfig    |    8 +
 drivers/scsi/beiscsi/Makefile   |    8 +
 drivers/scsi/beiscsi/be.h       |  186 +++++++++++
 drivers/scsi/beiscsi/be_iscsi.c |  645 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/beiscsi/be_iscsi.h |   89 ++++++
 drivers/scsi/beiscsi/be_mgmt.c  |  369 ++++++++++++++++++++++
 drivers/scsi/beiscsi/be_mgmt.h  |  260 ++++++++++++++++
 7 files changed, 1565 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/beiscsi/Kconfig
 create mode 100644 drivers/scsi/beiscsi/Makefile
 create mode 100644 drivers/scsi/beiscsi/be.h
 create mode 100644 drivers/scsi/beiscsi/be_iscsi.c
 create mode 100644 drivers/scsi/beiscsi/be_iscsi.h
 create mode 100644 drivers/scsi/beiscsi/be_mgmt.c
 create mode 100644 drivers/scsi/beiscsi/be_mgmt.h

diff --git a/drivers/scsi/beiscsi/Kconfig b/drivers/scsi/beiscsi/Kconfig
new file mode 100644
index 0000000..2952fcd
--- /dev/null
+++ b/drivers/scsi/beiscsi/Kconfig
@@ -0,0 +1,8 @@
+config BE2ISCSI
+	tristate "ServerEngines' 10Gbps iSCSI - BladeEngine 2"
+	depends on PCI && SCSI
+	select SCSI_ISCSI_ATTRS
+
+	help
+	This driver implements the iSCSI functionality for ServerEngines'
+	10Gbps Storage adapter - BladeEngine 2.
diff --git a/drivers/scsi/beiscsi/Makefile b/drivers/scsi/beiscsi/Makefile
new file mode 100644
index 0000000..c11f443
--- /dev/null
+++ b/drivers/scsi/beiscsi/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile to build the iSCSI driver for ServerEngine's BladeEngine.
+#
+#
+
+obj-$(CONFIG_BE2ISCSI) += be2iscsi.o
+
+be2iscsi-y := be_iscsi.o be_main.o be_mgmt.o be_cmds.o
diff --git a/drivers/scsi/beiscsi/be.h b/drivers/scsi/beiscsi/be.h
new file mode 100644
index 0000000..faa3c4a
--- /dev/null
+++ b/drivers/scsi/beiscsi/be.h
@@ -0,0 +1,186 @@
+/*
+ * Copyright (C) 2005 - 2009 ServerEngines
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.  The full GNU General
+ * Public License is included in this distribution in the file called COPYING.
+ *
+ * Contact Information:
+ * linux-drivers-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org
+ *
+ * ServerEngines
+ * 209 N. Fair Oaks Ave
+ * Sunnyvale, CA 94085
+ */
+
+#ifndef BEISCSI_H
+#define BEISCSI_H
+
+#include <linux/pci.h>
+#include <linux/if_vlan.h>
+
+#define FW_VER_LEN 32
+
+struct be_dma_mem {
+	void *va;
+	dma_addr_t dma;
+	u32 size;
+};
+
+struct be_queue_info {
+	struct be_dma_mem dma_mem;
+	u16 len;
+	u16 entry_size;		/* Size of an element in the queue */
+	u16 id;
+	u16 tail, head;
+	bool created;
+	atomic_t used;		/* Number of valid elements in the queue */
+};
+
+static inline u32 MODULO(u16 val, u16 limit)
+{
+	WARN_ON(limit & (limit - 1));
+	return val & (limit - 1);
+}
+
+static inline void index_inc(u16 *index, u16 limit)
+{
+	*index = MODULO((*index + 1), limit);
+}
+
+static inline void *queue_head_node(struct be_queue_info *q)
+{
+	return q->dma_mem.va + q->head * q->entry_size;
+}
+
+static inline void *queue_tail_node(struct be_queue_info *q)
+{
+	return q->dma_mem.va + q->tail * q->entry_size;
+}
+
+static inline void queue_head_inc(struct be_queue_info *q)
+{
+	index_inc(&q->head, q->len);
+}
+
+static inline void queue_tail_inc(struct be_queue_info *q)
+{
+	index_inc(&q->tail, q->len);
+}
+
+/*ISCSI */
+
+#define DEFAULT_MAX_BURST_LENGTH 262144
+
+struct be_eq_obj {
+	struct be_queue_info q;
+	char desc[32];
+
+	/* Adaptive interrupt coalescing (AIC) info */
+	bool enable_aic;
+	u16 min_eqd;		/* in usecs */
+	u16 max_eqd;		/* in usecs */
+	u16 cur_eqd;		/* in usecs */
+};
+
+struct be_mcc_obj {
+	struct be_queue_info *q;
+	struct be_queue_info *cq;
+};
+
+struct be_ctrl_info {
+	u8 __iomem *csr;
+	u8 __iomem *db;		/* Door Bell */
+	u8 __iomem *pcicfg;	/* PCI config space */
+	struct pci_dev *pdev;
+
+	/* Mbox used for cmd request/response */
+	spinlock_t mbox_lock;	/* For serializing mbox cmds to BE card */
+	struct be_dma_mem mbox_mem;
+	/* Mbox mem is adjusted to align to 16 bytes. The allocated addr
+	 * is stored for freeing purpose */
+	struct be_dma_mem mbox_mem_alloced;
+
+	/* MCC Rings */
+	struct be_mcc_obj mcc_obj;
+	spinlock_t mcc_lock;	/* For serializing mcc cmds to BE card */
+	spinlock_t mcc_cq_lock;
+
+	/* MCC Async callback */
+	void (*async_cb) (void *adapter, bool link_up);
+	void *adapter_ctxt;
+};
+
+#include "be_cmds.h"
+
+
+#define PAGE_SHIFT_4K 12
+#define PAGE_SIZE_4K (1 << PAGE_SHIFT_4K)
+
+/* Returns number of pages spanned by the data starting at the given addr */
+#define PAGES_4K_SPANNED(_address, size) 				\
+		((u32)((((size_t)(_address) & (PAGE_SIZE_4K - 1)) + 	\
+			(size) + (PAGE_SIZE_4K - 1)) >> PAGE_SHIFT_4K))
+
+/* Byte offset into the page corresponding to given address */
+#define OFFSET_IN_PAGE(addr)						\
+		((size_t)(addr) & (PAGE_SIZE_4K-1))
+
+/* Returns bit offset within a DWORD of a bitfield */
+#define AMAP_BIT_OFFSET(_struct, field)  				\
+		(((size_t)&(((_struct *)0)->field))%32)
+
+/* Returns the bit mask of the field that is NOT shifted into location. */
+static inline u32 amap_mask(u32 bitsize)
+{
+	return (bitsize == 32 ? 0xFFFFFFFF : (1 << bitsize) - 1);
+}
+
+static inline void amap_set(void *ptr, u32 dw_offset, u32 mask,
+					u32 offset, u32 value)
+{
+	u32 *dw = (u32 *) ptr + dw_offset;
+	*dw &= ~(mask << offset);
+	*dw |= (mask & value) << offset;
+}
+
+#define AMAP_SET_BITS(_struct, field, ptr, val)				\
+		amap_set(ptr,						\
+			offsetof(_struct, field)/32,			\
+			amap_mask(sizeof(((_struct *)0)->field)),	\
+			AMAP_BIT_OFFSET(_struct, field),		\
+			val)
+
+static inline u32 amap_get(void *ptr, u32 dw_offset, u32 mask, u32 offset)
+{
+	u32 *dw = (u32 *) ptr;
+	return mask & (*(dw + dw_offset) >> offset);
+}
+
+#define AMAP_GET_BITS(_struct, field, ptr)				\
+		amap_get(ptr,						\
+			offsetof(_struct, field)/32,			\
+			amap_mask(sizeof(((_struct *)0)->field)),	\
+			AMAP_BIT_OFFSET(_struct, field))
+
+#define be_dws_cpu_to_le(wrb, len) swap_dws(wrb, len)
+#define be_dws_le_to_cpu(wrb, len) swap_dws(wrb, len)
+static inline void swap_dws(void *wrb, int len)
+{
+#ifdef __BIG_ENDIAN
+	u32 *dw = wrb;
+	WARN_ON(len % 4);
+	do {
+		*dw = cpu_to_le32(*dw);
+		dw++;
+		len -= 4;
+	} while (len);
+#endif /* __BIG_ENDIAN */
+}
+
+extern void be_cq_notify(struct be_ctrl_info *ctrl, u16 qid, bool arm,
+		u16 num_popped);
+
+#endif /* BEISCSI_H */
diff --git a/drivers/scsi/beiscsi/be_iscsi.c b/drivers/scsi/beiscsi/be_iscsi.c
new file mode 100644
index 0000000..f6ce9f7
--- /dev/null
+++ b/drivers/scsi/beiscsi/be_iscsi.c
@@ -0,0 +1,645 @@
+/*
+ * Copyright (C) 2005 - 2009 ServerEngines
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.  The full GNU General
+ * Public License is included in this distribution in the file called COPYING.
+ *
+ * Written by: Jayamohan Kallickal (jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org)
+ *
+ * Contact Information:
+ * linux-drivers-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org
+ *
+ * ServerEngines
+ * 209 N. Fair Oaks Ave
+ * Sunnyvale, CA 94085
+ *
+ */
+
+#include <scsi/libiscsi.h>
+#include <scsi/scsi_transport_iscsi.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi.h>
+
+#include "be_iscsi.h"
+
+extern struct iscsi_transport beiscsi_iscsi_transport;
+
+/*
+ * beiscsi_session_create: creates a new iscsi session
+ * cmds_max:		max commands supported
+ * qdepth:		max queue depth supported
+ * initial_cmdsn:	initial iscsi CMDSN
+ */
+struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
+						u16 cmds_max,
+						u16 qdepth,
+						u32 initial_cmdsn)
+{
+	struct iscsi_cls_session *cls_session;
+	struct iscsi_session *sess;
+	struct Scsi_Host *shost;
+	struct beiscsi_endpoint *beiscsi_ep;
+	struct iscsi_task *task;
+	struct beiscsi_io_task *io_task;
+	int num_cmd;
+
+	if (!ep) {
+		SE_DEBUG(DBG_LVL_1, "beiscsi_session_create: invalid ep \n");
+		return NULL;
+	}
+	beiscsi_ep = (struct beiscsi_endpoint *)ep->dd_data;
+	shost = beiscsi_ep->phba->shost;
+
+	cls_session =
+		iscsi_session_setup(&beiscsi_iscsi_transport, shost, cmds_max,
+				sizeof(struct beiscsi_io_task), initial_cmdsn,
+				ISCSI_MAX_TARGET);
+	if (!cls_session)
+		return NULL;
+	sess = cls_session->dd_data;
+
+	shost->can_queue = sess->cmds_max;
+	for (num_cmd = 0; num_cmd < sess->cmds_max; num_cmd++) {
+		task = sess->cmds[num_cmd];
+		io_task = task->dd_data;
+		task->hdr = (struct iscsi_hdr *)&io_task->cmd_bhs.iscsi_hdr;
+		task->hdr_max = sizeof(struct be_cmd_bhs);
+	}
+	return cls_session;
+}
+
+/*
+ * beiscsi_conn_create: create an instance of iscsi connection
+ * cls_session :	ptr to iscsi_cls_session
+ * cid:			iscsi cid
+ */
+struct iscsi_cls_conn *beiscsi_conn_create(struct iscsi_cls_session
+					*cls_session, u32 cid)
+{
+	struct beiscsi_hba *phba;
+	struct Scsi_Host *shost;
+	struct iscsi_cls_conn *cls_conn;
+	struct beiscsi_conn *beiscsi_conn;
+	struct iscsi_conn *conn;
+
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_create ,cid"
+			"from iscsi layer=%d\n", cid);
+	shost = iscsi_session_to_shost(cls_session);
+	phba = iscsi_host_priv(shost);
+
+	cls_conn = iscsi_conn_setup(cls_session, sizeof(*beiscsi_conn), cid);
+	if (!cls_conn)
+		return NULL;
+
+	conn = cls_conn->dd_data;
+	beiscsi_conn = conn->dd_data;
+	beiscsi_conn->ep = NULL;
+	beiscsi_conn->phba = phba;
+	beiscsi_conn->exp_statsn = 0xDEADBEEF;
+	beiscsi_conn->conn = conn;
+
+	return cls_conn;
+
+}
+
+/*
+ * beiscsi_session_destroy: destroy the iscsi session
+ * cls_session :	ptr to iscsi_cls_session
+ */
+void beiscsi_session_destroy(struct iscsi_cls_session *cls_session)
+{
+	iscsi_session_teardown(cls_session);
+}
+
+/*
+ * beiscsi_conn_destroy: destroy the iscsi connection
+ * cls_conn :		ptr to iscsi_cls_conn
+ */
+void beiscsi_conn_destroy(struct iscsi_cls_conn *cls_conn)
+{
+	iscsi_conn_teardown(cls_conn);
+
+}
+
+/* beiscsi_conn_bind:  Binds iscsi session/connection with TCP connection
+ * @cls_session:	pointer to iscsi cls session
+ * @cls_conn:		pointer to iscsi cls conn
+ * transport_fd:	EP handle(64 bit)
+ * This function binds the TCP Conn with iSCSI Connection and Session.
+ */
+int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
+			struct iscsi_cls_conn *cls_conn,
+			u64 transport_fd, int is_leading)
+{
+	struct iscsi_conn *conn = cls_conn->dd_data;
+	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
+	struct Scsi_Host *shost =
+		(struct Scsi_Host *)iscsi_session_to_shost(cls_session);
+	struct beiscsi_hba *phba = (struct beiscsi_hba *)iscsi_host_priv(shost);
+	struct beiscsi_endpoint *beiscsi_ep;
+	struct iscsi_endpoint *ep;
+
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_bind\n");
+	ep = iscsi_lookup_endpoint(transport_fd);
+	if (!ep)
+		return -EINVAL;
+
+	beiscsi_ep = ep->dd_data;
+
+	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
+		return -EINVAL;
+
+	if (beiscsi_ep->phba != phba) {
+		SE_DEBUG(DBG_LVL_8,
+			"beiscsi_ep->hba=%p not equal to phba=%p \n",
+					beiscsi_ep->phba, phba);
+		return -EEXIST;
+	}
+
+	beiscsi_conn->beiscsi_conn_cid = beiscsi_ep->ep_cid;
+	beiscsi_conn->ep = beiscsi_ep;
+	beiscsi_ep->conn = beiscsi_conn;
+	SE_DEBUG(DBG_LVL_8, "ep_cid=%d \n", beiscsi_ep->ep_cid);
+
+	return beiscsi_bindconn_cid(phba, beiscsi_conn, beiscsi_ep->ep_cid);
+}
+
+/* beiscsi_conn_get_param: get the iscsi parameter
+ * cls_conn:		pointer to iscsi cls conn
+ * param:	parameter type identifier
+ * buf:	buffer pointer
+ * returns iscsi parameter
+ */
+
+int beiscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
+			enum iscsi_param param, char *buf)
+{
+	struct beiscsi_endpoint *beiscsi_ep;
+	struct iscsi_conn *conn = cls_conn->dd_data;
+	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
+	int len = 0;
+
+	beiscsi_ep = beiscsi_conn->ep;
+	if (!beiscsi_ep) {
+		SE_DEBUG(DBG_LVL_1,
+		"In beiscsi_conn_get_param , no beiscsi_ep\n");
+		return -1;
+	}
+
+	switch (param) {
+	case ISCSI_PARAM_CONN_PORT:
+		len = sprintf(buf, "%hu\n", beiscsi_ep->dst_tcpport);
+		break;
+	case ISCSI_PARAM_CONN_ADDRESS:
+		len = sprintf(buf, "%u.%u.%u.%u\n",
+			((unsigned char *)&beiscsi_ep->dst_addr)[0],
+			((unsigned char *)&beiscsi_ep->dst_addr)[1],
+			((unsigned char *)&beiscsi_ep->dst_addr)[2],
+			((unsigned char *)&beiscsi_ep->dst_addr)[3]);
+		break;
+	default:
+		return iscsi_conn_get_param(cls_conn, param, buf);
+	}
+
+	return len;
+}
+
+/* beiscsi_get_host_param: get the iscsi parameter
+ * shost:	pointer to scsi_host structure
+ * param:	parameter type identifier
+ * buf:		buffer pointer
+ * returns host parameter
+ */
+
+int beiscsi_get_host_param(struct Scsi_Host *shost,
+		enum iscsi_host_param param, char *buf)
+{
+	struct beiscsi_hba *phba = (struct beiscsi_hba *)iscsi_host_priv(shost);
+	int len = 0;
+
+	switch (param) {
+	case ISCSI_HOST_PARAM_HWADDRESS:
+		be_cmd_get_mac_addr(&phba->ctrl, phba->mac_address);
+		len = sysfs_format_mac(buf, phba->mac_address, ETH_ALEN);
+		break;
+	case ISCSI_HOST_PARAM_NETDEV_NAME:
+		   len = sprintf(buf, "beiscsi\n");
+		break;
+	default:
+		return iscsi_host_get_param(shost, param, buf);
+	}
+	return len;
+}
+
+/* beiscsi_conn_get_stats: get the iscsi stats
+ * cls_conn:	pointer to iscsi cls conn
+ * stats:	pointer to iscsi_stats structure
+ * returns iscsi stats
+ */
+void beiscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn,
+				struct iscsi_stats *stats)
+{
+	struct iscsi_conn *conn = cls_conn->dd_data;
+
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_get_stats\n");
+	stats->txdata_octets = conn->txdata_octets;
+	stats->rxdata_octets = conn->rxdata_octets;
+	stats->dataout_pdus = conn->dataout_pdus_cnt;
+	stats->scsirsp_pdus = conn->scsirsp_pdus_cnt;
+	stats->scsicmd_pdus = conn->scsicmd_pdus_cnt;
+	stats->datain_pdus = conn->datain_pdus_cnt;
+	stats->tmfrsp_pdus = conn->tmfrsp_pdus_cnt;
+	stats->tmfcmd_pdus = conn->tmfcmd_pdus_cnt;
+	stats->r2t_pdus = conn->r2t_pdus_cnt;
+	stats->digest_err = 0;
+	stats->timeout_err = 0;
+	stats->custom_length = 0;
+	strcpy(stats->custom[0].desc, "eh_abort_cnt");
+	stats->custom[0].value = conn->eh_abort_cnt;
+}
+
+/* beiscsi_set_params_for_offld : get the parameters for offload
+ * beiscsi_conn:	pointer to beiscsi_conn
+ * params:		pointer to offload_params structure
+ */
+static int beiscsi_set_params_for_offld(struct beiscsi_conn *beiscsi_conn,
+					struct beiscsi_offload_params *params)
+{
+
+	struct iscsi_conn *conn = beiscsi_conn->conn;
+	struct iscsi_session *session = conn->session;
+
+	AMAP_SET_BITS(struct amap_beiscsi_offload_params, max_burst_length,
+						params, session->max_burst);
+	AMAP_SET_BITS(struct amap_beiscsi_offload_params,
+		max_send_data_segment_length, params, 8192);
+	AMAP_SET_BITS(struct amap_beiscsi_offload_params, first_burst_length,
+						params, session->first_burst);
+	AMAP_SET_BITS(struct amap_beiscsi_offload_params, first_burst_length,
+								params, 8192);
+	AMAP_SET_BITS(struct amap_beiscsi_offload_params, erl, params,
+							session->erl);
+	AMAP_SET_BITS(struct amap_beiscsi_offload_params, dde, params,
+						conn->datadgst_en);
+	AMAP_SET_BITS(struct amap_beiscsi_offload_params, hde, params,
+						conn->hdrdgst_en);
+	AMAP_SET_BITS(struct amap_beiscsi_offload_params, ir2t, params,
+						session->initial_r2t_en);
+	AMAP_SET_BITS(struct amap_beiscsi_offload_params, imd, params,
+						session->imm_data_en);
+	AMAP_SET_BITS(struct amap_beiscsi_offload_params, exp_statsn, params,
+						(conn->exp_statsn - 1));
+	return 0;
+}
+
+
+/* beiscsi_conn_start : offload of session to chip
+ * cls_conn:	pointer to beiscsi_conn
+ */
+int beiscsi_conn_start(struct iscsi_cls_conn *cls_conn)
+{
+	struct iscsi_conn *conn = cls_conn->dd_data;
+	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
+	struct beiscsi_endpoint *beiscsi_ep;
+	struct beiscsi_offload_params params;
+
+	struct iscsi_session *session = conn->session;
+	struct Scsi_Host *shost = iscsi_session_to_shost(session->cls_session);
+	struct beiscsi_hba *phba = iscsi_host_priv(shost);
+
+	memset(&params, 0x0, sizeof(struct beiscsi_offload_params));
+	SE_DEBUG(DBG_LVL_8, "beiscsi_conn_start \n");
+	beiscsi_ep = beiscsi_conn->ep;
+	if (!beiscsi_ep)
+		SE_DEBUG(DBG_LVL_1, "In beiscsi_conn_start , no beiscsi_ep\n");
+	free_eh_sgl_handle(phba, beiscsi_conn->plogin_sgl_handle);
+	beiscsi_conn->login_in_progress = 0;
+	iscsi_conn_start(cls_conn);
+	beiscsi_set_params_for_offld(beiscsi_conn, &params);
+	beiscsi_offload_connection(beiscsi_conn, &params);
+	return 0;
+}
+
+/*
+ * beiscsi_ep_connect: Ask chip to create TCP Conn
+ * scsi_host:		Pointer to scsi_host structure
+ * dst_addr:		The IP address of Target
+ * non_blocking:	blocking or non-blocking call
+
+  This routines first asks chip to create a connection and then allocates an EP
+ */
+struct iscsi_endpoint
+	*beiscsi_ep_connect(struct Scsi_Host *shost,
+			struct sockaddr *dst_addr, int non_blocking)
+{
+	struct beiscsi_hba *phba;
+	struct beiscsi_endpoint *beiscsi_ep;
+	struct iscsi_endpoint *ep;
+	int ret;
+
+
+
+	if (shost)
+		phba = iscsi_host_priv(shost);
+	else {
+		ret = -ENXIO;
+		SE_DEBUG(DBG_LVL_1, "shost is NULL \n");
+		return ERR_PTR(ret);
+	}
+	ep = iscsi_create_endpoint(sizeof(struct beiscsi_endpoint));
+	if (!ep) {
+		ret = -ENOMEM;
+		return ERR_PTR(ret);
+	}
+
+	beiscsi_ep = ep->dd_data;
+	beiscsi_ep->phba = phba;
+
+	if (beiscsi_open_conn(ep, NULL, dst_addr, non_blocking)) {
+		SE_DEBUG(DBG_LVL_1, "Failed in allocate iscsi cid\n");
+		ret = -ENOMEM;
+		goto free_ep;
+	}
+
+	return ep;
+
+free_ep:
+	beiscsi_free_ep(ep);
+	return ERR_PTR(ret);
+}
+
+/*
+ * beiscsi_ep_poll: Poll to see if connection is established
+ * ep:			endpoint to be used
+ * timeout_ms:		timeout specified in millisecs
+ * Poll to see if TCP connection established
+ */
+int beiscsi_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
+{
+	struct beiscsi_endpoint *beiscsi_ep = ep->dd_data;
+
+	if (beiscsi_ep->cid_vld == 1)
+		return 1;
+	else
+		return 0;
+}
+
+
+/*
+ * beiscsi_cleanup_task: For compatibility with open-iscsi
+ *	as now this function is not an option
+ *
+ */
+void beiscsi_cleanup_task(struct iscsi_task *task)
+{
+
+	return;
+}
+
+/*
+ * beiscsi_ep_disconnect: Tears down the TCP connection
+ * ep:			endpoint to be used
+ * Tears down the TCP connection
+ */
+void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
+{
+	struct beiscsi_conn *beiscsi_conn;
+	struct beiscsi_endpoint *beiscsi_ep;
+	struct beiscsi_hba *phba;
+	int flag = 0;
+
+	beiscsi_ep = ep->dd_data;
+	phba = beiscsi_ep->phba;
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_ep_disconnect\n");
+
+	if (beiscsi_ep->conn) {
+		beiscsi_conn = beiscsi_ep->conn;
+		iscsi_suspend_tx(beiscsi_conn->conn);
+
+		beiscsi_close_conn(ep, flag);
+
+		beiscsi_conn->ep = NULL;
+	}
+
+	beiscsi_free_ep(ep);
+}
+
+/*
+ * beiscsi_put_cid: Free the cid
+ * phba:	The phba for which the cid is being freed
+ * cid:		The cid to free
+ */
+static void beiscsi_put_cid(struct beiscsi_hba *phba, unsigned short cid)
+{
+
+	phba->avlbl_cids++;
+	phba->cid_array[phba->cid_free++] = cid;
+	if (phba->cid_free == phba->params.cxns_per_ctrl)
+		phba->cid_free = 0;
+	return;
+}
+
+/*
+ * beiscsi_bindconn_cid:Bind the beiscsi_conn with
+ *		phba connection table
+ * beiscsi_conn:The pointer to  beiscsi_conn structure
+ * phba:	The phba instance
+ * cid:		The cid to free
+ */
+int beiscsi_bindconn_cid(struct beiscsi_hba *phba,
+		struct beiscsi_conn *beiscsi_conn, unsigned int cid)
+{
+	if (phba->conn_table[cid]) {
+		SE_DEBUG(DBG_LVL_1,
+			"Connection table already occupied. Detected clash\n");
+		return -EINVAL;
+	} else {
+		SE_DEBUG(DBG_LVL_8, "phba->conn_table[%d]=%p(beiscsi_conn) \n",
+							cid, beiscsi_conn);
+		phba->conn_table[cid] = beiscsi_conn;
+	}
+	return 0;
+
+}
+
+/*
+ * beiscsi_unbind_conn_to_cid:Unbind the beiscsi_conn from
+ *		phba connection table
+ * phba:	The phba instance
+ * cid:		The cid to free
+ */
+
+static int beiscsi_unbind_conn_to_cid(struct beiscsi_hba *phba,
+					unsigned int cid)
+{
+	if (phba->conn_table[cid]) {
+		phba->conn_table[cid] = NULL;
+	} else {
+		SE_DEBUG(DBG_LVL_8, "Connection table Not occupied. \n");
+		return -EINVAL;
+	}
+	return 0;
+
+}
+
+/*
+ * beiscsi_alloc_ep: Used to allocate a ep
+ * phba:	The phba instance
+ *
+ */
+struct iscsi_endpoint *beiscsi_alloc_ep(struct beiscsi_hba *phba)
+{
+	struct iscsi_endpoint *ep;
+	struct beiscsi_endpoint *beiscsi_ep;
+
+	ep = iscsi_create_endpoint(sizeof(struct beiscsi_endpoint));
+	if (!ep) {
+		SE_DEBUG(DBG_LVL_1, "Failed in iscsi_create_endpoint\n");
+		return NULL;
+	}
+
+	beiscsi_ep = ep->dd_data;
+	beiscsi_ep->phba = phba;
+	return ep;
+}
+
+/*
+ * beiscsi_free_ep: free endpoint
+ * ep:		pointer to iscsi endpoint structure
+ */
+void beiscsi_free_ep(struct iscsi_endpoint *ep)
+{
+	struct beiscsi_endpoint *beiscsi_ep = ep->dd_data;
+	struct beiscsi_hba *phba = beiscsi_ep->phba;
+
+	beiscsi_put_cid(phba, beiscsi_ep->ep_cid);
+	beiscsi_ep->phba = NULL;
+	iscsi_destroy_endpoint(ep);
+}
+
+/*
+ * beiscsi_get_cid:Allocate a cid
+ * phba:	The phba instance
+ */
+
+static int beiscsi_get_cid(struct beiscsi_hba *phba)
+{
+	unsigned short cid = 0xFFFF;
+
+	if (!phba->avlbl_cids)
+		return cid;
+
+	cid = phba->cid_array[phba->cid_alloc++];
+	if (phba->cid_alloc == phba->params.cxns_per_ctrl)
+		phba->cid_alloc = 0;
+	phba->avlbl_cids--;
+	return cid;		/* The cid returned here is
+				 * 0,2,4 ...or 1,3,5,...
+				 */
+}
+
+/*
+ * beiscsi_open_conn: Ask FW to open a TCP connection
+ * ep:		endpoint to be used
+ * src_addr:    The source IP address
+ * dst_addr:    The Destination  IP address
+ * Asks the FW to open a TCP connection
+ */
+int beiscsi_open_conn(struct iscsi_endpoint *ep,
+			struct sockaddr *src_addr,
+			struct sockaddr *dst_addr, int non_blocking)
+{
+
+
+	struct beiscsi_endpoint *beiscsi_ep = ep->dd_data;
+	struct beiscsi_hba *phba = beiscsi_ep->phba;
+	struct sockaddr_in *daddr_in = (struct sockaddr_in *)dst_addr;
+	int ret = -1;
+
+	beiscsi_ep->ep_cid = beiscsi_get_cid(phba);
+	if (beiscsi_ep->ep_cid == 0xFFFF) {
+		SE_DEBUG(DBG_LVL_1, "No free cid available\n");
+		return ret;
+	}
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_open_conn, ep_cid=%d ",
+						beiscsi_ep->ep_cid);
+	phba->ep_array[beiscsi_ep->ep_cid] = (unsigned long *)ep;
+	/* Here , the cid values are * 0,2,4 ... or  1,3,5... */
+	if (beiscsi_ep->ep_cid >
+		(phba->fw_config.iscsi_cid_start +
+		phba->params.cxns_per_ctrl)){
+		SE_DEBUG(DBG_LVL_1, "Failed in allocate iscsi cid\n");
+		return ret;
+	}
+
+	daddr_in->sin_port = ISCSI_LISTEN_PORT;
+	beiscsi_ep->cid_vld = 0;
+	ret = mgmt_open_connection(phba, daddr_in->sin_addr.s_addr,
+				daddr_in->sin_port, beiscsi_ep->ep_cid);
+
+	beiscsi_ep->dst_addr = daddr_in->sin_addr.s_addr;
+	beiscsi_ep->dst_tcpport = daddr_in->sin_port;
+
+	return ret;
+
+}
+
+/* beiscsi_conn_stop : Invalidate and stop the connection
+ * cls_conn:	pointer to beiscsi_conn
+ * flag:	The type of connection closure
+ */
+void beiscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
+{
+	struct iscsi_conn *conn = cls_conn->dd_data;
+	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
+	struct beiscsi_endpoint *beiscsi_ep;
+	struct iscsi_session *session = conn->session;
+	struct Scsi_Host *shost = iscsi_session_to_shost(session->cls_session);
+	struct beiscsi_hba *phba = iscsi_host_priv(shost);
+	unsigned int status;
+
+	unsigned short savecfg_flag = CMD_ISCSI_SESSION_SAVE_CFG_ON_FLASH;
+	beiscsi_ep = beiscsi_conn->ep;
+	if (!beiscsi_ep) {
+		SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_stop , no beiscsi_ep\n");
+		return;
+	}
+	status = mgmt_invalidate_connection(phba, beiscsi_ep,
+		beiscsi_ep->ep_cid, (unsigned short)true, savecfg_flag);
+	if (status != MGMT_STATUS_SUCCESS) {
+		SE_DEBUG(DBG_LVL_1,
+			"mgmt_invalidate_connection Failed for cid=%d \n",
+						beiscsi_ep->ep_cid);
+	}
+	beiscsi_unbind_conn_to_cid(phba, beiscsi_ep->ep_cid);
+
+	iscsi_conn_stop(cls_conn, flag);
+}
+
+/* beiscsi_close_conn : Upload the  connection
+ * ep:			The iscsi endpoint
+ * flag:	The type of connection closure
+ */
+int beiscsi_close_conn(struct iscsi_endpoint *ep, int flag)
+{
+	int ret = 0;
+	struct beiscsi_endpoint *beiscsi_ep = ep->dd_data;
+	struct beiscsi_hba *phba = beiscsi_ep->phba;
+
+	if (MGMT_STATUS_SUCCESS !=
+		mgmt_upload_connection(phba, beiscsi_ep->ep_cid,
+		CONNECTION_UPLOAD_GRACEFUL)) {
+		SE_DEBUG(DBG_LVL_8, "upload failed for cid 0x%x",
+					beiscsi_ep->ep_cid);
+		ret = -1;
+	}
+
+	return ret;
+}
+
diff --git a/drivers/scsi/beiscsi/be_iscsi.h b/drivers/scsi/beiscsi/be_iscsi.h
new file mode 100644
index 0000000..b85d701
--- /dev/null
+++ b/drivers/scsi/beiscsi/be_iscsi.h
@@ -0,0 +1,89 @@
+/*
+ * Copyright (C) 2005 - 2009 ServerEngines
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.  The full GNU General
+ * Public License is included in this distribution in the file called COPYING.
+ *
+ * Written by: Jayamohan Kallickal (jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org)
+ *
+ * Contact Information:
+ * linux-drivers-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org
+ *
+ * ServerEngines
+ * 209 N. Fair Oaks Ave
+ * Sunnyvale, CA 94085
+ *
+ */
+
+#ifndef _BE_ISCSI_
+#define _BE_ISCSI_
+
+#include "be_main.h"
+#include "be_mgmt.h"
+
+int
+beiscsi_bindconn_cid(struct beiscsi_hba *phba,
+		struct beiscsi_conn *beiscsi_conn, unsigned int cid);
+
+void beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
+				struct beiscsi_offload_params *params);
+
+int beiscsi_close_conn(struct iscsi_endpoint *ep, int flags);
+
+void beiscsi_offload_iscsi(struct beiscsi_hba *phba, struct iscsi_conn *conn,
+		struct beiscsi_conn *beiscsi_conn, unsigned int fw_handle);
+
+struct iscsi_endpoint *beiscsi_alloc_ep(struct beiscsi_hba *hba);
+
+void beiscsi_free_ep(struct iscsi_endpoint *ep);
+
+struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
+						 uint16_t cmds_max,
+						 uint16_t qdepth,
+						 uint32_t initial_cmdsn);
+
+struct iscsi_cls_conn *beiscsi_conn_create(struct iscsi_cls_session
+						*cls_session, uint32_t cid);
+
+int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
+			struct iscsi_cls_conn *cls_conn,
+			uint64_t transport_fd, int is_leading);
+void beiscsi_conn_destroy(struct iscsi_cls_conn *cls_conn);
+
+int beiscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
+				enum iscsi_param param, char *buf);
+
+int
+beiscsi_get_host_param(struct Scsi_Host *shost,
+		enum iscsi_host_param param, char *buf);
+
+int beiscsi_conn_start(struct iscsi_cls_conn *cls_conn);
+
+void beiscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag);
+
+struct iscsi_endpoint *beiscsi_ep_connect(struct Scsi_Host *shost,
+					struct sockaddr *dst_addr,
+						int non_blocking);
+
+void beiscsi_cleanup_task(struct iscsi_task *task);
+
+int beiscsi_ep_poll(struct iscsi_endpoint *ep, int timeout_ms);
+
+void beiscsi_ep_disconnect(struct iscsi_endpoint *ep);
+
+void beiscsi_session_destroy(struct iscsi_cls_session *cls_session);
+
+void beiscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn,
+				struct iscsi_stats *stats);
+
+void beiscsi_parse_itt(struct iscsi_conn *conn, itt_t itt, int *idx, int *age);
+
+int beiscsi_alloc_pdu(struct iscsi_task *task, u8 opcode);
+struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *conn, itt_t itt);
+
+extern int beiscsi_task_xmit(struct iscsi_task *task);
+
+#endif
diff --git a/drivers/scsi/beiscsi/be_mgmt.c b/drivers/scsi/beiscsi/be_mgmt.c
new file mode 100644
index 0000000..7494349
--- /dev/null
+++ b/drivers/scsi/beiscsi/be_mgmt.c
@@ -0,0 +1,369 @@
+/*
+ * Copyright (C) 2005 - 2009 ServerEngines
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.  The full GNU General
+ * Public License is included in this distribution in the file called COPYING.
+ *
+ * Written by: Jayamohan Kallickal (jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org)
+ *
+ * Contact Information:
+ * linux-drivers-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org
+ *
+ * ServerEngines
+ * 209 N. Fair Oaks Ave
+ * Sunnyvale, CA 94085
+ *
+ */
+
+#include "be_mgmt.h"
+#include "be_iscsi.h"
+
+/* All the mbox stuff */
+
+unsigned char mgmt_get_fw_config(struct be_ctrl_info *ctrl,
+				struct beiscsi_hba *phba)
+{
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct be_fw_cfg *req = embedded_payload(wrb);
+	int status = 0;
+
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
+			OPCODE_COMMON_QUERY_FIRMWARE_CONFIG, sizeof(*req));
+
+	status = be_mbox_notify(ctrl);
+	if (!status) {
+		struct be_fw_cfg *pfw_cfg;
+		pfw_cfg = (struct be_fw_cfg *)req;
+		phba->fw_config.phys_port = pfw_cfg->phys_port;
+		phba->fw_config.iscsi_icd_start =
+					pfw_cfg->ulp[0].icd_base;
+		phba->fw_config.iscsi_icd_count =
+					pfw_cfg->ulp[0].icd_count;
+		phba->fw_config.iscsi_cid_start =
+					pfw_cfg->ulp[0].sq_base;
+		phba->fw_config.iscsi_cid_count =
+					pfw_cfg->ulp[0].sq_count;
+	} else {
+		dev_warn(&phba->pcidev->dev,
+			"Failed in mgmt_get_fw_config \n");
+	}
+
+	spin_unlock(&ctrl->mbox_lock);
+	return status;
+}
+unsigned char mgmt_check_supported_fw(struct be_ctrl_info *ctrl)
+{
+	struct be_dma_mem nonemb_cmd;
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct be_mgmt_controller_attributes *req;
+	struct be_sge *sge = nonembedded_sgl(wrb);
+	int status = 0;
+
+	nonemb_cmd.va =
+	    pci_alloc_consistent(ctrl->pdev,
+			    sizeof(struct be_mgmt_controller_attributes),
+							&nonemb_cmd.dma);
+	if (nonemb_cmd.va == NULL) {
+		SE_DEBUG(DBG_LVL_1,
+		"Failed to allocate memory for mgmt_check_supported_fw"
+			"\n");
+		return -1;
+	}
+	nonemb_cmd.size = sizeof(struct be_mgmt_controller_attributes);
+	req = nonemb_cmd.va;
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+	be_wrb_hdr_prepare(wrb, sizeof(*req), false, 1);
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
+			OPCODE_COMMON_GET_CNTL_ATTRIBUTES, sizeof(*req));
+	sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd.dma));
+	sge->pa_lo = cpu_to_le32(nonemb_cmd.dma & 0xFFFFFFFF);
+	sge->len = cpu_to_le32(nonemb_cmd.size);
+
+	status = be_mbox_notify(ctrl);
+	if (!status) {
+		struct be_mgmt_controller_attributes_resp *resp = nonemb_cmd.va;
+		SE_DEBUG(DBG_LVL_8, "Firmware version of CMD: %s\n",
+			resp->params.hba_attribs.flashrom_version_string);
+		SE_DEBUG(DBG_LVL_8, "Firmware version is : %s\n",
+			resp->params.hba_attribs.firmware_version_string);
+		SE_DEBUG(DBG_LVL_8,
+			"Developer Build, not performing version check...\n");
+
+	} else {
+		SE_DEBUG(DBG_LVL_1,
+				" Failed in mgmt_check_supported_fw\n");
+	}
+	if (nonemb_cmd.va)
+		pci_free_consistent(ctrl->pdev, nonemb_cmd.size,
+				nonemb_cmd.va, nonemb_cmd.dma);
+
+	spin_unlock(&ctrl->mbox_lock);
+	return status;
+}
+
+unsigned char mgmt_set_fragnum_bits(struct beiscsi_hba *phba,
+					unsigned int num_bits)
+{
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct fragnum_bits_for_sgl_cra_in *req = embedded_payload(wrb);
+	int status = 0;
+
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
+			OPCODE_COMMON_ISCSI_SET_FRAGNUM_BITS_FOR_SGL_CRA,
+							sizeof(*req));
+	req->num_bits = num_bits;
+	status = be_mbox_notify(ctrl);
+	if (status)
+		dev_warn(&phba->pcidev->dev,
+				" mgmt_set_fragnum_bits , FAILED\n");
+
+	 spin_unlock(&ctrl->mbox_lock);
+	return status;
+
+}
+unsigned char
+mgmt_modify_eq_delay(struct beiscsi_hba *phba,
+		unsigned int eq_id, unsigned int new_delay)
+{
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct be_eq_delay_params_in *req = embedded_payload(wrb);
+	int status = 0;
+
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
+			OPCODE_COMMON_MODIFY_EQ_DELAY, sizeof(*req));
+
+	req->num_eq = 1;
+	req->delay[0].eq_id = eq_id;
+	req->delay[0].phase = 0;
+	req->delay[0].delay_multiplier = new_delay;
+
+	status = be_mbox_notify(ctrl);
+	if (status)
+		dev_warn(&phba->pcidev->dev,
+				" mgmt_modify_eq_delay , FAILED\n");
+
+	spin_unlock(&ctrl->mbox_lock);
+	return status;
+
+}
+unsigned char mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute)
+{
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct iscsi_cleanup_req *req = embedded_payload(wrb);
+	int status = 0;
+
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
+			OPCODE_COMMON_ISCSI_CLEANUP, sizeof(*req));
+
+	req->chute = chute;
+	req->hdr_ring_id = 0;
+	req->data_ring_id = 0;
+
+	status = be_mbox_notify(ctrl);
+	if (status)
+		dev_warn(&phba->pcidev->dev,
+				" mgmt_epfw_cleanup , FAILED\n");
+
+	spin_unlock(&ctrl->mbox_lock);
+	return status;
+}
+
+unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
+				unsigned int icd, unsigned int cid)
+{
+	struct be_dma_mem nonemb_cmd;
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct be_sge *sge = nonembedded_sgl(wrb);
+	struct invalidate_commands_params_in *req;
+	int status = 0;
+
+	nonemb_cmd.va = pci_alloc_consistent(ctrl->pdev,
+			sizeof(struct invalidate_commands_params_in),
+						&nonemb_cmd.dma);
+	if (nonemb_cmd.va == NULL) {
+		SE_DEBUG(DBG_LVL_1,
+			"Failed to allocate memory for"
+			"mgmt_check_supported_fw \n");
+		return -1;
+	}
+	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
+	req = nonemb_cmd.va;
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	be_wrb_hdr_prepare(wrb, sizeof(*req), false, 1);
+
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
+			OPCODE_COMMON_ISCSI_ERROR_RECOVERY_INVALIDATE_COMMANDS,
+								sizeof(*req));
+	req->ref_handle = 0;
+	req->cleanup_type = CMD_ISCSI_COMMAND_INVALIDATE;
+	req->icd_count = 0;
+	req->table[req->icd_count].icd = icd;
+	req->table[req->icd_count].cid = cid;
+	sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd.dma));
+	sge->pa_lo = cpu_to_le32(nonemb_cmd.dma & 0xFFFFFFFF);
+	sge->len = cpu_to_le32(nonemb_cmd.size);
+
+	status = be_mbox_notify(ctrl);
+	if (status)
+		SE_DEBUG(DBG_LVL_1, "ICDS Invalidation Failed\n");
+
+	spin_unlock(&ctrl->mbox_lock);
+	if (nonemb_cmd.va)
+		pci_free_consistent(ctrl->pdev, nonemb_cmd.size,
+					nonemb_cmd.va, nonemb_cmd.dma);
+	return status;
+}
+
+unsigned char mgmt_invalidate_connection(struct beiscsi_hba *phba,
+				struct beiscsi_endpoint *beiscsi_ep,
+				unsigned short cid,
+				unsigned short issue_reset,
+				unsigned short savecfg_flag)
+{
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct iscsi_invalidate_connection_params_in *req =
+						embedded_payload(wrb);
+	int status = 0;
+
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI_INI,
+			OPCODE_ISCSI_INI_DRIVER_INVALIDATE_CONNECTION,
+							sizeof(*req));
+	req->session_handle = beiscsi_ep->fw_handle;
+	req->cid = cid;
+	if (issue_reset)
+		req->cleanup_type = CMD_ISCSI_CONNECTION_ISSUE_TCP_RST;
+	else
+		req->cleanup_type = CMD_ISCSI_CONNECTION_INVALIDATE;
+	req->save_cfg = savecfg_flag;
+	status = be_mbox_notify(ctrl);
+	if (status)
+		SE_DEBUG(DBG_LVL_1, "Invalidation Failed\n");
+
+	spin_unlock(&ctrl->mbox_lock);
+	return status;
+}
+
+unsigned char mgmt_upload_connection(struct beiscsi_hba *phba,
+				unsigned short cid, unsigned int upload_flag)
+{
+
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct tcp_upload_params_in *req = embedded_payload(wrb);
+	int status = 0;
+
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+	be_cmd_hdr_prepare(&req->hdr, CMD_COMMON_TCP_UPLOAD,
+				OPCODE_COMMON_TCP_UPLOAD, sizeof(*req));
+	req->id = (unsigned short)cid;
+	req->upload_type = (unsigned char)upload_flag;
+	status = be_mbox_notify(ctrl);
+	if (status)
+		SE_DEBUG(DBG_LVL_1, "mgmt_upload_connection Failed\n");
+
+	spin_unlock(&ctrl->mbox_lock);
+	return status;
+
+}
+
+unsigned int mgmt_open_connection(struct beiscsi_hba *phba, __be32 s_addr,
+					__be16 sin_port, unsigned short cid)
+{
+	struct hwi_controller_ws *phwc;
+	struct hwi_context_memory *phwi_context;
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct tcp_connect_and_offload_in *req = embedded_payload(wrb);
+	unsigned short def_hdr_id;
+	unsigned short def_data_id;
+	struct phys_addr template_address = { 0, 0 };
+	struct phys_addr *ptemplate_address;
+	int status = 0;
+
+	phwc = GET_HWI_CONTROLLER_WS(phba);
+	phwi_context = phwc->phwic;
+	def_hdr_id = (unsigned short)HWI_GET_DEF_HDRQ_ID(phba);
+	def_data_id = (unsigned short)HWI_GET_DEF_BUFQ_ID(phba);
+
+	ptemplate_address = &template_address;
+	ISCSI_GET_PDU_TEMPLATE_ADDRESS(phba, ptemplate_address);
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
+			OPCODE_COMMON_ISCSI_TCP_CONNECT_AND_OFFLOAD,
+							sizeof(*req));
+
+	req->ip_address.ip_type = 1;
+	req->ip_address.ip_address[0] = s_addr & 0x000000ff;
+	req->ip_address.ip_address[1] = (s_addr & 0x0000ff00) >> 8;
+	req->ip_address.ip_address[2] = (s_addr & 0x00ff0000) >> 16;
+	req->ip_address.ip_address[3] = (s_addr & 0xff000000) >> 24;
+	req->tcp_port = sin_port;
+	req->cid = cid;
+	req->cq_id = phwi_context->be_cq.id;
+	req->defq_id = def_hdr_id;
+	req->hdr_ring_id = def_hdr_id;
+	req->data_ring_id = def_data_id;
+	req->do_offload = 1;
+
+	req->dataout_template_pa.lo = ptemplate_address->lo;
+	req->dataout_template_pa.hi = ptemplate_address->hi;
+	status = be_mbox_notify(ctrl);
+	if (!status) {
+		struct iscsi_endpoint *ep;
+		struct beiscsi_endpoint *beiscsi_ep;
+		struct tcp_connect_and_offload_out *ptcpcnct_out =
+							embedded_payload(wrb);
+		ep = (struct iscsi_endpoint *)phba->ep_array[ptcpcnct_out->cid];
+		beiscsi_ep = ep->dd_data;
+		beiscsi_ep->fw_handle = 0;
+		beiscsi_ep->cid_vld = 1;
+		SE_DEBUG(DBG_LVL_8, "mgmt_open_connection Success\n");
+	} else {
+		SE_DEBUG(DBG_LVL_1, "mgmt_open_connection Failed\n");
+	}
+	spin_unlock(&ctrl->mbox_lock);
+	return status;
+
+}
diff --git a/drivers/scsi/beiscsi/be_mgmt.h b/drivers/scsi/beiscsi/be_mgmt.h
new file mode 100644
index 0000000..bcad26e
--- /dev/null
+++ b/drivers/scsi/beiscsi/be_mgmt.h
@@ -0,0 +1,260 @@
+/*
+ * Copyright (C) 2005 - 2009 ServerEngines
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.  The full GNU General
+ * Public License is included in this distribution in the file called COPYING.
+ *
+ * Written by: Jayamohan Kallickal (jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org)
+ *
+ * Contact Information:
+ * linux-drivers-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org
+ *
+ * ServerEngines
+ * 209 N. Fair Oaks Ave
+ * Sunnyvale, CA 94085
+ *
+ */
+
+#ifndef _BEISCSI_MGMT_
+#define _BEISCSI_MGMT_
+
+#include <linux/types.h>
+#include <linux/list.h>
+#include "be_iscsi.h"
+#include "be_main.h"
+
+/* Pseudo amap definition in which each bit of the actual structure is defined
+ * as a byte: used to calculate offset/shift/mask of each field
+ */
+struct amap_mcc_sge {
+	u8 pa_lo[32];		/* dword 0 */
+	u8 pa_hi[32];		/* dword 1 */
+	u8 length[32];		/* DWORD 2 */
+} __packed;
+
+/* Pseudo amap definition in which each bit of the actual structure is defined
+ * as a byte: used to calculate offset/shift/mask of each field
+ */
+struct amap_mcc_wrb_payload {
+	union {
+		struct amap_mcc_sge sgl[19];
+		u8 embedded[59 * 32];	/* DWORDS 57 to 115 */
+	} u;
+} __packed;
+
+/* Pseudo amap definition in which each bit of the actual structure is defined
+ * as a byte: used to calculate offset/shift/mask of each field
+ */
+struct amap_mcc_wrb {
+	u8 embedded;		/* DWORD 0 */
+	u8 rsvd0[2];		/* DWORD 0 */
+	u8 sge_count[5];	/* DWORD 0 */
+	u8 rsvd1[16];		/* DWORD 0 */
+	u8 special[8];		/* DWORD 0 */
+	u8 payload_length[32];
+	u8 tag[64];		/* DWORD 2 */
+	u8 rsvd2[32];		/* DWORD 4 */
+	struct amap_mcc_wrb_payload payload;
+
+};
+
+struct mcc_sge {
+	u32 pa_lo;		/* dword 0 */
+	u32 pa_hi;		/* dword 1 */
+	u32 length;		/* DWORD 2 */
+} __packed;
+
+struct mcc_wrb_payload {
+	union {
+		struct mcc_sge sgl[19];
+		u32 embedded[59];	/* DWORDS 57 to 115 */
+	} u;
+} __packed;
+
+#define MCC_WRB_EMBEDDED_MASK                0x00000001
+
+struct mcc_wrb {
+	u32 dw[0];		/* DWORD 0 */
+	u32 payload_length;
+	u32 tag[2];		/* DWORD 2 */
+	u32 rsvd2[1];		/* DWORD 4 */
+	struct mcc_wrb_payload payload;
+
+};
+
+unsigned char mgmt_modify_eq_delay(struct beiscsi_hba *phba,
+			unsigned int eq_id, unsigned int new_delay);
+unsigned char mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute);
+
+unsigned int mgmt_open_connection(struct beiscsi_hba *phba,
+				__be32 s_addr, __be16 sin_port,
+					unsigned short cid);
+
+unsigned char mgmt_upload_connection(struct beiscsi_hba *phba,
+			unsigned short cid, unsigned int upload_flag);
+
+unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
+				unsigned int icd, unsigned int cid);
+
+
+
+struct iscsi_invalidate_connection_params_in {
+	struct be_cmd_req_hdr hdr;
+	unsigned int session_handle;
+	unsigned short cid;
+	unsigned short unused;
+	unsigned short cleanup_type;
+	unsigned short save_cfg;
+} __packed;
+
+struct iscsi_invalidate_connection_params_out {
+	unsigned int session_handle;
+	unsigned short cid;
+	unsigned short unused;
+} __packed;
+
+union iscsi_invalidate_connection_params {
+	struct iscsi_invalidate_connection_params_in request;
+	struct iscsi_invalidate_connection_params_out response;
+} __packed;
+
+
+struct invalidate_command_table {
+	unsigned short icd;
+	unsigned short cid;
+} __packed;
+
+
+struct invalidate_commands_params_in {
+	struct be_cmd_req_hdr hdr;
+	unsigned int ref_handle;
+	unsigned int icd_count;
+	struct invalidate_command_table table[128];
+	unsigned short cleanup_type;
+	unsigned short unused;
+} __packed;
+
+struct invalidate_commands_params_out {
+	unsigned int ref_handle;
+	unsigned int icd_count;
+	unsigned int icd_status[128];
+} __packed;
+
+union invalidate_commands_params {
+	struct invalidate_commands_params_in request;
+	struct invalidate_commands_params_out response;
+} __packed;
+
+
+struct mgmt_hba_attributes {
+	u8 flashrom_version_string[32];
+	u8 manufacturer_name[32];
+	u32 supported_modes;
+	u8 seeprom_version_lo;
+	u8 seeprom_version_hi;
+	u8 rsvd0[2];
+	u32 fw_cmd_data_struct_version;
+	u32 ep_fw_data_struct_version;
+	u32 future_reserved[12];
+	u32 default_extended_timeout;
+	u8 controller_model_number[32];
+	u8 controller_description[64];
+	u8 controller_serial_number[32];
+	u8 ip_version_string[32];
+	u8 firmware_version_string[32];
+	u8 bios_version_string[32];
+	u8 redboot_version_string[32];
+	u8 driver_version_string[32];
+	u8 fw_on_flash_version_string[32];
+	u32 functionalities_supported;
+	u16 max_cdblength;
+	u8 asic_revision;
+	u8 generational_guid[16];
+	u8 hba_port_count;
+	u16 default_link_down_timeout;
+	u8 iscsi_ver_min_max;
+	u8 multifunction_device;
+	u8 cache_valid;
+	u8 hba_status;
+	u8 max_domains_supported;
+	u8 phy_port;
+	u32 firmware_post_status;
+	u32 hba_mtu[8];
+	u32 future_u32[4];
+} __packed;
+
+struct mgmt_controller_attributes {
+	struct mgmt_hba_attributes hba_attribs;
+	u16 pci_vendor_id;
+	u16 pci_device_id;
+	u16 pci_sub_vendor_id;
+	u16 pci_sub_system_id;
+	u8 pci_bus_number;
+	u8 pci_device_number;
+	u8 pci_function_number;
+	u8 interface_type;
+	u64 unique_identifier;
+	u8 netfilters;
+	u8 rsvd0[3];
+	u8 future_u32[4];
+} __packed;
+
+struct be_mgmt_controller_attributes {
+	struct be_cmd_req_hdr hdr;
+	struct mgmt_controller_attributes params;
+} __packed;
+
+struct be_mgmt_controller_attributes_resp {
+	struct be_cmd_resp_hdr hdr;
+	struct mgmt_controller_attributes params;
+} __packed;
+
+/* configuration management */
+
+#define GET_MGMT_CONTROLLER_WS(phba)    (phba->pmgmt_ws)
+
+/* MGMT CMD flags */
+
+#define MGMT_CMDH_FREE                (1<<0)
+
+
+
+/*  --- MGMT_ERROR_CODES --- */
+/*  Error Codes returned in the status field of the CMD response header */
+#define MGMT_STATUS_SUCCESS 0	/* The CMD completed without errors */
+#define MGMT_STATUS_FAILED 1	/* Error status in the Status field of */
+					/* the CMD_RESPONSE_HEADER  */
+
+
+#define ISCSI_GET_PDU_TEMPLATE_ADDRESS(pc, pa) {\
+    pa->lo = phba->init_mem[ISCSI_MEM_GLOBAL_HEADER].mem_array[0].\
+					bus_address.u.a32.address_lo;  \
+    pa->hi = phba->init_mem[ISCSI_MEM_GLOBAL_HEADER].mem_array[0].\
+					bus_address.u.a32.address_hi;  \
+}
+
+
+
+unsigned char
+	mgmt_set_fragnum_bits(struct beiscsi_hba *phba, unsigned int num_bits);
+
+struct beiscsi_endpoint {
+	struct beiscsi_hba *phba;
+	struct beiscsi_sess *sess;
+	struct beiscsi_conn *conn;
+	unsigned long dst_addr;
+	unsigned short ep_cid;
+	unsigned int fw_handle;
+	u16 dst_tcpport;
+	u16 cid_vld;
+};
+
+unsigned char mgmt_invalidate_connection(struct beiscsi_hba *phba,
+			struct beiscsi_endpoint *beiscsi_ep,
+			unsigned short cid,
+			unsigned short issue_reset,
+			unsigned short savecfg_flag);
+#endif
-- 
1.6.3


--9UV9rz0O2dU/yYYn--

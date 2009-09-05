From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 6/8] be2iscsi: iscsi hook in and handling code
Date: Sat, 5 Sep 2009 07:39:31 +0530
Message-ID: <20090905020920.GA11903@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:51601 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S934532AbZIECJd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2009 22:09:33 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

 These files contain code to interface with open-iscsi layer

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be.h       |  183 ++++++++++++
 drivers/scsi/be2iscsi/be_iscsi.c |  594 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/be2iscsi/be_iscsi.h |   73 +++++
 3 files changed, 850 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/be2iscsi/be.h
 create mode 100644 drivers/scsi/be2iscsi/be_iscsi.c
 create mode 100644 drivers/scsi/be2iscsi/be_iscsi.h

diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
new file mode 100644
index 0000000..8c973a2
--- /dev/null
+++ b/drivers/scsi/be2iscsi/be.h
@@ -0,0 +1,183 @@
+/**
+ * Copyright (C) 2005 - 2009 ServerEngines
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.  The full GNU General
+ * Public License is included in this distribution in the file called COPYING.
+ *
+ * Contact Information:
+ * linux-drivers@serverengines.com
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
+	u32 *dw = ptr;
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
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
new file mode 100644
index 0000000..5a8fa33
--- /dev/null
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -0,0 +1,594 @@
+/**
+ * Copyright (C) 2005 - 2009 ServerEngines
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.  The full GNU General
+ * Public License is included in this distribution in the file called COPYING.
+ *
+ * Written by: Jayamohan Kallickal (jayamohank@serverengines.com)
+ *
+ * Contact Information:
+ * linux-drivers@serverengines.com
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
+/**
+ * beiscsi_session_create - creates a new iscsi session
+ * @cmds_max: max commands supported
+ * @qdepth: max queue depth supported
+ * @initial_cmdsn: initial iscsi CMDSN
+ */
+struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
+						 u16 cmds_max,
+						 u16 qdepth,
+						 u32 initial_cmdsn)
+{
+	struct Scsi_Host *shost;
+	struct beiscsi_endpoint *beiscsi_ep;
+
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_session_create\n");
+
+	if (!ep) {
+		SE_DEBUG(DBG_LVL_1, "beiscsi_session_create: invalid ep \n");
+		return NULL;
+	}
+	beiscsi_ep = ep->dd_data;
+	shost = beiscsi_ep->phba->shost;
+	if (cmds_max > beiscsi_ep->phba->params.wrbs_per_cxn) {
+		shost_printk(KERN_ERR, shost, "Cannot handle %d cmds."
+			     "Max cmds per session supported is %d. Using %d. "
+			     "\n", cmds_max,
+			      beiscsi_ep->phba->params.wrbs_per_cxn,
+			      beiscsi_ep->phba->params.wrbs_per_cxn);
+		cmds_max = beiscsi_ep->phba->params.wrbs_per_cxn;
+	}
+
+	return iscsi_session_setup(&beiscsi_iscsi_transport, shost, cmds_max,
+				   sizeof(struct beiscsi_io_task),
+				   initial_cmdsn, ISCSI_MAX_TARGET);
+}
+
+/**
+ * beiscsi_conn_create - create an instance of iscsi connection
+ * @cls_session: ptr to iscsi_cls_session
+ * @cid: iscsi cid
+ */
+struct iscsi_cls_conn *
+beiscsi_conn_create(struct iscsi_cls_session *cls_session, u32 cid)
+{
+	struct beiscsi_hba *phba;
+	struct Scsi_Host *shost;
+	struct iscsi_cls_conn *cls_conn;
+	struct beiscsi_conn *beiscsi_conn;
+	struct iscsi_conn *conn;
+
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_create ,cid"
+		 "from iscsi layer=%d\n", cid);
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
+	beiscsi_conn->conn = conn;
+	return cls_conn;
+}
+
+/**
+ * beiscsi_bindconn_cid - Bind the beiscsi_conn with phba connection table
+ * @beiscsi_conn: The pointer to  beiscsi_conn structure
+ * @phba: The phba instance
+ * @cid: The cid to free
+ */
+static int beiscsi_bindconn_cid(struct beiscsi_hba *phba,
+				struct beiscsi_conn *beiscsi_conn,
+				unsigned int cid)
+{
+	if (phba->conn_table[cid]) {
+		SE_DEBUG(DBG_LVL_1,
+			 "Connection table already occupied. Detected clash\n");
+		return -EINVAL;
+	} else {
+		SE_DEBUG(DBG_LVL_8, "phba->conn_table[%d]=%p(beiscsi_conn) \n",
+			 cid, beiscsi_conn);
+		phba->conn_table[cid] = beiscsi_conn;
+	}
+	return 0;
+}
+
+/**
+ * beiscsi_conn_bind - Binds iscsi session/connection with TCP connection
+ * @cls_session: pointer to iscsi cls session
+ * @cls_conn: pointer to iscsi cls conn
+ * @transport_fd: EP handle(64 bit)
+ *
+ * This function binds the TCP Conn with iSCSI Connection and Session.
+ */
+int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
+		      struct iscsi_cls_conn *cls_conn,
+		      u64 transport_fd, int is_leading)
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
+			 "beiscsi_ep->hba=%p not equal to phba=%p \n",
+			 beiscsi_ep->phba, phba);
+		return -EEXIST;
+	}
+
+	beiscsi_conn->beiscsi_conn_cid = beiscsi_ep->ep_cid;
+	beiscsi_conn->ep = beiscsi_ep;
+	beiscsi_ep->conn = beiscsi_conn;
+	SE_DEBUG(DBG_LVL_8, "beiscsi_conn=%p conn=%p ep_cid=%d \n",
+		 beiscsi_conn, conn, beiscsi_ep->ep_cid);
+	return beiscsi_bindconn_cid(phba, beiscsi_conn, beiscsi_ep->ep_cid);
+}
+
+/**
+ * beiscsi_conn_get_param - get the iscsi parameter
+ * @cls_conn: pointer to iscsi cls conn
+ * @param: parameter type identifier
+ * @buf: buffer pointer
+ *
+ * returns iscsi parameter
+ */
+int beiscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
+			   enum iscsi_param param, char *buf)
+{
+	struct beiscsi_endpoint *beiscsi_ep;
+	struct iscsi_conn *conn = cls_conn->dd_data;
+	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
+	int len = 0;
+
+	beiscsi_ep = beiscsi_conn->ep;
+	if (!beiscsi_ep) {
+		SE_DEBUG(DBG_LVL_1,
+			 "In beiscsi_conn_get_param , no beiscsi_ep\n");
+		return -1;
+	}
+
+	switch (param) {
+	case ISCSI_PARAM_CONN_PORT:
+		len = sprintf(buf, "%hu\n", beiscsi_ep->dst_tcpport);
+		break;
+	case ISCSI_PARAM_CONN_ADDRESS:
+		if (beiscsi_ep->ip_type == BE2_IPV4)
+			len = sprintf(buf, "%pI4\n", &beiscsi_ep->dst_addr);
+		else
+			len = sprintf(buf, "%pI6\n", &beiscsi_ep->dst6_addr);
+		break;
+	default:
+		return iscsi_conn_get_param(cls_conn, param, buf);
+	}
+	return len;
+}
+
+int beiscsi_set_param(struct iscsi_cls_conn *cls_conn,
+		      enum iscsi_param param, char *buf, int buflen)
+{
+	struct iscsi_conn *conn = cls_conn->dd_data;
+	struct iscsi_session *session = conn->session;
+	int ret;
+
+	ret = iscsi_set_param(cls_conn, param, buf, buflen);
+	if (ret)
+		return ret;
+	/*
+	 * If userspace tried to set the value to higher than we can
+	 * support override here.
+	 */
+	switch (param) {
+	case ISCSI_PARAM_FIRST_BURST:
+		if (session->first_burst > 8192)
+			session->first_burst = 8192;
+		break;
+	case ISCSI_PARAM_MAX_RECV_DLENGTH:
+		if (conn->max_recv_dlength > 65536)
+			conn->max_recv_dlength = 65536;
+		break;
+	case ISCSI_PARAM_MAX_BURST:
+		if (session->first_burst > 262144)
+			session->first_burst = 262144;
+		break;
+	default:
+		return 0;
+	}
+
+	return 0;
+}
+
+/**
+ * beiscsi_get_host_param - get the iscsi parameter
+ * @shost: pointer to scsi_host structure
+ * @param: parameter type identifier
+ * @buf: buffer pointer
+ *
+ * returns host parameter
+ */
+int beiscsi_get_host_param(struct Scsi_Host *shost,
+			   enum iscsi_host_param param, char *buf)
+{
+	struct beiscsi_hba *phba = (struct beiscsi_hba *)iscsi_host_priv(shost);
+	int len = 0;
+
+	switch (param) {
+	case ISCSI_HOST_PARAM_HWADDRESS:
+		be_cmd_get_mac_addr(&phba->ctrl, phba->mac_address);
+		len = sysfs_format_mac(buf, phba->mac_address, ETH_ALEN);
+		break;
+	default:
+		return iscsi_host_get_param(shost, param, buf);
+	}
+	return len;
+}
+
+/**
+ * beiscsi_conn_get_stats - get the iscsi stats
+ * @cls_conn: pointer to iscsi cls conn
+ * @stats: pointer to iscsi_stats structure
+ *
+ * returns iscsi stats
+ */
+void beiscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn,
+			    struct iscsi_stats *stats)
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
+/**
+ * beiscsi_set_params_for_offld - get the parameters for offload
+ * @beiscsi_conn: pointer to beiscsi_conn
+ * @params: pointer to offload_params structure
+ */
+static void  beiscsi_set_params_for_offld(struct beiscsi_conn *beiscsi_conn,
+					  struct beiscsi_offload_params *params)
+{
+	struct iscsi_conn *conn = beiscsi_conn->conn;
+	struct iscsi_session *session = conn->session;
+
+	AMAP_SET_BITS(struct amap_beiscsi_offload_params, max_burst_length,
+		      params, session->max_burst);
+	AMAP_SET_BITS(struct amap_beiscsi_offload_params,
+		      max_send_data_segment_length, params,
+		      conn->max_xmit_dlength);
+	AMAP_SET_BITS(struct amap_beiscsi_offload_params, first_burst_length,
+		      params, session->first_burst);
+	AMAP_SET_BITS(struct amap_beiscsi_offload_params, erl, params,
+		      session->erl);
+	AMAP_SET_BITS(struct amap_beiscsi_offload_params, dde, params,
+		      conn->datadgst_en);
+	AMAP_SET_BITS(struct amap_beiscsi_offload_params, hde, params,
+		      conn->hdrdgst_en);
+	AMAP_SET_BITS(struct amap_beiscsi_offload_params, ir2t, params,
+		      session->initial_r2t_en);
+	AMAP_SET_BITS(struct amap_beiscsi_offload_params, imd, params,
+		      session->imm_data_en);
+	AMAP_SET_BITS(struct amap_beiscsi_offload_params, exp_statsn, params,
+		      (conn->exp_statsn - 1));
+}
+
+/**
+ * beiscsi_conn_start - offload of session to chip
+ * @cls_conn: pointer to beiscsi_conn
+ */
+int beiscsi_conn_start(struct iscsi_cls_conn *cls_conn)
+{
+	struct iscsi_conn *conn = cls_conn->dd_data;
+	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
+	struct beiscsi_endpoint *beiscsi_ep;
+	struct beiscsi_offload_params params;
+	struct iscsi_session *session = conn->session;
+	struct Scsi_Host *shost = iscsi_session_to_shost(session->cls_session);
+	struct beiscsi_hba *phba = iscsi_host_priv(shost);
+
+	memset(&params, 0, sizeof(struct beiscsi_offload_params));
+	beiscsi_ep = beiscsi_conn->ep;
+	if (!beiscsi_ep)
+		SE_DEBUG(DBG_LVL_1, "In beiscsi_conn_start , no beiscsi_ep\n");
+
+	free_mgmt_sgl_handle(phba, beiscsi_conn->plogin_sgl_handle);
+	beiscsi_conn->login_in_progress = 0;
+	beiscsi_set_params_for_offld(beiscsi_conn, &params);
+	beiscsi_offload_connection(beiscsi_conn, &params);
+	iscsi_conn_start(cls_conn);
+	return 0;
+}
+
+/**
+ * beiscsi_get_cid - Allocate a cid
+ * @phba: The phba instance
+ */
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
+	return cid;
+}
+
+/**
+ * beiscsi_open_conn - Ask FW to open a TCP connection
+ * @ep:	endpoint to be used
+ * @src_addr: The source IP address
+ * @dst_addr: The Destination  IP address
+ *
+ * Asks the FW to open a TCP connection
+ */
+static int beiscsi_open_conn(struct iscsi_endpoint *ep,
+			     struct sockaddr *src_addr,
+			     struct sockaddr *dst_addr, int non_blocking)
+{
+	struct beiscsi_endpoint *beiscsi_ep = ep->dd_data;
+	struct beiscsi_hba *phba = beiscsi_ep->phba;
+	int ret = -1;
+
+	beiscsi_ep->ep_cid = beiscsi_get_cid(phba);
+	if (beiscsi_ep->ep_cid == 0xFFFF) {
+		SE_DEBUG(DBG_LVL_1, "No free cid available\n");
+		return ret;
+	}
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_open_conn, ep_cid=%d ",
+		 beiscsi_ep->ep_cid);
+	phba->ep_array[beiscsi_ep->ep_cid] = ep;
+	if (beiscsi_ep->ep_cid >
+	    (phba->fw_config.iscsi_cid_start + phba->params.cxns_per_ctrl)) {
+		SE_DEBUG(DBG_LVL_1, "Failed in allocate iscsi cid\n");
+		return ret;
+	}
+
+	beiscsi_ep->cid_vld = 0;
+	return mgmt_open_connection(phba, dst_addr, beiscsi_ep);
+}
+
+/**
+ * beiscsi_put_cid - Free the cid
+ * @phba: The phba for which the cid is being freed
+ * @cid: The cid to free
+ */
+static void beiscsi_put_cid(struct beiscsi_hba *phba, unsigned short cid)
+{
+	phba->avlbl_cids++;
+	phba->cid_array[phba->cid_free++] = cid;
+	if (phba->cid_free == phba->params.cxns_per_ctrl)
+		phba->cid_free = 0;
+}
+
+/**
+ * beiscsi_free_ep - free endpoint
+ * @ep:	pointer to iscsi endpoint structure
+ */
+static void beiscsi_free_ep(struct iscsi_endpoint *ep)
+{
+	struct beiscsi_endpoint *beiscsi_ep = ep->dd_data;
+	struct beiscsi_hba *phba = beiscsi_ep->phba;
+
+	beiscsi_put_cid(phba, beiscsi_ep->ep_cid);
+	beiscsi_ep->phba = NULL;
+	iscsi_destroy_endpoint(ep);
+}
+
+/**
+ * beiscsi_ep_connect - Ask chip to create TCP Conn
+ * @scsi_host: Pointer to scsi_host structure
+ * @dst_addr: The IP address of Target
+ * @non_blocking: blocking or non-blocking call
+ *
+ * This routines first asks chip to create a connection and then allocates an EP
+ */
+struct iscsi_endpoint *
+beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
+		   int non_blocking)
+{
+	struct beiscsi_hba *phba;
+	struct beiscsi_endpoint *beiscsi_ep;
+	struct iscsi_endpoint *ep;
+	int ret;
+
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_ep_connect \n");
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
+/**
+ * beiscsi_ep_poll - Poll to see if connection is established
+ * @ep:	endpoint to be used
+ * @timeout_ms: timeout specified in millisecs
+ *
+ * Poll to see if TCP connection established
+ */
+int beiscsi_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
+{
+	struct beiscsi_endpoint *beiscsi_ep = ep->dd_data;
+
+	SE_DEBUG(DBG_LVL_8, "In  beiscsi_ep_poll\n");
+	if (beiscsi_ep->cid_vld == 1)
+		return 1;
+	else
+		return 0;
+}
+
+/**
+ * beiscsi_close_conn - Upload the  connection
+ * @ep: The iscsi endpoint
+ * @flag: The type of connection closure
+ */
+static int beiscsi_close_conn(struct iscsi_endpoint *ep, int flag)
+{
+	int ret = 0;
+	struct beiscsi_endpoint *beiscsi_ep = ep->dd_data;
+	struct beiscsi_hba *phba = beiscsi_ep->phba;
+
+	if (MGMT_STATUS_SUCCESS !=
+	    mgmt_upload_connection(phba, beiscsi_ep->ep_cid,
+		CONNECTION_UPLOAD_GRACEFUL)) {
+		SE_DEBUG(DBG_LVL_8, "upload failed for cid 0x%x",
+			 beiscsi_ep->ep_cid);
+		ret = -1;
+	}
+
+	return ret;
+}
+
+/**
+ * beiscsi_ep_disconnect - Tears down the TCP connection
+ * @ep:	endpoint to be used
+ *
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
+		iscsi_suspend_queue(beiscsi_conn->conn);
+		beiscsi_close_conn(ep, flag);
+	}
+
+	beiscsi_free_ep(ep);
+}
+
+/**
+ * beiscsi_unbind_conn_to_cid - Unbind the beiscsi_conn from phba conn table
+ * @phba: The phba instance
+ * @cid: The cid to free
+ */
+static int beiscsi_unbind_conn_to_cid(struct beiscsi_hba *phba,
+				      unsigned int cid)
+{
+	if (phba->conn_table[cid])
+		phba->conn_table[cid] = NULL;
+	else {
+		SE_DEBUG(DBG_LVL_8, "Connection table Not occupied. \n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/**
+ * beiscsi_conn_stop - Invalidate and stop the connection
+ * @cls_conn: pointer to get iscsi_conn
+ * @flag: The type of connection closure
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
+	unsigned short savecfg_flag = CMD_ISCSI_SESSION_SAVE_CFG_ON_FLASH;
+
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_stop\n");
+	beiscsi_ep = beiscsi_conn->ep;
+	if (!beiscsi_ep) {
+		SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_stop , no beiscsi_ep\n");
+		return;
+	}
+	status = mgmt_invalidate_connection(phba, beiscsi_ep,
+					    beiscsi_ep->ep_cid, 1,
+					    savecfg_flag);
+	if (status != MGMT_STATUS_SUCCESS) {
+		SE_DEBUG(DBG_LVL_1,
+			 "mgmt_invalidate_connection Failed for cid=%d \n",
+			 beiscsi_ep->ep_cid);
+	}
+	beiscsi_unbind_conn_to_cid(phba, beiscsi_ep->ep_cid);
+	iscsi_conn_stop(cls_conn, flag);
+}
diff --git a/drivers/scsi/be2iscsi/be_iscsi.h b/drivers/scsi/be2iscsi/be_iscsi.h
new file mode 100644
index 0000000..fab16fd
--- /dev/null
+++ b/drivers/scsi/be2iscsi/be_iscsi.h
@@ -0,0 +1,73 @@
+/**
+ * Copyright (C) 2005 - 2009 ServerEngines
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.  The full GNU General
+ * Public License is included in this distribution in the file called COPYING.
+ *
+ * Written by: Jayamohan Kallickal (jayamohank@serverengines.com)
+ *
+ * Contact Information:
+ * linux-drivers@serverengines.com
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
+#define BE2_IPV4  0x1
+#define BE2_IPV6  0x10
+
+void beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
+				struct beiscsi_offload_params *params);
+
+void beiscsi_offload_iscsi(struct beiscsi_hba *phba, struct iscsi_conn *conn,
+			   struct beiscsi_conn *beiscsi_conn,
+			   unsigned int fw_handle);
+
+struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
+						 uint16_t cmds_max,
+						 uint16_t qdepth,
+						 uint32_t initial_cmdsn);
+
+struct iscsi_cls_conn *beiscsi_conn_create(struct iscsi_cls_session
+					   *cls_session, uint32_t cid);
+
+int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
+		      struct iscsi_cls_conn *cls_conn,
+		      uint64_t transport_fd, int is_leading);
+
+int beiscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
+			   enum iscsi_param param, char *buf);
+
+int beiscsi_get_host_param(struct Scsi_Host *shost,
+			   enum iscsi_host_param param, char *buf);
+
+int beiscsi_set_param(struct iscsi_cls_conn *cls_conn,
+		      enum iscsi_param param, char *buf, int buflen);
+
+int beiscsi_conn_start(struct iscsi_cls_conn *cls_conn);
+
+void beiscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag);
+
+struct iscsi_endpoint *beiscsi_ep_connect(struct Scsi_Host *shost,
+					  struct sockaddr *dst_addr,
+					  int non_blocking);
+
+int beiscsi_ep_poll(struct iscsi_endpoint *ep, int timeout_ms);
+
+void beiscsi_ep_disconnect(struct iscsi_endpoint *ep);
+
+void beiscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn,
+			    struct iscsi_stats *stats);
+
+#endif
-- 
1.6.4


From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 09/10] mlx4_fc: Implement fcoe/fcoib offload driver,
 fcoib initialization protocol driver
Date: Mon, 16 Aug 2010 15:16:53 -0700
Message-ID: <4C69B8D5.20908@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080309050801090905020009"
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Linux SCSI <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080309050801090905020009
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------080309050801090905020009
Content-Type: text/x-patch;
 name="0009-mlx4_fc-Implement-fcoe-fcoib-offload-driver-fcoib-in.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0009-mlx4_fc-Implement-fcoe-fcoib-offload-driver-fcoib-in.pa";
 filename*1="tch"

>From 0b10d95be067595dbb050d3cc2c779372038aec4 Mon Sep 17 00:00:00 2001
From: Vu Pham <vu-OnC3O1emZK9LiOotz6YBiwC/G2K4zDHf@public.gmane.org>
Date: Mon, 16 Aug 2010 14:47:34 -0700
Subject: [PATCH 09/10] mlx4_fc: Implement fcoe/fcoib offload driver, fcoib initialization protocol driver

Implement fcoe/fcoib offload driver. The driver utilizes mlx4_device to
completely offload SCSI operations, and FC-CRC calculations.

Implement mlx4_fcoib driver which uses FIP-alike protocol to discover
BridgeX gateways in the Infiniband fabric

Signed-off-by: Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/scsi/mlx4_fc/Makefile         |    8 +
 drivers/scsi/mlx4_fc/fcoib.h          |  343 ++++++
 drivers/scsi/mlx4_fc/fcoib_api.h      |   61 +
 drivers/scsi/mlx4_fc/fcoib_discover.c | 1925 +++++++++++++++++++++++++++++++
 drivers/scsi/mlx4_fc/fcoib_main.c     | 1211 ++++++++++++++++++++
 drivers/scsi/mlx4_fc/mfc.c            | 2003 +++++++++++++++++++++++++++++++++
 drivers/scsi/mlx4_fc/mfc.h            |  666 +++++++++++
 drivers/scsi/mlx4_fc/mfc_exch.c       | 1496 ++++++++++++++++++++++++
 drivers/scsi/mlx4_fc/mfc_rfci.c       | 1001 ++++++++++++++++
 drivers/scsi/mlx4_fc/mfc_sysfs.c      |  244 ++++
 10 files changed, 8958 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/mlx4_fc/Makefile
 create mode 100644 drivers/scsi/mlx4_fc/fcoib.h
 create mode 100644 drivers/scsi/mlx4_fc/fcoib_api.h
 create mode 100644 drivers/scsi/mlx4_fc/fcoib_discover.c
 create mode 100644 drivers/scsi/mlx4_fc/fcoib_main.c
 create mode 100644 drivers/scsi/mlx4_fc/mfc.c
 create mode 100644 drivers/scsi/mlx4_fc/mfc.h
 create mode 100644 drivers/scsi/mlx4_fc/mfc_exch.c
 create mode 100644 drivers/scsi/mlx4_fc/mfc_rfci.c
 create mode 100644 drivers/scsi/mlx4_fc/mfc_sysfs.c

diff --git a/drivers/scsi/mlx4_fc/Makefile b/drivers/scsi/mlx4_fc/Makefile
new file mode 100644
index 0000000..9109483
--- /dev/null
+++ b/drivers/scsi/mlx4_fc/Makefile
@@ -0,0 +1,8 @@
+obj-m += mlx4_fc.o
+mlx4_fc-y := mfc.o \
+	mfc_rfci.o \
+	mfc_exch.o \
+	mfc_sysfs.o
+
+obj-m += mlx4_fcoib.o
+mlx4_fcoib-y := fcoib_main.o fcoib_discover.o
diff --git a/drivers/scsi/mlx4_fc/fcoib.h b/drivers/scsi/mlx4_fc/fcoib.h
new file mode 100644
index 0000000..1c94275
--- /dev/null
+++ b/drivers/scsi/mlx4_fc/fcoib.h
@@ -0,0 +1,343 @@
+/*
+ * Copyright (c) 2010 Mellanox Technologies. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef MLX4_FCOIB_H
+#define MLX4_FCOIB_H
+
+#include <linux/netdevice.h>
+#include <linux/in.h>
+#include <net/dst.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_pack.h>
+#include <rdma/ib_sa.h>
+#include <linux/delay.h>
+#include <linux/kthread.h>
+#include <linux/workqueue.h>
+#include <linux/version.h>
+
+struct fip_dev_priv;
+
+/* Extern Variables */
+extern int fip_debug;
+extern struct workqueue_struct *fip_workqueue;
+
+/* definitions */
+#define DRV_NAME  "mlx4_fcoib"
+
+#define	FIP_OP_RECV	(1ul << 31)
+#define FIP_UD_MTU(ib_mtu)	(ib_mtu - FIP_ENCAP_LEN - FIP_ETH_HEADER_LEN)
+#define FIP_UD_BUF_SIZE(ib_mtu)	(ib_mtu + IB_GRH_BYTES)
+#define	FIP_MAX_BACKOFF_SECONDS	16
+#define	FIP_MAX_VHBAS_PER_GW	256
+#define FIP_DISCOVER_NUM_MCAST		2
+
+#define VHBAS_BITMASK	(FIP_MAX_VHBAS_PER_GW / 8 / sizeof(unsigned long))
+#define DELAYED_WORK_CLEANUP_JIFFS	2
+
+enum debug_print_level {
+	LOG_PRIO_HIGH = 1,
+	LOG_PRIO_MED = 2,
+	LOG_PRIO_LOW = 3,
+	LOG_PRIO_VERY_LOW = 4
+};
+
+#define fip_printk(level, priv, format, arg...)			\
+	printk(level "mlx4_fcoib: %s:%d: " format,		\
+		((struct fip_dev_priv *) priv)->ca->name,	\
+		((struct fip_dev_priv *) priv)->port, ## arg)
+
+#define fip_warn(priv, format, arg...)				\
+	fip_printk(KERN_WARNING, priv, format , ## arg)
+
+#define fip_dbg(priv, level, format, arg...)			\
+	if (fip_debug >= level)					\
+		fip_printk(KERN_WARNING, priv, format , ## arg)
+
+struct fip_mcast {
+	struct login_ctx *login;
+	char name[ETH_ALEN * 2 + IFNAMSIZ];
+	u8 mac[ETH_ALEN];
+	int vid;
+	union ib_gid gid;
+	u8 rss;
+	struct rb_node rb_node;
+	struct mcast_entry *mcast_data;
+};
+
+struct port_mcast_data {
+	struct list_head multicast_list;
+	struct delayed_work mcast_task;
+	struct mutex mlock;
+	unsigned long flags;
+
+	u8 port;
+	struct ib_pd *pd;
+	union ib_gid local_gid;
+	unsigned int mcast_mtu;
+	int rate;
+	struct ib_device *ca;
+};
+
+enum mcast_join_state {
+	MCAST_FLAG_USED = 0,
+	MCAST_FLAG_SEND = 1,
+	MCAST_FLAG_RECV = 2,
+	MCAST_FLAG_BUSY = 3,
+	MCAST_FLAG_JOINED = 4,
+	MCAST_FLAG_DONE = 5,
+	MCAST_FLAG_ATTACHED = 6,
+	MCAST_FLAG_AH_SET = 7,
+	MCAST_FLAG_REMOVED = 8
+};
+
+enum mcast_join_type {
+	MCAST_SEND_RECEIVE = 0,
+	MCAST_RECEIVE_ONLY = 1,
+	MCAST_SEND_ONLY = 2,
+};
+
+enum {
+	MCAST_TASK_RUN = 1,
+	MCAST_TASK_STOPPED = 2,
+};
+
+struct mcast_entry {
+	struct ib_sa_multicast *sa_mcast;
+	struct ib_sa_mcmember_rec mcmember;
+	struct list_head list;
+	unsigned long flags;
+	struct ib_ah *ah;
+	struct port_mcast_data *port_mcast;
+	atomic_t ref_cnt;
+	int backoff;
+	void (*callback) (struct mcast_entry *, void *context);
+	void *context;
+	struct ib_qp *qp;
+	u32 qkey;
+	u32 pkey;
+};
+
+enum {
+	FIP_ETH_HEADER_LEN = 14,
+	FIP_ENCAP_LEN = 4,
+	FIP_PROTOCOL_RX_SIZE = 64,	/* must be power of 2 */
+	FIP_PROTOCOL_TX_SIZE = 64,	/* must be power of 2 */
+};
+
+enum fip_packet_type {
+	FIP_DISCOVER_UCAST = 0,
+	FIP_DISCOVER_MCAST = 1
+};
+
+struct ring_entry {
+	char *mem;
+	u64 bus_addr;
+	int length;
+};
+
+struct ring {
+	int size;
+	struct ring_entry *ring;
+	int head;
+	int tail;
+};
+
+enum fip_discover_state {
+	FIP_DISCOVER_OFF,
+	FIP_DISCOVER_INIT,
+	FIP_DISCOVER_SOLICIT,
+	FIP_DISCOVER_LOGIN
+};
+
+struct fip_discover {
+	spinlock_t lock;
+	struct list_head gw_list;
+	struct list_head gw_rm_list;
+	enum fip_discover_state state;
+	int flush;
+	struct semaphore flush_done;
+	struct ib_cq *cq;
+	struct ib_qp *qp;
+	struct ring rx_ring;
+	struct ring tx_ring;
+
+	u16 pkey;
+	u16 pkey_index;
+	struct delayed_work task;
+	struct delayed_work cleanup_task;
+	struct work_struct pkt_rcv_task;
+	struct work_struct mcast_refresh_task;
+
+	int mcast_dest_mask;
+	struct mcast_entry *mcast[FIP_DISCOVER_NUM_MCAST];
+
+	int backoff_time;
+};
+
+enum fip_gw_state {
+	FIP_GW_RESET,
+	FIP_GW_RCVD_UNSOL_AD,
+	FIP_GW_SENT_SOL,
+	FIP_GW_RCVD_SOL_AD,
+	FIP_GW_WAITING_FOR_FLOGI,
+	FIP_GW_SENT_FLOGI,
+	FIP_GW_RCVD_FLOGI_ACCPT,
+};
+
+struct fip_gw_data_info {
+	int flags;
+	u32 gw_qpn;
+	u16 gw_lid;
+	u16 gw_port_id;
+	u16 gw_num_vnics;
+	u8 gw_guid[8];
+	u8 switch_name[8];
+	u8 fabric_name[8];
+	u32 keep_alive_frq;
+	u8 gw_vendor_id[9];
+	u8 priority;
+	u16 pkey;
+	u8 sl;
+};
+
+struct fip_gw_data {
+	int flush;
+	struct fip_dev_priv *priv;
+	struct list_head list;
+	enum fip_gw_state state;
+	struct list_head fip_destroy;
+	struct delayed_work gw_task;
+	struct delayed_work fip_cleanup_task;
+	struct fip_gw_data_info info;
+	struct fip_gw_data_info *new_gw_data;	/* used for GW modification */
+	unsigned long bitmask[VHBAS_BITMASK];
+
+	/* vHBA info - currently support single vHBA per gw */
+	u64 fc_handle;
+
+	/* unified timers */
+	unsigned long vhba_ka_tmr;
+	int vhba_ka_tmr_valid;
+	unsigned long gw_ka_tmr;
+	int gw_ka_tmr_valid;
+	unsigned long host_ka_tmr;
+	int host_ka_tmr_valid;
+};
+
+enum fip_gw_data_flags {
+	FIP_IS_FIP = 1,		/* protocol type */
+	FIP_RCV_MULTICAST = 1 << 1,	/* received mcast packet */
+	FIP_GW_AVAILABLE = 1 << 2,	/* GW available bit set in pkt */
+	FIP_HOST_ASSIGNED_VLAN = 1 << 3	/* H bit set in advertise pkt */
+};
+
+struct fip_dev_priv {
+	spinlock_t lock;
+	struct mutex mlock;
+	struct fip_discover discover;
+	struct port_mcast_data mcast;
+
+	struct delayed_work restart_task;
+	struct ib_device *ca;
+	u8 port;
+	u16 pkey;
+	u16 pkey_index;
+	struct ib_pd *pd;
+	struct ib_mr *mr;
+	union ib_gid local_gid;
+	u16 local_lid;
+
+	int max_mtu_enum;
+	unsigned int mtu;
+	unsigned int mcast_mtu;
+	int rate;
+	unsigned int max_ib_mtu;
+	struct ib_event_handler event_handler;
+	struct list_head list;
+
+	int hca_caps;
+
+};
+
+/*
+ * send a single multicast packet.
+ */
+int fip_mcast_send(struct fip_dev_priv *priv, struct ib_qp *qp,
+		   unsigned int wr_id, u64 mapping, int size,
+		   u16 pkey_index, struct mcast_entry *mcast);
+/*
+ * send a single unicast packet.
+ */
+int fip_ucast_send(struct fip_dev_priv *priv, struct ib_qp *qp,
+		   unsigned int wr_id, u64 mapping, int size,
+		   u16 pkey_index, u32 dest_qpn, u16 dlid, u32 qkey);
+
+int fip_init_qp(struct fip_dev_priv *priv, struct ib_qp *qp,
+		u16 pkey_index, u32 qkey);
+int fip_post_receive(struct fip_dev_priv *priv, struct ib_qp *qp, int size,
+		     int id, char *mem, struct ring_entry *mem_entry);
+
+void fip_flush_rings(struct fip_dev_priv *priv, struct ib_cq *cq,
+		     struct ib_qp *qp, struct ring *rx, struct ring *tx);
+void fip_free_rings(struct fip_dev_priv *p, struct ring *rx, struct ring *tx);
+
+int fip_init_tx(struct fip_dev_priv *priv, int size, struct ring *tx_ring);
+int fip_init_rx(struct fip_dev_priv *priv, int size,
+		struct ib_qp *qp, struct ring *rx_ring);
+int fip_comp(struct fip_dev_priv *priv, struct ib_cq *cq,
+	     struct ring *rx_ring, struct ring *tx_ring);
+void fip_discover_comp(struct ib_cq *cq, void *dev_ptr);
+void fip_discover_fsm(struct work_struct *work);
+int fip_discover_rx_packet(struct fip_dev_priv *priv, int index);
+void fip_discover_process_rx(struct work_struct *work);
+
+void fip_discover_mcast_connect_cb(struct mcast_entry *mcast,
+				   void *discover_context);
+struct mcast_entry *fip_mcast_join(struct port_mcast_data *port_mcast,
+				    void *context, const char *mgid, u32 qkey,
+				    u16 pkey, struct ib_qp *qp,
+				    enum mcast_join_type type,
+				    void (*callback) (struct mcast_entry *,
+						      void *context));
+void fip_mcast_free(struct mcast_entry *mcast);
+int fip_mcast_stop_thread(struct port_mcast_data *port_mcast);
+void fip_mcast_join_task(struct work_struct *work);
+
+int fip_free_gw_list(struct fip_dev_priv *priv);
+void fip_refresh_mcasts(struct work_struct *work);
+
+int fip_dev_init(struct fip_dev_priv *priv);
+void fip_dev_cleanup(struct fip_dev_priv *priv);
+int fip_discover_init(struct fip_dev_priv *priv);
+void fip_discover_cleanup(struct fip_dev_priv *priv);
+
+#endif /* MLX4_FCOIB_H */
diff --git a/drivers/scsi/mlx4_fc/fcoib_api.h b/drivers/scsi/mlx4_fc/fcoib_api.h
new file mode 100644
index 0000000..945516b
--- /dev/null
+++ b/drivers/scsi/mlx4_fc/fcoib_api.h
@@ -0,0 +1,61 @@
+/*
+ * Copyright (c) 2010 Mellanox Technologies. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef FCOIB_API_H
+#define FCOIB_API_H
+
+/* This .h file is used to integrate the mlx4_fc module with
+ * the FCoIB discovery module.
+ *
+ * mlx4_fc will implement these functions.
+ */
+
+struct ib_device;
+
+enum els_over_fip_type {
+	FLOGI_OVER_FIP = 0,
+	LOGO_OVER_FIP = 1,
+};
+
+typedef int (*fcoib_send_els_cb) (u64 gw_discovery_handle, u64 gw_fc_handle,
+				  enum els_over_fip_type type,
+				  u8 *els, u32 host_data_qpn);
+int fcoib_create_vhba(struct ib_device *ib_device, u8 port_num,
+		      unsigned int mtu, u16 gw_lid, u8 sl,
+		      u64 gw_disc_hl, fcoib_send_els_cb send_els_cb,
+		      u64 wwpn, u64 wwnn);
+int fcoib_recvd_flogi_reply(u64 gw_fc_handle, u8 *flogi_reply,
+			    int size, u32 gw_data_qpn);
+void fcoib_destroy_vhba(u64 gw_fc_handle);
+void fcoib_get_vhba_fcid(u64 gw_fc_handle, uint8_t *fcid);
+
+#endif /* FCOIB_API_H */
diff --git a/drivers/scsi/mlx4_fc/fcoib_discover.c b/drivers/scsi/mlx4_fc/fcoib_discover.c
new file mode 100644
index 0000000..ee57d76
--- /dev/null
+++ b/drivers/scsi/mlx4_fc/fcoib_discover.c
@@ -0,0 +1,1925 @@
+/*
+ * Copyright (c) 2010 Mellanox Technologies. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/delay.h>
+#include <rdma/ib_verbs.h>
+
+#include "fcoib.h"
+#include "fcoib_api.h"
+
+/* string "Mellanox" */
+#define FIP_VENDOR_MELLANOX {0x4d, 0x65, 0x6c, 0x6c, \
+			     0x61, 0x6e, 0x6f, 0x78}
+
+#define FIP_TEST_PKT_LENGTH(length, type)				\
+	if ((length) != sizeof(type) + IB_GRH_BYTES) {			\
+		fip_dbg(priv, LOG_PRIO_LOW, "Dump packet: at=%d"	\
+			" unexpected size. length=%d expected=%d\n",	\
+			__LINE__, (int)length,				\
+			(int)(sizeof(type) + IB_GRH_BYTES));		\
+		return -EINVAL;						\
+	}
+
+struct fip_fcoib_ver {
+	u8 version;
+	u8 reserved[3];
+};
+
+struct fip_fip_type {
+	u8 type;
+	u8 length;
+	u8 reserved[2];
+};
+
+struct fip_fip_header {
+	u16 opcode;
+	u8 reserved;
+	u8 subcode;
+	u16 list_length;
+	u16 flags;
+	struct fip_fip_type type;
+	u8 vendor_id[8];
+};
+
+struct fcoib_solicit {
+	struct fip_fcoib_ver version;
+	struct fip_fip_header fip;
+
+	u8 infiniband_address_type_f;
+	u8 infiniband_address_length_f;
+	u16 _reserved_1;
+	u8 t10_vendor_id[8];
+	u32 qpn;
+	u16 sl_gwPortId;
+	u16 lid;
+	u8 gw_guid[8];
+
+	u8 fip_name_id_type_f;
+	u8 fip_name_id_length_f;
+	u16 _reserved_2;
+	u8 node_name[8];
+
+	u8 max_receive_size_type_f;
+	u8 max_receive_size_length_f;
+	u16 max_fcoe_size;
+};
+
+struct fcoib_advertise {
+	struct fip_fcoib_ver version;
+	struct fip_fip_header fip;
+
+	u8 fip_priority_type_f;
+	u8 fip_priority_length_f;
+	u8 _reserved_1;
+	u8 priority;
+
+	u8 infiniband_address_type_f;
+	u8 infiniband_address_length_f;
+	u16 _reserved_2;
+	u8 t10_vendor_id[8];
+	u32 qpn;
+	u16 sl_gwportid;
+	u16 lid;
+	u8 gw_guid[8];
+
+	u8 fip_name_identifier_type_f;
+	u8 fip_name_identifier_length_f;
+	u16 _reserved_3;
+	u8 switch_name[8];
+
+	u8 fip_fabric_name_type_f;
+	u8 fip_fabric_name_length_f;
+	u16 _reserved_4;
+	u32 fc_map;
+	u8 fabric_name[8];
+
+	u8 fka_adv_period_type_f;
+	u8 fka_adv_period_length_f;
+	u16 _reserved_5;
+	u32 fka_adv_period;
+
+	u8 partition_type_f;
+	u8 partition_length_f;
+	u16 reserved_6;
+	u8 t10_vendor_id_2[8];
+	u16 reserved_7;
+	u16 pkey;
+};
+
+#define FLOGI_FDISC_REQUEST_SIZE (35 * 4)
+#define FLOGI_FDISC_ACCPT_SIZE (35 * 4)
+#define FLOGI_FDISC_RJCT_SIZE (8 * 4)
+
+struct fcoib_flogi_fdisc_request {
+	struct fip_fcoib_ver version;
+	struct fip_fip_header fip;
+
+	u8 els_type_f;
+	u8 els_length_f;
+	u16 _reserved_;
+	u8 els[FLOGI_FDISC_REQUEST_SIZE];
+
+	u8 infiniband_address_type_f;
+	u8 infiniband_address_length_f;
+	u16 reserved;
+	u8 t10_vendor_id[8];
+	u32 qpn;
+	u16 sl_gwportid;
+	u16 lid;
+	u8 port_guid[8];
+};
+
+struct fcoib_flogi_fdisc_acc {
+	struct fip_fcoib_ver version;
+	struct fip_fip_header fip;
+
+	u8 els_type_f;
+	u8 els_length_f;
+	u16 _reserved_;
+	u8 els[FLOGI_FDISC_ACCPT_SIZE];
+
+	u8 infiniband_address_type_f;
+	u8 infiniband_address_length_f;
+	u16 reserved;
+	u8 t10_vendor_id[8];
+	u32 qpn;
+	u16 sl_gwPortId;
+	u16 lid;
+	u8 port_guid[8];
+};
+
+struct fcoib_flogi_fdisc_rjt {
+	struct fip_fcoib_ver version;
+	struct fip_fip_header fip;
+
+	u8 els_type_f;
+	u8 els_length_f;
+	u16 _reserved_;
+	u8 els[FLOGI_FDISC_RJCT_SIZE];
+};
+
+#define LOGO_REQUEST_SIZE (10 * 4)
+#define LOGO_ACCPT_SIZE (9 * 4)
+#define LOGO_RJCT_SIZE (8 * 4)
+
+struct fcoib_logo_request {
+	struct fip_fcoib_ver version;
+	struct fip_fip_header fip;
+
+	u8 els_type_f;
+	u8 els_length_f;
+	u16 _reserved_;
+	u8 els[LOGO_REQUEST_SIZE];
+
+	u8 infiniband_address_type_f;
+	u8 infiniband_address_length_f;
+	u16 reserved;
+	u8 t10_vendor_id[8];
+	u32 qpn;
+	u16 sl_gwportid;
+	u16 lid;
+	u8 port_guid[8];
+};
+
+struct fcoib_ioa_alive {
+	struct fip_fcoib_ver version;
+	struct fip_fip_header fip;
+
+	uint8_t infiniband_address_type_f;
+	uint8_t infiniband_address_length_f;
+	u16 reserved;
+	u8 t10_vendor_id[8];
+	u32 qpn;
+	u16 sl_gwportid;
+	u16 lid;
+	u8 port_guid[8];
+};
+
+struct fcoib_vhba_alive {
+	struct fip_fcoib_ver version;
+	struct fip_fip_header fip;
+
+	u8 infiniband_address_type_f;
+	u8 infiniband_address_length_f;
+	u16 reserved;
+	u8 t10_vendor_id[8];
+	u32 qpn;
+	u16 sl_gwportid;
+	u16 lid;
+	u8 port_guid[8];
+
+	u8 infiniband_vx_port_id_type_f;
+	u8 infiniband_vx_port_id_length_f;
+	u16 reserved_2;
+	u8 t10_vendor_id_2[8];
+	u32 vn_port_qpn;
+	u8 vn_port_guid[8];
+	u32 vn_port_addres_id;
+	u8 vn_port_name[8];
+};
+
+struct fcoib_clear_virtual_link_ioa {
+	struct fip_fcoib_ver version;
+	struct fip_fip_header fip;
+
+	u8 infiniband_address_type_f;
+	u8 infiniband_address_length_f;
+	u16 reserved;
+	u8 t10_vendor_id[8];
+	u32 qpn;
+	u16 sl_gwPortId;
+	u16 lid;
+	u8 gw_guid[8];
+
+	u8 fip_name_identifier_type_f;
+	u8 fip_name_identifier_length_f;
+	u16 reserved_3;
+	u8 switch_name[8];
+};
+
+struct fcoib_clear_virtual_link_vhba {
+	struct fip_fcoib_ver version;
+	struct fip_fip_header fip;
+
+	u8 infiniband_address_type_f;
+	u8 infiniband_address_length_f;
+	u16 reserved;
+	u8 t10_vendor_id[8];
+	u32 qpn;
+	u16 sl_gwPortId;
+	u16 lid;
+	u8 gw_guid[8];
+
+	u8 fip_name_identifier_type_f;
+	u8 fip_name_identifier_length_f;
+	u16 reserved_3;
+	u8 switch_name[8];
+
+	/* TODO: array of items */
+	u8 infiniband_vx_port_id_type_f;
+	u8 infiniband_vx_port_id_length_f;
+	u16 reserved_2;
+	u8 t10_vendor_id_2[8];
+	u32 vn_port_qpn;
+	u8 vn_port_guid[8];
+	u32 vn_port_addres_id;
+	u8 vn_port_name[8];
+};
+
+enum fip_packet_fields {
+	FCOIB_FIP_OPCODE = 0xFFF8,
+	EOIB_FIP_OPCODE = 0xFFF9,
+	FIP_FIP_HDR_LENGTH = 3,
+	FIP_FIP_HDR_TYPE = 13,
+
+	FIP_HOST_SOL_SUB_OPCODE = 0x1,
+	FIP_GW_ADV_SUB_OPCODE = 0x2,
+	FIP_HOST_LOGIN_SUB_OPCODE = 0x3,
+	FIP_GW_LOGIN_SUB_OPCODE = 0x4,
+	FIP_HOST_LOGOUT_SUB_OPCODE = 0x5,
+	FIP_GW_UPDATE_SUB_OPCODE = 0x6,
+	FIP_GW_TABLE_SUB_OPCODE = 0x7,
+	FIP_HOST_ALIVE_SUB_OPCODE = 0x8,
+
+	FCOIB_HOST_SOL_SUB_OPCODE = 0x1,
+	FCOIB_GW_ADV_SUB_OPCODE = 0x2,
+	FCOIB_LS_REQUEST_SUB_OPCODE = 0x3,
+	FCOIB_LS_REPLY_SUB_OPCODE = 0x4,
+	FCOIB_HOST_ALIVE_SUB_OPCODE = 0x8,
+	FCOIB_CLVL_SUB_OPCODE = 0x9,
+
+	FIP_FIP_FCF_FLAG = 0x1,
+	FIP_FIP_SOLICITED_FLAG = 0x2,
+	FIP_FIP_ADVRTS_FLAG = 0x4,
+	FIP_FIP_FP_FLAG = 0x80,
+	FIP_FIP_SP_FLAG = 0x40,
+
+	FIP_BASIC_LENGTH = 7,
+	FIP_BASIC_TYPE = 240,
+
+	FIP_ADVERTISE_LENGTH_1 = 4,
+	FIP_ADVERTISE_TYPE_1 = 241,
+	FIP_ADVERTISE_HOST_VLANS = 0x80,
+
+	FIP_LOGIN_LENGTH_1 = 13,
+	FIP_LOGIN_TYPE_1 = 242,
+	FIP_LOGIN_LENGTH_2 = 4,
+	FIP_LOGIN_TYPE_2 = 246,
+
+	FIP_LOGIN_V_FLAG = 0x8000,
+	FIP_LOGIN_M_FLAG = 0x4000,
+	FIP_LOGIN_VP_FLAG = 0x2000,
+	FIP_LOGIN_DMAC_MGID_MASK = 0x3F,
+	FIP_LOGIN_RSS_MGID_MASK = 0x0F,
+	FIP_LOGIN_RSS_SHIFT = 4,
+
+	FIP_LOGOUT_LENGTH_1 = 13,
+	FIP_LOGOUT_TYPE_1 = 245,
+
+	FIP_HOST_UPDATE_LENGTH = 13,
+	FIP_HOST_UPDATE_TYPE = 245,
+	FIP_HOST_VP_FLAG = 0x01,
+	FIP_HOST_U_FLAG = 0x80,
+	FIP_HOST_R_FLAG = 0x40,
+
+	FIP_CONTEXT_UP_LENGTH = 9,
+	FIP_CONTEXT_UP_TYPE = 243,
+	FIP_CONTEXT_V_FLAG = 0x80,
+	FIP_CONTEXT_RSS_FLAG = 0x40,
+	FIP_CONTEXT_TYPE_MASK = 0x0F,
+
+	FIP_CONTEXT_TBL_TYPE = 244,
+	FIP_CONTEXT_TBL_SEQ_MASK = 0xC0,
+	FIP_CONTEXT_TBL_SEQ_FIRST = 0x40,
+	FIP_CONTEXT_TBL_SEQ_LAST = 0x80,
+
+	FKA_ADV_PERIOD = 8,
+
+	FIP_PRIORITY_TYPE = 1,
+	FIP_PRIORITY_LENGTH = 1,
+	FIP_MAC_TYPE = 2,
+	FIP_MAC_LENGTH = 2,
+	FIP_FC_MAP_TYPE = 3,
+	FIP_FC_MAP_LENGTH = 2,
+	FIP_NAME_IDENTIFIER_TYPE = 4,
+	FIP_NAME_IDENTIFIER_LENGTH = 3,
+	FIP_FABRIC_NAME_TYPE = 5,
+	FIP_FABRIC_NAME_LENGTH = 4,
+	MAX_RECEIVE_SIZE_TYPE = 6,
+	MAX_RECEIVE_SIZE_LENGTH = 1,
+	FLOGI_TYPE = 7,
+	FLOGI_REQUEST_LENGTH = 36,
+	FLOGI_ACCEPT_LENGTH = 36,
+	FLOGI_REJECT_LENGTH = 9,
+
+	FDISC_TYPE = 8,
+	FDISC_REQUEST_LENGTH = 36,
+	FDISC_ACCEPT_LENGTH = 36,
+	FDISC_REJECT_LENGTH = 9,
+	LOGO_TYPE = 9,
+	LOGO_REQUEST_LENGTH = 11,
+	LOGO_ACCEPT_LENGTH = 10,
+	LOGO_REJECT_LENGTH = 9,
+	VX_PORT_ID_TYPE = 11,
+	VX_PORT_ID_LENGTH = 5,
+	FKA_ADV_PERIOD_TYPE = 12,
+	FKA_ADV_PERIOD_LENGTH = 2,
+	INFINIBAND_ADDRESS_TYPE = 240,
+	INFINIBAND_ADDRESS_LENGTH = 7,
+	EOIB_GW_INFORMATION_TYPE = 241,
+	EOIB_GW_INFORMATION_LENGTH = 4,
+	VNIC_LOGIN_OR_ACK_INFORMATION_TYPE = 242,
+	VNIC_LOGIN_OR_ACK_INFORMATION_LENGTH = 13,
+	VHUB_UPDATE_TYPE = 243,
+	VHUB_UPDATE_LENGTH = 9,
+	VHUB_TABLE_TYPE = 244,
+	VNIC_IDENTITY_TYPE = 245,
+	VNIC_IDENTITY_LENGTH = 13,
+	PARTITION_TYPE = 246,
+	PARTITION_LENGTH = 4,
+	INFINIBAND_VX_PORT_ID_TYPE = 247,
+	INFINIBAND_VX_PORT_ID_LENGTH = 10,
+	BXM_TUNNELED_PACKET_TYPE = 250,
+	BXM_COMMAND_TYPE = 251,
+	FIP_VENDOR_ID_TYPE = 13,
+	FIP_VENDOR_ID_LENGTH = 3,
+};
+
+const char FIP_DISCOVER_MGID[16] = {
+	0xFF, 0x12, 0xFC, 0x1B,
+	0x00, 0x06, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00
+};
+
+const char FIP_SOLICIT_MGID[16] = {
+	0xFF, 0x12, 0xFC, 0x1B,
+	0x00, 0x07, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00
+};
+
+const u32 FCOIB_FIP_QKEY = 0x80020004;
+
+static void fip_gw_fsm(struct work_struct *work);
+static void fip_purge_gws(struct work_struct *work);
+
+static inline int _map_generic_pkt(struct fip_dev_priv *priv,
+				   struct ring_entry *tx_ring_entry,
+				   char *mem, int pkt_size)
+{
+	/* alloc packet to be sent */
+	tx_ring_entry->mem = mem;
+
+	/* map packet to bus */
+	tx_ring_entry->length = pkt_size;
+	tx_ring_entry->bus_addr = ib_dma_map_single(priv->ca,
+						    tx_ring_entry->mem,
+						    pkt_size, DMA_TO_DEVICE);
+
+	if (unlikely(ib_dma_mapping_error(priv->ca, tx_ring_entry->bus_addr))) {
+		fip_warn(priv, "send_generic_pkt failed to map to pci\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static inline int send_generic_mcast_pkt(struct fip_dev_priv *priv,
+					 struct ring *tx_ring,
+					 char *mem, int pkt_size,
+					 struct ib_qp *qp,
+					 int pkey_index,
+					 struct mcast_entry *mcast)
+{
+	int index, ret;
+
+	/*
+	 * we are only allowed to update the head at task level so no need to
+	 * perform any locks here
+	 */
+	index = tx_ring->head;
+	fip_dbg(priv, LOG_PRIO_LOW, "send mcast packet\n");
+
+	/* it is possible for the AH to be missing in transient
+	 * states (after events) */
+	if (!mcast || !test_bit(MCAST_FLAG_AH_SET, &mcast->flags))
+		return -EBUSY;
+
+	/* ring full try again */
+	if (index == tx_ring->tail) {
+		fip_warn(priv, "send_generic_pkt ring full\n");
+		return -EAGAIN;
+	}
+
+	ret = _map_generic_pkt(priv, &tx_ring->ring[index], mem, pkt_size);
+	if (ret)
+		return ret;
+
+	ret = fip_mcast_send(priv, qp, tx_ring->head,
+			     tx_ring->ring[index].bus_addr,
+			     pkt_size, pkey_index, mcast);
+
+	if (ret) {
+		fip_warn(priv,
+			 "send_generic_mcast_pkt: fip_mcast_send ret=%d\n",
+			 ret);
+		ret = -EINVAL;
+		goto error_unmap_dma;
+	}
+
+	tx_ring->head = (index + 1) & (tx_ring->size - 1);
+
+	return 0;
+
+error_unmap_dma:
+	ib_dma_unmap_single(priv->ca,
+			    tx_ring->ring[index].bus_addr,
+			    pkt_size, DMA_TO_DEVICE);
+	return -ENODEV;
+}
+
+static inline int send_generic_ucast_pkt(struct fip_dev_priv *priv,
+					 struct ring *tx_ring,
+					 char *mem, int pkt_size,
+					 struct ib_qp *qp,
+					 int pkey_index,
+					 u32 dst_qpn, u16 dst_lid, u32 qkey)
+{
+	int index, ret;
+
+	/*
+	 * we are only allowed to update the head at task level so no need to
+	 * perform any locks here
+	 */
+	index = tx_ring->head;
+
+	fip_dbg(priv, LOG_PRIO_LOW, "send ucast packet\n");
+
+	/* ring full try again */
+	if (index == tx_ring->tail) {
+		fip_warn(priv, "send_generic_pkt ring full\n");
+		return -EAGAIN;
+	}
+
+	ret = _map_generic_pkt(priv, &tx_ring->ring[index], mem, pkt_size);
+	if (ret)
+		return ret;
+
+	ret = fip_ucast_send(priv, qp,
+			     tx_ring->head, tx_ring->ring[index].bus_addr,
+			     pkt_size, priv->pkey_index,
+			     dst_qpn, dst_lid, qkey);
+
+	if (ret) {
+		fip_warn(priv,
+			 "send_generic_ucast_pkt: fip_ucast_send ret=%d\n",
+			 ret);
+		ret = -EINVAL;
+		goto error_unmap_dma;
+	}
+
+	tx_ring->head = (index + 1) & (tx_ring->size - 1);
+
+	return 0;
+
+error_unmap_dma:
+	ib_dma_unmap_single(priv->ca,
+			    tx_ring->ring[index].bus_addr,
+			    pkt_size, DMA_TO_DEVICE);
+	return -ENODEV;
+}
+
+const struct fcoib_solicit base_fcoib_solicit_pkt = {
+	.fip.subcode = FCOIB_HOST_SOL_SUB_OPCODE,
+	.fip.type.type = FIP_FIP_HDR_TYPE,
+	.fip.type.length = FIP_FIP_HDR_LENGTH,
+	.fip.vendor_id = FIP_VENDOR_MELLANOX,
+
+	.infiniband_address_type_f = INFINIBAND_ADDRESS_TYPE,
+	.infiniband_address_length_f = INFINIBAND_ADDRESS_LENGTH,
+	.t10_vendor_id = "mellanox",
+
+	.fip_name_id_type_f = FIP_NAME_IDENTIFIER_TYPE,
+	.fip_name_id_length_f = FIP_NAME_IDENTIFIER_LENGTH,
+
+	.max_receive_size_type_f = MAX_RECEIVE_SIZE_TYPE,
+	.max_receive_size_length_f = MAX_RECEIVE_SIZE_LENGTH,
+};
+
+struct fcoib_flogi_fdisc_request base_flogi_request_pkt = {
+	.fip.subcode = FCOIB_LS_REQUEST_SUB_OPCODE,
+	.fip.type.type = FIP_FIP_HDR_TYPE,
+	.fip.type.length = FIP_FIP_HDR_LENGTH,
+	.fip.vendor_id = FIP_VENDOR_MELLANOX,
+
+	.els_type_f = FLOGI_TYPE,
+	.els_length_f = FLOGI_REQUEST_LENGTH,
+	.infiniband_address_type_f = INFINIBAND_ADDRESS_TYPE,
+	.infiniband_address_length_f = INFINIBAND_ADDRESS_LENGTH,
+	.t10_vendor_id = "mellanox",
+};
+
+struct fcoib_logo_request base_logo_request_pkt = {
+	.fip.subcode = FCOIB_LS_REQUEST_SUB_OPCODE,
+	.fip.type.type = FIP_FIP_HDR_TYPE,
+	.fip.type.length = FIP_FIP_HDR_LENGTH,
+	.fip.vendor_id = FIP_VENDOR_MELLANOX,
+
+	.els_type_f = LOGO_TYPE,
+	.els_length_f = LOGO_REQUEST_LENGTH,
+	.infiniband_address_type_f = INFINIBAND_ADDRESS_TYPE,
+	.infiniband_address_length_f = INFINIBAND_ADDRESS_LENGTH,
+	.t10_vendor_id = "mellanox",
+};
+
+struct fcoib_ioa_alive base_ioa_alive_pkt = {
+	.fip.subcode = FCOIB_HOST_ALIVE_SUB_OPCODE,
+	.fip.type.type = FIP_FIP_HDR_TYPE,
+	.fip.type.length = FIP_FIP_HDR_LENGTH,
+	.fip.vendor_id = FIP_VENDOR_MELLANOX,
+
+	.infiniband_address_type_f = INFINIBAND_ADDRESS_TYPE,
+	.infiniband_address_length_f = INFINIBAND_ADDRESS_LENGTH,
+	.t10_vendor_id = "mellanox",
+};
+
+struct fcoib_vhba_alive base_vhba_alive_pkt = {
+	.fip.subcode = FCOIB_HOST_ALIVE_SUB_OPCODE,
+	.fip.type.type = FIP_FIP_HDR_TYPE,
+	.fip.type.length = FIP_FIP_HDR_LENGTH,
+	.fip.vendor_id = FIP_VENDOR_MELLANOX,
+
+	.infiniband_address_type_f = INFINIBAND_ADDRESS_TYPE,
+	.infiniband_address_length_f = INFINIBAND_ADDRESS_LENGTH,
+	.t10_vendor_id = "mellanox",
+
+	.infiniband_vx_port_id_type_f = INFINIBAND_VX_PORT_ID_TYPE,
+	.infiniband_vx_port_id_length_f = INFINIBAND_VX_PORT_ID_LENGTH,
+	.t10_vendor_id_2 = "mellanox",
+};
+
+int fcoib_advertise_parse(struct fip_dev_priv *priv,
+			  char *buffer, int length, struct fip_gw_data *data)
+{
+	int desc_length;
+	struct fcoib_advertise *pkt;
+
+	FIP_TEST_PKT_LENGTH(length, struct fcoib_advertise);
+
+	pkt = (struct fcoib_advertise *)(buffer + IB_GRH_BYTES);
+	desc_length = be16_to_cpu(pkt->fip.list_length);
+
+	data->info.flags = (be16_to_cpu(pkt->fip.flags) & FIP_FIP_ADVRTS_FLAG) ?
+	    FIP_GW_AVAILABLE : 0;
+
+	data->info.flags |=
+	    (be16_to_cpu(pkt->fip.flags) & FIP_FIP_SOLICITED_FLAG) ?
+	    0 : FIP_RCV_MULTICAST;
+
+	if (be16_to_cpu(pkt->fip.opcode) == FCOIB_FIP_OPCODE) {
+		if (pkt->fip_priority_type_f != FIP_PRIORITY_TYPE ||
+		    pkt->fip_priority_length_f != FIP_PRIORITY_LENGTH ||
+		    pkt->infiniband_address_type_f != INFINIBAND_ADDRESS_TYPE ||
+		    pkt->infiniband_address_length_f !=
+		    INFINIBAND_ADDRESS_LENGTH ||
+		    pkt->fip_name_identifier_type_f !=
+		    FIP_NAME_IDENTIFIER_TYPE ||
+		    pkt->fip_name_identifier_length_f !=
+		    FIP_NAME_IDENTIFIER_LENGTH ||
+		    pkt->fip_fabric_name_type_f != FIP_FABRIC_NAME_TYPE ||
+		    pkt->fip_fabric_name_length_f != FIP_FABRIC_NAME_LENGTH ||
+		    pkt->fka_adv_period_type_f != FKA_ADV_PERIOD_TYPE ||
+		    pkt->fka_adv_period_length_f != FKA_ADV_PERIOD_LENGTH ||
+		    pkt->partition_type_f != PARTITION_TYPE ||
+		    pkt->partition_length_f != PARTITION_LENGTH) {
+			fip_dbg(priv, LOG_PRIO_LOW,
+				"fcoib_advertise_parse dump packet\n");
+			return -EINVAL;
+		}
+
+		data->info.flags |= FIP_IS_FIP;
+
+		data->info.priority = pkt->priority;
+		data->info.gw_qpn = be32_to_cpu(pkt->qpn);
+		data->info.gw_port_id = be16_to_cpu(pkt->sl_gwportid) & 0xfff;
+		data->info.sl = be16_to_cpu(pkt->sl_gwportid) >> 12;
+		data->info.gw_lid = be16_to_cpu(pkt->lid);
+		memcpy(data->info.gw_guid, pkt->gw_guid,
+		       sizeof(data->info.gw_guid));
+		memcpy(data->info.switch_name, pkt->switch_name,
+		       sizeof(data->info.switch_name));
+
+		memcpy(data->info.fabric_name, pkt->fabric_name,
+		       sizeof(data->info.fabric_name));
+		data->info.keep_alive_frq = be32_to_cpu(pkt->fka_adv_period);
+		data->info.pkey = be16_to_cpu(pkt->pkey);
+
+	} else {
+		fip_dbg(priv, LOG_PRIO_LOW,
+			"fcoib_advertise_parse packet opcode is not "
+			"supported=0x%x\n", (int)be16_to_cpu(pkt->fip.opcode));
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int fcoib_solicit_send(struct fip_dev_priv *priv,
+		       enum fip_packet_type multicast, u32 dqpn, u16 dlid)
+{
+	int pkt_size = sizeof(struct fcoib_solicit);
+	struct fip_discover *discover = &priv->discover;
+	int ret;
+	char *mem;
+	struct fcoib_solicit *pkt;
+	const u32 FCOIB_FIP_QKEY = 0x80020004;
+	int i;
+
+	/* alloc packet to be sent */
+	mem = kzalloc(pkt_size, GFP_KERNEL);
+	if (!mem) {
+		fip_warn(priv, "fcoib_solicit_send malloc failed\n");
+		return -EAGAIN;
+	}
+
+	pkt = (struct fcoib_solicit *)mem;
+	memcpy(pkt, &base_fcoib_solicit_pkt, sizeof(struct fcoib_solicit));
+	pkt->fip.opcode = cpu_to_be16(FCOIB_FIP_OPCODE);
+	pkt->fip.list_length =
+	    cpu_to_be16((sizeof(struct fcoib_solicit) >> 2) - 2),
+	    pkt->qpn = cpu_to_be32(discover->qp->qp_num);
+	pkt->lid = cpu_to_be16(priv->local_lid);
+	memcpy(pkt->gw_guid, &priv->local_gid.global.interface_id,
+	       sizeof(pkt->gw_guid));
+
+	for (i = 0; i < 8; i++)
+		pkt->node_name[i] = i;
+
+	pkt->max_fcoe_size = cpu_to_be32(priv->max_ib_mtu);
+
+	fip_dbg(priv, LOG_PRIO_MED, "fcoib_solicit_send creating "
+		"multicast=%d solicit packet\n", multicast);
+
+	if (multicast)
+		ret = send_generic_mcast_pkt(priv, &discover->tx_ring,
+					     mem, pkt_size, discover->qp,
+					     discover->pkey_index,
+					     discover->mcast[1]);
+	else
+		ret = send_generic_ucast_pkt(priv, &discover->tx_ring,
+					     mem, pkt_size, discover->qp,
+					     discover->pkey_index,
+					     dqpn, dlid, FCOIB_FIP_QKEY);
+	if (ret) {
+		fip_warn(priv, "discover_send error ret=%d\n", ret);
+		goto error_free_mem;
+	}
+
+	return 0;
+
+error_free_mem:
+	kfree(mem);
+	return -ENOMEM;
+}
+
+/* flogi is assumed to be 35 * 4 bytes */
+static int fcoib_flogi_request_send(struct fip_dev_priv *priv,
+				    struct fip_gw_data *gw,
+				    u8 *flogi, u32 host_data_qpn)
+{
+	int pkt_size = sizeof(struct fcoib_flogi_fdisc_request);
+	struct fcoib_flogi_fdisc_request *pkt;
+	int ret;
+	char *mem;
+
+	/* alloc packet to be sent */
+	mem = kzalloc(pkt_size, GFP_ATOMIC);
+	if (!mem) {
+		fip_warn(priv, "flogi request send malloc failed\n");
+		return -EAGAIN;
+	}
+
+	pkt = (struct fcoib_flogi_fdisc_request *)mem;
+	memcpy(pkt, &base_flogi_request_pkt,
+	       sizeof(struct fcoib_flogi_fdisc_request));
+
+	memcpy(pkt->els, flogi, sizeof(pkt->els));
+	pkt->fip.opcode = cpu_to_be16(FCOIB_FIP_OPCODE);
+	pkt->fip.list_length = cpu_to_be16((sizeof(struct
+						   fcoib_flogi_fdisc_request) >>
+					    2) - 2);
+	pkt->qpn = cpu_to_be32(host_data_qpn);
+	pkt->sl_gwportid = cpu_to_be16(gw->info.gw_port_id);
+	pkt->lid = cpu_to_be16(priv->local_lid);
+	memcpy(pkt->port_guid, &priv->local_gid.global.interface_id,
+	       sizeof(pkt->port_guid));
+
+	ret = send_generic_ucast_pkt(priv,
+				     &priv->discover.tx_ring,
+				     mem, pkt_size, priv->discover.qp,
+				     priv->pkey_index, gw->info.gw_qpn,
+				     gw->info.gw_lid, FCOIB_FIP_QKEY);
+	if (ret) {
+		fip_warn(priv,
+			 "flogi request send:  fip_ucast_send ret=%d\n", ret);
+		goto error_free_mem;
+	}
+
+	return 0;
+
+error_free_mem:
+	kfree(mem);
+	return -ENOMEM;
+}
+
+static int fcoib_logo_request_send(struct fip_dev_priv *priv,
+				   struct fip_gw_data *gw,
+				   u8 *logo, u32 host_data_qpn)
+{
+	int pkt_size = sizeof(struct fcoib_logo_request);
+	struct fcoib_logo_request *pkt;
+	int ret;
+	char *mem;
+
+	/* alloc packet to be sent */
+	mem = kzalloc(pkt_size, GFP_ATOMIC);
+	if (!mem) {
+		fip_warn(priv, "logo request send malloc failed\n");
+		return -EAGAIN;
+	}
+
+	pkt = (struct fcoib_logo_request *)mem;
+	memcpy(pkt, &base_logo_request_pkt, sizeof(struct fcoib_logo_request));
+
+	memcpy(pkt->els, logo, sizeof(pkt->els));
+	pkt->fip.opcode = cpu_to_be16(FCOIB_FIP_OPCODE);
+	pkt->fip.list_length = cpu_to_be16((sizeof(struct
+						   fcoib_logo_request) >> 2) -
+					   2);
+	pkt->qpn = cpu_to_be32(host_data_qpn);
+	pkt->sl_gwportid = cpu_to_be16(gw->info.gw_port_id);
+	pkt->lid = cpu_to_be16(priv->local_lid);
+	memcpy(pkt->port_guid, &priv->local_gid.global.interface_id,
+	       sizeof(pkt->port_guid));
+
+	ret = send_generic_ucast_pkt(priv,
+				     &priv->discover.tx_ring,
+				     mem, pkt_size, priv->discover.qp,
+				     priv->pkey_index, gw->info.gw_qpn,
+				     gw->info.gw_lid, FCOIB_FIP_QKEY);
+	if (ret) {
+		fip_warn(priv,
+			 "logo request send:  fip_ucast_send ret=%d\n", ret);
+		goto error_free_mem;
+	}
+
+	return 0;
+
+error_free_mem:
+	kfree(mem);
+	return -ENOMEM;
+}
+
+int fcoib_ioa_alive_send(struct fip_dev_priv *priv, struct fip_gw_data *gw)
+{
+	int pkt_size = sizeof(struct fcoib_ioa_alive);
+	struct fcoib_ioa_alive *pkt;
+	int ret;
+	char *mem;
+
+	/* alloc packet to be sent */
+	mem = kzalloc(pkt_size, GFP_KERNEL);
+	if (!mem) {
+		fip_warn(priv, "IOA alive send malloc failed\n");
+		return -EAGAIN;
+	}
+
+	pkt = (struct fcoib_ioa_alive *)mem;
+	memcpy(pkt, &base_ioa_alive_pkt, sizeof(struct fcoib_ioa_alive));
+
+	pkt->fip.opcode = cpu_to_be16(FCOIB_FIP_OPCODE);
+	pkt->fip.list_length = cpu_to_be16(FIP_VENDOR_ID_LENGTH +
+					   INFINIBAND_ADDRESS_LENGTH);
+	pkt->qpn = cpu_to_be32(gw->info.gw_qpn);
+	pkt->sl_gwportid = cpu_to_be16(gw->info.gw_port_id);
+	pkt->lid = cpu_to_be16(priv->local_lid);
+	memcpy(pkt->port_guid, &priv->local_gid.global.interface_id,
+	       sizeof(pkt->port_guid));
+
+	ret = send_generic_ucast_pkt(priv,
+				     &priv->discover.tx_ring,
+				     mem, pkt_size, priv->discover.qp,
+				     priv->pkey_index, gw->info.gw_qpn,
+				     gw->info.gw_lid, FCOIB_FIP_QKEY);
+	if (ret) {
+		fip_warn(priv, "IOA alive send:  fip_ucast_send ret=%d\n", ret);
+		goto error_free_mem;
+	}
+
+	return 0;
+
+error_free_mem:
+	kfree(mem);
+	return -ENOMEM;
+}
+
+int fcoib_vhba_alive_send(struct fip_dev_priv *priv, struct fip_gw_data *gw)
+{
+	int pkt_size = sizeof(struct fcoib_vhba_alive);
+	struct fcoib_vhba_alive *pkt;
+	int ret;
+	char *mem;
+
+	/* alloc packet to be sent */
+	mem = kzalloc(pkt_size, GFP_KERNEL);
+	if (!mem) {
+		fip_warn(priv, "vHBA alive send malloc failed\n");
+		return -EAGAIN;
+	}
+
+	pkt = (struct fcoib_vhba_alive *)mem;
+	memcpy(pkt, &base_vhba_alive_pkt, sizeof(struct fcoib_vhba_alive));
+
+	pkt->fip.opcode = cpu_to_be16(FCOIB_FIP_OPCODE);
+	pkt->fip.list_length = cpu_to_be16(FIP_VENDOR_ID_LENGTH +
+					   INFINIBAND_ADDRESS_LENGTH +
+					   INFINIBAND_VX_PORT_ID_LENGTH);
+	pkt->qpn = cpu_to_be32(gw->info.gw_qpn);
+	pkt->sl_gwportid = cpu_to_be16(gw->info.gw_port_id);
+	pkt->lid = cpu_to_be16(priv->local_lid);
+	memcpy(pkt->port_guid, &priv->local_gid.global.interface_id,
+	       sizeof(pkt->port_guid));
+
+	fcoib_get_vhba_fcid(gw->fc_handle,
+			    (u8 *) (&pkt->vn_port_addres_id) + 1);
+
+	ret = send_generic_ucast_pkt(priv,
+				     &priv->discover.tx_ring,
+				     mem, pkt_size, priv->discover.qp,
+				     priv->pkey_index, gw->info.gw_qpn,
+				     gw->info.gw_lid, FCOIB_FIP_QKEY);
+	if (ret) {
+		fip_warn(priv,
+			 "vHBA alive send:  fip_ucast_send ret=%d\n", ret);
+		goto error_free_mem;
+	}
+
+	return 0;
+
+error_free_mem:
+	kfree(mem);
+	return -ENOMEM;
+}
+
+int fcoib_pkt_parse(struct fip_dev_priv *priv,
+		    char *buffer, int length, int *fip_type)
+{
+	struct fip_fip_header *fip_header;
+	u16 fip_opcode;
+
+	fip_header = (struct fip_fip_header *)(buffer +
+					       IB_GRH_BYTES +
+					       sizeof(struct fip_fcoib_ver));
+
+	fip_opcode = be16_to_cpu(fip_header->opcode);
+
+	if (fip_opcode != FCOIB_FIP_OPCODE) {
+		fip_dbg(priv, LOG_PRIO_LOW, "packet: packet is "
+			"not FCoIB FIP packet\n");
+		*fip_type = 0;
+		return -EINVAL;
+	}
+
+	*fip_type = fip_opcode;
+
+	return fip_header->subcode;
+}
+
+/*
+ * Configure the discover QP. This includes configuring rx+tx
+ * moving the discover QP to RTS and creating the tx  and rx rings
+ */
+int fip_discover_start_rings(struct fip_dev_priv *priv)
+{
+	int ret;
+	struct fip_discover *discover = &priv->discover;
+
+	spin_lock_init(&discover->lock);
+
+	ret = fip_init_tx(priv, discover->tx_ring.size, &discover->tx_ring);
+	if (ret) {
+		fip_warn(priv, "fip_init_tx failed ret=%d\n", ret);
+		return ret;
+	}
+
+	ret = fip_init_rx(priv, discover->rx_ring.size, discover->qp,
+			  &discover->rx_ring);
+	if (ret) {
+		fip_warn(priv, "fip_init_rx returned %d\n", ret);
+		goto release_queues;
+	}
+
+	return 0;
+
+release_queues:
+	fip_flush_rings(priv, discover->cq, discover->qp,
+			&discover->rx_ring, &discover->tx_ring);
+	fip_free_rings(priv, &discover->rx_ring, &discover->tx_ring);
+	return ret;
+}
+
+/*
+ * This function is the RX packet handler entry point at the thread level
+ * (unlike the completion handler that runs from interrupt context).
+ * the function calls a handler function and then reallocats the ring
+ * entry for the next receive.
+*/
+void fip_discover_process_rx(struct work_struct *work)
+{
+	struct fip_discover *discover =
+	    container_of(work, struct fip_discover, pkt_rcv_task);
+	struct fip_dev_priv *priv =
+	    container_of(discover, struct fip_dev_priv, discover);
+	int mtu_size = FIP_UD_BUF_SIZE(priv->max_ib_mtu);
+	int ret;
+
+	if (priv->discover.flush == 1)
+		return;
+
+	while (discover->rx_ring.head != discover->rx_ring.tail) {
+		if (discover->rx_ring.ring[discover->rx_ring.tail].length == 0)
+			continue;
+
+		if (discover->state == FIP_DISCOVER_LOGIN) {
+			/* login is the first state we RX packets in */
+			ret = fip_discover_rx_packet(priv,
+						     discover->rx_ring.tail);
+			if (ret)
+				fip_warn(priv, "discover_rx_packet ret=%d\n",
+					 ret);
+		}
+
+		ret = fip_post_receive(priv, discover->qp, mtu_size,
+				       discover->rx_ring.tail,
+				       discover->rx_ring.ring[discover->rx_ring.
+							      tail].mem,
+				       discover->rx_ring.ring +
+				       discover->rx_ring.tail);
+		if (ret)
+			fip_warn(priv, "fip_post_receive ret=%d\n", ret);
+
+		discover->rx_ring.tail++;
+		discover->rx_ring.tail &= (discover->rx_ring.size - 1);
+	}
+	return;
+}
+
+/*
+ * Alloc the discover CQ, QP. Configure the QP to RTS.
+ * alloc the RX + TX rings and queue work for discover
+ * finite state machine code.
+ */
+int fip_discover_init(struct fip_dev_priv *priv)
+{
+	struct ib_device *ca = priv->ca;
+	struct ib_qp_init_attr qp_init_attr;
+	struct fip_discover *discover;
+	int i;
+
+	discover = &priv->discover;
+
+	discover->state = FIP_DISCOVER_INIT;
+	discover->flush = 0;
+	discover->rx_ring.size = FIP_PROTOCOL_RX_SIZE;
+	discover->tx_ring.size = FIP_PROTOCOL_TX_SIZE;
+	discover->pkey = priv->pkey;
+	discover->backoff_time = 1;
+	for (i = 0; i < FIP_DISCOVER_NUM_MCAST; i++)
+		discover->mcast[i] = NULL;
+
+	sema_init(&discover->flush_done, 0);
+
+	INIT_DELAYED_WORK(&discover->task, fip_discover_fsm);
+	INIT_DELAYED_WORK(&discover->cleanup_task, fip_purge_gws);
+	INIT_WORK(&discover->pkt_rcv_task, fip_discover_process_rx);
+	INIT_WORK(&discover->mcast_refresh_task, fip_refresh_mcasts);
+	INIT_LIST_HEAD(&discover->gw_list);
+	INIT_LIST_HEAD(&discover->gw_rm_list);
+
+	discover->cq = ib_create_cq(priv->ca, fip_discover_comp, NULL, priv,
+				    discover->rx_ring.size +
+				    discover->tx_ring.size, 0);
+	if (IS_ERR(discover->cq)) {
+		fip_warn(priv, "%s: failed to create receive CQ\n", ca->name);
+		return -EIO;
+	}
+
+	memset(&qp_init_attr, 0, sizeof(qp_init_attr));
+	qp_init_attr.cap.max_send_wr = discover->tx_ring.size;
+	qp_init_attr.cap.max_recv_wr = discover->rx_ring.size;
+	qp_init_attr.cap.max_send_sge = 1;
+	qp_init_attr.cap.max_recv_sge = 1;
+	qp_init_attr.sq_sig_type = IB_SIGNAL_ALL_WR;
+	qp_init_attr.qp_type = IB_QPT_UD;
+	qp_init_attr.send_cq = discover->cq;
+	qp_init_attr.recv_cq = discover->cq;
+
+	discover->qp = ib_create_qp(priv->pd, &qp_init_attr);
+	if (IS_ERR(discover->qp)) {
+		fip_warn(priv, "%s: failed to create QP\n", ca->name);
+		goto error_free_cq;
+	}
+
+	fip_dbg(priv, LOG_PRIO_HIGH, "Local QPN=%d, LID=%d\n",
+		(int)discover->qp->qp_num, (int)priv->local_lid);
+
+	/* TODO - figure out whats going on with the PKEY */
+	if (ib_find_pkey(priv->ca, priv->port, discover->pkey,
+			 &discover->pkey_index)) {
+		fip_warn(priv, "P_Key 0x%04x not found\n", discover->pkey);
+		goto error_free_qp;
+	}
+
+	/* move QP from reset to RTS */
+	if (fip_init_qp(priv, discover->qp, discover->pkey_index,
+			FCOIB_FIP_QKEY)) {
+		fip_warn(priv, "ipoib_init_qp returned\n");
+		goto error_free_qp;
+	}
+
+	/* init RX+TX rings */
+	if (fip_discover_start_rings(priv)) {
+		fip_warn(priv, "%s: failed to move QP to RTS or "
+			 "allocate queues\n", ca->name);
+		goto error_free_qp;
+	}
+
+	/* enable recieving CQ completions */
+	if (ib_req_notify_cq(discover->cq, IB_CQ_NEXT_COMP))
+		goto error_release_rings;
+
+	/* start discover FSM code */
+	queue_delayed_work(fip_workqueue, &discover->task, 0 * HZ);
+
+	return 0;
+
+error_release_rings:
+	fip_flush_rings(priv, discover->cq, discover->qp,
+			&discover->rx_ring, &discover->tx_ring);
+	fip_free_rings(priv, &discover->rx_ring, &discover->tx_ring);
+error_free_qp:
+	ib_destroy_qp(discover->qp);
+error_free_cq:
+	ib_destroy_cq(discover->cq);
+	return -ENODEV;
+}
+
+/*
+ * free the discover TX and RX rings, QP and CQ.
+*/
+void fip_discover_cleanup(struct fip_dev_priv *priv)
+{
+	if (priv->discover.state == FIP_DISCOVER_OFF)
+		goto cleanup_done;
+
+	/*
+	 * move FSM to flush state and wait for the FSM
+	 * to finish whatever it is doing before we continue
+	 */
+	fip_dbg(priv, LOG_PRIO_LOW, "==>priv->discover.flush = 1\n");
+
+	spin_lock_irq(&priv->discover.lock);
+	priv->discover.flush = 1;
+	spin_unlock_irq(&priv->discover.lock);
+
+	cancel_delayed_work(&priv->discover.task);
+	queue_delayed_work(fip_workqueue, &priv->discover.task, 0);
+	down(&priv->discover.flush_done);
+
+	fip_flush_rings(priv, priv->discover.cq, priv->discover.qp,
+			&priv->discover.rx_ring, &priv->discover.tx_ring);
+	flush_workqueue(fip_workqueue);
+
+	fip_free_rings(priv, &priv->discover.rx_ring, &priv->discover.tx_ring);
+	if (priv->discover.qp)
+		ib_destroy_qp(priv->discover.qp);
+	priv->discover.qp = NULL;
+
+	if (priv->discover.cq)
+		ib_destroy_cq(priv->discover.cq);
+	priv->discover.cq = NULL;
+
+cleanup_done:
+	return;
+}
+
+/*
+ * This function handles completions of both TX and RX
+ * packets. RX packets are unmapped and passed to a thread
+ * for processing. TX packets are unmapped and freed.
+ * Note: this function is called from interrupt context
+ */
+void fip_discover_comp(struct ib_cq *cq, void *dev_ptr)
+{
+	struct fip_dev_priv *priv = dev_ptr;
+
+	spin_lock(&priv->discover.lock);
+	/* handle completions. On RX packets this will call discover_process_rx
+	 * from thread context to continue processing */
+	if (fip_comp(priv, priv->discover.cq, &priv->discover.rx_ring,
+		     &priv->discover.tx_ring)) {
+		if (!priv->discover.flush)
+			queue_work(fip_workqueue, &priv->discover.pkt_rcv_task);
+	}
+	spin_unlock(&priv->discover.lock);
+}
+
+/*
+ * Queue the GW for deletion. And trigger a delayed call to the cleanup
+ * function.
+ * Note: This deletion method insures that all pending GW work requests
+ * are cleared without dependency of the calling context.
+*/
+void fip_close_gw(struct fip_gw_data *gw)
+{
+	if (gw->state >= FIP_GW_WAITING_FOR_FLOGI) {
+		if (gw->fc_handle)
+			fcoib_destroy_vhba(gw->fc_handle);
+		else
+			printk(KERN_WARNING "close gw for unexistent vhba\n");
+	}
+
+	gw->vhba_ka_tmr_valid = 0;
+	gw->host_ka_tmr_valid = 0;
+	gw->gw_ka_tmr_valid = 0;
+	gw->flush = 1;
+	list_del(&gw->list);
+	list_add(&gw->list, &gw->priv->discover.gw_rm_list);
+	gw->info.gw_num_vnics = 0;
+	cancel_delayed_work(&gw->gw_task);
+
+	queue_delayed_work(fip_workqueue, &gw->priv->discover.cleanup_task,
+			   DELAYED_WORK_CLEANUP_JIFFS);
+}
+
+/*
+ * Free GW resources. This includes destroying the vnics. If the GW can be
+ * totaly destroyed (no pending work for the GW and all the vnics have been
+ * destroyed) the GW will be removed from the GWs list and it's memory
+ * freed. If the GW can not be closed at this time it will not be freed
+ * and the function will return an error.
+ * In this case the caller needs to recall the function to complete the
+ * operation.
+ * Do not call this function directly use: fip_close_gw
+*/
+static int fip_free_gw(struct fip_dev_priv *priv, struct fip_gw_data *gw)
+{
+	gw->flush = 1;
+	gw->info.gw_num_vnics = 0;
+
+	cancel_delayed_work(&gw->gw_task);
+	if (delayed_work_pending(&gw->gw_task))
+		return -EBUSY;
+
+	fip_dbg(priv, LOG_PRIO_LOW, "fip_free_gw. freeing GW\n");
+	list_del(&gw->list);
+	kfree(gw->new_gw_data);
+	kfree(gw);
+	return 0;
+}
+
+/*
+ * permanently delete all GWs pending delete. The function goes over
+ * the list of GWs awaiting deletion and tries to delete them. If the
+ * GW destructor returns an error value (currently busy) the function
+ * will requeue it self for another try.
+ */
+static void fip_purge_gws(struct work_struct *work)
+{
+	struct fip_discover *discover = container_of(work,
+						     struct fip_discover,
+						     cleanup_task.work);
+	struct fip_dev_priv *priv = container_of(discover,
+						 struct fip_dev_priv, discover);
+	struct fip_gw_data *gw, *tmp_gw;
+	int respawn = 0;
+
+	list_for_each_entry_safe(gw, tmp_gw, &discover->gw_rm_list, list) {
+		if (fip_free_gw(priv, gw) == -EBUSY)
+			respawn = 1;
+	}
+
+	if (respawn) {
+		fip_dbg(priv, LOG_PRIO_LOW,
+			"fip_free_gw is busy. respawn purge_gws\n");
+		queue_delayed_work(fip_workqueue, &discover->cleanup_task,
+				   DELAYED_WORK_CLEANUP_JIFFS);
+	}
+}
+
+#define NO_GWS_OPEN(discover) \
+	(list_empty(&(discover)->gw_rm_list) && \
+	list_empty(&(discover)->gw_list))
+
+/*
+ * Go over the GW list and try to close the GWs. It is possible that some
+ * of the GWs have pending work and therefore can not be closed. We can not
+ * sleep on this because we might be running on the same context as the one
+ * we are waiting for. To solve this recall the function if needed.
+ * Returns 0 if all GWs were removed and -EBUSY if one or more are still
+ * open.
+*/
+int fip_free_gw_list(struct fip_dev_priv *priv)
+{
+	struct fip_discover *discover = &priv->discover;
+	struct fip_gw_data *curr_gw, *tmp_gw;
+
+	list_for_each_entry_safe(curr_gw, tmp_gw, &discover->gw_list, list)
+	    fip_close_gw(curr_gw);
+
+	if (!NO_GWS_OPEN(discover)) {
+		fip_dbg(priv, LOG_PRIO_LOW, "fip_free_gw_list discover->"
+			"gw_rm_list %s gw_list %s\n",
+			list_empty(&discover->
+				   gw_rm_list) ? "empty" : "not empty",
+			list_empty(&discover->gw_list) ? "empty" : "not empty");
+		return -EBUSY;
+	}
+
+	cancel_delayed_work(&discover->cleanup_task);
+	if (delayed_work_pending(&discover->cleanup_task)) {
+		fip_dbg(priv, LOG_PRIO_LOW, "fip_free_gw_list waiting for "
+			"pending work on cleanup_task\n");
+		return -EBUSY;
+	}
+
+	fip_dbg(priv, LOG_PRIO_LOW, "fip_free_gw_list"
+		" Done freeing all GW we can go on\n");
+
+	return 0;
+}
+
+/*
+ * Look for a GW in the GW list. The search keys used are the GW lid (unique)
+ * and the GW port_id assuming that a single GW phisical port can advertise
+ * itself more then once.
+*/
+struct fip_gw_data *fip_find_gw_in_list(struct fip_discover *discover,
+					u16 gw_port_id, u16 gw_lid)
+{
+	struct fip_gw_data *curr_gw;
+
+	list_for_each_entry(curr_gw, &discover->gw_list, list) {
+		if (curr_gw->info.gw_lid == gw_lid &&
+		    curr_gw->info.gw_port_id == gw_port_id) {
+			return curr_gw;
+		}
+	}
+	return NULL;
+}
+
+struct fip_gw_data *fip_find_gw_by_guid(struct fip_discover *discover,
+					u16 gw_port_id, u8 *gw_guid)
+{
+	struct fip_gw_data *curr_gw;
+
+	list_for_each_entry(curr_gw, &discover->gw_list, list) {
+		if (curr_gw->info.gw_port_id == gw_port_id &&
+		    !memcmp(curr_gw->info.gw_guid, gw_guid, 8)) {
+			return curr_gw;
+		}
+	}
+	return NULL;
+}
+
+static struct fip_gw_data *fip_discover_create_gw(struct fip_dev_priv *priv)
+{
+	struct fip_gw_data *gw_data;
+
+	gw_data = kmalloc(sizeof(struct fip_gw_data), GFP_KERNEL);
+	if (!gw_data)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_DELAYED_WORK(&gw_data->gw_task, fip_gw_fsm);
+	gw_data->priv = priv;
+	gw_data->flush = 0;
+	memset(gw_data->bitmask, 0, sizeof(gw_data->bitmask));
+	gw_data->host_ka_tmr_valid = 0;
+	gw_data->vhba_ka_tmr_valid = 0;
+	gw_data->gw_ka_tmr_valid = 0;
+
+	return gw_data;
+}
+
+static int fip_discover_rx_advertise(struct fip_dev_priv *priv,
+				     struct fip_gw_data *advertise_data)
+{
+	struct fip_discover *discover = &priv->discover;
+	struct fip_gw_data *gw_data;
+	int update_entry = 0;
+
+	/* see if we received advertise packets from this GW before */
+	gw_data = fip_find_gw_in_list(discover,
+				      advertise_data->info.gw_port_id,
+				      advertise_data->info.gw_lid);
+
+	/*
+	 * GW not found in GW list, create a new GW structure and add it to GW
+	 * list. If GW was found in list but it is in multicast state (based on
+	 * received mcast packet) we will replace it with the newer up-to-date
+	 * packet.
+	 */
+	if (!gw_data) {
+		gw_data = fip_discover_create_gw(priv);
+		if (IS_ERR(gw_data))
+			return -ENOMEM;
+
+		list_add_tail(&gw_data->list, &discover->gw_list);
+		update_entry = 1;
+	} else {
+		if (gw_data->flush)
+			return 0;
+
+		if (gw_data->state <= FIP_GW_RCVD_UNSOL_AD) {
+			kfree(gw_data->new_gw_data);
+			update_entry = 1;
+		}
+	}
+
+	if (update_entry) {
+		memcpy(&gw_data->info, &advertise_data->info,
+		       sizeof(struct fip_gw_data_info));
+		gw_data->state = FIP_GW_RCVD_UNSOL_AD;
+		gw_data->new_gw_data = NULL;
+	}
+
+	/* if multicast advertisement received */
+	if (advertise_data->info.flags & FIP_RCV_MULTICAST) {
+		gw_data->gw_ka_tmr = jiffies + 3 * FKA_ADV_PERIOD * HZ;
+
+		/* we are beyond accepting mcast advertisement */
+		if (gw_data->state != FIP_GW_RCVD_UNSOL_AD)
+			return 0;
+
+		fip_dbg(priv, LOG_PRIO_VERY_LOW,
+			"Received mcast advertise sending ucast solicit"
+			" to GW qpn=%d lid=%d flags=0x%x\n",
+			gw_data->info.gw_qpn, gw_data->info.gw_lid,
+			gw_data->info.flags);
+	} else {		/* unicast advertisement received */
+		int ack_received =
+		    advertise_data->info.flags & FIP_GW_AVAILABLE;
+
+		fip_dbg(priv, LOG_PRIO_VERY_LOW,
+			"received ucast advertise from GW qpn=%d lid=%d"
+			" flags=0x%x\n",
+			gw_data->info.gw_qpn, gw_data->info.gw_lid,
+			gw_data->info.flags);
+
+		/* if this is first ACK received move to FIP_GW_ACK_RCVD */
+		if (ack_received && gw_data->state == FIP_GW_SENT_SOL)
+			gw_data->state = FIP_GW_RCVD_SOL_AD;
+	}
+
+	/* we will call the GW FSM to handle */
+	cancel_delayed_work(&gw_data->gw_task);
+	fip_gw_fsm(&gw_data->gw_task.work);
+	return 0;
+}
+
+/*
+ * This function handles a single received packet that are expected to be
+ * GW advertisements or login ACK packets. The function first parses the
+ * packet and decides what is the packet type and then handles the packets
+ * specifically according to its type. This functions runs in task context.
+*/
+int fip_discover_rx_packet(struct fip_dev_priv *priv, int index)
+{
+	struct fip_discover *discover = &priv->discover;
+	union {
+		struct fip_gw_data advertise_data;
+	} pkt_data;
+	char *packet = discover->rx_ring.ring[index].mem;
+	int length = discover->rx_ring.ring[index].length;
+	int ret, pkt_type, fip_type;
+
+	pkt_type = fcoib_pkt_parse(priv, packet, length, &fip_type);
+	if (pkt_type < 0)
+		return 0;
+
+	switch (pkt_type) {
+	case FCOIB_GW_ADV_SUB_OPCODE:
+		ret = fcoib_advertise_parse(priv, packet, length,
+					    &pkt_data.advertise_data);
+		if (!ret) {
+			return fip_discover_rx_advertise(priv, &pkt_data.
+							 advertise_data);
+		}
+		break;
+	case FCOIB_LS_REPLY_SUB_OPCODE:
+		{
+			struct fcoib_flogi_fdisc_acc *rep =
+			    (struct fcoib_flogi_fdisc_acc *)(packet +
+							     IB_GRH_BYTES);
+			struct fip_gw_data *gw;
+
+			/* find the GW that this login belongs to */
+			gw = fip_find_gw_in_list(discover,
+						 be16_to_cpu(rep->sl_gwPortId),
+						 be16_to_cpu(rep->lid));
+			if (!gw)
+				break;
+
+			if (!gw->fc_handle) {
+				printk(KERN_ERR "mlx4_fcoib: NO FC HANDLE\n");
+				break;
+			}
+
+			if (!fcoib_recvd_flogi_reply(gw->fc_handle,
+						     rep->els,
+						     (rep->els_length_f - 1) * 4,
+						     be32_to_cpu(rep->qpn))) {
+				gw->state = FIP_GW_RCVD_FLOGI_ACCPT;
+				cancel_delayed_work(&gw->gw_task);
+				fip_gw_fsm(&gw->gw_task.work);
+			} else {
+				printk(KERN_WARNING
+					"mlx4_fcoib: rejected gw\n");
+				gw->state = FIP_GW_RESET;
+			}
+		}
+		break;
+	case FCOIB_CLVL_SUB_OPCODE:
+		{
+			struct fcoib_clear_virtual_link_ioa *clvl =
+			    (struct fcoib_clear_virtual_link_ioa *)
+			    (packet + IB_GRH_BYTES);
+			struct fip_gw_data *gw;
+#define IOA_CLVL_LIST_LENGTH  (FIP_VENDOR_ID_LENGTH + \
+						  INFINIBAND_ADDRESS_LENGTH + \
+						 FIP_NAME_IDENTIFIER_LENGTH)
+#define VHBA_CLVL_LIST_LENGTH (IOA_CLVL_LIST_LENGTH + \
+					       INFINIBAND_VX_PORT_ID_LENGTH)
+
+			/* we should not look for gw by its' lid - because the
+			   gw may send CLVL because of changing this lid */
+
+			gw = fip_find_gw_by_guid(discover,
+						 be16_to_cpu(clvl->sl_gwPortId),
+						 clvl->gw_guid);
+			if (!gw) {
+				printk(KERN_ERR
+					"CLVL for non-existing gw\n");
+				break;
+			}
+
+			/* TODO: We should differ between IOA_CLVL to VHBA_CLVL
+			 * after vhba virtualization implementation, for now
+			 * we close the gw on VHBA_CLVL because each gw has one
+			 * vhba*/
+
+			if (be16_to_cpu(clvl->fip.list_length) >=
+			    IOA_CLVL_LIST_LENGTH)
+				fip_close_gw(gw);
+			else
+				printk(KERN_WARNING
+				       "received CLVL with unexpected size\n");
+		}
+		break;
+	default:
+		printk(KERN_WARNING "received unknown packet\n");
+		break;
+	}
+	return 0;
+}
+
+/*
+ * This function is a callback called upon successful join to a
+ * multicast group. The function checks if we have joined + attached
+ * to all required mcast groups and if so moves the discovery FSM to solicit.
+*/
+void fip_discover_mcast_connect_cb(struct mcast_entry *mcast,
+				   void *discover_context)
+{
+	struct fip_discover *discover = discover_context;
+	struct fip_dev_priv *priv =
+	    container_of(discover, struct fip_dev_priv, discover);
+	int i;
+
+	for (i = 0; i < FIP_DISCOVER_NUM_MCAST; i++)
+		if (mcast == discover->mcast[i])
+			break;
+
+	/*
+	 * if we have not started joining the mcast or the join is still in
+	 * progress return. We will continue only when all is done
+	 */
+	for (i = 0; i < FIP_DISCOVER_NUM_MCAST; i++) {
+		if (discover->mcast[i] == NULL ||
+		    !test_bit(MCAST_FLAG_DONE, &discover->mcast[i]->flags))
+			return;
+	}
+
+	/* in the case of a reconnect don't change state or send a solicit
+	 * packet */
+	if (discover->state < FIP_DISCOVER_SOLICIT) {
+		fip_dbg(priv, LOG_PRIO_LOW,
+			"fip_multicast_connected "
+			"moved state to solicit\n");
+		spin_lock_irq(&discover->lock);
+		if (!discover->flush) {
+			/* delay sending solicit packet by 0-100 mSec */
+			int rand_delay = jiffies % 100;	/*get_random_int() */
+			discover->state = FIP_DISCOVER_SOLICIT;
+			cancel_delayed_work(&discover->task);
+			/* This is really (rand_delay / 1000) * HZ */
+			queue_delayed_work(fip_workqueue, &discover->task,
+					   (rand_delay * HZ) / 1000);
+		}
+		spin_unlock_irq(&discover->lock);
+	}
+	fip_dbg(priv, LOG_PRIO_LOW, "discover_mcast_connect_cb done\n");
+}
+
+/*
+ * Try to connect to the relevant mcast groups. If one of the mcast failed
+ * The function should be recalled to try and complete the join process
+ * (for the mcast groups that the join process was not performed).
+ * Note: A successful return of fip_mcast_join means that the mcast join
+ * started, not that the join completed. completion of the connection process
+ * is asyncronous and uses a supplyed callback.
+*/
+int fip_discover_mcast_connect(struct fip_dev_priv *priv)
+{
+	struct fip_discover *discover = &priv->discover;
+
+	fip_dbg(priv, LOG_PRIO_LOW, "discover_mcast_connect\n");
+
+	priv->mcast.flags = 0;
+
+	/* connect to a well known multi cast group */
+	discover->mcast[0] = fip_mcast_join(&priv->mcast, discover,
+					     FIP_DISCOVER_MGID, FCOIB_FIP_QKEY,
+					     priv->discover.pkey,
+					     priv->discover.qp,
+					     MCAST_RECEIVE_ONLY,
+					     fip_discover_mcast_connect_cb);
+	if (!discover->mcast[0]) {
+		fip_warn(priv, "failed to join advertise MCAST groups\n");
+		return -1;
+	}
+
+	discover->mcast[1] = fip_mcast_join(&priv->mcast, discover,
+					     FIP_SOLICIT_MGID, FCOIB_FIP_QKEY,
+					     priv->discover.pkey,
+					     priv->discover.qp, MCAST_SEND_ONLY,
+					     fip_discover_mcast_connect_cb);
+	if (!discover->mcast[1]) {
+		fip_warn(priv, "failed to join solicit MCAST groups\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+void fip_discover_mcast_disconnect(struct fip_dev_priv *priv)
+{
+	struct fip_discover *discover = &priv->discover;
+	int i;
+
+	for (i = 0; i < FIP_DISCOVER_NUM_MCAST; i++) {
+		if (discover->mcast[i])
+			fip_mcast_free(discover->mcast[i]);
+		discover->mcast[i] = NULL;
+	}
+}
+
+static int fip_discover_mcast_recnct(struct fip_dev_priv *priv)
+{
+	fip_discover_mcast_disconnect(priv);
+	return fip_discover_mcast_connect(priv);
+}
+
+/*
+ * This function unjoins and rejoins all the mcasts used for a specific port.
+ * This includes 2 mcasts used by the discovery and the mcasts used for the
+ * vnics attached to the various GW using the port.
+*/
+void fip_refresh_mcasts(struct work_struct *work)
+{
+	struct fip_discover *discover =
+	    container_of(work, struct fip_discover, mcast_refresh_task);
+	struct fip_dev_priv *priv =
+	    container_of(discover, struct fip_dev_priv, discover);
+
+	if (discover->flush)
+		return;
+
+	fip_dbg(priv, LOG_PRIO_LOW, "discover_refresh_mcast: "
+		"calling discover_mcast_recnct\n");
+	if (fip_discover_mcast_recnct(priv))
+		fip_warn(priv, "discover_refresh_mcast: "
+			 "discover_mcast_recnct failed\n");
+}
+
+static int fcoib_els_over_fip_cb(u64 gw_discovery_handle,
+				 u64 gw_fc_handle,
+				 enum els_over_fip_type type,
+				 u8 *els, u32 host_data_qpn)
+{
+	struct fip_gw_data *curr_gw;
+	int ret = -EINVAL;
+
+	curr_gw = (struct fip_gw_data *)gw_discovery_handle;
+
+	switch (type) {
+	case FLOGI_OVER_FIP:
+		curr_gw->vhba_ka_tmr_valid = 0;
+		curr_gw->state = FIP_GW_SENT_FLOGI;
+
+		curr_gw->fc_handle = gw_fc_handle;
+		ret = fcoib_flogi_request_send(curr_gw->priv,
+					       curr_gw, els, host_data_qpn);
+		break;
+
+	case LOGO_OVER_FIP:
+		ret = fcoib_logo_request_send(curr_gw->priv,
+					      curr_gw, els, host_data_qpn);
+		break;
+	}
+	return ret;
+}
+
+static void fip_handle_gw_timers(struct fip_gw_data *curr_gw)
+{
+	if (curr_gw->host_ka_tmr_valid &&
+	    time_after_eq(jiffies, curr_gw->host_ka_tmr)) {
+		curr_gw->host_ka_tmr = jiffies + FKA_ADV_PERIOD * HZ;
+		fcoib_ioa_alive_send(curr_gw->priv, curr_gw);
+	}
+
+	if (curr_gw->vhba_ka_tmr_valid &&
+	    time_after_eq(jiffies, curr_gw->vhba_ka_tmr)) {
+		curr_gw->vhba_ka_tmr = jiffies + 90 * HZ;
+		fcoib_vhba_alive_send(curr_gw->priv, curr_gw);
+	}
+
+	if (curr_gw->gw_ka_tmr_valid &&
+	    time_after_eq(jiffies, curr_gw->gw_ka_tmr)) {
+		curr_gw->gw_ka_tmr = jiffies + 3 * FKA_ADV_PERIOD * HZ;
+		printk(KERN_WARNING
+		       "no keep alives from GW remove GW\n");
+		fip_close_gw(curr_gw);
+	}
+}
+
+static inline u64 guid_to_mac(u64 guid)
+{
+	return (guid & 0xffffff) | ((guid & 0xffffff0000000000) >> 16);
+}
+
+static void fip_gw_fsm(struct work_struct *work)
+{
+	struct fip_gw_data *curr_gw = container_of(work,
+						   struct fip_gw_data,
+						   gw_task.work);
+	int ret;
+	unsigned long next_wakeup = (3 * FKA_ADV_PERIOD * HZ);	/* timeout */
+	unsigned long rand = jiffies % 100;
+	u64 wwn, wwnn, wwpn;
+
+	if (curr_gw->flush)
+		return;
+
+	switch (curr_gw->state) {
+	case FIP_GW_RCVD_UNSOL_AD:
+		fip_dbg(curr_gw->priv, LOG_PRIO_VERY_LOW,
+			"Discover login, gw_mcast_rcv\n");
+		ret = 0;
+		curr_gw->state = FIP_GW_SENT_SOL;
+		ret = fcoib_solicit_send(curr_gw->priv,
+					 FIP_DISCOVER_UCAST,
+					 curr_gw->info.gw_qpn,
+					 curr_gw->info.gw_lid);
+		if (ret)
+			next_wakeup = (rand * HZ) / 250;
+		else
+			next_wakeup = (rand * HZ) / 25;
+		break;
+	case FIP_GW_RCVD_SOL_AD:
+		/* if GW was ACKed */
+		fip_dbg(curr_gw->priv, LOG_PRIO_VERY_LOW,
+			"Discover login, gw_ack_rcv\n");
+		curr_gw->state = FIP_GW_WAITING_FOR_FLOGI;
+		wwn =
+		    guid_to_mac(be64_to_cpu
+				(curr_gw->priv->local_gid.global.interface_id));
+		wwnn = wwn | ((u64) 0x10 << 56);
+		wwpn = wwn | ((u64) 0x20 << 56) |
+		    ((u64) (curr_gw->info.gw_port_id & 0xfff) << 48);
+
+		ret = fcoib_create_vhba(curr_gw->priv->ca,
+					curr_gw->priv->port,
+					curr_gw->priv->max_ib_mtu,
+					curr_gw->info.gw_lid,
+					curr_gw->info.sl,
+					(u64) curr_gw,
+					fcoib_els_over_fip_cb, wwpn, wwnn);
+		if (ret) {
+			fip_dbg(curr_gw->priv, LOG_PRIO_VERY_LOW,
+				"discover login: failed create vhba\n");
+			curr_gw->state = FIP_GW_RCVD_SOL_AD;
+			break;
+		}
+		curr_gw->host_ka_tmr = jiffies;
+		curr_gw->host_ka_tmr_valid = 1;
+		curr_gw->gw_ka_tmr = jiffies + FKA_ADV_PERIOD * 3 * HZ;
+		curr_gw->gw_ka_tmr_valid = 1;
+		break;
+	case FIP_GW_RCVD_FLOGI_ACCPT:
+		fip_dbg(curr_gw->priv, LOG_PRIO_LOW,
+			"discover login: GW_CONNECTED!!!\n");
+		next_wakeup = FKA_ADV_PERIOD * HZ;
+		if (!curr_gw->vhba_ka_tmr_valid) {
+			curr_gw->vhba_ka_tmr = jiffies + 90 * HZ;
+			curr_gw->vhba_ka_tmr_valid = 1;
+		}
+		break;
+	default:
+		break;
+	}
+
+	fip_handle_gw_timers(curr_gw);
+
+	/* go to sleep until time out. We expect that we will be awaken by
+	 * RX packets and never get to wake up due to timeout
+	 */
+	if (next_wakeup > FKA_ADV_PERIOD * HZ)
+		next_wakeup = FKA_ADV_PERIOD * HZ;
+
+	cancel_delayed_work(&curr_gw->gw_task);
+	queue_delayed_work(fip_workqueue, &curr_gw->gw_task, next_wakeup);
+}
+
+/*
+ * This is the discover finite state machine that runs the
+ * advertise and solicit packet exchange of the discovery
+ * process.
+ * It is assumed that this function is only called from work queue
+ * task context (for locking)
+ */
+void fip_discover_fsm(struct work_struct *work)
+{
+	struct fip_discover *discover =
+	    container_of(work, struct fip_discover, task.work);
+	struct fip_dev_priv *priv =
+	    container_of(discover, struct fip_dev_priv, discover);
+	int recall_time = -1;
+
+	/* we got a flush request and we have not performed it yet */
+	if (discover->flush && discover->state != FIP_DISCOVER_OFF) {
+		fip_dbg(priv, LOG_PRIO_LOW,
+			"==>discover_fsm switching to OFF\n");
+
+		recall_time = DELAYED_WORK_CLEANUP_JIFFS * 2;
+
+		/* if we failed to remove all GWs we
+		 * will retry to remove them */
+		if (fip_free_gw_list(priv)) {
+			fip_dbg(priv, LOG_PRIO_LOW,
+				"fip_free_gw_list not done, recalling\n");
+			goto recall_fsm;
+		}
+		fip_dbg(priv, LOG_PRIO_LOW, "fip_free_gw_list done\n");
+
+		fip_discover_mcast_disconnect(priv);
+
+		if (fip_mcast_stop_thread(&priv->mcast)) {
+			fip_dbg(priv, LOG_PRIO_LOW, "fip_mcast_stop_thread"
+				" not done, recalling\n");
+			goto recall_fsm;
+		}
+
+		discover->state = FIP_DISCOVER_OFF;
+
+		/* signal the unload to continue */
+		up(&priv->discover.flush_done);
+		return;
+	}
+
+	if (FIP_DISCOVER_OFF)
+		return;
+
+	if (!priv->local_lid) {
+		recall_time = 1 * HZ;
+		goto recall_fsm;
+	}
+
+	switch (discover->state) {
+	case FIP_DISCOVER_OFF:
+		return;
+	case FIP_DISCOVER_INIT:
+		fip_dbg(priv, LOG_PRIO_LOW, "DISCOVER_INIT\n");
+		/* in init try and join the discover multicast group
+		 * This is a preliminary request for all other progress */
+		if (fip_discover_mcast_connect(priv)) {
+			fip_warn(priv, "failed to join MCAST groups "
+				 "allocate queues\n");
+			/* try again later */
+			recall_time = 1 * HZ;
+		}
+		break;
+
+	case FIP_DISCOVER_SOLICIT:
+		/* future mcast solicitation requests may be inserted here */
+		discover->state = FIP_DISCOVER_LOGIN;
+		discover->backoff_time = -1;
+		break;
+
+	case FIP_DISCOVER_LOGIN:
+		/* do nothing */
+		break;
+
+	default:
+		fip_warn(priv, "discover->state in illegal state %d\n",
+			discover->state);
+		break;
+
+	}
+
+recall_fsm:
+	if (recall_time >= 0)
+		queue_delayed_work(fip_workqueue, &discover->task, recall_time);
+
+	return;
+}
diff --git a/drivers/scsi/mlx4_fc/fcoib_main.c b/drivers/scsi/mlx4_fc/fcoib_main.c
new file mode 100644
index 0000000..393eac7
--- /dev/null
+++ b/drivers/scsi/mlx4_fc/fcoib_main.c
@@ -0,0 +1,1211 @@
+/*
+ * Copyright (c) 2010 Mellanox Technologies. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/kernel.h>
+#include <linux/vmalloc.h>
+#include <linux/ip.h>
+#include <linux/in.h>
+
+#include <net/dst.h>
+
+#include "fcoib.h"
+
+MODULE_DESCRIPTION("FCoIB Discovery");
+MODULE_LICENSE("Dual BSD/GPL");
+
+int fip_debug = LOG_PRIO_HIGH;
+module_param_named(fip_debug_level, fip_debug, int, 0644);
+MODULE_PARM_DESC(fip_debug_level, "set verbosity level of debug message");
+
+struct workqueue_struct *fip_workqueue;
+struct workqueue_struct *fip_mng_workqueue;
+struct ib_sa_client fip_sa_client;
+
+static inline void fip_wr_pepare(struct fip_dev_priv *priv,
+				 struct ib_send_wr *tx_wr,
+				 struct ib_sge *tx_sge,
+				 unsigned int wr_id, u64 mapping,
+				 int size, u16 pkey_index)
+{
+	memset(tx_wr, 0, sizeof(struct ib_send_wr));
+	tx_wr->num_sge = 1;
+	tx_wr->sg_list = tx_sge;
+	tx_wr->opcode = IB_WR_SEND;
+	tx_wr->send_flags = IB_SEND_SIGNALED | IB_SEND_SOLICITED;
+	tx_wr->wr.ud.pkey_index = pkey_index;
+	tx_wr->wr_id = wr_id;
+
+	memset(tx_sge, 0, sizeof(struct ib_sge));
+	tx_sge->lkey = priv->mr->lkey;
+	tx_sge->addr = mapping;
+	tx_sge->length = size;
+}
+
+/*
+ * send a single multicast packet.
+ * return 0 on success, other on failure.
+*/
+int fip_mcast_send(struct fip_dev_priv *priv, struct ib_qp *qp,
+		   unsigned int wr_id, u64 mapping,
+		   int size, u16 pkey_index, struct mcast_entry *mcast)
+{
+	struct ib_send_wr *bad_wr;
+	struct ib_sge tx_sge;
+	struct ib_send_wr tx_wr;
+	int ret;
+
+	fip_wr_pepare(priv, &tx_wr, &tx_sge, wr_id, mapping, size, pkey_index);
+
+	tx_wr.wr.ud.ah = mcast->ah;
+	tx_wr.wr.ud.remote_qpn = 0xFFFFFFFF;
+	tx_wr.wr.ud.remote_qkey = mcast->qkey;
+
+	ret = ib_post_send(qp, &tx_wr, &bad_wr);
+
+	return ret;
+}
+
+/*
+ * send a single unicast packet.
+ * return 0 on success, other on failure.
+*/
+int fip_ucast_send(struct fip_dev_priv *priv, struct ib_qp *qp,
+		   unsigned int wr_id, u64 mapping,
+		   int size, u16 pkey_index, u32 dest_qpn, u16 dlid, u32 qkey)
+{
+	struct ib_send_wr *bad_wr;
+	struct ib_ah *new_ah;
+	struct ib_sge tx_sge;
+	struct ib_send_wr tx_wr;
+	int ret;
+	struct ib_ah_attr ah_attr = {
+		.dlid = dlid,
+		.port_num = priv->port,
+	};
+
+	fip_wr_pepare(priv, &tx_wr, &tx_sge, wr_id, mapping, size, pkey_index);
+
+	new_ah = ib_create_ah(priv->pd, &ah_attr);
+	if (IS_ERR(new_ah))
+		return -1;
+
+	tx_wr.wr.ud.ah = new_ah;
+	tx_wr.wr.ud.remote_qpn = dest_qpn;
+	tx_wr.wr.ud.remote_qkey = qkey;
+
+	ret = ib_post_send(qp, &tx_wr, &bad_wr);
+
+	ib_destroy_ah(new_ah);
+
+	return ret;
+}
+
+/*
+ * This is a general purpose CQ completion function that handles
+ * completions on RX and TX rings. It can serve all users that are
+ * using RX and TX rings.
+ * RX completions are destinguished from TX comp by the MSB that is set
+ * for RX and clear for TX. For RX, the memory is unmapped from the PCI,
+ * The head is incremented. For TX the memory is unmapped and then freed.
+ * The function returns the number of packets received.
+*/
+int fip_comp(struct fip_dev_priv *priv, struct ib_cq *cq,
+	     struct ring *rx_ring, struct ring *tx_ring)
+{
+#define FIP_DISCOVER_WC_COUNT 4
+	struct ib_wc ibwc[FIP_DISCOVER_WC_COUNT];
+	int wrid, n, i;
+	int mtu_size = FIP_UD_BUF_SIZE(priv->max_ib_mtu);
+	int rx_count = 0;
+
+	do {
+		/*
+		 * poll for up to FIP_DISCOVER_WC_COUNT in one request. n
+		 * returns the number of WC actually polled
+		 */
+		n = ib_poll_cq(cq, FIP_DISCOVER_WC_COUNT, ibwc);
+		for (i = 0; i < n; ++i) {
+			/*
+			 * use a mask on the id to decide if this is a receive
+			 * or  transmit WC
+			 */
+			if (ibwc[i].wr_id & FIP_OP_RECV) {
+				wrid = ibwc[i].wr_id & ~FIP_OP_RECV;
+
+				ib_dma_unmap_single(priv->ca,
+						    rx_ring->ring[wrid].
+						    bus_addr, mtu_size,
+						    DMA_FROM_DEVICE);
+
+				/* */
+				if (likely(ibwc[i].status == IB_WC_SUCCESS)) {
+					rx_ring->ring[wrid].length =
+					    ibwc[i].byte_len;
+					rx_ring->head =
+					    (wrid + 1) & (rx_ring->size - 1);
+					rx_count++;
+				} else {
+					rx_ring->ring[wrid].length = 0;
+					kfree(rx_ring->ring[wrid].mem);
+				}
+			} else {	/* TX completion */
+				wrid = ibwc[i].wr_id;
+
+				/* unmap and free transmitted packet */
+				ib_dma_unmap_single(priv->ca,
+						    tx_ring->ring[wrid].
+						    bus_addr, ibwc[i].byte_len,
+						    DMA_TO_DEVICE);
+
+				kfree(tx_ring->ring[wrid].mem);
+				tx_ring->ring[wrid].length = 0;
+				tx_ring->tail = wrid;
+			}
+		}
+	} while (n == FIP_DISCOVER_WC_COUNT);
+
+	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
+
+	return rx_count;
+}
+
+/* qonfigure a newly allocated QP and move it
+ * from reset->init->RTR->RTS
+ */
+int fip_init_qp(struct fip_dev_priv *priv, struct ib_qp *qp,
+		u16 pkey_index, u32 qkey)
+{
+	int ret;
+	struct ib_qp_attr qp_attr;
+	int attr_mask;
+
+	/* TODO - fix this
+	   if (!test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags))
+	   return -1; */
+
+	qp_attr.qp_state = IB_QPS_INIT;
+	qp_attr.qkey = qkey;
+	qp_attr.port_num = priv->port;
+	qp_attr.pkey_index = pkey_index;
+	attr_mask = IB_QP_QKEY | IB_QP_PORT | IB_QP_PKEY_INDEX | IB_QP_STATE;
+	ret = ib_modify_qp(qp, &qp_attr, attr_mask);
+	if (ret) {
+		fip_warn(priv, "failed to modify QP to init, ret = %d\n", ret);
+		fip_warn(priv, "qkey=%d, port_num=%d, pkey_index=0x%x,"
+			 " pkey_index=0x%x\n", (int)qp_attr.qkey,
+			 (int)qp_attr.port_num, (int)priv->pkey_index,
+			 (int)qp_attr.pkey_index);
+		goto out_fail;
+	}
+
+	qp_attr.qp_state = IB_QPS_RTR;
+	/* Can't set this in a INIT->RTR transition */
+	attr_mask &= ~IB_QP_PORT;
+	ret = ib_modify_qp(qp, &qp_attr, attr_mask);
+	if (ret) {
+		fip_warn(priv, "failed to modify QP to RTR, ret = %d\n", ret);
+		goto out_fail;
+	}
+
+	qp_attr.qp_state = IB_QPS_RTS;
+	qp_attr.sq_psn = 0;
+	attr_mask |= IB_QP_SQ_PSN;
+	attr_mask &= ~IB_QP_PKEY_INDEX;
+	ret = ib_modify_qp(qp, &qp_attr, attr_mask);
+	if (ret) {
+		fip_warn(priv, "failed to modify QP to RTS, ret = %d\n", ret);
+		goto out_fail;
+	}
+
+	return 0;
+
+out_fail:
+	qp_attr.qp_state = IB_QPS_RESET;
+	if (ib_modify_qp(qp, &qp_attr, IB_QP_STATE))
+		fip_warn(priv, "Failed to modify QP to RESET state\n");
+
+	return ret;
+}
+
+void fip_qp_to_err(struct fip_dev_priv *priv, struct ib_qp *qp)
+{
+	struct ib_qp_attr qp_attr;
+	struct ib_qp_init_attr qp_init_attr;
+	int timeout = 0;
+
+	qp_attr.qp_state = IB_QPS_ERR;
+	if (ib_modify_qp(qp, &qp_attr, IB_QP_STATE))
+		fip_warn(priv, "Failed to modify QP to RESET state\n");
+
+	do {
+		msleep(1 * (timeout != 0));
+		ib_query_qp(qp, &qp_attr, IB_QP_CUR_STATE, &qp_init_attr);
+		timeout++;
+	} while (qp_attr.cur_qp_state != IB_QPS_ERR && timeout < 100);
+
+	WARN_ON(qp_attr.cur_qp_state != IB_QPS_ERR);
+
+	return;
+}
+
+/*
+ * alloc a single buffer, map it and post it to the qp.
+ * id used to identify entry in receive queue.
+ */
+int fip_post_receive(struct fip_dev_priv *priv,
+		     struct ib_qp *qp,
+		     int size, int id, char *mem, struct ring_entry *mem_entry)
+{
+	struct ib_recv_wr rx_wr, *bad_wr;
+	struct ib_sge rx_sge;
+	int ret;
+
+	if (!mem) {
+		mem_entry->mem = kmalloc(size, GFP_KERNEL);
+		if (unlikely(!mem_entry->mem)) {
+			mem_entry->length = 0;
+			return -ENOMEM;
+		}
+	} else
+		mem_entry->mem = mem;
+
+	mem_entry->length = size;
+	mem_entry->bus_addr = ib_dma_map_single(priv->ca, mem_entry->mem, size,
+						DMA_FROM_DEVICE);
+
+	if (unlikely(ib_dma_mapping_error(priv->ca, mem_entry->bus_addr)))
+		goto error;
+
+	rx_wr.wr_id = id | FIP_OP_RECV;
+	rx_wr.next = NULL;
+	rx_wr.sg_list = &rx_sge;
+	rx_wr.num_sge = 1;
+	rx_sge.addr = mem_entry->bus_addr;
+	rx_sge.length = size;
+	rx_sge.lkey = priv->mr->lkey;
+
+	ret = ib_post_recv(qp, &rx_wr, &bad_wr);
+	if (unlikely(ret)) {
+		fip_warn(priv, "post receive failed for buf %d (%d)\n", id,
+			 ret);
+		goto post_recv_failed;
+	}
+	return 0;
+
+post_recv_failed:
+	ib_dma_unmap_single(priv->ca, rx_sge.addr, size, DMA_FROM_DEVICE);
+
+error:
+	mem_entry->length = 0;
+	kfree(mem_entry->mem);
+	return -EIO;
+}
+
+void fip_flush_rings(struct fip_dev_priv *priv,
+		     struct ib_cq *cq,
+		     struct ib_qp *qp,
+		     struct ring *rx_ring, struct ring *tx_ring)
+{
+	fip_dbg(priv, LOG_PRIO_LOW, "fip_qp_to_err called\n");
+	fip_qp_to_err(priv, qp);
+
+	spin_lock_irq(&priv->discover.lock);
+	fip_comp(priv, cq, rx_ring, tx_ring);
+	spin_unlock_irq(&priv->discover.lock);
+}
+
+void fip_free_rings(struct fip_dev_priv *priv,
+		    struct ring *rx_ring, struct ring *tx_ring)
+{
+	int i;
+
+	for (i = rx_ring->size - 1; i >= 0; i--)
+		if (rx_ring->ring[i].length != 0) {
+			ib_dma_unmap_single(priv->ca,
+					    rx_ring->ring[i].bus_addr,
+					    rx_ring->ring[i].length,
+					    DMA_FROM_DEVICE);
+			kfree(rx_ring->ring[i].mem);
+		}
+	rx_ring->size = 0;
+
+	for (i = tx_ring->size - 1; i >= 0; i--)
+		if (tx_ring->ring[i].length != 0) {
+			ib_dma_unmap_single(priv->ca,
+					    tx_ring->ring[i].bus_addr,
+					    tx_ring->ring[i].length,
+					    DMA_TO_DEVICE);
+			kfree(tx_ring->ring[i].mem);
+		}
+	tx_ring->size = 0;
+
+	fip_dbg(priv, LOG_PRIO_LOW, "==>Done cleaning RX and TX queues\n");
+
+	kfree(rx_ring->ring);
+	rx_ring->ring = NULL;
+	kfree(tx_ring->ring);
+	tx_ring->ring = NULL;
+}
+
+/*
+ * TODO - we can do a nicer job here. stage 2
+ *  allocates memory and post receives
+ */
+int fip_init_rx(struct fip_dev_priv *priv,
+		int ring_size, struct ib_qp *qp, struct ring *rx_ring)
+{
+	int i;
+	int mtu_size = FIP_UD_BUF_SIZE(priv->max_ib_mtu);
+
+	rx_ring->size = ring_size;
+	rx_ring->ring = kmalloc(rx_ring->size * sizeof(struct ring_entry),
+				GFP_KERNEL);
+	if (unlikely(!rx_ring->ring)) {
+		rx_ring->size = 0;
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < rx_ring->size; i++) {
+		if (fip_post_receive(priv, qp, mtu_size, i, NULL,
+				     rx_ring->ring + i)) {
+			/* we can not release memory without flushing QP */
+			for (; i < rx_ring->size; ++i) {
+				rx_ring->ring[i].mem = NULL;
+				rx_ring->ring[i].length = 0;
+			}
+			return -EIO;
+		}
+	}
+
+	rx_ring->head = 0;
+	rx_ring->tail = 0;
+
+	return 0;
+}
+
+/*
+ * This function allocates the tx buffers and initializes the head and
+ * tail indexes.
+ */
+int fip_init_tx(struct fip_dev_priv *priv, int size, struct ring *tx_ring)
+{
+	tx_ring->size = size;
+	tx_ring->ring = kzalloc(tx_ring->size * sizeof(struct ring_entry),
+				GFP_KERNEL);
+
+	if (!tx_ring->ring) {
+		fip_warn(priv, "fip_init_tx failed in alloc of tx. size=%d\n",
+			 tx_ring->size);
+		tx_ring->size = 0;
+		return -ENOMEM;
+	}
+
+	tx_ring->head = 0;
+	tx_ring->tail = tx_ring->size - 1;
+	return 0;
+}
+
+/*
+ * Allocate a PD and MR that will be used by all
+ * of the port's IB resources.
+ * Call fip_dev_cleanup to release
+ * the allocated resources.
+ */
+int fip_dev_init(struct fip_dev_priv *priv)
+{
+	struct ib_device *ca = priv->ca;
+
+	priv->pd = ib_alloc_pd(priv->ca);
+	if (IS_ERR(priv->pd)) {
+		fip_warn(priv, "%s: failed to allocate PD\n", ca->name);
+		return -ENODEV;
+	}
+
+	priv->mr = ib_get_dma_mr(priv->pd, IB_ACCESS_LOCAL_WRITE);
+	if (IS_ERR(priv->mr)) {
+		fip_warn(priv, "%s: ib_get_dma_mr failed\n", ca->name);
+		goto out_free_pd;
+	}
+
+	return 0;
+
+out_free_pd:
+	ib_dealloc_pd(priv->pd);
+	return -ENODEV;
+}
+
+/*
+ * cleanup resources allocated by fip_dev_init
+*/
+void fip_dev_cleanup(struct fip_dev_priv *priv)
+{
+	/*ipoib_cm_dev_cleanup(dev); */
+
+	if (ib_dereg_mr(priv->mr))
+		fip_warn(priv, "ib_dereg_mr failed\n");
+
+	if (ib_dealloc_pd(priv->pd))
+		fip_warn(priv, "ib_dealloc_pd failed\n");
+}
+
+/* trigered by a core event */
+void fip_event(struct ib_event_handler *handler, struct ib_event *record)
+{
+	struct fip_dev_priv *priv =
+	    container_of(handler, struct fip_dev_priv, event_handler);
+
+	if (record->element.port_num != priv->port)
+		return;
+
+	switch (record->event) {
+	case IB_EVENT_SM_CHANGE:
+	case IB_EVENT_CLIENT_REREGISTER:
+	case IB_EVENT_PORT_ACTIVE:	/* link up */
+		/* queue restart of discovery a bit
+		 * delayed to prevent threshing */
+		queue_work(fip_workqueue, &priv->discover.mcast_refresh_task);
+		fip_dbg(priv, LOG_PRIO_MED, "==> event=%d (CLIENT_REREGISTER,"
+			" or SM_CHANGE or PORT_ACTIVE)\n", record->event);
+		break;
+
+	case IB_EVENT_PKEY_CHANGE:
+	case IB_EVENT_DEVICE_FATAL:
+	case IB_EVENT_LID_CHANGE:
+		queue_delayed_work(fip_mng_workqueue,
+				   &priv->restart_task, HZ / 10);
+		fip_dbg(priv, LOG_PRIO_MED,
+			"event=%d (PKEY_CHANGE or LID_CHANGE\n", record->event);
+		break;
+	case IB_EVENT_PORT_ERR:
+	case IB_EVENT_SRQ_ERR:
+	case IB_EVENT_SRQ_LIMIT_REACHED:
+	case IB_EVENT_QP_LAST_WQE_REACHED:
+	default:
+		fip_dbg(priv, LOG_PRIO_MED, "event=%d unhandled\n",
+			record->event);
+		break;
+	}
+}
+
+static inline int backoff_delay(struct mcast_entry *mcast)
+{
+	int delay = (mcast->backoff * HZ) + (jiffies % (HZ / 10));
+
+	mcast->backoff *= 2;
+	mcast->backoff = (mcast->backoff > FIP_MAX_BACKOFF_SECONDS) ?
+	    FIP_MAX_BACKOFF_SECONDS : mcast->backoff;
+	return delay;
+}
+
+static struct mcast_entry *mcast_alloc(void)
+{
+	struct mcast_entry *mcast;
+
+	mcast = kzalloc(sizeof *mcast, GFP_KERNEL);
+	if (!mcast)
+		return NULL;
+
+	atomic_set(&mcast->ref_cnt, 0);
+	INIT_LIST_HEAD(&mcast->list);
+	return mcast;
+}
+
+static void mcast_requeue_task(struct port_mcast_data *port_mcast, int delay)
+{
+	mutex_lock(&port_mcast->mlock);
+	if (!test_bit(MCAST_TASK_STOPPED, &port_mcast->flags))
+		queue_delayed_work(fip_workqueue, &port_mcast->mcast_task,
+				   delay);
+	mutex_unlock(&port_mcast->mlock);
+}
+
+/*
+ * This function attaches a QP to a multicast group for receive.
+ * If you only use the mcast for transmit you don't neet to call
+ * this function. The function sets the QP's QKEY to the mcask QKEY
+ * and adds the QP to the mcast group filter. If the mcast was not
+ * joined for RX or the mcast joined is not done the function
+ * returns an error. Caller must hold the mcast->lock.
+*/
+static int mcast_attach(struct mcast_entry *mcast, struct ib_qp *qp)
+{
+	if (test_bit(MCAST_FLAG_ATTACHED, &mcast->flags))
+		return 0;
+
+	/* attach QP to multicast group */
+	if (ib_attach_mcast(qp, &mcast->mcmember.mgid,
+			    be16_to_cpu(mcast->mcmember.mlid)))
+		goto attach_failed;
+
+	set_bit(MCAST_FLAG_ATTACHED, &mcast->flags);
+	return 0;
+
+attach_failed:
+	printk(KERN_ALERT "mlx4_fcoib: mcast_attach failed\n");
+	return -1;
+}
+
+/*
+ * This function creates an address header for a multicast group needed
+ * for TX (only). If the AH was previously created the previously created
+ * AH will be used and the function will return success. Caller must hold
+ * the mcast->lock.
+*/
+static int mcast_create_ah(struct mcast_entry *mcast)
+{
+	struct port_mcast_data *port_mcast = mcast->port_mcast;
+	struct ib_ah_attr av = {
+		.dlid = be16_to_cpu(mcast->mcmember.mlid),
+		.port_num = port_mcast->port,
+		.sl = mcast->mcmember.sl,
+		.ah_flags = IB_AH_GRH,
+		.static_rate = mcast->mcmember.rate,
+		.grh = {
+			.flow_label = be32_to_cpu(mcast->mcmember.flow_label),
+			.hop_limit = mcast->mcmember.hop_limit,
+			.sgid_index = 0,
+			.traffic_class = mcast->mcmember.traffic_class}
+	};
+
+	if (test_bit(MCAST_FLAG_AH_SET, &mcast->flags))
+		return 0;
+
+	av.grh.dgid = mcast->mcmember.mgid;
+
+	/* create multicast ah that will be used for all
+	 * traffic of this mcast group */
+	mcast->ah = ib_create_ah(port_mcast->pd, &av);
+
+	if (IS_ERR(mcast->ah)) {
+		printk(KERN_ALERT
+		       "mlx4_fcoib: mcast_create_ah, failed to alloc ah\n");
+		mcast->ah = NULL;
+		goto create_ah_failed;
+	}
+
+	set_bit(MCAST_FLAG_AH_SET, &mcast->flags);
+	return 0;
+
+create_ah_failed:
+	return -ENODEV;
+}
+
+/*
+ * Called as a callback to ib_sa_join_multicast after join termination. Checks
+ * that termination was successful and if so calls mcast_join_finish
+ * to attach a QP to it and recalls mcast_task (maybe add more mcasts).
+ * If join failed marks the mcast address as ready for retry and calls
+ * mcast_task with exponential backoff.
+*/
+static int mcast_join_complete(int status, struct ib_sa_multicast *multicast)
+{
+	struct mcast_entry *mcast = multicast->context;
+
+	/* We trap for port events ourselves. */
+	if (status == -ENETRESET)
+		return 0;
+
+	/* join_complete is OK */
+	if (status)
+		goto retry_join_mcast;
+
+	mcast->mcmember = multicast->rec;
+
+	set_bit(MCAST_FLAG_JOINED, &mcast->flags);
+
+	if (test_bit(MCAST_FLAG_RECV, &mcast->flags) &&
+	    mcast_attach(mcast, mcast->qp)) {
+		printk(KERN_ALERT "mlx4_fcoib: mcast_attach failed\n");
+		goto retry_join_mcast;
+	}
+
+	if (test_bit(MCAST_FLAG_SEND, &mcast->flags) &&
+	    mcast_create_ah(mcast)) {
+		printk(KERN_ALERT "mlx4_fcoib: mcast_create_ah failed\n");
+		goto unattach_mcast;
+	}
+
+	set_bit(MCAST_FLAG_DONE, &mcast->flags);
+
+	if (mcast->callback)
+		mcast->callback(mcast, mcast->context);
+
+	/* this is to make sure no one uses the context after the
+	 * callback */
+	mcast->context = NULL;
+
+	/* we will queue mcast_task again to process
+	 * other mcast join requests */
+	mcast_requeue_task(mcast->port_mcast, 0);
+	atomic_dec(&mcast->ref_cnt);
+	return 0;
+
+unattach_mcast:
+	if (test_and_clear_bit(MCAST_FLAG_ATTACHED, &mcast->flags)) {
+		ib_detach_mcast(mcast->qp,
+				&mcast->mcmember.mgid, mcast->mcmember.mlid);
+	}
+
+retry_join_mcast:
+	printk(KERN_ALERT "mlx4_fcoib: multicast join failed\n");
+
+	/* Clear the busy flag so we try again */
+	clear_bit(MCAST_FLAG_BUSY, &mcast->flags);
+
+	mcast_requeue_task(mcast->port_mcast, backoff_delay(mcast));
+	atomic_dec(&mcast->ref_cnt);
+	return -1;
+}
+
+/*
+ * Join a multicast group. The mcast GID must be up to date
+ * mcast->mcmember.mgid.
+ * This function should not be called directly because it might fail and it
+ * is assumed retries will be conducted by the mcast_task. instead add your
+ * multicast to the multicast_list and activate mcast_task.
+*/
+static int _mcast_join(struct port_mcast_data *port_mcast,
+		       struct mcast_entry *mcast, u16 pkey, u32 qkey)
+{
+	struct ib_sa_mcmember_rec rec = {
+		.join_state = 1
+	};
+	ib_sa_comp_mask comp_mask;
+	int ret = 0;
+
+	rec.mgid = mcast->mcmember.mgid;
+	rec.port_gid = port_mcast->local_gid;
+	rec.pkey = cpu_to_be16(pkey);
+
+	comp_mask =
+	    IB_SA_MCMEMBER_REC_MGID |
+	    IB_SA_MCMEMBER_REC_PORT_GID |
+	    IB_SA_MCMEMBER_REC_PKEY | IB_SA_MCMEMBER_REC_JOIN_STATE;
+
+	/*
+	 * we will attempt to join a multicast group. the reply will be
+	 * through the supplied callback mcast_join_complete.
+	 */
+	set_bit(MCAST_FLAG_BUSY, &mcast->flags);
+	mcast->sa_mcast = ib_sa_join_multicast(&fip_sa_client, port_mcast->ca,
+					       port_mcast->port, &rec,
+					       comp_mask, GFP_KERNEL,
+					       mcast_join_complete, mcast);
+
+	if (IS_ERR(mcast->sa_mcast)) {
+		clear_bit(MCAST_FLAG_BUSY, &mcast->flags);
+		ret = PTR_ERR(mcast->sa_mcast);
+		printk(KERN_ALERT "mlx4_fcoib: ib_sa_join_multicast failed\n");
+
+		/*
+		 * add a delayed call so it will retry
+		 * to join the mcast group later.
+		 */
+		mcast_requeue_task(port_mcast, backoff_delay(mcast));
+	}
+	return ret;
+}
+
+static int mcast_start_thread(struct port_mcast_data *port_mcast)
+{
+	mcast_requeue_task(port_mcast, 0);
+	return 0;
+}
+
+static int mcast_leave(struct mcast_entry *mcast, struct ib_qp *qp)
+{
+	if (test_and_set_bit(MCAST_FLAG_REMOVED, &mcast->flags))
+		return 0;
+
+	if (test_and_clear_bit(MCAST_FLAG_ATTACHED, &mcast->flags))
+		if (ib_detach_mcast(qp,
+				    &mcast->mcmember.mgid,
+				    mcast->mcmember.mlid))
+			printk(KERN_ALERT "mlx4_fcoib: "
+			       "ib_detach_mcast failed\n");
+
+	if (test_and_clear_bit(MCAST_FLAG_AH_SET, &mcast->flags))
+		if (ib_destroy_ah(mcast->ah))
+			printk(KERN_ALERT "mlx4_fcoib: ib_destroy_ah failed\n");
+
+	if (test_and_clear_bit(MCAST_FLAG_BUSY, &mcast->flags))
+		ib_sa_free_multicast(mcast->sa_mcast);
+
+	return 0;
+}
+
+/* free a mcast group. This function might sleep */
+void fip_mcast_free(struct mcast_entry *mcast)
+{
+	int max_wait = 10;
+
+	mutex_lock(&mcast->port_mcast->mlock);
+	list_del(&mcast->list);
+	mutex_unlock(&mcast->port_mcast->mlock);
+
+	while (atomic_read(&mcast->ref_cnt) && max_wait) {
+		msleep(50);
+		max_wait--;
+	}
+
+	if (mcast_leave(mcast, mcast->qp))
+		printk(KERN_ALERT "mlx4_fcoib: fip_mcast_free failed\n");
+
+	kfree(mcast);
+}
+
+/*
+ * Stop mcast task running on thread. If the work can not be stopped at the
+ * moment because it is pending or running the function would return an error
+ * (it would need to be recalled)
+ */
+int fip_mcast_stop_thread(struct port_mcast_data *port_mcast)
+{
+	mutex_lock(&port_mcast->mlock);
+	set_bit(MCAST_TASK_STOPPED, &port_mcast->flags);
+	cancel_delayed_work(&port_mcast->mcast_task);
+	mutex_unlock(&port_mcast->mlock);
+
+	if (delayed_work_pending(&port_mcast->mcast_task))
+		return -EBUSY;
+
+	return 0;
+}
+
+/*
+ * This function tries to join all the multicast groups that
+ * are currently presnt in port_mcast->multicast_list. The code
+ * goes over the list sequentially tries to join a single
+ * group per call. mcast groups that are already being processed
+ * are disregarded.
+ * To join an mcast group call fip_mcast_join. Do not call this
+ * function directly.
+*/
+void fip_mcast_join_task(struct work_struct *work)
+{
+	struct port_mcast_data *port_mcast =
+	    container_of(work, struct port_mcast_data, mcast_task.work);
+	int found = 0;
+
+	/* if multicast task is disabled return */
+	if (test_bit(MCAST_TASK_STOPPED, &port_mcast->flags))
+		return;
+
+	while (1) {
+		struct mcast_entry *mcast = NULL;
+
+		mutex_lock(&port_mcast->mlock);
+		list_for_each_entry(mcast, &port_mcast->multicast_list, list) {
+			if (!test_bit(MCAST_FLAG_BUSY, &mcast->flags) &&
+			    !test_bit(MCAST_FLAG_JOINED, &mcast->flags) &&
+			    !test_bit(MCAST_FLAG_REMOVED, &mcast->flags)) {
+				/* Found the next unjoined group */
+				found = 1;
+				atomic_inc(&mcast->ref_cnt);
+				break;
+			}
+		}
+		mutex_unlock(&port_mcast->mlock);
+
+		if (!found)
+			break;
+
+		if (_mcast_join(port_mcast, mcast, mcast->pkey, mcast->qkey))
+			atomic_dec(&mcast->ref_cnt);
+
+		break;
+	}
+}
+
+/*
+ * Join a new mcast address. The function receives a callback function to
+ * call upon completion of the join operation. Be mindful that
+ * a successful return of the function does not mean the mcast is joined.
+ */
+struct mcast_entry *fip_mcast_join(struct port_mcast_data *port_mcast,
+				    void *context, const char *mgid, u32 qkey,
+				    u16 pkey, struct ib_qp *qp,
+				    enum mcast_join_type type,
+				    void (*callback) (struct mcast_entry *,
+						      void *context))
+{
+	struct mcast_entry *mcast;
+
+	/* alloc a new mcast address */
+	mcast = mcast_alloc();
+	if (!mcast) {
+		printk(KERN_ALERT "mlx4_fcoib: "
+		       "fip_mcast_connect: mcast alloc failed\n");
+		goto mcast_connect_exit;
+	}
+
+	mcast->port_mcast = port_mcast;
+	mcast->callback = callback;
+	mcast->qkey = qkey;
+	mcast->pkey = pkey;
+	mcast->context = context;
+	mcast->qp = qp;
+	mcast->backoff = 1;
+
+	if (type != MCAST_SEND_ONLY)
+		set_bit(MCAST_FLAG_RECV, &mcast->flags);
+	if (type != MCAST_RECEIVE_ONLY)
+		set_bit(MCAST_FLAG_SEND, &mcast->flags);
+
+	memcpy(mcast->mcmember.mgid.raw, mgid, sizeof(union ib_gid));
+
+	mutex_lock(&port_mcast->mlock);
+	list_add_tail(&mcast->list, &port_mcast->multicast_list);
+	mutex_unlock(&port_mcast->mlock);
+
+	mcast_start_thread(port_mcast);
+
+	return mcast;
+
+mcast_connect_exit:
+	return NULL;
+}
+
+static void fip_add_one(struct ib_device *device);
+static void fip_remove_one(struct ib_device *device);
+
+static struct ib_client fip_client = {
+	.name = "fip",
+	.add = fip_add_one,
+	.remove = fip_remove_one
+};
+
+/*
+ * query the port for a few of it's properties like:
+ * LID, MTU, device capabilities, and GID. This function
+ * does not allocate any resources requiring cleanup.
+*/
+static int fip_query_port_caps(struct fip_dev_priv *priv, u8 port)
+{
+	struct ib_device_attr *device_attr;
+	struct ib_port_attr attr;
+	int result = -ENOMEM;
+
+	/* set max MTU */
+	if (!ib_query_port(priv->ca, port, &attr)) {
+		priv->local_lid = attr.lid;
+		priv->max_mtu_enum = attr.max_mtu;
+		priv->max_ib_mtu = ib_mtu_enum_to_int(attr.max_mtu);
+	} else {
+		fip_warn(priv, "%s: ib_query_port %d failed\n",
+			 priv->ca->name, port);
+		goto device_query_failed;
+	}
+
+	if (attr.phys_state == 3)	/* port disable */
+		goto device_query_failed;
+
+	/* MTU will be reset when mcast join happens */
+	priv->mtu = FIP_UD_MTU(priv->max_ib_mtu);
+	priv->mcast_mtu = priv->mtu;
+	/* rate in Gb/sec = speed * width * 2.5 Gb/sec (speed is 1,2,4) */
+	priv->rate = ((int)attr.active_speed *
+		      ib_width_enum_to_int(attr.active_width) * 25) / 10;
+
+	result = ib_query_pkey(priv->ca, port, 0, &priv->pkey);
+	if (result) {
+		fip_warn(priv, "%s: ib_query_pkey port %d failed"
+			 " (ret = %d)\n", priv->ca->name, port, result);
+		goto device_query_failed;
+	}
+
+	device_attr = kmalloc(sizeof(*device_attr), GFP_KERNEL);
+	if (!device_attr) {
+		fip_warn(priv, "%s: allocation of %zu bytes failed\n",
+			 priv->ca->name, sizeof(*device_attr));
+		goto device_query_failed;
+	}
+
+	result = ib_query_device(priv->ca, device_attr);
+	if (result) {
+		fip_warn(priv, "%s: ib_query_device failed (ret = %d)\n",
+			 priv->ca->name, result);
+		kfree(device_attr);
+		goto device_query_failed;
+	}
+	priv->hca_caps = device_attr->device_cap_flags;
+
+	kfree(device_attr);
+
+	/*
+	 * Set the full membership bit, so that we join the right
+	 * broadcast group, etc.
+	 */
+	priv->pkey |= 0x8000;
+
+	result = ib_query_gid(priv->ca, port, 0, &priv->local_gid);
+	if (result) {
+		fip_warn(priv, "%s: ib_query_gid port %d failed (ret = %d)"
+			 "\n", priv->ca->name, port, result);
+		goto device_query_failed;
+	}
+
+	return 0;
+
+device_query_failed:
+	return result;
+}
+
+static void fip_remove_port(struct fip_dev_priv *priv)
+{
+	ib_unregister_event_handler(&priv->event_handler);
+
+	mutex_lock(&priv->mlock);
+	fip_discover_cleanup(priv);
+	fip_dev_cleanup(priv);
+	mutex_unlock(&priv->mlock);
+}
+
+void fip_discover_restart(struct work_struct *work)
+{
+	struct fip_dev_priv *priv =
+	    container_of(work, struct fip_dev_priv, restart_task.work);
+	int result;
+
+	mutex_lock(&priv->mlock);
+	fip_discover_cleanup(priv);
+
+	/* config MTU, GID, HW offload caps etc */
+	if (fip_query_port_caps(priv, priv->port)) {
+		fip_warn(priv, "fip_query_port failed\n");
+		goto err_query_port;
+	}
+
+	/*
+	 * open discover QP and move it to RTS. Alloc RX+TX rings and
+	 * call the discover queue work for the discover finite state machine
+	 */
+	result = fip_discover_init(priv);
+	if (result != 0) {
+		fip_warn(priv, "Failed to alloc discover resources "
+			 "ret=%d\n", result);
+	}
+
+err_query_port:
+	mutex_unlock(&priv->mlock);
+	return;
+}
+
+static void init_port_mcast(struct fip_dev_priv *priv,
+			    struct port_mcast_data *mcast)
+{
+	mcast->flags = 0;
+	INIT_DELAYED_WORK(&mcast->mcast_task, fip_mcast_join_task);
+	INIT_LIST_HEAD(&mcast->multicast_list);
+	mutex_init(&mcast->mlock);
+	mcast->port = priv->port;
+	mcast->ca = priv->ca;
+	mcast->local_gid = priv->local_gid;
+	mcast->mcast_mtu = priv->max_mtu_enum;
+	mcast->pd = priv->pd;
+	mcast->rate = priv->rate;
+}
+
+static struct fip_dev_priv *fip_add_port(const char *format,
+					 struct ib_device *hca, u8 port)
+{
+	struct fip_dev_priv *priv;
+	int result = -ENOMEM;
+
+	priv = kzalloc(sizeof(struct fip_dev_priv), GFP_KERNEL);
+	if (!priv)
+		return ERR_PTR(-ENOMEM);
+
+	/* init priv data structure vars */
+	priv->ca = hca;
+	priv->port = port;
+
+	/* config MTU, GID, HW offload caps etc */
+	if (fip_query_port_caps(priv, port)) {
+		fip_warn(priv, "fip_query_port failed\n");
+		goto device_init_failed;
+	}
+
+	INIT_DELAYED_WORK(&priv->restart_task, fip_discover_restart);
+	spin_lock_init(&priv->lock);
+	mutex_init(&priv->mlock);
+
+	/* create MR, PD, ... */
+	result = fip_dev_init(priv);
+	if (result != 0) {
+		fip_warn(priv, "Failed to alloc device resources ret=%d\n",
+			 result);
+		goto device_init_failed;
+	}
+
+	init_port_mcast(priv, &priv->mcast);
+
+	/*
+	 * open discover QP and move it to RTS. Alloc RX+TX rings and
+	 * call the discover queue work for the discover finite state machine
+	 */
+	result = fip_discover_init(priv);
+	if (result != 0) {
+		fip_warn(priv, "Failed to alloc discover resources "
+			 "ret=%d\n", result);
+		goto discover_init_failed;
+	}
+
+	/*
+	 * TODO - fix event handler
+	 * register callbacks for core events like change in LID, PKEY,...
+	 */
+	INIT_IB_EVENT_HANDLER(&priv->event_handler, priv->ca, fip_event);
+	result = ib_register_event_handler(&priv->event_handler);
+	if (result != 0) {
+		fip_warn(priv, "%s: ib_register_event_handler failed for "
+			 "port %d (ret = %d)\n", hca->name, port, result);
+		goto event_failed;
+	}
+
+	return priv;
+
+event_failed:
+	fip_discover_cleanup(priv);
+discover_init_failed:
+	fip_dev_cleanup(priv);
+device_init_failed:
+	kfree(priv);
+	return ERR_PTR(result);
+}
+
+static void fip_add_one(struct ib_device *device)
+{
+	struct list_head *dev_list;
+	struct fip_dev_priv *priv;
+	int s, e, p;
+
+	/* check IB device is mlx4 device */
+	if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
+		return;
+
+	dev_list = kmalloc(sizeof(*dev_list), GFP_KERNEL);
+	if (!dev_list)
+		return;
+
+	INIT_LIST_HEAD(dev_list);
+
+	if (device->node_type == RDMA_NODE_IB_SWITCH) {
+		s = 0;
+		e = 0;
+	} else {
+		s = 1;
+		e = device->phys_port_cnt;
+	}
+
+	for (p = s; p <= e; ++p) {
+		priv = fip_add_port("ib%d", device, p);
+		if (!IS_ERR(priv)) {
+			/*priv = netdev_priv(dev); */
+			list_add_tail(&priv->list, dev_list);
+		}
+	}
+
+	ib_set_client_data(device, &fip_client, dev_list);
+}
+
+static void fip_remove_one(struct ib_device *device)
+{
+	struct fip_dev_priv *priv, *tmp;
+	struct list_head *dev_list;
+
+	if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
+		return;
+
+	dev_list = ib_get_client_data(device, &fip_client);
+	if (!dev_list) {
+		printk(KERN_WARNING "dev_list is NULL on %s\n", device->name);
+		return;
+	}
+
+	/* flush_workqueue(fip_workqueue); */
+
+	list_for_each_entry_safe(priv, tmp, dev_list, list) {
+		fip_remove_port(priv);
+		list_del(&priv->list);
+		kfree(priv);
+	}
+
+	kfree(dev_list);
+}
+
+static int __init fip_init_module(void)
+{
+	int ret;
+
+	fip_workqueue = create_singlethread_workqueue("fip");
+	if (!fip_workqueue) {
+		ret = -ENOMEM;
+		goto err_workqueue;
+	}
+
+	fip_mng_workqueue = create_singlethread_workqueue("fip_create");
+	if (!fip_mng_workqueue) {
+		ret = -ENOMEM;
+		goto err_mng_workqueue;
+	}
+
+	ib_sa_register_client(&fip_sa_client);
+
+	ret = ib_register_client(&fip_client);
+	if (ret)
+		goto err_sa;
+
+	return 0;
+
+err_sa:
+	ib_sa_unregister_client(&fip_sa_client);
+	destroy_workqueue(fip_mng_workqueue);
+err_mng_workqueue:
+	destroy_workqueue(fip_workqueue);
+err_workqueue:
+	return ret;
+}
+
+static void __exit fip_cleanup_module(void)
+{
+	ib_unregister_client(&fip_client);
+	ib_sa_unregister_client(&fip_sa_client);
+	destroy_workqueue(fip_mng_workqueue);
+	destroy_workqueue(fip_workqueue);
+}
+
+module_init(fip_init_module);
+module_exit(fip_cleanup_module);
diff --git a/drivers/scsi/mlx4_fc/mfc.c b/drivers/scsi/mlx4_fc/mfc.c
new file mode 100644
index 0000000..74f6062
--- /dev/null
+++ b/drivers/scsi/mlx4_fc/mfc.c
@@ -0,0 +1,2003 @@
+/*
+ * Copyright (c) 2010 Mellanox Technologies. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/if_vlan.h>
+#include <linux/vmalloc.h>
+#include <linux/kthread.h>
+#include <linux/rtnetlink.h>
+
+#include <scsi/fc/fc_fip.h>
+
+#include "mfc.h"
+
+#define DRV_NAME	"mlnx_fc"
+#define PFX		DRV_NAME ": "
+#define DRV_VERSION	"1.1"
+#define DRV_RELDATE	"Feb 2010"
+
+MODULE_AUTHOR("Oren Duer/Vu Pham");
+MODULE_DESCRIPTION("Mellanox CX FCoE/FCoIB driver");
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_VERSION(DRV_VERSION);
+
+int mfc_debug_mode;
+module_param_named(debug_mode, mfc_debug_mode, int, 0644);
+MODULE_PARM_DESC(debug_mode,
+		 "0 = None (default), 1 = use gw_mac as dest and burnt"
+		 " MAC as src.");
+
+char *gateway_mac;
+module_param_named(gw_mac, gateway_mac, charp, 0644);
+MODULE_PARM_DESC(gw_mac,
+		 "GW MAC. Used for Debug Mode 1. Format: XX:XX:XX:XX:XX:XX");
+u8 gw_mac[ETH_ALEN] = { 0, 0, 0, 0, 0, 0 };
+
+int mfc_payload_size = MLX4_DEFAULT_FC_MTU;
+module_param_named(frame_size, mfc_payload_size, int, 0444);
+MODULE_PARM_DESC(frame_size,
+		 "Frame payload size, default is "
+		 __stringify(MLX4_DEFAULT_FC_MTU));
+
+int mfc_num_reserved_xids = MLX4_DEFAULT_NUM_RESERVED_XIDS;
+module_param_named(num_reserved_xids, mfc_num_reserved_xids, int, 0444);
+MODULE_PARM_DESC(num_reserved_xids,
+		 "Max outstanding RFCI exchanges per virtual HBA. "
+		 "Default =  " __stringify(MLX4_DEFAULT_NUM_RESERVED_XIDS));
+
+int mfc_log_exch_per_vhba = MLX4_DEFAULT_LOG_EXCH_PER_VHBA;
+module_param_named(log_exch_per_vhba, mfc_log_exch_per_vhba, int, 0444);
+MODULE_PARM_DESC(log_exch_per_vhba,
+		 "Max outstanding FC exchanges per virtual HBA (log). "
+		 "Default =  " __stringify(MLX4_DEFAULT_LOG_EXCH_PER_VHBA));
+
+int max_vhba_per_port = MLX4_DEFAULT_MAX_VHBA_PER_PORT;
+module_param_named(max_vhba_per_port, max_vhba_per_port, int, 0444);
+MODULE_PARM_DESC(max_vhba_per_port, "Max vHBAs allowed per port. "
+		 "Default =  " __stringify(MLX4_DEFAULT_MAX_VHBA_PER_PORT));
+
+int max_cmd_per_lun = MFC_MAX_CMD_PER_LUN;
+module_param_named(cmd_per_lun, max_cmd_per_lun, int, 0444);
+MODULE_PARM_DESC(cmd_per_lun,
+		 "Max outstanding scsi commands can queue per lun. "
+		 "Default =  " __stringify(MFC_MAX_CMD_PER_LUN));
+
+int mfc_t11_mode = 1;
+static int mfc_dev_idx;
+
+LIST_HEAD(mfc_dev_list);
+DEFINE_SPINLOCK(mfc_dev_list_lock);
+
+struct scsi_transport_template *mfc_transport_template;
+
+static void mfc_link_work(struct work_struct *work);
+static int mfc_lld_reset(struct fc_lport *lp);
+static void mfc_lport_cleanup(struct fc_lport *lp);
+static void mfc_lport_abort_io(struct fc_lport *lp);
+static int mfc_abort(struct scsi_cmnd *cmd);
+static int mfc_device_reset(struct scsi_cmnd *cmd);
+static int mfc_host_reset(struct scsi_cmnd *cmd);
+static struct fc_seq *mfc_elsct_send(struct fc_lport *lport, u32 did,
+				     struct fc_frame *fp, unsigned int op,
+				     void (*resp) (struct fc_seq *,
+						   struct fc_frame *,
+						   void *), void *arg,
+						   u32 timeout);
+
+struct libfc_function_template mlx4_libfc_fcn_templ = {
+	.frame_send = mfc_frame_send,
+	.fcp_cleanup = mfc_lport_cleanup,
+	.fcp_abort_io = mfc_lport_abort_io,
+	.elsct_send = mfc_elsct_send,
+};
+
+struct scsi_host_template mfc_driver_template = {
+	.module = THIS_MODULE,
+	.name = "Mellanox CX2 FCoE/FCoIB driver",
+	.proc_name = DRV_NAME,
+	.queuecommand = mfc_queuecommand,
+	.slave_alloc = fc_slave_alloc,
+	.change_queue_depth = fc_change_queue_depth,
+	.this_id = -1,
+	.cmd_per_lun = MFC_MAX_CMD_PER_LUN,
+	.use_clustering = ENABLE_CLUSTERING,
+	.sg_tablesize = SG_ALL,
+	.max_sectors = MFC_MAX_FMR_PAGES,
+	.eh_abort_handler = mfc_abort,
+	.eh_device_reset_handler = mfc_device_reset,
+	.eh_host_reset_handler = mfc_host_reset,
+};
+
+int mfc_q_init(struct mfc_queue *q, u16 stride, size_t size, size_t info_size)
+{
+	q->prod = 0;
+	q->cons = 0xffffffff;
+	q->stride = stride;
+	q->size = size;
+	q->size_mask = q->size - 1;
+	q->info = NULL;
+
+	if (info_size) {
+		q->info = (u8 *) vmalloc(q->size * info_size);
+		if (!q->info)
+			return -ENOMEM;
+	}
+
+	spin_lock_init(&q->lock);
+	memset(q->info, 0, q->size * info_size);
+
+	return 0;
+}
+
+void mfc_q_destroy(struct mfc_queue *q)
+{
+	if (!q->info)
+		return;
+
+	vfree(q->info);
+	q->info = NULL;
+}
+
+void mfc_stamp_q(struct mfc_queue *q)
+{
+	__be32 *p;
+	int i;
+
+	/* stamp first dword of every 64 byte */
+	for (i = 0; i < q->size; ++i) {
+		p = q->buf + i * q->stride;
+		*p = cpu_to_be32(1 << 31);
+	}
+
+}
+
+static void mfc_arm_cq(struct mfc_cq *cq)
+{
+	mlx4_cq_arm(&cq->mcq, MLX4_CQ_DB_REQ_NOT,
+		    cq->vhba->mfc_port->mfc_dev->uar_map,
+		    MLX4_GET_DOORBELL_LOCK(&cq->vhba->mfc_port->mfc_dev->
+					   uar_lock));
+}
+
+static void mfc_cq_event(struct mlx4_cq *cq, enum mlx4_event event)
+{
+	printk(KERN_ERR PFX "CQ event = 0x%x\n", (unsigned int)event);
+}
+
+void mfc_cq_clean(struct mfc_cq *cq)
+{
+	struct mlx4_cq *mcq = &cq->mcq;
+	struct mfc_vhba *vhba = cq->vhba;
+	struct mlx4_cqe *cqe, cqe2;
+
+	cqe = (struct mlx4_cqe *)cq->buf + (mcq->cons_index & cq->size_mask);
+
+	while (XNOR(cqe->owner_sr_opcode & MLX4_CQE_OWNER_MASK,
+		    mcq->cons_index & cq->size)) {
+		cqe2 = *cqe;
+		mcq->cons_index++;
+		mlx4_cq_set_ci(mcq);
+
+		if (cqe->owner_sr_opcode & MLX4_CQE_IS_SEND_MASK)
+			cq->comp_tx(vhba, &cqe2);
+		else
+			cq->comp_rx(vhba, &cqe2);
+
+		cqe =
+		    (struct mlx4_cqe *)cq->buf +
+		    (mcq->cons_index & cq->size_mask);
+	}
+}
+
+static void mfc_cq_comp(struct mlx4_cq *mcq)
+{
+	struct mfc_cq *cq = container_of(mcq, struct mfc_cq, mcq);
+
+	mfc_cq_clean(cq);
+	mfc_arm_cq(cq);
+}
+
+int mfc_create_cq(struct mfc_vhba *vhba, struct mfc_cq *cq,
+		  int entries, int eqidx, int arm, comp_fn comp_rx,
+		  comp_fn comp_tx, char *name)
+{
+	struct mfc_port *mfc_port = vhba->mfc_port;
+	struct mfc_dev *mfc_dev = mfc_port->mfc_dev;
+	int err;
+
+	cq->vhba = vhba;
+	cq->comp_rx = comp_rx;
+	cq->comp_tx = comp_tx;
+	strncpy(cq->name, name, sizeof(cq->name));
+
+	cq->size = roundup_pow_of_two(entries + 1);
+	cq->size_mask = cq->size - 1;
+	cq->buf_size = cq->size * sizeof(struct mlx4_cqe);
+
+	err = mlx4_alloc_hwq_res(mfc_dev->dev, &cq->wqres, cq->buf_size,
+				 cq->buf_size);
+	if (err)
+		return err;
+
+	cq->mcq.set_ci_db = cq->wqres.db.db;
+	cq->mcq.arm_db = cq->wqres.db.db + 1;
+	*cq->mcq.set_ci_db = 0;
+	*cq->mcq.arm_db = 0;
+
+	cq->buf = (struct mfc_cqe *)cq->wqres.buf.direct.buf;
+
+	err = mlx4_cq_alloc(mfc_dev->dev, cq->size, &cq->wqres.mtt,
+			    &mfc_dev->priv_uar, cq->wqres.db.dma, &cq->mcq,
+			    eqidx, 0);
+	if (err)
+		goto err_man;
+
+	cq->mcq.comp = mfc_cq_comp;
+	cq->mcq.event = mfc_cq_event;
+
+	if (arm)
+		mfc_arm_cq(cq);
+
+	return 0;
+
+err_man:
+	mlx4_free_hwq_res(mfc_dev->dev, &cq->wqres, cq->buf_size);
+	return err;
+}
+
+void mfc_destroy_cq(struct mfc_cq *cq)
+{
+	struct mfc_dev *mfc_dev = cq->vhba->mfc_port->mfc_dev;
+
+	mlx4_cq_free(mfc_dev->dev, &cq->mcq);
+	mlx4_free_hwq_res(mfc_dev->dev, &cq->wqres, cq->buf_size);
+	cq->buf_size = 0;
+	cq->buf = NULL;
+}
+
+int mfc_post_rx_buf(struct mfc_dev *mfc_dev, struct mfc_qp *fc_qp,
+		    void *buf, size_t buf_size)
+{
+	struct mfc_queue *rq = &fc_qp->rq;
+	struct mfc_rx_desc *rx_desc;
+	dma_addr_t dma;
+	int index;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rq->lock, flags);
+	if ((u32) (rq->prod - rq->cons) == rq->size) {
+		dev_err(mfc_dev->dma_dev,
+			"RFCI rq is full: prod 0x%x, cons 0x%x, size: 0x%x\n",
+			rq->prod, rq->cons, rq->size);
+		spin_unlock_irqrestore(&rq->lock, flags);
+		return -1;
+	}
+	index = rq->prod & rq->size_mask;
+	++rq->prod;
+	spin_unlock_irqrestore(&rq->lock, flags);
+
+	dma =
+	    pci_map_single(mfc_dev->dev->pdev, buf, buf_size,
+			   PCI_DMA_FROMDEVICE);
+	if (pci_dma_mapping_error(mfc_dev->dev->pdev, dma)) {
+		dev_err(mfc_dev->dma_dev, "Failed to pci_map_single\n");
+		return -1;
+	}
+
+	rx_desc = rq->buf + (index * rq->stride);
+	rx_desc->data[0].count = cpu_to_be32(buf_size);
+	rx_desc->data[0].mem_type = cpu_to_be32(mfc_dev->mr.key);
+	rx_desc->data[0].addr = cpu_to_be64(dma);
+
+	return index;
+}
+
+static u32 hw_index_to_key(u32 ind)
+{
+	return (ind >> 24) | (ind << 8);
+}
+
+static u64 mac_to_u64(u8 *mac)
+{
+	int i;
+	u64 ret = 0;
+
+	for (i = 0; i < 6; i++) {
+		ret <<= 8;
+		ret |= mac[i];
+	}
+	return ret;
+}
+
+static void u64_to_mac(u8 mac[6], u64 u64mac)
+{
+	int i;
+
+	for (i = 5; i >= 0; i--) {
+		mac[i] = u64mac & 0xff;
+		u64mac >>= 8;
+	}
+}
+
+static void mfc_update_src_mac(struct fc_lport *lp, u8 * addr)
+{
+	struct mfc_vhba *vhba = lport_priv(lp);
+
+	memcpy(vhba->rfci[RFCI_DATA].mac, addr, ETH_ALEN);
+}
+
+static u8 *mfc_get_src_addr(struct fc_lport *lp)
+{
+	struct mfc_vhba *vhba = lport_priv(lp);
+
+	return vhba->rfci[RFCI_DATA].mac;
+}
+
+static int mlx4_CONFIG_FC_BASIC(struct mlx4_dev *dev, u8 port,
+				struct mfc_basic_config_params *params)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	int err;
+
+#define CONFIG_FC_FEXCH_BASE_OFFSET	0x0
+#define CONFIG_FC_NM_OFFSET		0x5
+#define CONFIG_FC_NV_OFFSET		0x6
+#define CONFIG_FC_NP_OOFSET		0x7
+#define CONFIG_FC_BASEMPT_OFFSET	0x8
+#define CONFIG_FC_NUM_RFCI_OFFSET	0xc
+#define CONFIG_FC_RFCI_BASE_OFFSET	0xd
+#define CONFIG_FC_PROMISC_QPN_OFFSET	0x14
+#define CONFIG_FC_MCAST_QPN_OFFSET	0x18
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+
+	memset(mailbox->buf, 0, 256);
+
+	MLX4_PUT(mailbox->buf, params->fexch_base, CONFIG_FC_FEXCH_BASE_OFFSET);
+	MLX4_PUT(mailbox->buf, params->nm, CONFIG_FC_NM_OFFSET);
+	MLX4_PUT(mailbox->buf, params->nv, CONFIG_FC_NV_OFFSET);
+	MLX4_PUT(mailbox->buf, params->np, CONFIG_FC_NP_OOFSET);
+	MLX4_PUT(mailbox->buf, (hw_index_to_key(params->fexch_base_mpt)),
+		 CONFIG_FC_BASEMPT_OFFSET);
+	MLX4_PUT(mailbox->buf,
+		 params->rfci_base | (((u32) params->log_num_rfci) << 24),
+		 CONFIG_FC_NUM_RFCI_OFFSET);
+	MLX4_PUT(mailbox->buf, params->def_fcoe_promisc_qpn,
+		 CONFIG_FC_PROMISC_QPN_OFFSET);
+	MLX4_PUT(mailbox->buf, params->def_fcoe_mcast_qpn,
+		 CONFIG_FC_MCAST_QPN_OFFSET);
+
+	err = mlx4_cmd(dev, mailbox->dma,
+		       MLX4_CMD_INMOD_BASIC_CONF | port,
+		       MLX4_CMD_MOD_FC_ENABLE,
+		       MLX4_CMD_CONFIG_FC, MLX4_CMD_TIME_CLASS_B);
+
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return err;
+
+}
+
+static int mlx4_CONFIG_FC_NPORT_ID(struct mlx4_dev *dev, u8 port,
+				   struct nport_id *npid)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	int err = 0;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+
+	memcpy(mailbox->buf, npid, MFC_NUM_NPORT_IDS * sizeof(u32));
+
+	err = mlx4_cmd(dev, mailbox->dma,
+		       MLX4_CMD_INMOD_NPORT_TAB | port,
+		       MLX4_CMD_MOD_FC_ENABLE,
+		       MLX4_CMD_CONFIG_FC, MLX4_CMD_TIME_CLASS_B);
+
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return err;
+}
+
+int mfc_flogi_finished(struct fc_lport *lp)
+{
+	struct mfc_vhba *vhba = lport_priv(lp);
+	struct mfc_port *fc_port = vhba->mfc_port;
+	int err = 0;
+
+	/* start data RFCI in FCoE mode */
+	if (vhba->net_type == NET_ETH && !mfc_debug_mode) {
+		err = mfc_start_rfci_data(vhba,
+					  mac_to_u64(vhba->rfci[RFCI_DATA].
+						     mac));
+		if (err) {
+			dev_err(fc_port->mfc_dev->dma_dev,
+				"port%d vhba%d fail to start DATA RFCI %d\n",
+				fc_port->port, vhba->idx, err);
+			goto err;
+		}
+	}
+
+	if ((vhba->idx < 0) || (vhba->idx >= MFC_NUM_NPORT_IDS)) {
+		err = -EINVAL;
+		goto err;
+	}
+
+	memcpy(&fc_port->npid_table[vhba->idx], &vhba->my_npid,
+	       sizeof(vhba->my_npid));
+
+	err = mlx4_CONFIG_FC_NPORT_ID(fc_port->mfc_dev->dev, fc_port->port,
+				      fc_port->npid_table);
+	if (err) {
+		dev_err(fc_port->mfc_dev->dma_dev,
+			"port%d vhba%d: Couldn't cfg npid %x:%x:%x to idx %d\n",
+			fc_port->port, vhba->idx, vhba->my_npid.fid[0],
+			vhba->my_npid.fid[1], vhba->my_npid.fid[2], vhba->idx);
+		goto err;
+	}
+
+	dev_info(fc_port->mfc_dev->dma_dev,
+		 "FLOGI finished NPort ID %02x:%02x:%02x, idx=%d\n",
+		 vhba->my_npid.fid[0], vhba->my_npid.fid[1],
+		 vhba->my_npid.fid[2], vhba->idx);
+
+	err = mfc_init_fcmd(vhba);
+	if (err)
+		dev_err(fc_port->mfc_dev->dma_dev,
+			"port%d vhba%d: Could not init FCMD, err=%d\n",
+			fc_port->port, vhba->idx, err);
+err:
+	return err;
+}
+
+static int mlx4_rport_login(struct fc_rport_priv *rdata)
+{
+	struct fc_lport *lport = rdata->local_port;
+	struct mfc_vhba *vhba = lport_priv(lport);
+
+	dev_info(vhba->mfc_port->mfc_dev->dma_dev,
+		 "FLOGI finished. fid: %06x\n", fc_host_port_id(lport->host));
+
+	if (!vhba->flogi_finished) {
+		vhba->flogi_finished++;
+		vhba->my_npid.reserved = 0;
+		vhba->my_npid.fid[0] =
+		    (fc_host_port_id(lport->host) >> 16) & 0xff;
+		vhba->my_npid.fid[1] =
+		    (fc_host_port_id(lport->host) >> 8) & 0xff;
+		vhba->my_npid.fid[2] = fc_host_port_id(lport->host) & 0xff;
+		mfc_flogi_finished(lport);
+		vhba->flogi_progress = 0;
+	}
+
+	return vhba->fc_rport_login(rdata);
+}
+
+static void mfc_lport_destroy(struct fc_lport *lp)
+{
+	struct mfc_vhba *vhba = lport_priv(lp);
+
+	fc_lport_free_stats(lp);
+
+	if (vhba->emp) {
+		fc_exch_mgr_free(lp);
+		vhba->emp = NULL;
+	}
+}
+
+static int mfc_lport_config(struct fc_lport *lp)
+{
+	lp->link_up = 0;
+	lp->qfull = 0;
+	lp->max_retry_count = 3;
+	lp->max_rport_retry_count = 3;
+	lp->e_d_tov = 2 * 1000;
+	lp->r_a_tov = 2 * 2 * 1000;
+	lp->service_params = (FCP_SPPF_INIT_FCN | FCP_SPPF_RD_XRDY_DIS |
+			      FCP_SPPF_RETRY | FCP_SPPF_CONF_COMPL);
+	lp->link_supported_speeds |= FC_PORTSPEED_1GBIT | FC_PORTSPEED_4GBIT |
+	    FC_PORTSPEED_10GBIT | FC_PORTSPEED_8GBIT | FC_PORTSPEED_16GBIT;
+	lp->link_speed = FC_PORTSPEED_10GBIT;
+
+	if (fc_lport_init_stats(lp))
+		goto err_out;
+
+	fc_lport_config(lp);
+
+	/* offload related configuration */
+	lp->crc_offload = 0;
+	lp->seq_offload = 0;
+	lp->lro_enabled = 0;
+	lp->lro_xid = 0;
+	lp->lso_max = 0;
+
+	return 0;
+
+err_out:
+
+	return -ENOMEM;
+}
+
+static void mfc_lport_cleanup(struct fc_lport *lp)
+{
+	struct mfc_vhba *vhba = lport_priv(lp);
+
+	dev_info(vhba->mfc_port->mfc_dev->dma_dev,
+		 "port%d vhba%d: lport lld_cleanup\n",
+		 vhba->mfc_port->port, vhba->idx);
+
+	vhba->need_reset = 1;
+	mfc_lld_reset(lp);
+}
+
+static void mfc_lport_abort_io(struct fc_lport *lp)
+{
+	struct mfc_vhba *vhba = lport_priv(lp);
+
+	dev_info(vhba->mfc_port->mfc_dev->dma_dev,
+		 "port%d vhba%d: lport lld_abort_io\n",
+		 vhba->mfc_port->port, vhba->idx);
+}
+
+static int mlx4_fip_recv(struct sk_buff *skb, struct net_device *dev,
+			 struct packet_type *ptype, struct net_device *orig_dev)
+{
+	struct mfc_vhba *vhba =
+	    container_of(ptype, struct mfc_vhba, fip_packet_type);
+	struct ethhdr *eh = eth_hdr(skb);
+
+	fcoe_ctlr_recv(&vhba->ctlr, skb);
+
+	/* XXX: This is ugly */
+	memcpy(vhba->dest_addr, eh->h_source, 6);
+
+	return 0;
+}
+
+static void mlx4_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
+{
+	skb->dev = (struct net_device *)mlx4_from_ctlr(fip)->underdev;
+	dev_queue_xmit(skb);
+}
+
+static int mlx4_fip_ctrl_start(struct mfc_vhba *vhba)
+{
+	struct net_device *netdev = (struct net_device *)vhba->underdev;
+
+	/* Setup lport private data to point to fcoe softc */
+	vhba->ctlr.lp = vhba->lp;
+
+	/* setup Source Mac Address */
+	if (!vhba->ctlr.spma)
+		memcpy(vhba->ctlr.ctl_src_addr, netdev->dev_addr,
+		       netdev->addr_len);
+
+	dev_mc_add(netdev, FIP_ALL_ENODE_MACS);
+
+	vhba->fip_packet_type.func = mlx4_fip_recv;
+	vhba->fip_packet_type.type = htons(ETH_P_FIP);
+	vhba->fip_packet_type.dev = netdev;
+	dev_add_pack(&vhba->fip_packet_type);
+
+	return 0;
+}
+
+int mlx4_fip_ctrl_stop(struct mfc_vhba *vhba)
+{
+	dev_remove_pack(&vhba->fip_packet_type);
+	fcoe_ctlr_link_down(&vhba->ctlr);
+	fcoe_ctlr_destroy(&vhba->ctlr);
+
+	return 0;
+}
+
+static void mfc_libfc_destroy(struct fc_lport *lp)
+{
+	fc_remove_host(lp->host);
+	scsi_remove_host(lp->host);
+	fc_lport_destroy(lp);
+}
+
+static void mfc_flogi_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
+{
+	struct fcoe_ctlr *fip = arg;
+	struct fc_exch *exch = fc_seq_exch(seq);
+	struct fc_lport *lport = exch->lp;
+	struct mfc_vhba *vhba = lport_priv(lport);
+	u8 *mac;
+
+	if (IS_ERR(fp))
+		goto done;
+
+	mac = fr_cb(fp)->granted_mac;
+	if (is_zero_ether_addr(mac) && vhba->net_type == NET_ETH) {
+		/* pre-FIP */
+		if (fcoe_ctlr_recv_flogi(fip, lport, fp)) {
+			fc_frame_free(fp);
+			return;
+		}
+	}
+
+	mfc_update_src_mac(lport, mac);
+done:
+	fc_lport_flogi_resp(seq, fp, lport);
+}
+
+static void mfc_logo_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
+{
+	struct fc_lport *lport = arg;
+	static u8 zero_mac[ETH_ALEN] = { 0 };
+
+	if (!IS_ERR(fp))
+		mfc_update_src_mac(lport, zero_mac);
+	fc_lport_logo_resp(seq, fp, lport);
+}
+
+static struct fc_seq *mfc_elsct_send(struct fc_lport *lport, u32 did,
+				     struct fc_frame *fp, unsigned int op,
+				     void (*resp) (struct fc_seq *,
+						   struct fc_frame *,
+						   void *), void *arg,
+						   u32 timeout)
+{
+	struct mfc_vhba *vhba = lport_priv(lport);
+	struct fcoe_ctlr *fip = &vhba->ctlr;
+	struct fc_frame_header *fh = fc_frame_header_get(fp);
+
+	switch (op) {
+	case ELS_FLOGI:
+	case ELS_FDISC:
+		return fc_elsct_send(lport, did, fp, op, mfc_flogi_resp,
+				     fip, timeout);
+	case ELS_LOGO:
+		/* only hook onto fabric logouts, not port logouts */
+		if (ntoh24(fh->fh_d_id) != FC_FID_FLOGI)
+			break;
+		return fc_elsct_send(lport, did, fp, op, mfc_logo_resp,
+				     lport, timeout);
+	}
+	return fc_elsct_send(lport, did, fp, op, resp, arg, timeout);
+}
+
+static int mfc_libfc_init(struct fc_lport *lp, int min_xid, int max_xid,
+			  const char *symbolic_name, u64 wwpn, u64 wwnn)
+{
+	struct mfc_vhba *vhba = lport_priv(lp);
+	int err;
+
+	fc_set_wwnn(lp, wwnn);
+	fc_set_wwpn(lp, wwpn);
+
+	/* libfc expects max FC frame size, including native FC header */
+	fc_set_mfs(lp, vhba->fc_payload_size + sizeof(struct fc_frame_header));
+
+	lp->host->max_lun = MFC_MAX_LUN;
+	lp->host->max_id = MFC_MAX_FCP_TARGET;
+	lp->host->max_channel = 0;
+	lp->host->transportt = mfc_transport_template;
+
+	err = scsi_add_host(lp->host, NULL);
+	if (err) {
+		dev_err(vhba->mfc_port->mfc_dev->dma_dev,
+			"Failed scsi_add_host port %d vhba %d\n",
+			vhba->mfc_port->port, vhba->idx);
+		return err;
+	}
+
+	snprintf(fc_host_symbolic_name(lp->host), FC_SYMBOLIC_NAME_SIZE,
+		 "%s v%s over %s", DRV_NAME, DRV_VERSION, symbolic_name);
+
+	if (vhba->net_type == NET_ETH) {
+		/* Initialize FIP */
+		fcoe_ctlr_init(&vhba->ctlr, FIP_MODE_AUTO);
+		vhba->ctlr.send = mlx4_fip_send;
+		vhba->ctlr.update_mac = mfc_update_src_mac;
+		vhba->ctlr.get_src_addr = mfc_get_src_addr;
+	}
+
+	lp->tt = mlx4_libfc_fcn_templ;
+
+	fc_exch_init(lp);
+	fc_elsct_init(lp);
+	fc_lport_init(lp);
+	fc_rport_init(lp);
+
+	if (vhba->net_type == NET_ETH) {
+		vhba->fc_rport_login = (void *)lp->tt.rport_login;
+		lp->tt.rport_login = (void *)mlx4_rport_login;
+	}
+
+	fc_disc_init(lp);
+
+	vhba->emp = fc_exch_mgr_alloc(lp, FC_CLASS_3, min_xid, max_xid, NULL);
+	if (!vhba->emp) {
+		dev_err(vhba->mfc_port->mfc_dev->dma_dev,
+			"Failed allo libfc exch manager on port %d vhba %d\n",
+			vhba->mfc_port->port, vhba->idx);
+		return -ENOMEM;
+	}
+
+	if (vhba->net_type == NET_IB)
+		fc_fabric_login(lp);
+
+	return 0;
+}
+
+int mfc_create_vhba(struct mfc_port *fc_port,
+		    unsigned int mtu,
+		    int vlan_id, int prio,
+		    int dest_lid, unsigned long dest_ctrl_qpn,
+		    unsigned long dest_data_qpn, int dest_sl,
+		    void *underdev, const char *symbolic_name,
+		    u64 gw_discovery_handle,
+		    fcoib_send_els_cb fcoib_send_els_cb,
+		    enum mfc_net_type net_type, u64 wwpn, u64 wwnn)
+{
+	struct mfc_dev *mfc_dev = fc_port->mfc_dev;
+	struct mlx4_caps *caps = &mfc_dev->dev->caps;
+	struct fc_lport *lp;
+	struct mfc_vhba *vhba;
+	int idx, port = fc_port->port;
+	int err;
+	unsigned long flags;
+	struct Scsi_Host *shost;
+
+	mfc_driver_template.can_queue = (1 << mfc_log_exch_per_vhba) -
+	    mfc_num_reserved_xids;
+
+	lp = libfc_host_alloc(&mfc_driver_template, sizeof(struct mfc_vhba));
+	if (!lp) {
+		dev_err(mfc_dev->dma_dev,
+			"Could not allocate lport on port %d\n", port);
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	shost = lp->host;
+	vhba = lport_priv(lp);
+	vhba->lp = lp;
+	vhba->gw_discovery_handle = gw_discovery_handle;
+	vhba->fcoib_send_els_cb = fcoib_send_els_cb;
+
+	err = mfc_lport_config(lp);
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"Error configuring lport on port %d\n", port);
+		goto err_host_put;
+	}
+
+	idx = mfc_bitmap_slot_alloc(&fc_port->fexch_bulk_bm, 1);
+	if (idx == -1) {
+		dev_err(mfc_dev->dma_dev,
+			"Failed alloc fexchs for new vhba on port %d\n", port);
+		err = -ENOMEM;
+		goto err_lport_destroy;
+	}
+	vhba->idx = idx;
+	vhba->mfc_port = fc_port;
+	vhba->underdev = underdev;
+	vhba->rfci[RFCI_DATA].fc_mac_idx = -1;
+	/* TODO: needed? */
+	vhba->rfci_rx_enabled = 0;
+
+	if (!mfc_t11_mode) {
+		vhba->fcoe_hlen = sizeof(struct fcoe_hdr_old);
+		vhba->fc_payload_size = mtu -
+		    sizeof(struct fcoe_hdr_old) -
+		    sizeof(struct fc_frame_header) -
+		    sizeof(struct fcoe_crc_eof_old);
+	} else {
+		vhba->fcoe_hlen = sizeof(struct fcoe_hdr);
+		vhba->fc_payload_size = mtu -
+		    sizeof(struct fcoe_hdr) -
+		    sizeof(struct fc_frame_header) -
+		    sizeof(struct fcoe_crc_eof);
+	}
+
+	if (net_type == NET_IB) {
+		vhba->fc_payload_size -= 2;
+		if (!mfc_t11_mode)
+			/* in IB pre-T11 we have 3 padding in EOF */
+			vhba->fc_payload_size -= 3;
+	}
+
+	/*
+	 * Enforcing the fc_payload_size to 8B multiple to work-around
+	 * Tachyon/Tachlite DIF insertion/marshalling on 8B alignment.
+	 */
+	vhba->fc_payload_size = min(mfc_payload_size,
+				    vhba->fc_payload_size) & 0xFFFFFFFFFFFFFFF0;
+	vhba->num_fexch = 1 << fc_port->log_num_fexch_per_vhba;
+	vhba->base_fexch_qpn = fc_port->base_fexch_qpn + idx * vhba->num_fexch;
+	vhba->base_fexch_mpt = fc_port->base_fexch_mpt + idx * vhba->num_fexch;
+
+	dev_info(mfc_dev->dma_dev,
+		 "vhba %d type %s on port %d b_qpn=0x%x, b_mpt=0x%x, n_fexch=%d"
+		 " fc_payload_size=%d\n",
+		 vhba->idx, (net_type == NET_IB) ? "NET_IB" : "NET_ETH", port,
+		 vhba->base_fexch_qpn, vhba->base_fexch_mpt, vhba->num_fexch,
+		 vhba->fc_payload_size);
+
+	vhba->net_type = net_type;
+	vhba->dest_ib_lid = dest_lid;
+	vhba->dest_ib_ctrl_qpn = dest_ctrl_qpn;
+	vhba->dest_ib_data_qpn = dest_data_qpn;
+	vhba->dest_ib_sl = dest_sl;
+
+	vhba->fc_vlan_id = vlan_id;
+	vhba->fc_vlan_prio = prio;
+	if (vlan_id != -1) {
+		err = mlx4_register_vlan(mfc_dev->dev, port, vlan_id,
+					 &vhba->fc_vlan_idx);
+		if (err) {
+			dev_err(mfc_dev->dma_dev,
+				"Fail to reg VLAN %d err=0x%x port%d vhba%d\n",
+				vlan_id, err, port, idx);
+			goto err_free_fexch_bulk;
+		}
+		dev_info(mfc_dev->dma_dev,
+			 "Reg vlan %d prio %d to index %d on port %d vhba %d\n",
+			 vlan_id, prio, vhba->fc_vlan_idx, port, idx);
+	}
+	u64_to_mac(vhba->rfci[RFCI_CTRL].mac, caps->def_mac[port]);
+
+	err = mfc_create_rfci(vhba, &vhba->rfci[RFCI_CTRL],
+			      caps->def_mac[port]);
+
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"port%d vhba%d: Could not create CTRL RFCI, err=%d\n",
+			port, idx, err);
+		goto err_unreg_vlan;
+	}
+
+	err = mfc_create_fcmd(vhba);
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"port%d vhba%d: Could not create FCMD, err=%d\n",
+			port, idx, err);
+		goto err_destroy_rfci_ctrl;
+	}
+
+	err = mfc_libfc_init(lp, vhba->base_reserved_xid,
+			     vhba->base_reserved_xid + vhba->num_reserved_xid,
+			     symbolic_name, wwpn, wwnn);
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"Could not init libfc port %d vhba %d\n", port, idx);
+
+		goto err_destroy_fcmd;
+	}
+
+	err = mfc_init_rfci(vhba, &vhba->rfci[RFCI_CTRL]);
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"Could not init CTRL RFCI err=%x port %d vhba %d\n",
+			err, port, idx);
+		goto err_destroy_libfc;
+	}
+
+	memcpy(vhba->dest_addr, gw_mac, ETH_ALEN);
+	INIT_DELAYED_WORK(&vhba->delayed_work, mfc_link_work);
+
+	spin_lock_irqsave(&fc_port->lock, flags);
+	list_add(&vhba->list, &fc_port->vhba_list);
+	spin_unlock_irqrestore(&fc_port->lock, flags);
+
+	mfc_vhba_create_dentry(vhba);
+
+	if (net_type == NET_IB)
+		fc_linkup(lp);
+	else if (net_type == NET_ETH) {
+		mlx4_fip_ctrl_start(vhba);
+		fcoe_ctlr_link_up(&vhba->ctlr);
+		fc_fabric_login(lp);
+		vhba->link_up = 1;
+	}
+
+	return 0;
+
+err_destroy_libfc:
+	mfc_libfc_destroy(lp);
+err_destroy_fcmd:
+	mfc_destroy_fcmd(vhba);
+err_destroy_rfci_ctrl:
+	mfc_destroy_rfci(vhba, &vhba->rfci[RFCI_CTRL]);
+err_unreg_vlan:
+	if (vhba->fc_vlan_id != -1)
+		mlx4_unregister_vlan(mfc_dev->dev, port, vhba->fc_vlan_idx);
+err_free_fexch_bulk:
+	mfc_bitmap_slot_free(&fc_port->fexch_bulk_bm, idx);
+err_lport_destroy:
+	mfc_lport_destroy(lp);
+err_host_put:
+	scsi_host_put(lp->host);
+err_out:
+	return err;
+}
+
+/* vhba->mfc_port->lock must be held */
+void mfc_remove_vhba(struct mfc_vhba *vhba)
+{
+	struct mfc_port *fc_port = vhba->mfc_port;
+	struct mfc_dev *mfc_dev = fc_port->mfc_dev;
+	int port = fc_port->port, idx = vhba->idx;
+	struct fc_lport *lp = vhba->lp;
+	unsigned long flags;
+
+	vhba->need_reset = 1;
+	mfc_vhba_delete_dentry(vhba);
+
+	/* Logout of the fabric */
+	fc_fabric_logoff(lp);
+
+	if (vhba->net_type == NET_ETH)
+		mlx4_fip_ctrl_stop(vhba);
+
+	spin_lock_irqsave(&fc_port->lock, flags);
+	list_del(&vhba->list);
+	spin_unlock_irqrestore(&fc_port->lock, flags);
+
+	fc_linkdown(lp);
+
+	mfc_destroy_fcmd(vhba);
+
+	mfc_destroy_rfci(vhba, &vhba->rfci[RFCI_CTRL]);
+	if (vhba->rfci[RFCI_DATA].fc_mac_idx != -1)
+		mfc_destroy_rfci(vhba, &vhba->rfci[RFCI_DATA]);
+	if (vhba->fc_vlan_id != -1)
+		mlx4_unregister_vlan(mfc_dev->dev, port, vhba->fc_vlan_idx);
+	mfc_bitmap_slot_free(&fc_port->fexch_bulk_bm, idx);
+
+	mfc_libfc_destroy(vhba->lp);
+	mfc_lport_destroy(lp);
+	scsi_host_put(lp->host);
+}
+
+int mfc_init_port(struct mfc_dev *mfc_dev, int port)
+{
+	struct mfc_port *mfc_port = &mfc_dev->mfc_port[port];
+	int err = 0;
+	int mvp = (1 << mfc_dev->log_num_mac) * (1 << mfc_dev->log_num_vlan) *
+	    (1 << mfc_dev->log_num_prio);
+	struct mfc_basic_config_params params = { 0 };
+	int count = 0;
+	char wq_name[16];
+
+	memset(&mfc_port->npid_table, 0,
+	       sizeof(struct nport_id) * MFC_NUM_NPORT_IDS);
+	mfc_port->port = port;
+	mfc_port->mfc_dev = mfc_dev;
+	mfc_port->lock = __SPIN_LOCK_UNLOCKED(mfc_port->lock);
+	INIT_LIST_HEAD(&mfc_port->vhba_list);
+	mfc_port->num_fexch_qps =
+	    (1 << mfc_log_exch_per_vhba) * max_vhba_per_port;
+	mfc_port->log_num_fexch_per_vhba = mfc_log_exch_per_vhba;
+	err = mlx4_qp_reserve_range(mfc_dev->dev, mfc_port->num_fexch_qps,
+				    MFC_MAX_PORT_FEXCH,
+				    &mfc_port->base_fexch_qpn);
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"Could not allocate QP range for FEXCH."
+			" Need 0x%x QPs aligned to 0x%x on port %d\n",
+			mfc_port->num_fexch_qps, MFC_MAX_PORT_FEXCH, port);
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	/* TODO: for bidirectional SCSI we'll need to double the amount of
+	   reserved MPTs, with proper spanning */
+	err = mlx4_mr_reserve_range(mfc_dev->dev, mfc_port->num_fexch_qps,
+				    2 * MFC_MAX_PORT_FEXCH,
+				    &mfc_port->base_fexch_mpt);
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"Could not allocate MPT range for FEXCH."
+			" Need 0x%x MPTs aligned to 0x%x on port %d\n",
+			mfc_port->num_fexch_qps, 2 * MFC_MAX_PORT_FEXCH, port);
+		err = -ENOMEM;
+		goto err_free_qp_range;
+	}
+
+	switch (mfc_dev->dev->caps.port_type[port]) {
+	case MLX4_PORT_TYPE_IB:
+		count = max_vhba_per_port;
+		break;
+	case MLX4_PORT_TYPE_ETH:
+		count = mvp;
+		break;
+	default:
+		err = 1;
+		goto err_free_qp_range;
+	}
+
+	err = mlx4_qp_reserve_range(mfc_dev->dev, count, count,
+				    &mfc_port->base_rfci_qpn);
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"Could not allocate QP range for RFCIs."
+			" Need 0x%x QPs naturally aligned on port %d\n",
+			max_vhba_per_port, port);
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	params.rfci_base = mfc_port->base_rfci_qpn;
+	params.fexch_base = mfc_port->base_fexch_qpn;
+	params.fexch_base_mpt = mfc_port->base_fexch_mpt;
+	params.nm = mfc_port->n_m = mfc_dev->log_num_mac;
+	params.nv = mfc_port->n_v = mfc_dev->log_num_vlan;
+	params.np = mfc_port->n_p = mfc_dev->log_num_prio;
+	params.log_num_rfci = ilog2(count);
+	params.def_fcoe_promisc_qpn = 0x77;
+	params.def_fcoe_mcast_qpn = 0x78;
+
+	dev_info(mfc_dev->dma_dev,
+		 "port %d b_fexch=0x%x, n_fexch=0x%x, b_mpt=0x%x,"
+		 " b_rfci=0x%x, num_rfci=0x%x\n",
+		 port, mfc_port->base_fexch_qpn, mfc_port->num_fexch_qps,
+		 mfc_port->base_fexch_mpt, mfc_port->base_rfci_qpn, count);
+
+	err = mlx4_CONFIG_FC_BASIC(mfc_dev->dev, port, &params);
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"Failed issue CONFIG_FC Basic on port %d\n", port);
+		goto err_free_mr_range;
+	}
+
+	err = mfc_bitmap_alloc(&mfc_port->fexch_bulk_bm,
+			       mfc_port->num_fexch_qps >> mfc_port->
+			       log_num_fexch_per_vhba);
+
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"Failed alloc fexch bulks bitmap on port %d\n", port);
+		goto err_free_mr_range;
+	}
+
+	snprintf(wq_name, 16, "rfci_wq_%d_%d", mfc_dev_idx, port);
+
+	mfc_port->rfci_wq = create_singlethread_workqueue(wq_name);
+	if (!mfc_port->rfci_wq)
+		goto err_free_qp_range;
+
+	snprintf(wq_name, 16, "async_wq_%d_%d", mfc_dev_idx, port);
+	mfc_port->async_wq = create_singlethread_workqueue(wq_name);
+	if (!mfc_port->async_wq)
+		goto err_free_wq;
+
+	mfc_port->initialized = 1;
+	mfc_port_create_dentry(mfc_port);
+
+	return 0;
+
+err_free_wq:
+	destroy_workqueue(mfc_port->rfci_wq);
+err_free_qp_range:
+	mlx4_qp_release_range(mfc_dev->dev, mfc_port->base_fexch_qpn,
+			      mfc_port->num_fexch_qps);
+err_free_mr_range:
+	mlx4_mr_release_range(mfc_dev->dev, mfc_port->base_fexch_mpt,
+			      mfc_port->num_fexch_qps);
+err_out:
+	return err;
+}
+
+void mfc_free_port(struct mfc_dev *mfc_dev, int port)
+{
+	struct mfc_port *fc_port = &mfc_dev->mfc_port[port];
+	struct mfc_vhba *vhba, *tmp;
+
+	mfc_port_delete_dentry(fc_port);
+	fc_port->initialized = 0;
+
+	flush_workqueue(fc_port->rfci_wq);
+	flush_workqueue(fc_port->async_wq);
+
+	list_for_each_entry_safe(vhba, tmp, &fc_port->vhba_list, list)
+	    mfc_remove_vhba(vhba);
+
+	/*
+	 * make sure the bitmap is empty, meaning, no vhba's left using
+	 * fexch bulk
+	 */
+	mfc_bitmap_free(&fc_port->fexch_bulk_bm);
+	mlx4_qp_release_range(mfc_dev->dev, fc_port->base_fexch_qpn,
+			      fc_port->num_fexch_qps);
+	mlx4_mr_release_range(mfc_dev->dev, fc_port->base_fexch_mpt,
+			      fc_port->num_fexch_qps);
+
+	destroy_workqueue(fc_port->rfci_wq);
+	destroy_workqueue(fc_port->async_wq);
+}
+
+static void *mfc_add_dev(struct mlx4_dev *dev)
+{
+	struct mfc_dev *mfc_dev;
+	int port;
+	int err;
+	unsigned long flags;
+	int pre_t11_enable = 0;
+	int t11_supported = 0;
+
+	dev_info(&dev->pdev->dev, "Adding device[%d] %.*s at %s\n",
+		 mfc_dev_idx + 1, MLX4_BOARD_ID_LEN, dev->board_id,
+		 dev_driver_string(&dev->pdev->dev));
+
+	mfc_dev = kzalloc(sizeof(struct mfc_dev), GFP_KERNEL);
+	if (!mfc_dev) {
+		dev_err(&dev->pdev->dev, "Alloc mfc_dev failed\n");
+		goto err_out;
+	}
+
+	mfc_dev->idx = mfc_dev_idx++;
+
+	err = mlx4_pd_alloc(dev, &mfc_dev->priv_pdn);
+	if (err) {
+		dev_err(&dev->pdev->dev, "PD alloc failed %d\n", err);
+		goto err_free_dev;
+	}
+
+	err = mlx4_mr_alloc(dev, mfc_dev->priv_pdn, 0, ~0ull,
+			    MLX4_PERM_LOCAL_WRITE | MLX4_PERM_LOCAL_READ, 0, 0,
+			    &mfc_dev->mr);
+	if (err) {
+		dev_err(&dev->pdev->dev, "mr alloc failed %d\n", err);
+		goto err_free_pd;
+	}
+
+	err = mlx4_mr_enable(dev, &mfc_dev->mr);
+	if (err) {
+		dev_err(&dev->pdev->dev, "mr enable failed %d\n", err);
+		goto err_free_mr;
+	}
+
+	if (mlx4_uar_alloc(dev, &mfc_dev->priv_uar))
+		goto err_free_mr;
+
+	mfc_dev->uar_map =
+	    ioremap(mfc_dev->priv_uar.pfn << PAGE_SHIFT, PAGE_SIZE);
+	if (!mfc_dev->uar_map)
+		goto err_free_uar;
+
+	MLX4_INIT_DOORBELL_LOCK(&mfc_dev->uar_lock);
+
+	INIT_LIST_HEAD(&mfc_dev->pgdir_list);
+	mutex_init(&mfc_dev->pgdir_mutex);
+
+	mfc_dev->dev = dev;
+	mfc_dev->dma_dev = &dev->pdev->dev;
+	mfc_dev->log_num_mac = dev->caps.log_num_macs;
+	mfc_dev->log_num_vlan = dev->caps.log_num_vlans;
+	mfc_dev->log_num_prio = dev->caps.log_num_prios;
+
+	mlx4_get_fc_t11_settings(dev, &pre_t11_enable, &t11_supported);
+
+	if (pre_t11_enable) {
+		mfc_t11_mode = 0;
+		dev_info(&dev->pdev->dev, "Starting FC device PRE-T11 mode\n");
+	} else if (t11_supported && !pre_t11_enable) {
+		mfc_t11_mode = 1;
+		dev_info(mfc_dev->dma_dev, "Starting FC device T11 mode\n");
+	} else {
+		dev_err(mfc_dev->dma_dev, "FAIL start fc device in T11 mode, "
+			"please enable PRE-T11 in mlx4_core\n");
+		goto err_free_uar;
+	}
+
+	for (port = 1; port <= mfc_dev->dev->caps.num_ports; port++) {
+		err = mfc_init_port(mfc_dev, port);
+		if (err)
+			goto err_free_ports;
+	}
+
+	spin_lock_irqsave(&mfc_dev_list_lock, flags);
+	list_add(&mfc_dev->list, &mfc_dev_list);
+	spin_unlock_irqrestore(&mfc_dev_list_lock, flags);
+
+	return mfc_dev;
+
+err_free_ports:
+	while (--port)
+		mfc_free_port(mfc_dev, port);
+	iounmap(mfc_dev->uar_map);
+err_free_uar:
+	mlx4_uar_free(dev, &mfc_dev->priv_uar);
+err_free_mr:
+	mlx4_mr_free(mfc_dev->dev, &mfc_dev->mr);
+err_free_pd:
+	mlx4_pd_free(dev, mfc_dev->priv_pdn);
+err_free_dev:
+	kfree(mfc_dev);
+err_out:
+	return NULL;
+}
+
+static void mfc_remove_dev(struct mlx4_dev *dev, void *fcdev_ptr)
+{
+	struct mfc_dev *mfc_dev = fcdev_ptr;
+	int port;
+	unsigned long flags;
+
+	dev_info(&dev->pdev->dev, "%.*s: removing\n", MLX4_BOARD_ID_LEN,
+		 dev->board_id);
+
+	spin_lock_irqsave(&mfc_dev_list_lock, flags);
+	list_del(&mfc_dev->list);
+	spin_unlock_irqrestore(&mfc_dev_list_lock, flags);
+
+	for (port = 1; port <= mfc_dev->dev->caps.num_ports; port++)
+		mfc_free_port(mfc_dev, port);
+
+	iounmap(mfc_dev->uar_map);
+	mlx4_uar_free(dev, &mfc_dev->priv_uar);
+	mlx4_mr_free(dev, &mfc_dev->mr);
+	mlx4_pd_free(dev, mfc_dev->priv_pdn);
+
+	kfree(mfc_dev);
+}
+
+static inline struct mfc_vhba *find_vhba_for_netdev(struct net_device *netdev)
+{
+	struct mfc_dev *mfc_dev;
+	struct mfc_port *fc_port;
+	struct mfc_vhba *vhba;
+	int p;
+	unsigned long flags2;
+
+	spin_lock_irqsave(&mfc_dev_list_lock, flags2);
+	list_for_each_entry(mfc_dev, &mfc_dev_list, list)
+	    for (p = 1; p <= MLX4_MAX_PORTS; ++p) {
+		unsigned long flags;
+		fc_port = &mfc_dev->mfc_port[p];
+		if (!fc_port->initialized)
+			continue;
+		spin_lock_irqsave(&fc_port->lock, flags);
+		list_for_each_entry(vhba, &fc_port->vhba_list, list)
+		    if (vhba->underdev == netdev) {
+			spin_unlock_irqrestore(&fc_port->lock, flags);
+			spin_unlock_irqrestore(&mfc_dev_list_lock, flags2);
+			return vhba;
+		}
+		spin_unlock_irqrestore(&fc_port->lock, flags);
+	}
+	spin_unlock_irqrestore(&mfc_dev_list_lock, flags2);
+	return NULL;
+}
+
+static void mfc_link_change(struct mfc_vhba *vhba, int link_up)
+{
+	struct fc_lport *lp = vhba->lp;
+
+	if (link_up) {
+		if (vhba->net_type == NET_ETH)
+			fcoe_ctlr_link_up(&vhba->ctlr);
+
+		fc_linkup(lp);
+	} else {
+		if (vhba->net_type == NET_ETH)
+			fcoe_ctlr_link_down(&vhba->ctlr);
+
+		fc_linkdown(lp);
+	}
+}
+
+static void mfc_link_work(struct work_struct *work)
+{
+	struct mfc_vhba *vhba =
+	    container_of(work, struct mfc_vhba, delayed_work.work);
+
+	if (!vhba->link_up)
+		vhba->need_reset = 1;
+	mfc_link_change(vhba, vhba->link_up);
+}
+
+static void mfc_async_event(struct mlx4_dev *dev, void *mfc_dev_ptr,
+			    enum mlx4_dev_event event, int port)
+{
+	struct mfc_dev *mfc_dev = (struct mfc_dev *)mfc_dev_ptr;
+	struct mfc_port *fc_port = &mfc_dev->mfc_port[port];
+	struct mfc_vhba *vhba, *tmp;
+	int link_up;
+
+	switch (event) {
+	case MLX4_DEV_EVENT_PORT_UP:
+		link_up = 1;
+		break;
+	case MLX4_DEV_EVENT_CATASTROPHIC_ERROR:
+	case MLX4_DEV_EVENT_PORT_DOWN:
+		link_up = 0;
+		break;
+	case MLX4_DEV_EVENT_PORT_REINIT:
+	default:
+		return;
+	}
+
+	list_for_each_entry_safe(vhba, tmp, &fc_port->vhba_list, list) {
+		if (vhba->link_up != link_up) {
+			vhba->link_up = link_up;
+
+			cancel_delayed_work(&vhba->delayed_work);
+			dev_warn(&dev->pdev->dev,
+				 "link %s on vhba %d port %d\n",
+				 (link_up ? "UP" : "DOWN"), vhba->idx, port);
+			queue_delayed_work(fc_port->async_wq,
+					   &vhba->delayed_work,
+					   MFC_ASYNC_DELAY);
+		}
+	}
+}
+
+static int mfc_register_netdev(struct net_device *netdev, int vlan_id, int prio)
+{
+	struct mfc_vhba *vhba;
+	struct mlx4_dev *dev;
+	int port;
+	struct mfc_dev *mfc_dev;
+	struct net_device *tmp_netdev, *query_netdev;
+	int err;
+	unsigned long flags;
+	u64 wwn, wwpn, wwnn;
+	int found;
+
+	vhba = find_vhba_for_netdev(netdev);
+	if (vhba) {
+		dev_info(vhba->mfc_port->mfc_dev->dma_dev,
+			 "warning: already got vhba for %s. skipping\n",
+			 netdev->name);
+		return 0;
+	}
+
+	tmp_netdev = (netdev->priv_flags & IFF_802_1Q_VLAN) ?
+		     vlan_dev_real_dev(netdev) : netdev;
+
+	spin_lock_irqsave(&mfc_dev_list_lock, flags);
+	list_for_each_entry(mfc_dev, &mfc_dev_list, list) {
+		dev = mfc_dev->dev;
+		for (port = 1; port <= dev->caps.num_ports; ++port) {
+			query_netdev = mlx4_get_prot_dev(dev, MLX4_PROT_EN,
+							 port);
+			if (query_netdev == tmp_netdev) {
+				found = 1;
+				goto unlock;
+			}
+		}
+	}
+unlock:
+	spin_unlock_irqrestore(&mfc_dev_list_lock, flags);
+
+	if (!found) {
+		printk(KERN_ERR PFX "%s does not belong to mlx4_en.\n",
+		       netdev->name);
+		err = -EINVAL;
+		goto out;
+	}
+
+	dev_info(&dev->pdev->dev,
+		 "%s belongs to mlx4_en. port=%d\n", netdev->name, port);
+
+	wwn = mfc_dev->dev->caps.def_mac[port];
+	wwnn = wwn | ((u64) 0x10 << 56);
+	wwpn = wwn | ((u64) 0x20 << 56);
+
+	err = mfc_create_vhba(&mfc_dev->mfc_port[port], netdev->mtu, vlan_id,
+			      prio, -1, 0, 0, 0, netdev, netdev->name,
+			      0, NULL, NET_ETH, wwpn, wwnn);
+	if (err)
+		dev_err(&dev->pdev->dev,
+			"Could not create vhba for net device %s vlan %d\n",
+			netdev->name, vlan_id);
+out:
+	return err;
+}
+
+static int mfc_unregister_netdev(struct net_device *netdev)
+{
+	struct mfc_vhba *vhba;
+
+	vhba = find_vhba_for_netdev(netdev);
+	if (!vhba) {
+		printk(KERN_ERR PFX "No vhba for %s. skipping.\n",
+		       netdev->name);
+		return 0;
+	}
+
+	mfc_remove_vhba(vhba);
+	return 0;
+}
+
+static struct mlx4_interface mfc_interface = {
+	.add = mfc_add_dev,
+	.remove = mfc_remove_dev,
+	.event = mfc_async_event
+};
+
+static void trimstr(char *str, int len)
+{
+	char *cp = str + len;
+	while (--cp >= str && *cp == '\n')
+		*cp = '\0';
+}
+
+static ssize_t mfc_sys_destroy(struct class *cl, struct class_attribute *attr,
+			       const char *buf, size_t count)
+{
+	char ifname[IFNAMSIZ];
+	struct net_device *netdev = NULL;
+
+	strncpy(ifname, buf, sizeof(ifname));
+	trimstr(ifname, strlen(ifname));
+
+	netdev = dev_get_by_name(&init_net, ifname);
+	if (!netdev) {
+		printk(KERN_ERR "Couldn't get a network device for '%s'",
+		       ifname);
+		goto out;
+	}
+
+	mfc_unregister_netdev(netdev);
+
+out:
+	if (netdev)
+		dev_put(netdev);
+	return count;
+}
+
+static CLASS_ATTR(destroy, 0222, NULL, mfc_sys_destroy);
+
+static ssize_t mfc_sys_create(struct class *cl, struct class_attribute *attr,
+			      const char *buf, size_t count)
+{
+	char ifname[IFNAMSIZ + 1];
+	char *ch;
+	char test;
+	int cnt = 0;
+	int vlan_id = -1;
+	int prio = 0;
+	struct net_device *netdev = NULL;
+
+	strncpy(ifname, buf, sizeof(ifname));
+	trimstr(ifname, strlen(ifname));
+
+	ch = strchr(ifname, ',');
+	if (ch) {
+		*ch = '\0';
+		cnt = sscanf(ch + 1, "%d%c", &prio, &test);
+		if (cnt != 1 || prio < 0 || prio > 7)
+			prio = 0;
+	}
+
+	netdev = dev_get_by_name(&init_net, ifname);
+	if (!netdev) {
+		printk(KERN_ERR "Couldn't get a network device for '%s'\n",
+		       ifname);
+		goto out;
+	}
+	if (netdev->priv_flags & IFF_802_1Q_VLAN) {
+		vlan_id = vlan_dev_vlan_id(netdev);
+		printk(KERN_INFO PFX "vlan id %d prio %d\n", vlan_id, prio);
+		if (vlan_id < 0)
+			goto out;
+	}
+
+	mfc_register_netdev(netdev, vlan_id, prio);
+
+out:
+	if (netdev)
+		dev_put(netdev);
+	return count;
+}
+
+static CLASS_ATTR(create, 0222, NULL, mfc_sys_create);
+
+static ssize_t mfc_sys_create_ib(struct class *cl, struct class_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct mfc_dev *mfc_dev;
+	struct mfc_port *fc_port;
+	int p;
+	unsigned long flags2;
+	int idx, board_idx, port, lid, sl;
+	unsigned int mtu;
+	unsigned long ctrl_qpn, data_qpn;
+	char symbolic_name[] = "IB0P1";
+	u64 wwn, wwpn, wwnn;
+
+	if (7 != sscanf(buf, "%x,%x,%x,%x,%x,%lx,%lx,%x",
+			&idx, &board_idx, &port, &mtu, &lid, &ctrl_qpn,
+			&data_qpn, &sl)) {
+		printk(KERN_ERR
+		       "Bad string. All should be in hex without 0x: vhba_idx,"
+		       " board_idx, port ,mtu, lid, ctrl_qpn, data_qpn, sl\n");
+		return count;
+	}
+
+	p = 0;
+	spin_lock_irqsave(&mfc_dev_list_lock, flags2);
+	list_for_each_entry(mfc_dev, &mfc_dev_list, list) {
+		if (p == board_idx)
+			break;
+		++p;
+	}
+	spin_unlock_irqrestore(&mfc_dev_list_lock, flags2);
+
+	if (p < board_idx) {
+		printk(KERN_ERR PFX "Has only %d boards\n", p);
+		return count;
+	}
+
+	if ((port < 1) || (port > MLX4_MAX_PORTS)) {
+		printk(KERN_ERR PFX "Port should be in range 1-%d\n",
+		       MLX4_MAX_PORTS);
+		return count;
+	}
+
+	fc_port = &mfc_dev->mfc_port[port];
+	if (!fc_port->initialized) {
+		printk(KERN_ERR PFX "Port is not yet initialized for FCoIB\n");
+		return count;
+	}
+
+	wwn = mfc_dev->dev->caps.def_mac[fc_port->port];
+	wwnn = wwn | ((u64) 0x10 << 56);
+	wwpn = wwn | ((u64) (idx & 0xff) << 48) | ((u64) 0x20 << 56);
+
+	snprintf(symbolic_name, sizeof(symbolic_name), "IB%1dP%1d",
+		 board_idx, port);
+
+	mfc_create_vhba(fc_port, mtu, -1, -1, lid, ctrl_qpn, data_qpn, sl,
+			NULL, symbolic_name, 0, NULL, NET_IB, wwpn, wwnn);
+
+	return count;
+}
+
+static CLASS_ATTR(create_ib, 0222, NULL, mfc_sys_create_ib);
+
+int fcoib_create_vhba(struct ib_device *ib_device,
+		      u8 port, unsigned int mtu, u16 gw_lid, u8 sl,
+		      u64 gw_discovery_handle,
+		      fcoib_send_els_cb fcoib_send_els_cb, u64 wwpn, u64 wwnn)
+{
+	struct mfc_dev *mfc_dev;
+	struct mfc_port *fc_port;
+	struct mlx4_dev *mlxdev;
+	struct ib_device *ib_device_itr;
+	char symbolic_name[] = "IB0P1";
+	unsigned long flags;
+	int found;
+	int err = 0;
+
+	/* port number can be 1 or 2 */
+	if ((port < 1) || (port > MLX4_MAX_PORTS)) {
+		printk(KERN_ALERT "Port should be in range 1-%d\n",
+		       MLX4_MAX_PORTS);
+		return -1;
+	}
+
+	/* find the corresponding FC device from the IB device */
+	found = 0;
+	spin_lock_irqsave(&mfc_dev_list_lock, flags);
+	list_for_each_entry(mfc_dev, &mfc_dev_list, list) {
+		mlxdev = mfc_dev->dev;
+		ib_device_itr = mlx4_get_prot_dev(mlxdev, MLX4_PROT_IB, port);
+		if (ib_device == ib_device_itr) {
+			found = 1;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&mfc_dev_list_lock, flags);
+
+	if (!found) {
+		printk(KERN_ALERT "mlx4_fc: coudln't find match "
+		       "ib_dev to fc_dev\n");
+		return -1;
+	}
+
+	fc_port = &mfc_dev->mfc_port[port];
+	if (!fc_port || !fc_port->initialized) {
+		printk(KERN_ALERT "Port is not yet initialized for FCoIB\n");
+		return -1;
+	}
+
+	/* TODO: check how symbolic name should be built */
+	snprintf(symbolic_name, sizeof(symbolic_name),
+		 "IB%1dP%1d", 0, port);
+
+	err = mfc_create_vhba(fc_port, mtu, -1, -1, gw_lid, CTRL_QPN,
+			      DATA_QPN, sl, NULL, symbolic_name,
+			      gw_discovery_handle, fcoib_send_els_cb, NET_IB,
+			      wwpn, wwnn);
+	if (err) {
+		printk(KERN_ALERT "FAIL: create vhba\n");
+		return err;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(fcoib_create_vhba);
+
+void fcoib_destroy_vhba(u64 gw_fc_handle)
+{
+	struct mfc_vhba *vhba = (struct mfc_vhba *)gw_fc_handle;
+
+	if (!vhba->mfc_port->initialized)
+		return;
+
+	mfc_remove_vhba(vhba);
+}
+EXPORT_SYMBOL(fcoib_destroy_vhba);
+
+void fcoib_get_vhba_fcid(u64 gw_fc_handle, uint8_t *fcid)
+{
+	struct mfc_vhba *vhba = (struct mfc_vhba *)gw_fc_handle;
+
+	memcpy(fcid, vhba->my_npid.fid, 3);
+}
+EXPORT_SYMBOL(fcoib_get_vhba_fcid);
+
+static ssize_t mfc_sys_link_change(struct class *cl, const char *buf,
+				   size_t count, int link_up)
+{
+	struct mfc_vhba *vhba;
+	struct net_device *netdev = NULL;
+	char ifname[IFNAMSIZ];
+
+	strncpy(ifname, buf, sizeof(ifname));
+	trimstr(ifname, strlen(ifname));
+
+	netdev = dev_get_by_name(&init_net, ifname);
+	if (!netdev) {
+		printk(KERN_ERR PFX "Couldn't get a network device for '%s'",
+		       ifname);
+		goto out;
+	}
+
+	vhba = find_vhba_for_netdev(netdev);
+	if (!vhba) {
+		printk(KERN_ERR PFX "vhba for '%s' doesn't exist - ignoring\n",
+		       ifname);
+		goto out;
+	}
+
+	mfc_link_change(vhba, link_up);
+
+out:
+	if (netdev)
+		dev_put(netdev);
+	return count;
+}
+
+static ssize_t mfc_sys_link_up(struct class *cl, struct class_attribute *attr,
+			       const char *buf, size_t count)
+{
+	return mfc_sys_link_change(cl, buf, count, 1);
+}
+
+static CLASS_ATTR(link_up, 0222, NULL, mfc_sys_link_up);
+
+static ssize_t mfc_sys_link_down(struct class *cl, struct class_attribute *attr,
+				 const char *buf, size_t count)
+{
+	return mfc_sys_link_change(cl, buf, count, 0);
+}
+
+static CLASS_ATTR(link_down, 0222, NULL, mfc_sys_link_down);
+
+struct class *mfc_class;
+
+struct class_attribute *class_attrs[] = {
+	&class_attr_link_up,
+	&class_attr_link_down,
+	&class_attr_create,
+	&class_attr_create_ib,
+	&class_attr_destroy,
+	NULL
+};
+
+int mfc_reset(struct Scsi_Host *shost)
+{
+	struct fc_lport *lp = shost_priv(shost);
+	struct mfc_vhba *vhba = lport_priv(lp);
+	int err = 0;
+
+	dev_info(vhba->mfc_port->mfc_dev->dma_dev,
+		 "Reset port%d vhba%d\n", vhba->mfc_port->port, vhba->idx);
+
+	vhba->need_reset = 1;
+	err = mfc_lld_reset(lp);
+	if (err)
+		goto out;
+
+	fc_lport_reset(lp);
+
+out:
+	return err;
+}
+
+static int mfc_lld_reset(struct fc_lport *lp)
+{
+	struct mfc_vhba *vhba = lport_priv(lp);
+	struct mfc_dev *mfc_dev = vhba->mfc_port->mfc_dev;
+	struct mlx4_caps *caps = &mfc_dev->dev->caps;
+	int port = vhba->mfc_port->port;
+	int err = 0;
+
+	if (!vhba->need_reset)
+		return -EINVAL;
+
+	dev_info(mfc_dev->dma_dev,
+		 "lld reset on port%d vhba%d link_up=%d\n",
+		 port, vhba->idx, vhba->link_up);
+
+	/* destroy data rfci - will be created on flogi accept */
+	if ((vhba->net_type == NET_ETH && !mfc_debug_mode) &&
+	    (vhba->rfci[RFCI_DATA].fc_mac_idx != -1)) {
+		vhba->rfci[RFCI_DATA].fc_qp.is_flushing = 1;
+		err = mfc_destroy_rfci(vhba, &vhba->rfci[RFCI_DATA]);
+		if (err) {
+			dev_err(mfc_dev->dma_dev,
+				"Failed to destroy DATA RFCI port%d vhba%d"
+				" err=%d\n", port, vhba->idx, err);
+			goto out;
+		}
+	}
+
+	vhba->rfci[RFCI_CTRL].fc_qp.is_flushing = 1;
+
+	/* destroy create and init ctrl rfci */
+	err = mfc_destroy_rfci(vhba, &vhba->rfci[RFCI_CTRL]);
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"Failed to destroy CTRL RFCI on port%d vhba%d err=%d\n",
+			port, vhba->idx, err);
+		goto out;
+	}
+
+	err =
+	    mfc_create_rfci(vhba, &vhba->rfci[RFCI_CTRL], caps->def_mac[port]);
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"port%d vhba%d: Could not create CTRL RFCI, err=%d\n",
+			port, vhba->idx, err);
+		goto out;
+	}
+
+	err = mfc_init_rfci(vhba, &vhba->rfci[RFCI_CTRL]);
+	if (err) {
+		mfc_destroy_rfci(vhba, &vhba->rfci[RFCI_CTRL]);
+		dev_err(mfc_dev->dma_dev,
+			"port%d vhba%d: Could not init CTRL RFCI, err=%d\n",
+			port, vhba->idx, err);
+		goto out;
+	}
+
+	vhba->rfci[RFCI_CTRL].fc_qp.is_flushing = 0;
+
+	/* destroy and create fcmd - will be init on flogi accept */
+	if (vhba->fcmd.fc_qp.is_created)
+		if (mfc_reset_fcmd(vhba))
+			dev_err(mfc_dev->dma_dev, "reset_fcmd failed\n");
+	vhba->flogi_finished = 0;
+	vhba->need_reset = 0;
+
+out:
+	return err;
+}
+
+/*
+ * Scsi handler for fexch abort.
+ * After calling this function scsi will destroy the cmd.
+ * So if there is our abort running it will fail.
+ */
+static int mfc_abort(struct scsi_cmnd *cmd)
+{
+	struct mfc_exch *fexch;
+	struct mfc_vhba *vhba;
+	struct fc_rport *rp;
+	struct fc_lport *lp;
+	int rc = FAILED;
+
+	lp = shost_priv(cmd->device->host);
+	if (!lp || lp->state != LPORT_ST_READY)
+		goto out;
+	else if (!lp->link_up)
+		goto out;
+
+	fexch = (struct mfc_exch *)cmd->SCp.ptr;
+	if (!fexch)
+		goto out;
+
+	vhba = fexch->vhba;
+	if (!vhba || !vhba->link_up)
+		goto out;
+
+	spin_lock_irq(lp->host->host_lock);
+
+	rp = starget_to_rport(scsi_target(fexch->scmd->device));
+	if (fc_remote_port_chkready(rp)) {
+		spin_unlock_irq(lp->host->host_lock);
+		goto out;
+	}
+
+	init_completion(&fexch->tm_done);
+
+	fexch->state = FEXCH_SEND_ABORT;
+
+	spin_unlock_irq(lp->host->host_lock);
+
+	/* Send ABTS for current fexch */
+	if (mfc_send_abort_tsk(fexch, rp->port_id))
+		goto out;
+
+	rc = wait_for_completion_timeout(&fexch->tm_done, MFC_CMD_TIMEOUT);
+
+	if (!rc) {
+		dev_err(vhba->mfc_port->mfc_dev->dma_dev,
+			"target abort cmd timeout\n");
+		rc = FAILED;
+	} else if (fexch->state == FEXCH_ABORT) {
+		dev_err(vhba->mfc_port->mfc_dev->dma_dev,
+			"target abort cmd done\n");
+		cmd->result = DID_ABORT << 16;
+		rc = SUCCESS;
+		mfc_reset_fexch(vhba, fexch);
+	} else if (fexch->state == FEXCH_CMD_DONE) {
+		dev_err(vhba->mfc_port->mfc_dev->dma_dev, "target cmd done\n");
+		rc = SUCCESS;
+		mfc_reset_fexch(vhba, fexch);
+		cmd->scsi_done(cmd);
+	} else
+		rc = FAILED;
+out:
+	return rc;
+}
+
+static int mfc_device_reset(struct scsi_cmnd *cmd)
+{
+	struct mfc_exch *fexch;
+	struct mfc_vhba *vhba;
+
+	fexch = (struct mfc_exch *)cmd->SCp.ptr;
+	if (!fexch)
+		return FAILED;
+
+	vhba = fexch->vhba;
+	if (!vhba || !vhba->link_up)
+		return FAILED;
+
+	dev_info(vhba->mfc_port->mfc_dev->dma_dev,
+		 "device reset function called\n");
+
+	return FAILED;
+}
+
+static int mfc_host_reset(struct scsi_cmnd *cmd)
+{
+	return (mfc_reset(cmd->device->host)) ? FAILED : SUCCESS;
+}
+
+struct fc_function_template mfc_transport_function = {
+	.show_host_node_name = 1,
+	.show_host_port_name = 1,
+	.show_host_supported_classes = 1,
+	.show_host_supported_fc4s = 1,
+	.show_host_active_fc4s = 1,
+	.show_host_maxframe_size = 1,
+
+	.show_host_port_id = 1,
+	.show_host_supported_speeds = 1,
+	.get_host_speed = fc_get_host_speed,
+	.show_host_speed = 1,
+	.show_host_port_type = 1,
+	.get_host_port_state = fc_get_host_port_state,
+	.show_host_port_state = 1,
+	.show_host_symbolic_name = 1,
+
+	.dd_fcrport_size = sizeof(struct fc_rport_libfc_priv),
+	.show_rport_maxframe_size = 1,
+	.show_rport_supported_classes = 1,
+
+	.show_host_fabric_name = 1,
+	.show_starget_node_name = 1,
+	.show_starget_port_name = 1,
+	.show_starget_port_id = 1,
+	.set_rport_dev_loss_tmo = fc_set_rport_loss_tmo,
+	.show_rport_dev_loss_tmo = 1,
+	.get_fc_host_stats = fc_get_host_stats,
+	.issue_fc_host_lip = mfc_reset,
+	.terminate_rport_io = fc_rport_terminate_io,
+};
+
+static int __init mfc_init(void)
+{
+	int err = 0;
+	int i;
+
+	if (mfc_debug_mode) {
+		int r;
+		r = sscanf(gateway_mac,
+			   "%02hhx:%02hhx:%02hhx:%02hhx:%02hhx:%02hhx",
+			   &gw_mac[0], &gw_mac[1], &gw_mac[2], &gw_mac[3],
+			   &gw_mac[4], &gw_mac[5]);
+		if (r != 6) {
+			printk(KERN_ERR "Bad gw_mac: %s. r=%d\n", gateway_mac,
+			       r);
+			return -1;
+		}
+	}
+
+	mfc_transport_template = fc_attach_transport(&mfc_transport_function);
+	if (mfc_transport_template == NULL) {
+		printk(KERN_ERR PFX "Fail to attach fc transport");
+		return -1;
+	}
+
+	err = mlx4_register_interface(&mfc_interface);
+	if (err)
+		return err;
+
+	mfc_class = class_create(THIS_MODULE, "mlx4_fc");
+	if (IS_ERR(mfc_class))
+		goto err_unreg;
+
+	for (i = 0; class_attrs[i]; i++) {
+		err = class_create_file(mfc_class, class_attrs[i]);
+		if (err) {
+			class_attrs[i] = NULL;
+			return err;
+		}
+	}
+
+	return 0;
+
+err_unreg:
+	mlx4_unregister_interface(&mfc_interface);
+
+	return err;
+}
+
+static void __exit mfc_cleanup(void)
+{
+	int i;
+
+	for (i = 0; class_attrs[i]; i++)
+		class_remove_file(mfc_class, class_attrs[i]);
+
+	class_destroy(mfc_class);
+	mlx4_unregister_interface(&mfc_interface);
+	fc_release_transport(mfc_transport_template);
+}
+
+module_init(mfc_init);
+module_exit(mfc_cleanup);
diff --git a/drivers/scsi/mlx4_fc/mfc.h b/drivers/scsi/mlx4_fc/mfc.h
new file mode 100644
index 0000000..6e7bd4c
--- /dev/null
+++ b/drivers/scsi/mlx4_fc/mfc.h
@@ -0,0 +1,666 @@
+/*
+ * Copyright (c) 2010 Mellanox Technologies. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+#ifndef MFC_H
+#define MFC_H
+
+#include <linux/compiler.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/skbuff.h>
+#include <linux/if_ether.h>
+#include <linux/interrupt.h>
+#include <linux/kobject.h>
+
+#include <linux/mlx4/driver.h>
+#include <linux/mlx4/device.h>
+#include <linux/mlx4/qp.h>
+#include <linux/mlx4/doorbell.h>
+#include <linux/mlx4/qp.h>
+#include <linux/mlx4/srq.h>
+#include <linux/mlx4/cq.h>
+#include <linux/mlx4/cmd.h>
+#include <linux/netdevice.h>
+
+#include <scsi/scsi_cmnd.h>
+#include <scsi/libfc.h>
+#include <scsi/libfcoe.h>
+#include <scsi/fc_frame.h>
+#include <scsi/fc/fc_fcp.h>
+#include <scsi/fc/fc_fcoe.h>
+
+#include "fcoib_api.h"
+
+#define MFC_CMD_TIMEOUT			(5 * HZ)
+#define MFC_MAX_LUN			255
+#define MFC_MAX_FCP_TARGET		256
+#define MFC_MAX_CMD_PER_LUN		16
+#define MFC_BIT_DESC_OWN		0x80000000
+#define MFC_RFCI_OP_SEND		0xa
+#define MFC_CMD_OP_SEND			0xd
+#define MFC_BIT_INS_VLAN		0x4000
+#define MFC_BIT_NO_ICRC			0x2
+#define MFC_BIT_TX_COMP			0xc
+#define MFC_BIT_TX_IP_CS		0x10
+#define MFC_BIT_TX_TCP_CS		0x20
+#define MFC_BIT_TX_FCRC_CS		0x40
+#define MFC_CQ_ARM_CMD			0x2
+#define MFC_CMD_CQ_ENTRIES		128
+#define MFC_RFCI_CQ_ENTRIES		128
+#define MFC_NUM_NPORT_IDS		128
+#define MFC_MAX_PORT_FEXCH		(64 * 1024)
+#define MFC_MAX_FMR_PAGES		512
+#define MFC_FMR_PAGE_SHIFT		9
+#define MFC_RFCI_RX_SKB_BUFSIZE		(PAGE_SIZE - 1024)
+#define MFC_CMD_RX_SKB_BUFSIZE		(PAGE_SIZE - 1024)
+#define MFC_ALLOC_ORDER			2
+#define MFC_ALLOC_SIZE			(PAGE_SIZE << MFC_ALLOC_ORDER)
+#define MFC_GW_ADDR_MODE		0x00
+#define MFC_FCOUI_ADDR_MODE		0x01
+#define MFC_ASYNC_DELAY			(HZ / 4)
+
+#define MLX4_CMD_CONFIG_FC		0x4a
+#define MLX4_CMD_SET_VLAN_FLTR		0x47
+#define MLX4_CMD_MOD_FC_ENABLE		0
+#define MLX4_CMD_MOD_FC_DISABLE		1
+#define MLX4_CMD_INMOD_BASIC_CONF	0x0000
+#define MLX4_CMD_INMOD_NPORT_TAB	0x0100
+#define MLX4_LINK_TYPE_IB		0
+#define MLX4_LINK_TYPE_ETH		1
+#define MLX4_MPT_ENABLE_INVALIDATE	(0x3 << 24)
+#define MLX4_FCOIB_QKEY			0x80020005
+#define MLX4_DEFAULT_FC_MTU		2112
+#define MLX4_DEFAULT_NUM_RESERVED_XIDS	256
+#define MLX4_DEFAULT_LOG_EXCH_PER_VHBA	10
+#define MLX4_DEFAULT_MAX_VHBA_PER_PORT			\
+	(1 << (16 - MLX4_DEFAULT_LOG_EXCH_PER_VHBA))
+
+/* aligned to cacheline (wqe bug), enough for 1 ctl + 1 dgram + 1 ds */
+#define RFCI_SQ_BB_SIZE			128
+#define RFCI_RQ_WQE_SIZE		sizeof(struct mfc_data_seg)
+
+/* 1 ctl + 1 IB addr + 1 fcp init + 1 ds = 96*/
+#define FCMD_SQ_BB_SIZE			128
+#define FCMD_RQ_NUM_WQES		1	/* minimum allowed 2^0 */
+#define FCMD_RQ_WQE_SIZE		16	/* minimum allowed 2^0 * 16 */
+#define FEXCH_SQ_NUM_BBS		1	/* minimum allowed 2^0 */
+#define FEXCH_SQ_BB_SIZE		16	/* minimum allowed 2^0 * 16 */
+#define FEXCH_RQ_WQE_SIZE		16	/* 1 ds */
+#define FEXCH_RQ_NUM_WQES		32
+#define VLAN_FLTR_SIZE			128
+#define VHBA_SYSFS_LEN			32
+#define FC_MAX_ERROR_CNT		5
+#define QPC_SERVICE_TYPE_RFCI		9
+#define QPC_SERVICE_TYPE_FCMD		4
+#define QPC_SERVICE_TYPE_FEXCH		5
+#define ETH_P_FIP			0x8914
+#define FCOIB_SIG			0x4000
+#define QUERY_PORT_LINK_MASK		0x80
+#define SQ_NO_PREFETCH			(1 << 7)
+#define DATA_QPN			0
+#define CTRL_QPN			0
+
+#define FCOE_WORD_TO_BYTE		4
+#define	FCOE_ENCAPS_LEN_SOF(len, sof)	((FC_FCOE_VER << 14) |	\
+					 (((len) & 0x3ff) << 4) | ((sof) & 0xf))
+#define	FCOE_DECAPS_LEN(n)		(((n) >> 4) & 0x3ff)
+#define	FCOE_DECAPS_SOF(n)		(((n) & 0x8) ? (((n) &	\
+					 0xf) + 0x20) : (((n) & 0xf) + 0x30))
+
+#define XNOR(x, y)			(!(x) == !(y))
+
+#define MLX4_PUT(dest, source, offset)				\
+do {								\
+	void *__d = ((char *) (dest) + (offset));		\
+	switch (sizeof(source)) {				\
+	case 1:							\
+		*(u8 *) __d = (source);				\
+		break;						\
+	case 2:							\
+		*(__be16 *) __d = cpu_to_be16(source);		\
+		break;						\
+	case 4:							\
+		*(__be32 *) __d = cpu_to_be32(source);		\
+		break;						\
+	case 8:							\
+		*(__be64 *) __d = cpu_to_be64(source);		\
+		break;						\
+	default:						\
+		BUG();						\
+	}							\
+} while (0)
+
+#define OFFSET_IN_PAGE(v)	((u64)(v) & (PAGE_SIZE - 1))
+#define SHIFT_TO_SIZE(x)	(1 << (x))
+#define SHIFT_TO_MASK(x)	(~((u64) SHIFT_TO_SIZE(x) - 1))
+
+#define MAC_PRINTF_FMT "%02x:%02x:%02x:%02x:%02x:%02x"
+#define MAC_PRINTF_VAR(m) m[0], m[1], m[2], m[3], m[4], m[5]
+
+#define mfc_q_info_get(q, index, type)				\
+	(*((type *)((q)->info + ((index) * sizeof(type)))))
+
+#define mlx4_from_ctlr(fc) container_of(fc, struct mfc_vhba, ctlr)
+
+struct mfc_vhba;
+
+struct fcoe_hdr_old {
+	__be16 fcoe_plen;	/* fc frame len and SOF */
+};
+
+struct fcoe_crc_eof_old {
+	__be32 fcoe_crc32;	/* CRC for FC packet */
+	u8 fcoe_eof;		/* EOF */
+} __attribute__ ((packed));
+
+enum mfc_cmd_io_dir {
+	FCMD_IO_DIR_TARGET = 0,
+	FCMD_IO_DIR_READ,
+	FCMD_IO_DIR_WRITE,
+	FCMD_IO_DIR_BIDI,
+};
+
+enum mfc_rfci_type {
+	RFCI_CTRL = 0,
+	RFCI_DATA,
+	RFCI_NUM		/* must be last */
+};
+
+struct mfc_basic_config_params {
+	__be32 fexch_base;
+	u8 nm, nv, np;
+	__be32 fexch_base_mpt;
+	u8 log_num_rfci;
+	__be32 rfci_base;
+	__be32 def_fcoe_promisc_qpn;
+	__be32 def_fcoe_mcast_qpn;
+};
+
+struct mfc_query_port_context {
+	u8 supported_port_type;
+	u8 actual_port_type;
+	__be16 mtu;
+	u32 reserved2[3];
+	__be64 mac;
+};
+
+struct mfc_set_vlan_fltr_mbox {
+	__be32 entry[VLAN_FLTR_SIZE];
+};
+
+struct mfc_exch_cqe {
+	__be32 my_qpn;
+	__be32 invalidate_key;
+	__be32 seq_id_rqpn_srq;
+	__be32 xmit_byte_count;
+	__be32 rcv_byte_count;
+	__be32 byte_cnt;
+	__be16 wqe_index;
+	__be16 seq_count;
+	u8 reserved[3];
+	u8 owner_sr_opcode;
+};
+
+enum mfc_en_link_state {
+	LINK_DOWN,
+	LINK_UP
+};
+
+enum mfc_net_type {
+	NET_IB = 1,
+	NET_ETH = 2,
+};
+
+struct mfc_bitmap {
+	unsigned long *addr;
+	unsigned size;
+	unsigned long last_bit;
+};
+
+typedef void (*comp_fn) (struct mfc_vhba *, struct mlx4_cqe *);
+
+struct mfc_cq {
+	struct mlx4_cq mcq;
+	struct mlx4_hwq_resources wqres;
+	int size;
+	int buf_size;
+	struct mfc_cqe *buf;
+	int size_mask;
+	char name[10];
+	struct mfc_vhba *vhba;
+	comp_fn comp_rx;
+	comp_fn comp_tx;
+};
+
+struct mfc_queue {
+	u32 size;
+	u32 size_mask;
+	u16 stride;
+	u32 prod;
+	u32 cons;
+	void *buf;
+	spinlock_t lock;
+	void *info;
+};
+
+struct mfc_qp {
+	struct mlx4_qp mqp;
+	u32 buf_size;
+	struct mlx4_hwq_resources wqres;
+	struct mfc_queue sq;
+	struct mfc_queue rq;
+	u32 doorbell_qpn;
+	int is_created;
+	int is_flushing;
+};
+
+struct mfc_rfci {
+	struct mfc_qp fc_qp;
+	struct mfc_cq fc_cq;
+	u8 mac[ETH_ALEN];
+	int fc_mac_idx;
+};
+
+struct mfc_cmd {
+	struct mfc_qp fc_qp;
+	struct mfc_cq fc_cq;
+};
+
+enum mfc_exch_state {
+	FEXCH_OK = 1,
+	FEXCH_CMD_DONE,
+	FEXCH_SEND_ABORT,
+	FEXCH_ABORT
+};
+
+struct mfc_exch {
+	struct mfc_vhba *vhba;
+	struct mfc_qp fc_qp;
+	struct mlx4_fmr fmr;
+	char *bouncebuff;
+	int bounce_off;
+	struct scatterlist bounce_sg[1];
+	int tx_completed;
+	int mtu;
+	int fcmd_wqe_idx;
+	u8 *response_buf;
+	struct scsi_cmnd *scmd;
+	struct completion tm_done;
+	enum mfc_exch_state state;
+};
+
+struct mfc_sysfs_attr {
+	void *ctx;
+	struct kobject *kobj;
+	unsigned long data;
+	char name[VHBA_SYSFS_LEN];
+	struct module_attribute mattr;
+	struct device *dev;
+};
+
+struct nport_id {
+	u8 reserved;
+	u8 fid[3];
+};
+
+/* represents a virtual HBA on a port */
+struct mfc_vhba {
+	struct list_head list;
+	struct fc_lport *lp;
+	struct mfc_port *mfc_port;
+	void *underdev;
+	int idx;
+	int fc_vlan_id;
+	int fc_vlan_idx;
+	int fc_vlan_prio;
+	struct mfc_rfci rfci[RFCI_NUM];
+	struct mfc_cmd fcmd;
+	struct mfc_exch *fexch;
+	struct mfc_bitmap fexch_bm;
+	int num_fexch;
+	struct mfc_cq fexch_cq[NR_CPUS];
+	int base_fexch_qpn;
+	int base_fexch_mpt;
+	int base_reserved_xid;
+	int num_reserved_xid;
+	enum mfc_net_type net_type;
+	u8 dest_addr[ETH_ALEN];
+	int dest_ib_lid;
+	unsigned long dest_ib_ctrl_qpn;
+	unsigned long dest_ib_data_qpn;
+	int dest_ib_sl;
+	int flogi_finished;
+	int link_up;
+	struct nport_id my_npid;
+	int fc_payload_size;
+	u16 flogi_oxid;
+	u8 flogi_progress;
+	u8 fcoe_hlen;
+	u8 rfci_rx_enabled;
+	u8 need_reset;
+	struct delayed_work delayed_work;
+
+	/* Saved libfc rport_login callback */
+	int (*fc_rport_login) (struct fc_rport_priv *rdata);
+
+	/* sysfs stuff */
+	struct mfc_sysfs_attr dentry;
+
+	/*handle & callback for FCoIB discovery */
+	u64 gw_discovery_handle;
+	fcoib_send_els_cb fcoib_send_els_cb;
+
+	/* fip stuff */
+	struct packet_type fip_packet_type;
+	struct fcoe_ctlr ctlr;
+
+	struct fc_exch_mgr *emp;
+};
+
+/* represents a physical port on HCA */
+struct mfc_port {
+	struct mfc_dev *mfc_dev;
+	u8 port;
+	u8 n_m;
+	u8 n_v;
+	u8 n_p;
+	int base_rfci_qpn;
+	int base_fexch_qpn;
+	int base_fexch_mpt;
+	int num_fexch_qps;
+	int log_num_fexch_per_vhba;
+	int initialized;
+	struct mfc_bitmap fexch_bulk_bm;
+	struct list_head vhba_list;
+	spinlock_t lock;
+	struct mfc_sysfs_attr dentry;
+	struct nport_id npid_table[MFC_NUM_NPORT_IDS];
+	struct workqueue_struct *rfci_wq;
+	struct workqueue_struct *async_wq;
+};
+
+/* represents a single HCA */
+struct mfc_dev {
+	struct list_head list;
+	struct mlx4_dev *dev;
+	struct mfc_port mfc_port[MLX4_MAX_PORTS + 1];
+	int base_rfci_qpn;
+	int num_rfci_qps;
+	int log_num_mac;
+	int log_num_vlan;
+	int log_num_prio;
+	struct list_head pgdir_list;
+	struct mutex pgdir_mutex;
+	void __iomem *uar_map;
+	struct mlx4_uar priv_uar;
+	u32 priv_pdn;
+	struct mlx4_mr mr;
+	struct device *dma_dev;
+	int idx;
+	 MLX4_DECLARE_DOORBELL_LOCK(uar_lock);
+};
+
+struct mfc_rfci_rx_info {
+	struct mfc_vhba *vhba;
+	struct sk_buff *skb;
+	struct work_struct work;
+};
+
+struct mfc_flogi_finished_info {
+	struct work_struct work;
+	struct sk_buff *skb;
+	u8 eof;
+	struct fc_lport *lp;
+};
+
+struct mfc_ctrl_seg {
+	__be32 op_own;
+	__be16 vlan;
+	__be16 size;
+	__be32 flags;
+	__be32 parameter;
+};
+
+struct mfc_datagram_seg {
+	__be32 fl_portn_pd;
+	u8 reserved1;
+	u8 mlid_grh;
+	__be16 rlid;
+	u8 reserved2;
+	u8 mgid_idx;
+	u8 stat_rate;
+	u8 hop_limit;
+	__be32 sl_tclass_flabel;
+	__be32 rgid[4];
+	__be32 dqpn;
+	__be32 qkey;
+	__be32 reserved3[2];
+};				/* size 12 dwords */
+
+struct mfc_data_seg {
+	__be32 count;
+	__be32 mem_type;
+	__be64 addr;
+};
+
+struct mfcoe_rfci_tx_desc {
+	struct mfc_ctrl_seg ctrl;
+	struct mfc_data_seg data;	/* at least one data segment */
+};				/* size 8 dwords */
+
+struct mfcoib_rfci_tx_desc {
+	struct mfc_ctrl_seg ctrl;
+	struct mfc_datagram_seg dgram;
+	struct mfc_data_seg data;	/* at least one data segment */
+};				/* size 20 dwords */
+
+struct mfc_rx_desc {
+	struct mfc_data_seg data[0];
+};
+
+struct mfc_eth_addr_seg {
+	u8 static_rate;
+	u8 reserved1[3];
+	__be32 reserved2;
+	u8 reserved3[2];
+	u8 dmac[6];
+};
+
+struct mfc_init_seg {
+	u8 reserved1;
+	u8 pe;
+	u16 reserved;
+	u8 cs_ctl;
+	u8 seq_id_tx;
+	__be16 mtu;
+	u8 remote_fid[3];
+	u8 flags;
+	__be16 remote_exch;
+	__be16 local_exch_idx;
+};
+
+struct mfcoe_cmd_tx_desc {
+	struct mfc_ctrl_seg ctrl;
+	struct mfc_eth_addr_seg addr;
+	struct mfc_init_seg init;
+	struct mfc_data_seg data;
+};				/* 16 DWORDS, 64B */
+
+struct mfcoib_cmd_tx_desc {
+	struct mfc_ctrl_seg ctrl;
+	struct mfc_datagram_seg addr;
+	struct mfc_init_seg init;
+	struct mfc_data_seg data;
+};				/* 24 DWORDS, 96B */
+
+struct mfc_rx_thread {
+	int cpu;
+	struct task_struct *thread;
+	struct sk_buff_head rx_list;
+};
+
+static inline int mlx4_qp_to_reset(struct mlx4_dev *dev, struct mlx4_qp *qp)
+{
+	return mlx4_cmd(dev, 0, qp->qpn, 2,
+			MLX4_CMD_2RST_QP, MLX4_CMD_TIME_CLASS_A);
+}
+
+static inline int mlx4_qp_to_error(struct mlx4_dev *dev, struct mlx4_qp *qp)
+{
+	return mlx4_cmd(dev, 0, qp->qpn, 0,
+			MLX4_CMD_2ERR_QP, MLX4_CMD_TIME_CLASS_A);
+}
+
+#define mfc_bitmap_empty(bm)					\
+	(find_first_bit((bm)->addr, (bm)->size) >= (bm)->size)
+
+static inline int mfc_bitmap_alloc(struct mfc_bitmap *bitmap, unsigned size)
+{
+	bitmap->addr = kzalloc(sizeof(unsigned long) * BITS_TO_LONGS(size),
+			       GFP_KERNEL);
+	if (!bitmap->addr)
+		return -ENOMEM;
+
+	bitmap->size = size;
+	bitmap->last_bit = size - 1;
+
+	return 0;
+}
+
+static inline void mfc_bitmap_free(struct mfc_bitmap *bitmap)
+{
+	kfree(bitmap->addr);
+}
+
+static inline int mfc_bitmap_slot_alloc(struct mfc_bitmap *bm, int from_zero)
+{
+	int slot_num, last_bit = bm->last_bit + 1;
+
+	if (from_zero)
+		last_bit = 0;
+	do {
+		slot_num = find_next_zero_bit(bm->addr, bm->size,
+					      last_bit % bm->size);
+		if (slot_num >= bm->size) {
+			slot_num = find_first_zero_bit(bm->addr, bm->size);
+			if (slot_num >= bm->size)
+				return -1;
+		}
+	} while (test_and_set_bit(slot_num, bm->addr));
+
+	bm->last_bit = slot_num;
+	return slot_num;
+}
+
+static inline void mfc_bitmap_slot_free(struct mfc_bitmap *bm, int slot_num)
+{
+	if (slot_num >= bm->size)
+		printk(KERN_WARNING
+		       "Error: Trying to free out of bound slot number\n");
+	clear_bit(slot_num, bm->addr);
+}
+
+static inline char *mfc_bitmap_print(struct mfc_bitmap *bm)
+{
+#define BM_STR_BUF_LEN 1024
+	static char buf[BM_STR_BUF_LEN];
+	int i;
+	int len = 0;
+
+	len +=
+	    snprintf(buf + len, BM_STR_BUF_LEN - len, "size: %d, ", bm->size);
+
+	for (i = 0; i < BITS_TO_LONGS(bm->size); i++) {
+		len += snprintf(buf + len, BM_STR_BUF_LEN - len, "%08llx ",
+				cpu_to_be64(bm->addr[i]));
+	}
+
+	buf[len] = '\0';
+	return buf;
+}
+
+static inline void mfc_ring_db_rx(struct mfc_qp *fc_qp)
+{
+	struct mfc_queue *rq = &fc_qp->rq;
+
+	wmb();
+	*fc_qp->wqres.db.db = cpu_to_be32(rq->prod & 0xffff);
+	wmb();
+}
+
+extern int mfc_num_reserved_xids;
+extern int mfc_t11_mode;
+extern int mfc_debug_mode;
+
+extern int mfc_create_rfci(struct mfc_vhba *, struct mfc_rfci *, u64);
+extern int mfc_destroy_rfci(struct mfc_vhba *, struct mfc_rfci *);
+extern int mfc_init_rfci(struct mfc_vhba *, struct mfc_rfci *);
+extern int mfc_start_rfci_data(struct mfc_vhba *, u64);
+
+extern int mfc_init_port(struct mfc_dev *, int);
+extern void mfc_free_port(struct mfc_dev *, int);
+
+extern int mfc_create_vhba(struct mfc_port *, unsigned int, int, int,
+			   int, unsigned long, unsigned long, int, void *,
+			   const char *, u64, fcoib_send_els_cb,
+			   enum mfc_net_type, u64, u64);
+extern void mfc_remove_vhba(struct mfc_vhba *);
+
+extern int mfc_init_fcmd(struct mfc_vhba *);
+extern int mfc_reset_fcmd(struct mfc_vhba *);
+extern int mfc_create_fcmd(struct mfc_vhba *);
+extern void mfc_destroy_fcmd(struct mfc_vhba *);
+extern int mfc_post_rx_buf(struct mfc_dev *, struct mfc_qp *, void *, size_t);
+extern int mfc_q_init(struct mfc_queue *, u16, size_t, size_t);
+extern void mfc_q_destroy(struct mfc_queue *);
+extern void mfc_stamp_q(struct mfc_queue *);
+extern int flush_qp(struct mfc_dev *, struct mfc_qp *, int, int,
+		    struct mfc_cq *, struct mfc_exch *);
+extern int mfc_create_cq(struct mfc_vhba *, struct mfc_cq *, int, int, int,
+			 comp_fn, comp_fn, char *);
+extern void mfc_destroy_cq(struct mfc_cq *);
+extern void mfc_cq_clean(struct mfc_cq *);
+extern int mfc_flogi_finished(struct fc_lport *);
+extern void mfc_recv_flogi(struct fc_lport *, struct fc_frame *, u8 mc[6]);
+extern int mfc_reset_fexch(struct mfc_vhba *, struct mfc_exch *);
+extern int mfc_frame_send(struct fc_lport *, struct fc_frame *);
+extern int mfc_send_abort_tsk(struct mfc_exch *, u32);
+extern int mfc_queuecommand(struct scsi_cmnd *,
+			    void (*done) (struct scsi_cmnd *));
+
+extern void mfc_vhba_delete_dentry(struct mfc_vhba *);
+extern int mfc_vhba_create_dentry(struct mfc_vhba *);
+extern void mfc_port_delete_dentry(struct mfc_port *);
+extern int mfc_port_create_dentry(struct mfc_port *);
+
+#endif /* MFC_H */
diff --git a/drivers/scsi/mlx4_fc/mfc_exch.c b/drivers/scsi/mlx4_fc/mfc_exch.c
new file mode 100644
index 0000000..72eda55
--- /dev/null
+++ b/drivers/scsi/mlx4_fc/mfc_exch.c
@@ -0,0 +1,1496 @@
+/*
+ * Copyright (c) 2010 Mellanox Technologies. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/log2.h>
+#include <linux/delay.h>
+#include <linux/vmalloc.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_fc.h>
+#include <scsi/scsi_tcq.h>
+#include <linux/mlx4/driver.h>
+#include <linux/mlx4/cmd.h>
+#include <linux/mlx4/cq.h>
+#include <scsi/fc_frame.h>
+#include <scsi/fc/fc_fcp.h>
+#include <scsi/fc/fc_els.h>
+#include <scsi/fc/fc_fcoe.h>
+#include <scsi/libfc.h>
+
+#include "mfc.h"
+
+static enum mfc_cmd_io_dir scsi_dir_translate(enum dma_data_direction dmadir)
+{
+	switch (dmadir) {
+	case DMA_BIDIRECTIONAL:
+		return FCMD_IO_DIR_BIDI;
+	case DMA_FROM_DEVICE:
+		return FCMD_IO_DIR_READ;
+	case DMA_TO_DEVICE:
+		return FCMD_IO_DIR_WRITE;
+	case DMA_NONE:
+		return FCMD_IO_DIR_TARGET;
+	}
+	return -1;
+}
+
+static void mfc_cmd_tx_comp(struct mfc_vhba *vhba, struct mlx4_cqe *cqe)
+{
+	struct mfc_port *fc_port = vhba->mfc_port;
+	struct mfc_dev *mfc_dev = fc_port->mfc_dev;
+	struct mfc_queue *sq = &vhba->fcmd.fc_qp.sq;
+	struct mfc_data_seg *data = NULL;
+	struct mfc_exch *fexch;
+	u64 dma;
+	u32 count;
+	unsigned long flags;
+	int is_err = 0, xno = 0;
+	int wqe_idx = be16_to_cpu(cqe->wqe_index) & sq->size_mask;
+
+	is_err = ((cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) == 0x1e) ? 1 : 0;
+
+	if (is_err && vhba->fcmd.fc_qp.is_flushing)
+		dev_info(mfc_dev->dma_dev, "FCMD WQE %d flushed\n", wqe_idx);
+
+	if (vhba->net_type == NET_IB) {
+		struct mfcoib_cmd_tx_desc *tx_desc;
+
+		tx_desc = sq->buf + wqe_idx * FCMD_SQ_BB_SIZE;
+		data = &tx_desc->data;
+		xno = be16_to_cpu(tx_desc->init.local_exch_idx);
+	} else if (vhba->net_type == NET_ETH) {
+		struct mfcoe_cmd_tx_desc *tx_desc;
+
+		tx_desc = sq->buf + wqe_idx * FCMD_SQ_BB_SIZE;
+		data = &tx_desc->data;
+		xno = be16_to_cpu(tx_desc->init.local_exch_idx);
+	}
+
+	fexch = &vhba->fexch[xno];
+	fexch->tx_completed = 1;
+
+	dma = be64_to_cpu(data->addr);
+	count = be32_to_cpu(data->count);
+
+	pci_unmap_single(mfc_dev->dev->pdev, dma, count, PCI_DMA_TODEVICE);
+
+	spin_lock_irqsave(&sq->lock, flags);
+	sq->cons++;
+	spin_unlock_irqrestore(&sq->lock, flags);
+}
+
+static int mfc_map_sg_to_fmr(struct mfc_dev *mfc_dev,
+			     struct scatterlist *sglist, int nents,
+			     struct mfc_exch *fexch,
+			     enum dma_data_direction dir)
+{
+	struct mlx4_fmr *fmr = &fexch->fmr;
+	struct scatterlist *sg;
+	int page_cnt, sg_cnt;
+	unsigned int total_len;
+	int i;
+	u64 fmr_page_mask = SHIFT_TO_MASK(fmr->page_shift);
+	u64 dma;
+	u64 page_list[MFC_MAX_FMR_PAGES];
+	unsigned int fmr_page_size = SHIFT_TO_SIZE(fmr->page_shift);
+	u32 rkey, lkey;
+	int rc = 0;
+
+	sg_cnt = pci_map_sg(mfc_dev->dev->pdev, sglist, nents, dir);
+
+	if (sg_dma_address(sglist) & ~fmr_page_mask) {
+		rc = -EAGAIN;
+		goto out_unmap;
+	}
+
+	page_cnt = 0;
+	total_len = 0;
+	for_each_sg(sglist, sg, sg_cnt, i) {
+		total_len += sg_dma_len(sg);
+
+		if (sg_dma_address(sg) & ~fmr_page_mask) {
+			if (i > 0) {
+				rc = -EINVAL;
+				goto out_unmap;
+			}
+		}
+		if ((sg_dma_address(sg) + sg_dma_len(sg)) & ~fmr_page_mask) {
+			if (i < sg_cnt - 1) {
+				rc = -EINVAL;
+				goto out_unmap;
+			}
+		}
+
+		for (dma = (sg_dma_address(sg) & fmr_page_mask);
+		     dma < sg_dma_address(sg) + sg_dma_len(sg);
+		     dma += fmr_page_size) {
+			if (page_cnt == fmr->max_pages) {
+				rc = -EINVAL;
+				goto out_unmap;
+			}
+
+			page_list[page_cnt] = dma;
+			++page_cnt;
+		}
+	}
+
+	rc = mlx4_map_phys_fmr_fbo(mfc_dev->dev, fmr, page_list, page_cnt, 0,
+				   sg_dma_address(sglist) & ~fmr_page_mask,
+				   total_len, &lkey, &rkey, 1);
+	if (rc) {
+		dev_err(mfc_dev->dma_dev, "Could not map FMR rc=%d\n", rc);
+		goto out_unmap;
+	}
+
+	return 0;
+
+out_unmap:
+	pci_unmap_sg(mfc_dev->dev->pdev, sglist, nents, dir);
+	return rc;
+}
+
+#define BOUNCESIZE 16384
+
+static int mfc_create_bounce(struct mfc_dev *mfc_dev,
+			     struct scsi_cmnd *cmd, struct mfc_exch *fexch)
+{
+	void *bouncebuff;
+	int bounceoff = fexch->bounce_off;
+	unsigned int total_len;
+	struct scatterlist *sg;
+	void *page_addr;
+	int i;
+
+	if (scsi_bufflen(cmd) > BOUNCESIZE - bounceoff)
+		return -ENOMEM;
+
+	bouncebuff = kmalloc(BOUNCESIZE, GFP_ATOMIC);
+	if (!bouncebuff)
+		return -ENOMEM;
+
+	total_len = 0;
+	scsi_for_each_sg(cmd, sg, scsi_sg_count(cmd), i) {
+		if (cmd->sc_data_direction == DMA_TO_DEVICE) {
+			page_addr = kmap_atomic(sg_page(sg), KM_SOFTIRQ0);
+			memcpy(bouncebuff + bounceoff + total_len,
+			       page_addr + (sg->offset & ~PAGE_MASK),
+			       sg->length);
+			kunmap_atomic(page_addr, KM_SOFTIRQ0);
+		}
+		total_len += sg->length;
+	}
+	sg_init_one(&fexch->bounce_sg[0], bouncebuff + bounceoff,
+		    scsi_bufflen(cmd));
+	fexch->bouncebuff = bouncebuff;
+
+	return 0;
+}
+
+static int mfc_map_fmr(struct mfc_dev *mfc_dev, struct scsi_cmnd *cmd,
+		       struct mfc_exch *fexch)
+{
+	int err;
+
+	if (cmd->sc_data_direction == DMA_NONE)
+		return 0;
+
+	if (cmd->sc_data_direction == DMA_BIDIRECTIONAL) {
+		dev_err(mfc_dev->dma_dev, "BIDI SCSI commands not supported\n");
+		return -EINVAL;
+	}
+
+	fexch->bouncebuff = NULL;
+	fexch->bounce_off = 0;
+	err = mfc_map_sg_to_fmr(mfc_dev,
+				scsi_sglist(cmd), scsi_sg_count(cmd),
+				fexch, cmd->sc_data_direction);
+	if ((err == -EAGAIN) || (err == -EINVAL)) {
+		err = mfc_create_bounce(mfc_dev, cmd, fexch);
+		if (err)
+			return err;
+		err = mfc_map_sg_to_fmr(mfc_dev, &fexch->bounce_sg[0], 1,
+					fexch, cmd->sc_data_direction);
+	}
+
+	return err;
+}
+
+void mfc_rx_fcp_resp(struct mfc_vhba *vhba, struct fcp_resp *fc_rp,
+		     struct scsi_cmnd *scmd, size_t xfer_len,
+		     struct mlx4_fmr *fmr, u32 xno)
+{
+	enum dma_data_direction data_dir;
+	u8 cdb_op;
+	struct fcp_resp_ext *rp_ex;
+	struct fcp_resp_rsp_info *fc_rp_info;
+	u32 respl = 0;
+	u32 snsl = 0;
+	u32 scsi_resid;
+	u8 cdb_status;
+	unsigned data_len = scsi_bufflen(scmd);
+
+	/* things from openfc_scsi_rcv(), RESPONSE branch */
+	cdb_status = fc_rp->fr_status;
+	if ((fc_rp->fr_flags == 0) && (fc_rp->fr_status == 0)) {
+		data_dir = scmd->sc_data_direction;
+		cdb_op = scmd->cmnd[0];
+		if (data_dir == DMA_FROM_DEVICE) {
+			if (data_len > xfer_len) {
+				if ((cdb_op != READ_10 ||
+				     cdb_op != READ_6 ||
+				     cdb_op != WRITE_10 || cdb_op != WRITE_6)) {
+					scmd->result = DID_IMM_RETRY << 16;
+				} else {
+					if (cdb_status == 0) {
+						scmd->result =
+						    (DID_OK << 16) | cdb_status;
+					} else {
+						scmd->SCp.buffers_residual =
+						    scsi_resid;
+						scmd->result =
+						    (DID_ERROR << 16) |
+						    cdb_status;
+					}
+				}
+			} else if (data_len < xfer_len) {
+				if ((cdb_op != READ_10 ||
+				     cdb_op != READ_6 ||
+				     cdb_op != WRITE_10 || cdb_op != WRITE_6)) {
+					scmd->result = DID_IMM_RETRY << 16;
+				} else {
+					scmd->result =
+					    (DID_ERROR << 16) | cdb_status;
+				}
+			} else
+				scmd->result = (DID_OK << 16);
+		}
+	} else {
+		rp_ex = (void *)(fc_rp + 1);
+		fc_rp_info = (struct fcp_resp_rsp_info *)(rp_ex + 1);
+		if (fc_rp->fr_flags & FCP_RSP_LEN_VAL) {
+			respl = ntohl(rp_ex->fr_rsp_len);
+			if ((respl != 0 && respl != 4 && respl != 8) ||
+			    (fc_rp_info->rsp_code != FCP_TMF_CMPL)) {
+				scmd->result = (DID_ERROR << 16);
+			}
+		}
+		if (fc_rp->fr_flags & FCP_SNS_LEN_VAL) {
+			snsl = ntohl(rp_ex->fr_sns_len);
+			if (snsl > SCSI_SENSE_BUFFERSIZE)
+				snsl = SCSI_SENSE_BUFFERSIZE;
+			memcpy(scmd->sense_buffer,
+			       &fc_rp_info->_fr_resvd[0] + respl, snsl);
+		}
+		if (fc_rp->fr_flags & FCP_RESID_UNDER) {
+			scsi_resid = ntohl(rp_ex->fr_resid);
+			/*
+			 * The cmnd->underflow is the minimum number of
+			 * bytes that must be transfered for this
+			 * command.  Provided a sense condition is not
+			 * present, make sure the actual amount
+			 * transferred is at least the underflow value
+			 * or fail.
+			 */
+			if (!(fc_rp->fr_flags & FCP_SNS_LEN_VAL) &&
+			    (fc_rp->fr_status == 0) &&
+			    (scsi_bufflen(scmd) -
+			     scsi_resid) < scmd->underflow) {
+				scmd->result = (DID_ERROR << 16);
+			}
+		} else if (fc_rp->fr_flags & FCP_RESID_OVER) {
+			scmd->result = (DID_ERROR << 16);
+		}
+	}
+}
+
+static void mfc_unmap_fmr_sg(struct mfc_dev *mfc_dev,
+			     struct scatterlist *sglist, int nents,
+			     struct mlx4_fmr *fmr, enum dma_data_direction dir)
+{
+	u32 dummy_lkey, dummy_rkey;
+
+	pci_unmap_sg(mfc_dev->dev->pdev, sglist, nents, dir);
+	mlx4_fmr_unmap(mfc_dev->dev, fmr, &dummy_lkey, &dummy_rkey);
+}
+
+static void mfc_destroy_bounce(struct mfc_dev *mfc_dev, struct scsi_cmnd *cmd,
+			       struct mfc_exch *fexch)
+{
+	struct scatterlist *sg;
+	int i;
+	unsigned long total_len;
+	char *page_addr;
+
+	if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
+		total_len = 0;
+		scsi_for_each_sg(cmd, sg, scsi_sg_count(cmd), i) {
+			page_addr = kmap_atomic(sg_page(sg), KM_SOFTIRQ0);
+			memcpy(page_addr + (sg->offset & ~PAGE_MASK),
+			       fexch->bouncebuff + fexch->bounce_off +
+			       total_len, sg->length);
+			kunmap_atomic(page_addr, KM_SOFTIRQ0);
+			total_len += sg->length;
+		}
+	}
+
+	kfree(fexch->bouncebuff);
+	fexch->bouncebuff = NULL;
+}
+
+static void mfc_unmap_fmr(struct mfc_dev *mfc_dev, struct scsi_cmnd *cmd,
+			  struct mfc_exch *fexch)
+{
+	if ((cmd->sc_data_direction == DMA_NONE) ||
+	    (cmd->sc_data_direction == DMA_BIDIRECTIONAL))
+		return;
+
+	if (fexch->bouncebuff) {
+		mfc_unmap_fmr_sg(mfc_dev, &fexch->bounce_sg[0], 1,
+				 &fexch->fmr, cmd->sc_data_direction);
+		mfc_destroy_bounce(mfc_dev, cmd, fexch);
+	} else
+		mfc_unmap_fmr_sg(mfc_dev, scsi_sglist(cmd),
+				 scsi_sg_count(cmd), &fexch->fmr,
+				 cmd->sc_data_direction);
+}
+
+/*
+ * FEXCH completion - pay attention: ethernet header is stripped.
+ */
+static void mfc_exch_rx_comp(struct mfc_vhba *vhba, struct mlx4_cqe *g_cqe)
+{
+	struct mfc_exch_cqe *cqe = (struct mfc_exch_cqe *)g_cqe;
+	struct mfc_exch *fexch;
+	struct mfc_queue *rq;
+	int wqe_idx;
+	struct mfc_rx_desc *rx_desc;
+	int xno;
+	u32 qpn;
+	unsigned long flags;
+	struct fcp_resp *fc_rp;
+	size_t rxcnt;
+	u_int hlen;
+
+	qpn = be32_to_cpu(cqe->my_qpn) & ((1 << 24) - 1);
+	xno = qpn - vhba->base_fexch_qpn;
+	fexch = &vhba->fexch[xno];
+
+	rq = &fexch->fc_qp.rq;
+
+	wqe_idx = be16_to_cpu(cqe->wqe_index) & rq->size_mask;
+	rx_desc = rq->buf + (wqe_idx * rq->stride);
+
+	pci_unmap_single(vhba->mfc_port->mfc_dev->dev->pdev,
+			 be64_to_cpu(rx_desc->data[0].addr),
+			 be32_to_cpu(rx_desc->data[0].count),
+			 PCI_DMA_FROMDEVICE);
+
+	if (fexch->state == FEXCH_ABORT || fexch->state == FEXCH_SEND_ABORT) {
+		fexch->scmd->result = (DID_ABORT << 16);
+		fexch->state = FEXCH_CMD_DONE;
+		if ((g_cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) != 0x1e)
+			complete(&fexch->tm_done);
+		goto out_cons;
+	}
+
+	if ((g_cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) == 0x1e)
+		fexch->scmd->result = (DID_ERROR << 16);
+	else {
+		rxcnt = be32_to_cpu(cqe->rcv_byte_count);
+
+		if (!mfc_t11_mode)
+			hlen = sizeof(struct fcoe_hdr_old);
+		else
+			hlen = sizeof(struct fcoe_hdr);
+
+		fc_rp =
+		    (struct fcp_resp *)(fexch->response_buf + 2 + hlen + 24);
+
+		mfc_rx_fcp_resp(vhba, fc_rp, fexch->scmd, rxcnt,
+				&fexch->fmr, xno);
+	}
+
+	spin_lock_irqsave(fexch->scmd->device->host->host_lock, flags);
+
+	mfc_unmap_fmr(vhba->mfc_port->mfc_dev, fexch->scmd, fexch);
+
+	fexch->scmd->scsi_done(fexch->scmd);
+
+	if (!fexch->fc_qp.is_flushing || vhba->fcmd.fc_qp.is_flushing)
+		mfc_bitmap_slot_free(&vhba->fexch_bm, xno);
+
+	spin_unlock_irqrestore(fexch->scmd->device->host->host_lock, flags);
+
+out_cons:
+	spin_lock_irqsave(&rq->lock, flags);
+	rq->cons++;
+	spin_unlock_irqrestore(&rq->lock, flags);
+}
+
+static void mfc_qp_event(struct mlx4_qp *qp, enum mlx4_event type)
+{
+	printk(KERN_WARNING "qp event for qpn=0x%08x event_type=0x%x\n",
+	       qp->qpn, type);
+}
+
+static int mfc_create_fexch(struct mfc_vhba *vhba, int xno)
+{
+	struct mfc_port *fc_port = vhba->mfc_port;
+	struct mfc_dev *mfc_dev = fc_port->mfc_dev;
+	struct mfc_exch *fexch = &vhba->fexch[xno];
+	struct mfc_qp *qp = &fexch->fc_qp;
+	struct mfc_queue *sq = &qp->sq;
+	struct mfc_queue *rq = &qp->rq;
+	int err = 0;
+
+	fexch->vhba = vhba;
+	mfc_q_init(sq, FEXCH_SQ_BB_SIZE, FEXCH_SQ_NUM_BBS, 0);
+	mfc_q_init(rq, FEXCH_RQ_WQE_SIZE, FEXCH_RQ_NUM_WQES, 0);
+
+	qp->buf_size = (sq->size * sq->stride) + (rq->size * rq->stride);
+
+	err = mlx4_alloc_hwq_res(mfc_dev->dev, &qp->wqres, qp->buf_size,
+				 qp->buf_size);
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"Could not allocate man for FEXCH %d\n", xno);
+		goto err_free_rxinfo;
+	}
+
+	if (FEXCH_SQ_BB_SIZE >= FEXCH_RQ_WQE_SIZE) {
+		sq->buf = qp->wqres.buf.direct.buf;
+		rq->buf = sq->buf + (sq->size * sq->stride);
+	} else {
+		rq->buf = qp->wqres.buf.direct.buf;
+		sq->buf = rq->buf + (rq->size * rq->stride);
+	}
+
+	*qp->wqres.db.db = 0;
+
+	mfc_stamp_q(sq);
+	mfc_stamp_q(rq);
+
+	err = mlx4_qp_alloc(mfc_dev->dev, vhba->base_fexch_qpn + xno, &qp->mqp);
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"Could not allocate QP number 0x%x\n", qp->mqp.qpn);
+		goto err_free_man;
+	}
+
+	qp->doorbell_qpn = swab32(qp->mqp.qpn << 8);
+	qp->mqp.event = mfc_qp_event;
+
+	err = mlx4_fmr_alloc_reserved(mfc_dev->dev, vhba->base_fexch_mpt + xno,
+				      mfc_dev->priv_pdn |
+				      MLX4_MPT_ENABLE_INVALIDATE,
+				      MLX4_PERM_REMOTE_WRITE |
+				      MLX4_PERM_REMOTE_READ,
+				      MFC_MAX_FMR_PAGES, 1,
+				      MFC_FMR_PAGE_SHIFT, &fexch->fmr);
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"Could not allocate FMR for fexch %d, err=%d\n", xno,
+			err);
+		goto err_free_qp;
+	}
+
+	err = mlx4_fmr_enable(mfc_dev->dev, &fexch->fmr);
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"Could not enable FMR for fexch %d, err=%d\n", xno,
+			err);
+		goto err_free_fmr;
+	}
+
+	return 0;
+
+err_free_fmr:
+	mlx4_fmr_free_reserved(mfc_dev->dev, &fexch->fmr);
+err_free_qp:
+	mlx4_qp_remove(mfc_dev->dev, &fexch->fc_qp.mqp);
+	mlx4_qp_free(mfc_dev->dev, &fexch->fc_qp.mqp);
+err_free_man:
+	mlx4_free_hwq_res(mfc_dev->dev, &qp->wqres, qp->buf_size);
+err_free_rxinfo:
+	mfc_q_destroy(rq);
+	return err;
+}
+
+static int wait_for_q_comp(struct mfc_queue *q)
+{
+	unsigned long end;
+	unsigned long flags;
+	int err;
+
+	end = jiffies + 20 * HZ;
+	spin_lock_irqsave(&q->lock, flags);
+	while ((int)(q->prod - q->cons) > 1) {
+		spin_unlock_irqrestore(&q->lock, flags);
+		msleep(1000 / HZ);
+		if (time_after(jiffies, end))
+			break;
+		spin_lock_irqsave(&q->lock, flags);
+	}
+
+	if ((int)(q->prod - q->cons) > 1)
+		err = 1;
+	else
+		err = 0;
+
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return err;
+}
+
+DEFINE_SPINLOCK(cq_poll);
+
+int wait_for_fexch_tx_comp(struct mfc_exch *fexch, struct mfc_cq *cq)
+{
+	int err;
+	unsigned long end;
+	unsigned long flags;
+
+	end = jiffies + 20 * HZ;
+	while (!fexch->tx_completed) {
+		if (spin_trylock_irqsave(&cq_poll, flags)) {
+			mfc_cq_clean(cq);
+			spin_unlock_irqrestore(&cq_poll, flags);
+		}
+
+		msleep(1000 / HZ);
+
+		if (time_after(jiffies, end))
+			break;
+	}
+	if (!fexch->tx_completed)
+		err = 1;
+	else
+		err = 0;
+
+	return err;
+}
+
+int flush_qp(struct mfc_dev *mfc_dev, struct mfc_qp *qp, int is_sq,
+	     int is_rq, struct mfc_cq *cq, struct mfc_exch *fexch)
+{
+	struct mfc_queue *sq = &qp->sq;
+	struct mfc_queue *rq = &qp->rq;
+	unsigned long flags;
+	int err = 0;
+
+	qp->is_flushing = 1;
+
+	err = mlx4_qp_to_error(mfc_dev->dev, &qp->mqp);
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"Error %d bringing QP to error state, qpn=0x%x\n",
+			err, qp->mqp.qpn);
+		return err;
+	}
+
+	/* if sq in use (FCMD, RFCI), wait for sq flush */
+	if (is_sq) {
+		if (cq)
+			if (spin_trylock_irqsave(&cq_poll, flags)) {
+				mfc_cq_clean(cq);
+				spin_unlock_irqrestore(&cq_poll, flags);
+			}
+
+		err = wait_for_q_comp(sq);
+		if (err)
+			dev_err(mfc_dev->dma_dev,
+				"Error %d send q was not flushed after error\n",
+				err);
+	}
+
+	/* if rq in use (FEXCH, RFCI), wait for rq flush */
+	if (is_rq) {
+		if (cq) {
+			if (spin_trylock_irqsave(&cq_poll, flags)) {
+				mfc_cq_clean(cq);
+				spin_unlock_irqrestore(&cq_poll, flags);
+			}
+		}
+		if (fexch && !fexch->tx_completed) {
+			err = wait_for_fexch_tx_comp(fexch, cq);
+			if (err) {
+				dev_err(mfc_dev->dma_dev,
+					"ERROR: %d FCMD TX did not completed\n",
+					err);
+				return err;
+			}
+		}
+
+		err = wait_for_q_comp(rq);
+		if (err)
+			dev_err(mfc_dev->dma_dev,
+				"Error rq was not flushed after error %d\n",
+				err);
+
+	}
+
+	return err;
+}
+
+static int mfc_destroy_fexch(struct mfc_vhba *vhba, int xno)
+{
+	struct mfc_port *fc_port = vhba->mfc_port;
+	struct mfc_dev *mfc_dev = fc_port->mfc_dev;
+	struct mfc_exch *fexch = &vhba->fexch[xno];
+	struct mfc_qp *qp = &fexch->fc_qp;
+	struct mfc_queue *rq = &qp->rq;
+	struct mfc_queue *sq = &qp->sq;
+	int err = 0;
+
+	if (qp->is_created) {
+		err = flush_qp(mfc_dev, qp, 0, 1, &vhba->fcmd.fc_cq, fexch);
+		if (err) {
+			dev_err(mfc_dev->dma_dev,
+				"error flushing fexch qp, try host reset.\n");
+			goto out;
+		}
+	}
+
+	mlx4_fmr_free_reserved(mfc_dev->dev, &fexch->fmr);
+	if (qp->is_created)
+		mlx4_qp_to_reset(mfc_dev->dev, &qp->mqp);
+	qp->is_created = 0;
+	mlx4_qp_remove(mfc_dev->dev, &qp->mqp);
+	mlx4_qp_free(mfc_dev->dev, &qp->mqp);
+	mlx4_free_hwq_res(mfc_dev->dev, &qp->wqres, qp->buf_size);
+	mfc_q_destroy(rq);
+	mfc_q_destroy(sq);
+out:
+	return err;
+}
+
+int mfc_init_fexch(struct mfc_vhba *vhba, int xno)
+{
+	struct mfc_dev *mfc_dev = vhba->mfc_port->mfc_dev;
+	struct mfc_exch *fexch = &vhba->fexch[xno];
+	struct mfc_qp *qp = &fexch->fc_qp;
+	enum mlx4_qp_state qp_state = MLX4_QP_STATE_RST;
+	int err = 0;
+	u8 sched_q = 0;
+	struct mlx4_qp_context context;
+
+	if (vhba->net_type == NET_IB)
+		sched_q = 0x83 |
+		    (vhba->dest_ib_sl & 0xf) << 3 |
+		    (vhba->mfc_port->port - 1) << 6;
+	else if (vhba->net_type == NET_ETH)
+		sched_q = 0x83 |
+		    vhba->fc_vlan_prio << 3 | (vhba->mfc_port->port - 1) << 6;
+
+	context = (struct mlx4_qp_context) {
+		.flags = cpu_to_be32(QPC_SERVICE_TYPE_FEXCH << 16),
+		.pd = cpu_to_be32(mfc_dev->priv_pdn),
+		/* Raw-ETH requirement */
+		.mtu_msgmax = 0x77,
+		/* this means SQ_NUM_BBS=1, and SQ_BB_SIZE=1 */
+		.sq_size_stride = 0,
+		.rq_size_stride = ilog2(FEXCH_RQ_NUM_WQES) << 3 |
+				  ilog2(FEXCH_RQ_WQE_SIZE >> 4),
+		.usr_page = cpu_to_be32(mfc_dev->priv_uar.index),
+		.local_qpn = cpu_to_be32(qp->mqp.qpn),
+		.pri_path.sched_queue = sched_q,
+		.pri_path.counter_index = 0xff,
+		.pri_path.ackto = (vhba->net_type == NET_IB) ?
+			MLX4_LINK_TYPE_IB : MLX4_LINK_TYPE_ETH,
+		/* Source MAC index */
+		.pri_path.grh_mylmc =  (vhba->net_type == NET_IB) ?
+				       0 : vhba->rfci[RFCI_DATA].fc_mac_idx,
+		.params2 = cpu_to_be32((qp->wqres.buf.direct.map &
+					(PAGE_SIZE - 1)) & 0xfc0),
+		.cqn_send =
+		    cpu_to_be32(vhba->fexch_cq[xno % num_online_cpus()].mcq.
+				cqn),
+		.cqn_recv =
+		    cpu_to_be32(vhba->fexch_cq[xno % num_online_cpus()].mcq.
+				cqn),
+		.db_rec_addr = cpu_to_be64(qp->wqres.db.dma),
+		.srqn = 0,
+		.my_fc_id_idx = vhba->idx,
+		.qkey = cpu_to_be32(MLX4_FCOIB_QKEY),
+	};
+
+	fexch->tx_completed = 1;
+	if (vhba->fc_vlan_id != -1) {
+		context.pri_path.fl = 0x40;
+		context.pri_path.vlan_index = vhba->fc_vlan_idx;
+	}
+
+	err = mlx4_qp_to_ready(mfc_dev->dev, &qp->wqres.mtt, &context, &qp->mqp,
+			       &qp_state);
+
+	if (qp_state != MLX4_QP_STATE_RST)
+		qp->is_created = 1;
+
+	if (qp_state != MLX4_QP_STATE_RTS) {
+		dev_err(mfc_dev->dma_dev,
+			"Error bringing FEXCH %d QP to RTS state, qpn=0x%x\n",
+			xno, qp->mqp.qpn);
+		return err;
+	}
+
+	fexch->fc_qp.is_flushing = 0;
+
+	return 0;
+}
+
+int mfc_fill_abort_hdr(struct fc_frame *fp, u32 did, u32 sid,
+		       u16 ox_id, u8 seq_id)
+{
+
+	struct fc_frame_header *fh;
+	u16 fill;
+
+	/* Fill header */
+	fh = fc_frame_header_get(fp);
+	fh->fh_r_ctl = FC_RCTL_BA_ABTS;
+	hton24(fh->fh_d_id, did);
+	hton24(fh->fh_s_id, sid);
+	fh->fh_type = FC_TYPE_BLS;
+	hton24(fh->fh_f_ctl, FC_FC_END_SEQ | FC_FC_SEQ_INIT);
+	fh->fh_cs_ctl = 0;
+	fh->fh_df_ctl = 0;
+	fh->fh_ox_id = htons(ox_id);
+	fh->fh_rx_id = htons(FC_XID_UNKNOWN);
+	fh->fh_seq_id = seq_id;
+	fh->fh_seq_cnt = 0;
+	fh->fh_parm_offset = htonl(0);
+
+	/* Fill SOF and EOF */
+	fr_sof(fp) = FC_SOF_I3;	/* resume class 3 */
+	fr_eof(fp) = FC_EOF_T;
+
+	fill = fr_len(fp) & 3;
+	if (fill) {
+		fill = 4 - fill;
+		/* TODO, this may be a problem with fragmented skb */
+		skb_put(fp_skb(fp), fill);
+		hton24(fh->fh_f_ctl, ntoh24(fh->fh_f_ctl) | fill);
+	}
+
+	return 0;
+}
+
+int mfc_send_abort_tsk(struct mfc_exch *fexch, u32 rport_id)
+{
+	struct fc_frame *fp;
+	struct fc_lport *lp;
+	struct mfc_vhba *vhba = fexch->vhba;
+	int ox_id, err = 0, xno;
+
+	/* check we can use rfci */
+	if (vhba->lp->state != LPORT_ST_READY || fexch->fc_qp.is_flushing)
+		return -EINVAL;
+
+	/* Send abort packet via rfci */
+	xno = fexch - vhba->fexch;
+	ox_id = vhba->base_fexch_qpn + xno - vhba->mfc_port->base_fexch_qpn;
+	lp = vhba->lp;
+	fp = fc_frame_alloc(lp, 0);
+	if (fp) {
+		dev_info(vhba->mfc_port->mfc_dev->dma_dev,
+			 "Sending ABTS for 0x%x fexch\n", xno);
+
+		/* TODO: find out if seq_id = 0 is OK */
+		mfc_fill_abort_hdr(fp, rport_id,
+				   fc_host_port_id(lp->host), ox_id, 0);
+		err = mfc_frame_send(lp, fp);
+	} else {
+		dev_err(vhba->mfc_port->mfc_dev->dma_dev,
+			"Send ABTS for fexch[0x%x] ox_id 0x%x - NOT DONE!\n",
+			xno, ox_id);
+		err = -ENOMEM;
+	}
+
+	return err;
+}
+
+/*
+ * re-init and free fexch bitmap, fexch should be ready for reuse.
+ */
+int mfc_reset_fexch(struct mfc_vhba *vhba, struct mfc_exch *fexch)
+{
+	int err = 0, xno;
+
+	mfc_unmap_fmr(vhba->mfc_port->mfc_dev, fexch->scmd, fexch);
+
+	xno = fexch - vhba->fexch;
+
+	err = mfc_destroy_fexch(vhba, xno);
+	if (err) {
+		dev_err(vhba->mfc_port->mfc_dev->dma_dev,
+			"fail to destroy fexch 0x%x\n", xno);
+		goto out;
+	}
+
+	err = mfc_create_fexch(vhba, xno);
+	if (err) {
+		dev_err(vhba->mfc_port->mfc_dev->dma_dev,
+			"fail to recreate fexch 0x%x\n", xno);
+		goto out;
+	}
+
+	err = mfc_init_fexch(vhba, xno);
+	if (err) {
+		dev_err(vhba->mfc_port->mfc_dev->dma_dev,
+			"fail to init fexch 0x%x\n", xno);
+		mfc_destroy_fexch(vhba, xno);
+		goto out;
+	}
+
+	fexch->state = FEXCH_OK;
+	mfc_bitmap_slot_free(&vhba->fexch_bm, xno);
+out:
+	return err;
+
+}
+
+/*
+ * Attention: This function could be called from interrupt context
+ */
+int mfc_create_fcmd(struct mfc_vhba *vhba)
+{
+	struct mfc_port *fc_port = vhba->mfc_port;
+	struct mfc_dev *mfc_dev = fc_port->mfc_dev;
+	struct mfc_qp *qp = &vhba->fcmd.fc_qp;
+	struct mfc_queue *sq = &qp->sq;
+	struct mfc_queue *rq = &qp->rq;
+	int err = 0;
+	int i, eqidx, cpu;
+
+	err = mfc_q_init(sq, FCMD_SQ_BB_SIZE, vhba->num_fexch,
+			 sizeof(struct fcp_cmnd *));
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"port%d vhba%d: Could not alloc info for fcmd sq\n",
+			fc_port->port, vhba->idx);
+		goto err_out;
+	}
+
+	for (i = 0; i < sq->size; i++) {
+		struct fcp_cmnd *cdb_cmd;
+
+		cdb_cmd = mfc_q_info_get(sq, i, struct fcp_cmnd *) =
+			kmalloc(sizeof(struct fcp_cmnd), GFP_KERNEL);
+		if (!cdb_cmd)
+			goto err_free_txinfo;
+		memset(cdb_cmd, 0, sizeof(*cdb_cmd));
+	}
+
+	err = mfc_q_init(rq, FCMD_RQ_WQE_SIZE, FCMD_RQ_NUM_WQES, 0);
+	if (err) {
+		dev_err(mfc_dev->dma_dev, "Error initializing fcmd rq\n");
+		goto err_free_txinfo;
+	}
+
+	qp->buf_size = (sq->size * sq->stride) + (rq->size * rq->stride);
+
+	err =
+	    mlx4_alloc_hwq_res(mfc_dev->dev, &qp->wqres, qp->buf_size,
+			       qp->buf_size);
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"port%d vhba%d: Could not allocate fcmd, err=%d\n",
+			fc_port->port, vhba->idx, err);
+		goto err_free_txinfo;
+	}
+
+	if (FCMD_SQ_BB_SIZE >= FCMD_RQ_WQE_SIZE) {
+		sq->buf = qp->wqres.buf.direct.buf;
+		rq->buf = sq->buf + (sq->size * sq->stride);
+	} else {
+		rq->buf = qp->wqres.buf.direct.buf;
+		sq->buf = rq->buf + (rq->size * rq->stride);
+	}
+
+	*qp->wqres.db.db = 0;
+
+	mfc_stamp_q(sq);
+	mfc_stamp_q(rq);
+
+	err = mlx4_qp_reserve_range(mfc_dev->dev, 1, 1, &qp->mqp.qpn);
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"port%d vhba%d: Could not resv QPN for fcmd, err=%d\n",
+			fc_port->port, vhba->idx, err);
+		goto err_free_man;
+	}
+
+	err = mlx4_qp_alloc(mfc_dev->dev, qp->mqp.qpn, &qp->mqp);
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"port%d vhba%d: Could not allocate QPN 0x%x\n",
+			fc_port->port, vhba->idx, qp->mqp.qpn);
+		goto err_release_qp;
+	}
+
+	qp->doorbell_qpn = swab32(qp->mqp.qpn << 8);
+	qp->mqp.event = mfc_qp_event;
+
+	err = mfc_create_cq(vhba, &vhba->fcmd.fc_cq, vhba->num_fexch,
+			    MLX4_LEAST_ATTACHED_VECTOR, 0,
+			    NULL, mfc_cmd_tx_comp, "FCMD");
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"port%d vhba%d: Failed creating FCMD CQ, err=%d\n",
+			fc_port->port, vhba->idx, err);
+		goto err_free_qp;
+	}
+
+	/* Create FEXCHs for this FCMD */
+	vhba->fexch = vmalloc(vhba->num_fexch * sizeof(struct mfc_exch));
+	if (!vhba->fexch) {
+		dev_err(mfc_dev->dma_dev,
+			"port%d vhba%d: Error allocating fexch array\n",
+			fc_port->port, vhba->idx);
+		goto err_free_cq;
+
+	}
+	memset(vhba->fexch, 0, vhba->num_fexch * sizeof(struct mfc_exch));
+	for (i = 0; i < vhba->num_fexch; i++) {
+		vhba->fexch[i].response_buf =
+		    kmalloc(MFC_CMD_RX_SKB_BUFSIZE, GFP_KERNEL);
+		if (!vhba->fexch[i].response_buf) {
+			dev_err(mfc_dev->dma_dev,
+				"port%d vhba%d fexch %d: Error allocating\n",
+				fc_port->port, vhba->idx, i);
+			goto err_free_fexch_arr;
+		}
+	}
+
+	err = mfc_bitmap_alloc(&vhba->fexch_bm, vhba->num_fexch);
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"port%d vhba%d: Error allocating fexch bitmap for\n",
+			fc_port->port, vhba->idx);
+		goto err_free_fexch_arr;
+	}
+
+	for (i = 0; i < mfc_num_reserved_xids; ++i)
+		set_bit(i, vhba->fexch_bm.addr);
+
+	vhba->base_reserved_xid =
+	    vhba->base_fexch_qpn - fc_port->base_fexch_qpn;
+	vhba->num_reserved_xid = mfc_num_reserved_xids;
+
+	eqidx = 0;
+	for_each_online_cpu(cpu) {
+		err = mfc_create_cq(vhba, &vhba->fexch_cq[eqidx],
+				    vhba->num_fexch / num_online_cpus(),
+				    (eqidx % num_online_cpus()) %
+				     mfc_dev->dev->caps.num_comp_vectors,
+				     1, mfc_exch_rx_comp, NULL, "FEXCH");
+		if (err) {
+			dev_err(mfc_dev->dma_dev,
+				"port%d vhba%d: Failed creating CQ %d err=%d\n",
+				fc_port->port, vhba->idx, eqidx, err);
+			goto err_destroy_fexch_cq;
+		}
+
+		++eqidx;
+	}
+
+	for (i = 0; i < vhba->num_fexch; i++) {
+		err = mfc_create_fexch(vhba, i);
+		if (err) {
+			dev_err(mfc_dev->dma_dev,
+				"Fail to create FEXCH %d err=%d\n", i, err);
+			goto err_destroy_fexch;
+		}
+	}
+
+	return 0;
+
+err_destroy_fexch:
+	while (--i >= 0)
+		mfc_destroy_fexch(vhba, i);
+err_destroy_fexch_cq:
+	while (--eqidx >= 0)
+		mfc_destroy_cq(&vhba->fexch_cq[eqidx]);
+	mfc_bitmap_free(&vhba->fexch_bm);
+err_free_fexch_arr:
+	for (i = 0; i < vhba->num_fexch; i++) {
+		if (!vhba->fexch[i].response_buf)
+			break;
+		kfree(vhba->fexch[i].response_buf);
+	}
+	vfree(vhba->fexch);
+err_free_cq:
+	mfc_destroy_cq(&vhba->fcmd.fc_cq);
+err_free_qp:
+	mlx4_qp_remove(mfc_dev->dev, &qp->mqp);
+	mlx4_qp_free(mfc_dev->dev, &qp->mqp);
+err_release_qp:
+	mlx4_qp_release_range(mfc_dev->dev, qp->mqp.qpn, 1);
+err_free_man:
+	mlx4_free_hwq_res(mfc_dev->dev, &qp->wqres, qp->buf_size);
+err_free_txinfo:
+	for (i = 0; i < sq->size; i++) {
+		if (!mfc_q_info_get(sq, i, struct fcp_cmnd *))
+			break;
+		kfree(mfc_q_info_get(sq, i, struct fcp_cmnd *));
+	}
+	mfc_q_destroy(sq);
+err_out:
+	return err;
+}
+
+void mfc_destroy_fcmd(struct mfc_vhba *vhba)
+{
+	struct mfc_port *fc_port = vhba->mfc_port;
+	struct mfc_dev *mfc_dev = fc_port->mfc_dev;
+	struct mfc_qp *qp = &vhba->fcmd.fc_qp;
+	struct mfc_queue *sq = &qp->sq;
+	struct mfc_queue *rq = &qp->rq;
+	int err = 0;
+	int i;
+
+	if (qp->is_created) {
+		err = flush_qp(mfc_dev, qp, 1, 0, &vhba->fcmd.fc_cq, 0);
+		if (err)
+			dev_err(mfc_dev->dma_dev,
+				"Error flushing FCMD qp err=%d\n", err);
+
+	}
+
+	for (i = 0; i < vhba->num_fexch; ++i)
+		mfc_destroy_fexch(vhba, i);
+
+	for (i = 0; i < num_online_cpus(); ++i)
+		mfc_destroy_cq(&vhba->fexch_cq[i]);
+
+	for (i = 0; i < vhba->num_reserved_xid; ++i)
+		clear_bit(i, vhba->fexch_bm.addr);
+
+	if (!mfc_bitmap_empty(&vhba->fexch_bm))
+		dev_warn(mfc_dev->dma_dev,
+			 "uncompleted exchanges while destroying FCMD: %s\n",
+			 mfc_bitmap_print(&vhba->fexch_bm));
+
+	mfc_bitmap_free(&vhba->fexch_bm);
+
+	for (i = 0; i < vhba->num_fexch; i++) {
+		if (!vhba->fexch[i].response_buf)
+			break;
+		kfree(vhba->fexch[i].response_buf);
+	}
+	vfree(vhba->fexch);
+
+	mfc_destroy_cq(&vhba->fcmd.fc_cq);
+	if (qp->is_created)
+		mlx4_qp_to_reset(mfc_dev->dev, &qp->mqp);
+	qp->is_created = 0;
+	mlx4_qp_remove(mfc_dev->dev, &qp->mqp);
+	mlx4_qp_free(mfc_dev->dev, &qp->mqp);
+	mlx4_qp_release_range(mfc_dev->dev, vhba->fcmd.fc_qp.mqp.qpn, 1);
+	mlx4_free_hwq_res(mfc_dev->dev, &qp->wqres, qp->buf_size);
+
+	for (i = 0; i < sq->size; i++) {
+		if (!mfc_q_info_get(sq, i, struct fcp_cmnd *))
+			break;
+		kfree(mfc_q_info_get(sq, i, struct fcp_cmnd *));
+	}
+	mfc_q_destroy(sq);
+	mfc_q_destroy(rq);
+}
+
+int mfc_reset_fcmd(struct mfc_vhba *vhba)
+{
+	int err = 0;
+
+	mfc_destroy_fcmd(vhba);
+	err = mfc_create_fcmd(vhba);
+	if (err)
+		dev_err(vhba->mfc_port->mfc_dev->dma_dev,
+			"FAIL to create FCMD err=%d\n", err);
+
+	return err;
+}
+
+int mfc_init_fcmd(struct mfc_vhba *vhba)
+{
+	struct mfc_dev *mfc_dev = vhba->mfc_port->mfc_dev;
+	struct mfc_qp *qp = &vhba->fcmd.fc_qp;
+	enum mlx4_qp_state qp_state = MLX4_QP_STATE_RST;
+	int rc = 0;
+	int i;
+	u8 sched_q = 0;
+	struct mlx4_qp_context context;
+
+	if (vhba->net_type == NET_IB)
+		sched_q = 0x83 |
+		    (vhba->dest_ib_sl & 0xf) << 3 |
+		    (vhba->mfc_port->port - 1) << 6;
+	else if (vhba->net_type == NET_ETH)
+		sched_q = 0x83 |
+		    vhba->fc_vlan_prio << 3 | (vhba->mfc_port->port - 1) << 6;
+
+	context = (struct mlx4_qp_context) {
+		.flags = cpu_to_be32(QPC_SERVICE_TYPE_FCMD << 16),
+		.pd = cpu_to_be32(mfc_dev->priv_pdn),
+		.mtu_msgmax = 0x77,
+		.sq_size_stride =
+		    ilog2(vhba->
+			  num_fexch) << 3 | ilog2(FCMD_SQ_BB_SIZE >> 4) |
+		    SQ_NO_PREFETCH,
+		/* this means RQ_NUM_WQES=1, and RQ_WQE_SIZE=1 */
+		.rq_size_stride = 0,
+		.usr_page = cpu_to_be32(mfc_dev->priv_uar.index),
+		.local_qpn = cpu_to_be32(qp->mqp.qpn),
+		.pri_path.sched_queue = sched_q,
+		.pri_path.counter_index = 0xff,
+		.pri_path.ackto =  (vhba->net_type == NET_IB) ?
+			MLX4_LINK_TYPE_IB : MLX4_LINK_TYPE_ETH,
+		.pri_path.grh_mylmc =  (vhba->net_type == NET_IB) ?
+				       0 : vhba->rfci[RFCI_DATA].fc_mac_idx,
+		.params2 =
+		    cpu_to_be32((qp->wqres.buf.direct.
+				 map & (PAGE_SIZE - 1)) & 0xfc0),
+		.cqn_send = cpu_to_be32(vhba->fcmd.fc_cq.mcq.cqn),
+		.cqn_recv = cpu_to_be32(vhba->fcmd.fc_cq.mcq.cqn),
+		.db_rec_addr = cpu_to_be64(qp->wqres.db.dma),
+		.srqn = 0,
+		.VE = 0,
+		.exch_base = cpu_to_be16(vhba->base_fexch_qpn),
+		.exch_size = ilog2(vhba->num_fexch),
+		.my_fc_id_idx = vhba->idx,
+		.qkey = cpu_to_be32(MLX4_FCOIB_QKEY),
+	};
+
+	if (vhba->fc_vlan_id != -1) {
+		context.pri_path.fl = 0x40;
+		context.pri_path.vlan_index = vhba->fc_vlan_idx;
+	}
+
+	rc = mlx4_qp_to_ready(mfc_dev->dev, &qp->wqres.mtt, &context, &qp->mqp,
+			      &qp_state);
+	if (rc) {
+		dev_err(mfc_dev->dma_dev,
+			"Fail to bring FCMD QP to ready rc=%d\n", rc);
+		goto out;
+	}
+
+	if (qp_state != MLX4_QP_STATE_RST)
+		qp->is_created = 1;
+
+	if (qp_state != MLX4_QP_STATE_RTS) {
+		dev_err(mfc_dev->dma_dev,
+			"Error bringing FCMD QP to RTS state\n");
+		rc = -EINVAL;
+		goto out;
+	}
+
+	/* bring FEXCHs to ready state */
+	for (i = 0; i < vhba->num_fexch; i++) {
+		rc = mfc_init_fexch(vhba, i);
+		if (rc) {
+			dev_err(mfc_dev->dma_dev,
+				"Failed init of FEXCH %d for vhba, err=%d\n",
+				i, rc);
+			goto out;
+		}
+	}
+	qp->is_flushing = 0;
+out:
+	return rc;
+}
+
+static inline void set_ctrl_seg(struct mfc_ctrl_seg *ctrl, int size,
+				u8 seqid, u8 info, u8 ls, u32 task_retry_id)
+{
+	ctrl->size = cpu_to_be16(((size / 16) & 0x3f) | (1 << 7));
+	ctrl->flags = cpu_to_be32(MFC_BIT_TX_COMP |	/* request completion */
+				  (seqid << 24) | (info << 20) | (ls << 16));
+	ctrl->parameter = cpu_to_be32(task_retry_id);
+}
+
+static inline int prepare_fexch(struct mfc_vhba *vhba, struct scsi_cmnd *scmd)
+{
+	struct mfc_exch *fexch;
+	struct mfc_dev *mfc_dev = vhba->mfc_port->mfc_dev;
+	int fexch_idx;
+	int rc = 0;
+	int index;
+
+	fexch_idx = mfc_bitmap_slot_alloc(&vhba->fexch_bm, 0);
+	if (fexch_idx == -1) {
+		dev_err(mfc_dev->dma_dev, "No free FEXCH\n");
+		rc = -ENOMEM;
+		goto err_out;
+	}
+
+	fexch = &vhba->fexch[fexch_idx];
+
+	if (fexch->state == FEXCH_ABORT)
+		dev_err(mfc_dev->dma_dev,
+			"ERROR: Trying to send new FCMD on aborting FEXCH\n");
+
+	fexch->state = FEXCH_OK;
+	fexch->tx_completed = 0;
+	rc = mfc_map_fmr(mfc_dev, scmd, fexch);
+	if (rc) {
+		dev_err(mfc_dev->dma_dev,
+			"Could not map SCSI sg to MFR exch no %d, err=%d, cmd"
+			" bufflen=%d, num_sg=%d, fmr_pagesize=%d, pages=%d\n",
+			fexch_idx, rc, scsi_bufflen(scmd),
+			scsi_sg_count(scmd), (1 << fexch->fmr.page_shift),
+			fexch->fmr.max_pages);
+		mfc_bitmap_slot_free(&vhba->fexch_bm, fexch_idx);
+		goto err_out;
+	}
+
+	index = mfc_post_rx_buf(mfc_dev, &fexch->fc_qp, fexch->response_buf,
+				MFC_CMD_RX_SKB_BUFSIZE);
+	if (index < 0) {
+		mfc_bitmap_slot_free(&vhba->fexch_bm, fexch_idx);
+		rc = -ENOMEM;
+		goto err_out;
+	}
+
+	scmd->SCp.ptr = (char *)fexch;
+	fexch->scmd = scmd;
+
+	mfc_ring_db_rx(&fexch->fc_qp);
+
+	return fexch_idx;
+err_out:
+	return rc;
+}
+
+static inline void set_init_seg(struct mfc_init_seg *init, int frame_size,
+				u32 remote_fid,
+				enum dma_data_direction data_dir, int fexch_idx)
+{
+	init->pe = 0;		/* priority enable, goes to F_CTL[17] */
+	init->cs_ctl = 0;	/* CS_CTL/Priority field */
+	init->seq_id_tx = 0;	/* seq. id to be used in FCP_DATA frames */
+	init->mtu = cpu_to_be16(frame_size / 4);
+	init->remote_fid[2] = (remote_fid) & 0xff;
+	init->remote_fid[1] = (remote_fid >> 8) & 0xff;
+	init->remote_fid[0] = (remote_fid >> 16) & 0xff;
+
+	init->flags = (1 << 1) |
+		      (scsi_dir_translate(data_dir) << 3) | (0x0 << 6);
+
+	/* initiators never know remote exch no. at beginning of exch */
+	init->remote_exch = cpu_to_be16(0xffff);
+	/* alloc free exchange, put index here */
+	init->local_exch_idx = cpu_to_be16(fexch_idx);
+}
+
+static inline void set_eth_dgram_seg(struct mfc_eth_addr_seg *addr, u8 * dmac)
+{
+	addr->static_rate = 0;
+	memcpy(&addr->dmac, dmac, ETH_ALEN);
+}
+
+static inline void set_ib_dgram_seg(struct mfc_datagram_seg *dgram,
+				    int dest_lid, int dest_sl,
+				    unsigned long dest_qpn)
+{
+	dgram->mlid_grh = 0;	/* no GRH */
+	dgram->rlid = cpu_to_be16(dest_lid);	/* remote LID */
+	dgram->stat_rate = 0;	/* no rate limit */
+	dgram->sl_tclass_flabel = cpu_to_be32(dest_sl << 28);
+	dgram->dqpn = cpu_to_be32(dest_qpn);
+}
+
+int mfc_queuecommand(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd *))
+{
+	struct fc_lport *lp;
+	struct mfc_vhba *vhba;
+	struct mfc_dev *mfc_dev;
+	struct mlx4_dev *mdev;
+	struct mfc_queue *sq;
+	int fexch_idx;
+	struct fc_rport *rport;
+	struct mfc_data_seg *data = NULL;
+	struct mfc_ctrl_seg *ctrl = NULL;
+	struct mfc_init_seg *init = NULL;
+	dma_addr_t dma;
+	struct fcp_cmnd *cdb_cmd;
+	u32 index, prod;
+	__be32 op_own;
+	unsigned long flags;
+	int rc;
+
+	lp = shost_priv(scmd->device->host);
+	vhba = lport_priv(lp);
+
+	rport = starget_to_rport(scsi_target(scmd->device));
+	rc = fc_remote_port_chkready(rport);
+	if (rc) {
+		scmd->result = rc;
+		done(scmd);
+		return 0;
+	}
+
+	if (vhba->fcmd.fc_qp.is_flushing) {
+		scmd->result = DID_BUS_BUSY << 16;
+		done(scmd);
+		return 0;
+	}
+
+	if (!*(struct fc_remote_port **)rport->dd_data) {
+		/*
+		 * rport is transitioning from blocked/deleted to
+		 * online
+		 */
+		dev_err(vhba->mfc_port->mfc_dev->dma_dev,
+			"rport %x in transitioning to online\n",
+			rport->port_id);
+		scmd->result = DID_IMM_RETRY << 16;
+		done(scmd);
+		return 0;
+	}
+
+	if ((lp->state != LPORT_ST_READY) || lp->qfull || !lp->link_up) {
+		dev_err(vhba->mfc_port->mfc_dev->dma_dev,
+			"lport state=%d qfull=%d link_up=%d\n",
+			lp->state, lp->qfull, lp->link_up);
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+
+	scmd->scsi_done = done;
+	scmd->result = DID_OK << 16;
+
+	mfc_dev = vhba->mfc_port->mfc_dev;
+	mdev = mfc_dev->dev;
+	sq = &vhba->fcmd.fc_qp.sq;
+
+	if (spin_trylock_irqsave(&cq_poll, flags)) {
+		mfc_cq_clean(&vhba->fcmd.fc_cq);
+		spin_unlock_irqrestore(&cq_poll, flags);
+	}
+
+	/* Check available SQ BBs + 1 spare SQ BB for owenership */
+	spin_lock_irqsave(&sq->lock, flags);
+	if (unlikely((u32) (sq->prod - sq->cons - 1) > sq->size - 2)) {
+		spin_unlock_irqrestore(&sq->lock, flags);
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+	spin_unlock_irqrestore(&sq->lock, flags);
+
+	/* allocate and prepare FEXCH for command */
+	fexch_idx = prepare_fexch(vhba, scmd);
+	if (fexch_idx < 0)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
+	spin_lock_irqsave(&sq->lock, flags);
+	prod = sq->prod;
+	++sq->prod;
+	spin_unlock_irqrestore(&sq->lock, flags);
+
+	index = prod & sq->size_mask;
+	cdb_cmd = mfc_q_info_get(sq, index, struct fcp_cmnd *);
+
+	vhba->fexch[fexch_idx].fcmd_wqe_idx = index;
+	vhba->fexch[fexch_idx].mtu = rport->maxframe_size / 4;
+
+	if (vhba->net_type == NET_IB) {
+		struct mfcoib_cmd_tx_desc *tx_desc;
+
+		tx_desc = sq->buf + index * FCMD_SQ_BB_SIZE;
+		ctrl = &tx_desc->ctrl;
+		init = &tx_desc->init;
+		data = &tx_desc->data;
+		set_ctrl_seg(ctrl, sizeof(struct mfcoib_cmd_tx_desc),
+			     0, 6, 0, 0);
+		set_ib_dgram_seg(&tx_desc->addr, vhba->dest_ib_lid,
+				 vhba->dest_ib_sl, vhba->dest_ib_data_qpn);
+	} else if (vhba->net_type == NET_ETH) {
+		struct mfcoe_cmd_tx_desc *tx_desc;
+
+		tx_desc = sq->buf + index * FCMD_SQ_BB_SIZE;
+		ctrl = &tx_desc->ctrl;
+		init = &tx_desc->init;
+		data = &tx_desc->data;
+		set_ctrl_seg(ctrl, sizeof(struct mfcoe_cmd_tx_desc),
+			     0, 6, 0, 0);
+		set_eth_dgram_seg(&tx_desc->addr, vhba->dest_addr);
+	}
+
+	set_init_seg(init, rport->maxframe_size, rport->port_id,
+		     scmd->sc_data_direction, fexch_idx);
+
+	/* prepare cdb command in buffer */
+	if (scmd->sc_data_direction == DMA_FROM_DEVICE)
+		cdb_cmd->fc_flags = FCP_CFL_RDDATA;
+	else if (scmd->sc_data_direction == DMA_TO_DEVICE)
+		cdb_cmd->fc_flags = FCP_CFL_WRDATA;
+	else
+		cdb_cmd->fc_flags = 0;
+
+	cdb_cmd->fc_dl = htonl(scsi_bufflen(scmd));
+	cdb_cmd->fc_flags &= ~FCP_CFL_LEN_MASK;
+	int_to_scsilun(scmd->device->lun, (struct scsi_lun *)cdb_cmd->fc_lun);
+
+	memcpy(cdb_cmd->fc_cdb, scmd->cmnd, scmd->cmd_len);
+
+	/* set data segment */
+	dma = pci_map_single(mfc_dev->dev->pdev, cdb_cmd, sizeof(*cdb_cmd),
+			     PCI_DMA_TODEVICE);
+	if (pci_dma_mapping_error(mfc_dev->dev->pdev, dma))
+		return SCSI_MLQUEUE_HOST_BUSY;
+
+	data->addr = cpu_to_be64(dma);
+	data->count = cpu_to_be32(sizeof(*cdb_cmd));
+	data->mem_type = cpu_to_be32(mfc_dev->mr.key);	/* always snoop */
+
+	op_own = cpu_to_be32(MFC_CMD_OP_SEND) |
+	    ((prod & sq->size) ? cpu_to_be32(MFC_BIT_DESC_OWN) : 0);
+
+	/*
+	 * Ensure new descirptor (and ownership of next descirptor) hits memory
+	 * before setting ownership of this descriptor to HW
+	 */
+	wmb();
+	ctrl->op_own = op_own;
+
+	/* Ring doorbell! */
+	wmb();
+	writel(vhba->fcmd.fc_qp.doorbell_qpn,
+	       mfc_dev->uar_map + MLX4_SEND_DOORBELL);
+
+	return 0;
+}
diff --git a/drivers/scsi/mlx4_fc/mfc_rfci.c b/drivers/scsi/mlx4_fc/mfc_rfci.c
new file mode 100644
index 0000000..111ceb4
--- /dev/null
+++ b/drivers/scsi/mlx4_fc/mfc_rfci.c
@@ -0,0 +1,1001 @@
+/*
+ * Copyright (c) 2010 Mellanox Technologies. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/etherdevice.h>
+
+#include <linux/mlx4/driver.h>
+#include <linux/mlx4/cmd.h>
+#include <linux/mlx4/qp.h>
+#include <linux/mlx4/cq.h>
+
+#include <scsi/libfc.h>
+#include <scsi/fc_encode.h>
+
+#include "mfc.h"
+
+#define MLX4_CQE_QPN_MASK 0x00ffffff
+
+u8 fc_fid_flogi[] = { 0xff, 0xff, 0xfe };
+
+static void mfc_rx_rfci(struct work_struct *work);
+
+static int mfc_prepare_rx_buf(struct mfc_vhba *vhba, struct mfc_rfci *rfci)
+{
+	struct mfc_queue *rq = &rfci->fc_qp.rq;
+	struct sk_buff *skb;
+	struct mfc_rfci_rx_info *fr;
+	int index, rc = 0;
+
+	skb = dev_alloc_skb(MFC_RFCI_RX_SKB_BUFSIZE +
+			    sizeof(struct mfc_rfci_rx_info));
+	if (!skb) {
+		dev_err(vhba->mfc_port->mfc_dev->dma_dev,
+			"No skb - rx packet dropped\n");
+		rc = -ENOMEM;
+		goto err_out;
+	}
+
+	skb_reserve(skb, sizeof(struct mfc_rfci_rx_info));
+
+	fr = (struct mfc_rfci_rx_info *)skb->head;
+	fr->vhba = vhba;
+	fr->skb = skb;
+
+	index = mfc_post_rx_buf(vhba->mfc_port->mfc_dev, &rfci->fc_qp,
+				skb->data, MFC_RFCI_RX_SKB_BUFSIZE);
+	if (index < 0) {
+		rc = index;
+		goto err_out;
+	}
+
+	mfc_q_info_get(rq, index, struct sk_buff *) = skb;
+
+err_out:
+	return rc;
+}
+
+static void mfc_rfci_unpost_rx_bufs(struct mfc_dev *mfc_dev,
+				    struct mfc_queue *rq)
+{
+	int i;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rq->lock, flags);
+	for (i = 0; i < rq->size; i++) {
+		struct sk_buff *skb;
+
+		skb = mfc_q_info_get(rq, i, struct sk_buff *);
+		if (!skb)
+			continue;
+
+		mfc_q_info_get(rq, i, struct sk_buff *) = NULL;
+
+		kfree_skb(skb);
+	}
+	spin_unlock_irqrestore(&rq->lock, flags);
+}
+
+static struct mfc_rfci *rfci_by_qpn(struct mfc_vhba *vhba, int qpn)
+{
+	int i;
+
+	for (i = 0; (i < RFCI_NUM) && (vhba->rfci[i].fc_qp.mqp.qpn != qpn); i++)
+		;
+	return &vhba->rfci[i];
+}
+
+static void mfc_rfci_tx_comp(struct mfc_vhba *vhba, struct mlx4_cqe *cqe)
+{
+	struct mfc_rfci *rfci;
+	struct mfc_queue *sq;
+	struct sk_buff *skb;
+	u32 index;
+	unsigned long flags;
+	u64 dma = 0;
+	u32 count = 0;
+
+	rfci = rfci_by_qpn(vhba,
+			   be32_to_cpu(cqe->vlan_my_qpn) & MLX4_CQE_QPN_MASK);
+
+	sq = &rfci->fc_qp.sq;
+	index = be16_to_cpu(cqe->wqe_index) & sq->size_mask;
+
+	if (vhba->net_type == NET_IB) {
+		struct mfcoib_rfci_tx_desc *tx_desc;
+
+		tx_desc = sq->buf + index * RFCI_SQ_BB_SIZE;
+		dma = be64_to_cpu(tx_desc->data.addr);
+		count = be32_to_cpu(tx_desc->data.count);
+	} else if (vhba->net_type == NET_ETH) {
+		struct mfcoe_rfci_tx_desc *tx_desc;
+
+		tx_desc = sq->buf + index * RFCI_SQ_BB_SIZE;
+		dma = be64_to_cpu(tx_desc->data.addr);
+		count = be32_to_cpu(tx_desc->data.count);
+	}
+
+	pci_unmap_single(vhba->mfc_port->mfc_dev->dev->pdev,
+			 dma, count, PCI_DMA_TODEVICE);
+
+	skb = mfc_q_info_get(sq, index, struct sk_buff *);
+	mfc_q_info_get(sq, index, struct sk_buff *) = NULL;
+	kfree_skb(skb);
+
+	spin_lock_irqsave(&sq->lock, flags);
+	++sq->cons;
+	spin_unlock_irqrestore(&sq->lock, flags);
+}
+
+static void mfc_rfci_rx_comp(struct mfc_vhba *vhba, struct mlx4_cqe *cqe)
+{
+	struct mfc_rfci *rfci;
+	struct mfc_queue *rq;
+	struct mfc_rx_desc *rx_desc;
+	u32 index;
+	int len;
+	unsigned long flags;
+	struct sk_buff *skb;
+	struct mfc_rfci_rx_info *fr;
+	int err;
+
+	rfci = rfci_by_qpn(vhba,
+			   be32_to_cpu(cqe->vlan_my_qpn) & MLX4_CQE_QPN_MASK);
+
+	rq = &rfci->fc_qp.rq;
+	index = be16_to_cpu(cqe->wqe_index) & rq->size_mask;
+	rx_desc = rq->buf + (index * rq->stride);
+	pci_unmap_single(vhba->mfc_port->mfc_dev->dev->pdev,
+			 be64_to_cpu(rx_desc->data[0].addr),
+			 be32_to_cpu(rx_desc->data[0].count),
+			 PCI_DMA_FROMDEVICE);
+
+	spin_lock_irqsave(&rq->lock, flags);
+	rfci->fc_qp.rq.cons++;
+	spin_unlock_irqrestore(&rq->lock, flags);
+
+	skb = mfc_q_info_get(rq, index, struct sk_buff *);
+	if (!skb) {
+		if ((cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) == 0x1e)
+			dev_info(vhba->mfc_port->mfc_dev->dma_dev,
+				 "skb, RFCI Error completion, rfci qpn 0x%x\n",
+				 rfci->fc_qp.mqp.qpn);
+		goto out;
+	}
+
+	mfc_q_info_get(rq, index, struct sk_buff *) = NULL;
+
+	if (vhba->lp->state == LPORT_ST_RESET ||
+	    vhba->lp->state == LPORT_ST_DISABLED || rfci->fc_qp.is_flushing)
+		goto out;
+
+	if (!vhba->rfci_rx_enabled) {
+		dev_info(vhba->mfc_port->mfc_dev->dma_dev,
+			 "RFCI RX ignored till host started, rx_enabled = %d\n",
+			 vhba->rfci_rx_enabled);
+
+		err = mfc_prepare_rx_buf(vhba, rfci);
+		if (err) {
+			dev_err(vhba->mfc_port->mfc_dev->dma_dev,
+				"No mem - rx packet dropped\n");
+			goto free_skb;
+		}
+
+		mfc_ring_db_rx(&rfci->fc_qp);
+		goto free_skb;
+	}
+
+	len = be32_to_cpu(cqe->byte_cnt);
+	fr = (struct mfc_rfci_rx_info *)skb->head;
+
+	skb_put(skb, len);
+	skb_set_mac_header(skb, 0);
+
+	if (vhba->net_type == NET_IB)
+		skb_pull(skb, 0x2a);	/* 40 byte GRH, 2 byte reserved */
+	else if (vhba->net_type == NET_ETH)
+		skb_pull(skb, ETH_HLEN);
+
+	INIT_WORK(&fr->work, mfc_rx_rfci);
+	queue_work(vhba->mfc_port->rfci_wq, &fr->work);
+
+	err = mfc_prepare_rx_buf(vhba, rfci);
+	if (err)
+		goto free_skb;
+
+	mfc_ring_db_rx(&rfci->fc_qp);
+
+	goto out;
+
+free_skb:
+	if (skb)
+		kfree_skb(skb);
+out:
+	return;
+}
+
+int mfc_create_rfci(struct mfc_vhba *vhba, struct mfc_rfci *rfci, u64 mac)
+{
+	struct mfc_port *fc_port = vhba->mfc_port;
+	struct mfc_dev *mfc_dev = fc_port->mfc_dev;
+	struct mfc_qp *qp = &rfci->fc_qp;
+	struct mfc_queue *sq = &qp->sq;
+	struct mfc_queue *rq = &qp->rq;
+	u32 qpn = 0;
+	int err = 0;
+	int i;
+
+	if (vhba->net_type == NET_ETH) {
+		dev_info(mfc_dev->dma_dev, "create RFCI for mac 0x%llx\n", mac);
+
+		err = mlx4_register_mac(mfc_dev->dev, fc_port->port, mac,
+					&rfci->fc_mac_idx);
+		if (err) {
+			dev_err(mfc_dev->dma_dev,
+				"Could not register mac 0x%llx\n", mac);
+			goto err_out;
+		}
+	}
+
+	err = mfc_q_init(sq, RFCI_SQ_BB_SIZE, mfc_num_reserved_xids,
+			 sizeof(struct sk_buff *));
+	if (err) {
+		dev_err(mfc_dev->dma_dev, "Error initializing rfci sq\n");
+		goto err_unreg_mac;
+	}
+
+	err = mfc_q_init(rq, RFCI_RQ_WQE_SIZE, mfc_num_reserved_xids,
+			 sizeof(struct sk_buff *));
+	if (err) {
+		dev_err(mfc_dev->dma_dev, "Error initializing rfci rq\n");
+		err = -ENOMEM;
+		goto err_free_txinfo;
+	}
+
+	qp->buf_size = (sq->size * sq->stride) + (rq->size * rq->stride);
+
+	err = mlx4_alloc_hwq_res(mfc_dev->dev, &qp->wqres, qp->buf_size,
+				 qp->buf_size);
+	if (err)
+		goto err_free_rxinfo;
+
+	if (RFCI_SQ_BB_SIZE >= RFCI_RQ_WQE_SIZE) {
+		sq->buf = qp->wqres.buf.direct.buf;
+		rq->buf = sq->buf + (sq->size * sq->stride);
+	} else {
+		rq->buf = qp->wqres.buf.direct.buf;
+		sq->buf = rq->buf + (rq->size * rq->stride);
+	}
+
+	*qp->wqres.db.db = 0;
+
+	mfc_stamp_q(sq);
+	mfc_stamp_q(rq);
+
+	if (vhba->net_type == NET_IB)
+		qpn = fc_port->base_rfci_qpn + vhba->idx;
+	else if (vhba->net_type == NET_ETH) {
+		qpn = fc_port->base_rfci_qpn |
+		    (rfci->fc_mac_idx << (fc_port->n_v + fc_port->n_p));
+		if (vhba->fc_vlan_id != -1 && fc_port->n_v)
+			qpn |= (vhba->fc_vlan_idx << fc_port->n_p);
+	}
+
+	err = mlx4_qp_alloc(mfc_dev->dev, qpn, &rfci->fc_qp.mqp);
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"Could not allocate QP number 0x%x\n", qpn);
+		goto err_free_man;
+	}
+
+	qp->doorbell_qpn = swab32(qp->mqp.qpn << 8);
+
+	err = mfc_create_cq(vhba, &rfci->fc_cq, 2 * mfc_num_reserved_xids,
+			    0, 1, mfc_rfci_rx_comp, mfc_rfci_tx_comp, "RFCI");
+	if (err) {
+		dev_err(mfc_dev->dma_dev,
+			"Failed creating RFCI CQ for port %d, err=%d\n",
+			fc_port->port, err);
+		goto err_free_qp;
+	}
+
+	for (i = 0; i < rq->size - 1; i++) {
+		err = mfc_prepare_rx_buf(vhba, rfci);
+		if (err) {
+			dev_err(mfc_dev->dma_dev,
+				"Failed preparing RFCI RX desc[%d]\n", i);
+			goto err_free_cq;
+		}
+	}
+
+	mfc_ring_db_rx(&rfci->fc_qp);
+
+	return 0;
+
+err_free_cq:
+	mfc_rfci_unpost_rx_bufs(mfc_dev, &rfci->fc_qp.rq);
+	mfc_destroy_cq(&rfci->fc_cq);
+err_free_qp:
+	mlx4_qp_remove(mfc_dev->dev, &qp->mqp);
+	mlx4_qp_free(mfc_dev->dev, &qp->mqp);
+err_free_man:
+	mlx4_free_hwq_res(mfc_dev->dev, &qp->wqres, qp->buf_size);
+err_free_rxinfo:
+	mfc_q_destroy(rq);
+err_free_txinfo:
+	mfc_q_destroy(sq);
+err_unreg_mac:
+	/* TODO: IB case */
+	if (vhba->net_type == NET_ETH)
+		mlx4_unregister_mac(mfc_dev->dev, fc_port->port,
+				    rfci->fc_mac_idx);
+err_out:
+	return err;
+}
+
+int mfc_destroy_rfci(struct mfc_vhba *vhba, struct mfc_rfci *rfci)
+{
+	struct mfc_port *fc_port = vhba->mfc_port;
+	struct mfc_dev *mfc_dev = fc_port->mfc_dev;
+	struct mfc_qp *qp = &rfci->fc_qp;
+	struct mfc_queue *sq = &qp->sq;
+	struct mfc_queue *rq = &qp->rq;
+	int err;
+
+	if (qp->is_created) {
+		err = flush_qp(mfc_dev, qp, 1, 1, &rfci->fc_cq, NULL);
+		if (err) {
+			dev_err(mfc_dev->dma_dev,
+				"Error flushing RFCI qpn=0x%x err=%d\n",
+				qp->mqp.qpn, err);
+			return err;
+		}
+	}
+
+	mfc_destroy_cq(&rfci->fc_cq);
+	if (qp->is_created)
+		mlx4_qp_to_reset(mfc_dev->dev, &qp->mqp);
+	qp->is_created = 0;
+	mlx4_qp_remove(mfc_dev->dev, &qp->mqp);
+	mlx4_qp_free(mfc_dev->dev, &qp->mqp);
+	mlx4_free_hwq_res(mfc_dev->dev, &qp->wqres, qp->buf_size);
+
+	mfc_rfci_unpost_rx_bufs(mfc_dev, &rfci->fc_qp.rq);
+
+	mfc_q_destroy(rq);
+	mfc_q_destroy(sq);
+	/* TODO: IB case */
+	if (vhba->net_type == NET_ETH) {
+		mlx4_unregister_mac(mfc_dev->dev, fc_port->port,
+				    rfci->fc_mac_idx);
+		rfci->fc_mac_idx = -1;
+	}
+
+	return 0;
+}
+
+int mfc_init_rfci(struct mfc_vhba *vhba, struct mfc_rfci *rfci)
+{
+	struct mfc_port *fc_port = vhba->mfc_port;
+	struct mfc_dev *mfc_dev = fc_port->mfc_dev;
+	struct mfc_qp *qp = &rfci->fc_qp;
+	enum mlx4_qp_state qp_state = MLX4_QP_STATE_RST;
+	int err = 0;
+	u8 sched_q = 0;
+	struct mlx4_qp_context context;
+
+	if (vhba->net_type == NET_IB)
+		sched_q = 0x83 |
+		    (vhba->dest_ib_sl & 0xf) << 2 | (fc_port->port - 1) << 6;
+	else if (vhba->net_type == NET_ETH)
+		sched_q = 0x83 |
+		    (vhba->fc_vlan_prio & 0xf) << 2 | (fc_port->port - 1) << 6;
+
+	context = (struct mlx4_qp_context) {
+		.flags = cpu_to_be32(QPC_SERVICE_TYPE_RFCI << 16),
+		.pd = cpu_to_be32(mfc_dev->priv_pdn),
+		/* Raw-ETH requirement */
+		.mtu_msgmax = 0x77,
+		.sq_size_stride = ilog2(mfc_num_reserved_xids) << 3 |
+				  ilog2(RFCI_SQ_BB_SIZE >> 4),
+		.rq_size_stride = ilog2(mfc_num_reserved_xids) << 3 |
+				  ilog2(RFCI_RQ_WQE_SIZE >> 4),
+		.usr_page = cpu_to_be32(mfc_dev->priv_uar.index),
+		.local_qpn = cpu_to_be32(qp->mqp.qpn),
+		.pri_path.sched_queue = sched_q,
+		.pri_path.counter_index = 0xff,
+		.pri_path.ackto = (vhba->net_type == NET_IB) ?
+				  MLX4_LINK_TYPE_IB : MLX4_LINK_TYPE_ETH,
+		.params2 = cpu_to_be32((qp->wqres.buf.direct.map &
+					(PAGE_SIZE - 1)) & 0xfc0),
+		.cqn_send = cpu_to_be32(rfci->fc_cq.mcq.cqn),
+		.cqn_recv = cpu_to_be32(rfci->fc_cq.mcq.cqn),
+		/* we can assume that db.dma is aligned */
+		.db_rec_addr = cpu_to_be64(qp->wqres.db.dma),
+		.srqn = 0,
+		.qkey = cpu_to_be32(MLX4_FCOIB_QKEY),
+	};
+
+	err = mlx4_qp_to_ready(mfc_dev->dev, &qp->wqres.mtt, &context,
+			       &qp->mqp, &qp_state);
+
+	if (qp_state != MLX4_QP_STATE_RST)
+		qp->is_created = 1;
+
+	if (qp_state != MLX4_QP_STATE_RTS) {
+		dev_err(mfc_dev->dma_dev,
+			"Error bringing RFCI QP to RTS state\n");
+		return err;
+	}
+	return 0;
+}
+
+int mlx4_do_rfci_xmit(struct mfc_vhba *vhba, int channel,
+		      struct sk_buff *skb, u8 fceof)
+{
+	struct mfc_rfci *rfci = &vhba->rfci[RFCI_CTRL];
+	struct mfc_dev *mfc_dev = vhba->mfc_port->mfc_dev;
+	struct mfc_queue *sq = &rfci->fc_qp.sq;
+	struct mfc_ctrl_seg *ctrl = NULL;
+	struct mfc_data_seg *data = NULL;
+	struct mfc_datagram_seg *dgram;
+	int desc_size;
+	dma_addr_t dma;
+	u32 index, prod;
+	__be32 op_own;
+	unsigned long flags;
+	int offset = 0;
+	struct mfcoib_rfci_tx_desc *tx_desc_ib;
+	struct mfcoe_rfci_tx_desc *tx_desc_eth;
+	u_int tlen = 0;
+
+	spin_lock_irqsave(&sq->lock, flags);
+	if (unlikely((u32) (sq->prod - sq->cons - 1) > sq->size - 2)) {
+		dev_err(mfc_dev->dma_dev, "rfci_xmit: Out of send queue BBs\n");
+		spin_unlock_irqrestore(&sq->lock, flags);
+		return -ENOMEM;
+	}
+
+	prod = sq->prod;
+	++sq->prod;
+	spin_unlock_irqrestore(&sq->lock, flags);
+
+	index = prod & sq->size_mask;
+	mfc_q_info_get(sq, index, struct sk_buff *) = skb;
+
+	if (vhba->net_type == NET_IB) {
+		desc_size = sizeof(struct mfc_ctrl_seg) +
+		    sizeof(struct mfc_data_seg) +
+		    sizeof(struct mfc_datagram_seg);
+
+		tx_desc_ib = sq->buf + index * RFCI_SQ_BB_SIZE;
+		ctrl = &tx_desc_ib->ctrl;
+		ctrl->size = cpu_to_be16((desc_size / 16) & 0x3f);
+		ctrl->flags = cpu_to_be32(MFC_BIT_TX_COMP | MFC_BIT_TX_FCRC_CS);
+
+		dgram = &tx_desc_ib->dgram;
+		dgram->fl_portn_pd = cpu_to_be32((vhba->mfc_port->port << 24) |
+						 mfc_dev->priv_pdn);
+		dgram->mlid_grh = 0;	/* no GRH */
+		dgram->rlid = cpu_to_be16(vhba->dest_ib_lid);	/* remote LID */
+		dgram->mgid_idx = 0;
+		dgram->stat_rate = 0;	/* no rate limit */
+		dgram->sl_tclass_flabel = cpu_to_be32(0 << 28 /* SL */);
+		dgram->dqpn = cpu_to_be32((channel == RFCI_CTRL) ?
+					  vhba->dest_ib_ctrl_qpn : vhba->
+					  dest_ib_data_qpn);
+		dgram->qkey = cpu_to_be32(MLX4_FCOIB_QKEY);
+
+		data = &tx_desc_ib->data;
+		/* skip macs reserved space in skb, but not ethtype */
+		offset = sizeof(struct ethhdr) - 2;
+	} else if (vhba->net_type == NET_ETH) {
+		desc_size = sizeof(struct mfc_ctrl_seg) +
+		    sizeof(struct mfc_data_seg);
+
+		tx_desc_eth = sq->buf + index * RFCI_SQ_BB_SIZE;
+		ctrl = &tx_desc_eth->ctrl;
+		ctrl->size = cpu_to_be16((desc_size / 16) & 0x3f);
+		if (vhba->fc_vlan_id != -1) {
+			tx_desc_eth->ctrl.size |= cpu_to_be16(MFC_BIT_INS_VLAN);
+			tx_desc_eth->ctrl.vlan =
+			    cpu_to_be16(vhba->fc_vlan_id |
+					vhba->fc_vlan_prio << 13);
+		}
+
+		ctrl->flags = cpu_to_be32(MFC_BIT_TX_COMP |
+					  MFC_BIT_NO_ICRC | MFC_BIT_TX_FCRC_CS);
+		data = &tx_desc_eth->data;
+		offset = 0;
+	}
+
+	op_own = cpu_to_be32(MFC_RFCI_OP_SEND) |
+	    cpu_to_be32((u32) fceof << 16) |
+	    ((prod & sq->size) ? cpu_to_be32(MFC_BIT_DESC_OWN) : 0);
+	if (!mfc_t11_mode)
+		tlen = sizeof(struct fcoe_crc_eof_old);
+	else
+		tlen = sizeof(struct fcoe_crc_eof);
+
+	dma = pci_map_single(mfc_dev->dev->pdev, skb->data + offset,
+			     skb->len - tlen - offset, PCI_DMA_TODEVICE);
+	if (pci_dma_mapping_error(mfc_dev->dev->pdev, dma))
+		return -EINVAL;
+
+	data->addr = cpu_to_be64(dma);
+	data->count = cpu_to_be32(skb->len - tlen - offset);
+	data->mem_type = cpu_to_be32(mfc_dev->mr.key);	/* always snoop */
+
+	/* Ensure new descirptor (and ownership of next descirptor) hits memory
+	 * before setting ownership of this descriptor to HW */
+	wmb();
+	ctrl->op_own = op_own;
+
+	/* Ring doorbell! */
+	wmb();
+	writel(rfci->fc_qp.doorbell_qpn, mfc_dev->uar_map + MLX4_SEND_DOORBELL);
+
+	return 0;
+}
+
+int mfc_start_rfci_data(struct mfc_vhba *vhba, u64 mac)
+{
+	int err = 0;
+
+	/*
+	 * Remove any previously-set unicast MAC filter.
+	 * Add secondary FCoE MAC address filter for our OUI.
+	 */
+
+	err = mfc_create_rfci(vhba, &vhba->rfci[RFCI_DATA], mac);
+	if (err) {
+		dev_err(vhba->mfc_port->mfc_dev->dma_dev,
+			"Could not create data RFCI QP, err=%d\n", err);
+		goto out;
+	}
+
+	err = mfc_init_rfci(vhba, &vhba->rfci[RFCI_DATA]);
+	if (err) {
+		dev_err(vhba->mfc_port->mfc_dev->dma_dev,
+			"Could not init data RFCI QP, err=%d\n", err);
+		goto out;
+	}
+
+	vhba->rfci[RFCI_DATA].fc_qp.is_flushing = 0;
+out:
+	return err;
+}
+
+void mfc_recv_flogi(struct fc_lport *lp, struct fc_frame *fp, u8 sa[6])
+{
+	struct mfc_vhba *vhba = lport_priv(lp);
+	struct fc_frame_header *fh;
+	u8 op;
+
+	op = fc_frame_payload_op(fp);
+	fh = fc_frame_header_get(fp);
+	if (fh->fh_type != FC_TYPE_ELS)
+		return;
+
+	if (op == ELS_LS_ACC && fh->fh_r_ctl == FC_RCTL_ELS_REP &&
+	    vhba->flogi_oxid == ntohs(fh->fh_ox_id)) {
+		/* keep my FID */
+		memcpy(vhba->my_npid.fid, fh->fh_d_id, 3);
+
+		/* If non-FIP, learn dest addr from incoming LS_ACC */
+		if (vhba->net_type == NET_ETH) {
+			memcpy(vhba->dest_addr, sa, ETH_ALEN);
+			fc_fcoe_set_mac(vhba->rfci[RFCI_DATA].mac, fh->fh_d_id);
+		}
+
+		/* We should check rc here !!! */
+		mfc_flogi_finished(lp);
+		vhba->flogi_progress = 0;
+
+	} else if (op == ELS_FLOGI && fh->fh_r_ctl == FC_RCTL_ELS_REQ && sa)
+		/* TODO: support for p2p */
+		memcpy(vhba->dest_addr, sa, ETH_ALEN);
+}
+
+int fcoib_recvd_flogi_reply(u64 gw_fc_handle, u8 *flogi_reply,
+			    int size, u32 gw_data_qpn)
+{
+	struct fc_frame *fp;
+	struct mfc_vhba *vhba = (struct mfc_vhba *)gw_fc_handle;
+	struct fc_lport *lp = vhba->lp;
+	struct sk_buff *skb;
+	struct mfc_rfci_rx_info *fr;
+
+	skb = dev_alloc_skb(MFC_RFCI_RX_SKB_BUFSIZE +
+			    sizeof(struct mfc_rfci_rx_info));
+	if (!skb) {
+		dev_err(vhba->mfc_port->mfc_dev->dma_dev,
+			"No skb - rx packet dropped\n");
+		return -ENOMEM;
+	}
+
+	skb_reserve(skb, sizeof(struct mfc_rfci_rx_info));
+
+	fr = (struct mfc_rfci_rx_info *)skb->head;
+	fr->vhba = vhba;
+	fr->skb = skb;
+
+	memcpy(skb_put(skb, size), flogi_reply, size);
+
+	fp = (struct fc_frame *)skb;
+	vhba->dest_ib_data_qpn = gw_data_qpn;
+
+	fc_frame_init(fp);
+	fr_eof(fp) = FC_EOF_T;
+	fr_sof(fp) = FC_SOF_I3;
+	fr_dev(fp) = lp;
+
+	if (unlikely(vhba->flogi_progress))
+		mfc_recv_flogi(lp, fp, NULL);
+
+	fc_exch_recv(lp, fp);
+
+	return 0;
+}
+EXPORT_SYMBOL(fcoib_recvd_flogi_reply);
+
+static int mfc_recv_abort_reply(struct fc_frame *fp, struct mfc_vhba *vhba)
+{
+	struct fc_frame_header *fh = fc_frame_header_get(fp);
+	struct mfc_exch *fexch;
+	int xno;
+	struct fc_ba_rjt *rjt;
+	struct fc_ba_acc *acc;
+
+	xno = ntohs(fh->fh_ox_id) - vhba->base_fexch_qpn +
+	    vhba->mfc_port->base_fexch_qpn;
+
+	fexch = &vhba->fexch[xno];
+
+	switch (fh->fh_r_ctl) {
+	case FC_RCTL_BA_RJT:
+		rjt = fc_frame_payload_get(fp, sizeof(*rjt));
+
+		if (xno > vhba->base_reserved_xid &&
+		    xno < vhba->base_reserved_xid + vhba->num_reserved_xid) {
+			dev_err(vhba->mfc_port->mfc_dev->dma_dev,
+				"This fexch reserved, pass to upper layer\n");
+			return -1;
+		}
+
+		if (xno < 0 || xno > vhba->num_fexch) {
+			dev_err(vhba->mfc_port->mfc_dev->dma_dev,
+				"BA_RJT with invalid fexch number %d\n", xno);
+			return -1;
+		}
+
+		dev_info(vhba->mfc_port->mfc_dev->dma_dev,
+			 "BA_RJT fexch 0x%x reason 0x%x exp 0x%x\n",
+			 xno, rjt->br_reason, rjt->br_explan);
+
+		if (fexch->state == FEXCH_SEND_ABORT)
+			fexch->state = FEXCH_ABORT;
+		break;
+
+	case FC_RCTL_BA_ACC:
+
+		acc = fc_frame_payload_get(fp, sizeof(*acc));
+
+		xno = ntohs(acc->ba_ox_id) - vhba->base_fexch_qpn +
+		    vhba->mfc_port->base_fexch_qpn;
+
+		if (xno > vhba->base_reserved_xid &&
+		    xno < vhba->base_reserved_xid + vhba->num_reserved_xid) {
+			dev_err(vhba->mfc_port->mfc_dev->dma_dev,
+				"This fexch reserved, pass to upper layer\n");
+			return -1;
+		}
+
+		if (xno < 0 || xno > vhba->num_fexch) {
+			dev_err(vhba->mfc_port->mfc_dev->dma_dev,
+				"BA_ACC with invalid fexch number %d.\n", xno);
+			return -1;
+		}
+
+		if (fexch->state == FEXCH_SEND_ABORT)
+			fexch->state = FEXCH_ABORT;
+
+		dev_info(vhba->mfc_port->mfc_dev->dma_dev,
+			 "BA_ACC for 0x%x fexch\n", xno);
+
+		break;
+
+	default:
+		return -1;
+	}
+
+	complete(&fexch->tm_done);
+
+	return 0;
+}
+
+static void mfc_rx_rfci(struct work_struct *work)
+{
+	struct mfc_rfci_rx_info *fr =
+	    container_of(work, struct mfc_rfci_rx_info, work);
+	u_int32_t fr_len;
+	u_int hlen;
+	u_int tlen;
+	struct mfc_vhba *vhba = fr->vhba;
+	struct fc_lport *lp = vhba->lp;
+	struct fcoe_dev_stats *stats = per_cpu_ptr(lp->dev_stats, get_cpu());
+	struct fc_frame_header *fh;
+	struct sk_buff *skb = fr->skb;
+	struct fcoe_crc_eof_old *cp;
+	enum fc_sof sof;
+	struct fc_frame *fp;
+	u8 mac[6] = { 0 };
+	struct fcoe_hdr_old *fchp;
+	u_int len;
+	struct fcoe_hdr *hp;
+	int rc;
+
+	/*
+	 * Save source MAC address before discarding header.
+	 */
+	if (unlikely(vhba->flogi_progress))
+		memcpy(mac, eth_hdr(skb)->h_source, ETH_ALEN);
+
+	/*
+	 * Check the header and pull it off.
+	 */
+	hlen = vhba->fcoe_hlen;
+	if (!mfc_t11_mode) {	/* pre-T11 */
+		fchp = (struct fcoe_hdr_old *)skb->data;
+		tlen = sizeof(struct fcoe_crc_eof_old);
+		len = ntohs(fchp->fcoe_plen);
+		fr_len = FCOE_DECAPS_LEN(len);
+		fr_len = fr_len * FCOE_WORD_TO_BYTE;
+		fr_len -= sizeof(cp->fcoe_crc32);
+		skb_pull(skb, sizeof(*fchp));
+		sof = FCOE_DECAPS_SOF(len);
+		if (unlikely(fr_len + tlen > skb->len)) {
+			if (stats->ErrorFrames < 5)
+				dev_err(vhba->mfc_port->mfc_dev->dma_dev,
+					"len error fr_len 0x%x skb->len 0x%x\n",
+					fr_len + tlen, skb->len);
+			stats->ErrorFrames++;
+			goto free_packet;
+		}
+	} else {		/* T11 */
+		hp = (struct fcoe_hdr *)skb->data;
+		skb_pull(skb, sizeof(struct fcoe_hdr));
+		tlen = sizeof(struct fcoe_crc_eof);
+		fr_len = skb->len - tlen;
+		sof = hp->fcoe_sof;
+	}
+
+	if (unlikely(fr_len < sizeof(struct fc_frame_header))) {
+		if (stats->ErrorFrames < 5)
+			dev_err(vhba->mfc_port->mfc_dev->dma_dev,
+				"length error: len_sof %x\n", fr_len);
+		stats->ErrorFrames++;
+		goto free_packet;
+	}
+
+	if (skb_is_nonlinear(skb))
+		skb_linearize(skb);	/* not ideal */
+
+	stats->RxFrames++;
+	stats->RxWords += fr_len / FCOE_WORD_TO_BYTE;
+
+	fp = (struct fc_frame *)skb;
+	fc_frame_init(fp);
+	cp = (struct fcoe_crc_eof_old *)(skb->data + fr_len);
+	fr_eof(fp) = cp->fcoe_eof;
+	fr_sof(fp) = sof;
+	fr_dev(fp) = lp;
+
+	fh = fc_frame_header_get(fp);
+
+	if (fh->fh_r_ctl == FC_RCTL_BA_ACC || fh->fh_r_ctl == FC_RCTL_BA_RJT) {
+		rc = mfc_recv_abort_reply(fp, vhba);
+		if (rc)
+			goto libfc_packet;
+		else
+			goto free_packet;
+	}
+
+	if (unlikely(vhba->flogi_progress))
+		mfc_recv_flogi(lp, fp, mac);
+
+libfc_packet:
+	fc_exch_recv(lp, fp);
+
+	/*
+	 * no need for kfree_skb() - skb was already freed inside
+	 * fc_exch_recv()
+	 */
+	return;
+
+free_packet:
+	kfree_skb(skb);
+}
+
+int mfc_frame_send(struct fc_lport *lp, struct fc_frame *fp)
+{
+	struct mfc_vhba *vhba = lport_priv(lp);
+	struct fc_frame_header *fh;
+	struct sk_buff *skb;
+	u8 sof, eof;
+	unsigned int elen;
+	unsigned int hlen;
+	unsigned int tlen;
+	int wlen;
+	struct ethhdr *eh;
+	struct fcoe_crc_eof *cp;
+	int flogi_in_progress = 0;
+	struct fcoe_hdr *hp;
+	struct fcoe_hdr_old *ohp;
+	int data_channel;
+	int rc = 0;
+
+	fh = fc_frame_header_get(fp);
+
+	skb = fp_skb(fp);
+
+	if (unlikely(fh->fh_r_ctl == FC_RCTL_ELS_REQ)) {
+		if (fc_frame_payload_op(fp) == ELS_FLOGI) {
+			vhba->flogi_oxid = ntohs(fh->fh_ox_id);
+			vhba->flogi_progress = 1;
+			flogi_in_progress = 1;
+			vhba->rfci_rx_enabled = 1;
+			if (mfc_debug_mode == 0)
+				fc_fcoe_set_mac(vhba->dest_addr, fc_fid_flogi);
+
+			if (vhba->net_type == NET_ETH && vhba->link_up) {
+				if (fcoe_ctlr_els_send(&vhba->ctlr, lp, skb)) {
+					dev_err(vhba->mfc_port->mfc_dev->
+						dma_dev,
+						"Sending FLOGI over FIP\n");
+					goto out;
+				}
+			} else if (vhba->net_type == NET_IB) {
+				vhba->fcoib_send_els_cb(vhba->
+							gw_discovery_handle,
+							(u64) vhba,
+							FLOGI_OVER_FIP,
+							skb->data,
+							vhba->rfci[RFCI_CTRL].
+							fc_qp.mqp.qpn);
+				goto out_skb_free;
+			}
+		} else if (fc_frame_payload_op(fp) == ELS_LOGO &&
+			   !memcmp(fc_fid_flogi, fh->fh_d_id, 3)) {
+
+			if (vhba->net_type == NET_ETH) {
+				if (fcoe_ctlr_els_send(&vhba->ctlr, lp, skb)) {
+					dev_info(vhba->mfc_port->mfc_dev->
+						 dma_dev,
+						 "Sending FLOGO over FIP\n");
+					goto out;
+				}
+			} else if (vhba->net_type == NET_IB) {
+				vhba->fcoib_send_els_cb(vhba->
+							gw_discovery_handle,
+							(u64) vhba,
+							LOGO_OVER_FIP,
+							skb->data,
+							vhba->rfci[RFCI_CTRL].
+							fc_qp.mqp.qpn);
+				goto out_skb_free;
+			}
+		}
+	}
+
+	if (vhba->rfci[RFCI_CTRL].fc_qp.is_flushing) {
+		rc = -1;
+		goto out_skb_free;
+	}
+
+	if (flogi_in_progress || (mfc_debug_mode == 1))
+		data_channel = RFCI_CTRL;
+	else
+		data_channel = RFCI_DATA;
+
+	sof = fr_sof(fp);
+	eof = fr_eof(fp);
+
+	if (!mfc_t11_mode) {
+		hlen = sizeof(struct fcoe_hdr_old);
+		tlen = sizeof(struct fcoe_crc_eof_old);
+	} else {
+		hlen = sizeof(struct fcoe_hdr);
+		tlen = sizeof(struct fcoe_crc_eof);
+	}
+
+	elen = sizeof(struct ethhdr);
+
+	cp = (struct fcoe_crc_eof *)skb_put(skb, tlen);
+	memset(cp, 0, sizeof(*cp));
+
+	wlen = (skb->len - tlen + sizeof(u32)) / FCOE_WORD_TO_BYTE;
+
+	/* adjust skb network/transport offsets to match mac/fcoe/fc */
+	skb_push(skb, elen + hlen);
+	skb_reset_mac_header(skb);
+	skb_reset_network_header(skb);
+	skb->mac_len = elen;
+
+	eh = eth_hdr(skb);
+
+	if (vhba->net_type == NET_ETH) {
+		skb->protocol = htons(ETH_P_FCOE);
+		eh->h_proto = htons(ETH_P_FCOE);
+
+		if (vhba->ctlr.map_dest)
+			fc_fcoe_set_mac(eh->h_dest, fh->fh_d_id);
+		else
+			/* insert GW address */
+			memcpy(eh->h_dest, vhba->ctlr.dest_addr, ETH_ALEN);
+
+		if (unlikely(vhba->ctlr.flogi_oxid != FC_XID_UNKNOWN))
+			memcpy(eh->h_source, vhba->ctlr.ctl_src_addr, ETH_ALEN);
+		else
+			memcpy(eh->h_source, vhba->rfci[RFCI_DATA].mac,
+			       ETH_ALEN);
+	} else if (vhba->net_type == NET_IB) {
+		skb->protocol = htons(FCOIB_SIG);
+		eh->h_proto = htons(FCOIB_SIG);
+	}
+
+	if (!mfc_t11_mode) {
+		ohp = (struct fcoe_hdr_old *)(eh + 1);
+		ohp->fcoe_plen = htons(FCOE_ENCAPS_LEN_SOF(wlen, sof));
+	} else {
+		hp = (struct fcoe_hdr *)(eh + 1);
+		memset(hp, 0, sizeof(*hp));
+		if (FC_FCOE_VER)
+			FC_FCOE_ENCAPS_VER(hp, FC_FCOE_VER);
+		hp->fcoe_sof = sof;
+	}
+
+	fr_dev(fp) = lp;
+
+	rc = mlx4_do_rfci_xmit(vhba, data_channel, skb, eof);
+	if (!rc)
+		goto out;
+
+out_skb_free:
+	kfree_skb(skb);
+
+out:
+	return rc;
+}
diff --git a/drivers/scsi/mlx4_fc/mfc_sysfs.c b/drivers/scsi/mlx4_fc/mfc_sysfs.c
new file mode 100644
index 0000000..61511f2
--- /dev/null
+++ b/drivers/scsi/mlx4_fc/mfc_sysfs.c
@@ -0,0 +1,244 @@
+/*
+ * Copyright (c) 2010 Mellanox Technologies. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+#include <scsi/libfc.h>
+#include "mfc.h"
+
+char *vhba_dentry_name(char *buf, struct mfc_vhba *vhba, char *str)
+{
+	snprintf(buf, VHBA_SYSFS_LEN, "%s%d_%s", "vhba",
+		 vhba->lp->host->host_no, str);
+	return buf;
+}
+
+char *fport_dentry_name(char *buf, struct mfc_port *fport, char *str)
+{
+	snprintf(buf, VHBA_SYSFS_LEN, "mlx4_%d_port%d_%s",
+		 fport->mfc_dev->idx, fport->port, str);
+	return buf;
+}
+
+#define _sprintf(p, buf, format, arg...)				\
+	(((PAGE_SIZE - (int)(p - buf)) <= 0) ?				\
+	 0 : scnprintf(p, PAGE_SIZE - (int)(p - buf), format, ## arg))
+
+#define DENTRY_REMOVE(_dentry)						\
+do {									\
+	sysfs_remove_file((_dentry)->kobj, &(_dentry)->mattr.attr);	\
+} while (0);
+
+#define DENTRY_CREATE(_ctx, _dentry, _name, _show, _store)		\
+do {									\
+	struct mfc_sysfs_attr *vdentry = _dentry;			\
+	struct module *owner = THIS_MODULE;				\
+	vdentry->ctx = _ctx;						\
+	vdentry->mattr.show = _show;					\
+	vdentry->mattr.store = _store;					\
+	vdentry->mattr.attr.name = vdentry->name;			\
+	vdentry->mattr.attr.mode = 0;					\
+	vdentry->kobj = &owner->mkobj.kobj;				\
+	snprintf(vdentry->name, VHBA_SYSFS_LEN, "%s", _name);		\
+	if (vdentry->mattr.store)					\
+		vdentry->mattr.attr.mode |= S_IWUGO;			\
+	if (vdentry->mattr.show)					\
+		vdentry->mattr.attr.mode |= S_IRUGO;			\
+	if (sysfs_create_file(vdentry->kobj, &vdentry->mattr.attr)) {	\
+		printk(KERN_WARNING "failed to create %s\n",		\
+			vdentry->mattr.attr.name);			\
+		vdentry->ctx = NULL;					\
+		break;							\
+	}								\
+} while (0);
+
+static inline struct net_device *vhba_get_netdev(struct mfc_vhba *vhba)
+{
+	return (struct net_device *)vhba->underdev;
+}
+
+static inline const char *fc_lport_state_name(enum fc_lport_state lp_state)
+{
+	static const char *fc_lport_state_names[] = {
+		[LPORT_ST_DISABLED] = "Disabled",
+		[LPORT_ST_FLOGI] = "FLOGI",
+		[LPORT_ST_DNS] = "dNS",
+		[LPORT_ST_RSPN_ID] = "RSPN_ID",
+		[LPORT_ST_RFT_ID] = "RFT_ID",
+		[LPORT_ST_SCR] = "SCR",
+		[LPORT_ST_READY] = "Ready",
+		[LPORT_ST_LOGO] = "LOGO",
+		[LPORT_ST_RESET] = "reset",
+	};
+
+	if (lp_state > LPORT_ST_RESET)
+		return "invalid_state";
+
+	return fc_lport_state_names[lp_state];
+};
+
+static ssize_t vhba_show(struct module_attribute *attr,
+			 struct module *mod, char *buf)
+{
+	char *p = buf;
+	struct mfc_sysfs_attr *vhba_dentry =
+	    container_of(attr, struct mfc_sysfs_attr, mattr);
+	struct mfc_vhba *vhba = vhba_dentry->ctx;
+	struct net_device *netdev;
+
+	switch (vhba->net_type) {
+	case NET_ETH:
+		/* FCOE VHBA */
+		netdev = vhba_get_netdev(vhba);
+
+		p += _sprintf(p, buf, "PROTO                    FCoE\n");
+		p += _sprintf(p, buf, "ETH_IF                   %s\n",
+			      netdev->name);
+		p += _sprintf(p, buf, "GW_MAC                   "
+			      MAC_PRINTF_FMT "\n",
+			      MAC_PRINTF_VAR(vhba->dest_addr));
+		p += _sprintf(p, buf, "VLAN_ID                  %d\n",
+			      vhba->fc_vlan_id);
+		p += _sprintf(p, buf, "VLAN_HW_TABLE_IDX        %d\n",
+			      vhba->fc_vlan_idx);
+		p += _sprintf(p, buf, "VLAN_PRIO                %d\n",
+			      vhba->fc_vlan_prio);
+		break;
+	case NET_IB:
+		/* FCOIB VHBA */
+		p += _sprintf(p, buf, "PROTO                    FCoIB\n");
+		p += _sprintf(p, buf, "GW_CTRL_QPN              0x%lx\n",
+			      vhba->dest_ib_ctrl_qpn);
+		p += _sprintf(p, buf, "GW_DATA_QPN              0x%lx\n",
+			      vhba->dest_ib_data_qpn);
+		p += _sprintf(p, buf, "GW_LID                   0x%x\n",
+			      vhba->dest_ib_lid);
+		break;
+	}
+	/* VHBA GENERAL */
+	p += _sprintf(p, buf, "PORT_NUM                 %d\n",
+		      vhba->mfc_port->port);
+	p += _sprintf(p, buf, "SYSFS_PORT_NAME          mlx4_%d_port%d\n",
+		      vhba->mfc_port->mfc_dev->idx, vhba->mfc_port->port);
+	p += _sprintf(p, buf, "FC_PAYLOAD               %d\n",
+		      vhba->fc_payload_size);
+	p += _sprintf(p, buf, "BASE_FEXCH_MPT           0x%x\n",
+		      vhba->base_fexch_mpt);
+	p += _sprintf(p, buf, "BASE_LIBFC_FEXCH         0x%x\n",
+		      vhba->base_reserved_xid);
+	p += _sprintf(p, buf, "NUM_LIBFC_FEXCH          %d\n",
+		      vhba->num_reserved_xid);
+	p += _sprintf(p, buf, "BASE_FEXCH_QPN           0x%x\n",
+		      vhba->base_fexch_qpn);
+	p += _sprintf(p, buf, "NUM_FEXCH                %d\n", vhba->num_fexch);
+	p += _sprintf(p, buf, "LPORT_STATE              %s\n",
+		      fc_lport_state_name(vhba->lp->state));
+
+	/* RFCI CTRL */
+	p += _sprintf(p, buf, "RFCI_CTRL_QPN            0x%x\n",
+		      vhba->rfci[RFCI_CTRL].fc_qp.mqp.qpn);
+	p += _sprintf(p, buf, "RFCI_CTRL_CQN            0x%x\n",
+		      vhba->rfci[RFCI_CTRL].fc_cq.mcq.cqn);
+
+	if (vhba->net_type == NET_ETH) {
+		p += _sprintf(p, buf,
+			      "RFCI_CTRL_MAC            " MAC_PRINTF_FMT "\n",
+			      MAC_PRINTF_VAR(vhba->rfci[RFCI_CTRL].mac));
+	}
+
+	/* RFCI DATA for fcoe only */
+	if (vhba->net_type == NET_ETH) {
+		p += _sprintf(p, buf, "RFCI_DATA_QPN            0x%x\n",
+			      vhba->rfci[RFCI_DATA].fc_qp.mqp.qpn);
+		p += _sprintf(p, buf, "RFCI_DATA_CQN            0x%x\n",
+			      vhba->rfci[RFCI_DATA].fc_cq.mcq.cqn);
+		p += _sprintf(p, buf,
+			      "RFCI_DATA_MAC            " MAC_PRINTF_FMT "\n",
+			      MAC_PRINTF_VAR(vhba->rfci[RFCI_DATA].mac));
+	}
+
+	return (ssize_t) (p - buf);
+}
+
+static ssize_t fport_show(struct module_attribute *attr,
+			  struct module *mod, char *buf)
+{
+	char *p = buf;
+	struct mfc_sysfs_attr *fport_dentry =
+	    container_of(attr, struct mfc_sysfs_attr, mattr);
+	struct mfc_port *fport = fport_dentry->ctx;
+	p += _sprintf(p, buf, "HCA_BOARD_ID             %.*s\n",
+		      MLX4_BOARD_ID_LEN, fport->mfc_dev->dev->board_id);
+	p += _sprintf(p, buf, "PCI_DEV                  %s\n",
+		      pci_name(fport->mfc_dev->dev->pdev));
+	p += _sprintf(p, buf, "BASE_FEXCH_MPT           0x%x\n",
+		      fport->base_fexch_mpt);
+	p += _sprintf(p, buf, "BASE_FEXCH_QPN           0x%x\n",
+		      fport->base_fexch_qpn);
+	p += _sprintf(p, buf, "BASE_RFCI_QPN            0x%x\n",
+		      fport->base_rfci_qpn);
+	p += _sprintf(p, buf, "NUM_FEXCH_QPS            %d\n",
+		      fport->num_fexch_qps);
+
+	return (ssize_t) (p - buf);
+}
+
+int mfc_vhba_create_dentry(struct mfc_vhba *vhba)
+{
+	char name[VHBA_SYSFS_LEN];
+
+	DENTRY_CREATE(vhba, &vhba->dentry, vhba_dentry_name(name, vhba, "info"),
+		      vhba_show, NULL);
+
+	return 0;
+}
+
+void mfc_vhba_delete_dentry(struct mfc_vhba *vhba)
+{
+	if (vhba->dentry.ctx)
+		DENTRY_REMOVE(&vhba->dentry);
+}
+
+int mfc_port_create_dentry(struct mfc_port *fport)
+{
+	char name[VHBA_SYSFS_LEN];
+
+	DENTRY_CREATE(fport, &fport->dentry,
+		      fport_dentry_name(name, fport, "info"), fport_show, NULL);
+
+	return 0;
+}
+
+void mfc_port_delete_dentry(struct mfc_port *fport)
+{
+	if (fport->dentry.ctx)
+		DENTRY_REMOVE(&fport->dentry);
+}
-- 
1.6.3.3


--------------080309050801090905020009
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--------------080309050801090905020009--

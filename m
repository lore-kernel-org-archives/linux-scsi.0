From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH v2 16/16] cxgbit: add files for cxgbit.ko
Date: Sat,  9 Apr 2016 18:41:26 +0530
Message-ID: <e4928787896079253b48346e6214e8f718e7daca.1460204441.git.varun@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <cover.1460204441.git.varun@chelsio.com>
In-Reply-To: <cover.1460204441.git.varun@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

cxgbit.h - This file contains data structure
definitions for cxgbit.ko.

cxgbit_lro.h - This file contains data structure
definitions for LRO support.

cxgbit_main.c - This file contains code for
registering with iscsi target transport and
cxgb4 driver.

cxgbit_cm.c - This file contains code for
connection management.

cxgbit_target.c - This file contains code
for processing iSCSI PDU.

cxgbit_ddp.c - This file contains code for
Direct Data Placement.
v2: added check for NULL sg in cxgbit_set_one_ppod()

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

cxgbit: add Kconfig and Makefile
v2: added dependency on INET

Reported-by: Arnd Bergmann <arnd@arndb.de>

iscsi-target: update Kconfig and Makefile
for compiling cxgbit.ko.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/Kconfig                |    2 +
 drivers/target/iscsi/Makefile               |    1 +
 drivers/target/iscsi/cxgbit/Kconfig         |    7 +
 drivers/target/iscsi/cxgbit/Makefile        |    6 +
 drivers/target/iscsi/cxgbit/cxgbit.h        |  358 +++++
 drivers/target/iscsi/cxgbit/cxgbit_cm.c     | 2086 +++++++++++++++++++++++++++
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c    |  325 +++++
 drivers/target/iscsi/cxgbit/cxgbit_lro.h    |   72 +
 drivers/target/iscsi/cxgbit/cxgbit_main.c   |  703 +++++++++
 drivers/target/iscsi/cxgbit/cxgbit_target.c | 1601 ++++++++++++++++++++
 10 files changed, 5161 insertions(+)
 create mode 100644 drivers/target/iscsi/cxgbit/Kconfig
 create mode 100644 drivers/target/iscsi/cxgbit/Makefile
 create mode 100644 drivers/target/iscsi/cxgbit/cxgbit.h
 create mode 100644 drivers/target/iscsi/cxgbit/cxgbit_cm.c
 create mode 100644 drivers/target/iscsi/cxgbit/cxgbit_ddp.c
 create mode 100644 drivers/target/iscsi/cxgbit/cxgbit_lro.h
 create mode 100644 drivers/target/iscsi/cxgbit/cxgbit_main.c
 create mode 100644 drivers/target/iscsi/cxgbit/cxgbit_target.c

diff --git a/drivers/target/iscsi/Kconfig b/drivers/target/iscsi/Kconfig
index 8345fb4..bbdbf9c 100644
--- a/drivers/target/iscsi/Kconfig
+++ b/drivers/target/iscsi/Kconfig
@@ -7,3 +7,5 @@ config ISCSI_TARGET
 	help
 	Say M here to enable the ConfigFS enabled Linux-iSCSI.org iSCSI
 	Target Mode Stack.
+
+source	"drivers/target/iscsi/cxgbit/Kconfig"
diff --git a/drivers/target/iscsi/Makefile b/drivers/target/iscsi/Makefile
index 0f43be9..0f18295 100644
--- a/drivers/target/iscsi/Makefile
+++ b/drivers/target/iscsi/Makefile
@@ -18,3 +18,4 @@ iscsi_target_mod-y +=		iscsi_target_parameters.o \
 				iscsi_target_transport.o
 
 obj-$(CONFIG_ISCSI_TARGET)	+= iscsi_target_mod.o
+obj-$(CONFIG_ISCSI_TARGET_CXGB4) += cxgbit/
diff --git a/drivers/target/iscsi/cxgbit/Kconfig b/drivers/target/iscsi/cxgbit/Kconfig
new file mode 100644
index 0000000..c9b6a3c
--- /dev/null
+++ b/drivers/target/iscsi/cxgbit/Kconfig
@@ -0,0 +1,7 @@
+config ISCSI_TARGET_CXGB4
+	tristate "Chelsio iSCSI target offload driver"
+	depends on ISCSI_TARGET && CHELSIO_T4 && INET
+	select CHELSIO_T4_UWIRE
+	---help---
+	To compile this driver as module, choose M here: the module
+	will be called cxgbit.
diff --git a/drivers/target/iscsi/cxgbit/Makefile b/drivers/target/iscsi/cxgbit/Makefile
new file mode 100644
index 0000000..bd56c07
--- /dev/null
+++ b/drivers/target/iscsi/cxgbit/Makefile
@@ -0,0 +1,6 @@
+ccflags-y := -Idrivers/net/ethernet/chelsio/cxgb4
+ccflags-y += -Idrivers/target/iscsi
+
+obj-$(CONFIG_ISCSI_TARGET_CXGB4)  += cxgbit.o
+
+cxgbit-y  := cxgbit_main.o cxgbit_cm.o cxgbit_target.o cxgbit_ddp.o
diff --git a/drivers/target/iscsi/cxgbit/cxgbit.h b/drivers/target/iscsi/cxgbit/cxgbit.h
new file mode 100644
index 0000000..3aa9a3c
--- /dev/null
+++ b/drivers/target/iscsi/cxgbit/cxgbit.h
@@ -0,0 +1,358 @@
+/*
+ * Copyright (c) 2016 Chelsio Communications, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __CXGBIT_H__
+#define __CXGBIT_H__
+
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/idr.h>
+#include <linux/completion.h>
+#include <linux/netdevice.h>
+#include <linux/sched.h>
+#include <linux/pci.h>
+#include <linux/dma-mapping.h>
+#include <linux/inet.h>
+#include <linux/wait.h>
+#include <linux/kref.h>
+#include <linux/timer.h>
+#include <linux/io.h>
+
+#include <asm/byteorder.h>
+
+#include <net/net_namespace.h>
+
+#include <target/iscsi/iscsi_transport.h>
+#include <iscsi_target_parameters.h>
+#include <iscsi_target_login.h>
+
+#include "t4_regs.h"
+#include "t4_msg.h"
+#include "cxgb4.h"
+#include "cxgb4_uld.h"
+#include "l2t.h"
+#include "cxgb4_ppm.h"
+#include "cxgbit_lro.h"
+
+extern struct mutex cdev_list_lock;
+extern struct list_head cdev_list_head;
+struct cxgbit_np;
+
+struct cxgbit_sock;
+
+struct cxgbit_cmd {
+	struct sk_buff *skb;
+	struct scatterlist sg;
+	struct cxgbi_task_tag_info ttinfo;
+	bool setup_ddp;
+	bool release;
+};
+
+#define CXGBIT_MAX_ISO_PAYLOAD	\
+	min_t(u32, MAX_SKB_FRAGS * PAGE_SIZE, 65535)
+
+struct cxgbit_iso_info {
+	u8 flags;
+	u32 mpdu;
+	u32 len;
+	u32 burst_len;
+};
+
+enum cxgbit_skcb_flags {
+	SKCBF_TX_NEED_HDR	= (1 << 0), /* packet needs a header */
+	SKCBF_TX_FLAG_COMPL	= (1 << 1), /* wr completion flag */
+	SKCBF_TX_ISO		= (1 << 2), /* iso cpl in tx skb */
+	SKCBF_RX_LRO		= (1 << 3), /* lro skb */
+};
+
+struct cxgbit_skb_rx_cb {
+	u8 opcode;
+	void *pdu_cb;
+	void (*backlog_fn)(struct cxgbit_sock *, struct sk_buff *);
+};
+
+struct cxgbit_skb_tx_cb {
+	u8 submode;
+	u32 extra_len;
+};
+
+union cxgbit_skb_cb {
+	struct {
+		u8 flags;
+		union {
+			struct cxgbit_skb_tx_cb tx;
+			struct cxgbit_skb_rx_cb rx;
+		};
+	};
+
+	struct {
+		/* This member must be first. */
+		struct l2t_skb_cb l2t;
+		struct sk_buff *wr_next;
+	};
+};
+
+#define CXGBIT_SKB_CB(skb)	((union cxgbit_skb_cb *)&((skb)->cb[0]))
+#define cxgbit_skcb_flags(skb)		(CXGBIT_SKB_CB(skb)->flags)
+#define cxgbit_skcb_submode(skb)	(CXGBIT_SKB_CB(skb)->tx.submode)
+#define cxgbit_skcb_tx_wr_next(skb)	(CXGBIT_SKB_CB(skb)->wr_next)
+#define cxgbit_skcb_tx_extralen(skb)	(CXGBIT_SKB_CB(skb)->tx.extra_len)
+#define cxgbit_skcb_rx_opcode(skb)	(CXGBIT_SKB_CB(skb)->rx.opcode)
+#define cxgbit_skcb_rx_backlog_fn(skb)	(CXGBIT_SKB_CB(skb)->rx.backlog_fn)
+#define cxgbit_rx_pdu_cb(skb)		(CXGBIT_SKB_CB(skb)->rx.pdu_cb)
+
+static inline void *cplhdr(struct sk_buff *skb)
+{
+	return skb->data;
+}
+
+enum cxgbit_cdev_flags {
+	CDEV_STATE_UP = 0,
+	CDEV_ISO_ENABLE,
+	CDEV_DDP_ENABLE,
+};
+
+#define NP_INFO_HASH_SIZE 32
+
+struct np_info {
+	struct np_info *next;
+	struct cxgbit_np *cnp;
+	unsigned int stid;
+};
+
+struct cxgbit_list_head {
+	struct list_head list;
+	/* device lock */
+	spinlock_t lock;
+};
+
+struct cxgbit_device {
+	struct list_head list;
+	struct cxgb4_lld_info lldi;
+	struct np_info *np_hash_tab[NP_INFO_HASH_SIZE];
+	/* np lock */
+	spinlock_t np_lock;
+	u8 selectq[MAX_NPORTS][2];
+	struct cxgbit_list_head cskq;
+	u32 mdsl;
+	struct kref kref;
+	unsigned long flags;
+};
+
+struct cxgbit_wr_wait {
+	struct completion completion;
+	int ret;
+};
+
+enum cxgbit_csk_state {
+	CSK_STATE_IDLE = 0,
+	CSK_STATE_LISTEN,
+	CSK_STATE_CONNECTING,
+	CSK_STATE_ESTABLISHED,
+	CSK_STATE_ABORTING,
+	CSK_STATE_CLOSING,
+	CSK_STATE_MORIBUND,
+	CSK_STATE_DEAD,
+};
+
+enum cxgbit_csk_flags {
+	CSK_TX_DATA_SENT = 0,
+	CSK_LOGIN_PDU_DONE,
+	CSK_LOGIN_DONE,
+	CSK_DDP_ENABLE,
+};
+
+struct cxgbit_sock_common {
+	struct cxgbit_device *cdev;
+	struct sockaddr_storage local_addr;
+	struct sockaddr_storage remote_addr;
+	struct cxgbit_wr_wait wr_wait;
+	enum cxgbit_csk_state state;
+	unsigned long flags;
+};
+
+struct cxgbit_np {
+	struct cxgbit_sock_common com;
+	wait_queue_head_t accept_wait;
+	struct iscsi_np *np;
+	struct completion accept_comp;
+	struct list_head np_accept_list;
+	/* np accept lock */
+	spinlock_t np_accept_lock;
+	struct kref kref;
+	unsigned int stid;
+};
+
+struct cxgbit_sock {
+	struct cxgbit_sock_common com;
+	struct cxgbit_np *cnp;
+	struct iscsi_conn *conn;
+	struct l2t_entry *l2t;
+	struct dst_entry *dst;
+	struct list_head list;
+	struct sk_buff_head rxq;
+	struct sk_buff_head txq;
+	struct sk_buff_head ppodq;
+	struct sk_buff_head backlogq;
+	struct sk_buff_head skbq;
+	struct sk_buff *wr_pending_head;
+	struct sk_buff *wr_pending_tail;
+	struct sk_buff *skb;
+	struct sk_buff *lro_skb;
+	struct sk_buff *lro_hskb;
+	struct list_head accept_node;
+	/* socket lock */
+	spinlock_t lock;
+	wait_queue_head_t waitq;
+	wait_queue_head_t ack_waitq;
+	bool lock_owner;
+	struct kref kref;
+	u32 max_iso_npdu;
+	u32 wr_cred;
+	u32 wr_una_cred;
+	u32 wr_max_cred;
+	u32 snd_una;
+	u32 tid;
+	u32 snd_nxt;
+	u32 rcv_nxt;
+	u32 smac_idx;
+	u32 tx_chan;
+	u32 mtu;
+	u32 write_seq;
+	u32 rx_credits;
+	u32 snd_win;
+	u32 rcv_win;
+	u16 mss;
+	u16 emss;
+	u16 plen;
+	u16 rss_qid;
+	u16 txq_idx;
+	u16 ctrlq_idx;
+	u8 tos;
+	u8 port_id;
+#define CXGBIT_SUBMODE_HCRC 0x1
+#define CXGBIT_SUBMODE_DCRC 0x2
+	u8 submode;
+#ifdef CONFIG_CHELSIO_T4_DCB
+	u8 dcb_priority;
+#endif
+	u8 snd_wscale;
+};
+
+void _cxgbit_free_cdev(struct kref *kref);
+void _cxgbit_free_csk(struct kref *kref);
+void _cxgbit_free_cnp(struct kref *kref);
+
+static inline void cxgbit_get_cdev(struct cxgbit_device *cdev)
+{
+	kref_get(&cdev->kref);
+}
+
+static inline void cxgbit_put_cdev(struct cxgbit_device *cdev)
+{
+	kref_put(&cdev->kref, _cxgbit_free_cdev);
+}
+
+static inline void cxgbit_get_csk(struct cxgbit_sock *csk)
+{
+	kref_get(&csk->kref);
+}
+
+static inline void cxgbit_put_csk(struct cxgbit_sock *csk)
+{
+	kref_put(&csk->kref, _cxgbit_free_csk);
+}
+
+static inline void cxgbit_get_cnp(struct cxgbit_np *cnp)
+{
+	kref_get(&cnp->kref);
+}
+
+static inline void cxgbit_put_cnp(struct cxgbit_np *cnp)
+{
+	kref_put(&cnp->kref, _cxgbit_free_cnp);
+}
+
+static inline void cxgbit_sock_reset_wr_list(struct cxgbit_sock *csk)
+{
+	csk->wr_pending_tail = NULL;
+	csk->wr_pending_head = NULL;
+}
+
+static inline struct sk_buff *cxgbit_sock_peek_wr(const struct cxgbit_sock *csk)
+{
+	return csk->wr_pending_head;
+}
+
+static inline void
+cxgbit_sock_enqueue_wr(struct cxgbit_sock *csk, struct sk_buff *skb)
+{
+	cxgbit_skcb_tx_wr_next(skb) = NULL;
+
+	skb_get(skb);
+
+	if (!csk->wr_pending_head)
+		csk->wr_pending_head = skb;
+	else
+		cxgbit_skcb_tx_wr_next(csk->wr_pending_tail) = skb;
+	csk->wr_pending_tail = skb;
+}
+
+static inline struct sk_buff *cxgbit_sock_dequeue_wr(struct cxgbit_sock *csk)
+{
+	struct sk_buff *skb = csk->wr_pending_head;
+
+	if (likely(skb)) {
+		csk->wr_pending_head = cxgbit_skcb_tx_wr_next(skb);
+		cxgbit_skcb_tx_wr_next(skb) = NULL;
+	}
+	return skb;
+}
+
+typedef void (*cxgbit_cplhandler_func)(struct cxgbit_device *,
+				       struct sk_buff *);
+
+int cxgbit_setup_np(struct iscsi_np *, struct sockaddr_storage *);
+int cxgbit_setup_conn_digest(struct cxgbit_sock *);
+int cxgbit_accept_np(struct iscsi_np *, struct iscsi_conn *);
+void cxgbit_free_np(struct iscsi_np *);
+void cxgbit_free_conn(struct iscsi_conn *);
+extern cxgbit_cplhandler_func cxgbit_cplhandlers[NUM_CPL_CMDS];
+int cxgbit_get_login_rx(struct iscsi_conn *, struct iscsi_login *);
+int cxgbit_rx_data_ack(struct cxgbit_sock *);
+int cxgbit_l2t_send(struct cxgbit_device *, struct sk_buff *,
+		    struct l2t_entry *);
+void cxgbit_push_tx_frames(struct cxgbit_sock *);
+int cxgbit_put_login_tx(struct iscsi_conn *, struct iscsi_login *, u32);
+void *cxgbit_alloc_pdu(struct iscsi_conn *, struct iscsi_cmd *);
+int cxgbit_xmit_pdu(struct iscsi_conn *, struct iscsi_cmd *,
+		    const void *, u32);
+int cxgbit_xmit_datain_pdu(struct iscsi_conn *, struct iscsi_cmd *,
+			   struct iscsi_datain_req *,
+			   struct iscsi_datain *);
+void cxgbit_get_r2t_ttt(struct iscsi_conn *, struct iscsi_cmd *,
+			struct iscsi_r2t *);
+u32 cxgbit_send_tx_flowc_wr(struct cxgbit_sock *);
+int cxgbit_ofld_send(struct cxgbit_device *, struct sk_buff *);
+void cxgbit_get_rx_pdu(struct iscsi_conn *);
+int cxgbit_validate_params(struct iscsi_conn *);
+struct cxgbit_device *cxgbit_find_device(struct net_device *, u8 *);
+
+/* DDP */
+int cxgbit_ddp_init(struct cxgbit_device *);
+int cxgbit_setup_conn_pgidx(struct cxgbit_sock *, u32);
+int cxgbit_reserve_ttt(struct cxgbit_sock *, struct iscsi_cmd *);
+void cxgbit_release_cmd(struct iscsi_conn *, struct iscsi_cmd *);
+
+static inline
+struct cxgbi_ppm *cdev2ppm(struct cxgbit_device *cdev)
+{
+	return (struct cxgbi_ppm *)(*cdev->lldi.iscsi_ppm);
+}
+#endif /* __CXGBIT_H__ */
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_cm.c b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
new file mode 100644
index 0000000..0ae0b13
--- /dev/null
+++ b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
@@ -0,0 +1,2086 @@
+/*
+ * Copyright (c) 2016 Chelsio Communications, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/workqueue.h>
+#include <linux/skbuff.h>
+#include <linux/timer.h>
+#include <linux/notifier.h>
+#include <linux/inetdevice.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/if_vlan.h>
+
+#include <net/neighbour.h>
+#include <net/netevent.h>
+#include <net/route.h>
+#include <net/tcp.h>
+#include <net/ip6_route.h>
+#include <net/addrconf.h>
+
+#include "cxgbit.h"
+#include "clip_tbl.h"
+
+static void cxgbit_init_wr_wait(struct cxgbit_wr_wait *wr_waitp)
+{
+	wr_waitp->ret = 0;
+	reinit_completion(&wr_waitp->completion);
+}
+
+static void
+cxgbit_wake_up(struct cxgbit_wr_wait *wr_waitp, const char *func, u8 ret)
+{
+	if (ret == CPL_ERR_NONE)
+		wr_waitp->ret = 0;
+	else
+		wr_waitp->ret = -EIO;
+
+	if (wr_waitp->ret)
+		pr_err("%s: err:%u", func, ret);
+
+	complete(&wr_waitp->completion);
+}
+
+static int
+cxgbit_wait_for_reply(struct cxgbit_device *cdev,
+		      struct cxgbit_wr_wait *wr_waitp, u32 tid, u32 timeout,
+		      const char *func)
+{
+	int ret;
+
+	if (!test_bit(CDEV_STATE_UP, &cdev->flags)) {
+		wr_waitp->ret = -EIO;
+		goto out;
+	}
+
+	ret = wait_for_completion_timeout(&wr_waitp->completion, timeout * HZ);
+	if (!ret) {
+		pr_info("%s - Device %s not responding tid %u\n",
+			func, pci_name(cdev->lldi.pdev), tid);
+		wr_waitp->ret = -ETIMEDOUT;
+	}
+out:
+	if (wr_waitp->ret)
+		pr_info("%s: FW reply %d tid %u\n",
+			pci_name(cdev->lldi.pdev), wr_waitp->ret, tid);
+	return wr_waitp->ret;
+}
+
+/* Returns whether a CPL status conveys negative advice.
+ */
+static int cxgbit_is_neg_adv(unsigned int status)
+{
+	return status == CPL_ERR_RTX_NEG_ADVICE ||
+		status == CPL_ERR_PERSIST_NEG_ADVICE ||
+		status == CPL_ERR_KEEPALV_NEG_ADVICE;
+}
+
+static int cxgbit_np_hashfn(const struct cxgbit_np *cnp)
+{
+	return ((unsigned long)cnp >> 10) & (NP_INFO_HASH_SIZE - 1);
+}
+
+static struct np_info *
+cxgbit_np_hash_add(struct cxgbit_device *cdev, struct cxgbit_np *cnp,
+		   unsigned int stid)
+{
+	struct np_info *p = kzalloc(sizeof(*p), GFP_KERNEL);
+
+	if (p) {
+		int bucket = cxgbit_np_hashfn(cnp);
+
+		p->cnp = cnp;
+		p->stid = stid;
+		spin_lock(&cdev->np_lock);
+		p->next = cdev->np_hash_tab[bucket];
+		cdev->np_hash_tab[bucket] = p;
+		spin_unlock(&cdev->np_lock);
+	}
+
+	return p;
+}
+
+static int
+cxgbit_np_hash_find(struct cxgbit_device *cdev, struct cxgbit_np *cnp)
+{
+	int stid = -1, bucket = cxgbit_np_hashfn(cnp);
+	struct np_info *p;
+
+	spin_lock(&cdev->np_lock);
+	for (p = cdev->np_hash_tab[bucket]; p; p = p->next) {
+		if (p->cnp == cnp) {
+			stid = p->stid;
+			break;
+		}
+	}
+	spin_unlock(&cdev->np_lock);
+
+	return stid;
+}
+
+static int cxgbit_np_hash_del(struct cxgbit_device *cdev, struct cxgbit_np *cnp)
+{
+	int stid = -1, bucket = cxgbit_np_hashfn(cnp);
+	struct np_info *p, **prev = &cdev->np_hash_tab[bucket];
+
+	spin_lock(&cdev->np_lock);
+	for (p = *prev; p; prev = &p->next, p = p->next) {
+		if (p->cnp == cnp) {
+			stid = p->stid;
+			*prev = p->next;
+			kfree(p);
+			break;
+		}
+	}
+	spin_unlock(&cdev->np_lock);
+
+	return stid;
+}
+
+void _cxgbit_free_cnp(struct kref *kref)
+{
+	struct cxgbit_np *cnp;
+
+	cnp = container_of(kref, struct cxgbit_np, kref);
+	kfree(cnp);
+}
+
+static int
+cxgbit_create_server6(struct cxgbit_device *cdev, unsigned int stid,
+		      struct cxgbit_np *cnp)
+{
+	struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)
+				     &cnp->com.local_addr;
+	int addr_type;
+	int ret;
+
+	pr_debug("%s: dev = %s; stid = %u; sin6_port = %u\n",
+		 __func__, cdev->lldi.ports[0]->name, stid, sin6->sin6_port);
+
+	addr_type = ipv6_addr_type((const struct in6_addr *)
+				   &sin6->sin6_addr);
+	if (addr_type != IPV6_ADDR_ANY) {
+		ret = cxgb4_clip_get(cdev->lldi.ports[0],
+				     (const u32 *)&sin6->sin6_addr.s6_addr, 1);
+		if (ret) {
+			pr_err("Unable to find clip table entry. laddr %pI6. Error:%d.\n",
+			       sin6->sin6_addr.s6_addr, ret);
+			return -ENOMEM;
+		}
+	}
+
+	cxgbit_get_cnp(cnp);
+	cxgbit_init_wr_wait(&cnp->com.wr_wait);
+
+	ret = cxgb4_create_server6(cdev->lldi.ports[0],
+				   stid, &sin6->sin6_addr,
+				   sin6->sin6_port,
+				   cdev->lldi.rxq_ids[0]);
+	if (!ret)
+		ret = cxgbit_wait_for_reply(cdev, &cnp->com.wr_wait,
+					    0, 10, __func__);
+	else if (ret > 0)
+		ret = net_xmit_errno(ret);
+	else
+		cxgbit_put_cnp(cnp);
+
+	if (ret) {
+		if (ret != -ETIMEDOUT)
+			cxgb4_clip_release(cdev->lldi.ports[0],
+				   (const u32 *)&sin6->sin6_addr.s6_addr, 1);
+
+		pr_err("create server6 err %d stid %d laddr %pI6 lport %d\n",
+		       ret, stid, sin6->sin6_addr.s6_addr,
+		       ntohs(sin6->sin6_port));
+	}
+
+	return ret;
+}
+
+static int
+cxgbit_create_server4(struct cxgbit_device *cdev, unsigned int stid,
+		      struct cxgbit_np *cnp)
+{
+	struct sockaddr_in *sin = (struct sockaddr_in *)
+				   &cnp->com.local_addr;
+	int ret;
+
+	pr_debug("%s: dev = %s; stid = %u; sin_port = %u\n",
+		 __func__, cdev->lldi.ports[0]->name, stid, sin->sin_port);
+
+	cxgbit_get_cnp(cnp);
+	cxgbit_init_wr_wait(&cnp->com.wr_wait);
+
+	ret = cxgb4_create_server(cdev->lldi.ports[0],
+				  stid, sin->sin_addr.s_addr,
+				  sin->sin_port, 0,
+				  cdev->lldi.rxq_ids[0]);
+	if (!ret)
+		ret = cxgbit_wait_for_reply(cdev,
+					    &cnp->com.wr_wait,
+					    0, 10, __func__);
+	else if (ret > 0)
+		ret = net_xmit_errno(ret);
+	else
+		cxgbit_put_cnp(cnp);
+
+	if (ret)
+		pr_err("create server failed err %d stid %d laddr %pI4 lport %d\n",
+		       ret, stid, &sin->sin_addr, ntohs(sin->sin_port));
+	return ret;
+}
+
+struct cxgbit_device *cxgbit_find_device(struct net_device *ndev, u8 *port_id)
+{
+	struct cxgbit_device *cdev;
+	u8 i;
+
+	list_for_each_entry(cdev, &cdev_list_head, list) {
+		struct cxgb4_lld_info *lldi = &cdev->lldi;
+
+		for (i = 0; i < lldi->nports; i++) {
+			if (lldi->ports[i] == ndev) {
+				if (port_id)
+					*port_id = i;
+				return cdev;
+			}
+		}
+	}
+
+	return NULL;
+}
+
+static struct net_device *cxgbit_get_real_dev(struct net_device *ndev)
+{
+	if (ndev->priv_flags & IFF_BONDING) {
+		pr_err("Bond devices are not supported. Interface:%s\n",
+		       ndev->name);
+		return NULL;
+	}
+
+	if (is_vlan_dev(ndev))
+		return vlan_dev_real_dev(ndev);
+
+	return ndev;
+}
+
+static struct net_device *cxgbit_ipv4_netdev(__be32 saddr)
+{
+	struct net_device *ndev;
+
+	ndev = __ip_dev_find(&init_net, saddr, false);
+	if (!ndev)
+		return NULL;
+
+	return cxgbit_get_real_dev(ndev);
+}
+
+static struct net_device *cxgbit_ipv6_netdev(struct in6_addr *addr6)
+{
+	struct net_device *ndev = NULL;
+	bool found = false;
+
+	if (IS_ENABLED(CONFIG_IPV6)) {
+		for_each_netdev_rcu(&init_net, ndev)
+			if (ipv6_chk_addr(&init_net, addr6, ndev, 1)) {
+				found = true;
+				break;
+			}
+	}
+	if (!found)
+		return NULL;
+	return cxgbit_get_real_dev(ndev);
+}
+
+static struct cxgbit_device *cxgbit_find_np_cdev(struct cxgbit_np *cnp)
+{
+	struct sockaddr_storage *sockaddr = &cnp->com.local_addr;
+	int ss_family = sockaddr->ss_family;
+	struct net_device *ndev = NULL;
+	struct cxgbit_device *cdev = NULL;
+
+	rcu_read_lock();
+	if (ss_family == AF_INET) {
+		struct sockaddr_in *sin;
+
+		sin = (struct sockaddr_in *)sockaddr;
+		ndev = cxgbit_ipv4_netdev(sin->sin_addr.s_addr);
+	} else if (ss_family == AF_INET6) {
+		struct sockaddr_in6 *sin6;
+
+		sin6 = (struct sockaddr_in6 *)sockaddr;
+		ndev = cxgbit_ipv6_netdev(&sin6->sin6_addr);
+	}
+	if (!ndev)
+		goto out;
+
+	cdev = cxgbit_find_device(ndev, NULL);
+out:
+	rcu_read_unlock();
+	return cdev;
+}
+
+static bool cxgbit_inaddr_any(struct cxgbit_np *cnp)
+{
+	struct sockaddr_storage *sockaddr = &cnp->com.local_addr;
+	int ss_family = sockaddr->ss_family;
+	int addr_type;
+
+	if (ss_family == AF_INET) {
+		struct sockaddr_in *sin;
+
+		sin = (struct sockaddr_in *)sockaddr;
+		if (sin->sin_addr.s_addr == htonl(INADDR_ANY))
+			return true;
+	} else if (ss_family == AF_INET6) {
+		struct sockaddr_in6 *sin6;
+
+		sin6 = (struct sockaddr_in6 *)sockaddr;
+		addr_type = ipv6_addr_type((const struct in6_addr *)
+				&sin6->sin6_addr);
+		if (addr_type == IPV6_ADDR_ANY)
+			return true;
+	}
+	return false;
+}
+
+static int
+__cxgbit_setup_cdev_np(struct cxgbit_device *cdev, struct cxgbit_np *cnp)
+{
+	int stid, ret;
+	int ss_family = cnp->com.local_addr.ss_family;
+
+	if (!test_bit(CDEV_STATE_UP, &cdev->flags))
+		return -EINVAL;
+
+	stid = cxgb4_alloc_stid(cdev->lldi.tids, ss_family, cnp);
+	if (stid < 0)
+		return -EINVAL;
+
+	if (!cxgbit_np_hash_add(cdev, cnp, stid)) {
+		cxgb4_free_stid(cdev->lldi.tids, stid, ss_family);
+		return -EINVAL;
+	}
+
+	if (ss_family == AF_INET)
+		ret = cxgbit_create_server4(cdev, stid, cnp);
+	else
+		ret = cxgbit_create_server6(cdev, stid, cnp);
+
+	if (ret) {
+		if (ret != -ETIMEDOUT)
+			cxgb4_free_stid(cdev->lldi.tids, stid,
+					ss_family);
+		cxgbit_np_hash_del(cdev, cnp);
+		return ret;
+	}
+	return ret;
+}
+
+static int cxgbit_setup_cdev_np(struct cxgbit_np *cnp)
+{
+	struct cxgbit_device *cdev;
+	int ret = -1;
+
+	mutex_lock(&cdev_list_lock);
+	cdev = cxgbit_find_np_cdev(cnp);
+	if (!cdev)
+		goto out;
+
+	if (cxgbit_np_hash_find(cdev, cnp) >= 0)
+		goto out;
+
+	if (__cxgbit_setup_cdev_np(cdev, cnp))
+		goto out;
+
+	cnp->com.cdev = cdev;
+	ret = 0;
+out:
+	mutex_unlock(&cdev_list_lock);
+	return ret;
+}
+
+static int cxgbit_setup_all_np(struct cxgbit_np *cnp)
+{
+	struct cxgbit_device *cdev;
+	int ret;
+	u32 count = 0;
+
+	mutex_lock(&cdev_list_lock);
+	list_for_each_entry(cdev, &cdev_list_head, list) {
+		if (cxgbit_np_hash_find(cdev, cnp) >= 0) {
+			mutex_unlock(&cdev_list_lock);
+			return -1;
+		}
+	}
+
+	list_for_each_entry(cdev, &cdev_list_head, list) {
+		ret = __cxgbit_setup_cdev_np(cdev, cnp);
+		if (ret == -ETIMEDOUT)
+			break;
+		if (ret != 0)
+			continue;
+		count++;
+	}
+	mutex_unlock(&cdev_list_lock);
+
+	return count ? 0 : -1;
+}
+
+int cxgbit_setup_np(struct iscsi_np *np, struct sockaddr_storage *ksockaddr)
+{
+	struct cxgbit_np *cnp;
+	int ret;
+
+	if ((ksockaddr->ss_family != AF_INET) &&
+	    (ksockaddr->ss_family != AF_INET6))
+		return -EINVAL;
+
+	cnp = kzalloc(sizeof(*cnp), GFP_KERNEL);
+	if (!cnp)
+		return -ENOMEM;
+
+	init_waitqueue_head(&cnp->accept_wait);
+	init_completion(&cnp->com.wr_wait.completion);
+	init_completion(&cnp->accept_comp);
+	INIT_LIST_HEAD(&cnp->np_accept_list);
+	spin_lock_init(&cnp->np_accept_lock);
+	kref_init(&cnp->kref);
+	memcpy(&np->np_sockaddr, ksockaddr,
+	       sizeof(struct sockaddr_storage));
+	memcpy(&cnp->com.local_addr, &np->np_sockaddr,
+	       sizeof(cnp->com.local_addr));
+
+	cnp->np = np;
+	cnp->com.cdev = NULL;
+
+	if (cxgbit_inaddr_any(cnp))
+		ret = cxgbit_setup_all_np(cnp);
+	else
+		ret = cxgbit_setup_cdev_np(cnp);
+
+	if (ret) {
+		cxgbit_put_cnp(cnp);
+		return -EINVAL;
+	}
+
+	np->np_context = cnp;
+	cnp->com.state = CSK_STATE_LISTEN;
+	return 0;
+}
+
+static void
+cxgbit_set_conn_info(struct iscsi_np *np, struct iscsi_conn *conn,
+		     struct cxgbit_sock *csk)
+{
+	conn->login_family = np->np_sockaddr.ss_family;
+	conn->login_sockaddr = csk->com.remote_addr;
+	conn->local_sockaddr = csk->com.local_addr;
+}
+
+int cxgbit_accept_np(struct iscsi_np *np, struct iscsi_conn *conn)
+{
+	struct cxgbit_np *cnp = np->np_context;
+	struct cxgbit_sock *csk;
+	int ret = 0;
+
+accept_wait:
+	ret = wait_for_completion_interruptible(&cnp->accept_comp);
+	if (ret)
+		return -ENODEV;
+
+	spin_lock_bh(&np->np_thread_lock);
+	if (np->np_thread_state >= ISCSI_NP_THREAD_RESET) {
+		spin_unlock_bh(&np->np_thread_lock);
+		/**
+		 * No point in stalling here when np_thread
+		 * is in state RESET/SHUTDOWN/EXIT - bail
+		 **/
+		return -ENODEV;
+	}
+	spin_unlock_bh(&np->np_thread_lock);
+
+	spin_lock_bh(&cnp->np_accept_lock);
+	if (list_empty(&cnp->np_accept_list)) {
+		spin_unlock_bh(&cnp->np_accept_lock);
+		goto accept_wait;
+	}
+
+	csk = list_first_entry(&cnp->np_accept_list,
+			       struct cxgbit_sock,
+			       accept_node);
+
+	list_del_init(&csk->accept_node);
+	spin_unlock_bh(&cnp->np_accept_lock);
+	conn->context = csk;
+	csk->conn = conn;
+
+	cxgbit_set_conn_info(np, conn, csk);
+	return 0;
+}
+
+static int
+__cxgbit_free_cdev_np(struct cxgbit_device *cdev, struct cxgbit_np *cnp)
+{
+	int stid, ret;
+	bool ipv6 = false;
+
+	stid = cxgbit_np_hash_del(cdev, cnp);
+	if (stid < 0)
+		return -EINVAL;
+	if (!test_bit(CDEV_STATE_UP, &cdev->flags))
+		return -EINVAL;
+
+	if (cnp->np->np_sockaddr.ss_family == AF_INET6)
+		ipv6 = true;
+
+	cxgbit_get_cnp(cnp);
+	cxgbit_init_wr_wait(&cnp->com.wr_wait);
+	ret = cxgb4_remove_server(cdev->lldi.ports[0], stid,
+				  cdev->lldi.rxq_ids[0], ipv6);
+
+	if (ret > 0)
+		ret = net_xmit_errno(ret);
+
+	if (ret) {
+		cxgbit_put_cnp(cnp);
+		return ret;
+	}
+
+	ret = cxgbit_wait_for_reply(cdev, &cnp->com.wr_wait,
+				    0, 10, __func__);
+	if (ret == -ETIMEDOUT)
+		return ret;
+
+	if (ipv6 && cnp->com.cdev) {
+		struct sockaddr_in6 *sin6;
+
+		sin6 = (struct sockaddr_in6 *)&cnp->com.local_addr;
+		cxgb4_clip_release(cdev->lldi.ports[0],
+				   (const u32 *)&sin6->sin6_addr.s6_addr,
+				   1);
+	}
+
+	cxgb4_free_stid(cdev->lldi.tids, stid,
+			cnp->com.local_addr.ss_family);
+	return 0;
+}
+
+static void cxgbit_free_all_np(struct cxgbit_np *cnp)
+{
+	struct cxgbit_device *cdev;
+	int ret;
+
+	mutex_lock(&cdev_list_lock);
+	list_for_each_entry(cdev, &cdev_list_head, list) {
+		ret = __cxgbit_free_cdev_np(cdev, cnp);
+		if (ret == -ETIMEDOUT)
+			break;
+	}
+	mutex_unlock(&cdev_list_lock);
+}
+
+static void cxgbit_free_cdev_np(struct cxgbit_np *cnp)
+{
+	struct cxgbit_device *cdev;
+	bool found = false;
+
+	mutex_lock(&cdev_list_lock);
+	list_for_each_entry(cdev, &cdev_list_head, list) {
+		if (cdev == cnp->com.cdev) {
+			found = true;
+			break;
+		}
+	}
+	if (!found)
+		goto out;
+
+	__cxgbit_free_cdev_np(cdev, cnp);
+out:
+	mutex_unlock(&cdev_list_lock);
+}
+
+void cxgbit_free_np(struct iscsi_np *np)
+{
+	struct cxgbit_np *cnp = np->np_context;
+
+	cnp->com.state = CSK_STATE_DEAD;
+	if (cnp->com.cdev)
+		cxgbit_free_cdev_np(cnp);
+	else
+		cxgbit_free_all_np(cnp);
+
+	np->np_context = NULL;
+	cxgbit_put_cnp(cnp);
+}
+
+static void cxgbit_send_halfclose(struct cxgbit_sock *csk)
+{
+	struct sk_buff *skb;
+	struct cpl_close_con_req *req;
+	unsigned int len = roundup(sizeof(struct cpl_close_con_req), 16);
+
+	skb = alloc_skb(len, GFP_ATOMIC);
+	if (!skb)
+		return;
+
+	req = (struct cpl_close_con_req *)__skb_put(skb, len);
+	memset(req, 0, len);
+
+	set_wr_txq(skb, CPL_PRIORITY_DATA, csk->txq_idx);
+	INIT_TP_WR(req, csk->tid);
+	OPCODE_TID(req) = cpu_to_be32(MK_OPCODE_TID(CPL_CLOSE_CON_REQ,
+						    csk->tid));
+	req->rsvd = 0;
+
+	cxgbit_skcb_flags(skb) |= SKCBF_TX_FLAG_COMPL;
+	__skb_queue_tail(&csk->txq, skb);
+	cxgbit_push_tx_frames(csk);
+}
+
+static void cxgbit_arp_failure_discard(void *handle, struct sk_buff *skb)
+{
+	pr_debug("%s cxgbit_device %p\n", __func__, handle);
+	kfree_skb(skb);
+}
+
+static void cxgbit_abort_arp_failure(void *handle, struct sk_buff *skb)
+{
+	struct cxgbit_device *cdev = handle;
+	struct cpl_abort_req *req = cplhdr(skb);
+
+	pr_debug("%s cdev %p\n", __func__, cdev);
+	req->cmd = CPL_ABORT_NO_RST;
+	cxgbit_ofld_send(cdev, skb);
+}
+
+static int cxgbit_send_abort_req(struct cxgbit_sock *csk)
+{
+	struct cpl_abort_req *req;
+	unsigned int len = roundup(sizeof(*req), 16);
+	struct sk_buff *skb;
+
+	pr_debug("%s: csk %p tid %u; state %d\n",
+		 __func__, csk, csk->tid, csk->com.state);
+
+	__skb_queue_purge(&csk->txq);
+
+	if (!test_and_set_bit(CSK_TX_DATA_SENT, &csk->com.flags))
+		cxgbit_send_tx_flowc_wr(csk);
+
+	skb = __skb_dequeue(&csk->skbq);
+	req = (struct cpl_abort_req *)__skb_put(skb, len);
+	memset(req, 0, len);
+
+	set_wr_txq(skb, CPL_PRIORITY_DATA, csk->txq_idx);
+	t4_set_arp_err_handler(skb, csk->com.cdev, cxgbit_abort_arp_failure);
+	INIT_TP_WR(req, csk->tid);
+	OPCODE_TID(req) = cpu_to_be32(MK_OPCODE_TID(CPL_ABORT_REQ,
+						    csk->tid));
+	req->cmd = CPL_ABORT_SEND_RST;
+	return cxgbit_l2t_send(csk->com.cdev, skb, csk->l2t);
+}
+
+void cxgbit_free_conn(struct iscsi_conn *conn)
+{
+	struct cxgbit_sock *csk = conn->context;
+	bool release = false;
+
+	pr_debug("%s: state %d\n",
+		 __func__, csk->com.state);
+
+	spin_lock_bh(&csk->lock);
+	switch (csk->com.state) {
+	case CSK_STATE_ESTABLISHED:
+		if (conn->conn_state == TARG_CONN_STATE_IN_LOGOUT) {
+			csk->com.state = CSK_STATE_CLOSING;
+			cxgbit_send_halfclose(csk);
+		} else {
+			csk->com.state = CSK_STATE_ABORTING;
+			cxgbit_send_abort_req(csk);
+		}
+		break;
+	case CSK_STATE_CLOSING:
+		csk->com.state = CSK_STATE_MORIBUND;
+		cxgbit_send_halfclose(csk);
+		break;
+	case CSK_STATE_DEAD:
+		release = true;
+		break;
+	default:
+		pr_err("%s: csk %p; state %d\n",
+		       __func__, csk, csk->com.state);
+	}
+	spin_unlock_bh(&csk->lock);
+
+	if (release)
+		cxgbit_put_csk(csk);
+}
+
+static void cxgbit_set_emss(struct cxgbit_sock *csk, u16 opt)
+{
+	csk->emss = csk->com.cdev->lldi.mtus[TCPOPT_MSS_G(opt)] -
+			((csk->com.remote_addr.ss_family == AF_INET) ?
+			sizeof(struct iphdr) : sizeof(struct ipv6hdr)) -
+			sizeof(struct tcphdr);
+	csk->mss = csk->emss;
+	if (TCPOPT_TSTAMP_G(opt))
+		csk->emss -= round_up(TCPOLEN_TIMESTAMP, 4);
+	if (csk->emss < 128)
+		csk->emss = 128;
+	if (csk->emss & 7)
+		pr_info("Warning: misaligned mtu idx %u mss %u emss=%u\n",
+			TCPOPT_MSS_G(opt), csk->mss, csk->emss);
+	pr_debug("%s mss_idx %u mss %u emss=%u\n", __func__, TCPOPT_MSS_G(opt),
+		 csk->mss, csk->emss);
+}
+
+static void cxgbit_free_skb(struct cxgbit_sock *csk)
+{
+	struct sk_buff *skb;
+
+	__skb_queue_purge(&csk->txq);
+	__skb_queue_purge(&csk->rxq);
+	__skb_queue_purge(&csk->backlogq);
+	__skb_queue_purge(&csk->ppodq);
+	__skb_queue_purge(&csk->skbq);
+
+	while ((skb = cxgbit_sock_dequeue_wr(csk)))
+		kfree_skb(skb);
+
+	__kfree_skb(csk->lro_hskb);
+}
+
+void _cxgbit_free_csk(struct kref *kref)
+{
+	struct cxgbit_sock *csk;
+	struct cxgbit_device *cdev;
+
+	csk = container_of(kref, struct cxgbit_sock, kref);
+
+	pr_debug("%s csk %p state %d\n", __func__, csk, csk->com.state);
+
+	if (csk->com.local_addr.ss_family == AF_INET6) {
+		struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)
+					     &csk->com.local_addr;
+		cxgb4_clip_release(csk->com.cdev->lldi.ports[0],
+				   (const u32 *)
+				   &sin6->sin6_addr.s6_addr, 1);
+	}
+
+	cxgb4_remove_tid(csk->com.cdev->lldi.tids, 0, csk->tid);
+	dst_release(csk->dst);
+	cxgb4_l2t_release(csk->l2t);
+
+	cdev = csk->com.cdev;
+	spin_lock_bh(&cdev->cskq.lock);
+	list_del(&csk->list);
+	spin_unlock_bh(&cdev->cskq.lock);
+
+	cxgbit_free_skb(csk);
+	cxgbit_put_cdev(cdev);
+
+	kfree(csk);
+}
+
+static void
+cxgbit_get_tuple_info(struct cpl_pass_accept_req *req, int *iptype,
+		      __u8 *local_ip, __u8 *peer_ip, __be16 *local_port,
+		      __be16 *peer_port)
+{
+	u32 eth_len = ETH_HDR_LEN_G(be32_to_cpu(req->hdr_len));
+	u32 ip_len = IP_HDR_LEN_G(be32_to_cpu(req->hdr_len));
+	struct iphdr *ip = (struct iphdr *)((u8 *)(req + 1) + eth_len);
+	struct ipv6hdr *ip6 = (struct ipv6hdr *)((u8 *)(req + 1) + eth_len);
+	struct tcphdr *tcp = (struct tcphdr *)
+			      ((u8 *)(req + 1) + eth_len + ip_len);
+
+	if (ip->version == 4) {
+		pr_debug("%s saddr 0x%x daddr 0x%x sport %u dport %u\n",
+			 __func__,
+			 ntohl(ip->saddr), ntohl(ip->daddr),
+			 ntohs(tcp->source),
+			 ntohs(tcp->dest));
+		*iptype = 4;
+		memcpy(peer_ip, &ip->saddr, 4);
+		memcpy(local_ip, &ip->daddr, 4);
+	} else {
+		pr_debug("%s saddr %pI6 daddr %pI6 sport %u dport %u\n",
+			 __func__,
+			 ip6->saddr.s6_addr, ip6->daddr.s6_addr,
+			 ntohs(tcp->source),
+			 ntohs(tcp->dest));
+		*iptype = 6;
+		memcpy(peer_ip, ip6->saddr.s6_addr, 16);
+		memcpy(local_ip, ip6->daddr.s6_addr, 16);
+	}
+
+	*peer_port = tcp->source;
+	*local_port = tcp->dest;
+}
+
+static int
+cxgbit_our_interface(struct cxgbit_device *cdev, struct net_device *egress_dev)
+{
+	u8 i;
+
+	egress_dev = cxgbit_get_real_dev(egress_dev);
+	for (i = 0; i < cdev->lldi.nports; i++)
+		if (cdev->lldi.ports[i] == egress_dev)
+			return 1;
+	return 0;
+}
+
+static struct dst_entry *
+cxgbit_find_route6(struct cxgbit_device *cdev, __u8 *local_ip, __u8 *peer_ip,
+		   __be16 local_port, __be16 peer_port, u8 tos,
+		   __u32 sin6_scope_id)
+{
+	struct dst_entry *dst = NULL;
+
+	if (IS_ENABLED(CONFIG_IPV6)) {
+		struct flowi6 fl6;
+
+		memset(&fl6, 0, sizeof(fl6));
+		memcpy(&fl6.daddr, peer_ip, 16);
+		memcpy(&fl6.saddr, local_ip, 16);
+		if (ipv6_addr_type(&fl6.daddr) & IPV6_ADDR_LINKLOCAL)
+			fl6.flowi6_oif = sin6_scope_id;
+		dst = ip6_route_output(&init_net, NULL, &fl6);
+		if (!dst)
+			goto out;
+		if (!cxgbit_our_interface(cdev, ip6_dst_idev(dst)->dev) &&
+		    !(ip6_dst_idev(dst)->dev->flags & IFF_LOOPBACK)) {
+			dst_release(dst);
+			dst = NULL;
+		}
+	}
+out:
+	return dst;
+}
+
+static struct dst_entry *
+cxgbit_find_route(struct cxgbit_device *cdev, __be32 local_ip, __be32 peer_ip,
+		  __be16 local_port, __be16 peer_port, u8 tos)
+{
+	struct rtable *rt;
+	struct flowi4 fl4;
+	struct neighbour *n;
+
+	rt = ip_route_output_ports(&init_net, &fl4, NULL, peer_ip,
+				   local_ip,
+				   peer_port, local_port, IPPROTO_TCP,
+				   tos, 0);
+	if (IS_ERR(rt))
+		return NULL;
+	n = dst_neigh_lookup(&rt->dst, &peer_ip);
+	if (!n)
+		return NULL;
+	if (!cxgbit_our_interface(cdev, n->dev) &&
+	    !(n->dev->flags & IFF_LOOPBACK)) {
+		neigh_release(n);
+		dst_release(&rt->dst);
+		return NULL;
+	}
+	neigh_release(n);
+	return &rt->dst;
+}
+
+static void cxgbit_set_tcp_window(struct cxgbit_sock *csk, struct port_info *pi)
+{
+	unsigned int linkspeed;
+	u8 scale;
+
+	linkspeed = pi->link_cfg.speed;
+	scale = linkspeed / SPEED_10000;
+
+#define CXGBIT_10G_RCV_WIN (256 * 1024)
+	csk->rcv_win = CXGBIT_10G_RCV_WIN;
+	if (scale)
+		csk->rcv_win *= scale;
+
+#define CXGBIT_10G_SND_WIN (256 * 1024)
+	csk->snd_win = CXGBIT_10G_SND_WIN;
+	if (scale)
+		csk->snd_win *= scale;
+
+	pr_debug("%s snd_win %d rcv_win %d\n",
+		 __func__, csk->snd_win, csk->rcv_win);
+}
+
+#ifdef CONFIG_CHELSIO_T4_DCB
+static u8 cxgbit_get_iscsi_dcb_state(struct net_device *ndev)
+{
+	return ndev->dcbnl_ops->getstate(ndev);
+}
+
+static int cxgbit_select_priority(int pri_mask)
+{
+	if (!pri_mask)
+		return 0;
+
+	return (ffs(pri_mask) - 1);
+}
+
+static u8 cxgbit_get_iscsi_dcb_priority(struct net_device *ndev, u16 local_port)
+{
+	int ret;
+	u8 caps;
+
+	struct dcb_app iscsi_dcb_app = {
+		.protocol = local_port
+	};
+
+	ret = (int)ndev->dcbnl_ops->getcap(ndev, DCB_CAP_ATTR_DCBX, &caps);
+
+	if (ret)
+		return 0;
+
+	if (caps & DCB_CAP_DCBX_VER_IEEE) {
+		iscsi_dcb_app.selector = IEEE_8021QAZ_APP_SEL_ANY;
+
+		ret = dcb_ieee_getapp_mask(ndev, &iscsi_dcb_app);
+
+	} else if (caps & DCB_CAP_DCBX_VER_CEE) {
+		iscsi_dcb_app.selector = DCB_APP_IDTYPE_PORTNUM;
+
+		ret = dcb_getapp(ndev, &iscsi_dcb_app);
+	}
+
+	pr_info("iSCSI priority is set to %u\n", cxgbit_select_priority(ret));
+
+	return cxgbit_select_priority(ret);
+}
+#endif
+
+static int
+cxgbit_offload_init(struct cxgbit_sock *csk, int iptype, __u8 *peer_ip,
+		    u16 local_port, struct dst_entry *dst,
+		    struct cxgbit_device *cdev)
+{
+	struct neighbour *n;
+	int ret, step;
+	struct net_device *ndev;
+	u16 rxq_idx, port_id;
+#ifdef CONFIG_CHELSIO_T4_DCB
+	u8 priority = 0;
+#endif
+
+	n = dst_neigh_lookup(dst, peer_ip);
+	if (!n)
+		return -ENODEV;
+
+	rcu_read_lock();
+	ret = -ENOMEM;
+	if (n->dev->flags & IFF_LOOPBACK) {
+		if (iptype == 4)
+			ndev = cxgbit_ipv4_netdev(*(__be32 *)peer_ip);
+		else if (IS_ENABLED(CONFIG_IPV6))
+			ndev = cxgbit_ipv6_netdev((struct in6_addr *)peer_ip);
+		else
+			ndev = NULL;
+
+		if (!ndev) {
+			ret = -ENODEV;
+			goto out;
+		}
+
+		csk->l2t = cxgb4_l2t_get(cdev->lldi.l2t,
+					 n, ndev, 0);
+		if (!csk->l2t)
+			goto out;
+		csk->mtu = ndev->mtu;
+		csk->tx_chan = cxgb4_port_chan(ndev);
+		csk->smac_idx = (cxgb4_port_viid(ndev) & 0x7F) << 1;
+		step = cdev->lldi.ntxq /
+			cdev->lldi.nchan;
+		csk->txq_idx = cxgb4_port_idx(ndev) * step;
+		step = cdev->lldi.nrxq /
+			cdev->lldi.nchan;
+		csk->ctrlq_idx = cxgb4_port_idx(ndev);
+		csk->rss_qid = cdev->lldi.rxq_ids[
+				cxgb4_port_idx(ndev) * step];
+		csk->port_id = cxgb4_port_idx(ndev);
+		cxgbit_set_tcp_window(csk,
+				      (struct port_info *)netdev_priv(ndev));
+	} else {
+		ndev = cxgbit_get_real_dev(n->dev);
+		if (!ndev) {
+			ret = -ENODEV;
+			goto out;
+		}
+
+#ifdef CONFIG_CHELSIO_T4_DCB
+		if (cxgbit_get_iscsi_dcb_state(ndev))
+			priority = cxgbit_get_iscsi_dcb_priority(ndev,
+								 local_port);
+
+		csk->dcb_priority = priority;
+
+		csk->l2t = cxgb4_l2t_get(cdev->lldi.l2t, n, ndev, priority);
+#else
+		csk->l2t = cxgb4_l2t_get(cdev->lldi.l2t, n, ndev, 0);
+#endif
+		if (!csk->l2t)
+			goto out;
+		port_id = cxgb4_port_idx(ndev);
+		csk->mtu = dst_mtu(dst);
+		csk->tx_chan = cxgb4_port_chan(ndev);
+		csk->smac_idx = (cxgb4_port_viid(ndev) & 0x7F) << 1;
+		step = cdev->lldi.ntxq /
+			cdev->lldi.nports;
+		csk->txq_idx = (port_id * step) +
+				(cdev->selectq[port_id][0]++ % step);
+		csk->ctrlq_idx = cxgb4_port_idx(ndev);
+		step = cdev->lldi.nrxq /
+			cdev->lldi.nports;
+		rxq_idx = (port_id * step) +
+				(cdev->selectq[port_id][1]++ % step);
+		csk->rss_qid = cdev->lldi.rxq_ids[rxq_idx];
+		csk->port_id = port_id;
+		cxgbit_set_tcp_window(csk,
+				      (struct port_info *)netdev_priv(ndev));
+	}
+	ret = 0;
+out:
+	rcu_read_unlock();
+	neigh_release(n);
+	return ret;
+}
+
+int cxgbit_ofld_send(struct cxgbit_device *cdev, struct sk_buff *skb)
+{
+	int ret = 0;
+
+	if (!test_bit(CDEV_STATE_UP, &cdev->flags)) {
+		kfree_skb(skb);
+		pr_err("%s - device not up - dropping\n", __func__);
+		return -EIO;
+	}
+
+	ret = cxgb4_ofld_send(cdev->lldi.ports[0], skb);
+	if (ret < 0)
+		kfree_skb(skb);
+	return ret < 0 ? ret : 0;
+}
+
+static void cxgbit_release_tid(struct cxgbit_device *cdev, u32 tid)
+{
+	struct cpl_tid_release *req;
+	unsigned int len = roundup(sizeof(*req), 16);
+	struct sk_buff *skb;
+
+	skb = alloc_skb(len, GFP_ATOMIC);
+	if (!skb)
+		return;
+
+	req = (struct cpl_tid_release *)__skb_put(skb, len);
+	memset(req, 0, len);
+
+	INIT_TP_WR(req, tid);
+	OPCODE_TID(req) = cpu_to_be32(MK_OPCODE_TID(
+		   CPL_TID_RELEASE, tid));
+	set_wr_txq(skb, CPL_PRIORITY_SETUP, 0);
+	cxgbit_ofld_send(cdev, skb);
+}
+
+int
+cxgbit_l2t_send(struct cxgbit_device *cdev, struct sk_buff *skb,
+		struct l2t_entry *l2e)
+{
+	int ret = 0;
+
+	if (!test_bit(CDEV_STATE_UP, &cdev->flags)) {
+		kfree_skb(skb);
+		pr_err("%s - device not up - dropping\n", __func__);
+		return -EIO;
+	}
+
+	ret = cxgb4_l2t_send(cdev->lldi.ports[0], skb, l2e);
+	if (ret < 0)
+		kfree_skb(skb);
+	return ret < 0 ? ret : 0;
+}
+
+static void
+cxgbit_best_mtu(const unsigned short *mtus, unsigned short mtu,
+		unsigned int *idx, int use_ts, int ipv6)
+{
+	unsigned short hdr_size = (ipv6 ? sizeof(struct ipv6hdr) :
+				   sizeof(struct iphdr)) +
+				   sizeof(struct tcphdr) +
+				   (use_ts ? round_up(TCPOLEN_TIMESTAMP,
+				    4) : 0);
+	unsigned short data_size = mtu - hdr_size;
+
+	cxgb4_best_aligned_mtu(mtus, hdr_size, data_size, 8, idx);
+}
+
+static void cxgbit_send_rx_credits(struct cxgbit_sock *csk, struct sk_buff *skb)
+{
+	if (csk->com.state != CSK_STATE_ESTABLISHED) {
+		__kfree_skb(skb);
+		return;
+	}
+
+	cxgbit_ofld_send(csk->com.cdev, skb);
+}
+
+/*
+ * CPL connection rx data ack: host ->
+ * Send RX credits through an RX_DATA_ACK CPL message.
+ * Returns the number of credits sent.
+ */
+int cxgbit_rx_data_ack(struct cxgbit_sock *csk)
+{
+	struct sk_buff *skb;
+	struct cpl_rx_data_ack *req;
+	unsigned int len = roundup(sizeof(*req), 16);
+
+	skb = alloc_skb(len, GFP_KERNEL);
+	if (!skb)
+		return -1;
+
+	req = (struct cpl_rx_data_ack *)__skb_put(skb, len);
+	memset(req, 0, len);
+
+	set_wr_txq(skb, CPL_PRIORITY_ACK, csk->ctrlq_idx);
+	INIT_TP_WR(req, csk->tid);
+	OPCODE_TID(req) = cpu_to_be32(MK_OPCODE_TID(CPL_RX_DATA_ACK,
+						    csk->tid));
+	req->credit_dack = cpu_to_be32(RX_DACK_CHANGE_F | RX_DACK_MODE_V(1) |
+				       RX_CREDITS_V(csk->rx_credits));
+
+	csk->rx_credits = 0;
+
+	spin_lock_bh(&csk->lock);
+	if (csk->lock_owner) {
+		cxgbit_skcb_rx_backlog_fn(skb) = cxgbit_send_rx_credits;
+		__skb_queue_tail(&csk->backlogq, skb);
+		spin_unlock_bh(&csk->lock);
+		return 0;
+	}
+
+	cxgbit_send_rx_credits(csk, skb);
+	spin_unlock_bh(&csk->lock);
+
+	return 0;
+}
+
+#define FLOWC_WR_NPARAMS_MIN    9
+#define FLOWC_WR_NPARAMS_MAX	11
+static int cxgbit_alloc_csk_skb(struct cxgbit_sock *csk)
+{
+	struct sk_buff *skb;
+	u32 len, flowclen;
+	u8 i;
+
+	flowclen = offsetof(struct fw_flowc_wr,
+			    mnemval[FLOWC_WR_NPARAMS_MAX]);
+
+	len = max_t(u32, sizeof(struct cpl_abort_req),
+		    sizeof(struct cpl_abort_rpl));
+
+	len = max(len, flowclen);
+	len = roundup(len, 16);
+
+	for (i = 0; i < 3; i++) {
+		skb = alloc_skb(len, GFP_ATOMIC);
+		if (!skb)
+			goto out;
+		__skb_queue_tail(&csk->skbq, skb);
+	}
+
+	skb = alloc_skb(LRO_SKB_MIN_HEADROOM, GFP_ATOMIC);
+	if (!skb)
+		goto out;
+
+	memset(skb->data, 0, LRO_SKB_MIN_HEADROOM);
+	csk->lro_hskb = skb;
+
+	return 0;
+out:
+	__skb_queue_purge(&csk->skbq);
+	return -ENOMEM;
+}
+
+static u32 cxgbit_compute_wscale(u32 win)
+{
+	u32 wscale = 0;
+
+	while (wscale < 14 && (65535 << wscale) < win)
+		wscale++;
+	return wscale;
+}
+
+static void
+cxgbit_pass_accept_rpl(struct cxgbit_sock *csk, struct cpl_pass_accept_req *req)
+{
+	struct sk_buff *skb;
+	const struct tcphdr *tcph;
+	struct cpl_t5_pass_accept_rpl *rpl5;
+	unsigned int len = roundup(sizeof(*rpl5), 16);
+	unsigned int mtu_idx;
+	u64 opt0;
+	u32 opt2, hlen;
+	u32 wscale;
+	u32 win;
+
+	pr_debug("%s csk %p tid %u\n", __func__, csk, csk->tid);
+
+	skb = alloc_skb(len, GFP_ATOMIC);
+	if (!skb) {
+		cxgbit_put_csk(csk);
+		return;
+	}
+
+	rpl5 = (struct cpl_t5_pass_accept_rpl *)__skb_put(skb, len);
+	memset(rpl5, 0, len);
+
+	INIT_TP_WR(rpl5, csk->tid);
+	OPCODE_TID(rpl5) = cpu_to_be32(MK_OPCODE_TID(CPL_PASS_ACCEPT_RPL,
+						     csk->tid));
+	cxgbit_best_mtu(csk->com.cdev->lldi.mtus, csk->mtu, &mtu_idx,
+			req->tcpopt.tstamp,
+			(csk->com.remote_addr.ss_family == AF_INET) ? 0 : 1);
+	wscale = cxgbit_compute_wscale(csk->rcv_win);
+	/*
+	 * Specify the largest window that will fit in opt0. The
+	 * remainder will be specified in the rx_data_ack.
+	 */
+	win = csk->rcv_win >> 10;
+	if (win > RCV_BUFSIZ_M)
+		win = RCV_BUFSIZ_M;
+	opt0 =  TCAM_BYPASS_F |
+		WND_SCALE_V(wscale) |
+		MSS_IDX_V(mtu_idx) |
+		L2T_IDX_V(csk->l2t->idx) |
+		TX_CHAN_V(csk->tx_chan) |
+		SMAC_SEL_V(csk->smac_idx) |
+		DSCP_V(csk->tos >> 2) |
+		ULP_MODE_V(ULP_MODE_ISCSI) |
+		RCV_BUFSIZ_V(win);
+
+	opt2 = RX_CHANNEL_V(0) |
+		RSS_QUEUE_VALID_F | RSS_QUEUE_V(csk->rss_qid);
+
+	if (req->tcpopt.tstamp)
+		opt2 |= TSTAMPS_EN_F;
+	if (req->tcpopt.sack)
+		opt2 |= SACK_EN_F;
+	if (wscale)
+		opt2 |= WND_SCALE_EN_F;
+
+	hlen = ntohl(req->hdr_len);
+	tcph = (const void *)(req + 1) + ETH_HDR_LEN_G(hlen) +
+		IP_HDR_LEN_G(hlen);
+
+	if (tcph->ece && tcph->cwr)
+		opt2 |= CCTRL_ECN_V(1);
+
+	opt2 |= RX_COALESCE_V(3);
+	opt2 |= CONG_CNTRL_V(CONG_ALG_NEWRENO);
+
+	opt2 |= T5_ISS_F;
+	rpl5->iss = cpu_to_be32((prandom_u32() & ~7UL) - 1);
+
+	opt2 |= T5_OPT_2_VALID_F;
+
+	rpl5->opt0 = cpu_to_be64(opt0);
+	rpl5->opt2 = cpu_to_be32(opt2);
+	set_wr_txq(skb, CPL_PRIORITY_SETUP, csk->ctrlq_idx);
+	t4_set_arp_err_handler(skb, NULL, cxgbit_arp_failure_discard);
+	cxgbit_l2t_send(csk->com.cdev, skb, csk->l2t);
+}
+
+static void
+cxgbit_pass_accept_req(struct cxgbit_device *cdev, struct sk_buff *skb)
+{
+	struct cxgbit_sock *csk = NULL;
+	struct cxgbit_np *cnp;
+	struct cpl_pass_accept_req *req = cplhdr(skb);
+	unsigned int stid = PASS_OPEN_TID_G(ntohl(req->tos_stid));
+	struct tid_info *t = cdev->lldi.tids;
+	unsigned int tid = GET_TID(req);
+	u16 peer_mss = ntohs(req->tcpopt.mss);
+	unsigned short hdrs;
+
+	struct dst_entry *dst;
+	__u8 local_ip[16], peer_ip[16];
+	__be16 local_port, peer_port;
+	int ret;
+	int iptype;
+
+	pr_debug("%s: cdev = %p; stid = %u; tid = %u\n",
+		 __func__, cdev, stid, tid);
+
+	cnp = lookup_stid(t, stid);
+	if (!cnp) {
+		pr_err("%s connect request on invalid stid %d\n",
+		       __func__, stid);
+		goto rel_skb;
+	}
+
+	if (cnp->com.state != CSK_STATE_LISTEN) {
+		pr_err("%s - listening parent not in CSK_STATE_LISTEN\n",
+		       __func__);
+		goto reject;
+	}
+
+	csk = lookup_tid(t, tid);
+	if (csk) {
+		pr_err("%s csk not null tid %u\n",
+		       __func__, tid);
+		goto rel_skb;
+	}
+
+	cxgbit_get_tuple_info(req, &iptype, local_ip, peer_ip,
+			      &local_port, &peer_port);
+
+	/* Find output route */
+	if (iptype == 4)  {
+		pr_debug("%s parent sock %p tid %u laddr %pI4 raddr %pI4 "
+			 "lport %d rport %d peer_mss %d\n"
+			 , __func__, cnp, tid,
+			 local_ip, peer_ip, ntohs(local_port),
+			 ntohs(peer_port), peer_mss);
+		dst = cxgbit_find_route(cdev, *(__be32 *)local_ip,
+					*(__be32 *)peer_ip,
+					local_port, peer_port,
+					PASS_OPEN_TOS_G(ntohl(req->tos_stid)));
+	} else {
+		pr_debug("%s parent sock %p tid %u laddr %pI6 raddr %pI6 "
+			 "lport %d rport %d peer_mss %d\n"
+			 , __func__, cnp, tid,
+			 local_ip, peer_ip, ntohs(local_port),
+			 ntohs(peer_port), peer_mss);
+		dst = cxgbit_find_route6(cdev, local_ip, peer_ip,
+					 local_port, peer_port,
+					 PASS_OPEN_TOS_G(ntohl(req->tos_stid)),
+					 ((struct sockaddr_in6 *)
+					 &cnp->com.local_addr)->sin6_scope_id);
+	}
+	if (!dst) {
+		pr_err("%s - failed to find dst entry!\n",
+		       __func__);
+		goto reject;
+	}
+
+	csk = kzalloc(sizeof(*csk), GFP_ATOMIC);
+	if (!csk) {
+		dst_release(dst);
+		goto rel_skb;
+	}
+
+	ret = cxgbit_offload_init(csk, iptype, peer_ip, ntohs(local_port),
+				  dst, cdev);
+	if (ret) {
+		pr_err("%s - failed to allocate l2t entry!\n",
+		       __func__);
+		dst_release(dst);
+		kfree(csk);
+		goto reject;
+	}
+
+	kref_init(&csk->kref);
+	init_completion(&csk->com.wr_wait.completion);
+
+	INIT_LIST_HEAD(&csk->accept_node);
+
+	hdrs = (iptype == 4 ? sizeof(struct iphdr) : sizeof(struct ipv6hdr)) +
+		sizeof(struct tcphdr) +	(req->tcpopt.tstamp ? 12 : 0);
+	if (peer_mss && csk->mtu > (peer_mss + hdrs))
+		csk->mtu = peer_mss + hdrs;
+
+	csk->com.state = CSK_STATE_CONNECTING;
+	csk->com.cdev = cdev;
+	csk->cnp = cnp;
+	csk->tos = PASS_OPEN_TOS_G(ntohl(req->tos_stid));
+	csk->dst = dst;
+	csk->tid = tid;
+	csk->wr_cred = cdev->lldi.wr_cred -
+			DIV_ROUND_UP(sizeof(struct cpl_abort_req), 16);
+	csk->wr_max_cred = csk->wr_cred;
+	csk->wr_una_cred = 0;
+
+	if (iptype == 4) {
+		struct sockaddr_in *sin = (struct sockaddr_in *)
+					  &csk->com.local_addr;
+		sin->sin_family = AF_INET;
+		sin->sin_port = local_port;
+		sin->sin_addr.s_addr = *(__be32 *)local_ip;
+
+		sin = (struct sockaddr_in *)&csk->com.remote_addr;
+		sin->sin_family = AF_INET;
+		sin->sin_port = peer_port;
+		sin->sin_addr.s_addr = *(__be32 *)peer_ip;
+	} else {
+		struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)
+					    &csk->com.local_addr;
+
+		sin6->sin6_family = PF_INET6;
+		sin6->sin6_port = local_port;
+		memcpy(sin6->sin6_addr.s6_addr, local_ip, 16);
+		cxgb4_clip_get(cdev->lldi.ports[0],
+			       (const u32 *)&sin6->sin6_addr.s6_addr,
+			       1);
+
+		sin6 = (struct sockaddr_in6 *)&csk->com.remote_addr;
+		sin6->sin6_family = PF_INET6;
+		sin6->sin6_port = peer_port;
+		memcpy(sin6->sin6_addr.s6_addr, peer_ip, 16);
+	}
+
+	skb_queue_head_init(&csk->rxq);
+	skb_queue_head_init(&csk->txq);
+	skb_queue_head_init(&csk->ppodq);
+	skb_queue_head_init(&csk->backlogq);
+	skb_queue_head_init(&csk->skbq);
+	cxgbit_sock_reset_wr_list(csk);
+	spin_lock_init(&csk->lock);
+	init_waitqueue_head(&csk->waitq);
+	init_waitqueue_head(&csk->ack_waitq);
+	csk->lock_owner = false;
+
+	if (cxgbit_alloc_csk_skb(csk)) {
+		dst_release(dst);
+		kfree(csk);
+		goto rel_skb;
+	}
+
+	cxgbit_get_cdev(cdev);
+
+	spin_lock(&cdev->cskq.lock);
+	list_add_tail(&csk->list, &cdev->cskq.list);
+	spin_unlock(&cdev->cskq.lock);
+
+	cxgb4_insert_tid(t, csk, tid);
+	cxgbit_pass_accept_rpl(csk, req);
+	goto rel_skb;
+
+reject:
+	cxgbit_release_tid(cdev, tid);
+rel_skb:
+	__kfree_skb(skb);
+}
+
+static u32
+cxgbit_tx_flowc_wr_credits(struct cxgbit_sock *csk, u32 *nparamsp,
+			   u32 *flowclenp)
+{
+	u32 nparams, flowclen16, flowclen;
+
+	nparams = FLOWC_WR_NPARAMS_MIN;
+
+	if (csk->snd_wscale)
+		nparams++;
+
+#ifdef CONFIG_CHELSIO_T4_DCB
+	nparams++;
+#endif
+	flowclen = offsetof(struct fw_flowc_wr, mnemval[nparams]);
+	flowclen16 = DIV_ROUND_UP(flowclen, 16);
+	flowclen = flowclen16 * 16;
+	/*
+	 * Return the number of 16-byte credits used by the flowc request.
+	 * Pass back the nparams and actual flowc length if requested.
+	 */
+	if (nparamsp)
+		*nparamsp = nparams;
+	if (flowclenp)
+		*flowclenp = flowclen;
+	return flowclen16;
+}
+
+u32 cxgbit_send_tx_flowc_wr(struct cxgbit_sock *csk)
+{
+	struct cxgbit_device *cdev = csk->com.cdev;
+	struct fw_flowc_wr *flowc;
+	u32 nparams, flowclen16, flowclen;
+	struct sk_buff *skb;
+	u8 index;
+
+#ifdef CONFIG_CHELSIO_T4_DCB
+	u16 vlan = ((struct l2t_entry *)csk->l2t)->vlan;
+#endif
+
+	flowclen16 = cxgbit_tx_flowc_wr_credits(csk, &nparams, &flowclen);
+
+	skb = __skb_dequeue(&csk->skbq);
+	flowc = (struct fw_flowc_wr *)__skb_put(skb, flowclen);
+	memset(flowc, 0, flowclen);
+
+	flowc->op_to_nparams = cpu_to_be32(FW_WR_OP_V(FW_FLOWC_WR) |
+					   FW_FLOWC_WR_NPARAMS_V(nparams));
+	flowc->flowid_len16 = cpu_to_be32(FW_WR_LEN16_V(flowclen16) |
+					  FW_WR_FLOWID_V(csk->tid));
+	flowc->mnemval[0].mnemonic = FW_FLOWC_MNEM_PFNVFN;
+	flowc->mnemval[0].val = cpu_to_be32(FW_PFVF_CMD_PFN_V
+					    (csk->com.cdev->lldi.pf));
+	flowc->mnemval[1].mnemonic = FW_FLOWC_MNEM_CH;
+	flowc->mnemval[1].val = cpu_to_be32(csk->tx_chan);
+	flowc->mnemval[2].mnemonic = FW_FLOWC_MNEM_PORT;
+	flowc->mnemval[2].val = cpu_to_be32(csk->tx_chan);
+	flowc->mnemval[3].mnemonic = FW_FLOWC_MNEM_IQID;
+	flowc->mnemval[3].val = cpu_to_be32(csk->rss_qid);
+	flowc->mnemval[4].mnemonic = FW_FLOWC_MNEM_SNDNXT;
+	flowc->mnemval[4].val = cpu_to_be32(csk->snd_nxt);
+	flowc->mnemval[5].mnemonic = FW_FLOWC_MNEM_RCVNXT;
+	flowc->mnemval[5].val = cpu_to_be32(csk->rcv_nxt);
+	flowc->mnemval[6].mnemonic = FW_FLOWC_MNEM_SNDBUF;
+	flowc->mnemval[6].val = cpu_to_be32(csk->snd_win);
+	flowc->mnemval[7].mnemonic = FW_FLOWC_MNEM_MSS;
+	flowc->mnemval[7].val = cpu_to_be32(csk->emss);
+
+	flowc->mnemval[8].mnemonic = FW_FLOWC_MNEM_TXDATAPLEN_MAX;
+	if (test_bit(CDEV_ISO_ENABLE, &cdev->flags))
+		flowc->mnemval[8].val = cpu_to_be32(CXGBIT_MAX_ISO_PAYLOAD);
+	else
+		flowc->mnemval[8].val = cpu_to_be32(16384);
+
+	index = 9;
+
+	if (csk->snd_wscale) {
+		flowc->mnemval[index].mnemonic = FW_FLOWC_MNEM_RCV_SCALE;
+		flowc->mnemval[index].val = cpu_to_be32(csk->snd_wscale);
+		index++;
+	}
+
+#ifdef CONFIG_CHELSIO_T4_DCB
+	flowc->mnemval[index].mnemonic = FW_FLOWC_MNEM_DCBPRIO;
+	if (vlan == VLAN_NONE) {
+		pr_warn("csk %u without VLAN Tag on DCB Link\n", csk->tid);
+		flowc->mnemval[index].val = cpu_to_be32(0);
+	} else
+		flowc->mnemval[index].val = cpu_to_be32(
+				(vlan & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT);
+#endif
+
+	pr_debug("%s: csk %p; tx_chan = %u; rss_qid = %u; snd_seq = %u;"
+		 " rcv_seq = %u; snd_win = %u; emss = %u\n",
+		 __func__, csk, csk->tx_chan, csk->rss_qid, csk->snd_nxt,
+		 csk->rcv_nxt, csk->snd_win, csk->emss);
+	set_wr_txq(skb, CPL_PRIORITY_DATA, csk->txq_idx);
+	cxgbit_ofld_send(csk->com.cdev, skb);
+	return flowclen16;
+}
+
+int cxgbit_setup_conn_digest(struct cxgbit_sock *csk)
+{
+	struct sk_buff *skb;
+	struct cpl_set_tcb_field *req;
+	u8 hcrc = csk->submode & CXGBIT_SUBMODE_HCRC;
+	u8 dcrc = csk->submode & CXGBIT_SUBMODE_DCRC;
+	unsigned int len = roundup(sizeof(*req), 16);
+	int ret;
+
+	skb = alloc_skb(len, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	/*  set up ulp submode */
+	req = (struct cpl_set_tcb_field *)__skb_put(skb, len);
+	memset(req, 0, len);
+
+	INIT_TP_WR(req, csk->tid);
+	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_SET_TCB_FIELD, csk->tid));
+	req->reply_ctrl = htons(NO_REPLY_V(0) | QUEUENO_V(csk->rss_qid));
+	req->word_cookie = htons(0);
+	req->mask = cpu_to_be64(0x3 << 4);
+	req->val = cpu_to_be64(((hcrc ? ULP_CRC_HEADER : 0) |
+				(dcrc ? ULP_CRC_DATA : 0)) << 4);
+	set_wr_txq(skb, CPL_PRIORITY_CONTROL, csk->ctrlq_idx);
+
+	cxgbit_get_csk(csk);
+	cxgbit_init_wr_wait(&csk->com.wr_wait);
+
+	cxgbit_ofld_send(csk->com.cdev, skb);
+
+	ret = cxgbit_wait_for_reply(csk->com.cdev,
+				    &csk->com.wr_wait,
+				    csk->tid, 5, __func__);
+	if (ret)
+		return -1;
+
+	return 0;
+}
+
+int cxgbit_setup_conn_pgidx(struct cxgbit_sock *csk, u32 pg_idx)
+{
+	struct sk_buff *skb;
+	struct cpl_set_tcb_field *req;
+	unsigned int len = roundup(sizeof(*req), 16);
+	int ret;
+
+	skb = alloc_skb(len, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	req = (struct cpl_set_tcb_field *)__skb_put(skb, len);
+	memset(req, 0, len);
+
+	INIT_TP_WR(req, csk->tid);
+	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_SET_TCB_FIELD, csk->tid));
+	req->reply_ctrl = htons(NO_REPLY_V(0) | QUEUENO_V(csk->rss_qid));
+	req->word_cookie = htons(0);
+	req->mask = cpu_to_be64(0x3 << 8);
+	req->val = cpu_to_be64(pg_idx << 8);
+	set_wr_txq(skb, CPL_PRIORITY_CONTROL, csk->ctrlq_idx);
+
+	cxgbit_get_csk(csk);
+	cxgbit_init_wr_wait(&csk->com.wr_wait);
+
+	cxgbit_ofld_send(csk->com.cdev, skb);
+
+	ret = cxgbit_wait_for_reply(csk->com.cdev,
+				    &csk->com.wr_wait,
+				    csk->tid, 5, __func__);
+	if (ret)
+		return -1;
+
+	return 0;
+}
+
+static void
+cxgbit_pass_open_rpl(struct cxgbit_device *cdev, struct sk_buff *skb)
+{
+	struct cpl_pass_open_rpl *rpl = cplhdr(skb);
+	struct tid_info *t = cdev->lldi.tids;
+	unsigned int stid = GET_TID(rpl);
+	struct cxgbit_np *cnp = lookup_stid(t, stid);
+
+	pr_debug("%s: cnp = %p; stid = %u; status = %d\n",
+		 __func__, cnp, stid, rpl->status);
+
+	if (!cnp) {
+		pr_info("%s stid %d lookup failure\n", __func__, stid);
+		return;
+	}
+
+	cxgbit_wake_up(&cnp->com.wr_wait, __func__, rpl->status);
+	cxgbit_put_cnp(cnp);
+}
+
+static void
+cxgbit_close_listsrv_rpl(struct cxgbit_device *cdev, struct sk_buff *skb)
+{
+	struct cpl_close_listsvr_rpl *rpl = cplhdr(skb);
+	struct tid_info *t = cdev->lldi.tids;
+	unsigned int stid = GET_TID(rpl);
+	struct cxgbit_np *cnp = lookup_stid(t, stid);
+
+	pr_debug("%s: cnp = %p; stid = %u; status = %d\n",
+		 __func__, cnp, stid, rpl->status);
+
+	if (!cnp) {
+		pr_info("%s stid %d lookup failure\n", __func__, stid);
+		return;
+	}
+
+	cxgbit_wake_up(&cnp->com.wr_wait, __func__, rpl->status);
+	cxgbit_put_cnp(cnp);
+}
+
+static void
+cxgbit_pass_establish(struct cxgbit_device *cdev, struct sk_buff *skb)
+{
+	struct cpl_pass_establish *req = cplhdr(skb);
+	struct tid_info *t = cdev->lldi.tids;
+	unsigned int tid = GET_TID(req);
+	struct cxgbit_sock *csk;
+	struct cxgbit_np *cnp;
+	u16 tcp_opt = be16_to_cpu(req->tcp_opt);
+	u32 snd_isn = be32_to_cpu(req->snd_isn);
+	u32 rcv_isn = be32_to_cpu(req->rcv_isn);
+
+	csk = lookup_tid(t, tid);
+	if (unlikely(!csk)) {
+		pr_err("can't find connection for tid %u.\n", tid);
+		goto rel_skb;
+	}
+	cnp = csk->cnp;
+
+	pr_debug("%s: csk %p; tid %u; cnp %p\n",
+		 __func__, csk, tid, cnp);
+
+	csk->write_seq = snd_isn;
+	csk->snd_una = snd_isn;
+	csk->snd_nxt = snd_isn;
+
+	csk->rcv_nxt = rcv_isn;
+
+	if (csk->rcv_win > (RCV_BUFSIZ_M << 10))
+		csk->rx_credits = (csk->rcv_win - (RCV_BUFSIZ_M << 10));
+
+	csk->snd_wscale = TCPOPT_SND_WSCALE_G(tcp_opt);
+	cxgbit_set_emss(csk, tcp_opt);
+	dst_confirm(csk->dst);
+	csk->com.state = CSK_STATE_ESTABLISHED;
+	spin_lock_bh(&cnp->np_accept_lock);
+	list_add_tail(&csk->accept_node, &cnp->np_accept_list);
+	spin_unlock_bh(&cnp->np_accept_lock);
+	complete(&cnp->accept_comp);
+rel_skb:
+	__kfree_skb(skb);
+}
+
+static void cxgbit_queue_rx_skb(struct cxgbit_sock *csk, struct sk_buff *skb)
+{
+	cxgbit_skcb_flags(skb) = 0;
+	spin_lock_bh(&csk->rxq.lock);
+	__skb_queue_tail(&csk->rxq, skb);
+	spin_unlock_bh(&csk->rxq.lock);
+	wake_up(&csk->waitq);
+}
+
+static void cxgbit_peer_close(struct cxgbit_sock *csk, struct sk_buff *skb)
+{
+	pr_debug("%s: csk %p; tid %u; state %d\n",
+		 __func__, csk, csk->tid, csk->com.state);
+
+	switch (csk->com.state) {
+	case CSK_STATE_ESTABLISHED:
+		csk->com.state = CSK_STATE_CLOSING;
+		cxgbit_queue_rx_skb(csk, skb);
+		return;
+	case CSK_STATE_CLOSING:
+		/* simultaneous close */
+		csk->com.state = CSK_STATE_MORIBUND;
+		break;
+	case CSK_STATE_MORIBUND:
+		csk->com.state = CSK_STATE_DEAD;
+		cxgbit_put_csk(csk);
+		break;
+	case CSK_STATE_ABORTING:
+		break;
+	default:
+		pr_info("%s: cpl_peer_close in bad state %d\n",
+			__func__, csk->com.state);
+	}
+
+	__kfree_skb(skb);
+}
+
+static void cxgbit_close_con_rpl(struct cxgbit_sock *csk, struct sk_buff *skb)
+{
+	pr_debug("%s: csk %p; tid %u; state %d\n",
+		 __func__, csk, csk->tid, csk->com.state);
+
+	switch (csk->com.state) {
+	case CSK_STATE_CLOSING:
+		csk->com.state = CSK_STATE_MORIBUND;
+		break;
+	case CSK_STATE_MORIBUND:
+		csk->com.state = CSK_STATE_DEAD;
+		cxgbit_put_csk(csk);
+		break;
+	case CSK_STATE_ABORTING:
+	case CSK_STATE_DEAD:
+		break;
+	default:
+		pr_info("%s: cpl_close_con_rpl in bad state %d\n",
+			__func__, csk->com.state);
+	}
+
+	__kfree_skb(skb);
+}
+
+static void cxgbit_abort_req_rss(struct cxgbit_sock *csk, struct sk_buff *skb)
+{
+	struct cpl_abort_req_rss *hdr = cplhdr(skb);
+	unsigned int tid = GET_TID(hdr);
+	struct cpl_abort_rpl *rpl;
+	struct sk_buff *rpl_skb;
+	bool release = false;
+	bool wakeup_thread = false;
+	unsigned int len = roundup(sizeof(*rpl), 16);
+
+	pr_debug("%s: csk %p; tid %u; state %d\n",
+		 __func__, csk, tid, csk->com.state);
+
+	if (cxgbit_is_neg_adv(hdr->status)) {
+		pr_err("%s: got neg advise %d on tid %u\n",
+		       __func__, hdr->status, tid);
+		goto rel_skb;
+	}
+
+	switch (csk->com.state) {
+	case CSK_STATE_CONNECTING:
+	case CSK_STATE_MORIBUND:
+		csk->com.state = CSK_STATE_DEAD;
+		release = true;
+		break;
+	case CSK_STATE_ESTABLISHED:
+		csk->com.state = CSK_STATE_DEAD;
+		wakeup_thread = true;
+		break;
+	case CSK_STATE_CLOSING:
+		csk->com.state = CSK_STATE_DEAD;
+		if (!csk->conn)
+			release = true;
+		break;
+	case CSK_STATE_ABORTING:
+		break;
+	default:
+		pr_info("%s: cpl_abort_req_rss in bad state %d\n",
+			__func__, csk->com.state);
+		csk->com.state = CSK_STATE_DEAD;
+	}
+
+	__skb_queue_purge(&csk->txq);
+
+	if (!test_and_set_bit(CSK_TX_DATA_SENT, &csk->com.flags))
+		cxgbit_send_tx_flowc_wr(csk);
+
+	rpl_skb = __skb_dequeue(&csk->skbq);
+	set_wr_txq(skb, CPL_PRIORITY_DATA, csk->txq_idx);
+
+	rpl = (struct cpl_abort_rpl *)__skb_put(rpl_skb, len);
+	memset(rpl, 0, len);
+
+	INIT_TP_WR(rpl, csk->tid);
+	OPCODE_TID(rpl) = cpu_to_be32(MK_OPCODE_TID(CPL_ABORT_RPL, tid));
+	rpl->cmd = CPL_ABORT_NO_RST;
+	cxgbit_ofld_send(csk->com.cdev, rpl_skb);
+
+	if (wakeup_thread) {
+		cxgbit_queue_rx_skb(csk, skb);
+		return;
+	}
+
+	if (release)
+		cxgbit_put_csk(csk);
+rel_skb:
+	__kfree_skb(skb);
+}
+
+static void cxgbit_abort_rpl_rss(struct cxgbit_sock *csk, struct sk_buff *skb)
+{
+	pr_debug("%s: csk %p; tid %u; state %d\n",
+		 __func__, csk, csk->tid, csk->com.state);
+
+	switch (csk->com.state) {
+	case CSK_STATE_ABORTING:
+		csk->com.state = CSK_STATE_DEAD;
+		cxgbit_put_csk(csk);
+		break;
+	default:
+		pr_info("%s: cpl_abort_rpl_rss in state %d\n",
+			__func__, csk->com.state);
+	}
+
+	__kfree_skb(skb);
+}
+
+static bool cxgbit_credit_err(const struct cxgbit_sock *csk)
+{
+	const struct sk_buff *skb = csk->wr_pending_head;
+	u32 credit = 0;
+
+	if (unlikely(csk->wr_cred > csk->wr_max_cred)) {
+		pr_err("csk 0x%p, tid %u, credit %u > %u\n",
+		       csk, csk->tid, csk->wr_cred, csk->wr_max_cred);
+		return true;
+	}
+
+	while (skb) {
+		credit += skb->csum;
+		skb = cxgbit_skcb_tx_wr_next(skb);
+	}
+
+	if (unlikely((csk->wr_cred + credit) != csk->wr_max_cred)) {
+		pr_err("csk 0x%p, tid %u, credit %u + %u != %u.\n",
+		       csk, csk->tid, csk->wr_cred,
+		       credit, csk->wr_max_cred);
+
+		return true;
+	}
+
+	return false;
+}
+
+static void cxgbit_fw4_ack(struct cxgbit_sock *csk, struct sk_buff *skb)
+{
+	struct cpl_fw4_ack *rpl = (struct cpl_fw4_ack *)cplhdr(skb);
+	u32 credits = rpl->credits;
+	u32 snd_una = ntohl(rpl->snd_una);
+
+	csk->wr_cred += credits;
+	if (csk->wr_una_cred > (csk->wr_max_cred - csk->wr_cred))
+		csk->wr_una_cred = csk->wr_max_cred - csk->wr_cred;
+
+	while (credits) {
+		struct sk_buff *p = cxgbit_sock_peek_wr(csk);
+
+		if (unlikely(!p)) {
+			pr_err("csk 0x%p,%u, cr %u,%u+%u, empty.\n",
+			       csk, csk->tid, credits,
+			       csk->wr_cred, csk->wr_una_cred);
+			break;
+		}
+
+		if (unlikely(credits < p->csum)) {
+			pr_warn("csk 0x%p,%u, cr %u,%u+%u, < %u.\n",
+				csk,  csk->tid,
+				credits, csk->wr_cred, csk->wr_una_cred,
+				p->csum);
+			p->csum -= credits;
+			break;
+		}
+
+		cxgbit_sock_dequeue_wr(csk);
+		credits -= p->csum;
+		kfree_skb(p);
+	}
+
+	if (unlikely(cxgbit_credit_err(csk))) {
+		cxgbit_queue_rx_skb(csk, skb);
+		return;
+	}
+
+	if (rpl->seq_vld & CPL_FW4_ACK_FLAGS_SEQVAL) {
+		if (unlikely(before(snd_una, csk->snd_una))) {
+			pr_warn("csk 0x%p,%u, snd_una %u/%u.",
+				csk, csk->tid, snd_una,
+				csk->snd_una);
+			goto rel_skb;
+		}
+
+		if (csk->snd_una != snd_una) {
+			csk->snd_una = snd_una;
+			dst_confirm(csk->dst);
+			wake_up(&csk->ack_waitq);
+		}
+	}
+
+	if (skb_queue_len(&csk->txq))
+		cxgbit_push_tx_frames(csk);
+
+rel_skb:
+	__kfree_skb(skb);
+}
+
+static void cxgbit_set_tcb_rpl(struct cxgbit_device *cdev, struct sk_buff *skb)
+{
+	struct cxgbit_sock *csk;
+	struct cpl_set_tcb_rpl *rpl = (struct cpl_set_tcb_rpl *)skb->data;
+	unsigned int tid = GET_TID(rpl);
+	struct cxgb4_lld_info *lldi = &cdev->lldi;
+	struct tid_info *t = lldi->tids;
+
+	csk = lookup_tid(t, tid);
+	if (unlikely(!csk))
+		pr_err("can't find connection for tid %u.\n", tid);
+	else
+		cxgbit_wake_up(&csk->com.wr_wait, __func__, rpl->status);
+
+	cxgbit_put_csk(csk);
+}
+
+static void cxgbit_rx_data(struct cxgbit_device *cdev, struct sk_buff *skb)
+{
+	struct cxgbit_sock *csk;
+	struct cpl_rx_data *cpl = cplhdr(skb);
+	unsigned int tid = GET_TID(cpl);
+	struct cxgb4_lld_info *lldi = &cdev->lldi;
+	struct tid_info *t = lldi->tids;
+
+	csk = lookup_tid(t, tid);
+	if (unlikely(!csk)) {
+		pr_err("can't find conn. for tid %u.\n", tid);
+		goto rel_skb;
+	}
+
+	cxgbit_queue_rx_skb(csk, skb);
+	return;
+rel_skb:
+	__kfree_skb(skb);
+}
+
+static void
+__cxgbit_process_rx_cpl(struct cxgbit_sock *csk, struct sk_buff *skb)
+{
+	spin_lock(&csk->lock);
+	if (csk->lock_owner) {
+		__skb_queue_tail(&csk->backlogq, skb);
+		spin_unlock(&csk->lock);
+		return;
+	}
+
+	cxgbit_skcb_rx_backlog_fn(skb)(csk, skb);
+	spin_unlock(&csk->lock);
+}
+
+static void cxgbit_process_rx_cpl(struct cxgbit_sock *csk, struct sk_buff *skb)
+{
+	cxgbit_get_csk(csk);
+	__cxgbit_process_rx_cpl(csk, skb);
+	cxgbit_put_csk(csk);
+}
+
+static void cxgbit_rx_cpl(struct cxgbit_device *cdev, struct sk_buff *skb)
+{
+	struct cxgbit_sock *csk;
+	struct cpl_tx_data *cpl = cplhdr(skb);
+	struct cxgb4_lld_info *lldi = &cdev->lldi;
+	struct tid_info *t = lldi->tids;
+	unsigned int tid = GET_TID(cpl);
+	u8 opcode = cxgbit_skcb_rx_opcode(skb);
+	bool ref = true;
+
+	switch (opcode) {
+	case CPL_FW4_ACK:
+			cxgbit_skcb_rx_backlog_fn(skb) = cxgbit_fw4_ack;
+			ref = false;
+			break;
+	case CPL_PEER_CLOSE:
+			cxgbit_skcb_rx_backlog_fn(skb) = cxgbit_peer_close;
+			break;
+	case CPL_CLOSE_CON_RPL:
+			cxgbit_skcb_rx_backlog_fn(skb) = cxgbit_close_con_rpl;
+			break;
+	case CPL_ABORT_REQ_RSS:
+			cxgbit_skcb_rx_backlog_fn(skb) = cxgbit_abort_req_rss;
+			break;
+	case CPL_ABORT_RPL_RSS:
+			cxgbit_skcb_rx_backlog_fn(skb) = cxgbit_abort_rpl_rss;
+			break;
+	default:
+		goto rel_skb;
+	}
+
+	csk = lookup_tid(t, tid);
+	if (unlikely(!csk)) {
+		pr_err("can't find conn. for tid %u.\n", tid);
+		goto rel_skb;
+	}
+
+	if (ref)
+		cxgbit_process_rx_cpl(csk, skb);
+	else
+		__cxgbit_process_rx_cpl(csk, skb);
+
+	return;
+rel_skb:
+	__kfree_skb(skb);
+}
+
+cxgbit_cplhandler_func cxgbit_cplhandlers[NUM_CPL_CMDS] = {
+	[CPL_PASS_OPEN_RPL]	= cxgbit_pass_open_rpl,
+	[CPL_CLOSE_LISTSRV_RPL] = cxgbit_close_listsrv_rpl,
+	[CPL_PASS_ACCEPT_REQ]	= cxgbit_pass_accept_req,
+	[CPL_PASS_ESTABLISH]	= cxgbit_pass_establish,
+	[CPL_SET_TCB_RPL]	= cxgbit_set_tcb_rpl,
+	[CPL_RX_DATA]		= cxgbit_rx_data,
+	[CPL_FW4_ACK]		= cxgbit_rx_cpl,
+	[CPL_PEER_CLOSE]	= cxgbit_rx_cpl,
+	[CPL_CLOSE_CON_RPL]	= cxgbit_rx_cpl,
+	[CPL_ABORT_REQ_RSS]	= cxgbit_rx_cpl,
+	[CPL_ABORT_RPL_RSS]	= cxgbit_rx_cpl,
+};
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
new file mode 100644
index 0000000..5d78bdb
--- /dev/null
+++ b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
@@ -0,0 +1,325 @@
+/*
+ * Copyright (c) 2016 Chelsio Communications, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "cxgbit.h"
+
+static void
+cxgbit_set_one_ppod(struct cxgbi_pagepod *ppod,
+		    struct cxgbi_task_tag_info *ttinfo,
+		    struct scatterlist **sg_pp, unsigned int *sg_off)
+{
+	struct scatterlist *sg = sg_pp ? *sg_pp : NULL;
+	unsigned int offset = sg_off ? *sg_off : 0;
+	dma_addr_t addr = 0UL;
+	unsigned int len = 0;
+	int i;
+
+	memcpy(ppod, &ttinfo->hdr, sizeof(struct cxgbi_pagepod_hdr));
+
+	if (sg) {
+		addr = sg_dma_address(sg);
+		len = sg_dma_len(sg);
+	}
+
+	for (i = 0; i < PPOD_PAGES_MAX; i++) {
+		if (sg) {
+			ppod->addr[i] = cpu_to_be64(addr + offset);
+			offset += PAGE_SIZE;
+			if (offset == (len + sg->offset)) {
+				offset = 0;
+				sg = sg_next(sg);
+				if (sg) {
+					addr = sg_dma_address(sg);
+					len = sg_dma_len(sg);
+				}
+			}
+		} else {
+			ppod->addr[i] = 0ULL;
+		}
+	}
+
+	/*
+	 * the fifth address needs to be repeated in the next ppod, so do
+	 * not move sg
+	 */
+	if (sg_pp) {
+		*sg_pp = sg;
+		*sg_off = offset;
+	}
+
+	if (offset == len) {
+		offset = 0;
+		if (sg) {
+			sg = sg_next(sg);
+			if (sg)
+				addr = sg_dma_address(sg);
+		}
+	}
+	ppod->addr[i] = sg ? cpu_to_be64(addr + offset) : 0ULL;
+}
+
+static struct sk_buff *
+cxgbit_ppod_init_idata(struct cxgbit_device *cdev, struct cxgbi_ppm *ppm,
+		       unsigned int idx, unsigned int npods, unsigned int tid)
+{
+	struct ulp_mem_io *req;
+	struct ulptx_idata *idata;
+	unsigned int pm_addr = (idx << PPOD_SIZE_SHIFT) + ppm->llimit;
+	unsigned int dlen = npods << PPOD_SIZE_SHIFT;
+	unsigned int wr_len = roundup(sizeof(struct ulp_mem_io) +
+				sizeof(struct ulptx_idata) + dlen, 16);
+	struct sk_buff *skb;
+
+	skb  = alloc_skb(wr_len, GFP_KERNEL);
+	if (!skb)
+		return NULL;
+
+	req = (struct ulp_mem_io *)__skb_put(skb, wr_len);
+	INIT_ULPTX_WR(req, wr_len, 0, tid);
+	req->wr.wr_hi = htonl(FW_WR_OP_V(FW_ULPTX_WR) |
+		FW_WR_ATOMIC_V(0));
+	req->cmd = htonl(ULPTX_CMD_V(ULP_TX_MEM_WRITE) |
+		ULP_MEMIO_ORDER_V(0) |
+		T5_ULP_MEMIO_IMM_V(1));
+	req->dlen = htonl(ULP_MEMIO_DATA_LEN_V(dlen >> 5));
+	req->lock_addr = htonl(ULP_MEMIO_ADDR_V(pm_addr >> 5));
+	req->len16 = htonl(DIV_ROUND_UP(wr_len - sizeof(req->wr), 16));
+
+	idata = (struct ulptx_idata *)(req + 1);
+	idata->cmd_more = htonl(ULPTX_CMD_V(ULP_TX_SC_IMM));
+	idata->len = htonl(dlen);
+
+	return skb;
+}
+
+static int
+cxgbit_ppod_write_idata(struct cxgbi_ppm *ppm, struct cxgbit_sock *csk,
+			struct cxgbi_task_tag_info *ttinfo, unsigned int idx,
+			unsigned int npods, struct scatterlist **sg_pp,
+			unsigned int *sg_off)
+{
+	struct cxgbit_device *cdev = csk->com.cdev;
+	struct sk_buff *skb;
+	struct ulp_mem_io *req;
+	struct ulptx_idata *idata;
+	struct cxgbi_pagepod *ppod;
+	unsigned int i;
+
+	skb = cxgbit_ppod_init_idata(cdev, ppm, idx, npods, csk->tid);
+	if (!skb)
+		return -ENOMEM;
+
+	req = (struct ulp_mem_io *)skb->data;
+	idata = (struct ulptx_idata *)(req + 1);
+	ppod = (struct cxgbi_pagepod *)(idata + 1);
+
+	for (i = 0; i < npods; i++, ppod++)
+		cxgbit_set_one_ppod(ppod, ttinfo, sg_pp, sg_off);
+
+	__skb_queue_tail(&csk->ppodq, skb);
+
+	return 0;
+}
+
+static int
+cxgbit_ddp_set_map(struct cxgbi_ppm *ppm, struct cxgbit_sock *csk,
+		   struct cxgbi_task_tag_info *ttinfo)
+{
+	unsigned int pidx = ttinfo->idx;
+	unsigned int npods = ttinfo->npods;
+	unsigned int i, cnt;
+	struct scatterlist *sg = ttinfo->sgl;
+	unsigned int offset = 0;
+	int ret = 0;
+
+	for (i = 0; i < npods; i += cnt, pidx += cnt) {
+		cnt = npods - i;
+
+		if (cnt > ULPMEM_IDATA_MAX_NPPODS)
+			cnt = ULPMEM_IDATA_MAX_NPPODS;
+
+		ret = cxgbit_ppod_write_idata(ppm, csk, ttinfo, pidx, cnt,
+					      &sg, &offset);
+		if (ret < 0)
+			break;
+	}
+
+	return ret;
+}
+
+static int cxgbit_ddp_sgl_check(struct scatterlist *sg,
+				unsigned int nents)
+{
+	unsigned int last_sgidx = nents - 1;
+	unsigned int i;
+
+	for (i = 0; i < nents; i++, sg = sg_next(sg)) {
+		unsigned int len = sg->length + sg->offset;
+
+		if ((sg->offset & 0x3) || (i && sg->offset) ||
+		    ((i != last_sgidx) && (len != PAGE_SIZE))) {
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int
+cxgbit_ddp_reserve(struct cxgbit_sock *csk, struct cxgbi_task_tag_info *ttinfo,
+		   unsigned int xferlen)
+{
+	struct cxgbit_device *cdev = csk->com.cdev;
+	struct cxgbi_ppm *ppm = cdev2ppm(cdev);
+	struct scatterlist *sgl = ttinfo->sgl;
+	unsigned int sgcnt = ttinfo->nents;
+	unsigned int sg_offset = sgl->offset;
+	int ret;
+
+	if ((xferlen < DDP_THRESHOLD) || (!sgcnt)) {
+		pr_debug("ppm 0x%p, pgidx %u, xfer %u, sgcnt %u, NO ddp.\n",
+			 ppm, ppm->tformat.pgsz_idx_dflt,
+			 xferlen, ttinfo->nents);
+		return -EINVAL;
+	}
+
+	if (cxgbit_ddp_sgl_check(sgl, sgcnt) < 0)
+		return -EINVAL;
+
+	ttinfo->nr_pages = (xferlen + sgl->offset +
+			    (1 << PAGE_SHIFT) - 1) >> PAGE_SHIFT;
+
+	/*
+	 * the ddp tag will be used for the ttt in the outgoing r2t pdu
+	 */
+	ret = cxgbi_ppm_ppods_reserve(ppm, ttinfo->nr_pages, 0, &ttinfo->idx,
+				      &ttinfo->tag, 0);
+	if (ret < 0)
+		return ret;
+	ttinfo->npods = ret;
+
+	sgl->offset = 0;
+	ret = dma_map_sg(&ppm->pdev->dev, sgl, sgcnt, DMA_FROM_DEVICE);
+	sgl->offset = sg_offset;
+	if (!ret) {
+		pr_info("%s: 0x%x, xfer %u, sgl %u dma mapping err.\n",
+			__func__, 0, xferlen, sgcnt);
+		goto rel_ppods;
+	}
+
+	cxgbi_ppm_make_ppod_hdr(ppm, ttinfo->tag, csk->tid, sgl->offset,
+				xferlen, &ttinfo->hdr);
+
+	ret = cxgbit_ddp_set_map(ppm, csk, ttinfo);
+	if (ret < 0) {
+		__skb_queue_purge(&csk->ppodq);
+		dma_unmap_sg(&ppm->pdev->dev, sgl, sgcnt, DMA_FROM_DEVICE);
+		goto rel_ppods;
+	}
+
+	return 0;
+
+rel_ppods:
+	cxgbi_ppm_ppod_release(ppm, ttinfo->idx);
+	return -EINVAL;
+}
+
+void
+cxgbit_get_r2t_ttt(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
+		   struct iscsi_r2t *r2t)
+{
+	struct cxgbit_sock *csk = conn->context;
+	struct cxgbit_device *cdev = csk->com.cdev;
+	struct cxgbit_cmd *ccmd = iscsit_priv_cmd(cmd);
+	struct cxgbi_task_tag_info *ttinfo = &ccmd->ttinfo;
+	int ret = -EINVAL;
+
+	if ((!ccmd->setup_ddp) ||
+	    (!test_bit(CSK_DDP_ENABLE, &csk->com.flags)))
+		goto out;
+
+	ccmd->setup_ddp = false;
+
+	ttinfo->sgl = cmd->se_cmd.t_data_sg;
+	ttinfo->nents = cmd->se_cmd.t_data_nents;
+
+	ret = cxgbit_ddp_reserve(csk, ttinfo, cmd->se_cmd.data_length);
+	if (ret < 0) {
+		pr_info("csk 0x%p, cmd 0x%p, xfer len %u, sgcnt %u no ddp.\n",
+			csk, cmd, cmd->se_cmd.data_length, ttinfo->nents);
+
+		ttinfo->sgl = NULL;
+		ttinfo->nents = 0;
+	} else {
+		ccmd->release = true;
+	}
+out:
+	pr_debug("cdev 0x%p, cmd 0x%p, tag 0x%x\n", cdev, cmd, ttinfo->tag);
+	r2t->targ_xfer_tag = ttinfo->tag;
+}
+
+void cxgbit_release_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
+{
+	struct cxgbit_cmd *ccmd = iscsit_priv_cmd(cmd);
+
+	if (ccmd->release) {
+		struct cxgbi_task_tag_info *ttinfo = &ccmd->ttinfo;
+
+		if (ttinfo->sgl) {
+			struct cxgbit_sock *csk = conn->context;
+			struct cxgbit_device *cdev = csk->com.cdev;
+			struct cxgbi_ppm *ppm = cdev2ppm(cdev);
+
+			cxgbi_ppm_ppod_release(ppm, ttinfo->idx);
+
+			dma_unmap_sg(&ppm->pdev->dev, ttinfo->sgl,
+				     ttinfo->nents, DMA_FROM_DEVICE);
+		} else {
+			put_page(sg_page(&ccmd->sg));
+		}
+
+		ccmd->release = false;
+	}
+}
+
+int cxgbit_ddp_init(struct cxgbit_device *cdev)
+{
+	struct cxgb4_lld_info *lldi = &cdev->lldi;
+	struct net_device *ndev = cdev->lldi.ports[0];
+	struct cxgbi_tag_format tformat;
+	unsigned int ppmax;
+	int ret, i;
+
+	if (!lldi->vr->iscsi.size) {
+		pr_warn("%s, iscsi NOT enabled, check config!\n", ndev->name);
+		return -EACCES;
+	}
+
+	ppmax = lldi->vr->iscsi.size >> PPOD_SIZE_SHIFT;
+
+	memset(&tformat, 0, sizeof(struct cxgbi_tag_format));
+	for (i = 0; i < 4; i++)
+		tformat.pgsz_order[i] = (lldi->iscsi_pgsz_order >> (i << 3))
+					 & 0xF;
+	cxgbi_tagmask_check(lldi->iscsi_tagmask, &tformat);
+
+	ret = cxgbi_ppm_init(lldi->iscsi_ppm, cdev->lldi.ports[0],
+			     cdev->lldi.pdev, &cdev->lldi, &tformat,
+			     ppmax, lldi->iscsi_llimit,
+			     lldi->vr->iscsi.start, 2);
+	if (ret >= 0) {
+		struct cxgbi_ppm *ppm = (struct cxgbi_ppm *)(*lldi->iscsi_ppm);
+
+		if ((ppm->tformat.pgsz_idx_dflt < DDP_PGIDX_MAX) &&
+		    (ppm->ppmax >= 1024))
+			set_bit(CDEV_DDP_ENABLE, &cdev->flags);
+		ret = 0;
+	}
+
+	return ret;
+}
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_lro.h b/drivers/target/iscsi/cxgbit/cxgbit_lro.h
new file mode 100644
index 0000000..28c11bd
--- /dev/null
+++ b/drivers/target/iscsi/cxgbit/cxgbit_lro.h
@@ -0,0 +1,72 @@
+/*
+ * Copyright (c) 2016 Chelsio Communications, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ *
+ */
+
+#ifndef	__CXGBIT_LRO_H__
+#define	__CXGBIT_LRO_H__
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/skbuff.h>
+
+#define LRO_FLUSH_LEN_MAX	65535
+
+struct cxgbit_lro_cb {
+	struct cxgbit_sock *csk;
+	u32 pdu_totallen;
+	u32 offset;
+	u8 pdu_idx;
+	bool complete;
+};
+
+enum cxgbit_pducb_flags {
+	PDUCBF_RX_HDR		= (1 << 0), /* received pdu header */
+	PDUCBF_RX_DATA		= (1 << 1), /* received pdu payload */
+	PDUCBF_RX_STATUS	= (1 << 2), /* received ddp status */
+	PDUCBF_RX_DATA_DDPD	= (1 << 3), /* pdu payload ddp'd */
+	PDUCBF_RX_HCRC_ERR	= (1 << 4), /* header digest error */
+	PDUCBF_RX_DCRC_ERR	= (1 << 5), /* data digest error */
+};
+
+struct cxgbit_lro_pdu_cb {
+	u8 flags;
+	u8 frags;
+	u8 hfrag_idx;
+	u8 nr_dfrags;
+	u8 dfrag_idx;
+	bool complete;
+	u32 seq;
+	u32 pdulen;
+	u32 hlen;
+	u32 dlen;
+	u32 doffset;
+	u32 ddigest;
+	void *hdr;
+};
+
+#define LRO_SKB_MAX_HEADROOM  \
+		(sizeof(struct cxgbit_lro_cb) + \
+		 (MAX_SKB_FRAGS * sizeof(struct cxgbit_lro_pdu_cb)))
+
+#define LRO_SKB_MIN_HEADROOM  \
+		(sizeof(struct cxgbit_lro_cb) + \
+		 sizeof(struct cxgbit_lro_pdu_cb))
+
+#define cxgbit_skb_lro_cb(skb)	((struct cxgbit_lro_cb *)skb->data)
+#define cxgbit_skb_lro_pdu_cb(skb, i)	\
+	((struct cxgbit_lro_pdu_cb *)(skb->data + sizeof(struct cxgbit_lro_cb) \
+		+ (i * sizeof(struct cxgbit_lro_pdu_cb))))
+
+#define CPL_RX_ISCSI_DDP_STATUS_DDP_SHIFT	16 /* ddp'able */
+#define CPL_RX_ISCSI_DDP_STATUS_PAD_SHIFT	19 /* pad error */
+#define CPL_RX_ISCSI_DDP_STATUS_HCRC_SHIFT	20 /* hcrc error */
+#define CPL_RX_ISCSI_DDP_STATUS_DCRC_SHIFT	21 /* dcrc error */
+
+#endif	/*__CXGBIT_LRO_H_*/
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_main.c b/drivers/target/iscsi/cxgbit/cxgbit_main.c
new file mode 100644
index 0000000..9cf8430
--- /dev/null
+++ b/drivers/target/iscsi/cxgbit/cxgbit_main.c
@@ -0,0 +1,703 @@
+/*
+ * Copyright (c) 2016 Chelsio Communications, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define DRV_NAME "cxgbit"
+#define DRV_VERSION "1.0.0-ko"
+#define pr_fmt(fmt) DRV_NAME ": " fmt
+
+#include "cxgbit.h"
+
+#ifdef CONFIG_CHELSIO_T4_DCB
+#include <net/dcbevent.h>
+#include "cxgb4_dcb.h"
+#endif
+
+LIST_HEAD(cdev_list_head);
+/* cdev list lock */
+DEFINE_MUTEX(cdev_list_lock);
+
+void _cxgbit_free_cdev(struct kref *kref)
+{
+	struct cxgbit_device *cdev;
+
+	cdev = container_of(kref, struct cxgbit_device, kref);
+	kfree(cdev);
+}
+
+static void cxgbit_set_mdsl(struct cxgbit_device *cdev)
+{
+	struct cxgb4_lld_info *lldi = &cdev->lldi;
+	u32 mdsl;
+
+#define ULP2_MAX_PKT_LEN 16224
+#define ISCSI_PDU_NONPAYLOAD_LEN 312
+	mdsl = min_t(u32, lldi->iscsi_iolen - ISCSI_PDU_NONPAYLOAD_LEN,
+		     ULP2_MAX_PKT_LEN - ISCSI_PDU_NONPAYLOAD_LEN);
+	mdsl = min_t(u32, mdsl, 8192);
+	mdsl = min_t(u32, mdsl, (MAX_SKB_FRAGS - 1) * PAGE_SIZE);
+
+	cdev->mdsl = mdsl;
+}
+
+static void *cxgbit_uld_add(const struct cxgb4_lld_info *lldi)
+{
+	struct cxgbit_device *cdev;
+
+	if (is_t4(lldi->adapter_type))
+		return ERR_PTR(-ENODEV);
+
+	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
+	if (!cdev)
+		return ERR_PTR(-ENOMEM);
+
+	kref_init(&cdev->kref);
+
+	cdev->lldi = *lldi;
+
+	cxgbit_set_mdsl(cdev);
+
+	if (cxgbit_ddp_init(cdev) < 0) {
+		kfree(cdev);
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (!test_bit(CDEV_DDP_ENABLE, &cdev->flags))
+		pr_info("cdev %s ddp init failed\n",
+			pci_name(lldi->pdev));
+
+	if (lldi->fw_vers >= 0x10d2b00)
+		set_bit(CDEV_ISO_ENABLE, &cdev->flags);
+
+	spin_lock_init(&cdev->cskq.lock);
+	INIT_LIST_HEAD(&cdev->cskq.list);
+
+	mutex_lock(&cdev_list_lock);
+	list_add_tail(&cdev->list, &cdev_list_head);
+	mutex_unlock(&cdev_list_lock);
+
+	pr_info("cdev %s added for iSCSI target transport\n",
+		pci_name(lldi->pdev));
+
+	return cdev;
+}
+
+static void cxgbit_close_conn(struct cxgbit_device *cdev)
+{
+	struct cxgbit_sock *csk;
+	struct sk_buff *skb;
+	bool wakeup_thread = false;
+
+	spin_lock_bh(&cdev->cskq.lock);
+	list_for_each_entry(csk, &cdev->cskq.list, list) {
+		skb = alloc_skb(0, GFP_ATOMIC);
+		if (!skb)
+			continue;
+
+		spin_lock_bh(&csk->rxq.lock);
+		__skb_queue_tail(&csk->rxq, skb);
+		if (skb_queue_len(&csk->rxq) == 1)
+			wakeup_thread = true;
+		spin_unlock_bh(&csk->rxq.lock);
+
+		if (wakeup_thread) {
+			wake_up(&csk->waitq);
+			wakeup_thread = false;
+		}
+	}
+	spin_unlock_bh(&cdev->cskq.lock);
+}
+
+static void cxgbit_detach_cdev(struct cxgbit_device *cdev)
+{
+	bool free_cdev = false;
+
+	spin_lock_bh(&cdev->cskq.lock);
+	if (list_empty(&cdev->cskq.list))
+		free_cdev = true;
+	spin_unlock_bh(&cdev->cskq.lock);
+
+	if (free_cdev) {
+		mutex_lock(&cdev_list_lock);
+		list_del(&cdev->list);
+		mutex_unlock(&cdev_list_lock);
+
+		cxgbit_put_cdev(cdev);
+	} else {
+		cxgbit_close_conn(cdev);
+	}
+}
+
+static int cxgbit_uld_state_change(void *handle, enum cxgb4_state state)
+{
+	struct cxgbit_device *cdev = handle;
+
+	switch (state) {
+	case CXGB4_STATE_UP:
+		set_bit(CDEV_STATE_UP, &cdev->flags);
+		pr_info("cdev %s state UP.\n", pci_name(cdev->lldi.pdev));
+		break;
+	case CXGB4_STATE_START_RECOVERY:
+		clear_bit(CDEV_STATE_UP, &cdev->flags);
+		cxgbit_close_conn(cdev);
+		pr_info("cdev %s state RECOVERY.\n", pci_name(cdev->lldi.pdev));
+		break;
+	case CXGB4_STATE_DOWN:
+		pr_info("cdev %s state DOWN.\n", pci_name(cdev->lldi.pdev));
+		break;
+	case CXGB4_STATE_DETACH:
+		clear_bit(CDEV_STATE_UP, &cdev->flags);
+		cxgbit_detach_cdev(cdev);
+		pr_info("cdev %s state DETACH.\n", pci_name(cdev->lldi.pdev));
+		break;
+	default:
+		pr_info("cdev %s unknown state %d.\n",
+			pci_name(cdev->lldi.pdev), state);
+		break;
+	}
+	return 0;
+}
+
+static void
+cxgbit_proc_ddp_status(unsigned int tid, struct cpl_rx_data_ddp *cpl,
+		       struct cxgbit_lro_pdu_cb *pdu_cb)
+{
+	unsigned int status = ntohl(cpl->ddpvld);
+
+	pdu_cb->flags |= PDUCBF_RX_STATUS;
+	pdu_cb->ddigest = ntohl(cpl->ulp_crc);
+	pdu_cb->pdulen = ntohs(cpl->len);
+
+	if (status & (1 << CPL_RX_ISCSI_DDP_STATUS_HCRC_SHIFT)) {
+		pr_info("tid 0x%x, status 0x%x, hcrc bad.\n", tid, status);
+		pdu_cb->flags |= PDUCBF_RX_HCRC_ERR;
+	}
+
+	if (status & (1 << CPL_RX_ISCSI_DDP_STATUS_DCRC_SHIFT)) {
+		pr_info("tid 0x%x, status 0x%x, dcrc bad.\n", tid, status);
+		pdu_cb->flags |= PDUCBF_RX_DCRC_ERR;
+	}
+
+	if (status & (1 << CPL_RX_ISCSI_DDP_STATUS_PAD_SHIFT))
+		pr_info("tid 0x%x, status 0x%x, pad bad.\n", tid, status);
+
+	if ((status & (1 << CPL_RX_ISCSI_DDP_STATUS_DDP_SHIFT)) &&
+	    (!(pdu_cb->flags & PDUCBF_RX_DATA))) {
+		pdu_cb->flags |= PDUCBF_RX_DATA_DDPD;
+	}
+}
+
+static void
+cxgbit_lro_add_packet_rsp(struct sk_buff *skb, u8 op, const __be64 *rsp)
+{
+	struct cxgbit_lro_cb *lro_cb = cxgbit_skb_lro_cb(skb);
+	struct cxgbit_lro_pdu_cb *pdu_cb = cxgbit_skb_lro_pdu_cb(skb,
+						lro_cb->pdu_idx);
+	struct cpl_rx_iscsi_ddp *cpl = (struct cpl_rx_iscsi_ddp *)(rsp + 1);
+
+	cxgbit_proc_ddp_status(lro_cb->csk->tid, cpl, pdu_cb);
+
+	if (pdu_cb->flags & PDUCBF_RX_HDR)
+		pdu_cb->complete = true;
+
+	lro_cb->complete = true;
+	lro_cb->pdu_totallen += pdu_cb->pdulen;
+	lro_cb->pdu_idx++;
+}
+
+static void
+cxgbit_copy_frags(struct sk_buff *skb, const struct pkt_gl *gl,
+		  unsigned int offset)
+{
+	u8 skb_frag_idx = skb_shinfo(skb)->nr_frags;
+	u8 i;
+
+	/* usually there's just one frag */
+	__skb_fill_page_desc(skb, skb_frag_idx, gl->frags[0].page,
+			     gl->frags[0].offset + offset,
+			     gl->frags[0].size - offset);
+	for (i = 1; i < gl->nfrags; i++)
+		__skb_fill_page_desc(skb, skb_frag_idx + i,
+				     gl->frags[i].page,
+				     gl->frags[i].offset,
+				     gl->frags[i].size);
+
+	skb_shinfo(skb)->nr_frags += gl->nfrags;
+
+	/* get a reference to the last page, we don't own it */
+	get_page(gl->frags[gl->nfrags - 1].page);
+}
+
+static void
+cxgbit_lro_add_packet_gl(struct sk_buff *skb, u8 op, const struct pkt_gl *gl)
+{
+	struct cxgbit_lro_cb *lro_cb = cxgbit_skb_lro_cb(skb);
+	struct cxgbit_lro_pdu_cb *pdu_cb = cxgbit_skb_lro_pdu_cb(skb,
+						lro_cb->pdu_idx);
+	u32 len, offset;
+
+	if (op == CPL_ISCSI_HDR) {
+		struct cpl_iscsi_hdr *cpl = (struct cpl_iscsi_hdr *)gl->va;
+
+		offset = sizeof(struct cpl_iscsi_hdr);
+		pdu_cb->flags |= PDUCBF_RX_HDR;
+		pdu_cb->seq = ntohl(cpl->seq);
+		len = ntohs(cpl->len);
+		pdu_cb->hdr = gl->va + offset;
+		pdu_cb->hlen = len;
+		pdu_cb->hfrag_idx = skb_shinfo(skb)->nr_frags;
+
+		if (unlikely(gl->nfrags > 1))
+			cxgbit_skcb_flags(skb) = 0;
+
+		lro_cb->complete = false;
+	} else {
+		struct cpl_iscsi_data *cpl = (struct cpl_iscsi_data *)gl->va;
+
+		offset = sizeof(struct cpl_iscsi_data);
+		pdu_cb->flags |= PDUCBF_RX_DATA;
+		len = ntohs(cpl->len);
+		pdu_cb->dlen = len;
+		pdu_cb->doffset = lro_cb->offset;
+		pdu_cb->nr_dfrags = gl->nfrags;
+		pdu_cb->dfrag_idx = skb_shinfo(skb)->nr_frags;
+	}
+
+	cxgbit_copy_frags(skb, gl, offset);
+
+	pdu_cb->frags += gl->nfrags;
+	lro_cb->offset += len;
+	skb->len += len;
+	skb->data_len += len;
+	skb->truesize += len;
+}
+
+static struct sk_buff *
+cxgbit_lro_init_skb(struct cxgbit_sock *csk, u8 op, const struct pkt_gl *gl,
+		    const __be64 *rsp, struct napi_struct *napi)
+{
+	struct sk_buff *skb;
+	struct cxgbit_lro_cb *lro_cb;
+
+	skb = napi_alloc_skb(napi, LRO_SKB_MAX_HEADROOM);
+
+	if (unlikely(!skb))
+		return NULL;
+
+	memset(skb->data, 0, LRO_SKB_MAX_HEADROOM);
+
+	cxgbit_skcb_flags(skb) |= SKCBF_RX_LRO;
+
+	lro_cb = cxgbit_skb_lro_cb(skb);
+
+	cxgbit_get_csk(csk);
+
+	lro_cb->csk = csk;
+
+	return skb;
+}
+
+static void cxgbit_queue_lro_skb(struct cxgbit_sock *csk, struct sk_buff *skb)
+{
+	bool wakeup_thread = false;
+
+	spin_lock(&csk->rxq.lock);
+	__skb_queue_tail(&csk->rxq, skb);
+	if (skb_queue_len(&csk->rxq) == 1)
+		wakeup_thread = true;
+	spin_unlock(&csk->rxq.lock);
+
+	if (wakeup_thread)
+		wake_up(&csk->waitq);
+}
+
+static void cxgbit_lro_flush(struct t4_lro_mgr *lro_mgr, struct sk_buff *skb)
+{
+	struct cxgbit_lro_cb *lro_cb = cxgbit_skb_lro_cb(skb);
+	struct cxgbit_sock *csk = lro_cb->csk;
+
+	csk->lro_skb = NULL;
+
+	__skb_unlink(skb, &lro_mgr->lroq);
+	cxgbit_queue_lro_skb(csk, skb);
+
+	cxgbit_put_csk(csk);
+
+	lro_mgr->lro_pkts++;
+	lro_mgr->lro_session_cnt--;
+}
+
+static void cxgbit_uld_lro_flush(struct t4_lro_mgr *lro_mgr)
+{
+	struct sk_buff *skb;
+
+	while ((skb = skb_peek(&lro_mgr->lroq)))
+		cxgbit_lro_flush(lro_mgr, skb);
+}
+
+static int
+cxgbit_lro_receive(struct cxgbit_sock *csk, u8 op, const __be64 *rsp,
+		   const struct pkt_gl *gl, struct t4_lro_mgr *lro_mgr,
+		   struct napi_struct *napi)
+{
+	struct sk_buff *skb;
+	struct cxgbit_lro_cb *lro_cb;
+
+	if (!csk) {
+		pr_err("%s: csk NULL, op 0x%x.\n", __func__, op);
+		goto out;
+	}
+
+	if (csk->lro_skb)
+		goto add_packet;
+
+start_lro:
+	if (lro_mgr->lro_session_cnt >= MAX_LRO_SESSIONS) {
+		cxgbit_uld_lro_flush(lro_mgr);
+		goto start_lro;
+	}
+
+	skb = cxgbit_lro_init_skb(csk, op, gl, rsp, napi);
+	if (unlikely(!skb))
+		goto out;
+
+	csk->lro_skb = skb;
+
+	__skb_queue_tail(&lro_mgr->lroq, skb);
+	lro_mgr->lro_session_cnt++;
+
+add_packet:
+	skb = csk->lro_skb;
+	lro_cb = cxgbit_skb_lro_cb(skb);
+
+	if ((gl && (((skb_shinfo(skb)->nr_frags + gl->nfrags) >
+	    MAX_SKB_FRAGS) || (lro_cb->pdu_totallen >= LRO_FLUSH_LEN_MAX))) ||
+	    (lro_cb->pdu_idx >= MAX_SKB_FRAGS)) {
+		cxgbit_lro_flush(lro_mgr, skb);
+		goto start_lro;
+	}
+
+	if (gl)
+		cxgbit_lro_add_packet_gl(skb, op, gl);
+	else
+		cxgbit_lro_add_packet_rsp(skb, op, rsp);
+
+	lro_mgr->lro_merged++;
+
+	return 0;
+
+out:
+	return -1;
+}
+
+static int
+cxgbit_uld_lro_rx_handler(void *hndl, const __be64 *rsp,
+			  const struct pkt_gl *gl, struct t4_lro_mgr *lro_mgr,
+			  struct napi_struct *napi)
+{
+	struct cxgbit_device *cdev = hndl;
+	struct cxgb4_lld_info *lldi = &cdev->lldi;
+	struct cpl_tx_data *rpl = NULL;
+	struct cxgbit_sock *csk = NULL;
+	unsigned int tid = 0;
+	struct sk_buff *skb;
+	unsigned int op = *(u8 *)rsp;
+	bool lro_flush = true;
+
+	switch (op) {
+	case CPL_ISCSI_HDR:
+	case CPL_ISCSI_DATA:
+	case CPL_RX_ISCSI_DDP:
+	case CPL_FW4_ACK:
+		lro_flush = false;
+	case CPL_ABORT_RPL_RSS:
+	case CPL_PASS_ESTABLISH:
+	case CPL_PEER_CLOSE:
+	case CPL_CLOSE_CON_RPL:
+	case CPL_ABORT_REQ_RSS:
+	case CPL_SET_TCB_RPL:
+	case CPL_RX_DATA:
+		rpl = gl ? (struct cpl_tx_data *)gl->va :
+			   (struct cpl_tx_data *)(rsp + 1);
+		tid = GET_TID(rpl);
+		csk = lookup_tid(lldi->tids, tid);
+		break;
+	default:
+		break;
+	}
+
+	if (csk && csk->lro_skb && lro_flush)
+		cxgbit_lro_flush(lro_mgr, csk->lro_skb);
+
+	if (!gl) {
+		unsigned int len;
+
+		if (op == CPL_RX_ISCSI_DDP) {
+			if (!cxgbit_lro_receive(csk, op, rsp, NULL, lro_mgr,
+						napi))
+				return 0;
+		}
+
+		len = 64 - sizeof(struct rsp_ctrl) - 8;
+		skb = napi_alloc_skb(napi, len);
+		if (!skb)
+			goto nomem;
+		__skb_put(skb, len);
+		skb_copy_to_linear_data(skb, &rsp[1], len);
+	} else {
+		if (unlikely(op != *(u8 *)gl->va)) {
+			pr_info("? FL 0x%p,RSS%#llx,FL %#llx,len %u.\n",
+				gl->va, be64_to_cpu(*rsp),
+				be64_to_cpu(*(u64 *)gl->va),
+				gl->tot_len);
+			return 0;
+		}
+
+		if (op == CPL_ISCSI_HDR || op == CPL_ISCSI_DATA) {
+			if (!cxgbit_lro_receive(csk, op, rsp, gl, lro_mgr,
+						napi))
+				return 0;
+		}
+
+#define RX_PULL_LEN 128
+		skb = cxgb4_pktgl_to_skb(gl, RX_PULL_LEN, RX_PULL_LEN);
+		if (unlikely(!skb))
+			goto nomem;
+	}
+
+	rpl = (struct cpl_tx_data *)skb->data;
+	op = rpl->ot.opcode;
+	cxgbit_skcb_rx_opcode(skb) = op;
+
+	pr_debug("cdev %p, opcode 0x%x(0x%x,0x%x), skb %p.\n",
+		 cdev, op, rpl->ot.opcode_tid,
+		 ntohl(rpl->ot.opcode_tid), skb);
+
+	if (op < NUM_CPL_CMDS && cxgbit_cplhandlers[op]) {
+		cxgbit_cplhandlers[op](cdev, skb);
+	} else {
+		pr_err("No handler for opcode 0x%x.\n", op);
+		__kfree_skb(skb);
+	}
+	return 0;
+nomem:
+	pr_err("%s OOM bailing out.\n", __func__);
+	return 1;
+}
+
+#ifdef CONFIG_CHELSIO_T4_DCB
+struct cxgbit_dcb_work {
+	struct dcb_app_type dcb_app;
+	struct work_struct work;
+};
+
+static void
+cxgbit_update_dcb_priority(struct cxgbit_device *cdev, u8 port_id,
+			   u8 dcb_priority, u16 port_num)
+{
+	struct cxgbit_sock *csk;
+	struct sk_buff *skb;
+	u16 local_port;
+	bool wakeup_thread = false;
+
+	spin_lock_bh(&cdev->cskq.lock);
+	list_for_each_entry(csk, &cdev->cskq.list, list) {
+		if (csk->port_id != port_id)
+			continue;
+
+		if (csk->com.local_addr.ss_family == AF_INET6) {
+			struct sockaddr_in6 *sock_in6;
+
+			sock_in6 = (struct sockaddr_in6 *)&csk->com.local_addr;
+			local_port = ntohs(sock_in6->sin6_port);
+		} else {
+			struct sockaddr_in *sock_in;
+
+			sock_in = (struct sockaddr_in *)&csk->com.local_addr;
+			local_port = ntohs(sock_in->sin_port);
+		}
+
+		if (local_port != port_num)
+			continue;
+
+		if (csk->dcb_priority == dcb_priority)
+			continue;
+
+		skb = alloc_skb(0, GFP_ATOMIC);
+		if (!skb)
+			continue;
+
+		spin_lock(&csk->rxq.lock);
+		__skb_queue_tail(&csk->rxq, skb);
+		if (skb_queue_len(&csk->rxq) == 1)
+			wakeup_thread = true;
+		spin_unlock(&csk->rxq.lock);
+
+		if (wakeup_thread) {
+			wake_up(&csk->waitq);
+			wakeup_thread = false;
+		}
+	}
+	spin_unlock_bh(&cdev->cskq.lock);
+}
+
+static void cxgbit_dcb_workfn(struct work_struct *work)
+{
+	struct cxgbit_dcb_work *dcb_work;
+	struct net_device *ndev;
+	struct cxgbit_device *cdev = NULL;
+	struct dcb_app_type *iscsi_app;
+	u8 priority, port_id = 0xff;
+
+	dcb_work = container_of(work, struct cxgbit_dcb_work, work);
+	iscsi_app = &dcb_work->dcb_app;
+
+	if (iscsi_app->dcbx & DCB_CAP_DCBX_VER_IEEE) {
+		if (iscsi_app->app.selector != IEEE_8021QAZ_APP_SEL_ANY)
+			goto out;
+
+		priority = iscsi_app->app.priority;
+
+	} else if (iscsi_app->dcbx & DCB_CAP_DCBX_VER_CEE) {
+		if (iscsi_app->app.selector != DCB_APP_IDTYPE_PORTNUM)
+			goto out;
+
+		if (!iscsi_app->app.priority)
+			goto out;
+
+		priority = ffs(iscsi_app->app.priority) - 1;
+	} else {
+		goto out;
+	}
+
+	pr_debug("priority for ifid %d is %u\n",
+		 iscsi_app->ifindex, priority);
+
+	ndev = dev_get_by_index(&init_net, iscsi_app->ifindex);
+
+	if (!ndev)
+		goto out;
+
+	mutex_lock(&cdev_list_lock);
+	cdev = cxgbit_find_device(ndev, &port_id);
+
+	dev_put(ndev);
+
+	if (!cdev) {
+		mutex_unlock(&cdev_list_lock);
+		goto out;
+	}
+
+	cxgbit_update_dcb_priority(cdev, port_id, priority,
+				   iscsi_app->app.protocol);
+	mutex_unlock(&cdev_list_lock);
+out:
+	kfree(dcb_work);
+}
+
+static int
+cxgbit_dcbevent_notify(struct notifier_block *nb, unsigned long action,
+		       void *data)
+{
+	struct cxgbit_dcb_work *dcb_work;
+	struct dcb_app_type *dcb_app = data;
+
+	dcb_work = kzalloc(sizeof(*dcb_work), GFP_ATOMIC);
+	if (!dcb_work)
+		return NOTIFY_DONE;
+
+	dcb_work->dcb_app = *dcb_app;
+	INIT_WORK(&dcb_work->work, cxgbit_dcb_workfn);
+	schedule_work(&dcb_work->work);
+	return NOTIFY_OK;
+}
+#endif
+
+static enum target_prot_op cxgbit_get_sup_prot_ops(struct iscsi_conn *conn)
+{
+	return TARGET_PROT_NORMAL;
+}
+
+static struct iscsit_transport cxgbit_transport = {
+	.name			= DRV_NAME,
+	.transport_type		= ISCSI_HW_OFFLOAD,
+	.priv_size		= sizeof(struct cxgbit_cmd),
+	.owner			= THIS_MODULE,
+	.iscsit_setup_np	= cxgbit_setup_np,
+	.iscsit_accept_np	= cxgbit_accept_np,
+	.iscsit_free_np		= cxgbit_free_np,
+	.iscsit_free_conn	= cxgbit_free_conn,
+	.iscsit_get_login_rx	= cxgbit_get_login_rx,
+	.iscsit_put_login_tx	= cxgbit_put_login_tx,
+	.iscsit_immediate_queue	= iscsit_immediate_queue,
+	.iscsit_response_queue	= iscsit_response_queue,
+	.iscsit_get_dataout	= iscsit_build_r2ts_for_cmd,
+	.iscsit_queue_data_in	= iscsit_queue_rsp,
+	.iscsit_queue_status	= iscsit_queue_rsp,
+	.iscsit_alloc_pdu	= cxgbit_alloc_pdu,
+	.iscsit_xmit_pdu	= cxgbit_xmit_pdu,
+	.iscsit_xmit_datain_pdu	= cxgbit_xmit_datain_pdu,
+	.iscsit_get_r2t_ttt	= cxgbit_get_r2t_ttt,
+	.iscsit_get_rx_pdu	= cxgbit_get_rx_pdu,
+	.iscsit_validate_params	= cxgbit_validate_params,
+	.iscsit_release_cmd	= cxgbit_release_cmd,
+	.iscsit_aborted_task	= iscsit_aborted_task,
+	.iscsit_get_sup_prot_ops = cxgbit_get_sup_prot_ops,
+};
+
+static struct cxgb4_uld_info cxgbit_uld_info = {
+	.name		= DRV_NAME,
+	.add		= cxgbit_uld_add,
+	.state_change	= cxgbit_uld_state_change,
+	.lro_rx_handler = cxgbit_uld_lro_rx_handler,
+	.lro_flush	= cxgbit_uld_lro_flush,
+};
+
+#ifdef CONFIG_CHELSIO_T4_DCB
+static struct notifier_block cxgbit_dcbevent_nb = {
+	.notifier_call = cxgbit_dcbevent_notify,
+};
+#endif
+
+static int __init cxgbit_init(void)
+{
+	cxgb4_register_uld(CXGB4_ULD_ISCSIT, &cxgbit_uld_info);
+	iscsit_register_transport(&cxgbit_transport);
+
+#ifdef CONFIG_CHELSIO_T4_DCB
+	pr_info("%s dcb enabled.\n", DRV_NAME);
+	register_dcbevent_notifier(&cxgbit_dcbevent_nb);
+#endif
+	BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff, cb) <
+		     sizeof(union cxgbit_skb_cb));
+	return 0;
+}
+
+static void __exit cxgbit_exit(void)
+{
+	struct cxgbit_device *cdev, *tmp;
+
+#ifdef CONFIG_CHELSIO_T4_DCB
+	unregister_dcbevent_notifier(&cxgbit_dcbevent_nb);
+#endif
+	mutex_lock(&cdev_list_lock);
+	list_for_each_entry_safe(cdev, tmp, &cdev_list_head, list) {
+		list_del(&cdev->list);
+		cxgbit_put_cdev(cdev);
+	}
+	mutex_unlock(&cdev_list_lock);
+	iscsit_unregister_transport(&cxgbit_transport);
+	cxgb4_unregister_uld(CXGB4_ULD_ISCSIT);
+}
+
+module_init(cxgbit_init);
+module_exit(cxgbit_exit);
+
+MODULE_DESCRIPTION("Chelsio iSCSI target offload driver");
+MODULE_AUTHOR("Chelsio Communications");
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL");
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
new file mode 100644
index 0000000..96355b0a
--- /dev/null
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -0,0 +1,1601 @@
+/*
+ * Copyright (c) 2016 Chelsio Communications, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/workqueue.h>
+#include <linux/kthread.h>
+#include <asm/unaligned.h>
+#include <target/target_core_base.h>
+#include <target/target_core_fabric.h>
+#include "cxgbit.h"
+
+struct sge_opaque_hdr {
+	void *dev;
+	dma_addr_t addr[MAX_SKB_FRAGS + 1];
+};
+
+static const u8 cxgbit_digest_len[] = {0, 4, 4, 8};
+
+#define TX_HDR_LEN (sizeof(struct sge_opaque_hdr) + \
+		    sizeof(struct fw_ofld_tx_data_wr))
+
+static struct sk_buff *
+__cxgbit_alloc_skb(struct cxgbit_sock *csk, u32 len, bool iso)
+{
+	struct sk_buff *skb = NULL;
+	u8 submode = 0;
+	int errcode;
+	static const u32 hdr_len = TX_HDR_LEN + ISCSI_HDR_LEN;
+
+	if (len) {
+		skb = alloc_skb_with_frags(hdr_len, len,
+					   0, &errcode,
+					   GFP_KERNEL);
+		if (!skb)
+			return NULL;
+
+		skb_reserve(skb, TX_HDR_LEN);
+		skb_reset_transport_header(skb);
+		__skb_put(skb, ISCSI_HDR_LEN);
+		memset(skb->data, 0, ISCSI_HDR_LEN);
+		skb->data_len = len;
+		skb->len += len;
+		submode |= (csk->submode & CXGBIT_SUBMODE_DCRC);
+
+	} else {
+		u32 iso_len = iso ? sizeof(struct cpl_tx_data_iso) : 0;
+
+		skb = alloc_skb(hdr_len + iso_len, GFP_KERNEL);
+		if (!skb)
+			return NULL;
+
+		skb_reserve(skb, TX_HDR_LEN + iso_len);
+		skb_reset_transport_header(skb);
+		__skb_put(skb, ISCSI_HDR_LEN);
+		memset(skb->data, 0, ISCSI_HDR_LEN);
+	}
+
+	submode |= (csk->submode & CXGBIT_SUBMODE_HCRC);
+	cxgbit_skcb_submode(skb) = submode;
+	cxgbit_skcb_tx_extralen(skb) = cxgbit_digest_len[submode];
+	cxgbit_skcb_flags(skb) |= SKCBF_TX_NEED_HDR;
+	return skb;
+}
+
+static struct sk_buff *cxgbit_alloc_skb(struct cxgbit_sock *csk, u32 len)
+{
+	return __cxgbit_alloc_skb(csk, len, false);
+}
+
+/*
+ * cxgbit_is_ofld_imm - check whether a packet can be sent as immediate data
+ * @skb: the packet
+ *
+ * Returns true if a packet can be sent as an offload WR with immediate
+ * data.  We currently use the same limit as for Ethernet packets.
+ */
+static int cxgbit_is_ofld_imm(const struct sk_buff *skb)
+{
+	int length = skb->len;
+
+	if (likely(cxgbit_skcb_flags(skb) & SKCBF_TX_NEED_HDR))
+		length += sizeof(struct fw_ofld_tx_data_wr);
+
+	if (likely(cxgbit_skcb_flags(skb) & SKCBF_TX_ISO))
+		length += sizeof(struct cpl_tx_data_iso);
+
+#define MAX_IMM_TX_PKT_LEN	256
+	return length <= MAX_IMM_TX_PKT_LEN;
+}
+
+/*
+ * cxgbit_sgl_len - calculates the size of an SGL of the given capacity
+ * @n: the number of SGL entries
+ * Calculates the number of flits needed for a scatter/gather list that
+ * can hold the given number of entries.
+ */
+static inline unsigned int cxgbit_sgl_len(unsigned int n)
+{
+	n--;
+	return (3 * n) / 2 + (n & 1) + 2;
+}
+
+/*
+ * cxgbit_calc_tx_flits_ofld - calculate # of flits for an offload packet
+ * @skb: the packet
+ *
+ * Returns the number of flits needed for the given offload packet.
+ * These packets are already fully constructed and no additional headers
+ * will be added.
+ */
+static unsigned int cxgbit_calc_tx_flits_ofld(const struct sk_buff *skb)
+{
+	unsigned int flits, cnt;
+
+	if (cxgbit_is_ofld_imm(skb))
+		return DIV_ROUND_UP(skb->len, 8);
+	flits = skb_transport_offset(skb) / 8;
+	cnt = skb_shinfo(skb)->nr_frags;
+	if (skb_tail_pointer(skb) != skb_transport_header(skb))
+		cnt++;
+	return flits + cxgbit_sgl_len(cnt);
+}
+
+#define CXGBIT_ISO_FSLICE 0x1
+#define CXGBIT_ISO_LSLICE 0x2
+static void
+cxgbit_cpl_tx_data_iso(struct sk_buff *skb, struct cxgbit_iso_info *iso_info)
+{
+	struct cpl_tx_data_iso *cpl;
+	unsigned int submode = cxgbit_skcb_submode(skb);
+	unsigned int fslice = !!(iso_info->flags & CXGBIT_ISO_FSLICE);
+	unsigned int lslice = !!(iso_info->flags & CXGBIT_ISO_LSLICE);
+
+	cpl = (struct cpl_tx_data_iso *)__skb_push(skb, sizeof(*cpl));
+
+	cpl->op_to_scsi = htonl(CPL_TX_DATA_ISO_OP_V(CPL_TX_DATA_ISO) |
+			CPL_TX_DATA_ISO_FIRST_V(fslice) |
+			CPL_TX_DATA_ISO_LAST_V(lslice) |
+			CPL_TX_DATA_ISO_CPLHDRLEN_V(0) |
+			CPL_TX_DATA_ISO_HDRCRC_V(submode & 1) |
+			CPL_TX_DATA_ISO_PLDCRC_V(((submode >> 1) & 1)) |
+			CPL_TX_DATA_ISO_IMMEDIATE_V(0) |
+			CPL_TX_DATA_ISO_SCSI_V(2));
+
+	cpl->ahs_len = 0;
+	cpl->mpdu = htons(DIV_ROUND_UP(iso_info->mpdu, 4));
+	cpl->burst_size = htonl(DIV_ROUND_UP(iso_info->burst_len, 4));
+	cpl->len = htonl(iso_info->len);
+	cpl->reserved2_seglen_offset = htonl(0);
+	cpl->datasn_offset = htonl(0);
+	cpl->buffer_offset = htonl(0);
+	cpl->reserved3 = 0;
+
+	__skb_pull(skb, sizeof(*cpl));
+}
+
+static void
+cxgbit_tx_data_wr(struct cxgbit_sock *csk, struct sk_buff *skb, u32 dlen,
+		  u32 len, u32 credits, u32 compl)
+{
+	struct fw_ofld_tx_data_wr *req;
+	u32 submode = cxgbit_skcb_submode(skb);
+	u32 wr_ulp_mode = 0;
+	u32 hdr_size = sizeof(*req);
+	u32 opcode = FW_OFLD_TX_DATA_WR;
+	u32 immlen = 0;
+	u32 force = TX_FORCE_V(!submode);
+
+	if (cxgbit_skcb_flags(skb) & SKCBF_TX_ISO) {
+		opcode = FW_ISCSI_TX_DATA_WR;
+		immlen += sizeof(struct cpl_tx_data_iso);
+		hdr_size += sizeof(struct cpl_tx_data_iso);
+		submode |= 8;
+	}
+
+	if (cxgbit_is_ofld_imm(skb))
+		immlen += dlen;
+
+	req = (struct fw_ofld_tx_data_wr *)__skb_push(skb,
+							hdr_size);
+	req->op_to_immdlen = cpu_to_be32(FW_WR_OP_V(opcode) |
+					FW_WR_COMPL_V(compl) |
+					FW_WR_IMMDLEN_V(immlen));
+	req->flowid_len16 = cpu_to_be32(FW_WR_FLOWID_V(csk->tid) |
+					FW_WR_LEN16_V(credits));
+	req->plen = htonl(len);
+	wr_ulp_mode = FW_OFLD_TX_DATA_WR_ULPMODE_V(ULP_MODE_ISCSI) |
+				FW_OFLD_TX_DATA_WR_ULPSUBMODE_V(submode);
+
+	req->tunnel_to_proxy = htonl((wr_ulp_mode) | force |
+		 FW_OFLD_TX_DATA_WR_SHOVE_V(skb_peek(&csk->txq) ? 0 : 1));
+}
+
+static void cxgbit_arp_failure_skb_discard(void *handle, struct sk_buff *skb)
+{
+	kfree_skb(skb);
+}
+
+void cxgbit_push_tx_frames(struct cxgbit_sock *csk)
+{
+	struct sk_buff *skb;
+
+	while (csk->wr_cred && ((skb = skb_peek(&csk->txq)) != NULL)) {
+		u32 dlen = skb->len;
+		u32 len = skb->len;
+		u32 credits_needed;
+		u32 compl = 0;
+		u32 flowclen16 = 0;
+		u32 iso_cpl_len = 0;
+
+		if (cxgbit_skcb_flags(skb) & SKCBF_TX_ISO)
+			iso_cpl_len = sizeof(struct cpl_tx_data_iso);
+
+		if (cxgbit_is_ofld_imm(skb))
+			credits_needed = DIV_ROUND_UP(dlen + iso_cpl_len, 16);
+		else
+			credits_needed = DIV_ROUND_UP((8 *
+					cxgbit_calc_tx_flits_ofld(skb)) +
+					iso_cpl_len, 16);
+
+		if (likely(cxgbit_skcb_flags(skb) & SKCBF_TX_NEED_HDR))
+			credits_needed += DIV_ROUND_UP(
+				sizeof(struct fw_ofld_tx_data_wr), 16);
+		/*
+		 * Assumes the initial credits is large enough to support
+		 * fw_flowc_wr plus largest possible first payload
+		 */
+
+		if (!test_and_set_bit(CSK_TX_DATA_SENT, &csk->com.flags)) {
+			flowclen16 = cxgbit_send_tx_flowc_wr(csk);
+			csk->wr_cred -= flowclen16;
+			csk->wr_una_cred += flowclen16;
+		}
+
+		if (csk->wr_cred < credits_needed) {
+			pr_debug("csk 0x%p, skb %u/%u, wr %d < %u.\n",
+				 csk, skb->len, skb->data_len,
+				 credits_needed, csk->wr_cred);
+			break;
+		}
+		__skb_unlink(skb, &csk->txq);
+		set_wr_txq(skb, CPL_PRIORITY_DATA, csk->txq_idx);
+		skb->csum = credits_needed + flowclen16;
+		csk->wr_cred -= credits_needed;
+		csk->wr_una_cred += credits_needed;
+
+		pr_debug("csk 0x%p, skb %u/%u, wr %d, left %u, unack %u.\n",
+			 csk, skb->len, skb->data_len, credits_needed,
+			 csk->wr_cred, csk->wr_una_cred);
+
+		if (likely(cxgbit_skcb_flags(skb) & SKCBF_TX_NEED_HDR)) {
+			len += cxgbit_skcb_tx_extralen(skb);
+
+			if ((csk->wr_una_cred >= (csk->wr_max_cred / 2)) ||
+			    (!before(csk->write_seq,
+				     csk->snd_una + csk->snd_win))) {
+				compl = 1;
+				csk->wr_una_cred = 0;
+			}
+
+			cxgbit_tx_data_wr(csk, skb, dlen, len, credits_needed,
+					  compl);
+			csk->snd_nxt += len;
+
+		} else if ((cxgbit_skcb_flags(skb) & SKCBF_TX_FLAG_COMPL) ||
+			   (csk->wr_una_cred >= (csk->wr_max_cred / 2))) {
+			struct cpl_close_con_req *req =
+				(struct cpl_close_con_req *)skb->data;
+			req->wr.wr_hi |= htonl(FW_WR_COMPL_F);
+			csk->wr_una_cred = 0;
+		}
+
+		cxgbit_sock_enqueue_wr(csk, skb);
+		t4_set_arp_err_handler(skb, csk,
+				       cxgbit_arp_failure_skb_discard);
+
+		pr_debug("csk 0x%p,%u, skb 0x%p, %u.\n",
+			 csk, csk->tid, skb, len);
+
+		cxgbit_l2t_send(csk->com.cdev, skb, csk->l2t);
+	}
+}
+
+static bool cxgbit_lock_sock(struct cxgbit_sock *csk)
+{
+	spin_lock_bh(&csk->lock);
+
+	if (before(csk->write_seq, csk->snd_una + csk->snd_win))
+		csk->lock_owner = true;
+
+	spin_unlock_bh(&csk->lock);
+
+	return csk->lock_owner;
+}
+
+static void cxgbit_unlock_sock(struct cxgbit_sock *csk)
+{
+	struct sk_buff_head backlogq;
+	struct sk_buff *skb;
+	void (*fn)(struct cxgbit_sock *, struct sk_buff *);
+
+	skb_queue_head_init(&backlogq);
+
+	spin_lock_bh(&csk->lock);
+	while (skb_queue_len(&csk->backlogq)) {
+		skb_queue_splice_init(&csk->backlogq, &backlogq);
+		spin_unlock_bh(&csk->lock);
+
+		while ((skb = __skb_dequeue(&backlogq))) {
+			fn = cxgbit_skcb_rx_backlog_fn(skb);
+			fn(csk, skb);
+		}
+
+		spin_lock_bh(&csk->lock);
+	}
+
+	csk->lock_owner = false;
+	spin_unlock_bh(&csk->lock);
+}
+
+static int cxgbit_queue_skb(struct cxgbit_sock *csk, struct sk_buff *skb)
+{
+	int ret = 0;
+
+	wait_event_interruptible(csk->ack_waitq, cxgbit_lock_sock(csk));
+
+	if (unlikely((csk->com.state != CSK_STATE_ESTABLISHED) ||
+		     signal_pending(current))) {
+		__kfree_skb(skb);
+		__skb_queue_purge(&csk->ppodq);
+		ret = -1;
+		spin_lock_bh(&csk->lock);
+		if (csk->lock_owner) {
+			spin_unlock_bh(&csk->lock);
+			goto unlock;
+		}
+		spin_unlock_bh(&csk->lock);
+		return ret;
+	}
+
+	csk->write_seq += skb->len +
+			  cxgbit_skcb_tx_extralen(skb);
+
+	skb_queue_splice_tail_init(&csk->ppodq, &csk->txq);
+	__skb_queue_tail(&csk->txq, skb);
+	cxgbit_push_tx_frames(csk);
+
+unlock:
+	cxgbit_unlock_sock(csk);
+	return ret;
+}
+
+void *cxgbit_alloc_pdu(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
+{
+	struct cxgbit_sock *csk = conn->context;
+	struct cxgbit_cmd *ccmd = iscsit_priv_cmd(cmd);
+	struct sk_buff *skb;
+	static const u32 max_hdr_len = TX_HDR_LEN + ISCSI_HDR_LEN +
+				       sizeof(struct cpl_tx_data_iso);
+
+	skb = alloc_skb(max_hdr_len, GFP_KERNEL);
+	if (!skb)
+		return NULL;
+
+	skb_reserve(skb, max_hdr_len);
+	skb_reset_transport_header(skb);
+	__skb_put(skb, ISCSI_HDR_LEN);
+	memset(skb->data, 0, ISCSI_HDR_LEN);
+
+	cxgbit_skcb_submode(skb) = csk->submode &
+				   CXGBIT_SUBMODE_HCRC;
+	cxgbit_skcb_flags(skb) |= SKCBF_TX_NEED_HDR;
+
+	ccmd->skb = skb;
+
+	return skb->data;
+}
+
+static int
+cxgbit_map_skb(struct iscsi_cmd *cmd, struct sk_buff *skb, u32 data_offset,
+	       u32 data_length)
+{
+	u32 i = 0, nr_frags = MAX_SKB_FRAGS;
+	u32 padding = ((-data_length) & 3);
+	struct scatterlist *sg;
+	struct page *page;
+	unsigned int page_off;
+
+	if (padding)
+		nr_frags--;
+
+	/*
+	 * We know each entry in t_data_sg contains a page.
+	 */
+	sg = &cmd->se_cmd.t_data_sg[data_offset / PAGE_SIZE];
+	page_off = (data_offset % PAGE_SIZE);
+
+	while (data_length && (i < nr_frags)) {
+		u32 cur_len = min_t(u32, data_length, sg->length - page_off);
+
+		page = sg_page(sg);
+
+		get_page(page);
+		skb_fill_page_desc(skb, i, page, sg->offset + page_off,
+				   cur_len);
+		skb->data_len += cur_len;
+		skb->len += cur_len;
+		skb->truesize += cur_len;
+
+		data_length -= cur_len;
+		page_off = 0;
+		sg = sg_next(sg);
+		i++;
+	}
+
+	if (data_length)
+		return -1;
+
+	if (padding) {
+		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!page)
+			return -1;
+		skb_fill_page_desc(skb, i, page, 0, padding);
+		skb->data_len += padding;
+		skb->len += padding;
+		skb->truesize += padding;
+	}
+
+	return 0;
+}
+
+static int
+cxgbit_tx_datain_iso(struct cxgbit_sock *csk, struct iscsi_cmd *cmd,
+		     struct iscsi_datain_req *dr)
+{
+	struct iscsi_conn *conn = csk->conn;
+	struct cxgbit_cmd *ccmd = iscsit_priv_cmd(cmd);
+	struct sk_buff *skb;
+	struct iscsi_datain datain;
+	struct cxgbit_iso_info iso_info;
+	u32 data_length = cmd->se_cmd.data_length;
+	u32 mrdsl = conn->conn_ops->MaxRecvDataSegmentLength;
+	u32 num_pdu, plen, tx_data = 0;
+	bool task_sense = !!(cmd->se_cmd.se_cmd_flags &
+		SCF_TRANSPORT_TASK_SENSE);
+	bool set_statsn = false;
+	int ret = -1;
+
+	while (data_length) {
+		num_pdu = (data_length + mrdsl - 1) / mrdsl;
+		if (num_pdu > csk->max_iso_npdu)
+			num_pdu = csk->max_iso_npdu;
+
+		plen = num_pdu * mrdsl;
+		if (plen > data_length)
+			plen = data_length;
+
+		if (ccmd->skb) {
+			skb = ccmd->skb;
+			memset(skb->data, 0, ISCSI_HDR_LEN);
+			ccmd->skb = NULL;
+		} else {
+			skb = __cxgbit_alloc_skb(csk, 0, true);
+			if (!skb)
+				return -ENOMEM;
+		}
+
+		cxgbit_skcb_flags(skb) |= SKCBF_TX_ISO;
+		cxgbit_skcb_submode(skb) |= (csk->submode &
+				CXGBIT_SUBMODE_DCRC);
+		cxgbit_skcb_tx_extralen(skb) = (num_pdu *
+				cxgbit_digest_len[cxgbit_skcb_submode(skb)]) +
+						((num_pdu - 1) * ISCSI_HDR_LEN);
+
+		memset(&datain, 0, sizeof(struct iscsi_datain));
+		memset(&iso_info, 0, sizeof(iso_info));
+
+		if (!tx_data)
+			iso_info.flags |= CXGBIT_ISO_FSLICE;
+
+		if (!(data_length - plen)) {
+			iso_info.flags |= CXGBIT_ISO_LSLICE;
+			if (!task_sense) {
+				datain.flags = ISCSI_FLAG_DATA_STATUS;
+				iscsit_increment_maxcmdsn(cmd, conn->sess);
+				cmd->stat_sn = conn->stat_sn++;
+				set_statsn = true;
+			}
+		}
+
+		iso_info.burst_len = num_pdu * mrdsl;
+		iso_info.mpdu = mrdsl;
+		iso_info.len = ISCSI_HDR_LEN + plen;
+
+		cxgbit_cpl_tx_data_iso(skb, &iso_info);
+
+		datain.offset = tx_data;
+		datain.data_sn = cmd->data_sn - 1;
+
+		iscsit_build_datain_pdu(cmd, conn, &datain,
+					(struct iscsi_data_rsp *)skb->data,
+					set_statsn);
+
+		ret = cxgbit_map_skb(cmd, skb, tx_data, plen);
+		if (unlikely(ret)) {
+			__kfree_skb(skb);
+			goto out;
+		}
+
+		ret = cxgbit_queue_skb(csk, skb);
+		if (unlikely(ret))
+			goto out;
+
+		tx_data += plen;
+		data_length -= plen;
+
+		cmd->read_data_done += plen;
+		cmd->data_sn += num_pdu;
+	}
+
+	dr->dr_complete = DATAIN_COMPLETE_NORMAL;
+
+	return 0;
+
+out:
+	return ret;
+}
+
+static int
+cxgbit_tx_datain(struct cxgbit_sock *csk, struct iscsi_cmd *cmd,
+		 struct iscsi_datain *datain)
+{
+	struct cxgbit_cmd *ccmd = iscsit_priv_cmd(cmd);
+	struct sk_buff *skb = ccmd->skb;
+	int ret = 0;
+
+	ccmd->skb = NULL;
+
+	if (datain->length) {
+		cxgbit_skcb_submode(skb) |= (csk->submode &
+				CXGBIT_SUBMODE_DCRC);
+		cxgbit_skcb_tx_extralen(skb) =
+				cxgbit_digest_len[cxgbit_skcb_submode(skb)];
+	}
+
+	ret = cxgbit_map_skb(cmd, skb, datain->offset, datain->length);
+	if (ret < 0) {
+		__kfree_skb(skb);
+		return ret;
+	}
+
+	return cxgbit_queue_skb(csk, skb);
+}
+
+int
+cxgbit_xmit_datain_pdu(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
+		       struct iscsi_datain_req *dr, struct iscsi_datain *datain)
+{
+	struct cxgbit_sock *csk = conn->context;
+	u32 data_length = cmd->se_cmd.data_length;
+	u32 padding = ((-data_length) & 3);
+	u32 mrdsl = conn->conn_ops->MaxRecvDataSegmentLength;
+
+	if ((data_length > mrdsl) && (!dr->recovery) &&
+	    (!padding) && (!datain->offset) && csk->max_iso_npdu) {
+		atomic_long_add(data_length - datain->length,
+				&conn->sess->tx_data_octets);
+		return cxgbit_tx_datain_iso(csk, cmd, dr);
+	}
+
+	return cxgbit_tx_datain(csk, cmd, datain);
+}
+
+int
+cxgbit_xmit_pdu(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
+		const void *data_buf, u32 data_buf_len)
+{
+	struct cxgbit_sock *csk = conn->context;
+	struct cxgbit_cmd *ccmd = iscsit_priv_cmd(cmd);
+	struct sk_buff *skb = ccmd->skb;
+
+	ccmd->skb = NULL;
+
+	if (data_buf_len) {
+		u32 padding = ((-data_buf_len) & 3);
+		u32 nr_frags = DIV_ROUND_UP(data_buf_len +
+					    padding, PAGE_SIZE);
+		u32 pad_bytes = 0;
+		u8 i;
+
+		for (i = 0; i < nr_frags; i++) {
+			struct page *page;
+
+			page = alloc_page(GFP_KERNEL);
+			if (!page) {
+				__kfree_skb(skb);
+				return -ENOMEM;
+			}
+
+			skb_fill_page_desc(skb, i, page, 0, PAGE_SIZE);
+			skb->truesize += PAGE_SIZE;
+		}
+
+		skb->data_len = data_buf_len + padding;
+		skb->len += skb->data_len;
+
+		skb_store_bits(skb, ISCSI_HDR_LEN, data_buf, data_buf_len);
+
+		if (padding)
+			skb_store_bits(skb, ISCSI_HDR_LEN + data_buf_len,
+				       &pad_bytes, padding);
+
+		cxgbit_skcb_submode(skb) |= (csk->submode &
+					     CXGBIT_SUBMODE_DCRC);
+	}
+
+	cxgbit_skcb_tx_extralen(skb) = cxgbit_digest_len[
+				       cxgbit_skcb_submode(skb)];
+
+	return cxgbit_queue_skb(csk, skb);
+}
+
+int cxgbit_validate_params(struct iscsi_conn *conn)
+{
+	struct cxgbit_sock *csk = conn->context;
+	struct cxgbit_device *cdev = csk->com.cdev;
+	struct iscsi_param *param;
+	u32 max_xmitdsl;
+
+	param = iscsi_find_param_from_key(MAXXMITDATASEGMENTLENGTH,
+					  conn->param_list);
+	if (!param)
+		return -1;
+
+	if (kstrtou32(param->value, 0, &max_xmitdsl) < 0)
+		return -1;
+
+	if (max_xmitdsl > cdev->mdsl) {
+		if (iscsi_change_param_sprintf
+		    (conn, "MaxXmitDataSegmentLength=%u",
+		     cdev->mdsl))
+			return -1;
+	}
+
+	return 0;
+}
+
+static int cxgbit_set_digest(struct cxgbit_sock *csk)
+{
+	struct iscsi_conn *conn = csk->conn;
+	struct iscsi_param *param;
+
+	param = iscsi_find_param_from_key(HEADERDIGEST, conn->param_list);
+	if (!param) {
+		pr_err("param not found key %s\n", HEADERDIGEST);
+		return -1;
+	}
+
+	if (!strcmp(param->value, CRC32C))
+		csk->submode |= CXGBIT_SUBMODE_HCRC;
+
+	param = iscsi_find_param_from_key(DATADIGEST, conn->param_list);
+	if (!param) {
+		csk->submode = 0;
+		pr_err("param not found key %s\n", DATADIGEST);
+		return -1;
+	}
+
+	if (!strcmp(param->value, CRC32C))
+		csk->submode |= CXGBIT_SUBMODE_DCRC;
+
+	if (cxgbit_setup_conn_digest(csk)) {
+		csk->submode = 0;
+		return -1;
+	}
+
+	return 0;
+}
+
+static int cxgbit_set_iso_npdu(struct cxgbit_sock *csk)
+{
+	struct iscsi_conn *conn = csk->conn;
+	struct iscsi_conn_ops *conn_ops = conn->conn_ops;
+	struct iscsi_param *param;
+	u32 mrdsl, mbl;
+	u32 max_npdu, max_iso_npdu;
+
+	if (conn->login->leading_connection) {
+		param = iscsi_find_param_from_key(DATASEQUENCEINORDER,
+						  conn->param_list);
+		if (!param) {
+			pr_err("param not found key %s\n", DATASEQUENCEINORDER);
+			return -1;
+		}
+
+		if (strcmp(param->value, YES))
+			return 0;
+
+		param = iscsi_find_param_from_key(DATAPDUINORDER,
+						  conn->param_list);
+		if (!param) {
+			pr_err("param not found key %s\n", DATAPDUINORDER);
+			return -1;
+		}
+
+		if (strcmp(param->value, YES))
+			return 0;
+
+		param = iscsi_find_param_from_key(MAXBURSTLENGTH,
+						  conn->param_list);
+		if (!param) {
+			pr_err("param not found key %s\n", MAXBURSTLENGTH);
+			return -1;
+		}
+
+		if (kstrtou32(param->value, 0, &mbl) < 0)
+			return -1;
+	} else {
+		if (!conn->sess->sess_ops->DataSequenceInOrder)
+			return 0;
+		if (!conn->sess->sess_ops->DataPDUInOrder)
+			return 0;
+
+		mbl = conn->sess->sess_ops->MaxBurstLength;
+	}
+
+	mrdsl = conn_ops->MaxRecvDataSegmentLength;
+	max_npdu = mbl / mrdsl;
+
+	max_iso_npdu = CXGBIT_MAX_ISO_PAYLOAD /
+			(ISCSI_HDR_LEN + mrdsl +
+			cxgbit_digest_len[csk->submode]);
+
+	csk->max_iso_npdu = min(max_npdu, max_iso_npdu);
+
+	if (csk->max_iso_npdu <= 1)
+		csk->max_iso_npdu = 0;
+
+	return 0;
+}
+
+static int cxgbit_set_params(struct iscsi_conn *conn)
+{
+	struct cxgbit_sock *csk = conn->context;
+	struct cxgbit_device *cdev = csk->com.cdev;
+	struct cxgbi_ppm *ppm = *csk->com.cdev->lldi.iscsi_ppm;
+	struct iscsi_conn_ops *conn_ops = conn->conn_ops;
+	struct iscsi_param *param;
+	u8 erl;
+
+	if (conn_ops->MaxRecvDataSegmentLength > cdev->mdsl)
+		conn_ops->MaxRecvDataSegmentLength = cdev->mdsl;
+
+	if (conn->login->leading_connection) {
+		param = iscsi_find_param_from_key(ERRORRECOVERYLEVEL,
+						  conn->param_list);
+		if (!param) {
+			pr_err("param not found key %s\n", ERRORRECOVERYLEVEL);
+			return -1;
+		}
+		if (kstrtou8(param->value, 0, &erl) < 0)
+			return -1;
+	} else {
+		erl = conn->sess->sess_ops->ErrorRecoveryLevel;
+	}
+
+	if (!erl) {
+		if (test_bit(CDEV_ISO_ENABLE, &cdev->flags)) {
+			if (cxgbit_set_iso_npdu(csk))
+				return -1;
+		}
+
+		if (test_bit(CDEV_DDP_ENABLE, &cdev->flags)) {
+			if (cxgbit_setup_conn_pgidx(csk,
+						    ppm->tformat.pgsz_idx_dflt))
+				return -1;
+			set_bit(CSK_DDP_ENABLE, &csk->com.flags);
+		}
+	}
+
+	if (cxgbit_set_digest(csk))
+		return -1;
+
+	return 0;
+}
+
+int
+cxgbit_put_login_tx(struct iscsi_conn *conn, struct iscsi_login *login,
+		    u32 length)
+{
+	struct cxgbit_sock *csk = conn->context;
+	struct sk_buff *skb;
+	u32 padding_buf = 0;
+	u8 padding = ((-length) & 3);
+
+	skb = cxgbit_alloc_skb(csk, length + padding);
+	if (!skb)
+		return -ENOMEM;
+	skb_store_bits(skb, 0, login->rsp, ISCSI_HDR_LEN);
+	skb_store_bits(skb, ISCSI_HDR_LEN, login->rsp_buf, length);
+
+	if (padding)
+		skb_store_bits(skb, ISCSI_HDR_LEN + length,
+			       &padding_buf, padding);
+
+	if (login->login_complete) {
+		if (cxgbit_set_params(conn)) {
+			kfree_skb(skb);
+			return -1;
+		}
+
+		set_bit(CSK_LOGIN_DONE, &csk->com.flags);
+	}
+
+	if (cxgbit_queue_skb(csk, skb))
+		return -1;
+
+	if ((!login->login_complete) && (!login->login_failed))
+		schedule_delayed_work(&conn->login_work, 0);
+
+	return 0;
+}
+
+static void
+cxgbit_skb_copy_to_sg(struct sk_buff *skb, struct scatterlist *sg,
+		      unsigned int nents)
+{
+	struct skb_seq_state st;
+	const u8 *buf;
+	unsigned int consumed = 0, buf_len;
+	struct cxgbit_lro_pdu_cb *pdu_cb = cxgbit_rx_pdu_cb(skb);
+
+	skb_prepare_seq_read(skb, pdu_cb->doffset,
+			     pdu_cb->doffset + pdu_cb->dlen,
+			     &st);
+
+	while (true) {
+		buf_len = skb_seq_read(consumed, &buf, &st);
+		if (!buf_len) {
+			skb_abort_seq_read(&st);
+			break;
+		}
+
+		consumed += sg_pcopy_from_buffer(sg, nents, (void *)buf,
+						 buf_len, consumed);
+	}
+}
+
+static struct iscsi_cmd *cxgbit_allocate_cmd(struct cxgbit_sock *csk)
+{
+	struct iscsi_conn *conn = csk->conn;
+	struct cxgbi_ppm *ppm = cdev2ppm(csk->com.cdev);
+	struct cxgbit_cmd *ccmd;
+	struct iscsi_cmd *cmd;
+
+	cmd = iscsit_allocate_cmd(conn, TASK_INTERRUPTIBLE);
+	if (!cmd) {
+		pr_err("Unable to allocate iscsi_cmd + cxgbit_cmd\n");
+		return NULL;
+	}
+
+	ccmd = iscsit_priv_cmd(cmd);
+	ccmd->ttinfo.tag = ppm->tformat.no_ddp_mask;
+	ccmd->setup_ddp = true;
+
+	return cmd;
+}
+
+static int
+cxgbit_handle_immediate_data(struct iscsi_cmd *cmd, struct iscsi_scsi_req *hdr,
+			     u32 length)
+{
+	struct iscsi_conn *conn = cmd->conn;
+	struct cxgbit_sock *csk = conn->context;
+	struct cxgbit_lro_pdu_cb *pdu_cb = cxgbit_rx_pdu_cb(csk->skb);
+
+	if (pdu_cb->flags & PDUCBF_RX_DCRC_ERR) {
+		pr_err("ImmediateData CRC32C DataDigest error\n");
+		if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
+			pr_err("Unable to recover from"
+			       " Immediate Data digest failure while"
+			       " in ERL=0.\n");
+			iscsit_reject_cmd(cmd, ISCSI_REASON_DATA_DIGEST_ERROR,
+					  (unsigned char *)hdr);
+			return IMMEDIATE_DATA_CANNOT_RECOVER;
+		}
+
+		iscsit_reject_cmd(cmd, ISCSI_REASON_DATA_DIGEST_ERROR,
+				  (unsigned char *)hdr);
+		return IMMEDIATE_DATA_ERL1_CRC_FAILURE;
+	}
+
+	if (cmd->se_cmd.se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC) {
+		struct cxgbit_cmd *ccmd = iscsit_priv_cmd(cmd);
+		struct skb_shared_info *ssi = skb_shinfo(csk->skb);
+		skb_frag_t *dfrag = &ssi->frags[pdu_cb->dfrag_idx];
+
+		sg_init_table(&ccmd->sg, 1);
+		sg_set_page(&ccmd->sg, dfrag->page.p, skb_frag_size(dfrag),
+			    dfrag->page_offset);
+		get_page(dfrag->page.p);
+
+		cmd->se_cmd.t_data_sg = &ccmd->sg;
+		cmd->se_cmd.t_data_nents = 1;
+
+		ccmd->release = true;
+	} else {
+		struct scatterlist *sg = &cmd->se_cmd.t_data_sg[0];
+		u32 sg_nents = max(1UL, DIV_ROUND_UP(pdu_cb->dlen, PAGE_SIZE));
+
+		cxgbit_skb_copy_to_sg(csk->skb, sg, sg_nents);
+	}
+
+	cmd->write_data_done += pdu_cb->dlen;
+
+	if (cmd->write_data_done == cmd->se_cmd.data_length) {
+		spin_lock_bh(&cmd->istate_lock);
+		cmd->cmd_flags |= ICF_GOT_LAST_DATAOUT;
+		cmd->i_state = ISTATE_RECEIVED_LAST_DATAOUT;
+		spin_unlock_bh(&cmd->istate_lock);
+	}
+
+	return IMMEDIATE_DATA_NORMAL_OPERATION;
+}
+
+static int
+cxgbit_get_immediate_data(struct iscsi_cmd *cmd, struct iscsi_scsi_req *hdr,
+			  bool dump_payload)
+{
+	struct iscsi_conn *conn = cmd->conn;
+	int cmdsn_ret = 0, immed_ret = IMMEDIATE_DATA_NORMAL_OPERATION;
+	/*
+	 * Special case for Unsupported SAM WRITE Opcodes and ImmediateData=Yes.
+	 */
+	if (dump_payload)
+		goto after_immediate_data;
+
+	immed_ret = cxgbit_handle_immediate_data(cmd, hdr,
+						 cmd->first_burst_len);
+after_immediate_data:
+	if (immed_ret == IMMEDIATE_DATA_NORMAL_OPERATION) {
+		/*
+		 * A PDU/CmdSN carrying Immediate Data passed
+		 * DataCRC, check against ExpCmdSN/MaxCmdSN if
+		 * Immediate Bit is not set.
+		 */
+		cmdsn_ret = iscsit_sequence_cmd(conn, cmd,
+						(unsigned char *)hdr,
+						hdr->cmdsn);
+		if (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER)
+			return -1;
+
+		if (cmd->sense_reason || cmdsn_ret == CMDSN_LOWER_THAN_EXP) {
+			target_put_sess_cmd(&cmd->se_cmd);
+			return 0;
+		} else if (cmd->unsolicited_data) {
+			iscsit_set_unsoliticed_dataout(cmd);
+		}
+
+	} else if (immed_ret == IMMEDIATE_DATA_ERL1_CRC_FAILURE) {
+		/*
+		 * Immediate Data failed DataCRC and ERL>=1,
+		 * silently drop this PDU and let the initiator
+		 * plug the CmdSN gap.
+		 *
+		 * FIXME: Send Unsolicited NOPIN with reserved
+		 * TTT here to help the initiator figure out
+		 * the missing CmdSN, although they should be
+		 * intelligent enough to determine the missing
+		 * CmdSN and issue a retry to plug the sequence.
+		 */
+		cmd->i_state = ISTATE_REMOVE;
+		iscsit_add_cmd_to_immediate_queue(cmd, conn, cmd->i_state);
+	} else /* immed_ret == IMMEDIATE_DATA_CANNOT_RECOVER */
+		return -1;
+
+	return 0;
+}
+
+static int
+cxgbit_handle_scsi_cmd(struct cxgbit_sock *csk, struct iscsi_cmd *cmd)
+{
+	struct iscsi_conn *conn = csk->conn;
+	struct cxgbit_lro_pdu_cb *pdu_cb = cxgbit_rx_pdu_cb(csk->skb);
+	struct iscsi_scsi_req *hdr = (struct iscsi_scsi_req *)pdu_cb->hdr;
+	int rc;
+	bool dump_payload = false;
+
+	rc = iscsit_setup_scsi_cmd(conn, cmd, (unsigned char *)hdr);
+	if (rc < 0)
+		return rc;
+
+	if (pdu_cb->dlen && (pdu_cb->dlen == cmd->se_cmd.data_length) &&
+	    (pdu_cb->nr_dfrags == 1))
+		cmd->se_cmd.se_cmd_flags |= SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC;
+
+	rc = iscsit_process_scsi_cmd(conn, cmd, hdr);
+	if (rc < 0)
+		return 0;
+	else if (rc > 0)
+		dump_payload = true;
+
+	if (!pdu_cb->dlen)
+		return 0;
+
+	return cxgbit_get_immediate_data(cmd, hdr, dump_payload);
+}
+
+static int cxgbit_handle_iscsi_dataout(struct cxgbit_sock *csk)
+{
+	struct scatterlist *sg_start;
+	struct iscsi_conn *conn = csk->conn;
+	struct iscsi_cmd *cmd = NULL;
+	struct cxgbit_lro_pdu_cb *pdu_cb = cxgbit_rx_pdu_cb(csk->skb);
+	struct iscsi_data *hdr = (struct iscsi_data *)pdu_cb->hdr;
+	u32 data_offset = be32_to_cpu(hdr->offset);
+	u32 data_len = pdu_cb->dlen;
+	int rc, sg_nents, sg_off;
+	bool dcrc_err = false;
+
+	rc = iscsit_check_dataout_hdr(conn, (unsigned char *)hdr, &cmd);
+	if (rc < 0)
+		return rc;
+	else if (!cmd)
+		return 0;
+
+	if (pdu_cb->flags & PDUCBF_RX_DCRC_ERR) {
+		pr_err("ITT: 0x%08x, Offset: %u, Length: %u,"
+		       " DataSN: 0x%08x\n",
+		       hdr->itt, hdr->offset, data_len,
+		       hdr->datasn);
+
+		dcrc_err = true;
+		goto check_payload;
+	}
+
+	pr_debug("DataOut data_len: %u, "
+		"write_data_done: %u, data_length: %u\n",
+		  data_len,  cmd->write_data_done,
+		  cmd->se_cmd.data_length);
+
+	if (!(pdu_cb->flags & PDUCBF_RX_DATA_DDPD)) {
+		sg_off = data_offset / PAGE_SIZE;
+		sg_start = &cmd->se_cmd.t_data_sg[sg_off];
+		sg_nents = max(1UL, DIV_ROUND_UP(data_len, PAGE_SIZE));
+
+		cxgbit_skb_copy_to_sg(csk->skb, sg_start, sg_nents);
+	}
+
+check_payload:
+
+	rc = iscsit_check_dataout_payload(cmd, hdr, dcrc_err);
+	if (rc < 0)
+		return rc;
+
+	return 0;
+}
+
+static int cxgbit_handle_nop_out(struct cxgbit_sock *csk, struct iscsi_cmd *cmd)
+{
+	struct iscsi_conn *conn = csk->conn;
+	struct cxgbit_lro_pdu_cb *pdu_cb = cxgbit_rx_pdu_cb(csk->skb);
+	struct iscsi_nopout *hdr = (struct iscsi_nopout *)pdu_cb->hdr;
+	unsigned char *ping_data = NULL;
+	u32 payload_length = pdu_cb->dlen;
+	int ret;
+
+	ret = iscsit_setup_nop_out(conn, cmd, hdr);
+	if (ret < 0)
+		return 0;
+
+	if (pdu_cb->flags & PDUCBF_RX_DCRC_ERR) {
+		if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
+			pr_err("Unable to recover from"
+			       " NOPOUT Ping DataCRC failure while in"
+			       " ERL=0.\n");
+			ret = -1;
+			goto out;
+		} else {
+			/*
+			 * drop this PDU and let the
+			 * initiator plug the CmdSN gap.
+			 */
+			pr_info("Dropping NOPOUT"
+				" Command CmdSN: 0x%08x due to"
+				" DataCRC error.\n", hdr->cmdsn);
+			ret = 0;
+			goto out;
+		}
+	}
+
+	/*
+	 * Handle NOP-OUT payload for traditional iSCSI sockets
+	 */
+	if (payload_length && hdr->ttt == cpu_to_be32(0xFFFFFFFF)) {
+		ping_data = kzalloc(payload_length + 1, GFP_KERNEL);
+		if (!ping_data) {
+			pr_err("Unable to allocate memory for"
+				" NOPOUT ping data.\n");
+			ret = -1;
+			goto out;
+		}
+
+		skb_copy_bits(csk->skb, pdu_cb->doffset,
+			      ping_data, payload_length);
+
+		ping_data[payload_length] = '\0';
+		/*
+		 * Attach ping data to struct iscsi_cmd->buf_ptr.
+		 */
+		cmd->buf_ptr = ping_data;
+		cmd->buf_ptr_size = payload_length;
+
+		pr_debug("Got %u bytes of NOPOUT ping"
+			" data.\n", payload_length);
+		pr_debug("Ping Data: \"%s\"\n", ping_data);
+	}
+
+	return iscsit_process_nop_out(conn, cmd, hdr);
+out:
+	if (cmd)
+		iscsit_free_cmd(cmd, false);
+	return ret;
+}
+
+static int
+cxgbit_handle_text_cmd(struct cxgbit_sock *csk, struct iscsi_cmd *cmd)
+{
+	struct iscsi_conn *conn = csk->conn;
+	struct cxgbit_lro_pdu_cb *pdu_cb = cxgbit_rx_pdu_cb(csk->skb);
+	struct iscsi_text *hdr = (struct iscsi_text *)pdu_cb->hdr;
+	u32 payload_length = pdu_cb->dlen;
+	int rc;
+	unsigned char *text_in = NULL;
+
+	rc = iscsit_setup_text_cmd(conn, cmd, hdr);
+	if (rc < 0)
+		return rc;
+
+	if (pdu_cb->flags & PDUCBF_RX_DCRC_ERR) {
+		if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
+			pr_err("Unable to recover from"
+			       " Text Data digest failure while in"
+			       " ERL=0.\n");
+			goto reject;
+		} else {
+			/*
+			 * drop this PDU and let the
+			 * initiator plug the CmdSN gap.
+			 */
+			pr_info("Dropping Text"
+				" Command CmdSN: 0x%08x due to"
+				" DataCRC error.\n", hdr->cmdsn);
+			return 0;
+		}
+	}
+
+	if (payload_length) {
+		text_in = kzalloc(payload_length, GFP_KERNEL);
+		if (!text_in) {
+			pr_err("Unable to allocate text_in of payload_length: %u\n",
+			       payload_length);
+			return -ENOMEM;
+		}
+		skb_copy_bits(csk->skb, pdu_cb->doffset,
+			      text_in, payload_length);
+
+		text_in[payload_length - 1] = '\0';
+
+		cmd->text_in_ptr = text_in;
+	}
+
+	return iscsit_process_text_cmd(conn, cmd, hdr);
+
+reject:
+	return iscsit_reject_cmd(cmd, ISCSI_REASON_PROTOCOL_ERROR,
+				 pdu_cb->hdr);
+}
+
+static int cxgbit_target_rx_opcode(struct cxgbit_sock *csk)
+{
+	struct cxgbit_lro_pdu_cb *pdu_cb = cxgbit_rx_pdu_cb(csk->skb);
+	struct iscsi_hdr *hdr = (struct iscsi_hdr *)pdu_cb->hdr;
+	struct iscsi_conn *conn = csk->conn;
+	struct iscsi_cmd *cmd = NULL;
+	u8 opcode = (hdr->opcode & ISCSI_OPCODE_MASK);
+	int ret = -EINVAL;
+
+	switch (opcode) {
+	case ISCSI_OP_SCSI_CMD:
+		cmd = cxgbit_allocate_cmd(csk);
+		if (!cmd)
+			goto reject;
+
+		ret = cxgbit_handle_scsi_cmd(csk, cmd);
+		break;
+	case ISCSI_OP_SCSI_DATA_OUT:
+		ret = cxgbit_handle_iscsi_dataout(csk);
+		break;
+	case ISCSI_OP_NOOP_OUT:
+		if (hdr->ttt == cpu_to_be32(0xFFFFFFFF)) {
+			cmd = cxgbit_allocate_cmd(csk);
+			if (!cmd)
+				goto reject;
+		}
+
+		ret = cxgbit_handle_nop_out(csk, cmd);
+		break;
+	case ISCSI_OP_SCSI_TMFUNC:
+		cmd = cxgbit_allocate_cmd(csk);
+		if (!cmd)
+			goto reject;
+
+		ret = iscsit_handle_task_mgt_cmd(conn, cmd,
+						 (unsigned char *)hdr);
+		break;
+	case ISCSI_OP_TEXT:
+		if (hdr->ttt != cpu_to_be32(0xFFFFFFFF)) {
+			cmd = iscsit_find_cmd_from_itt(conn, hdr->itt);
+			if (!cmd)
+				goto reject;
+		} else {
+			cmd = cxgbit_allocate_cmd(csk);
+			if (!cmd)
+				goto reject;
+		}
+
+		ret = cxgbit_handle_text_cmd(csk, cmd);
+		break;
+	case ISCSI_OP_LOGOUT:
+		cmd = cxgbit_allocate_cmd(csk);
+		if (!cmd)
+			goto reject;
+
+		ret = iscsit_handle_logout_cmd(conn, cmd, (unsigned char *)hdr);
+		if (ret > 0)
+			wait_for_completion_timeout(&conn->conn_logout_comp,
+						    SECONDS_FOR_LOGOUT_COMP
+						    * HZ);
+		break;
+	case ISCSI_OP_SNACK:
+		ret = iscsit_handle_snack(conn, (unsigned char *)hdr);
+		break;
+	default:
+		pr_err("Got unknown iSCSI OpCode: 0x%02x\n", opcode);
+		dump_stack();
+		break;
+	}
+
+	return ret;
+
+reject:
+	return iscsit_add_reject(conn, ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+				 (unsigned char *)hdr);
+	return ret;
+}
+
+static int cxgbit_rx_opcode(struct cxgbit_sock *csk)
+{
+	struct cxgbit_lro_pdu_cb *pdu_cb = cxgbit_rx_pdu_cb(csk->skb);
+	struct iscsi_conn *conn = csk->conn;
+	struct iscsi_hdr *hdr = pdu_cb->hdr;
+	u8 opcode;
+
+	if (pdu_cb->flags & PDUCBF_RX_HCRC_ERR) {
+		atomic_long_inc(&conn->sess->conn_digest_errors);
+		goto transport_err;
+	}
+
+	if (conn->conn_state == TARG_CONN_STATE_IN_LOGOUT)
+		goto transport_err;
+
+	opcode = hdr->opcode & ISCSI_OPCODE_MASK;
+
+	if (conn->sess->sess_ops->SessionType &&
+	    ((!(opcode & ISCSI_OP_TEXT)) ||
+	     (!(opcode & ISCSI_OP_LOGOUT)))) {
+		pr_err("Received illegal iSCSI Opcode: 0x%02x"
+			" while in Discovery Session, rejecting.\n", opcode);
+		iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
+				  (unsigned char *)hdr);
+		goto transport_err;
+	}
+
+	if (cxgbit_target_rx_opcode(csk) < 0)
+		goto transport_err;
+
+	return 0;
+
+transport_err:
+	return -1;
+}
+
+static int cxgbit_rx_login_pdu(struct cxgbit_sock *csk)
+{
+	struct iscsi_conn *conn = csk->conn;
+	struct iscsi_login *login = conn->login;
+	struct cxgbit_lro_pdu_cb *pdu_cb = cxgbit_rx_pdu_cb(csk->skb);
+	struct iscsi_login_req *login_req;
+
+	login_req = (struct iscsi_login_req *)login->req;
+	memcpy(login_req, pdu_cb->hdr, sizeof(*login_req));
+
+	pr_debug("Got Login Command, Flags 0x%02x, ITT: 0x%08x,"
+		" CmdSN: 0x%08x, ExpStatSN: 0x%08x, CID: %hu, Length: %u\n",
+		login_req->flags, login_req->itt, login_req->cmdsn,
+		login_req->exp_statsn, login_req->cid, pdu_cb->dlen);
+	/*
+	 * Setup the initial iscsi_login values from the leading
+	 * login request PDU.
+	 */
+	if (login->first_request) {
+		login_req = (struct iscsi_login_req *)login->req;
+		login->leading_connection = (!login_req->tsih) ? 1 : 0;
+		login->current_stage	= ISCSI_LOGIN_CURRENT_STAGE(
+				login_req->flags);
+		login->version_min	= login_req->min_version;
+		login->version_max	= login_req->max_version;
+		memcpy(login->isid, login_req->isid, 6);
+		login->cmd_sn		= be32_to_cpu(login_req->cmdsn);
+		login->init_task_tag	= login_req->itt;
+		login->initial_exp_statsn = be32_to_cpu(login_req->exp_statsn);
+		login->cid		= be16_to_cpu(login_req->cid);
+		login->tsih		= be16_to_cpu(login_req->tsih);
+	}
+
+	if (iscsi_target_check_login_request(conn, login) < 0)
+		return -1;
+
+	memset(login->req_buf, 0, MAX_KEY_VALUE_PAIRS);
+	skb_copy_bits(csk->skb, pdu_cb->doffset, login->req_buf, pdu_cb->dlen);
+
+	return 0;
+}
+
+static int
+cxgbit_process_iscsi_pdu(struct cxgbit_sock *csk, struct sk_buff *skb, int idx)
+{
+	struct cxgbit_lro_pdu_cb *pdu_cb = cxgbit_skb_lro_pdu_cb(skb, idx);
+	int ret;
+
+	cxgbit_rx_pdu_cb(skb) = pdu_cb;
+
+	csk->skb = skb;
+
+	if (!test_bit(CSK_LOGIN_DONE, &csk->com.flags)) {
+		ret = cxgbit_rx_login_pdu(csk);
+		set_bit(CSK_LOGIN_PDU_DONE, &csk->com.flags);
+	} else {
+		ret = cxgbit_rx_opcode(csk);
+	}
+
+	return ret;
+}
+
+static void cxgbit_lro_skb_dump(struct sk_buff *skb)
+{
+	struct skb_shared_info *ssi = skb_shinfo(skb);
+	struct cxgbit_lro_cb *lro_cb = cxgbit_skb_lro_cb(skb);
+	struct cxgbit_lro_pdu_cb *pdu_cb = cxgbit_skb_lro_pdu_cb(skb, 0);
+	u8 i;
+
+	pr_info("skb 0x%p, head 0x%p, 0x%p, len %u,%u, frags %u.\n",
+		skb, skb->head, skb->data, skb->len, skb->data_len,
+		ssi->nr_frags);
+	pr_info("skb 0x%p, lro_cb, csk 0x%p, pdu %u, %u.\n",
+		skb, lro_cb->csk, lro_cb->pdu_idx, lro_cb->pdu_totallen);
+
+	for (i = 0; i < lro_cb->pdu_idx; i++, pdu_cb++)
+		pr_info("skb 0x%p, pdu %d, %u, f 0x%x, seq 0x%x, dcrc 0x%x, "
+			"frags %u.\n",
+			skb, i, pdu_cb->pdulen, pdu_cb->flags, pdu_cb->seq,
+			pdu_cb->ddigest, pdu_cb->frags);
+	for (i = 0; i < ssi->nr_frags; i++)
+		pr_info("skb 0x%p, frag %d, off %u, sz %u.\n",
+			skb, i, ssi->frags[i].page_offset, ssi->frags[i].size);
+}
+
+static void cxgbit_lro_hskb_reset(struct cxgbit_sock *csk)
+{
+	struct sk_buff *skb = csk->lro_hskb;
+	struct skb_shared_info *ssi = skb_shinfo(skb);
+	u8 i;
+
+	memset(skb->data, 0, LRO_SKB_MIN_HEADROOM);
+	for (i = 0; i < ssi->nr_frags; i++)
+		put_page(skb_frag_page(&ssi->frags[i]));
+	ssi->nr_frags = 0;
+}
+
+static void
+cxgbit_lro_skb_merge(struct cxgbit_sock *csk, struct sk_buff *skb, u8 pdu_idx)
+{
+	struct sk_buff *hskb = csk->lro_hskb;
+	struct cxgbit_lro_pdu_cb *hpdu_cb = cxgbit_skb_lro_pdu_cb(hskb, 0);
+	struct cxgbit_lro_pdu_cb *pdu_cb = cxgbit_skb_lro_pdu_cb(skb, pdu_idx);
+	struct skb_shared_info *hssi = skb_shinfo(hskb);
+	struct skb_shared_info *ssi = skb_shinfo(skb);
+	unsigned int len = 0;
+
+	if (pdu_cb->flags & PDUCBF_RX_HDR) {
+		hpdu_cb->flags = pdu_cb->flags;
+		hpdu_cb->seq = pdu_cb->seq;
+		hpdu_cb->hdr = pdu_cb->hdr;
+		hpdu_cb->hlen = pdu_cb->hlen;
+
+		memcpy(&hssi->frags[0], &ssi->frags[pdu_cb->hfrag_idx],
+		       sizeof(skb_frag_t));
+
+		get_page(skb_frag_page(&hssi->frags[0]));
+		hssi->nr_frags = 1;
+		hpdu_cb->frags = 1;
+		hpdu_cb->hfrag_idx = 0;
+
+		len = hssi->frags[0].size;
+		hskb->len = len;
+		hskb->data_len = len;
+		hskb->truesize = len;
+	}
+
+	if (pdu_cb->flags & PDUCBF_RX_DATA) {
+		u8 hfrag_idx = 1, i;
+
+		hpdu_cb->flags |= pdu_cb->flags;
+
+		len = 0;
+		for (i = 0; i < pdu_cb->nr_dfrags; hfrag_idx++, i++) {
+			memcpy(&hssi->frags[hfrag_idx],
+			       &ssi->frags[pdu_cb->dfrag_idx + i],
+			       sizeof(skb_frag_t));
+
+			get_page(skb_frag_page(&hssi->frags[hfrag_idx]));
+
+			len += hssi->frags[hfrag_idx].size;
+
+			hssi->nr_frags++;
+			hpdu_cb->frags++;
+		}
+
+		hpdu_cb->dlen = pdu_cb->dlen;
+		hpdu_cb->doffset = hpdu_cb->hlen;
+		hpdu_cb->nr_dfrags = pdu_cb->nr_dfrags;
+		hpdu_cb->dfrag_idx = 1;
+		hskb->len += len;
+		hskb->data_len += len;
+		hskb->truesize += len;
+	}
+
+	if (pdu_cb->flags & PDUCBF_RX_STATUS) {
+		hpdu_cb->flags |= pdu_cb->flags;
+
+		if (hpdu_cb->flags & PDUCBF_RX_DATA)
+			hpdu_cb->flags &= ~PDUCBF_RX_DATA_DDPD;
+
+		hpdu_cb->ddigest = pdu_cb->ddigest;
+		hpdu_cb->pdulen = pdu_cb->pdulen;
+	}
+}
+
+static int cxgbit_process_lro_skb(struct cxgbit_sock *csk, struct sk_buff *skb)
+{
+	struct cxgbit_lro_cb *lro_cb = cxgbit_skb_lro_cb(skb);
+	struct cxgbit_lro_pdu_cb *pdu_cb = cxgbit_skb_lro_pdu_cb(skb, 0);
+	u8 pdu_idx = 0, last_idx = 0;
+	int ret = 0;
+
+	if (!pdu_cb->complete) {
+		cxgbit_lro_skb_merge(csk, skb, 0);
+
+		if (pdu_cb->flags & PDUCBF_RX_STATUS) {
+			struct sk_buff *hskb = csk->lro_hskb;
+
+			ret = cxgbit_process_iscsi_pdu(csk, hskb, 0);
+
+			cxgbit_lro_hskb_reset(csk);
+
+			if (ret < 0)
+				goto out;
+		}
+
+		pdu_idx = 1;
+	}
+
+	if (lro_cb->pdu_idx)
+		last_idx = lro_cb->pdu_idx - 1;
+
+	for (; pdu_idx <= last_idx; pdu_idx++) {
+		ret = cxgbit_process_iscsi_pdu(csk, skb, pdu_idx);
+		if (ret < 0)
+			goto out;
+	}
+
+	if ((!lro_cb->complete) && lro_cb->pdu_idx)
+		cxgbit_lro_skb_merge(csk, skb, lro_cb->pdu_idx);
+
+out:
+	return ret;
+}
+
+static int cxgbit_rx_lro_skb(struct cxgbit_sock *csk, struct sk_buff *skb)
+{
+	struct cxgbit_lro_cb *lro_cb = cxgbit_skb_lro_cb(skb);
+	struct cxgbit_lro_pdu_cb *pdu_cb = cxgbit_skb_lro_pdu_cb(skb, 0);
+	int ret = -1;
+
+	if ((pdu_cb->flags & PDUCBF_RX_HDR) &&
+	    (pdu_cb->seq != csk->rcv_nxt)) {
+		pr_info("csk 0x%p, tid 0x%x, seq 0x%x != 0x%x.\n",
+			csk, csk->tid, pdu_cb->seq, csk->rcv_nxt);
+		cxgbit_lro_skb_dump(skb);
+		return ret;
+	}
+
+	csk->rcv_nxt += lro_cb->pdu_totallen;
+
+	ret = cxgbit_process_lro_skb(csk, skb);
+
+	csk->rx_credits += lro_cb->pdu_totallen;
+
+	if (csk->rx_credits >= (csk->rcv_win / 4))
+		cxgbit_rx_data_ack(csk);
+
+	return ret;
+}
+
+static int cxgbit_rx_skb(struct cxgbit_sock *csk, struct sk_buff *skb)
+{
+	int ret = -1;
+
+	if (likely(cxgbit_skcb_flags(skb) & SKCBF_RX_LRO))
+		ret = cxgbit_rx_lro_skb(csk, skb);
+
+	__kfree_skb(skb);
+	return ret;
+}
+
+static bool cxgbit_rxq_len(struct cxgbit_sock *csk, struct sk_buff_head *rxq)
+{
+	spin_lock_bh(&csk->rxq.lock);
+	if (skb_queue_len(&csk->rxq)) {
+		skb_queue_splice_init(&csk->rxq, rxq);
+		spin_unlock_bh(&csk->rxq.lock);
+		return true;
+	}
+	spin_unlock_bh(&csk->rxq.lock);
+	return false;
+}
+
+static int cxgbit_wait_rxq(struct cxgbit_sock *csk)
+{
+	struct sk_buff *skb;
+	struct sk_buff_head rxq;
+
+	skb_queue_head_init(&rxq);
+
+	wait_event_interruptible(csk->waitq, cxgbit_rxq_len(csk, &rxq));
+
+	if (signal_pending(current))
+		goto out;
+
+	while ((skb = __skb_dequeue(&rxq))) {
+		if (cxgbit_rx_skb(csk, skb))
+			goto out;
+	}
+
+	return 0;
+out:
+	__skb_queue_purge(&rxq);
+	return -1;
+}
+
+int cxgbit_get_login_rx(struct iscsi_conn *conn, struct iscsi_login *login)
+{
+	struct cxgbit_sock *csk = conn->context;
+	int ret = -1;
+
+	while (!test_and_clear_bit(CSK_LOGIN_PDU_DONE, &csk->com.flags)) {
+		ret = cxgbit_wait_rxq(csk);
+		if (ret) {
+			clear_bit(CSK_LOGIN_PDU_DONE, &csk->com.flags);
+			break;
+		}
+	}
+
+	return ret;
+}
+
+void cxgbit_get_rx_pdu(struct iscsi_conn *conn)
+{
+	struct cxgbit_sock *csk = conn->context;
+
+	while (!kthread_should_stop()) {
+		iscsit_thread_check_cpumask(conn, current, 0);
+		if (cxgbit_wait_rxq(csk))
+			return;
+	}
+}
-- 
2.0.2

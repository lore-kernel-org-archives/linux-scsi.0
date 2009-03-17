From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 11/14] fcoe: cleans up libfcoe.h and adds fcoe.h for fcoe
	module
Date: Tue, 17 Mar 2009 11:42:24 -0700
Message-ID: <20090317184224.22987.60607.stgit@fritz>
References: <20090317184124.22987.65368.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:8698 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760272AbZCQSm0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Mar 2009 14:42:26 -0400
In-Reply-To: <20090317184124.22987.65368.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

From: Vasu Dev <vasu.dev@intel.com>

Removes no where used several inline functions prefixed with skb_*
and be16_to_cpu.

Moves fcoe module specific func prototypes to fcoe.c from libfcoe.h,
moved only need for build.

Adds fcoe module header file fcoe.h and then moves fcoe module
specific fcoe_percpu_s and fcoe_softc to fcoe.h from libfcoe.h.

Moves all defines from fcoe.c to fcoe.h since now fcoe module
has its own header file fcoe.h.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   42 +++++++---------
 drivers/scsi/fcoe/fcoe.h |   86 +++++++++++++++++++++++++++++++++
 include/scsi/libfcoe.h   |  120 +---------------------------------------------
 3 files changed, 105 insertions(+), 143 deletions(-)
 create mode 100644 drivers/scsi/fcoe/fcoe.h

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index e9c3d26..c76ff5d 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -19,15 +19,12 @@
 
 #include <linux/module.h>
 #include <linux/version.h>
-#include <linux/kernel.h>
 #include <linux/spinlock.h>
-#include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
-#include <linux/kthread.h>
 #include <linux/crc32.h>
 #include <linux/cpu.h>
 #include <linux/fs.h>
@@ -45,28 +42,9 @@
 #include <scsi/fc_frame.h>
 #include <scsi/libfcoe.h>
 
-static int debug_fcoe;
-
-#define FCOE_MAX_QUEUE_DEPTH  256
-#define FCOE_LOW_QUEUE_DEPTH  32
-
-/* destination address mode */
-#define FCOE_GW_ADDR_MODE	    0x00
-#define FCOE_FCOUI_ADDR_MODE	    0x01
-
-#define FCOE_WORD_TO_BYTE  4
-
-#define FCOE_VERSION	"0.1"
-#define	FCOE_NAME	"fcoe"
-#define	FCOE_VENDOR	"Open-FCoE.org"
-
-#define FCOE_MAX_LUN		255
-#define FCOE_MAX_FCP_TARGET	256
+#include "fcoe.h"
 
-#define FCOE_MAX_OUTSTANDING_COMMANDS	1024
-
-#define FCOE_MIN_XID		0x0001	/* the min xid supported by fcoe_sw */
-#define FCOE_MAX_XID		0x07ef	/* the max xid supported by fcoe_sw */
+static int debug_fcoe;
 
 MODULE_AUTHOR("Open-FCoE.org");
 MODULE_DESCRIPTION("FCoE");
@@ -78,8 +56,22 @@ DEFINE_RWLOCK(fcoe_hostlist_lock);
 DEFINE_TIMER(fcoe_timer, NULL, 0, 0);
 DEFINE_PER_CPU(struct fcoe_percpu_s, fcoe_percpu);
 
-
 /* Function Prototyes */
+static int fcoe_reset(struct Scsi_Host *shost);
+static int fcoe_xmit(struct fc_lport *, struct fc_frame *);
+static int fcoe_rcv(struct sk_buff *, struct net_device *,
+		    struct packet_type *, struct net_device *);
+static int fcoe_percpu_receive_thread(void *arg);
+static void fcoe_clean_pending_queue(struct fc_lport *lp);
+static void fcoe_percpu_clean(struct fc_lport *lp);
+static int fcoe_link_ok(struct fc_lport *lp);
+
+static struct fc_lport *fcoe_hostlist_lookup(const struct net_device *);
+static int fcoe_hostlist_add(const struct fc_lport *);
+static int fcoe_hostlist_remove(const struct fc_lport *);
+
+static struct Scsi_Host *fcoe_host_alloc(struct scsi_host_template *, int);
+
 static int fcoe_check_wait_queue(struct fc_lport *);
 static void fcoe_recv_flogi(struct fcoe_softc *, struct fc_frame *, u8 *);
 static int fcoe_device_notification(struct notifier_block *, ulong, void *);
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
new file mode 100644
index 0000000..4a9611f
--- /dev/null
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -0,0 +1,86 @@
+/*
+ * Copyright(c) 2009 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Maintained at www.Open-FCoE.org
+ */
+
+#ifndef _FCOE_H_
+#define _FCOE_H_
+
+#include <linux/skbuff.h>
+#include <linux/kthread.h>
+
+#define FCOE_MAX_QUEUE_DEPTH	256
+#define FCOE_LOW_QUEUE_DEPTH	32
+
+/* destination address mode */
+#define FCOE_GW_ADDR_MODE	0x00
+#define FCOE_FCOUI_ADDR_MODE	0x01
+
+#define FCOE_WORD_TO_BYTE	4
+
+#define FCOE_VERSION	"0.1"
+#define FCOE_NAME	"fcoe"
+#define FCOE_VENDOR	"Open-FCoE.org"
+
+#define FCOE_MAX_LUN		255
+#define FCOE_MAX_FCP_TARGET	256
+
+#define FCOE_MAX_OUTSTANDING_COMMANDS	1024
+
+#define FCOE_MIN_XID		0x0001	/* the min xid supported by fcoe_sw */
+#define FCOE_MAX_XID		0x07ef	/* the max xid supported by fcoe_sw */
+
+/*
+ * this percpu struct for fcoe
+ */
+struct fcoe_percpu_s {
+	struct task_struct *thread;
+	struct sk_buff_head fcoe_rx_list;
+	struct page *crc_eof_page;
+	int crc_eof_offset;
+};
+
+/*
+ * the fcoe sw transport private data
+ */
+struct fcoe_softc {
+	struct list_head list;
+	struct fc_lport *lp;
+	struct net_device *real_dev;
+	struct net_device *phys_dev;		/* device with ethtool_ops */
+	struct packet_type  fcoe_packet_type;
+	struct sk_buff_head fcoe_pending_queue;
+	u8	fcoe_pending_queue_active;
+
+	u8 dest_addr[ETH_ALEN];
+	u8 ctl_src_addr[ETH_ALEN];
+	u8 data_src_addr[ETH_ALEN];
+	/*
+	 * fcoe protocol address learning related stuff
+	 */
+	u16 flogi_oxid;
+	u8 flogi_progress;
+	u8 address_mode;
+};
+
+static inline struct net_device *fcoe_netdev(
+	const struct fc_lport *lp)
+{
+	return ((struct fcoe_softc *)lport_priv(lp))->real_dev;
+}
+
+#endif /* _FCOE_H_ */
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index e99633c..d07ebe6 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -25,124 +25,8 @@
 #include <scsi/fc/fc_fcoe.h>
 #include <scsi/libfc.h>
 
-/*
- * this percpu struct for fcoe
- */
-struct fcoe_percpu_s {
-	struct task_struct *thread;
-	struct sk_buff_head fcoe_rx_list;
-	struct page *crc_eof_page;
-	int crc_eof_offset;
-};
-
-/*
- * the fcoe sw transport private data
- */
-struct fcoe_softc {
-	struct list_head list;
-	struct fc_lport *lp;
-	struct net_device *real_dev;
-	struct net_device *phys_dev;		/* device with ethtool_ops */
-	struct packet_type  fcoe_packet_type;
-	struct sk_buff_head fcoe_pending_queue;
-	u8	fcoe_pending_queue_active;
-
-	u8 dest_addr[ETH_ALEN];
-	u8 ctl_src_addr[ETH_ALEN];
-	u8 data_src_addr[ETH_ALEN];
-	/*
-	 * fcoe protocol address learning related stuff
-	 */
-	u16 flogi_oxid;
-	u8 flogi_progress;
-	u8 address_mode;
-};
-
-static inline struct net_device *fcoe_netdev(
-	const struct fc_lport *lp)
-{
-	return ((struct fcoe_softc *)lport_priv(lp))->real_dev;
-}
-
-static inline struct fcoe_hdr *skb_fcoe_header(const struct sk_buff *skb)
-{
-	return (struct fcoe_hdr *)skb_network_header(skb);
-}
-
-static inline int skb_fcoe_offset(const struct sk_buff *skb)
-{
-	return skb_network_offset(skb);
-}
-
-static inline struct fc_frame_header *skb_fc_header(const struct sk_buff *skb)
-{
-	return (struct fc_frame_header *)skb_transport_header(skb);
-}
-
-static inline int skb_fc_offset(const struct sk_buff *skb)
-{
-	return skb_transport_offset(skb);
-}
-
-static inline void skb_reset_fc_header(struct sk_buff *skb)
-{
-	skb_reset_network_header(skb);
-	skb_set_transport_header(skb, skb_network_offset(skb) +
-				 sizeof(struct fcoe_hdr));
-}
-
-static inline bool skb_fc_is_data(const struct sk_buff *skb)
-{
-	return skb_fc_header(skb)->fh_r_ctl == FC_RCTL_DD_SOL_DATA;
-}
-
-static inline bool skb_fc_is_cmd(const struct sk_buff *skb)
-{
-	return skb_fc_header(skb)->fh_r_ctl == FC_RCTL_DD_UNSOL_CMD;
-}
-
-static inline bool skb_fc_has_exthdr(const struct sk_buff *skb)
-{
-	return (skb_fc_header(skb)->fh_r_ctl == FC_RCTL_VFTH) ||
-	    (skb_fc_header(skb)->fh_r_ctl == FC_RCTL_IFRH) ||
-	    (skb_fc_header(skb)->fh_r_ctl == FC_RCTL_ENCH);
-}
-
-static inline bool skb_fc_is_roff(const struct sk_buff *skb)
-{
-	return skb_fc_header(skb)->fh_f_ctl[2] & FC_FC_REL_OFF;
-}
-
-static inline u16 skb_fc_oxid(const struct sk_buff *skb)
-{
-	return be16_to_cpu(skb_fc_header(skb)->fh_ox_id);
-}
-
-static inline u16 skb_fc_rxid(const struct sk_buff *skb)
-{
-	return be16_to_cpu(skb_fc_header(skb)->fh_rx_id);
-}
-
 /* libfcoe funcs */
-int fcoe_reset(struct Scsi_Host *shost);
-u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN],
-		      unsigned int scheme, unsigned int port);
-
-u32 fcoe_fc_crc(struct fc_frame *fp);
-int fcoe_xmit(struct fc_lport *, struct fc_frame *);
-int fcoe_rcv(struct sk_buff *, struct net_device *,
-	     struct packet_type *, struct net_device *);
-
-int fcoe_percpu_receive_thread(void *arg);
-void fcoe_clean_pending_queue(struct fc_lport *lp);
-void fcoe_percpu_clean(struct fc_lport *lp);
-void fcoe_watchdog(ulong vp);
-int fcoe_link_ok(struct fc_lport *lp);
-
-struct fc_lport *fcoe_hostlist_lookup(const struct net_device *);
-int fcoe_hostlist_add(const struct fc_lport *);
-int fcoe_hostlist_remove(const struct fc_lport *);
-
-struct Scsi_Host *fcoe_host_alloc(struct scsi_host_template *, int);
+u64 fcoe_wwn_from_mac(unsigned char mac[], unsigned int, unsigned int);
 int fcoe_libfc_config(struct fc_lport *, struct libfc_function_template *);
+
 #endif /* _LIBFCOE_H */


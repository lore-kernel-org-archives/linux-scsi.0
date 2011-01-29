From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 28/28] libfcoe: Move common code from fcoe to libfcoe module
Date: Fri, 28 Jan 2011 16:05:37 -0800
Message-ID: <20110129000537.1784.10795.stgit@localhost6.localdomain6>
References: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42350 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547Ab1A2AFi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 19:05:38 -0500
In-Reply-To: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

To facilitate LLDDs to reuse the code, skb queue related functions are moved to
libfcoe, so that both fcoe and bnx2fc drivers can use them. The common structures
fcoe_port, fcoe_percpu_s are moved to libfcoe. fcoe_port will now have an
opaque pointer that points to corresponding driver's interface structure.
Also, fcoe_start_io and fcoe_fc_crc are moved to libfcoe.

As part of this change, fixed fcoe_start_io to return ENOMEM if
skb_clone fails.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c           |  217 +++---------------------------------
 drivers/scsi/fcoe/fcoe.h           |   44 -------
 drivers/scsi/fcoe/fcoe_transport.c |  200 +++++++++++++++++++++++++++++++++
 include/scsi/libfcoe.h             |   51 ++++++++
 4 files changed, 275 insertions(+), 237 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 46c57e5..495456f 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -75,7 +75,6 @@ static int fcoe_xmit(struct fc_lport *, struct fc_frame *);
 static int fcoe_rcv(struct sk_buff *, struct net_device *,
 		    struct packet_type *, struct net_device *);
 static int fcoe_percpu_receive_thread(void *);
-static void fcoe_clean_pending_queue(struct fc_lport *);
 static void fcoe_percpu_clean(struct fc_lport *);
 static int fcoe_link_speed_update(struct fc_lport *);
 static int fcoe_link_ok(struct fc_lport *);
@@ -83,7 +82,6 @@ static int fcoe_link_ok(struct fc_lport *);
 static struct fc_lport *fcoe_hostlist_lookup(const struct net_device *);
 static int fcoe_hostlist_add(const struct fc_lport *);
 
-static void fcoe_check_wait_queue(struct fc_lport *, struct sk_buff *);
 static int fcoe_device_notification(struct notifier_block *, ulong, void *);
 static void fcoe_dev_setup(void);
 static void fcoe_dev_cleanup(void);
@@ -506,7 +504,7 @@ static void fcoe_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
 static void fcoe_update_src_mac(struct fc_lport *lport, u8 *addr)
 {
 	struct fcoe_port *port = lport_priv(lport);
-	struct fcoe_interface *fcoe = port->fcoe;
+	struct fcoe_interface *fcoe = port->priv;
 
 	rtnl_lock();
 	if (!is_zero_ether_addr(port->data_src_addr))
@@ -562,17 +560,6 @@ static int fcoe_lport_config(struct fc_lport *lport)
 }
 
 /**
- * fcoe_queue_timer() - The fcoe queue timer
- * @lport: The local port
- *
- * Calls fcoe_check_wait_queue on timeout
- */
-static void fcoe_queue_timer(ulong lport)
-{
-	fcoe_check_wait_queue((struct fc_lport *)lport, NULL);
-}
-
-/**
  * fcoe_get_wwn() - Get the world wide name from LLD if it supports it
  * @netdev: the associated net device
  * @wwn: the output WWN
@@ -651,7 +638,7 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 
 	/* Setup lport private data to point to fcoe softc */
 	port = lport_priv(lport);
-	fcoe = port->fcoe;
+	fcoe = port->priv;
 
 	/*
 	 * Determine max frame size based on underlying device and optional
@@ -761,7 +748,7 @@ bool fcoe_oem_match(struct fc_frame *fp)
 static inline int fcoe_em_config(struct fc_lport *lport)
 {
 	struct fcoe_port *port = lport_priv(lport);
-	struct fcoe_interface *fcoe = port->fcoe;
+	struct fcoe_interface *fcoe = port->priv;
 	struct fcoe_interface *oldfcoe = NULL;
 	struct net_device *old_real_dev, *cur_real_dev;
 	u16 min_xid = FCOE_MIN_XID;
@@ -845,7 +832,7 @@ skip_oem:
 static void fcoe_if_destroy(struct fc_lport *lport)
 {
 	struct fcoe_port *port = lport_priv(lport);
-	struct fcoe_interface *fcoe = port->fcoe;
+	struct fcoe_interface *fcoe = port->priv;
 	struct net_device *netdev = fcoe->netdev;
 
 	FCOE_NETDEV_DBG(netdev, "Destroying interface\n");
@@ -966,7 +953,9 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 	}
 	port = lport_priv(lport);
 	port->lport = lport;
-	port->fcoe = fcoe;
+	port->priv = fcoe;
+	port->max_queue_depth = FCOE_MAX_QUEUE_DEPTH;
+	port->min_queue_depth = FCOE_MIN_QUEUE_DEPTH;
 	INIT_WORK(&port->destroy_work, fcoe_destroy_work);
 
 	/* configure a fc_lport including the exchange manager */
@@ -1362,108 +1351,22 @@ err2:
 }
 
 /**
- * fcoe_start_io() - Start FCoE I/O
- * @skb: The packet to be transmitted
- *
- * This routine is called from the net device to start transmitting
- * FCoE packets.
- *
- * Returns: 0 for success
- */
-static inline int fcoe_start_io(struct sk_buff *skb)
-{
-	struct sk_buff *nskb;
-	int rc;
-
-	nskb = skb_clone(skb, GFP_ATOMIC);
-	rc = dev_queue_xmit(nskb);
-	if (rc != 0)
-		return rc;
-	kfree_skb(skb);
-	return 0;
-}
-
-/**
- * fcoe_get_paged_crc_eof() - Allocate a page to be used for the trailer CRC
+ * fcoe_alloc_paged_crc_eof() - Allocate a page to be used for the trailer CRC
  * @skb:  The packet to be transmitted
  * @tlen: The total length of the trailer
  *
- * This routine allocates a page for frame trailers. The page is re-used if
- * there is enough room left on it for the current trailer. If there isn't
- * enough buffer left a new page is allocated for the trailer. Reference to
- * the page from this function as well as the skbs using the page fragments
- * ensure that the page is freed at the appropriate time.
- *
  * Returns: 0 for success
  */
-static int fcoe_get_paged_crc_eof(struct sk_buff *skb, int tlen)
+static int fcoe_alloc_paged_crc_eof(struct sk_buff *skb, int tlen)
 {
 	struct fcoe_percpu_s *fps;
-	struct page *page;
+	int rc;
 
 	fps = &get_cpu_var(fcoe_percpu);
-	page = fps->crc_eof_page;
-	if (!page) {
-		page = alloc_page(GFP_ATOMIC);
-		if (!page) {
-			put_cpu_var(fcoe_percpu);
-			return -ENOMEM;
-		}
-		fps->crc_eof_page = page;
-		fps->crc_eof_offset = 0;
-	}
-
-	get_page(page);
-	skb_fill_page_desc(skb, skb_shinfo(skb)->nr_frags, page,
-			   fps->crc_eof_offset, tlen);
-	skb->len += tlen;
-	skb->data_len += tlen;
-	skb->truesize += tlen;
-	fps->crc_eof_offset += sizeof(struct fcoe_crc_eof);
-
-	if (fps->crc_eof_offset >= PAGE_SIZE) {
-		fps->crc_eof_page = NULL;
-		fps->crc_eof_offset = 0;
-		put_page(page);
-	}
+	rc = fcoe_get_paged_crc_eof(skb, tlen, fps);
 	put_cpu_var(fcoe_percpu);
-	return 0;
-}
 
-/**
- * fcoe_fc_crc() - Calculates the CRC for a given frame
- * @fp: The frame to be checksumed
- *
- * This uses crc32() routine to calculate the CRC for a frame
- *
- * Return: The 32 bit CRC value
- */
-u32 fcoe_fc_crc(struct fc_frame *fp)
-{
-	struct sk_buff *skb = fp_skb(fp);
-	struct skb_frag_struct *frag;
-	unsigned char *data;
-	unsigned long off, len, clen;
-	u32 crc;
-	unsigned i;
-
-	crc = crc32(~0, skb->data, skb_headlen(skb));
-
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
-		frag = &skb_shinfo(skb)->frags[i];
-		off = frag->page_offset;
-		len = frag->size;
-		while (len > 0) {
-			clen = min(len, PAGE_SIZE - (off & ~PAGE_MASK));
-			data = kmap_atomic(frag->page + (off >> PAGE_SHIFT),
-					   KM_SKB_DATA_SOFTIRQ);
-			crc = crc32(crc, data + (off & ~PAGE_MASK), clen);
-			kunmap_atomic(data, KM_SKB_DATA_SOFTIRQ);
-			off += clen;
-			len -= clen;
-		}
-	}
-	return crc;
+	return rc;
 }
 
 /**
@@ -1486,7 +1389,7 @@ int fcoe_xmit(struct fc_lport *lport, struct fc_frame *fp)
 	unsigned int tlen;		/* trailer length */
 	unsigned int elen;		/* eth header, may include vlan */
 	struct fcoe_port *port = lport_priv(lport);
-	struct fcoe_interface *fcoe = port->fcoe;
+	struct fcoe_interface *fcoe = port->priv;
 	u8 sof, eof;
 	struct fcoe_hdr *hp;
 
@@ -1527,7 +1430,7 @@ int fcoe_xmit(struct fc_lport *lport, struct fc_frame *fp)
 	/* copy port crc and eof to the skb buff */
 	if (skb_is_nonlinear(skb)) {
 		skb_frag_t *frag;
-		if (fcoe_get_paged_crc_eof(skb, tlen)) {
+		if (fcoe_alloc_paged_crc_eof(skb, tlen)) {
 			kfree_skb(skb);
 			return -ENOMEM;
 		}
@@ -1636,7 +1539,7 @@ static inline int fcoe_filter_frames(struct fc_lport *lport,
 	if (fh->fh_r_ctl == FC_RCTL_DD_SOL_DATA && fh->fh_type == FC_TYPE_FCP)
 		return 0;
 
-	fcoe = ((struct fcoe_port *)lport_priv(lport))->fcoe;
+	fcoe = ((struct fcoe_port *)lport_priv(lport))->priv;
 	if (is_fip_mode(&fcoe->ctlr) && fc_frame_payload_op(fp) == ELS_LOGO &&
 	    ntoh24(fh->fh_s_id) == FC_FID_FLOGI) {
 		FCOE_DBG("fcoe: dropping FCoE lport LOGO in fip mode\n");
@@ -1771,64 +1674,6 @@ int fcoe_percpu_receive_thread(void *arg)
 }
 
 /**
- * fcoe_check_wait_queue() - Attempt to clear the transmit backlog
- * @lport: The local port whose backlog is to be cleared
- *
- * This empties the wait_queue, dequeues the head of the wait_queue queue
- * and calls fcoe_start_io() for each packet. If all skb have been
- * transmitted it returns the qlen. If an error occurs it restores
- * wait_queue (to try again later) and returns -1.
- *
- * The wait_queue is used when the skb transmit fails. The failed skb
- * will go in the wait_queue which will be emptied by the timer function or
- * by the next skb transmit.
- */
-static void fcoe_check_wait_queue(struct fc_lport *lport, struct sk_buff *skb)
-{
-	struct fcoe_port *port = lport_priv(lport);
-	int rc;
-
-	spin_lock_bh(&port->fcoe_pending_queue.lock);
-
-	if (skb)
-		__skb_queue_tail(&port->fcoe_pending_queue, skb);
-
-	if (port->fcoe_pending_queue_active)
-		goto out;
-	port->fcoe_pending_queue_active = 1;
-
-	while (port->fcoe_pending_queue.qlen) {
-		/* keep qlen > 0 until fcoe_start_io succeeds */
-		port->fcoe_pending_queue.qlen++;
-		skb = __skb_dequeue(&port->fcoe_pending_queue);
-
-		spin_unlock_bh(&port->fcoe_pending_queue.lock);
-		rc = fcoe_start_io(skb);
-		spin_lock_bh(&port->fcoe_pending_queue.lock);
-
-		if (rc) {
-			__skb_queue_head(&port->fcoe_pending_queue, skb);
-			/* undo temporary increment above */
-			port->fcoe_pending_queue.qlen--;
-			break;
-		}
-		/* undo temporary increment above */
-		port->fcoe_pending_queue.qlen--;
-	}
-
-	if (port->fcoe_pending_queue.qlen < FCOE_LOW_QUEUE_DEPTH)
-		lport->qfull = 0;
-	if (port->fcoe_pending_queue.qlen && !timer_pending(&port->timer))
-		mod_timer(&port->timer, jiffies + 2);
-	port->fcoe_pending_queue_active = 0;
-out:
-	if (port->fcoe_pending_queue.qlen > FCOE_MAX_QUEUE_DEPTH)
-		lport->qfull = 1;
-	spin_unlock_bh(&port->fcoe_pending_queue.lock);
-	return;
-}
-
-/**
  * fcoe_dev_setup() - Setup the link change notification interface
  */
 static void fcoe_dev_setup(void)
@@ -2180,8 +2025,7 @@ out_nodev:
  */
 int fcoe_link_speed_update(struct fc_lport *lport)
 {
-	struct fcoe_port *port = lport_priv(lport);
-	struct net_device *netdev = port->fcoe->netdev;
+	struct net_device *netdev = fcoe_netdev(lport);
 	struct ethtool_cmd ecmd = { ETHTOOL_GSET };
 
 	if (!dev_ethtool_get_settings(netdev, &ecmd)) {
@@ -2212,8 +2056,7 @@ int fcoe_link_speed_update(struct fc_lport *lport)
  */
 int fcoe_link_ok(struct fc_lport *lport)
 {
-	struct fcoe_port *port = lport_priv(lport);
-	struct net_device *netdev = port->fcoe->netdev;
+	struct net_device *netdev = fcoe_netdev(lport);
 
 	if (netif_oper_up(netdev))
 		return 0;
@@ -2277,24 +2120,6 @@ void fcoe_percpu_clean(struct fc_lport *lport)
 }
 
 /**
- * fcoe_clean_pending_queue() - Dequeue a skb and free it
- * @lport: The local port to dequeue a skb on
- */
-void fcoe_clean_pending_queue(struct fc_lport *lport)
-{
-	struct fcoe_port  *port = lport_priv(lport);
-	struct sk_buff *skb;
-
-	spin_lock_bh(&port->fcoe_pending_queue.lock);
-	while ((skb = __skb_dequeue(&port->fcoe_pending_queue)) != NULL) {
-		spin_unlock_bh(&port->fcoe_pending_queue.lock);
-		kfree_skb(skb);
-		spin_lock_bh(&port->fcoe_pending_queue.lock);
-	}
-	spin_unlock_bh(&port->fcoe_pending_queue.lock);
-}
-
-/**
  * fcoe_reset() - Reset a local port
  * @shost: The SCSI host associated with the local port to be reset
  *
@@ -2361,7 +2186,7 @@ static int fcoe_hostlist_add(const struct fc_lport *lport)
 	fcoe = fcoe_hostlist_lookup_port(fcoe_netdev(lport));
 	if (!fcoe) {
 		port = lport_priv(lport);
-		fcoe = port->fcoe;
+		fcoe = port->priv;
 		list_add_tail(&fcoe->list, &fcoe_hostlist);
 	}
 	return 0;
@@ -2555,7 +2380,7 @@ static struct fc_seq *fcoe_elsct_send(struct fc_lport *lport, u32 did,
 				      void *arg, u32 timeout)
 {
 	struct fcoe_port *port = lport_priv(lport);
-	struct fcoe_interface *fcoe = port->fcoe;
+	struct fcoe_interface *fcoe = port->priv;
 	struct fcoe_ctlr *fip = &fcoe->ctlr;
 	struct fc_frame_header *fh = fc_frame_header_get(fp);
 
@@ -2588,7 +2413,7 @@ static int fcoe_vport_create(struct fc_vport *vport, bool disabled)
 	struct Scsi_Host *shost = vport_to_shost(vport);
 	struct fc_lport *n_port = shost_priv(shost);
 	struct fcoe_port *port = lport_priv(n_port);
-	struct fcoe_interface *fcoe = port->fcoe;
+	struct fcoe_interface *fcoe = port->priv;
 	struct net_device *netdev = fcoe->netdev;
 	struct fc_lport *vn_port;
 
@@ -2732,7 +2557,7 @@ static void fcoe_set_port_id(struct fc_lport *lport,
 			     u32 port_id, struct fc_frame *fp)
 {
 	struct fcoe_port *port = lport_priv(lport);
-	struct fcoe_interface *fcoe = port->fcoe;
+	struct fcoe_interface *fcoe = port->priv;
 
 	if (fp && fc_frame_payload_op(fp) == ELS_FLOGI)
 		fcoe_ctlr_recv_flogi(&fcoe->ctlr, lport, fp);
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index c69b2c5..d775128 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -24,7 +24,7 @@
 #include <linux/kthread.h>
 
 #define FCOE_MAX_QUEUE_DEPTH	256
-#define FCOE_LOW_QUEUE_DEPTH	32
+#define FCOE_MIN_QUEUE_DEPTH	32
 
 #define FCOE_WORD_TO_BYTE	4
 
@@ -71,21 +71,6 @@ do {                                                            	\
 				  netdev->name, ##args);)
 
 /**
- * struct fcoe_percpu_s - The per-CPU context for FCoE receive threads
- * @thread:	    The thread context
- * @fcoe_rx_list:   The queue of pending packets to process
- * @page:	    The memory page for calculating frame trailer CRCs
- * @crc_eof_offset: The offset into the CRC page pointing to available
- *		    memory for a new trailer
- */
-struct fcoe_percpu_s {
-	struct task_struct *thread;
-	struct sk_buff_head fcoe_rx_list;
-	struct page *crc_eof_page;
-	int crc_eof_offset;
-};
-
-/**
  * struct fcoe_interface - A FCoE interface
  * @list:	      Handle for a list of FCoE interfaces
  * @netdev:	      The associated net device
@@ -108,30 +93,6 @@ struct fcoe_interface {
 	struct kref	   kref;
 };
 
-/**
- * struct fcoe_port - The FCoE private structure
- * @fcoe:		       The associated fcoe interface
- * @lport:		       The associated local port
- * @fcoe_pending_queue:	       The pending Rx queue of skbs
- * @fcoe_pending_queue_active: Indicates if the pending queue is active
- * @timer:		       The queue timer
- * @destroy_work:	       Handle for work context
- *			       (to prevent RTNL deadlocks)
- * @data_srt_addr:	       Source address for data
- *
- * An instance of this structure is to be allocated along with the
- * Scsi_Host and libfc fc_lport structures.
- */
-struct fcoe_port {
-	struct fcoe_interface *fcoe;
-	struct fc_lport	      *lport;
-	struct sk_buff_head   fcoe_pending_queue;
-	u8		      fcoe_pending_queue_active;
-	struct timer_list     timer;
-	struct work_struct    destroy_work;
-	u8		      data_src_addr[ETH_ALEN];
-};
-
 #define fcoe_from_ctlr(fip) container_of(fip, struct fcoe_interface, ctlr)
 
 /**
@@ -140,7 +101,8 @@ struct fcoe_port {
  */
 static inline struct net_device *fcoe_netdev(const struct fc_lport *lport)
 {
-	return ((struct fcoe_port *)lport_priv(lport))->fcoe->netdev;
+	return ((struct fcoe_interface *)
+			((struct fcoe_port *)lport_priv(lport))->priv)->netdev;
 }
 
 #endif /* _FCOE_H_ */
diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index e5aef56..745eb9a 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -23,6 +23,7 @@
 #include <linux/list.h>
 #include <linux/netdevice.h>
 #include <linux/errno.h>
+#include <linux/crc32.h>
 #include <scsi/libfcoe.h>
 
 #include "libfcoe.h"
@@ -75,6 +76,205 @@ __MODULE_PARM_TYPE(disable, "string");
 MODULE_PARM_DESC(disable, " Disables fcoe on a ethernet interface.");
 
 /**
+ * fcoe_fc_crc() - Calculates the CRC for a given frame
+ * @fp: The frame to be checksumed
+ *
+ * This uses crc32() routine to calculate the CRC for a frame
+ *
+ * Return: The 32 bit CRC value
+ */
+u32 fcoe_fc_crc(struct fc_frame *fp)
+{
+	struct sk_buff *skb = fp_skb(fp);
+	struct skb_frag_struct *frag;
+	unsigned char *data;
+	unsigned long off, len, clen;
+	u32 crc;
+	unsigned i;
+
+	crc = crc32(~0, skb->data, skb_headlen(skb));
+
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		frag = &skb_shinfo(skb)->frags[i];
+		off = frag->page_offset;
+		len = frag->size;
+		while (len > 0) {
+			clen = min(len, PAGE_SIZE - (off & ~PAGE_MASK));
+			data = kmap_atomic(frag->page + (off >> PAGE_SHIFT),
+					   KM_SKB_DATA_SOFTIRQ);
+			crc = crc32(crc, data + (off & ~PAGE_MASK), clen);
+			kunmap_atomic(data, KM_SKB_DATA_SOFTIRQ);
+			off += clen;
+			len -= clen;
+		}
+	}
+	return crc;
+}
+EXPORT_SYMBOL_GPL(fcoe_fc_crc);
+
+/**
+ * fcoe_start_io() - Start FCoE I/O
+ * @skb: The packet to be transmitted
+ *
+ * This routine is called from the net device to start transmitting
+ * FCoE packets.
+ *
+ * Returns: 0 for success
+ */
+int fcoe_start_io(struct sk_buff *skb)
+{
+	struct sk_buff *nskb;
+	int rc;
+
+	nskb = skb_clone(skb, GFP_ATOMIC);
+	if (!nskb)
+		return -ENOMEM;
+	rc = dev_queue_xmit(nskb);
+	if (rc != 0)
+		return rc;
+	kfree_skb(skb);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fcoe_start_io);
+
+
+/**
+ * fcoe_clean_pending_queue() - Dequeue a skb and free it
+ * @lport: The local port to dequeue a skb on
+ */
+void fcoe_clean_pending_queue(struct fc_lport *lport)
+{
+	struct fcoe_port  *port = lport_priv(lport);
+	struct sk_buff *skb;
+
+	spin_lock_bh(&port->fcoe_pending_queue.lock);
+	while ((skb = __skb_dequeue(&port->fcoe_pending_queue)) != NULL) {
+		spin_unlock_bh(&port->fcoe_pending_queue.lock);
+		kfree_skb(skb);
+		spin_lock_bh(&port->fcoe_pending_queue.lock);
+	}
+	spin_unlock_bh(&port->fcoe_pending_queue.lock);
+}
+EXPORT_SYMBOL_GPL(fcoe_clean_pending_queue);
+
+/**
+ * fcoe_check_wait_queue() - Attempt to clear the transmit backlog
+ * @lport: The local port whose backlog is to be cleared
+ *
+ * This empties the wait_queue, dequeues the head of the wait_queue queue
+ * and calls fcoe_start_io() for each packet. If all skb have been
+ * transmitted it returns the qlen. If an error occurs it restores
+ * wait_queue (to try again later) and returns -1.
+ *
+ * The wait_queue is used when the skb transmit fails. The failed skb
+ * will go in the wait_queue which will be emptied by the timer function or
+ * by the next skb transmit.
+ */
+void fcoe_check_wait_queue(struct fc_lport *lport, struct sk_buff *skb)
+{
+	struct fcoe_port *port = lport_priv(lport);
+	int rc;
+
+	spin_lock_bh(&port->fcoe_pending_queue.lock);
+
+	if (skb)
+		__skb_queue_tail(&port->fcoe_pending_queue, skb);
+
+	if (port->fcoe_pending_queue_active)
+		goto out;
+	port->fcoe_pending_queue_active = 1;
+
+	while (port->fcoe_pending_queue.qlen) {
+		/* keep qlen > 0 until fcoe_start_io succeeds */
+		port->fcoe_pending_queue.qlen++;
+		skb = __skb_dequeue(&port->fcoe_pending_queue);
+
+		spin_unlock_bh(&port->fcoe_pending_queue.lock);
+		rc = fcoe_start_io(skb);
+		spin_lock_bh(&port->fcoe_pending_queue.lock);
+
+		if (rc) {
+			__skb_queue_head(&port->fcoe_pending_queue, skb);
+			/* undo temporary increment above */
+			port->fcoe_pending_queue.qlen--;
+			break;
+		}
+		/* undo temporary increment above */
+		port->fcoe_pending_queue.qlen--;
+	}
+
+	if (port->fcoe_pending_queue.qlen < port->min_queue_depth)
+		lport->qfull = 0;
+	if (port->fcoe_pending_queue.qlen && !timer_pending(&port->timer))
+		mod_timer(&port->timer, jiffies + 2);
+	port->fcoe_pending_queue_active = 0;
+out:
+	if (port->fcoe_pending_queue.qlen > port->max_queue_depth)
+		lport->qfull = 1;
+	spin_unlock_bh(&port->fcoe_pending_queue.lock);
+}
+EXPORT_SYMBOL_GPL(fcoe_check_wait_queue);
+
+/**
+ * fcoe_queue_timer() - The fcoe queue timer
+ * @lport: The local port
+ *
+ * Calls fcoe_check_wait_queue on timeout
+ */
+void fcoe_queue_timer(ulong lport)
+{
+	fcoe_check_wait_queue((struct fc_lport *)lport, NULL);
+}
+EXPORT_SYMBOL_GPL(fcoe_queue_timer);
+
+/**
+ * fcoe_get_paged_crc_eof() - Allocate a page to be used for the trailer CRC
+ * @skb:  The packet to be transmitted
+ * @tlen: The total length of the trailer
+ * @fps:  The fcoe context
+ *
+ * This routine allocates a page for frame trailers. The page is re-used if
+ * there is enough room left on it for the current trailer. If there isn't
+ * enough buffer left a new page is allocated for the trailer. Reference to
+ * the page from this function as well as the skbs using the page fragments
+ * ensure that the page is freed at the appropriate time.
+ *
+ * Returns: 0 for success
+ */
+int fcoe_get_paged_crc_eof(struct sk_buff *skb, int tlen,
+			   struct fcoe_percpu_s *fps)
+{
+	struct page *page;
+
+	page = fps->crc_eof_page;
+	if (!page) {
+		page = alloc_page(GFP_ATOMIC);
+		if (!page)
+			return -ENOMEM;
+
+		fps->crc_eof_page = page;
+		fps->crc_eof_offset = 0;
+	}
+
+	get_page(page);
+	skb_fill_page_desc(skb, skb_shinfo(skb)->nr_frags, page,
+			   fps->crc_eof_offset, tlen);
+	skb->len += tlen;
+	skb->data_len += tlen;
+	skb->truesize += tlen;
+	fps->crc_eof_offset += sizeof(struct fcoe_crc_eof);
+
+	if (fps->crc_eof_offset >= PAGE_SIZE) {
+		fps->crc_eof_page = NULL;
+		fps->crc_eof_offset = 0;
+		put_page(page);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fcoe_get_paged_crc_eof);
+
+/**
  * fcoe_transport_lookup - find an fcoe transport that matches a netdev
  * @netdev: The netdev to look for from all attached transports
  *
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index efb6ae5..e502463 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -221,6 +221,8 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *, struct fc_lport *,
 u64 fcoe_wwn_from_mac(unsigned char mac[], unsigned int, unsigned int);
 int fcoe_libfc_config(struct fc_lport *, struct fcoe_ctlr *,
 		      const struct libfc_function_template *, int init_fcp);
+u32 fcoe_fc_crc(struct fc_frame *fp);
+int fcoe_start_io(struct sk_buff *skb);
 
 /**
  * is_fip_mode() - returns true if FIP mode selected.
@@ -267,6 +269,55 @@ struct fcoe_transport {
 };
 
 /**
+ * struct fcoe_percpu_s - The context for FCoE receive thread(s)
+ * @thread:	    The thread context
+ * @fcoe_rx_list:   The queue of pending packets to process
+ * @page:	    The memory page for calculating frame trailer CRCs
+ * @crc_eof_offset: The offset into the CRC page pointing to available
+ *		    memory for a new trailer
+ */
+struct fcoe_percpu_s {
+	struct task_struct *thread;
+	struct sk_buff_head fcoe_rx_list;
+	struct page *crc_eof_page;
+	int crc_eof_offset;
+};
+
+/**
+ * struct fcoe_port - The FCoE private structure
+ * @priv:		       The associated fcoe interface. The structure is
+ *			       defined by the low level driver
+ * @lport:		       The associated local port
+ * @fcoe_pending_queue:	       The pending Rx queue of skbs
+ * @fcoe_pending_queue_active: Indicates if the pending queue is active
+ * @max_queue_depth:	       Max queue depth of pending queue
+ * @min_queue_depth:	       Min queue depth of pending queue
+ * @timer:		       The queue timer
+ * @destroy_work:	       Handle for work context
+ *			       (to prevent RTNL deadlocks)
+ * @data_srt_addr:	       Source address for data
+ *
+ * An instance of this structure is to be allocated along with the
+ * Scsi_Host and libfc fc_lport structures.
+ */
+struct fcoe_port {
+	void		      *priv;
+	struct fc_lport	      *lport;
+	struct sk_buff_head   fcoe_pending_queue;
+	u8		      fcoe_pending_queue_active;
+	u32		      max_queue_depth;
+	u32		      min_queue_depth;
+	struct timer_list     timer;
+	struct work_struct    destroy_work;
+	u8		      data_src_addr[ETH_ALEN];
+};
+void fcoe_clean_pending_queue(struct fc_lport *);
+void fcoe_check_wait_queue(struct fc_lport *lport, struct sk_buff *skb);
+void fcoe_queue_timer(ulong lport);
+int fcoe_get_paged_crc_eof(struct sk_buff *skb, int tlen,
+			   struct fcoe_percpu_s *fps);
+
+/**
  * struct netdev_list
  * A mapping from netdevice to fcoe_transport
  */


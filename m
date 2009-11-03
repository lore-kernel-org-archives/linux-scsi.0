From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 43/54] fnic: Add FIP support to the fnic driver
Date: Tue, 03 Nov 2009 11:49:22 -0800
Message-ID: <20091103194922.4085.11106.stgit@localhost.localdomain>
References: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:1523 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216AbZKCTtR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:49:17 -0500
In-Reply-To: <20091103194530.4085.37963.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

Use libfcoe as a common FIP implementation with fcoe.
FIP or non-FIP mode is fully automatic if the firmware
supports and enables it.

Even if FIP is not supported, this uses libfcoe for the non-FIP
handling of FLOGI and its response.

Use the new lport_set_port_id() notification to capture
successful FLOGI responses and port_id resets.

While transitioning between Ethernet and FC mode, all rx and
tx FC frames are queued.  In Ethernet mode, all frames are
passed to the exchange manager to capture FLOGI responses.

Change to set data_src_addr to the ctl_src_addr whenever it
would have previously been zero because we're not logged in.
This seems safer so we'll never send a frame with a 0 source MAC.
This also eliminates a special case for sending FLOGI frames.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/Kconfig          |    2 
 drivers/scsi/fnic/fnic.h      |   23 +-
 drivers/scsi/fnic/fnic_fcs.c  |  499 ++++++++++++++++++++---------------------
 drivers/scsi/fnic/fnic_main.c |   71 +++---
 drivers/scsi/fnic/fnic_res.c  |    5 
 drivers/scsi/fnic/fnic_res.h  |   50 ++++
 drivers/scsi/fnic/fnic_scsi.c |   73 +++---
 drivers/scsi/fnic/vnic_scsi.h |    1 
 8 files changed, 382 insertions(+), 342 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index b4d8d63..36900c7 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -663,7 +663,7 @@ config FCOE
 config FCOE_FNIC
 	tristate "Cisco FNIC Driver"
 	depends on PCI && X86
-	select LIBFC
+	select LIBFCOE
 	help
 	  This is support for the Cisco PCI-Express FCoE HBA.
 
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 1bc267e..bb208a6 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -22,6 +22,7 @@
 #include <linux/netdevice.h>
 #include <linux/workqueue.h>
 #include <scsi/libfc.h>
+#include <scsi/libfcoe.h>
 #include "fnic_io.h"
 #include "fnic_res.h"
 #include "vnic_dev.h"
@@ -145,6 +146,7 @@ struct mempool;
 /* Per-instance private data structure */
 struct fnic {
 	struct fc_lport *lport;
+	struct fcoe_ctlr ctlr;		/* FIP FCoE controller structure */
 	struct vnic_dev_bar bar0;
 
 	struct msix_entry msix_entry[FNIC_MSIX_INTR_MAX];
@@ -162,23 +164,16 @@ struct fnic {
 	unsigned int wq_count;
 	unsigned int cq_count;
 
-	u32 fcoui_mode:1;		/* use fcoui address*/
 	u32 vlan_hw_insert:1;	        /* let hw insert the tag */
 	u32 in_remove:1;                /* fnic device in removal */
 	u32 stop_rx_link_events:1;      /* stop proc. rx frames, link events */
 
 	struct completion *remove_wait; /* device remove thread blocks */
 
-	struct fc_frame *flogi;
-	struct fc_frame *flogi_resp;
-	u16 flogi_oxid;
-	unsigned long s_id;
 	enum fnic_state state;
 	spinlock_t fnic_lock;
 
 	u16 vlan_id;	                /* VLAN tag including priority */
-	u8 mac_addr[ETH_ALEN];
-	u8 dest_addr[ETH_ALEN];
 	u8 data_src_addr[ETH_ALEN];
 	u64 fcp_input_bytes;		/* internal statistic */
 	u64 fcp_output_bytes;		/* internal statistic */
@@ -205,6 +200,7 @@ struct fnic {
 	struct work_struct link_work;
 	struct work_struct frame_work;
 	struct sk_buff_head frame_queue;
+	struct sk_buff_head tx_queue;
 
 	/* copy work queue cache line section */
 	____cacheline_aligned struct vnic_wq_copy wq_copy[FNIC_WQ_COPY_MAX];
@@ -224,6 +220,11 @@ struct fnic {
 	____cacheline_aligned struct vnic_intr intr[FNIC_MSIX_INTR_MAX];
 };
 
+static inline struct fnic *fnic_from_ctlr(struct fcoe_ctlr *fip)
+{
+	return container_of(fip, struct fnic, ctlr);
+}
+
 extern struct workqueue_struct *fnic_event_queue;
 extern struct device_attribute *fnic_attrs[];
 
@@ -239,7 +240,11 @@ void fnic_handle_link(struct work_struct *work);
 int fnic_rq_cmpl_handler(struct fnic *fnic, int);
 int fnic_alloc_rq_frame(struct vnic_rq *rq);
 void fnic_free_rq_buf(struct vnic_rq *rq, struct vnic_rq_buf *buf);
-int fnic_send_frame(struct fnic *fnic, struct fc_frame *fp);
+void fnic_flush_tx(struct fnic *);
+void fnic_eth_send(struct fcoe_ctlr *, struct sk_buff *skb);
+void fnic_set_port_id(struct fc_lport *, u32, struct fc_frame *);
+void fnic_update_mac(struct fc_lport *, u8 *new);
+void fnic_update_mac_locked(struct fnic *, u8 *new);
 
 int fnic_queuecommand(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
 int fnic_abort_cmd(struct scsi_cmnd *);
@@ -252,7 +257,7 @@ void fnic_empty_scsi_cleanup(struct fc_lport *);
 void fnic_exch_mgr_reset(struct fc_lport *, u32, u32);
 int fnic_wq_copy_cmpl_handler(struct fnic *fnic, int);
 int fnic_wq_cmpl_handler(struct fnic *fnic, int);
-int fnic_flogi_reg_handler(struct fnic *fnic);
+int fnic_flogi_reg_handler(struct fnic *fnic, u32);
 void fnic_wq_copy_cleanup_handler(struct vnic_wq_copy *wq,
 				  struct fcpio_host_req *desc);
 int fnic_fw_reset_handler(struct fnic *fnic);
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 50db3e3..54f8d0e 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -23,6 +23,7 @@
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
 #include <linux/workqueue.h>
+#include <scsi/fc/fc_fip.h>
 #include <scsi/fc/fc_els.h>
 #include <scsi/fc/fc_fcoe.h>
 #include <scsi/fc_frame.h>
@@ -34,6 +35,8 @@
 
 struct workqueue_struct *fnic_event_queue;
 
+static void fnic_set_eth_mode(struct fnic *);
+
 void fnic_handle_link(struct work_struct *work)
 {
 	struct fnic *fnic = container_of(work, struct fnic, link_work);
@@ -64,10 +67,10 @@ void fnic_handle_link(struct work_struct *work)
 				spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 				FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
 					     "link down\n");
-				fc_linkdown(fnic->lport);
+				fcoe_ctlr_link_down(&fnic->ctlr);
 				FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
 					     "link up\n");
-				fc_linkup(fnic->lport);
+				fcoe_ctlr_link_up(&fnic->ctlr);
 			} else
 				/* UP -> UP */
 				spin_unlock_irqrestore(&fnic->fnic_lock, flags);
@@ -76,13 +79,13 @@ void fnic_handle_link(struct work_struct *work)
 		/* DOWN -> UP */
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host, "link up\n");
-		fc_linkup(fnic->lport);
+		fcoe_ctlr_link_up(&fnic->ctlr);
 	} else {
 		/* UP -> DOWN */
 		fnic->lport->host_stats.link_failure_count++;
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host, "link down\n");
-		fc_linkdown(fnic->lport);
+		fcoe_ctlr_link_down(&fnic->ctlr);
 	}
 
 }
@@ -107,197 +110,179 @@ void fnic_handle_frame(struct work_struct *work)
 			return;
 		}
 		fp = (struct fc_frame *)skb;
-		/* if Flogi resp frame, register the address */
-		if (fr_flags(fp)) {
-			vnic_dev_add_addr(fnic->vdev,
-					  fnic->data_src_addr);
-			fr_flags(fp) = 0;
+
+		/*
+		 * If we're in a transitional state, just re-queue and return.
+		 * The queue will be serviced when we get to a stable state.
+		 */
+		if (fnic->state != FNIC_IN_FC_MODE &&
+		    fnic->state != FNIC_IN_ETH_MODE) {
+			skb_queue_head(&fnic->frame_queue, skb);
+			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+			return;
 		}
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
 		fc_exch_recv(lp, fp);
 	}
-
-}
-
-static inline void fnic_import_rq_fc_frame(struct sk_buff *skb,
-					   u32 len, u8 sof, u8 eof)
-{
-	struct fc_frame *fp = (struct fc_frame *)skb;
-
-	skb_trim(skb, len);
-	fr_eof(fp) = eof;
-	fr_sof(fp) = sof;
 }
 
-
-static inline int fnic_import_rq_eth_pkt(struct sk_buff *skb, u32 len)
+/**
+ * fnic_import_rq_eth_pkt() - handle received FCoE or FIP frame.
+ * @fnic:	fnic instance.
+ * @skb:	Ethernet Frame.
+ */
+static inline int fnic_import_rq_eth_pkt(struct fnic *fnic, struct sk_buff *skb)
 {
 	struct fc_frame *fp;
 	struct ethhdr *eh;
-	struct vlan_ethhdr *vh;
 	struct fcoe_hdr *fcoe_hdr;
 	struct fcoe_crc_eof *ft;
-	u32    transport_len = 0;
 
+	/*
+	 * Undo VLAN encapsulation if present.
+	 */
 	eh = (struct ethhdr *)skb->data;
-	vh = (struct vlan_ethhdr *)skb->data;
-	if (vh->h_vlan_proto == htons(ETH_P_8021Q) &&
-	    vh->h_vlan_encapsulated_proto == htons(ETH_P_FCOE)) {
-		skb_pull(skb, sizeof(struct vlan_ethhdr));
-		transport_len += sizeof(struct vlan_ethhdr);
-	} else if (eh->h_proto == htons(ETH_P_FCOE)) {
-		transport_len += sizeof(struct ethhdr);
-		skb_pull(skb, sizeof(struct ethhdr));
-	} else
-		return -1;
+	if (eh->h_proto == htons(ETH_P_8021Q)) {
+		memmove((u8 *)eh + VLAN_HLEN, eh, ETH_ALEN * 2);
+		eh = (struct ethhdr *)skb_pull(skb, VLAN_HLEN);
+		skb_reset_mac_header(skb);
+	}
+	if (eh->h_proto == htons(ETH_P_FIP)) {
+		skb_pull(skb, sizeof(*eh));
+		fcoe_ctlr_recv(&fnic->ctlr, skb);
+		return 1;		/* let caller know packet was used */
+	}
+	if (eh->h_proto != htons(ETH_P_FCOE))
+		goto drop;
+	skb_set_network_header(skb, sizeof(*eh));
+	skb_pull(skb, sizeof(*eh));
 
 	fcoe_hdr = (struct fcoe_hdr *)skb->data;
 	if (FC_FCOE_DECAPS_VER(fcoe_hdr) != FC_FCOE_VER)
-		return -1;
+		goto drop;
 
 	fp = (struct fc_frame *)skb;
 	fc_frame_init(fp);
 	fr_sof(fp) = fcoe_hdr->fcoe_sof;
 	skb_pull(skb, sizeof(struct fcoe_hdr));
-	transport_len += sizeof(struct fcoe_hdr);
+	skb_reset_transport_header(skb);
 
-	ft = (struct fcoe_crc_eof *)(skb->data + len -
-				     transport_len - sizeof(*ft));
+	ft = (struct fcoe_crc_eof *)(skb->data + skb->len - sizeof(*ft));
 	fr_eof(fp) = ft->fcoe_eof;
-	skb_trim(skb, len - transport_len - sizeof(*ft));
+	skb_trim(skb, skb->len - sizeof(*ft));
 	return 0;
+drop:
+	dev_kfree_skb_irq(skb);
+	return -1;
 }
 
-static inline int fnic_handle_flogi_resp(struct fnic *fnic,
-					 struct fc_frame *fp)
+/**
+ * fnic_update_mac_locked() - set data MAC address and filters.
+ * @fnic:	fnic instance.
+ * @new:	newly-assigned FCoE MAC address.
+ *
+ * Called with the fnic lock held.
+ */
+void fnic_update_mac_locked(struct fnic *fnic, u8 *new)
 {
-	u8 mac[ETH_ALEN] = FC_FCOE_FLOGI_MAC;
-	struct ethhdr *eth_hdr;
-	struct fc_frame_header *fh;
-	int ret = 0;
-	unsigned long flags;
-	struct fc_frame *old_flogi_resp = NULL;
+	u8 *ctl = fnic->ctlr.ctl_src_addr;
+	u8 *data = fnic->data_src_addr;
 
-	fh = (struct fc_frame_header *)fr_hdr(fp);
+	if (is_zero_ether_addr(new))
+		new = ctl;
+	if (!compare_ether_addr(data, new))
+		return;
+	FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host, "update_mac %pM\n", new);
+	if (!is_zero_ether_addr(data) && compare_ether_addr(data, ctl))
+		vnic_dev_del_addr(fnic->vdev, data);
+	memcpy(data, new, ETH_ALEN);
+	if (compare_ether_addr(new, ctl))
+		vnic_dev_add_addr(fnic->vdev, new);
+}
 
-	spin_lock_irqsave(&fnic->fnic_lock, flags);
+/**
+ * fnic_update_mac() - set data MAC address and filters.
+ * @lport:	local port.
+ * @new:	newly-assigned FCoE MAC address.
+ */
+void fnic_update_mac(struct fc_lport *lport, u8 *new)
+{
+	struct fnic *fnic = lport_priv(lport);
 
-	if (fnic->state == FNIC_IN_ETH_MODE) {
+	spin_lock_irq(&fnic->fnic_lock);
+	fnic_update_mac_locked(fnic, new);
+	spin_unlock_irq(&fnic->fnic_lock);
+}
 
-		/*
-		 * Check if oxid matches on taking the lock. A new Flogi
-		 * issued by libFC might have changed the fnic cached oxid
-		 */
-		if (fnic->flogi_oxid != ntohs(fh->fh_ox_id)) {
-			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
-				     "Flogi response oxid not"
-				     " matching cached oxid, dropping frame"
-				     "\n");
-			ret = -1;
-			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-			dev_kfree_skb_irq(fp_skb(fp));
-			goto handle_flogi_resp_end;
-		}
+/**
+ * fnic_set_port_id() - set the port_ID after successful FLOGI.
+ * @lport:	local port.
+ * @port_id:	assigned FC_ID.
+ * @fp:		received frame containing the FLOGI accept or NULL.
+ *
+ * This is called from libfc when a new FC_ID has been assigned.
+ * This causes us to reset the firmware to FC_MODE and setup the new MAC
+ * address and FC_ID.
+ *
+ * It is also called with FC_ID 0 when we're logged off.
+ *
+ * If the FC_ID is due to point-to-point, fp may be NULL.
+ */
+void fnic_set_port_id(struct fc_lport *lport, u32 port_id, struct fc_frame *fp)
+{
+	struct fnic *fnic = lport_priv(lport);
+	u8 *mac;
+	int ret;
 
-		/* Drop older cached flogi response frame, cache this frame */
-		old_flogi_resp = fnic->flogi_resp;
-		fnic->flogi_resp = fp;
-		fnic->flogi_oxid = FC_XID_UNKNOWN;
+	FNIC_FCS_DBG(KERN_DEBUG, lport->host, "set port_id %x fp %p\n",
+		     port_id, fp);
 
-		/*
-		 * this frame is part of flogi get the src mac addr from this
-		 * frame if the src mac is fcoui based then we mark the
-		 * address mode flag to use fcoui base for dst mac addr
-		 * otherwise we have to store the fcoe gateway addr
-		 */
-		eth_hdr = (struct ethhdr *)skb_mac_header(fp_skb(fp));
-		memcpy(mac, eth_hdr->h_source, ETH_ALEN);
+	/*
+	 * If we're clearing the FC_ID, change to use the ctl_src_addr.
+	 * Set ethernet mode to send FLOGI.
+	 */
+	if (!port_id) {
+		fnic_update_mac(lport, fnic->ctlr.ctl_src_addr);
+		fnic_set_eth_mode(fnic);
+		return;
+	}
 
-		if (ntoh24(mac) == FC_FCOE_OUI)
-			fnic->fcoui_mode = 1;
-		else {
-			fnic->fcoui_mode = 0;
-			memcpy(fnic->dest_addr, mac, ETH_ALEN);
+	if (fp) {
+		mac = fr_cb(fp)->granted_mac;
+		if (is_zero_ether_addr(mac)) {
+			/* non-FIP - FLOGI already accepted - ignore return */
+			fcoe_ctlr_recv_flogi(&fnic->ctlr, lport, fp);
 		}
+		fnic_update_mac(lport, mac);
+	}
 
-		/*
-		 * Except for Flogi frame, all outbound frames from us have the
-		 * Eth Src address as FC_FCOE_OUI"our_sid". Flogi frame uses
-		 * the vnic MAC address as the Eth Src address
-		 */
-		fc_fcoe_set_mac(fnic->data_src_addr, fh->fh_d_id);
-
-		/* We get our s_id from the d_id of the flogi resp frame */
-		fnic->s_id = ntoh24(fh->fh_d_id);
-
-		/* Change state to reflect transition from Eth to FC mode */
+	/* Change state to reflect transition to FC mode */
+	spin_lock_irq(&fnic->fnic_lock);
+	if (fnic->state == FNIC_IN_ETH_MODE || fnic->state == FNIC_IN_FC_MODE)
 		fnic->state = FNIC_IN_ETH_TRANS_FC_MODE;
-
-	} else {
+	else {
 		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
 			     "Unexpected fnic state %s while"
 			     " processing flogi resp\n",
 			     fnic_state_to_str(fnic->state));
-		ret = -1;
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		dev_kfree_skb_irq(fp_skb(fp));
-		goto handle_flogi_resp_end;
+		spin_unlock_irq(&fnic->fnic_lock);
+		return;
 	}
-
-	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-
-	/* Drop older cached frame */
-	if (old_flogi_resp)
-		dev_kfree_skb_irq(fp_skb(old_flogi_resp));
+	spin_unlock_irq(&fnic->fnic_lock);
 
 	/*
-	 * send flogi reg request to firmware, this will put the fnic in
-	 * in FC mode
+	 * Send FLOGI registration to firmware to set up FC mode.
+	 * The new address will be set up when registration completes.
 	 */
-	ret = fnic_flogi_reg_handler(fnic);
+	ret = fnic_flogi_reg_handler(fnic, port_id);
 
 	if (ret < 0) {
-		int free_fp = 1;
-		spin_lock_irqsave(&fnic->fnic_lock, flags);
-		/*
-		 * free the frame is some other thread is not
-		 * pointing to it
-		 */
-		if (fnic->flogi_resp != fp)
-			free_fp = 0;
-		else
-			fnic->flogi_resp = NULL;
-
+		spin_lock_irq(&fnic->fnic_lock);
 		if (fnic->state == FNIC_IN_ETH_TRANS_FC_MODE)
 			fnic->state = FNIC_IN_ETH_MODE;
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		if (free_fp)
-			dev_kfree_skb_irq(fp_skb(fp));
+		spin_unlock_irq(&fnic->fnic_lock);
 	}
-
- handle_flogi_resp_end:
-	return ret;
-}
-
-/* Returns 1 for a response that matches cached flogi oxid */
-static inline int is_matching_flogi_resp_frame(struct fnic *fnic,
-					       struct fc_frame *fp)
-{
-	struct fc_frame_header *fh;
-	int ret = 0;
-	u32 f_ctl;
-
-	fh = fc_frame_header_get(fp);
-	f_ctl = ntoh24(fh->fh_f_ctl);
-
-	if (fnic->flogi_oxid == ntohs(fh->fh_ox_id) &&
-	    fh->fh_r_ctl == FC_RCTL_ELS_REP &&
-	    (f_ctl & (FC_FC_EX_CTX | FC_FC_SEQ_CTX)) == FC_FC_EX_CTX &&
-	    fh->fh_type == FC_TYPE_ELS)
-		ret = 1;
-
-	return ret;
 }
 
 static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
@@ -326,6 +311,7 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 	pci_unmap_single(fnic->pdev, buf->dma_addr, buf->len,
 			 PCI_DMA_FROMDEVICE);
 	skb = buf->os_buf;
+	fp = (struct fc_frame *)skb;
 	buf->os_buf = NULL;
 
 	cq_desc_dec(cq_desc, &type, &color, &q_number, &completed_index);
@@ -338,6 +324,9 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 				   &fcoe_enc_error, &fcs_ok, &vlan_stripped,
 				   &vlan);
 		eth_hdrs_stripped = 1;
+		skb_trim(skb, fcp_bytes_written);
+		fr_sof(fp) = sof;
+		fr_eof(fp) = eof;
 
 	} else if (type == CQ_DESC_TYPE_RQ_ENET) {
 		cq_enet_rq_desc_dec((struct cq_enet_rq_desc *)cq_desc,
@@ -352,6 +341,14 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 				    &ipv4_csum_ok, &ipv6, &ipv4,
 				    &ipv4_fragment, &fcs_ok);
 		eth_hdrs_stripped = 0;
+		skb_trim(skb, bytes_written);
+		if (!fcs_ok) {
+			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
+				     "fcs error.  dropping packet.\n");
+			goto drop;
+		}
+		if (fnic_import_rq_eth_pkt(fnic, skb))
+			return;
 
 	} else {
 		/* wrong CQ type*/
@@ -370,43 +367,11 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 		goto drop;
 	}
 
-	if (eth_hdrs_stripped)
-		fnic_import_rq_fc_frame(skb, fcp_bytes_written, sof, eof);
-	else if (fnic_import_rq_eth_pkt(skb, bytes_written))
-		goto drop;
-
-	fp = (struct fc_frame *)skb;
-
-	/*
-	 * If frame is an ELS response that matches the cached FLOGI OX_ID,
-	 * and is accept, issue flogi_reg_request copy wq request to firmware
-	 * to register the S_ID and determine whether FC_OUI mode or GW mode.
-	 */
-	if (is_matching_flogi_resp_frame(fnic, fp)) {
-		if (!eth_hdrs_stripped) {
-			if (fc_frame_payload_op(fp) == ELS_LS_ACC) {
-				fnic_handle_flogi_resp(fnic, fp);
-				return;
-			}
-			/*
-			 * Recd. Flogi reject. No point registering
-			 * with fw, but forward to libFC
-			 */
-			goto forward;
-		}
-		goto drop;
-	}
-	if (!eth_hdrs_stripped)
-		goto drop;
-
-forward:
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 	if (fnic->stop_rx_link_events) {
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		goto drop;
 	}
-	/* Use fr_flags to indicate whether succ. flogi resp or not */
-	fr_flags(fp) = 0;
 	fr_dev(fp) = fnic->lport;
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
@@ -494,12 +459,49 @@ void fnic_free_rq_buf(struct vnic_rq *rq, struct vnic_rq_buf *buf)
 	buf->os_buf = NULL;
 }
 
-static inline int is_flogi_frame(struct fc_frame_header *fh)
+/**
+ * fnic_eth_send() - Send Ethernet frame.
+ * @fip:	fcoe_ctlr instance.
+ * @skb:	Ethernet Frame, FIP, without VLAN encapsulation.
+ */
+void fnic_eth_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
 {
-	return fh->fh_r_ctl == FC_RCTL_ELS_REQ && *(u8 *)(fh + 1) == ELS_FLOGI;
+	struct fnic *fnic = fnic_from_ctlr(fip);
+	struct vnic_wq *wq = &fnic->wq[0];
+	dma_addr_t pa;
+	struct ethhdr *eth_hdr;
+	struct vlan_ethhdr *vlan_hdr;
+	unsigned long flags;
+
+	if (!fnic->vlan_hw_insert) {
+		eth_hdr = (struct ethhdr *)skb_mac_header(skb);
+		vlan_hdr = (struct vlan_ethhdr *)skb_push(skb,
+				sizeof(*vlan_hdr) - sizeof(*eth_hdr));
+		memcpy(vlan_hdr, eth_hdr, 2 * ETH_ALEN);
+		vlan_hdr->h_vlan_proto = htons(ETH_P_8021Q);
+		vlan_hdr->h_vlan_encapsulated_proto = eth_hdr->h_proto;
+		vlan_hdr->h_vlan_TCI = htons(fnic->vlan_id);
+	}
+
+	pa = pci_map_single(fnic->pdev, skb->data, skb->len, PCI_DMA_TODEVICE);
+
+	spin_lock_irqsave(&fnic->wq_lock[0], flags);
+	if (!vnic_wq_desc_avail(wq)) {
+		pci_unmap_single(fnic->pdev, pa, skb->len, PCI_DMA_TODEVICE);
+		spin_unlock_irqrestore(&fnic->wq_lock[0], flags);
+		kfree_skb(skb);
+		return;
+	}
+
+	fnic_queue_wq_eth_desc(wq, skb, pa, skb->len,
+			       fnic->vlan_hw_insert, fnic->vlan_id, 1);
+	spin_unlock_irqrestore(&fnic->wq_lock[0], flags);
 }
 
-int fnic_send_frame(struct fnic *fnic, struct fc_frame *fp)
+/*
+ * Send FC frame.
+ */
+static int fnic_send_frame(struct fnic *fnic, struct fc_frame *fp)
 {
 	struct vnic_wq *wq = &fnic->wq[0];
 	struct sk_buff *skb;
@@ -515,6 +517,10 @@ int fnic_send_frame(struct fnic *fnic, struct fc_frame *fp)
 	fh = fc_frame_header_get(fp);
 	skb = fp_skb(fp);
 
+	if (unlikely(fh->fh_r_ctl == FC_RCTL_ELS_REQ) &&
+	    fcoe_ctlr_els_send(&fnic->ctlr, fnic->lport, skb))
+		return 0;
+
 	if (!fnic->vlan_hw_insert) {
 		eth_hdr_len = sizeof(*vlan_hdr) + sizeof(*fcoe_hdr);
 		vlan_hdr = (struct vlan_ethhdr *)skb_push(skb, eth_hdr_len);
@@ -530,16 +536,11 @@ int fnic_send_frame(struct fnic *fnic, struct fc_frame *fp)
 		fcoe_hdr = (struct fcoe_hdr *)(eth_hdr + 1);
 	}
 
-	if (is_flogi_frame(fh)) {
+	if (fnic->ctlr.map_dest)
 		fc_fcoe_set_mac(eth_hdr->h_dest, fh->fh_d_id);
-		memcpy(eth_hdr->h_source, fnic->mac_addr, ETH_ALEN);
-	} else {
-		if (fnic->fcoui_mode)
-			fc_fcoe_set_mac(eth_hdr->h_dest, fh->fh_d_id);
-		else
-			memcpy(eth_hdr->h_dest, fnic->dest_addr, ETH_ALEN);
-		memcpy(eth_hdr->h_source, fnic->data_src_addr, ETH_ALEN);
-	}
+	else
+		memcpy(eth_hdr->h_dest, fnic->ctlr.dest_addr, ETH_ALEN);
+	memcpy(eth_hdr->h_source, fnic->data_src_addr, ETH_ALEN);
 
 	tot_len = skb->len;
 	BUG_ON(tot_len % 4);
@@ -578,109 +579,85 @@ fnic_send_frame_end:
 int fnic_send(struct fc_lport *lp, struct fc_frame *fp)
 {
 	struct fnic *fnic = lport_priv(lp);
-	struct fc_frame_header *fh;
-	int ret = 0;
-	enum fnic_state old_state;
 	unsigned long flags;
-	struct fc_frame *old_flogi = NULL;
-	struct fc_frame *old_flogi_resp = NULL;
 
 	if (fnic->in_remove) {
 		dev_kfree_skb(fp_skb(fp));
-		ret = -1;
-		goto fnic_send_end;
+		return -1;
 	}
 
-	fh = fc_frame_header_get(fp);
-	/* if not an Flogi frame, send it out, this is the common case */
-	if (!is_flogi_frame(fh))
-		return fnic_send_frame(fnic, fp);
+	/*
+	 * Queue frame if in a transitional state.
+	 * This occurs while registering the Port_ID / MAC address after FLOGI.
+	 */
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	if (fnic->state != FNIC_IN_FC_MODE && fnic->state != FNIC_IN_ETH_MODE) {
+		skb_queue_tail(&fnic->tx_queue, fp_skb(fp));
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		return 0;
+	}
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
-	/* Flogi frame, now enter the state machine */
+	return fnic_send_frame(fnic, fp);
+}
 
-	spin_lock_irqsave(&fnic->fnic_lock, flags);
-again:
-	/* Get any old cached frames, free them after dropping lock */
-	old_flogi = fnic->flogi;
-	fnic->flogi = NULL;
-	old_flogi_resp = fnic->flogi_resp;
-	fnic->flogi_resp = NULL;
+/**
+ * fnic_flush_tx() - send queued frames.
+ * @fnic: fnic device
+ *
+ * Send frames that were waiting to go out in FC or Ethernet mode.
+ * Whenever changing modes we purge queued frames, so these frames should
+ * be queued for the stable mode that we're in, either FC or Ethernet.
+ *
+ * Called without fnic_lock held.
+ */
+void fnic_flush_tx(struct fnic *fnic)
+{
+	struct sk_buff *skb;
+	struct fc_frame *fp;
 
-	fnic->flogi_oxid = FC_XID_UNKNOWN;
+	while ((skb = skb_dequeue(&fnic->frame_queue))) {
+		fp = (struct fc_frame *)skb;
+		fnic_send_frame(fnic, fp);
+	}
+}
 
+/**
+ * fnic_set_eth_mode() - put fnic into ethernet mode.
+ * @fnic: fnic device
+ *
+ * Called without fnic lock held.
+ */
+static void fnic_set_eth_mode(struct fnic *fnic)
+{
+	unsigned long flags;
+	enum fnic_state old_state;
+	int ret;
+
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+again:
 	old_state = fnic->state;
 	switch (old_state) {
 	case FNIC_IN_FC_MODE:
 	case FNIC_IN_ETH_TRANS_FC_MODE:
 	default:
 		fnic->state = FNIC_IN_FC_TRANS_ETH_MODE;
-		vnic_dev_del_addr(fnic->vdev, fnic->data_src_addr);
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
-		if (old_flogi) {
-			dev_kfree_skb(fp_skb(old_flogi));
-			old_flogi = NULL;
-		}
-		if (old_flogi_resp) {
-			dev_kfree_skb(fp_skb(old_flogi_resp));
-			old_flogi_resp = NULL;
-		}
-
 		ret = fnic_fw_reset_handler(fnic);
 
 		spin_lock_irqsave(&fnic->fnic_lock, flags);
 		if (fnic->state != FNIC_IN_FC_TRANS_ETH_MODE)
 			goto again;
-		if (ret) {
+		if (ret)
 			fnic->state = old_state;
-			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-			dev_kfree_skb(fp_skb(fp));
-			goto fnic_send_end;
-		}
-		old_flogi = fnic->flogi;
-		fnic->flogi = fp;
-		fnic->flogi_oxid = ntohs(fh->fh_ox_id);
-		old_flogi_resp = fnic->flogi_resp;
-		fnic->flogi_resp = NULL;
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		break;
 
 	case FNIC_IN_FC_TRANS_ETH_MODE:
-		/*
-		 * A reset is pending with the firmware. Store the flogi
-		 * and its oxid. The transition out of this state happens
-		 * only when Firmware completes the reset, either with
-		 * success or failed. If success, transition to
-		 * FNIC_IN_ETH_MODE, if fail, then transition to
-		 * FNIC_IN_FC_MODE
-		 */
-		fnic->flogi = fp;
-		fnic->flogi_oxid = ntohs(fh->fh_ox_id);
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		break;
-
 	case FNIC_IN_ETH_MODE:
-		/*
-		 * The fw/hw is already in eth mode. Store the oxid,
-		 * and send the flogi frame out. The transition out of this
-		 * state happens only we receive flogi response from the
-		 * network, and the oxid matches the cached oxid when the
-		 * flogi frame was sent out. If they match, then we issue
-		 * a flogi_reg request and transition to state
-		 * FNIC_IN_ETH_TRANS_FC_MODE
-		 */
-		fnic->flogi_oxid = ntohs(fh->fh_ox_id);
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		ret = fnic_send_frame(fnic, fp);
 		break;
 	}
-
-fnic_send_end:
-	if (old_flogi)
-		dev_kfree_skb(fp_skb(old_flogi));
-	if (old_flogi_resp)
-		dev_kfree_skb(fp_skb(old_flogi_resp));
-	return ret;
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 }
 
 static void fnic_wq_complete_frame_send(struct vnic_wq *wq,
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 018cc42..0333c7f 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -25,6 +25,8 @@
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
+#include <linux/if_ether.h>
+#include <scsi/fc/fc_fip.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
@@ -68,6 +70,7 @@ MODULE_PARM_DESC(fnic_log_level, "bit mask of fnic logging levels");
 
 static struct libfc_function_template fnic_transport_template = {
 	.frame_send = fnic_send,
+	.lport_set_port_id = fnic_set_port_id,
 	.fcp_abort_io = fnic_empty_scsi_cleanup,
 	.fcp_cleanup = fnic_empty_scsi_cleanup,
 	.exch_mgr_reset = fnic_exch_mgr_reset
@@ -324,9 +327,6 @@ static int fnic_cleanup(struct fnic *fnic)
 {
 	unsigned int i;
 	int err;
-	unsigned long flags;
-	struct fc_frame *flogi = NULL;
-	struct fc_frame *flogi_resp = NULL;
 
 	vnic_dev_disable(fnic->vdev);
 	for (i = 0; i < fnic->intr_count; i++)
@@ -367,24 +367,6 @@ static int fnic_cleanup(struct fnic *fnic)
 	for (i = 0; i < fnic->intr_count; i++)
 		vnic_intr_clean(&fnic->intr[i]);
 
-	/*
-	 * Remove cached flogi and flogi resp frames if any
-	 * These frames are not in any queue, and therefore queue
-	 * cleanup does not clean them. So clean them explicitly
-	 */
-	spin_lock_irqsave(&fnic->fnic_lock, flags);
-	flogi = fnic->flogi;
-	fnic->flogi = NULL;
-	flogi_resp = fnic->flogi_resp;
-	fnic->flogi_resp = NULL;
-	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-
-	if (flogi)
-		dev_kfree_skb(fp_skb(flogi));
-
-	if (flogi_resp)
-		dev_kfree_skb(fp_skb(flogi_resp));
-
 	mempool_destroy(fnic->io_req_pool);
 	for (i = 0; i < FNIC_SGL_NUM_CACHES; i++)
 		mempool_destroy(fnic->io_sgl_pool[i]);
@@ -409,6 +391,17 @@ static void *fnic_alloc_slab_dma(gfp_t gfp_mask, void *pool_data)
 	return kmem_cache_alloc(mem, gfp_mask | GFP_ATOMIC | GFP_DMA);
 }
 
+/**
+ * fnic_get_mac() - get assigned data MAC address for FIP code.
+ * @lport: 	local port.
+ */
+static u8 *fnic_get_mac(struct fc_lport *lport)
+{
+	struct fnic *fnic = lport_priv(lport);
+
+	return fnic->data_src_addr;
+}
+
 static int __devinit fnic_probe(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
@@ -433,6 +426,7 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	host = lp->host;
 	fnic = lport_priv(lp);
 	fnic->lport = lp;
+	fnic->ctlr.lp = lp;
 
 	snprintf(fnic->name, sizeof(fnic->name) - 1, "%s%d", DRV_NAME,
 		 host->host_no);
@@ -541,12 +535,14 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 		goto err_out_dev_close;
 	}
 
-	err = vnic_dev_mac_addr(fnic->vdev, fnic->mac_addr);
+	err = vnic_dev_mac_addr(fnic->vdev, fnic->ctlr.ctl_src_addr);
 	if (err) {
 		shost_printk(KERN_ERR, fnic->lport->host,
 			     "vNIC get MAC addr failed \n");
 		goto err_out_dev_close;
 	}
+	/* set data_src for point-to-point mode and to keep it non-zero */
+	memcpy(fnic->data_src_addr, fnic->ctlr.ctl_src_addr, ETH_ALEN);
 
 	/* Get vNIC configuration */
 	err = fnic_get_vnic_config(fnic);
@@ -615,9 +611,21 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	fnic->vlan_hw_insert = 1;
 	fnic->vlan_id = 0;
 
-	fnic->flogi_oxid = FC_XID_UNKNOWN;
-	fnic->flogi = NULL;
-	fnic->flogi_resp = NULL;
+	/* Initialize the FIP fcoe_ctrl struct */
+	fnic->ctlr.send = fnic_eth_send;
+	fnic->ctlr.update_mac = fnic_update_mac;
+	fnic->ctlr.get_src_addr = fnic_get_mac;
+	fcoe_ctlr_init(&fnic->ctlr);
+	if (fnic->config.flags & VFCF_FIP_CAPABLE) {
+		shost_printk(KERN_INFO, fnic->lport->host,
+			     "firmware supports FIP\n");
+		vnic_dev_add_addr(fnic->vdev, FIP_ALL_ENODE_MACS);
+		vnic_dev_add_addr(fnic->vdev, fnic->ctlr.ctl_src_addr);
+	} else {
+		shost_printk(KERN_INFO, fnic->lport->host,
+			     "firmware uses non-FIP mode\n");
+		fnic->ctlr.mode = FIP_ST_NON_FIP;
+	}
 	fnic->state = FNIC_IN_FC_MODE;
 
 	/* Enable hardware stripping of vlan header on ingress */
@@ -708,6 +716,7 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	INIT_WORK(&fnic->link_work, fnic_handle_link);
 	INIT_WORK(&fnic->frame_work, fnic_handle_frame);
 	skb_queue_head_init(&fnic->frame_queue);
+	skb_queue_head_init(&fnic->tx_queue);
 
 	/* Enable all queues */
 	for (i = 0; i < fnic->raw_wq_count; i++)
@@ -738,8 +747,8 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 err_out_free_exch_mgr:
 	fc_exch_mgr_free(lp);
 err_out_remove_scsi_host:
-	fc_remove_host(fnic->lport->host);
-	scsi_remove_host(fnic->lport->host);
+	fc_remove_host(lp->host);
+	scsi_remove_host(lp->host);
 err_out_free_rq_buf:
 	for (i = 0; i < fnic->rq_count; i++)
 		vnic_rq_clean(&fnic->rq[i], fnic_free_rq_buf);
@@ -773,6 +782,7 @@ err_out:
 static void __devexit fnic_remove(struct pci_dev *pdev)
 {
 	struct fnic *fnic = pci_get_drvdata(pdev);
+	struct fc_lport *lp = fnic->lport;
 	unsigned long flags;
 
 	/*
@@ -794,6 +804,7 @@ static void __devexit fnic_remove(struct pci_dev *pdev)
 	 */
 	flush_workqueue(fnic_event_queue);
 	skb_queue_purge(&fnic->frame_queue);
+	skb_queue_purge(&fnic->tx_queue);
 
 	/*
 	 * Log off the fabric. This stops all remote ports, dns port,
@@ -806,7 +817,8 @@ static void __devexit fnic_remove(struct pci_dev *pdev)
 	fnic->in_remove = 1;
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
-	fc_lport_destroy(fnic->lport);
+	fcoe_ctlr_destroy(&fnic->ctlr);
+	fc_lport_destroy(lp);
 
 	/*
 	 * This stops the fnic device, masks all interrupts. Completed
@@ -816,6 +828,7 @@ static void __devexit fnic_remove(struct pci_dev *pdev)
 	fnic_cleanup(fnic);
 
 	BUG_ON(!skb_queue_empty(&fnic->frame_queue));
+	BUG_ON(!skb_queue_empty(&fnic->tx_queue));
 
 	spin_lock_irqsave(&fnic_list_lock, flags);
 	list_del(&fnic->list);
@@ -834,7 +847,7 @@ static void __devexit fnic_remove(struct pci_dev *pdev)
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
-	scsi_host_put(fnic->lport->host);
+	scsi_host_put(lp->host);
 }
 
 static struct pci_driver fnic_driver = {
diff --git a/drivers/scsi/fnic/fnic_res.c b/drivers/scsi/fnic/fnic_res.c
index 7ba61ec..50488f8 100644
--- a/drivers/scsi/fnic/fnic_res.c
+++ b/drivers/scsi/fnic/fnic_res.c
@@ -144,10 +144,9 @@ int fnic_get_vnic_config(struct fnic *fnic)
 	c->intr_timer_type = c->intr_timer_type;
 
 	shost_printk(KERN_INFO, fnic->lport->host,
-		     "vNIC MAC addr %02x:%02x:%02x:%02x:%02x:%02x "
+		     "vNIC MAC addr %pM "
 		     "wq/wq_copy/rq %d/%d/%d\n",
-		     fnic->mac_addr[0], fnic->mac_addr[1], fnic->mac_addr[2],
-		     fnic->mac_addr[3], fnic->mac_addr[4], fnic->mac_addr[5],
+		     fnic->ctlr.ctl_src_addr,
 		     c->wq_enet_desc_count, c->wq_copy_desc_count,
 		     c->rq_desc_count);
 	shost_printk(KERN_INFO, fnic->lport->host,
diff --git a/drivers/scsi/fnic/fnic_res.h b/drivers/scsi/fnic/fnic_res.h
index 88c4471..ef8aaf2 100644
--- a/drivers/scsi/fnic/fnic_res.h
+++ b/drivers/scsi/fnic/fnic_res.h
@@ -51,6 +51,31 @@ static inline void fnic_queue_wq_desc(struct vnic_wq *wq,
 	vnic_wq_post(wq, os_buf, dma_addr, len, sop, eop);
 }
 
+static inline void fnic_queue_wq_eth_desc(struct vnic_wq *wq,
+				      void *os_buf, dma_addr_t dma_addr,
+				      unsigned int len,
+				      int vlan_tag_insert,
+				      unsigned int vlan_tag,
+				      int cq_entry)
+{
+	struct wq_enet_desc *desc = vnic_wq_next_desc(wq);
+
+	wq_enet_desc_enc(desc,
+			 (u64)dma_addr | VNIC_PADDR_TARGET,
+			 (u16)len,
+			 0, /* mss_or_csum_offset */
+			 0, /* fc_eof */
+			 0, /* offload_mode */
+			 1, /* eop */
+			 (u8)cq_entry,
+			 0, /* fcoe_encap */
+			 (u8)vlan_tag_insert,
+			 (u16)vlan_tag,
+			 0 /* loopback */);
+
+	vnic_wq_post(wq, os_buf, dma_addr, len, 1, 1);
+}
+
 static inline void fnic_queue_wq_copy_desc_icmnd_16(struct vnic_wq_copy *wq,
 						    u32 req_id,
 						    u32 lunmap_id, u8 spl_flags,
@@ -134,12 +159,37 @@ static inline void fnic_queue_wq_copy_desc_flogi_reg(struct vnic_wq_copy *wq,
 	desc->hdr.tag.u.req_id = req_id;      /* id for this request */
 
 	desc->u.flogi_reg.format = format;
+	desc->u.flogi_reg._resvd = 0;
 	hton24(desc->u.flogi_reg.s_id, s_id);
 	memcpy(desc->u.flogi_reg.gateway_mac, gw_mac, ETH_ALEN);
 
 	vnic_wq_copy_post(wq);
 }
 
+static inline void fnic_queue_wq_copy_desc_fip_reg(struct vnic_wq_copy *wq,
+						   u32 req_id, u32 s_id,
+						   u8 *fcf_mac, u8 *ha_mac,
+						   u32 r_a_tov, u32 e_d_tov)
+{
+	struct fcpio_host_req *desc = vnic_wq_copy_next_desc(wq);
+
+	desc->hdr.type = FCPIO_FLOGI_FIP_REG; /* enum fcpio_type */
+	desc->hdr.status = 0;                 /* header status entry */
+	desc->hdr._resvd = 0;                 /* reserved */
+	desc->hdr.tag.u.req_id = req_id;      /* id for this request */
+
+	desc->u.flogi_fip_reg._resvd0 = 0;
+	hton24(desc->u.flogi_fip_reg.s_id, s_id);
+	memcpy(desc->u.flogi_fip_reg.fcf_mac, fcf_mac, ETH_ALEN);
+	desc->u.flogi_fip_reg._resvd1 = 0;
+	desc->u.flogi_fip_reg.r_a_tov = r_a_tov;
+	desc->u.flogi_fip_reg.e_d_tov = e_d_tov;
+	memcpy(desc->u.flogi_fip_reg.ha_mac, ha_mac, ETH_ALEN);
+	desc->u.flogi_fip_reg._resvd2 = 0;
+
+	vnic_wq_copy_post(wq);
+}
+
 static inline void fnic_queue_wq_copy_desc_fw_reset(struct vnic_wq_copy *wq,
 						    u32 req_id)
 {
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index b5d1738..d2286df 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -174,6 +174,9 @@ int fnic_fw_reset_handler(struct fnic *fnic)
 	int ret = 0;
 	unsigned long flags;
 
+	skb_queue_purge(&fnic->frame_queue);
+	skb_queue_purge(&fnic->tx_queue);
+
 	spin_lock_irqsave(&fnic->wq_copy_lock[0], flags);
 
 	if (vnic_wq_copy_desc_avail(wq) <= fnic->wq_copy_desc_low[0])
@@ -200,9 +203,11 @@ int fnic_fw_reset_handler(struct fnic *fnic)
  * fnic_flogi_reg_handler
  * Routine to send flogi register msg to fw
  */
-int fnic_flogi_reg_handler(struct fnic *fnic)
+int fnic_flogi_reg_handler(struct fnic *fnic, u32 fc_id)
 {
 	struct vnic_wq_copy *wq = &fnic->wq_copy[0];
+	enum fcpio_flogi_reg_format_type format;
+	struct fc_lport *lp = fnic->lport;
 	u8 gw_mac[ETH_ALEN];
 	int ret = 0;
 	unsigned long flags;
@@ -217,23 +222,32 @@ int fnic_flogi_reg_handler(struct fnic *fnic)
 		goto flogi_reg_ioreq_end;
 	}
 
-	if (fnic->fcoui_mode)
+	if (fnic->ctlr.map_dest) {
 		memset(gw_mac, 0xff, ETH_ALEN);
-	else
-		memcpy(gw_mac, fnic->dest_addr, ETH_ALEN);
+		format = FCPIO_FLOGI_REG_DEF_DEST;
+	} else {
+		memcpy(gw_mac, fnic->ctlr.dest_addr, ETH_ALEN);
+		format = FCPIO_FLOGI_REG_GW_DEST;
+	}
 
-	fnic_queue_wq_copy_desc_flogi_reg(wq, SCSI_NO_TAG,
-					  FCPIO_FLOGI_REG_GW_DEST,
-					  fnic->s_id,
-					  gw_mac);
+	if ((fnic->config.flags & VFCF_FIP_CAPABLE) && !fnic->ctlr.map_dest) {
+		fnic_queue_wq_copy_desc_fip_reg(wq, SCSI_NO_TAG,
+						fc_id, gw_mac,
+						fnic->data_src_addr,
+						lp->r_a_tov, lp->e_d_tov);
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			      "FLOGI FIP reg issued fcid %x src %pM dest %pM\n",
+			      fc_id, fnic->data_src_addr, gw_mac);
+	} else {
+		fnic_queue_wq_copy_desc_flogi_reg(wq, SCSI_NO_TAG,
+						  format, fc_id, gw_mac);
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			      "FLOGI reg issued fcid %x map %d dest %pM\n",
+			      fc_id, fnic->ctlr.map_dest, gw_mac);
+	}
 
 flogi_reg_ioreq_end:
 	spin_unlock_irqrestore(&fnic->wq_copy_lock[0], flags);
-
-	if (!ret)
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			      "flog reg issued\n");
-
 	return ret;
 }
 
@@ -453,7 +467,6 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fnic *fnic,
 	u8 hdr_status;
 	struct fcpio_tag tag;
 	int ret = 0;
-	struct fc_frame *flogi;
 	unsigned long flags;
 
 	fcpio_header_dec(&desc->hdr, &type, &hdr_status, &tag);
@@ -463,9 +476,6 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fnic *fnic,
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 
-	flogi = fnic->flogi;
-	fnic->flogi = NULL;
-
 	/* fnic should be in FC_TRANS_ETH_MODE */
 	if (fnic->state == FNIC_IN_FC_TRANS_ETH_MODE) {
 		/* Check status of reset completion */
@@ -506,17 +516,14 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fnic *fnic,
 	 * free the flogi frame. Else, send it out
 	 */
 	if (fnic->remove_wait || ret) {
-		fnic->flogi_oxid = FC_XID_UNKNOWN;
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		if (flogi)
-			dev_kfree_skb_irq(fp_skb(flogi));
+		skb_queue_purge(&fnic->tx_queue);
 		goto reset_cmpl_handler_end;
 	}
 
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
-	if (flogi)
-		ret = fnic_send_frame(fnic, flogi);
+	fnic_flush_tx(fnic);
 
  reset_cmpl_handler_end:
 	return ret;
@@ -533,18 +540,13 @@ static int fnic_fcpio_flogi_reg_cmpl_handler(struct fnic *fnic,
 	u8 hdr_status;
 	struct fcpio_tag tag;
 	int ret = 0;
-	struct fc_frame *flogi_resp = NULL;
 	unsigned long flags;
-	struct sk_buff *skb;
 
 	fcpio_header_dec(&desc->hdr, &type, &hdr_status, &tag);
 
 	/* Update fnic state based on status of flogi reg completion */
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 
-	flogi_resp = fnic->flogi_resp;
-	fnic->flogi_resp = NULL;
-
 	if (fnic->state == FNIC_IN_ETH_TRANS_FC_MODE) {
 
 		/* Check flogi registration completion status */
@@ -568,25 +570,17 @@ static int fnic_fcpio_flogi_reg_cmpl_handler(struct fnic *fnic,
 		ret = -1;
 	}
 
-	/* Successful flogi reg cmpl, pass frame to LibFC */
-	if (!ret && flogi_resp) {
+	if (!ret) {
 		if (fnic->stop_rx_link_events) {
 			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 			goto reg_cmpl_handler_end;
 		}
-		skb = (struct sk_buff *)flogi_resp;
-		/* Use fr_flags to indicate whether flogi resp or not */
-		fr_flags(flogi_resp) = 1;
-		fr_dev(flogi_resp) = fnic->lport;
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
-		skb_queue_tail(&fnic->frame_queue, skb);
+		fnic_flush_tx(fnic);
 		queue_work(fnic_event_queue, &fnic->frame_work);
-
 	} else {
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		if (flogi_resp)
-			dev_kfree_skb_irq(fp_skb(flogi_resp));
 	}
 
 reg_cmpl_handler_end:
@@ -908,6 +902,7 @@ static int fnic_fcpio_cmpl_handler(struct vnic_dev *vdev,
 		break;
 
 	case FCPIO_FLOGI_REG_CMPL: /* fw completed flogi_reg */
+	case FCPIO_FLOGI_FIP_REG_CMPL: /* fw completed flogi_fip_reg */
 		ret = fnic_fcpio_flogi_reg_cmpl_handler(fnic, desc);
 		break;
 
@@ -1763,7 +1758,7 @@ void fnic_scsi_abort_io(struct fc_lport *lp)
 	fnic->remove_wait = &remove_wait;
 	old_state = fnic->state;
 	fnic->state = FNIC_IN_FC_TRANS_ETH_MODE;
-	vnic_dev_del_addr(fnic->vdev, fnic->data_src_addr);
+	fnic_update_mac_locked(fnic, fnic->ctlr.ctl_src_addr);
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
 	err = fnic_fw_reset_handler(fnic);
@@ -1803,7 +1798,7 @@ void fnic_scsi_cleanup(struct fc_lport *lp)
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 	old_state = fnic->state;
 	fnic->state = FNIC_IN_FC_TRANS_ETH_MODE;
-	vnic_dev_del_addr(fnic->vdev, fnic->data_src_addr);
+	fnic_update_mac_locked(fnic, fnic->ctlr.ctl_src_addr);
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
 	if (fnic_fw_reset_handler(fnic)) {
diff --git a/drivers/scsi/fnic/vnic_scsi.h b/drivers/scsi/fnic/vnic_scsi.h
index 46baa52..fbb5536 100644
--- a/drivers/scsi/fnic/vnic_scsi.h
+++ b/drivers/scsi/fnic/vnic_scsi.h
@@ -95,5 +95,6 @@ struct vnic_fc_config {
 
 #define VFCF_FCP_SEQ_LVL_ERR	0x1	/* Enable FCP-2 Error Recovery */
 #define VFCF_PERBI		0x2	/* persistent binding info available */
+#define VFCF_FIP_CAPABLE	0x4	/* firmware can handle FIP */
 
 #endif /* _VNIC_SCSI_H_ */


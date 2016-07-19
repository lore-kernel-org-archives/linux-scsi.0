From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/2] fcoe: implement FIP VLAN responder
Date: Tue, 19 Jul 2016 13:49:40 +0200
Message-ID: <1468928980-40549-2-git-send-email-hare@suse.de>
References: <1468928980-40549-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50088 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbcGSLto (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2016 07:49:44 -0400
In-Reply-To: <1468928980-40549-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jth@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When running in VN2VN mode there is no central instance which
would send out any FIP VLAN discovery notifications. So this
patch adds a new sysfs attribute 'fip_vlan_responder' which
will activate a FIP VLAN discovery responder.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fcoe/fcoe.c       |   6 ++
 drivers/scsi/fcoe/fcoe_ctlr.c  | 224 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/fcoe/fcoe_sysfs.c |  39 +++++++
 include/scsi/libfc.h           |   1 +
 include/scsi/libfcoe.h         |   5 +-
 5 files changed, 274 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 61eda74..c8a4305 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -673,6 +673,12 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 	fcoe = port->priv;
 	ctlr = fcoe_to_ctlr(fcoe);
 
+	/* Figure out the VLAN ID, if any */
+	if (netdev->priv_flags & IFF_802_1Q_VLAN)
+		lport->vlan = vlan_dev_vlan_id(netdev);
+	else
+		lport->vlan = 0;
+
 	/*
 	 * Determine max frame size based on underlying device and optional
 	 * user-configured limit.  If the MFS is too low, fcoe_link_ok()
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index dd45531..a569c65 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -59,6 +59,8 @@ static int fcoe_ctlr_vn_recv(struct fcoe_ctlr *, struct sk_buff *);
 static void fcoe_ctlr_vn_timeout(struct fcoe_ctlr *);
 static int fcoe_ctlr_vn_lookup(struct fcoe_ctlr *, u32, u8 *);
 
+static int fcoe_ctlr_vlan_recv(struct fcoe_ctlr *, struct sk_buff *);
+
 static u8 fcoe_all_fcfs[ETH_ALEN] = FIP_ALL_FCF_MACS;
 static u8 fcoe_all_enode[ETH_ALEN] = FIP_ALL_ENODE_MACS;
 static u8 fcoe_all_vn2vn[ETH_ALEN] = FIP_ALL_VN2VN_MACS;
@@ -149,6 +151,7 @@ void fcoe_ctlr_init(struct fcoe_ctlr *fip, enum fip_state mode)
 {
 	fcoe_ctlr_set_state(fip, FIP_ST_LINK_WAIT);
 	fip->mode = mode;
+	fip->fip_resp = false;
 	INIT_LIST_HEAD(&fip->fcfs);
 	mutex_init(&fip->ctlr_mutex);
 	spin_lock_init(&fip->ctlr_lock);
@@ -1513,6 +1516,7 @@ static int fcoe_ctlr_recv_handler(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	struct fip_header *fiph;
 	struct ethhdr *eh;
 	enum fip_state state;
+	bool fip_vlan_resp = false;
 	u16 op;
 	u8 sub;
 
@@ -1546,11 +1550,17 @@ static int fcoe_ctlr_recv_handler(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		state = FIP_ST_ENABLED;
 		LIBFCOE_FIP_DBG(fip, "Using FIP mode\n");
 	}
+	fip_vlan_resp = fip->fip_resp;
 	mutex_unlock(&fip->ctlr_mutex);
 
 	if (fip->mode == FIP_MODE_VN2VN && op == FIP_OP_VN2VN)
 		return fcoe_ctlr_vn_recv(fip, skb);
 
+	if (fip_vlan_resp && op == FIP_OP_VLAN) {
+		LIBFCOE_FIP_DBG(fip, "fip vlan discovery\n");
+		return fcoe_ctlr_vlan_recv(fip, skb);
+	}
+
 	if (state != FIP_ST_ENABLED && state != FIP_ST_VNMP_UP &&
 	    state != FIP_ST_VNMP_CLAIM)
 		goto drop;
@@ -2704,6 +2714,220 @@ drop:
 }
 
 /**
+ * fcoe_ctlr_vlan_parse - parse vlan discovery request or response
+ * @fip: The FCoE controller
+ * @skb: incoming packet
+ * @rdata: buffer for resulting parsed VLAN entry plus fcoe_rport
+ *
+ * Returns non-zero error number on error.
+ * Does not consume the packet.
+ */
+static int fcoe_ctlr_vlan_parse(struct fcoe_ctlr *fip,
+			      struct sk_buff *skb,
+			      struct fc_rport_priv *rdata)
+{
+	struct fip_header *fiph;
+	struct fip_desc *desc = NULL;
+	struct fip_mac_desc *macd = NULL;
+	struct fip_wwn_desc *wwn = NULL;
+	struct fcoe_rport *frport;
+	size_t rlen;
+	size_t dlen;
+	u32 desc_mask = 0;
+	u32 dtype;
+	u8 sub;
+
+	memset(rdata, 0, sizeof(*rdata) + sizeof(*frport));
+	frport = fcoe_ctlr_rport(rdata);
+
+	fiph = (struct fip_header *)skb->data;
+	frport->flags = ntohs(fiph->fip_flags);
+
+	sub = fiph->fip_subcode;
+	switch (sub) {
+	case FIP_SC_VL_REQ:
+		desc_mask = BIT(FIP_DT_MAC) | BIT(FIP_DT_NAME);
+		break;
+	default:
+		LIBFCOE_FIP_DBG(fip, "vn_parse unknown subcode %u\n", sub);
+		return -EINVAL;
+	}
+
+	rlen = ntohs(fiph->fip_dl_len) * 4;
+	if (rlen + sizeof(*fiph) > skb->len)
+		return -EINVAL;
+
+	desc = (struct fip_desc *)(fiph + 1);
+	while (rlen > 0) {
+		dlen = desc->fip_dlen * FIP_BPW;
+		if (dlen < sizeof(*desc) || dlen > rlen)
+			return -EINVAL;
+
+		dtype = desc->fip_dtype;
+		if (dtype < 32) {
+			if (!(desc_mask & BIT(dtype))) {
+				LIBFCOE_FIP_DBG(fip,
+						"unexpected or duplicated desc "
+						"desc type %u in "
+						"FIP VN2VN subtype %u\n",
+						dtype, sub);
+				return -EINVAL;
+			}
+			desc_mask &= ~BIT(dtype);
+		}
+
+		switch (dtype) {
+		case FIP_DT_MAC:
+			if (dlen != sizeof(struct fip_mac_desc))
+				goto len_err;
+			macd = (struct fip_mac_desc *)desc;
+			if (!is_valid_ether_addr(macd->fd_mac)) {
+				LIBFCOE_FIP_DBG(fip,
+					"Invalid MAC addr %pM in FIP VN2VN\n",
+					 macd->fd_mac);
+				return -EINVAL;
+			}
+			memcpy(frport->enode_mac, macd->fd_mac, ETH_ALEN);
+			break;
+		case FIP_DT_NAME:
+			if (dlen != sizeof(struct fip_wwn_desc))
+				goto len_err;
+			wwn = (struct fip_wwn_desc *)desc;
+			rdata->ids.node_name = get_unaligned_be64(&wwn->fd_wwn);
+			break;
+		default:
+			LIBFCOE_FIP_DBG(fip, "unexpected descriptor type %x "
+					"in FIP probe\n", dtype);
+			/* standard says ignore unknown descriptors >= 128 */
+			if (dtype < FIP_DT_NON_CRITICAL)
+				return -EINVAL;
+			break;
+		}
+		desc = (struct fip_desc *)((char *)desc + dlen);
+		rlen -= dlen;
+	}
+	return 0;
+
+len_err:
+	LIBFCOE_FIP_DBG(fip, "FIP length error in descriptor type %x len %zu\n",
+			dtype, dlen);
+	return -EINVAL;
+}
+
+/**
+ * fcoe_ctlr_vlan_send() - Send a FIP VLAN Notification
+ * @fip: The FCoE controller
+ * @sub: sub-opcode for vlan notification or vn2vn vlan notification
+ * @dest: The destination Ethernet MAC address
+ * @min_len: minimum size of the Ethernet payload to be sent
+ */
+static void fcoe_ctlr_vlan_send(struct fcoe_ctlr *fip,
+			      enum fip_vlan_subcode sub,
+			      const u8 *dest)
+{
+	struct sk_buff *skb;
+	struct fip_vlan_notify_frame {
+		struct ethhdr eth;
+		struct fip_header fip;
+		struct fip_mac_desc mac;
+		struct fip_vlan_desc vlan;
+	} __packed * frame;
+	size_t len;
+	size_t dlen;
+
+	len = sizeof(*frame);
+	dlen = sizeof(frame->mac) + sizeof(frame->vlan);
+	len = max(len, sizeof(struct ethhdr));
+
+	skb = dev_alloc_skb(len);
+	if (!skb)
+		return;
+
+	LIBFCOE_FIP_DBG(fip, "fip %s vlan notification, vlan %d\n",
+			fip->mode == FIP_MODE_VN2VN ? "vn2vn" : "fcf",
+			fip->lp->vlan);
+
+	frame = (struct fip_vlan_notify_frame *)skb->data;
+	memset(frame, 0, len);
+	memcpy(frame->eth.h_dest, dest, ETH_ALEN);
+
+	memcpy(frame->eth.h_source, fip->ctl_src_addr, ETH_ALEN);
+	frame->eth.h_proto = htons(ETH_P_FIP);
+
+	frame->fip.fip_ver = FIP_VER_ENCAPS(FIP_VER);
+	frame->fip.fip_op = htons(FIP_OP_VLAN);
+	frame->fip.fip_subcode = sub;
+	frame->fip.fip_dl_len = htons(dlen / FIP_BPW);
+
+	frame->mac.fd_desc.fip_dtype = FIP_DT_MAC;
+	frame->mac.fd_desc.fip_dlen = sizeof(frame->mac) / FIP_BPW;
+	memcpy(frame->mac.fd_mac, fip->ctl_src_addr, ETH_ALEN);
+
+	frame->vlan.fd_desc.fip_dtype = FIP_DT_VLAN;
+	frame->vlan.fd_desc.fip_dlen = sizeof(frame->vlan) / FIP_BPW;
+	put_unaligned_be16(fip->lp->vlan, &frame->vlan.fd_vlan);
+
+	skb_put(skb, len);
+	skb->protocol = htons(ETH_P_FIP);
+	skb->priority = fip->priority;
+	skb_reset_mac_header(skb);
+	skb_reset_network_header(skb);
+
+	fip->send(fip, skb);
+}
+
+/**
+ * fcoe_ctlr_vlan_disk_reply() - send FIP VLAN Discovery Notification.
+ * @fip: The FCoE controller
+ *
+ * Called with ctlr_mutex held.
+ */
+static void fcoe_ctlr_vlan_disc_reply(struct fcoe_ctlr *fip,
+				      struct fc_rport_priv *rdata)
+{
+	struct fcoe_rport *frport = fcoe_ctlr_rport(rdata);
+	enum fip_vlan_subcode sub = FIP_SC_VL_NOTE;
+
+	if (fip->mode == FIP_MODE_VN2VN)
+		sub = FIP_SC_VL_VN2VN_NOTE;
+
+	fcoe_ctlr_vlan_send(fip, sub, frport->enode_mac);
+}
+
+/**
+ * fcoe_ctlr_vlan_recv - vlan request receive handler for VN2VN mode.
+ * @lport: The local port
+ * @fp: The received frame
+ *
+ */
+static int fcoe_ctlr_vlan_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
+{
+	struct fip_header *fiph;
+	enum fip_vlan_subcode sub;
+	struct {
+		struct fc_rport_priv rdata;
+		struct fcoe_rport frport;
+	} buf;
+	int rc;
+
+	fiph = (struct fip_header *)skb->data;
+	sub = fiph->fip_subcode;
+	rc = fcoe_ctlr_vlan_parse(fip, skb, &buf.rdata);
+	if (rc) {
+		LIBFCOE_FIP_DBG(fip, "vlan_recv vlan_parse error %d\n", rc);
+		goto drop;
+	}
+	mutex_lock(&fip->ctlr_mutex);
+	if (sub == FIP_SC_VL_REQ)
+		fcoe_ctlr_vlan_disc_reply(fip, &buf.rdata);
+	mutex_unlock(&fip->ctlr_mutex);
+
+drop:
+	kfree(skb);
+	return rc;
+}
+
+/**
  * fcoe_ctlr_disc_recv - discovery receive handler for VN2VN mode.
  * @lport: The local port
  * @fp: The received frame
diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index 045c4e1..0675fd1 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -385,6 +385,44 @@ static FCOE_DEVICE_ATTR(ctlr, enabled, S_IRUGO | S_IWUSR,
 			show_ctlr_enabled_state,
 			store_ctlr_enabled);
 
+static ssize_t store_ctlr_fip_resp(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct fcoe_ctlr_device *ctlr = dev_to_ctlr(dev);
+	struct fcoe_ctlr *fip = fcoe_ctlr_device_priv(ctlr);
+
+	mutex_lock(&fip->ctlr_mutex);
+	if ((buf[1] == '\0') || ((buf[1] == '\n') && (buf[2] == '\0'))) {
+		if (buf[0] == '1') {
+			fip->fip_resp = 1;
+			mutex_unlock(&fip->ctlr_mutex);
+			return count;
+		}
+		if (buf[0] == '0') {
+			fip->fip_resp = 0;
+			mutex_unlock(&fip->ctlr_mutex);
+			return count;
+		}
+	}
+	mutex_unlock(&fip->ctlr_mutex);
+	return -EINVAL;
+}
+
+static ssize_t show_ctlr_fip_resp(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	struct fcoe_ctlr_device *ctlr = dev_to_ctlr(dev);
+	struct fcoe_ctlr *fip = fcoe_ctlr_device_priv(ctlr);
+
+	return sprintf(buf, "%d\n", fip->fip_resp ? 1 : 0);
+}
+
+static FCOE_DEVICE_ATTR(ctlr, fip_vlan_responder, S_IRUGO | S_IWUSR,
+			show_ctlr_fip_resp,
+			store_ctlr_fip_resp);
+
 static ssize_t
 store_private_fcoe_ctlr_fcf_dev_loss_tmo(struct device *dev,
 					 struct device_attribute *attr,
@@ -467,6 +505,7 @@ static struct attribute_group fcoe_ctlr_lesb_attr_group = {
 };
 
 static struct attribute *fcoe_ctlr_attrs[] = {
+	&device_attr_fcoe_ctlr_fip_vlan_responder.attr,
 	&device_attr_fcoe_ctlr_fcf_dev_loss_tmo.attr,
 	&device_attr_fcoe_ctlr_enabled.attr,
 	&device_attr_fcoe_ctlr_mode.attr,
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 93d14da..7428a53 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -878,6 +878,7 @@ struct fc_lport {
 	struct libfc_function_template tt;
 	u8			       link_up;
 	u8			       qfull;
+	u16			       vlan;
 	enum fc_lport_state	       state;
 	unsigned long		       boot_time;
 	struct fc_host_statistics      host_stats;
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index bcc5c3e..722d326 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -110,8 +110,10 @@ enum fip_mode {
  * @flogi_req_send: send of FLOGI requested
  * @flogi_count:   number of FLOGI attempts in AUTO mode.
  * @map_dest:	   use the FC_MAP mode for destination MAC addresses.
+ * @fip_resp:	   start FIP VLAN discovery responder
  * @spma:	   supports SPMA server-provided MACs mode
  * @probe_tries:   number of FC_IDs probed
+ * @priority:      DCBx FCoE APP priority
  * @dest_addr:	   MAC address of the selected FC forwarder.
  * @ctl_src_addr:  the native MAC address of our local port.
  * @send:	   LLD-supplied function to handle sending FIP Ethernet frames
@@ -149,7 +151,8 @@ struct fcoe_ctlr {
 	u16 flogi_oxid;
 	u8 flogi_req_send;
 	u8 flogi_count;
-	u8 map_dest;
+	bool map_dest;
+	bool fip_resp;
 	u8 spma;
 	u8 probe_tries;
 	u8 priority;
-- 
1.8.5.6


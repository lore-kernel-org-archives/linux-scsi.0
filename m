From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 08/28] fcoe: drop FCoE LOGO in FIP mode
Date: Fri, 28 Jan 2011 16:03:52 -0800
Message-ID: <20110129000352.1784.56566.stgit@localhost6.localdomain6>
References: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5725 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab1A2ADx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 19:03:53 -0500
In-Reply-To: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@linux.intel.com>

Allowing FCoE LOGO followed by CVL in this case prevents
FIP login back to the FCF and then keeps lport offline,
only FIP LOGO and CLV needs to be processed while in
FIP mode, therefore this patch drops FCoE LOGO in FIP mode.

Added fcoe_filter_frames() to filter out above mentioned LOGO
in fcoe rx path along with other existing filtering in code
for bad CRC frames. Adding separate fcoe_filter_frames function
helped with better code indentations and if needed then same
will allow adding more filters at one place in future.

This LOGO drop is added after FCP frames passed up to avoid
any additional checks on fast path for this.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   84 ++++++++++++++++++++++++++++++----------------
 1 files changed, 54 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 452b421..d114699 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1620,6 +1620,56 @@ static void fcoe_percpu_flush_done(struct sk_buff *skb)
 }
 
 /**
+ * fcoe_filter_frames() - filter out bad fcoe frames, i.e. bad CRC
+ * @lport: The local port the frame was received on
+ * @fp:	   The received frame
+ *
+ * Return: 0 on passing filtering checks
+ */
+static inline int fcoe_filter_frames(struct fc_lport *lport,
+				     struct fc_frame *fp)
+{
+	struct fcoe_interface *fcoe;
+	struct fc_frame_header *fh;
+	struct sk_buff *skb = (struct sk_buff *)fp;
+	struct fcoe_dev_stats *stats;
+
+	/*
+	 * We only check CRC if no offload is available and if it is
+	 * it's solicited data, in which case, the FCP layer would
+	 * check it during the copy.
+	 */
+	if (lport->crc_offload && skb->ip_summed == CHECKSUM_UNNECESSARY)
+		fr_flags(fp) &= ~FCPHF_CRC_UNCHECKED;
+	else
+		fr_flags(fp) |= FCPHF_CRC_UNCHECKED;
+
+	fh = (struct fc_frame_header *) skb_transport_header(skb);
+	fh = fc_frame_header_get(fp);
+	if (fh->fh_r_ctl == FC_RCTL_DD_SOL_DATA && fh->fh_type == FC_TYPE_FCP)
+		return 0;
+
+	fcoe = ((struct fcoe_port *)lport_priv(lport))->fcoe;
+	if (is_fip_mode(&fcoe->ctlr) && fc_frame_payload_op(fp) == ELS_LOGO &&
+	    ntoh24(fh->fh_s_id) == FC_FID_FLOGI) {
+		FCOE_DBG("fcoe: dropping FCoE lport LOGO in fip mode\n");
+		return -EINVAL;
+	}
+
+	if (!fr_flags(fp) & FCPHF_CRC_UNCHECKED ||
+	    le32_to_cpu(fr_crc(fp)) == ~crc32(~0, skb->data, skb->len)) {
+		fr_flags(fp) &= ~FCPHF_CRC_UNCHECKED;
+		return 0;
+	}
+
+	stats = per_cpu_ptr(lport->dev_stats, get_cpu());
+	stats->InvalidCRCCount++;
+	if (stats->InvalidCRCCount < 5)
+		printk(KERN_WARNING "fcoe: dropping frame with CRC error\n");
+	return -EINVAL;
+}
+
+/**
  * fcoe_recv_frame() - process a single received frame
  * @skb: frame to process
  */
@@ -1629,7 +1679,6 @@ static void fcoe_recv_frame(struct sk_buff *skb)
 	struct fc_lport *lport;
 	struct fcoe_rcv_info *fr;
 	struct fcoe_dev_stats *stats;
-	struct fc_frame_header *fh;
 	struct fcoe_crc_eof crc_eof;
 	struct fc_frame *fp;
 	struct fcoe_port *port;
@@ -1660,7 +1709,6 @@ static void fcoe_recv_frame(struct sk_buff *skb)
 	 * was done in fcoe_rcv already.
 	 */
 	hp = (struct fcoe_hdr *) skb_network_header(skb);
-	fh = (struct fc_frame_header *) skb_transport_header(skb);
 
 	stats = per_cpu_ptr(lport->dev_stats, get_cpu());
 	if (unlikely(FC_FCOE_DECAPS_VER(hp) != FC_FCOE_VER)) {
@@ -1693,35 +1741,11 @@ static void fcoe_recv_frame(struct sk_buff *skb)
 	if (pskb_trim(skb, fr_len))
 		goto drop;
 
-	/*
-	 * We only check CRC if no offload is available and if it is
-	 * it's solicited data, in which case, the FCP layer would
-	 * check it during the copy.
-	 */
-	if (lport->crc_offload &&
-	    skb->ip_summed == CHECKSUM_UNNECESSARY)
-		fr_flags(fp) &= ~FCPHF_CRC_UNCHECKED;
-	else
-		fr_flags(fp) |= FCPHF_CRC_UNCHECKED;
-
-	fh = fc_frame_header_get(fp);
-	if ((fh->fh_r_ctl != FC_RCTL_DD_SOL_DATA ||
-	    fh->fh_type != FC_TYPE_FCP) &&
-	    (fr_flags(fp) & FCPHF_CRC_UNCHECKED)) {
-		if (le32_to_cpu(fr_crc(fp)) !=
-		    ~crc32(~0, skb->data, fr_len)) {
-			if (stats->InvalidCRCCount < 5)
-				printk(KERN_WARNING "fcoe: dropping "
-				       "frame with CRC error\n");
-			stats->InvalidCRCCount++;
-			goto drop;
-		}
-		fr_flags(fp) &= ~FCPHF_CRC_UNCHECKED;
+	if (!fcoe_filter_frames(lport, fp)) {
+		put_cpu();
+		fc_exch_recv(lport, fp);
+		return;
 	}
-	put_cpu();
-	fc_exch_recv(lport, fp);
-	return;
-
 drop:
 	stats->ErrorFrames++;
 	put_cpu();


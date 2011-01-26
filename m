From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [v4 PATCH 1/5] libfcoe: Move common code from fcoe.c to
 libfcoe.c
Date: Tue, 25 Jan 2011 18:57:45 -0800
Message-ID: <1296010665.3536.2586.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4197 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab1AZC6K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jan 2011 21:58:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org, linux-scsi@vger.kernel.org
Cc: Michael Chan <mchan@broadcom.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>

fcoe_start_io and fcoe_fc_crc are moved to libfcoe so that both
fcoe and bnx2fc drivers can use these common functions.

As part of this change, fixed fcoe_start_io to return ENOMEM if
skb_clone fails.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/fcoe/fcoe.c      |   58 -------------------------------------
 drivers/scsi/fcoe/fcoe_ctlr.c |   63 +++++++++++++++++++++++++++++++++++++++++
 include/scsi/libfcoe.h        |    2 +
 3 files changed, 65 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 8a1005d..ef87d4f 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1359,28 +1359,6 @@ err2:
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
  * fcoe_get_paged_crc_eof() - Allocate a page to be used for the trailer CRC
  * @skb:  The packet to be transmitted
  * @tlen: The total length of the trailer
@@ -1428,42 +1406,6 @@ static int fcoe_get_paged_crc_eof(struct sk_buff *skb, int tlen)
 }
 
 /**
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
-}
-
-/**
  * fcoe_xmit() - Transmit a FCoE frame
  * @lport: The local port that the frame is to be transmitted for
  * @fp:	   The frame to be transmitted
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index d449b66..8c845f6 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -32,6 +32,7 @@
 #include <linux/errno.h>
 #include <linux/bitops.h>
 #include <linux/slab.h>
+#include <linux/crc32.h>
 #include <net/rtnetlink.h>
 
 #include <scsi/fc/fc_els.h>
@@ -2680,3 +2681,65 @@ int fcoe_libfc_config(struct fc_lport *lport, struct fcoe_ctlr *fip,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(fcoe_libfc_config);
+
+/**
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
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index efb6ae5..a9a9875 100644
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
-- 
1.7.0.6





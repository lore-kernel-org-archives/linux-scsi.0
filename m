From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 51/54] libfc, fcoe: fixes for highmem skb linearize panics
Date: Tue, 03 Nov 2009 11:50:05 -0800
Message-ID: <20091103195005.4085.32630.stgit@localhost.localdomain>
References: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15619 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbZKCTuA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:50:00 -0500
In-Reply-To: <20091103194530.4085.37963.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

There are cases outside of our control that may result in a transmit
skb being linearized in dev_queue_xmit.  There are a couple of bugs
in libfc/fcoe that can result in a panic at that point.  This patch
contains two fixes to prevent those panics.

1) use fast cloning instead of shared skbs with dev_queue_xmit

dev_queue_xmit doen't want shared skbuffs being passed in, and
__skb_linearize will BUG if the skb is shared.  FCoE is holding an extra
reference around the call to dev_queue_xmit, so that when it returns an
error code indicating the frame has been dropped it can maintain it's
own backlog and retransmit.  Switch to using fast skb cloning for this
instead.

2) don't append compound pages as > PAGE_SIZE skb fragments

fc_fcp_send_data will append pages from a scatterlist to the nr_frags[]
if the netdev supports it.  But, it's using > PAGE_SIZE compound pages
as a single skb_frag.  In the highmem linearize case that page will be
passed to kmap_atomic to get a mapping to copy out of, but
kmap_atomic will only allow access to the first PAGE_SIZE part.
The memcpy will keep going and cause a page fault once is crosses the
first boundary.

If fc_fcp_send_data uses linear buffers from the start, it calls
kmap_atomic one PAGE_SIZE at a time.  That same logic needs to be
applied when setting up skb_frags.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c      |    5 +++--
 drivers/scsi/libfc/fc_fcp.c   |   20 ++++++++++----------
 drivers/scsi/libfc/fc_frame.c |    5 +++--
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 28029a3..b570f39 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1267,10 +1267,11 @@ err2:
  */
 static inline int fcoe_start_io(struct sk_buff *skb)
 {
+	struct sk_buff *nskb;
 	int rc;
 
-	skb_get(skb);
-	rc = dev_queue_xmit(skb);
+	nskb = skb_clone(skb, GFP_ATOMIC);
+	rc = dev_queue_xmit(nskb);
 	if (rc != 0)
 		return rc;
 	kfree_skb(skb);
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index db252e2..c4b58d0 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -530,11 +530,13 @@ static int fc_fcp_send_data(struct fc_fcp_pkt *fsp, struct fc_seq *seq,
 	struct scatterlist *sg;
 	struct fc_frame *fp = NULL;
 	struct fc_lport *lport = fsp->lp;
+	struct page *page;
 	size_t remaining;
 	size_t t_blen;
 	size_t tlen;
 	size_t sg_bytes;
 	size_t frame_offset, fh_parm_offset;
+	size_t off;
 	int error;
 	void *data = NULL;
 	void *page_addr;
@@ -605,28 +607,26 @@ static int fc_fcp_send_data(struct fc_fcp_pkt *fsp, struct fc_seq *seq,
 			fh_parm_offset = frame_offset;
 			fr_max_payload(fp) = fsp->max_payload;
 		}
+
+		off = offset + sg->offset;
 		sg_bytes = min(tlen, sg->length - offset);
+		sg_bytes = min(sg_bytes,
+			       (size_t) (PAGE_SIZE - (off & ~PAGE_MASK)));
+		page = sg_page(sg) + (off >> PAGE_SHIFT);
 		if (using_sg) {
-			get_page(sg_page(sg));
+			get_page(page);
 			skb_fill_page_desc(fp_skb(fp),
 					   skb_shinfo(fp_skb(fp))->nr_frags,
-					   sg_page(sg), sg->offset + offset,
-					   sg_bytes);
+					   page, off & ~PAGE_MASK, sg_bytes);
 			fp_skb(fp)->data_len += sg_bytes;
 			fr_len(fp) += sg_bytes;
 			fp_skb(fp)->truesize += PAGE_SIZE;
 		} else {
-			size_t off = offset + sg->offset;
-
 			/*
 			 * The scatterlist item may be bigger than PAGE_SIZE,
 			 * but we must not cross pages inside the kmap.
 			 */
-			sg_bytes = min(sg_bytes, (size_t) (PAGE_SIZE -
-							   (off & ~PAGE_MASK)));
-			page_addr = kmap_atomic(sg_page(sg) +
-						(off >> PAGE_SHIFT),
-						KM_SOFTIRQ0);
+			page_addr = kmap_atomic(page, KM_SOFTIRQ0);
 			memcpy(data, (char *)page_addr + (off & ~PAGE_MASK),
 			       sg_bytes);
 			kunmap_atomic(page_addr, KM_SOFTIRQ0);
diff --git a/drivers/scsi/libfc/fc_frame.c b/drivers/scsi/libfc/fc_frame.c
index 79c9565..6da01c6 100644
--- a/drivers/scsi/libfc/fc_frame.c
+++ b/drivers/scsi/libfc/fc_frame.c
@@ -58,12 +58,13 @@ struct fc_frame *_fc_frame_alloc(size_t len)
 
 	WARN_ON((len % sizeof(u32)) != 0);
 	len += sizeof(struct fc_frame_header);
-	skb = dev_alloc_skb(len + FC_FRAME_HEADROOM + FC_FRAME_TAILROOM);
+	skb = alloc_skb_fclone(len + FC_FRAME_HEADROOM + FC_FRAME_TAILROOM +
+			       NET_SKB_PAD, GFP_ATOMIC);
 	if (!skb)
 		return NULL;
+	skb_reserve(skb, NET_SKB_PAD + FC_FRAME_HEADROOM);
 	fp = (struct fc_frame *) skb;
 	fc_frame_init(fp);
-	skb_reserve(skb, FC_FRAME_HEADROOM);
 	skb_put(skb, len);
 	return fp;
 }


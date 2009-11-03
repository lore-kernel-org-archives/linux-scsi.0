From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 27/54] fcoe, libfc: use single frame allocation API
Date: Tue, 03 Nov 2009 11:47:55 -0800
Message-ID: <20091103194755.4085.73133.stgit@localhost.localdomain>
References: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:29941 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357AbZKCTru (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:47:50 -0500
In-Reply-To: <20091103194530.4085.37963.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Cleans up frame allocation APIs to have just single fc_frame_alloc API.

Removes _fc_frame_alloc, renames __fc_frame_alloc to _fc_frame_alloc.

Modifies fc_fcp_send_data for removed _fc_frame_alloc, fc_fcp_send_data
was the only user of removed _fc_frame_alloc.

Also Adds check in fc_frame_alloc to do mod by 4 for only non-zero
len value.

This patch is prep work to fix can_queue reducing in next patch.
Single fc_frame_alloc API helps in fixing can_queue reducing in
next patch.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c   |   15 ++++-----------
 drivers/scsi/libfc/fc_frame.c |    6 +++---
 include/scsi/fc_frame.h       |   16 +++-------------
 3 files changed, 10 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 970b54f..567eee7 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -505,18 +505,11 @@ static int fc_fcp_send_data(struct fc_fcp_pkt *fsp, struct fc_seq *seq,
 			 */
 			if (tlen % 4)
 				using_sg = 0;
-			if (using_sg) {
-				fp = _fc_frame_alloc(lport, 0);
-				if (!fp)
-					return -ENOMEM;
-			} else {
-				fp = fc_frame_alloc(lport, tlen);
-				if (!fp)
-					return -ENOMEM;
+			fp = fc_frame_alloc(lport, using_sg ? 0 : tlen);
+			if (!fp)
+				return -ENOMEM;
 
-				data = (void *)(fr_hdr(fp)) +
-					sizeof(struct fc_frame_header);
-			}
+			data = fc_frame_header_get(fp) + 1;
 			fh_parm_offset = frame_offset;
 			fr_max_payload(fp) = fsp->max_payload;
 		}
diff --git a/drivers/scsi/libfc/fc_frame.c b/drivers/scsi/libfc/fc_frame.c
index 4fea369..79c9565 100644
--- a/drivers/scsi/libfc/fc_frame.c
+++ b/drivers/scsi/libfc/fc_frame.c
@@ -51,7 +51,7 @@ EXPORT_SYMBOL(fc_frame_crc_check);
  * Allocate a frame intended to be sent via fcoe_xmit.
  * Get an sk_buff for the frame and set the length.
  */
-struct fc_frame *__fc_frame_alloc(size_t len)
+struct fc_frame *_fc_frame_alloc(size_t len)
 {
 	struct fc_frame *fp;
 	struct sk_buff *skb;
@@ -67,7 +67,7 @@ struct fc_frame *__fc_frame_alloc(size_t len)
 	skb_put(skb, len);
 	return fp;
 }
-EXPORT_SYMBOL(__fc_frame_alloc);
+EXPORT_SYMBOL(_fc_frame_alloc);
 
 struct fc_frame *fc_frame_alloc_fill(struct fc_lport *lp, size_t payload_len)
 {
@@ -77,7 +77,7 @@ struct fc_frame *fc_frame_alloc_fill(struct fc_lport *lp, size_t payload_len)
 	fill = payload_len % 4;
 	if (fill != 0)
 		fill = 4 - fill;
-	fp = __fc_frame_alloc(payload_len + fill);
+	fp = _fc_frame_alloc(payload_len + fill);
 	if (fp) {
 		memset((char *) fr_hdr(fp) + payload_len, 0, fill);
 		/* trim is OK, we just allocated it so there are no fragments */
diff --git a/include/scsi/fc_frame.h b/include/scsi/fc_frame.h
index ab2f8d4..4d3e9c7 100644
--- a/include/scsi/fc_frame.h
+++ b/include/scsi/fc_frame.h
@@ -100,17 +100,7 @@ static inline void fc_frame_init(struct fc_frame *fp)
 }
 
 struct fc_frame *fc_frame_alloc_fill(struct fc_lport *, size_t payload_len);
-
-struct fc_frame *__fc_frame_alloc(size_t payload_len);
-
-/*
- * Get frame for sending via port.
- */
-static inline struct fc_frame *_fc_frame_alloc(struct fc_lport *dev,
-					       size_t payload_len)
-{
-	return __fc_frame_alloc(payload_len);
-}
+struct fc_frame *_fc_frame_alloc(size_t payload_len);
 
 /*
  * Allocate fc_frame structure and buffer.  Set the initial length to
@@ -124,10 +114,10 @@ static inline struct fc_frame *fc_frame_alloc(struct fc_lport *dev, size_t len)
 	 * Note: Since len will often be a constant multiple of 4,
 	 * this check will usually be evaluated and eliminated at compile time.
 	 */
-	if ((len % 4) != 0)
+	if (len && len % 4)
 		fp = fc_frame_alloc_fill(dev, len);
 	else
-		fp = _fc_frame_alloc(dev, len);
+		fp = _fc_frame_alloc(len);
 	return fp;
 }
 


From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 33/35] fcoe, libfc: use single frame allocation API
Date: Fri, 11 Sep 2009 16:59:56 -0700
Message-ID: <20090911235956.27223.72586.stgit@localhost.localdomain>
References: <20090911235655.27223.69728.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:61482 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199AbZIKX7w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Sep 2009 19:59:52 -0400
In-Reply-To: <20090911235655.27223.69728.stgit@localhost.localdomain>
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
index 858c0b2..e85dc9a 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -507,18 +507,11 @@ static int fc_fcp_send_data(struct fc_fcp_pkt *fsp, struct fc_seq *seq,
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
index 8ddb685..6da01c6 100644
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
@@ -68,7 +68,7 @@ struct fc_frame *__fc_frame_alloc(size_t len)
 	skb_put(skb, len);
 	return fp;
 }
-EXPORT_SYMBOL(__fc_frame_alloc);
+EXPORT_SYMBOL(_fc_frame_alloc);
 
 struct fc_frame *fc_frame_alloc_fill(struct fc_lport *lp, size_t payload_len)
 {
@@ -78,7 +78,7 @@ struct fc_frame *fc_frame_alloc_fill(struct fc_lport *lp, size_t payload_len)
 	fill = payload_len % 4;
 	if (fill != 0)
 		fill = 4 - fill;
-	fp = __fc_frame_alloc(payload_len + fill);
+	fp = _fc_frame_alloc(payload_len + fill);
 	if (fp) {
 		memset((char *) fr_hdr(fp) + payload_len, 0, fill);
 		/* trim is OK, we just allocated it so there are no fragments */
diff --git a/include/scsi/fc_frame.h b/include/scsi/fc_frame.h
index bfdb7aa..b2b2267 100644
--- a/include/scsi/fc_frame.h
+++ b/include/scsi/fc_frame.h
@@ -97,17 +97,7 @@ static inline void fc_frame_init(struct fc_frame *fp)
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
@@ -121,10 +111,10 @@ static inline struct fc_frame *fc_frame_alloc(struct fc_lport *dev, size_t len)
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
 


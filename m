From: Joe Eykholt <fcoe@eykholt.com>
Subject: [OpenFCoE PATCH] If expecting pre-T11 frames,
	a T11 frame caused a data fault.
Date: Tue, 04 Dec 2007 16:52:14 -0800
Message-ID: <20071205005214.26211.62814.stgit@mink.he.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eykholt.com ([72.52.117.41]:35100 "HELO eykholt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751495AbXLEAwR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 19:52:17 -0500
Received: from mink.he.net ([127.0.0.1]) by eykholt.com for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 16:52:14 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

If expecting pre-T11 frames, a T11 frame caused a data fault.

This is because the T11 frames have zeros where the old length/SOF
field was, and a length of less than the size of the FC header was
not checked for.

Also limit length error messages to frames (per-CPU actually).

Signed-off-by: Joe Eykholt <fcoe@eykholt.com>

---
 drivers/scsi/ofc/fcoe/fcoe_dev.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ofc/fcoe/fcoe_dev.c b/drivers/scsi/ofc/fcoe/fcoe_dev.c
index df652b6..878efd4 100644
--- a/drivers/scsi/ofc/fcoe/fcoe_dev.c
+++ b/drivers/scsi/ofc/fcoe/fcoe_dev.c
@@ -485,8 +485,9 @@ int fcoe_percpu_receive_thread(void *arg)
 
 			hp = (struct fcoe_hdr *)skb->data;
 			if (unlikely(FC_FCOE_DECAPS_VER(hp) != FC_FCOE_VER)) {
-				SA_LOG("unknown FCoE version %x",
-				       FC_FCOE_DECAPS_VER(hp));
+				if (stats->ErrorFrames < 5)
+					SA_LOG("unknown FCoE version %x",
+					       FC_FCOE_DECAPS_VER(hp));
 				stats->ErrorFrames++;
 				kfree_skb(skb);
 				continue;
@@ -505,20 +506,25 @@ int fcoe_percpu_receive_thread(void *arg)
 			skb_pull(skb, sizeof(*fchp));
 			fr_len = FC_FCOE_DECAPS_LEN(len);
 			fr_len = fr_len * FCOE_WORD_TO_BYTE;
+			if (unlikely(fr_len < sizeof(struct fc_frame_header) +
+			    sizeof(cp->fcoe_crc32))) {
+				if (stats->ErrorFrames < 5)
+					SA_LOG("length error: len_sof %x", len);
+				stats->ErrorFrames++;
+				kfree_skb(skb);
+				continue;
+			}
 			sof = FC_FCOE_DECAPS_SOF(len);
 			fr_len -= sizeof(cp->fcoe_crc32);
 			tlen = sizeof(struct fcoe_crc_eof_old);
 		}
 
 		if (skb_is_nonlinear(skb))
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18)
-			skb_linearize(skb, GFP_KERNEL);	/* not ideal */
-#else
 			skb_linearize(skb);	/* not ideal */
-#endif
 		if (unlikely(fr_len + tlen > skb->len)) {
-			SA_LOG("short frame fr_len %x skb->len %x\n",
-			       fr_len + tlen, skb->len);
+			if (stats->ErrorFrames < 5)
+				SA_LOG("length error fr_len 0x%x skb->len 0x%x",
+				       fr_len + tlen, skb->len);
 			stats->ErrorFrames++;
 			kfree_skb(skb);
 			continue;
@@ -540,6 +546,7 @@ int fcoe_percpu_receive_thread(void *arg)
 		 * and it'll be more cache-efficient.
 		 */
 		fh = fc_frame_header_get(fp);
+		ASSERT(fh);
 		if (fh->fh_r_ctl == FC_RCTL_DD_SOL_DATA &&
 		    fh->fh_type == FC_TYPE_FCP) {
 			fp->fr_flags |= FCPHF_CRC_UNCHECKED;



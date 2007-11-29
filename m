From: Joe Eykholt <fcoe@eykholt.com>
Subject: [Open-FCoE] [PATCH] If expecting pre-T11 frames, a T11 frame caused
 a data fault.
Date: Thu, 29 Nov 2007 15:21:11 -0800
Message-ID: <474F4967.60204@eykholt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eykholt.com ([72.52.117.41]:41405 "HELO eykholt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934173AbXK2Xfc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Nov 2007 18:35:32 -0500
Received: from 67.91.200.194 ([67.91.200.194]) by eykholt.com for <linux-scsi@vger.kernel.org>; Thu, 29 Nov 2007 15:21:00 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Joe Eykholt <joe@eykholt.com>
Date: Mon, 26 Nov 2007 18:51:01 -0800
If expecting pre-T11 frames, a T11 frame caused a data fault.

This is because the T11 frames have zeros where the old length/SOF
field was, and a length of less than the size of the FC header was
not checked for.

Also limit length error messages to 5 frames (per-CPU actually).
---
 drivers/scsi/ofc/fcoe/fcoe_dev.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ofc/fcoe/fcoe_dev.c b/drivers/scsi/ofc/fcoe/fcoe_dev.c
index df652b6..f5b5eed 100644
--- a/drivers/scsi/ofc/fcoe/fcoe_dev.c
+++ b/drivers/scsi/ofc/fcoe/fcoe_dev.c
@@ -485,8 +485,9 @@ int fcoe_percpu_receive_thread(void *arg)

                        hp = (struct fcoe_hdr *)skb->data;
                        if (unlikely(FC_FCOE_DECAPS_VER(hp) != FC_FCOE_VER)) {
-                               SA_LOG("unknown FCoE version %x",
-                                      FC_FCOE_DECAPS_VER(hp));
+                               if (stats->ErrorFrames < 5)
+                                       SA_LOG("unknown FCoE version %x",
+                                              FC_FCOE_DECAPS_VER(hp));
                                stats->ErrorFrames++;
                                kfree_skb(skb);
                                continue;
@@ -505,20 +506,25 @@ int fcoe_percpu_receive_thread(void *arg)
                        skb_pull(skb, sizeof(*fchp));
                        fr_len = FC_FCOE_DECAPS_LEN(len);
                        fr_len = fr_len * FCOE_WORD_TO_BYTE;
+                       if (unlikely(fr_len < sizeof (struct fc_frame_header) +
+                           sizeof (cp->fcoe_crc32))) {
+                               if (stats->ErrorFrames < 5)
+                                       SA_LOG("length error: len_sof %x", len);
+                               stats->ErrorFrames++;
+                               kfree_skb(skb);
+                               continue;
+                       }
                        sof = FC_FCOE_DECAPS_SOF(len);
                        fr_len -= sizeof(cp->fcoe_crc32);
                        tlen = sizeof(struct fcoe_crc_eof_old);
                }

                if (skb_is_nonlinear(skb))
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18)
-                       skb_linearize(skb, GFP_KERNEL); /* not ideal */
-#else
                        skb_linearize(skb);     /* not ideal */
-#endif
                if (unlikely(fr_len + tlen > skb->len)) {
-                       SA_LOG("short frame fr_len %x skb->len %x\n",
-                              fr_len + tlen, skb->len);
+                       if (stats->ErrorFrames < 5)
+                               SA_LOG("length error fr_len 0x%x skb->len 0x%x",
+                                      fr_len + tlen, skb->len);
                        stats->ErrorFrames++;
                        kfree_skb(skb);
                        continue;
@@ -540,6 +546,7 @@ int fcoe_percpu_receive_thread(void *arg)
                 * and it'll be more cache-efficient.
                 */
                fh = fc_frame_header_get(fp);
+               ASSERT(fh);
                if (fh->fh_r_ctl == FC_RCTL_DD_SOL_DATA &&
                    fh->fh_type == FC_TYPE_FCP) {
                        fp->fr_flags |= FCPHF_CRC_UNCHECKED;
--
1.5.3.6

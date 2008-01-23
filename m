From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 07/10] [FCoE] Remove ASSERTs from fcoe
Date: Tue, 22 Jan 2008 16:37:11 -0800
Message-ID: <20080123003711.8469.99478.stgit@fritz>
References: <20080123003523.8469.62236.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1292 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757445AbYAWAvM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jan 2008 19:51:12 -0500
In-Reply-To: <20080123003523.8469.62236.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/ofc/fcoe/fcoe_def.h  |    1 -
 drivers/scsi/ofc/fcoe/fcoe_dev.c  |   16 ++++++----------
 drivers/scsi/ofc/fcoe/fcoe_if.c   |    4 ----
 drivers/scsi/ofc/fcoe/fcoeinit.c  |    1 -
 drivers/scsi/ofc/fcoe/fcoeioctl.c |    1 -
 5 files changed, 6 insertions(+), 17 deletions(-)


diff --git a/drivers/scsi/ofc/fcoe/fcoe_def.h b/drivers/scsi/ofc/fcoe/fcoe_def.h
index 22c5934..867ae55 100644
--- a/drivers/scsi/ofc/fcoe/fcoe_def.h
+++ b/drivers/scsi/ofc/fcoe/fcoe_def.h
@@ -93,7 +93,6 @@ struct fcoe_rcv_info {
  */
 static inline struct fcoe_rcv_info *fcoe_dev_from_skb(struct sk_buff *skb)
 {
-        ASSERT(sizeof(struct fcoe_rcv_info) <= sizeof(skb->cb));
         return ((struct fcoe_rcv_info *) skb->cb);
 }
 
diff --git a/drivers/scsi/ofc/fcoe/fcoe_dev.c b/drivers/scsi/ofc/fcoe/fcoe_dev.c
index f37bd2c..0beb78e 100644
--- a/drivers/scsi/ofc/fcoe/fcoe_dev.c
+++ b/drivers/scsi/ofc/fcoe/fcoe_dev.c
@@ -36,7 +36,6 @@
 #include <scsi/scsi_transport_fc.h>
 #include <net/rtnetlink.h>
 
-#include "sa_assert.h"
 #include "fc_types.h"
 #include "fc_frame.h"
 #include "fc_print.h"
@@ -178,7 +177,7 @@ static void fcoe_skb_destroy(struct sk_buff *skb)
 	struct fcdev *fdev = (struct fcdev *)fp->fr_dev;
 	struct fcoe_softc *fc = NULL;
 
-	ASSERT(fp->fr_free_priv == skb);
+	WARN_ON(fp->fr_free_priv != skb);
 
 	if (fdev)
 		fc = (struct fcoe_softc *)fdev->drv_priv;
@@ -201,7 +200,7 @@ struct fc_frame *fcoe_frame_alloc(size_t len)
 	struct fc_frame *fp;
 	struct sk_buff *skb;
 
-	ASSERT((len % sizeof(uint32_t)) == 0);
+	WARN_ON((len % sizeof(uint32_t)) != 0);
 	len += sizeof(struct fc_frame_header);
 	skb = dev_alloc_skb(len + sizeof(*fp) +
 			    FC_FRAME_HEADROOM + FC_FRAME_TAILROOM);
@@ -245,7 +244,7 @@ int fcoe_xmit(struct fcdev *fc_dev, struct fc_frame *fp)
 	if (unlikely(debug_fcoe))
 		fc_print_frame_hdr("fcoe_xmit", fp);
 
-	ASSERT((fp->fr_len % sizeof(uint32_t)) == 0);
+	WARN_ON((fp->fr_len % sizeof(uint32_t)) != 0);
 
 	fc = (struct fcoe_softc *)fc_dev->drv_priv;
 	/*
@@ -272,9 +271,9 @@ int fcoe_xmit(struct fcdev *fc_dev, struct fc_frame *fp)
 		}
 	}
 
-	ASSERT(fp->fr_free == fcoe_frame_free);	/* allocated by us */
+	WARN_ON(fp->fr_free != fcoe_frame_free);	/* allocated by us */
 	skb = (struct sk_buff *)fp->fr_free_priv;
-	ASSERT(skb->data == (unsigned char *)fp->fr_hdr);
+	WARN_ON(skb->data != (unsigned char *)fp->fr_hdr);
 
 	sof = fp->fr_sof;
 	eof = fp->fr_eof;
@@ -394,7 +393,6 @@ int fcoe_xmit(struct fcdev *fc_dev, struct fc_frame *fp)
 	} else {
 		struct fcoe_hdr_old *ohp;
 
-		ASSERT(hlen == sizeof(*ohp));
 		ohp = (struct fcoe_hdr_old *)(eh + 1);
 		net16_put(&ohp->fcoe_plen, FC_FCOE_ENCAPS_LEN_SOF(wlen, sof));
 	}
@@ -502,7 +500,6 @@ int fcoe_percpu_receive_thread(void *arg)
 			struct fcoe_hdr_old *fchp;
 			u_int len;
 
-			ASSERT(hlen == sizeof(*fchp));
 			fchp = (struct fcoe_hdr_old *)skb->data;
 			len = net16_get(&fchp->fcoe_plen);
 			skb_pull(skb, sizeof(*fchp));
@@ -548,7 +545,6 @@ int fcoe_percpu_receive_thread(void *arg)
 		 * and it'll be more cache-efficient.
 		 */
 		fh = fc_frame_header_get(fp);
-		ASSERT(fh);
 		if (fh->fh_r_ctl == FC_RCTL_DD_SOL_DATA &&
 		    fh->fh_type == FC_TYPE_FCP) {
 			fp->fr_flags |= FCPHF_CRC_UNCHECKED;
@@ -568,7 +564,7 @@ int fcoe_percpu_receive_thread(void *arg)
 			stats->ErrorFrames++;
 			fc_frame_free(fp);
 		}
-		ASSERT(fc_frame_freed_static(fp));
+		WARN_ON(!fc_frame_freed_static(fp));
 		kfree_skb(skb);
 	}
 	return 0;
diff --git a/drivers/scsi/ofc/fcoe/fcoe_if.c b/drivers/scsi/ofc/fcoe/fcoe_if.c
index 9963593..f3e323d 100644
--- a/drivers/scsi/ofc/fcoe/fcoe_if.c
+++ b/drivers/scsi/ofc/fcoe/fcoe_if.c
@@ -40,7 +40,6 @@
 /*
  * Non Linux header definitions
  */
-#include "sa_assert.h"
 #include "fc_types.h"
 #include "fc_frame.h"
 #include "fc_print.h"
@@ -102,8 +101,6 @@ int fcoe_destroy_interface(struct fcdev *fd)
 	net8_t flogi_maddr[ETH_ALEN];
 #endif
 
-	ASSERT(fd != NULL);
-
 	openfc_unregister(fd);
 
 	fc = (struct fcoe_softc *)fd->drv_priv;
@@ -222,7 +219,6 @@ int fcoe_create_interface(struct fcoe_info *fci, void *ptr)
 	net8_t flogi_maddr[ETH_ALEN];
 #endif
 
-	ASSERT(fci != NULL);
 	fdev = openfc_alloc_dev(&fcoe_port_ops, sizeof(struct fcoe_softc));
 	if (unlikely(!fdev)) {
 		OFC_DBG("couldn't allocate space for hba struct");
diff --git a/drivers/scsi/ofc/fcoe/fcoeinit.c b/drivers/scsi/ofc/fcoe/fcoeinit.c
index 1ac7d69..a39f451 100644
--- a/drivers/scsi/ofc/fcoe/fcoeinit.c
+++ b/drivers/scsi/ofc/fcoe/fcoeinit.c
@@ -29,7 +29,6 @@
 #include <linux/if_ether.h>
 #include <linux/fs.h>
 
-#include "sa_assert.h"
 #include "fc_types.h"
 #include "fc_frame.h"
 #include "fcdev.h"
diff --git a/drivers/scsi/ofc/fcoe/fcoeioctl.c b/drivers/scsi/ofc/fcoe/fcoeioctl.c
index a2f8a25..8621cff 100644
--- a/drivers/scsi/ofc/fcoe/fcoeioctl.c
+++ b/drivers/scsi/ofc/fcoe/fcoeioctl.c
@@ -22,7 +22,6 @@
 #include <linux/kernel.h>
 #include <linux/fs.h>
 
-#include "sa_assert.h"
 #include "fc_types.h"
 #include "fc_frame.h"
 #include "fcdev.h"


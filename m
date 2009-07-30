From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 20/22] libfc: Remove FC_FRAME_SG_LEN in fc_fcp_send_data
Date: Wed, 29 Jul 2009 17:05:32 -0700
Message-ID: <20090730000532.24658.82220.stgit@localhost.localdomain>
References: <20090730000345.24658.24830.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10563 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510AbZG3AFe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 20:05:34 -0400
In-Reply-To: <20090730000345.24658.24830.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

FC_FRAME_SG_LEN is 4 which is too small when offload is enabled. Actually, the
WARN_ON() in fc_fcp_send_data() should be:

	WARN_ON(skb_shinfo(fp_skb(fp))->nr_frags > MAX_SKB_FRAGS);

But since we will not get anything more than 64K anyway, so there is no need
to do this anyway here. Therefore, I am getting rid of FC_FRAME_SG_LEN here
and the WARN_ON here.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c |    2 --
 include/scsi/fc_frame.h     |    7 -------
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index e303e0d..2069edf 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -569,8 +569,6 @@ static int fc_fcp_send_data(struct fc_fcp_pkt *fsp, struct fc_seq *seq,
 		}
 		sg_bytes = min(tlen, sg->length - offset);
 		if (using_sg) {
-			WARN_ON(skb_shinfo(fp_skb(fp))->nr_frags >
-				FC_FRAME_SG_LEN);
 			get_page(sg_page(sg));
 			skb_fill_page_desc(fp_skb(fp),
 					   skb_shinfo(fp_skb(fp))->nr_frags,
diff --git a/include/scsi/fc_frame.h b/include/scsi/fc_frame.h
index 5951105..c35d238 100644
--- a/include/scsi/fc_frame.h
+++ b/include/scsi/fc_frame.h
@@ -37,13 +37,6 @@
 #define	FC_FRAME_HEADROOM	32	/* headroom for VLAN + FCoE headers */
 #define	FC_FRAME_TAILROOM	8	/* trailer space for FCoE */
 
-/*
- * Information about an individual fibre channel frame received or to be sent.
- * The buffer may be in up to 4 additional non-contiguous sections,
- * but the linear section must hold the frame header.
- */
-#define FC_FRAME_SG_LEN		4	/* scatter/gather list maximum length */
-
 #define fp_skb(fp)	(&((fp)->skb))
 #define fr_hdr(fp)	((fp)->skb.data)
 #define fr_len(fp)	((fp)->skb.len)


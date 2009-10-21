From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 14/20] libfc: Fix frags in frame exceeding SKB_MAX_FRAGS in
	fc_fcp_send_data
Date: Wed, 21 Oct 2009 16:27:58 -0700
Message-ID: <20091021232758.12986.69286.stgit@localhost.localdomain>
References: <20091021232640.12986.79205.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41449 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbZJUX2K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 19:28:10 -0400
In-Reply-To: <20091021232640.12986.79205.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

In case of sequence offload, in fc_fcp_send_data(), the skb_fill_page_info()
called may end up adding more frags to the skb_shinfo(fp_skb(fp))->frags[],
exceeding SKB_MAX_FRAGS, this eventually corrupts the memory. I am adding the
FR_FRAME_SG_LEN back, but as SKB_MAX_FRAGS -1, leaving 1 for our fcoe_eof_crc
page. And send will be broken into multiple large sends if the frame already
contains more frags than skb handle.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c |    3 ++-
 include/scsi/fc_frame.h     |    3 +++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 40ed744..28bfe1c 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -574,7 +574,8 @@ static int fc_fcp_send_data(struct fc_fcp_pkt *fsp, struct fc_seq *seq,
 		tlen -= sg_bytes;
 		remaining -= sg_bytes;
 
-		if (tlen)
+		if ((skb_shinfo(fp_skb(fp))->nr_frags < FC_FRAME_SG_LEN) &&
+		    (tlen))
 			continue;
 
 		/*
diff --git a/include/scsi/fc_frame.h b/include/scsi/fc_frame.h
index c35d238..148126d 100644
--- a/include/scsi/fc_frame.h
+++ b/include/scsi/fc_frame.h
@@ -37,6 +37,9 @@
 #define	FC_FRAME_HEADROOM	32	/* headroom for VLAN + FCoE headers */
 #define	FC_FRAME_TAILROOM	8	/* trailer space for FCoE */
 
+/* Max number of skb frags allowed, reserving one for fcoe_crc_eof page */
+#define FC_FRAME_SG_LEN		(MAX_SKB_FRAGS - 1)
+
 #define fp_skb(fp)	(&((fp)->skb))
 #define fr_hdr(fp)	((fp)->skb.data)
 #define fr_len(fp)	((fp)->skb.len)


From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 21/24] fcoe: fix kfree(skb)
Date: Fri, 27 Feb 2009 10:56:22 -0800
Message-ID: <20090227185621.25509.32451.stgit@fritz>
References: <20090227185430.25509.34309.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:29603 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501AbZB0S4X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 13:56:23 -0500
In-Reply-To: <20090227185430.25509.34309.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

Use kfree_skb instead of kfree for struct sk_buff pointers.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 7887f2a..7265e09 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -437,7 +437,7 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 	if (skb_is_nonlinear(skb)) {
 		skb_frag_t *frag;
 		if (fcoe_get_paged_crc_eof(skb, tlen)) {
-			kfree(skb);
+			kfree_skb(skb);
 			return -ENOMEM;
 		}
 		frag = &skb_shinfo(skb)->frags[skb_shinfo(skb)->nr_frags - 1];


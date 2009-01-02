From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] [SCSI] fcoe: fix kfree(skb)
Date: Fri, 02 Jan 2009 13:50:00 +0100
Message-ID: <495E0D78.1010301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:35494 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513AbZABMuE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jan 2009 07:50:04 -0500
Received: by ewy10 with SMTP id 10so6740338ewy.13
        for <linux-scsi@vger.kernel.org>; Fri, 02 Jan 2009 04:50:01 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: robert.w.love@intel.com, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

Use kfree_skb instead of kfree for struct sk_buff pointers.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index e419f48..41f592f 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -439,7 +439,7 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 	if (skb_is_nonlinear(skb)) {
 		skb_frag_t *frag;
 		if (fcoe_get_paged_crc_eof(skb, tlen)) {
-			kfree(skb);
+			kfree_skb(skb);
 			return -ENOMEM;
 		}
 		frag = &skb_shinfo(skb)->frags[skb_shinfo(skb)->nr_frags - 1];

From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] replace skb_clone with skb_get in fcoe_start_io()
Date: Sun, 17 Oct 2010 20:08:06 +0800
Message-ID: <AANLkTimWO2r=KX522JD6iQxxgjpX9XJ5-0CzeqJXv63b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36052 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab0JQMIJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Oct 2010 08:08:09 -0400
Received: by wyb28 with SMTP id 28so2185664wyb.19
        for <linux-scsi@vger.kernel.org>; Sun, 17 Oct 2010 05:08:08 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org

There seems that skb_get could outlight skb_clone, if
retransmitting skb is the major concern.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/fcoe/fcoe.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/fcoe/fcoe.c	2010-10-17 20:03:08.000000000 +0800
@@ -1373,15 +1373,14 @@ err2:
  */
 static inline int fcoe_start_io(struct sk_buff *skb)
 {
-	struct sk_buff *nskb;
 	int rc;

-	nskb = skb_clone(skb, GFP_ATOMIC);
-	rc = dev_queue_xmit(nskb);
-	if (rc != 0)
+	skb_get(skb); /* bump ref count for retransmitting */
+	rc = dev_queue_xmit(skb);
+	if (rc != NET_XMIT_SUCCESS)
 		return rc;
 	kfree_skb(skb);
-	return 0;
+	return NET_XMIT_SUCCESS;
 }

 /**

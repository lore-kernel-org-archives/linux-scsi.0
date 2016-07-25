From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] fcoe: Use kfree_skb() instead of kfree()
Date: Mon, 25 Jul 2016 07:00:33 +0000
Message-ID: <1469430033-8422-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33904 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbcGYHAp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jul 2016 03:00:45 -0400
Received: by mail-pf0-f194.google.com with SMTP id g202so11436176pfb.1
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2016 00:00:44 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jth@kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org

Use kfree_skb() instead of kfree() to free sk_buff.

Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index a569c65..dcf3653 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2923,7 +2923,7 @@ static int fcoe_ctlr_vlan_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	mutex_unlock(&fip->ctlr_mutex);
 
 drop:
-	kfree(skb);
+	kfree_skb(skb);
 	return rc;
 }
 




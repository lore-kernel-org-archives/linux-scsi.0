From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 24/30] fcoe: Use kfree_skb() instead of kfree()
Date: Fri, 26 Aug 2016 14:01:47 +0200
Message-ID: <1472212913-39810-25-git-send-email-hare@suse.de>
References: <1472212913-39810-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35133 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752313AbcHZMCN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 08:02:13 -0400
In-Reply-To: <1472212913-39810-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Martin Wilck <martin.wilck@suse.com>, Wei Yongjun <weiyj.lk@gmail.com>

From: Wei Yongjun <weiyj.lk@gmail.com>

Use kfree_skb() instead of kfree() to free sk_buff.

Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>
Reviewed-by: Johannes Thumshirn <jth@kernel.org>
---
 drivers/scsi/fcoe/fcoe_ctlr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 5eacd33..1dd8a7c 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2934,7 +2934,7 @@ static int fcoe_ctlr_vlan_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	mutex_unlock(&fip->ctlr_mutex);
 
 drop:
-	kfree(skb);
+	kfree_skb(skb);
 	return rc;
 }
 
-- 
1.8.5.6


From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] fcoe: use kfree_skb() to free an skb
Date: Thu, 4 Aug 2016 08:27:56 +0300
Message-ID: <20160804052756.GH775@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36312 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbcHDF2O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2016 01:28:14 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jth@kernel.org>, Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

This should be doing kfree_skb() instead of kfree().

Fixes: 9a6cf881df02 ('fcoe: implement FIP VLAN responder')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

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
 

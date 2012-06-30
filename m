From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] bnx2i: use strlcpy() instead of memcpy() for strings
Date: Sat, 30 Jun 2012 14:49:35 +0300
Message-ID: <20120630114935.GB22767@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:38029 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab2F3Ltv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Jun 2012 07:49:51 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Barak Witkowski <barak@broadcom.com>
Cc: Eddie Wai <eddie.wai@broadcom.com>, Michael Chan <mchan@broadcom.com>, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>

DRV_MODULE_VERSION here is "2.7.2.2" which is only 8 chars but we copy
12 bytes from the stack so it's a small information leak.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This was just added to linux-next yesterday, but I'm not sure which tree
it came from.

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 7729a52..b17637a 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -400,7 +400,7 @@ int bnx2i_get_stats(void *handle)
 	if (!stats)
 		return -ENOMEM;
 
-	memcpy(stats->version, DRV_MODULE_VERSION, sizeof(stats->version));
+	strlcpy(stats->version, DRV_MODULE_VERSION, sizeof(stats->version));
 	memcpy(stats->mac_add1 + 2, hba->cnic->mac_addr, ETH_ALEN);
 
 	stats->max_frame_size = hba->netdev->mtu;

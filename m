From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 2/2] iscsi_ibft: Always display netmask
Date: Fri, 22 Jan 2016 11:49:13 -0800
Message-ID: <71c84546d99332f77d1f462d735ec1e38aa1e7ba.1453419653.git.lduncan@suse.com>
References: <cover.1453419653.git.lduncan@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429AbcAVTvc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jan 2016 14:51:32 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 1CFF2ACA7
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jan 2016 19:51:30 +0000 (UTC)
In-Reply-To: <cover.1453419653.git.lduncan@suse.com>
In-Reply-To: <cover.1453419653.git.lduncan@suse.com>
References: <cover.1453419653.git.lduncan@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hare@suse.de, Lee Duncan <lduncan@suse.com>

From: Hannes Reinecke <hare@suse.de>

Some older user-space code might rely on the netmask attribute
being present, so we should always display it.
This fixes a regression introduced by commit
0b2eb3c4060a16f3ec11a4d6d4c934e7e5d5334f.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/firmware/iscsi_ibft.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
index 2dd1fbb8cccc..81037e5fe301 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -464,14 +464,8 @@ static umode_t ibft_check_nic_for(void *data, int type)
 			rc = S_IRUGO;
 		break;
 	case ISCSI_BOOT_ETH_PREFIX_LEN:
-		if (nic->subnet_mask_prefix)
-			rc = S_IRUGO;
-		break;
 	case ISCSI_BOOT_ETH_SUBNET_MASK:
-		if (!memcmp(nic->ip_addr, nulls, 10) &&
-		    (nic->ip_addr[10] == 0xff) &&
-		    (nic->ip_addr[11] == 0xff) &&
-		    nic->subnet_mask_prefix)
+		if (nic->subnet_mask_prefix)
 			rc = S_IRUGO;
 		break;
 	case ISCSI_BOOT_ETH_ORIGIN:
-- 
1.8.5.2


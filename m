From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] sd: don't use the ALL_TG_PT bit for reservations
Date: Fri,  8 Jul 2016 21:23:50 +0900
Message-ID: <1467980631-18945-2-git-send-email-hch@lst.de>
References: <1467980631-18945-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51999 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786AbcGHMYF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2016 08:24:05 -0400
In-Reply-To: <1467980631-18945-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: linux-block@vger.kernel.org

These only work if the we use the same initiator ID for all path,
which might not be true if we use different protocols, or even just
different HBAs.

Instead dm-mpath will grow support to register all path manually
later in this series.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 60bff78..42b4d05 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1613,8 +1613,7 @@ static int sd_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
 		return -EOPNOTSUPP;
 	return sd_pr_command(bdev, (flags & PR_FL_IGNORE_KEY) ? 0x06 : 0x00,
 			old_key, new_key, 0,
-			(1 << 0) /* APTPL */ |
-			(1 << 2) /* ALL_TG_PT */);
+			(1 << 0) /* APTPL */);
 }
 
 static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
-- 
2.1.4


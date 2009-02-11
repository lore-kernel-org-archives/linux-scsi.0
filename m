From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/2] sg: use ALIGN macro
Date: Thu, 12 Feb 2009 02:42:57 +0900
Message-ID: <1234374177-6192-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1234374177-6192-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:51137 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884AbZBKRnm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2009 12:43:42 -0500
In-Reply-To: <1234374177-6192-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dgilbert@interlog.com, fujita.tomonori@lab.ntt.co.jp

This changes sg_build_indirect() to use ALIGN macro instead of
calculating by hand.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index d17d89b..b459864 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -98,7 +98,6 @@ static int scatter_elem_sz = SG_SCATTER_SZ;
 static int scatter_elem_sz_prev = SG_SCATTER_SZ;
 
 #define SG_SECTOR_SZ 512
-#define SG_SECTOR_MSK (SG_SECTOR_SZ - 1)
 
 static int sg_add(struct device *, struct class_interface *);
 static void sg_remove(struct device *, struct class_interface *);
@@ -1723,8 +1722,8 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 		return -EFAULT;
 	if (0 == blk_size)
 		++blk_size;	/* don't know why */
-/* round request up to next highest SG_SECTOR_SZ byte boundary */
-	blk_size = (blk_size + SG_SECTOR_MSK) & (~SG_SECTOR_MSK);
+	/* round request up to next highest SG_SECTOR_SZ byte boundary */
+	blk_size = ALIGN(blk_size, SG_SECTOR_SZ);
 	SCSI_LOG_TIMEOUT(4, printk("sg_build_indirect: buff_size=%d, blk_size=%d\n",
 				   buff_size, blk_size));
 
-- 
1.6.0.6


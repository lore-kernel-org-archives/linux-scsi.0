From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/8] buffer: make invalidate_bdev() drain all percpu LRU add caches
Date: Sat, 15 May 2010 20:09:27 +0200
Message-ID: <1273946974-29131-2-git-send-email-tj@kernel.org>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:40256 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845Ab0EOSKO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 May 2010 14:10:14 -0400
In-Reply-To: <1273946974-29131-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, ben@decadent.org.uk, davem@daveml
Cc: Tejun Heo <tj@kernel.org>

invalidate_bdev() should release all page cache pages which are clean
and not being used; however, if some pages are still in the percpu LRU
add caches on other cpus, those pages are considered in used and don't
get released.  Fix it by calling lru_add_drain_all() before trying to
invalidate pages.

This problem was discovered while testing block automatic native
capacity unlocking.  Null pages which were read before automatic
unlocking didn't get released by invalidate_bdev() and ended up
interfering with partition scan after unlocking.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/buffer.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index c9c266d..08e422d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -275,6 +275,7 @@ void invalidate_bdev(struct block_device *bdev)
 		return;
 
 	invalidate_bh_lrus();
+	lru_add_drain_all();	/* make sure all lru add caches are flushed */
 	invalidate_mapping_pages(mapping, 0, -1);
 }
 EXPORT_SYMBOL(invalidate_bdev);
-- 
1.6.4.2


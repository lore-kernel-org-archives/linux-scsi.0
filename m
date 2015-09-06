From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 4/6] Update soc driver to use new ida helper functions
Date: Sun,  6 Sep 2015 10:59:32 -0700
Message-ID: <5cae960d268ffac76392f887c2efe03a92364261.1441416572.git.lduncan@suse.com>
References: <cover.1441416571.git.lduncan@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46816 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbbIFR7p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Sep 2015 13:59:45 -0400
In-Reply-To: <cover.1441416571.git.lduncan@suse.com>
In-Reply-To: <cover.1441416571.git.lduncan@suse.com>
References: <cover.1441416571.git.lduncan@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, hare@suse.com, jthumshirn@suse.de, JBottomley@Parallels.com, Lee Duncan <lduncan@suse.com>

This simplifies the calling sequence to
acquire and to release an ida-managed index.

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/block/mtip32xx/mtip32xx.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 4a2ef09e6704..ccff4119b554 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3821,15 +3821,7 @@ static int mtip_block_initialize(struct driver_data *dd)
 	}
 
 	/* Generate the disk name, implemented same as in sd.c */
-	do {
-		if (!ida_pre_get(&rssd_index_ida, GFP_KERNEL))
-			goto ida_get_error;
-
-		spin_lock(&rssd_index_lock);
-		rv = ida_get_new(&rssd_index_ida, &index);
-		spin_unlock(&rssd_index_lock);
-	} while (rv == -EAGAIN);
-
+	rv = ida_get_index(&rssd_index_ida, &rssd_index_lock, &index);
 	if (rv)
 		goto ida_get_error;
 
@@ -3981,9 +3973,7 @@ init_hw_cmds_error:
 block_queue_alloc_init_error:
 	mtip_hw_debugfs_exit(dd);
 disk_index_error:
-	spin_lock(&rssd_index_lock);
-	ida_remove(&rssd_index_ida, index);
-	spin_unlock(&rssd_index_lock);
+	ida_put_index(&rssd_index_ida, &rssd_index_lock, index);
 
 ida_get_error:
 	put_disk(dd->disk);
@@ -4051,9 +4041,7 @@ static int mtip_block_remove(struct driver_data *dd)
 	}
 	dd->disk  = NULL;
 
-	spin_lock(&rssd_index_lock);
-	ida_remove(&rssd_index_ida, dd->index);
-	spin_unlock(&rssd_index_lock);
+	ida_put_index(&rssd_index_ida, &rssd_index_lock, dd->index);
 
 	/* De-initialize the protocol layer. */
 	mtip_hw_exit(dd);
@@ -4092,9 +4080,7 @@ static int mtip_block_shutdown(struct driver_data *dd)
 		dd->queue = NULL;
 	}
 
-	spin_lock(&rssd_index_lock);
-	ida_remove(&rssd_index_ida, dd->index);
-	spin_unlock(&rssd_index_lock);
+	ida_put_index(&rssd_index_ida, &rssd_index_lock, dd->index);
 	return 0;
 }
 
-- 
2.1.4


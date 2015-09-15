From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 16/17] Update the Micron PCIe SSD driver to use ida helper functions.
Date: Tue, 15 Sep 2015 09:46:16 -0700
Message-ID: <cf60d82bf8a4f7e8ed92fda68638176dae188efc.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>, Lee Duncan <lduncan@suse.com>
List-Id: linux-scsi@vger.kernel.org

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

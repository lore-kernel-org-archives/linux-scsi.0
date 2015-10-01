From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 4/5] block: mtip32xx: simplify ida usage
Date: Thu,  1 Oct 2015 11:59:08 -0700
Message-ID: <64f964663b1a35ff2352dc3cea76baaae03a2d13.1443723136.git.lduncan@suse.com>
References: <cover.1443723136.git.lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1443723136.git.lduncan@suse.com>
In-Reply-To: <cover.1443723136.git.lduncan@suse.com>
References: <cover.1443723136.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Lee Duncan <lduncan@suse.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Simplify ida index allocation and removal by
using the ida_simple_* helper functions

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/block/mtip32xx/mtip32xx.c | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 4a2ef09e6704..e62d170b0641 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -118,7 +118,6 @@ static struct dentry *dfs_device_status;
 
 static u32 cpu_use[NR_CPUS];
 
-static DEFINE_SPINLOCK(rssd_index_lock);
 static DEFINE_IDA(rssd_index_ida);
 
 static int mtip_block_initialize(struct driver_data *dd);
@@ -3821,17 +3820,10 @@ static int mtip_block_initialize(struct driver_data *dd)
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
-	if (rv)
+	rv = ida_simple_get(&rssd_index_ida, 0, 0, GFP_KERNEL);
+	if (rv < 0)
 		goto ida_get_error;
+	index = rv;
 
 	rv = rssd_disk_name_format("rssd",
 				index,
@@ -3981,9 +3973,7 @@ init_hw_cmds_error:
 block_queue_alloc_init_error:
 	mtip_hw_debugfs_exit(dd);
 disk_index_error:
-	spin_lock(&rssd_index_lock);
-	ida_remove(&rssd_index_ida, index);
-	spin_unlock(&rssd_index_lock);
+	ida_simple_remove(&rssd_index_ida, index);
 
 ida_get_error:
 	put_disk(dd->disk);
@@ -4051,9 +4041,7 @@ static int mtip_block_remove(struct driver_data *dd)
 	}
 	dd->disk  = NULL;
 
-	spin_lock(&rssd_index_lock);
-	ida_remove(&rssd_index_ida, dd->index);
-	spin_unlock(&rssd_index_lock);
+	ida_simple_remove(&rssd_index_ida, dd->index);
 
 	/* De-initialize the protocol layer. */
 	mtip_hw_exit(dd);
@@ -4092,9 +4080,7 @@ static int mtip_block_shutdown(struct driver_data *dd)
 		dd->queue = NULL;
 	}
 
-	spin_lock(&rssd_index_lock);
-	ida_remove(&rssd_index_ida, dd->index);
-	spin_unlock(&rssd_index_lock);
+	ida_simple_remove(&rssd_index_ida, dd->index);
 	return 0;
 }
 
-- 
2.1.4

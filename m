From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/8] block: kill genhd_media_change_notify()
Date: Wed,  8 Dec 2010 20:57:35 +0100
Message-ID: <1291838262-21274-2-git-send-email-tj@kernel.org>
References: <1291838262-21274-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1291838262-21274-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, jack@suse.cz, James.Bottomley@HansenPartnership.com
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

There's no user of the facility.  Kill it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c         |   25 -------------------------
 include/linux/genhd.h |    1 -
 2 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 5fa2b44..0905ab2 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1110,29 +1110,6 @@ static int __init proc_genhd_init(void)
 module_init(proc_genhd_init);
 #endif /* CONFIG_PROC_FS */
 
-static void media_change_notify_thread(struct work_struct *work)
-{
-	struct gendisk *gd = container_of(work, struct gendisk, async_notify);
-	char event[] = "MEDIA_CHANGE=1";
-	char *envp[] = { event, NULL };
-
-	/*
-	 * set enviroment vars to indicate which event this is for
-	 * so that user space will know to go check the media status.
-	 */
-	kobject_uevent_env(&disk_to_dev(gd)->kobj, KOBJ_CHANGE, envp);
-	put_device(gd->driverfs_dev);
-}
-
-#if 0
-void genhd_media_change_notify(struct gendisk *disk)
-{
-	get_device(disk->driverfs_dev);
-	schedule_work(&disk->async_notify);
-}
-EXPORT_SYMBOL_GPL(genhd_media_change_notify);
-#endif  /*  0  */
-
 dev_t blk_lookup_devt(const char *name, int partno)
 {
 	dev_t devt = MKDEV(0, 0);
@@ -1198,8 +1175,6 @@ struct gendisk *alloc_disk_node(int minors, int node_id)
 		disk_to_dev(disk)->class = &block_class;
 		disk_to_dev(disk)->type = &disk_type;
 		device_initialize(disk_to_dev(disk));
-		INIT_WORK(&disk->async_notify,
-			media_change_notify_thread);
 	}
 	return disk;
 }
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 7a7b9c1..5e4e692 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -173,7 +173,6 @@ struct gendisk {
 	struct timer_rand_state *random;
 
 	atomic_t sync_io;		/* RAID */
-	struct work_struct async_notify;
 #ifdef  CONFIG_BLK_DEV_INTEGRITY
 	struct blk_integrity *integrity;
 #endif
-- 
1.7.1

From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 04/12] target: Move subdev release logic into ->release() callback
Date: Thu,  3 Feb 2011 22:45:04 -0800
Message-ID: <1296801912-18857-5-git-send-email-nab@linux-iscsi.org>
References: <1296801912-18857-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm11.bullet.mail.ac4.yahoo.com ([98.139.52.208]:30750 "HELO
	nm11.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752549Ab1BDGpU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Feb 2011 01:45:20 -0500
In-Reply-To: <1296801912-18857-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Joel Becker <jlbec@evilplan.org>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch moves the se_free_virtual_device() / se_subsystem_api->free_device()
and subsequent release of struct se_subsystem_dev memory to inside of the
configfs callback target_core_dev_item_ops->release() called from within
fs/configfs/item.c:config_item_cleanup() context.  This patch resolves the
following SLUB 'Poison overwritten' warning when calling target_core_drop_subdev()
-> kfree(se_dev) directly after config_item_put():

[ 5147.638639] =============================================================================
[ 5147.638959] BUG kmalloc-4096: Poison overwritten
[ 5147.639124] -----------------------------------------------------------------------------
[ 5147.639124]
[ 5147.639294] INFO: 0xffff88000d2f887c-0xffff88000d2f887c. First byte 0x6a instead of 0x6b
[ 5147.639294] INFO: Allocated in kzalloc+0xf/0x11 [target_core_mod] age=2602 cpu=0 pid=14639
[ 5147.639294] INFO: Freed in target_core_drop_subdev+0x18d/0x199 [target_core_mod] age=25 cpu=0 pid=14654
[ 5147.639294] INFO: Slab 0xffffea00002e2640 objects=7 used=1 fp=0xffff88000d2f8000 flags=0x1000000000040c1
[ 5147.639294] INFO: Object 0xffff88000d2f8000 @offset=0 fp=0xffff88000d2fb0d8

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c |   64 ++++++++++++++++-----------------
 1 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 9e74aa1..a9e0c66 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2003,9 +2003,35 @@ static void target_core_dev_release(struct config_item *item)
 {
 	struct se_subsystem_dev *se_dev = container_of(to_config_group(item),
 				struct se_subsystem_dev, se_dev_group);
+	struct se_hba *hba = item_to_hba(&se_dev->se_dev_hba->hba_group.cg_item);
+	struct se_subsystem_api *t = hba->transport;
 	struct config_group *dev_cg = &se_dev->se_dev_group;
 
 	kfree(dev_cg->default_groups);
+	/*
+	 * This pointer will set when the storage is enabled with:
+	 *`echo 1 > $CONFIGFS/core/$HBA/$DEV/dev_enable`
+	 */
+	if (se_dev->se_dev_ptr) {
+		printk(KERN_INFO "Target_Core_ConfigFS: Calling se_free_"
+			"virtual_device() for se_dev_ptr: %p\n",
+			se_dev->se_dev_ptr);
+
+		se_free_virtual_device(se_dev->se_dev_ptr, hba);
+	} else {
+		/*
+		 * Release struct se_subsystem_dev->se_dev_su_ptr..
+		 */
+		printk(KERN_INFO "Target_Core_ConfigFS: Calling t->free_"
+			"device() for se_dev_su_ptr: %p\n",
+			se_dev->se_dev_su_ptr);
+
+		t->free_device(se_dev->se_dev_su_ptr);
+	}
+
+	printk(KERN_INFO "Target_Core_ConfigFS: Deallocating se_subsystem"
+			"_dev_t: %p\n", se_dev);
+	kfree(se_dev);
 }
 
 static ssize_t target_core_dev_show(struct config_item *item,
@@ -2799,13 +2825,11 @@ static void target_core_drop_subdev(
 	struct se_subsystem_api *t;
 	struct config_item *df_item;
 	struct config_group *dev_cg, *tg_pt_gp_cg;
-	int i, ret;
+	int i;
 
 	hba = item_to_hba(&se_dev->se_dev_hba->hba_group.cg_item);
 
-	if (mutex_lock_interruptible(&hba->hba_access_mutex))
-		goto out;
-
+	mutex_lock(&hba->hba_access_mutex);
 	t = hba->transport;
 
 	spin_lock(&se_global->g_device_lock);
@@ -2828,38 +2852,12 @@ static void target_core_drop_subdev(
 		dev_cg->default_groups[i] = NULL;
 		config_item_put(df_item);
 	}
-
-	config_item_put(item);
 	/*
-	 * This pointer will set when the storage is enabled with:
-	 * `echo 1 > $CONFIGFS/core/$HBA/$DEV/dev_enable`
+	 * The releasing of se_dev and associated se_dev->se_dev_ptr is done
+	 * from target_core_dev_item_ops->release() ->target_core_dev_release().
 	 */
-	if (se_dev->se_dev_ptr) {
-		printk(KERN_INFO "Target_Core_ConfigFS: Calling se_free_"
-			"virtual_device() for se_dev_ptr: %p\n",
-				se_dev->se_dev_ptr);
-
-		ret = se_free_virtual_device(se_dev->se_dev_ptr, hba);
-		if (ret < 0)
-			goto hba_out;
-	} else {
-		/*
-		 * Release struct se_subsystem_dev->se_dev_su_ptr..
-		 */
-		printk(KERN_INFO "Target_Core_ConfigFS: Calling t->free_"
-			"device() for se_dev_su_ptr: %p\n",
-			se_dev->se_dev_su_ptr);
-
-		t->free_device(se_dev->se_dev_su_ptr);
-	}
-
-	printk(KERN_INFO "Target_Core_ConfigFS: Deallocating se_subsystem"
-		"_dev_t: %p\n", se_dev);
-
-hba_out:
+	config_item_put(item);
 	mutex_unlock(&hba->hba_access_mutex);
-out:
-	kfree(se_dev);
 }
 
 static struct configfs_group_operations target_core_hba_group_ops = {
-- 
1.7.4


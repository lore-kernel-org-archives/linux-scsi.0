From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 013/103] target: Remove hba queue depth and convert to spin_lock_irq usage
Date: Thu, 21 Jul 2011 00:04:49 -0700
Message-ID: <1311231979-6631-14-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm23-vm0.bullet.mail.bf1.yahoo.com ([98.139.212.191]:43357 "HELO
	nm23-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751445Ab1GUHA1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:00:27 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Andy Grover <agrover@redhat.com>

The queue depth in the virtual hba is no longer needed, we can just
rely on the per-device queue depth limits.

Remove hba_queue_lock, since updating a single atomic no longer needs
protection.  This patch also converts se_dev->execute_task_lock usage in
__transport_execute_tasks to use execute_task_lock with spin_lock_irq

Remove load_balance_queue, unused.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c      |    7 +----
 drivers/target/target_core_file.h      |    2 -
 drivers/target/target_core_hba.c       |    4 ---
 drivers/target/target_core_iblock.c    |    7 +----
 drivers/target/target_core_iblock.h    |    1 -
 drivers/target/target_core_pscsi.c     |   22 +------------------
 drivers/target/target_core_pscsi.h     |    1 -
 drivers/target/target_core_rd.c        |    7 +----
 drivers/target/target_core_rd.h        |    2 -
 drivers/target/target_core_transport.c |   35 ++++++-------------------------
 include/target/target_core_base.h      |    5 ----
 11 files changed, 15 insertions(+), 78 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 40386ec..5ca1f5b 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -72,17 +72,14 @@ static int fd_attach_hba(struct se_hba *hba, u32 host_id)
 
 	fd_host->fd_host_id = host_id;
 
-	atomic_set(&hba->left_queue_depth, FD_HBA_QUEUE_DEPTH);
-	atomic_set(&hba->max_queue_depth, FD_HBA_QUEUE_DEPTH);
 	hba->hba_ptr = (void *) fd_host;
 
 	printk(KERN_INFO "CORE_HBA[%d] - TCM FILEIO HBA Driver %s on Generic"
 		" Target Core Stack %s\n", hba->hba_id, FD_VERSION,
 		TARGET_CORE_MOD_VERSION);
 	printk(KERN_INFO "CORE_HBA[%d] - Attached FILEIO HBA: %u to Generic"
-		" Target Core with TCQ Depth: %d MaxSectors: %u\n",
-		hba->hba_id, fd_host->fd_host_id,
-		atomic_read(&hba->max_queue_depth), FD_MAX_SECTORS);
+		" MaxSectors: %u\n",
+		hba->hba_id, fd_host->fd_host_id, FD_MAX_SECTORS);
 
 	return 0;
 }
diff --git a/drivers/target/target_core_file.h b/drivers/target/target_core_file.h
index ef4de2b..6386d3f 100644
--- a/drivers/target/target_core_file.h
+++ b/drivers/target/target_core_file.h
@@ -4,8 +4,6 @@
 #define FD_VERSION		"4.0"
 
 #define FD_MAX_DEV_NAME		256
-/* Maximum queuedepth for the FILEIO HBA */
-#define FD_HBA_QUEUE_DEPTH	256
 #define FD_DEVICE_QUEUE_DEPTH	32
 #define FD_MAX_DEVICE_QUEUE_DEPTH 128
 #define FD_BLOCKSIZE		512
diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index ddf5ae0..8f3a0c4 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -110,15 +110,11 @@ core_alloc_hba(const char *plugin_name, u32 plugin_dep_id, u32 hba_flags)
 
 	INIT_LIST_HEAD(&hba->hba_dev_list);
 	spin_lock_init(&hba->device_lock);
-	spin_lock_init(&hba->hba_queue_lock);
 	mutex_init(&hba->hba_access_mutex);
 
 	hba->hba_index = scsi_get_new_index(SCSI_INST_INDEX);
 	hba->hba_flags |= hba_flags;
 
-	atomic_set(&hba->max_queue_depth, 0);
-	atomic_set(&hba->left_queue_depth, 0);
-
 	hba->transport = core_get_backend(plugin_name);
 	if (!hba->transport) {
 		ret = -EINVAL;
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 5d5bd6e..5bd4f1c 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -74,17 +74,14 @@ static int iblock_attach_hba(struct se_hba *hba, u32 host_id)
 
 	ib_host->iblock_host_id = host_id;
 
-	atomic_set(&hba->left_queue_depth, IBLOCK_HBA_QUEUE_DEPTH);
-	atomic_set(&hba->max_queue_depth, IBLOCK_HBA_QUEUE_DEPTH);
 	hba->hba_ptr = (void *) ib_host;
 
 	printk(KERN_INFO "CORE_HBA[%d] - TCM iBlock HBA Driver %s on"
 		" Generic Target Core Stack %s\n", hba->hba_id,
 		IBLOCK_VERSION, TARGET_CORE_MOD_VERSION);
 
-	printk(KERN_INFO "CORE_HBA[%d] - Attached iBlock HBA: %u to Generic"
-		" Target Core TCQ Depth: %d\n", hba->hba_id,
-		ib_host->iblock_host_id, atomic_read(&hba->max_queue_depth));
+	printk(KERN_INFO "CORE_HBA[%d] - Attached iBlock HBA: %u to Generic\n",
+		hba->hba_id, ib_host->iblock_host_id);
 
 	return 0;
 }
diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
index 64c1f4d..6b6d17b 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -3,7 +3,6 @@
 
 #define IBLOCK_VERSION		"4.0"
 
-#define IBLOCK_HBA_QUEUE_DEPTH	512
 #define IBLOCK_DEVICE_QUEUE_DEPTH	32
 #define IBLOCK_MAX_DEVICE_QUEUE_DEPTH	128
 #define IBLOCK_MAX_CDBS		16
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index d39226f..e221dea 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -62,7 +62,6 @@ static void pscsi_req_done(struct request *, int);
  */
 static int pscsi_attach_hba(struct se_hba *hba, u32 host_id)
 {
-	int hba_depth;
 	struct pscsi_hba_virt *phv;
 
 	phv = kzalloc(sizeof(struct pscsi_hba_virt), GFP_KERNEL);
@@ -72,18 +71,14 @@ static int pscsi_attach_hba(struct se_hba *hba, u32 host_id)
 	}
 	phv->phv_host_id = host_id;
 	phv->phv_mode = PHV_VIRUTAL_HOST_ID;
-	hba_depth = PSCSI_VIRTUAL_HBA_DEPTH;
-	atomic_set(&hba->left_queue_depth, hba_depth);
-	atomic_set(&hba->max_queue_depth, hba_depth);
 
 	hba->hba_ptr = (void *)phv;
 
 	printk(KERN_INFO "CORE_HBA[%d] - TCM SCSI HBA Driver %s on"
 		" Generic Target Core Stack %s\n", hba->hba_id,
 		PSCSI_VERSION, TARGET_CORE_MOD_VERSION);
-	printk(KERN_INFO "CORE_HBA[%d] - Attached SCSI HBA to Generic"
-		" Target Core with TCQ Depth: %d\n", hba->hba_id,
-		atomic_read(&hba->max_queue_depth));
+	printk(KERN_INFO "CORE_HBA[%d] - Attached SCSI HBA to Generic\n",
+	       hba->hba_id);
 
 	return 0;
 }
@@ -112,7 +107,6 @@ static int pscsi_pmode_enable_hba(struct se_hba *hba, unsigned long mode_flag)
 {
 	struct pscsi_hba_virt *phv = (struct pscsi_hba_virt *)hba->hba_ptr;
 	struct Scsi_Host *sh = phv->phv_lld_host;
-	int hba_depth = PSCSI_VIRTUAL_HBA_DEPTH;
 	/*
 	 * Release the struct Scsi_Host
 	 */
@@ -122,8 +116,6 @@ static int pscsi_pmode_enable_hba(struct se_hba *hba, unsigned long mode_flag)
 
 		phv->phv_lld_host = NULL;
 		phv->phv_mode = PHV_VIRUTAL_HOST_ID;
-		atomic_set(&hba->left_queue_depth, hba_depth);
-		atomic_set(&hba->max_queue_depth, hba_depth);
 
 		printk(KERN_INFO "CORE_HBA[%d] - Disabled pSCSI HBA Passthrough"
 			" %s\n", hba->hba_id, (sh->hostt->name) ?
@@ -142,16 +134,6 @@ static int pscsi_pmode_enable_hba(struct se_hba *hba, unsigned long mode_flag)
 			" phv_host_id: %d\n", phv->phv_host_id);
 		return PTR_ERR(sh);
 	}
-	/*
-	 * Usually the SCSI LLD will use the hostt->can_queue value to define
-	 * its HBA TCQ depth.  Some other drivers (like 2.6 megaraid) don't set
-	 * this at all and set sh->can_queue at runtime.
-	 */
-	hba_depth = (sh->hostt->can_queue > sh->can_queue) ?
-		sh->hostt->can_queue : sh->can_queue;
-
-	atomic_set(&hba->left_queue_depth, hba_depth);
-	atomic_set(&hba->max_queue_depth, hba_depth);
 
 	phv->phv_lld_host = sh;
 	phv->phv_mode = PHV_LLD_SCSI_HOST_NO;
diff --git a/drivers/target/target_core_pscsi.h b/drivers/target/target_core_pscsi.h
index a4cd5d3..280b689 100644
--- a/drivers/target/target_core_pscsi.h
+++ b/drivers/target/target_core_pscsi.h
@@ -2,7 +2,6 @@
 #define TARGET_CORE_PSCSI_H
 
 #define PSCSI_VERSION		"v4.0"
-#define PSCSI_VIRTUAL_HBA_DEPTH	2048
 
 /* used in pscsi_find_alloc_len() */
 #ifndef INQUIRY_DATA_SIZE
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 2a00f70..0a424bb 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -66,17 +66,14 @@ static int rd_attach_hba(struct se_hba *hba, u32 host_id)
 
 	rd_host->rd_host_id = host_id;
 
-	atomic_set(&hba->left_queue_depth, RD_HBA_QUEUE_DEPTH);
-	atomic_set(&hba->max_queue_depth, RD_HBA_QUEUE_DEPTH);
 	hba->hba_ptr = (void *) rd_host;
 
 	printk(KERN_INFO "CORE_HBA[%d] - TCM Ramdisk HBA Driver %s on"
 		" Generic Target Core Stack %s\n", hba->hba_id,
 		RD_HBA_VERSION, TARGET_CORE_MOD_VERSION);
 	printk(KERN_INFO "CORE_HBA[%d] - Attached Ramdisk HBA: %u to Generic"
-		" Target Core TCQ Depth: %d MaxSectors: %u\n", hba->hba_id,
-		rd_host->rd_host_id, atomic_read(&hba->max_queue_depth),
-		RD_MAX_SECTORS);
+		" MaxSectors: %u\n", hba->hba_id,
+		rd_host->rd_host_id, RD_MAX_SECTORS);
 
 	return 0;
 }
diff --git a/drivers/target/target_core_rd.h b/drivers/target/target_core_rd.h
index 3ea19e2..bab9302 100644
--- a/drivers/target/target_core_rd.h
+++ b/drivers/target/target_core_rd.h
@@ -7,8 +7,6 @@
 
 /* Largest piece of memory kmalloc can allocate */
 #define RD_MAX_ALLOCATION_SIZE	65536
-/* Maximum queuedepth for the Ramdisk HBA */
-#define RD_HBA_QUEUE_DEPTH	256
 #define RD_DEVICE_QUEUE_DEPTH	32
 #define RD_MAX_DEVICE_QUEUE_DEPTH 128
 #define RD_BLOCKSIZE		512
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 99b9e33..ae153bf 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -959,12 +959,8 @@ void transport_complete_task(struct se_task *task, int success)
 	printk(KERN_INFO "task: %p CDB: 0x%02x obj_ptr: %p\n", task,
 			T_TASK(cmd)->t_task_cdb[0], dev);
 #endif
-	if (dev) {
-		spin_lock_irqsave(&SE_HBA(dev)->hba_queue_lock, flags);
+	if (dev)
 		atomic_inc(&dev->depth_left);
-		atomic_inc(&SE_HBA(dev)->left_queue_depth);
-		spin_unlock_irqrestore(&SE_HBA(dev)->hba_queue_lock, flags);
-	}
 
 	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
 	atomic_set(&task->task_active, 0);
@@ -2140,16 +2136,6 @@ static int transport_stop_tasks_for_cmd(struct se_cmd *cmd)
 	return ret;
 }
 
-static void transport_failure_reset_queue_depth(struct se_device *dev)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&SE_HBA(dev)->hba_queue_lock, flags);
-	atomic_inc(&dev->depth_left);
-	atomic_inc(&SE_HBA(dev)->left_queue_depth);
-	spin_unlock_irqrestore(&SE_HBA(dev)->hba_queue_lock, flags);
-}
-
 /*
  * Handle SAM-esque emulation for generic transport request failures.
  */
@@ -2181,7 +2167,7 @@ static void transport_generic_request_failure(
 	transport_stop_all_task_timers(cmd);
 
 	if (dev)
-		transport_failure_reset_queue_depth(dev);
+		atomic_inc(&dev->depth_left);
 	/*
 	 * For SAM Task Attribute emulation for failed struct se_cmd
 	 */
@@ -2650,26 +2636,19 @@ static int __transport_execute_tasks(struct se_device *dev)
 	 * struct se_transport_task's to the selected transport.
 	 */
 check_depth:
-	spin_lock_irqsave(&SE_HBA(dev)->hba_queue_lock, flags);
-	if (!(atomic_read(&dev->depth_left)) ||
-	    !(atomic_read(&SE_HBA(dev)->left_queue_depth))) {
-		spin_unlock_irqrestore(&SE_HBA(dev)->hba_queue_lock, flags);
+	if (!atomic_read(&dev->depth_left))
 		return transport_tcq_window_closed(dev);
-	}
+
 	dev->dev_tcq_window_closed = 0;
 
-	spin_lock(&dev->execute_task_lock);
+	spin_lock_irq(&dev->execute_task_lock);
 	task = transport_get_task_from_execute_queue(dev);
-	spin_unlock(&dev->execute_task_lock);
+	spin_unlock_irq(&dev->execute_task_lock);
 
-	if (!task) {
-		spin_unlock_irqrestore(&SE_HBA(dev)->hba_queue_lock, flags);
+	if (!task)
 		return 0;
-	}
 
 	atomic_dec(&dev->depth_left);
-	atomic_dec(&SE_HBA(dev)->left_queue_depth);
-	spin_unlock_irqrestore(&SE_HBA(dev)->hba_queue_lock, flags);
 
 	cmd = TASK_CMD(task);
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 561ac99..e35e9e4 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -837,17 +837,12 @@ struct se_hba {
 	/* Virtual iSCSI devices attached. */
 	u32			dev_count;
 	u32			hba_index;
-	atomic_t		load_balance_queue;
-	atomic_t		left_queue_depth;
-	/* Maximum queue depth the HBA can handle. */
-	atomic_t		max_queue_depth;
 	/* Pointer to transport specific host structure. */
 	void			*hba_ptr;
 	/* Linked list for struct se_device */
 	struct list_head	hba_dev_list;
 	struct list_head	hba_list;
 	spinlock_t		device_lock;
-	spinlock_t		hba_queue_lock;
 	struct config_group	hba_group;
 	struct mutex		hba_access_mutex;
 	struct se_subsystem_api *transport;
-- 
1.7.6


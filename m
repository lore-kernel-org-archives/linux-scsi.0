From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] scsi-misc-2.5 user per-device spare command
Date: Thu, 24 Apr 2003 10:03:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030424100317.A32134@beaverton.ibm.com>
References: <20030424100229.A32098@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-99-218-173.dsl.aracnet.com ([216.99.218.173]:2543 "EHLO
	dyn9-47-17-132.beaverton.ibm.com") by vger.kernel.org with ESMTP
	id S263408AbTDXQyx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2003 12:54:53 -0400
Content-Disposition: inline
In-Reply-To: <20030424100229.A32098@beaverton.ibm.com>; from patmans@us.ibm.com on Thu, Apr 24, 2003 at 10:02:29AM -0700
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Patch against scsi-misc-2.5

Use a per-device spare command rather than a per-host spare.

Use the sdev->sdev_lock (or queue_lock) to protect use of the spare
command rather than the free_list_lock.

diff -purN -X /home/patman/dontdiff rmcmd_lock-2.5-cur/drivers/scsi/hosts.h rmhost_flock-2.5-cur/drivers/scsi/hosts.h
--- rmcmd_lock-2.5-cur/drivers/scsi/hosts.h	Sat Apr 12 16:25:38 2003
+++ rmhost_flock-2.5-cur/drivers/scsi/hosts.h	Thu Apr 24 09:14:47 2003
@@ -378,8 +378,6 @@ struct Scsi_Host
     struct list_head	  my_devices;
 
     struct scsi_host_cmd_pool *cmd_pool;
-    spinlock_t            free_list_lock;
-    struct list_head      free_list;   /* backup store of cmd structs */
     struct list_head      starved_list;
 
     spinlock_t		  default_lock;
diff -purN -X /home/patman/dontdiff rmcmd_lock-2.5-cur/drivers/scsi/scsi.c rmhost_flock-2.5-cur/drivers/scsi/scsi.c
--- rmcmd_lock-2.5-cur/drivers/scsi/scsi.c	Thu Apr 24 09:14:04 2003
+++ rmhost_flock-2.5-cur/drivers/scsi/scsi.c	Thu Apr 24 09:14:47 2003
@@ -254,26 +254,20 @@ static struct scsi_host_cmd_pool scsi_cm
 
 static DECLARE_MUTEX(host_cmd_pool_mutex);
 
-static struct scsi_cmnd *scsi_alloc_cmd(struct Scsi_Host *shost,
+static struct scsi_cmnd *scsi_alloc_cmd(struct scsi_device *sdev,
 					    int gfp_mask)
 {
 	struct scsi_cmnd *cmd;
 
-	cmd = kmem_cache_alloc(shost->cmd_pool->slab,
-			gfp_mask | shost->cmd_pool->gfp_mask);
-
-	if (unlikely(!cmd)) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&shost->free_list_lock, flags);
-		if (likely(!list_empty(&shost->free_list))) {
-			cmd = list_entry(shost->free_list.next,
-					 struct scsi_cmnd, list);
-			list_del_init(&cmd->list);
-		}
-		spin_unlock_irqrestore(&shost->free_list_lock, flags);
-	}
-
+	/*
+	 * Use any spare command first.
+	 */
+	cmd = sdev->spare_cmd;
+	if (cmd != NULL)
+		sdev->spare_cmd = NULL;
+	else 
+		cmd = kmem_cache_alloc(sdev->host->cmd_pool->slab,
+				gfp_mask | sdev->host->cmd_pool->gfp_mask);
 	return cmd;
 }
 
@@ -292,7 +286,7 @@ static struct scsi_cmnd *scsi_alloc_cmd(
  */
 struct scsi_cmnd *__scsi_get_command(struct scsi_device *dev, int gfp_mask)
 {
-	struct scsi_cmnd *cmd = scsi_alloc_cmd(dev->host, gfp_mask);
+	struct scsi_cmnd *cmd = scsi_alloc_cmd(dev, gfp_mask);
 
 	if (likely(cmd != NULL)) {
 		memset(cmd, 0, sizeof(*cmd));
@@ -347,21 +341,13 @@ struct scsi_cmnd *scsi_get_command(struc
  */
 void __scsi_put_command(struct scsi_cmnd *cmd)
 {
-	struct Scsi_Host *shost = cmd->device->host;
-	unsigned long flags;
-	
 	/* serious error if the command hasn't come from a device list */
 	BUG_ON(list_empty(&cmd->list));
-	list_del_init(&cmd->list);
-	spin_lock_irqsave(&shost->free_list_lock, flags);
-	if (unlikely(list_empty(&shost->free_list))) {
-		list_add(&cmd->list, &shost->free_list);
-		cmd = NULL;
-	}
-	spin_unlock_irqrestore(&shost->free_list_lock, flags);
-
-	if (likely(cmd != NULL))
-		kmem_cache_free(shost->cmd_pool->slab, cmd);
+	list_del(&cmd->list);
+	if (!cmd->device->spare_cmd)
+		cmd->device->spare_cmd = cmd;
+	else
+		kmem_cache_free(cmd->device->host->cmd_pool->slab, cmd);
 }
 
 /*
@@ -384,6 +370,41 @@ void scsi_put_command(struct scsi_cmnd *
 }
 
 /*
+ * Function:	scsi_setup_sdev_spare_command()
+ *
+ * Purpose:	Setup the spare commands for a scsi_device
+ *
+ * Arguments:	sdev - host to allocate spares for
+ *
+ * Returns:	0 if no error, else -ENOMEM.
+ */
+int scsi_setup_sdev_spare_command(struct scsi_device *sdev)
+{
+	sdev->spare_cmd = kmem_cache_alloc(sdev->host->cmd_pool->slab,
+			       GFP_KERNEL | sdev->host->cmd_pool->gfp_mask);
+	if (sdev->spare_cmd)
+		return 0;
+	else
+		return -ENOMEM;
+}
+
+/*
+ * Function:	scsi_destroy_sdev_spare_command()
+ *
+ * Purpose:	destroy the spare commands for a scsi_device
+ *
+ * Arguments:	sdev - host to free spares from
+ *
+ * Returns:	0 if no error, else -ENOMEM.
+ */
+void scsi_destroy_sdev_spare_command(struct scsi_device *sdev)
+{
+	if (sdev->spare_cmd)
+		kmem_cache_free(sdev->host->cmd_pool->slab, sdev->spare_cmd);
+	sdev->spare_cmd = NULL;
+}
+
+/*
  * Function:	scsi_setup_command_freelist()
  *
  * Purpose:	Setup the command freelist for a scsi host.
@@ -395,10 +416,6 @@ void scsi_put_command(struct scsi_cmnd *
 int scsi_setup_command_freelist(struct Scsi_Host *shost)
 {
 	struct scsi_host_cmd_pool *pool;
-	struct scsi_cmnd *cmd;
-
-	spin_lock_init(&shost->free_list_lock);
-	INIT_LIST_HEAD(&shost->free_list);
 
 	/*
 	 * Select a command slab for this host and create it if not
@@ -413,25 +430,11 @@ int scsi_setup_command_freelist(struct S
 		if (!pool->slab)
 			goto fail;
 	}
-
 	pool->users++;
 	shost->cmd_pool = pool;
 	up(&host_cmd_pool_mutex);
-
-	/*
-	 * Get one backup command for this host.
-	 */
-	cmd = kmem_cache_alloc(shost->cmd_pool->slab,
-			GFP_KERNEL | shost->cmd_pool->gfp_mask);
-	if (!cmd)
-		goto fail2;
-	list_add(&cmd->list, &shost->free_list);		
 	return 0;
 
- fail2:
-	if (!--pool->users)
-		kmem_cache_destroy(pool->slab);
-	return -ENOMEM;
  fail:
 	up(&host_cmd_pool_mutex);
 	return -ENOMEM;
@@ -447,14 +450,6 @@ int scsi_setup_command_freelist(struct S
  */
 void scsi_destroy_command_freelist(struct Scsi_Host *shost)
 {
-	while (!list_empty(&shost->free_list)) {
-		struct scsi_cmnd *cmd;
-
-		cmd = list_entry(shost->free_list.next, struct scsi_cmnd, list);
-		list_del_init(&cmd->list);
-		kmem_cache_free(shost->cmd_pool->slab, cmd);
-	}
-
 	down(&host_cmd_pool_mutex);
 	if (!--shost->cmd_pool->users)
 		kmem_cache_destroy(shost->cmd_pool->slab);
diff -purN -X /home/patman/dontdiff rmcmd_lock-2.5-cur/drivers/scsi/scsi.h rmhost_flock-2.5-cur/drivers/scsi/scsi.h
--- rmcmd_lock-2.5-cur/drivers/scsi/scsi.h	Thu Apr 24 09:14:04 2003
+++ rmhost_flock-2.5-cur/drivers/scsi/scsi.h	Thu Apr 24 09:14:47 2003
@@ -411,6 +411,8 @@ extern void scsi_exit_queue(void);
  * Prototypes for functions in scsi.c
  */
 extern int scsi_dispatch_cmd(Scsi_Cmnd * SCpnt);
+extern int scsi_setup_sdev_spare_command(struct scsi_device *sdev);
+extern void scsi_destroy_sdev_spare_command(struct scsi_device *sdev);
 extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
 extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
 extern struct scsi_cmnd *__scsi_get_command(struct scsi_device *dev, int flags);
@@ -550,6 +552,7 @@ struct scsi_device {
 	spinlock_t sdev_lock;           /* also the request queue_lock */
 	struct list_head cmd_list;	/* queue of in use SCSI Command structures */
 	struct list_head starved_entry;
+	struct scsi_cmnd *spare_cmd;
         Scsi_Cmnd *current_cmnd;	/* currently active command */
 	unsigned short queue_depth;	/* How deep of a queue we want */
 	unsigned short last_queue_full_depth; /* These two are used by */
diff -purN -X /home/patman/dontdiff rmcmd_lock-2.5-cur/drivers/scsi/scsi_scan.c rmhost_flock-2.5-cur/drivers/scsi/scsi_scan.c
--- rmcmd_lock-2.5-cur/drivers/scsi/scsi_scan.c	Thu Apr 24 09:14:04 2003
+++ rmhost_flock-2.5-cur/drivers/scsi/scsi_scan.c	Thu Apr 24 09:14:47 2003
@@ -422,9 +422,13 @@ static struct scsi_device *scsi_alloc_sd
 	sdev->borken = 1;
 
 	spin_lock_init(&sdev->sdev_lock);
+
+	if (scsi_setup_sdev_spare_command(sdev))
+		goto out_free_dev;
+
 	sdev->request_queue = scsi_alloc_queue(sdev);
 	if (!sdev->request_queue)
-		goto out_free_dev;
+		goto out_free_cmd;
 
 	sdev->request_queue->queuedata = sdev;
 	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
@@ -465,6 +469,8 @@ static struct scsi_device *scsi_alloc_sd
 
 out_free_queue:
 	scsi_free_queue(sdev->request_queue);
+out_free_cmd:
+	scsi_destroy_sdev_spare_command(sdev);
 out_free_dev:
 	kfree(sdev);
 out:
@@ -487,6 +493,7 @@ static void scsi_free_sdev(struct scsi_d
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
 
+	scsi_destroy_sdev_spare_command(sdev);
 	if (sdev->request_queue)
 		scsi_free_queue(sdev->request_queue);
 	if (sdev->host->hostt->slave_destroy)

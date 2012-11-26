From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 0/7 v5] More device removal fixes
Date: Mon, 26 Nov 2012 18:19:51 +0100
Message-ID: <50B3A4B7.5050801@acm.org>
References: <508A7B63.60608@acm.org> <50AF5206.9060608@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:57419 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934229Ab2KZRTz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Nov 2012 12:19:55 -0500
In-Reply-To: <50AF5206.9060608@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

On 11/23/12 11:37, Bart Van Assche wrote:
> On 10/26/12 14:00, Bart Van Assche wrote:
>> Fix a few race conditions that can be triggered by removing a device:
>> [ ... ]
> 
> I'd like to add the patch below to this series. [ ... ]

Below is another patch (hopefully the last) that I'd like to add to
this series. Note: the reason that I only ran into this issue now is
because I only started testing very recently with an ib_srp version
with the host state check removed from srp_queuecommand().

[PATCH] Make scsi_remove_host() wait for device removal

SCSI LLDs may start cleaning up host resources needed by their
queuecommand() callback as soon as scsi_remove_host() finished.
Hence scsi_remove_host() must wait until blk_cleanup_queue() for
all devices associated with the host has finished.

This patch fixes the following kernel oops:

BUG: spinlock bad magic on CPU#0, multipathd/20128
 lock: 0xffff8801b32e8bc8, .magic: ffff8801, .owner: <none>/-1, .owner_cpu: -1556759232
Pid: 20128, comm: multipathd Not tainted 3.7.0-rc7-debug+ #1
Call Trace:
 [<ffffffff8141206f>] spin_dump+0x8c/0x91
 [<ffffffff81412095>] spin_bug+0x21/0x26
 [<ffffffff81218a6f>] do_raw_spin_lock+0x13f/0x150
 [<ffffffff81417b38>] _raw_spin_lock_irqsave+0x78/0xa0
 [<ffffffffa0293c6c>] srp_queuecommand+0x3c/0xc80 [ib_srp]
 [<ffffffffa0002f18>] scsi_dispatch_cmd+0x148/0x310 [scsi_mod]
 [<ffffffffa000a080>] scsi_request_fn+0x320/0x520 [scsi_mod]
 [<ffffffff811ec397>] __blk_run_queue+0x37/0x50
 [<ffffffff811ec3ee>] queue_unplugged+0x3e/0xd0
 [<ffffffff811eef33>] blk_flush_plug_list+0x1c3/0x240
 [<ffffffff811eefc8>] blk_finish_plug+0x18/0x50
 [<ffffffff8119661e>] do_io_submit+0x29e/0xa00
 [<ffffffff81196d90>] sys_io_submit+0x10/0x20
 [<ffffffff81420d82>] system_call_fastpath+0x16/0x1b
---
 drivers/scsi/hosts.c      |   16 ++++++++++++++++
 drivers/scsi/scsi_priv.h  |    2 +-
 drivers/scsi/scsi_scan.c  |    5 ++++-
 drivers/scsi/scsi_sysfs.c |   15 ++++++++++++---
 include/scsi/scsi_host.h  |    1 +
 5 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 593085a..7b6b0b2 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -150,6 +150,19 @@ int scsi_host_set_state(struct Scsi_Host *shost, enum scsi_host_state state)
 }
 EXPORT_SYMBOL(scsi_host_set_state);
 
+static bool scsi_device_list_empty(struct Scsi_Host *shost)
+{
+	bool res;
+
+	WARN_ON_ONCE(irqs_disabled());
+
+	spin_lock_irq(shost->host_lock);
+	res = list_empty(&shost->__devices);
+	spin_unlock_irq(shost->host_lock);
+
+	return res;
+}
+
 /**
  * scsi_remove_host - remove a scsi host
  * @shost:	a pointer to a scsi host to remove
@@ -178,6 +191,8 @@ void scsi_remove_host(struct Scsi_Host *shost)
 		BUG_ON(scsi_host_set_state(shost, SHOST_DEL_RECOVERY));
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
+	wait_event(shost->device_list_empty, scsi_device_list_empty(shost));
+
 	transport_unregister_device(&shost->shost_gendev);
 	device_unregister(&shost->shost_dev);
 	device_del(&shost->shost_gendev);
@@ -351,6 +366,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->shost_state = SHOST_CREATED;
 	INIT_LIST_HEAD(&shost->__devices);
 	INIT_LIST_HEAD(&shost->__targets);
+	init_waitqueue_head(&shost->device_list_empty);
 	INIT_LIST_HEAD(&shost->eh_cmd_q);
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 8f9a0ca..86250fb 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -130,7 +130,7 @@ extern int scsi_sysfs_add_sdev(struct scsi_device *);
 extern int scsi_sysfs_add_host(struct Scsi_Host *);
 extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);
-extern void scsi_sysfs_device_initialize(struct scsi_device *);
+extern int scsi_sysfs_device_initialize(struct scsi_device *);
 extern int scsi_sysfs_target_initialize(struct scsi_device *);
 extern struct scsi_transport_template blank_transport_template;
 extern void __scsi_remove_device(struct scsi_device *);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3e58b22..ddea318 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -289,7 +289,10 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	sdev->request_queue->queuedata = sdev;
 	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 
-	scsi_sysfs_device_initialize(sdev);
+	if (scsi_sysfs_device_initialize(sdev)) {
+		display_failure_msg = 0;
+		goto out_device_destroy;
+	}
 
 	if (shost->hostt->slave_alloc) {
 		ret = shost->hostt->slave_alloc(sdev);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 2661a957..760fc85 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -348,6 +348,8 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	starget->reap_ref++;
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
+	if (list_empty(&sdev->host->__devices))
+		wake_up(&sdev->host->device_list_empty);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
 	cancel_work_sync(&sdev->event_work);
@@ -1109,11 +1111,12 @@ static struct device_type scsi_dev_type = {
 	.groups =	scsi_sdev_attr_groups,
 };
 
-void scsi_sysfs_device_initialize(struct scsi_device *sdev)
+int scsi_sysfs_device_initialize(struct scsi_device *sdev)
 {
 	unsigned long flags;
 	struct Scsi_Host *shost = sdev->host;
 	struct scsi_target  *starget = sdev->sdev_target;
+	int ret = -ENODEV;
 
 	device_initialize(&sdev->sdev_gendev);
 	sdev->sdev_gendev.bus = &scsi_bus_type;
@@ -1128,10 +1131,16 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 	sdev->scsi_level = starget->scsi_level;
 	transport_setup_device(&sdev->sdev_gendev);
+
 	spin_lock_irqsave(shost->host_lock, flags);
-	list_add_tail(&sdev->same_target_siblings, &starget->devices);
-	list_add_tail(&sdev->siblings, &shost->__devices);
+	if (scsi_host_scan_allowed(shost)) {
+		list_add_tail(&sdev->same_target_siblings, &starget->devices);
+		list_add_tail(&sdev->siblings, &shost->__devices);
+		ret = 0;
+	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	return ret;
 }
 
 int scsi_is_sdev_device(const struct device *dev)
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 4908480..4ad2d9f 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -561,6 +561,7 @@ struct Scsi_Host {
 	 */
 	struct list_head	__devices;
 	struct list_head	__targets;
+	wait_queue_head_t	device_list_empty;
 	
 	struct scsi_host_cmd_pool *cmd_pool;
 	spinlock_t		free_list_lock;
-- 
1.7.10.4




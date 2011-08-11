From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [BUG] Oops when SCSI device under multipath is removed
Date: Thu, 11 Aug 2011 12:01:05 +0900
Message-ID: <4E4345F1.9040501@ce.jp.nec.com>
References: <4E420941.3080601@ce.jp.nec.com> <1313005933.2785.12.camel@mulgrave> <4E432122.9050101@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E432122.9050101@ce.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: jaxboe@fusionio.com, roland@purestorage.com, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

Hi James,

On 08/11/11 09:24, Jun'ichi Nomura wrote:
> On 08/11/11 04:52, James Bottomley wrote:
>> On Wed, 2011-08-10 at 13:29 +0900, Jun'ichi Nomura wrote:
>>>   2) SCSI to call blk_cleanup_queue() from device's ->release() callback
>>>      (before 2.6.39, it used to work like this)
>>>      https://lkml.org/lkml/2011/7/2/106
>>
>> Well, they both have documented objections.  I asked why we destroy the
>> elevator in the del case and didn't get any traction, so let me show the
>> actual patch which should fix all of these issues.
>>
>> Is there a good reason for not doing this as a bug fix now?
...
> I think it doesn't work because elevator_exit() and
> blk_throtl_exit() take &q->queue_lock, which may be freed
> by LLD after blk_cleanup_queue, before blk_release_queue.

If the reason you moved scsi_free_queue into scsi_remove_device
is marking the queue dead, how about the following patch?
Do you think it's acceptable?

Jun'ichi Nomura, NEC Corporation


Add blk_kill_queue() for drivers which want to mark the queue dead early.

blk_cleanup_queue() is an interface for LLD to notify block layer
that LLD no longer needs the queue.
Since q->queue_lock may point to a structure in LLD which is freed
after blk_cleanup_queue, blk_cleanup_queue() frees subordinate structures
like elevator, which uses q->queue_lock, to avoid invalid reference.

OTOH, LLD like SCSI wants to just mark the queue dead earlier in tear
down phase.

So this patch factors out the early part of blk_cleanup_queue into
blk_kill_queue for such drivers.

--- linux-3.1-rc1/include/linux/blkdev.h.orig	2011-08-11 11:19:52.585280223 +0900
+++ linux-3.1-rc1/include/linux/blkdev.h	2011-08-11 11:20:09.482279763 +0900
@@ -804,6 +804,7 @@ extern struct request_queue *blk_init_al
 extern struct request_queue *blk_init_queue(request_fn_proc *, spinlock_t *);
 extern struct request_queue *blk_init_allocated_queue(struct request_queue *,
 						      request_fn_proc *, spinlock_t *);
+extern void blk_kill_queue(struct request_queue *);
 extern void blk_cleanup_queue(struct request_queue *);
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
--- linux-3.1-rc1/block/blk-core.c.orig	2011-08-10 09:46:06.014043123 +0900
+++ linux-3.1-rc1/block/blk-core.c	2011-08-11 11:19:34.551280697 +0900
@@ -347,6 +347,17 @@ void blk_put_queue(struct request_queue 
 }
 EXPORT_SYMBOL(blk_put_queue);
 
+void blk_kill_queue(struct request_queue *q)
+{
+	blk_sync_queue(q);
+
+	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
+	mutex_lock(&q->sysfs_lock);
+	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
+	mutex_unlock(&q->sysfs_lock);
+}
+EXPORT_SYMBOL(blk_kill_queue);
+
 /*
  * Note: If a driver supplied the queue lock, it should not zap that lock
  * unexpectedly as some queue cleanup components like elevator_exit() and
@@ -360,12 +371,7 @@ void blk_cleanup_queue(struct request_qu
 	 * are done before moving on. Going into this function, we should
 	 * not have processes doing IO to this device.
 	 */
-	blk_sync_queue(q);
-
-	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
-	mutex_lock(&q->sysfs_lock);
-	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
-	mutex_unlock(&q->sysfs_lock);
+	blk_kill_queue(q);
 
 	if (q->elevator)
 		elevator_exit(q->elevator);
--- linux-3.1-rc1/drivers/scsi/scsi_sysfs.c.orig	2011-08-09 18:48:13.676485115 +0900
+++ linux-3.1-rc1/drivers/scsi/scsi_sysfs.c	2011-08-11 11:21:07.923277456 +0900
@@ -322,6 +322,7 @@ static void scsi_device_dev_release_user
 		kfree(evt);
 	}
 
+	scsi_free_queue(sdev->request_queue);
 	blk_put_queue(sdev->request_queue);
 	/* NULL queue means the device can't be used */
 	sdev->request_queue = NULL;
@@ -937,7 +938,7 @@ void __scsi_remove_device(struct scsi_de
 	sdev->request_queue->queuedata = NULL;
 
 	/* Freeing the queue signals to block that we're done */
-	scsi_free_queue(sdev->request_queue);
+	blk_kill_queue(sdev->request_queue);
 	put_device(dev);
 }
 

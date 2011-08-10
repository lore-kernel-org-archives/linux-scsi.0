From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG] Oops when SCSI device under multipath is removed
Date: Wed, 10 Aug 2011 14:52:13 -0500
Message-ID: <1313005933.2785.12.camel@mulgrave>
References: <4E420941.3080601@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E420941.3080601@ce.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: jaxboe@fusionio.com, roland@purestorage.com, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-08-10 at 13:29 +0900, Jun'ichi Nomura wrote:
> Hi James,
> 
> With the attached shell script, blk_insert_cloned_request will cause
> oops with 3.1-rc1. (This is a regression introduced in 2.6.39)
> 
> The regression was introduced by 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b,
> "[SCSI] put stricter guards on queue dead checks".
> Part of the commit has moved scsi_free_queue(), which calls
> blk_cleanup_queue(), to scsi_remove_device(), which is called while
> the device is still open.
> The oops occurs because blk_insert_cloned_request() is called
> after blk_cleanup_queue() is called (which frees elevator
> and turns on QUEUE_FLAG_DEAD).
> 
> 2 patches have been proposed but neither of them included:
>   1) Add QUEUE_FLAG_DEAD check in blk_insert_cloned_request()
>      https://lkml.org/lkml/2011/7/8/457
>   2) SCSI to call blk_cleanup_queue() from device's ->release() callback
>      (before 2.6.39, it used to work like this)
>      https://lkml.org/lkml/2011/7/2/106

Well, they both have documented objections.  I asked why we destroy the
elevator in the del case and didn't get any traction, so let me show the
actual patch which should fix all of these issues.

Is there a good reason for not doing this as a bug fix now?

James

---
diff --git a/block/blk-core.c b/block/blk-core.c
index b627558..cc72b7d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -367,11 +367,6 @@ void blk_cleanup_queue(struct request_queue *q)
 	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
 	mutex_unlock(&q->sysfs_lock);
 
-	if (q->elevator)
-		elevator_exit(q->elevator);
-
-	blk_throtl_exit(q);
-
 	blk_put_queue(q);
 }
 EXPORT_SYMBOL(blk_cleanup_queue);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 0ee17b5..a5a756b 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -477,6 +477,11 @@ static void blk_release_queue(struct kobject *kobj)
 
 	blk_sync_queue(q);
 
+	if (q->elevator)
+		elevator_exit(q->elevator);
+
+	blk_throtl_exit(q);
+
 	if (rl->rq_pool)
 		mempool_destroy(rl->rq_pool);
 

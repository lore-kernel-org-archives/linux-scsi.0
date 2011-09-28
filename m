From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue resources
 at blk_release_queue())
Date: Wed, 28 Sep 2011 08:14:42 -0600
Message-ID: <4E832BD2.50409@kernel.dk>
References: <201109221318.p8MDIXPP020015@pentland.suse.de>  <20110928004722.GA27421@kernel.dk>  <CA+55aFznvejXWe68BpjsJqCWnDizbHWBOzKLY_H+YqhRiK42sQ@mail.gmail.com>  <4E82751C.9050908@kernel.dk>  <CA+55aFyL76hD7o_839G7tKa0y6dFRcK-kC+g_h_coEp=Qk23pw@mail.gmail.com>  <1317183038.17578.9.camel@dabdike.hansenpartnership.com>  <4E832A55.30709@kernel.dk> <1317219074.19034.4.camel@dabdike.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1317219074.19034.4.camel@dabdike.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2011-09-28 08:11, James Bottomley wrote:
> On Wed, 2011-09-28 at 08:08 -0600, Jens Axboe wrote:
>> On 2011-09-27 22:10, James Bottomley wrote:
>>> On Tue, 2011-09-27 at 18:59 -0700, Linus Torvalds wrote:
>>>> On Tue, Sep 27, 2011 at 6:15 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>
>>>>>> But if you forward the actual patch to me (the one I see on lkml seems
>>>>>> to be broken and doesn't compile cleanly because it's assiging a
>>>>>> structure to a pointer), I'll try it out anyway.
>>>>>
>>>>> Thanks, that would be great. It's inlined below.
>>>>
>>>> Well, I did several USB eject events, and nothing bad happened.
>>>>
>>>> But as mentioned, I don't think that means much. Have you tried this
>>>> with slub debugging and poisoning? It might be worth some extra
>>>> testing that way.
>>>
>>> I've been testing a simpler version:
>>>
>>> http://marc.info/?l=linux-kernel&m=131300594629839
>>>
>>> For a long time now with great success.  The only difference is the
>>> locking cleanup, but SCSI doesn't need that since it doesn't supply its
>>> own lock, so I've been voting for this as the final fix for a while now.
>>
>> The locking cleanup looks good, though, for devices that do use the
>> embedded lock.
> 
> Exactly ... it's the missing piece; without it my patch is really only
> addressing SCSI.
> 
>>  But functionally they should be the same for SCSI, so if
>> you had great success with it, then that's a good data point.
> 
> Right, I've run it through the memory debugger and USB ejection testing
> (with ext2, which seems to be the fs that triggers this problem the
> most).

Alright, lets call this fully tested and fixed then. Linus, I committed
it, please pull:

  git://git.kernel.dk/linux-block.git for-linus

Hannes Reinecke (1):
      block: Free queue resources at blk_release_queue()

 block/blk-core.c  |   13 ++++++-------
 block/blk-sysfs.c |    5 +++++
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index b2ed78a..d34433a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -348,9 +348,10 @@ void blk_put_queue(struct request_queue *q)
 EXPORT_SYMBOL(blk_put_queue);
 
 /*
- * Note: If a driver supplied the queue lock, it should not zap that lock
- * unexpectedly as some queue cleanup components like elevator_exit() and
- * blk_throtl_exit() need queue lock.
+ * Note: If a driver supplied the queue lock, it is disconnected
+ * by this function. The actual state of the lock doesn't matter
+ * here as the request_queue isn't accessible after this point
+ * (QUEUE_FLAG_DEAD is set) and no other requests will be queued.
  */
 void blk_cleanup_queue(struct request_queue *q)
 {
@@ -367,10 +368,8 @@ void blk_cleanup_queue(struct request_queue *q)
 	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
 	mutex_unlock(&q->sysfs_lock);
 
-	if (q->elevator)
-		elevator_exit(q->elevator);
-
-	blk_throtl_exit(q);
+	if (q->queue_lock != &q->__queue_lock)
+		q->queue_lock = &q->__queue_lock;
 
 	blk_put_queue(q);
 }
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index e681805..60fda88 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -479,6 +479,11 @@ static void blk_release_queue(struct kobject *kobj)
 
 	blk_sync_queue(q);
 
+	if (q->elevator)
+		elevator_exit(q->elevator);
+
+	blk_throtl_exit(q);
+
 	if (rl->rq_pool)
 		mempool_destroy(rl->rq_pool);
 


-- 
Jens Axboe

From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [Bug 25832] kernel crashes when a mounted ext3/4 file system
 is physically removed
Date: Tue, 20 Sep 2011 16:32:52 +0900
Message-ID: <4E7841A4.8040104@ce.jp.nec.com>
References: <BAY151-W32DCB4BAFEC97DD4913A12A1090@phx.gbl>	 <Pine.LNX.4.44L0.1109171330360.18455-100000@netrider.rowland.org> <1316386825.14749.207.camel@deadeye>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:55511 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab1ITHeD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Sep 2011 03:34:03 -0400
In-Reply-To: <1316386825.14749.207.camel@deadeye>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>, jaxboe@fusionio.com
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Rocko Requin <rockorequin@hotmail.com>, tytso@mit.edu, Kernel development list <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 09/19/11 08:00, Ben Hutchings wrote:
> On Sat, 2011-09-17 at 13:34 -0400, Alan Stern wrote:
>> On Sat, 17 Sep 2011, Rocko Requin wrote:
>>
>>>> Why were you using gnome-terminal?  You should be running the tests at
>>>> a console VT, not under X at all.  Ctrl-Alt-F2 or the equivalent...
>>>
>>> Because with Ted's patch it doesn't crash when run from a console VT, even with an X server running.
>>
>> That's weird.  Maybe the screen updates change some timing.
>>
>>>> Here's another patch to address the new problem.  You can apply it on 
>>>> top of all the other patches.
>>>
>>> Attached is the crash log I get with the latest patch applied.
>>
>> Okay, more fallout from the same problem.  Here's an updated version of 
>> the previous patch.
> [...]
> 
> There have been reports of this in Debian going back to 2.6.39:
> 
> http://bugs.debian.org/631187
> http://bugs.debian.org/636263
> http://bugs.debian.org/642043
> 
> Plus possibly related crashes in elv_put_request after CD-ROM removal:
> 
> http://bugs.debian.org/633890
> http://bugs.debian.org/634681
> http://bugs.debian.org/636103
> 
> The former was also reported in Ubuntu since their 2.6.38-10:
> 
> https://bugs.launchpad.net/debian/+source/linux-2.6/+bug/793796
> 
> The result of the discussion there was that it appeared to be a
> regression due to commit 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b 
> ("[SCSI] put stricter guards on queue dead checks") which was also
> included in a stable update for 2.6.38.
> 
> There was also a report on bugzilla.kernel.org, though no-one can see
> quite what that says now:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=38842
> 
> I also reported most of the above to James Bottomley and linux-scsi
> nearly 2 months ago, to no response.

I've reported a similar oops related to the above commit:
  [BUG] Oops when SCSI device under multipath is removed
  https://lkml.org/lkml/2011/8/10/11

Elevator being removed is the core of the problem.
And the essential issue seems 2 different models of queue/driver relation
implied by queue_lock.

If reverting the commit is not an option,
until somebody comes up to fix the essential issue,
the patch below should close the regressions introduced by the commit.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation


This patch moves elevator_exit() and blk_throtl_exit() from
blk_cleanup_queue() to blk_release_queue() when it is possible.

elevator_exit() and blk_throtl_exit() were called in blk_cleanup_queue()
because they use queue_lock.

There are 2 types of queue_locks:
  a) supplied by driver (via blk_init_queue)
  b) embedded in struct request_queue (__queue_lock)

When queue_lock is supplied by driver, there is no guarantee that
the pointer is valid after blk_cleanup_queue(), so they have to be
called in blk_cleanup_queue().
In this case, the driver has to make sure nobody is using the queue
before calling blk_cleanup_queue().

However, OTOH, if queue_lock is '__queue_lock' in request_queue,
blk_release_queue() is better place for freeing structures
because the block layer knows for sure there is no reference.

This patch is ugly but should fix various oopses introduced by this change:
  86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b
  [SCSI] put stricter guards on queue dead checks

For example:
  https://lkml.org/lkml/2011/8/10/11

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

Index: linux-3.1-rc4/block/blk-core.c
===================================================================
--- linux-3.1-rc4.orig/block/blk-core.c	2011-08-29 13:16:01.000000000 +0900
+++ linux-3.1-rc4/block/blk-core.c	2011-09-20 15:53:23.496814819 +0900
@@ -352,6 +352,14 @@
  * unexpectedly as some queue cleanup components like elevator_exit() and
  * blk_throtl_exit() need queue lock.
  */
+void blk_release_queue_components_with_queuelock(struct request_queue *q)
+{
+	if (q->elevator)
+		elevator_exit(q->elevator);
+
+	blk_throtl_exit(q);
+}
+
 void blk_cleanup_queue(struct request_queue *q)
 {
 	/*
@@ -367,10 +375,12 @@
 	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
 	mutex_unlock(&q->sysfs_lock);
 
-	if (q->elevator)
-		elevator_exit(q->elevator);
-
-	blk_throtl_exit(q);
+	/*
+	 * A driver supplied the queue lock.
+	 * Cleanup components while the queue lock is valid.
+	 */
+	if (q->queue_lock != &q->__queue_lock)
+		blk_release_queue_components_with_queuelock(q);
 
 	blk_put_queue(q);
 }
Index: linux-3.1-rc4/block/blk-sysfs.c
===================================================================
--- linux-3.1-rc4.orig/block/blk-sysfs.c	2011-09-19 09:38:51.000000000 +0900
+++ linux-3.1-rc4/block/blk-sysfs.c	2011-09-20 15:57:50.358807023 +0900
@@ -477,6 +477,9 @@
 
 	blk_sync_queue(q);
 
+	if (q->queue_lock == &q->__queue_lock)
+		blk_release_queue_components_with_queuelock(q);
+
 	if (rl->rq_pool)
 		mempool_destroy(rl->rq_pool);
 
Index: linux-3.1-rc4/block/blk.h
===================================================================
--- linux-3.1-rc4.orig/block/blk.h	2011-08-29 13:16:01.000000000 +0900
+++ linux-3.1-rc4/block/blk.h	2011-09-20 15:57:38.306807136 +0900
@@ -25,6 +25,9 @@
 void blk_add_timer(struct request *);
 void __generic_unplug_device(struct request_queue *);
 
+/* Wrapper to release functions to be called while queue_lock is valid */
+void blk_release_queue_components_with_queuelock(struct request_queue *q);
+
 /*
  * Internal atomic flags for request handling
  */

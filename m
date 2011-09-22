From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Thu, 22 Sep 2011 11:16:30 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1109221113380.2137-100000@iolanthe.rowland.org>
References: <4E7B296D.8020900@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E7B296D.8020900@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Rocko Requin <rockorequin@hotmail.com>
Cc: Hannes Reinecke <hare@suse.de>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Ben Hutchings <ben@decadent.org.uk>, jaxboe@fusionio.com, James Bottomley <James.Bottomley@HansenPartnership.com>, tytso@mit.edu, Kernel development list <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Rocko:

Can you try testing this patch instead of all the patches I sent to 
you (but keep Ted's patch)?

Alan Stern

On Thu, 22 Sep 2011, Hannes Reinecke wrote:

> On 09/20/2011 09:32 AM, Jun'ichi Nomura wrote:
> > On 09/19/11 08:00, Ben Hutchings wrote:
> [ .. ]
> >>
> >> There have been reports of this in Debian going back to 2.6.39:
> >>
> >> http://bugs.debian.org/631187
> >> http://bugs.debian.org/636263
> >> http://bugs.debian.org/642043
> >>
> >> Plus possibly related crashes in elv_put_request after CD-ROM removal:
> >>
> >> http://bugs.debian.org/633890
> >> http://bugs.debian.org/634681
> >> http://bugs.debian.org/636103
> >>
> >> The former was also reported in Ubuntu since their 2.6.38-10:
> >>
> >> https://bugs.launchpad.net/debian/+source/linux-2.6/+bug/793796
> >>
> >> The result of the discussion there was that it appeared to be a
> >> regression due to commit 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b 
> >> ("[SCSI] put stricter guards on queue dead checks") which was also
> >> included in a stable update for 2.6.38.
> >>
> >> There was also a report on bugzilla.kernel.org, though no-one can see
> >> quite what that says now:
> >>
> >> https://bugzilla.kernel.org/show_bug.cgi?id=38842
> >>
> >> I also reported most of the above to James Bottomley and linux-scsi
> >> nearly 2 months ago, to no response.
> > 
> > I've reported a similar oops related to the above commit:
> >   [BUG] Oops when SCSI device under multipath is removed
> >   https://lkml.org/lkml/2011/8/10/11
> > 
> > Elevator being removed is the core of the problem.
> > And the essential issue seems 2 different models of queue/driver relation
> > implied by queue_lock.
> > 
> > If reverting the commit is not an option,
> > until somebody comes up to fix the essential issue,
> > the patch below should close the regressions introduced by the commit.
> > 
> Why do you have to do it that complicated?
> Couldn't we just state that any external lock is being disconnected from
> queue_lock after blk_cleanup_queue()?
> 
> Then something like this should suffice here:



diff --git a/block/blk-core.c b/block/blk-core.c
index 90e1ffd..a4ac005 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -367,10 +367,8 @@ void blk_cleanup_queue(struct request_queue *q)
        queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
        mutex_unlock(&q->sysfs_lock);

-       if (q->elevator)
-               elevator_exit(q->elevator);
-
-       blk_throtl_exit(q);
+       if (q->queue_lock != q->__queue_lock)
+               q->queue_lock = q->__queue_lock;

        blk_put_queue(q);
 }
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 0ee17b5..a5a756b 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -477,6 +477,11 @@ static void blk_release_queue(struct kobject *kobj)

        blk_sync_queue(q);

+       if (q->elevator)
+               elevator_exit(q->elevator);
+
+       blk_throtl_exit(q);
+
        if (rl->rq_pool)
                mempool_destroy(rl->rq_pool);
 

> And yeah, I find it pretty annoying, too.
> 
> Cheers,
> 
> Hannes
> 

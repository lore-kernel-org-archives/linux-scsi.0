From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: blk-tag.c: 89 BUG() triggering + initial analysis
Date: Fri, 13 Dec 2013 12:32:36 -0800
Message-ID: <1386966756.2055.68.camel@dabdike.int.hansenpartnership.com>
References: <5284AF58.5070901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53235 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752696Ab3LMUcj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 15:32:39 -0500
In-Reply-To: <5284AF58.5070901@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Sarah Sharp <sarah.a.sharp@linux.intel.com>

On Thu, 2013-11-14 at 12:09 +0100, Hans de Goede wrote:
> Hi All,
> 
> I hope linux-scsi is the right list for this, if not let me know.
> 
> I've been working on getting the uas (Usb Attached Scsi) driver into
> working shape for the last 3 weeks, so that it can be enabled in 3.14 .
> 
> My latest tests where performed on top of 3.11 + a bunch of xhci and
> of course uas fixes.
> 
> I can reliable trigger the BUG() in blk-tag.c line 89:
> 
> void blk_free_tags(struct blk_queue_tag *bqt)
> {
>          if (unlikely(!__blk_free_tags(bqt)))
>                  BUG();
> }
> 
> I believe this is not an uas driver bug, but rather a bug which
> any scsi host which uses scsi_init_shared_tag_map() can trigger,
> which is likely not seen before because almost no hosts actually
> use scsi_init_shared_tag_map().

Um, well, no, stex, qla4xxx and fnic do.  Of those, I think fnic and
qla4xxx have quite large install bases.

> The above test triggering the BUG() assumes that blk_free_tags()
> caller holds the last reference to the bqt. For scsi hosts using
> scsi_init_shared_tag_map() this assumes that the release of the
> block_queue through blk-sysfs.c: blk_release_queue() happens before
> the release of the host through scsi/hosts.c: scsi_host_dev_release()

The devices all hold parent references to the host.  The last action of
a device release is a put on its parent (this is after the last put of
the device queue).  The host release function shouldn't be called until
every device has released its reference ... unless something has gone
wrong with the device model, of course.

> I've added some strategic debug printk-s to debug this problem
> (and removed the BUG()) and in some cases this is not true.
> 
> Here is the output of my debug scripts on a normal unplug of
> the uas usb-device:
> 
> [ 7678.202540] blk-sysfs.c: blk_release_queue queue_tags ffff88022d4d59e0
> [ 7678.202551] blk-tag.c: __blk_queue_free_tags bqt ffff88022d4d59e0
> [ 7678.202553] blk-tag.c: __blk_free_tags refcnt before dec: 2
> [ 7678.202626] scsi/hosts.c: scsi_host_dev_release bqt ffff88022d4d59e0
> [ 7678.202654] blk-tag.c: blk_free_tags bqt ffff88022d4d59e0
> [ 7678.202655] blk-tag.c: __blk_free_tags refcnt before dec: 1
> [ 7678.202657] blk-tag.c: __blk_free_tags free-ed: ffff88022d4d59e0
> 
> Which does not trigger the BUG().
> 
> If however I do the following:
> 1) plug in uas usb-device
> 2) let udisks auto-mount it under:
>     /run/media/hans/4e82585c-3c40-48ac-81ad-11d2a7bad0fc
> 3) cd into that dir to keep it busy
> 4) unplug
> 5) cd out of the directory, at which points udisks will umount it
> 
> 
> Then with an unpatched kernel I hit the BUG() at step 5, and with
> a kernel with the BUG() removed I get the following debug trace:
> 
> [ 9089.808021] scsi/hosts.c: scsi_host_dev_release bqt ffff88022c02ae40
> [ 9089.808040] blk-tag.c: blk_free_tags bqt ffff88022c02ae40
> [ 9089.808041] blk-tag.c: __blk_free_tags refcnt before dec: 2
> [ 9089.808046] blk-sysfs.c: blk_release_queue queue_tags ffff88022c02ae40
> [ 9089.808057] blk-tag.c: __blk_queue_free_tags bqt ffff88022c02ae40
> [ 9089.808058] blk-tag.c: __blk_free_tags refcnt before dec: 1
> [ 9089.808059] blk-tag.c: __blk_free_tags free-ed: ffff88022c02ae40
> 
> Notice how in this case scsi_host_dev_release() runs before
> blk_release_queue(), breaking the assumption the BUG() tests for.
> 
> I think this may be caused by userspace holding a reference to the
> kobj which has blk_release_queue as release callback when doing the
> umount. But I simply don't know the code in question well enough to do
> a more detailed analysis of the problem.
> 
> A naive fix, which seems to work, would be to simply remove the BUG()
> but I'm not sure if that is the right solution...

So this looks like an induced failure caused by the filesystem holding a
queue reference which you force by holding the directory, meaning that
the blk_queue_put in the sdev release function isn't the last put.  The
fix for this is probably to release the tags once the queue is dead and
can accept no I/O.  That would be this, does that fix it?

This isn't the whole fix, we can likely now remove the queue free from
last put as well ... I'm just not sure if there's any block devices that
don't call blk_cleanup_queue, which keeping it in would catch.

James

---

diff --git a/block/blk-core.c b/block/blk-core.c
index 8bdd012..03c0bf9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -506,6 +506,8 @@ void blk_cleanup_queue(struct request_queue *q)
 	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
 	blk_sync_queue(q);
 
+	__blk_queue_free_tags(q);
+
 	spin_lock_irq(lock);
 	if (q->queue_lock != &q->__queue_lock)
 		q->queue_lock = &q->__queue_lock;



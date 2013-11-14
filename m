From: Hans de Goede <hdegoede@redhat.com>
Subject: blk-tag.c: 89 BUG() triggering + initial analysis
Date: Thu, 14 Nov 2013 12:09:12 +0100
Message-ID: <5284AF58.5070901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928Ab3KNLJZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Nov 2013 06:09:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>

Hi All,

I hope linux-scsi is the right list for this, if not let me know.

I've been working on getting the uas (Usb Attached Scsi) driver into
working shape for the last 3 weeks, so that it can be enabled in 3.14 .

My latest tests where performed on top of 3.11 + a bunch of xhci and
of course uas fixes.

I can reliable trigger the BUG() in blk-tag.c line 89:

void blk_free_tags(struct blk_queue_tag *bqt)
{
         if (unlikely(!__blk_free_tags(bqt)))
                 BUG();
}

I believe this is not an uas driver bug, but rather a bug which
any scsi host which uses scsi_init_shared_tag_map() can trigger,
which is likely not seen before because almost no hosts actually
use scsi_init_shared_tag_map().

The above test triggering the BUG() assumes that blk_free_tags()
caller holds the last reference to the bqt. For scsi hosts using
scsi_init_shared_tag_map() this assumes that the release of the
block_queue through blk-sysfs.c: blk_release_queue() happens before
the release of the host through scsi/hosts.c: scsi_host_dev_release()

I've added some strategic debug printk-s to debug this problem
(and removed the BUG()) and in some cases this is not true.

Here is the output of my debug scripts on a normal unplug of
the uas usb-device:

[ 7678.202540] blk-sysfs.c: blk_release_queue queue_tags ffff88022d4d59e0
[ 7678.202551] blk-tag.c: __blk_queue_free_tags bqt ffff88022d4d59e0
[ 7678.202553] blk-tag.c: __blk_free_tags refcnt before dec: 2
[ 7678.202626] scsi/hosts.c: scsi_host_dev_release bqt ffff88022d4d59e0
[ 7678.202654] blk-tag.c: blk_free_tags bqt ffff88022d4d59e0
[ 7678.202655] blk-tag.c: __blk_free_tags refcnt before dec: 1
[ 7678.202657] blk-tag.c: __blk_free_tags free-ed: ffff88022d4d59e0

Which does not trigger the BUG().

If however I do the following:
1) plug in uas usb-device
2) let udisks auto-mount it under:
    /run/media/hans/4e82585c-3c40-48ac-81ad-11d2a7bad0fc
3) cd into that dir to keep it busy
4) unplug
5) cd out of the directory, at which points udisks will umount it


Then with an unpatched kernel I hit the BUG() at step 5, and with
a kernel with the BUG() removed I get the following debug trace:

[ 9089.808021] scsi/hosts.c: scsi_host_dev_release bqt ffff88022c02ae40
[ 9089.808040] blk-tag.c: blk_free_tags bqt ffff88022c02ae40
[ 9089.808041] blk-tag.c: __blk_free_tags refcnt before dec: 2
[ 9089.808046] blk-sysfs.c: blk_release_queue queue_tags ffff88022c02ae40
[ 9089.808057] blk-tag.c: __blk_queue_free_tags bqt ffff88022c02ae40
[ 9089.808058] blk-tag.c: __blk_free_tags refcnt before dec: 1
[ 9089.808059] blk-tag.c: __blk_free_tags free-ed: ffff88022c02ae40

Notice how in this case scsi_host_dev_release() runs before
blk_release_queue(), breaking the assumption the BUG() tests for.

I think this may be caused by userspace holding a reference to the
kobj which has blk_release_queue as release callback when doing the
umount. But I simply don't know the code in question well enough to do
a more detailed analysis of the problem.

A naive fix, which seems to work, would be to simply remove the BUG()
but I'm not sure if that is the right solution...

Regards,

Hans


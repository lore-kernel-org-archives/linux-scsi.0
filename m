From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: open write failure not predicted by blockdev getro
Date: 14 Jul 2004 18:00:28 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1089849628.3736.48.camel@patibmrh9>
References: <1089754717.9125.11.camel@patibmrh9><20040714053638.GG3055@suse.
	de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:46755 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265872AbUGOAAa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jul 2004 20:00:30 -0400
In-Reply-To: <20040714053638.GG3055@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

> > inserting a read-only DVD disc into a USB drive, ...
> > the paradoxical contradiction:
> > ...
> > $ sudo blockdev --getro /dev/scd0
> > 0
> > $ sudo dd of=/dev/scd0 bs=64K count=1 if=/dev/zero
> > dd: opening `/dev/scd0': Read-only file system
> > $
> ...
> does interest me, ...

Excellent, hi.

> please see if you can track this problem down.

printk tells me,

We call set_disk_ro of drivers/block/genhd.c only once per device plug
in, not once per disc insert.

Logically therefore, given a mixed collection of rewritable and
read-only discs, our guessing blockdev --getro 1 at plug in will prevent
writes of rewritable discs, and our guessing blockdev --getro 0 at plug
in will allow writes of read-only discs.

We necessarily lose both ways.

Do we care?

May we say that blockdev --setrw --setro --getro is a facility for
write-protecting DVD/ CD devices, not DVD/ CD discs, and take on the job
of guessing which devices don't want blanket write protection?

Or do we learn to refresh set_disk_ro once per disc insert?

We can decide in light of the drivers/scsi/sd.c precedent.  I see there
a comment telling me we call set_disk_ro once per disc insert:

--- http://lxr.linux.no/source/drivers/scsi/sd.c?v=2.6.5#L1109
...
* read write protect setting, if possible - called only in sd_revalidate_disk()
...
---

Pat LaVarre

P.S. Newbie, me I haven't yet found the lines of cdrom.ko code we run
only once per disc insert.

The following patch ain't it, at least not yet.  dmesg tells me this
source line executes indefinitely often while I have a USB DVD disc
(specifically an Iomega RRD disc) present.  Even with PATAPI alone
connected, still it ran more often than the count of discs present.

diff -urp linux-2.6.8-rc1/drivers/cdrom/cdrom.c linux-2.6.8-rc1-pel/drivers/cdrom/cdrom.c
--- linux-2.6.8-rc1/drivers/cdrom/cdrom.c	2004-07-13 08:26:02.000000000 -0600
+++ linux-2.6.8-rc1-pel/drivers/cdrom/cdrom.c	2004-07-14 17:46:24.013859464 -0600
@@ -1297,6 +1297,7 @@ int media_changed(struct cdrom_device_in
 	    return ret;
 	/* changed since last call? */
 	if (cdi->ops->media_changed(cdi, CDSL_CURRENT)) {
+printk("PEL: could refresh set_disk_ro\n");
 		cdi->mc_flags = 0x3;    /* set bit on both queues */
 		ret |= 1;
 	}



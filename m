From: Peter Jones <pjones@redhat.com>
Subject: Re: BSG question
Date: Thu, 16 Sep 2004 11:11:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095347511.4852.38.camel@localhost.localdomain>
References: <4148FC12.1010205@torque.net> <20040916060508.GF2300@suse.de>
	 <41493D5C.9000700@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:32669 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S268271AbUIPPMJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2004 11:12:09 -0400
In-Reply-To: <41493D5C.9000700@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-09-16 at 17:14 +1000, Douglas Gilbert wrote:

> > (you should cc the author when you ask questions about the patch :-)
>
> I have cc-ed Peter Jones now.

It's really Jens's project, but thanks for including me as well ;)

> > I'll try and set up a tree that gets regularly updated, if people are
> > interested in it. Last time I basically came to the conclusion that bsg
> > wasn't 'interesting enough'. SG_IO might not be a pretty interface (I
> > mean the ioctl, not the sg_io_hdr structure), but as long as you don't
> > require queueing or async io it works well enough. And that covers just
> > about 99.5% of the use of sg.
> 
> It has another advantage. It allows device policy
> (including error processing) to be decoupled from
> the primary device interface. For example cdrecord
> does not want to see EROFS (when it opens O_RDWR)
> and does want to see all sense data back from the device **.

And, excuse me for sounding like a broken record, it's traceable with
strace.  I still count this as a big win, even though it horribly abuses
some API for that.

> On the other hand there does seem to be a security issue
> with bsg. Perhaps there could be a "non_root" sysfs attribute
> (default 0, root only writable) on devices that bsg can
> bind to. Then a bsg bind to a specific device needs
> a user with CAP_SYS_RAWIO (or CAP_SYS_ADMIN) or the
> device with non_root=1.

Or, rather, the filtering stuff that's been discussed on l-k...  It's an
idea suitable for a really grungy dumpster, but it works ok.  It'd be
simple enough to add in.

> >>bsg has one device node (i.e. "/dev/bsg") which users can
> >>open and then bind/attach to an existing block device
> >>node (e.g. /dev/sda). Extending this to bind to sysfs
> >>device paths might be handy as well for
> >>   - (SCSI) devices that have an unsupported peripheral device
> >>      type (e.g. SES)
> >>   - other devices (e.g. SMP port of an SAS expander)

It'd be better to get rid of the binding all together, as it's pretty
ugly to begin with.  It's fairly straightforward to make a file in
sysfs, "/sys/block/hda/rawio" or whatnot, and hang it off of a gendisk.
That way there'd be no binding to do whatsoever; you'd just open the
right device to begin with.  Jens and I discussed that earlier, but
didn't really work on it in light of the biarch problems.

-- 
        Peter


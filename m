From: Jens Axboe <axboe@suse.de>
Subject: Re: BSG question
Date: Thu, 16 Sep 2004 09:24:28 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040916072427.GM2300@suse.de>
References: <4148FC12.1010205@torque.net> <20040916060508.GF2300@suse.de> <41493D5C.9000700@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:18894 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S267494AbUIPH0D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2004 03:26:03 -0400
Content-Disposition: inline
In-Reply-To: <41493D5C.9000700@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, pjones@redhat.com

On Thu, Sep 16 2004, Douglas Gilbert wrote:
> Jens Axboe wrote:
> >On Thu, Sep 16 2004, Douglas Gilbert wrote:
> >
> >>In the "[PATCH] New QStor SATA/RAID Driver for 2.6.9-rc2"
> >>thread Jeff Garzik wrote:
> >>
> >>
> >>>* if the userland interface is 100% sending cdbs or taskfiles, then I
> >>>would prefer that Jens Axboe's "bsg" be used.  Its a chardev interface
> >>>for sending/receiving commands to a request queue.
> >>
> >>I played around with bsg
> >>http://marc.theaimsgroup.com/?l=linux-scsi&m=109160967927030&w=2
> >>about a month ago and it
> >>looked good (and I would like sg to evolve in that
> >>direction as well). My plan was to make a version of sg_dd
> >>from sg3_utils use it. However since it was a patch it is hard
> >>to keep in sync as kernel versions roll-out.
> >>
> >>Any chance of getting it into the main line kernel,
> >>on the quiet? Failing that, a web site with up to date
> >>patches.
> >
> >
> >(you should cc the author when you ask questions about the patch :-)
> 
> I have cc-ed Peter Jones now.

I don't know if you are trying to be funny and failing miserably, but I
am the primary author of bsg. It's my "invention", written from scratch.
Peter has joined later.

> >I'll try and set up a tree that gets regularly updated, if people are
> >interested in it. Last time I basically came to the conclusion that bsg
> >wasn't 'interesting enough'. SG_IO might not be a pretty interface (I
> >mean the ioctl, not the sg_io_hdr structure), but as long as you don't
> >require queueing or async io it works well enough. And that covers just
> >about 99.5% of the use of sg.
> 
> It has another advantage. It allows device policy
> (including error processing) to be decoupled from
> the primary device interface. For example cdrecord
> does not want to see EROFS (when it opens O_RDWR)
> and does want to see all sense data back from the device **.
> 
> On the other hand there does seem to be a security issue
> with bsg. Perhaps there could be a "non_root" sysfs attribute
> (default 0, root only writable) on devices that bsg can
> bind to. Then a bsg bind to a specific device needs
> a user with CAP_SYS_RAWIO (or CAP_SYS_ADMIN) or the
> device with non_root=1.

Yep, hasn't tracked the latest command filter horrors yet.

> >>bsg has one device node (i.e. "/dev/bsg") which users can
> >>open and then bind/attach to an existing block device
> >>node (e.g. /dev/sda). Extending this to bind to sysfs
> >>device paths might be handy as well for
> >>  - (SCSI) devices that have an unsupported peripheral device
> >>     type (e.g. SES)
> >>  - other devices (e.g. SMP port of an SAS expander)
> >
> >
> >Yep. I suppose you would need a 'unknown' SCSI driver to attach
> >unsupported peripherals to for that to work transparently.
> 
> 
> ** for example I noticed that sg gets to see Unit Attentions
> but users of the block SG_IO don't (as the command is silently
> retried clearing the Unit attention condition).

Please fix that then. I'm not surprised that REQ_BLOCK_PC doesn't carry
all the info yet, it really must though.

-- 
Jens Axboe


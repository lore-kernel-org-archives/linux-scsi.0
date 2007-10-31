From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
	devices (fwd)
Date: Wed, 31 Oct 2007 11:46:30 +0100
Message-ID: <1193827590.2423.42.camel@lov.site>
References: <Pine.LNX.4.44L0.0710291434370.11432-100000@iolanthe.rowland.org>
	 <1193685197.2321.9.camel@lov.site>  <20071031042531.GB16426@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:55869 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbXJaKoV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 06:44:21 -0400
In-Reply-To: <20071031042531.GB16426@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@SteelEye.com>, Hannes Reinecke <hare@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2007-10-30 at 21:25 -0700, Greg KH wrote:
> On Mon, Oct 29, 2007 at 08:13:17PM +0100, Kay Sievers wrote:
> > On Mon, 2007-10-29 at 14:47 -0400, Alan Stern wrote:
> > > On Mon, 29 Oct 2007, James Bottomley wrote:
> > > 
> > > > I'm not sure if we can do this patch.  If you kill a device, you see
> > > > there's a processing state in scsi_prep_fn() for SDEV_DEL, which has a
> > > > printk message I see quite often when I unplug devices while they're
> > > > operating.
> > > > 
> > > > If you NULL out and free the request queue immediately after setting
> > > > SDEV_DEL, without allowing the devices and filesystems to finish, are
> > > > you sure we're not going to get a null deref on sdev->request_queue?
> > > 
> > > Let's get at this another way.  The patch below probably should be 
> > > applied in any case.  It's essentially a reversion of this patch from 
> > > 2003:
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commit;h=10921a8f1305b8ec97794941db78b825db5839bc
> > > 
> > > which was written to compensate for problems in the SCSI stack.  The
> > > idea was to avoid releasing a kobject before all its children were
> > > released.  However as far as I can see, in general we should be able to
> > > release a kobject as soon as all its children are removed and its
> > > refcount drops to 0, without waiting for the children to be released.  
> > > To put it another way, once a child is removed from visibility it
> > > should not try (or need) to access its parent at all.  If it has to
> > > then it should take an explicit reference to the parent.
> > > 
> > > Since the SCSI stack is now in much better shape, there doesn't seem to 
> > > be any reason to keep the old code.  Do you agree that the patch below 
> > > is worth merging?  I submitted it to Greg some time ago, but he didn't 
> > > want to accept it without some assurance that it is now safe.
> > > 
> > > It would fix the problem Kay and saw with the circular references, 
> > > because the references would all get dropped when the scsi_device is 
> > > removed instead of waiting for a release that will never come.
> > 
> > It indeed fixes my problem. And it sounds you are right, the "fix" from
> > 2003 is probably just a paper-over for a missing explicit reference that
> > time.
> > 
> > I'm all for giving the reversion a try, and add explicit parent get/put
> > if needed somewhere. If, for some reason, that will not happen, I'll
> > need to do something like this in the block patch, which will then be a
> > "fix for the paper-over solution for an unknown bug". :)
> > 
> > 
> > --- a/fs/partitions/check.c
> > +++ b/fs/partitions/check.c
> > ...
> > +       device_del(&disk->dev);
> > +
> > +       /*
> > +        * disconnect from parent device, so the parent can clean up
> > +        * without waiting for us to clean up
> > +        *
> > +        * the driver core took this reference while we added ourself as
> > +        * a child of the parent device
> > +        */
> > +       parent = disk->dev.kobj.parent;
> 
> Save off the parent before calling device_del() otherwise it could be a
> stale pointer, right?

I still hold a ref, the one I drop a few lines later. It should be safe.

> > +       disk->dev.kobj.parent = NULL;
> > +       disk->dev.parent = NULL;
> > +       kobject_put(parent);
> 
> No, that's just wrong, if this is needed, something else really is
> broken, and I don't think it's the driver core...

It's just a kobject_orphan() function. We need to break the circiular
reference somewhere, one of the objects in the circle has to clean up,
to allow the others to clean up. The objects are properly deleted, but
all final references are only dropped on cleanup. The kobject_orphan()
here is just what Alan's patch is doing for the whole core.

With the current logic, if you have any parent referencing a child, the
core will deadlock, and never reach any cleanup funtion, right? That's
the loop I need to break here.

Thanks,
Kay


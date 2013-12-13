From: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [usb-storage] UAS hangs khubd on USB disconnect
Date: Fri, 13 Dec 2013 10:09:07 -0800
Message-ID: <20131213180907.GB10727@xanatos>
References: <20131212000715.GA3181@xanatos>
 <Pine.LNX.4.44L0.1312121632470.849-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1312121632470.849-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 12, 2013 at 05:04:31PM -0500, Alan Stern wrote:
> On Wed, 11 Dec 2013, Sarah Sharp wrote:
> 
> > Hi Hans,
> > 
> > I've been testing the UAS code you sent a pull request for against
> > 3.13-rc1, and I've run into a rather nasty issue with USB disconnect.
> > 
> > I ran some tests with a USB 3.0 storage device under xHCI.  The disk has
> > three 10GB partitions: ext3 (sdb1), ext4 (sdb2), and fat32 (sdb4).
> > There was a btrfs partition on sdb3, but I deleted it.
> > 
> > If I start to play a movie on the ext4 partition, and then yank the USB
> > cable, the uas driver is unbound from the device.  It looks like
> > something goes wrong in the SCSI layer shortly after that, causing an
> > oops in sysfs_remove_group().
> 
> I did a little testing.  It turns out this WARN (not an oops) is the 
> result of recent changes to sysfs, combined with the peculiar way the 
> SCSI layer handles targets.
> 
> In the new kernel, when you call device_del for some object, the 
> object's directory and everything beneath it get removed from sysfs.  
> This wasn't true in the past.
> 
> When a USB drive is unplugged, almost everything below it gets
> unregistered.  But not the SCSI target -- it remains registered until
> the number of "reap references" drops to 0.  This doesn't happen until
> all the devices beneath it are released, which happens when all the
> open file references are closed and the filesystem is unmounted.
> 
> So scsi_target_reap_usercontext ends up calling device_del for the
> target after everything else has been removed from sysfs.  As part of
> normal device_del processing, attribute groups get removed.  In
> particular the power/ subdirectory is removed from the target's sysfs
> directory.  But the sysfs directories are long gone by this time, so
> sysfs_remove_group complains that it was asked to remove a non-existent
> subdirectory.
> 
> Given the way things work now, I suspect these warnings are truly 
> harmless.  We could simply get rid of the WARN in sysfs_remove_group.
> 
> The alternative is to call device_del for SCSI targets earlier on, such 
> as when their hosts are unregistered.  I don't know how James would 
> feel about this approach.  It would be difficult because targets use 
> their own reference counts instead of relying on the usual device 
> refcounting mechanism.

Thanks for looking into this.  I think just getting rid of the WARN
would be sufficient.  Can you make a patch for that?

The patch still won't help with the UAS issues with
scsi_init_shared_tag_map though.

Sarah Sharp
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

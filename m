From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [usb-storage] UAS hangs khubd on USB disconnect
Date: Fri, 13 Dec 2013 15:05:19 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1312131453350.1185-100000@iolanthe.rowland.org>
References: <1386962327.2055.54.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1386962327.2055.54.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 13 Dec 2013, James Bottomley wrote:

> > > I wasn't clear on the reason for that problem.  Does it also arise from 
> > > late device_del for scsi_target?  I could try to change the way that 
> > > works, if anybody (Hans?) would like to test it.
> > 
> > While the recent sysfs changes made this issue more visible, Greg
> > wants to make sure that devices are removed from leaf up in all cases
> > and keep the warning to ensure that.  Would there be a way fix SCSI
> > removal ordering?
> 
> Could someone analyse the actual problem?  We're quite careful even on
> host remove to iterate and remove all the devices, then targets, then
> host (and allied transport objects).  Which removal is inverted?

The scsi_host is removed before the scsi_target.

The reason is that scsi_remove_host() calls
device_del(&shost->shost_gendev) directly, but
scsi_target_reap_usercontext() doesn't call device_del(&starget->dev)
until it gets invoked (indirectly) from
scsi_device_dev_release_usercontext(), by way of scsi_target_reap().

Thus, the host gets removed from visibility at the appropriate time,
but the target remains until all the scsi_devices beneath it are not
only removed from visibility but also released (their refcounts drop to
0).

This can occur much later if, for example, a scsi_device holds a
mounted filesystem.  The scsi_host and scsi_device are removed when the
underlying USB device is unplugged.  But the scsi_device isn't
released, and hence the scsi_target isn't removed, until the filesystem
is unmounted.

Broadly speaking, the correct approach would be to call
scsi_target_reap() from __scsi_remove_device() instead of from
scsi_device_dev_release_usercontext().

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

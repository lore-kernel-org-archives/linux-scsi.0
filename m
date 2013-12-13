From: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [usb-storage] UAS hangs khubd on USB disconnect
Date: Fri, 13 Dec 2013 11:07:21 -0800
Message-ID: <20131213190721.GA2901@xanatos>
References: <20131213180907.GB10727@xanatos>
 <Pine.LNX.4.44L0.1312131316470.1185-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1312131316470.1185-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 13, 2013 at 01:19:36PM -0500, Alan Stern wrote:
> On Fri, 13 Dec 2013, Sarah Sharp wrote:
> 
> > > Given the way things work now, I suspect these warnings are truly 
> > > harmless.  We could simply get rid of the WARN in sysfs_remove_group.
> > > 
> > > The alternative is to call device_del for SCSI targets earlier on, such 
> > > as when their hosts are unregistered.  I don't know how James would 
> > > feel about this approach.  It would be difficult because targets use 
> > > their own reference counts instead of relying on the usual device 
> > > refcounting mechanism.
> > 
> > Thanks for looking into this.  I think just getting rid of the WARN
> > would be sufficient.  Can you make a patch for that?
> 
> Easily.  The downside is that there would no longer be any warning 
> when someone tries to remove a wrong subdirectory by mistake.
> 
> > The patch still won't help with the UAS issues with
> > scsi_init_shared_tag_map though.
> 
> I wasn't clear on the reason for that problem.  Does it also arise from 
> late device_del for scsi_target?  I could try to change the way that 
> works, if anybody (Hans?) would like to test it.

I can certainly test it with my UAS device as well.  I don't know if the
issue arises from the late device_del.  Looking at Hans' stack trace,
the BUG in blk_free_tags gets triggered when the scsi_host is released
before the block_queue release.  So I don't think moving the scsi_target
delete sooner would help?  I really don't know anything about the SCSI
or block layer though.

I can confirm that simply removing the BUG() call in blk_free_tags
allows the partitions on the UAS device to be mounted after it was
hot-removed in the middle of video playback.  Hans, maybe in order to
get an answer to your question[1], you should submit a patch to the
block layer maintainer, Jens Axboe?

Sarah Sharp

[1] http://www.spinics.net/lists/linux-scsi/msg70002.html
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] usb/uas: use scsi_host_find_tag() to find command from a
 tag
Date: Mon, 19 Dec 2011 16:01:07 -0500
Message-ID: <20111219210107.GS14291@linux.intel.com>
References: <20111215211201.GA6482@xanatos>
 <20111216144724.GC19563@linutronix.de>
 <20111216201236.GE19563@linutronix.de>
 <20111216203146.GN14291@linux.intel.com>
 <20111216204241.GA30915@linutronix.de>
 <20111216213628.GA5509@xanatos>
 <1324072059.10429.27.camel@dabdike>
 <20111219193955.GA2060@linutronix.de>
 <20111219195050.GQ14291@linux.intel.com>
 <20111219201226.GC5470@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111219201226.GC5470@xanatos>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 19, 2011 at 12:12:26PM -0800, Sarah Sharp wrote:
> On Mon, Dec 19, 2011 at 02:50:50PM -0500, Matthew Wilcox wrote:
> > On Mon, Dec 19, 2011 at 08:39:55PM +0100, Sebastian Andrzej Siewior wrote:
> > > In "usb/uas: use unique tags for all LUNs" we make sure to create unique
> > > tags across all LUNs. This patch uses scsi_host_find_tag() to obtain the
> > > correct command which is associated with the tag.
> > > The following changes were required:
> > > - don't use sdev->current_cmnd anymore
> > >   Since be can have devices which don't support command tagging we must
> > >   ensure that we can tell the two commands apart. devinfo->cmnd is used
> > >   for this.
> > 
> > I don't understand.  There's one devinfo per sdev.  How does moving the
> > untagged command anchor from sdev to devinfo change anything?
> 
> I thought there was only one devinfo per USB device.  uas_probe() is
> only called once per USB device, and that's where devinfo is allocated and
> the scsi_host is created.

Oh, duh, there's one devinfo per Scsi_Host.  Sorry, my mistake.

> > It's my understanding that the SCSI core will only send either a single
> > untagged command, or tagged commands.  ie any outstanding tagged command
> > will cause an untagged command to be deferred, and an outstanding untagged
> > command will prevent any other command from being sent to the driver.
> 
> Across all scsi_devices on a scsi_host?

Per scsi_dev ... which of course is insufficient ...

> In the status command completion for USB 2.0 devices, we can't know
> which scsi_device we're completing the command for.  Is it an untagged
> command completion for LUN 1 or LUN 2?  We can't tell, because the
> device could reorder the commands across LUNs.  So for untagged USB 2.0
> devices, we need to be sure there is only one untagged command pending
> per scsi_host, and pull the command out of devinfo.

Yes, makes sense now :-)  So we can have multiple tagged commands to LUN 2
and a single untagged command to LUN 1, which is just fine.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

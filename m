From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] SCSI hotplug support
Date: Tue, 15 Oct 2002 10:35:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015143533.GA4288@redhat.com>
References: <200210142107.g9EL7IX04354@localhost.localdomain> <200210150019.53689.oliver@neukum.name> <20021015002252.GE1274@redhat.com> <200210150953.29905.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210150953.29905.oliver@neukum.name>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: James Bottomley <James.Bottomley@steeleye.com>, andersen@codepoet.org, linux-scsi@vger.kernel.org

On Tue, Oct 15, 2002 at 09:53:29AM +0200, Oliver Neukum wrote:
> 
> > > It's harder than doing it the simple way. User space really can do
> > > nothing but do the call.
> >
> > Not true, see my last email.  User space can do a *lot* more than just
> > make the call to add the device, and as a matter of fact it already does.
> 
> But surely it can do more if it can be called with knowledge of a device node,
> can't it? Nobody argues against doing a hotplug call. But divorcing
> recognisition on the bus and attaching a driver to it seems to be bad
> to me. After all there's nothing you can do with a SCSI device without device
> node.
> Plus you keep a difference between the coldplugging and the hotplugging case,
> which is not nice.

You guys aren't thinking.  Come on, what's the realistic difference in the 
hot plug user space manager in the two cases:

Case 1, scsi does the attach, hot plug does the rest:

hot_plug_attach_notifier(dev_t device)
{
  do stuff..
}

Case 2, scsi doesn't do the attach:
hot_plug_attach_notifier(int host, int bus, int target, int lun)
{
  fprintf(/proc/scsi/scsi, "scsi add-single-device %d %d %d %d", host, 
bus, target, lun);
  if(device_added_successfully) {
    do stuff..
  }
}


Now, please, someone tell me why everyone is whining about user space 
doing so little to accomplish what the much larger patch that was 
posted does in kernel space?  My point is, and was, that since we need the 
user space manager *anyway* to handle things the kernel will *never* 
handle, there is no real reason to split up the code segments into a 
kernel space portion and a user space portion.  In fact, it simply makes 
things more complex because if something breaks and you have both a kernel 
part and a user space part, you have to track down which one screwed the 
pooch.  This way at least it's all in one spot.

Besides, I've not heard anyone address my concerns about what context the
disc attach is done in with the kernel space patch.

> > > Plus, you can use such a kernel API to really free the device's
> > > memory, because you cannot know when user space, or indeed if, has
> > > freed the device.
> >
> > Not true at all.  Define a revoke/slave_detach entry point to your driver
> > and you get called when the device is removed so that you can free up any
> > of your resources.
> 
> I see.
> 
> 	Regards
> 		Oliver

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  

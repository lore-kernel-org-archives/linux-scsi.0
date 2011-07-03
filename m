From: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Sun, 3 Jul 2011 03:16:30 +0200
Message-ID: <20110703011630.GA15637@one.firstfloor.org>
References: <20110702181501.GN23059@one.firstfloor.org> <Pine.LNX.4.44L0.1107021559250.16190-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1107021559250.16190-100000-pYrvlCTfrz9XsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

> > if (trace_scsi && dev->type == &scsi_dev_type &&
> >      trace_scsi_dev[0] == 0 || !strcmp(dev_name(dev), trace_scsi_dev))) {
> > 	dev_printk ...
> 
> These extra puts could be coming from deep inside the device-model
> core, where they operate directly on the underlying kobject instead of
> going through put_device().  For example, removal of sysfs symlinks
> could have this effect.

Ok I could move it to kobject with some complications (need a real
back trace then)

> On my system, at least, the scsi_device's refcount dropped to 0 at the 
> right time.  That wasn't the problem.  The NULL pointer occurs because 
> the request_queue is used after the scsi_device has been removed from 
> visibility; among other things, __scsi_remove_device() sets 
> sdev->request_queue->queuedata to NULL.
> 
> As the comment says, this causes the request function to reject all I/O 
> requests -- but not before trying to dereference the NULL pointer!

Your explanation completely contradicts what James wrote earlier.

Maybe it's good if you guys come up with a common avenue of debugging
before I try further.

-Andi

-- 
ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org -- Speaking for myself only.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

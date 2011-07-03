From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Sun, 3 Jul 2011 11:29:51 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1107031121440.28411-100000@netrider.rowland.org>
References: <20110703011630.GA15637@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110703011630.GA15637-qrUzlfsMFqo/4alezvVtWx2eb7JE58TQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 3 Jul 2011, Andi Kleen wrote:

> > On my system, at least, the scsi_device's refcount dropped to 0 at the 
> > right time.  That wasn't the problem.  The NULL pointer occurs because 
> > the request_queue is used after the scsi_device has been removed from 
> > visibility; among other things, __scsi_remove_device() sets 
> > sdev->request_queue->queuedata to NULL.
> > 
> > As the comment says, this causes the request function to reject all I/O 
> > requests -- but not before trying to dereference the NULL pointer!
> 
> Your explanation completely contradicts what James wrote earlier.

Yes, it does.  I'm claiming that James was on a wrong track or looking
in the wrong direction.

> Maybe it's good if you guys come up with a common avenue of debugging
> before I try further.

It will be interesting to hear what James has to say about all this...

> > Would you like to try this patch to see if it fixes the problem?  As I 
> > said before, I'm not certain it's the best thing to do, but it worked 
> > on my system.
> 
> I can try next week.

Okay.

> Is this patch likely to fix the RCU stall?

I have no idea.  All I know about this RCU stall is what you wrote 
before, i.e., that it happened once.  No debugging information or 
anything else.  However if it happens again with the patch in place, 
we'll be in a good position to figure the cause and fix it.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

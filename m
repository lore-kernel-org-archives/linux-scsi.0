From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH] Set manage_start_stop for some USB storage devices by
 default
Date: Mon, 2 Mar 2009 14:42:15 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0903021432060.12263-100000@netrider.rowland.org>
References: <20090302174240.GA22206@vespa.holoscopio.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090302174240.GA22206-StA3NKSgq9XYLCA8tIpKU1aTQe2KTcn/@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thadeu Lima de Souza Cascardo <cascardo-DmMZpsCg3uxeGPcbtGPokg@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2 Mar 2009, Thadeu Lima de Souza Cascardo wrote:

> Hello,
> 
> Some time ago, I've worked with a Sandisk storage device, which could
> not resume properly. I've found out that it was timing out when
> receiving requests. I could mount it right after resuming, but using a
> mounted device was not possible. Since this device is the only storage
> present in some mobile, it is used as the root device and cannot be
> unmounted.
> 
> I've thought this was a bug in the device itself and not a problem in
> the bus or host controller, since other devices worked pretty well.
> After doing some tests, I've realized that doing a rescan in the device
> before accessing it worked. And setting manage_start_stop as true does
> this automatically when resuming for us.
> 
> Thus, the patch below. I would like some comments about this particular
> issue and, if the solution is acceptable, I will send a proper commit
> log.

Maybe there doesn't need to be a patch for this at all.  Can't you get 
the same result by writing a udev rule?  In fact, isn't that how the 
manage_start_stop flag is intended to be set?

As for the patch itself...  You are setting the flag in the wrong 
place.  The manage_start_stop flag applies only to SCSI disk devices 
AFAICT.  (The sysfs interface isn't present if the device isn't a disk, 
at any rate.)  So you should set the flag in the code that applies to 
disks.

Also, this patch won't apply to the current development tree, because
there have been several changes to usb-storage's recently.  In
particular there is new code allowing quirk flags to be set by a module
parameter, and your new flag (if it is accepted) should be added to
this mechanism.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Deadlock in usb-storage error handling
Date: Thu, 20 Mar 2014 15:59:19 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1403201549550.866-100000@iolanthe.rowland.org>
References: <1395331764.2244.16.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395331764.2244.16.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Andreas Reis <andreas.reis-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 20 Mar 2014, James Bottomley wrote:

> OK, so I think we have three things to do
> 
>      1. Investigate SCSI and fix it's abort state problem that's causing
>         it not to send the abort second time around
>      2. Fix usb-storage to fail a reset it can't do (i.e. device reset
>         with outstanding commands)
>      3. Find out why we're sending a spurious request sense.
> 
> I can look at 1 and 3 if you want to take 2.

I wrote a patch for 2.  It turned out not to help much, because I was
wrong -- while a command is running, usb-storage won't do a bus reset
either.  The lock occurs in a separate part of the code, where I wasn't
looking earlier.  When I tested the patch, the device reset failed
immediately (as desired) and then the attempted bus reset hung.  
Overall, not much of an improvement...

In fact, this restriction on bus resets is important and necessary.  
USB devices can be composite, meaning they can contain several
functions all packed into a single device.  If a driver for one of the
other functions needs to perform a bus reset, we don't want it to
interrupt an ongoing mass-storage command.  Thus, it is important for
the reset routine to wait for an outstanding command to complete.

Anyway, this looks to be a moot point.  With your fix for 1, neither 
sort of reset was necessary.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

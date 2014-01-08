From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: RE: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Date: Wed, 8 Jan 2014 12:14:25 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401081210140.1659-100000@iolanthe.rowland.org>
References: <063D6719AE5E284EB5DD2968C1650D6D455602@AcuExch.aculab.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D455602-VkEWCZq2GCInGFn1LkZF6NBPR1lH4CV8@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>
Cc: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, walt <w41ter-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 8 Jan 2014, David Laight wrote:

> > From: Alan Stern
> > 
> > This may be a foolish question, but why is xhci-hcd using no-op TRBs in
> > the first place?
> 
> Because it can't write in a link TRB because other parts of the
> code use link TRBs to detect the end of the ring.
> 
> The problem is that it can't put a link TRB in the middle of
> a chain of data fragments unless it is at a 'suitable' offset
> from the start of the data TD. Given arbitrary input fragmentation
> this means that you can't put a link TRB in the middle of a TD.
> (The documented alignment might be as high as 16kB.)
> 
> If the rest of the code used a 'ring end pointer' then a link TRB
> could be used instead.

I see.  Sounds like a poor design decision in hindsight.  Can it be
changed?

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

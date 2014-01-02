From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Date: Thu, 02 Jan 2014 13:19:20 -0800
Message-ID: <1388697560.2399.29.camel@dabdike.int.hansenpartnership.com>
References: <20131218211219.461663463@linuxfoundation.org>
	 <20131218211220.412278148@linuxfoundation.org> <52C32BB0.90600@gmail.com>
	 <20140102191510.GA9621@xanatos> <52C5D3A9.60708@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52C5D3A9.60708-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Lord <mlord-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>
Cc: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, walt <w41ter-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Laight <david.laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2014-01-02 at 16:01 -0500, Mark Lord wrote:
> On 14-01-02 02:15 PM, Sarah Sharp wrote:
> > On Tue, Dec 31, 2013 at 12:40:16PM -0800, walt wrote:
> ..
> >> Unfortunately this patch causes a regression when copying large files to my
> >> outboard USB3 drive. (Nothing at all to do with networking.)
> >>
> >> When I try to copy a large (20GB) file to the USB3 drive, the copy dies after
> >> about 7GB, the ext4 journal aborts and the drive is remounted read-only.
> >>
> >> This bug is 100% reproducible (always pretty close to 7GB) and reverting this
> >> patch completely fixes the problem.
> > 
> > Ok, I had feared that would be a consequence of this patch.  I think the
> > problem is that the usb-storage driver submitted an URB with more
> > scatter-gather entries than would fit on the ring segment, the xHCI
> > driver rejected the URB with -ENOMEM, and the SCSI core eventually gave
> > up on the SCSI command.
> 
> 
> Is there not a block layer / scheduler tunable for max sg entries or something?

Yes, it's blk_queue_max_segments()  You can also add an indirect limit
from userspace using the queue/max_sectors_kb parameter (it doesn't
limit the number of sg elements directly, but it does limit the overall
size of the transfer, and since each segment is 4k or larger except at
the beginning and end, that limits the total number of sg elements as
well).

James


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

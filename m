From: Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Thu, 25 Feb 2010 18:52:10 +0100
Message-ID: <20100225175210.GY1025@kernel.dk>
References: <yq1aauzopk2.fsf@sermon.lab.mkp.net> <Pine.LNX.4.44L0.1002251132170.1686-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1002251132170.1686-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Ramya Desai <ramya.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 25 2010, Alan Stern wrote:
> On Tue, 23 Feb 2010, Martin K. Petersen wrote:
> 
> > Alan> Are drivers supposed to assign values directly to
> > Alan> q-> limits.max_sectors?  Shouldn't there be a cleaner API for all
> > Alan> this?
> > 
> > Drivers are supposed to set the hard limit.  The soft limit is a
> > fs/block layer value and none of the device driver's business.
> 
> _How_ are drivers supposed to set the hard limit?
> 
> If they call blk_queue_max_sectors() then both the hard and soft limits 
> are affected, but at least the hard limit is set correctly.

blk_queue_max_hw_sectors(). I can understand the confusion though, the
comment is crap for blk_queue_max_sectors(). Mostly because the logic
isn't as clean as it should be, I'll try and get that cleaned up.

> If they call blk_queue_max_hw_sectors() then only the hard limit is 
> affected, but it cannot be set to a value less than 1024 
> (BLK_DEF_MAX_SECTORS).  Wouldn't it be more logical to allow the hard 
> limit to be set to anything at least as large as the page size, and 
> decrease the soft limit if it is larger than the new hard limit?

The driver really should only set the hard limit, they should not change
the soft setting.

We cannot easily support < page size software not hardware limit.

-- 
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

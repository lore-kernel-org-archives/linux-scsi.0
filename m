From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Thu, 25 Feb 2010 14:47:54 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1002251436060.1686-100000@iolanthe.rowland.org>
References: <yq1iq9lkueh.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <yq1iq9lkueh.fsf-+q57XtR/GgMb6DWv4sQWN6xOck334EZe@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Ramya Desai <ramya.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 25 Feb 2010, Martin K. Petersen wrote:

> >>>>> "Alan" == Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> writes:
> 
> Alan> Why is max_sectors changed?  If it is already smaller than the new
> Alan> value of max_hw_sectors, shouldn't it remain the same?
> 
> We have a lot of legacy device drivers kicking around in the tree so the
> default max request size remains the conservative SAFE_MAX_SECTORS
> (255).
> 
> When a low level driver explicitly tells us that it can support bigger
> requests we take the opportunity to increase the soft limit to the block
> layer default (1024).
> 
> Also, this function is generally called at block device creation time so
> it's not like we're overwriting an existing user setting.

With usb-storage we've got a situation where the function can be called
later than device creation time.  This is because there's such a wide
variety among USB devices, there's no way for the driver always to know
the device's actual capabilities -- sometimes the user has to tell it.

This should work out okay with your code.  I just have to change
usb-storage so that the value it reports to the user in the attribute
file is max_hw_sectors instead of max_sectors, to reflect what's
actually being changed.

BTW, how come you didn't write it like this?

	q->limits.max_hw_sectors = max_sectors;

	if (max_sectors < BLK_DEF_MAX_SECTORS)
		q->limits.max_sectors = max_sectors;
	else
		q->limits.max_sectors = BLK_DEF_MAX_SECTORS;

For me this is easier to understand.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

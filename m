From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Thu, 25 Feb 2010 13:28:13 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1002251324200.1686-100000@iolanthe.rowland.org>
References: <yq1zl2xl0j3.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <yq1zl2xl0j3.fsf-+q57XtR/GgMb6DWv4sQWN6xOck334EZe@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Ramya Desai <ramya.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 25 Feb 2010, Martin K. Petersen wrote:

> >>>>> "mkp" == Martin K Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> writes:
> 
> mkp> This one is a runt that came in as part of the DM topology
> mkp> enablement.  DM ended up doing things differently and it is no
> mkp> longer used.  I already have a patch in my queue that removes it.
> 
> Here it is, btw...
> 
> 
> block: Remove blk_queue_max_hw_sectors
> 
> This function is no longer called by any subsystem and can be removed.
> 
> Also clarify test in blk_queue_max_sectors.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
> ---
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index aaa379b..69b7c67 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -226,7 +226,7 @@ void blk_queue_max_sectors(struct request_queue *q, unsigned int max_sectors)
>  		       __func__, max_sectors);
>  	}
>  
> -	if (BLK_DEF_MAX_SECTORS > max_sectors)
> +	if (max_sectors < BLK_DEF_MAX_SECTORS)
>  		q->limits.max_hw_sectors = q->limits.max_sectors = max_sectors;
>  	else {
>  		q->limits.max_sectors = BLK_DEF_MAX_SECTORS;

Why is max_sectors changed?  If it is already smaller than the new 
value of max_hw_sectors, shouldn't it remain the same?

Or to put it another way, shouldn't the code look more like this?

	q->limits.max_hw_sectors = max(max_sectors, BLK_DEF_MAX_SECTORS);
	if (q->limits.max_sectors > q->limits.max_hw_sectors)
		q->limits.max_sectors = q->limits.max_hw_sectors;

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

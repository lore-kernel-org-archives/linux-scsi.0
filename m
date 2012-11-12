From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH] USB enclosures seem to require read(16) with >2TB drives
Date: Mon, 12 Nov 2012 15:10:55 +0000
Message-ID: <1352733055.2449.34.camel@dabdike.int.hansenpartnership.com>
References: <1352477289-8133-1-git-send-email-hernejj@gmail.com>
	 <1352719990.2449.23.camel@dabdike.int.hansenpartnership.com>
	 <50A10856.6090009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50A10856.6090009-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Jason J. Herne" <hernejj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-11-12 at 15:31 +0100, Paolo Bonzini wrote:
> Il 12/11/2012 12:33, James Bottomley ha scritto:
> > On Fri, 2012-11-09 at 11:08 -0500, Jason J. Herne wrote:
> >> diff --git a/drivers/usb/storage/scsiglue.c
> >> b/drivers/usb/storage/scsiglue.c
> >> index 13b8bcd..6ff785e 100644
> >> --- a/drivers/usb/storage/scsiglue.c
> >> +++ b/drivers/usb/storage/scsiglue.c
> >> @@ -251,6 +251,11 @@ static int slave_configure(struct scsi_device
> >> *sdev)
> >>                                         US_FL_SCM_MULT_TARG)) &&
> >>                                 us->protocol == USB_PR_BULK)
> >>                         us->use_last_sector_hacks = 1;
> >> +
> >> +               /* Force read-16 for large capacity drives. */
> >> +               sdev->force_read_16 = 1;
> >> +
> >> +
> > 
> > This turns READ_16 on unconditionally for all USB disks ... is that
> > safe?  As in have you tested this with older USB thumb drives?
> 
> Actually it only turns it on for large capacity drives, as said in the
> comment.  sdp->force_read_16 only matters for >2TB drives: 

If you follow the discussion, we'll need to turn it on for some drives
regardless of size.

> >> +	/* Many large capacity USB drives/controllers require the use of read(16). */
> >> +	force_read16 = (sdkp->capacity > 0xffffffffULL && sdp->force_read_16);
> >> +
> >>  	if (host_dif == SD_DIF_TYPE2_PROTECTION) {
> >>  		SCpnt->cmnd = mempool_alloc(sd_cdb_pool, GFP_ATOMIC);
> >>  
> >> @@ -833,7 +836,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
> >>  		SCpnt->cmnd[29] = (unsigned char) (this_count >> 16) & 0xff;
> >>  		SCpnt->cmnd[30] = (unsigned char) (this_count >> 8) & 0xff;
> >>  		SCpnt->cmnd[31] = (unsigned char) this_count & 0xff;
> >> -	} else if (block > 0xffffffff) {
> >> +	} else if (block > 0xffffffff || force_read16) {
> 
> so the better name would be never_use_10_for_rw_on_large_disks.  For
> some definitions of better. :)

Hm.

> Any reason not to do this always on >2TB drives, which basically means
> changing this:
> 
> -	} else if (block > 0xffffffff) {
> +	} else if (sdkp->capacity > 0xffffffff) {
> 
> and nothing else?

Because of the coming T10 mandate in SBC-4 deprecating everything other
than the 16 byte commands.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

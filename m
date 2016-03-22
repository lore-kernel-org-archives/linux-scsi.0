From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] sd: fixup capacity calculation for 4k drives
Date: Tue, 22 Mar 2016 10:16:57 -0400
Message-ID: <1458656217.17965.48.camel@localhost.localdomain>
References: <1458563249-91200-1-git-send-email-hare@suse.de>
	 <yq1a8lr5n2y.fsf@sermon.lab.mkp.net>  <56F0F0E8.6060302@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758771AbcCVOQ7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2016 10:16:59 -0400
In-Reply-To: <56F0F0E8.6060302@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On Tue, 2016-03-22 at 08:14 +0100, Hannes Reinecke wrote:
> On 03/22/2016 02:16 AM, Martin K. Petersen wrote:
> >>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:
> > 
> > Hannes> in sd_read_capacity() the sdkp->capacity field changes its
> > Hannes> meaning: after the call to read_capacity_XX() it carries the
> > Hannes> _unscaled_ values, making the comparison between the original
> > Hannes> value and the new value always false for drives with a sector
> > Hannes> size != 512.  So introduce a 'new_capacity' carrying the new,
> > Hannes> scaled, capacity.
> > 
> > I agree with Christoph.
> > 
> > How about something like this instead?
> > 
> I've coded it somewhat different, but this one works as well.
> But please modify the description in sd.h, as with this patch
> 'sdkp->capacity' is the _unscaled_ value.
> Might lead to confusion otherwise.
> 
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 5f2a84a..5ed7434 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -65,7 +65,7 @@ struct scsi_disk {
>         struct device   dev;
>         struct gendisk  *disk;
>         atomic_t        openers;
> -       sector_t        capacity;       /* size in 512-byte sectors */
> +       sector_t        capacity;       /* size in logical sectors */
>         u32             max_xfer_blocks;
>         u32             opt_xfer_blocks;
>         u32             max_ws_blocks;
> 
> (Apologies for the mangled patch)
> 
> Cheers,
> 
> Hannes

If we change the meaning of the scsi_disk->capacity field to be logical
sectors, we also have to change sd_getgeo() in sd.c, do we not?

The ->capacity field is also accessed by last_sector_hacks() in
drivers/usb/storage/transport.c, although it kind of looks like
that code might not have been correct for 4K sectors with the
scaled value.

-Ewan







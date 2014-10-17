From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: PC partition tables are little endian
Date: Fri, 17 Oct 2014 06:13:50 -0700
Message-ID: <20141017131349.GB16538@infradead.org>
References: <1412188261-29632-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36581 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbaJQNNu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Oct 2014 09:13:50 -0400
Content-Disposition: inline
In-Reply-To: <1412188261-29632-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>

ping?

On Wed, Oct 01, 2014 at 08:31:01PM +0200, Christoph Hellwig wrote:
> As sparse correctly pointed out scsi_partsize should use get_unaligned_le32
> to read PC partition tables from disk, as they are little endian.
> 
> The result of this bug is that we returned incorrect geometries on big
> endian systems when using the scsicam variant.  Which probably doesn't
> matter as only old x86 systems every cared about the geometry.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsicam.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsicam.c b/drivers/scsi/scsicam.c
> index 92d24d6..910f4a7 100644
> --- a/drivers/scsi/scsicam.c
> +++ b/drivers/scsi/scsicam.c
> @@ -163,8 +163,8 @@ int scsi_partsize(unsigned char *buf, unsigned long capacity,
>  		    end_head * end_sector + end_sector;
>  
>  		/* This is the actual _sector_ number at the end */
> -		logical_end = get_unaligned(&largest->start_sect)
> -		    + get_unaligned(&largest->nr_sects);
> +		logical_end = get_unaligned_le32(&largest->start_sect)
> +		    + get_unaligned_le32(&largest->nr_sects);
>  
>  		/* This is for >1023 cylinders */
>  		ext_cyl = (logical_end - (end_head * end_sector + end_sector))
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---

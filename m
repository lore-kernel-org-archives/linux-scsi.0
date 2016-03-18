From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH] scsi_common: do not clobber fixed sense information
Date: Fri, 18 Mar 2016 09:02:12 -0700
Message-ID: <56EC2684.1080006@suse.com>
References: <1458288095-126497-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57463 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbcCRQGL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2016 12:06:11 -0400
In-Reply-To: <1458288095-126497-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 03/18/2016 01:01 AM, Hannes Reinecke wrote:
> For fixed sense the information field is 32 bits, to we need
> to truncate the information field to avoid clobbering the
> sense code.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/scsi_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
> index c126966..3459009 100644
> --- a/drivers/scsi/scsi_common.c
> +++ b/drivers/scsi/scsi_common.c
> @@ -279,7 +279,7 @@ int scsi_set_sense_information(u8 *buf, int buf_len, u64 info)
>  		put_unaligned_be64(info, &ucp[4]);
>  	} else if ((buf[0] & 0x7f) == 0x70) {
>  		buf[0] |= 0x80;
> -		put_unaligned_be64(info, &buf[3]);
> +		put_unaligned_be32((u32)info, &buf[3]);
>  	}
>  
>  	return 0;
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

-- 
Lee

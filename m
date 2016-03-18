From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi_common: do not clobber fixed sense information
Date: Fri, 18 Mar 2016 08:57:43 -0400
Message-ID: <1458305863.17965.24.camel@localhost.localdomain>
References: <1458288095-126497-1-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbcCRM5p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2016 08:57:45 -0400
In-Reply-To: <1458288095-126497-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, 2016-03-18 at 09:01 +0100, Hannes Reinecke wrote:
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

Well, not clobbering the ADDITIONAL SENSE LENGTH field is good,
however according to SPC-5 what we are really supposed to do here
is not set the VALID bit (buf[0] |= 0x80) if the value to be
returned can't be represented in 32 bits (and set the INFORMATION
field to a "vendor specific" value, whatever that means).

I'm not a T10 member so I don't have immediate access to what the
earlier SPC revisions say.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>



From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] scsi_common: do not clobber fixed sense information
Date: Fri, 18 Mar 2016 09:19:26 -0700
Message-ID: <56EC2A8E.1010005@sandisk.com>
References: <1458288095-126497-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0060.outbound.protection.outlook.com ([157.56.111.60]:22592
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751024AbcCRQTb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2016 12:19:31 -0400
In-Reply-To: <1458288095-126497-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>

On 03/18/2016 01:01 AM, Hannes Reinecke wrote:
> For fixed sense the information field is 32 bits, to we need
> to truncate the information field to avoid clobbering the
> sense code.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>   drivers/scsi/scsi_common.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
> index c126966..3459009 100644
> --- a/drivers/scsi/scsi_common.c
> +++ b/drivers/scsi/scsi_common.c
> @@ -279,7 +279,7 @@ int scsi_set_sense_information(u8 *buf, int buf_len, u64 info)
>   		put_unaligned_be64(info, &ucp[4]);
>   	} else if ((buf[0] & 0x7f) == 0x70) {
>   		buf[0] |= 0x80;
> -		put_unaligned_be64(info, &buf[3]);
> +		put_unaligned_be32((u32)info, &buf[3]);
>   	}
>
>   	return 0;

Hello Hannes,

Please Cc stable for this patch.

Are you aware that the explicit cast to u32 can be left out? Without 
that cast the compiler implicitly performs casting from u64 to u32.

Anyway:

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>


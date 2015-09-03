From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH RESEND] scsi: Fix sense information setting in fixed
 sized format
Date: Thu, 03 Sep 2015 15:02:28 -0400
Message-ID: <1441306948.23183.328.camel@localhost.localdomain>
References: <1441298973-27735-1-git-send-email-sagig@mellanox.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbbICTC3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Sep 2015 15:02:29 -0400
In-Reply-To: <1441298973-27735-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Thu, 2015-09-03 at 19:49 +0300, Sagi Grimberg wrote:
> In fixed size sense format the information field is a four byte
> field.
> 
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
> index 41432c10dda2..8cfb7eeb5bbc 100644
> --- a/drivers/scsi/scsi_common.c
> +++ b/drivers/scsi/scsi_common.c
> @@ -270,7 +270,7 @@ void scsi_set_sense_information(u8 *buf, u64 info)
>  		put_unaligned_be64(info, &ucp[4]);
>  	} else if ((buf[0] & 0x7f) == 0x70) {
>  		buf[0] |= 0x80;
> -		put_unaligned_be64(info, &buf[3]);
> +		put_unaligned_be32(info, &buf[3]);
>  	}
>  }
>  EXPORT_SYMBOL(scsi_set_sense_information);

Looks correct per SPC-4 4.5.3

And you did post a patch to target for the case where the sector
did not fit in 32 bits, which requires descriptor format sense, so...

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


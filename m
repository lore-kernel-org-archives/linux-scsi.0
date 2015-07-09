From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] scsi: Fix sense information setting in fixed sized format
Date: Thu, 9 Jul 2015 07:38:07 -0700
Message-ID: <559E874F.5080105@sandisk.com>
References: <1436367603-16456-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0060.outbound.protection.outlook.com ([65.55.169.60]:20848
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750998AbbGIOiM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jul 2015 10:38:12 -0400
In-Reply-To: <1436367603-16456-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

On 07/08/15 08:00, Sagi Grimberg wrote:
> In fixed size sense format the information field is a four byte
> field.
>
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> ---
>   drivers/scsi/scsi_common.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
> index 41432c1..8cfb7ee 100644
> --- a/drivers/scsi/scsi_common.c
> +++ b/drivers/scsi/scsi_common.c
> @@ -270,7 +270,7 @@ void scsi_set_sense_information(u8 *buf, u64 info)
>   		put_unaligned_be64(info, &ucp[4]);
>   	} else if ((buf[0] & 0x7f) == 0x70) {
>   		buf[0] |= 0x80;
> -		put_unaligned_be64(info, &buf[3]);
> +		put_unaligned_be32(info, &buf[3]);
>   	}
>   }
>   EXPORT_SYMBOL(scsi_set_sense_information);

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

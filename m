From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 06/14] block: Make protection interval calculation generic
Date: Wed, 06 Aug 2014 18:43:15 +0300
Message-ID: <53E24D13.5030006@dev.mellanox.co.il>
References: <1406320469-29352-1-git-send-email-martin.petersen@oracle.com> <1406320469-29352-7-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:57178 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbaHFPnV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2014 11:43:21 -0400
Received: by mail-wg0-f47.google.com with SMTP id b13so2730928wgh.6
        for <linux-scsi@vger.kernel.org>; Wed, 06 Aug 2014 08:43:20 -0700 (PDT)
In-Reply-To: <1406320469-29352-7-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On 7/25/2014 11:34 PM, Martin K. Petersen wrote:
> Now that the protection interval has been detached from the sector size
> we need to be able to handle sizes that are different from 4K and
> 512. Make the interval calculation generic.
>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>   block/bio-integrity.c | 6 +-----
>   1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> index 8c03c78281e9..320ce7df1a5f 100644
> --- a/block/bio-integrity.c
> +++ b/block/bio-integrity.c
> @@ -203,11 +203,7 @@ EXPORT_SYMBOL(bio_integrity_enabled);
>   static inline unsigned int bio_integrity_intervals(struct blk_integrity *bi,
>   						   unsigned int sectors)
>   {
> -	/* At this point there are only 512b or 4096b DIF/EPP devices */
> -	if (bi->interval == 4096)
> -		return sectors >>= 3;
> -
> -	return sectors;
> +	return sectors >> (ilog2(bi->interval) - 9);
>   }
>
>   static inline unsigned int bio_integrity_bytes(struct blk_integrity *bi,
>

Looks good to me,

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>

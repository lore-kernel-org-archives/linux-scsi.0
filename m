From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] sd: Fix discard granularity when LBPRZ=1
Date: Tue, 8 Mar 2016 09:02:58 -0800
Message-ID: <56DF05C2.8000901@sandisk.com>
References: <20160304152409.GA31358@redhat.com>
 <1457219421-836-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0062.outbound.protection.outlook.com ([157.56.111.62]:11584
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933200AbcCHRDF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Mar 2016 12:03:05 -0500
In-Reply-To: <1457219421-836-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: snitzer@redhat.com

On 03/05/2016 03:10 PM, Martin K. Petersen wrote:
> Commit 397737223c59 ("sd: Make discard granularity match logical block
> size when LBPRZ=1") accidentally set the granularity to one byte instead
> of one logical block on devices that provide determistic zeroes after
> UNMAP.
>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reported-by: Mike Snitzer <snitzer@redhat.com>
> Fixes: 397737223c59e89dca7305feb6528caef8fbef84
> Cc: <stable@vger.kernel.org> # 4.4+
> ---
>   drivers/scsi/sd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index d749da765df1..5a5457ac9cdb 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -648,7 +648,7 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
>   	 */
>   	if (sdkp->lbprz) {
>   		q->limits.discard_alignment = 0;
> -		q->limits.discard_granularity = 1;
> +		q->limits.discard_granularity = logical_block_size;
>   	} else {
>   		q->limits.discard_alignment = sdkp->unmap_alignment *
>   			logical_block_size;

Please fix the spelling of "deterministic" in the patch description. 
With or without that change:

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

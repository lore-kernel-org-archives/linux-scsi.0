From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] sd: Fix discard granularity when LBPRZ=1
Date: Mon, 07 Mar 2016 10:42:08 -0500
Message-ID: <1457365328.16707.65.camel@localhost.localdomain>
References: <20160304152409.GA31358@redhat.com>
	 <1457219421-836-1-git-send-email-martin.petersen@oracle.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbcCGPmK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2016 10:42:10 -0500
In-Reply-To: <1457219421-836-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, snitzer@redhat.com, stable@vger.kernel.org#4.4+

On Sat, 2016-03-05 at 18:10 -0500, Martin K. Petersen wrote:
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
>  drivers/scsi/sd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index d749da765df1..5a5457ac9cdb 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -648,7 +648,7 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
>  	 */
>  	if (sdkp->lbprz) {
>  		q->limits.discard_alignment = 0;
> -		q->limits.discard_granularity = 1;
> +		q->limits.discard_granularity = logical_block_size;
>  	} else {
>  		q->limits.discard_alignment = sdkp->unmap_alignment *
>  			logical_block_size;

Reviewed-by: Ewan D. Milne <emilne@redhat.com>



From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 33/48] hpsa: slightly optimize SA5_performant_completed
Date: Fri, 16 Jan 2015 15:16:21 +0100
Message-ID: <54B91D35.9010203@redhat.com>
References: <20150114215756.21325.41198.stgit@brunhilda> <20150114220232.21325.30631.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbbAPOQu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2015 09:16:50 -0500
In-Reply-To: <20150114220232.21325.30631.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 01/14/2015 11:02 PM, Don Brace wrote:
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.h |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
> index 1856445..aa6cb0b 100644
> --- a/drivers/scsi/hpsa.h
> +++ b/drivers/scsi/hpsa.h
> @@ -412,19 +412,19 @@ static unsigned long SA5_performant_completed(struct ctlr_info *h, u8 q)
>  	unsigned long register_value = FIFO_EMPTY;

Hi Don,

the above assignment might be also removed when you at changing this function.
I have noticed that you have taken two patches I've posted earlier - thanks.
Would you mind adding to your series the workqueue patch http://www.spinics.net/lists/linux-scsi/msg80035.html
or should I recreate it and repost?

Thanks,
Tomas


>  
>  	/* msi auto clears the interrupt pending bit. */
> -	if (!(h->msi_vector || h->msix_vector)) {
> +	if (unlikely(!(h->msi_vector || h->msix_vector))) {
>  		/* flush the controller write of the reply queue by reading
>  		 * outbound doorbell status register.
>  		 */
> -		register_value = readl(h->vaddr + SA5_OUTDB_STATUS);
> +		(void) readl(h->vaddr + SA5_OUTDB_STATUS);
>  		writel(SA5_OUTDB_CLEAR_PERF_BIT, h->vaddr + SA5_OUTDB_CLEAR);
>  		/* Do a read in order to flush the write to the controller
>  		 * (as per spec.)
>  		 */
> -		register_value = readl(h->vaddr + SA5_OUTDB_STATUS);
> +		(void) readl(h->vaddr + SA5_OUTDB_STATUS);
>  	}
>  
> -	if ((rq->head[rq->current_entry] & 1) == rq->wraparound) {
> +	if ((((u32) rq->head[rq->current_entry]) & 1) == rq->wraparound) {
>  		register_value = rq->head[rq->current_entry];
>  		rq->current_entry++;
>  		atomic_dec(&h->commands_outstanding);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


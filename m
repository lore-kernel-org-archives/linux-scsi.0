From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 04/17] scsi: avoid useless free_list lock roundtrips
Date: Wed, 05 Feb 2014 15:44:04 -0800
Message-ID: <1391643844.2213.62.camel@dabdike.int.hansenpartnership.com>
References: <20140205123930.150608699@bombadil.infradead.org>
	 <20140205124019.577883829@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46390 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751368AbaBEXoG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 18:44:06 -0500
In-Reply-To: <20140205124019.577883829@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

On Wed, 2014-02-05 at 04:39 -0800, Christoph Hellwig wrote:
> Avoid hitting the host-wide free_list lock unless we need to put a command
> back onto the freelist.

This one looks like it can go independently on its own.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi.c |   13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index ebcea6c..4139486 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -320,15 +320,16 @@ void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
>  {
>  	unsigned long flags;
>  
> -	/* changing locks here, don't need to restore the irq state */
> -	spin_lock_irqsave(&shost->free_list_lock, flags);
>  	if (unlikely(list_empty(&shost->free_list))) {
> -		list_add(&cmd->list, &shost->free_list);
> -		cmd = NULL;
> +		spin_lock_irqsave(&shost->free_list_lock, flags);
> +		if (list_empty(&shost->free_list)) {
> +			list_add(&cmd->list, &shost->free_list);
> +			cmd = NULL;
> +		}
> +		spin_unlock_irqrestore(&shost->free_list_lock, flags);
>  	}
> -	spin_unlock_irqrestore(&shost->free_list_lock, flags);
>  
> -	if (likely(cmd != NULL))
> +	if (cmd)

Why do this?  cmd is still likely to be not NULL, which helps the
compiler optimise.

James

>  		scsi_pool_free_command(shost->cmd_pool, cmd);
>  
>  	put_device(dev);
> -- 
> 1.7.10.4



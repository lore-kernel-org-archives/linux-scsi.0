From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] 53c700: fix memory leak of dma non-cosistent memory
Date: Wed, 16 Nov 2016 21:46:39 -0500
Message-ID: <1479350799.3525.41.camel@HansenPartnership.com>
References: <582962db.0130ed0a.10866.5633@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42154 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752999AbcKQCqp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Nov 2016 21:46:45 -0500
In-Reply-To: <582962db.0130ed0a.10866.5633@mx.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Li Qiang <liq3ea@gmail.com>, linux-scsi@vger.kernel.org

On Mon, 2016-11-14 at 15:07 +0800, Li Qiang wrote:
> From: Li Qiang <liq3ea@gmail.com>
> 
> In NCR_700_detect function, if an error occurs it will return
> NULL without freeing the dma non-cosistent memory once allocated.
> This patch avoid this.
> 
> Signed-off-by: Li Qiang <liq3ea@gmail.com>

There's not a lot of point doing this, since the memory leak is so tiny
and the failures would be instantly noticeable.  However:

> ---
>  drivers/scsi/53c700.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
> index 95e32a4..d5a2ba3 100644
> --- a/drivers/scsi/53c700.c
> +++ b/drivers/scsi/53c700.c
> @@ -332,8 +332,10 @@ struct Scsi_Host *
>  		tpnt->proc_name = "53c700";
>  
>  	host = scsi_host_alloc(tpnt, 4);
> -	if (!host)
> +	if (!host) {
> +		dma_free_noncoherent(hostdata->dev, TOTAL_MEM_SIZE,
> memory, pScript);
>  		return NULL;
> +	}

This you could do.

>  	memset(hostdata->slots, 0, sizeof(struct
> NCR_700_command_slot)
>  	       * NCR_700_COMMAND_SLOTS_PER_HOST);
>  	for (j = 0; j < NCR_700_COMMAND_SLOTS_PER_HOST; j++) {
> @@ -394,6 +396,7 @@ struct Scsi_Host *
>  
>  	if (scsi_add_host(host, dev)) {
>  		dev_printk(KERN_ERR, dev, "53c700: scsi_add_host
> failed\n");
> +		dma_free_noncoherent(hostdata->dev, TOTAL_MEM_SIZE,
> memory, pScript);
>  		scsi_host_put(host);
>  		return NULL;
>  	}

This I'm not sure about; I'd have to dig more deeply into how the
driver works.  If the scripts engine is already started, you can't just
free the memory it's running from without actually stopping it,
otherwise nasty things may happen if something else reuses the memory. 
 I have a vague feeling that this driver is activation driven rather
than mailbox driven, so it might be OK, but it needs checking.

James


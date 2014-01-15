From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH] hpsa: fixup MSI-X registration
Date: Wed, 15 Jan 2014 15:32:05 -0600
Message-ID: <20140115213205.GA3776@beardog.cce.hp.com>
References: <1389789053-95698-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:35096 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaAOUcM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 15:32:12 -0500
Content-Disposition: inline
In-Reply-To: <1389789053-95698-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, scameron@beardog.cce.hp.com

On Wed, Jan 15, 2014 at 01:30:53PM +0100, Hannes Reinecke wrote:
> Commit 254f796b9f22b1944c64caabc356a56caaa2facd updated
> the driver to use 16 MSI-X vectors, despite the fact that
> older controllers would provide only 4.
> This was causing MSI-X registration to drop down to INTx
> mode. But as the controller support performant mode, the
> initialisation will become confused and cause the machine
> to stall during boot.
> 
> This patch fixes up the MSI-X registration to re-issue
> the pci_enable_msix() call with the correct number of
> MSI-X vectors. With that the hpsa driver continues to
> works on older controllers like the P200.
> 
> Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Ack.

Looks good to me, thanks.

-- steve

> ---
>  drivers/scsi/hpsa.c | 31 +++++++++++++++++--------------
>  1 file changed, 17 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 868318a..40989ee 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -598,7 +598,7 @@ static void set_performant_mode(struct ctlr_info *h, struct CommandList *c)
>  {
>  	if (likely(h->transMethod & CFGTBL_Trans_Performant)) {
>  		c->busaddr |= 1 | (h->blockFetchTable[c->Header.SGList] << 1);
> -		if (likely(h->msix_vector))
> +		if (likely(h->msix_vector > 0))
>  			c->Header.ReplyQueue =
>  				raw_smp_processor_id() % h->nreply_queues;
>  	}
> @@ -4169,21 +4169,24 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
>  		goto default_int_mode;
>  	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSIX)) {
>  		dev_info(&h->pdev->dev, "MSIX\n");
> +		h->msix_vector = MAX_REPLY_QUEUES;
>  		err = pci_enable_msix(h->pdev, hpsa_msix_entries,
> -						MAX_REPLY_QUEUES);
> -		if (!err) {
> -			for (i = 0; i < MAX_REPLY_QUEUES; i++)
> -				h->intr[i] = hpsa_msix_entries[i].vector;
> -			h->msix_vector = 1;
> -			return;
> -		}
> +				      h->msix_vector);
>  		if (err > 0) {
>  			dev_warn(&h->pdev->dev, "only %d MSI-X vectors "
>  			       "available\n", err);
> -			goto default_int_mode;
> +			h->msix_vector = err;
> +			err = pci_enable_msix(h->pdev, hpsa_msix_entries,
> +					      h->msix_vector);
> +		}
> +		if (!err) {
> +			for (i = 0; i < h->msix_vector; i++)
> +				h->intr[i] = hpsa_msix_entries[i].vector;
> +			return;
>  		} else {
>  			dev_warn(&h->pdev->dev, "MSI-X init failed %d\n",
>  			       err);
> +			h->msix_vector = 0;
>  			goto default_int_mode;
>  		}
>  	}
> @@ -4597,15 +4600,15 @@ static int hpsa_request_irq(struct ctlr_info *h,
>  	for (i = 0; i < MAX_REPLY_QUEUES; i++)
>  		h->q[i] = (u8) i;
>  
> -	if (h->intr_mode == PERF_MODE_INT && h->msix_vector) {
> +	if (h->intr_mode == PERF_MODE_INT && h->msix_vector > 0) {
>  		/* If performant mode and MSI-X, use multiple reply queues */
> -		for (i = 0; i < MAX_REPLY_QUEUES; i++)
> +		for (i = 0; i < h->msix_vector; i++)
>  			rc = request_irq(h->intr[i], msixhandler,
>  					0, h->devname,
>  					&h->q[i]);
>  	} else {
>  		/* Use single reply pool */
> -		if (h->msix_vector || h->msi_vector) {
> +		if (h->msix_vector > 0 || h->msi_vector) {
>  			rc = request_irq(h->intr[h->intr_mode],
>  				msixhandler, 0, h->devname,
>  				&h->q[h->intr_mode]);
> @@ -4658,7 +4661,7 @@ static void free_irqs(struct ctlr_info *h)
>  		return;
>  	}
>  
> -	for (i = 0; i < MAX_REPLY_QUEUES; i++)
> +	for (i = 0; i < h->msix_vector; i++)
>  		free_irq(h->intr[i], &h->q[i]);
>  }
>  
> @@ -5178,7 +5181,7 @@ static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
>  	if (!(trans_support & PERFORMANT_MODE))
>  		return;
>  
> -	h->nreply_queues = h->msix_vector ? MAX_REPLY_QUEUES : 1;
> +	h->nreply_queues = h->msix_vector > 0 ? h->msix_vector : 1;
>  	hpsa_get_max_perf_mode_cmds(h);
>  	/* Performant mode ring buffer and supporting data structures */
>  	h->reply_pool_size = h->max_commands * sizeof(u64) * h->nreply_queues;
> -- 
> 1.7.12.4

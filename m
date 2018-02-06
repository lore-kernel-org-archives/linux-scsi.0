From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V2 7/8] scsi: hpsa: call hpsa_hba_inquiry() after adding
 host
Date: Tue, 6 Feb 2018 09:32:02 +0100
Message-ID: <a36adf6c-9b44-9bc1-c049-38949773b049@suse.de>
References: <20180205152035.15016-1-ming.lei@redhat.com>
 <20180205152035.15016-8-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180205152035.15016-8-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 02/05/2018 04:20 PM, Ming Lei wrote:
> So that we can decide the default reply queue by the map created
> during adding host.
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Arun Easi <arun.easi@cavium.com>
> Cc: Omar Sandoval <osandov@fb.com>,
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
> Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
> Cc: Christoph Hellwig <hch@lst.de>,
> Cc: Don Brace <don.brace@microsemi.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Peter Rivera <peter.rivera@broadcom.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Tested-by: Laurence Oberman <loberman@redhat.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/hpsa.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 287e5eb0723f..443eabf63a9f 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -8691,12 +8691,9 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	/* Disable discovery polling.*/
>  	h->discovery_polling = 0;
>  
> -
>  	/* Turn the interrupts on so we can service requests */
>  	h->access.set_intr_mask(h, HPSA_INTR_ON);
>  
> -	hpsa_hba_inquiry(h);
> -
>  	h->lastlogicals = kzalloc(sizeof(*(h->lastlogicals)), GFP_KERNEL);
>  	if (!h->lastlogicals)
>  		dev_info(&h->pdev->dev,
> @@ -8707,6 +8704,8 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (rc)
>  		goto clean7; /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
>  
> +	hpsa_hba_inquiry(h);
> +
>  	/* Monitor the controller for firmware lockups */
>  	h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL;
>  	INIT_DELAYED_WORK(&h->monitor_ctlr_work, hpsa_monitor_ctlr_worker);
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)

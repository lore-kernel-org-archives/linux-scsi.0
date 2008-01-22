From: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH rc8-mm1] hotfix libata-scsi corruption
Date: Tue, 22 Jan 2008 20:20:16 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0801222009070.16267@blonde.site>
References: <Pine.LNX.4.64.0801221706320.5832@blonde.site>
 <1201022985.3210.24.camel@localhost.localdomain>  <Pine.LNX.4.64.0801221813540.8693@blonde.site>
 <1201031028.3210.61.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
Received: from [172.20.20.139]([172.20.20.139]) (3399 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1JHPcD-0000GVC@megami.veritas.com>
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jan 2008 12:21:01 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
In-Reply-To: <1201031028.3210.61.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>, Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 22 Jan 2008, James Bottomley wrote:
> 
> Actually, I don't think it's a smaller I/O issue.  The SMART protocol
> specifically mandates that the transfers for SMART READ DATA and SMART
> READ LOG shall be 512 bytes).  However, the pio transfer routine does
> seem to be assuming sector alignment as well, which will be where your
> problems are coming from.  I think we need to specify sector minimum
> alignment for ata (but not atapi, which has its own non sector size pio
> routine).  How about the attached?
> 
> We have to do this for all ATA devices, because they'll likely all
> support SMART, and SMART is defined to be a PIO command.

Thanks, you've answered several of my uncertainties (why the PIO,
why the sector size).

I've just tried it, and can confirm that your replacement patch
below fixes the issue for me in practice.

What I can't say, you and Jeff and others will judge, is whether that's
actually the right placement for the blk_queue_update_dma_alignment call
(as an outsider, I'm not convinced that the SMART requirement should be
imposing this limitation on the rest).

Hugh

> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 4bb268b..bc5cf6b 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -824,9 +824,6 @@ static void ata_scsi_sdev_config(struct scsi_device *sdev)
>  	 * requests.
>  	 */
>  	sdev->max_device_blocked = 1;
> -
> -	/* set the min alignment */
> -	blk_queue_update_dma_alignment(sdev->request_queue, ATA_DMA_PAD_SZ - 1);
>  }
>  
>  static void ata_scsi_dev_config(struct scsi_device *sdev,
> @@ -842,7 +839,14 @@ static void ata_scsi_dev_config(struct scsi_device *sdev,
>  	if (dev->class == ATA_DEV_ATAPI) {
>  		struct request_queue *q = sdev->request_queue;
>  		blk_queue_max_hw_segments(q, q->max_hw_segments - 1);
> -	}
> +
> +		/* set the min alignment */
> +		blk_queue_update_dma_alignment(sdev->request_queue,
> +					       ATA_DMA_PAD_SZ - 1);
> +	} else
> +		/* ATA devices must be sector aligned */
> +		blk_queue_update_dma_alignment(sdev->request_queue,
> +					       ATA_SECT_SIZE - 1);
>  
>  	if (dev->flags & ATA_DFLAG_AN)
>  		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);

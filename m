From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH rc8-mm1] hotfix libata-scsi corruption
Date: Tue, 22 Jan 2008 15:32:18 -0500
Message-ID: <479652D2.10800@garzik.org>
References: <Pine.LNX.4.64.0801221706320.5832@blonde.site>	 <1201022985.3210.24.camel@localhost.localdomain>	 <Pine.LNX.4.64.0801221813540.8693@blonde.site> <1201031028.3210.61.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1201031028.3210.61.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>, Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
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
> 
> James
> 
> ---
> 
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


ACK

Unlike ATAPI, ATA is indeed all 512-byte alignment transfers (_not_ 
sector size, which may or may not be 512 bytes)

Does this apply to libata?  libata + jejb dma alignment patch?

What tree...

	Jeff




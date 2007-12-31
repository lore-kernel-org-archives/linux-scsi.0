From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/2] relax scsi dma alignment
Date: Mon, 31 Dec 2007 17:57:00 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0712311754240.11410-100000@iolanthe.rowland.org>
References: <1199141005.3110.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:39515 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751085AbXLaW5D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Dec 2007 17:57:03 -0500
In-Reply-To: <1199141005.3110.27.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Kristian Hoegsberg <krh@bitplanet.net>

On Mon, 31 Dec 2007, James Bottomley wrote:

> This patch relaxes the default SCSI DMA alignment from 512 bytes to 4
> bytes.  I remember from previous discussions that usb and firewire have
> sector size alignment requirements, so I upped their alignments in the
> respective slave allocs.
> 
> The reason for doing this is so that we don't get such a huge amount of
> copy overhead in bio_copy_user() for udev.  (basically all inquiries it
> issues can now be directly mapped).

...

> diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
> index 7c9593b..39c03f9 100644
> --- a/drivers/usb/storage/scsiglue.c
> +++ b/drivers/usb/storage/scsiglue.c
> @@ -82,6 +82,12 @@ static int slave_alloc (struct scsi_device *sdev)
>  	sdev->inquiry_len = 36;
>  
>  	/*
> +	 * Update the dma alignment (minimum alignment requirements for
> +	 * start and end of DMA transfers) to be a sector
> +	 */
> +	blk_queue_update_dma_alignment(sdev->request_queue, 511);
> +
> +	/*
>  	 * The UFI spec treates the Peripheral Qualifier bits in an
>  	 * INQUIRY result as reserved and requires devices to set them
>  	 * to 0.  However the SCSI spec requires these bits to be set

It would be better to move the existing code from the start of
slave_configure() up into slave_alloc().  Otherwise it's fine.

Alan Stern


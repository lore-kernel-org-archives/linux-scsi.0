From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fix wrong argument to pci_dma_sync_sg in megaraid driver
Date: 01 Feb 2004 11:16:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075652188.1818.15.camel@mulgrave>
References: <20040201160032.GA14959@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:60834 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265367AbUBAQQi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Feb 2004 11:16:38 -0500
In-Reply-To: <20040201160032.GA14959@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Atulm@lsil.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2004-02-01 at 11:00, Christoph Hellwig wrote:
> sgl is incremented for each element in the routine, but pci_dma_sync_sg
> needs the original buffer.
> 
> 
> --- 1.59/drivers/scsi/megaraid.c	Fri Jan 23 06:37:03 2004
> +++ edited/drivers/scsi/megaraid.c	Sat Jan 31 07:09:25 2004
> @@ -1805,7 +1805,7 @@
>  	*len = (u32)cmd->request_bufflen;
>  
>  	if( scb->dma_direction == PCI_DMA_TODEVICE ) {
> -		pci_dma_sync_sg(adapter->dev, sgl, cmd->use_sg,
> +		pci_dma_sync_sg(adapter->dev, cmd->request_buffer, cmd->use_sg,
>  				PCI_DMA_TODEVICE);
>  	}

Hang on a minute, none of these syncs (including all the other syncs to
and from the device) looks to be necessary.

Once the buffers are mapped, their cache line ownership is transferred
automatically to the device.  Once they are unmapped, it is transferred
back.  There's no need to do additional syncs after mapping and
unmapping *unless* the driver needs to touch the actual data in between
the mapping and the unmapping.  I didn't notice the megaraid actually
doing this (but even if it does, the sync would be in the wrong place).

James



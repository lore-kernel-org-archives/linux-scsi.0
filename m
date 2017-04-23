From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: mvumi: add check for dma mapping errors
Date: Sun, 23 Apr 2017 01:41:33 -0700
Message-ID: <20170423084133.GE30869@infradead.org>
References: <1492816670-25795-1-git-send-email-khoroshilov@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:42657 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1428006AbdDWIlk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Apr 2017 04:41:40 -0400
Content-Disposition: inline
In-Reply-To: <1492816670-25795-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org

On Sat, Apr 22, 2017 at 02:17:50AM +0300, Alexey Khoroshilov wrote:
>  	} else {
> -		scmd->SCp.dma_handle = scsi_bufflen(scmd) ?
> -			pci_map_single(mhba->pdev, scsi_sglist(scmd),
> -				scsi_bufflen(scmd),
> -				(int) scmd->sc_data_direction)
> -			: 0;
> +		if (!scsi_bufflen(scmd))
> +			return -1;
> +		scmd->SCp.dma_handle = pci_map_single(mhba->pdev,
> +						scsi_sglist(scmd),
> +						scsi_bufflen(scmd),
> +						(int) scmd->sc_data_direction);
> +		if (pci_dma_mapping_error(mhba->pdev, scmd->SCp.dma_handle))
> +			return -1;

This looks completely broken.  Why would you DMA map the in-memory
struct scatterlist?  It has no meaning for the hardware.

In fact this whole branch (and the equivalent in the unmap path)
are dead - SCSI commands that transfer data always have a SG entry.

So the right fix is to remove the !scsi_sg_count(scmd) map/unmap
path.

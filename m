From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 12/12] advansys: Update to version 3.5 and remove
	compilation warning
Date: Thu, 4 Dec 2014 10:23:05 +0100
Message-ID: <20141204092305.GA24091@lst.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de> <1417607105-85455-13-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57387 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbaLDJXJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2014 04:23:09 -0500
Content-Disposition: inline
In-Reply-To: <1417607105-85455-13-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

>  /* FIXME:
>   *
> - *  1. Although all of the necessary command mapping places have the
> - *     appropriate dma_map.. APIs, the driver still processes its internal
> - *     queue using bus_to_virt() and virt_to_bus() which are illegal under
> - *     the API.  The entire queue processing structure will need to be
> - *     altered to fix this.
> + *  1. (done)
>   *  2. Need to add memory mapping workaround. Test the memory mapping.
>   *     If it doesn't work revert to I/O port access. Can a test be done
>   *     safely?
>   *  3. Handle an interrupt not working. Keep an interrupt counter in
>   *     the interrupt handler. In the timeout function if the interrupt
>   *     has not occurred then print a message and run in polled mode.
> - *  4. Need to add support for target mode commands, cf. CAM XPT.
> - *  5. check DMA mapping functions for failure
> + *  4. (obsolete)
> + *  5. (done)
>   *  6. Use scsi_transport_spi
>   *  7. advansys_info is not safe against multiple simultaneous callers
>   *  8. Add module_param to override ISA/VLB ioport array


Just drop the done/obsolete items and renumber the rest :)

> +	if (dma_mapping_error(board->dev, scp->SCp.dma_handle)) {
> +		ASC_DBG(1, "failed to map sense buffer\n");
> +		return 0;
> +	}
>  	dma_cache_sync(board->dev, scp->sense_buffer,
>  		       SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
>  	return cpu_to_le32(scp->SCp.dma_handle);
> @@ -7794,6 +7794,8 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
>  	    ASC_TIDLUN_TO_IX(scp->device->id, scp->device->lun);
>  	asc_scsi_q->q1.sense_addr = advansys_get_sense_buffer_dma(scp);
>  	asc_scsi_q->q1.sense_len = SCSI_SENSE_BUFFERSIZE;
> +	if (!asc_scsi_q->q1.sense_addr)
> +		return ASC_ERROR;

Please split the addition of error handling into a separate patch,
or in case of newly added mappigns add them to the patch that add the
mappings.

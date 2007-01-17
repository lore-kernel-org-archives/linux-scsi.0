From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] libata: initialize qc->dma_dir to DMA_NONE
Date: Tue, 16 Jan 2007 21:43:59 -0600
Message-ID: <45AD9B7F.4090608@us.ibm.com>
References: <45AD50AD.2040700@linux.vnet.ibm.com> <20070116224115.50d29cf7@localhost.localdomain> <45AD55A4.50208@pobox.com> <1168989094.2789.20.camel@mulgrave.il.steeleye.com> <45AD5D27.8020004@linux.vnet.ibm.com> <45AD60B9.3030501@linux.vnet.ibm.com> <20070117023402.GP10987@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:53376 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbXAQDo7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jan 2007 22:44:59 -0500
In-Reply-To: <20070117023402.GP10987@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@SteelEye.com>, Alan <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>

ACK

Tejun Heo wrote:
> libata didn't used to init qc->dma_dir to any specific value on qc
> initialization and command translation path didn't set qc->dma_dir if
> the command doesn't need data transfer.  This made non-data commands
> to have random qc->dma_dir.
> 
> This usually doesn't cause problem because LLDs usually check
> qc->protocol first and look at qc->dma_dir iff the command needs data
> transfer but this doesn't hold for all LLDs.
> 
> It might be worthwhile to rename qc->dma_dir to qc->data_dir as we use
> the field to tag data direction for both PIO and DMA protocols.
> 
> This problem has been spotted by James Bottomley.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: James Bottomley <James.Bottomley@SteelEye.com>
> 
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 7cfc18f..925ad7f 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -1139,6 +1139,7 @@ static inline void ata_tf_init(struct ata_device *dev, struct ata_taskfile *tf)
> 
>  static inline void ata_qc_reinit(struct ata_queued_cmd *qc)
>  {
> +	qc->dma_dir = DMA_NONE;
>  	qc->__sg = NULL;
>  	qc->flags = 0;
>  	qc->cursect = qc->cursg = qc->cursg_ofs = 0;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

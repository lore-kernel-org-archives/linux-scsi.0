From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/11]: megaraid_sas: Add MegaRAID 9265/9285 specific
 functions: megaraid_sas_fusion.c
Date: Tue, 21 Dec 2010 15:28:10 -0500
Message-ID: <20101221202810.GB15750@infradead.org>
References: <AANLkTik1KwdG+73gWCqGj7sROdxWfBYfKqH4t=rcQkhi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52602 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab0LUU2L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Dec 2010 15:28:11 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTik1KwdG+73gWCqGj7sROdxWfBYfKqH4t=rcQkhi@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

> +/* Fusion OCR work queue */
> +void megasas_fusion_ocr_wq(struct work_struct *work)
> +{
> +	struct megasas_instance *instance =
> +		container_of(work, struct megasas_instance, work_init);
> +	struct scsi_cmnd scmd;
> +	struct scsi_device dev;
> +
> +	scmd.device = &dev;
> +	dev.host = instance->host;
> +	megasas_reset_fusion(&scmd);
> +}

You should never allocate the scsi midlayer structures yourself,
nevermind on stack.  It seems like you want a version of
megasas_reset_fusion that just takes a scsi host and call it both from
the work queue and the EH handler.

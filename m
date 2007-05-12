From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/19] add data buffer accessors
Date: Sat, 12 May 2007 16:31:51 +0100
Message-ID: <20070512153151.GB8088@infradead.org>
References: <20070512182805L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:58951 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbXELPbx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 11:31:53 -0400
Content-Disposition: inline
In-Reply-To: <20070512182805L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, hch@infradead.org

> +int scsi_dma_map(struct device *dev, struct scsi_cmnd *cmd)
> +{
> +	int nseg = 0;
> +
> +	if (cmd->use_sg) {
> +		struct scatterlist *sg =
> +			(struct scatterlist *) cmd->request_buffer;
> +
> +		nseg = dma_map_sg(dev, sg, cmd->use_sg, cmd->sc_data_direction);
> +		if (unlikely(!nseg))
> +			return -ENOMEM;
> +	}
> +	return nseg;
> +}
> +EXPORT_SYMBOL(scsi_dma_map);

As James already said the device argument should not be needed at all.
Also please add kerneldoc comment describing exported functions.


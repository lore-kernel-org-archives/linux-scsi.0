From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/19] add data buffer accessors
Date: Sat, 12 May 2007 09:38:48 -0500
Message-ID: <1178980728.3723.8.camel@mulgrave.il.steeleye.com>
References: <20070512182805L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:56760 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754285AbXELOi6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 10:38:58 -0400
In-Reply-To: <20070512182805L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, hch@infradead.org

On Sat, 2007-05-12 at 19:05 +0900, FUJITA Tomonori wrote:
> Add a set of accessors for the scsi data buffer. This is in
> preparation for chaining sg lists and bidirectional requests (and
> possibly, the mid-layer dma mapping).
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/scsi_lib.c  |   26 ++++++++++++++++++++++++++
>  include/scsi/scsi_cmnd.h |   11 +++++++++++
>  2 files changed, 37 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 1f5a07b..a2ebe61 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2290,3 +2290,29 @@ void scsi_kunmap_atomic_sg(void *virt)
>  	kunmap_atomic(virt, KM_BIO_SRC_IRQ);
>  }
>  EXPORT_SYMBOL(scsi_kunmap_atomic_sg);
> +
> +int scsi_dma_map(struct device *dev, struct scsi_cmnd *cmd)

Actually, this is redundant.  We make sure the
shost->shost_gendev.parent is the device which should have been passed
in to scsi_add_host().

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
> +
> +void scsi_dma_unmap(struct device *dev, struct scsi_cmnd *cmd)

Same here.

James



From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 2/3] scsi_debug: add bidi data transfer support
Date: Wed, 23 Jan 2008 00:11:36 +0100
Message-ID: <47967828.1050804@torque.net>
References: <20080123013012N.tomof@acm.org> <20080123013109J.tomof@acm.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:58409 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbYAVXLt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jan 2008 18:11:49 -0500
In-Reply-To: <20080123013109J.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, Jens.Axboe@oracle.com

FUJITA Tomonori wrote:
> This enables fill_from_dev_buffer and fetch_to_dev_buffer to handle
> bidi commands.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/scsi_debug.c |   21 ++++++++++-----------
>  1 files changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 31f7378..d810aa7 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -594,18 +594,18 @@ static int fill_from_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
>  	int k, req_len, act_len, len, active;
>  	void * kaddr;
>  	void * kaddr_off;
> -	struct scatterlist * sg;
> +	struct scatterlist *sg;
> +	struct scsi_data_buffer *sdb = scsi_in(scp);
>  
> -	if (0 == scsi_bufflen(scp))
> +	if (!sdb->length)
>  		return 0;
> -	if (NULL == scsi_sglist(scp))
> +	if (!sdb->table.sgl)
>  		return (DID_ERROR << 16);
> -	if (! ((scp->sc_data_direction == DMA_BIDIRECTIONAL) ||
> -	      (scp->sc_data_direction == DMA_FROM_DEVICE)))
> +	if (!(scsi_bidi_cmnd(scp) || scp->sc_data_direction == DMA_FROM_DEVICE))
>  		return (DID_ERROR << 16);
>  	active = 1;
>  	req_len = act_len = 0;
> -	scsi_for_each_sg(scp, sg, scsi_sg_count(scp), k) {
> +	for_each_sg(sdb->table.sgl, sg, sdb->table.nents, k) {
>  		if (active) {
>  			kaddr = (unsigned char *)
>  				kmap_atomic(sg_page(sg), KM_USER0);
> @@ -623,10 +623,10 @@ static int fill_from_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
>  		}
>  		req_len += sg->length;
>  	}
> -	if (scsi_get_resid(scp))
> -		scsi_set_resid(scp, scsi_get_resid(scp) - act_len);
> +	if (sdb->resid)
> +		sdb->resid -= act_len;
>  	else
> -		scsi_set_resid(scp, req_len - act_len);
> +		sdb->resid = req_len - act_len;
>  	return 0;
>  }
>  
> @@ -643,8 +643,7 @@ static int fetch_to_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
>  		return 0;
>  	if (NULL == scsi_sglist(scp))
>  		return -1;
> -	if (! ((scp->sc_data_direction == DMA_BIDIRECTIONAL) ||
> -	      (scp->sc_data_direction == DMA_TO_DEVICE)))
> +	if (!(scsi_bidi_cmnd(scp) || scp->sc_data_direction == DMA_TO_DEVICE))
>  		return -1;
>  	req_len = fin = 0;
>  	scsi_for_each_sg(scp, sg, scsi_sg_count(scp), k) {

Signed-off-by: Douglas Gilbert <dougg@torque.net>


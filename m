From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] ib_srp: initialize dma_length in srp_map_idb
Date: Sun, 15 Nov 2015 20:20:51 +0200
Message-ID: <5648CD03.4000206@dev.mellanox.co.il>
References: <1447610393-2899-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:38210 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbbKOSU5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2015 13:20:57 -0500
Received: by wmec201 with SMTP id c201so91830432wme.1
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2015 10:20:55 -0800 (PST)
In-Reply-To: <1447610393-2899-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org



On 15/11/2015 19:59, Christoph Hellwig wrote:
> Without this sg_dma_len will return 0 on architectures tha have
> the dma_length field.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 32f7962..445c0a6 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1520,6 +1520,9 @@ static int srp_map_idb(struct srp_rdma_ch *ch, struct srp_request *req,
>   		state.sg_nents = 1;
>   		sg_set_buf(idb_sg, req->indirect_desc, idb_len);
>   		idb_sg->dma_address = req->indirect_dma_addr; /* hack! */
> +#ifdef CONFIG_NEED_SG_DMA_LENGTH
> +		idb_sg->dma_length = idb_sg->length;	      /* hack^2 */
> +#endif

:)

We should really get this properly map/unmap per IO at some point.
Probably do it in both code paths...

Having said that,

Looks fine,

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>

From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH 08/11] IB/iser: Support T10-PI operations
Date: Sun, 23 Feb 2014 22:50:04 -0800
Message-ID: <1393224604.22656.16.camel@haakon3.risingtidesystems.com>
References: <1393157974-24931-1-git-send-email-sagig@mellanox.com>
	 <1393157974-24931-9-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393157974-24931-9-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2014-02-23 at 14:19 +0200, Sagi Grimberg wrote:
> Add logic to initialize protection information entities.
> Upon each iSCSI task, we keep the scsi_cmnd in order to
> query the scsi protection operations and reference to
> protection buffers.
> 
> Modify iser_fast_reg_mr to receive indication weather it
> is registering the data or protection buffers.
> 
> In addition Introduce iser_reg_sig_mr which performs fast
> registration work-request for a signature enabled memory region
> (IB_WR_REG_SIG_MR). In this routine we set all the protection
> relevants for the device to offload protection data-transfer
> and verification.
> 
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/ulp/iser/iscsi_iser.c     |    2 +
>  drivers/infiniband/ulp/iser/iscsi_iser.h     |    8 +
>  drivers/infiniband/ulp/iser/iser_initiator.c |   41 ++++-
>  drivers/infiniband/ulp/iser/iser_memory.c    |  255 +++++++++++++++++++++++---
>  4 files changed, 280 insertions(+), 26 deletions(-)
> 

<SNIP>

> diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
> index 3edab18..9729aae 100644
> --- a/drivers/infiniband/ulp/iser/iser_memory.c
> +++ b/drivers/infiniband/ulp/iser/iser_memory.c

<SNIP>

> @@ -471,35 +646,42 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
>  		return 0;
>  	}
>  
> -	plen = iser_sg_to_page_vec(mem, device->ib_device,
> -				   desc->data_frpl->page_list,
> +	if (ind == ISER_DATA_KEY_VALID) {
> +		mr = desc->data_mr;
> +		frpl = desc->data_frpl;
> +	} else {
> +		mr = desc->pi_ctx->prot_mr;
> +		frpl = desc->pi_ctx->prot_frpl;
> +	}
> +
> +	plen = iser_sg_to_page_vec(mem, device->ib_device, frpl->page_list,
>  				   &offset, &size);
>  	if (plen * SIZE_4K < size) {
>  		iser_err("fast reg page_list too short to hold this SG\n");
>  		return -EINVAL;
>  	}
>  
> -	if (!(desc->reg_indicators & ISER_DATA_KEY_VALID)) {
> +	if (!(desc->reg_indicators & ind)) {
>  		memset(&inv_wr, 0, sizeof(inv_wr));
>  		inv_wr.wr_id = ISER_FRWR_LI_WRID;
>  		inv_wr.opcode = IB_WR_LOCAL_INV;
> -		inv_wr.ex.invalidate_rkey = desc->data_mr->rkey;
> +		inv_wr.ex.invalidate_rkey = mr->rkey;
>  		wr = &inv_wr;
>  		/* Bump the key */
> -		key = (u8)(desc->data_mr->rkey & 0x000000FF);
> -		ib_update_fast_reg_key(desc->data_mr, ++key);
> +		key = (u8)(mr->rkey & 0x000000FF);
> +		ib_update_fast_reg_key(mr, ++key);
>  	}
>  
>  	/* Prepare FASTREG WR */
>  	memset(&fastreg_wr, 0, sizeof(fastreg_wr));
>  	fastreg_wr.wr_id = ISER_FRWR_LI_WRID;
>  	fastreg_wr.opcode = IB_WR_FAST_REG_MR;
> -	fastreg_wr.wr.fast_reg.iova_start = desc->data_frpl->page_list[0] + offset;
> -	fastreg_wr.wr.fast_reg.page_list = desc->data_frpl;
> +	fastreg_wr.wr.fast_reg.iova_start = frpl->page_list[0] + offset;
> +	fastreg_wr.wr.fast_reg.page_list = frpl;
>  	fastreg_wr.wr.fast_reg.page_list_len = plen;
>  	fastreg_wr.wr.fast_reg.page_shift = SHIFT_4K;
>  	fastreg_wr.wr.fast_reg.length = size;
> -	fastreg_wr.wr.fast_reg.rkey = desc->data_mr->rkey;
> +	fastreg_wr.wr.fast_reg.rkey = mr->rkey;
>  	fastreg_wr.wr.fast_reg.access_flags = (IB_ACCESS_LOCAL_WRITE  |
>  					       IB_ACCESS_REMOTE_WRITE |
>  					       IB_ACCESS_REMOTE_READ);

This one did not apply on v3.14-rc2 either.  Fixed up the context
change.

Please verify this patch in target-pending/rdma-dif is what you expect.

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

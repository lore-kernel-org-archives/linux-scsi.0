From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] ib_srp: initialize dma_length in srp_map_idb
Date: Mon, 16 Nov 2015 09:16:06 -0800
Message-ID: <564A0F56.8060408@sandisk.com>
References: <1447610393-2899-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447610393-2899-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 11/15/2015 09:59 AM, Christoph Hellwig wrote:
> Without this sg_dma_len will return 0 on architectures tha have
> the dma_length field.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
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
>   		ret = srp_map_finish_fr(&state, ch);
>   		if (ret < 0)
>   			return ret;
>

Hello Christoph,

How about adding "Cc: stable" to this patch such that it not only will 
be integrated in kernel v4.4 but also in kernel v4.3.1 or later ?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

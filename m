From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] IB/iser: do I/O path allocations with GFP_NOIO
Date: Tue, 30 May 2006 14:50:44 -0500
Message-ID: <447CA214.7010202@cs.wisc.edu>
References: <Pine.LNX.4.64.0605301448001.734@zuben>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56250 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932441AbWE3Tpe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 May 2006 15:45:34 -0400
In-Reply-To: <Pine.LNX.4.64.0605301448001.734@zuben>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Or Gerlitz <ogerlitz@voltaire.com>
Cc: rdreier@cisco.com, openib-general@openib.org, linux-scsi@vger.kernel.org

Should iser patches have linux-scsi ccd on them in the future? And
should they go through the scsi maintainer normally (I understand they
cannot now since James does not have all the infinniband bits)? I am
really just trying to avoid any coordinatation issues that come about by
having core iscsi and tcp iscsi patched sent to the scsi maintainer then
having to have iser going through Roland.

For example I left a bit in the core iscsi code so I would not break
iser. Now iser is updating their code, so we do not need that bit, but
Or's patch missed the cleanup. If we sent everything through one
maintainer then we could have cleaned everything up in one pass.

Does srp go from openib-general and Roland then to lkml? For iscsi we do
not go through net-dev and we live in drivers/scsi so maybe we are the
odd driver?:) What is the proper or normal procedure?





Or Gerlitz wrote:
> Thanks for Mike Christie for pointing this out - Or.
> 
> a block driver is not allowed to use GFP_KERNEL allocations on its I/O code
> path since the allocation might require I/O (eg to pageout other memory),
> resulting in either deadlock or tightloop.
> 
> move I/O path (queuecommand) allocations to be done with GFP_NOIO
> 
> Signed-off-by: Or Gerlitz <ogerlitz@voltaire.com>
> 
> diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
> index 2703bb0..073e7b5 100644
> --- a/drivers/infiniband/ulp/iser/iser_initiator.c
> +++ b/drivers/infiniband/ulp/iser/iser_initiator.c
> @@ -225,7 +225,7 @@ static int iser_post_receive_control(str
>  	struct iser_device  *device = iser_conn->ib_conn->device;
>  	int rx_data_size, err = 0;
> 
> -	rx_desc = kmem_cache_alloc(ig.desc_cache, GFP_KERNEL);
> +	rx_desc = kmem_cache_alloc(ig.desc_cache, GFP_NOIO);
>  	if (rx_desc == NULL) {
>  		iser_err("Failed to alloc desc for post recv\n");
>  		return -ENOMEM;
> @@ -238,7 +238,7 @@ static int iser_post_receive_control(str
>  	else /* FIXME till user space sets conn->max_recv_dlength correctly */
>  		rx_data_size = 128;
> 
> -	rx_desc->data = kmalloc(rx_data_size, GFP_KERNEL);
> +	rx_desc->data = kmalloc(rx_data_size, GFP_NOIO);
>  	if (rx_desc->data == NULL) {
>  		iser_err("Failed to alloc data buf for post recv\n");
>  		err = -ENOMEM;
> @@ -467,7 +467,7 @@ int iser_send_data_out(struct iscsi_conn
>  	iser_dbg("%s itt %d dseg_len %d offset %d\n",
>  		 __func__,(int)itt,(int)data_seg_len,(int)buf_offset);
> 
> -	tx_desc = kmem_cache_alloc(ig.desc_cache, GFP_KERNEL);
> +	tx_desc = kmem_cache_alloc(ig.desc_cache, GFP_NOIO);
>  	if (tx_desc == NULL) {
>  		iser_err("Failed to alloc desc for post dataout\n");
>  		return -ENOMEM;
> diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
> index 0881f55..31950a5 100644
> --- a/drivers/infiniband/ulp/iser/iser_memory.c
> +++ b/drivers/infiniband/ulp/iser/iser_memory.c
> @@ -111,10 +111,10 @@ int iser_start_rdma_unaligned_sg(struct
>  	unsigned long  cmd_data_len = data->data_len;
> 
>  	if (cmd_data_len > ISER_KMALLOC_THRESHOLD)
> -		mem = (void *)__get_free_pages(GFP_KERNEL,
> +		mem = (void *)__get_free_pages(GFP_NOIO,
>  		      long_log2(roundup_pow_of_two(cmd_data_len)) - PAGE_SHIFT);
>  	else
> -		mem = kmalloc(cmd_data_len, GFP_KERNEL);
> +		mem = kmalloc(cmd_data_len, GFP_NOIO);
> 
>  	if (mem == NULL) {
>  		iser_err("Failed to allocate mem size %d %d for copying sglist\n",


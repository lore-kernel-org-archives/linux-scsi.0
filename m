Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA7E9C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Mar 2022 15:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbiCCPUg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Mar 2022 10:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234358AbiCCPUf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2022 10:20:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D293B191434
        for <linux-scsi@vger.kernel.org>; Thu,  3 Mar 2022 07:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646320788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JiTqpFf8iibOETp4YcIF8zvDIHUvovReUvwUvjk3NUM=;
        b=A4h0+yFqkTyPpycBqButYkI7JaEy1LckenmtVSrZogZp3KnmDM25DZoomuxsH2RLVlzPPZ
        /ZwBbnwHPsI2bRUMRob8u+29PXvxLkc4d0CR8UXz3UB8gCI8o8+cMhVLHvtjNF6Yfvs6HZ
        eeJn/yEGHL51FWrusVFIM7Dkb1AK6Gs=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-m5ZT04z4P3OKevmZafHe9w-1; Thu, 03 Mar 2022 10:19:47 -0500
X-MC-Unique: m5ZT04z4P3OKevmZafHe9w-1
Received: by mail-oi1-f198.google.com with SMTP id h25-20020a056808015900b002d6048692beso3370273oie.8
        for <linux-scsi@vger.kernel.org>; Thu, 03 Mar 2022 07:19:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JiTqpFf8iibOETp4YcIF8zvDIHUvovReUvwUvjk3NUM=;
        b=TaSmE2pKPvIZDdZKTkos+q/6NBYFvpKgoyGMzE4JYHEmtct+lCbz6l5pJpM03eYv4P
         HZ+GtWO7wYt1RDjcV2UkIbSC7JsUcnyK95NFlRoGLoPcTNdUQnpN1kVKUf+Xld7eqRPQ
         y6ZjFen+KHIpoCybOupQ516nmWBt3an5hiP8pNaeBVrqKjTwknli6BPK/lN9ApApT27C
         C61qgJaCwO/0nMnYvO0A0euqPdbBJG+n6VC9d5W5QGgOnNyskNsEA+J5deUkMCv5qp2a
         a7wEW5V6hJ+9dCbYp9IYgTnntkp3cnw83/dN7eqfJGptKrXoDCbAD+oqU7itBVnbkfip
         Z9eA==
X-Gm-Message-State: AOAM531tvNojIyNRoHBXsqend8b0V3uONmi2SX2iPK+8R3Qma/C7fAuC
        2zkJtFu9BB+U3s/KovDdbZKiBpA675wn5Ta1b4eCcNOQfeX/0/EyKkUEdVOxKnpmnWYGpRHWAYX
        RH81qcGMiuY7tF9yEKrHjPA==
X-Received: by 2002:a4a:98b0:0:b0:320:5a26:c989 with SMTP id a45-20020a4a98b0000000b003205a26c989mr4838731ooj.62.1646320786577;
        Thu, 03 Mar 2022 07:19:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzXZEVn7VD5pmB/va9xOv28qHh5UA+wI6Kav+zC35Cm3JZwtI+ktff80uFmuMaQ64uANjAmeA==
X-Received: by 2002:a4a:98b0:0:b0:320:5a26:c989 with SMTP id a45-20020a4a98b0000000b003205a26c989mr4838710ooj.62.1646320786194;
        Thu, 03 Mar 2022 07:19:46 -0800 (PST)
Received: from loberhel ([2600:6c64:4e7f:cee0:729d:61b6:700c:6b56])
        by smtp.gmail.com with ESMTPSA id b15-20020a05687061cf00b000d17a5f0ee6sm1195882oah.11.2022.03.03.07.19.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Mar 2022 07:19:45 -0800 (PST)
Message-ID: <00bb164a30a71be8becc1101d8929d633694e8dd.camel@redhat.com>
Subject: Re: [PATCH] mpt3sas: Fix incorrect 4gb boundary check
From:   Laurence Oberman <loberman@redhat.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com
Date:   Thu, 03 Mar 2022 10:19:44 -0500
In-Reply-To: <20220303140230.13098-1-sreekanth.reddy@broadcom.com>
References: <20220303140230.13098-1-sreekanth.reddy@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2022-03-03 at 19:32 +0530, Sreekanth Reddy wrote:
> Driver has to do a 4gb boundary check using the pool's
> dma address instead of using a virtual address.
> 
> Fixes: d6adc251dd2f("mpt3sas: Force PCIe scatterlist allocations to
> be within same 4 GB region")
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 25 ++++++++++++-------------
>  1 file changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c
> b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index ebb61b47dc2f..a10ceaa8f881 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -5723,14 +5723,13 @@ _base_release_memory_pools(struct
> MPT3SAS_ADAPTER *ioc)
>   */
>  
>  static int
> -mpt3sas_check_same_4gb_region(long reply_pool_start_address, u32
> pool_sz)
> +mpt3sas_check_same_4gb_region(dma_addr_t start_address, u32 pool_sz)
>  {
> -	long reply_pool_end_address;
> +	dma_addr_t end_address;
>  
> -	reply_pool_end_address = reply_pool_start_address + pool_sz;
> +	end_address = start_address + pool_sz - 1;
>  
> -	if (upper_32_bits(reply_pool_start_address) ==
> -		upper_32_bits(reply_pool_end_address))
> +	if (upper_32_bits(start_address) == upper_32_bits(end_address))
>  		return 1;
>  	else
>  		return 0;
> @@ -5791,7 +5790,7 @@ _base_allocate_pcie_sgl_pool(struct
> MPT3SAS_ADAPTER *ioc, u32 sz)
>  		}
>  
>  		if (!mpt3sas_check_same_4gb_region(
> -		    (long)ioc->pcie_sg_lookup[i].pcie_sgl, sz)) {
> +		    ioc->pcie_sg_lookup[i].pcie_sgl_dma, sz)) {
>  			ioc_err(ioc, "PCIE SGLs are not in same 4G !!
> pcie sgl (0x%p) dma = (0x%llx)\n",
>  			    ioc->pcie_sg_lookup[i].pcie_sgl,
>  			    (unsigned long long)
> @@ -5846,8 +5845,8 @@ _base_allocate_chain_dma_pool(struct
> MPT3SAS_ADAPTER *ioc, u32 sz)
>  			    GFP_KERNEL, &ctr->chain_buffer_dma);
>  			if (!ctr->chain_buffer)
>  				return -EAGAIN;
> -			if (!mpt3sas_check_same_4gb_region((long)
> -			    ctr->chain_buffer, ioc->chain_segment_sz))
> {
> +			if (!mpt3sas_check_same_4gb_region(
> +			    ctr->chain_buffer_dma, ioc-
> >chain_segment_sz)) {
>  				ioc_err(ioc,
>  				    "Chain buffers are not in same 4G
> !!! Chain buff (0x%p) dma = (0x%llx)\n",
>  				    ctr->chain_buffer,
> @@ -5883,7 +5882,7 @@ _base_allocate_sense_dma_pool(struct
> MPT3SAS_ADAPTER *ioc, u32 sz)
>  	    GFP_KERNEL, &ioc->sense_dma);
>  	if (!ioc->sense)
>  		return -EAGAIN;
> -	if (!mpt3sas_check_same_4gb_region((long)ioc->sense, sz)) {
> +	if (!mpt3sas_check_same_4gb_region(ioc->sense_dma, sz)) {
>  		dinitprintk(ioc, pr_err(
>  		    "Bad Sense Pool! sense (0x%p) sense_dma =
> (0x%llx)\n",
>  		    ioc->sense, (unsigned long long) ioc->sense_dma));
> @@ -5916,7 +5915,7 @@ _base_allocate_reply_pool(struct
> MPT3SAS_ADAPTER *ioc, u32 sz)
>  	    &ioc->reply_dma);
>  	if (!ioc->reply)
>  		return -EAGAIN;
> -	if (!mpt3sas_check_same_4gb_region((long)ioc->reply_free, sz))
> {
> +	if (!mpt3sas_check_same_4gb_region(ioc->reply_dma, sz)) {
>  		dinitprintk(ioc, pr_err(
>  		    "Bad Reply Pool! Reply (0x%p) Reply dma =
> (0x%llx)\n",
>  		    ioc->reply, (unsigned long long) ioc->reply_dma));
> @@ -5951,7 +5950,7 @@ _base_allocate_reply_free_dma_pool(struct
> MPT3SAS_ADAPTER *ioc, u32 sz)
>  	    GFP_KERNEL, &ioc->reply_free_dma);
>  	if (!ioc->reply_free)
>  		return -EAGAIN;
> -	if (!mpt3sas_check_same_4gb_region((long)ioc->reply_free, sz))
> {
> +	if (!mpt3sas_check_same_4gb_region(ioc->reply_free_dma, sz)) {
>  		dinitprintk(ioc,
>  		    pr_err("Bad Reply Free Pool! Reply Free (0x%p)
> Reply Free dma = (0x%llx)\n",
>  		    ioc->reply_free, (unsigned long long) ioc-
> >reply_free_dma));
> @@ -5990,7 +5989,7 @@ _base_allocate_reply_post_free_array(struct
> MPT3SAS_ADAPTER *ioc,
>  	    GFP_KERNEL, &ioc->reply_post_free_array_dma);
>  	if (!ioc->reply_post_free_array)
>  		return -EAGAIN;
> -	if (!mpt3sas_check_same_4gb_region((long)ioc-
> >reply_post_free_array,
> +	if (!mpt3sas_check_same_4gb_region(ioc-
> >reply_post_free_array_dma,
>  	    reply_post_free_array_sz)) {
>  		dinitprintk(ioc, pr_err(
>  		    "Bad Reply Free Pool! Reply Free (0x%p) Reply Free
> dma = (0x%llx)\n",
> @@ -6055,7 +6054,7 @@ base_alloc_rdpq_dma_pool(struct MPT3SAS_ADAPTER
> *ioc, int sz)
>  			 * resources and set DMA mask to 32 and
> allocate.
>  			 */
>  			if (!mpt3sas_check_same_4gb_region(
> -				(long)ioc-
> >reply_post[i].reply_post_free, sz)) {
> +				ioc->reply_post[i].reply_post_free_dma, 
> sz)) {
>  				dinitprintk(ioc,
>  				    ioc_err(ioc, "bad Replypost free
> pool(0x%p)"
>  				    "reply_post_free_dma = (0x%llx)\n",

Please add
Suggested-by: David Jeffery <djeffery@redhat.com>


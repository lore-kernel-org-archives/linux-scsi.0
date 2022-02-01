Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 184CBC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 12:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238159AbiBAMg6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 07:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237946AbiBAMgz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 07:36:55 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0977AC06173B
        for <linux-scsi@vger.kernel.org>; Tue,  1 Feb 2022 04:36:55 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id 13so14864607qkd.13
        for <linux-scsi@vger.kernel.org>; Tue, 01 Feb 2022 04:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nskeSRiBDGoJdBUOhSRpII4ymRQB/RCZW6MS1+0kpvM=;
        b=mDPlLjNErpVCtqtsADancFzkLBmw2S+bXBPoILSGxKLUJz63L0rtVX0E+uIJ1BQJPm
         DIW4sRvonVCFjMNv7tIo0KxFmA4JIWX+ABxVtU7ZqLLWFK//4u162OThrMYofKmZmy9l
         V2Nebp/Km4rhU1Db/RMAmSdEx77JIzmUH66hvegpy6x/gVRKcfFJG/z8FfLCvmKVLAhu
         KNEA8/5zU06Vfj9WX4R7G7s9Gz6+WBE/QQp3VKlyjg0qHv54Y0mdPqSOg9VNeUxY3YxO
         E+DbwtOd7I004ecGyetRUm2jOLjIkMRTL9SxchLuW1/3XM+Xl6r/FN63oYZqis3jpxNx
         q4AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nskeSRiBDGoJdBUOhSRpII4ymRQB/RCZW6MS1+0kpvM=;
        b=KNAQdBll7fuxV4qIZGPuJM1w5nm52ev7NOjV4Cv6bFuKIaGGVTpWzNjMJLPEPJx+09
         YTjK2ATb3xZ+1dh0BKKMkwrwEhcdGbZVsTSlKuXOykhr/j0/Rtcu+EVHGsO5msr8WOEd
         uN0H9MppNj/w3RcCf0Aac3rUrkbe2/xFmeHIsrS29XH45IVNi5smBp5zEK09S84rvGbF
         10pqjw7ib3Vz7GuDrQosgcYy3wGWH3TtYgjJJVO3PKmdOO5uO8wvi3GSlFqwnXhIiiGL
         lE1ph71R/BKwFMfvOmlMYw3ABJL4eEkMeNk8KzCZHwu6DBO0t0sHdy7UCKSby1MDSBV0
         MqSw==
X-Gm-Message-State: AOAM530xsUzWiPpy7ZNnyiBmzJeNCbGaGnAYVsGuHKfyqtsfA38al49p
        BSBd/WpwYSwJVux3lZ5rpsEtW4/4JTFB8A==
X-Google-Smtp-Source: ABdhPJy8a1by7jIsBADUNDKiXTVedVbFSBvgzztZ25yKMzc7Lw3UMCCBlQ3EYyDDmoD2PL87m7SIzg==
X-Received: by 2002:a05:620a:40c5:: with SMTP id g5mr16227786qko.139.1643719014182;
        Tue, 01 Feb 2022 04:36:54 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id 16sm3216564qty.86.2022.02.01.04.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 04:36:53 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1nEsOy-00A73m-Vh; Tue, 01 Feb 2022 08:36:52 -0400
Date:   Tue, 1 Feb 2022 08:36:52 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, Bodo Stroesser <bostroesser@gmail.com>
Subject: Re: [PATCH v7 1/4] sgl_alloc_order: remove 4 GiB limit
Message-ID: <20220201123652.GA8034@ziepe.ca>
References: <20220201034915.183117-1-dgilbert@interlog.com>
 <20220201034915.183117-2-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201034915.183117-2-dgilbert@interlog.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 31, 2022 at 10:49:12PM -0500, Douglas Gilbert wrote:
> This patch fixes a check done by sgl_alloc_order() before it starts
> any allocations. The comment in the original said: "Check for integer
> overflow" but the right hand side of the expression in the condition
> is resolved as u32 so it can not exceed UINT32_MAX (4 GiB) which
> means 'length' can not exceed that value.
> 
> This function may be used to replace vmalloc(unsigned long) for a
> large allocation (e.g. a ramdisk). vmalloc has no limit at 4 GiB so
> it seems unreasonable that sgl_alloc_order() whose length type is
> unsigned long long should be limited to 4 GB.
> 
> In early 2021 there was discussion between Jason Gunthorpe
> <jgg@ziepe.ca> and Bodo Stroesser <bostroesser@gmail.com> about the
> way to check for overflow caused by order (an exponent) being
> too large. Take the solution proposed by Bodo in post dated
> 20210118 to the linux-scsi and linux-block lists.
> 
> An earlier patch fixed a memory leak in sg_alloc_order() due to the
> misuse of sgl_free(). Take the opportunity to put a one line comment
> above sgl_free()'s declaration warning that it is not suitable when
> order > 0 .
> 
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>  include/linux/scatterlist.h |  1 +
>  lib/scatterlist.c           | 24 +++++++++++++-----------
>  2 files changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index 7ff9d6386c12..03130be581bb 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -357,6 +357,7 @@ struct scatterlist *sgl_alloc(unsigned long long length, gfp_t gfp,
>  			      unsigned int *nent_p);
>  void sgl_free_n_order(struct scatterlist *sgl, int nents, int order);
>  void sgl_free_order(struct scatterlist *sgl, int order);
> +/* Only use sgl_free() when order is 0 */
>  void sgl_free(struct scatterlist *sgl);
>  #endif /* CONFIG_SGL_ALLOC */
>  
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index d5e82e4a57ad..ed6d0465c78e 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -585,13 +585,16 @@ EXPORT_SYMBOL(sg_alloc_table_from_pages_segment);
>  #ifdef CONFIG_SGL_ALLOC
>  
>  /**
> - * sgl_alloc_order - allocate a scatterlist and its pages
> + * sgl_alloc_order - allocate a scatterlist with equally sized elements each
> + *		     of which has 2^@order continuous pages
>   * @length: Length in bytes of the scatterlist. Must be at least one
> - * @order: Second argument for alloc_pages()
> + * @order:  Second argument for alloc_pages(). Each sgl element size will
> + *	    be (PAGE_SIZE*2^@order) bytes. @order must not exceed 16.
>   * @chainable: Whether or not to allocate an extra element in the scatterlist
> - *	for scatterlist chaining purposes
> + *	       for scatterlist chaining purposes
>   * @gfp: Memory allocation flags
> - * @nent_p: [out] Number of entries in the scatterlist that have pages
> + * @nent_p: [out] Number of entries in the scatterlist that have pages.
> + *		  Ignored if @nent_p is NULL.
>   *
>   * Returns: A pointer to an initialized scatterlist or %NULL upon failure.
>   */
> @@ -604,16 +607,15 @@ struct scatterlist *sgl_alloc_order(unsigned long long length,
>  	unsigned int nent, nalloc;
>  	u32 elem_len;
>  
> -	nent = round_up(length, PAGE_SIZE << order) >> (PAGE_SHIFT + order);
> -	/* Check for integer overflow */
> -	if (length > (nent << (PAGE_SHIFT + order)))
> +	if (length >> (PAGE_SHIFT + order) >= UINT_MAX)
>  		return NULL;
> -	nalloc = nent;
> +	nent = DIV_ROUND_UP(length, PAGE_SIZE << order);
> +

This would be clearer to make nent/etc an unsigned long long. Then
check if nalloc is > SIZE_MAX before casting it to size_t for the
allocation. Avoids the wonky if statement.

Kaspm

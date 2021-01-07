Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD46C4332D
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 17:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5774D233FB
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 17:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbhAGRoy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 12:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728201AbhAGRox (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 12:44:53 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3FBC0612F9
        for <linux-scsi@vger.kernel.org>; Thu,  7 Jan 2021 09:44:13 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id p14so6155383qke.6
        for <linux-scsi@vger.kernel.org>; Thu, 07 Jan 2021 09:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lHNm8uDmPy3iG7VP+rZSrjxlKRFNIPZy9iz2Yh/Sa+s=;
        b=DilJRgOjUGCkNxVbxqaEZR1cwZNNstBr627PIcTB9nAkNhFIAEdj2KP9O/SRdV1mTy
         fwsNq4eEp0F+MGgRKtNUHxsis3IsLDldIIGRF9oAp4kxNykVi2lUkquJNA3T8hZ8Y0S5
         BKEOlaehVFxfM/tqZ4q+TczmHy6izyRHS5wE/oLZtnlcdKbSvT5M8372+4oNafqS+J0c
         VbyMm00QdGgQ9hCdLJqY2hsPbrzaX+gJDeCGl6JjEHQE3ivIvZX2YeuEZjhb55hhBsEw
         O4EbR0zCO3kQRe/EiyZJNsaQLjfohF5vzinPCUFyJHNbCPwwG/MbuMJNcQcpI4/Yia9h
         tn2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lHNm8uDmPy3iG7VP+rZSrjxlKRFNIPZy9iz2Yh/Sa+s=;
        b=sGBQZCIvrhUwNwHvzdzPrfwNYXjfWulEcyzb6DHKp0eX45J8DRjWHHJm5MEm4J0B1U
         jgkHkH9INbPScIY0s9CP7or6glbruN7tlcoOtUNvQRSIrVHU6+AXPcCi8ItLTE39iw9O
         RvEuybK+jidTEysT3a+OHMbJJ7ewIBNjwJnxmuQuRHIW4hk5YlrGgowBKdQYxD4T39Yv
         xa6XdhwNVwvlx7B2XMsCkSg1M8rbwO4MPkMmYi0R8EU6uftbGsdPSA5Xyp5ePIKA0ry6
         y65BOHsXSsie1NhIUbW9yOxdXQX9CZvvTOtl6kg+tS2JIB0cz018mHfErg229+3eZgyG
         NZKg==
X-Gm-Message-State: AOAM532J8DFYqi2GTbTh9qUa/O0M4i/HYePnZ1biIXd0+ejEboJ0gaxn
        iN2gVTmbPfbOGy3uQ5guiKsnPA==
X-Google-Smtp-Source: ABdhPJwTdp1mFNmZjd/uTThSUu3tREo6Dtb4VkwqpGpv7ZYVPfWDxnJ3YoPDIOWbz+jR2KjGnUR+yw==
X-Received: by 2002:a05:620a:9d7:: with SMTP id y23mr10176247qky.181.1610041452516;
        Thu, 07 Jan 2021 09:44:12 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id b12sm3053989qtj.12.2021.01.07.09.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 09:44:11 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kxZKU-003lqO-Rg; Thu, 07 Jan 2021 13:44:10 -0400
Date:   Thu, 7 Jan 2021 13:44:10 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        target-devel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, bostroesser@gmail.com, bvanassche@acm.org,
        ddiss@suse.de
Subject: Re: [PATCH v5 1/4] sgl_alloc_order: remove 4 GiB limit, sgl_free()
 warning
Message-ID: <20210107174410.GB504133@ziepe.ca>
References: <20201228234955.190858-1-dgilbert@interlog.com>
 <20201228234955.190858-2-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201228234955.190858-2-dgilbert@interlog.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 28, 2020 at 06:49:52PM -0500, Douglas Gilbert wrote:
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index a59778946404..4986545beef9 100644
> +++ b/lib/scatterlist.c
> @@ -554,13 +554,15 @@ EXPORT_SYMBOL(sg_alloc_table_from_pages);
>  #ifdef CONFIG_SGL_ALLOC
>  
>  /**
> - * sgl_alloc_order - allocate a scatterlist and its pages
> + * sgl_alloc_order - allocate a scatterlist with equally sized elements
>   * @length: Length in bytes of the scatterlist. Must be at least one
> - * @order: Second argument for alloc_pages()
> + * @order: Second argument for alloc_pages(). Each sgl element size will
> + *	   be (PAGE_SIZE*2^order) bytes
>   * @chainable: Whether or not to allocate an extra element in the scatterlist
> - *	for scatterlist chaining purposes
> + *	       for scatterlist chaining purposes
>   * @gfp: Memory allocation flags
> - * @nent_p: [out] Number of entries in the scatterlist that have pages
> + * @nent_p: [out] Number of entries in the scatterlist that have pages.
> + *		  Ignored if NULL is given.
>   *
>   * Returns: A pointer to an initialized scatterlist or %NULL upon failure.
>   */
> @@ -574,8 +576,8 @@ struct scatterlist *sgl_alloc_order(unsigned long long length,
>  	u32 elem_len;
>  
>  	nent = round_up(length, PAGE_SIZE << order) >> (PAGE_SHIFT + order);
> -	/* Check for integer overflow */
> -	if (length > (nent << (PAGE_SHIFT + order)))
> +	/* Integer overflow if:  length > nent*2^(PAGE_SHIFT+order) */
> +	if (ilog2(length) > ilog2(nent) + PAGE_SHIFT + order)
>  		return NULL;
>  	nalloc = nent;
>  	if (chainable) {

This is a little bit too tortured now, how about this:

	if (length >> (PAGE_SHIFT + order) >= UINT_MAX)
		return NULL;
	nent = length >> (PAGE_SHIFT + order);
	if (length & ((1ULL << (PAGE_SHIFT + order)) - 1))
		nent++;

	if (chainable) {
		if (check_add_overflow(nent, 1, &nalloc))
			return NULL;
	}
	else
		nalloc = nent;

Jason

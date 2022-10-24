Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C951CFA373F
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 17:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbiJXRCm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Oct 2022 13:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235067AbiJXRBx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2022 13:01:53 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DD66EF3C
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2022 08:38:32 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id 13so5958060ejn.3
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2022 08:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UszRhZR1w1ojJqSk6wrS+sFA+R3605Sk2xC3aetY+ic=;
        b=GmJs7rcuktE8Xj7KTk90FD6TM6ocPhTImZGN1IwRIVjYVmb0WsbRp7U8DVm7Co08U6
         Gfnq/ne9R6iLSjHE/YnQ51S1SRpcX79JtcPebD3KI8ew2VzoTnPQGgTgE7GzS0nltMdn
         sDbcYMt/Ebkmrk7FwllCXuJwkKkmM3hkplqHUdFsKC3kSAh8lHsBB+DI8ToyqgheQBZ+
         n8PqCC64ca9tTquG+DvniPTD9dyUZzc+0X6dYRlV4XIHOAUy01R2QDfK5sd4N7IPmWEA
         M1txbzLLQ4xpjxmVGqst1w/Nv19GvEwr2Xl0BCHb6G3j9foq4NCbd8IRw7yYGW1bw+vM
         sWSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UszRhZR1w1ojJqSk6wrS+sFA+R3605Sk2xC3aetY+ic=;
        b=l6o1RQB9Byo6R720rVg4/Uoz5REHjoycDT3UmDjUAYZ2XQbeKKUVN8//XBNPNK+O7+
         K4hssXz29VQ7SNXIxkyhndwbYaI2uhdnRaadyVy9tBy/2JfefRuU9Pv0qL9/EKA72l4Q
         6tacRTJAwyCEZtuFIq87R0fvEEQnQwodZSWhK1NX5CHKPmaXZRmfJTjuJjZQ6XUe2v2T
         OAYtbJmkhbvQbFCUugwP9uJ4Ztu+HbiA2BU4jjokqljqhPei2uoUgfojh6BOlze+rNC1
         L6UYKzL9KZEMtd04cndu7G4w+nGaX4jBv/C4omxWT5JeCLLLJjwlaa6ZgOcs70ZXCeNK
         xt3w==
X-Gm-Message-State: ACrzQf3P0WlX8iIGzRUZqafCH+CmdjswMF94Q3imJ2roPhxmH8yzrzMO
        BgNP1c+i0v9ZiPFFiE6vuBpF3sGa4YQ=
X-Google-Smtp-Source: AMsMyM6pYYxchGMiI2yrevaHWEYeDG4IqyJwcQlFdXgxCrFp8S+8qEM/Ro5JGEiai96PWKy5tAkkyg==
X-Received: by 2002:a17:907:168c:b0:7a5:74eb:d123 with SMTP id hc12-20020a170907168c00b007a574ebd123mr6992985ejc.268.1666621951971;
        Mon, 24 Oct 2022 07:32:31 -0700 (PDT)
Received: from [192.168.178.40] (ip5f597b78.dynamic.kabel-deutschland.de. [95.89.123.120])
        by smtp.gmail.com with ESMTPSA id l23-20020aa7d957000000b0044ef2ac2650sm18364357eds.90.2022.10.24.07.32.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 07:32:31 -0700 (PDT)
Message-ID: <665f8dee-6688-60d1-5097-49f9726c38ec@gmail.com>
Date:   Mon, 24 Oct 2022 16:32:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 1/5] sgl_alloc_order: remove 4 GiB limit
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org
References: <20221024010244.9522-1-dgilbert@interlog.com>
 <20221024010244.9522-2-dgilbert@interlog.com> <Y1aDQznakNaWD8kd@ziepe.ca>
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <Y1aDQznakNaWD8kd@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24.10.22 14:21, Jason Gunthorpe wrote:
> On Sun, Oct 23, 2022 at 09:02:40PM -0400, Douglas Gilbert wrote:
>> This patch fixes a check done by sgl_alloc_order() before it starts
>> any allocations. The comment in the original said: "Check for integer
>> overflow" but the right hand side of the expression in the condition
>> is resolved as u32 so it can not exceed UINT32_MAX (4 GiB) which
>> means 'length' can not exceed that value.
>>
>> This function may be used to replace vmalloc(unsigned long) for a
>> large allocation (e.g. a ramdisk). vmalloc has no limit at 4 GiB so
>> it seems unreasonable that sgl_alloc_order() whose length type is
>> unsigned long long should be limited to 4 GB.
>>
>> Solutions to this issue were discussed by Jason Gunthorpe
>> <jgg@ziepe.ca> and Bodo Stroesser <bostroesser@gmail.com>. This
>> version is base on a linux-scsi post by Jason titled: "Re:
>> [PATCH v7 1/4] sgl_alloc_order: remove 4 GiB limit" dated 20220201.
> 
> You should link to lore here..
> 
> I think I prefer we just fix this so it doesn't have a problem in the
> first place - nothing needs the weird unsigned long long argument type:
> 
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index c8c3d675845c37..c39e19fa174bca 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -595,19 +595,17 @@ EXPORT_SYMBOL(sg_alloc_table_from_pages_segment);
>    *
>    * Returns: A pointer to an initialized scatterlist or %NULL upon failure.
>    */
> -struct scatterlist *sgl_alloc_order(unsigned long long length,
> -				    unsigned int order, bool chainable,
> -				    gfp_t gfp, unsigned int *nent_p)
> +struct scatterlist *sgl_alloc_order(size_t length, unsigned int order,
> +				    bool chainable, gfp_t gfp, size_t *nent_p)
>   {
>   	struct scatterlist *sgl, *sg;
>   	struct page *page;
> -	unsigned int nent, nalloc;
> +	size_t nent, nalloc;
>   	u32 elem_len;
>   
> -	nent = round_up(length, PAGE_SIZE << order) >> (PAGE_SHIFT + order);
> -	/* Check for integer overflow */
> -	if (length > (nent << (PAGE_SHIFT + order)))
> -		return NULL;
> +	nent = length >> (PAGE_SHIFT + order);
> +	if (length % (1 << (PAGE_SHIFT + order)))

This might end up doing a modulo operation for divisor 0, if caller
specifies a too high order parameter, right?

To be on the safe side I'd prefer to use the following code instead:
     if (length & ((1 << (PAGE_SHIFT + order)) - 1))

Thank you
Bodo

> +		nent++;
>   	nalloc = nent;
>   	if (chainable) {
>   		/* Check for integer overflow */
> @@ -649,8 +647,7 @@ EXPORT_SYMBOL(sgl_alloc_order);
>    *
>    * Returns: A pointer to an initialized scatterlist or %NULL upon failure.
>    */
> -struct scatterlist *sgl_alloc(unsigned long long length, gfp_t gfp,
> -			      unsigned int *nent_p)
> +struct scatterlist *sgl_alloc(size_t length, gfp_t gfp, size_t *nent_p)
>   {
>   	return sgl_alloc_order(length, 0, false, gfp, nent_p);
>   }
> 
> Jason

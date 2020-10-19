Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE79C433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 11:18:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 247FE22263
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 11:18:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j2o7B/XN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgJSLSq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 07:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbgJSLSp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2020 07:18:45 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9C9C0613CE;
        Mon, 19 Oct 2020 04:18:44 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id t21so9810654eds.6;
        Mon, 19 Oct 2020 04:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=45s2FCkwzyyTYjXpdLwRQnD7aZKp7qq3wruiWtEoA1o=;
        b=j2o7B/XNkY6QxAUAH9C351tgOWQYsxOBcYAFqEPbz5qI0dLEg5vA0FTiZdfZvZyD4N
         +Z7wS6AMAbyE+PMsMIOXAc+VCm+0HcwRZXq3GBTdMpTiCJxQhsIGb7f6M1tqs5wQPcYD
         9mKeSEBGXwJ1y3TA11fdiQ8CICZ/LAZj/3pnThAPTMVjvkll18eU4mkdmIL5WaFaZAKg
         5dPyAdbvco8Y67FeIK67sMD282GkbIPRS0KZAxvgxtOjn83m+l0IXH/jmr+D3dp/3wxA
         U3kG39Cgcbq1R2+z2y8zAeXzvWFC2UvaEqcxynYUVJELMvBzbzEqPvGOAaEFw+MCsHlN
         U/uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=45s2FCkwzyyTYjXpdLwRQnD7aZKp7qq3wruiWtEoA1o=;
        b=lbhpALajv+gnVUxAlYpkjImX0/88AZ7PjP0QAadBdyafRZbB+HAX4viMI6xitN7bQ6
         HX7OMmM6dkethJbqiYS0wkWP3Qgvmjc82Pci9DAix69vIz5zZr9sEE+GmCbrX0rHK93M
         iOW4+G3Hnb/hMbACVjFuoWy99EH8wVJZazmKCd/HZjTR2iOlnEigpsDWIs6b2wIyiKUf
         oXBi4Xih7domL0pzPDFNVjPnSG2Hu1BwAVOdWfLD+ufLD4zAhB6TJSmLwyBOrq6YDSZr
         NVw8efu5cV1mGsQ9/pWI0PMTDEFz2HdvKpY9660NHSkCsG2dxqGNcIcxJkxH3jrZE6Xv
         h3bQ==
X-Gm-Message-State: AOAM533SWioSpQsOeiL5hUuXyaU/uPf4WderEAtZ05pzBiB5kwjwjfQr
        6QObiXFci0K1PkLSnZ9a2oN7eEfOGw/r5Q==
X-Google-Smtp-Source: ABdhPJw2B7R7ZQuAnZZQqQwRpR70rr/Vg1pWrC/W/1VOCzjuKr6oga62jViR/knTDnu+L4fnJQDPjg==
X-Received: by 2002:aa7:c54f:: with SMTP id s15mr17950954edr.107.1603106322909;
        Mon, 19 Oct 2020 04:18:42 -0700 (PDT)
Received: from [192.168.178.40] ([188.192.138.212])
        by smtp.gmail.com with ESMTPSA id d6sm10259216edr.26.2020.10.19.04.18.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 04:18:42 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] scatterlist: add sgl_memset()
To:     Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     martin.petersen@oracle.com, axboe@kernel.dk, bvanassche@acm.org
References: <20201018171336.63839-1-dgilbert@interlog.com>
 <20201018171336.63839-5-dgilbert@interlog.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <75d9b1cf-e418-cee1-89de-c59c5b2b4304@gmail.com>
Date:   Mon, 19 Oct 2020 13:18:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201018171336.63839-5-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

AFAICS, there are 2 unneeded lines in the new implementation
of sgl_memset. Please see details below.


Am 18.10.20 um 19:13 schrieb Douglas Gilbert:
> The existing sg_zero_buffer() function is a bit restrictive.
> For example protection information (PI) blocks are usually
> initialized to 0xff bytes. As its name suggests sgl_memset()
> is modelled on memset(). One difference is the type of the
> val argument which is u8 rather than int. Plus it returns
> the number of bytes (over)written.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---

...

> +
> +/**
> + * sgl_memset - set byte 'val' up to n_bytes times on SG list
> + * @sgl:		 The SG list
> + * @nents:		 Number of SG entries in sgl
> + * @skip:		 Number of bytes to skip before starting
> + * @val:		 byte value to write to sgl
> + * @n_bytes:		 The (maximum) number of bytes to modify
> + *
> + * Returns:
> + *   The number of bytes written.
> + *
> + * Notes:
> + *   Stops writing if either sgl or n_bytes is exhausted. If n_bytes is
> + *   set SIZE_MAX then val will be written to each byte until the end
> + *   of sgl.
> + *
> + *   The notes in sgl_copy_sgl() about large sgl_s _applies here as well.
> + *
> + **/
> +size_t sgl_memset(struct scatterlist *sgl, unsigned int nents, off_t skip,
> +		  u8 val, size_t n_bytes)
> +{
> +	size_t offset = 0;
> +	size_t len;
> +	struct sg_mapping_iter miter;
> +
> +	if (n_bytes == 0)
> +		return 0;
> +	sg_miter_start(&miter, sgl, nents, SG_MITER_ATOMIC | SG_MITER_TO_SG);
> +	if (!sg_miter_skip(&miter, skip))
> +		goto fini;
> +
> +	while ((offset < n_bytes) && sg_miter_next(&miter)) {
> +		len = min(miter.length, n_bytes - offset);
> +		memset(miter.addr, val, len);
> +		offset += len;
> +		miter.consumed = len;

The above line will not change miter.consumed in all loop cycles but the
last, since len will be miter.length for all loop cycles but the last
and sg_miter_next initializes miter.consumed to contain miter.length.
In the last loop cycle it does not harm if miter.consumed stays bigger
than len. So this line is not needed and can be removed.

> +		sg_miter_stop(&miter);

Since the code does not use nested sg_miter, the sg_miter_stop() here is
not needed, you can remove that line.

Either the next call to sg_miter_next will call sg_miter_stop before
preparing next chunk of mem, or sg_miter_stop is called behind the loop.

> +	}
> +fini:
> +	sg_miter_stop(&miter);
> +	return offset;
> +}
> +EXPORT_SYMBOL(sgl_memset);
> +
> 

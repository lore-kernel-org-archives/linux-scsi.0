Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C6BC388F7
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 13:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B264D2224E
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 13:28:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AexxnffH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbgKCN2x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 08:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729299AbgKCN2v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 08:28:51 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74016C0613D1;
        Tue,  3 Nov 2020 05:28:51 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id gn41so6801006ejc.4;
        Tue, 03 Nov 2020 05:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W85cv178Io00vNnAkpj7Pt3zl5qZ2MXocYPpNy0GZ/M=;
        b=AexxnffHSO+sJ2/fc86DVWjR+ebyCUJaYzZ3KWhR+OPk12FOsVn/NHUzrPSNVqGGSh
         JjgCyShJCox0fFHdiTLiytnLgCa8vngoM+1aBcpyBR/hZtD/kE5luDT4mz+kfWBogp8g
         LZiw90IRwCpoHJi3YuxyyTXRwL3PPFhyYRgejVS73k/eKHkYjQjEf9N9k9rWXTgb14rh
         iaPQ6viFylXVZwgG7oFlatQ4thgqJAtvTg7kJT7PimI+c/cZ+otsQA/bNC5G0tNxD9+L
         uZ1Dom4JHBtRT1aYJ3STiBsr3ACHl6RIaq3u2cK05Pazn/FGZiMKQBaIIOH6aFibf6e9
         ZK7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W85cv178Io00vNnAkpj7Pt3zl5qZ2MXocYPpNy0GZ/M=;
        b=Nli6G5ST6mwJW5m5A2bS7XB7ANYiEq8HUTPzJOW8mf8jsVi9La7EjCffaR/xsluoL0
         qpv5XeSR4ADZrV9SH9k53nnCl9firNHLxPyBdkiZCuoCIBVWV8SWPbngA/qxxhCYW8S6
         4G462dS/vnslw4ATyqMAsyo/6GYBLDpuKIRTvWVNkSwF7020N+fQadHHxm3HEACdKfJq
         /PVwE4dhcQJZuGYyXJ0hVC7/UvOH7CwCh8R4I/Pz4Dr5T58ZvT+/vwjMA5ZygWaW4h9m
         Tz9hZjK2dT3M1EPfF9PUh28cS5dayvfAQLX5rALxrcMTJ89mDrBTC2cGi1gQPNj6RUnz
         dXrg==
X-Gm-Message-State: AOAM532y9cdEru+FeRoeDRVCI026xWoRoFCCxFX0G1Rr3aTIKZmAOvVG
        fMQwqFKfVURY48h6n/FY4Y0=
X-Google-Smtp-Source: ABdhPJyTgIvCBJ2JckYGqyeirVc598R3rz0DfvbgHj+UU4tzHrnokqXUolGMBzThihXOigi5P8jYeg==
X-Received: by 2002:a17:906:1246:: with SMTP id u6mr20059028eja.432.1604410130138;
        Tue, 03 Nov 2020 05:28:50 -0800 (PST)
Received: from [192.168.178.40] (ipbcc08ad4.dynamic.kabel-deutschland.de. [188.192.138.212])
        by smtp.gmail.com with ESMTPSA id l11sm4095302ejk.53.2020.11.03.05.28.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 05:28:49 -0800 (PST)
Subject: Re: [PATCH v3 4/4] scatterlist: add sgl_memset()
To:     Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     martin.petersen@oracle.com, axboe@kernel.dk, bvanassche@acm.org
References: <20201019191928.77845-1-dgilbert@interlog.com>
 <20201019191928.77845-5-dgilbert@interlog.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <9a8ab6d9-72cf-1dd2-a9e8-114e7f9f198c@gmail.com>
Date:   Tue, 3 Nov 2020 14:28:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019191928.77845-5-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Am 19.10.20 um 21:19 schrieb Douglas Gilbert:
> The existing sg_zero_buffer() function is a bit restrictive.
> For example protection information (PI) blocks are usually
> initialized to 0xff bytes. As its name suggests sgl_memset()
> is modelled on memset(). One difference is the type of the
> val argument which is u8 rather than int. Plus it returns
> the number of bytes (over)written.
> 
> Change implementation of sg_zero_buffer() to call this new
> function.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>   include/linux/scatterlist.h |  3 ++
>   lib/scatterlist.c           | 65 +++++++++++++++++++++++++------------
>   2 files changed, 48 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index ae260dc5fedb..a40012c8a4e6 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -329,6 +329,9 @@ bool sgl_compare_sgl(struct scatterlist *x_sgl, unsigned int x_nents, off_t x_sk
>   		     struct scatterlist *y_sgl, unsigned int y_nents, off_t y_skip,
>   		     size_t n_bytes);
>   
> +size_t sgl_memset(struct scatterlist *sgl, unsigned int nents, off_t skip,
> +		  u8 val, size_t n_bytes);
> +
>   /*
>    * Maximum number of entries that will be allocated in one piece, if
>    * a list larger than this is required then chaining will be utilized.
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index 49185536acba..6b430f7293e0 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -952,26 +952,7 @@ EXPORT_SYMBOL(sg_pcopy_to_buffer);
>   size_t sg_zero_buffer(struct scatterlist *sgl, unsigned int nents,
>   		       size_t buflen, off_t skip)
>   {
> -	unsigned int offset = 0;
> -	struct sg_mapping_iter miter;
> -	unsigned int sg_flags = SG_MITER_ATOMIC | SG_MITER_TO_SG;
> -
> -	sg_miter_start(&miter, sgl, nents, sg_flags);
> -
> -	if (!sg_miter_skip(&miter, skip))
> -		return false;
> -
> -	while (offset < buflen && sg_miter_next(&miter)) {
> -		unsigned int len;
> -
> -		len = min(miter.length, buflen - offset);
> -		memset(miter.addr, 0, len);
> -
> -		offset += len;
> -	}
> -
> -	sg_miter_stop(&miter);
> -	return offset;
> +	return sgl_memset(sgl, nents, skip, 0, buflen);
>   }
>   EXPORT_SYMBOL(sg_zero_buffer);
>   
> @@ -1110,3 +1091,47 @@ bool sgl_compare_sgl(struct scatterlist *x_sgl, unsigned int x_nents, off_t x_sk
>   	return equ;
>   }
>   EXPORT_SYMBOL(sgl_compare_sgl);
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
> +	}
> +fini:
> +	sg_miter_stop(&miter);
> +	return offset;
> +}
> +EXPORT_SYMBOL(sgl_memset);
> +
> 

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>

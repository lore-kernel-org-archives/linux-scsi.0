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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6974C4742C
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 12:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CF5720731
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 12:54:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="udqUPOFr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729158AbgKCMyf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 07:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729130AbgKCMyV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 07:54:21 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B14C0613D1;
        Tue,  3 Nov 2020 04:54:17 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id v4so18157001edi.0;
        Tue, 03 Nov 2020 04:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9Sl56c8k51H8Vu2OSyVbh5e7wa+RNXgDGujKIEt2TYo=;
        b=udqUPOFrit8ZOErOJKsB+z4D6+BLT5eAqGZLwqEby83aQe/aGEkKqG4hjNj1o7IAo+
         THuNzMAIH5yvOo2hVRFZFOnQ5MyXhtggMKkE9QCnuQNwQpaC8UMkHOsQ+XrlrR6KOBqR
         oxAes5dDPqc001mJt7Yh6nQR+jiLYnFLsu47LaLk3xhJ/KLuq86E3x6xq8bc9nfWcDjR
         Kl6yKx4ZSf3RVllNkYRJhKqU5wnHoqWAJZCNBYTztGZ+0lXE8rvUJ2fFCq+HFg+7LLLK
         eJsVRgFDMp3vrOBdN/ATAz4vZpizlGLnfMlJ0nRI7OlbBN+9wzM5re/lc9P12q4MLXRD
         YMqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9Sl56c8k51H8Vu2OSyVbh5e7wa+RNXgDGujKIEt2TYo=;
        b=HLwMqtATmdbN+4eWj+gjPqic3rRrrk/Z9PHn2I3v1NLMuoJF7aLQ5rA3fKa9IsacLB
         3GoEcA5/EpMa5mej5Ewhf3ywXuPtsfTKnpI30y53IXIXayj50D9zlDXuZK/az4IRrRyu
         nIZbvb0bgnnhMJ9O/J3ogfEOeDkMRL47IN9M7eKyiEhcRcma2Pw6VxqcB6rDBN3Rspqe
         i2bumluMNSs4S/Mc7JY+Rzbwkud/neUhnI+vZhECc7dND+a7r43WLvBuvNu9m4UDVF0i
         R7mLcnsUgpZ4cLM7JaqXc6k621kUqsQkABfskePOjtCNHHNlptsegvqLx3HGbsXGNDAd
         DR7Q==
X-Gm-Message-State: AOAM5304vultbes0dFQyP/84aam1ZT7PRndKPInNzmQ4i+KRJfYjUOi5
        1i5rzzf2sJjjroJeuyMngx4=
X-Google-Smtp-Source: ABdhPJw/aBni6ZTG1aHvoYitADBy4us0mcruZhypS49M61E3Nu53RTJ3rq6JWQRM/239ttS3V5CT9A==
X-Received: by 2002:aa7:c5d0:: with SMTP id h16mr10094225eds.7.1604408056190;
        Tue, 03 Nov 2020 04:54:16 -0800 (PST)
Received: from [192.168.178.40] ([188.192.138.212])
        by smtp.gmail.com with ESMTPSA id k4sm11010356edq.73.2020.11.03.04.54.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 04:54:15 -0800 (PST)
Subject: Re: [PATCH v3 1/4] sgl_alloc_order: remove 4 GiB limit, sgl_free()
 warning
To:     Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     martin.petersen@oracle.com, axboe@kernel.dk, bvanassche@acm.org
References: <20201019191928.77845-1-dgilbert@interlog.com>
 <20201019191928.77845-2-dgilbert@interlog.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <2e94f118-1216-b926-a275-2fb325874b04@gmail.com>
Date:   Tue, 3 Nov 2020 13:54:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019191928.77845-2-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Am 19.10.20 um 21:19 schrieb Douglas Gilbert:
> This patch removes a check done by sgl_alloc_order() before it starts
> any allocations. The comment before the removed code says: "Check for
> integer overflow" arguably gives a false sense of security. The right
> hand side of the expression in the condition is resolved as u32 so
> cannot exceed UINT32_MAX (4 GiB) which means 'length' cannot exceed
> that amount. If that was the intention then the comment above it
> could be dropped and the condition rewritten more clearly as:
>       if (length > UINT32_MAX) <<failure path >>;

I think the intention of the check is to reject calls, where length is so high, that calculation of nent overflows unsigned int nent/nalloc.
Consistently a similar check is done few lines later before incrementing nalloc due to chainable = true.
So I think the code tries to allow length values up to 4G << (PAGE_SHIFT + order).

That said I think instead of removing the check it better should be fixed, e.g. by adding an unsigned long long cast before nent

BTW: I don't know why there are two checks. I think one check after conditionally incrementing nalloc would be enough.

> 
> The author's intention is to use sgl_alloc_order() to replace
> vmalloc(unsigned long) for a large allocation (debug ramdisk).
> vmalloc has no limit at 4 GiB so its seems unreasonable that:
>      sgl_alloc_order(unsigned long long length, ....)
> does. sgl_s made with sgl_alloc_order(chainable=false) have equally
> sized segments placed in a scatter gather array. That allows O(1)
> navigation around a big sgl using some simple integer maths.
> 
> Having previously sent a patch to fix a memory leak in
> sg_alloc_order() take the opportunity to put a one line comment above
> sgl_free()'s declaration that it is not suitable when order > 0 . The
> mis-use of sgl_free() when order > 0 was the reason for the memory
> leak. The other users of sgl_alloc_order() in the kernel where
> checked and found to handle free-ing properly.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>   include/linux/scatterlist.h | 1 +
>   lib/scatterlist.c           | 3 ---
>   2 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index 45cf7b69d852..80178afc2a4a 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -302,6 +302,7 @@ struct scatterlist *sgl_alloc(unsigned long long length, gfp_t gfp,
>   			      unsigned int *nent_p);
>   void sgl_free_n_order(struct scatterlist *sgl, int nents, int order);
>   void sgl_free_order(struct scatterlist *sgl, int order);
> +/* Only use sgl_free() when order is 0 */
>   void sgl_free(struct scatterlist *sgl);
>   #endif /* CONFIG_SGL_ALLOC */
>   
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index c448642e0f78..d5770e7f1030 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -493,9 +493,6 @@ struct scatterlist *sgl_alloc_order(unsigned long long length,
>   	u32 elem_len;
>   
>   	nent = round_up(length, PAGE_SIZE << order) >> (PAGE_SHIFT + order);
> -	/* Check for integer overflow */
> -	if (length > (nent << (PAGE_SHIFT + order)))
> -		return NULL;
>   	nalloc = nent;
>   	if (chainable) {
>   		/* Check for integer overflow */
> 

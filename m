Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7163CC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Sep 2022 01:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiI3B0b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 21:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiI3B0a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 21:26:30 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46A413A075
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 18:26:28 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id e11-20020a17090a77cb00b00205edbfd646so7595241pjs.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 18:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Cg6k590d1gYe1qvzLK8US59eUH7WJXJdcnukMaAq5JQ=;
        b=h1bgzldX+/L9fXhKSk/XewnvXXMCnpgpXGG+N2Vrmw1HCHa2Ue3P1gJ7lte3NhLNQQ
         opK+geSBRBxre64a+lTdmBjopIL/SaVrmYu2tOsXNhLUrZzsi+1uC/7omK6b5UzWoMrU
         0s+n2Jt5Y7fRUSttfrhG9F9OFaCS+v/BB4zpkWDUFBPy7qgp0BYAj0/rj4sUlDwL5mqi
         lf6Dj936AuSMLz8c2Ts/9Gp1dt93hERti9oZ7/X4OSGNgSrMxOaiDlqtnUbMvvbdaS98
         8LuBaifjg5iqEfMuaYIueKFg4evNfIFH/KNja02Zt80LaLRRT/RSyj0XAI3hKP5OV+gV
         vUdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Cg6k590d1gYe1qvzLK8US59eUH7WJXJdcnukMaAq5JQ=;
        b=Ojbr57ScY9S3Qp2Hsqx+09jUAWg5A99TNYq8NIQCXN9HVilyJ9N+eCyZGweJP6QEqb
         za8KI5xQz0Zb9gXRCSOolxS+lSbVIbqZuZgNI6OB2wd1BP4JN5HEwwLdM4YXTbaTY1CN
         xT20UNp2OyI2Q53s8peCoc2oNfjud07ZeBkcMpb/vpdP23VcU3fn9+0HX0uzkKzMHtnG
         Ybg9Mq065KJwAJklCCZiGk1X2qoBdrVPTNzjJf6VRCVcauEln/Kj1gnbPdabat/h8x4U
         ly+SljAms6W1RwIb0IKnIfPoacmcuj5dcRtLeV4ktdnUgb+IXhyMBcB+G2zvMqVVAjZe
         VGbg==
X-Gm-Message-State: ACrzQf1Ev5On7Lds6tz5VE1bfOvox9o+uM2T/vWt1AUpyCrUE1dswKVO
        wQKt8JY7nFVKk3K2Sqfpo/CYgw==
X-Google-Smtp-Source: AMsMyM54XYNL60ZKYJnXrSIFgmbWTCJkL3I8OdtaVHNuzxN6EhKViW84Cz8nyS9OLFnrbEHSDcY+kw==
X-Received: by 2002:a17:90b:3b47:b0:202:a81f:4059 with SMTP id ot7-20020a17090b3b4700b00202a81f4059mr19768268pjb.150.1664501188259;
        Thu, 29 Sep 2022 18:26:28 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s10-20020a63e80a000000b0042fe1914e26sm558361pgh.37.2022.09.29.18.26.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 18:26:27 -0700 (PDT)
Message-ID: <eaa47591-10e0-426a-6345-2881963be080@kernel.dk>
Date:   Thu, 29 Sep 2022 19:26:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH for-next v11 02/13] io_uring: introduce fixed buffer
 support for io_uring_cmd
Content-Language: en-US
To:     Anuj Gupta <anuj20.g@samsung.com>, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20220929120632.64749-1-anuj20.g@samsung.com>
 <CGME20220929121637epcas5p2ff344c7951037f79d117d000e405dd45@epcas5p2.samsung.com>
 <20220929120632.64749-3-anuj20.g@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220929120632.64749-3-anuj20.g@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/29/22 6:06 AM, Anuj Gupta wrote:
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 6a6d69523d75..faefa9f6f259 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -4,6 +4,7 @@
>  #include <linux/file.h>
>  #include <linux/io_uring.h>
>  #include <linux/security.h>
> +#include <linux/nospec.h>
>  
>  #include <uapi/linux/io_uring.h>
>  
> @@ -77,8 +78,21 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
>  	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
>  
> -	if (sqe->rw_flags || sqe->__pad1)
> +	if (sqe->__pad1)
>  		return -EINVAL;
> +
> +	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);

After reading this and checking for IORING_URING_CMD_FIXED, this should
have a:

	if (iocmd->flags & ~IORING_URING_CMD_FIXED)
		return -EINVAL;

to ensure we can safely add more flags in the future. Apart from that,
this looks good.

-- 
Jens Axboe

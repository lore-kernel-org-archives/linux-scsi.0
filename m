Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A93C32771
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Sep 2022 14:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbiI1OrW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 10:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233742AbiI1OrV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 10:47:21 -0400
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E9AAE84A;
        Wed, 28 Sep 2022 07:47:19 -0700 (PDT)
Received: by mail-wm1-f52.google.com with SMTP id z13-20020a7bc7cd000000b003b5054c6f9bso1412283wmk.2;
        Wed, 28 Sep 2022 07:47:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=dKSJWsaz2k2Rz3kNbppOUzRD8OicKQ/iayXhM8rffPU=;
        b=dncA1Q0RVtA+hzBl9BM0QdlKxGLynYjKugTCS2H2BJUIbmte3xpsY+kVq10qfuZvkj
         LjtnATDJYdooE1FbITvd+uDb2NuZT2WhBfC4+N6iT8X0UljVH9s4Ao/mPSsdLiOyuQCZ
         gvTjR7EvmOKAk9vXviXJID6DXIhgIq6yY/NQvqhXk9xW2GYezcLMcZ/BdPoWogjX91Xn
         VkkceHpld2WcIII6aV4dUVZIU8gDVkS6oAhQDRnyx+5HCYcRfUpWKfu0qeiMFUBuw8uy
         rXJ00A8iaciTUPXsNKmWH0D0hr5xuXFLmdglrhzs9Ex1+5Y+akIMtsfc+riyxbNPBq5O
         FdwA==
X-Gm-Message-State: ACrzQf0JlyTRTQd+x/Wgnge31J7HXdwFp98mmFlui2L8eaLnTHsxb23Z
        FtjRhxJU+EInrwfvtjewYYk=
X-Google-Smtp-Source: AMsMyM52NSab6Rs8LAi0TQgYLsj0YfdZ1a0kciP3sgbNHYmOzL5hVNO9A+jyjWgzUUofo+qQm4NVvA==
X-Received: by 2002:a1c:4b05:0:b0:3b4:90c1:e249 with SMTP id y5-20020a1c4b05000000b003b490c1e249mr7284717wma.201.1664376438222;
        Wed, 28 Sep 2022 07:47:18 -0700 (PDT)
Received: from [192.168.64.53] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id j6-20020a05600c190600b003a5f3f5883dsm2234534wmq.17.2022.09.28.07.47.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 07:47:17 -0700 (PDT)
Message-ID: <88638fa8-8ef8-6e52-0c5e-7d8729ce0784@grimberg.me>
Date:   Wed, 28 Sep 2022 17:47:16 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 4/5] nvme: split out metadata vs non metadata end_io
 uring_cmd completions
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        Stefan Roesch <shr@fb.com>
References: <20220927014420.71141-1-axboe@kernel.dk>
 <20220927014420.71141-5-axboe@kernel.dk>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20220927014420.71141-5-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> -static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd)
> +static void nvme_uring_task_meta_cb(struct io_uring_cmd *ioucmd)
>   {
>   	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
>   	struct request *req = pdu->req;
> -	struct bio *bio = req->bio;

Unrelated change I think. But other than that, looks good,

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 499FFC43217
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Nov 2022 22:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbiKBWyV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Nov 2022 18:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbiKBWyB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2022 18:54:01 -0400
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20015F8E;
        Wed,  2 Nov 2022 15:54:00 -0700 (PDT)
Received: by mail-pj1-f48.google.com with SMTP id c15-20020a17090a1d0f00b0021365864446so139016pjd.4;
        Wed, 02 Nov 2022 15:54:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6sCkwj9YSprxNmaofEdMTvLEH5B6xW9TB9afqYojreE=;
        b=EQYV0AnVUm9iQsoNNjNrzU+igaKyrSajLmFdaOLxPycRiyHOyKtzXzPZnAYic/Ib8G
         r1noqOc/7hPdQ8GTZVAWqKjZE1VqnUp10NcHYnFcMRmbtF2C5O938DXrKP/L85ubOaoh
         95S8+zgdAZs1CPr5hZ4SmS6yWEXo2qHQBAqsmJiMxlfDRGCIDJad4NveOy/wJFPXml4f
         SpnZ0YMY7afw/lW2z7RtKkXqUZAIpZVGt2S07U4SM60pxiGjSC4zWsM4S03xtdWK998c
         M7BiA9bATnrvhUiDNLWrWWbZ27JArfGraLv/CpS7l65hRFMZQaRU61lH+e/9S8A51e7m
         qD/w==
X-Gm-Message-State: ACrzQf1Vk1ARGYRghfK3zlfgHy78Hv1TWjq2IIANjllyvP1Xlvgs4IG3
        Wukw7WZk7z0a9yWfN2f2OXQ=
X-Google-Smtp-Source: AMsMyM711K/XUrQHKPUtbBSxzz99QtzdPWA4ooVlF037LAOY+yPo/0v1VhBhBLoucp5Sp0Kf7/u28Q==
X-Received: by 2002:a17:902:ec86:b0:187:2430:d377 with SMTP id x6-20020a170902ec8600b001872430d377mr16640073plg.33.1667429640140;
        Wed, 02 Nov 2022 15:54:00 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:22d3:f380:fa84:4b89? ([2620:15c:211:201:22d3:f380:fa84:4b89])
        by smtp.gmail.com with ESMTPSA id t4-20020a63f344000000b0046f8e444edfsm7630960pgj.60.2022.11.02.15.53.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 15:53:59 -0700 (PDT)
Message-ID: <569dfa4d-0f0e-a596-1f38-2f4ccc555fe5@acm.org>
Date:   Wed, 2 Nov 2022 15:53:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 01/19] block: Add PR callouts for read keys and
 reservation
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-2-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221026231945.6609-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/26/22 16:19, Mike Christie wrote:
> +struct pr_keys {
> +	u32	generation;
> +	u32	num_keys;
> +	u64	keys[];
> +};
Is my understanding correct that keys[] is treated as opaque data by the 
kernel? If so, is it necessary to convert the persistent reservation 
keys from big endian to CPU endianness? Some SCSI stacks keep 
reservation keys as __be64 format.

Thanks,

Bart.

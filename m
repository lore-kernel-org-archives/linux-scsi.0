Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 612C6C47088
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Nov 2022 22:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiK3W3d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 17:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiK3W3c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 17:29:32 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100C887CB4;
        Wed, 30 Nov 2022 14:29:32 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id d18so7323360pls.4;
        Wed, 30 Nov 2022 14:29:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TxyvabiM0fk8qsnnh1dEJTsqZuBGjrZh1YkmfEskrjg=;
        b=dcy4JIHua9OHZCCzbcu5wKrAOhqwE0jneHE+9YG7b+3YPFkXJY0tsExPq28DasZNrX
         pq+2uIfgC2aR5v4Culiv5VAyd44n2muCUGE+Sm3pbgiLZDh7bzufiUqaDGK1UAYTv97C
         cAR5jNFFi0Qs39MbtkaqzgFM7kKChrQsvs79J6CDYTE4+YGyT45WAxY6t1Z8QKm8DbPI
         uiIhfHeUUtOUgk1uqCO0Y9pH6WbB8HfdEK3yS8lo99G3mZ25dvZZRhsBwYyawqyfxS6d
         ltnLm9Pbh0TzLFroyfU3qRRiNWSAfAvAcZNcbzwtMwazZkTEWbUrk/XnENi6DLqTJVLJ
         ifXg==
X-Gm-Message-State: ANoB5pmy+YidBFuZrnFpLMRzhuiCLuJsP/Hk7tsUaRU0cu45j7YHqYvH
        OGk0cR1g3Wm9099gyM+rwVU=
X-Google-Smtp-Source: AA0mqf5x1+T8vIsvv1kwkFegQRX2kFD/FSK3fgo4uB5kILThxZXS2SfnIvWwRBhxzuiTEgMQmnpP+w==
X-Received: by 2002:a17:90b:3011:b0:219:5f5a:7192 with SMTP id hg17-20020a17090b301100b002195f5a7192mr6749099pjb.144.1669847371429;
        Wed, 30 Nov 2022 14:29:31 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:3729:bd90:53d2:99e3? ([2620:15c:211:201:3729:bd90:53d2:99e3])
        by smtp.gmail.com with ESMTPSA id i28-20020a056a00005c00b00576145a9bd0sm168366pfk.127.2022.11.30.14.29.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 14:29:30 -0800 (PST)
Message-ID: <6c41f85b-7add-60d7-e131-71c3cfae80d0@acm.org>
Date:   Wed, 30 Nov 2022 14:29:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 8/8] null_blk: Support configuring the maximum segment
 size
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        Chaitanya Kulkarni <kch@nvidia.com>
References: <20221123205740.463185-1-bvanassche@acm.org>
 <20221123205740.463185-9-bvanassche@acm.org>
 <32feb681-e858-1a0c-b91d-3f0d85615a6d@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <32feb681-e858-1a0c-b91d-3f0d85615a6d@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/23/22 17:40, Damien Le Moal wrote:
> On 11/24/22 05:57, Bart Van Assche wrote:
>> +static unsigned int g_max_segment_size = 1UL << 31;
> 
> 1UL is unsigned long be this var is unsigned int. Why not simply use
> UINT_MAX here ? You prefer the 2GB value ? If yes, then may be at least
> change that to "1U << 31", no ?
> 
> [ ... ]
>> @@ -2106,6 +2119,7 @@ static int null_add_dev(struct nullb_device *dev)
>>   	dev->max_sectors = min_t(unsigned int, dev->max_sectors,
>>   				 BLK_DEF_MAX_SECTORS);
>>   	blk_queue_max_hw_sectors(nullb->q, dev->max_sectors);
>> +	blk_queue_max_segment_size(nullb->q, dev->max_segment_size);
> 
> Should we keep the ability to use the kernel default value as the default
> here ?
> E.g.
> 
> 	if (dev->max_segment_size)
> 		blk_queue_max_segment_size(nullb->q,
> 				dev->max_segment_size);
> 
> If yes, then g_max_segment_size initial value should be 0, meaning "kernel
> default".

Hi Damien,

How about changing the default value for g_max_segment_size from
1UL << 31 into BLK_MAX_SEGMENT_SIZE? That will simplify the code and 
also prevents that this patch changes the behavior of the null_blk 
driver if g_max_segment_size is not modified by the user.

Thanks,

Bart.


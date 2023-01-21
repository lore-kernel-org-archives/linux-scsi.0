Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0BACC05027
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Jan 2023 00:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjAUALa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Jan 2023 19:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjAUAL2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jan 2023 19:11:28 -0500
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248837B2CF;
        Fri, 20 Jan 2023 16:11:28 -0800 (PST)
Received: by mail-pj1-f45.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so9678316pjq.0;
        Fri, 20 Jan 2023 16:11:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QvPQDaF8rcLeaATRSfak4co9kivPPKbIQgzECM4yf1Y=;
        b=mRrjtq6r+0rT+vzaQLrXgsp6TdcA9Wmv+2c+Vsu9zVOCzAiwYbCV8rtzGymbrQu6Ck
         ROYGhR5djVmyc4YxCDJ4yAg9BOkGAXB1ZWWeAuCsHkCtJhVaFOVpqvSiQiDAjSo23wD7
         z80JhqAWsYPtYj6LznrA6b7nlEOVETG44TvC4Hh2OyjoakWQqeieuFgxKyKNGOzGU8QM
         bW88djYE2PMmh/rEAo1ZmoqSfg0kTnjDebZnMJJ531i2l7jICLrDP8LdVLhN61TN3BNj
         pH6ReFPYANs4TDlIp/2H1Ic5vOzfAvhKOSyV0jwBC2Z52Wl6iZuv9nvcio/FzM7acd+X
         sAvg==
X-Gm-Message-State: AFqh2kozcH/QHOIJNq+nx59HeQ7Kv3m9VLYKJIASdEnkfXaMjXm+e8ek
        UsDxkwIVyn75L2ioq308QBA=
X-Google-Smtp-Source: AMrXdXtStrF8JvfPhaycHuf9QfB/qaRA8VxFh1iOj3q2+BQvTkUV6VXnMU7xufRDP3j9ClqwC++5jw==
X-Received: by 2002:a17:90a:f409:b0:226:f7f6:ad2f with SMTP id ch9-20020a17090af40900b00226f7f6ad2fmr18266071pjb.38.1674259887381;
        Fri, 20 Jan 2023 16:11:27 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:3a65:5ceb:1d3:9e21? ([2620:15c:211:201:3a65:5ceb:1d3:9e21])
        by smtp.gmail.com with ESMTPSA id f1-20020a17090a8e8100b0021904307a53sm2124300pjo.19.2023.01.20.16.11.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 16:11:26 -0800 (PST)
Message-ID: <f1317a6f-9c74-b41d-749e-f9dc34f0ad80@acm.org>
Date:   Fri, 20 Jan 2023 16:11:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3 1/9] block: Introduce QUEUE_FLAG_SUB_PAGE_SEGMENTS and
 CONFIG_BLK_SUB_PAGE_SEGMENTS
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>
References: <20230118225447.2809787-1-bvanassche@acm.org>
 <20230118225447.2809787-2-bvanassche@acm.org>
 <4f308b47-e08c-efa6-6a86-965ba6761350@kernel.dk>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4f308b47-e08c-efa6-6a86-965ba6761350@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/18/23 15:02, Jens Axboe wrote:
> On 1/18/23 3:54 PM, Bart Van Assche wrote:
>> Prepare for introducing support for segments smaller than the page size
>> by introducing the request queue flag QUEUE_FLAG_SUB_PAGE_SEGMENTS.
>> Introduce CONFIG_BLK_SUB_PAGE_SEGMENTS to prevent that performance of
>> block drivers that support segments >= PAGE_SIZE would be affected.
>>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Ming Lei <ming.lei@redhat.com>
>> Cc: Keith Busch <kbusch@kernel.org>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   block/Kconfig          | 9 +++++++++
>>   include/linux/blkdev.h | 7 +++++++
>>   2 files changed, 16 insertions(+)
>>
>> diff --git a/block/Kconfig b/block/Kconfig
>> index 5d9d9c84d516..e85061d2175b 100644
>> --- a/block/Kconfig
>> +++ b/block/Kconfig
>> @@ -35,6 +35,15 @@ config BLOCK_LEGACY_AUTOLOAD
>>   	  created on demand, but scripts that manually create device nodes and
>>   	  then call losetup might rely on this behavior.
>>   
>> +config BLK_SUB_PAGE_SEGMENTS
>> +       bool "Support segments smaller than the page size"
>> +       default n
>> +       help
>> +	  Most storage controllers support DMA segments larger than the typical
>> +	  size of a virtual memory page. Some embedded controllers only support
>> +	  DMA segments smaller than the page size. Enable this option to support
>> +	  such controllers.
> 
> This should not be a visible option at all, affected drivers should just
> select it.

Hi Jens,

If CONFIG_BLK_SUB_PAGE_SEGMENTS is made invisible, how should this 
option be enabled for the scsi_debug and null_blk drivers? Adding 
"select BLK_SUB_PAGE_SEGMENTS" to the Kconfig section of these drivers 
would have the unfortunate side effect that enabling either driver would 
make all block drivers slower. How about making sub-page segment support 
configurable for the scsi_debug and null_blk drivers only? That would 
allow kernel developers who want to test the sub-page segment support to 
enable this functionality without making e.g. distro kernels slower.

Thanks,

Bart.

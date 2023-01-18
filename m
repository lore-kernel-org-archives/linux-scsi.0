Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D77C38159
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Jan 2023 23:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjARXkk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 18:40:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjARXkj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 18:40:39 -0500
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CBD654F3;
        Wed, 18 Jan 2023 15:40:37 -0800 (PST)
Received: by mail-pl1-f175.google.com with SMTP id d9so661261pll.9;
        Wed, 18 Jan 2023 15:40:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fUpnfuil0lI1NIKG1PFbIEZeU6dqCK4MK5QIOJ5PnzE=;
        b=rtDVt/rY2/5bpPdm83X/eZuXZir1GgscWx7XaOB/+ZD+lTjEVY1DA79xRh7s07rbZW
         CeZ4w71Ysr0Ghy5oueeHZEnh1hMkEr8AkiYsDZkfhjIt4amLu/U5XlOIFGz83yle/qgK
         ok2O6ADeo6wcAct7aBjwK2Rq2bhZ4bVKrvfoOkqVEqLMwwGWy6hSm4Tw6YK/qr4jsx+G
         8gR3oquYGWTd2uZoNWtep+2Aic8ub/mTG41JR7Bd0akam7QoTTRDcoYzfe4dSrvzOjhW
         SxVGWMg4jNWWYpPryo0p1BCIfmMaPy5aTnNK3lXVKe8qg8QaC77tOw581JMoMOa7ByJc
         PW7A==
X-Gm-Message-State: AFqh2krpdIGOvGtqYd7rRuBdxBT3mD4vc8HgVXOn2D59TI71wQcUqs63
        Qg8y4CS8mB4xjTyZSaumOrM=
X-Google-Smtp-Source: AMrXdXunBe3Em4ihK+pm1IYFAFGP+gvQYgmCYMx0bYpQEFeuoF1K1RHkUwd1vL3REkaoHqLIeCt3PQ==
X-Received: by 2002:a17:902:8602:b0:189:e55d:ec72 with SMTP id f2-20020a170902860200b00189e55dec72mr7837489plo.20.1674085237385;
        Wed, 18 Jan 2023 15:40:37 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:22ae:3ae3:fde6:2308? ([2620:15c:211:201:22ae:3ae3:fde6:2308])
        by smtp.gmail.com with ESMTPSA id v21-20020a1709028d9500b001868981a18esm6255933plo.6.2023.01.18.15.40.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 15:40:36 -0800 (PST)
Message-ID: <3b96872f-45d1-2acb-d251-d14e82b9d9bf@acm.org>
Date:   Wed, 18 Jan 2023 15:40:34 -0800
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

Thanks for the feedback. Unless anyone requests me to realize this in another
way, I plan to merge the patch below into the patch above:


diff --git a/block/Kconfig b/block/Kconfig
index e85061d2175b..b44b449c47bf 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -36,13 +36,7 @@ config BLOCK_LEGACY_AUTOLOAD
  	  then call losetup might rely on this behavior.

  config BLK_SUB_PAGE_SEGMENTS
-       bool "Support segments smaller than the page size"
-       default n
-       help
-	  Most storage controllers support DMA segments larger than the typical
-	  size of a virtual memory page. Some embedded controllers only support
-	  DMA segments smaller than the page size. Enable this option to support
-	  such controllers.
+       bool

  config BLK_RQ_ALLOC_TIME
  	bool



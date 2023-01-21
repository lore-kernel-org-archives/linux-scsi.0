Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51FE3C05027
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Jan 2023 02:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjAUCnQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Jan 2023 21:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjAUCnP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jan 2023 21:43:15 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A747CCE8
        for <linux-scsi@vger.kernel.org>; Fri, 20 Jan 2023 18:43:14 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id z20so4897322plc.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Jan 2023 18:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=op5hDwjbzfVECTXQOpZ3gZ09SxcA7kYJCe8wIzxibno=;
        b=fSup2CufQIQ67ziFp10s273fFAtZB5VClW3NgZsl3MYhnAt9Krio8iNmZDpRx4F07W
         vYPX6P7gXQoLSIr3iXb5w8Zs0Fb50JuK3Xn6qDAYSZvE4Y2ShCt9OojDs47+VTUqbkkN
         OBk6cN87lXPRq9KT+4OTULPSDTdm3OBfCoTkkaIv6u9ZIGsEfaGbqEMNshqsmBHaXvVN
         DZGztUPRFHftTFo0yNM0JnK1rJJ+gwYZLKJF2aIsBLNmP89t2kT58dYCAwTocaUjKlyu
         OVuVsrg2SizQ6JszpnmN1F9pOddPrhTbrRtq/8wpuWvjQnqgaEM+D9gyMLqIOhf1VoLn
         GuFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=op5hDwjbzfVECTXQOpZ3gZ09SxcA7kYJCe8wIzxibno=;
        b=NPQbVWTIzGGyr/51bo8tBfwO4yuJ0mrvAx3sHldtmCp8u1mFeB/yzVK7FLEJpnjo39
         l3CwDFDhYZEwqZo3Dzv1sxxcK+UesiA2bKSZObcTsg8kJE+k23m60vl5tK2vgbxbtHpw
         eoQHS/SVOUb1xWQ3Qo0dATmNAamUSHqeM1Wgd+ZJ6rn2+i7zqThXV27vCEeLcei1GNlw
         KBMnJW0+ldwbVwJapMyRD6/ojNhBGoep+fSder6l18PqFJIGToQOxzje/jvFMEV9U9gS
         LnTlCaIrwuwiwNyBEvD1F8uw6BmgFpCpZ4GgX/efRyzGcSasg2vRPTGQZr45glH8rK7P
         Lu6A==
X-Gm-Message-State: AFqh2kp3Z16MSrKTAPWDX4jPOYowB4IJvGNvipKA7KNxaeAoGCB85mAm
        0lDxCf/2O46tlIx/gBD7M2HcjA==
X-Google-Smtp-Source: AMrXdXuRWWnHng24jf4RnPPsvZIjmw9iXlZwxFx0aMH9XB1abOpKOB1bostUWA3clzV4umNAzybvtA==
X-Received: by 2002:a17:903:32c2:b0:195:e437:ba2 with SMTP id i2-20020a17090332c200b00195e4370ba2mr1077515plr.6.1674268993690;
        Fri, 20 Jan 2023 18:43:13 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j5-20020a170902758500b00192d9258512sm27578041pll.154.2023.01.20.18.43.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 18:43:13 -0800 (PST)
Message-ID: <6b1fa9a4-a06b-4b47-023d-b52f4efae6e5@kernel.dk>
Date:   Fri, 20 Jan 2023 19:43:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 1/9] block: Introduce QUEUE_FLAG_SUB_PAGE_SEGMENTS and
 CONFIG_BLK_SUB_PAGE_SEGMENTS
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>
References: <20230118225447.2809787-1-bvanassche@acm.org>
 <20230118225447.2809787-2-bvanassche@acm.org>
 <4f308b47-e08c-efa6-6a86-965ba6761350@kernel.dk>
 <f1317a6f-9c74-b41d-749e-f9dc34f0ad80@acm.org>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f1317a6f-9c74-b41d-749e-f9dc34f0ad80@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/20/23 5:11?PM, Bart Van Assche wrote:
> On 1/18/23 15:02, Jens Axboe wrote:
>> On 1/18/23 3:54?PM, Bart Van Assche wrote:
>>> Prepare for introducing support for segments smaller than the page size
>>> by introducing the request queue flag QUEUE_FLAG_SUB_PAGE_SEGMENTS.
>>> Introduce CONFIG_BLK_SUB_PAGE_SEGMENTS to prevent that performance of
>>> block drivers that support segments >= PAGE_SIZE would be affected.
>>>
>>> Cc: Christoph Hellwig <hch@lst.de>
>>> Cc: Ming Lei <ming.lei@redhat.com>
>>> Cc: Keith Busch <kbusch@kernel.org>
>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>> ---
>>>   block/Kconfig          | 9 +++++++++
>>>   include/linux/blkdev.h | 7 +++++++
>>>   2 files changed, 16 insertions(+)
>>>
>>> diff --git a/block/Kconfig b/block/Kconfig
>>> index 5d9d9c84d516..e85061d2175b 100644
>>> --- a/block/Kconfig
>>> +++ b/block/Kconfig
>>> @@ -35,6 +35,15 @@ config BLOCK_LEGACY_AUTOLOAD
>>>         created on demand, but scripts that manually create device nodes and
>>>         then call losetup might rely on this behavior.
>>>   +config BLK_SUB_PAGE_SEGMENTS
>>> +       bool "Support segments smaller than the page size"
>>> +       default n
>>> +       help
>>> +      Most storage controllers support DMA segments larger than the typical
>>> +      size of a virtual memory page. Some embedded controllers only support
>>> +      DMA segments smaller than the page size. Enable this option to support
>>> +      such controllers.
>>
>> This should not be a visible option at all, affected drivers should just
>> select it.
> 
> Hi Jens,
> 
> If CONFIG_BLK_SUB_PAGE_SEGMENTS is made invisible, how should this
> option be enabled for the scsi_debug and null_blk drivers? Adding
> "select BLK_SUB_PAGE_SEGMENTS" to the Kconfig section of these drivers
> would have the unfortunate side effect that enabling either driver
> would make all block drivers slower. How about making sub-page segment
> support configurable for the scsi_debug and null_blk drivers only?
> That would allow kernel developers who want to test the sub-page
> segment support to enable this functionality without making e.g.
> distro kernels slower.

You'd need to have a separate sub-option for each of them, Kconfig
style. But this also highlights the usual issue with pretending that
Kconfig options means that this doesn't matter, because inevitably they
end up getting enabled by default in distros anyway. And then you may as
well not even have them...

Why can't we just handle this in the driver? The segment path is hard
enough to grok in the first place, and this just makes it worse.
Generally not a huge fan of punting this to the driver, but just maybe
it'd make sense in this case since it's just the one. At least that
seems a lot more palatable than the alternative.

-- 
Jens Axboe


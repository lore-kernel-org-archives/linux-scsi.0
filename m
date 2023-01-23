Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81E17C25B50
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 19:58:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbjAWT6d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 14:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbjAWT6c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 14:58:32 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA7E27D68;
        Mon, 23 Jan 2023 11:58:31 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id z4-20020a17090a170400b00226d331390cso12000560pjd.5;
        Mon, 23 Jan 2023 11:58:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GImCMdHtN1051Hi4rO3ytDSWOitU9SLLUPh7VcfKUPs=;
        b=3YO8nf3sW93cLd8duQGu8N8F2g1g1738+s1cIK252627puN1KVe24/CHLG8+O4KHzI
         nyP76TV8KtYthcGycwUf21VJK9MBSvpedohgMiqFXiPkUwcmDPceHLj5L86+ZYQzmG9D
         yI5sVeF1y7T4zsRTbpv2QyYgOP99L5APX9G9AXTgK383nlv33cmYQzEaC94dPjjsdgUC
         bXsfcHwEnJUUbo28c5p3WU6cZ9PnaFdcj5zU8vEqS0gtQHcjOD0MiQ0P9y7fIvOkPBsf
         oFaE6a5HQAx3hNh6VGmNkK7vmglBW/dAgLxn4nzpc4jACW2e/87wU76oxeegGaf+ruyo
         3NWA==
X-Gm-Message-State: AFqh2kpw5dcuBA59vuo1QHTHTQFYqQHgRTjc1MfvXCGWqy7rMpP9GRsp
        4C1QFbmwtp6J2iShyY8zSFk=
X-Google-Smtp-Source: AMrXdXu1JCYGeF5F1CTumxD6hcIEXhDzQgrqyZL2V1zDBop8nlkjgsb/ryVYzQswxSJ5coB092jCmw==
X-Received: by 2002:a17:90a:460f:b0:227:23c3:5db1 with SMTP id w15-20020a17090a460f00b0022723c35db1mr26623924pjg.47.1674503911026;
        Mon, 23 Jan 2023 11:58:31 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:dbe2:4986:5f46:bb00? ([2620:15c:211:201:dbe2:4986:5f46:bb00])
        by smtp.gmail.com with ESMTPSA id p9-20020a17090a284900b0022b787fb08dsm6986130pjf.5.2023.01.23.11.58.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 11:58:30 -0800 (PST)
Message-ID: <31b21272-a17b-0dc6-756c-c990ff2c7ea7@acm.org>
Date:   Mon, 23 Jan 2023 11:58:28 -0800
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
 <f1317a6f-9c74-b41d-749e-f9dc34f0ad80@acm.org>
 <6b1fa9a4-a06b-4b47-023d-b52f4efae6e5@kernel.dk>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6b1fa9a4-a06b-4b47-023d-b52f4efae6e5@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/20/23 18:43, Jens Axboe wrote:
> On 1/20/23 5:11?PM, Bart Van Assche wrote:
>> If CONFIG_BLK_SUB_PAGE_SEGMENTS is made invisible, how should this
>> option be enabled for the scsi_debug and null_blk drivers? Adding
>> "select BLK_SUB_PAGE_SEGMENTS" to the Kconfig section of these drivers
>> would have the unfortunate side effect that enabling either driver
>> would make all block drivers slower. How about making sub-page segment
>> support configurable for the scsi_debug and null_blk drivers only?
>> That would allow kernel developers who want to test the sub-page
>> segment support to enable this functionality without making e.g.
>> distro kernels slower.
> 
> You'd need to have a separate sub-option for each of them, Kconfig
> style. But this also highlights the usual issue with pretending that
> Kconfig options means that this doesn't matter, because inevitably they
> end up getting enabled by default in distros anyway. And then you may as
> well not even have them...

Hi Jens,

How about the following approach?
* Remove CONFIG_BLK_SUB_PAGE_SEGMENTS.
* Use the static key mechanism instead of #ifdef
   CONFIG_BLK_SUB_PAGE_SEGMENTS to prevent that this patch series makes
   the hot path in the block layer slower.
* Count the number of request queues that need support for segments
   smaller than a page or max_hw_sector values smaller than
   PAGE_SIZE >> SECTOR_SHIFT. If that number changes from zero to one,
   enable the code introduced by this patch series. If that number drops
   to zero, toggle the static key such that the overhead of the code that
   supports small segments is eliminated.

> Why can't we just handle this in the driver? The segment path is hard
> enough to grok in the first place, and this just makes it worse.
> Generally not a huge fan of punting this to the driver, but just maybe
> it'd make sense in this case since it's just the one. At least that
> seems a lot more palatable than the alternative.

One of the functions modified by this patch series is 
blk_rq_append_bio(). That function is called by code that builds a bio 
(e.g. filesystems). Code that builds a bio does not call any block 
driver code. This is why I think it would be hard to move the 
functionality introduced by this patch series into block drivers.

Thanks,

Bart.



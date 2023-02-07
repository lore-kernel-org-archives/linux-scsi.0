Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 917BCC636D3
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Feb 2023 18:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbjBGS1I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Feb 2023 13:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbjBGS1H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2023 13:27:07 -0500
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF4F6EB6;
        Tue,  7 Feb 2023 10:26:42 -0800 (PST)
Received: by mail-pl1-f171.google.com with SMTP id iy2so6423596plb.11;
        Tue, 07 Feb 2023 10:26:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OYHp2ts2Cd4biba4exHlCAA6w0pxpQp8qxcKkWtwtMk=;
        b=vYSc09h66X9lIEMN0+wx6ho8Fn/9eIkBO1eduYfZpFJb7oA/5ExKgpetPs0DWOOrKj
         SPpNwOnjp8EhaOHUrvFp5dJBNywdgaND1U8JNxTmUs99XRqvi7cF2eEdeqWv5W/lZ7p3
         c/kpDGpS9mjXiKQKRn05IEtxDgiSByVpm5apicFjQwweKGtVwEodN3sgmDZUulg1CtQh
         7lrxe5rbAUIQVL0/rOHOCt9wFy9quZZXIspztTD1NutsnkdrY/m0NFCrP6cxqS0reiiA
         krFj0fZ/XOZXRxLIzScbzgkDU7aBjLuY5KzIy8eNP0TJ4wv6GQDhR1mVYEeahGjxbflR
         Uliw==
X-Gm-Message-State: AO0yUKVhYiuGiJf37GyFCCmGp+/NzKKFbpVNCgRwYpOIdIXauRyWG02Q
        WaXJExF61OvxpJkKkCyIDPg=
X-Google-Smtp-Source: AK7set8fdT0ialgK/QEbPbgNHHzOpGfsJSXnt1cCW1M05ds5Pnwv+j8TZln9gIp8AzCApM34jdSy9w==
X-Received: by 2002:a05:6a20:1e43:b0:bc:5a6:1b2a with SMTP id cy3-20020a056a201e4300b000bc05a61b2amr3830357pzb.49.1675794401208;
        Tue, 07 Feb 2023 10:26:41 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:1000:8a4b:e165:69ed? ([2620:15c:211:201:1000:8a4b:e165:69ed])
        by smtp.gmail.com with ESMTPSA id l9-20020a056a00140900b00593edee1af6sm9605590pfu.67.2023.02.07.10.26.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 10:26:40 -0800 (PST)
Message-ID: <36a712ed-994f-319b-ff41-65fd4eb28d32@acm.org>
Date:   Tue, 7 Feb 2023 10:26:38 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v4 2/7] block: Support configuring limits below the page
 size
Content-Language: en-US
To:     Luis Chamberlain <mcgrof@kernel.org>,
        =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier.gonz@samsung.com>
Cc:     Pankaj Raghav <p.raghav@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>
References: <20230130212656.876311-1-bvanassche@acm.org>
 <20230130212656.876311-3-bvanassche@acm.org>
 <20230201235038.nnayavxpadq5yj34@garbanzo>
 <24b34999-8f7c-7821-0b15-fdfc3f508b13@acm.org>
 <Y+GZFoHiUOQeq25d@bombadil.infradead.org>
 <bee64ad1-a465-123e-4208-013e7dd69e04@acm.org>
 <Y+Gyj5pFkhIKY32K@bombadil.infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Y+Gyj5pFkhIKY32K@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/6/23 18:08, Luis Chamberlain wrote:
> On Mon, Feb 06, 2023 at 04:31:58PM -0800, Bart Van Assche wrote:
>> On 2/6/23 16:19, Luis Chamberlain wrote:
>>> But I'm trying to do a careful review here.
>>
>> That's appreciated :-)
>>
>>> The commit log did not describe what *does* happen in these situations today,
>>> and you seem to now be suggesting in the worst case corruption can happen.
>>> That changes the patch context quite a bit!
>>>
>>> My question above still stands though, how many block drivers have a max
>>> hw sector smaller than the equivalent PAGE_SIZE. If you make your
>>> change, even if it fixes some new use case where corruption is seen, can
>>> it regress some old use cases for some old controllers?
>>
>> The blk_queue_max_hw_sectors() change has been requested by a contributor to
>> the MMC driver (I'm not familiar with the MMC driver).
>>
>> I'm not aware of any storage controllers for which the maximum segment size
>> is below 4 KiB.
> 
> Then the commit log should mention that. Because do you admit that it
> could possible change their behaviour?

I will make the commit message more detailed.

>> For some storage controllers, e.g. the UFS Exynos controller, the maximum
>> supported segment size is 4 KiB. This patch series makes such storage
>> controllers compatible with larger page sizes, e.g. 16 KiB.
>>
>> Does this answer your question?
> 
> Does mine answer the reason to why I am asking it? If we are sure these
> don't exist then please mention it in the commit log. And also more
> importantly the possible corruption issue you describe which could
> happen! Was a corruption actually observed in real life or reported!?

Incorrect data transfers have been observed in our tests. We noticed in 
our tests with the Exynos controller and PAGE_SIZE = 16 KiB that booting 
fails without this patch series. I think booting failed because the DMA 
engine in this controller was asked to perform transfers that fall 
outside the supported limits. I expect similar behavior for all other 
storage controllers with a DMA engine.

Bart.


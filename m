Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D9CC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 20:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 987646054F
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 20:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345906AbhIIUlj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Sep 2021 16:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345878AbhIIUli (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Sep 2021 16:41:38 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819D3C061756
        for <linux-scsi@vger.kernel.org>; Thu,  9 Sep 2021 13:40:28 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id a22so4040181iok.12
        for <linux-scsi@vger.kernel.org>; Thu, 09 Sep 2021 13:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K661PKSm8ynNfd3M9m5f/SuYoVkqWyuufk1lZufUBHI=;
        b=Kk49WXxGI4Lm6oaick7648IphOhBS9iGNDV1xXGwJbd0rdMIB47VoA8nMiXOWl9UQs
         bYhSg05tYWKWNgcVoGBdRV+cmajWLDQssFcmP69L3jTYM304T4ZfMJs9RqPc2cuj+MCM
         JwPJnHtWzemcF2VZRhb/VuDZ6tpCzw0r1iZgNZBT30seCXRpSiPziFCzFP9K69dakV5p
         HEABxn5yQcYRvplLjvrop7knvZZjPRkI9MbLYxq89liyYA83YdzBZgtuq7n6Iy0ZJknq
         KARnvP+RUFC4rxW0I//8DUpmcBvvLA8IN/662fSWOXzBRDqj+VBM65Z6FwyY7MKZi3yw
         Au9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K661PKSm8ynNfd3M9m5f/SuYoVkqWyuufk1lZufUBHI=;
        b=y/iKu544cyPMmqauYZdaMWNvuWZORfopO0qo6LJ7dUPfsIrmt0MQ3BSmiBrEWJyd6f
         67yhVMN6i2rDArZw8cMtTAkeSqIlgD7RK5XdEWJKDoxdR4QGywBiGlgLHnuVKTwWrXMi
         j7tyfSsjYWfpxtQAiY6VZVGr+ZOsGUNmX87WVzRMww1M/hmKZLOOp2esEzj19rSfWBlY
         Sn2yJJSn8hkF+wv2ChnINRT88pQYTaRqL9giawWWM4ZR/LJp37i2Mk0ZTD01Q1RnwNli
         nObZEg4ZiHgKQceMrCMxMTJeAW6XQOw7u5lejFjosPWwuK4SmTucgLL1Vie/rtiqYHKo
         vFIw==
X-Gm-Message-State: AOAM531nuQ2vTwK/wILAGrrwHYt1KwjqvHzKStKbXj3U7kmpQFUlgAOL
        qVygOy5msXir2BxHMuRCvKf4xQ==
X-Google-Smtp-Source: ABdhPJyZrfEvanEj4R5uDT0596howBbcNyxuQ3962MrXM6rhaRXofB110KBrxiJbUlwOOkSa8+BpmQ==
X-Received: by 2002:a05:6602:2ac7:: with SMTP id m7mr4226626iov.66.1631220027881;
        Thu, 09 Sep 2021 13:40:27 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t11sm1387116ilf.16.2021.09.09.13.40.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 13:40:27 -0700 (PDT)
Subject: Re: [PATCH] scsi: bsg: Fix device unregistration
To:     Zenghui Yu <yuzenghui@huawei.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     fujita.tomonori@lab.ntt.co.jp, martin.petersen@oracle.com,
        hch@lst.de, gregkh@linuxfoundation.org, wanghaibin.wang@huawei.com
References: <20210909034608.1435-1-yuzenghui@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <78c3c08b-ebba-8d46-7eae-f82d0b1c50fe@kernel.dk>
Date:   Thu, 9 Sep 2021 14:40:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210909034608.1435-1-yuzenghui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/8/21 9:46 PM, Zenghui Yu wrote:
> We use device_initialize() to take refcount for the device but forget to
> put_device() on device teardown, which ends up leaking private data of the
> driver core, dev_name(), etc. This is reported by kmemleak at boot time if
> we compile kernel with DEBUG_TEST_DRIVER_REMOVE.
> 
> Note that adding the missing put_device() is _not_ sufficient to fix device
> unregistration. As we don't provide the .release() method for device, which
> turned out to be typically wrong and will be complained loudly by the
> driver core.
> 
> Fix both of them.

Applied, thanks.

-- 
Jens Axboe


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C426C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 20:42:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 520886113E
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 20:42:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345508AbhIIUnW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Sep 2021 16:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245624AbhIIUnV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Sep 2021 16:43:21 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF2BC061574
        for <linux-scsi@vger.kernel.org>; Thu,  9 Sep 2021 13:42:12 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id b7so4074842iob.4
        for <linux-scsi@vger.kernel.org>; Thu, 09 Sep 2021 13:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VMwlM4GyMZLXj8Fib8keX4XRi0UDBn+ujtEneqseAMU=;
        b=jDwT6b38OSIO6dlAh50hbay4fjrqkM8GLiVdhZTZXBBlD7OdbOkbGoLZo0uUvA463U
         7N1kBmkmWqrazTDs9egtgdslGoFE+huJQCrJ/MIe9VQfm1jWhLplnQ8xzUXbvoB8RKWm
         doKi9I2kCw0tCx+7g2+JZitd5Akx+ZWofu8RJMti8mc0H+v/d6AXK00/TIwSPJKvvtHg
         J8nTf7SG/xOvND0trDnMzMvgWsVnFuPpfnbrXXDDwYrQHr6S+cRPxdwIO3L9d93Y8N5q
         okBjG3D/4ZUiPNCO6cQRG7g2GdxEWJ36Yzpdy5N7d4BT6ipCrrO5pIywyf4A/L/KgOz2
         nW6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VMwlM4GyMZLXj8Fib8keX4XRi0UDBn+ujtEneqseAMU=;
        b=L7J6OnKPHUUlgYp41FdwQuqahr8yGDudZFssyLzIeNQztEMQChNTYgyk0ea3ElS6YY
         5ag7IMBKa6p+0VBC1y/j66QXGTWa+rF2ei5+MYDHrZCiTmXmk1IxUC9hNFGSx/0505S2
         8Xg40urcV71IBbsd/nDoBvalVjbtkWJ4ZAOXbDtM+zAg7iHvPaseV8wOYlQw81obSnke
         o5KCUwanW0ux9ubSXpQE15pSHrnCBMfNVtOJQINXtrDX5aHXspSpRI4+9u5Go6W5PJOu
         0nf6a1Qz+eo7EkbG9/hwwEHYrQ89LylLzn56IX9IkUY1NYa15Lvc9cA1XeqA8+gsxDTE
         hZ6A==
X-Gm-Message-State: AOAM5330+815Rwt7gLHJcuOFGHnmH2wvuAUUw8u3LP+aYS59cOOrEElQ
        Dz2f9he++mCRTZE5Tf+pn+d7Vw==
X-Google-Smtp-Source: ABdhPJx5/GznvKhLT6rvGZ+4I8MGwh86gDp/0GuBtqVrWW7mCTLsptR8tMOZ/TBavfaj2qmNZbCtgg==
X-Received: by 2002:a05:6638:d11:: with SMTP id q17mr1496935jaj.63.1631220131553;
        Thu, 09 Sep 2021 13:42:11 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f3sm1339667ilu.85.2021.09.09.13.42.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 13:42:11 -0700 (PDT)
Subject: Re: [PATCH] scsi: bsg: Fix device unregistration
From:   Jens Axboe <axboe@kernel.dk>
To:     Zenghui Yu <yuzenghui@huawei.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     fujita.tomonori@lab.ntt.co.jp, martin.petersen@oracle.com,
        hch@lst.de, gregkh@linuxfoundation.org, wanghaibin.wang@huawei.com
References: <20210909034608.1435-1-yuzenghui@huawei.com>
 <78c3c08b-ebba-8d46-7eae-f82d0b1c50fe@kernel.dk>
Message-ID: <ac61cf8b-061e-dd96-1730-edec5a886c62@kernel.dk>
Date:   Thu, 9 Sep 2021 14:42:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <78c3c08b-ebba-8d46-7eae-f82d0b1c50fe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/9/21 2:40 PM, Jens Axboe wrote:
> On 9/8/21 9:46 PM, Zenghui Yu wrote:
>> We use device_initialize() to take refcount for the device but forget to
>> put_device() on device teardown, which ends up leaking private data of the
>> driver core, dev_name(), etc. This is reported by kmemleak at boot time if
>> we compile kernel with DEBUG_TEST_DRIVER_REMOVE.
>>
>> Note that adding the missing put_device() is _not_ sufficient to fix device
>> unregistration. As we don't provide the .release() method for device, which
>> turned out to be typically wrong and will be complained loudly by the
>> driver core.
>>
>> Fix both of them.
> 
> Applied, thanks.

Actually, let's move this through the SCSI tree, as the offending patch
went that way (and my branches are behind that point).

-- 
Jens Axboe


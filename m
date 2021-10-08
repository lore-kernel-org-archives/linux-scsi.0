Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD95C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 03:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D3AD60FDC
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 03:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbhJHDNG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 23:13:06 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:35590 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhJHDNF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 23:13:05 -0400
Received: by mail-pf1-f169.google.com with SMTP id c29so7010061pfp.2;
        Thu, 07 Oct 2021 20:11:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rLOkTDNXQRue7DStz70VlFnLnX3t0szG1FNVtaPMlsg=;
        b=zMJi0si6WhTch7SM4n3OJ8numdd2xW1ThpJXfj5yOARN2CMm+PFNcf3K1vWJjtzsbF
         p6Ik7MFeBPU2Y4jFX1G+zhOsgflqyNUNIa373mZidKTSQsGQTR4QaaVZRJD8SWntPilu
         PrVBH9XjqG3TjmworPYKmZrYd1I6wXm2qOGM/CaNtk+HBSkaMF3mWRYfBA6g7FOxMiPX
         D3IJq0J3mUmNLcCUOvH2CL9ecu8BxRQXb0FfxFKOWf4FmNtql5/CF8EvmxLHXlavRaY3
         UQZwRSB5Rr4BiNALdcg64NSMk+SyIz64QuXFoG9NDc9y77jpEap/LN3CEFR/BtvKBHiM
         aDGw==
X-Gm-Message-State: AOAM532bJ5EP+7gB86y0OCCTXR7tY823ybk5/HbuWRZ1gbBFHeHv8vuX
        kFnwzPgns1Vrkkc5pe0ITtk=
X-Google-Smtp-Source: ABdhPJx51wt6jP3tgXED0xnjgBGnPzOmyEzNtu0+eW1vyBuVUs42LmsYFErRQ+kLdJU4zGJaPCBlkQ==
X-Received: by 2002:a63:530e:: with SMTP id h14mr2648011pgb.279.1633662670722;
        Thu, 07 Oct 2021 20:11:10 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:9fa9:27d:6339:b8ef? ([2601:647:4000:d7:9fa9:27d:6339:b8ef])
        by smtp.gmail.com with ESMTPSA id g22sm784609pfj.15.2021.10.07.20.11.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 20:11:10 -0700 (PDT)
Message-ID: <597c4cbe-ca6c-53e5-1139-be2ca0fbb677@acm.org>
Date:   Thu, 7 Oct 2021 20:11:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH v5 00/14] blk-mq: Reduce static requests memory footprint
 for shared sbitmap
Content-Language: en-US
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        John Garry <john.garry@huawei.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        ming.lei@redhat.com, hare@suse.de, linux-scsi@vger.kernel.org
References: <1633429419-228500-1-git-send-email-john.garry@huawei.com>
 <ae33dde8-96e8-2978-5f32-c7e0a6136e8e@kernel.dk>
 <81d9e019-b730-221e-a8c0-f72a8422a2ec@huawei.com>
 <e4e92abbe9d52bcba6b8cc6c91c442cc@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e4e92abbe9d52bcba6b8cc6c91c442cc@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/7/21 13:31, Kashyap Desai wrote:
> I tested this patchset on 5.15-rc4 (master) -
> https://github.com/torvalds/linux.git
> 
> #1 I noticed some performance regression @mq-deadline scheduler which is not
> related to this series. I will bisect and get more detail about this issue
> separately.

Please test this patch series on top of Jens' for-next branch 
(git://git.kernel.dk/linux-block). The mq-deadline performance on Jens' 
for-next branch should match that of kernel v5.13.

Thanks,

Bart.

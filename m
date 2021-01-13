Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E526FC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 18:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F0C6230F9
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 18:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbhAMR7y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 12:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727198AbhAMR7y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 12:59:54 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0237C061786;
        Wed, 13 Jan 2021 09:59:13 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id e18so4305905ejt.12;
        Wed, 13 Jan 2021 09:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K3lJSkAmIONPcPf9xd+9VR4Fox3bOonPKOs/UyGeHBg=;
        b=IiVJwDFjknV0MCeRm+zflcNlKRlgNisAvliRi4aqQzoHrZbPMoS9Wf7DwhquZZTKrM
         Y0mg8t8ESlugD2Je3+BvIi3QmnBK5kzzgAxlWWR9VJNm7HcCj7/nRVsFMAlx/n1Cnp/a
         fpAwe5Zn1Y0IDz4CyEwFeLkybolvmLxhXEkxXAbQGA0cvfOET9iIvxawE1ner/q6Kf87
         Qr15Ikh5cOQK20+X/3GZa3vcDOVtmp1uz3abAfzzSNrctw50jdUmRc5hTGpdPQZYgqgM
         Xz4CZgOQLgp7/sls8INl4Hx8rxaHSIkHhKhlVaEGaMEa4NWdLeImdrSfPwPy8joUq5hj
         dD/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K3lJSkAmIONPcPf9xd+9VR4Fox3bOonPKOs/UyGeHBg=;
        b=MrMcgjMfXho/Pe5mPDeg6K4IAhf0auYOxwB8WNsap2MSdLNGu9AiFlrqo+1iE6nYC8
         k2XLlxhP8d+6MXGXYK3G1dWgnnPRvbc6eoEW82yaTgy0RRdXaS/MsvYGYnC4u2IHoqK9
         e18OUaqC6kUJFQHdFWrU9/8ht4gA41vFVCW5J7Mx8LsHaG9yO/uLmgeZj8xiZCrLIE0J
         VOjR/0mhUoDLvgMAPHIBFTmJvLesTJyDELzYLQ0OeaIe9NIU1maLyd7iyuemQBVvBcyh
         WjAWMvpXK8kpdLQl/yvQaDUfQjbreyDIXLIee+iN50T9AYQO/4hQIdoBCUpZFcnIVpS1
         s+Hg==
X-Gm-Message-State: AOAM530Wa0KM2JiWNMPAKnGsjja5J5LfODzCZWhImqFtinolSB5F2iap
        RmFebWBY7Y91Ne7zrtOSseg=
X-Google-Smtp-Source: ABdhPJyGambVBXGSTAkUy+ghOTP6gayM2fFu5Hn60IlqUncvDPpABHsO1R6RzDQwW4DQ9fUwfwXGbA==
X-Received: by 2002:a17:907:20a6:: with SMTP id pw6mr2503938ejb.73.1610560752516;
        Wed, 13 Jan 2021 09:59:12 -0800 (PST)
Received: from [192.168.178.40] (ipbcc05d1b.dynamic.kabel-deutschland.de. [188.192.93.27])
        by smtp.gmail.com with ESMTPSA id x9sm989146ejd.99.2021.01.13.09.59.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 09:59:11 -0800 (PST)
Subject: Re: [PATCH] scsi: target: tcmu: Fix wrong uio handling causing big
 memory leak
To:     Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20201218141534.9918-1-bostroesser@gmail.com>
 <73dc2d01-6398-c1d1-df47-66034d184eec@oracle.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <aa95b4db-ca88-e38c-3871-fb935f1e2212@gmail.com>
Date:   Wed, 13 Jan 2021 18:59:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <73dc2d01-6398-c1d1-df47-66034d184eec@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12.01.21 19:36, Mike Christie wrote:
> On 12/18/20 8:15 AM, Bodo Stroesser wrote:
>> tcmu calls uio_unregister_device from tcmu_destroy_device.
>> After that uio will never call tcmu_release for this device.
>> If userspace still had the uio device open and / or mmap'ed
>> during uio_unregister_device, tcmu_release will not be called and
>> udev->kref will never go down to 0.
>>
> 
> I didn't get why the release function is not called if you call
> uio_unregister_device while a device is open. Does the device_destroy call in
> uio_unregister_device completely free the device or does it set some bits so
> uio_release is not called later?

uio_unregister_device() resets the pointer (idev->info) to the struct 
uio_info which tcmu provided in uio_register_device().
The uio device itself AFAICS is kept while it is open / mmap'ed.
But no matter what userspace does, uio will not call tcmu's callbacks
since info pointer now is NULL.

When userspace finally closes the uio device, uio_release is called, but
tcmu_release can not be called.

> 
> Do other drivers hit this? Should uio have refcounting so uio_release is called
> when the last ref (from userspace open/close/mmap calls and from the kernel by
> drivers like target_core_user) is done?
> 

To be honest I don't know exactly.
tcmu seems to be a special case in that is has it's own mmap callback.
That allows us to map pages allocated by tcmu.
As long as userspace still holds the mapping, we should not unmap those
pages, because userspace then could get killed by SIGSEGV.
So we have to wait for userspace closing uio before we may unmap and
free the pages.

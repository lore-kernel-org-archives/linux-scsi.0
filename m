Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45913C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 16:51:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19CEF23B40
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 16:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbhANQur (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 11:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727214AbhANQuq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 11:50:46 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57007C061574;
        Thu, 14 Jan 2021 08:50:06 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id hs11so6827322ejc.1;
        Thu, 14 Jan 2021 08:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tlbKPE7uTZZR7ghtrcJbjkI4MtAdaHYk7YXhrBrERiw=;
        b=LFAVkpoOP4ym75SjjeKlxMP30bXZQd/la1MU80s7ATLCMNl0imGhVeCf7r3Ez0HBDp
         RHzpPCwZaYHxxvtA2Y1icrrWVut3k36nkOU6YQYAT+NR3ok2ZmwZQRwwT2H5iB++Qfqc
         ceky3/JElTRWxv7RMlsUtfT5/PRZEJgE0x/gOsfzpbagjgfs2KjhvrMebcHHrL2T3TFe
         GZwgvq8qokbl3DJrvZHJB4lfJhHQwylxtpkDCKZP/vzPwFCFAaNwTJewdztJs8EgP1Go
         eyvLhVg89sfGJ+TWStdce2c4WMyiJ7VwIPM3um7WILmyZD9s2uPxcfs23cnjUYMn2QET
         FDfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tlbKPE7uTZZR7ghtrcJbjkI4MtAdaHYk7YXhrBrERiw=;
        b=MFinXC89tsjNv4shlLp7yiDi5zaUbdR3y6lfSu4tPYTcB5K0RIUlTEsErZcFzp5vSm
         6pLoTS7vUAIBFJF0YEmfSPwPRfExvsJWFnDfb2FES0Mjjy8rN1hEyC11yiinNqkIInkP
         TIZnjCjnIDn5mZ32i1K8IfB2I+rtgAGb727b+PYmX/4yoapt5leFDaLF8xBNXuq3gmsn
         RW9e7fsOp+w38/UpgmGwPX4PASWK/NFJ4Jy+EyUqmqYVljNUYUhVmAwjYxisWK6iBPSp
         4pI/0SVv4XlVYX70tWka1JazQtGm268Ri/zFxcDt7rrkoOTPYnpqV2KuK2bLVH5re6dX
         jCqg==
X-Gm-Message-State: AOAM531BPW2xqlJd/KcmOh/LWP49PryadcQgGH0NBkQm1wmk5ApDx3f2
        8gixerYAfkOuPUy3oBH0wJc=
X-Google-Smtp-Source: ABdhPJznUfoVSAxoHGale9B+KIbksfqRnSUgxQr4Tq75l4SnGXbgepoKsdJ4RyW5ZAWJ7H77RCFaKQ==
X-Received: by 2002:a17:906:2695:: with SMTP id t21mr6155193ejc.287.1610643005032;
        Thu, 14 Jan 2021 08:50:05 -0800 (PST)
Received: from [192.168.178.40] (ipbcc05d1b.dynamic.kabel-deutschland.de. [188.192.93.27])
        by smtp.gmail.com with ESMTPSA id bo20sm2435232edb.1.2021.01.14.08.50.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 08:50:04 -0800 (PST)
Subject: Re: [PATCH] scsi: target: tcmu: Fix wrong uio handling causing big
 memory leak
To:     Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20201218141534.9918-1-bostroesser@gmail.com>
 <73dc2d01-6398-c1d1-df47-66034d184eec@oracle.com>
 <aa95b4db-ca88-e38c-3871-fb935f1e2212@gmail.com>
 <3caa89ba-47b8-d85c-e7a5-54d84d1471f0@oracle.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <f2bf0c02-0d44-4b75-7c36-5d5fb213d747@gmail.com>
Date:   Thu, 14 Jan 2021 17:50:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3caa89ba-47b8-d85c-e7a5-54d84d1471f0@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13.01.21 22:04, Mike Christie wrote:
> On 1/13/21 11:59 AM, Bodo Stroesser wrote:
>> On 12.01.21 19:36, Mike Christie wrote:
>>> On 12/18/20 8:15 AM, Bodo Stroesser wrote:
>>>> tcmu calls uio_unregister_device from tcmu_destroy_device.
>>>> After that uio will never call tcmu_release for this device.
>>>> If userspace still had the uio device open and / or mmap'ed
>>>> during uio_unregister_device, tcmu_release will not be called and
>>>> udev->kref will never go down to 0.
>>>>
>>>
>>> I didn't get why the release function is not called if you call
>>> uio_unregister_device while a device is open. Does the device_destroy call in
>>> uio_unregister_device completely free the device or does it set some bits so
>>> uio_release is not called later?
>>
>> uio_unregister_device() resets the pointer (idev->info) to the struct uio_info which tcmu provided in uio_register_device().
>> The uio device itself AFAICS is kept while it is open / mmap'ed.
>> But no matter what userspace does, uio will not call tcmu's callbacks
>> since info pointer now is NULL.
>>
>> When userspace finally closes the uio device, uio_release is called, but
>> tcmu_release can not be called.
>>
>>>
>>> Do other drivers hit this? Should uio have refcounting so uio_release is called
>>> when the last ref (from userspace open/close/mmap calls and from the kernel by
>>> drivers like target_core_user) is done?
>>>
>>
>> To be honest I don't know exactly.
>> tcmu seems to be a special case in that is has it's own mmap callback.
>> That allows us to map pages allocated by tcmu.
>> As long as userspace still holds the mapping, we should not unmap those
>> pages, because userspace then could get killed by SIGSEGV.
>> So we have to wait for userspace closing uio before we may unmap and
>> free the pages.
> 
> 
> If we removed the clearing of idev->info in uio_unregister_device, and
> then moved the idev->info->release call from uio_release to
> uio_device_release it would work like you need right? The release callback
> would always be called and called when userspace has dropped it's refs.
> You need to also fix up the module refcount and some other bits because
> it looks like uio uses the uio->info check to determine if the device is
> being removed.

I fear that would not work, because uio_release must be called always,
no matter whether userspace closes the device before or after
uio_unregister_device.

But we could add a new callback pointer 'late_release' to struct
uio_info and struct uio_device. During uio_register_device we would
copy the pointer from info to idev.

If info == NULL, uio_release calls idev->late_release if != NULL.

tcmu would of course set info->release and ->late_release both to
tcmu_release.

> 
> I don't know if that is the correct approach. It looks like non
> target_core_user drivers could hit a similar issue. It seems like drivers
> like qedi/bnx2i could hit the issue if their port is removed from the
> kernel before their uio daemon closes the device. However, they also
> could do a driver specific fix and handle the issue by adding some extra
> kernel/userspace bits to sync the port removal.
> 

I had a closer look into qedi. I assume there might be a leak also,
because qedi_uio_close calls "qedi_ll2_free_skbs(qedi)".

Unfortunately my above proposal would not work here without adding a
new refcount to qedi_uio_dev, because currently in __qedi_free_uio
the udev is freed shortly after uio_unregister_device. So later calls
of qedi_uio_close(udev) would be harmful.

But I guess the leak can be fixed by adding two lines after the
uio_unregister_device() in __qedi_free_uio:

	if (test_bit(UIO_DEV_OPENED, &udev->qedi->flags)
		qedi_ll2_free_skbs(qedi);

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2345C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 19:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E9B264E35
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 19:57:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbhBJT55 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 14:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbhBJT5y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 14:57:54 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF4BC061756;
        Wed, 10 Feb 2021 11:57:13 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id a9so6367992ejr.2;
        Wed, 10 Feb 2021 11:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ppjX8xfUsw0JJlSdyTmPLEULTDnO9P+JMAkdzafPbp4=;
        b=BJ2sBhvLtgNe8iL1KtePm6mJxazwweMY4FobnfBorVj0A928skm2IN57QSFCBFLHUT
         J3/+amfRbro3Re5ei4HS8lf/8noBlT8XDVGWBbsJMYg9mriWDZgAHV5IdiGpFm48vzNS
         qqcRPV3A7/vxa20PJMUo/W96I/h2/tOIaKQQj+U/9rLOgP9omQq5Ny5k2uPS5qoo9HO3
         Ltnrc2S9mePjnyhB5XJK1Pq14CIf5YQ6xu0QDL38ZUn5ddmhClweNRwl1a6a1BBdoH+N
         DYgW+PBMcojURkuTofG8QbaM5A7Rx+MMTF8DM3nVri7d3ZPrh6R9vPcecCzXTaWtcCh3
         /8wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ppjX8xfUsw0JJlSdyTmPLEULTDnO9P+JMAkdzafPbp4=;
        b=LqFqdWD2IDRYyRDAGxkcGLimebX90VMDMXyQMxWZ1ceAy/FmvsNx45qX2hjq9ccZDw
         ST+foJUMcsgIew4wvn6RTgErxR/B5OrdYwUwg4lxK5no1r3PFh/xGZ9h8OkE4gPwpEG/
         9foIcOtX/NrydcZRAVgbmgo/0MwvqdOo8laovjRY1i/XJnm1qBZfAtSbB3O14jTuW1n9
         HwN3BEAilKY7od/h7nSGFbJM+WZ2BPDlPnPBDt5NU9uww/o9iWOFpK3bLW09NJR9d64n
         AuiusmTfc/JSt/fV1/rZebmAaTDENFcBNDG1NYOa6mTCI+1exHrQHzq4o6x+/pr4Dd9z
         j9eA==
X-Gm-Message-State: AOAM530d3gilG/gPHX5u1oBWO7td6M98t5qT/YCzvLjfDCINheOrUIVq
        ulHsnSoblIXpqKIH30TsyaA=
X-Google-Smtp-Source: ABdhPJyHta2aTRFovXvWLxieuqjN4Yna/ed99rJNt7hcG0RWPuod4iqiNrXGrUgK5cFA3vS8SLU/sA==
X-Received: by 2002:a17:907:724a:: with SMTP id ds10mr4522159ejc.28.1612987032650;
        Wed, 10 Feb 2021 11:57:12 -0800 (PST)
Received: from [192.168.178.40] (ipbcc06d06.dynamic.kabel-deutschland.de. [188.192.109.6])
        by smtp.gmail.com with ESMTPSA id v20sm1870517edt.3.2021.02.10.11.57.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 11:57:12 -0800 (PST)
Subject: Re: [PATCH 1/2] uio: Add late_release callback to uio_info
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
References: <20210210194031.7422-1-bostroesser@gmail.com>
 <20210210194031.7422-2-bostroesser@gmail.com> <YCQ4aEz29P26ZxaL@kroah.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <7bc9eef9-0a9e-58a9-11f1-2c32010c70f0@gmail.com>
Date:   Wed, 10 Feb 2021 20:57:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YCQ4aEz29P26ZxaL@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10.02.21 20:47, Greg Kroah-Hartman wrote:
> On Wed, Feb 10, 2021 at 08:40:30PM +0100, Bodo Stroesser wrote:
>> If uio_unregister_device() is called while userspace daemon
>> still holds the uio device open or mmap'ed, uio will not call
>> uio_info->release() on later close / munmap.
>>
>> At least one user of uio (tcmu) should not free resources (pages
>> allocated by tcmu which are mmap'ed to userspace) while uio
>> device still is open, because that could cause userspace daemon
>> to be killed by SIGSEGV or SIGBUS. Therefore tcmu frees the
>> pages only after it called uio_unregister_device _and_ the device
>> was closed.
>> So, uio not calling uio_info->release causes trouble.
>> tcmu currently leaks memory in that case.
>>
>> Just waiting for userspace daemon to exit before calling
>> uio_unregister_device I think is not the right solution, because
>> daemon would not become aware of kernel code wanting to destroy
>> the uio device.
>> After uio_unregister_device was called, reading or writing the
>> uio device returns -EIO, which normally results in daemon exit.
>>
>> This patch adds new callback pointer 'late_release' to struct
>> uio_info. If uio user sets this callback, it will be called by
>> uio if userspace closes / munmaps the device after
>> uio_unregister_device was executed.
>>
>> That way we can use uio_unregister_device() to notify userspace
>> that we are going to destroy the device, but still get a call
>> to late_release when uio device is finally closed.
>>
>> Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
>> ---
>>   Documentation/driver-api/uio-howto.rst | 10 ++++++++++
>>   drivers/uio/uio.c                      |  4 ++++
>>   include/linux/uio_driver.h             |  4 ++++
>>   3 files changed, 18 insertions(+)
>>
>> diff --git a/Documentation/driver-api/uio-howto.rst b/Documentation/driver-api/uio-howto.rst
>> index 907ffa3b38f5..a2d57a7d623a 100644
>> --- a/Documentation/driver-api/uio-howto.rst
>> +++ b/Documentation/driver-api/uio-howto.rst
>> @@ -265,6 +265,16 @@ the members are required, others are optional.
>>      function. The parameter ``irq_on`` will be 0 to disable interrupts
>>      and 1 to enable them.
>>   
>> +-  ``int (*late_release)(struct uio_info *info, struct inode *inode)``:
>> +   Optional. If you define your own :c:func:`open()`, you will
>> +   in certain cases also want a custom :c:func:`late_release()`
>> +   function. If uio device is unregistered - by calling
>> +   :c:func:`uio_unregister_device()` - while it is open or mmap'ed by
>> +   userspace, the custom :c:func:`release()` function will not be
>> +   called when userspace later closes the device. An optionally
>> +   specified :c:func:`late_release()` function will be called in that
>> +   situation.
>> +
>>   Usually, your device will have one or more memory regions that can be
>>   mapped to user space. For each region, you have to set up a
>>   ``struct uio_mem`` in the ``mem[]`` array. Here's a description of the
>> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
>> index ea96e319c8a0..0b2636f8d373 100644
>> --- a/drivers/uio/uio.c
>> +++ b/drivers/uio/uio.c
>> @@ -532,6 +532,8 @@ static int uio_release(struct inode *inode, struct file *filep)
>>   	mutex_lock(&idev->info_lock);
>>   	if (idev->info && idev->info->release)
>>   		ret = idev->info->release(idev->info, inode);
>> +	else if (idev->late_info && idev->late_info->late_release)
>> +		ret = idev->late_info->late_release(idev->late_info, inode);
>>   	mutex_unlock(&idev->info_lock);
> 
> Why can't release() be called here?  Why doesn't your driver define a
> release() if it cares about this information?  Why do we need 2
> different callbacks that fire at exactly the same time?
> 
> This feels really wrong.
> 
> greg k-h
> 

tcmu has a release callback. But uio can't call it after
uio_unregister_device was executed, because in uio_unregister_device
uio sets the uio_device::info to NULL.

So, uio would never call both callbacks for the same release action,
but would call release before uio_unregister_device is executed, and
late_release after that.

Of course it would be good for tcmu if uio would call uio_info:release 
even after uio_unregister_device, but changing this AFAICS could cause
trouble in other drivers using uio.

Bodo
after uio_unregister_device.

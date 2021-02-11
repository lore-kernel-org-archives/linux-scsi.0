Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E1CEC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 19:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAF796186A
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 19:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhBKTFY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 14:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhBKTEM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 14:04:12 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBB0C061756;
        Thu, 11 Feb 2021 11:03:31 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id df22so8115783edb.1;
        Thu, 11 Feb 2021 11:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kPhjJXfm6+kQOfWXztpcCTmvFWPa71ZgKqQVo0Ho3dI=;
        b=LbEITIm2GF+EoJHZQsnzpUgZgvHIg5RwynEU8X4cKVwcjKRQR2RsxXo51p/+1zFcws
         QGC+VhHbZ+k6ZZHoC77bPdXNybPWU8F195qO3EuBjlLnkuzC8nuolstUQtygL4yS0wg7
         +ybDxAHK92k01MK0Bo6ohfv25/rM7+ZldYlZKYJMIBhiPLC36mhPjjBkcRjYDIEObD9H
         IFZ0uTiLNCLtJrc818Pq38rMOX5DO7sO+vXaP/x8vMr8paxiexMElapjeFWsi0PVwhNe
         oPFIEteK+DFnC8XYMYqEczsvsrFKK3gs815OGb4Js0Imr2IEzsnlI8vLf7/bhCbGmSAH
         u9Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kPhjJXfm6+kQOfWXztpcCTmvFWPa71ZgKqQVo0Ho3dI=;
        b=L5ePyR/t5B/Q0UQbqJMlCtK3hPBMIhYqJ77vUgg+wyifXBZfJrpRi2zM9dw+YSYHJB
         aQwN7+GDzNsQdAn8PBIwXTP2f6DeqC/v0BD9C/zy27EDNN5c/Jvf5OmybcXygJyptirw
         SZ8vVC67d1pPw7oKksJ+4/u+HRY0n+uGlvMhdLPWkQzn1ZgYGKVA8CHpE+QuYGKGgYna
         AfGKS7nh+D0pKp8O6he+QbkMLSAAdrAfQEslCiCwdeMao28fgTjtvpZk5zNLPkHeot2C
         //6e1406/EnzKZoGo3jr4/b33+hQXdIZB/+bDt9OUme4fvgmJAB9Mqm7ssiQpGkkGifv
         JvGA==
X-Gm-Message-State: AOAM532C6ytSlAPgGGG8GG5swRZbL4NNgI0sxOwK4R6qApHvTVFD3zlb
        d+AZggVfiBOdIQEH1BIyobT5yP6jN78=
X-Google-Smtp-Source: ABdhPJyv83sxlk478XZcaUgFcnkwG3zGSGIsUAkaWmG7NrTEmMV7xeaMHHKhQtpVfdcTmBIe2qMf8Q==
X-Received: by 2002:a05:6402:1383:: with SMTP id b3mr9336825edv.131.1613070210543;
        Thu, 11 Feb 2021 11:03:30 -0800 (PST)
Received: from [192.168.178.40] (ipbcc06d06.dynamic.kabel-deutschland.de. [188.192.109.6])
        by smtp.gmail.com with ESMTPSA id r23sm5045171ejd.56.2021.02.11.11.03.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 11:03:30 -0800 (PST)
Subject: Re: [PATCH 1/2] uio: Add late_release callback to uio_info
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
References: <20210210194031.7422-1-bostroesser@gmail.com>
 <20210210194031.7422-2-bostroesser@gmail.com> <YCQ4aEz29P26ZxaL@kroah.com>
 <7bc9eef9-0a9e-58a9-11f1-2c32010c70f0@gmail.com> <YCTT8HQ7PobTyUz4@kroah.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <fb4d82c3-2add-d745-2044-bb90c98c954f@gmail.com>
Date:   Thu, 11 Feb 2021 20:03:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YCTT8HQ7PobTyUz4@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11.02.21 07:51, Greg Kroah-Hartman wrote:
> On Wed, Feb 10, 2021 at 08:57:11PM +0100, Bodo Stroesser wrote:
>> On 10.02.21 20:47, Greg Kroah-Hartman wrote:
>>> On Wed, Feb 10, 2021 at 08:40:30PM +0100, Bodo Stroesser wrote:
>>>> If uio_unregister_device() is called while userspace daemon
>>>> still holds the uio device open or mmap'ed, uio will not call
>>>> uio_info->release() on later close / munmap.
>>>>
>>>> At least one user of uio (tcmu) should not free resources (pages
>>>> allocated by tcmu which are mmap'ed to userspace) while uio
>>>> device still is open, because that could cause userspace daemon
>>>> to be killed by SIGSEGV or SIGBUS. Therefore tcmu frees the
>>>> pages only after it called uio_unregister_device _and_ the device
>>>> was closed.
>>>> So, uio not calling uio_info->release causes trouble.
>>>> tcmu currently leaks memory in that case.
>>>>
>>>> Just waiting for userspace daemon to exit before calling
>>>> uio_unregister_device I think is not the right solution, because
>>>> daemon would not become aware of kernel code wanting to destroy
>>>> the uio device.
>>>> After uio_unregister_device was called, reading or writing the
>>>> uio device returns -EIO, which normally results in daemon exit.
>>>>
>>>> This patch adds new callback pointer 'late_release' to struct
>>>> uio_info. If uio user sets this callback, it will be called by
>>>> uio if userspace closes / munmaps the device after
>>>> uio_unregister_device was executed.
>>>>
>>>> That way we can use uio_unregister_device() to notify userspace
>>>> that we are going to destroy the device, but still get a call
>>>> to late_release when uio device is finally closed.
>>>>
>>>> Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
>>>> ---
>>>>    Documentation/driver-api/uio-howto.rst | 10 ++++++++++
>>>>    drivers/uio/uio.c                      |  4 ++++
>>>>    include/linux/uio_driver.h             |  4 ++++
>>>>    3 files changed, 18 insertions(+)
>>>>
>>>> diff --git a/Documentation/driver-api/uio-howto.rst b/Documentation/driver-api/uio-howto.rst
>>>> index 907ffa3b38f5..a2d57a7d623a 100644
>>>> --- a/Documentation/driver-api/uio-howto.rst
>>>> +++ b/Documentation/driver-api/uio-howto.rst
>>>> @@ -265,6 +265,16 @@ the members are required, others are optional.
>>>>       function. The parameter ``irq_on`` will be 0 to disable interrupts
>>>>       and 1 to enable them.
>>>> +-  ``int (*late_release)(struct uio_info *info, struct inode *inode)``:
>>>> +   Optional. If you define your own :c:func:`open()`, you will
>>>> +   in certain cases also want a custom :c:func:`late_release()`
>>>> +   function. If uio device is unregistered - by calling
>>>> +   :c:func:`uio_unregister_device()` - while it is open or mmap'ed by
>>>> +   userspace, the custom :c:func:`release()` function will not be
>>>> +   called when userspace later closes the device. An optionally
>>>> +   specified :c:func:`late_release()` function will be called in that
>>>> +   situation.
>>>> +
>>>>    Usually, your device will have one or more memory regions that can be
>>>>    mapped to user space. For each region, you have to set up a
>>>>    ``struct uio_mem`` in the ``mem[]`` array. Here's a description of the
>>>> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
>>>> index ea96e319c8a0..0b2636f8d373 100644
>>>> --- a/drivers/uio/uio.c
>>>> +++ b/drivers/uio/uio.c
>>>> @@ -532,6 +532,8 @@ static int uio_release(struct inode *inode, struct file *filep)
>>>>    	mutex_lock(&idev->info_lock);
>>>>    	if (idev->info && idev->info->release)
>>>>    		ret = idev->info->release(idev->info, inode);
>>>> +	else if (idev->late_info && idev->late_info->late_release)
>>>> +		ret = idev->late_info->late_release(idev->late_info, inode);
>>>>    	mutex_unlock(&idev->info_lock);
>>>
>>> Why can't release() be called here?  Why doesn't your driver define a
>>> release() if it cares about this information?  Why do we need 2
>>> different callbacks that fire at exactly the same time?
>>>
>>> This feels really wrong.
>>>
>>> greg k-h
>>>
>>
>> tcmu has a release callback. But uio can't call it after
>> uio_unregister_device was executed, because in uio_unregister_device
>> uio sets the uio_device::info to NULL.
> 
> As it should because the driver could then be gone.  It should NEVER
> call back into it again.

OTOH, uio does try_module_get(idev->owner) in uio_open before calling
the driver's open callback and module_put(idev_owner) in uio_release
after calling driver's release callback. So driver's release callback
is guaranteed to exist until last release is done.

Apart from that, tcmu also has an uio_info::mmap callback. In that
callback it installs its own vm_operations_struct::fault handler.
This handler also can happen to be called as long as userspace holds
the uio device mmap'ed. I think, this is not a problem due to the
above mentioned mechanism.

tcmu just has to ensure, that the tcmu device, which contains the 
uio_info - is kept until the final release call happens. Unfortunately
this call will not happen if uio device is open during
uio_unregister_device. That's why tcmu sometimes leaks memory.

> 
>> So, uio would never call both callbacks for the same release action,
>> but would call release before uio_unregister_device is executed, and
>> late_release after that.
> 
> That's not ok.
> 
>> Of course it would be good for tcmu if uio would call uio_info:release even
>> after uio_unregister_device, but changing this AFAICS could cause
>> trouble in other drivers using uio.
> 
> You are confusing two different lifetime rules here it seems.  One is
> the char device and one is the struct device.  They work independently
> as different users affect them.
I'm not sure I get your point.

> 
> So if one is removed from the system, do not try to keep a callback to
> it, otherwise you will crash.

That's why I tried to change uio in a compatible way, so other drivers
based on it are not afflicted by the change. I saw, that some drivers
based on uio free their resources directly after calling
uio_unregister_device. Executing their release callback later would
definitely cause trouble.

> 
> And why is scsi using the uio driver in the first place?  That feels
> really odd to me.  Why not just make a "real" driver if you want to
> somehow tie these two lifetimes together?

Why tcmu driver is based on uio I don't know. I inherited the driver as
it is. Maybe it would have been better to not base it on uio, I don't
know. But changing this now would cause an API change for all existing
userspace apps, e.g. tcmu-runner. I think I should avoid that and
therefore have to find an acceptable solution for the tcmu/uio
combination.

> 
> thanks,
> 
> greg k-h
> 

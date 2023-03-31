Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D485AC76196
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Mar 2023 18:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbjCaSde (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Mar 2023 14:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbjCaSdd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Mar 2023 14:33:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3671BF49
        for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2023 11:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680287569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qR0tNVk25Dp1b/qFdEIIqaZjqxcmkBU+35+rqb5/9Wg=;
        b=LabgDLKY4gmePt+xWaYRDeYtrW7ymt0NBY6NK/M1woa0BDaWra0BZPZvGLie/Q6QoM2LtN
        t6KiDIOyvzkmgNYaY5U+/9GPgofQhLorRv488/xDH9A320UhzRTZELPNEbQrfzIwXpvbZA
        w2kWylNrkjRrKCbqOLfYAN1kGlg4Www=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-UK495WHvOqCLX4it88JVeQ-1; Fri, 31 Mar 2023 14:32:48 -0400
X-MC-Unique: UK495WHvOqCLX4it88JVeQ-1
Received: by mail-wm1-f69.google.com with SMTP id o37-20020a05600c512500b003edd119ec9eso11539392wms.0
        for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2023 11:32:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680287566;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qR0tNVk25Dp1b/qFdEIIqaZjqxcmkBU+35+rqb5/9Wg=;
        b=IchhJ+g+3LezMp1CEDDp2kTqZnx62EF1JZjXTk2uyZojAO4KmWibP7AAtduUTYHJjl
         lJtH5m9AyGSem2hVIMSF78Rb0v5CbyvHMhK/Nlrb9wjR/ghS5fDMWNImYzDp1VN+OwKg
         OfcpssVUPxIFpg3SwRoOayO0XQRYoXOW0FZzdXlTeJ4gLEBV06sCGtfGU5iiUHsbpDrs
         33JWaF0oRsoxu0MI0Vj4v0BrAL3JvUs3D1YgVyF9pGiLQZeYHhGf6lA1Anj4ufOzV6D2
         6McS24PL96EyR+GXMlvVjLwjgMDG4kuNF6GTTKaEVT1B7r6NtE+UCgVXSp7ts9VRsCR3
         f2PA==
X-Gm-Message-State: AO0yUKUfqHOs/Sa1QU7UtWEk+cefHvtuV24uuUJ50TGMyJgLR3EqsPTD
        B45t/F7HfjXmp9uCwXQXnfl43767V98JhswxCblGGEM+9XHklou5CZN3FNp8VYll8Hz1niA3Plw
        252DrG1rqCHHXaRuiTeFX2wEs9RKnmw==
X-Received: by 2002:a1c:4b07:0:b0:3eb:29fe:f911 with SMTP id y7-20020a1c4b07000000b003eb29fef911mr20918839wma.13.1680287566214;
        Fri, 31 Mar 2023 11:32:46 -0700 (PDT)
X-Google-Smtp-Source: AK7set8+6s8tXsUcZa8UnWV5R0qtjw2DdDVXU9LGFTZFGoWpmrFfMIg/ADtSasWqBI7AiJjcAjj19Q==
X-Received: by 2002:a1c:4b07:0:b0:3eb:29fe:f911 with SMTP id y7-20020a1c4b07000000b003eb29fef911mr20918829wma.13.1680287565918;
        Fri, 31 Mar 2023 11:32:45 -0700 (PDT)
Received: from [192.168.0.107] (ip4-83-240-118-160.cust.nbox.cz. [83.240.118.160])
        by smtp.gmail.com with ESMTPSA id u17-20020a05600c19d100b003dd1bd0b915sm10704597wmq.22.2023.03.31.11.32.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 11:32:45 -0700 (PDT)
Message-ID: <33501374-2cc7-ba1c-9d42-0da2aeed4341@redhat.com>
Date:   Fri, 31 Mar 2023 20:32:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] scsi: sd: mark the scsi device in shutdown as deleted
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20230330164943.11607-1-thenzl@redhat.com>
 <af17886b-5b18-f71f-9fe7-ea929f30b5a6@oracle.com>
 <e4dd3ea37807166820e3b3b7e5102e23ab6b3898.camel@HansenPartnership.com>
 <457808a0-1ec2-d846-075c-7f8812a7a416@redhat.com>
 <488bb066654104bc6b84fdc45595232305519597.camel@HansenPartnership.com>
Content-Language: en-US
From:   Tomas Henzl <thenzl@redhat.com>
In-Reply-To: <488bb066654104bc6b84fdc45595232305519597.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/31/23 17:06, James Bottomley wrote:
> On Fri, 2023-03-31 at 16:11 +0200, Tomas Henzl wrote:
>> On 3/31/23 13:48, James Bottomley wrote:
>>> On Thu, 2023-03-30 at 12:12 -0500, Mike Christie wrote:
> [...]
>>>> Are we going to do:
>>>> 1. __scsi_remove_device sets the state to SDEV_CANCEL at the
>>>> beginning of the function
>>>
>>> It will also interfere with target and host device removal.  They
>>> traverse their own lists and assume that anything in DEL is already
>>> being removed, which won't be the case here.  So basically, after
>>> this happens it's impossible to clean the device trees.  It also
>>> means any I/O to the root device wouldn't be allowed.
>>  
>> How will it interfere? After a return from sd_remove or via
>> device_unregister->__scsi_remove_device the device state is SDEV_DEL
>> regardless whether this patch has been added or not. Or is
>> sd_shutdown called directly?
> 
> I thought it was called directly from the restart logic via the
> device_shutdown() call (see kernel/reboot.c:kernel_restart_prepare())
> and was completely independent of any other state transitions within
> the device model ... however, I'd really like *you* to confirm this.
> 
> I think by the time it's called, we're already in the system death
> throes, so if there were going to be an orderly shut down it's already
> happened, but if not, once you set a devices state to DEL, it will
> defeat any later attempt to do orderly remove of the host or target.
After the first device's shutdown method in device_shutdown has been
called there is now way back (we don't have an opposite to shutdown like
for suspend resume is) so it can't be undone and also it doesn't matter
if some structures remain in memory. To me it seems to be the only
logical consequence but I can't prove it.

>>> I assume the contention is that if we get here, we're either going
>>> for immediate shutdown or all the root device remounting to read
>>> only has already been done?  If so, could you say that?
>>  
>> I can't say that, quite the opposite (see body of the mail). When the
>> system goes shutdown the individual device's .shutdown is called.
>> Just moments after sd shutdown the LLD shutdown is entered and the
>> driver stops any I/O immediately anyway. With this patch the I/O is
>> stopped before reaching LLD with a reasonable message and without
>> error correction mechanism in place.
>>
>> I also assume that no I/O after sd_shutdown was projected when it was
>> written as there is a cache sync followed by a device power down.
> 
> It seems reasonable, but can you validate that?  Shutdown is called
> both from reboot and kexec and if we stop IO to a quiescing root device
> before it completes, so that all filesystems come back dirty, we'll
> have a lot of unhappy users ...
Validate, I don't know how or what you mean. Making sure that everything
is in a state when the kernel shutdown procedure may be entered is for
example on my system done by userspace systemd-shutdown service like so
:"systemd-shutdown[1]: Syncing filesystems and block devices ..."
When the kernel shutdown procedure is entered the I/O will be cut off
abruptly by a LLD.shutdown. That means it depends on scripts like
systemd and that works well on all systems I checked for reboot but not
for kexec on everywhere.
The patch may stop the I/O few msec sooner that is true. But the clearer
 messages may bring a script writer to fix it.

The patch doesn't fix a real bug so it isn't urgent nor important,
seeing the congestion it creates please just drop it.

Tomas

> 
> James
> 


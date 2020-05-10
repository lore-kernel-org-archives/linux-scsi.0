Return-Path: <SRS0=m8SI=6Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BAD5C54E8C
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 08:35:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 697FE24953
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 08:35:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eeDOtH1x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbgEJIfj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 04:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728815AbgEJIfj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 May 2020 04:35:39 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43777C061A0C;
        Sun, 10 May 2020 01:35:39 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id v63so3231452pfb.10;
        Sun, 10 May 2020 01:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7agiBsUJ0WJpTqY/Qk8WKBAW1zaA6qAMgzq/5zf2raI=;
        b=eeDOtH1x9jnloaFnJ3Z+SjvbWmCsGddQmRP6Iy+I7niyfkzGtXriuvDkz2NxfIQ21M
         a/I2o+Y7VeQNyZ3zT9CtF/Yq0CgR3TqtZjngMrsypwGmYQRhKcIfGgWM86VvfyOtxZqZ
         a4bx9Nl8SSveRxybgTAhA8I9FPrqAk0qVPYFW32kpn4B6zCDGnWy3vvF3HVT2e2Laf49
         X2nC0Ar7E63t5n8QBWCqIT6JNk0vnAHnqrhzI5obQU6NMXieNSdxKcqcJJozgW2zODc8
         gSSPDpRZjK+S4Ffos5vuz1FjQBq/dzTr3CI12ODVlT/oOHiaReIGkenWxScGlT3qVjTr
         XzmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7agiBsUJ0WJpTqY/Qk8WKBAW1zaA6qAMgzq/5zf2raI=;
        b=DCbdpFgSQ/BZAz9cDefJhR2quWqNxuKLiryM9GwC1tYvb+70ajQpeuMHUcvFeX42wx
         J191+/OOnSfSGJLW81GXd68/9dotm+UYBRhDNFyeOxZrwaGvgGPAMKOWYi0FokHLHrkL
         PT6X94JzsOiZ4nbnBV3nC/8e1Dl/AFx6C+jB6cYpN2SKMaQUJYjqIm+M2716tXziu1rN
         lyquDvk8ZwsC2UrwZ57oVRf69UOG483EQZEtrMW4GV4qiJxtN/iqX4L3zJtUfAg9P/XG
         M0tH25iNaAEFw1+0fK3yqNyfxEt7hbvaijEc2mM33CYJxpAbIdbD84JT3jZGDL0Ficn7
         lvGA==
X-Gm-Message-State: AGi0PuYJBpN8ROA44+q0ulcdxDMzSMaf8TkOkxdHxpiDGR8Rq9bpWoTy
        dTRhyaO3Qziqxav3o7dVPkHmLblPRJI=
X-Google-Smtp-Source: APiQypKRBfBFVeXFXk/wb20AlTooYehwAX9iEMTObrGdj4gjFJvK4P7wp7R0eR5PZ6i/gLEbxAas7g==
X-Received: by 2002:a63:5642:: with SMTP id g2mr9755057pgm.211.1589099738277;
        Sun, 10 May 2020 01:35:38 -0700 (PDT)
Received: from ASMDT.1 ([114.125.245.237])
        by smtp.gmail.com with ESMTPSA id s76sm5236338pgc.85.2020.05.10.01.35.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 May 2020 01:35:37 -0700 (PDT)
Subject: Re: USB Attached SCSI breakage due no udev involvement
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, stern@rowland.harvard.edu,
        linux-kernel@vger.kernel.org
References: <CAOyCV0zW_20Jq6Rrb9=fhZQAHeqMMs_oHBJdTVt8Nqje0Zoeig@mail.gmail.com>
 <20200510054717.GA3365021@kroah.com>
 <1f9c0b30-f440-de43-366f-28ccba6a22e2@gmail.com>
 <20200510065416.GA3434442@kroah.com>
 <e409bbfe-c446-2ba3-423d-c6e198abef33@gmail.com>
 <20200510073258.GA3474912@kroah.com>
From:   Dio Putra <dioput12@gmail.com>
Message-ID: <6dcbc78c-8c2f-e620-822b-7e777144d4ae@gmail.com>
Date:   Sun, 10 May 2020 15:35:34 +0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200510073258.GA3474912@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/10/20 2:32 PM, Greg KH wrote:
> On Sun, May 10, 2020 at 02:10:04PM +0700, Dio Putra wrote:
>> On 5/10/20 1:54 PM, Greg KH wrote:
>>> On Sun, May 10, 2020 at 01:48:24PM +0700, Dio Putra wrote:
>>>> On 5/10/20 12:47 PM, Greg KH wrote:
>>>>> On Sun, May 10, 2020 at 09:55:57AM +0700, Dio Putra wrote:
>>>>>> Hi, it's first time for me to report user-space breakage in here, so
>>>>>> i'm begging your pardon.
>>>>>>
>>>>>> I want to report that Linux 5.4 breaking my USB mount workflow due
>>>>>> udevadm monitor report here (I'm using vanilla kernel 5.4.39 on
>>>>>> Slackware64 Current and vanilla kernel 4.4.221 on Slackware64 14.2):
>>>>>
>>>>> <snip>
>>>>>
>>>>> Sorry, but what actually changed that you can see in the logs?
>>>> Sorry, what do you mean? The dmesg log or the kernel changelogs?
>>>
>>> Either, your message made them pretty impossible to compare with all of
>>> the line-wrapping :(
>>>
>> I'm so sorry for first message mess, because that message has been sent by
>> Gmail Website. Can I send my logs as attachment? I try to convenient everyone
>> here. ( FYI, I just switched to Thunderbird with these settings:
>> https://www.kernel.org/doc/html/v4.12/process/email-clients.html#thunderbird-gui ) 
> 
> Sure, attachments work, but better yet, if you can show the difference
> in a few lines that is much nicer than having to dig through large
> numbers of log files.
> 
Okay, I'll attach long messages and trim it as far as I can.

>>>>> What functionality broke?  What used to work that no longer does work?
>>>>>
>>>> Yes, it supposed that just work and kernel could talk with udev, not just handled by the kernel.
>>>
>>> I don't understand, what functionality changed?  What exactly used to
>>> work that no longer does?
>> linux-5.4 has been never called the udev dependencies whereas
>> linux-4.4 will call any udev dependencies if necessary, that's the problem.
> 
> I do not understand what exactly you mean by "call udev dependencies".
> 
> udev is used to create symlinks and set user/group permissions on device
> nodes in /dev/ which is created by devtmpfs.  What exactly is not
> happening in your /dev/ with the move to a newer kernel?
> 
Would I send my dmesg log with "udev.log-priority=debug" as attachment then?

>>> Did you change anything else other than the kernel on your system?  Did
>>> you change to a newer version of udev/systemd or anything else?
>>>
>> I'm using eudev-master from their official mirror github:
>> https://github.com/gentoo/eudev
> 
> Have you contacted the eudev developers to see if something different
> needs to be set in your kernel when moving 4 years in kernel development
> forward?  Are you sure you have all the correct config options enabled?
> 
It's my bad not to contact the eudev developers first. However I'm not quite
sure to contact the eudev developers would solve the problem, but CMIIW.

> Why such a huge leap forward all at once, how about going from 4.4.y to
> 4.9.y and then 4.14.y and then 5.4.y?  That might help narrow things
> down a bit easier.
> 
Unfortunately I need to think twice due almost ran out of electricity
here every time I power on my laptop for long time. So maybe I can't.

But if these steps are necessary, I'll think solution later.
> thanks,
> 
> greg k-h
> 


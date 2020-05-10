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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C36B3C54E8C
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 07:14:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9499E24966
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 07:14:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lCasFaHp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgEJHKK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 03:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728815AbgEJHKK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 May 2020 03:10:10 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A93CC061A0C;
        Sun, 10 May 2020 00:10:10 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 207so2972493pgc.6;
        Sun, 10 May 2020 00:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HOBl8gaNDw+V3G712N2mxPQDvynt9URL9SIOfp9L2xo=;
        b=lCasFaHpQFZhMqvsUu215Gn/U7NOZ57R8RQDyp6PFzYOz5c9qdk+/Vz6FaupZetvaN
         TQDWo1N4q60YIc+0TBI3txOD5r2/oMxzWmsNKjyMSq7zcuLP7Rd41kOf4pnu7ti+lxq9
         ox07Vu9bH3wh8yx14XcwXCSqX9lY7IqmXfQKSTan0ZmT5Xtnw7NbMxHv++yUymlaDH1D
         ncbXXBWOdg8RyHPR0UBXGkkk38CYfn+AEBwKenyK62jg1pNLFPvvQsg5XrwwZEMaa248
         jtG0pno9D+NzszwZOlFhWZjjWncgsNJ6je2HOQp4JeX8gNU1Utqy58K2VLq7ACmSsTtt
         BoNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HOBl8gaNDw+V3G712N2mxPQDvynt9URL9SIOfp9L2xo=;
        b=osTfXpBqpvuy68VegXHbM5XCYFvdr/lNxffWyZyDhfviLh0MEk104wNNV45F1OGq2T
         r0dcPB3sZljO9jzFLXvQ/5H1id3HCaAMCpFtVcvJL4tSxejUFI2pZqz/hCx++/hVbUV9
         xc1YqH1AtM0Es5+HUSU7iU8BihVQWlmne6gYhoPRvSILFo1hliXQw6jmxlUF5a47t5a8
         8jhggPhm/Z807EYkt/oa/yhLhv1JeBaOHJyCQKPBpIQdvh3dXZUUVuQd/es38JOKmdNv
         h/t+aS7M7NBVl8ckeL4WMKZAjYWMhlNDJlgEkoeJHWATZvSFpPrcxZl+EvWyxWEm3/SE
         NVhg==
X-Gm-Message-State: AOAM532rn1ytosKyM3kzsL34HpvbHjNnBPkNVeXfSEb3VY4TrY1K/9Z8
        zR1BBVeeAcO0s4nds9cTMCuV4ivZ
X-Google-Smtp-Source: ABdhPJyO5ONbm1pnw8jlr2jFEXb2hPYGwMfKJMJ4cdzo4zpzPrNBax6u6FRpXupyaMPSTpMeU1A5fQ==
X-Received: by 2002:a63:e74e:: with SMTP id j14mr35375pgk.390.1589094609581;
        Sun, 10 May 2020 00:10:09 -0700 (PDT)
Received: from ASMDT.1 ([114.125.230.31])
        by smtp.gmail.com with ESMTPSA id 71sm6378732pfw.111.2020.05.10.00.10.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 May 2020 00:10:09 -0700 (PDT)
Subject: Re: USB Attached SCSI breakage due no udev involvement
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     oneukum@suse.com, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        stern@rowland.harvard.edu, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        stern@rowland.harvard.edu, linux-kernel@vger.kernel.org
References: <CAOyCV0zW_20Jq6Rrb9=fhZQAHeqMMs_oHBJdTVt8Nqje0Zoeig@mail.gmail.com>
 <20200510054717.GA3365021@kroah.com>
 <1f9c0b30-f440-de43-366f-28ccba6a22e2@gmail.com>
 <20200510065416.GA3434442@kroah.com>
From:   Dio Putra <dioput12@gmail.com>
Message-ID: <e409bbfe-c446-2ba3-423d-c6e198abef33@gmail.com>
Date:   Sun, 10 May 2020 14:10:04 +0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200510065416.GA3434442@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/10/20 1:54 PM, Greg KH wrote:
> On Sun, May 10, 2020 at 01:48:24PM +0700, Dio Putra wrote:
>> On 5/10/20 12:47 PM, Greg KH wrote:
>>> On Sun, May 10, 2020 at 09:55:57AM +0700, Dio Putra wrote:
>>>> Hi, it's first time for me to report user-space breakage in here, so
>>>> i'm begging your pardon.
>>>>
>>>> I want to report that Linux 5.4 breaking my USB mount workflow due
>>>> udevadm monitor report here (I'm using vanilla kernel 5.4.39 on
>>>> Slackware64 Current and vanilla kernel 4.4.221 on Slackware64 14.2):
>>>
>>> <snip>
>>>
>>> Sorry, but what actually changed that you can see in the logs?
>> Sorry, what do you mean? The dmesg log or the kernel changelogs?
> 
> Either, your message made them pretty impossible to compare with all of
> the line-wrapping :(
> 
I'm so sorry for first message mess, because that message has been sent by
Gmail Website. Can I send my logs as attachment? I try to convenient everyone
here. ( FYI, I just switched to Thunderbird with these settings:
https://www.kernel.org/doc/html/v4.12/process/email-clients.html#thunderbird-gui ) 

>>> What functionality broke?  What used to work that no longer does work?
>>>
>> Yes, it supposed that just work and kernel could talk with udev, not just handled by the kernel.
> 
> I don't understand, what functionality changed?  What exactly used to
> work that no longer does?
linux-5.4 has been never called the udev dependencies whereas
linux-4.4 will call any udev dependencies if necessary, that's the problem.

> 
> Did you change anything else other than the kernel on your system?  Did
> you change to a newer version of udev/systemd or anything else?
> 
I'm using eudev-master from their official mirror github:
https://github.com/gentoo/eudev

> thanks,
> 
> greg k-h
> 

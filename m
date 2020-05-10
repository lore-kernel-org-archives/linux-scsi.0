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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B75C54E8A
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 13:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 670B12080C
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 13:15:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uOOGBNmH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728946AbgEJNPU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 09:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726630AbgEJNPT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 May 2020 09:15:19 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9ADC061A0C;
        Sun, 10 May 2020 06:15:18 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id fu13so6405253pjb.5;
        Sun, 10 May 2020 06:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ixpwz+CZUCzdVL4WIaof0tEN90fPL/+PWTbROOL+Yio=;
        b=uOOGBNmHHI1d5pogU50lwRqVawaGAePidMmAXR2R6gyIkUk1A5qWWHIqUB+1n1lQZV
         B9LrvgOCDx9cjUjnOW/YEbYORa3LSEXQ1O4NcuWaQGEWjvQUKsfzOi34lK//WtKL1Tgk
         Zl4i1T4sJTld3DY6/4lFwSFTQ2FbKw/souM/IZN8TAnEdML+UveP+CQBinY4DFtfaNmI
         PVGGIYtJNVTUnyfkTG6YjGjn8ag5fURoGB7RhIXugUfNczb2iwXdlDtiWkqX+xjP4Ezt
         /ugKKAYZlBhHW0dx5Nrh4rjhn9NlJNWdu7vTRC5m7mEv92+tYFxCz+sFbX1t/EWlO7oU
         OIfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ixpwz+CZUCzdVL4WIaof0tEN90fPL/+PWTbROOL+Yio=;
        b=mQ3MXTb/WJrfSps6bY48M871FO7mM8BUpnpp+kmtOla39Kxs+TOh/XVE1ORW4KgMW3
         PyBCA3bsXW7q3zIdvjMA/gZFHJUAG0f/Y2rnXQuSaRr04Z04mwcOyg9hUBv95TR7GCmP
         A9vvUKZQUB+VKXuKTEnwCy7yokFsThELTp/oD561MVRlx3SneWSlwbP+Fjxfk0bs2keq
         VmAvSqf8uYHxQHVY4/2etuxl7uamDByWRaIvQa4hvpT+1IExKjYCsoMhJeeal9IA9Q6G
         Tq3Ol0mLxjDTpgZ0ctKiRhKcx83gtw/vw1Db7qb6b0vxaWjBKAvJ3fnhn8V17CT5+Bfk
         2T1A==
X-Gm-Message-State: AGi0PuawCTtwTiaAutTsysE6eJF3Z3YvxTapOwINAnO3BK2QM90JL+NG
        g9IK7t4njsQ17rAjEd5pBsrIQZTa4bs=
X-Google-Smtp-Source: APiQypLPPX92pnOA27qt4RRdrZzwvkaZMIFaLotCBcFjq/9rxAlntFydg1uVw/EGQz5RyNC3Mc4iTw==
X-Received: by 2002:a17:902:7082:: with SMTP id z2mr10566383plk.317.1589116517963;
        Sun, 10 May 2020 06:15:17 -0700 (PDT)
Received: from ASMDT.1 ([202.67.42.2])
        by smtp.gmail.com with ESMTPSA id j14sm7498649pjm.27.2020.05.10.06.15.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 May 2020 06:15:17 -0700 (PDT)
Subject: Re: USB Attached SCSI breakage due no udev involvement
From:   Dio Putra <dioput12@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     oneukum@suse.com, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        stern@rowland.harvard.edu, linux-kernel@vger.kernel.org
References: <CAOyCV0zW_20Jq6Rrb9=fhZQAHeqMMs_oHBJdTVt8Nqje0Zoeig@mail.gmail.com>
 <20200510054717.GA3365021@kroah.com>
 <1f9c0b30-f440-de43-366f-28ccba6a22e2@gmail.com>
 <20200510065416.GA3434442@kroah.com>
 <e409bbfe-c446-2ba3-423d-c6e198abef33@gmail.com>
 <20200510073258.GA3474912@kroah.com>
 <6dcbc78c-8c2f-e620-822b-7e777144d4ae@gmail.com>
 <20200510084820.GA3598083@kroah.com>
 <80d4f4d9-91be-b7e8-1f64-13c2fe74f496@gmail.com>
Message-ID: <3b107771-550f-8ca1-d05a-4f6c2ef1920a@gmail.com>
Date:   Sun, 10 May 2020 20:15:08 +0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <80d4f4d9-91be-b7e8-1f64-13c2fe74f496@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/10/20 4:48 PM, Dio Putra wrote:
> On 5/10/20 3:48 PM, Greg KH wrote:
>> On Sun, May 10, 2020 at 03:35:34PM +0700, Dio Putra wrote:
>>> On 5/10/20 2:32 PM, Greg KH wrote:
>>>> On Sun, May 10, 2020 at 02:10:04PM +0700, Dio Putra wrote:
>>>>> On 5/10/20 1:54 PM, Greg KH wrote:
>>>>>> On Sun, May 10, 2020 at 01:48:24PM +0700, Dio Putra wrote:
>>>>>>> On 5/10/20 12:47 PM, Greg KH wrote:
>>>>>>>> On Sun, May 10, 2020 at 09:55:57AM +0700, Dio Putra wrote:
>>>>>>>>> Hi, it's first time for me to report user-space breakage in here, so
>>>>>>>>> i'm begging your pardon.
>>>>>>>>>
>>>>>>>>> I want to report that Linux 5.4 breaking my USB mount workflow due
>>>>>>>>> udevadm monitor report here (I'm using vanilla kernel 5.4.39 on
>>>>>>>>> Slackware64 Current and vanilla kernel 4.4.221 on Slackware64 14.2):
>>>>>>>>
>>>>>>>> <snip>
>>>>>>>>
>>>>>>>> Sorry, but what actually changed that you can see in the logs?
>>>>>>> Sorry, what do you mean? The dmesg log or the kernel changelogs?
>>>>>>
>>>>>> Either, your message made them pretty impossible to compare with all of
>>>>>> the line-wrapping :(
>>>>>>
>>>>> I'm so sorry for first message mess, because that message has been sent by
>>>>> Gmail Website. Can I send my logs as attachment? I try to convenient everyone
>>>>> here. ( FYI, I just switched to Thunderbird with these settings:
>>>>> https://www.kernel.org/doc/html/v4.12/process/email-clients.html#thunderbird-gui )
>>>>
>>>> Sure, attachments work, but better yet, if you can show the difference
>>>> in a few lines that is much nicer than having to dig through large
>>>> numbers of log files.
>>>>
>>> Okay, I'll attach long messages and trim it as far as I can.
>>
>> Again, I really do not understand what exactly is "not working".
>>
>> Please explain that when you send the new log messages.
>>
> Okay, here's compilation of "dmesg | grep -i udev && udevadm
> monitor && lsblk" on linux-4.4.221 vs linux-5.4.39. You can check
> my attachment here because I can't explain it by words (I'm not
> english native speaker anyway, which makes it so difficult to
> explain it for me).
> 
>>>>>>>> What functionality broke?  What used to work that no longer does work?
>>>>>>>>
>>>>>>> Yes, it supposed that just work and kernel could talk with udev, not just handled by the kernel.
>>>>>>
>>>>>> I don't understand, what functionality changed?  What exactly used to
>>>>>> work that no longer does?
>>>>> linux-5.4 has been never called the udev dependencies whereas
>>>>> linux-4.4 will call any udev dependencies if necessary, that's the problem.
>>>>
>>>> I do not understand what exactly you mean by "call udev dependencies".
>>>>
>>>> udev is used to create symlinks and set user/group permissions on device
>>>> nodes in /dev/ which is created by devtmpfs.  What exactly is not
>>>> happening in your /dev/ with the move to a newer kernel?
>>>>
>>> Would I send my dmesg log with "udev.log-priority=debug" as attachment then?
>>>
>>>>>> Did you change anything else other than the kernel on your system?  Did
>>>>>> you change to a newer version of udev/systemd or anything else?
>>>>>>
>>>>> I'm using eudev-master from their official mirror github:
>>>>> https://github.com/gentoo/eudev
>>>>
>>>> Have you contacted the eudev developers to see if something different
>>>> needs to be set in your kernel when moving 4 years in kernel development
>>>> forward?  Are you sure you have all the correct config options enabled?
>>>>
>>> It's my bad not to contact the eudev developers first. However I'm not quite
>>> sure to contact the eudev developers would solve the problem, but CMIIW.
>>>
>>>> Why such a huge leap forward all at once, how about going from 4.4.y to
>>>> 4.9.y and then 4.14.y and then 5.4.y?  That might help narrow things
>>>> down a bit easier.
>>>>
>>> Unfortunately I need to think twice due almost ran out of electricity
>>> here every time I power on my laptop for long time. So maybe I can't.
>>>
>>> But if these steps are necessary, I'll think solution later.
>>
>> Why would it take a long time to do this type of change?
>>
> It's a weak machine, it took appropriately 2 hours to just compiling
> linux kernel. I need to think twice too because electricity is expensive here.
>
After deep digging into /dev/ folder, indeed some important file has 
been deleted after restart on Slackware.

On behalf from myself for linux-kernel community, I'm really sorry for 
causing these noise. Thank you Greg and all for the hints.
>> thanks,
>>
>> greg k-h
>>
> 


Return-Path: <SRS0=SQ1Y=2D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B03C2D0CF
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Dec 2019 04:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEB402465E
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Dec 2019 04:18:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ksDmDwZw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731677AbfLMESP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Dec 2019 23:18:15 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37750 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727299AbfLMESP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Dec 2019 23:18:15 -0500
Received: by mail-pf1-f196.google.com with SMTP id p14so766598pfn.4;
        Thu, 12 Dec 2019 20:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J+VXXEpqpT1b0Kt78pCe+xpHKloAmNUpN7ezOmJ2NB0=;
        b=ksDmDwZwpGeEFBHqIZzt8KKfMIYgWH5S5NsW05L0CjlXsVFWSChJeZ+xC+VC/X0auG
         /gvQeFbOfkBqLuX4qu6xCgDBpJS3EYiYCSgTausXPWxTTU+TuehXNF5PiuNOpw6Rv8if
         yXH3e/lwIm22D9qlN81HSa8SmFPEp92pkfsc/jwgLZh3XGP2PNJlVrqRqrJpNzfNV07X
         SiHNNgQDdo7xBw2Z/Q5PziQtRpzfqcHxtFjR9WmL9LrWyUvYJNKkAGMLuaOXXtDA4UTB
         SQNkozDBYCYPLCPN+iiwI9Li70BvZemw0o/qAY20vUr/qSks8wYH/IStnMLig4s3KTru
         +Aow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J+VXXEpqpT1b0Kt78pCe+xpHKloAmNUpN7ezOmJ2NB0=;
        b=g48hSp0Q02R41l8iMUE3d/OjWKM2t878MCyeg/IkqLDf++/ExhDkXSUKiYi2cpbs5M
         AJkZrd4Z6ixCuB5uPZRY3Yw+zkg4Q1YlRSKOz//gUXSx3TN1Gp8M/N4putRQVBxYe7kG
         4P/Y0hjEfOeq+wAZ2SyAxfqt1EMNN56CQ7iEOBJsGoi+A9ZTrYqK6E0jhL1UNJ1hSH11
         5TPMSoBkTph3KsbgG0fvTWObnXMhKttxfaSxpZcyCb0U9ngIUKvpXXzl2EAXw1a3L5Xl
         v09lU5fLiztgJV7kqF2HE2+2ZiyhYLscRhEaKF8TigkliYNUF0tUSSa3Jx9nTBz2nTiP
         XGNw==
X-Gm-Message-State: APjAAAUUpopGfY40/oY36APZ50iwbqzu9TwkPa0UfOZ3aHQQnusXmIGh
        +Tv0roa+Ds6Jjl8qgpq1LVI=
X-Google-Smtp-Source: APXvYqyu9bam4Mq+Jdr4Xf4RkjFCzPnnKOKiqla8LydRYnEZ6HNk9qndLr9uuzCyMPiQqzSmDrMEuQ==
X-Received: by 2002:a63:4b52:: with SMTP id k18mr14579197pgl.371.1576210694052;
        Thu, 12 Dec 2019 20:18:14 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g18sm9275813pfi.80.2019.12.12.20.18.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2019 20:18:13 -0800 (PST)
Subject: Re: [PATCH 1/1] hwmon: Driver for temperature sensors on SATA drives
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>
References: <20191209052119.32072-1-linux@roeck-us.net>
 <20191209052119.32072-2-linux@roeck-us.net>
 <CACRpkdYjidQHB0=S_brDxH3k+qJ2mfXCTF9A3SVZkPvBaVg6JQ@mail.gmail.com>
 <yq1wob1jfjm.fsf@oracle.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <541a7ddd-f4c9-5d5f-4f43-0ae5bc46aef6@roeck-us.net>
Date:   Thu, 12 Dec 2019 20:18:11 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <yq1wob1jfjm.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/12/19 3:21 PM, Martin K. Petersen wrote:
> 
> Linus,
> 
>> It's a nice addition with the SCT command, I never figured that part
>> out. Also nice how you register the scsi class interface I never saw
>> that before, it makes it a very neat plug-in.
> 
> Yep, I agree that the patch looks pretty good in general. There are just
> a few wrinkles in the detection heuristics I would like to tweak. More
> on that later.
> 
> Yesterday I added support for the SCSI temperature log page and am
> working through some kinks wrt. making this work for USB as well.
> 
>> When I read the comments from the previous thread I got the impression
>> the SCSI people wanted me to use something like the SCT transport and
>> the hook in the SMART thing in the libata back-end specifically for
>> [S]ATA in response to the SCT read log command.
> 
> Our recommendation was for libata-scsi.c to export the SCSI temperature
> log page, just like we do for all the other ATA parameters.
> 
> However, in tinkering with this the last couple of days, I find myself
> torn on the subject. For two reasons. First of all, there is no 1:1
> sensor mapping unless you implement the slightly more complex
> environmental log page. Which isn't a big deal, except out of the
> hundred or so SCSI devices I have here there isn't a single one that
> supports it it. So in practice this interface would probably only exist
> for the purpose of the libata SATL.
> 
> The other reason the libata approach is slightly less attractive is that
> we need all the same SMART parsing for USB as well. So while it is
> cleaner to hide everything ATA in libata, the reality of USB-ATA bridges
> gets in the way. That is why I previously suggested having a libsmart or
> similar with those common bits.
> 
> Anyway, based on what I've worked on today, I'm not sure that libata is
> necessarily the way to go. Sorry about giving bad advice! We've
> successfully implemented translations for everything else in libata over
> the years without too much trouble. And it's not really that the
> translation is bad. It's more the need to support it for USB as well
> that makes things clunky.
> 
>> I don't understand if that means the SCT read log also works
>> on some SCSI drives, or if it is just a slot-in thing for
>> ATA translation that has no meaning on SCSI drives.
> 
> It's an ATA command.
> 
> One concern I have is wrt. to sensor naming. Maybe my /usr/bin/sensors
> command is too old. But it's pretty hopeless to get sensor readings for

You'll need the command (and libsensors) from the lm-sensors package version
3.5 or later for it to recognize SCSI/ATA drives.

> 100 drives without being able to tell which sensor is for which
> device. Haven't looked into that yet. The links exist in
> /sys/class/hwmon that would allow vendor/model/serial to be queried.
> 

There is a device/ subdirectory which points to that information.
Is that what you are looking for ? "sensors" displays something
like satatemp-scsi-5-0, which matches sd 5:0:0:0:

> Oh, and another issue. While technically legal according to the spec, I
> am not sure it's a good idea to export a sensor per scsi_device. I have
> moved things to scsi_target instead to avoid having bazillions of
> sensors show up. Multi-actuator drives are already shipping.
> 

Not sure I understand what you mean with 'bazillions of sensors' and
'sensor per scsi_device'. Can you elaborate ? I see one sensor per drive,
which is what I would expect.

Thanks,
Guenter

> If I recall correctly, though, I seem to recall that you had some sort
> of multi-LUN external disk box that warranted you working on this in the
> first place. Is that correct? Can you refresh my memory?
> 


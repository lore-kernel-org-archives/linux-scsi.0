Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99F7CC2D0C5
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 04:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CE1221835
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 04:21:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bICWgS5r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfLQEVD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Dec 2019 23:21:03 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46915 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfLQEVC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2019 23:21:02 -0500
Received: by mail-pl1-f196.google.com with SMTP id k20so5455645pll.13;
        Mon, 16 Dec 2019 20:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1dhrWMKVs0KTJdvoLHIwqKx+SooldXEIUnlctNZyd24=;
        b=bICWgS5rux5fbWmrgeTA24HGXKEgn2EDTPjH8yidgqQm8ZY7in7URgbA2LKrOF3LCQ
         p6FhN8Ghce01yenIMuVhbo8JkmwPfeZobAw3R1cy0UVXXAotfceSxT6RlH3+krNvKJPS
         smclAlJw4/hvKt1fXJa5wy1e5mZHcqwVnBqgd10xNrY9zGS8joLNkLD/ZJakMuG8HdjZ
         Oiv2K4v7VDvQ47VAg7LMU4ROmJj9qunpXJUPzUARXdkwrPc7gmLc2kB7r0TbnQZnPe5Q
         gQgmckd54pvK90mQ1ide7rpaF3iAFo8V7MvVfv4KsSCSMkEPqfAdJ8U/SEzvveWNCrsp
         HVXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1dhrWMKVs0KTJdvoLHIwqKx+SooldXEIUnlctNZyd24=;
        b=FtyJpge8Muc9MBG7m87A99+SjXO+/bPrGEW9EMa7YO6m+lgjIA4KsKghaSK+BA3wMs
         tDDKl4arzF1vyyIQuRCjZ9OabUTdQvCdPb9q6gYVfGIQBFYwho8acl2npBihS1/mi52b
         MqyGZz0CmxStfHydbSG3mFEpK5K/yz8StAoM0nKWvUHt0QZMDcGYwcF5yt7CrmZv7unR
         958SdGmueFUz2pSVnqRNrlutP6OwSiPLzIf8R74v6A2Va0rWrrv7sJJ6nKG8pw7QgwCG
         mt/jwJoDt8y7iZRRdEgteR7Ye/WssWUx1emvk8pjLFC438OlAZhJb8GzBZf7FfiuE9vP
         0D/g==
X-Gm-Message-State: APjAAAUKN7WlP1VgC3RIAFd5u25c0BVzX34W/gP/6PyDtQ/ipFzB1fei
        ukqXeTzjyR3vnBBBLdIhJVk=
X-Google-Smtp-Source: APXvYqxVd0mKhRZCKOnZFBo0ppXpy8qS2wEsSanP647rWSVDfDnnJ+XyZh1+YSiEdqCDajdLbp5YDg==
X-Received: by 2002:a17:90a:fa92:: with SMTP id cu18mr3710241pjb.114.1576556462069;
        Mon, 16 Dec 2019 20:21:02 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f8sm1076415pjg.28.2019.12.16.20.20.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 20:20:59 -0800 (PST)
Subject: Re: [PATCH 1/1] hwmon: Driver for temperature sensors on SATA drives
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>
References: <20191209052119.32072-1-linux@roeck-us.net>
 <20191209052119.32072-2-linux@roeck-us.net>
 <CACRpkdYjidQHB0=S_brDxH3k+qJ2mfXCTF9A3SVZkPvBaVg6JQ@mail.gmail.com>
 <yq1wob1jfjm.fsf@oracle.com>
 <541a7ddd-f4c9-5d5f-4f43-0ae5bc46aef6@roeck-us.net>
 <yq1tv5zhdn5.fsf@oracle.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <c5689126-46bc-b551-11d7-e5bd8c01f82c@roeck-us.net>
Date:   Mon, 16 Dec 2019 20:20:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <yq1tv5zhdn5.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/16/19 6:47 PM, Martin K. Petersen wrote:
> 
> Guenter,
> 
>> Not sure I understand what you mean with 'bazillions of sensors' and
>> 'sensor per scsi_device'. Can you elaborate ? I see one sensor per
>> drive, which is what I would expect.
> 
> Yes, but for storage arrays, hanging off of struct scsi_device means you
> would get a sensor for each volume you create. Even though you
> presumably only have one physical "box" to monitor (ignoring for a
> moment that the drives inside the box may have their own sensors that
> may or may not be visible to the host).
> 
> Also, multi-actuator disk drives are shipping. They present themselves
> to the host as a target with multiple LUNs. Once again you'll probably
> have one temperature sensor for the physical drive but many virtual
> disks being presented to the OS. So you'd end up with for instance 4
> sensors in hwmon even though there physically only is one.
> 
> It's a tough call since there may be hardware configurations where
> distinct per-LUN temperature is valid (some quirky JBODs represent disk
> drives as different LUNs instead of different targets, for instance).
> 
> How expensive will it be to have - say - 100 hwmon sensors instantiated
> for a drive tray?
> 

If that drive tray has 100 physical drives, that is what I would expect
to see. The most expensive part is the device entry, and there are already
several of those for each scsi device. I have seen systems with hundreds
of hwmon devices (backbone switches tend to be quite generous with
voltage, current, power, and temperature sensors), so I am not
particularly concerned in that regard. If there are 100 physical drives,
you would actually want to see the temperature of each drive separately,
as one of them might be overheating due to some internal failure.

If the storage array is represented to the system as single huge physical
drive, which is then split into logical entities not related to physical
drives, I guess that would represent a problem for system management overall.
Maybe such boxes have separate thermal monitoring ? Either case, we
have the question if it is possible to distinguish the pseudo-physical
drive from the virtual drives (or volumes).

I would not mind to tie the hardware monitoring device to something else
than the scsi device if the scsi device does not always have a physical
representation. Is there a way to determine if a scsi device is virtual
or real ? Obviously it does not make sense to report the same temperature
multiple times, and we would want only a single temperature reported
for each physical drive. At the same time, I absolutely want to avoid
a situation where a single hardware monitoring device would report
the temperature of multiple drives. The concern here is crossing OIR
boundaries. A single hardware monitoring device should never cross
an OIR boundary.

Thanks,
Guenter

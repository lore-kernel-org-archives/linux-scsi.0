Return-Path: <SRS0=w4/B=3B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5C2C32771
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 13:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D6A821556
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 13:07:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M3VUccRO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732866AbgALNHV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jan 2020 08:07:21 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43480 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732692AbgALNHV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jan 2020 08:07:21 -0500
Received: by mail-pl1-f194.google.com with SMTP id p27so2743744pli.10;
        Sun, 12 Jan 2020 05:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CkkPV1V6F6dgkJ6dL78qCqHTk9axSH3F/zPW2/96HSo=;
        b=M3VUccRO9lT0qjWJ/wQWpecefvjDM6o0eEW8XPRdjzcOv5Bzw96STc3J5TY427x6Zu
         rxK5qB9K2nh+Zbmizv/V2ETFkMZ02/3dhbaTYvUv2m1jq7bwBoXOkScRzMemhL62CYV3
         ZCU5VnK/rnpoaUpQ0c021tCUopJyrO4/fujHIdwnJxNAIbk+e2N3LKiNhd7sFa7yV0B0
         0iWWMi96CtbrteICeUxzaU2rg82AYJIGA4btWh0sWFCyNibyfWI7S0io7TNAgXm93yoK
         qn+5NpWDbH2MsfCNRJ6+d3p0E+5J4mWjRLfGnBxGzoPWGFNW5s4FQl9Co98ocEwkwucT
         lKsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CkkPV1V6F6dgkJ6dL78qCqHTk9axSH3F/zPW2/96HSo=;
        b=Xd40E9CjIdJz3zhl/wfWglH3n3lcCeHYFYevxI0R9E/iGZD/Wh1+kS2l9OD9kGunZU
         l5BVKHJEyAHt/vpkKrSU4f7+Ho25+EoZGezVKp/jFA+n41C38eG7f/7iMZthnPlINN1i
         4QGI7NQ8JslccVy66jlWgPElAz3/+AQOx/QJJ5qqheeGcb9aZ2AeLutBZfXCJbIsYn1b
         01IPMYx8+zdmhZrf66OYS0MIpS6xRpwR2TRlJPd2XvJ/c0t8ugdkK5Vga60sljOqmQdc
         x9LeLvMCAFsKxrGVCd8nKP2c6De6qawmfRLefi2nORuBpp4SuksxWdzwp3vYcW0JeX9S
         A82Q==
X-Gm-Message-State: APjAAAXQw3wUqCPWcsIceXiHfTq8aP43+dFWl3axysEUtg2RQvwV7QGq
        SvBh+NWR7pa2B0/SMC0j8Ks=
X-Google-Smtp-Source: APXvYqzkAvWcYQUahLKqH+GNQBSBv3IY+OiC0xqWmAiqJltAql2ji+1REEQW/kfYhGfwcgCKrrju9w==
X-Received: by 2002:a17:902:b48c:: with SMTP id y12mr11774768plr.153.1578834440298;
        Sun, 12 Jan 2020 05:07:20 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k23sm9355894pgg.7.2020.01.12.05.07.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jan 2020 05:07:19 -0800 (PST)
Subject: Re: [PATCH v2] hwmon: Driver for temperature sensors on SATA drives
To:     Linus Walleij <linus.walleij@linaro.org>,
        Gabriel C <nix.or.die@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)" 
        <linux-ide@vger.kernel.org>, Chris Healy <cphealy@gmail.com>
References: <20191215174509.1847-1-linux@roeck-us.net>
 <20191215174509.1847-2-linux@roeck-us.net> <yq1r211dvck.fsf@oracle.com>
 <b22a519c-8f26-e731-345f-9deca1b2150e@roeck-us.net>
 <yq1sgkq21ll.fsf@oracle.com> <20200108153341.GB28530@roeck-us.net>
 <38af9fda-9edf-1b54-bd8d-92f712ae4cda@roeck-us.net>
 <CAEJqkgg_piiAWy4r3VD=KyQ7pi69bZNym2Ws=Tr8SY5wf+Sprg@mail.gmail.com>
 <CACRpkdYU7ZDcKp+BbXRCnEFDw1xwDkU_vXsfo-AZNUWGEVknXQ@mail.gmail.com>
 <CAEJqkggo3Mou1SykjisyYn+3SGGgNfnKagr=7ZPyw=Y=1MZ55w@mail.gmail.com>
 <CACRpkdayHFmdz4nAMaXR07Hcy=dLLGnnU8PkFhwQKuDTLnvOSw@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <e3caa946-b8f2-75c7-4bcb-69ad198de472@roeck-us.net>
Date:   Sun, 12 Jan 2020 05:07:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CACRpkdayHFmdz4nAMaXR07Hcy=dLLGnnU8PkFhwQKuDTLnvOSw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/12/20 4:07 AM, Linus Walleij wrote:
> On Sun, Jan 12, 2020 at 1:03 PM Gabriel C <nix.or.die@gmail.com> wrote:
>> Am So., 12. Jan. 2020 um 12:22 Uhr schrieb Linus Walleij
>> <linus.walleij@linaro.org>:
>>>
>>> On Sun, Jan 12, 2020 at 12:18 PM Gabriel C <nix.or.die@gmail.com> wrote:
>>>
>>>> What I've noticed however is the nvme temperature low/high values on
>>>> the Sensors X are strange here.
>>> (...)
>>>> Sensor 1:     +27.9°C  (low  = -273.1°C, high = +65261.8°C)
>>>> Sensor 2:     +29.9°C  (low  = -273.1°C, high = +65261.8°C)
>>> (...)
>>>> Sensor 1:     +23.9°C  (low  = -273.1°C, high = +65261.8°C)
>>>> Sensor 2:     +25.9°C  (low  = -273.1°C, high = +65261.8°C)
>>>
>>> That doesn't look strange to me. It seems like reasonable defaults
>>> from the firmware if either it doesn't really log the min/max temperatures
>>> or hasn't been through a cycle of updating these yet. Just set both
>>> to absolute min/max temperatures possible.
>>
>> Ok I'll check that.
>>
>> Do you mean by setting the temperatures to use a lmsensors config?
>> Or is there a way to set these with a nvme command?
> 
> Not that I know of.
> 
> The min/max are the minumum and maximum temperatures the
> device has experienced during this power-on cycle.
> 

No, that would be lowest/highest. The above are (or should be) per-sensor
setpoints. The default for those is typically the absolute minimum /
maximum of the supported range.

Some SATA drives report the lowest/highest temperatures experienced
since power cycle, like here.

drivetemp-scsi-5-0
Adapter: SCSI adapter
temp1:        +23.0°C  (low  =  +0.0°C, high = +60.0°C)
                        (crit low = -41.0°C, crit = +85.0°C)
                        (lowest = +20.0°C, highest = +31.0°C)

Guenter

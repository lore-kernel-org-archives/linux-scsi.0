Return-Path: <SRS0=w4/B=3B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC9CC33CAA
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 15:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2CE021556
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 15:26:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QbaxMTLB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733071AbgALP0l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jan 2020 10:26:41 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36723 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733062AbgALP0l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jan 2020 10:26:41 -0500
Received: by mail-pg1-f194.google.com with SMTP id k3so3472055pgc.3;
        Sun, 12 Jan 2020 07:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9mpci+1EtRHccMISBpQo/AaeUz8hmG5B92+V59ldewE=;
        b=QbaxMTLBdKalE2qMh2Tpw+5yK7FumIrWlcYNOLDH18cuwZlJNkNE5Pdg4ERKs+7hSr
         jKs4+T5bHy1SSe+2xxdCJ5B0XxIcbDaRWJwFW/J/GHcutfT/+XVWH9Rd5Klqg4ZMKa4o
         zNYmr9Os9X0xFrTzo5dcCsTNrAaJ4ecIn+pjhA2ck1lKeiTCA2x1xuCEkvRQeP7wyXnH
         SGWs0oqSy1X6zBwEZI4F+u25DKFcwJYGblp/drIaV0ETZLxQYPACy/BnfVmBQHzE+4X6
         wA+U5OhkUlsAohaeB3ebYNhBr228glL/KrNLYWW825nnPqcnHPNk3vxB49NToK3bqnGh
         PbtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9mpci+1EtRHccMISBpQo/AaeUz8hmG5B92+V59ldewE=;
        b=Amf/bol+Y+qwKHZ3VmNVdQbyw1tdCatnGFzYyUkK/5HgVAlkjo6ayspFfPeYvYK1bs
         0R8shQIiIEv8y+x68YV82VOKFpy/R4XMjlnmaCI5AGouR1LzzroSGbE2CzDCpLef6oWK
         9OvhNkXqM2SeX5rv0k2ANfLsT116MnYt6aeCdyLAuLyVTCGqWcl0rawYZKnq9rMi0g+F
         tGHbioZLFcflvfk3uU0DnpmsTNYBkNVg4CU26GICLaqM4vXMG6g0WcwSRgEq0bdiOFnF
         oLeVvN/hb625ifkeJ1aGVpTaUDR8+61kil2Yq18lXtOPie998kPpWj8dEo9K9mxy7h+u
         kemA==
X-Gm-Message-State: APjAAAVK2OZhTsxu35omG/fdXn5SKAn+1vFQiWa8raiHpsYZWVndiORc
        EBUXYR+6RDASF2S8nhC8y7A=
X-Google-Smtp-Source: APXvYqwtXlY/DrUh/9KJc0JZMcj64zOvfPnmBKd6tEWpEB6gV61zOaYlOu+px7l9oQR+Mgboegh2xw==
X-Received: by 2002:aa7:848c:: with SMTP id u12mr14881679pfn.12.1578842799627;
        Sun, 12 Jan 2020 07:26:39 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l21sm10624740pff.100.2020.01.12.07.26.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jan 2020 07:26:38 -0800 (PST)
Subject: Re: [PATCH v2] hwmon: Driver for temperature sensors on SATA drives
To:     Gabriel C <nix.or.die@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
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
 <e3caa946-b8f2-75c7-4bcb-69ad198de472@roeck-us.net>
 <CAEJqkggBvBus-G=TevSf0OUWLx_63qmZEThi-tNyPmAD2JXW-g@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <25c57e9d-94db-3a8b-5f68-f8a49e500b45@roeck-us.net>
Date:   Sun, 12 Jan 2020 07:26:36 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAEJqkggBvBus-G=TevSf0OUWLx_63qmZEThi-tNyPmAD2JXW-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/12/20 5:45 AM, Gabriel C wrote:
> Am So., 12. Jan. 2020 um 14:07 Uhr schrieb Guenter Roeck <linux@roeck-us.net>:
>>
>> On 1/12/20 4:07 AM, Linus Walleij wrote:
>>> On Sun, Jan 12, 2020 at 1:03 PM Gabriel C <nix.or.die@gmail.com> wrote:
>>>> Am So., 12. Jan. 2020 um 12:22 Uhr schrieb Linus Walleij
>>>> <linus.walleij@linaro.org>:
>>>>>
>>>>> On Sun, Jan 12, 2020 at 12:18 PM Gabriel C <nix.or.die@gmail.com> wrote:
>>>>>
>>>>>> What I've noticed however is the nvme temperature low/high values on
>>>>>> the Sensors X are strange here.
>>>>> (...)
>>>>>> Sensor 1:     +27.9°C  (low  = -273.1°C, high = +65261.8°C)
>>>>>> Sensor 2:     +29.9°C  (low  = -273.1°C, high = +65261.8°C)
>>>>> (...)
>>>>>> Sensor 1:     +23.9°C  (low  = -273.1°C, high = +65261.8°C)
>>>>>> Sensor 2:     +25.9°C  (low  = -273.1°C, high = +65261.8°C)
>>>>>
>>>>> That doesn't look strange to me. It seems like reasonable defaults
>>>>> from the firmware if either it doesn't really log the min/max temperatures
>>>>> or hasn't been through a cycle of updating these yet. Just set both
>>>>> to absolute min/max temperatures possible.
>>>>
>>>> Ok I'll check that.
>>>>
>>>> Do you mean by setting the temperatures to use a lmsensors config?
>>>> Or is there a way to set these with a nvme command?
>>>
>>> Not that I know of.
>>>
>>> The min/max are the minumum and maximum temperatures the
>>> device has experienced during this power-on cycle.
>>>
>>
>> No, that would be lowest/highest. The above are (or should be) per-sensor
>> setpoints. The default for those is typically the absolute minimum /
>> maximum of the supported range.
>>
>> Some SATA drives report the lowest/highest temperatures experienced
>> since power cycle, like here.
>>
>> drivetemp-scsi-5-0
>> Adapter: SCSI adapter
>> temp1:        +23.0°C  (low  =  +0.0°C, high = +60.0°C)
>>                          (crit low = -41.0°C, crit = +85.0°C)
>>                          (lowest = +20.0°C, highest = +31.0°C)
>>
> 
> The SATA temperatures are fine and reported like this here too, just
> the nvme ones are strange.
> 
> drivetemp-scsi-4-0
> Adapter: SCSI adapter
> temp1:        +28.0°C  (low  =  +1.0°C, high = +61.0°C)
>                        (crit low =  +2.0°C, crit = +60.0°C)
>                        (lowest = +16.0°C, highest = +31.0°C)
> 
> drivetemp-scsi-12-0
> Adapter: SCSI adapter
> temp1:        +29.0°C  (low  =  +1.0°C, high = +61.0°C)
>                        (crit low =  +2.0°C, crit = +60.0°C)
>                        (lowest = +18.0°C, highest = +32.0°C)
> 
> and so on.
> 
> Btw, where I can find the code does these calculations?
> 

Not sure if that is what you are looking for, but the nvme hardware
monitoring driver is at drivers/nvme/host/hwmon.c, the SATA hardware
monitoring driver is at drivers/hwmon/drivetemp.c.

The limits on nvme drives are configurable.

root@server:/sys/class/hwmon# sensors nvme-pci-0100
nvme-pci-0100
Adapter: PCI adapter
Composite:    +40.9°C  (low  = -273.1°C, high = +84.8°C)
                        (crit = +84.8°C)
Sensor 1:     +40.9°C  (low  = -273.1°C, high = +65261.8°C)
Sensor 2:     +43.9°C  (low  = -273.1°C, high = +65261.8°C)

root@server:/sys/class/hwmon# echo 0 > hwmon1/temp2_min
root@server:/sys/class/hwmon# echo 100000 > hwmon1/temp2_max

root@server:/sys/class/hwmon# sensors nvme-pci-0100
nvme-pci-0100
Adapter: PCI adapter
Composite:    +38.9°C  (low  = -273.1°C, high = +84.8°C)
                        (crit = +84.8°C)
Sensor 1:     +38.9°C  (low  =  -0.1°C, high = +99.8°C)
Sensor 2:     +42.9°C  (low  = -273.1°C, high = +65261.8°C)

If you dislike the defaults, just configure whatever you think is
appropriate for your system.

Thanks,
Guenter

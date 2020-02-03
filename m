Return-Path: <SRS0=0hmW=3X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94812C35247
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 14:48:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C1022080C
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 14:48:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jx6r5Lia"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgBCOsB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Feb 2020 09:48:01 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44694 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727427AbgBCOsB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2020 09:48:01 -0500
Received: by mail-pg1-f194.google.com with SMTP id g3so2229971pgs.11;
        Mon, 03 Feb 2020 06:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=83ABERR3SXd05uLlC6qxZc3SIAbiKjtXN4TG7rOd3Iw=;
        b=jx6r5LiaMOeXKCsrDYstzaXd7gnLPfl8GsxDRXbrlpiegDSSSs6lfqikAOxXcpCw/g
         zcoBvk656wdjPs/cXgQE0zZXdJjw3tMvGZzWdXu/EWmXCvQUASsXrepUkWMXhzrwvwc6
         3zvYITHwDyHM8NLtg0u/YxV3u+JX7mMu5Nv+vhLLDAkZYVPmnB3KkFwJx1dH8hu5S/lP
         fArySjxW9I+ydFx7oOCR0GTdMtyMZ9ftfKw9Dt0gQs4mTpelN6D8FVYoccGaiMhrpO3+
         BpzwFlW/2qjRKa11OFh2Xs5NouhLtUpQyfGx47q/qpamFd+1g06/Ar7jPjoLeIXZhSuN
         CwJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=83ABERR3SXd05uLlC6qxZc3SIAbiKjtXN4TG7rOd3Iw=;
        b=PSo4W8BvapONgwfPWquFH+vFhOyTeHJkfF7RG9O3wgcHXqqenCmLiYMacStreFf+le
         faOfPrcR3jTQGWeeGsbLHRtoVoTKjyjLKjgcFDmDcIszs0U5x6NOHHQi/POcX1A9EvX/
         O9OaKuhhO+XGfA03CJqMPFHE7pMg7ZDSH5OiIG+1anWYf4B7vOQN2QBJ0fAU7VcX3kjY
         gDmIBVbI3RCX/asiaxaAp8IzgQu3NBdES4HKU6IjJdWzu/N0jTOCLeoxx87SmU3MRYMi
         Ryws4zvM5O0be43vqSe7FWQIpc729pDzu/ZvnaFjRQ8uqkztlvGmcZfhX6y6UBA0xBTv
         H5QA==
X-Gm-Message-State: APjAAAXmmetBwnU00sFFDn4NFZfEepiLAcyzK34V0zfR1u5HByOB8GYs
        HwqxWrpUoehlfZfTHL6s9ZER23aq
X-Google-Smtp-Source: APXvYqyBFaoP5ZJZ+WoBLALu6+7YmzoFOXgRahLjQGDeB3p6e69HOopAuyLkHP4C/vNi39uai6rA8g==
X-Received: by 2002:a63:f403:: with SMTP id g3mr25999128pgi.62.1580741279858;
        Mon, 03 Feb 2020 06:47:59 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a16sm20142226pgb.5.2020.02.03.06.47.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2020 06:47:57 -0800 (PST)
Subject: Re: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
To:     Avi Shchislowski <Avi.Shchislowski@wdc.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
 <20200202192105.GA20107@roeck-us.net>
 <MN2PR04MB61906E820FAF0F17082D53AE9A000@MN2PR04MB6190.namprd04.prod.outlook.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <94cb1e97-18ed-ebec-23c2-b4d87434726a@roeck-us.net>
Date:   Mon, 3 Feb 2020 06:47:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <MN2PR04MB61906E820FAF0F17082D53AE9A000@MN2PR04MB6190.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/3/20 3:57 AM, Avi Shchislowski wrote:
> 
> 
>> -----Original Message-----
>> From: Guenter Roeck <groeck7@gmail.com> On Behalf Of Guenter Roeck
>> Sent: Sunday, February 2, 2020 9:21 PM
>> To: Avi Shchislowski <Avi.Shchislowski@wdc.com>
>> Cc: Alim Akhtar <alim.akhtar@samsung.com>; Avri Altman
>> <Avri.Altman@wdc.com>; James E.J. Bottomley <jejb@linux.ibm.com>;
>> Martin K. Petersen <martin.petersen@oracle.com>; linux-
>> kernel@vger.kernel.org; linux-scsi@vger.kernel.org
>> Subject: Re: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
>>
>   
>> On Sun, Feb 02, 2020 at 12:46:54PM +0200, Avi Shchislowski wrote:
>>> UFS3.0 allows using the ufs device as a temperature sensor. The
>>> purpose of this feature is to provide notification to the host of the
>>> UFS device case temperature. It allows reading of a rough estimate
>>> (+-10 degrees centigrade) of the current case temperature, And setting
>>> a lower and upper temperature bounds, in which the device will trigger
>>> an applicable exception event.
>>>
>>> We added the capability of responding to such notifications, while
>>> notifying the kernel's thermal core, which further exposes the thermal
>>> zone attributes to user space. UFS temperature attributes are all
>>> read-only, so only thermal read ops (.get_xxx) can be implemented.
>>>
>>
>> Can you add an explanation why this can't be added to the just-introduced
>> 'drivetemp' driver in the hwmon subsystem, and why it make sense to have
>> proprietary attributes for temperature and temperature limits ?
>>
>> Thanks,
>> Guenter
>>
> Hi Guenter
> 
> Thank you for your comment
> 
> The ufs device is not a temperature sensor per-se.  It is, first and foremost, a storage device.

Huh ? Many non-temperature-sensor devices in the kernel report their temperature
through the hardware monitoring subsystem.

> Reporting the device case temperature is a feature added in a recently released UFS spec (UFS3.0).
> Therefore, adding a thermal-core module, in opposed to hwmon module, seemed more appropriate.
> Registering a hwmon device look excessive, as no other hw-monitoring attribute is available - aside temperature.
> 
Really ? Interesting position. Are you saying that instantiating a thermal core
module, plus providing non-standard sysfs attributes to report the temperature,
is less complex ? Are you sure ? Can you provide evidence that this is indeed
the case ?

> Using Martin's tree, I wasn't able to locate the 'drivetemp' module, nor any reference to  it in the hwmon documentation.
> 

You might want to consider looking in the mainline kernel.

Guenter

Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D8E4C43603
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 06:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E787B2071E
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 06:00:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KuvapgAF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfLIGAe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 01:00:34 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39640 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfLIGAe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 01:00:34 -0500
Received: by mail-pl1-f194.google.com with SMTP id o9so5321536plk.6;
        Sun, 08 Dec 2019 22:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nhb5iYSKarpzYLBlnwTSbrMg2sj4+ZyMpkyTdMyfngA=;
        b=KuvapgAFtrWic560Lj82rvz2Y68f8uUuOoJqyquWJGcFKs4rW0HDc6Wz7l/s3VT3tQ
         Ig4sY6x26kFVEsosgohf5d4njPDHmLerGHLdJrCvRRO8/ziqkggrI5XZxOXahiBW38Zj
         rvv65YuqvzNvPl/nVot8+8PtO/11UL3ArGalFLY4oFAnD/jbWGQESUxhGmFrW1kCFK/L
         TMGh5sHS8V/NKC3dcbiY4+mn4uINqxsH4aM7vUc/fxm2bUUvGWKFDPocnz1H3fdgVC71
         QrVSz1+1uVv6KVDfLf/4gpg0yvGhK3EG72k/egpBXRfAcERNWKU+spbtHsR04V9YJn8r
         OOmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nhb5iYSKarpzYLBlnwTSbrMg2sj4+ZyMpkyTdMyfngA=;
        b=XSyVVRfZBdfj2AQLvahCdUf7jhbWNAg3qnSBj//dxSr03U1CFap0IIbBWhwuTwsgnE
         c5nMNcwd7XqR3fCAC7WyTFTgUasOwKZ/ylwTZ2esz1v7HGcYpo3bdl1fFF8i4UNHwZVx
         7lmeX6xObJN+Ra/QTMaACuzdRkBKPGQOXKJJjFuELiNXunhg+WF0uJ6GStmc3/VfWPiU
         GtQRDr5whq+VBNarMQ3nhWEpC4YrxM6xuplTH+pT0KvWYQXZu0DNNU/1rC4FkSz4RkgK
         3IeUCiuEe262VJhNhHXFITKUztpkFXOFRSQLV/FdEgUfVTv4jgwbCvPkrX6t70b4GTTx
         YUFg==
X-Gm-Message-State: APjAAAWQU+zmOSEW/iuRn7YL7EWgs41mtKTj/s9S3pEfUofNn4pyQqMa
        4yTUuQ63+GgGOFzsqRbwarU=
X-Google-Smtp-Source: APXvYqwZaJmwlO80tNnx2ffsisZwtZsQB/t/XqrR/oUKqfUW4e6AsIWaHBQmae/9M1fzSWQykM7boA==
X-Received: by 2002:a17:902:8309:: with SMTP id bd9mr27125627plb.113.1575871233472;
        Sun, 08 Dec 2019 22:00:33 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z10sm2324777pfa.184.2019.12.08.22.00.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Dec 2019 22:00:32 -0800 (PST)
Subject: Re: [PATCH 1/1] hwmon: Driver for temperature sensors on SATA drives
To:     Randy Dunlap <rdunlap@infradead.org>, linux-hwmon@vger.kernel.org
Cc:     Jean Delvare <jdelvare@suse.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, Chris Healy <cphealy@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
References: <20191209052119.32072-1-linux@roeck-us.net>
 <20191209052119.32072-2-linux@roeck-us.net>
 <dc914b45-961c-a1d1-bc25-f6922004f6f4@infradead.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <2b77af4c-7a49-2f50-e209-2fe27bc0ed48@roeck-us.net>
Date:   Sun, 8 Dec 2019 22:00:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <dc914b45-961c-a1d1-bc25-f6922004f6f4@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/8/19 9:28 PM, Randy Dunlap wrote:
> Hi,
> 
> On 12/8/19 9:21 PM, Guenter Roeck wrote:
>> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
>> index 13a6b4afb4b3..4c63eb7ba96a 100644
>> --- a/drivers/hwmon/Kconfig
>> +++ b/drivers/hwmon/Kconfig
>> @@ -1346,6 +1346,16 @@ config SENSORS_RASPBERRYPI_HWMON
>>   	  This driver can also be built as a module. If so, the module
>>   	  will be called raspberrypi-hwmon.
>>   
>> +config SENSORS_SATATEMP
>> +	tristate "SATA hard disk drives with temperature sensors"
>> +	depends on SCSI && ATA
>> +	help
>> +	  If you say yes you get support for the temperature sensor on
>> +	  SATA hard disk drives.
>> +
>> +	  This driver can also be built as a module. If so, the module
>> +	  will be called smarttemp.
> 
> Makefile seems to say satatemp.
> 

Oops. Thanks for the note. Will fix.

Guenter

>> +
>>   config SENSORS_SHT15
>>   	tristate "Sensiron humidity and temperature sensors. SHT15 and compat."
>>   	depends on GPIOLIB || COMPILE_TEST
>> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
>> index 40c036ea45e6..fe55b8f76af9 100644
>> --- a/drivers/hwmon/Makefile
>> +++ b/drivers/hwmon/Makefile
>> @@ -148,6 +148,7 @@ obj-$(CONFIG_SENSORS_S3C)	+= s3c-hwmon.o
>>   obj-$(CONFIG_SENSORS_SCH56XX_COMMON)+= sch56xx-common.o
>>   obj-$(CONFIG_SENSORS_SCH5627)	+= sch5627.o
>>   obj-$(CONFIG_SENSORS_SCH5636)	+= sch5636.o
>> +obj-$(CONFIG_SENSORS_SATATEMP)	+= satatemp.o
>>   obj-$(CONFIG_SENSORS_SHT15)	+= sht15.o
>>   obj-$(CONFIG_SENSORS_SHT21)	+= sht21.o
>>   obj-$(CONFIG_SENSORS_SHT3x)	+= sht3x.o
> 
> 


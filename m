Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E5A3C2D0C0
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 05:28:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34A9020637
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 05:28:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QrzkL5Vg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfLIF22 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 00:28:28 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51366 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfLIF22 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 00:28:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4Z1NZMDltVAwA0hJxCsesvavrWXAqJG384PzoA7CdXA=; b=QrzkL5VgqOxbZoKXf8QU9NCRv
        KNCVzrIszwSvzJkOpcraw85pgPE1FKeM/P0TQ4D9e9oQ/BdtJC2tKuqX0MBIgHDQckHHZwk0arXxH
        R7ioJ0MJwiv8K9jr3KWbLpBVHs0b2ACNxDpNrTgaKe3DVklvu8N9ae7fwsZmNdRayDBVTmAQ9Dbey
        irA+1HN/3qddZkin23JELDQkZn78rFpGNjpnpt8aRCUv1pIsxm7leAtpOIkYl1Vjbyg5YrF7GsPMg
        LZ6t8OGeh0b5u8L6xHoqS2PucPGWTHFRpuQTIidWBXT9kSIPbQsIT5TBbvAH4u0f9QNGfIuYqBW2M
        l/Vp8XprA==;
Received: from [2601:1c0:6280:3f0::3deb]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ieBar-0002fD-O3; Mon, 09 Dec 2019 05:28:25 +0000
Subject: Re: [PATCH 1/1] hwmon: Driver for temperature sensors on SATA drives
To:     Guenter Roeck <linux@roeck-us.net>, linux-hwmon@vger.kernel.org
Cc:     Jean Delvare <jdelvare@suse.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, Chris Healy <cphealy@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
References: <20191209052119.32072-1-linux@roeck-us.net>
 <20191209052119.32072-2-linux@roeck-us.net>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <dc914b45-961c-a1d1-bc25-f6922004f6f4@infradead.org>
Date:   Sun, 8 Dec 2019 21:28:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191209052119.32072-2-linux@roeck-us.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 12/8/19 9:21 PM, Guenter Roeck wrote:
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 13a6b4afb4b3..4c63eb7ba96a 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -1346,6 +1346,16 @@ config SENSORS_RASPBERRYPI_HWMON
>  	  This driver can also be built as a module. If so, the module
>  	  will be called raspberrypi-hwmon.
>  
> +config SENSORS_SATATEMP
> +	tristate "SATA hard disk drives with temperature sensors"
> +	depends on SCSI && ATA
> +	help
> +	  If you say yes you get support for the temperature sensor on
> +	  SATA hard disk drives.
> +
> +	  This driver can also be built as a module. If so, the module
> +	  will be called smarttemp.

Makefile seems to say satatemp.

> +
>  config SENSORS_SHT15
>  	tristate "Sensiron humidity and temperature sensors. SHT15 and compat."
>  	depends on GPIOLIB || COMPILE_TEST
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index 40c036ea45e6..fe55b8f76af9 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -148,6 +148,7 @@ obj-$(CONFIG_SENSORS_S3C)	+= s3c-hwmon.o
>  obj-$(CONFIG_SENSORS_SCH56XX_COMMON)+= sch56xx-common.o
>  obj-$(CONFIG_SENSORS_SCH5627)	+= sch5627.o
>  obj-$(CONFIG_SENSORS_SCH5636)	+= sch5636.o
> +obj-$(CONFIG_SENSORS_SATATEMP)	+= satatemp.o
>  obj-$(CONFIG_SENSORS_SHT15)	+= sht15.o
>  obj-$(CONFIG_SENSORS_SHT21)	+= sht21.o
>  obj-$(CONFIG_SENSORS_SHT3x)	+= sht3x.o


-- 
~Randy

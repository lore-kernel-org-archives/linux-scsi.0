Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB419C04E30
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 17:08:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D69E207FD
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 17:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfLIRIS convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 12:08:18 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42250 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfLIRIQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 12:08:16 -0500
Received: by mail-pg1-f195.google.com with SMTP id s64so709651pgb.9;
        Mon, 09 Dec 2019 09:08:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pPjzbV+XoAtiNq1c5fnVV7Us4zipQoGWT7Qul1cJyng=;
        b=ffaJjSqJSiRVtvv352eTQohYdXE+ft52Bfkez4Tjv8dNz5/VsuxocjJwBBZsMDnwp6
         FffcmkHM4+TGDNtyE5MwkNi0KZ9Q5qeLhrAzbi4dKS0ZBUMrUQkJbANFoz++ikq7J18G
         t69eSJsqtWvM9rtR/Auviw14ClMgUNgrdl3KQ5U3DAV5qgjnhFBZf2ZTKFk8im97Trj0
         Szc3ztW4nxbzhXROF4ibtGSqUcjjlZoBIPEy29mfWBISUYlRa9XLFp+CevQua6xw4jvL
         1N2b0BueTTVBpe82Yoms+UVtJCklOEsGdB+7Hn68AQLvId/iQzFwl2n75Kn4p+gTFbpk
         0MAQ==
X-Gm-Message-State: APjAAAXpZ8ENbsXXspHEb/tkWgVGjmotOD2GtvNPGaHYHUUZ+aYSKThK
        EE07nzXskbWPyjRHmu7z5jQ=
X-Google-Smtp-Source: APXvYqxLZEJRTdaKTvd+1D3aFVyOayeVhezMkQ+DuhC85xm2Fqahw6g5npYOtg5jcKeoWnsdtMVLpA==
X-Received: by 2002:a65:6914:: with SMTP id s20mr19419027pgq.44.1575911295347;
        Mon, 09 Dec 2019 09:08:15 -0800 (PST)
Received: from [172.31.133.107] ([216.9.110.1])
        by smtp.gmail.com with ESMTPSA id g191sm43969pfb.19.2019.12.09.09.08.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2019 09:08:14 -0800 (PST)
Subject: Re: [PATCH 1/1] hwmon: Driver for temperature sensors on SATA drives
To:     Guenter Roeck <linux@roeck-us.net>, linux-hwmon@vger.kernel.org
Cc:     Jean Delvare <jdelvare@suse.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, Chris Healy <cphealy@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
References: <20191209052119.32072-1-linux@roeck-us.net>
 <20191209052119.32072-2-linux@roeck-us.net>
From:   Bart Van Assche <bvanassche@acm.org>
X-Pep-Version: 2.0
Message-ID: <c87ca545-d8f1-bf1e-2474-b98a6eb60422@acm.org>
Date:   Mon, 9 Dec 2019 09:08:13 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191209052119.32072-2-linux@roeck-us.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/8/19 9:21 PM, Guenter Roeck wrote:
> +static int satatemp_scsi_command(struct satatemp_data *st,
> +				 u8 ata_command, u8 feature,
> +				 u8 lba_low, u8 lba_mid, u8 lba_high)
> +{
> +	static u8 scsi_cmd[MAX_COMMAND_SIZE];
> +	int data_dir;

Declaring scsi_cmd[] static makes an otherwise thread-safe function
thread-unsafe. Has it been considered to allocate scsi_cmd[] on the stack?

> +	/*
> +	 * Inquiry data sanity checks (per SAT-5):
> +	 * - peripheral qualifier must be 0
> +	 * - peripheral device type must be 0x0 (Direct access block device)
> +	 * - SCSI Vendor ID is "ATA     "
> +	 */
> +	if (sdev->inquiry[0] ||
> +	    strncmp(&sdev->inquiry[8], "ATA     ", 8))
> +		return -ENODEV;

It's possible that we will need a quirk mechanism to disable temperature
monitoring for certain ATA devices. Has it been considered to make
scsi_add_lun() set a flag that indicates whether or not temperatures
should be monitored and to check that flag from inside this function?
I'm asking this because an identical strncmp() check exists in
scsi_add_lun().

> +static int satatemp_read(struct device *dev, enum hwmon_sensor_types type,
> +			 u32 attr, int channel, long *val)
> +{
> +	struct satatemp_data *st = dev_get_drvdata(dev);

Which device does 'dev' represent? What guarantees that the drvdata
won't be used for another purpose, e.g. by the SCSI core?

> +/*
> + * The device argument points to sdev->sdev_dev. Its parent is
> + * sdev->sdev_gendev, which we can use to get the scsi_device pointer.
> + */
> +static int satatemp_add(struct device *dev, struct class_interface *intf)
> +{
> +	struct scsi_device *sdev = to_scsi_device(dev->parent);
> +	struct satatemp_data *st;
> +	int err;
> +
> +	st = kzalloc(sizeof(*st), GFP_KERNEL);
> +	if (!st)
> +		return -ENOMEM;
> +
> +	st->sdev = sdev;
> +	st->dev = dev;
> +	mutex_init(&st->lock);
> +
> +	if (satatemp_identify(st)) {
> +		err = -ENODEV;
> +		goto abort;
> +	}
> +
> +	st->hwdev = hwmon_device_register_with_info(dev->parent, "satatemp",
> +						    st, &satatemp_chip_info,
> +						    NULL);
> +	if (IS_ERR(st->hwdev)) {
> +		err = PTR_ERR(st->hwdev);
> +		goto abort;
> +	}
> +
> +	list_add(&st->list, &satatemp_devlist);
> +	return 0;
> +
> +abort:
> +	kfree(st);
> +	return err;
> +}

How much does synchronously submitting SCSI commands from inside the
device probing call back slow down SCSI device discovery? What is the
impact of this code on systems with a large number of ATA devices?

Thanks,

Bart.


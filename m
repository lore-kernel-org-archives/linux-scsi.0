Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 376A3C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 07:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19FEA60F6D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 07:41:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237710AbhIMHmW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 03:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237653AbhIMHmV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 03:42:21 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F49C061574;
        Mon, 13 Sep 2021 00:41:06 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id i8-20020a056830402800b0051afc3e373aso12136648ots.5;
        Mon, 13 Sep 2021 00:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KNclMVzCG2iKwN+Z4VI8hQxdQzboyYW+jRIl7iwDZ5M=;
        b=iLTr2RZflXI6AC+DOcfdNcWEhKcP4As9CcOQ8N7puf/ZRKTDV3AcA5/Tn4xlGOBKAG
         Ta79uBB+e+YvgYDO9J2ZgUSLL+sbTG9m8ctBxl8dkn5bi/0T8lt+DfJI+PkTUtxYWTDI
         2SamGWU15gyURPXhcIdPDarmt1jY0uQ4C09SBp0hYtmq1yK7prDxlJDg1/NmHoHnG5rQ
         HVK77GP2nq7l/Lr+WYlO9xWvjjkfk6SDABvynQcvE5o/fVilWl3gb/xvN4a3UUOYcLYT
         9wc1hukLq+aTziV+lcC5vem4lYK8R5kDcBT4r2OeDLAN+zjV0Ch29M9mYPIDA0WrkBNu
         kI7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KNclMVzCG2iKwN+Z4VI8hQxdQzboyYW+jRIl7iwDZ5M=;
        b=lbNtU2hcI/K3GOdu6EOIjAf4jE3t4Q1/jxHvhnmmPbMnoEKwspU7FbYpQV07y1JhsU
         1/Q/bFNLxNdKVcIxYoU6fItbNKXCQDQQWshYq8x+MyHjMVVoTYI80ib63eqXlFTmUDuT
         Ic28274bbNzWac158WmtHuKOj9gYPlUtpTI/rwLfuCCJSDVGaL6/Yok4zlltuWCq+fX8
         w0Z4DhCAMHhw/GvSuHngQaBDeFpcZ53krwPJoSDAKOAcAm6XwnvgNn0FRAXl1hIEUhB3
         U6vp7h6xOb9roZ/NLAayYLIpGLS42HYOWT1L3u9PGJkusnJ2jNx+93NXKlTEItjne5Rn
         lTMg==
X-Gm-Message-State: AOAM533Jl6T5ekn+uB1EkKmGG2Q6qcHr2k0xskrIh8wyLzORY5Mrvt+u
        79JqraoBtJfNf+WPZjr2mNY=
X-Google-Smtp-Source: ABdhPJy2Heu3s/aKxkFVCZX8U2jvvo76ztlqD6zvWhvFX4P15WNMTsfti/P4mZ88paHtueCSxOgNog==
X-Received: by 2002:a9d:6945:: with SMTP id p5mr8630084oto.301.1631518865704;
        Mon, 13 Sep 2021 00:41:05 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f5sm1533943oij.6.2021.09.13.00.41.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 00:41:04 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH v3 1/2] scsi: ufs: Probe for temperature notification
 support
To:     Avri Altman <Avri.Altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
References: <20210912131919.12962-1-avri.altman@wdc.com>
 <20210912131919.12962-2-avri.altman@wdc.com>
 <8abe6364-9240-bcaf-c17f-1703243170cb@roeck-us.net>
 <DM6PR04MB65754D1CF6B4769E6CECDB5DFCD99@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <d28e37db-44bb-75f8-d479-dcb106fe146d@roeck-us.net>
Date:   Mon, 13 Sep 2021 00:41:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB65754D1CF6B4769E6CECDB5DFCD99@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/13/21 12:06 AM, Avri Altman wrote:
>>> +config SCSI_UFS_HWMON
>>> +     bool "UFS  Temperature Notification"
>>> +     depends on SCSI_UFSHCD && HWMON
>>> +     help
>>> +       This provides support for UFS hardware monitoring. If enabled,
>>> +       a hardware monitoring device will be created for the UFS device.
>>> +
>>> +       If unsure, say N.
>>> +
>>
>> git complains about blank line at EOF.
> Done.
> 
>>
>>> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
>>> index c407da9b5171..966048875b50 100644
>>> --- a/drivers/scsi/ufs/Makefile
>>> +++ b/drivers/scsi/ufs/Makefile
>>> @@ -10,6 +10,7 @@ ufshcd-core-$(CONFIG_SCSI_UFS_BSG)  += ufs_bsg.o
>>>    ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO)       += ufshcd-crypto.o
>>>    ufshcd-core-$(CONFIG_SCSI_UFS_HPB)  += ufshpb.o
>>>    ufshcd-core-$(CONFIG_SCSI_UFS_FAULT_INJECTION) +=
>>> ufs-fault-injection.o
>>> +ufshcd-core-$(CONFIG_SCSI_UFS_HWMON) += ufs-hwmon.o
>>>
>>>    obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o
>> tc-dwc-g210.o
>>>    obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o
>>> ufshcd-dwc.o tc-dwc-g210.o diff --git a/drivers/scsi/ufs/ufs-hwmon.c
>>> b/drivers/scsi/ufs/ufs-hwmon.c new file mode 100644 index
>>> 000000000000..a50e83f645f4
>>> --- /dev/null
>>> +++ b/drivers/scsi/ufs/ufs-hwmon.c
>>> @@ -0,0 +1,179 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/*
>>> + * UFS hardware monitoring support
>>> + * Copyright (c) 2021, Western Digital Corporation  */
>>> +
>>> +#include <linux/hwmon.h>
>>> +
>>> +#include "ufshcd.h"
>>> +
>>> +struct ufs_hwmon_data {
>>> +     struct ufs_hba *hba;
>>> +     u8 mask;
>>> +};
>>> +
>>> +static bool ufs_temp_enabled(struct ufs_hba *hba, u8 mask) {
>>> +     u32 ee_mask;
>>> +
>>> +     if (ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
>>> +                           QUERY_ATTR_IDN_EE_CONTROL, 0, 0, &ee_mask))
>>> +             return false;
>>> +
>>> +     return (mask & ee_mask & MASK_EE_TOO_HIGH_TEMP) ||
>>> +             (mask & ee_mask & MASK_EE_TOO_LOW_TEMP); }
>>> +
>>> +static bool ufs_temp_valid(struct ufs_hba *hba, u8 mask,
>>> +                        enum attr_idn idn, u32 value) {
>>> +     return (idn == QUERY_ATTR_IDN_CASE_ROUGH_TEMP && value >= 1
>> &&
>>> +             value <= 250 && ufs_temp_enabled(hba, mask)) ||
>>> +           (idn == QUERY_ATTR_IDN_HIGH_TEMP_BOUND && value >= 100 &&
>>> +            value <= 250) ||
>>> +           (idn == QUERY_ATTR_IDN_LOW_TEMP_BOUND && value >= 1 &&
>>> +            value <= 80);
>>> +}
>>> +
>> The value ranges checed above suggest that the temperature is reported in
>> degrees C (or maybe degrees C with an offset).
> Yes.  No offset.
> 
>> The hwmon API expects
>> temperatures to be reported in milli-degrees C, and I don't see a conversion in
>> the actual read functions. What does the "sensors" command report ?
> I missed that (Although it is well documented) - sorry about that.
> I wasn't aware of the sensors command.  I don't have it in my arm64 android platform image (galaxy s21).
> Will try to get it.
> I was reading the temperature using hwmon sysfs entries, which indicate the correct temperature.
> e.g
> t2s:/ # ls -la /sys/class/hwmon/
> total 0
> drwxr-xr-x   2 root root 0 2020-12-20 10:16 .
> drwxr-xr-x 104 root root 0 2020-12-19 19:05 ..
> lrwxrwxrwx   1 root root 0 2020-12-20 10:16 hwmon0 -> ../../devices/platform/13100000.ufs/hwmon/hwmon0
> .....
> 
> t2s:/ # cat /sys/class/hwmon/hwmon0/temp1_input
> 25
> 
> Will fix it.  Thanks.
> 
>>
>>> +static int ufs_get_temp(struct ufs_hba *hba, u8 mask, enum attr_idn
>>> +idn) {
>>> +     u32 value;
>>> +
>>> +     if (ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR, idn, 0, 0,
>>> +         &value))
>>
>> checkpatch states that alignment is off, and I am quite sure this fits into one
>> line anyway (with the 100-column limit). There are more instances with bad
>> alignment according to checkpatch.
> I wasn't aware that the Linux Kernel deprecates the 80 Character Line Coding Style.
> Will try to make it full 100-characters lines.
> I didn't get any alignment complaints from checkpatch.
> 
>>
>> Also, ufshcd_query_attr() returns a valid Linux error code. That should be
>> returned to the caller and not be replaced. More on that below.
>>
>>> +             return 0;
>>> +
>>> +     if (ufs_temp_valid(hba, mask, idn, value))
>>> +             return value - 80;
>>> +
>>
>> This again suggests that the temperature is not milli-degrees C.
>>
>> Is there reason to believe that this validation is necessary ?
>> Note that this reports an "error" if the returned temperature value happens to
>> have a value of 80. Again, more on that below.
> Data->mask holds the temperature related bits in the ufs features register: TOO_LOW_TEMPERATURE and TOO_HIGH_TEMPERATURE.
> This is set for the device by the flash vendor and can't be changed by the OEMs.
> If the device doesn't support any of that, then hwmon_probe is not even called, see ufshcd_temp_notif_probe.
> So data->mask is not 0, and never changes.
> 
> When the device returns a 0 temperature value, it means that it is not valid.
> The spec say about the Device’s rough package case surface temperature:
> "
> This value shall be valid when (TOO_HIGH_TEMPERATURE is supported and TOO_HIGH_TEMP_EN is enabled) or
> ( TOO_LOW_TEMPERATURE is supported and TOO_LOW_TEMP_EN is enabled ).
> 0 : Unknown Temperature , 1~250 : ( this value – 80 ) degrees in Celsius. ( i.e., -79 ºC ~ 170 ºC )
> Others: Reserved
> "
> data->mask is not 0, but the temperature exception bits: TOO_HIGH_TEMP_EN and TOO_LOW_TEMP_EN are of type read/volatile,
> Meaning it can be written many times, e.g. by debugfs or ufs-utils.
> 
> To sum up:
>   - yes, checking the temperature against the spec boundaries is useless.
>     The device will return 0 if it is not valid.
>     ufs_temp_valid() can be removed, and just need to check that the temperature is not 0.
> 
>   - The return value of querry_attr is of less interest.
>      if it failed or temp == 0, then the temperature is invalid and the proper return value should be -EINVAL.
> 
>>
>>> +     return 0;
>>> +}
>>> +
>>> +static int ufs_hwmon_read(struct device *dev, enum hwmon_sensor_types
>> type,
>>> +                        u32 attr, int channel, long *val) {
>>> +     struct ufs_hwmon_data *data = dev_get_drvdata(dev);
>>> +     struct ufs_hba *hba = data->hba;
>>> +     u8 mask = data->mask;
>>> +     int err = 0;
>>> +     bool get_temp = true;
>>> +
>>> +     if (type != hwmon_temp)
>>> +             return 0;
>>> +
>>> +     down(&hba->host_sem);
>>> +
>>> +     if (!ufshcd_is_user_access_allowed(hba)) {
>>> +             up(&hba->host_sem);
>>> +             return -EBUSY;
>>> +     }
>>> +
>>> +     ufshcd_rpm_get_sync(hba);
>>> +
>>> +     switch (attr) {
>>> +     case hwmon_temp_enable:
>>> +             *val = ufs_temp_enabled(hba, mask);
>>> +             get_temp = false;
>>> +
>>
>> This seems to be read-only, and the mask only affects the limit registers as far
>> as I con see. If so, this is wrong: The mask should be used to enable or hide the
>> limit attributes as needed. If the mask is 0, and if this means that the current
>> temperature is not reported either, the driver should not instantiate at all.
>>
>> The "enable" attribute only makes sense if it can be used to actually enable or
>> disable a specific sensor, and is not tied to limit attributes but to the actual
>> sensor values.
> See explanation above.
>   Will make it writable as well.
> 

That only makes sense if the information is passed to the chip. What is going
to happen if the user writes 0 into the attribute ?

Guenter

>>
>>> +             break;
>>> +     case hwmon_temp_max_alarm:
>>> +             *val = ufs_get_temp(hba, mask,
>>> + QUERY_ATTR_IDN_HIGH_TEMP_BOUND);
>>> +
>>> +             break;
>>> +     case hwmon_temp_min_alarm:
>>> +             *val = ufs_get_temp(hba, mask,
>>> + QUERY_ATTR_IDN_LOW_TEMP_BOUND);
>>> +
>>> +             break;
>>> +     case hwmon_temp_input:
>>> +             *val = ufs_get_temp(hba, mask,
>>> + QUERY_ATTR_IDN_CASE_ROUGH_TEMP);
>>> +
>> If an enable attribute exists and is 0 (disabled), this should return -ENODATA.
>> In this case, that would imply that the driver should not be instantiated in the
>> first place since it has nothing to report.
> See explanation above.
> Will fix it so the error value will make more sense.
> 
>>
>>> +             break;
>>> +     default:
>>> +             err = -EOPNOTSUPP;
>>> +
>>> +             break;
>>> +     }
>>> +
>>> +     ufshcd_rpm_put_sync(hba);
>>> +
>>> +     up(&hba->host_sem);
>>> +
>>> +     if (get_temp && !err && *val == 0)
>>> +             err = -EINVAL;
>>> +
>> That is an odd way of detection errors. If it was in the hwmon subsystem, I'd ask
>> for the error handling to be moved into the case statements. On top of that,
>> interpreting a return value of "0" as error seems wrong.
>> ufs_get_temp() returns 0 if the measured temperature or the reported limit
>> happens to have a value of 80, and that is perfectly valid. If ufs_get_temp()
>> reports an error, it should report that as error.
>>
>> Also, EINVAL is "invalid argument", which I am quite sure does not apply here.
> Ditto.
> EINVAL implies that the temperature is invalid.
> 
>>>
>>> +static void ufshcd_temp_notif_probe(struct ufs_hba *hba, u8
>>> +*desc_buf) {
>>> +     struct ufs_dev_info *dev_info = &hba->dev_info;
>>> +     u32 ext_ufs_feature;
>>> +     u8 mask = 0;
>>> +
>>> +     if (!(hba->caps & UFSHCD_CAP_TEMP_NOTIF) ||
>>> +         dev_info->wspecversion < 0x300)
>>
>> I am quite sure this fits a single line.
> Done.
> 


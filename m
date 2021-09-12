Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6217C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Sep 2021 15:24:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7AE56108F
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Sep 2021 15:24:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235454AbhILPZx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Sep 2021 11:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhILPZx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Sep 2021 11:25:53 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE65C061574;
        Sun, 12 Sep 2021 08:24:38 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id b5-20020a4ac285000000b0029038344c3dso2491544ooq.8;
        Sun, 12 Sep 2021 08:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qXJqR8Vkfo+Aif3Ur55LBCmo/8P1slpsU8JvFqRYZN8=;
        b=iYwQ3xb59rArk90wAqsINLETloDFysGo89AScQybLCn/Bf8TLUqsV9A5gBWciyeTMs
         yJJLwN8Icp0CJFFK6F4dHGf+G5XJ8V/tlaUQooSgddUmtWkghmPidplQssEGVlnYv86q
         8tFetSfn73fuNtTKp+abGjY9MTvWsmatJr+5GDAIWe2BmcVW4tDRWFkQ6Dek/mUbZ8Qy
         zf910fkbWS9EAwsJYZyzkBKbzT3Ev4Jrf/H1rHwWYBUxxN855KDN//zSsuP/gW1K3lpj
         OSk1GQltBriCZoMBa1t0bpifEg4kaJq4iMIy3sTeVJC3DUFHJz8AvQPHX8BD7mD/ssGR
         2emQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qXJqR8Vkfo+Aif3Ur55LBCmo/8P1slpsU8JvFqRYZN8=;
        b=zGlDLbL5gbDt6am4nt38mypTyAebqxaTrodOjJDCpwQ5JXuYH0f3rT59Of+YdD/15f
         dCRvqGpKDtohl294ao0pCLU6qKvEua/3bL37U4n2GE/f07CYQ8X+aUONKX1kPoQE0N3g
         L5lzVeivGOxlZuQCY3FqAjNsKFsVicCtEhWxn9epVIBBu557oSFcKywzDurxrajzHcto
         XQw3L1QW+eYe9HxG4L+1P/jLhIpjD9cd4ph+B0nFyHx2JmLPcBMHizYDGEDnzXhKiKzI
         CUp6rFcDYpyV593Z6mijvwjpbF0jc0VNLMU1xKIEyB0pukrTtMRFYanZBKoF6YCe+S7W
         zIBQ==
X-Gm-Message-State: AOAM5314mRnIUKnXm2r4EyX9ftPMP4eNvaceovTwm5XzZ15HT/VXGE9M
        Tgnq4HkKDdcS/MkW0+tEygc=
X-Google-Smtp-Source: ABdhPJzYenFZT9PUz/F1HVsJ6hF/vFQq2GjYx55bGdjFNTr0jgKm6B7achuZD3vjLGtQfnuLClabig==
X-Received: by 2002:a4a:c98c:: with SMTP id u12mr5955718ooq.86.1631460278017;
        Sun, 12 Sep 2021 08:24:38 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v24sm1178233ote.66.2021.09.12.08.24.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 08:24:37 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
References: <20210912131919.12962-1-avri.altman@wdc.com>
 <20210912131919.12962-2-avri.altman@wdc.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v3 1/2] scsi: ufs: Probe for temperature notification
 support
Message-ID: <8abe6364-9240-bcaf-c17f-1703243170cb@roeck-us.net>
Date:   Sun, 12 Sep 2021 08:24:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210912131919.12962-2-avri.altman@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/12/21 6:19 AM, Avri Altman wrote:
> Probe the dExtendedUFSFeaturesSupport register for the device's
> temperature notification support, and if supported, add a hw monitor
> device.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>   drivers/scsi/ufs/Kconfig     |  10 ++
>   drivers/scsi/ufs/Makefile    |   1 +
>   drivers/scsi/ufs/ufs-hwmon.c | 179 +++++++++++++++++++++++++++++++++++
>   drivers/scsi/ufs/ufs.h       |   6 ++
>   drivers/scsi/ufs/ufshcd.c    |  28 ++++++
>   drivers/scsi/ufs/ufshcd.h    |  18 ++++
>   6 files changed, 242 insertions(+)
>   create mode 100644 drivers/scsi/ufs/ufs-hwmon.c
> 
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index 432df76e6318..b930f29fc375 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -199,3 +199,13 @@ config SCSI_UFS_FAULT_INJECTION
>   	help
>   	  Enable fault injection support in the UFS driver. This makes it easier
>   	  to test the UFS error handler and abort handler.
> +
> +config SCSI_UFS_HWMON
> +	bool "UFS  Temperature Notification"
> +	depends on SCSI_UFSHCD && HWMON
> +	help
> +	  This provides support for UFS hardware monitoring. If enabled,
> +	  a hardware monitoring device will be created for the UFS device.
> +
> +	  If unsure, say N.
> +

git complains about blank line at EOF.

> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> index c407da9b5171..966048875b50 100644
> --- a/drivers/scsi/ufs/Makefile
> +++ b/drivers/scsi/ufs/Makefile
> @@ -10,6 +10,7 @@ ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
>   ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO)	+= ufshcd-crypto.o
>   ufshcd-core-$(CONFIG_SCSI_UFS_HPB)	+= ufshpb.o
>   ufshcd-core-$(CONFIG_SCSI_UFS_FAULT_INJECTION) += ufs-fault-injection.o
> +ufshcd-core-$(CONFIG_SCSI_UFS_HWMON) += ufs-hwmon.o
>   
>   obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.o
>   obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
> diff --git a/drivers/scsi/ufs/ufs-hwmon.c b/drivers/scsi/ufs/ufs-hwmon.c
> new file mode 100644
> index 000000000000..a50e83f645f4
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs-hwmon.c
> @@ -0,0 +1,179 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * UFS hardware monitoring support
> + * Copyright (c) 2021, Western Digital Corporation
> + */
> +
> +#include <linux/hwmon.h>
> +
> +#include "ufshcd.h"
> +
> +struct ufs_hwmon_data {
> +	struct ufs_hba *hba;
> +	u8 mask;
> +};
> +
> +static bool ufs_temp_enabled(struct ufs_hba *hba, u8 mask)
> +{
> +	u32 ee_mask;
> +
> +	if (ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +			      QUERY_ATTR_IDN_EE_CONTROL, 0, 0, &ee_mask))
> +		return false;
> +
> +	return (mask & ee_mask & MASK_EE_TOO_HIGH_TEMP) ||
> +		(mask & ee_mask & MASK_EE_TOO_LOW_TEMP);
> +}
> +
> +static bool ufs_temp_valid(struct ufs_hba *hba, u8 mask,
> +			   enum attr_idn idn, u32 value)
> +{
> +	return (idn == QUERY_ATTR_IDN_CASE_ROUGH_TEMP && value >= 1 &&
> +		value <= 250 && ufs_temp_enabled(hba, mask)) ||
> +	      (idn == QUERY_ATTR_IDN_HIGH_TEMP_BOUND && value >= 100 &&
> +	       value <= 250) ||
> +	      (idn == QUERY_ATTR_IDN_LOW_TEMP_BOUND && value >= 1 &&
> +	       value <= 80);
> +}
> +
The value ranges checed above suggest that the temperature is reported
in degrees C (or maybe degrees C with an offset). The hwmon API expects
temperatures to be reported in milli-degrees C, and I don't see a
conversion in the actual read functions. What does the "sensors" command report ?

> +static int ufs_get_temp(struct ufs_hba *hba, u8 mask, enum attr_idn idn)
> +{
> +	u32 value;
> +
> +	if (ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR, idn, 0, 0,
> +	    &value))

checkpatch states that alignment is off, and I am quite sure this fits into one
line anyway (with the 100-column limit). There are more instances with bad alignment
according to checkpatch.

Also, ufshcd_query_attr() returns a valid Linux error code. That should be
returned to the caller and not be replaced. More on that below.

> +		return 0;
> +
> +	if (ufs_temp_valid(hba, mask, idn, value))
> +		return value - 80;
> +

This again suggests that the temperature is not milli-degrees C.

Is there reason to believe that this validation is necessary ?
Note that this reports an "error" if the returned temperature value
happens to have a value of 80. Again, more on that below.

> +	return 0;
> +}
> +
> +static int ufs_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
> +			   u32 attr, int channel, long *val)
> +{
> +	struct ufs_hwmon_data *data = dev_get_drvdata(dev);
> +	struct ufs_hba *hba = data->hba;
> +	u8 mask = data->mask;
> +	int err = 0;
> +	bool get_temp = true;
> +
> +	if (type != hwmon_temp)
> +		return 0;
> +
> +	down(&hba->host_sem);
> +
> +	if (!ufshcd_is_user_access_allowed(hba)) {
> +		up(&hba->host_sem);
> +		return -EBUSY;
> +	}
> +
> +	ufshcd_rpm_get_sync(hba);
> +
> +	switch (attr) {
> +	case hwmon_temp_enable:
> +		*val = ufs_temp_enabled(hba, mask);
> +		get_temp = false;
> +

This seems to be read-only, and the mask only affects the limit registers as
far as I con see. If so, this is wrong: The mask should be used to enable
or hide the limit attributes as needed. If the mask is 0, and if this means
that the current temperature is not reported either, the driver should not
instantiate at all.

The "enable" attribute only makes sense if it can be used to actually enable
or disable a specific sensor, and is not tied to limit attributes but to the
actual sensor values.

> +		break;
> +	case hwmon_temp_max_alarm:
> +		*val = ufs_get_temp(hba, mask, QUERY_ATTR_IDN_HIGH_TEMP_BOUND);
> +
> +		break;
> +	case hwmon_temp_min_alarm:
> +		*val = ufs_get_temp(hba, mask, QUERY_ATTR_IDN_LOW_TEMP_BOUND);
> +
> +		break;
> +	case hwmon_temp_input:
> +		*val = ufs_get_temp(hba, mask, QUERY_ATTR_IDN_CASE_ROUGH_TEMP);
> +
If an enable attribute exists and is 0 (disabled), this should return -ENODATA.
In this case, that would imply that the driver should not be instantiated
in the first place since it has nothing to report.

> +		break;
> +	default:
> +		err = -EOPNOTSUPP;
> +
> +		break;
> +	}
> +
> +	ufshcd_rpm_put_sync(hba);
> +
> +	up(&hba->host_sem);
> +
> +	if (get_temp && !err && *val == 0)
> +		err = -EINVAL;
> +
That is an odd way of detection errors. If it was in the hwmon subsystem,
I'd ask for the error handling to be moved into the case statements. On
top of that, interpreting a return value of "0" as error seems wrong.
ufs_get_temp() returns 0 if the measured temperature or the reported limit
happens to have a value of 80, and that is perfectly valid. If ufs_get_temp()
reports an error, it should report that as error.

Also, EINVAL is "invalid argument", which I am quite sure does not apply here.

> +	return err;
> +}
> +
> +static umode_t ufs_hwmon_is_visible(const void *_data,
> +				     enum hwmon_sensor_types type,
> +				     u32 attr, int channel)
> +{
> +	if (type != hwmon_temp)
> +		return 0;
> +
> +	switch (attr) {
> +	case hwmon_temp_enable:
> +	case hwmon_temp_max_alarm:
> +	case hwmon_temp_min_alarm:
> +	case hwmon_temp_input:
> +		return 0444;
> +	default:
> +		break;
> +	}
> +	return 0;
> +}
> +
> +static const struct hwmon_channel_info *ufs_hwmon_info[] = {
> +	HWMON_CHANNEL_INFO(temp, HWMON_T_ENABLE | HWMON_T_INPUT |
> +			    HWMON_T_MIN_ALARM | HWMON_T_MAX_ALARM),
> +	NULL
> +};
> +
> +static const struct hwmon_ops ufs_hwmon_ops = {
> +	.is_visible	= ufs_hwmon_is_visible,
> +	.read		= ufs_hwmon_read,
> +};
> +
> +static const struct hwmon_chip_info ufs_hwmon_hba_info = {
> +	.ops	= &ufs_hwmon_ops,
> +	.info	= ufs_hwmon_info,
> +};
> +
> +void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask)
> +{
> +	struct device *dev = hba->dev;
> +	struct ufs_hwmon_data *data;
> +	struct device *hwmon;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return;
> +
> +	data->hba = hba;
> +	data->mask = mask;
> +
> +	hwmon = hwmon_device_register_with_info(dev, "ufs",
> +						data, &ufs_hwmon_hba_info,
> +						NULL);
> +	if (IS_ERR(hwmon)) {
> +		dev_warn(dev, "Failed to instantiate hwmon device\n");
> +		kfree(data);
> +		return;
> +	}
> +
> +	hba->hwmon_device = hwmon;
> +}
> +
> +void ufs_hwmon_remove(struct ufs_hba *hba)
> +{
> +	struct ufs_hwmon_data *data;
> +
> +	if (!hba->hwmon_device)
> +		return;
> +
> +	data = dev_get_drvdata(hba->hwmon_device);
> +	hwmon_device_unregister(hba->hwmon_device);
> +	hba->hwmon_device = NULL;
> +	kfree(data);
> +}
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index 8c6b38b1b142..171b27be7b1d 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -152,6 +152,9 @@ enum attr_idn {
>   	QUERY_ATTR_IDN_PSA_STATE		= 0x15,
>   	QUERY_ATTR_IDN_PSA_DATA_SIZE		= 0x16,
>   	QUERY_ATTR_IDN_REF_CLK_GATING_WAIT_TIME	= 0x17,
> +	QUERY_ATTR_IDN_CASE_ROUGH_TEMP          = 0x18,
> +	QUERY_ATTR_IDN_HIGH_TEMP_BOUND          = 0x19,
> +	QUERY_ATTR_IDN_LOW_TEMP_BOUND           = 0x1A,
>   	QUERY_ATTR_IDN_WB_FLUSH_STATUS	        = 0x1C,
>   	QUERY_ATTR_IDN_AVAIL_WB_BUFF_SIZE       = 0x1D,
>   	QUERY_ATTR_IDN_WB_BUFF_LIFE_TIME_EST    = 0x1E,
> @@ -338,6 +341,9 @@ enum {
>   
>   /* Possible values for dExtendedUFSFeaturesSupport */
>   enum {
> +	UFS_DEV_LOW_TEMP_NOTIF		= BIT(4),
> +	UFS_DEV_HIGH_TEMP_NOTIF		= BIT(5),
> +	UFS_DEV_EXT_TEMP_NOTIF		= BIT(6),
>   	UFS_DEV_HPB_SUPPORT		= BIT(7),
>   	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),
>   };
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 67889d74761c..90c2e9677435 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7469,6 +7469,31 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
>   	hba->caps &= ~UFSHCD_CAP_WB_EN;
>   }
>   
> +static void ufshcd_temp_notif_probe(struct ufs_hba *hba, u8 *desc_buf)
> +{
> +	struct ufs_dev_info *dev_info = &hba->dev_info;
> +	u32 ext_ufs_feature;
> +	u8 mask = 0;
> +
> +	if (!(hba->caps & UFSHCD_CAP_TEMP_NOTIF) ||
> +	    dev_info->wspecversion < 0x300)

I am quite sure this fits a single line.

> +		return;
> +
> +	ext_ufs_feature = get_unaligned_be32(desc_buf +
> +					DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP);
> +
> +	if (ext_ufs_feature & UFS_DEV_LOW_TEMP_NOTIF)
> +		mask |= MASK_EE_TOO_LOW_TEMP;
> +
> +	if (ext_ufs_feature & UFS_DEV_HIGH_TEMP_NOTIF)
> +		mask |= MASK_EE_TOO_HIGH_TEMP;
> +
> +	if (mask) {
> +		ufshcd_enable_ee(hba, mask);
> +		ufs_hwmon_probe(hba, mask);
> +	}
> +}
> +
>   void ufshcd_fixup_dev_quirks(struct ufs_hba *hba, struct ufs_dev_fix *fixups)
>   {
>   	struct ufs_dev_fix *f;
> @@ -7564,6 +7589,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
>   
>   	ufshcd_wb_probe(hba, desc_buf);
>   
> +	ufshcd_temp_notif_probe(hba, desc_buf);
> +
>   	/*
>   	 * ufshcd_read_string_desc returns size of the string
>   	 * reset the error value
> @@ -9408,6 +9435,7 @@ void ufshcd_remove(struct ufs_hba *hba)
>   {
>   	if (hba->sdev_ufs_device)
>   		ufshcd_rpm_get_sync(hba);
> +	ufs_hwmon_remove(hba);
>   	ufs_bsg_remove(hba);
>   	ufshpb_remove(hba);
>   	ufs_sysfs_remove_nodes(hba->dev);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 4723f27a55d1..798a408d71e5 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -653,6 +653,12 @@ enum ufshcd_caps {
>   	 * in order to exit DeepSleep state.
>   	 */
>   	UFSHCD_CAP_DEEPSLEEP				= 1 << 10,
> +
> +	/*
> +	 * This capability allows the host controller driver to use temperature
> +	 * notification if it is supported by the UFS device.
> +	 */
> +	UFSHCD_CAP_TEMP_NOTIF				= 1 << 11,
>   };
>   
>   struct ufs_hba_variant_params {
> @@ -789,6 +795,10 @@ struct ufs_hba {
>   	struct scsi_device *sdev_ufs_device;
>   	struct scsi_device *sdev_rpmb;
>   
> +#ifdef CONFIG_SCSI_UFS_HWMON
> +	struct device *hwmon_device;
> +#endif
> +
>   	enum ufs_dev_pwr_mode curr_dev_pwr_mode;
>   	enum uic_link_state uic_link_state;
>   	/* Desired UFS power management level during runtime PM */
> @@ -1050,6 +1060,14 @@ static inline u8 ufshcd_wb_get_query_index(struct ufs_hba *hba)
>   	return 0;
>   }
>   
> +#ifdef CONFIG_SCSI_UFS_HWMON
> +void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask);
> +void ufs_hwmon_remove(struct ufs_hba *hba);
> +#else
> +static inline void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask) {}
> +static inline void ufs_hwmon_remove(struct ufs_hba *hba) {}
> +#endif
> +
>   #ifdef CONFIG_PM
>   extern int ufshcd_runtime_suspend(struct device *dev);
>   extern int ufshcd_runtime_resume(struct device *dev);
> 


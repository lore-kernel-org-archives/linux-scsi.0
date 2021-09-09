Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ADF1C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 16:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14DC461179
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 16:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238926AbhIIQw7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Sep 2021 12:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237092AbhIIQw5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Sep 2021 12:52:57 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBB3C061575;
        Thu,  9 Sep 2021 09:51:48 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id l7-20020a0568302b0700b0051c0181deebso3281134otv.12;
        Thu, 09 Sep 2021 09:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xwF2084JMJTFYgmNtqV3BOiSB2hh/XFpb4dQEXs2kgM=;
        b=lRshhfpPX+z/S3cXSWtiA3YiWy/sKoi/wmJS6NfOyOwzGWcf6mMx7GT+QHo6drXQ4z
         g/0MjFwkson4HPomqMW2NmBxKyLt+8cHaYX23gfx6tiphJormwn2hzYmNIR+j2dTjNwj
         ukMI7DorK6oq9LqkQVqokOn1o+6mLw/foqfknwg7fdowBjUtjH95p/w4prxQWsgofoam
         hFFVhY0uSMjU49Y1GY82Vn80WPbJopAPnZvEP+GY1Jdw0999k2VRyL2ZGTPsQaA06iQn
         Pt4PbCH8LRu5iRuUGxYJg4QjTkjKjqDS4l/fv9ZZ8Mfy9wCeV/j64pfeIRoV3JcpnWOc
         Jkuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=xwF2084JMJTFYgmNtqV3BOiSB2hh/XFpb4dQEXs2kgM=;
        b=f/SJ1yX81VY7byTEQyaN7Yaa7LXeLW+9bBo8W5Yi8njaJSBrNwc9FjK/7bL/e3PNK0
         +158Yqf8V3QoQ3f1+oMK14rZ7ODJ4T7tK/c6X80rv/sMjCL8BPYVoSissEdMl3akhL+T
         JDAQy2Zew4XF0fVxyYgJYlAntA9J6+l7KHa+OERP0HYT3FbtHW/Pl8b44BE77ZCE5MFh
         mUZm0b8VL8NPXMNJVefRKcfCiEiopo+0zu8OlQArVwJN7FCmiqdYStiHrTWSWNoaggJw
         mW3ZgcAFaYwiCMgytezgV53Rg9w0kUBBZ4EniL6H/kHLso0l2PWV6n6HPI3LrM8b97ow
         m3iQ==
X-Gm-Message-State: AOAM533tX18Dxu6tOsaMcKDrEbhqEkeMmhOVP5fw/7oDeAppx8MowebN
        N3Xp1Q2ZlludPcW4aq06tV75Mgj4lVo=
X-Google-Smtp-Source: ABdhPJzQdVZkYuk1Ed2fuUW1slK/maeKdS74gns9i8xGYx6iqrvgoSw5BITRUKIA7yeu0czYVy4IsA==
X-Received: by 2002:a05:6830:70b:: with SMTP id y11mr683963ots.281.1631206307531;
        Thu, 09 Sep 2021 09:51:47 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v24sm550004ote.66.2021.09.09.09.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 09:51:46 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 9 Sep 2021 09:51:45 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Avri Altman <avri.altman@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Probe for temperature notification
 support
Message-ID: <20210909165145.GA3973437@roeck-us.net>
References: <20210909063444.22407-1-avri.altman@wdc.com>
 <20210909063444.22407-2-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909063444.22407-2-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 09, 2021 at 09:34:43AM +0300, Avri Altman wrote:
> Probe the dExtendedUFSFeaturesSupport register for the device's
> temperature notification support, and if supported, add a hw monitor
> device.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/scsi/ufs/Kconfig     |  10 ++
>  drivers/scsi/ufs/Makefile    |   1 +
>  drivers/scsi/ufs/ufs-hwmon.c | 180 +++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufs.h       |   6 ++
>  drivers/scsi/ufs/ufshcd.c    |  27 ++++++
>  drivers/scsi/ufs/ufshcd.h    |  18 ++++
>  6 files changed, 242 insertions(+)
>  create mode 100644 drivers/scsi/ufs/ufs-hwmon.c
> 
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index 432df76e6318..b930f29fc375 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -199,3 +199,13 @@ config SCSI_UFS_FAULT_INJECTION
>  	help
>  	  Enable fault injection support in the UFS driver. This makes it easier
>  	  to test the UFS error handler and abort handler.
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
> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> index c407da9b5171..966048875b50 100644
> --- a/drivers/scsi/ufs/Makefile
> +++ b/drivers/scsi/ufs/Makefile
> @@ -10,6 +10,7 @@ ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
>  ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO)	+= ufshcd-crypto.o
>  ufshcd-core-$(CONFIG_SCSI_UFS_HPB)	+= ufshpb.o
>  ufshcd-core-$(CONFIG_SCSI_UFS_FAULT_INJECTION) += ufs-fault-injection.o
> +ufshcd-core-$(CONFIG_SCSI_UFS_HWMON) += ufs-hwmon.o
>  
>  obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.o
>  obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
> diff --git a/drivers/scsi/ufs/ufs-hwmon.c b/drivers/scsi/ufs/ufs-hwmon.c
> new file mode 100644
> index 000000000000..159678ce89ce
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs-hwmon.c
> @@ -0,0 +1,180 @@
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
> +static bool ufs_temp_enabled(struct ufs_hba *hba, struct ufs_hwmon_data *data)
> +{
> +	u32 ee_mask;
> +
> +	if (ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +			      QUERY_ATTR_IDN_EE_CONTROL, 0, 0, &ee_mask))
> +		return false;
> +
> +	return (data->mask & ee_mask & MASK_EE_TOO_HIGH_TEMP) ||
> +		(data->mask & ee_mask & MASK_EE_TOO_LOW_TEMP);
> +}
> +
> +static bool ufs_temp_valid(struct ufs_hba *hba, struct ufs_hwmon_data *data,
> +			   enum attr_idn idn, u32 value)
> +{
> +	return (idn == QUERY_ATTR_IDN_CASE_ROUGH_TEMP && value >= 1 &&
> +		value <= 250 && ufs_temp_enabled(hba, data)) ||
> +	      (idn == QUERY_ATTR_IDN_HIGH_TEMP_BOUND && value >= 100 &&
> +	       value <= 250) ||
> +	      (idn == QUERY_ATTR_IDN_LOW_TEMP_BOUND && value >= 1 &&
> +	       value <= 80);
> +}
> +
> +static int ufs_get_temp(struct ufs_hba *hba, struct ufs_hwmon_data *data,
> +			enum attr_idn idn)
> +{
> +	u32 value;
> +
> +	if (ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR, idn, 0, 0,
> +	    &value))
> +		return 0;
> +
> +	if (ufs_temp_valid(hba, data, idn, value))
> +		return value - 80;
> +
> +	return 0;
> +}
> +
> +static int ufs_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
> +			   u32 attr, int channel, long *val)
> +{
> +	struct ufs_hwmon_data *data = dev_get_drvdata(dev);
> +	struct ufs_hba *hba = data->hba;
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
> +		*val = ufs_temp_enabled(hba, data);
> +		get_temp = false;
> +
> +		break;
> +	case hwmon_temp_max_alarm:
> +		*val = ufs_get_temp(hba, data, QUERY_ATTR_IDN_HIGH_TEMP_BOUND);
> +
> +		break;
> +	case hwmon_temp_min_alarm:
> +		*val = ufs_get_temp(hba, data, QUERY_ATTR_IDN_LOW_TEMP_BOUND);
> +
> +		break;
> +	case hwmon_temp_input:
> +		*val = ufs_get_temp(hba, data, QUERY_ATTR_IDN_CASE_ROUGH_TEMP);
> +
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
> +int ufs_hwmon_probe(struct ufs_hba *hba, u8 mask)
> +{
> +	struct device *dev = hba->dev;
> +	struct ufs_hwmon_data *data;
> +	struct device *hwmon;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return 0;
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
> +		return PTR_ERR(hwmon);

If the error is ignored by the caller, it doesn't make sense
to return it.

> +	}
> +
> +	hba->hwmon_device = hwmon;
> +
> +	return 0;
> +}
> +
> +void ufs_hwmon_remove(struct ufs_hba *hba)
> +{
> +	if (hba->hwmon_device) {
> +		struct ufs_hwmon_data *data =
> +			dev_get_drvdata(hba->hwmon_device);
> +
> +		hwmon_device_unregister(hba->hwmon_device);
> +		hba->hwmon_device = NULL;
> +		kfree(data);
> +	}
> +}

That function is never called and thus pointless (suggesting that there may be 
some structural problem in the code).

> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index 8c6b38b1b142..171b27be7b1d 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -152,6 +152,9 @@ enum attr_idn {
>  	QUERY_ATTR_IDN_PSA_STATE		= 0x15,
>  	QUERY_ATTR_IDN_PSA_DATA_SIZE		= 0x16,
>  	QUERY_ATTR_IDN_REF_CLK_GATING_WAIT_TIME	= 0x17,
> +	QUERY_ATTR_IDN_CASE_ROUGH_TEMP          = 0x18,
> +	QUERY_ATTR_IDN_HIGH_TEMP_BOUND          = 0x19,
> +	QUERY_ATTR_IDN_LOW_TEMP_BOUND           = 0x1A,
>  	QUERY_ATTR_IDN_WB_FLUSH_STATUS	        = 0x1C,
>  	QUERY_ATTR_IDN_AVAIL_WB_BUFF_SIZE       = 0x1D,
>  	QUERY_ATTR_IDN_WB_BUFF_LIFE_TIME_EST    = 0x1E,
> @@ -338,6 +341,9 @@ enum {
>  
>  /* Possible values for dExtendedUFSFeaturesSupport */
>  enum {
> +	UFS_DEV_LOW_TEMP_NOTIF		= BIT(4),
> +	UFS_DEV_HIGH_TEMP_NOTIF		= BIT(5),
> +	UFS_DEV_EXT_TEMP_NOTIF		= BIT(6),
>  	UFS_DEV_HPB_SUPPORT		= BIT(7),
>  	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),
>  };
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 3841ab49f556..fc995bf1f296 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7469,6 +7469,31 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
>  	hba->caps &= ~UFSHCD_CAP_WB_EN;
>  }
>  
> +static void ufshcd_temp_notif_probe(struct ufs_hba *hba, u8 *desc_buf)
> +{
> +	struct ufs_dev_info *dev_info = &hba->dev_info;
> +	u32 ext_ufs_feature;
> +	u8 mask = 0;
> +
> +	if (!(hba->caps & UFSHCD_CAP_TEMP_NOTIF) ||
> +	    dev_info->wspecversion < 0x300)
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
>  void ufshcd_fixup_dev_quirks(struct ufs_hba *hba, struct ufs_dev_fix *fixups)
>  {
>  	struct ufs_dev_fix *f;
> @@ -7564,6 +7589,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
>  
>  	ufshcd_wb_probe(hba, desc_buf);
>  
> +	ufshcd_temp_notif_probe(hba, desc_buf);
> +

Is that the appropriate place to make this call ?

>  	/*
>  	 * ufshcd_read_string_desc returns size of the string
>  	 * reset the error value
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 52ea6f350b18..9bc434c4ae71 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -653,6 +653,12 @@ enum ufshcd_caps {
>  	 * in order to exit DeepSleep state.
>  	 */
>  	UFSHCD_CAP_DEEPSLEEP				= 1 << 10,
> +
> +	/*
> +	 * This capability allows the host controller driver to use temperature
> +	 * notification if it is supported by the UFS device.
> +	 */
> +	UFSHCD_CAP_TEMP_NOTIF				= 1 << 11,
>  };
>  
>  struct ufs_hba_variant_params {
> @@ -789,6 +795,10 @@ struct ufs_hba {
>  	struct scsi_device *sdev_ufs_device;
>  	struct scsi_device *sdev_rpmb;
>  
> +#ifdef CONFIG_SCSI_UFS_HWMON
> +	struct device *hwmon_device;
> +#endif
> +
>  	enum ufs_dev_pwr_mode curr_dev_pwr_mode;
>  	enum uic_link_state uic_link_state;
>  	/* Desired UFS power management level during runtime PM */
> @@ -1049,6 +1059,14 @@ static inline u8 ufshcd_wb_get_query_index(struct ufs_hba *hba)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_SCSI_UFS_HWMON
> +int ufs_hwmon_probe(struct ufs_hba *hba, u8 mask);
> +void ufs_hwmon_remove(struct ufs_hba *hba);
> +#else
> +static inline int ufs_hwmon_probe(struct ufs_hba *hba, u8 mask) { return 0; }
> +static inline void nvme_hwmon_remove(struct ufs_hba *hba) {}

ufs_hwmon_remove

> +#endif
> +
>  #ifdef CONFIG_PM
>  extern int ufshcd_runtime_suspend(struct device *dev);
>  extern int ufshcd_runtime_resume(struct device *dev);
> -- 
> 2.17.1
> 

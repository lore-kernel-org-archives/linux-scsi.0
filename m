Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBCAEC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 07:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C391A61185
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 07:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236514AbhIOHGu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 03:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236469AbhIOHGt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Sep 2021 03:06:49 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA22C061574;
        Wed, 15 Sep 2021 00:05:31 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id w19so2901450oik.10;
        Wed, 15 Sep 2021 00:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EZwswX+J7vLVimILrhAmOyjyP15BryubCpQLOP51mFI=;
        b=Kw3ME9FF54jXgHWBS2k6PDrTSL4tu3XOZVygz4aog1Iaq9GU+D1EdjT4vZ5PnZyH82
         7mGcn+HUrgWPTCR6b/B+7XU2K3Q/zx8STG0of0B/7bA+CpH8oEKcGIccmuognaqHko0O
         INh2Y9hCq1ixKsMyDRhErWMSk7V9BC0+g2dRcVls/TgRX29vEVCsilQLozcRZDEoJ4Od
         20kaMifO4o/u4c4EwcVT2upiBhS6/VHZS0WvFVbwjmnds/rS+zSdQFZUaJNJtY3lYXfo
         /dua7NsMeqKXdcE7SjCFLyZMuwdRIAMwL27FoghYQ+9XwuYy9CrXITx6qFe1IfGF9Ea7
         xuyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=EZwswX+J7vLVimILrhAmOyjyP15BryubCpQLOP51mFI=;
        b=pwm7r2WQJoonS6QczyxOW5h1NvZ5danyQzOe9Q8iFQvWwe7MdNEcAM5HN83JtTPPYK
         /ts9EQkSk9CajlvVdIcSYnV9ZLa/RfEh1/wU/Qff9fwjE0oYYhdHT93Vi9MKr9HO6e9O
         fpf67dW2OuMqJuxglXzRt78WX1BCHGAZXejiT8ZpEjFv0TnfvX9HznlqC39kgDLMXsbG
         n81Ij0ChGlnZtxK4bUmdv+cy824ME+3C5V61k3tassClhD/IZkHR8szcz/NdifAbEd0V
         PwdAccAsiEpyOjzetdAYy5Mp0KJ3gN1n5cKXvgesiktW8swge+zr2ygZGKE/r3CtzrGh
         iqGw==
X-Gm-Message-State: AOAM5338JS91Cnu4zirTzBH73d9G/TJsESGSPZtyjyTpTNmkBqJstCua
        TTNJB4jwEsuLzzQ9Ba8j0Sg=
X-Google-Smtp-Source: ABdhPJz7X6MusN1FJ3pI6so7XXwdKnlWXF11EjEBN0klL3eGgP/19u5WYZvdY6sovNLzhmdasRJbNA==
X-Received: by 2002:a05:6808:b21:: with SMTP id t1mr4202527oij.165.1631689530569;
        Wed, 15 Sep 2021 00:05:30 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a6sm3112059oto.36.2021.09.15.00.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 00:05:29 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 15 Sep 2021 00:05:28 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Avri Altman <avri.altman@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH v7 1/2] scsi: ufs: Probe for temperature notification
 support
Message-ID: <20210915070528.GA4174921@roeck-us.net>
References: <20210915060407.40-1-avri.altman@wdc.com>
 <20210915060407.40-2-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915060407.40-2-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 15, 2021 at 09:04:06AM +0300, Avri Altman wrote:
> Probe the dExtendedUFSFeaturesSupport register for the device's
> temperature notification support, and if supported, add a hw monitor
> device.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/scsi/ufs/Kconfig     |   9 ++
>  drivers/scsi/ufs/Makefile    |   1 +
>  drivers/scsi/ufs/ufs-hwmon.c | 198 +++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufs.h       |   7 ++
>  drivers/scsi/ufs/ufshcd.c    |  26 +++++
>  drivers/scsi/ufs/ufshcd.h    |  18 ++++
>  6 files changed, 259 insertions(+)
>  create mode 100644 drivers/scsi/ufs/ufs-hwmon.c
> 
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index 432df76e6318..565e8aa6319d 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -199,3 +199,12 @@ config SCSI_UFS_FAULT_INJECTION
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
> index 000000000000..33b66736aaa4
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs-hwmon.c
> @@ -0,0 +1,198 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * UFS hardware monitoring support
> + * Copyright (c) 2021, Western Digital Corporation
> + */
> +
> +#include <linux/hwmon.h>
> +#include <linux/units.h>
> +
> +#include "ufshcd.h"
> +
> +struct ufs_hwmon_data {
> +	struct ufs_hba *hba;
> +	u8 mask;
> +};
> +
> +static int ufs_read_temp_enable(struct ufs_hba *hba, u8 mask, long *val)
> +{
> +	u32 ee_mask;
> +	int err;
> +
> +	err = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR, QUERY_ATTR_IDN_EE_CONTROL, 0, 0,
> +				&ee_mask);
> +	if (err)
> +		return err;
> +
> +	*val = (mask & ee_mask & MASK_EE_TOO_HIGH_TEMP) || (mask & ee_mask & MASK_EE_TOO_LOW_TEMP);
> +
> +	return 0;
> +}
> +
> +static int ufs_get_temp(struct ufs_hba *hba, enum attr_idn idn, long *val)
> +{
> +	u32 value;
> +	int err;
> +
> +	err = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR, idn, 0, 0, &value);
> +	if (err)
> +		return err;
> +
> +	if (value == 0)
> +		return -ENODATA;
> +
> +	*val = ((long)value - 80) * MILLIDEGREE_PER_DEGREE;
> +
> +	return 0;
> +}
> +
> +static int ufs_hwmon_read(struct device *dev, enum hwmon_sensor_types type, u32 attr, int channel,
> +			  long *val)
> +{
> +	struct ufs_hwmon_data *data = dev_get_drvdata(dev);
> +	struct ufs_hba *hba = data->hba;
> +	int err;
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
> +		err = ufs_read_temp_enable(hba, data->mask, val);
> +
> +		break;
> +	case hwmon_temp_crit:
> +		err = ufs_get_temp(hba, QUERY_ATTR_IDN_HIGH_TEMP_BOUND, val);
> +
> +		break;
> +	case hwmon_temp_lcrit:
> +		err = ufs_get_temp(hba, QUERY_ATTR_IDN_LOW_TEMP_BOUND, val);
> +
> +		break;
> +	case hwmon_temp_input:
> +		err = ufs_get_temp(hba, QUERY_ATTR_IDN_CASE_ROUGH_TEMP, val);
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
> +	return err;
> +}
> +
> +static int ufs_hwmon_write(struct device *dev, enum hwmon_sensor_types type, u32 attr, int channel,
> +			   long val)
> +{
> +	struct ufs_hwmon_data *data = dev_get_drvdata(dev);
> +	struct ufs_hba *hba = data->hba;
> +	int err;
> +
> +	if (attr != hwmon_temp_enable)
> +		return -EINVAL;
> +
> +	if (val != 0 && val != 1)
> +		return -EINVAL;
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
> +	if (val == 1)
> +		err = ufshcd_update_ee_usr_mask(hba, MASK_EE_URGENT_TEMP, 0);
> +	else
> +		err = ufshcd_update_ee_usr_mask(hba, 0, MASK_EE_URGENT_TEMP);
> +
> +	ufshcd_rpm_put_sync(hba);
> +
> +	up(&hba->host_sem);
> +
> +	return err;
> +}
> +
> +static umode_t ufs_hwmon_is_visible(const void *_data, enum hwmon_sensor_types type, u32 attr,
> +				    int channel)
> +{
> +	if (type != hwmon_temp)
> +		return 0;
> +
> +	switch (attr) {
> +	case hwmon_temp_enable:
> +		return 0644;
> +	case hwmon_temp_crit:
> +	case hwmon_temp_lcrit:
> +	case hwmon_temp_input:
> +		return 0444;
> +	default:
> +		break;
> +	}
> +	return 0;
> +}
> +
> +static const struct hwmon_channel_info *ufs_hwmon_info[] = {
> +	HWMON_CHANNEL_INFO(temp, HWMON_T_ENABLE | HWMON_T_INPUT | HWMON_T_CRIT | HWMON_T_LCRIT),
> +	NULL
> +};
> +
> +static const struct hwmon_ops ufs_hwmon_ops = {
> +	.is_visible	= ufs_hwmon_is_visible,
> +	.read		= ufs_hwmon_read,
> +	.write		= ufs_hwmon_write,
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
> +	hwmon = hwmon_device_register_with_info(dev, "ufs", data, &ufs_hwmon_hba_info, NULL);
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
> index 8c6b38b1b142..0bfdca3e648e 100644
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
> @@ -370,6 +376,7 @@ enum {
>  	MASK_EE_WRITEBOOSTER_EVENT	= BIT(5),
>  	MASK_EE_PERFORMANCE_THROTTLING	= BIT(6),
>  };
> +#define MASK_EE_URGENT_TEMP (MASK_EE_TOO_HIGH_TEMP | MASK_EE_TOO_LOW_TEMP)
>  
>  /* Background operation status */
>  enum bkops_status {
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 3841ab49f556..ce22340024ce 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7469,6 +7469,29 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
>  	hba->caps &= ~UFSHCD_CAP_WB_EN;
>  }
>  
> +static void ufshcd_temp_notif_probe(struct ufs_hba *hba, u8 *desc_buf)
> +{
> +	struct ufs_dev_info *dev_info = &hba->dev_info;
> +	u32 ext_ufs_feature;
> +	u8 mask = 0;
> +
> +	if (!(hba->caps & UFSHCD_CAP_TEMP_NOTIF) || dev_info->wspecversion < 0x300)
> +		return;
> +
> +	ext_ufs_feature = get_unaligned_be32(desc_buf + DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP);
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
> @@ -7564,6 +7587,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
>  
>  	ufshcd_wb_probe(hba, desc_buf);
>  
> +	ufshcd_temp_notif_probe(hba, desc_buf);
> +
>  	/*
>  	 * ufshcd_read_string_desc returns size of the string
>  	 * reset the error value
> @@ -9408,6 +9433,7 @@ void ufshcd_remove(struct ufs_hba *hba)
>  {
>  	if (hba->sdev_ufs_device)
>  		ufshcd_rpm_get_sync(hba);
> +	ufs_hwmon_remove(hba);
>  	ufs_bsg_remove(hba);
>  	ufshpb_remove(hba);
>  	ufs_sysfs_remove_nodes(hba->dev);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 52ea6f350b18..021c858955af 100644
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
> +void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask);
> +void ufs_hwmon_remove(struct ufs_hba *hba);
> +#else
> +static inline void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask) {}
> +static inline void ufs_hwmon_remove(struct ufs_hba *hba) {}
> +#endif
> +
>  #ifdef CONFIG_PM
>  extern int ufshcd_runtime_suspend(struct device *dev);
>  extern int ufshcd_runtime_resume(struct device *dev);
> -- 
> 2.17.1
> 

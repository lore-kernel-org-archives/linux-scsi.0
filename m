Return-Path: <SRS0=199q=EK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04401C388F7
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 08:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9657720782
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 08:30:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="PGq0jase"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgKDIaP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 03:30:15 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:47551 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbgKDIaN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Nov 2020 03:30:13 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604478611; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=I/+u+IhpIIiHTW1EzeEf3IU7VsI4JPT1igN9dqtQNZw=;
 b=PGq0jase1hSSTDfL3UUwbLdP6WEK67e2U25OIRejdcHU1vt6SU+hsfL9WSo3WssN1WaK9LGx
 AwpKnyCaceIPaUkcFr2b8Lw1byGryJIzD2qUz0UAFJGXulNpsje1pgRR1CzRv4wpJ2Cb706O
 MihbyGC4zkpMQepD2zloLb/cRfM=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5fa2666b978460d05b581227 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 04 Nov 2020 08:29:31
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 89993C433FF; Wed,  4 Nov 2020 08:29:31 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 890CFC433C9;
        Wed,  4 Nov 2020 08:29:29 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 04 Nov 2020 16:29:29 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: [PATCH V4 1/2] scsi: ufs: Add DeepSleep feature
In-Reply-To: <20201103141403.2142-2-adrian.hunter@intel.com>
References: <20201103141403.2142-1-adrian.hunter@intel.com>
 <20201103141403.2142-2-adrian.hunter@intel.com>
Message-ID: <5331559186b4ecf5e5ffc1bf1d28c6b3@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Adrian,

On 2020-11-03 22:14, Adrian Hunter wrote:
> DeepSleep is a UFS v3.1 feature that achieves the lowest power 
> consumption
> of the device, apart from power off.
> 
> In DeepSleep mode, no commands are accepted, and the only way to exit 
> is
> using a hardware reset or power cycle.
> 
> This patch assumes that if a power cycle was an option, then power off
> would be preferable, so only exit via a hardware reset is supported.
> 
> Drivers that wish to support DeepSleep need to set a new capability 
> flag
> UFSHCD_CAP_DEEPSLEEP and provide a hardware reset via the existing
>  ->device_reset() callback.
> 
> It is assumed that UFS devices with wspecversion >= 0x310 support
> DeepSleep.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-driver-ufs | 34 +++++++++++--------
>  drivers/scsi/ufs/ufs-sysfs.c               |  7 ++++
>  drivers/scsi/ufs/ufs.h                     |  1 +
>  drivers/scsi/ufs/ufshcd.c                  | 39 ++++++++++++++++++++--
>  drivers/scsi/ufs/ufshcd.h                  | 17 +++++++++-
>  include/trace/events/ufs.h                 |  3 +-
>  6 files changed, 83 insertions(+), 18 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs
> b/Documentation/ABI/testing/sysfs-driver-ufs
> index adc0d0e91607..e77fa784d6d8 100644
> --- a/Documentation/ABI/testing/sysfs-driver-ufs
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> @@ -916,21 +916,24 @@ Date:		September 2014
>  Contact:	Subhash Jadavani <subhashj@codeaurora.org>
>  Description:	This entry could be used to set or show the UFS device
>  		runtime power management level. The current driver
> -		implementation supports 6 levels with next target states:
> +		implementation supports 7 levels with next target states:
> 
>  		==  ====================================================
> -		0   an UFS device will stay active, an UIC link will
> +		0   UFS device will stay active, UIC link will
>  		    stay active
> -		1   an UFS device will stay active, an UIC link will
> +		1   UFS device will stay active, UIC link will
>  		    hibernate
> -		2   an UFS device will moved to sleep, an UIC link will
> +		2   UFS device will be moved to sleep, UIC link will
>  		    stay active
> -		3   an UFS device will moved to sleep, an UIC link will
> +		3   UFS device will be moved to sleep, UIC link will
>  		    hibernate
> -		4   an UFS device will be powered off, an UIC link will
> +		4   UFS device will be powered off, UIC link will
>  		    hibernate
> -		5   an UFS device will be powered off, an UIC link will
> +		5   UFS device will be powered off, UIC link will
>  		    be powered off
> +		6   UFS device will be moved to deep sleep, UIC link
> +		will be powered off. Note, deep sleep might not be
> +		supported in which case this value will not be accepted

Nitpicking, usually higher spm/rpm_lvl means better power saving.
Since POWERDOWN+LINKOFF achieves the lowest power consumption, can
we put DEEPSLEEP_LINKOFF to 5, and POWERDOWN_LINKOFF to 6?

Thanks,

Can Guo.

>  		==  ====================================================
> 
>  What:		/sys/bus/platform/drivers/ufshcd/*/rpm_target_dev_state
> @@ -954,21 +957,24 @@ Date:		September 2014
>  Contact:	Subhash Jadavani <subhashj@codeaurora.org>
>  Description:	This entry could be used to set or show the UFS device
>  		system power management level. The current driver
> -		implementation supports 6 levels with next target states:
> +		implementation supports 7 levels with next target states:
> 
>  		==  ====================================================
> -		0   an UFS device will stay active, an UIC link will
> +		0   UFS device will stay active, UIC link will
>  		    stay active
> -		1   an UFS device will stay active, an UIC link will
> +		1   UFS device will stay active, UIC link will
>  		    hibernate
> -		2   an UFS device will moved to sleep, an UIC link will
> +		2   UFS device will be moved to sleep, UIC link will
>  		    stay active
> -		3   an UFS device will moved to sleep, an UIC link will
> +		3   UFS device will be moved to sleep, UIC link will
>  		    hibernate
> -		4   an UFS device will be powered off, an UIC link will
> +		4   UFS device will be powered off, UIC link will
>  		    hibernate
> -		5   an UFS device will be powered off, an UIC link will
> +		5   UFS device will be powered off, UIC link will
>  		    be powered off
> +		6   UFS device will be moved to deep sleep, UIC link
> +		will be powered off. Note, deep sleep might not be
> +		supported in which case this value will not be accepted
>  		==  ====================================================
> 
>  What:		/sys/bus/platform/drivers/ufshcd/*/spm_target_dev_state
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c 
> b/drivers/scsi/ufs/ufs-sysfs.c
> index bdcd27faa054..08e72b7eef6a 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -28,6 +28,7 @@ static const char *ufschd_ufs_dev_pwr_mode_to_string(
>  	case UFS_ACTIVE_PWR_MODE:	return "ACTIVE";
>  	case UFS_SLEEP_PWR_MODE:	return "SLEEP";
>  	case UFS_POWERDOWN_PWR_MODE:	return "POWERDOWN";
> +	case UFS_DEEPSLEEP_PWR_MODE:	return "DEEPSLEEP";
>  	default:			return "UNKNOWN";
>  	}
>  }
> @@ -38,6 +39,7 @@ static inline ssize_t ufs_sysfs_pm_lvl_store(struct
> device *dev,
>  					     bool rpm)
>  {
>  	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	struct ufs_dev_info *dev_info = &hba->dev_info;
>  	unsigned long flags, value;
> 
>  	if (kstrtoul(buf, 0, &value))
> @@ -46,6 +48,11 @@ static inline ssize_t ufs_sysfs_pm_lvl_store(struct
> device *dev,
>  	if (value >= UFS_PM_LVL_MAX)
>  		return -EINVAL;
> 
> +	if (ufs_pm_lvl_states[value].dev_state == UFS_DEEPSLEEP_PWR_MODE &&
> +	    (!(hba->caps & UFSHCD_CAP_DEEPSLEEP) ||
> +	     !(dev_info->wspecversion >= 0x310)))
> +		return -EINVAL;
> +
>  	spin_lock_irqsave(hba->host->host_lock, flags);
>  	if (rpm)
>  		hba->rpm_lvl = value;
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index f8ab16f30fdc..d593edb48767 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -442,6 +442,7 @@ enum ufs_dev_pwr_mode {
>  	UFS_ACTIVE_PWR_MODE	= 1,
>  	UFS_SLEEP_PWR_MODE	= 2,
>  	UFS_POWERDOWN_PWR_MODE	= 3,
> +	UFS_DEEPSLEEP_PWR_MODE	= 4,
>  };
> 
>  #define UFS_WB_BUF_REMAIN_PERCENT(val) ((val) / 10)
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 2309253d3101..ee083b96e405 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -163,6 +163,11 @@ struct ufs_pm_lvl_states ufs_pm_lvl_states[] = {
>  	{UFS_SLEEP_PWR_MODE, UIC_LINK_HIBERN8_STATE},
>  	{UFS_POWERDOWN_PWR_MODE, UIC_LINK_HIBERN8_STATE},
>  	{UFS_POWERDOWN_PWR_MODE, UIC_LINK_OFF_STATE},
> +	/*
> +	 * For DeepSleep, the link is first put in hibern8 and then off.
> +	 * Leaving the link in hibern8 is not supported.
> +	 */
> +	{UFS_DEEPSLEEP_PWR_MODE, UIC_LINK_OFF_STATE},
>  };
> 
>  static inline enum ufs_dev_pwr_mode
> @@ -8297,7 +8302,8 @@ static int ufshcd_link_state_transition(struct
> ufs_hba *hba,
>  	}
>  	/*
>  	 * If autobkops is enabled, link can't be turned off because
> -	 * turning off the link would also turn off the device.
> +	 * turning off the link would also turn off the device, except in the
> +	 * case of DeepSleep where the device is expected to remain powered.
>  	 */
>  	else if ((req_link_state == UIC_LINK_OFF_STATE) &&
>  		 (!check_for_bkops || !hba->auto_bkops_enabled)) {
> @@ -8307,6 +8313,9 @@ static int ufshcd_link_state_transition(struct
> ufs_hba *hba,
>  		 * put the link in low power mode is to send the DME end point
>  		 * to device and then send the DME reset command to local
>  		 * unipro. But putting the link in hibern8 is much faster.
> +		 *
> +		 * Note also that putting the link in Hibern8 is a requirement
> +		 * for entering DeepSleep.
>  		 */
>  		ret = ufshcd_uic_hibern8_enter(hba);
>  		if (ret) {
> @@ -8439,6 +8448,7 @@ static void ufshcd_hba_vreg_set_hpm(struct 
> ufs_hba *hba)
>  static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  {
>  	int ret = 0;
> +	int check_for_bkops;
>  	enum ufs_pm_level pm_lvl;
>  	enum ufs_dev_pwr_mode req_dev_pwr_mode;
>  	enum uic_link_state req_link_state;
> @@ -8524,7 +8534,13 @@ static int ufshcd_suspend(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  	}
> 
>  	flush_work(&hba->eeh_work);
> -	ret = ufshcd_link_state_transition(hba, req_link_state, 1);
> +
> +	/*
> +	 * In the case of DeepSleep, the device is expected to remain powered
> +	 * with the link off, so do not check for bkops.
> +	 */
> +	check_for_bkops = !ufshcd_is_ufs_dev_deepsleep(hba);
> +	ret = ufshcd_link_state_transition(hba, req_link_state, 
> check_for_bkops);
>  	if (ret)
>  		goto set_dev_active;
> 
> @@ -8565,11 +8581,25 @@ static int ufshcd_suspend(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  	if (hba->clk_scaling.is_allowed)
>  		ufshcd_resume_clkscaling(hba);
>  	ufshcd_vreg_set_hpm(hba);
> +	/*
> +	 * Device hardware reset is required to exit DeepSleep. Also, for
> +	 * DeepSleep, the link is off so host reset and restore will be done
> +	 * further below.
> +	 */
> +	if (ufshcd_is_ufs_dev_deepsleep(hba)) {
> +		ufshcd_vops_device_reset(hba);
> +		WARN_ON(!ufshcd_is_link_off(hba));
> +	}
>  	if (ufshcd_is_link_hibern8(hba) && !ufshcd_uic_hibern8_exit(hba))
>  		ufshcd_set_link_active(hba);
>  	else if (ufshcd_is_link_off(hba))
>  		ufshcd_host_reset_and_restore(hba);
>  set_dev_active:
> +	/* Can also get here needing to exit DeepSleep */
> +	if (ufshcd_is_ufs_dev_deepsleep(hba)) {
> +		ufshcd_vops_device_reset(hba);
> +		ufshcd_host_reset_and_restore(hba);
> +	}
>  	if (!ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE))
>  		ufshcd_disable_auto_bkops(hba);
>  enable_gating:
> @@ -8631,6 +8661,9 @@ static int ufshcd_resume(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  	if (ret)
>  		goto disable_vreg;
> 
> +	/* For DeepSleep, the only supported option is to have the link off 
> */
> +	WARN_ON(ufshcd_is_ufs_dev_deepsleep(hba) && 
> !ufshcd_is_link_off(hba));
> +
>  	if (ufshcd_is_link_hibern8(hba)) {
>  		ret = ufshcd_uic_hibern8_exit(hba);
>  		if (!ret) {
> @@ -8644,6 +8677,8 @@ static int ufshcd_resume(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  		/*
>  		 * A full initialization of the host and the device is
>  		 * required since the link was put to off during suspend.
> +		 * Note, in the case of DeepSleep, the device will exit
> +		 * DeepSleep due to device reset.
>  		 */
>  		ret = ufshcd_reset_and_restore(hba);
>  		/*
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 0fbb735bb70c..213be0667b59 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -114,16 +114,22 @@ enum uic_link_state {
>  	((h)->curr_dev_pwr_mode = UFS_SLEEP_PWR_MODE)
>  #define ufshcd_set_ufs_dev_poweroff(h) \
>  	((h)->curr_dev_pwr_mode = UFS_POWERDOWN_PWR_MODE)
> +#define ufshcd_set_ufs_dev_deepsleep(h) \
> +	((h)->curr_dev_pwr_mode = UFS_DEEPSLEEP_PWR_MODE)
>  #define ufshcd_is_ufs_dev_active(h) \
>  	((h)->curr_dev_pwr_mode == UFS_ACTIVE_PWR_MODE)
>  #define ufshcd_is_ufs_dev_sleep(h) \
>  	((h)->curr_dev_pwr_mode == UFS_SLEEP_PWR_MODE)
>  #define ufshcd_is_ufs_dev_poweroff(h) \
>  	((h)->curr_dev_pwr_mode == UFS_POWERDOWN_PWR_MODE)
> +#define ufshcd_is_ufs_dev_deepsleep(h) \
> +	((h)->curr_dev_pwr_mode == UFS_DEEPSLEEP_PWR_MODE)
> 
>  /*
>   * UFS Power management levels.
> - * Each level is in increasing order of power savings.
> + * Each level is in increasing order of power savings, except 
> DeepSleep
> + * which is lower than PowerDown with power on but not PowerDown with
> + * power off.
>   */
>  enum ufs_pm_level {
>  	UFS_PM_LVL_0, /* UFS_ACTIVE_PWR_MODE, UIC_LINK_ACTIVE_STATE */
> @@ -132,6 +138,7 @@ enum ufs_pm_level {
>  	UFS_PM_LVL_3, /* UFS_SLEEP_PWR_MODE, UIC_LINK_HIBERN8_STATE */
>  	UFS_PM_LVL_4, /* UFS_POWERDOWN_PWR_MODE, UIC_LINK_HIBERN8_STATE */
>  	UFS_PM_LVL_5, /* UFS_POWERDOWN_PWR_MODE, UIC_LINK_OFF_STATE */
> +	UFS_PM_LVL_6, /* UFS_DEEPSLEEP_PWR_MODE, UIC_LINK_OFF_STATE */
>  	UFS_PM_LVL_MAX
>  };
> 
> @@ -599,6 +606,14 @@ enum ufshcd_caps {
>  	 * This would increase power savings.
>  	 */
>  	UFSHCD_CAP_AGGR_POWER_COLLAPSE			= 1 << 9,
> +
> +	/*
> +	 * This capability allows the host controller driver to use 
> DeepSleep,
> +	 * if it is supported by the UFS device. The host controller driver 
> must
> +	 * support device hardware reset via the hba->device_reset() 
> callback,
> +	 * in order to exit DeepSleep state.
> +	 */
> +	UFSHCD_CAP_DEEPSLEEP				= 1 << 10,
>  };
> 
>  struct ufs_hba_variant_params {
> diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
> index 84841b3a7ffd..2362244c2a9e 100644
> --- a/include/trace/events/ufs.h
> +++ b/include/trace/events/ufs.h
> @@ -19,7 +19,8 @@
>  #define UFS_PWR_MODES			\
>  	EM(UFS_ACTIVE_PWR_MODE)		\
>  	EM(UFS_SLEEP_PWR_MODE)		\
> -	EMe(UFS_POWERDOWN_PWR_MODE)
> +	EM(UFS_POWERDOWN_PWR_MODE)	\
> +	EMe(UFS_DEEPSLEEP_PWR_MODE)
> 
>  #define UFSCHD_CLK_GATING_STATES	\
>  	EM(CLKS_OFF)			\

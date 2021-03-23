Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89422C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 15:29:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54EB961984
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 15:29:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbhCWP27 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 11:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbhCWP2i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Mar 2021 11:28:38 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1812C061763
        for <linux-scsi@vger.kernel.org>; Tue, 23 Mar 2021 08:28:37 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id i81so15924489oif.6
        for <linux-scsi@vger.kernel.org>; Tue, 23 Mar 2021 08:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=01Q0ruAgwKc8bAW5HMlMo1t4e9rGUfQVWgyknJBWak4=;
        b=ndyIP0EF5slZHT/EPhtD9l29v93CuNkMZVCq1YivvRM6ECxcEP1W6Qc9nLpIDquJTq
         lzlGq78DbYGyEDaaRW6xAXVhSxZK5gdoDxBuMJ3oSO2c0e82uvuMiNwklJCb/6IZuKhC
         Pn+yUT4/oQ8e2Rqr84cn639o6cOXkpuy0dvI09YAAZVM+dLQNVnfphn1gRH4zY6muTkG
         YsC6/HoH4p1RiPeGgE2XDbEwZ7F4j+FzCPy9209PqxZmW6h/UVcHL7Z03fV/6UO7Q5vt
         ScnbP351X1ng5WKdWKsLs2sQg3ufQi83/o+80NqweNBlX2TZqVkH2moXLdUDSc4C2NmG
         +qdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=01Q0ruAgwKc8bAW5HMlMo1t4e9rGUfQVWgyknJBWak4=;
        b=pbKCFb6iEydwvqdbprI4ROV3J8DHuxsO4ZlpK7M7iBb6P+oLIZKr4lV2ttm8KY96wJ
         XnFsLWigm4cfp+Z0T6rB37XfoUpBHAryNDfhPZSORN9noNDU9JXSNRnJItDsFDMW8AK2
         0GCeW4DpMNwA1FVSQZpPf18Xq8b4yty4rL5pQg1I7i2hdA3XaJsVMriGJJ7/gbLTpIh0
         N6LqWPH6/LZEcbmH6ZlbIHP6R+Fbyo4AcgXVdFjSBwKViEnhdS+/IYJdVwoqjZ8G7YKZ
         MEDEwwPra8EqZHcB8mhBcPzUnUxSx4zhKyRGZhcfN4VFO3Gfar079MGf+HomL7bUPAxJ
         lyKw==
X-Gm-Message-State: AOAM533uBJa1YbeNlIsZTUMv8LyATTAQWMThyZ819qBqRh78QUsJqdPS
        P91tp9JEi4e7jwdL6pz0mKu4pg==
X-Google-Smtp-Source: ABdhPJyPSuUhTF8WRdKSbqhk3M1FQHZsj6X0tA6ZudKa6D1aTxYFFjqClxhvKGJfXUEDmJmK3wCLKQ==
X-Received: by 2002:aca:4dd3:: with SMTP id a202mr3736583oib.13.1616513317083;
        Tue, 23 Mar 2021 08:28:37 -0700 (PDT)
Received: from yoga (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id h12sm814409ote.75.2021.03.23.08.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 08:28:36 -0700 (PDT)
Date:   Tue, 23 Mar 2021 10:28:34 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Nitin Rawat <nitirawa@codeaurora.org>
Cc:     asutoshd@codeaurora.org, cang@codeaurora.org,
        stummala@codeaurora.org, vbadigan@codeaurora.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, adrian.hunter@intel.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 3/3] scsi: ufs-qcom: configure VCC voltage level in
 vendor file
Message-ID: <20210323152834.GH5254@yoga>
References: <1616363857-26760-1-git-send-email-nitirawa@codeaurora.org>
 <1616363857-26760-4-git-send-email-nitirawa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1616363857-26760-4-git-send-email-nitirawa@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun 21 Mar 16:57 CDT 2021, Nitin Rawat wrote:

> As a part of vops handler, VCC voltage is updated
> as per the ufs device probed after reading the device
> descriptor. We follow below steps to configure voltage
> level.
> 
> 1. Set the device to SLEEP state.
> 2. Disable the Vcc Regulator.
> 3. Set the vcc voltage according to the device type and reenable
>    the regulator.
> 4. Set the device mode back to ACTIVE.
> 

When we discussed this a while back this was described as a requirement
from the device specification, you only operate on objects "owned" by
ufshcd and you invoke ufshcd operations to perform the actions.

So why is this a ufs-qcom patch and not something in ufshcd?

Regards,
Bjorn

> Signed-off-by: Nitin Rawat <nitirawa@codeaurora.org>
> Signed-off-by: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 51 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index f97d7b0..ca35f5c 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -21,6 +21,17 @@
>  #define UFS_QCOM_DEFAULT_DBG_PRINT_EN	\
>  	(UFS_QCOM_DBG_PRINT_REGS_EN | UFS_QCOM_DBG_PRINT_TEST_BUS_EN)
> 
> +#define	ANDROID_BOOT_DEV_MAX	30
> +static char android_boot_dev[ANDROID_BOOT_DEV_MAX];
> +
> +/* Min and Max VCC voltage values for ufs 2.x and
> + * ufs 3.x devices
> + */
> +#define UFS_3X_VREG_VCC_MIN_UV	2540000 /* uV */
> +#define UFS_3X_VREG_VCC_MAX_UV	2700000 /* uV */
> +#define UFS_2X_VREG_VCC_MIN_UV	2950000 /* uV */
> +#define UFS_2X_VREG_VCC_MAX_UV	2960000 /* uV */
> +
>  enum {
>  	TSTBUS_UAWM,
>  	TSTBUS_UARM,
> @@ -1293,6 +1304,45 @@ static void ufs_qcom_print_hw_debug_reg_all(struct ufs_hba *hba,
>  	print_fn(hba, reg, 9, "UFS_DBG_RD_REG_TMRLUT ", priv);
>  }
> 
> +  /**
> +   * ufs_qcom_setup_vcc_regulators - Update VCC voltage
> +   * @hba: host controller instance
> +   * Update VCC voltage based on UFS device(ufs 2.x or
> +   * ufs 3.x probed)
> +   */
> +static int ufs_qcom_setup_vcc_regulators(struct ufs_hba *hba)
> +{
> +	struct ufs_dev_info *dev_info = &hba->dev_info;
> +	struct ufs_vreg *vreg = hba->vreg_info.vcc;
> +	int ret;
> +
> +	/* Put the device in sleep before lowering VCC level */
> +	ret = ufshcd_set_dev_pwr_mode(hba, UFS_SLEEP_PWR_MODE);
> +
> +	/* Switch off VCC before switching it ON at 2.5v or 2.96v */
> +	ret = ufshcd_disable_vreg(hba->dev, vreg);
> +
> +	/* add ~2ms delay before renabling VCC at lower voltage */
> +	usleep_range(2000, 2100);
> +
> +	/* set VCC min and max voltage according to ufs device type */
> +	if (dev_info->wspecversion >= 0x300) {
> +		vreg->min_uV = UFS_3X_VREG_VCC_MIN_UV;
> +		vreg->max_uV = UFS_3X_VREG_VCC_MAX_UV;
> +	}
> +
> +	else {
> +		vreg->min_uV = UFS_2X_VREG_VCC_MIN_UV;
> +		vreg->max_uV = UFS_2X_VREG_VCC_MAX_UV;
> +	}
> +
> +	ret = ufshcd_enable_vreg(hba->dev, vreg);
> +
> +	/* Bring the device in active now */
> +	ret = ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE);
> +	return ret;
> +}
> +
>  static void ufs_qcom_enable_test_bus(struct ufs_qcom_host *host)
>  {
>  	if (host->dbg_print_en & UFS_QCOM_DBG_PRINT_TEST_BUS_EN) {
> @@ -1490,6 +1540,7 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
>  	.device_reset		= ufs_qcom_device_reset,
>  	.config_scaling_param = ufs_qcom_config_scaling_param,
>  	.program_key		= ufs_qcom_ice_program_key,
> +	.setup_vcc_regulators	= ufs_qcom_setup_vcc_regulators,
>  };
> 
>  /**
> --
> 2.7.4
> 

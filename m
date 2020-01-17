Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF14C33C9E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 20:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1CB82072B
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 20:13:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="KuAxWGLs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729613AbgAQUNk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 15:13:40 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:48446 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727573AbgAQUNk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Jan 2020 15:13:40 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579292019; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=Y5qgxoSZTqTYC4luxASPjmnJF+fm6elstbh/xEVfpDE=; b=KuAxWGLsBU4KcPeE23NEunOAbT43nMWo0ccE7NFKQVthehzZS8tVzqMcEhKaT++4+bhiGO9U
 +Ob3D5p/5FWpc6+ruocVtJ/BLZ6HDM5zjK4nxGvyiDhOj7sq/7bVJcRpG7utk8dZiZumgakG
 1Ei5qCh9ZRRVtmXX0zhJNC86J6o=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e22156f.7f6e204ad068-smtp-out-n01;
 Fri, 17 Jan 2020 20:13:35 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7C48FC447A6; Fri, 17 Jan 2020 20:13:33 +0000 (UTC)
Received: from [10.46.161.159] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5B99FC43383;
        Fri, 17 Jan 2020 20:13:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5B99FC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v2 3/9] scsi: ufs: Split ufshcd_probe_hba() based on its
 called flow
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200116215914.16015-1-huobean@gmail.com>
 <20200116215914.16015-4-huobean@gmail.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <74a9bcdc-5d6a-2514-88b4-fe832f5b893a@codeaurora.org>
Date:   Fri, 17 Jan 2020 12:13:30 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200116215914.16015-4-huobean@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/16/2020 1:59 PM, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> This patch has two major non-functionality changes:
> 
> 1. Take scanning host if-statement out from ufshcd_probe_hba(), and
> move them into a new added function ufs_lu_add().
> In this new function ufs_lu_add(), the main functionalitis include:
> ICC initialization, add well-known LUs, devfreq initialization, UFS
> bsg probe and scsi host scan. The reason for this change is that these
> functionalities only being called during booting stage flow
> ufshcd_init()->ufshcd_async_scan(). In the processes of error handling
> and power management ufshcd_suspend(), ufshcd_resume(), ufshcd_probe_hba()
> being called,  but these functionalitis above metioned are not hit.
> 
> 2. Move context of initialization of parameters associated with UFS
> device to a new added ufs_init_params().
> The reason for this change is that all of these parameters are used by
> the driver and only need to be initialized once when booting. Combine
> them into an integral function.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>   drivers/scsi/ufs/ufshcd.c | 167 +++++++++++++++++++++++---------------
>   1 file changed, 101 insertions(+), 66 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 58ef45b80cb0..2cec0816632c 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -246,7 +246,7 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba);
>   static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
>   static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
>   static void ufshcd_hba_exit(struct ufs_hba *hba);
> -static int ufshcd_probe_hba(struct ufs_hba *hba);
> +static int ufshcd_probe_hba(struct ufs_hba *hba, bool async);
>   static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
>   				 bool skip_ref_clk);
>   static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
> @@ -6307,7 +6307,7 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
>   		goto out;
>   
>   	/* Establish the link again and restore the device */
> -	err = ufshcd_probe_hba(hba);
> +	err = ufshcd_probe_hba(hba, false);
>   
>   	if (!err && (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL))
>   		err = -EIO;
> @@ -6935,13 +6935,83 @@ static int ufshcd_set_dev_ref_clk(struct ufs_hba *hba)
>   	return err;
>   }
>   
> +static int ufs_init_params(struct ufs_hba *hba)
Accordance to the naming norms in ufshcd file, should this be 
ufshcd_init_params?

> +{
> +	bool flag;
> +	int ret;
> +
> +	/* Init check for device descriptor sizes */
> +	ufshcd_init_desc_sizes(hba);
> +
> +	/* Check and apply UFS device quirks */
> +	ret = ufs_get_device_desc(hba);
> +	if (ret) {
> +		dev_err(hba->dev, "%s: Failed getting device info. err = %d\n",
> +			__func__, ret);
> +		goto out;
> +	}
> +
> +	ufs_fixup_device_setup(hba);
> +
> +	/* Clear any previous UFS device information */
> +	memset(&hba->dev_info, 0, sizeof(hba->dev_info));
> +	if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
> +			QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
> +		hba->dev_info.f_power_on_wp_en = flag;
> +
> +out:
> +	return ret;
> +}
> +
> +/**
> + * ufs_lu_add - probe and add UFS logical units
> + * @hba: per-adapter instance
> + */
> +static int ufs_lu_add(struct ufs_hba *hba)
Accordance to the naming norms in ufshcd file, should this be 
ufshcd_init_params?

> +{
> +	int ret;
> +
> +	if (!hba->is_init_prefetch)
> +		ufshcd_init_icc_levels(hba);
> +
> +	/* Add required well known logical units to scsi mid layer */
> +	ret = ufshcd_scsi_add_wlus(hba);
> +	if (ret)
> +		goto out;
> +
> +	/* Initialize devfreq after UFS device is detected */
> +	if (ufshcd_is_clkscaling_supported(hba)) {
> +		memcpy(&hba->clk_scaling.saved_pwr_info.info,
> +			&hba->pwr_info,
> +			sizeof(struct ufs_pa_layer_attr));
> +		hba->clk_scaling.saved_pwr_info.is_valid = true;
> +		if (!hba->devfreq) {
> +			ret = ufshcd_devfreq_init(hba);
> +			if (ret)
> +				goto out;
> +		}
> +
> +		hba->clk_scaling.is_allowed = true;
> +	}
> +
> +	ufs_bsg_probe(hba);
> +	scsi_scan_host(hba->host);
> +	pm_runtime_put_sync(hba->dev);
> +
> +	if (!hba->is_init_prefetch)
> +		hba->is_init_prefetch = true;
> +out:
> +	return ret;
> +}
> +
>   /**
>    * ufshcd_probe_hba - probe hba to detect device and initialize
>    * @hba: per-adapter instance
> + * @async: asynchronous execution or not
>    *
>    * Execute link-startup and verify device initialization
>    */
> -static int ufshcd_probe_hba(struct ufs_hba *hba)
> +static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
>   {
>   	int ret;
>   	ktime_t start = ktime_get();
> @@ -6960,25 +7030,26 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>   	/* UniPro link is active now */
>   	ufshcd_set_link_active(hba);
>   
> +	/* Verify device initialization by sending NOP OUT UPIU */
>   	ret = ufshcd_verify_dev_init(hba);
>   	if (ret)
>   		goto out;
>   
> +	/* Initiate UFS initialization, and waiting until completion */
>   	ret = ufshcd_complete_dev_init(hba);
>   	if (ret)
>   		goto out;
>   
> -	/* Init check for device descriptor sizes */
> -	ufshcd_init_desc_sizes(hba);
> -
> -	ret = ufs_get_device_desc(hba);
> -	if (ret) {
> -		dev_err(hba->dev, "%s: Failed getting device info. err = %d\n",
> -			__func__, ret);
> -		goto out;
> +	/*
> +	 * Initialize UFS device parameters used by driver, these
> +	 * parameters are associated with UFS descriptors.
> +	 */
> +	if (async) {
> +		ret = ufs_init_params(hba);
> +		if (ret)
> +			goto out;
>   	}
>   
> -	ufs_fixup_device_setup(hba);
>   	ufshcd_tune_unipro_params(hba);
>   
>   	/* UFS device is also active now */
> @@ -7011,60 +7082,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>   	/* Enable Auto-Hibernate if configured */
>   	ufshcd_auto_hibern8_enable(hba);
>   
> -	/*
> -	 * If we are in error handling context or in power management callbacks
> -	 * context, no need to scan the host
> -	 */
> -	if (!ufshcd_eh_in_progress(hba) && !hba->pm_op_in_progress) {
> -		bool flag;
> -
> -		/* clear any previous UFS device information */
> -		memset(&hba->dev_info, 0, sizeof(hba->dev_info));
> -		if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
> -				QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
> -			hba->dev_info.f_power_on_wp_en = flag;
> -
> -		if (!hba->is_init_prefetch)
> -			ufshcd_init_icc_levels(hba);
> -
> -		/* Add required well known logical units to scsi mid layer */
> -		ret = ufshcd_scsi_add_wlus(hba);
> -		if (ret)
> -			goto out;
> -
> -		/* Initialize devfreq after UFS device is detected */
> -		if (ufshcd_is_clkscaling_supported(hba)) {
> -			memcpy(&hba->clk_scaling.saved_pwr_info.info,
> -				&hba->pwr_info,
> -				sizeof(struct ufs_pa_layer_attr));
> -			hba->clk_scaling.saved_pwr_info.is_valid = true;
> -			if (!hba->devfreq) {
> -				ret = ufshcd_devfreq_init(hba);
> -				if (ret)
> -					goto out;
> -			}
> -			hba->clk_scaling.is_allowed = true;
> -		}
> -
> -		ufs_bsg_probe(hba);
> -
> -		scsi_scan_host(hba->host);
> -		pm_runtime_put_sync(hba->dev);
> -	}
> -
> -	if (!hba->is_init_prefetch)
> -		hba->is_init_prefetch = true;
> -
>   out:
> -	/*
> -	 * If we failed to initialize the device or the device is not
> -	 * present, turn off the power/clocks etc.
> -	 */
> -	if (ret && !ufshcd_eh_in_progress(hba) && !hba->pm_op_in_progress) {
> -		pm_runtime_put_sync(hba->dev);
> -		ufshcd_exit_clk_scaling(hba);
> -		ufshcd_hba_exit(hba);
> -	}
>   
>   	trace_ufshcd_init(dev_name(hba->dev), ret,
>   		ktime_to_us(ktime_sub(ktime_get(), start)),
> @@ -7080,8 +7098,25 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>   static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>   {
>   	struct ufs_hba *hba = (struct ufs_hba *)data;
> +	int ret;
>   
> -	ufshcd_probe_hba(hba);
> +	/* Initialize hba, detect and initialize UFS device */
> +	ret = ufshcd_probe_hba(hba, true);
> +	if (ret)
> +		goto out;
> +
> +	/* Probe and add UFS logical units  */
> +	ret = ufs_lu_add(hba);
> +out:
> +	/*
> +	 * If we failed to initialize the device or the device is not
> +	 * present, turn off the power/clocks etc.
> +	 */
> +	if (ret) {
> +		pm_runtime_put_sync(hba->dev);
> +		ufshcd_exit_clk_scaling(hba);
> +		ufshcd_hba_exit(hba);
> +	}
>   }
>   
>   static const struct attribute_group *ufshcd_driver_groups[] = {
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project

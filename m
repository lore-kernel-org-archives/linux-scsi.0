Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E862C32771
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 20:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D38072253D
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 20:40:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="PAxgaT+b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgATUkB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 15:40:01 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:26808 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726586AbgATUkB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jan 2020 15:40:01 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579552800; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=hMMkrdpbQuWKKh6Fs/yw9vSMFlUgvTehkHZkaLEuz20=; b=PAxgaT+bttYsTUXO96sj9H7EZrf0fdY+HfT5EfuSLBXCqBs5DTYeD5hT1ckC8fK7DVdu3Jj6
 NxsOgC4t40LHSX/h6E+XHP8P0Oi9k9UVV5MTCdQCbUbkxKlRwuUO1PM99ordEeMTi0yWdOXS
 HH9eND4Ruhz0KnAKVtty5cB8IUk=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e26101b.7fd2f4c67e68-smtp-out-n01;
 Mon, 20 Jan 2020 20:39:55 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4B889C433A2; Mon, 20 Jan 2020 20:39:55 +0000 (UTC)
Received: from [10.46.161.159] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 68823C43383;
        Mon, 20 Jan 2020 20:39:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 68823C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v4 4/8] scsi: ufs: Move ufshcd_get_max_pwr_mode() to
 ufshcd_device_params_init()
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200120130820.1737-1-huobean@gmail.com>
 <20200120130820.1737-5-huobean@gmail.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <87a60011-75da-f38c-07fe-105e97074f0c@codeaurora.org>
Date:   Mon, 20 Jan 2020 12:39:51 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200120130820.1737-5-huobean@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/20/2020 5:08 AM, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> ufshcd_get_max_pwr_mode() only need to be called once while booting, take
> it out from ufshcd_probe_hba() and inline into ufshcd_device_params_init().
> 
> Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/ufshcd.c | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 935b50861864..5dfe760f2786 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6959,6 +6959,11 @@ static int ufshcd_device_params_init(struct ufs_hba *hba)
>   			QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
>   		hba->dev_info.f_power_on_wp_en = flag;
>   
> +	/* Probe maximum power mode co-supported by both UFS host and device */
> +	if (ufshcd_get_max_pwr_mode(hba))
> +		dev_err(hba->dev,
> +			"%s: Failed getting max supported power mode\n",
> +			__func__);
>   out:
>   	return ret;
>   }
> @@ -7057,11 +7062,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
>   	ufshcd_force_reset_auto_bkops(hba);
>   	hba->wlun_dev_clr_ua = true;
>   
> -	if (ufshcd_get_max_pwr_mode(hba)) {
> -		dev_err(hba->dev,
> -			"%s: Failed getting max supported power mode\n",
> -			__func__);
> -	} else {
> +	/* Gear up to HS gear if supported */
> +	if (hba->max_pwr_info.is_valid) {
>   		/*
>   		 * Set the right value to bRefClkFreq before attempting to
>   		 * switch to HS gears.
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project

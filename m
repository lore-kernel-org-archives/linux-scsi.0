Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B616558BA
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2024 06:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718780129; cv=none; b=iq7v+HTtoFUqxIrrYdZ32CRr+WdQzB7y7Eta0Y28dBJvzDhSHrjU75wf20DKLsj0PKbl2MBinPbftTkA9VtiGMoOvyHQLIizOXupgX/zVNGkaDCSLCA9ziUnbSb1z7AV2vMeD31dsStsOMelvo1E04+il3zeILsZ5ldilo1f0n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718780129; c=relaxed/simple;
	bh=jvRjRihByPl2TWv43KZdm7WgtpljFaN5sKuonvsHJ50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PYQmyNoJvJ3OP08gsg1IKfYpYf+0JUG1xVzQalvCiKUhYmhMSsINKZLFLsGmNuqlWe/G8uLLJ4NwZNEWD4Eh6IMsP1W/YP5kFbNI34INfPmEoDiUs6GY4hqzOQCo4CHFG9pWid7TP2jpbeRrEzFSHkOwRP4wjFJCnJECKLXrQ8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hE0/EZyu; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hE0/EZyu"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-704313fa830so4900838b3a.3
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 23:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718780127; x=1719384927; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=elO43JEybfpwfnJw57iJ4pRuJ39vRm2tVpdUN/i49IE=;
        b=hE0/EZyuIWz4BSChVPVqFlGZ0ETEOMMmGm9+KUCT1Bn+vANpnzR94RqPBjybeSvovv
         CqLk1uhnrBv6cMxoKb3TzgUWGMpQJ26LlXOxdq7OV3uq3NMR+zJ8HXHU9csiNSTTih1e
         NfST2X30FY5QH7YT3nyC8yY/8FaBQVL6l4TKSDF5xhzHfxzGyMlJFM05l9W0rPeouByA
         myo+PsblJbxtCq+4foc9ZWO/JGARa70pQZYzJm1kln96cNmzhrH3T7jKFzrYYLsiwsls
         eE3qHCHZR48V1vxmS2amiR9V6ygpZlcK5EB8jsFLrvrgsyV51uQtqiojC3a39xi9wYQP
         1JOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718780127; x=1719384927;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=elO43JEybfpwfnJw57iJ4pRuJ39vRm2tVpdUN/i49IE=;
        b=OUy/ABIfea1HRuMkcXA2USIL+dEfVFDWfkEc2HUBqjdsMXON6DYXgXRH65grVaEkIO
         YhhYvSFKwB1XU/HgJYMzoOVERM9TazFa0NSGxFoWW6vKv6/yMP8zttM8AANi8Tv11567
         IAau/sVZu5n9hDyxJIhLkXdeb0IXg0sHgQVD9XbF61Pr6lqBnoHncMf801XLUo609HDo
         SaDq1mwkPLspxPDWIxx4VDRdoB0VZn767ByG+xdpLpeN9aUNnSovLdlBNDirf0g3ZqQY
         p/ikhTa5J4Ey0lBfZNNb6trYTt0p2w1VOtQZV+q7WUznBlsJAWvffia406mdla6i96GP
         CAuA==
X-Forwarded-Encrypted: i=1; AJvYcCXh9EMVusWn77Z5VuTrD39r3suOlzc1Nbd6OI5jSgyKufPkRGGhUKgQDuy0UmdCUuwueSaLRRaVQCLitkWOIgMc5i4fArOdBNDL1g==
X-Gm-Message-State: AOJu0YyZywKXkicHgVpNhitxdV31clvR0lzAT4yeMT6H3FeCoRxo+D8r
	8lXV2Y6bFahJLzpEMjK0CJYLv/aJsJvt9MGQ92Nd+WkW6aND3TcUMaLkD25a0+W3VXNdFEJztwc
	=
X-Google-Smtp-Source: AGHT+IHrHR96iTo9mfynCoEH0akfh+7cgvC5FwmqVhmPH4BvvxL0kRMICVMpAITThZm2otN9uQ3VPQ==
X-Received: by 2002:a05:6a00:218e:b0:705:e5da:8290 with SMTP id d2e1a72fcca58-70629ccb7fdmr2073803b3a.24.1718780126550;
        Tue, 18 Jun 2024 23:55:26 -0700 (PDT)
Received: from thinkpad ([120.60.70.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccb718easm10354206b3a.177.2024.06.18.23.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 23:55:26 -0700 (PDT)
Date: Wed, 19 Jun 2024 12:25:16 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Avri Altman <avri.altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/8] scsi: ufs: Initialize struct uic_command once
Message-ID: <20240619065516.GB6056@thinkpad>
References: <20240617210844.337476-1-bvanassche@acm.org>
 <20240617210844.337476-2-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240617210844.337476-2-bvanassche@acm.org>

On Mon, Jun 17, 2024 at 02:07:40PM -0700, Bart Van Assche wrote:
> Instead of first zero-initializing struct uic_command and next initializing
> it memberwise, initialize all members at once.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  drivers/ufs/core/ufshcd.c | 62 ++++++++++++++++++++-------------------
>  include/ufs/ufshcd.h      |  4 +--
>  2 files changed, 34 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 41bf2e249c83..5d784876513e 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -3993,11 +3993,11 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
>   */
>  static int ufshcd_dme_link_startup(struct ufs_hba *hba)
>  {
> -	struct uic_command uic_cmd = {0};
> +	struct uic_command uic_cmd = {
> +		.command = UIC_CMD_DME_LINK_STARTUP,
> +	};
>  	int ret;
>  
> -	uic_cmd.command = UIC_CMD_DME_LINK_STARTUP;
> -
>  	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
>  	if (ret)
>  		dev_dbg(hba->dev,
> @@ -4015,11 +4015,11 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
>   */
>  static int ufshcd_dme_reset(struct ufs_hba *hba)
>  {
> -	struct uic_command uic_cmd = {0};
> +	struct uic_command uic_cmd = {
> +		.command = UIC_CMD_DME_RESET,
> +	};
>  	int ret;
>  
> -	uic_cmd.command = UIC_CMD_DME_RESET;
> -
>  	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
>  	if (ret)
>  		dev_err(hba->dev,
> @@ -4054,11 +4054,11 @@ EXPORT_SYMBOL_GPL(ufshcd_dme_configure_adapt);
>   */
>  static int ufshcd_dme_enable(struct ufs_hba *hba)
>  {
> -	struct uic_command uic_cmd = {0};
> +	struct uic_command uic_cmd = {
> +		.command = UIC_CMD_DME_ENABLE,
> +	};
>  	int ret;
>  
> -	uic_cmd.command = UIC_CMD_DME_ENABLE;
> -
>  	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
>  	if (ret)
>  		dev_err(hba->dev,
> @@ -4111,7 +4111,12 @@ static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba)
>  int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
>  			u8 attr_set, u32 mib_val, u8 peer)
>  {
> -	struct uic_command uic_cmd = {0};
> +	struct uic_command uic_cmd = {
> +		.command = peer ? UIC_CMD_DME_PEER_SET : UIC_CMD_DME_SET,
> +		.argument1 = attr_sel,
> +		.argument2 = UIC_ARG_ATTR_TYPE(attr_set),
> +		.argument3 = mib_val,
> +	};
>  	static const char *const action[] = {
>  		"dme-set",
>  		"dme-peer-set"
> @@ -4120,12 +4125,6 @@ int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
>  	int ret;
>  	int retries = UFS_UIC_COMMAND_RETRIES;
>  
> -	uic_cmd.command = peer ?
> -		UIC_CMD_DME_PEER_SET : UIC_CMD_DME_SET;
> -	uic_cmd.argument1 = attr_sel;
> -	uic_cmd.argument2 = UIC_ARG_ATTR_TYPE(attr_set);
> -	uic_cmd.argument3 = mib_val;
> -
>  	do {
>  		/* for peer attributes we retry upon failure */
>  		ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
> @@ -4155,7 +4154,11 @@ EXPORT_SYMBOL_GPL(ufshcd_dme_set_attr);
>  int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
>  			u32 *mib_val, u8 peer)
>  {
> -	struct uic_command uic_cmd = {0};
> +	struct uic_command uic_cmd = {
> +		.command = peer ? UIC_CMD_DME_PEER_GET : UIC_CMD_DME_GET,
> +		.argument1 = attr_sel,
> +
> +	};
>  	static const char *const action[] = {
>  		"dme-get",
>  		"dme-peer-get"
> @@ -4189,10 +4192,6 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
>  		}
>  	}
>  
> -	uic_cmd.command = peer ?
> -		UIC_CMD_DME_PEER_GET : UIC_CMD_DME_GET;
> -	uic_cmd.argument1 = attr_sel;
> -
>  	do {
>  		/* for peer attributes we retry upon failure */
>  		ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
> @@ -4325,7 +4324,11 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
>   */
>  int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
>  {
> -	struct uic_command uic_cmd = {0};
> +	struct uic_command uic_cmd = {
> +		.command = UIC_CMD_DME_SET,
> +		.argument1 = UIC_ARG_MIB(PA_PWRMODE),
> +		.argument3 = mode,
> +	};
>  	int ret;
>  
>  	if (hba->quirks & UFSHCD_QUIRK_BROKEN_PA_RXHSUNTERMCAP) {
> @@ -4338,9 +4341,6 @@ int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
>  		}
>  	}
>  
> -	uic_cmd.command = UIC_CMD_DME_SET;
> -	uic_cmd.argument1 = UIC_ARG_MIB(PA_PWRMODE);
> -	uic_cmd.argument3 = mode;
>  	ufshcd_hold(hba);
>  	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
>  	ufshcd_release(hba);
> @@ -4381,13 +4381,14 @@ EXPORT_SYMBOL_GPL(ufshcd_link_recovery);
>  
>  int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
>  {
> -	int ret;
> -	struct uic_command uic_cmd = {0};
> +	struct uic_command uic_cmd = {
> +		.command = UIC_CMD_DME_HIBER_ENTER,
> +	};
>  	ktime_t start = ktime_get();
> +	int ret;
>  
>  	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_ENTER, PRE_CHANGE);
>  
> -	uic_cmd.command = UIC_CMD_DME_HIBER_ENTER;
>  	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
>  	trace_ufshcd_profile_hibern8(dev_name(hba->dev), "enter",
>  			     ktime_to_us(ktime_sub(ktime_get(), start)), ret);
> @@ -4405,13 +4406,14 @@ EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_enter);
>  
>  int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
>  {
> -	struct uic_command uic_cmd = {0};
> +	struct uic_command uic_cmd = {
> +		.command = UIC_CMD_DME_HIBER_EXIT,
> +	};
>  	int ret;
>  	ktime_t start = ktime_get();
>  
>  	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_EXIT, PRE_CHANGE);
>  
> -	uic_cmd.command = UIC_CMD_DME_HIBER_EXIT;
>  	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
>  	trace_ufshcd_profile_hibern8(dev_name(hba->dev), "exit",
>  			     ktime_to_us(ktime_sub(ktime_get(), start)), ret);
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 9e0581115b34..d4d63507d090 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -73,8 +73,8 @@ enum ufs_event_type {
>   * @done: UIC command completion
>   */
>  struct uic_command {
> -	u32 command;
> -	u32 argument1;
> +	const u32 command;
> +	const u32 argument1;
>  	u32 argument2;
>  	u32 argument3;
>  	int cmd_active;

-- 
மணிவண்ணன் சதாசிவம்

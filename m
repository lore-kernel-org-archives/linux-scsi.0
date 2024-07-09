Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D01A1E898
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jul 2024 05:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720501869; cv=none; b=gWtTTCxXRZheSGK+uDQPHWeGe1OukfNG6chpbdySqHbwbzOspTJcayomRXnufB0hsLqHPDG9ml2hHFBAMv8qVSBrWqyCEyMQ5YVre9VyhhghH73VYNPn+cMvV8DSRtgU0owg9G8U4YwIVilZ5liA4rM8v9hxUrZ+yJ2hZImiXAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720501869; c=relaxed/simple;
	bh=dhJ/NAaV4MMGlkEqfwWZ7iSUN1XdqaHE+7dB6ZXEgtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hfef3/TwACXN1OEFf8a5SwBURit5/uCviHYEH3cMw+gMAYKxU5sYtGjX6KOvV33C1Js/yUhOooXu6N5Z3YAU0hmcsFMSFB294ERN9QpQhXCkcoahN0pHESaJpbIM7V6kxwkGWCwZEZFB3JNN0+FwTk6o0tKjoPfm1xKkiPupaN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UrUHYQjr; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UrUHYQjr"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-70b12572bd8so2087415b3a.2
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jul 2024 22:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720501867; x=1721106667; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=f9UW2LuituNq45ybnCB1D89SvMPwcqnNc3nGmlsJSQQ=;
        b=UrUHYQjrXovbPx5YlxE0xRIwJFELMae566f9rQM+itXJjBa4KBskB75OdCx3Ncr7J9
         rUNOCFKuU2LnkRnun3A7xT8RNDppUr+np4KyFr79sBCQSE1opm80Oc/QswBfcEnIAp+h
         CFzNX/KsE9h2dB8BwJvaMejbWgP6OWqtt3+xpSOn4NPbLj7+Q6x8uDDcG3VxAxHPdgEe
         fWUxYlWlnuv04Ru8FbjUlGMHSRzKR8mCGy2XPkGIq7IkAHsm5WaakYtboOxRjwGtviCy
         XwgkPNuSxNQJ07A0tDFgMzCoQI9VC2FR92i7J0SijsPUHVSilLI74LAu674ZCUXjSUqG
         +Qyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720501867; x=1721106667;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f9UW2LuituNq45ybnCB1D89SvMPwcqnNc3nGmlsJSQQ=;
        b=ai+lgysTmRvIjk4ldcu9Dl7ibXwSeD0TzgVou1wRpC1iVXkwit2MzpCU3hPvLi8BQS
         cGPqgn3hn0IQS1fLQjJ/y9SiwRuOiA7x9+ZqQtUq0JllPL3lmy9abA00Bv0OlolQJN1L
         ETywLtbTA+BIblykt+RDSyB9QJadxxzlt/ura7D9KZW369oYEYVaS0h7e8+bX1tE6pBU
         VHEM7E0xjFXPqdPxvqew5c2YGwOqoMlYYwxivJQ/RuCWjC0JMjUHnrVutiUC7yY7Zi4Y
         +S2snbg1cGzGH7mjv+DxB40pvnoXKDuD2UhVFM4U6joM6Tk3mCoqrTZwe3Jj2vhuAe1h
         qukQ==
X-Forwarded-Encrypted: i=1; AJvYcCUG3orxFGy8/g3y2HkCIxnlIWekv8uAGXIREfX/u6K116N62/PajrgHzs8u/hAI8bNQrENkWqaM14eM0ZMt9d6BqFdfuNobvChZqw==
X-Gm-Message-State: AOJu0YxygHw64L7K1Z+5SKHXrPnX+fCcSincTI3/fGw3rL9x6wpzpSgk
	/UG3+mGljuAVT7VlhTznvcth2iihGseLv73p3G/QhvKq9PnkhwsvIZ2Xaog2hVKIh6zIEjkBttc
	=
X-Google-Smtp-Source: AGHT+IG3lFL4mSQVlKt1fwOdSsagWBE4FF5FNtRRLeHy4tb7Oqq0cvA5P2hLUkecH1NYfZF+mJj31Q==
X-Received: by 2002:a05:6a00:b45:b0:705:a450:a9a2 with SMTP id d2e1a72fcca58-70b435561ebmr1988898b3a.13.1720501867340;
        Mon, 08 Jul 2024 22:11:07 -0700 (PDT)
Received: from thinkpad ([117.193.209.237])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b43967898sm809453b3a.123.2024.07.08.22.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jul 2024 22:11:06 -0700 (PDT)
Date: Tue, 9 Jul 2024 10:40:58 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, peter.wang@mediatek.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>,
	Naomi Chu <naomi.chu@mediatek.com>, Rohit Ner <rohitner@google.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v5 10/10] scsi: ufs: Make .get_hba_mac() optional
Message-ID: <20240709051058.GF3820@thinkpad>
References: <20240708211716.2827751-1-bvanassche@acm.org>
 <20240708211716.2827751-11-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240708211716.2827751-11-bvanassche@acm.org>

On Mon, Jul 08, 2024 at 02:16:05PM -0700, Bart Van Assche wrote:
> UFSHCI controllers that are compliant with the UFSHCI 4.0 standard report
> the maximum number of supported commands in the controller capabilities
> register. Use that value if .get_hba_mac == NULL.
> 
> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  drivers/ufs/core/ufs-mcq.c     | 26 ++++++++++++++++++++------
>  drivers/ufs/core/ufshcd-priv.h |  1 +
>  drivers/ufs/core/ufshcd.c      |  3 ++-
>  include/ufs/ufshcd.h           |  4 +++-
>  include/ufs/ufshci.h           |  1 +
>  5 files changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> index ef98c9797d07..70951829192f 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -138,18 +138,26 @@ EXPORT_SYMBOL_GPL(ufshcd_mcq_queue_cfg_addr);
>   *
>   * MAC - Max. Active Command of the Host Controller (HC)
>   * HC wouldn't send more than this commands to the device.
> - * It is mandatory to implement get_hba_mac() to enable MCQ mode.
>   * Calculates and adjusts the queue depth based on the depth
>   * supported by the HC and ufs device.
>   */
>  int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba)
>  {
> -	int mac = -EOPNOTSUPP;
> +	int mac;
>  
> -	if (!hba->vops || !hba->vops->get_hba_mac)
> -		goto err;
> -
> -	mac = hba->vops->get_hba_mac(hba);
> +	if (!hba->vops || !hba->vops->get_hba_mac) {
> +		/*
> +		 * Extract the maximum number of active transfer tasks value
> +		 * from the host controller capabilities register. This value is
> +		 * 0-based.
> +		 */
> +		hba->capabilities =
> +			ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES);
> +		mac = hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS_MCQ;
> +		mac++;
> +	} else {
> +		mac = hba->vops->get_hba_mac(hba);
> +	}
>  	if (mac < 0)
>  		goto err;
>  
> @@ -424,6 +432,12 @@ void ufshcd_mcq_enable(struct ufs_hba *hba)
>  }
>  EXPORT_SYMBOL_GPL(ufshcd_mcq_enable);
>  
> +void ufshcd_mcq_disable(struct ufs_hba *hba)
> +{
> +	ufshcd_rmwl(hba, MCQ_MODE_SELECT, 0, REG_UFS_MEM_CFG);
> +	hba->mcq_enabled = false;
> +}
> +
>  void ufshcd_mcq_config_esi(struct ufs_hba *hba, struct msi_msg *msg)
>  {
>  	ufshcd_writel(hba, msg->address_lo, REG_UFS_ESILBA);
> diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
> index 88ce93748305..ce36154ce963 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -64,6 +64,7 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
>  void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
>  			  struct cq_entry *cqe);
>  int ufshcd_mcq_init(struct ufs_hba *hba);
> +void ufshcd_mcq_disable(struct ufs_hba *hba);
>  int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba);
>  int ufshcd_mcq_memory_alloc(struct ufs_hba *hba);
>  struct ufs_hw_queue *ufshcd_mcq_req_to_hwq(struct ufs_hba *hba,
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 4c2b60dec43f..1ba5668b0700 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8754,12 +8754,13 @@ static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
>  		if (ret)
>  			return ret;
>  		if (is_mcq_supported(hba) && !hba->scsi_host_added) {
> +			ufshcd_mcq_enable(hba);
>  			ret = ufshcd_alloc_mcq(hba);
>  			if (!ret) {
>  				ufshcd_config_mcq(hba);
> -				ufshcd_mcq_enable(hba);
>  			} else {
>  				/* Continue with SDB mode */
> +				ufshcd_mcq_disable(hba);
>  				use_mcq_mode = false;
>  				dev_err(hba->dev, "MCQ mode is disabled, err=%d\n",
>  					 ret);
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 3eaa8bc7eaea..52b0b10cca50 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -325,7 +325,9 @@ struct ufs_pwr_mode_info {
>   * @event_notify: called to notify important events
>   * @reinit_notify: called to notify reinit of UFSHCD during max gear switch
>   * @mcq_config_resource: called to configure MCQ platform resources
> - * @get_hba_mac: called to get vendor specific mac value, mandatory for mcq mode
> + * @get_hba_mac: reports maximum number of outstanding commands supported by
> + *	the controller. Should be implemented for UFSHCI 4.0 or later
> + *	controllers that are not compliant with the UFSHCI 4.0 specification.
>   * @op_runtime_config: called to config Operation and runtime regs Pointers
>   * @get_outstanding_cqs: called to get outstanding completion queues
>   * @config_esi: called to config Event Specific Interrupt
> diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
> index 8d0cc73537c6..38fe97971a65 100644
> --- a/include/ufs/ufshci.h
> +++ b/include/ufs/ufshci.h
> @@ -68,6 +68,7 @@ enum {
>  /* Controller capability masks */
>  enum {
>  	MASK_TRANSFER_REQUESTS_SLOTS_SDB	= 0x0000001F,
> +	MASK_TRANSFER_REQUESTS_SLOTS_MCQ	= 0x000000FF,
>  	MASK_NUMBER_OUTSTANDING_RTT		= 0x0000FF00,
>  	MASK_TASK_MANAGEMENT_REQUEST_SLOTS	= 0x00070000,
>  	MASK_EHSLUTRD_SUPPORTED			= 0x00400000,

-- 
மணிவண்ணன் சதாசிவம்

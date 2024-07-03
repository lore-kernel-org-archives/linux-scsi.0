Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5509E13A25B
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jul 2024 13:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720012930; cv=none; b=acOzkhSPkWTRaK1OW450Ffwh9+GR0ylWcQFEVG7Cf68mJeP9fu7izxgfIJtWScFbCpnaQEiOF8VLclWmLq4IBL3IcD7cGQJruZApXMUMdoV79fh3401KMZBg5XZFsk6ixssYZuS9QoXJuJbAEhxR6hDmL/jtF52ualgDuassj8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720012930; c=relaxed/simple;
	bh=6uqKrAO52A/ZT1nOpbJHYysngxDMgJIpFdtq0v5B5yY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ljhgho3qs/qgNA7IBvimsVOu9Ypi4MXtwSsFmwHI9up1fh37Q6WuBIV5owtH1DK0yWKrUAi9ITxjf1MrIFHhvvogT/MERob9Cd1NOJptF6qIwICgeUYEtzvHkS+ft7v5/K5/L6SWU4IvcTeqHc0LygSwkQsl+J4rGcP2HRB6cAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YiE7JUTp; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YiE7JUTp"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1fab50496f0so32840905ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jul 2024 06:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720012927; x=1720617727; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OvcW77TWKg3DR5fpa/Ko9c9C/wfXdmr7hQSGYh2yjEc=;
        b=YiE7JUTppFU6BVbE2JbIJ+EWS29gNfihJ4lOZpDXi+dNnFelITXy6RrKj+tF0IYhgy
         7WtKAgZdBXpHwu48kY/f+gJIv9As1gzHg+x4HgbQ+AuVz2uL9ZMPQlfUnP1TbRnOlIvQ
         jdOfb0GeSHOXoEfdxlTyvTTkxwte3yN5Y9U0X5Qk8iJUuXGFhav25By7T0TeO3KNAxug
         eMWr8OpOApgiIv7ZBdmo5hchJiTGP+6l7D7XqFkS4vAsXE0OtuuzN3B6jHPVdaX79gF0
         JpSnkUV5FjzrAJ0V6UE4NA+7YRlUVLg161j8uRGYWlFjOr/lPzJcs31XrZYQBascWCsy
         4vlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720012927; x=1720617727;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OvcW77TWKg3DR5fpa/Ko9c9C/wfXdmr7hQSGYh2yjEc=;
        b=rsx5ovVDotOqTD7QgEolfTVk3YqP4I1T4TGe7TPUviBTR4fa4qpIhdkpMzHn1NF4Up
         umFB9bEf2T661VSNrAQTTBaeN3U7dsn4uKXuiwCzfENrOkFd58JItjxEmEsD3aTdmdJw
         2mg9DlFVpKmm3s6NoJxc/4nNz++pOHHi6421NA2LWtWGcl9QH8HvVnFkyupSMXrpJhIg
         4z0/6Fz3NPQXmMKwvyci0naq6SKW0dVshyPZOOSyVG5x2xL0SGfH4imGK+s3iGOf+uKd
         T6lEhyrRhMGwByv7MgnzW1WPyrJhQP3YhMoGauDMIyJiZpCKC3DSNxd19qTN/4sdIr0Y
         36Nw==
X-Forwarded-Encrypted: i=1; AJvYcCU0WzA0yrs1xmeaWHV/K4pMocwryisdQOpDfqelLETPe0CAzgBbtkcbjVp2vTpzMHW9jkUJcbkK0iAnTZt/01qPXPZnvJAM5wAfYQ==
X-Gm-Message-State: AOJu0YypcYf8QVnq78eGVUIkIWil7DocakymAiW8IAU5u5MfyId/Z+TG
	nZeapZZkjEsMqT6N87a9wpEKiDd4AzobNgjX29edmNDI9ewfyLtZPn/GUHZIfg==
X-Google-Smtp-Source: AGHT+IGn7hc/Fj/DhWZXq+aVgKy3hLNj/2k43r0m3e5veGXKZ00As92eCF55OwLH6Dv+SQygrcMSkw==
X-Received: by 2002:a17:902:c40a:b0:1fa:2277:f56c with SMTP id d9443c01a7336-1fadbcb2163mr86558315ad.41.1720012927467;
        Wed, 03 Jul 2024 06:22:07 -0700 (PDT)
Received: from thinkpad ([220.158.156.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fafb173f05sm32736195ad.104.2024.07.03.06.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jul 2024 06:22:06 -0700 (PDT)
Date: Wed, 3 Jul 2024 18:52:02 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v4 9/9] scsi: ufs: Make .get_hba_mac() optional
Message-ID: <20240703132202.GE3498@thinkpad>
References: <20240702204020.2489324-1-bvanassche@acm.org>
 <20240702204020.2489324-10-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240702204020.2489324-10-bvanassche@acm.org>

On Tue, Jul 02, 2024 at 01:39:17PM -0700, Bart Van Assche wrote:
> UFSHCI controllers that are compliant with the UFSHCI 4.0 standard report
> the maximum number of supported commands in the controller capabilities
> register. Use that value if .get_hba_mac == NULL.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufs-mcq.c     | 20 ++++++++++++++------
>  drivers/ufs/core/ufshcd-priv.h |  1 +
>  drivers/ufs/core/ufshcd.c      |  6 ++++--
>  include/ufs/ufshcd.h           |  4 +++-
>  include/ufs/ufshci.h           |  1 +
>  5 files changed, 23 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> index 0482c7a1e419..b2cf34a1fe48 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -138,18 +138,21 @@ EXPORT_SYMBOL_GPL(ufshcd_mcq_queue_cfg_addr);
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
> +		hba->capabilities =
> +			ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES);
> +		mac = hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS_MCQ;
> +		mac++;

Can you add a comment to state that the MAC value is 0 based?

> +	} else {
> +		mac = hba->vops->get_hba_mac(hba);
> +	}
>  	if (mac < 0)
>  		goto err;
>  
> @@ -423,6 +426,11 @@ void ufshcd_mcq_enable(struct ufs_hba *hba)
>  }
>  EXPORT_SYMBOL_GPL(ufshcd_mcq_enable);
>  
> +void ufshcd_mcq_disable(struct ufs_hba *hba)
> +{
> +	ufshcd_rmwl(hba, MCQ_MODE_SELECT, 0, REG_UFS_MEM_CFG);
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
> index b3444f9ce130..9e0290c6c2d3 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8753,13 +8753,15 @@ static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
>  		if (ret)
>  			return ret;
>  		if (is_mcq_supported(hba) && !hba->scsi_host_added) {
> +			ufshcd_mcq_enable(hba);
> +			hba->mcq_enabled = true;

If the 'mcq_enabled' assignment goes hand in hand with
ufshcd_mcq_{enable/disable}, why shouldn't it be moved inside?

- Mani

>  			ret = ufshcd_alloc_mcq(hba);
>  			if (!ret) {
>  				ufshcd_config_mcq(hba);
> -				ufshcd_mcq_enable(hba);
> -				hba->mcq_enabled = true;
>  			} else {
>  				/* Continue with SDB mode */
> +				ufshcd_mcq_disable(hba);
> +				hba->mcq_enabled = false;
>  				use_mcq_mode = false;
>  				dev_err(hba->dev, "MCQ mode is disabled, err=%d\n",
>  					 ret);
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index c0e28a512b3c..6518997930f3 100644
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

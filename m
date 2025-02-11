Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E047A1C3C14
	for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2025 07:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739258133; cv=none; b=LopS3Us5IW9TkcFX/TCY4cfCP4oOZex7d60uDDkRfmQfkUBHepqL2KYQ+heRiQn4yEiOhWrZsoNhoHzEMu7DXPNdrE/vrE2/R+Dyt8VkuoXJNC1pHP6/EjgKW23fY1DCW1peJ2yIqPqyoX044BsHmP1UT5TEND5ORpuE75wa0G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739258133; c=relaxed/simple;
	bh=a+SKBh55AkQwYZrfdvManTiJRIi7EDKWKDZDpzgL7vk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LGYjmTYyTGl+p2/OM5xXAUJHIagdMmxT08tzbXad2sDf8LmTguLqwJSnyKwrwPyiGVWhEVuj4YkVT71LYxv5Fk73HvNopN2h56f1xTRkJgXDWSe21HrY0zUHMzk/vADz4O5mGnsNrdhh4zj64t6w9RF/993XTfXSW1EucJeJ1lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ycqy3atr; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ycqy3atr"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-21f5a224544so42279545ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2025 23:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739258131; x=1739862931; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vD+EgsZ0T7PDMw/bMLDaz1PONiZNjDPIMfFzu3/y2Rc=;
        b=ycqy3atrmqBo8HLOmmY5HyLv+Qo1KIVBOk3uT4jhAJtO7oN8CJfScCulymd5NSCbQ6
         wYRO6PuNjILbLk+P4zfFc18gCfOFrk1YbExiCSWdpkDMicvDyCUPoUHKhpVxM/KTJpkm
         ft/TKo1xcdDZBocgR8wLaQR091hZ0FHaRvWYCZzyw6bZ/9bQGiGaJGN3WTxNE1lZu20S
         hgH2Be7VPgR826F6bBf1dCrp3n9Gwe7bYkNueR8N10C02O/Jg8P51IgyDchWMBFSk4jC
         dFqlOpVfVtdNiGcwUfrvfIJV6ibSk8bniPR+O6De/3aRzRGfCB6yBkwBtPujfFXI+Ad9
         eNrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739258131; x=1739862931;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vD+EgsZ0T7PDMw/bMLDaz1PONiZNjDPIMfFzu3/y2Rc=;
        b=FlNsOC8ATW5TD+1JJuUeaR4YvfZSNDvPxLLhb687pZN8kW9KFcOzEaiT6qFyfi2M6i
         NYO7DK+6iGAvnQHxL5gN+sTe6g3LHkQtI0rwnsnpC4dZUrilQWJ/8P8HJprvw3yrsQWl
         I6TywsOi5wOrTWB83cSOjJ2eYxlkY6SdW+nlDBlaHj9imDmhcoyXRhmDLKRnXKalf4xP
         KryBLhycveTMYAAdhvqff2A0lxVFB3FgrCX2oz5g3R9ra/AnhcQDk8aSQUdayR4UKYkP
         np1XFQWQKARZonpLmehVE66q3ySSbQCJCwKg8fCRc5XNOjSpr9SspXC6aCQ8QPfvPSqW
         4bjw==
X-Forwarded-Encrypted: i=1; AJvYcCXA+Buf6vQKgd2UIjz+r14bqYQ1guFt1eMVxARclKqbP11uMXLGF447JthWVgwIk4dGMWsj4dhl8aGI@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3qfVjx0GnipL3kYpLYZ82Az54NabR80B6wHxFUeTrpBzz6bHc
	9A+xHqoCjWIs/7sZTyDb15p8THBqpBqS1IgMmElmx6pm2Aolu9rJ2mqsXDwKEg==
X-Gm-Gg: ASbGnctogWbuUyWQ+p7CB7mt4A4nQhw5uzIk4/906K/1biaCLfRIpaa54s9f+mH6xFd
	rnDU/dBUFlmwrylJfhte6BNoqj+FKlaCMsa81DDiupyWqR/PVlvOmN1MTLlKeO3VUIipfJK1XKL
	oYQT/1ba9Z69YEVFPa4huKYfGw50lkKQ9U82/UxLCLGus7Rh7oMDe8RWKYb3XsjgIVoFtJB/BAl
	POjnOlsayBPxPh+XTBfJeodlbEnC7sZKAiPr8mjPsnKPcH5+62KLIc/ZuMk/PlYQj+dL8qzC7Fp
	eej4FKIYilTdNIR7OLn12/ssCw==
X-Google-Smtp-Source: AGHT+IHXWpkWXnY0YN0Dt30stPJV13qAiNuqoc6gzlnixFD8RnVzl3TtjB3rZRgLYzNlQ56fzxsgrA==
X-Received: by 2002:a17:902:d4c7:b0:21f:6005:503d with SMTP id d9443c01a7336-21f60055488mr226844615ad.42.1739258131023;
        Mon, 10 Feb 2025 23:15:31 -0800 (PST)
Received: from thinkpad ([36.255.17.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21f3687c187sm90632165ad.168.2025.02.10.23.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 23:15:30 -0800 (PST)
Date: Tue, 11 Feb 2025 12:45:23 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	YiFeng Zhao <zyf@rock-chips.com>, Liang Chen <cl@rock-chips.com>,
	linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org,
	devicetree@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v7 3/7] pmdomain: core: Introduce
 dev_pm_genpd_rpm_always_on()
Message-ID: <20250211071523.fd6zss7jjtqivw6a@thinkpad>
References: <1738736156-119203-1-git-send-email-shawn.lin@rock-chips.com>
 <1738736156-119203-4-git-send-email-shawn.lin@rock-chips.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1738736156-119203-4-git-send-email-shawn.lin@rock-chips.com>

On Wed, Feb 05, 2025 at 02:15:52PM +0800, Shawn Lin wrote:
> From: Ulf Hansson <ulf.hansson@linaro.org>
> 
> For some usecases a consumer driver requires its device to remain power-on
> from the PM domain perspective during runtime. Using dev PM qos along with
> the genpd governors, doesn't work for this case as would potentially
> prevent the device from being runtime suspended too.
> 
> To support these usecases, let's introduce dev_pm_genpd_rpm_always_on() to
> allow consumers drivers to dynamically control the behaviour in genpd for a
> device that is attached to it.
> 
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>

Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
> 
> Changes in v7: None
> Changes in v6:
> - export dev_pm_genpd_rpm_always_on()
> 
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
> 
>  drivers/pmdomain/core.c   | 35 +++++++++++++++++++++++++++++++++++
>  include/linux/pm_domain.h |  7 +++++++
>  2 files changed, 42 insertions(+)
> 
> diff --git a/drivers/pmdomain/core.c b/drivers/pmdomain/core.c
> index 6c94137..9b2f28b 100644
> --- a/drivers/pmdomain/core.c
> +++ b/drivers/pmdomain/core.c
> @@ -697,6 +697,37 @@ bool dev_pm_genpd_get_hwmode(struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(dev_pm_genpd_get_hwmode);
>  
> +/**
> + * dev_pm_genpd_rpm_always_on() - Control if the PM domain can be powered off.
> + *
> + * @dev: Device for which the PM domain may need to stay on for.
> + * @on: Value to set or unset for the condition.
> + *
> + * For some usecases a consumer driver requires its device to remain power-on
> + * from the PM domain perspective during runtime. This function allows the
> + * behaviour to be dynamically controlled for a device attached to a genpd.
> + *
> + * It is assumed that the users guarantee that the genpd wouldn't be detached
> + * while this routine is getting called.
> + *
> + * Return: Returns 0 on success and negative error values on failures.
> + */
> +int dev_pm_genpd_rpm_always_on(struct device *dev, bool on)
> +{
> +	struct generic_pm_domain *genpd;
> +
> +	genpd = dev_to_genpd_safe(dev);
> +	if (!genpd)
> +		return -ENODEV;
> +
> +	genpd_lock(genpd);
> +	dev_gpd_data(dev)->rpm_always_on = on;
> +	genpd_unlock(genpd);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(dev_pm_genpd_rpm_always_on);
> +
>  static int _genpd_power_on(struct generic_pm_domain *genpd, bool timed)
>  {
>  	unsigned int state_idx = genpd->state_idx;
> @@ -868,6 +899,10 @@ static int genpd_power_off(struct generic_pm_domain *genpd, bool one_dev_on,
>  		if (!pm_runtime_suspended(pdd->dev) ||
>  			irq_safe_dev_in_sleep_domain(pdd->dev, genpd))
>  			not_suspended++;
> +
> +		/* The device may need its PM domain to stay powered on. */
> +		if (to_gpd_data(pdd)->rpm_always_on)
> +			return -EBUSY;
>  	}
>  
>  	if (not_suspended > 1 || (not_suspended == 1 && !one_dev_on))
> diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
> index 1aab313..d56a78a 100644
> --- a/include/linux/pm_domain.h
> +++ b/include/linux/pm_domain.h
> @@ -261,6 +261,7 @@ struct generic_pm_domain_data {
>  	unsigned int rpm_pstate;
>  	unsigned int opp_token;
>  	bool hw_mode;
> +	bool rpm_always_on;
>  	void *data;
>  };
>  
> @@ -293,6 +294,7 @@ ktime_t dev_pm_genpd_get_next_hrtimer(struct device *dev);
>  void dev_pm_genpd_synced_poweroff(struct device *dev);
>  int dev_pm_genpd_set_hwmode(struct device *dev, bool enable);
>  bool dev_pm_genpd_get_hwmode(struct device *dev);
> +int dev_pm_genpd_rpm_always_on(struct device *dev, bool on);
>  
>  extern struct dev_power_governor simple_qos_governor;
>  extern struct dev_power_governor pm_domain_always_on_gov;
> @@ -376,6 +378,11 @@ static inline bool dev_pm_genpd_get_hwmode(struct device *dev)
>  	return false;
>  }
>  
> +static inline int dev_pm_genpd_rpm_always_on(struct device *dev, bool on)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>  #define simple_qos_governor		(*(struct dev_power_governor *)(NULL))
>  #define pm_domain_always_on_gov		(*(struct dev_power_governor *)(NULL))
>  #endif
> -- 
> 2.7.4
> 

-- 
மணிவண்ணன் சதாசிவம்

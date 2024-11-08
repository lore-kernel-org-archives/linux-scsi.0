Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B671E5000
	for <linux-scsi@vger.kernel.org>; Fri,  8 Nov 2024 14:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731075588; cv=none; b=iyaTHem5/g+FNzQ7q7T3OGAYDi7F/XMYRxLk5EOOlgCd+o8zob/DZgbZS+5Jy7vI0jGK0s+KMCa3ldFiQQzwe3w0+jL1HP81nyRIuaY4BKUkbl8sprEDaz4+HrJsAOqyC1S0ZZeqF0ZZPy/fjs5RnkM6xs32lsXWUaiu6giQMVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731075588; c=relaxed/simple;
	bh=ZLLRMH49n6WaYFzMYL7hdn+IuXPLKE4cMZuz6YX2Flw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=hYhIHex9rasQjIrYhySWrBvvrEufcsJIqVFmxsrM6fdnUaG6Sr6/HLrfSyflbaUIra2Di2FsaKKZScUoHe6XMqHmr1pClGjHIC623q1EeU6KDS3+cOrI9uFAvmGt17GG7Xr1uge9iVAz7aTfVL6HkKsLJXQoI0C3h2tXCgV1T9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dkSfIlzZ; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dkSfIlzZ"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5ceb03aaddeso2616010a12.2
        for <linux-scsi@vger.kernel.org>; Fri, 08 Nov 2024 06:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731075584; x=1731680384; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VGA9Y6BP3dpROBWYVYwafi2ecYshZ4WbiAsNU+E9Uq0=;
        b=dkSfIlzZ01tuUyCJu2Q/ceX4tVXfWxnQIXSJAiL+uxqLTewekRdBIFo8/qfK/gccZX
         w3YJA84ky8AnDTxm2w6A757YV7YhU19lT8/CX/4gGlhrATqdsotN/EI+HWFdTpPgp0u9
         RL12LsIzXLLbh4CifnLIoW6P49qsWPmLdRByDt4IMO2ZNnC8O90waHBTB5TN8k/GL/KU
         Th/X3JLD1mwX73RYNJhKK8tLxwfZ0w5yDB4pqboiWiEttVAE+AeRzU/Pk/RGdP3+tbYH
         fnYt4lVqdpLLVZfXkrTb2+KTl4NyZMiFCwgWo/F3EgokYIgJFcT5WCL7+tBFrwu9i8oB
         VL7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731075584; x=1731680384;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VGA9Y6BP3dpROBWYVYwafi2ecYshZ4WbiAsNU+E9Uq0=;
        b=aEp6q8PIdHK28BqWuTKNafkgmo5TjC25VL4u+1x398B3YdJcO8l7HAK4CUs05alyph
         wGHIeyC2k9U8V41JLwESSKhtxCbMg4sHjVfbpe+SsK+2KmHwiAK7XeZrLvaEJfHSDAiE
         kQJk82zNY+KBcYun5fbZOl1WpSWfYGIIsNcrHbEdN8aSapdpEQ4NnxP/MACOumQJ8dWh
         0+cvwsjEuGQGI5b2ApZY0nVftI/LfCP4BlcZT2B0NM56Ao6OlGF8yeGn1ng3+hWRQ00K
         UvyEjCwyKsLCzvKdn6iE4INiNzbMBtPIu8454GMmumrcMHA0i58uAmxXrhM2U5V1jzYY
         4WOw==
X-Forwarded-Encrypted: i=1; AJvYcCVyS7YKZ4zV2HjSCizTR6wIPdNKWh+4YBa/+eM63xqoEfqRlrtVuplrKhbiwuhM1i71WcUaTCyKE6UA@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+rNY2U0cqYjpGO1LQv7DeETaG0aNUp7zm9okbMJjQ1zVnRZ79
	Hv9dMMTInPstGB9AHyLA9y0sMyDR+fvWucBzLAG4xpEuXFOX9gnwtTbtM+gqI6M=
X-Google-Smtp-Source: AGHT+IHmXybQiAHW1OqbfUTN22sas0nIZd7gHqCAPHOaYdpQEeD0jrEFikAP+yhuHydY+dzM1edQDw==
X-Received: by 2002:a05:6402:d0d:b0:5ca:151a:b84c with SMTP id 4fb4d7f45d1cf-5cf0a320706mr2220233a12.18.1731075583567;
        Fri, 08 Nov 2024 06:19:43 -0800 (PST)
Received: from localhost ([154.14.63.34])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cf03bb765asm2025429a12.48.2024.11.08.06.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2024 06:19:43 -0800 (PST)
Date: Fri, 8 Nov 2024 17:19:41 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Shawn Lin <shawn.lin@rock-chips.com>,
	Rob Herring <robh+dt@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	"Rafael J . Wysocki" <rafael@kernel.org>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	YiFeng Zhao <zyf@rock-chips.com>, Liang Chen <cl@rock-chips.com>,
	linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org,
	devicetree@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v4 4/7] pmdomain: core: Introduce
 dev_pm_genpd_rpm_always_on()
Message-ID: <54ad5572-3ad6-4c8d-80cd-b2f975ad91bf@suswa.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1730705521-23081-5-git-send-email-shawn.lin@rock-chips.com>

Hi Shawn,

kernel test robot noticed the following build warnings:

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Shawn-Lin/dt-bindings-ufs-Document-Rockchip-UFS-host-controller/20241104-191810
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/1730705521-23081-5-git-send-email-shawn.lin%40rock-chips.com
patch subject: [PATCH v4 4/7] pmdomain: core: Introduce dev_pm_genpd_rpm_always_on()
config: loongarch-randconfig-r073-20241107 (https://download.01.org/0day-ci/archive/20241108/202411080432.5dWP6wRt-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 14.2.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202411080432.5dWP6wRt-lkp@intel.com/

New smatch warnings:
drivers/pmdomain/core.c:898 genpd_power_off() warn: curly braces intended?

vim +898 drivers/pmdomain/core.c

2da835452a08758 drivers/base/power/domain.c Ulf Hansson     2017-02-17  850  static int genpd_power_off(struct generic_pm_domain *genpd, bool one_dev_on,
2da835452a08758 drivers/base/power/domain.c Ulf Hansson     2017-02-17  851  			   unsigned int depth)
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  852  {
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  853  	struct pm_domain_data *pdd;
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  854  	struct gpd_link *link;
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  855  	unsigned int not_suspended = 0;
f63816e43d90442 drivers/base/power/domain.c Ulf Hansson     2020-09-24  856  	int ret;
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  857  
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  858  	/*
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  859  	 * Do not try to power off the domain in the following situations:
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  860  	 * (1) The domain is already in the "power off" state.
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  861  	 * (2) System suspend is in progress.
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  862  	 */
41e2c8e0060db25 drivers/base/power/domain.c Ulf Hansson     2017-03-20  863  	if (!genpd_status_on(genpd) || genpd->prepared_count > 0)
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  864  		return 0;
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  865  
ffaa42e8a40b7f1 drivers/base/power/domain.c Ulf Hansson     2017-03-20  866  	/*
ffaa42e8a40b7f1 drivers/base/power/domain.c Ulf Hansson     2017-03-20  867  	 * Abort power off for the PM domain in the following situations:
ffaa42e8a40b7f1 drivers/base/power/domain.c Ulf Hansson     2017-03-20  868  	 * (1) The domain is configured as always on.
ffaa42e8a40b7f1 drivers/base/power/domain.c Ulf Hansson     2017-03-20  869  	 * (2) When the domain has a subdomain being powered on.
ffaa42e8a40b7f1 drivers/base/power/domain.c Ulf Hansson     2017-03-20  870  	 */
ed61e18a4b4e445 drivers/base/power/domain.c Leonard Crestez 2019-04-30  871  	if (genpd_is_always_on(genpd) ||
ed61e18a4b4e445 drivers/base/power/domain.c Leonard Crestez 2019-04-30  872  			genpd_is_rpm_always_on(genpd) ||
ed61e18a4b4e445 drivers/base/power/domain.c Leonard Crestez 2019-04-30  873  			atomic_read(&genpd->sd_count) > 0)
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  874  		return -EBUSY;
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  875  
e7d90cfac5510f8 drivers/base/power/domain.c Ulf Hansson     2022-02-17  876  	/*
e7d90cfac5510f8 drivers/base/power/domain.c Ulf Hansson     2022-02-17  877  	 * The children must be in their deepest (powered-off) states to allow
e7d90cfac5510f8 drivers/base/power/domain.c Ulf Hansson     2022-02-17  878  	 * the parent to be powered off. Note that, there's no need for
e7d90cfac5510f8 drivers/base/power/domain.c Ulf Hansson     2022-02-17  879  	 * additional locking, as powering on a child, requires the parent's
e7d90cfac5510f8 drivers/base/power/domain.c Ulf Hansson     2022-02-17  880  	 * lock to be acquired first.
e7d90cfac5510f8 drivers/base/power/domain.c Ulf Hansson     2022-02-17  881  	 */
e7d90cfac5510f8 drivers/base/power/domain.c Ulf Hansson     2022-02-17  882  	list_for_each_entry(link, &genpd->parent_links, parent_node) {
e7d90cfac5510f8 drivers/base/power/domain.c Ulf Hansson     2022-02-17  883  		struct generic_pm_domain *child = link->child;
e7d90cfac5510f8 drivers/base/power/domain.c Ulf Hansson     2022-02-17  884  		if (child->state_idx < child->state_count - 1)
e7d90cfac5510f8 drivers/base/power/domain.c Ulf Hansson     2022-02-17  885  			return -EBUSY;
e7d90cfac5510f8 drivers/base/power/domain.c Ulf Hansson     2022-02-17  886  	}
e7d90cfac5510f8 drivers/base/power/domain.c Ulf Hansson     2022-02-17  887  
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  888  	list_for_each_entry(pdd, &genpd->dev_list, list_node) {
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  889  		/*
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  890  		 * Do not allow PM domain to be powered off, when an IRQ safe
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  891  		 * device is part of a non-IRQ safe domain.
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  892  		 */
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  893  		if (!pm_runtime_suspended(pdd->dev) ||
7a02444b8fc25ac drivers/base/power/domain.c Ulf Hansson     2022-05-11  894  			irq_safe_dev_in_sleep_domain(pdd->dev, genpd))

{

1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  895  			not_suspended++;
f0f6da10152fb8f drivers/pmdomain/core.c     Ulf Hansson     2024-11-04  896  
f0f6da10152fb8f drivers/pmdomain/core.c     Ulf Hansson     2024-11-04  897  			/* The device may need its PM domain to stay powered on. */
f0f6da10152fb8f drivers/pmdomain/core.c     Ulf Hansson     2024-11-04 @898  			if (to_gpd_data(pdd)->rpm_always_on)
f0f6da10152fb8f drivers/pmdomain/core.c     Ulf Hansson     2024-11-04  899  				return -EBUSY;

}

1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  900  	}
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  901  
3c64649d1cf9f32 drivers/base/power/domain.c Ulf Hansson     2017-02-17  902  	if (not_suspended > 1 || (not_suspended == 1 && !one_dev_on))
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  903  		return -EBUSY;
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  904  
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  905  	if (genpd->gov && genpd->gov->power_down_ok) {
1f8728b7adc4c2b drivers/base/power/domain.c Ulf Hansson     2017-02-17  906  		if (!genpd->gov->power_down_ok(&genpd->domain))

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


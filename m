Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601BE217651
	for <linux-scsi@vger.kernel.org>; Fri, 28 Mar 2025 10:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743156020; cv=none; b=G6HrBdsQIZdEhHQ2hkE2AavfPEaMeYCYlwysXt+uQxdKG5xQZ2hppGZLnc1iISVJI7tRGx5X2ouG0+C4rB7U/jzGlmmRH/dyHHH4OIllXW5ekErrwbDws9MqqJq4Jtp2nIrkinbiNQAmYDVXAB9s+ARPefaw/tGCeHWwbcMgYWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743156020; c=relaxed/simple;
	bh=VAxMnppZDd0EsjFlPAHPDvkheirt5PDlBP3XZemzIlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J9htAtb4yGUnd8HHCXsKbeDoBpvQEKb6CdWQgsc5HQPdVMN6olXvuw7AfUDiPdrMWGpHu5wnYk9kP1txOt3Oh7nxkLX8709DwBKWBh9CmaCw7JEsosE+xsJD4uAAMPr8XfJcecJEueAA7+hfwpbzUqJCjNq9Y9//2NvbWE/tgwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gRjdAwiz; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gRjdAwiz"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-39727fe912cso635707f8f.3
        for <linux-scsi@vger.kernel.org>; Fri, 28 Mar 2025 03:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743156016; x=1743760816; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uMHy4UXVXze7CguX+fTXXYQovkguTPZAbEfyyQdz7+s=;
        b=gRjdAwizbI2GB3mpJ0tuxllHhWl0gs/tAULTfZ2mfewHdZpDlIOeDma/iytqf1UzxN
         ocf+uk72V3eRFg4BWf5h9pgVtsojIXJMWaueALkbX53tK3GmFoW6C27xzQSrVGUSkQ3c
         NdU9FgGqxpTr8LluBHUXTwl6+jIuGlzWW+wB3vW1VHrQU2EhReQhMYiGigPb8Sx9itqp
         bq4jidTcD/JdMVKxBEiGUsmDFn1yFsAo3mooRgLvXEoM2niY+RO8KYvdnpvV5lpnNGGT
         KgkJGYqa+sZjGKKH/y+BUhty9ueYFPUr23INntKMp0GkHj0x+7rZ8RKoQ9SgSVKVuDaW
         sdcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743156016; x=1743760816;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uMHy4UXVXze7CguX+fTXXYQovkguTPZAbEfyyQdz7+s=;
        b=kv02yvs76X5bokp8BrLL9PEeUR72KtNsURhJrrm7KMo99frcQ7qVBnSeBFUjP+Dm+T
         ZLn102f+2IT4XPuE69cp3kcKAYF6Je1MJGK0o3H+eQqfyDWSwEBF4SyYQtvQGlmilmoc
         jooet7O0Lby1OcFWtkR3fSSW54PMyccmtusYxOBUYlRpp6k1b3xYgl3tgzUW/2LsJhg/
         mQtXuLQXfUeA/i1TKQFCp8cxMYQdTkAASyj3MhoLHmjqpT/6wiMITBYb/NMBG0nmypSJ
         Sp9ZdO8wv0j6UIqYhRuPOLqGij23yFnLyBJTxfdbC+qmI49GuRW5XLOdiyDJzmPFAJ1q
         mcgw==
X-Forwarded-Encrypted: i=1; AJvYcCUiek5MlmHGtdFHyKHNBvnmSeVo/w+sHmuGBV657WJvpysbI2kT6mLgXgp8hCTcUnslp4sglqsZg5pM@vger.kernel.org
X-Gm-Message-State: AOJu0YwGYhH8ceQeWxmKVs5fgA8VV1hSTI76RY3v9En33/k9TDEZfK/s
	BHUU5jxcgMioyuXCi4ORNHg6FL+uZWbUr8wjm0Q3VyDSCqb8RGoDEKdCQ7Coaks=
X-Gm-Gg: ASbGncvNnJebJHQmHNBJPe5yXguOIvwYzuohXKeCgw7OaVh9628md7H0Z6dIkcPpCFw
	MLjTw3FLk3C2On37dN4kvVF++f4CSmv2sDl346QyFozteLOgka6evySWWXb53TmoB7EXiwxbypU
	RH0g/qAQYU9i9q1zx21IYK0/hjkePxayRAPn0xSvX44F2vxUqXhSlMm7CkX1XXXeu3IqGr5tLqL
	UktTpWtmEk018+qw7g6O1s4LvOt5oRxm1x6nbbYzxFW4FZw2LXgWlIVVBNOk5BpL6UCEHYTLInN
	d+/OjtO2zo9CymuFlvSX++OrilZmjaCjzXLbqJ9xSZYoou5Va6Ybfeo7xA6R
X-Google-Smtp-Source: AGHT+IGj9pQvphUGd9QRvl74y+vh1brVfy4aIv4DoMY75sWkzHFUx8Bt1I9v28FP8We3YasMPehrOQ==
X-Received: by 2002:a05:6000:1fa9:b0:399:71d4:b8 with SMTP id ffacd0b85a97d-39ad17505efmr6306834f8f.23.1743156015550;
        Fri, 28 Mar 2025 03:00:15 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-43d8fccfe2fsm22243795e9.22.2025.03.28.03.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 03:00:15 -0700 (PDT)
Date: Fri, 28 Mar 2025 13:00:13 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
	Nishanth Menon <nm@ti.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dhruva Gole <d-gole@ti.com>, Tero Kristo <kristo@kernel.org>,
	Santosh Shilimkar <ssantosh@kernel.org>,
	Logan Gunthorpe <logang@deltatee.com>,
	Dave Jiang <dave.jiang@intel.com>, Jon Mason <jdmason@kudzu.us>,
	Allen Hubbe <allenbh@gmail.com>, ntb@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
	Michael Kelley <mhklinux@outlook.com>, Wei Liu <wei.liu@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	linux-hyperv@vger.kernel.org, Wei Huang <wei.huang2@amd.com>,
	Jonathan Cameron <Jonathan.Cameron@huwei.com>
Subject: Re: [patch V2 09/10] scsi: ufs: qcom: Remove the MSI descriptor abuse
Message-ID: <f0df759f-42b2-450c-90c6-25953093e244@stanley.mountain>
References: <20250313130212.450198939@linutronix.de>
 <20250313130321.963504017@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250313130321.963504017@linutronix.de>

On Thu, Mar 13, 2025 at 02:03:51PM +0100, Thomas Gleixner wrote:
> @@ -1799,8 +1803,7 @@ static irqreturn_t ufs_qcom_mcq_esi_hand
>  static int ufs_qcom_config_esi(struct ufs_hba *hba)
>  {
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> -	struct msi_desc *desc;
> -	struct msi_desc *failed_desc = NULL;
> +	struct ufs_qcom_irq *qi;
>  	int nr_irqs, ret;
>  
>  	if (host->esi_enabled)
> @@ -1811,47 +1814,47 @@ static int ufs_qcom_config_esi(struct uf
>  	 * 2. Poll queues do not need ESI.
>  	 */
>  	nr_irqs = hba->nr_hw_queues - hba->nr_queues[HCTX_TYPE_POLL];
> +	qi = devm_kcalloc(hba->dev, nr_irqs, sizeof(*qi), GFP_KERNEL);
> +	if (qi)

This NULL check is reversed.  Missing !.

regards,
dan carpenter

> +		return -ENOMEM;
> +
>  	ret = platform_device_msi_init_and_alloc_irqs(hba->dev, nr_irqs,
>  						      ufs_qcom_write_msi_msg);


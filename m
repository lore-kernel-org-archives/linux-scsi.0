Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2251D132C39
	for <linux-scsi@vger.kernel.org>; Wed, 17 Apr 2024 09:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713347534; cv=none; b=NhQ8sgiMLXt7u4FRxy5vzOKz26vjxFohJJcGtBDQ60Z9XDSMHaqR7tOeVTRBPt+lNXj08fVPqomfZS1UReBr5Gc3Nzw0O6N1R3YwVtwbR6IB+vQifskLm2z/x2CmeLSIrOW+2oFY9pFhJ8N6S8KPn1BASx+JpMazdVV1PiDwohY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713347534; c=relaxed/simple;
	bh=3X6WwNfAVR7FMkoaL54r/zUW5zJ1gH7cm4+/P1mg7j0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pwnn5iwvrRwjJpzDtaGJlHBquXpJBTlFta1VORI8zJxqyTNdOAVn1/1GrOp+QzjLRHWSOzhyLi0KVn4uzFgqnHi5sTr2iak2wK7XzHDripitdIPkYOiH3wP4wqV5DFPChKhb4ycNJDCHeeATHvOYuKKbBbNw5EWlA2fxdvMIkAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fGY39utO; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fGY39utO"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5708d8a773aso272638a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 17 Apr 2024 02:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713347531; x=1713952331; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5f5XU8CL1kg+VvVC0mF3oI+N9DcL6GD1pDu7yNmuO1Q=;
        b=fGY39utO6irKOll8izO+7MR1eqH1lbzYw2D+KRkJoY2GDZ1weRqAekMVOf0hw/bdXd
         PzHupGVCXJkwYGv1UpqG+56mMCXm+Cg0FLX/BHOP49/+P3UzNBlDJArd9RQlCRVczfRg
         zCXihgKHtNnRETbVT0LpeF5+pZ3WBuxNjhOJpZ5iJScAzOlWCSTIyRbF/G9Gt/uAqyBj
         Kyl8j2RUwiDAuiDPftEVv0g1ZDNlEJz4qEGCIubiZvQIYMIgw5aJwM0I4wwoTGjkO4Ny
         EbuHnLpmot0+NwjF7D5KxOtWFzrV3Xa3Nhar4+MWhPJDnEr3g0vYEMDIGFWf6hBHTUxc
         9XAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713347531; x=1713952331;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5f5XU8CL1kg+VvVC0mF3oI+N9DcL6GD1pDu7yNmuO1Q=;
        b=j5KmFX0YVNW9MfRibzD7lM1FUBDydPG3KBYkIhd+V7k8UfD8rS7s5L+KHwNdKISsIp
         ClKAO5sv+RdChm6vtMMfpT2ClmTuWoL/x4zD8m3AxYo08HpSxsEwBRCNGHpXu0YX+0VL
         P+qqvA4BKuK79iHoaXrv8ZFi2WpeWf+N/nPR+AijgElGDRtEu/Gof1QWT84iblARsLE3
         ykH+3A4m9jOompCTHxMm/eX8rr0RlSCm7stuSp42nRdlzrmrFlVzUo5lGNXXRT9nHIb8
         ny2ja6tefx6e6bepOKwxq6Mba1S6XHpKWJvM1BxbtBFqRFF+Y1Euc2o14oBjrSbxFO7M
         j4bg==
X-Forwarded-Encrypted: i=1; AJvYcCUXTVWGIYHwhvBVDEF9k8e47pU4RDJD7Pg/TIBUfbRQvvtMD0IHkNUufL4ua2FmtKJCSsXf6p6JL3pDLpxaIPBQC3iMQMvmE8Fc1g==
X-Gm-Message-State: AOJu0Ywh0vnvD/HqC8BdZmXu57N0JZabIkUep2kvJMXdNMmzw8Ujpe3H
	vp2+Fi+ioKRFm+SEXbhq8r6UK87I1F1yupTgjFnCuEEKBNMQzBR8g2/F2lNzLq4=
X-Google-Smtp-Source: AGHT+IEYPrQEauvIgRMeVjGwsmiUGzuIZo8hcH8ym7d63O1kdjEGb0XdYaDBVBXRGhRdHQrpHYNOWg==
X-Received: by 2002:a17:907:7d91:b0:a54:1c55:7123 with SMTP id oz17-20020a1709077d9100b00a541c557123mr5905226ejc.73.1713347531118;
        Wed, 17 Apr 2024 02:52:11 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id t6-20020a1709067c0600b00a5229c51077sm7414958ejo.9.2024.04.17.02.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 02:52:10 -0700 (PDT)
Date: Wed, 17 Apr 2024 12:52:07 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: mturquette@baylibre.com, sboyd@kernel.org, robh@kernel.org,
	krzk+dt@kernel.org, conor+dt@kernel.org, vkoul@kernel.org,
	kishon@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
	bvanassche@acm.org, s.nawrocki@samsung.com, cw00.choi@samsung.com,
	jejb@linux.ibm.com, martin.petersen@oracle.com,
	chanho61.park@samsung.com, ebiggers@kernel.org,
	linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org,
	devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, tudor.ambarus@linaro.org,
	andre.draszik@linaro.org, saravanak@google.com,
	willmcvicker@google.com
Subject: Re: [PATCH 10/17] phy: samsung-ufs: ufs: Add SoC callbacks for
 calibration and clk data recovery
Message-ID: <75b1b063-e8d4-417d-99a8-4320d72297cf@moroto.mountain>
References: <20240404122559.898930-1-peter.griffin@linaro.org>
 <20240404122559.898930-11-peter.griffin@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240404122559.898930-11-peter.griffin@linaro.org>

On Thu, Apr 04, 2024 at 01:25:52PM +0100, Peter Griffin wrote:
> diff --git a/drivers/phy/samsung/phy-samsung-ufs.c b/drivers/phy/samsung/phy-samsung-ufs.c
> index c567efafc30f..f57a2f2a415d 100644
> --- a/drivers/phy/samsung/phy-samsung-ufs.c
> +++ b/drivers/phy/samsung/phy-samsung-ufs.c
> @@ -46,7 +46,7 @@ static void samsung_ufs_phy_config(struct samsung_ufs_phy *phy,
>  	}
>  }
>  
> -static int samsung_ufs_phy_wait_for_lock_acq(struct phy *phy)
> +int samsung_ufs_phy_wait_for_lock_acq(struct phy *phy, u8 lane)
>  {
>  	struct samsung_ufs_phy *ufs_phy = get_samsung_ufs_phy(phy);
>  	const unsigned int timeout_us = 100000;
> @@ -98,8 +98,15 @@ static int samsung_ufs_phy_calibrate(struct phy *phy)
>  		}
>  	}
>  
> -	if (ufs_phy->ufs_phy_state == CFG_POST_PWR_HS)
> -		err = samsung_ufs_phy_wait_for_lock_acq(phy);
> +	for_each_phy_lane(ufs_phy, i) {
> +		if (ufs_phy->ufs_phy_state == CFG_PRE_INIT &&
> +		    ufs_phy->drvdata->wait_for_cal)
> +			err = ufs_phy->drvdata->wait_for_cal(phy, i);
> +
> +		if (ufs_phy->ufs_phy_state == CFG_POST_PWR_HS &&
> +		    ufs_phy->drvdata->wait_for_cdr)
> +			err = ufs_phy->drvdata->wait_for_cdr(phy, i);

The "err" value is only preserved from the last iteration in this loop.

regards,
dan carpenter

> +	}
>  
>  	/**
>  	 * In Samsung ufshci, PHY need to be calibrated at different


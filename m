Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0071E50B
	for <linux-scsi@vger.kernel.org>; Sun, 22 Jun 2025 19:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750620260; cv=none; b=cSb7W1ZxjqtVlK8QsvMxZ9WlYZtNOYEAVJbg659oSDmyxBkL8a8E96ygLjcjnRkLDdaye8pqcF2uIf2PGQWl+ICjfuyuywov2XVdUaoRpJ7OujC/QzxisMRjqFQ7TrwxhN22DViCIDJAWcdXQrHkTHkxRxxuUge/wRtSOEO8Ne0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750620260; c=relaxed/simple;
	bh=aFEOGwXZo/AwrY6Y2o0qz0Ly30CX2ZmBavksQY0KkfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gGbCl2HoVtGZnF1/Eh4RXzLTviihxa7ERNvZhSszanKxG7lzfY0niWop8fjQmKSfVYsrL74lekwDpaSmROyNDPK3hTl7h499ouit8Y+Rj+AwcgNgV0y+0D6hAdHAYnTC+7559UpQNK93E0fF9pm2xKOkTSVzYN+z8tF7mkGEE84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PINn/ZXA; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PINn/ZXA"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6070293103cso6519555a12.0
        for <linux-scsi@vger.kernel.org>; Sun, 22 Jun 2025 12:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750620256; x=1751225056; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IbjF/h91o8sYLkOV/LaCb7h1OWB7p+JRyaYdcedZZEg=;
        b=PINn/ZXASV6NRr9eUbnV9su3fYt84qChXDvb6c2qib//pX7/ujeHVIe63Y5bMt7rcP
         4B63u0K9fmLktGy4K4voyOnjVRlLpv9ivloks1MdqO2ru3rOMg3MTfHWika8Yw3G5WG+
         8pL4YNLQfRky8aOZy9KpwzJYpzSZDlZznUzWEgmm0b8bvgB/SmNBPyu8XODrg1b315sr
         xGrVokMG6LA8We6r+VVeXWtnLfKX0f18YTS1olN58rvqUijO7wF8XBhcw0ikM8A41EPg
         gDKvsUuPeVWPA3M6GUy8QluPeRb4X9BE7nyZh3f02p+8dl6exNMqt01d82VL5ESgCUl1
         LO4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750620256; x=1751225056;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IbjF/h91o8sYLkOV/LaCb7h1OWB7p+JRyaYdcedZZEg=;
        b=tQ/l/gYVHd6ML3aCLhdh/FI9P0QpMgptLPJkeouiLsrtOXEoLyfZnpcVrW6tCKYhGr
         kILmcIj+U9TaMKLA8q5QtzKIF4UJyoupnISCaQBxwSIVwyDSjAlTAIKlClzYNG1F7W36
         kBzVf0Vqas3vKJT3c8yGOBUgoqAeenHILyoKqjjXO/We6D8PaXDkypdE7cXUNlDBknxH
         zlsF1efEkLh/fRUwjMvs60xzuGesbrgOzdO3Z5rTZCa6Zl7vUS0y7BkrPgghwuYQdJQy
         3SGOayoiqvPr8HWVP+Pqf6t0I7X7XkFoS3pnxpwq0HYlKwQYGuXX1WopNc6TntuDOLVN
         7gRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVo43ZibdtZ+ATlT8oGpv8nVM/AH7UVCcRv1b1rl67bscwAflmVBHGp39UXCA88hlcy99D0qxdmukXh@vger.kernel.org
X-Gm-Message-State: AOJu0Yxgpx7mGv1jZYZDASH+yWQTvt9ir8GTz0IAuO2ScmnGZ6nV4HOV
	QRDTVEnNJ3ijloP+ZtgUrt1W5jKXnXhp6lf6N4AUn45Yr1rcB4J8l3TVqLWiy3KoO/U=
X-Gm-Gg: ASbGncvrb6luKa+26veeElBdU6UifY/mu29/xQhOayWxI2heREbF4WYz0dNNByQuvdL
	EiIfffJO1l6gbyVthE2B0UoeTTAllDyLMDl32+0AV4Sn/j8zg3gTudJgzHd7hLfqzw6taD8nREz
	If5ZKRPVPyFAvyxwjYcNNoBaDp9+/oPZtFXbUwGJmwztmng1TKOyqEP1oWSgKlu+T/Xtd5DZJDh
	FDbpn/jFoOS23iEdcMu7XbulEHSB2pgkdy0GG7Oeb4tPJDsG+cAeEU4ISjrcu6Mrsg8TOG6jhXG
	sBVateiE9VzClNXrOGXOLWtsPgLoqH5/ELbYcUQJqbPMob76nJyUgEs4TvM=
X-Google-Smtp-Source: AGHT+IHnoYTbMPh1mNJsjdl28NGezTFEyAyfF+x9j3rQX5TVC51X/4ITVYOLyUMfiFovN1yLap6AKQ==
X-Received: by 2002:a17:906:9f8a:b0:adb:43d0:aedb with SMTP id a640c23a62f3a-ae057fa74c6mr937853066b.61.1750620256156;
        Sun, 22 Jun 2025 12:24:16 -0700 (PDT)
Received: from linaro.org ([82.79.186.23])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae053e8218bsm577845166b.4.2025.06.22.12.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jun 2025 12:24:15 -0700 (PDT)
Date: Sun, 22 Jun 2025 22:24:13 +0300
From: Abel Vesa <abel.vesa@linaro.org>
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: vkoul@kernel.org, kishon@kernel.org, manivannan.sadhasivam@linaro.org,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	bvanassche@acm.org, andersson@kernel.org, neil.armstrong@linaro.org,
	konrad.dybcio@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com,
	quic_rdwivedi@quicinc.com, quic_cang@quicinc.com,
	linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V6 02/10] scsi: ufs: qcom: add a new phy calibrate API
 call
Message-ID: <aFhYXfBMRMluXgdv@linaro.org>
References: <20250526153821.7918-1-quic_nitirawa@quicinc.com>
 <20250526153821.7918-3-quic_nitirawa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250526153821.7918-3-quic_nitirawa@quicinc.com>

On 25-05-26 21:08:13, Nitin Rawat wrote:
> Introduce a new phy calibrate API call in the UFS Qualcomm driver to
> separate phy calibration from phy power-on. This change is a precursor
> to the successive commits in this series, which requires these two
> operations to be distinct.
> 
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>

Reviewed-by: Abel Vesa <abel.vesa@linaro.org>

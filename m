Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B473F8289E
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2024 05:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723786120; cv=none; b=EWidM4y8Ap9Vk7TS2kkkGwNarowsGLfnL9v1nqZgfDNUP65BMd4PpqQYTjx3lK1hZhfYJr8OjrMM4HfGM3TDNOdENYj6/X9seH2AIzbp/ctSFs8VB4NumvA2eW7SGJKUSOAIQyo0QfFNGWqnNnNlJLOhi3WwEu+HxombRmrEjIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723786120; c=relaxed/simple;
	bh=CVgyyW45hqKlKWSJtD9mWkFJqSEYWC96cjYmVWtoD4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MzeRxq0WCcBZT+XBcdQYEB8YfJP384nWWX9nPM7rPsVYmhYSoGO20SG30gs8Lu4iatbH0wMEgQmdnxmX4u2i++Q/JeX5kJTeEf5s8+ixfKBlPmuMyFuBcsam61aScAkFO0hE0E5e9JxqHR+n4Bsy7985o6BhI/hNVIBuDdgxyik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Rpk9rTkH; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Rpk9rTkH"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-70eae5896bcso1454068b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 15 Aug 2024 22:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723786118; x=1724390918; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HjZ4i2QLY2MCZUTKrXk0L2WJ9ATcFb1xvQJ16nAWgPU=;
        b=Rpk9rTkHkfDWBw9ANRoJmFBPA1SiQO/sIwfIM5KjzGhfd/F3SyO8OY9AYC74q5r8GC
         Zxi0l/jNcB0pIyPkxhFlAVaki/xQWM+Ws6mYZ8uh5evqI+Ez/URAbapQMg2jhkkR2IEf
         QpMamo0fcz3yJI6p7iSXHCX9s09ot/6vM/OzSVNnZaFpzfiW3wr6TfeBsIBpaKgk0UWh
         bcx0A6wrL1bhkpJ/uFHlKOZ/9dDsJ70mfaV+qOlQZm4OVA0RNuD1BkZh640/qMHGQrAP
         as0zFafFBr+iV9xU7oWjoFmTJHC5OBsKjrSWZUFla2CzCX2Fc1tiRXOpiBpWuMQ/LkYg
         +ttA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723786118; x=1724390918;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HjZ4i2QLY2MCZUTKrXk0L2WJ9ATcFb1xvQJ16nAWgPU=;
        b=jP434g17Hanbyte+OGCIpIlehfVQiRlr/sxFb4rsONkSRyQKs94aVLoeWF8eE66a57
         /gMg1T6FYnnjZqqmBMzkcKDgB1KjOTx3UOoULMAzZ3tO58NnJ3YGuE0tgcXW9NMIZKiZ
         nAGo/+QaUgjaNqHxYSz9aLEnVeC/pT71kJvB4BlWzsE4wRDFnFScx0lQztIZ8aMlV6xM
         7WsIoJLJpRuqcu04TTHCxAWd0I4ajguJU9Io8Y2QMhP6CdbVJ+jjctvbWaAV7Eci72Ib
         pRx+Hm2v1UsVsSo8hv1enBWjBvxdZim83s3JaXLlWjLY3VZXUEyalIoGmeF99izJLFKH
         SBSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTv7mkAExAYyyaZQeDOQK2aUC7VHAoPFyTKEmB8L0gzKmSI25K8TsOsvBf/K2MIUdhXRwnQ3U8zB+0rKMwSS0zmNGlbdtRTqV8fQ==
X-Gm-Message-State: AOJu0YwDFqQEsCF0vP2H3g0vIB+dbOFdejruVa+9hzlrtMN18lZ3+fbf
	8L/UOYZr9CetF3sLqcv/CFk09TSpFm94otoSVeCCAUHnT6TpKJzdpfBvC7xVmw==
X-Google-Smtp-Source: AGHT+IGG47xUshJiY1c6p/0b3IHMBPociHpJXS5YR2Dk8ppi8J/QwruzB8NXPo12pRISFhAwDv1BBw==
X-Received: by 2002:a05:6a21:3998:b0:1c2:a0b2:e69 with SMTP id adf61e73a8af0-1c90501bd2fmr2157398637.33.1723786118061;
        Thu, 15 Aug 2024 22:28:38 -0700 (PDT)
Received: from thinkpad ([36.255.17.34])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f039e084sm18407175ad.243.2024.08.15.22.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 22:28:37 -0700 (PDT)
Date: Fri, 16 Aug 2024 10:58:32 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, Kyoungrul Kim <k831.kim@samsung.com>,
	Amit Pundir <amit.pundir@linaro.org>
Subject: Re: [PATCH v2 3/3] ufs: qcom: Add UFSHCD_QUIRK_BROKEN_LSDBS_CAP for
 SM8550 SoC
Message-ID: <20240816052832.GD2331@thinkpad>
References: <20240815-ufs-bug-fix-v2-0-b373afae888f@linaro.org>
 <20240815-ufs-bug-fix-v2-3-b373afae888f@linaro.org>
 <4b24453a-3f4e-4707-8c3a-2dbb0040281d@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4b24453a-3f4e-4707-8c3a-2dbb0040281d@acm.org>

On Thu, Aug 15, 2024 at 11:01:47AM -0700, Bart Van Assche wrote:
> On 8/14/24 10:16 PM, Manivannan Sadhasivam via B4 Relay wrote:
> > From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > 
> > SM8550 SoC supports the UFSHCI 3.0 spec, but it reports a bogus value of
> > 1 in the reserved 'Legacy Queue & Single Doorbell Support (LSDBS)' field of
> > the Controller Capabilities register. This field is supposed to read 0 as
> > per the spec.
> > 
> > But starting with commit 0c60eb0cc320 ("scsi: ufs: core: Check LSDBS cap
> > when !mcq"), ufshcd driver is now relying on the LSDBS field to decide when
> > to use the legacy doorbell mode if MCQ is not supported. And this ends up
> > breaking UFS on SM8550:
> > 
> > ufshcd-qcom 1d84000.ufs: ufshcd_init: failed to initialize (legacy doorbell mode not supported)
> > ufshcd-qcom 1d84000.ufs: error -EINVAL: Initialization failed with error -22
> > 
> > So use the UFSHCD_QUIRK_BROKEN_LSDBS_CAP quirk for SM8550 SoC so that the
> > ufshcd driver could use legacy doorbell mode correctly.
> > 
> > Fixes: 0c60eb0cc320 ("scsi: ufs: core: Check LSDBS cap when !mcq")
> 
> Since this patch depends on the previous two patches, the previous two
> patches probably need a "Cc: stable" tag. Otherwise the stable
> maintainers will have a hard time figuring out which patches this patch
> depends on.
> 

Well, I have not CCed stable list for this patch intentionally as the offending
commit got merged in v6.11-rc2. So there is no need of backport. Once this
series gets merged into one of the v6.11-rcS, all will be good.

> Since this patch by itself looks good to me:
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> 

Thanks!

- Mani

-- 
மணிவண்ணன் சதாசிவம்

Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB301D3578
	for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 09:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730281155; cv=none; b=XJa0D0FBJkEbgsylm+3TLvfqP7DOE4TgLJi9n0pOgeaBccjFxZB/IeWJTwV8kXrdTjyNjWx8TAz8GSqr147tH9AeCc80ThZ51WIlS/zHsy8Kz9v9auWq6baKMQvOeywnO/X7g14ikzJNo4rL7HRhWBjFDF8iUpo97yFuuJMKfFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730281155; c=relaxed/simple;
	bh=gExNcjrUtvag1nDOnOiDLd7cvI4wjdQFmT0fqwMb11A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BrmqY4qvTH9HNtwSCAbW/uZGVp5x5BwbdpwypbEDnT3GHgZnAu7sS7hZPNmXl8f/SnBAryfy2ADDZVrD+r/MTBc/zKHKKWyb8Mbi+skKN7FECR2TZyoQphJqwzrbzg5jQ4WKgjRIHKNMUiadj/470hJumKMM5tkV8VG1A8g57Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hrcTSY4P; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hrcTSY4P"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-37d4d1b48f3so4642257f8f.1
        for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 02:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730281152; x=1730885952; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gExNcjrUtvag1nDOnOiDLd7cvI4wjdQFmT0fqwMb11A=;
        b=hrcTSY4P0PsxcOUusUi/CL6E//NGAce1CbDjPrQIjROhXQ2FL9WPCLRNiUK9lkp1xi
         ZJ6M9pDLtAeeJxwE4H2ONZeaK0LjriLWHFKpk7L2rvSjYUhYb19PkzP7+5ipllozolKU
         wU2/7h6HQrXRIXyF2qrWSMOijWeyENbtMjndskfwByOOEh2/QsGiEk6J0tGNciatYjh0
         DOGleFq3eIGYYGSc5V8MgPawUAr7Rkumsw7peggkFuNA6gzqtNXIJYdZRpz4AcE3xk3L
         LqVzPJEwpCqadtuCoe4V6iqtqqsWcEpx901Fvt6YtMPOuCbCKwrxePuaKlpw6Nv7GPVS
         LgdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730281152; x=1730885952;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gExNcjrUtvag1nDOnOiDLd7cvI4wjdQFmT0fqwMb11A=;
        b=evPzFiZ2zoNxLvLKCbGSst64oKakXSiMUqBmIFALM6u9bPgQkCZdEtdASdSbqTPg/Z
         Uv9hLtWpVR3MEfucaPdaNcQ551hhj0/urUX0N7t1g6cT7PLMBgde3t9IWb2AIUyjCh/X
         o+6LRXHnNCSQZboIIv7t50udkvxz1DPBtryv88dvlp/untu00OOsiBTQmt9jsKO4A8ez
         MYPsQ2NiY4l9ZVMO5ubrW3ZvPfxs1RZdnBiJdNH2Q7CYy8jcxShTMarhdTuyYGmidk8A
         PcRSo8C77TjrGvU2X54pdBHhOEV+cjAcq/tfpozQvwveSJiFoIlEZvPtIP1voHTYJoJ3
         xBYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHOJLzfkrMowTSc6I8ccuJGk3nbt+jcldxpgY3MfaH+VCGbvVL90ljlIPxCy48I5zjEM7EGx9lgF11@vger.kernel.org
X-Gm-Message-State: AOJu0Yww4g74ra5TszQfBn7LGC/HHR+4e3uohMSwjAExVjU5jnsVSfpY
	PQUw6HYOGDhyKgf56BtqbRP0HaAg8ujseeXGazs7Cy/lUqG2utyiutcLmuVkxus=
X-Google-Smtp-Source: AGHT+IE32/QWwJxt5SXFpIYLSDpj6WX3oAgieA0BND3K1CgVJXvPCDBSisVF5SvFS5ZZDNzolgjR8w==
X-Received: by 2002:adf:ec4f:0:b0:374:c614:73df with SMTP id ffacd0b85a97d-381b710f3f4mr1868603f8f.57.1730281152021;
        Wed, 30 Oct 2024 02:39:12 -0700 (PDT)
Received: from [192.168.0.157] ([79.115.63.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b70c44sm14816858f8f.80.2024.10.30.02.39.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2024 02:39:11 -0700 (PDT)
Message-ID: <430e6dfd-4a7d-44d9-9dd6-64d99c8bc91e@linaro.org>
Date: Wed, 30 Oct 2024 09:39:09 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/11] scsi: ufs: exynos: remove tx_dif_p_nsec from
 exynosauto_ufs_drv_init()
To: Peter Griffin <peter.griffin@linaro.org>, alim.akhtar@samsung.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 avri.altman@wdc.com, bvanassche@acm.org, krzk@kernel.org
Cc: andre.draszik@linaro.org, kernel-team@android.com,
 willmcvicker@google.com, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
 ebiggers@kernel.org
References: <20241025131442.112862-1-peter.griffin@linaro.org>
 <20241025131442.112862-7-peter.griffin@linaro.org>
Content-Language: en-US
From: Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <20241025131442.112862-7-peter.griffin@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/25/24 2:14 PM, Peter Griffin wrote:
> Firstly exynosauto sets EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR so setting

exynosauto and gs101, the users of exynosauto_ufs_drv_init().

> tx_dif_p_nsec has no effect.

Both set EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR, the conclusion is correct
for gs101 as well.

With this addressed:
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>

nitpick/personal preference: I wouldn't use the commit body as a
continuation of the subject. I would specify what the commit does in the
body as well. No need to address.

Also, as a side note, I thought of removing tx_dif_p_nsec from
exynos7_uic_attr, but it seems that this struct is used by
exynos_ufs_drvs as well, which don't set
EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR. That's a little confusing, I guess
it's more clear if each driver has its own required settings specified.

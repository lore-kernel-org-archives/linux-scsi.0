Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCC913B791
	for <linux-scsi@vger.kernel.org>; Sun,  3 Nov 2024 06:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730617078; cv=none; b=MOd0wcX7CfHT91D0yERB1QMVEHLQZ6ST6TmjRb+zKEvf0gtX33VeiFmVRNGwRLwZ9UL7op44uJ4a/KW52ueGllR4EKqEuHQasbk9vMgFJKVKhghA76KEBpq2FgtuaEd188X7fhisV2Ix4PmaK12Y4lz29EmIJjz9g40ogZ+M7u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730617078; c=relaxed/simple;
	bh=7np/I76LHj5RuluQ3/YJmSLHvUBqTcAuqIlQuP1knkY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tru/umcUrSqhffo6FSfKhiQ+MlFo8Gr2hg7kpkD/Uz29f/7HfehQtOzzcuJexavaxg7Wm2nAx0SzFWEMECDqlj4qQ404uRvpVBHbKDqzvyxrEOkUAha8eF1V48aEZWdR2D6eZTzey+i9Fo6KwZUgoWkWe1JSmH887jHrgN/qNJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XhlX8Cb9; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XhlX8Cb9"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-5e7e1320cabso1403475eaf.0
        for <linux-scsi@vger.kernel.org>; Sat, 02 Nov 2024 23:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730617076; x=1731221876; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fS1npImPfHb20Sl7e7er9IvRC0E477hQsJ+7VA0CBuE=;
        b=XhlX8Cb9hPa+D2zxSnv7jpB3Tl2BKh1SKouaL2nLzFZTxeKhPmqhId+PkOctHfayQ8
         ESxGOk6Jg6Td5ZdA2qjJYEk11i1wOeOuw+7px3B4MQ/BkMYYgA5McHeHSbyIPFwDd+Fl
         mvvrmgPTSYuebUCSC/daNHojBdNUDFpKbNkaFUQU8yRF9IWcCpQ7Y8aGJ55KYcySH487
         dK1Scwzhx5yYDmLPU6m9KQPW567lxShgFRuET3krYxbYWCOZnYQI6UX7n/l2PAk5XCZH
         g1ccHc+tfnnHBhgpIcNBft0bgB/IcdKf6IvNjOzGENu1HypNWxMYfKobXxF0HBAiqTav
         x1WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730617076; x=1731221876;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fS1npImPfHb20Sl7e7er9IvRC0E477hQsJ+7VA0CBuE=;
        b=RdddUs8x6UstyRuX1Pq1Nkxj7pCoIBvw4AgFgH2CtPn0B/KOw987e3dP9EnQJSxRyF
         Ms4ZvkdLTc2VX4DVPpJkr+m/Fo1PhDfTy4poGaVwvzSRF1rU06IbwkJvvycXthb52+8Q
         uL+0mOOFoobkhKGPwIetEg/2EfsZoA2LvKPs1imzS+wG09s+UB+FlhDcScDu95jtSCmN
         f8t9DYWMwSBxZtKbF5NK+Xe5JkcjBxj/pTmDHkVitHTMJ7jSk2FNGxAV03/UQW1YGRgl
         6mHhP73eetVMdyEgLNBSrhwQYQYOjk4/KjeQhtH/ITXVfyPkpDHNN7mBdZo3jjOMLvDU
         IYkA==
X-Forwarded-Encrypted: i=1; AJvYcCVEa1ckpTqwAG3hL2GITfHqXoH8pEwWc+wdRwP6pHgbbLXsmX4IE81DIMSo0mGjWWKF4Z24r2ghUK5y@vger.kernel.org
X-Gm-Message-State: AOJu0YzcYeh1dxaTPvKsdQ0KaZHp7sKT2C17uY26F3xJICfiYZm6UfKW
	VpV5iK/JGaCMdanX2LXtPKagzVsrvl4aiv0nRpq58gzooRAynFL1A8uv5M5iFiwg14L0U/IGZ//
	PYtxPspSyRLjmBqD13ChJJVv0OY6cm0A75T4jjg==
X-Google-Smtp-Source: AGHT+IE+q1rK+3oCKtp9SkJcnFzCrL9vfkFECGy5BIRlaiafb9OMt6z17EkSsb1RPUubkyZ3F6wWlfWwl558mwfUioY=
X-Received: by 2002:a05:6871:c707:b0:28f:329e:9f23 with SMTP id
 586e51a60fabf-2949f07cb9emr7517716fac.42.1730617075872; Sat, 02 Nov 2024
 23:57:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241031150033.3440894-1-peter.griffin@linaro.org> <yq1wmhl6rp8.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1wmhl6rp8.fsf@ca-mkp.ca.oracle.com>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Sun, 3 Nov 2024 06:57:45 +0000
Message-ID: <CADrjBPp9-ucYgztdRNP81FfY0h+1s7N=LEPS2Ny=D2Vh2HsWYw@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] UFS cleanups and enhancements to ufs-exynos for gs101
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: alim.akhtar@samsung.com, James.Bottomley@hansenpartnership.com, 
	avri.altman@wdc.com, bvanassche@acm.org, krzk@kernel.org, 
	tudor.ambarus@linaro.org, ebiggers@kernel.org, andre.draszik@linaro.org, 
	kernel-team@android.com, willmcvicker@google.com, linux-scsi@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Martin,

On Sun, 3 Nov 2024 at 01:36, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Peter,
>
> > This series provides a few cleanups, bug fixes and feature
> > enhancements for the ufs-exynos driver, particularly for gs101 SoC.
>
> Patches 1 and 2 were missing your SoB tags. I took the liberty of adding
> these instead of having you resubmit. Please acknowledge that these two
> patches should have your SoB.

Yes those 2 patches should have my SoB, that was an oversight on my
part.  Thanks for fixing it :)

Peter

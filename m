Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E56412C06
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 07:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787039968; cv=none; b=hrbmm//9eoIbPa8Skjg4bV2/1kx3aWK2FFzBqUUs0RYhow0TWbmAQv2+LVag82gkc4JN2Do9LjAWMejRUV9o/PojZZ7B/91ehrr1vDXFQzFYNnzkyy24RGZ8j4gA32f7SxIdY9dWTcbMkPcXyh4Q50nnDvs99beCTqNhXffzyYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787039968; c=relaxed/simple;
	bh=YFU3Pxe6gZ6OmY9pTLdPdTUYsy1M0azynELZsCUa+Fg=;
	h=Subject:To:References:Cc:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=MakM2/tPsGSaax+CaQfgXrGqIRKzenoxqJfHAc0dwpQWau/8LrWDEUPdMlUon2VafUDmLUeLGwMvFxKetqDWoht92Q3pNukMfOyNjmWRS92uYECffsgR34/h/MnR32+w7x7Bj2uB95cbCjzbRwBKJOJuljMGPL8NLL2ZtLCcAfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P7dgyZfT; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P7dgyZfT"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-848743155bcso1387404b3a.0
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 00:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787039966; x=1787644766; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:mime-version
         :user-agent:date:message-id:from:cc:references:to:subject:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ZchxzJNZlCmLlQz1ZrVBz9XS0KwQdc7Hx8gtAKmig1U=;
        b=P7dgyZfTD9GVADMHvqAZ8j+fnkz+ifDlE7Q12aNpZk0SeBxlrTd2Dgj+nX+CanPwq+
         Rm44yrvbOr2rLWLaXPtytRfdhuMFl7/WK8EZ0DdWvylc+d/e7O5iU4cvA4LsqZVb7qEI
         kFBJJm458Sw0hDXkfr+7Dbb+ymsr1Yi8DxkBQgzHi0eLYa70nLzaF63rv6V8BlqhsXEI
         kE963PsjGQuY/k59nbBzkz8oldgKXR/HMUzlwWPIGxakDL7uDx6td3zGehXlY3ii/pjw
         YQEGX8gszGsTV+7TeBJhCt1geDQlg/Vm299Q5ryXCXJ2JoQv1/ymgTas4pczvtB/Iam4
         KDjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787039966; x=1787644766;
        h=content-transfer-encoding:content-type:in-reply-to:mime-version
         :user-agent:date:message-id:from:cc:references:to:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZchxzJNZlCmLlQz1ZrVBz9XS0KwQdc7Hx8gtAKmig1U=;
        b=mV95RzkENQV+mMa0SSvO4hVPJlyVO1XL0j3C6LnrI/ReJdNgPxXI2dDLQt7tjol8T1
         24V3xh+k6h8R9p4obRDGpmFDwMD+3YTCiky+xJ9hN1oPNkjkGzgsAYV3NARaYM4Po2i7
         ITpR4+Vl3iqRl9fMMdOeGqGrV1wE0wsLSpUJ015EECHcvvQvUMOHpW/DvkeogLw/zKXL
         aMvAktReOcSAw4mRKOIfWZx7O3YbECVG6f6bpsuVqs7gAVlmtPmM4ZYM8rwYgiryPEfA
         vzfgf0ZiZzcZtBbbomwVB84ODxWyPcP1sQ5WHFtuzGbKJpubUhm0NZpG9XdQJDVZ6ouK
         d9jg==
X-Forwarded-Encrypted: i=1; AHgh+Robdal5T30zEoAAgMTYnJeEQaE5Mml/8S7/KPjkC+f4W+Zq2bNpD5IhCUO5n1lXgx279k4YkxcixXFI@vger.kernel.org
X-Gm-Message-State: AOJu0Yxo6D/NGHdMO7GL72cabxdCPBdje8d6jjLB6eo6RqstAzTtGzf4
	9G7GPf/XEdXCpy6GNpxiLuCJRKMhI0RsA5lHfvpZ1lvA16PGd1/smTobA41FPA==
X-Gm-Gg: AR+sD12wv0Oq/XEDRH6m801naBnLS/Qj0iJ+VeOslTOHc6oaUOJ6AZ7BJpBH5dJ50nF
	0xKiqlsWntdbOSyTmXIOlLKjrtYSs8rcyZXQhDXinPW+pVm8xFwur9w3qXZF/1n4HuArp4pnKN3
	CfhTfb7XRk4VmvqVZ/CBVD3ul14Fe8kX9pknDTEZBskRs6s6P+9MGJxe5nQS+jW9zazEe/RXTym
	6uugxbBYtOoqCYC/XljeVWwfZ+mK4eSEP/ypX2cIITTPK8J5mzFmTs8MpyhlP4r1oJs/qcHq7kg
	FxRovP99WP5CeM+kUMpuysg5sVeC8mGc8QyC76aaIgA2/ZOpx63uf+BxsvD5b9jI5Wntd0a3eAW
	EAAzdHfQr6FwRYEF2X55clLXAV56qXfrV64CTVXiKSUR4MPQI+uvo8PtWAEKqBSLOrN/imZjGDx
	2tmrvhKjBMIurkgTM+3BjQppAvvKdWc/7cJ/LtZcu8VgtrLRrFNlgF6CiswodouQ+zSsH9giCk+
	DtTcBu4Zh/PwzdcJQMJsb37
X-Received: by 2002:a05:6a00:428e:b0:848:8445:6956 with SMTP id d2e1a72fcca58-84fde223e4cmr33063388b3a.18.1787039966532;
        Tue, 18 Aug 2026 00:59:26 -0700 (PDT)
Received: from [10.1.1.24] (222-152-170-159-fibre.sparkbb.co.nz. [222.152.170.159])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b4072c39sm1416320b3a.26.2026.08.18.00.59.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2026 00:59:26 -0700 (PDT)
Subject: Re: [PATCH] MAINTAINERS: Leave the cumana_1 and oak drivers to the
 RISCPC maintainers
To: Finn Thain <fthain@linux-m68k.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <935b08c0fb292888c06c2233570331f2ccadcd53.1787014824.git.fthain@linux-m68k.org>
Cc: Russell King <linux@armlinux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
From: Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <12b21181-dd25-70e0-8b55-f29fc33829ac@gmail.com>
Date: Tue, 18 Aug 2026 19:59:19 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <935b08c0fb292888c06c2233570331f2ccadcd53.1787014824.git.fthain@linux-m68k.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Finn,

thanks for your patch!

Am 18.08.2026 um 13:00 schrieb Finn Thain:
> The NCR5380 entry in MAINTAINERS includes drivers/scsi/arm/cumana_1.c and
> drivers/scsi/arm/oak.c. However, those two files are also covered by the
> drivers/scsi/arm/ pathname in the ARM/RISCPC entry.
>
> The latter entry is more effective than the former because, AIUI, neither
> Michael nor I have access to the necessary hardware. IMHO, such access is
> a pre-requisite for the 'maintainer' role for device drivers.
>
> To work on these particular drivers would require an old GCC compiler,
> having support for -march=armv3m, which is a problem for contributors.
>
> Cc: Michael Schmitz <schmitzmic@gmail.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Finn Thain <fthain@linux-m68k.org>

Acked-by: Michael Schmitz <schmitzmic@gmail.com>

> ---
>  MAINTAINERS | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8014b9f8253e..e36df6b23326 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -18571,8 +18571,6 @@ L:	linux-scsi@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/scsi/g_NCR5380.rst
>  F:	drivers/scsi/NCR5380.*
> -F:	drivers/scsi/arm/cumana_1.c
> -F:	drivers/scsi/arm/oak.c
>  F:	drivers/scsi/atari_scsi.*
>  F:	drivers/scsi/dmx3191d.c
>  F:	drivers/scsi/g_NCR5380.*
>

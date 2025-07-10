Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36942874F8
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jul 2025 08:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752134549; cv=none; b=ZLnPol3nqGNjHaIA+5l3AUX1jHmwtgUC2WQB3JaXZaZYS4BhIS1lDILu/UR6Acq56N7gKMoi9jp+5di2qRWbJptVE1tDCjy4dZyIJp8P0alh8qGGzp8N4ALMpT21JQP/RhDHHRgHdlOAwFX12XrJbdKPhgshqeQQsONMA4J55Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752134549; c=relaxed/simple;
	bh=GI1VtsjhXtrT2WJCXUGzz8y+u1YIjjmIvhsqRtpRE5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rMY6vX9iXqLXBYRRjM8GVfqTcmlIRaZ9G0C7kemrvnxr5ibEMWS3eVtfNGcEcppDTrpigZHZ3mCS+tbn/hD7wzbIwFMhTmVnMicYLi9u1L7unF73PWRq2kLOvY+46E1HzG3r/rJdKD8cJ4DAHIMfWyJjCfuSP+YuIatDpqDsoQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wkZPnnmi; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wkZPnnmi"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-61208b86d75so388611eaf.2
        for <linux-scsi@vger.kernel.org>; Thu, 10 Jul 2025 01:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752134546; x=1752739346; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fK8V0E4Xdcf1fTBLfVQvRq2RbYuBxS2NIoLWeiVRMmk=;
        b=wkZPnnmidyJSCaLNWtyJhGh9e0+16A29vkVSz8bkZKgdtNVyBUkmiqZbxdbg5WQINy
         xodsGCuA5b6dM2hysgikYh/bnVvgKwgU6SdcY4urPjaU6IW+QwKA3d6UEksSFKbjuLM7
         Sis63Zn+sbeLvxr0znbSNrbUWnsLSi2HYH2jgTnMS2xFaQ+rijuR94bV7KXyDuSjA3y/
         J8HIkBiFh+BA0dAhl8DMm5cD52faHyi25VbCqdlvnforhWcNGLU2PyhBnJSGEMwgdCxp
         c7EvgGd0t6lF4Ca4f/QY2a+Xb+cl/hsdHjougPVqXZ2yUOExfY8qKGhDRvrd7FITNMKP
         aYTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752134546; x=1752739346;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fK8V0E4Xdcf1fTBLfVQvRq2RbYuBxS2NIoLWeiVRMmk=;
        b=F9BnM3ABYQ6b0P/0TzK7Cb1CgWkG9H/QTUXxa0jiBnEZKQ4FODHQMa+IA4pLw+bVWO
         G274mYd33WsfBWjy1hlQJlc4h69cPOG1OWdyq7HnCRw4o8kYrlYnJf2fV6VDdgq2TGXd
         2R2FH1T3rvsfs8XnWtow45QqwJExicwqOgTow4b4NJ77AppURMojI2UgvSSiDp8hcAR0
         r9JfcMBEP24dUeJvdB6y90cpPTHGfuHqjxXvnhdkkPPXSzBz4wH0cjJj6I+D9go5Suis
         54BAiEIxwH20grjRbwjP7AXZXYFiKQWtuFONkaKsSdoD2gMq9vCeAVfVgvQkLxPrNBHn
         7mZw==
X-Forwarded-Encrypted: i=1; AJvYcCXHr4HnphveOZ3M58sdT+3IH6b1TKPZ2BQh+E2xI+cwD9Q8G+QtZV+xC6DYdCek3PgPuy0SahTuUxTV@vger.kernel.org
X-Gm-Message-State: AOJu0YyDOBLYJEL+2VZvw7hJSGR0xI1VnGLmu/WsDFwWIsoRglNtJHzq
	6W/nrWRE5UsOpP9OKBXQHuaQQd/2uaRbMtuKg3fP904c+1oR0J60P2wfNGXU6P4G35ygs/c5ERB
	WJDeKlymp8Obkb14d8WHo/VQSCHPhWQvQx6PAANMVYQ==
X-Gm-Gg: ASbGncuDa6ZNJlgbzXemqOFIfpy06R54BAYHVMaG7f+BDwNVUvsMez+7LSifReMnyCa
	F/IjA/Elxm+epfEIRsKPxJM/xJXzbViiO0Etigxkz6OoekNAbWN2bgC5CXfCB/Lxs+lrFtURg/J
	lkGWnyN9Yt1p/d19ZctrDANPNILErpPWMZlAEOhcvpAnBbrnOsHSot5g==
X-Google-Smtp-Source: AGHT+IHrFLYymR6F7UKamK/gjTFOEV/FWv98kovyNcG7HeAzZOtkYSEipfwxdZEaT2lEQ5TAU9vcD7JJ0ogSkLcbVfA=
X-Received: by 2002:a05:6820:260e:b0:613:8176:8a00 with SMTP id
 006d021491bc7-613d9db2e43mr1002071eaf.2.1752134546426; Thu, 10 Jul 2025
 01:02:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250707-ufs-exynos-shift-v1-1-1418e161ae40@linaro.org>
In-Reply-To: <20250707-ufs-exynos-shift-v1-1-1418e161ae40@linaro.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Thu, 10 Jul 2025 09:02:15 +0100
X-Gm-Features: Ac12FXw14Fnv-NHIV6I5KCDE4Qv3eilf3MCfG465JBU1_Jo35wVeJqk-I6YsdjU
Message-ID: <CADrjBPr_7NL4jFY=0B=VN7+WtxHrFxGvvqg0AnnPY_P45dtngQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: exynos: fix programming of HCI_UTRL_NEXUS_TYPE
To: =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Krzysztof Kozlowski <krzk@kernel.org>, 
	Seungwon Jeon <essuuj@gmail.com>, Avri Altman <avri.altman@wdc.com>, 
	Kiwoong Kim <kwmad.kim@samsung.com>, Tudor Ambarus <tudor.ambarus@linaro.org>, 
	Will McVicker <willmcvicker@google.com>, kernel-team@android.com, 
	linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 7 Jul 2025 at 18:05, Andr=C3=A9 Draszik <andre.draszik@linaro.org> =
wrote:
>
> On Google gs101, the number of UTP transfer request slots (nutrs) is
> 32, and in this case the driver ends up programming the UTRL_NEXUS_TYPE
> incorrectly as 0.
>
> This is because the left hand side of the shift is 1, which is of type
> int, i.e. 31 bits wide. Shifting by more than that width results in
> undefined behaviour.
>
> Fix this by switching to the BIT() macro, which applies correct type
> casting as required. This ensures the correct value is written to
> UTRL_NEXUS_TYPE (0xffffffff on gs101), and it also fixes a UBSAN shift
> warning:
>     UBSAN: shift-out-of-bounds in drivers/ufs/host/ufs-exynos.c:1113:21
>     shift exponent 32 is too large for 32-bit type 'int'
>
> For consistency, apply the same change to the nutmrs / UTMRL_NEXUS_TYPE
> write.
>
> Fixes: 55f4b1f73631 ("scsi: ufs: ufs-exynos: Add UFS host support for Exy=
nos SoCs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Andr=C3=A9 Draszik <andre.draszik@linaro.org>
> ---

Reviewed-by: Peter Griffin <peter.griffin@linaro.org>

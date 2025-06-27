Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9226F2EA735
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2025 16:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751041699; cv=none; b=caDIT10q6IEZLtN/QwYmls1WinJHzVdWxDF9k+lowXTCKYsBVy+5zPkbJkYv+SUBIHtSX4qLRM1fJoPhTU7pzGKp77ZF7ESGFNtKSRPAQ3tthRT9+7jyCVOR8s2zh48UNWuBudyfTT24f+RF9ymrHAiFoTb8LHxtVi2sr0cSpMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751041699; c=relaxed/simple;
	bh=9FA9bMKxVeb5yQVsUVm+jp/IZZQX6CQBPJL+CqLfVAg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m3nhcWETQIrbNJDL9kFfjoqhQ0/qTiBRbEQ28zb7Q8QyxPlijnhTF+bwuN4QmW01W0WEFHZ+7KTZzGEj7dz6wm4q+KmkgpmJFa8CKqZsYfARJeh7BUFvhoSWhKDgQcvXeFMa+49Q9EVN3lQD/OqAoM+NoY/6Bla7Azy00EgtlEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XzXmYOkR; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XzXmYOkR"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-73ac5680bb0so602609a34.3
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2025 09:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751041696; x=1751646496; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9FA9bMKxVeb5yQVsUVm+jp/IZZQX6CQBPJL+CqLfVAg=;
        b=XzXmYOkRJ409bBDin9CGpXNXJ/Rguok2syKgwL0r1XCkF0tzEEAz2jX1AHHcuDIi+d
         LeXiRWftzPsqNigFV4oEP5JWkqyiPK/Xro0o8uGqA3/2fegb9dqc+Uq2T/ESbE9o9brF
         lU8UPeuPu2nT4u1TkGszLmuGqV7KQea/xJW9wsJ3EXTLWGAFpBpIBEJY/fSAzlZR1Elu
         uUdpjsfI/OMYt0WpiPt19Zm/qlGGPLAU/t880gHT7dwScVPk4XbS3gR7dRib6frY6iWU
         X6P5sLE3lnjW39LkE+u/EQ6jtfZ0Rr6LevvTbeAZ4+Tw/CtYd9jIJhKOmdMQiMavDOlE
         NRJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751041696; x=1751646496;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9FA9bMKxVeb5yQVsUVm+jp/IZZQX6CQBPJL+CqLfVAg=;
        b=WHQoyyylhsXg7pjMiIzFHdoE7+2wJJH/iDdwutZ4plVZo/RyOSVV/qiAOMcs2Ctr4d
         PgRKxiYwZ+qf05bs/0tqAT92vxI9jgistWCCuXY03fIuDvHt3UXEApfYV2b8tf5vS80+
         OW1MGbnj1OlV8Zq0D4TQZte5mhObnM6OHd+ltYHlL0odcWdLRL37YHK/cJWJ63bewqO4
         akDZ+uMP7HUAFxbg2Ccc1m1NQPwj4uyzUYvUXkhucbHltJC8ozrfW2PdByuBTSzn4TZL
         tcWKIWo0QNehNj8T53eCWBojCh0cxGJHg78Tgdc+DPWiVZWijmvTwj1d/8cJsaSnHhy9
         j+2g==
X-Forwarded-Encrypted: i=1; AJvYcCVfxFJZaKuXvfCrpjDL9N7gYxL2NASGHAVBH0RvGe6rcTGJYH+chvregj2f+L8pO+A6ppKBR9Mk1P32@vger.kernel.org
X-Gm-Message-State: AOJu0YwrW12mKdDoU02Kug8kDJfQ9tS2eU9Y+8HG1Flwyw1c06IRv1zh
	W1cw2gP64vbLxhb2E3YTfRAsgQUfy7d6wyi+qwc7K0arg/7cVcesX85atVECLw8TpZbPDlIDkll
	F7bz7D045XIe01JQhpTxH3RVrgryPf8QIY+TtsM6GFQ==
X-Gm-Gg: ASbGncv+5Ou2Ep1IvxO2HYI8zKM1PbASPfgP/y56E9Hw6mDcoIhP7QprYnOQH9Lw2Qx
	ITzo3C8QvZmKeU62fXL/1nE1RJTNLqDA2PpJzMymofm6h2AFAk781rNZlsnszpJWzhpwKja4Olt
	xrSDbLHsqvzcFuTPQ4nDjxRJ6TLQ1iDoCdmkYn5b6YEq83
X-Google-Smtp-Source: AGHT+IHG27gv9karbj1NOogatAO2BrlEvYrLEtmFNeu9XKhGpRsgm/m1RTB+hY9Q08ptcJZaTLUxxE8Xd6aHQ2a8Oic=
X-Received: by 2002:a05:6871:588a:b0:2d9:45b7:8ffc with SMTP id
 586e51a60fabf-2efed430597mr2254424fac.3.1751041696545; Fri, 27 Jun 2025
 09:28:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250314-ufs-dma-coherent-v1-0-bdf9f9be2919@linaro.org> <20250314-ufs-dma-coherent-v1-1-bdf9f9be2919@linaro.org>
In-Reply-To: <20250314-ufs-dma-coherent-v1-1-bdf9f9be2919@linaro.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Fri, 27 Jun 2025 17:28:05 +0100
X-Gm-Features: Ac12FXykTIPEyZRenrTTVdLWukedtCGjmkjr6e-4BGSc71M9daw1mwCSL7G-obU
Message-ID: <CADrjBPqdr1NEd+W4ATJ-6Xi36y8Gi_=81LsFNtY_s2-pBPagFA@mail.gmail.com>
Subject: Re: [PATCH 1/2] arm64: dts: exynos: gs101: ufs: add dma-coherent property
To: =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>, 
	Tudor Ambarus <tudor.ambarus@linaro.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, linux-arm-kernel@lists.infradead.org, 
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	kernel-team@android.com, willmcvicker@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Krzysztof,

On Fri, 14 Mar 2025 at 15:38, Peter Griffin <peter.griffin@linaro.org> wrote:
>
> ufs-exynos driver configures the sysreg shareability as
> cacheable for gs101 so we need to set the dma-coherent
> property so the descriptors are also allocated cacheable.
>
> This fixes the UFS stability issues we have seen with
> the upstream UFS driver on gs101.
>
> Fixes: 4c65d7054b4c ("arm64: dts: exynos: gs101: Add ufs and ufs-phy dt nodes")
> Cc: stable@vger.kernel.org
> Suggested-by: Will McVicker <willmcvicker@google.com>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---

Friendly ping about this patch :)

Peter

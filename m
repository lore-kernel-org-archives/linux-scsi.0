Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F5C159562
	for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 19:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715800646; cv=none; b=n7yKgrkjU+YuD9QWiUh1STvID5jGih/nC/Jrhrp/MSccebndeb8L4V0nkgidWWOB4CKi5nkiVoNIwMeDhPINoznCo3x3V3fyyLyZiq1EDmLYF0Ye559dxaIXwtQYmtOEMmpgSHDrUW2IkmpnRljxhKPaiGM/jpNob6b9wF5HOw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715800646; c=relaxed/simple;
	bh=2wOSUNfTJLFeeO8pVhd+GkVyVWXNaK2KlYom7vpA//o=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jhH7V6PJwiSbwtPiEPOMBSJ0wWzwLo4gOvSDPA3qRFPZY+UiJooivylNbCdQko/vm7VPQaLV3kl9INSKRpFG3ZfgIRDL/+vO60UPjReyx+aZ3YH6DQ5gdLM424JXRz9jlHKoUV/SHb+EoctMYRZG0BteNmSAv5WHehXxWfLWj0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=VaVjYqTa; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="VaVjYqTa"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-df3dfcf7242so674933276.2
        for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 12:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1715800644; x=1716405444; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2wOSUNfTJLFeeO8pVhd+GkVyVWXNaK2KlYom7vpA//o=;
        b=VaVjYqTaqag5ahciEsniuQeiaaM1+WmSRLj7IXRyvHoUt2DH50yTedQ5Y+ummo9hEn
         8ibYsnVWXPkJrxQEpwQXEaVs7XGLeZFLK7BqoePSkso/7QRO87sDMaieV3dLy3HJfPil
         NCPGqIv2fz2hMHLsN1IVkdzj3PL341mKrhO2k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715800644; x=1716405444;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2wOSUNfTJLFeeO8pVhd+GkVyVWXNaK2KlYom7vpA//o=;
        b=NgSHx9U/dw5mWsvHYkhSRu2S2wkX2IISGbtNSHxaYeNYKP46W3qC2ZNpM/D73YIdJt
         rODaHJOgI//qqfuaVHK4i1FHzwQRd4cI27dVQhvNwbB7vaHxDo8UM8C20pJ2vfMl03VE
         RrqoT+WVqoyyof63fpGIukAlpvvcOmDdsRZB+ajDpaNUS8o6az38i2vPrFWXdllecNy/
         5iPlADhhFQbIE17NMb8hVCwL1fiFasQOqHvQMv4VRqPujYpm8/dGCuPgL8eaMAxAPk55
         fTpOs0Kj4wsGC/1A1PcDojFdx59eQn1x8YUjkbQoid0zsxvWpYhjQ8MlM5A4lwmpS41K
         FMAA==
X-Forwarded-Encrypted: i=1; AJvYcCVRw/0sVcxT2AvpKQoGBOTPelLEVrdk84dWx3GFDey/iJH5/1AjTio5M/PJtfAMeWYF2zQ1cJKwH9vqzJX7LUis+5lGiz083HZQjw==
X-Gm-Message-State: AOJu0YwNuUl/NXKdZ70DlrWUODO2EV8PQ9J/7HIzu5yhTQi+/uSesgYj
	OsPTib0zzFlTUAmebdgMEO7rXt2DCiV5tQtPIBob89kyQgNeddjWhJXeVvGm3IZi11XMh7Yiz8+
	PUOm/4IyL0pF8wsPum9ZXEimha1/LU0gttIDj
X-Google-Smtp-Source: AGHT+IGovPGHDhP22BqWNaDOxfm72F+WXpO5BaZMtM00OAugcjSUU6eQQoWzKsASpiWzzblUTpSndz6EgU420El/kfY=
X-Received: by 2002:a25:2e0b:0:b0:dcf:3ef5:4d30 with SMTP id
 3f1490d57ef6-dee4f2c71dfmr15357241276.17.1715800643992; Wed, 15 May 2024
 12:17:23 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 15 May 2024 12:17:23 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240514-ufs-nodename-fix-v1-1-4c55483ac401@linaro.org>
References: <20240514-ufs-nodename-fix-v1-0-4c55483ac401@linaro.org> <20240514-ufs-nodename-fix-v1-1-4c55483ac401@linaro.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 15 May 2024 12:17:23 -0700
Message-ID: <CAE-0n52AYOgG7S3acMj4ZJOvAwNLvQnnv_P8=D+fMYZb0csoBQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: ufs: qcom: Use 'ufshc' as the node name
 for UFS controller nodes
To: Alim Akhtar <alim.akhtar@samsung.com>, Andy Gross <agross@kernel.org>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bjorn Andersson <andersson@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Konrad Dybcio <konrad.dybcio@linaro.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Rob Herring <robh@kernel.org>, 
	cros-qcom-dts-watchers@chromium.org
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Quoting Manivannan Sadhasivam (2024-05-14 06:08:40)
> Devicetree binding has documented the node name for UFS controllers as
> 'ufshc'. So let's use it instead of 'ufs' which is for the UFS devices.
>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---

Reviewed-by: Stephen Boyd <swboyd@chromium.org>

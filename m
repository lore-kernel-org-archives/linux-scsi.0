Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EFE328253
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 15:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737053; cv=pass; b=PWEgoQjlhJ89aiH61FezyFqLyl5BaCA17h/1D0FsU66oAG+uMiEdK1I3NqyC1hEXY29Eu5UHNZ3mOG7BWzcxUiHp0TNvuUxunWsYpzDrZ14y7qU00bvYGVAu09gawW6KSkxVIu0uz3ZvzDQ1gSeuPsBqlxNX+CNJz8uOEMb1LWw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737053; c=relaxed/simple;
	bh=k0gmt2SK6YJLMLSXE/TJpOL6RyovHLpu3hpDi2DSn3o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eFiSNjn2wdVaq7JOhSEYkY2tu5GNhxjqdLQtXinUZyNVaIce202EjW2wptX82gQNNd7GQnuvhJrtjG6ZIG+nZWOl+GhAbQD65erN/PmOg8dQrcboO4CYRuOFhr3npj1YqOM7+4/J+rNoPL76zeSStt85U3+yPwX8FO+bEvziOD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=D72UpHgx; arc=pass smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="D72UpHgx"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-59e4993dff5so3619230e87.3
        for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 07:24:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770737051; cv=none;
        d=google.com; s=arc-20240605;
        b=SphjOuhE68pu4DRFhFfz9nODBCExelMTej6fxGSqybiFshErwif9YO+SG2IHcsPugo
         /7qfYzShCS0Tmx9rmRNGa9XEZT9A9VEXcgEFeLkXHgH5JgotXZJjihAk58LW73yeXU5a
         1Iqz39BNpL6U53jatJkSzprectfnH0cUgDiJTumkdSXR8NfFRQBBkganfGPvSS9p8wJl
         SWEvNhrhCHkgOHGBjXu1BnPGTUx9VDVgeaDVDZplQhz8OWGmXYDmWKDq1XAVDv0X+S2y
         VTqjopLs7i3d5x0qgnkscq3wnU575p0Ha5JfKz+H49uFc4ZwKxf7DUvAJRG0jqvpL45j
         0dsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=GxQFlDkHrupA4LseelclaxK8eMfOdVdlkWQK4k7mZ+0=;
        fh=gbUkP1OM77O+Hg7c+hf0ZUgKnsG03HthPt3vIF3CA6U=;
        b=TmTDywHu+O/xLj4KrGTxS80JE9xLQxujyHa+3fMXEo/4TG0ThCw+0PmapdW3n39m8o
         0hSsvvKUr3NytH25JgC10voGIvDXdNBa5yyCaeeasX5aUl2D/2sDdDjCepEmhlzOceNj
         YoB51yIx81/r8Cj3CZGAq0jwTIHpQW5Dww4oRYPtBFgUVfomPQuuqGUG/Ju/URebO4dD
         Do6Q9LFwiL0MS6q3Tztcy8ND6GORPlKcDB0yeZaUf6R8bviciRSfpnlXbex1qw36pUYy
         MlnfOs9ZOyz0Hhx4uXiHzN5YHWIB1DP8+lw0zE2dOndb/Y/6HHlb0eDvtBbZMkJGqm36
         o9zQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770737051; x=1771341851; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GxQFlDkHrupA4LseelclaxK8eMfOdVdlkWQK4k7mZ+0=;
        b=D72UpHgxhDUkjrXSG0pnzdiDMJKPqQXlXpA9RzIdiiltVSj8RkQvuY4wBIa2SbfZym
         +kSztaMsXMC3M7wmBJtuE6Cfj7N7bd8KUyoM3xoaB77afcJGcjLjweWGdF+mpOccHVYw
         Q7WHJumbRqt+N/Rs1ejDbYGatWJ4dM0iDkxOwdc+DNmuDiwsSlRYX5vOvnaCmKCJaeO/
         dVaeikN7Sa/l7JhiQgSB1iSisN+oo5x8feMgOr04iyHxfJIlt8X/kAciqNgcPEVlMOtu
         IdyVo1zUuBxX8rLLPPOhZA9DT+yOxm3nDXzOZQPCQg54xRptxKlNWo0/rpzWCuigt/th
         hpfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770737051; x=1771341851;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GxQFlDkHrupA4LseelclaxK8eMfOdVdlkWQK4k7mZ+0=;
        b=NMXei+zBN4DGnK8Wu6+W+dgAlvZd2rojdzUjJj/E/hXE/52jk22NyfPikg6X59QrqX
         rX9T3LonzkAAL+YONsfdDvIUx6t9rxf47+A7l1cUjpLdTms5m0ORL0impCWqsibMIINC
         u6jTEibilbfMbEPR2X+i/cvBnkkRrBRwvmrQeP2kVw+a4CFN0BSxg7KjooiDzAjmnY0L
         c6nFNuFOfTDJB5xYQl/nMWnUKO1pVOm3741hfzWC5bliqkUi80l4G5OuBiDmBvmnFKL2
         DFY9Am76yYXCpwZYEQKMmKaM2TcQI6BqPVSdsZ2GXTs+Iu+djuLUwKpn7qOeDQNcIW5X
         2bHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUxU7rvqbcOacls2T9NTzSWPVERPrMRE4+7hnai7/+mW05B7NlL2lVno+Zo/73ggoTdoTFqIBk40upv@vger.kernel.org
X-Gm-Message-State: AOJu0YxMhCOUQHTYtqYoqvHcOJci/W5Gh1iPCBn3k+dH6Hoxy3G93gBD
	yd1T2R9djYtvRD7bFeKXSp+pY89UXqlTXZkiddB8DptIta/A1tPvGWd/lUojrwukTGo9+MPaNUR
	IHpa4WiZpO9UwirNKYGJcc+XLR2obqzg7Q2Tx6p8Jdw==
X-Gm-Gg: AZuq6aKNe/SQl0xRmr2lZ8IXLeGkVR7dVIJJbwXOZUGgfi35os4fpvmj0C0d0E7nM3A
	THs6IGDm34nPy/VdErgOFXnksaOlkUH1s4ggGkNy0etXOzyC4knXLVcTHGhETUsiVrBzEmo1Hex
	DRuN3kTGF3dmAZy5ncffu9jRkpThOBeznNMPw7Xn0dfOy6upR38GALKVNhGmHUexZ6SIMvlDoJY
	7B+KWXcpjQ+K4vVJTZLamFZ3uDqSqacMFVpK2lTg1GefEx5s1Kc3wFPIoOLU49fYPlBdzsqEeek
	cd8ccfXyadp1VN01Ma4b3JLGaw/XUCFA66IsO6HB
X-Received: by 2002:a05:6512:ad5:b0:59e:45ae:7034 with SMTP id
 2adb3069b0e04-59e55bdc59fmr883838e87.36.1770737050449; Tue, 10 Feb 2026
 07:24:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260210-qcom-ice-fix-v2-0-9c1ab5d6502c@oss.qualcomm.com> <20260210-qcom-ice-fix-v2-3-9c1ab5d6502c@oss.qualcomm.com>
In-Reply-To: <20260210-qcom-ice-fix-v2-3-9c1ab5d6502c@oss.qualcomm.com>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Tue, 10 Feb 2026 16:23:32 +0100
X-Gm-Features: AZwV_QjnOROVr9Ygs9hCFhr8L9ZPMcLim0_8y8vdfEht-oO3Vkh2tAqIyIExc0o
Message-ID: <CAPDyKFoYAqkLxJTN8BWGWkcjaD7fs+XkfqWhgnTbhekUnXUw9A@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] mmc: sdhci-msm: Remove NULL check from devm_of_qcom_ice_get()
To: manivannan.sadhasivam@oss.qualcomm.com
Cc: Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Abel Vesa <abel.vesa@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, 
	Manivannan Sadhasivam <mani@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, 
	linux-scsi@vger.kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 10 Feb 2026 at 07:56, Manivannan Sadhasivam via B4 Relay
<devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org> wrote:
>
> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
>
> Now since the devm_of_qcom_ice_get() API never returns NULL, remove the
> NULL check and also simplify the error handling.
>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

Please take this through the qcom-soc tree.

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

> ---
>  drivers/mmc/host/sdhci-msm.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
> index 3b85233131b3..8d862079cf17 100644
> --- a/drivers/mmc/host/sdhci-msm.c
> +++ b/drivers/mmc/host/sdhci-msm.c
> @@ -1906,14 +1906,14 @@ static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
>                 return 0;
>
>         ice = devm_of_qcom_ice_get(dev);
> -       if (ice == ERR_PTR(-EOPNOTSUPP)) {
> +       if (IS_ERR(ice)) {
> +               if (ice != ERR_PTR(-EOPNOTSUPP))
> +                       return PTR_ERR(ice);
> +
>                 dev_warn(dev, "Disabling inline encryption support\n");
> -               ice = NULL;
> +               return 0;
>         }
>
> -       if (IS_ERR_OR_NULL(ice))
> -               return PTR_ERR_OR_ZERO(ice);
> -
>         if (qcom_ice_get_supported_key_type(ice) != BLK_CRYPTO_KEY_TYPE_RAW) {
>                 dev_warn(dev, "Wrapped keys not supported. Disabling inline encryption support.\n");
>                 return 0;
>
> --
> 2.51.0
>
>

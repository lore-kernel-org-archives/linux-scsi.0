Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5169810E4
	for <linux-scsi@vger.kernel.org>; Sun, 28 Jan 2024 01:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706403692; cv=none; b=Y6jf5vM9+L1Vxpgpnz6hs62YQRkhSozy/GSGWWH+JfPKFigE+AgVCrU1xlJ7Hivg/DLn2/TlibYtaYZLaRxtT1+X96qWIsYIdW8T7AliJC//ZCR5PsOQ6LO48zBy3KnhqEfXhwLkLi8qj1xnsQm9zgdiYHgMth5XTGyUXouq07E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706403692; c=relaxed/simple;
	bh=s1ktUUM3CbOPG51ADbCX7yYyhsiSqRrPySzxWGfX3cw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uHXg3k0+mSkXu2or/YujqJzBTYahThlWf7LCtOLTVMBST+ePIp5YFudZjtElmc+2/8MG7/s8fman5aXQLxsAjXDJZ2WqO+6zbXEPVyiJVCYgPOAUa0BviIoSoBXa/fhNXKKRatZgv4C2709Ic3WNy99VTKpnI4I9mhV6u7+GaOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iU3z4Mk8; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iU3z4Mk8"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-5f69383e653so21604557b3.1
        for <linux-scsi@vger.kernel.org>; Sat, 27 Jan 2024 17:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706403690; x=1707008490; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Akq4ZUpGAZUPtZ9ZSl7kec9+rWKqnjhKQTKGm0D6B4E=;
        b=iU3z4Mk8LGTYyxCHw/aQclMPmjNBcd6xju8kqXbvDKIjCe792H4H12h8GKYp8Uy8d4
         Rjq5Y/zOfU9cOqx5HHIFFnXUGVZHKKSTb/nNx+JmBdefMcUafRWfu+wK6eUJq41YcY34
         tXVlwMIxzH+6zTm6iifdoo73zlWuLESVF6QHAa1PQLXB9RhUvrFrS3b1NjrZ+ziVn7Oy
         Lc86UxfxxeWlSGWmVPez6uje9gdDop/if/+xXDfjbQKocyrbUEAe1rBcEggCOTDUQypZ
         lZxQspP/3QGzHMRSMW95OSF8g7spAcO6QUOlEgo4ukdymr4uYOPWAYOM8u+sHJCsQcrG
         79ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706403690; x=1707008490;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Akq4ZUpGAZUPtZ9ZSl7kec9+rWKqnjhKQTKGm0D6B4E=;
        b=Z4Ai3PvdEerOwZJu7rE4F4UqPQc4lhB+dIeIohePALnudhI3xo0qGWdMxVlYZjIEcm
         GlMvbcJOgWCIad+xjIdkal6EHfHxxcnQnBZoUn/O+laFXEecp3AIdYx72Qw+phjtKCRb
         9KxLyFYg5EZ4j5ahonuVaBLrTudNfovIIqMtMEfJ5aHtIPMNf2XOCatuJJZO0XQdZEUp
         fv0jB+z5H7U9qSX2eTLcVsaIQd/nHMHfko4JNK7/8rs7I7n39FJRT1eHdEobwxTyxQ9h
         s9v9dFt2yLlC6OTKOx6dtN/IKVynj0YBqZ+wivNmkVmmCFZnUlNvh39hrIVdndb0GNNb
         1YyA==
X-Gm-Message-State: AOJu0YyjR8u5WqxrBSxuQao1NgU/qLDMQt4YuRBljYPSdas+3LSJQFjd
	o5yMeIXDgH5KhHk1C9ZLCKCFm6zmkvH4ZkpJgqMcSOtNpf7RQSxrVHPdr/7jtPEDhpItlI/MMuW
	queSPdH9G0rcGWvx7u8f16nI3wePUjGezq1VjMg==
X-Google-Smtp-Source: AGHT+IFYb7HatSQPPLoPjPqnFQmWWbGZoWPVCQcd0gG1UWF2VmrKzHToe0mTzGvGfmkPE6SpfevyHBwphWYYblRQKag=
X-Received: by 2002:a81:6d4a:0:b0:5d7:1941:aa6 with SMTP id
 i71-20020a816d4a000000b005d719410aa6mr2551028ywc.65.1706403689965; Sat, 27
 Jan 2024 17:01:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240127232436.2632187-1-quic_gaurkash@quicinc.com> <20240127232436.2632187-16-quic_gaurkash@quicinc.com>
In-Reply-To: <20240127232436.2632187-16-quic_gaurkash@quicinc.com>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Sun, 28 Jan 2024 03:01:18 +0200
Message-ID: <CAA8EJpr5fLYR1v64-DtjOigkUy3579tx_gwHpFWr9k0GyGajGw@mail.gmail.com>
Subject: Re: [PATCH v4 15/15] arm64: dts: qcom: sm8550: add hwkm support to
 ufs ice
To: Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	andersson@kernel.org, ebiggers@google.com, neil.armstrong@linaro.org, 
	srinivas.kandagatla@linaro.org, krzysztof.kozlowski+dt@linaro.org, 
	conor+dt@kernel.org, robh+dt@kernel.org, linux-kernel@vger.kernel.org, 
	linux-mmc@vger.kernel.org, kernel@quicinc.com, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, quic_omprsing@quicinc.com, 
	quic_nguyenb@quicinc.com, bartosz.golaszewski@linaro.org, 
	konrad.dybcio@linaro.org, ulf.hansson@linaro.org, jejb@linux.ibm.com, 
	martin.petersen@oracle.com, mani@kernel.org, davem@davemloft.net, 
	herbert@gondor.apana.org.au
Content-Type: text/plain; charset="UTF-8"

On Sun, 28 Jan 2024 at 01:28, Gaurav Kashyap <quic_gaurkash@quicinc.com> wrote:
>
> The Inline Crypto Engine (ICE) for UFS/EMMC supports the
> Hardware Key Manager (HWKM) to securely manage storage
> keys. Enable using this hardware on sm8550.
>
> This requires two changes:
> 1. Register size increase: HWKM is an additional piece of hardware
>    sitting alongside ICE, and extends the old ICE's register space.
> 2. Explicitly tell the ICE driver to use HWKM with ICE so that
>    wrapped keys are used in sm8550.
>
> NOTE: Although wrapped keys cannot be independently generated and
> tested on this platform using generate, prepare and import key calls,
> there are non-kernel paths to create wrapped keys, and still use the
> kernel to program them into ICE. Hence, enabling wrapped key support
> on sm8550 too.
>
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>  arch/arm64/boot/dts/qcom/sm8550.dtsi | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
> index ee1ba5a8c8fc..b5b41d0a544c 100644
> --- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
> @@ -1977,7 +1977,8 @@ ufs_mem_hc: ufs@1d84000 {
>                 ice: crypto@1d88000 {
>                         compatible = "qcom,sm8550-inline-crypto-engine",
>                                      "qcom,inline-crypto-engine";
> -                       reg = <0 0x01d88000 0 0x8000>;
> +                       reg = <0 0x01d88000 0 0x10000>;

Does the driver fail gracefully with the old DT size? At least it
should not crash.

> +                       qcom,ice-use-hwkm;
>                         clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;

-- 
With best wishes
Dmitry

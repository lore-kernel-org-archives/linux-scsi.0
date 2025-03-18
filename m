Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDBC2B9A4
	for <linux-scsi@vger.kernel.org>; Tue, 18 Mar 2025 05:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742275848; cv=none; b=Dt8wacL7qyCLAZSY1BcnTogk6aPaV0HNND5NrRA3UTX9GMFgoMSSJU5FR6FoHUKTJ7Yrya2E2r8VVEnGAi5JUGpo5SiVrb/xIWpcs9ynWoHVPndVYkGW6xuyZs17K07Z3OCmxgd3/ovZd5oTSP2AvvX7QRu+hu8rno+W5a80jh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742275848; c=relaxed/simple;
	bh=FM8tOSiWZN6ldhIz1/RdvJxSRCOBEVALQYCx8ILxKVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cTOdT7fsCdwA/1NI84A57a7NEkj2OpbJNZp6VnzDDunqJFgI30bTR9qNlqCRXIOeJqO+5Tlt/nC6wOc7LPgRPyWgCdlX1KisB9BZnJ1UdLeHLB1mjcWWS9wx+9DWtCbalf62ITzvf9U8ar2qLwbqhKNFfzEoyW2AcPtA3WmgSbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OTPYGDSP; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OTPYGDSP"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-224019ad9edso48700745ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 17 Mar 2025 22:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742275846; x=1742880646; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vVrlX5/yKFewVW4DNtsi/TcZgSdsi6s244vHzJco34Q=;
        b=OTPYGDSPuJcHCpdTTYvM2a8a1E0/0KwwgJmxisPzpXfqmDaf5VMeC+MeWQfEwfVVn2
         P1mHRPT0TPQJhgH5IvmMTnN9sIQ18jhmDTzXnhvUG4glBNVxbgeaPy1SWpQIlBXkC26k
         HBg0XHRRMFxOtXJoNIJPZJXVake1c9Zn2/P9d+uCyb8BYMibT/SeDWs+I0JP8/67y778
         jKgDf9MV2wBon06Tc1hNYZ/n28L91hckW3Bhp+PVQylcoy4iVdLKVkcYni/ah35eGAX3
         Yn2lD6XKjNF1Jx5hubcGLYQZmiHJI4HI8bHBCS2rKd7cGdoPI8D1cWFJrfyV673hfs/j
         tQHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742275846; x=1742880646;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vVrlX5/yKFewVW4DNtsi/TcZgSdsi6s244vHzJco34Q=;
        b=tJTPvjf3OSxQBSe9zpHvjTNm9yZjxc8p4R0cycwlOkyPLz66sR45k8rWpFj1LV58v9
         bWbVcFoHrQWY0hpCSdoUEblHE4SpIFQEIwU45M1aziJFGzHYih/w2PXGDpHlbDXYl+2d
         BpsIhgeq7PvNFgK5Kk2mYyw6Wtr1g80AycyoeA9Sjj0z0TP8ifqbpiwlOdrQXHRx/mFV
         iDjhqSC1VLxLmbTYDKMLb1eYp6ElVNYHkW15F5Azi+4jKgCpn2F5bSSDoUP+hz7T/0in
         OBpf/IQ9MpmhJE4TKq0f6HSX1Qugk3JGKedmpHuyJCxS9LdOZvV8FhvZ/WkbrJh2POtu
         BWfg==
X-Forwarded-Encrypted: i=1; AJvYcCWo87d+MSLBUeey1FZrDPgb/crZEhieFDPx/ULJ5bok0jAbTa+hfrSWuDCtu0jqzJDyxbkxLKA41iqe@vger.kernel.org
X-Gm-Message-State: AOJu0YyFAINDUuzqM/jeTRdZvxPS9sGSP1dW+KOlH1AQ/f3Wm7U6zx/l
	c48SDPjySsHNs9B5NvTPXDGEtirBdQTcTuEvDP21uURLbwyQbC8JBm1HJ5yZ0w==
X-Gm-Gg: ASbGnctozRnnyaO6+nvrcbD8pRhgQzfh2PkErHFs8ERDZRl7EYBHaHfcErxR9X7GunA
	DL5dLsHAm3+sS0Wr7hg2bYAXsBx3b4Rej6ymnucS/A6rl3SW9lvKtgw6BAmlOoyQpth8He+9uYy
	VOQBYaSD4tE72XtGvSHCsL1npf7oslJNaw/ileOhR9Eq6Aj2FSH2j7lJC2xiJ46VtH/ZBiIG2Vu
	EjinBbmTxBFiEdOawWqHGeTJPnB8USq5HVmSVRht8BkBP/feQ2gWkmcfQXMz1+ssO6MfC6tsQG7
	nDB9u+f1QloMv8yRKZ29WdbtxJ76aZGBEYWhGYh2pe7fJmCPMS3HnNtpk4fa60QWxME=
X-Google-Smtp-Source: AGHT+IEtt4J+fZu9T/XWxc1ZJtom12OamyfKq1wK8CZ3f3/gBNHUNIaz9zHfTwn3v99uwCqK19+WIQ==
X-Received: by 2002:a17:902:db0a:b0:220:faa2:c911 with SMTP id d9443c01a7336-2262c53587bmr23587095ad.14.1742275846568;
        Mon, 17 Mar 2025 22:30:46 -0700 (PDT)
Received: from thinkpad ([120.56.195.170])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c6bbffc2sm85375845ad.162.2025.03.17.22.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 22:30:46 -0700 (PDT)
Date: Tue, 18 Mar 2025 11:00:38 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Melody Olvera <quic_molvera@quicinc.com>
Cc: Vinod Koul <vkoul@kernel.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Andy Gross <agross@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Satya Durga Srinivasu Prabhala <quic_satyap@quicinc.com>,
	Trilok Soni <quic_tsoni@quicinc.com>, linux-arm-msm@vger.kernel.org,
	linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manish Pandey <quic_mapa@quicinc.com>
Subject: Re: [PATCH v2 5/6] arm64: dts: qcom: sm8750: Add UFS nodes for
 SM8750 MTP
Message-ID: <20250318053038.k25p26qsxqozqyvb@thinkpad>
References: <20250310-sm8750_ufs_master-v2-0-0dfdd6823161@quicinc.com>
 <20250310-sm8750_ufs_master-v2-5-0dfdd6823161@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250310-sm8750_ufs_master-v2-5-0dfdd6823161@quicinc.com>

On Mon, Mar 10, 2025 at 02:12:33PM -0700, Melody Olvera wrote:
> From: Nitin Rawat <quic_nitirawa@quicinc.com>
> 
> Add UFS host controller and PHY nodes for SM8750 MTP board.
> 
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Co-developed-by: Manish Pandey <quic_mapa@quicinc.com>
> Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  arch/arm64/boot/dts/qcom/sm8750-mtp.dts | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sm8750-mtp.dts b/arch/arm64/boot/dts/qcom/sm8750-mtp.dts
> index 9e3aacad7bdab6848e86f8e45e04907e1c752a07..9d34159e73948e7f3f939593d1ace444cc5dcd15 100644
> --- a/arch/arm64/boot/dts/qcom/sm8750-mtp.dts
> +++ b/arch/arm64/boot/dts/qcom/sm8750-mtp.dts
> @@ -792,3 +792,21 @@ &tlmm {
>  &uart7 {
>  	status = "okay";
>  };
> +
> +&ufs_mem_phy {
> +	vdda-phy-supply = <&vreg_l1j_0p91>;
> +	vdda-pll-supply = <&vreg_l3g_1p2>;
> +
> +	status = "okay";
> +};
> +
> +&ufs_mem_hc {
> +	reset-gpios = <&tlmm 215 GPIO_ACTIVE_LOW>;
> +
> +	vcc-supply = <&vreg_l17b_2p5>;
> +	vcc-max-microamp = <1300000>;
> +	vccq-supply = <&vreg_l1d_1p2>;
> +	vccq-max-microamp = <1200000>;
> +
> +	status = "okay";
> +};
> 
> -- 
> 2.46.1
> 

-- 
மணிவண்ணன் சதாசிவம்

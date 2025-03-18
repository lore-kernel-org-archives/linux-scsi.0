Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151B11C84B7
	for <linux-scsi@vger.kernel.org>; Tue, 18 Mar 2025 05:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742275730; cv=none; b=GBSbIaurXkfa/0KzrFzFvZhu6kwignj373wTwlkiApU3hDFu7DTGzWMcrFmzi23M5Qr+JvP2xE3l9P+U+85vgpNCVyUjKVyHITz0aj9onQG8nAC+ic10yC+HUMtiYsTuSdbyUNLRJdm9mDJjrqLmaFp7r51WjTA5+Ho/B12XkHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742275730; c=relaxed/simple;
	bh=/0mkySwxx8CUCvupfW3tEVscVADwcQaLSwPmfTKJfsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mDa5I1WVWvTaUmkX9Xsy9Z0ptEu5fOLhIbQokMb4hMPGsJed2Xg5DEX2o2W+NhL4DiYv+DjJutffEuCDCwudhUjc9cckK2XJT/1bs4XmjSRsm3C9jCzK6/7ybLuylfSsl/eXFWEWQ7tvyNoVcScB7an/WyeVcERONZ1Wc37wKVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=n1VUWMHo; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="n1VUWMHo"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22548a28d0cso141873925ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 17 Mar 2025 22:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742275728; x=1742880528; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VRqPHtspOPLV5fzzZRBSafJQnspJw3fNNbyVspVhWQ4=;
        b=n1VUWMHogcTpKm1MVl0iy7k2Ew+vTSFDZHP4Da/IsEnW0lZykV/iAfwsdNJBGznFyq
         bRNWL+P/X20QCsioixrhSXzuPa/RbYxje/RHM6Efbd/swKjIxygOQRDHSzlYnnixpcw4
         qDOvvMEEoAzipXQ9I8EzTjn4PkFkXTPE3+lPfnhYp9dUoKvTPK9okKWyC5ngR2VGCKWD
         ix3Q1SJqs175pidMXDxr/yE3me+5ELtATfuzL/aqFYFRwu0+DGNApY+aqUx08LAjz94C
         fwS5UEgBKvH90Pmh4gq74tR6MegboNIG2+voLEHSlEqThrio6qEHHgBacS3l746dfyuE
         76uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742275728; x=1742880528;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VRqPHtspOPLV5fzzZRBSafJQnspJw3fNNbyVspVhWQ4=;
        b=iGyDPY4x8+fxGcIkR3KGau4qnN8ixYXMcTNjXTTT1WccB2VufnYnqUVojtQmrwj3yQ
         KmNs0dGJOGs4MMOujNgJNlswpUen9sJTO7FtwiSjT2W3tS7aO/hXFlMHJ4ywRs8rP63J
         wh7suEMq6JKRX5OI+73qSlJKveWgEn0ssIrZI5MWjDWTlk5R6RHZQdUU5y1YFHA81Wal
         feBVeb3kKyvoF8ClN3cY99vbd8RaCYZULKKsmJRK0vTOM0diQ8ltTgwUUUwJLiJiOaPA
         Es0zDzDFWKPQmQIBZ045h8RxF/VJzLbRogEox6xSsCYCvfGS5quVZ8oq5AQOAvRBjwh6
         47Qg==
X-Forwarded-Encrypted: i=1; AJvYcCUEMdKOXEkAOn/fEQT2zA8Zol6SJovo5BYzKfvC8hPp18eQyO7YUwNXrp6MiLUynspXEqX1WggpC9sL@vger.kernel.org
X-Gm-Message-State: AOJu0YwuRbE7gZ1eLAFdE+wB846lJZB5asNuMNJhitJdrsClHl4f6LOG
	8/0PBVHE5xGuDslv41itoFqJMY6C3um6d4U9gNp3WbAUfbKSj+Mhr4Bz/QvM3Q==
X-Gm-Gg: ASbGncvAgqRHhv7krjNPaKfBKioKXqZ/lDQUJDIgBfXIZBifQ7PdsdK6m/k72XGJHjC
	qR7oH2UBKyKK2UkmmN5PIuoyUThjKV+ojTrvLy6XYhUaU2iW8YXM62j8ADQZDV6LwHAhqz0aJkI
	yAyT+OXRqzvvfqoeJ5osUPoilhWikrtHwxfA5keUhaADwJusaS42hoQah2dXDLXrwo9eYTMuXD2
	JpZ01ARepgs6rLNI0tsjyA3vcKKyfzK4qpLHpB7PsAuyAxxbG9/wUYH4zKwbGYPHtSjAPGPweAv
	jppUT6jLc8NdZi5tkr6JoBniMqnBmfYZRTuUmvPwFvJVkmvQQoZlc8oPQpR+zIO/+dQ=
X-Google-Smtp-Source: AGHT+IFG5Sp+xZKN+EExsVukhBXmwQgVJv7iaqIRzDwSj/npYT8oIBOs7InzmHh3m7smIDKT/Xzh+w==
X-Received: by 2002:a17:902:d4c6:b0:223:58ea:6fdf with SMTP id d9443c01a7336-225e0a7a005mr192432975ad.28.1742275728222;
        Mon, 17 Mar 2025 22:28:48 -0700 (PDT)
Received: from thinkpad ([120.56.195.170])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22637cf43ffsm2371755ad.129.2025.03.17.22.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 22:28:47 -0700 (PDT)
Date: Tue, 18 Mar 2025 10:58:41 +0530
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
	Manish Pandey <quic_mapa@quicinc.com>
Subject: Re: [PATCH v2 4/6] arm64: dts: qcom: sm8750: Add UFS nodes for
 SM8750 SoC
Message-ID: <20250318052841.bdiqbzxrpzwqf7h7@thinkpad>
References: <20250310-sm8750_ufs_master-v2-0-0dfdd6823161@quicinc.com>
 <20250310-sm8750_ufs_master-v2-4-0dfdd6823161@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250310-sm8750_ufs_master-v2-4-0dfdd6823161@quicinc.com>

On Mon, Mar 10, 2025 at 02:12:32PM -0700, Melody Olvera wrote:
> From: Nitin Rawat <quic_nitirawa@quicinc.com>
> 
> Add UFS host controller and PHY nodes for SM8750 SoC.
> 
> Co-developed-by: Manish Pandey <quic_mapa@quicinc.com>
> Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> ---
>  arch/arm64/boot/dts/qcom/sm8750.dtsi | 106 +++++++++++++++++++++++++++++++++++
>  1 file changed, 106 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sm8750.dtsi b/arch/arm64/boot/dts/qcom/sm8750.dtsi
> index 529e4e4e1d0ea9e99e89c12d072e27c45091f29e..72f69e717ce049bb0c524aa389d837ecd1459535 100644
> --- a/arch/arm64/boot/dts/qcom/sm8750.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8750.dtsi
> @@ -13,6 +13,7 @@
>  #include <dt-bindings/power/qcom,rpmhpd.h>
>  #include <dt-bindings/power/qcom-rpmpd.h>
>  #include <dt-bindings/soc/qcom,rpmh-rsc.h>
> +#include <dt-bindings/gpio/gpio.h>

Sort includes alphabetically.

>  
>  / {
>  	interrupt-parent = <&intc>;
> @@ -2675,6 +2676,111 @@ gic_its: msi-controller@16040000 {
>  			};
>  		};
>  
> +		ufs_mem_phy: phy@1d80000 {
> +			compatible = "qcom,sm8750-qmp-ufs-phy";
> +			reg = <0 0x01d80000 0 0x2000>;

Use 0x0 for consistency.

> +
> +			clocks = <&rpmhcc RPMH_CXO_CLK>,
> +				<&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
> +				 <&tcsrcc TCSR_UFS_CLKREF_EN>;

Please align the clocks.

> +
> +			clock-names = "ref",
> +				      "ref_aux",
> +				      "qref";
> +
> +			resets = <&ufs_mem_hc 0>;
> +			reset-names = "ufsphy";
> +
> +			power-domains = <&gcc GCC_UFS_MEM_PHY_GDSC>;
> +
> +			#clock-cells = <1>;
> +			#phy-cells = <0>;
> +
> +			status = "disabled";
> +			};

Here too.

> +
> +		ufs_mem_hc: ufs@1d84000 {
> +			compatible = "qcom,sm8750-ufshc",
> +				     "qcom,ufshc",
> +				     "jedec,ufs-2.0";

Compatibles can be ordered in the same line.

> +			reg = <0 0x01d84000 0 0x3000>;

0x0

> +
> +			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
> +
> +			clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
> +				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
> +				 <&gcc GCC_UFS_PHY_AHB_CLK>,
> +				 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
> +				 <&rpmhcc RPMH_LN_BB_CLK3>,
> +				 <&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
> +				 <&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
> +				 <&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
> +			clock-names = "core_clk",
> +				      "bus_aggr_clk",
> +				      "iface_clk",
> +				      "core_clk_unipro",
> +				      "ref_clk",
> +				      "tx_lane0_sync_clk",
> +				      "rx_lane0_sync_clk",
> +				      "rx_lane1_sync_clk";
> +
> +			operating-points-v2 = <&ufs_opp_table>;
> +
> +			resets = <&gcc GCC_UFS_PHY_BCR>;
> +			reset-names = "rst";
> +
> +			interconnects = <&aggre1_noc MASTER_UFS_MEM QCOM_ICC_TAG_ALWAYS
> +					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
> +					<&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
> +					 &config_noc SLAVE_UFS_MEM_CFG QCOM_ICC_TAG_ACTIVE_ONLY>;
> +			interconnect-names = "ufs-ddr",
> +					     "cpu-ufs";
> +
> +			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
> +			required-opps = <&rpmhpd_opp_nom>;
> +
> +			iommus = <&apps_smmu 0x60 0>;
> +			dma-coherent;
> +
> +			lanes-per-direction = <2>;
> +
> +			phys = <&ufs_mem_phy>;
> +			phy-names = "ufsphy";
> +
> +			#reset-cells = <1>;
> +
> +			status = "disabled";
> +

Extra newline

- Mani

-- 
மணிவண்ணன் சதாசிவம்

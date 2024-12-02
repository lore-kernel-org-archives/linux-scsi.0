Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216E320D4E2
	for <linux-scsi@vger.kernel.org>; Mon,  2 Dec 2024 14:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733150708; cv=none; b=MYnPjxP1t6Ln10W3umRrcJbEUOhcYxEWmKTPbqF8j/WwoNPvwH2zIWPObwVOwKMJgTZoTIoJyHZ0mOR9GZ4ZmKqvSgP/eHHiMZRjMe0aSepMUR8SVU6wnw4YKFVJBFUnAW0ckUhSboIkSvSd7A8lD+iEyfwhcZ9yyKCBy1TGX0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733150708; c=relaxed/simple;
	bh=LAR2OPaTHuw75CmRdL3urd56d1GQCR1zzyVJwcom4AE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L3Qh9DE2KRdkgWeh/BikH4uxmH4xtrWclJBHqH5bqSMayL8giQnVHQ/oy8c06UHFzaHYoQ7IjjNWHLOH6SnERzyY4MSG6R25DXnFDPjBV0OsSdSZbXwPxdeHNaRVpdKY5hSt3vCKSUgFo++qXsbr7tro0M6uCIyz5MtKWJd/WYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iFUMtdVP; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iFUMtdVP"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-215ac560292so5007575ad.2
        for <linux-scsi@vger.kernel.org>; Mon, 02 Dec 2024 06:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733150706; x=1733755506; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZPr+rqxrsBrYoMzAPXWAODr8cERzCFOtYTMVsGmGlwM=;
        b=iFUMtdVPq/0ShCe8ovuiiuE3sHpvs2rnG6x3FfQe7fY08poq5MUtbyAGkjl2qgHMbu
         Ot2q7Brkvo4zMpMnhaItm+Yah7lae+WWrwTI7/29+vIcEHRA6S+5LdUaYOEs2FhepSV5
         KQ5DqvKt4IAw/EXnIcY7IA1DuksthfwLyFNqcWWH57vxu4/E9Q0KuP85TW5vQTpxXhVm
         kSRbFGcNBwFtSTQQ0WsAJbWDAekWWJqnOW94cbe7z6gBHSqloNUr736Iuc87CDXZ3ISN
         XQd6AEGjx22BF8b56p0ioE9VpFMit8ggibYqlZpjXlTOGJUWp12y2Cc/dpfc3xGUdrlu
         MJDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733150706; x=1733755506;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZPr+rqxrsBrYoMzAPXWAODr8cERzCFOtYTMVsGmGlwM=;
        b=CgaMrRqf3jMC47emehd2lM9yhprsL97m2ioSDie2Cx9LERb+r5EK69VyYJL5nZSSIJ
         8UPdx+zR1sGIUbX+3TWG+MxzHwi+ok6atOFT/5APq7ahXbePVxfZfVbUuOpB6T2g0cjj
         90CZmzym0Ky2Sem3wQYPguLGpgPtT7podA16nojND0ka1+NcOklaoGzjkQG7oOWC4lnI
         C+KKjgObaS0wkeIRSUDRbGLZVimomZ3WRA4hgXJbLfADiwHBrEwJsutBk1U625EgyhWO
         B6SMmYD6rdKB/ZnCGcux89CjEf4k6/tolFsHB9yasaRJMg2oFCafFdIALQAkd8a0l++I
         4ERw==
X-Forwarded-Encrypted: i=1; AJvYcCVAMFQ8tOZydcNCOY6cC9L1+gvl0+Dp5630gLpO6VsZFkz1luGItcrvNC9NhIJKWrv1tpuvOJmD6b3E@vger.kernel.org
X-Gm-Message-State: AOJu0Yy38jJhsRUomqL7RMPEy219R2dPhCWKJdEd+qb7aVMPiEhsGgPP
	HaHcfQh/vwsVFlcHyzn3xPR5tyPPoqczdSGxz2TCKieD4Fz4jmAiHZvPgcgd5Q==
X-Gm-Gg: ASbGnctNkydCFRCxdLn1e8neHaaYwOjMCkFRkU4bJH+BuycYCy/RLwAJtg6OMo3x3sc
	BrGyqVKjfCDt+Bc9bM91zV6vthxcPcyTSxe1tSMEQymTohfFNeq5IrHuboT/Kh1KFkVfdYeHIPG
	JEHTZ4s32IkjmyFdgxR0e/dexUyIgDxPp1njJr1KrrPlKAdWJRHKFT3X5gSsGa6NRcM+qr2Cb8W
	noemq3NDv/Wo1IqKUVEyITdpQ16TVBdUX1oQPcnUMBN6/MtHtjpwnRcCt45Ng==
X-Google-Smtp-Source: AGHT+IFVCODuAccsYt/2/80+IXDxhd60+2Yn4zsceONDv9zG3hdrKNerpQeL5Z00zmSVyrmEYMEANw==
X-Received: by 2002:a17:902:ce92:b0:215:7ce8:1363 with SMTP id d9443c01a7336-2157ce815f5mr100011155ad.19.1733150706219;
        Mon, 02 Dec 2024 06:45:06 -0800 (PST)
Received: from thinkpad ([120.60.140.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21530f1d769sm71106335ad.81.2024.12.02.06.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2024 06:45:05 -0800 (PST)
Date: Mon, 2 Dec 2024 20:14:56 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Xin Liu <quic_liuxin@quicinc.com>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Andy Gross <agross@kernel.org>, linux-arm-msm@vger.kernel.org,
	linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	quic_jiegan@quicinc.com, quic_aiquny@quicinc.com,
	quic_tingweiz@quicinc.com, quic_sayalil@quicinc.com
Subject: Re: [PATCH v3 2/3] arm64: dts: qcom: qcs615: add UFS node
Message-ID: <20241202144456.scq5d2orw4d3dbxg@thinkpad>
References: <20241122064428.278752-1-quic_liuxin@quicinc.com>
 <20241122064428.278752-3-quic_liuxin@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241122064428.278752-3-quic_liuxin@quicinc.com>

On Fri, Nov 22, 2024 at 02:44:27PM +0800, Xin Liu wrote:
> From: Sayali Lokhande <quic_sayalil@quicinc.com>
> 
> Add the UFS Host Controller node and its PHY for QCS615 SoC.
> 
> Signed-off-by: Sayali Lokhande <quic_sayalil@quicinc.com>
> Co-developed-by: Xin Liu <quic_liuxin@quicinc.com>
> Signed-off-by: Xin Liu <quic_liuxin@quicinc.com>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  arch/arm64/boot/dts/qcom/qcs615.dtsi | 114 +++++++++++++++++++++++++++
>  1 file changed, 114 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/qcs615.dtsi b/arch/arm64/boot/dts/qcom/qcs615.dtsi
> index 590beb37f441..5e501511e6db 100644
> --- a/arch/arm64/boot/dts/qcom/qcs615.dtsi
> +++ b/arch/arm64/boot/dts/qcom/qcs615.dtsi
> @@ -458,6 +458,120 @@ mmss_noc: interconnect@1740000 {
>  			qcom,bcm-voters = <&apps_bcm_voter>;
>  		};
>  
> +		ufs_mem_hc: ufshc@1d84000 {
> +			compatible = "qcom,qcs615-ufshc", "qcom,ufshc", "jedec,ufs-2.0";
> +			reg = <0x0 0x01d84000 0x0 0x3000>,
> +			      <0x0 0x01d90000 0x0 0x8000>;
> +			reg-names = "std",
> +				    "ice";
> +
> +			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
> +
> +			clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
> +				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
> +				 <&gcc GCC_UFS_PHY_AHB_CLK>,
> +				 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
> +				 <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
> +				 <&rpmhcc RPMH_CXO_CLK>,
> +				 <&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
> +				 <&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>;
> +			clock-names = "core_clk",
> +				      "bus_aggr_clk",
> +				      "iface_clk",
> +				      "core_clk_unipro",
> +				      "core_clk_ice",
> +				      "ref_clk",
> +				      "tx_lane0_sync_clk",
> +				      "rx_lane0_sync_clk";
> +
> +			resets = <&gcc GCC_UFS_PHY_BCR>;
> +			reset-names = "rst";
> +
> +			operating-points-v2 = <&ufs_opp_table>;
> +			interconnects = <&aggre1_noc MASTER_UFS_MEM QCOM_ICC_TAG_ALWAYS
> +					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
> +					<&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ALWAYS
> +					 &config_noc SLAVE_UFS_MEM_CFG QCOM_ICC_TAG_ALWAYS>;
> +			interconnect-names = "ufs-ddr",
> +					     "cpu-ufs";
> +
> +			power-domains = <&gcc UFS_PHY_GDSC>;
> +			required-opps = <&rpmhpd_opp_nom>;
> +
> +			iommus = <&apps_smmu 0x300 0x0>;
> +			dma-coherent;
> +
> +			lanes-per-direction = <1>;
> +
> +			phys = <&ufs_mem_phy>;
> +			phy-names = "ufsphy";
> +
> +			#reset-cells = <1>;
> +
> +			status = "disabled";
> +
> +			ufs_opp_table: opp-table {
> +				compatible = "operating-points-v2";
> +
> +				opp-50000000 {
> +					opp-hz = /bits/ 64 <50000000>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <37500000>,
> +						 /bits/ 64 <75000000>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <0>;
> +					required-opps = <&rpmhpd_opp_low_svs>;
> +				};
> +
> +				opp-100000000 {
> +					opp-hz = /bits/ 64 <100000000>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <75000000>,
> +						 /bits/ 64 <150000000>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <0>;
> +					required-opps = <&rpmhpd_opp_svs>;
> +				};
> +
> +				opp-200000000 {
> +					opp-hz = /bits/ 64 <200000000>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <150000000>,
> +						 /bits/ 64 <300000000>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <0>;
> +					required-opps = <&rpmhpd_opp_nom>;
> +				};
> +			};
> +		};
> +
> +		ufs_mem_phy: phy@1d87000 {
> +			compatible = "qcom,qcs615-qmp-ufs-phy", "qcom,sm6115-qmp-ufs-phy";
> +			reg = <0x0 0x01d87000 0x0 0xe00>;
> +			clocks = <&rpmhcc RPMH_CXO_CLK>,
> +				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
> +				 <&gcc GCC_UFS_MEM_CLKREF_CLK>;
> +			clock-names = "ref",
> +				      "ref_aux",
> +				      "qref";
> +
> +			power-domains = <&gcc UFS_PHY_GDSC>;
> +
> +			resets = <&ufs_mem_hc 0>;
> +			reset-names = "ufsphy";
> +
> +			#clock-cells = <1>;
> +			#phy-cells = <0>;
> +
> +			status = "disabled";
> +		};
> +
>  		tcsr_mutex: hwlock@1f40000 {
>  			compatible = "qcom,tcsr-mutex";
>  			reg = <0x0 0x01f40000 0x0 0x20000>;
> -- 
> 2.34.1
> 

-- 
மணிவண்ணன் சதாசிவம்

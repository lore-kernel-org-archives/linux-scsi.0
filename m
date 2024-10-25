Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582DB20F3D1
	for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2024 19:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729884294; cv=none; b=SGZYJAmbysevGXiMnTpbvC+ZvK+bQZMkABax01R9NTMFgwi+iFvR5naVrRseddwAsBd21WQ7/VU1esjJlWR5aPMlL5gGLnpFCK7642ZENIw1A9S5rkxyo2z6Akk48OJ3OtJbdzo3UQyQ67BlpdRlalRAtNMcxVWO9O+6PhYOxNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729884294; c=relaxed/simple;
	bh=QQpHCClhXrPyRs6UARwaoQsu3+yZD34Mn21hUGlrJGY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SRHOlIwgfGnGw2IUewg4OOSNy7E8ftLB2N5AhIaW5hMiVlLqIGSJ8oYHRA5b/2nYSAH0qpEWC0I87uK3OlN+yatO7t1V4UztvlOY1sVJ9MML6PFdH7jcg5UabgzBTC9BM2T3RUzoU3dP0ZkWH1qqRsAloTjYUClh+7eDJmBfztA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=fail smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pilsUO3C; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pilsUO3C"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49PAEEQg029449
	for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2024 19:24:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MVK7yFV+LSKHjauEJCgphRRBdSUgRulvWMCx8A+MGTw=; b=pilsUO3CatOHV8oW
	VU53v9FNxi70IZmBSiMwjHY4vFcl/0ngdFyqcE68VfhNIED8UbYaqZ5lXFRC7kMY
	g/HFKibekvyeDXm7pvqNopylvpKpz71EWVbfcGF40RG1Q8Jx15bYDLhEc5uFEXkz
	jplBfOFsd4SsuwdVo5TaNopXKcZigxACA8YilqmG7Pz3Zyf8LDQO5v/JpbgQQcFY
	2cXIpSs7LZjIXJ9jB/VdPZJ/FWG3I3UiK3SEIFdm5tN2HkDj828cvAklz/DLjlNR
	RUseSQ/rVv8RevAfLcIXC2UnsC2zey92nTyoCi9qIECUqFGpXKmV6JmrWIhaA+sI
	wcbMqw==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 42em3wa6fs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2024 19:24:51 +0000 (GMT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6cda6fd171bso5226866d6.3
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2024 12:24:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729884290; x=1730489090;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MVK7yFV+LSKHjauEJCgphRRBdSUgRulvWMCx8A+MGTw=;
        b=aoC6e6tp05FM4TwY5Ya7b/usQFzaVQvKriMt8/gmfOK+DiGgvW3OEe7QmTXAhSK8Jo
         7zPf5XSQ90LCakZgWpkhlJ8YQTH4FQzuKREmFZYOKAhu+IQLEHAnQoZIb1A0KhFeJqjl
         r+LLGQfCBzo8CZHVq9clUuOY0qzt0/Dx4if+8J1rh13V/q3HH9X5L7hlaTRmZlzk6rLn
         nAPnbbwtX5kBXW8/IAGTTqIZd5DAjfJGqpofnGydphvvosevbhtwJ7iBG+fE+b6q+/ES
         R9G4bX41WvOjOEfAET/CZeDafTURpg64ClrlHGjcwWvHUeZSTHWqBGr13coKkuJGI+j6
         Ip3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWnklzfNQgZNrnacbg+fgGMydhR3S7Z0p+NFiZDKXOx6tMxaBmzynGoG1YLQxXBlI32EJ2B+ajXZzdu@vger.kernel.org
X-Gm-Message-State: AOJu0YwZlsgT5rrHfH0E2XnmQB5hrXiyw1Hl8Aw2SBSi5Ldpgic0mPrC
	BvmPm3Q/1A4jQUu+ZHnsYV10QCqYMrlHyRBti8uJ2r/iyZ5vtG+PCPXGpeMquDvL9laiEUXVPTw
	SLGq1OnPoo0a5LU5tjxA8CqFOiIspgsgv5VtxezlQM5XMECE3gtYE9R0lZ3VS
X-Received: by 2002:a05:6214:246a:b0:6cb:bc57:d840 with SMTP id 6a1803df08f44-6d1856b5615mr3813286d6.3.1729884289994;
        Fri, 25 Oct 2024 12:24:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFLFymaf4R41fHwjqkvWTwAkfwHaKv/afK0j85pTCGuheLL7dDzp+Y9LhFBEJGXlVq7rzUSA==
X-Received: by 2002:a05:6214:246a:b0:6cb:bc57:d840 with SMTP id 6a1803df08f44-6d1856b5615mr3813166d6.3.1729884289641;
        Fri, 25 Oct 2024 12:24:49 -0700 (PDT)
Received: from [192.168.212.120] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9b307b5375sm99385966b.155.2024.10.25.12.24.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Oct 2024 12:24:49 -0700 (PDT)
Message-ID: <5fe37609-ed58-4617-bd5f-90edc90f5d8b@oss.qualcomm.com>
Date: Fri, 25 Oct 2024 21:24:46 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/4] arm64: dts: qcom: qcs615: add UFS node
To: Xin Liu <quic_liuxin@quicinc.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: Vinod Koul <vkoul@kernel.org>, Kishon Vijay Abraham I
 <kishon@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Andy Gross <agross@kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, quic_jiegan@quicinc.com,
        quic_aiquny@quicinc.com, quic_tingweiz@quicinc.com,
        quic_sayalil@quicinc.com
References: <20241017042300.872963-1-quic_liuxin@quicinc.com>
 <20241017042300.872963-4-quic_liuxin@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20241017042300.872963-4-quic_liuxin@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: nPj_WckqInRAwB72VoXyJhOQsV7TdneU
X-Proofpoint-GUID: nPj_WckqInRAwB72VoXyJhOQsV7TdneU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 lowpriorityscore=0
 clxscore=1011 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410250149

On 17.10.2024 6:22 AM, Xin Liu wrote:
> From: Sayali Lokhande <quic_sayalil@quicinc.com>	
> 	
> Add the UFS Host Controller node and its PHY for QCS615 SoC.
> 
> Signed-off-by: Sayali Lokhande <quic_sayalil@quicinc.com>
> Co-developed-by: Xin Liu <quic_liuxin@quicinc.com>
> Signed-off-by: Xin Liu <quic_liuxin@quicinc.com>
> ---

+ Taniya (see below)

>  arch/arm64/boot/dts/qcom/qcs615.dtsi | 74 ++++++++++++++++++++++++++++
>  1 file changed, 74 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/qcs615.dtsi b/arch/arm64/boot/dts/qcom/qcs615.dtsi
> index fcba83fca7cf..689418466dc2 100644
> --- a/arch/arm64/boot/dts/qcom/qcs615.dtsi
> +++ b/arch/arm64/boot/dts/qcom/qcs615.dtsi
> @@ -458,6 +458,80 @@ mmss_noc: interconnect@1740000 {
>  			qcom,bcm-voters = <&apps_bcm_voter>;
>  		};
>  
> +		ufs_mem_hc: ufs@1d84000 {

ufshc@ would be consistent with other files in dts/qcom


> +			compatible = "qcom,qcs615-ufshc", "qcom,ufshc", "jedec,ufs-2.0";
> +			reg = <0x0 0x01d84000 0x0 0x3000>, <0x0 0x01d90000 0x0 0x8000>;
> +			reg-names = "std", "ice";

One per line, please

> +			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
> +			phys = <&ufs_mem_phy>;
> +			phy-names = "ufsphy";
> +			lanes-per-direction = <1>;
> +			#reset-cells = <1>;
> +			resets = <&gcc GCC_UFS_PHY_BCR>;
> +			reset-names = "rst";
> +
> +			power-domains = <&gcc UFS_PHY_GDSC>;
> +			required-opps = <&rpmhpd_opp_nom>;
> +
> +			iommus = <&apps_smmu 0x300 0x0>;
> +			dma-coherent;
> +
> +			interconnects = <&aggre1_noc MASTER_UFS_MEM QCOM_ICC_TAG_ALWAYS
> +					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
> +					<&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ALWAYS
> +					 &config_noc SLAVE_UFS_MEM_CFG QCOM_ICC_TAG_ALWAYS>;
> +			interconnect-names = "ufs-ddr",
> +					     "cpu-ufs";
> +
> +			clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
> +				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
> +				 <&gcc GCC_UFS_PHY_AHB_CLK>,
> +				 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
> +				 <&rpmhcc RPMH_CXO_CLK>,
> +				 <&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
> +				 <&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
> +				 <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
> +			clock-names = "core_clk",
> +				      "bus_aggr_clk",
> +				      "iface_clk",
> +				      "core_clk_unipro",
> +				      "ref_clk",
> +				      "tx_lane0_sync_clk",
> +				      "rx_lane0_sync_clk",
> +				      "ice_core_clk";
> +			freq-table-hz = <50000000 200000000>,
> +					<0 0>,
> +					<0 0>,
> +					<37500000 150000000>,
> +					<0 0>,
> +					<0 0>,
> +					<0 0>,
> +					<75000000 300000000>;

Please try to match the order of properties present in sm8650.dtsi

And please use an OPP table instead of freq-table-hz (see sm8*5*50.dtsi)

> +
> +			status = "disabled";
> +		};
> +
> +		ufs_mem_phy: phy@1d87000 {
> +			compatible = "qcom,qcs615-qmp-ufs-phy", "qcom,sm6115-qmp-ufs-phy";
> +			reg = <0x0 0x01d87000 0x0 0xe00>;

This register region is a bit longer

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

The PHY is a clock provider. Normally, it's a parent of
gcc_ufs_phy_[rt]x_symbol_n clocks.

Taniya, could you please wire that up in your patchset?

Konrad

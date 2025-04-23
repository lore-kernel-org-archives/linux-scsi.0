Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F901EB1B7
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 12:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745410702; cv=none; b=KTH2LDMN8N2Ak1pIu1C7O/Hl7Ah5VTzTlOPCpnMtBHVnADx6ut77uaLdpSdt47LHoLc93aiSKT+80K7B789TPTY+oc6enuxLkRNo6PWPN1OQUNHLMwOBO0My833Kr7Pad4GMbzqu7MV5bHAs0iAkLPoIa2WPvc95vQx7RBnwqyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745410702; c=relaxed/simple;
	bh=tCHjkL1SLgoL2j2PMqkiNHKmGBzODwMfabfskxgGLgY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hc9I7L7hJ4SJA/ipHKbhgD2sfGccQMFOQtGH7LA7VvWBtRGSOIBvsNNu4w3oCiiwlMDbmPuC9xCyZPD+xloLvc5fDdTDLL4p+ZXzzIGLf3JmHs5rkQWPDtaa6bcXDceXCjJd8b4Qq9JFcB9XtOsnPjMNGU4yyljiCUmX2iy7cik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Si+5gSsH; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Si+5gSsH"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53NAPCIH008429
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 12:18:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ioGfs5MtgxexvBjcj4mXKq9ldJm50YBOXelQWnDDA+w=; b=Si+5gSsH5Sq4CR5G
	Zobx6D0+awRftNyIeqLD7wIQskcuztJErV9gBIQp2+U6xijczIIGrGoV3uMuvabf
	cR2Xq8lPy7e8jzNEHDBW+Og4hF5TZymj9fK/dEZzsIqvbifYODTJbgyUohcQ64+u
	0X4uPBqGFeeHEAdZ5+1hXskww8AEFCL86Squ1tM1exBkLb5iGs0PXfZdkADjR3M6
	xq1FhOyRQWGM1oeaQTo0L0a/yBRvylt0hKZKgfCANbK3gwS0ayoj1gl7bPDuhqPG
	LxAOgDlMO66Wd5eF2yvBd/PwJx6SGqzIu3vcrZc2MrGFEWvmTNoGel42tBrLw6u7
	lJVAvQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 466jh5a3a1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 12:18:18 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7c54788bdf7so28137285a.2
        for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 05:18:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745410698; x=1746015498;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ioGfs5MtgxexvBjcj4mXKq9ldJm50YBOXelQWnDDA+w=;
        b=TV2Q49smVChuZ7X0t+tFNSr2S77EJVMddFkKpIsA4IhQ38Pt8kr7CzZLADUM8QTC0r
         7ImxSyA78tESEpXwyX/ZWhHUm8KDgcDSoJyPczGDIgX3LzSgbjxlpTpHTJcfMz0lBIQs
         o5Noax//12QA/onim66ysyGUCNj0aVlp7RWgN9dta+kVrf9BWrgVq3MCt1rVATNxMLQG
         YxD3AhdZx9mqa+PkJ6vY8Zppl1enmleZZvgbMuHjRwFKAsjRgWJIrrz0nh3mDckILb1u
         NLsslSx/zR46z0BL1A+IFX4sttuxweEUzRu8/NoLEKRbzr+P2qyWociLqOPB5e87gSX5
         NzUQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+DtAzLN7GNs/lL0kujO5B1YdJQ3iUlvcMRRgXfJXzjK2lxfSIhzxC9WON9z5M3o8n+uMfD1NW0oYJ@vger.kernel.org
X-Gm-Message-State: AOJu0YwFnk+/MBMEl+tpgpIK85/4ITPv4dY13hVH3bn4gVCZ9qy0kUmv
	CWSnB4sEW2uDOXxKjzws1yVrECxmBZgs9FQC0Zn1EyN+vO2d8E/tR+/h8I/qGzEUtOWCGqly519
	5ZzGJieDHNjLOP3Y4nzAakcM1oQ4ARZEigKXsVq/3xTNdzRAMKq+mrpcShnPe
X-Gm-Gg: ASbGncuJa1IQb7BZ2gxAHE6lf9avxCzJMjvSKC5H2j0PKLR2WT54d2Bmg5x/TpZ8U+L
	RVaIq2GxRDdat4unqTpD3NXZSFOchf/WSKA0GTYUEFAx2aKnVUDa+PMJ0bVVHP7bIhp9yXbeKK6
	JszfPYu2fYe5//27sJlpt2Evgm/lLGyjYztkeIOpq6Y8wEqNNlD8SKGangVpogdaYcGjQnTg/w8
	HhggjtqmwwdvG2nQXu/Bnw70MFktzd31Dcnse4crnZe9XIRdhdPIOUZBfWfLHQy682bmXjNOciQ
	NBufPLm/j7S0O8VM7AoZow5hZm649jyJV+1MYYjSZHshqHnGWd7Rxd+5wkEtmGvHW3Q=
X-Received: by 2002:a05:620a:2492:b0:7c0:be0e:cb09 with SMTP id af79cd13be357-7c94d266c35mr148952085a.7.1745410697592;
        Wed, 23 Apr 2025 05:18:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEav1ZFFMWH2+h22EnPEjP1DswVCKNGIgBpCwJp2VazcB6M7t8R/W/1xgUW9/XgzClpBqzW6A==
X-Received: by 2002:a05:620a:2492:b0:7c0:be0e:cb09 with SMTP id af79cd13be357-7c94d266c35mr148944985a.7.1745410697019;
        Wed, 23 Apr 2025 05:18:17 -0700 (PDT)
Received: from [192.168.65.183] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb6efadd51sm817256866b.179.2025.04.23.05.18.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 05:18:16 -0700 (PDT)
Message-ID: <e0a61158-6278-45bc-bc5c-fe35227bdbf1@oss.qualcomm.com>
Date: Wed, 23 Apr 2025 14:18:05 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 30/33] arm64: dts: qcom: Add dtsi for Snapdragon
 730/730g/732g (SM7150) SoCs
To: Danila Tikhonov <danila@jiaxyga.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck
 <linux@roeck-us.net>,
        Rajendra Nayak <quic_rjendra@quicinc.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Bjorn Andersson
 <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Amit Kucheria <amitk@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wesley Cheng <quic_wcheng@quicinc.com>, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Souradeep Chowdhury <quic_schowdhu@quicinc.com>,
        Lee Jones <lee@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
        "David S . Miller"
 <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Alex Elder <elder@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Andy Gross <agross@kernel.org>,
        Srinivas Kandagatla <srini@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Georgi Djakov <djakov@kernel.org>,
        Loic Poulain <loic.poulain@oss.qualcomm.com>,
        Robert Foss
 <rfoss@kernel.org>, Andi Shyti <andi.shyti@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd
 <sboyd@kernel.org>, Taniya Das <quic_tdas@quicinc.com>,
        Sibi Sankar <quic_sibis@quicinc.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Imran Shaik <quic_imrashai@quicinc.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Jessica Zhang <quic_jesszhan@quicinc.com>,
        David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>, Kees Cook <kees@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        "Guilherme G . Piccoli" <gpiccoli@igalia.com>,
        David Wronek <david@mainlining.org>,
        Jens Reidel <adrian@mainlining.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
        linux-remoteproc@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-hardening@vger.kernel.org, linux@mainlining.org,
        ~postmarketos/upstreaming@lists.sr.ht
References: <20250422213137.80366-1-danila@jiaxyga.com>
 <20250422213137.80366-14-danila@jiaxyga.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250422213137.80366-14-danila@jiaxyga.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDIzMDA4NSBTYWx0ZWRfXxPFjr3Ql37/D 4jK9B4O1gA6g5TckysIE5gyFQTK1yJ+4ndQt7zshLOjl2JXqjgLyZPWuzeFqqLj33K7hjz2KEv0 sQiZD4q3Wuel6J6DZfk6pkXGQtfRMg5Fk4V1HIcNbqJcP0qsZXqWTZJIqNvMqkDjwRDsf/hj+nz
 1cKiii58AJdTi6Xx6RJYaOAUf4EY9sTv/3g2TqHZTyBfLj4u9eWsG4HZw9HZtA7yive82jX19wm dXO94xk52+0OHdAMGCI+v2+UTBQaD/ZBN7Ge9UzkcvdquuoiRuaOTwTumgSOfARfphw/Uc8dFrv DAsYbHIGPOluFWtLMjZZFglVMaPoosWsMkR6d1b1bMEjbw3Riq80T33j6CZQ7SKTmW5gnJ0msC1
 IYopONyJnkNpXYlshCjJ0qH8gDiW47lLB8vxOa2DS/zKUksgzvAyVuKG0vTVWAT3+Vt0BP81
X-Proofpoint-GUID: F81fjGsgudDACXjb30AnLhv6AfLy2sy0
X-Authority-Analysis: v=2.4 cv=B/S50PtM c=1 sm=1 tr=0 ts=6808da8a cx=c_pps a=50t2pK5VMbmlHzFWWp8p/g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=OuZLqq7tAAAA:8 a=7ibcVnAUAAAA:8
 a=uu6HZSQSBnFQn7oXV_IA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22 a=cvBusfyB2V15izCimMoJ:22 a=AKGiAy9iJ-JzxKVHQNES:22 a=HywIFdX19-EX8Ph82vJO:22
X-Proofpoint-ORIG-GUID: F81fjGsgudDACXjb30AnLhv6AfLy2sy0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.80.40
 definitions=2025-04-23_07,2025-04-22_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=636
 lowpriorityscore=0 bulkscore=0 impostorscore=0 suspectscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0 clxscore=1015
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504230085

On 4/22/25 11:31 PM, Danila Tikhonov wrote:
> Add base dtsi for SM7150-AA/SM7150-AB/SM7150-AC SoCs
> 
> Co-developed-by: David Wronek <david@mainlining.org>
> Signed-off-by: David Wronek <david@mainlining.org>
> Co-developed-by: Jens Reidel <adrian@mainlining.org>
> Signed-off-by: Jens Reidel <adrian@mainlining.org>
> Signed-off-by: Danila Tikhonov <danila@jiaxyga.com>
> ---

[...]

> +		cpu0: cpu@0 {
> +			device_type = "cpu";
> +			compatible = "qcom,kryo470";

Please split this into Kryo 470 silver and gold, with the former being
based on CA55 and the latter on CA76

[...]

> +	pmu-a55 {
> +		compatible = "arm,cortex-a55-pmu";
> +		interrupts = <GIC_PPI 7 IRQ_TYPE_LEVEL_LOW>;
> +	};
> +
> +	pmu-a76 {
> +		compatible = "arm,cortex-a78-pmu";
> +		interrupts = <GIC_PPI 7 IRQ_TYPE_LEVEL_LOW>;
> +	};

Please update this, mimicking 

2c06e0797c32 ("arm64: dts: qcom: sm8650: add PPI interrupt partitions for the ARM PMUs")

> +
> +	psci {
> +		compatible = "arm,psci-1.0";
> +		method = "smc";
> +
> +		cpu_pd0: power-domain-cpu0 {
> +			#power-domain-cells = <0>;
> +			power-domains = <&cluster_pd>;
> +			domain-idle-states = <&little_cpu_sleep_0
> +					      &little_cpu_sleep_1>;

<&foo>,
<&foo2>;

because they are phandles to separate things - DTC treats them equally
though..

[...]

> +				interconnects = <&aggre1_noc MASTER_QUP_0 QCOM_ICC_TAG_ALWAYS
> +						 &config_noc SLAVE_QUP_0 QCOM_ICC_TAG_ALWAYS>,
> +						<&gem_noc MASTER_AMPSS_M0 QCOM_ICC_TAG_ALWAYS
> +						 &config_noc SLAVE_QUP_0 QCOM_ICC_TAG_ALWAYS>,

Paths involving AMPSS_M0 (the cpu endpoint) should be ACTIVE_ONLY,
this applies to the entire file and all paths

[...]

> +		remoteproc_adsp: remoteproc@62400000 {
> +			compatible = "qcom,sm7150-adsp-pas";
> +			reg = <0x0 0x62400000 0x0 0x100>;

This region is 0x10_000 long

[...]

> +		adreno_smmu: iommu@5040000 {
> +			compatible = "qcom,sm7150-smmu-v2",
> +				     "qcom,adreno-smmu",
> +				     "qcom,smmu-v2";
> +			reg = <0x0 0x05040000 0x0 0x10000>;
> +
> +			interrupts = <GIC_SPI 229 IRQ_TYPE_LEVEL_HIGH>,
> +				     <GIC_SPI 231 IRQ_TYPE_LEVEL_HIGH>,
> +				     <GIC_SPI 364 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 365 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 366 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 367 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 368 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 369 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 370 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 371 IRQ_TYPE_EDGE_RISING>;
> +
> +			clocks = <&gpucc GPU_CC_AHB_CLK>,
> +				 <&gcc GCC_GPU_MEMNOC_GFX_CLK>,
> +				 <&gcc GCC_GPU_SNOC_DVM_GFX_CLK>;
> +			clock-names = "ahb",
> +				      "bus",
> +				      "iface";
> +
> +			power-domains = <&gpucc CX_GDSC>;
> +
> +			#iommu-cells = <1>;
> +			#global-interrupts = <2>;

Add `dma-coherent` and check whether the GPU still works

[...]

> +		};
> +
> +		gmu: gmu@506a000 {
> +			compatible = "qcom,adreno-gmu-618.0",
> +				     "qcom,adreno-gmu";
> +			reg = <0x0 0x0506a000 0x0 0x31000>,

Make it 0x26_000 so that it doesn't leak into GPU_CC

[...]

> +		tsens0: thermal-sensor@c263000 {
> +			compatible = "qcom,sm7150-tsens",
> +				     "qcom,tsens-v2";
> +			reg = <0x0 0x0c263000 0x0 0x1ff>, /* TM */
> +			      <0x0 0x0c222000 0x0 0x1ff>; /* SROT */

Please remove these comments

[...]

> +		intc: interrupt-controller@17a00000 {
> +			compatible = "arm,gic-v3";
> +			reg = <0x0 0x17a00000 0x0 0x10000>,  /* GICD */
> +			      <0x0 0x17a60000 0x0 0x100000>; /* GICR * 8 */

And these ones too

[...]

> +	thermal-zones {

Please adjust this against 

https://lore.kernel.org/linux-arm-msm/20250219-x1e80100-thermal-fixes-v1-0-d110e44ac3f9@linaro.org/

(keep only critical trips with no sw cooling for the CPU, etc.)

Konrad

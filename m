Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9E929D294
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 10:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768213802; cv=none; b=nhGT2z7VqmsKf8XDjibbDKfwgOzeK+vC9ZM6/9MKEBx3W59DDWRLUHZaD9+Vxla5zEKJYkRbPRArH342ja4i4j1cNoTHiiw3EA9cnEcremHtzXLOIQdzLY6YHAXbyLc6JmMpSg67i16UlDnCVHav0K5r+Xy9B5yTWjjPPanRQxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768213802; c=relaxed/simple;
	bh=zxYqm0zQueh0U0yDRbTPD4QtsJ7Bx27wmqHwL5z/+7A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LN0mEYg6MXlizeCwPCL44e6DYPooSuzhhqzy5WjWjB+0MK31Il78c42pdu79OHyigw70XE2ZLvDks8m/1GQr14aYjxRXwkNegMJ/MY11FTRCn22a3NNj8xildPVTQxPes992TYx8sn3urjuYhLTl9yVsFQiIk6z10TQbQ2YwnXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mKcniPiC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Bu4u0C4a; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mKcniPiC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Bu4u0C4a"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60C8pQ7w113363
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 10:29:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bxMVnP7klhF7zuicFFjZTjp3gwEJfISaysxyhwsH6zU=; b=mKcniPiCqKedrd1a
	ZUavt6rBtOP9PeRqG2qVS49oIRhL6AIthCiVoVjr8f2DbNgTRdVTW0+4NdwzwiTz
	mFnrtTo4ozC736ydacctG+gIxMusfsYN3gmym7B6h/Mv4BJJNTfl7NMK72cPBA/D
	lIWXR/U47x8G8F/Jy5k9RlNIJdrByd6jRvT15zXcKVSq1TYUcRNzMqjSkjNAFLho
	1qQYnEuDtZw7atGKh9tu+dUdvwVqYvL1z9/JK8LvjzbMQ8FytlMWyR75dfZWknmj
	2SULBr9nOtM/PrKw16HaGYI6Gw6oqExCw5lS46DsF9OWAeNPF/wQwaS74TFB5AGP
	5ZKobQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bmr4uhcjt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 10:29:59 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8b2de66a28eso186168985a.2
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 02:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1768213798; x=1768818598; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bxMVnP7klhF7zuicFFjZTjp3gwEJfISaysxyhwsH6zU=;
        b=Bu4u0C4amzGQv55u6EpOQEEtFY7GRKj/YEvL1WGKy9IDYmL0ok+uRwq6SUwCwSIF6P
         zUexIOpD7hmL4rI/W7mSYNXP+G/HsCW4HPiMSzEnYWSxlM6c42UFQ+xkTOV5D/7T49Ro
         iH5RkVsFF3iF0B2HYOc8+TIxfBNRACHF00fWdPVK/zARO8ovPrrTEkHZK/ud4X3RBcls
         z4mOQv4FOANPI4wzAY37fNF8KTNM85MbuAhZq455jf5brrViMRvC8VSNDjKGNNx88Mwp
         HCIV2ZU13kUscx/01ArB0ukr1K6y652JTFNJva8x9715ydtQHyz9xjJV+sCFXZZfwlP8
         7Smw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768213798; x=1768818598;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bxMVnP7klhF7zuicFFjZTjp3gwEJfISaysxyhwsH6zU=;
        b=vw0UNzL6At0eKhmdcQkdbcK1l9s3KP8wmCRJiB9rfyLqgF0+SfpUkUUTs7kB29sIgW
         79Bj0w6PkiUJypiwPB+zame0rt3wlYORHgT8bMSfXiFaZR4wpC+8UN+Il91VxraJi21m
         Gsisyl0GupYOH0XVGCZe2ISe82KI5fu8bPuCOXDe8wAXZSCIHOwiXssKmd56WT1De9H8
         egv1SLr31J1+aHsaHoqrZqxuwPh0VAGfKidg+5KiTrM1pELIGzm/HMwffGRKzxTW7dY7
         Kd3Bt403YRbo8zLiruMsTmIZscQndLH8TvoaGT/MQJ4bJVrQe0MXqp9ZqgvaGsvOjI7I
         +REg==
X-Forwarded-Encrypted: i=1; AJvYcCXOTPmJgF6eRjZdRYFLBOuzhPktb2/DvI+ua9QWTvVY/685P0MMTYxq/9BZtivJA5ZNXqmgvdt/3dZ8@vger.kernel.org
X-Gm-Message-State: AOJu0YxNMJn5D+vUad42Gajc1/RYV4YQ4/omQFroqdI1pL5LPBVhg3ao
	uEZL9Xe0oi/MYMs+m6QyZYuT3zPOT6KUhdsUnzVoVQS/Cbng2oP0lneY0Td5vwb2zHNff/8DDkV
	8qI/YBJDvRzVYpYQM52Ya0gy5RyLfsCNPf1xiYTN2TBBD00DpiNZHEd6/m3eZHvbKAiSNR9f7
X-Gm-Gg: AY/fxX7dAT4VDoCSU2usWx9Hf3UDIYIfKrPI65TssJQhMzU7yz4F3APBAnT80JLJBYy
	fNyPcNVyeJUvKnA1B1UpJ3lRFUjMvEF99JuzxgKogs1xNi8IXgoHINzXQnaQ0XuckwCvta81nSy
	e0nAyeJR9nlU37MY9MJcWjzw0qJoVa0Jy3HMOltkMaxUa7MVrbU3y/p4yKktgym+UXjJYhFw6VF
	kc3Wk/ZoAtCZu3+rHAgoIRoMy1yeYdRP4H2oZcw3GbtT/Bt9PWO31ubOSB8fZ+fXggk9kEbBg9u
	9OcGEXbNlPUOvabAu/yfWnvCanzSX6MXpkgleRAw1hnpusdICN+Z4MylgfNZ4JKCTYaiSDm6KJQ
	m2xWQfV2Cghc/k1WHJ79fUUV416epYub7gXhY5N7xU0kK5KUhu497MNWyv8ea2E55RCg=
X-Received: by 2002:a05:620a:4150:b0:8be:7dd7:f041 with SMTP id af79cd13be357-8c3893dc319mr1707033985a.7.1768213798001;
        Mon, 12 Jan 2026 02:29:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFYkinKvuUhGe4V4yaanPySErY45GVSf7HQse7lAC+h88C4FKeCk2VIkqMj67TZjna5NhPTaQ==
X-Received: by 2002:a05:620a:4150:b0:8be:7dd7:f041 with SMTP id af79cd13be357-8c3893dc319mr1707031185a.7.1768213797514;
        Mon, 12 Jan 2026 02:29:57 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b86fee09163sm593221066b.26.2026.01.12.02.29.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jan 2026 02:29:56 -0800 (PST)
Message-ID: <ccbaff51-d7fa-4b22-8d4e-02bea5d8a529@oss.qualcomm.com>
Date: Mon, 12 Jan 2026 11:29:54 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] arm64: dts: qcom: milos: Add UFS nodes
To: Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Vinod Koul <vkoul@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org
References: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
 <20260107-milos-ufs-v1-5-6982ab20d0ac@fairphone.com>
 <2486dc4b-71f3-4cd9-8139-b397407d7e4d@linaro.org>
 <543d9e55-c858-40f9-8785-c9f636850120@linaro.org>
 <DFMH8W40TCJ0.XCTHNRJFJE4T@fairphone.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <DFMH8W40TCJ0.XCTHNRJFJE4T@fairphone.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEyMDA4MiBTYWx0ZWRfX4XfJLsbqbKG6
 MsH9gG/z9RlGCR4mA0BXEa7FtfpzJUHHk9A57PqO3W7xrMys2Lxe2MSkmwLLyx5nJnR2P8MKDr8
 uCLoyNHorYndQj4JjtulJ+SjrdFIDs4AOeTGX5hzW7Nh0v008hORKEt0J6Db+DxAPZydOweMmoJ
 Ptj+X07JUAq8yh3PkPtLGn0uohUHTrX1kRNnRhQyyDCdEEiAcc69QPyCPqAZI+lut8N8aPA/2N8
 ew4uwhvj6ZCTibYlTTlsgjzLZLNpS6hMLMcDa4QA8vNG347n7Hw4uQ7N/qBK+oJPz5KfrWLFGJz
 eI/1Msw65OMwPk7KqmP97q3mpvqlpO5GW1I8BtOxXolVLxbGjVRpk2tLeI1quy9+lh2vRrvGDmC
 U+A57ZBzXRi6tNDpwdDGrZKH1sH0j68LIdfG6tGIBJr1RhrQBXHCjQ4OU3z/WdZoa8GJ/XpjGAN
 khVl+XX/VngAelD2QNg==
X-Proofpoint-ORIG-GUID: fILSqVtLcG-i1McDyXo_pD6TYmxMgYBF
X-Authority-Analysis: v=2.4 cv=YocChoYX c=1 sm=1 tr=0 ts=6964cd27 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=6H0WHjuAAAAA:8 a=7X8Kw1P6343en4nalX4A:9
 a=ZPF2tL_FRqzNxS05:21 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-GUID: fILSqVtLcG-i1McDyXo_pD6TYmxMgYBF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-12_03,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 clxscore=1015 impostorscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601120082

On 1/12/26 9:45 AM, Luca Weiss wrote:
> Hi Neil,
> 
> On Mon Jan 12, 2026 at 9:26 AM CET, Neil Armstrong wrote:
>> On 1/7/26 14:53, Neil Armstrong wrote:
>>> Hi,
>>>
>>> On 1/7/26 09:05, Luca Weiss wrote:
>>>> Add the nodes for the UFS PHY and UFS host controller, along with the
>>>> ICE used for UFS.
>>>>
>>>> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
>>>> ---
>>>>   arch/arm64/boot/dts/qcom/milos.dtsi | 127 +++++++++++++++++++++++++++++++++++-
>>>>   1 file changed, 124 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/boot/dts/qcom/milos.dtsi b/arch/arm64/boot/dts/qcom/milos.dtsi
>>>> index e1a51d43943f..0f69deabb60c 100644
>>>> --- a/arch/arm64/boot/dts/qcom/milos.dtsi
>>>> +++ b/arch/arm64/boot/dts/qcom/milos.dtsi
>>>> @@ -797,9 +797,9 @@ gcc: clock-controller@100000 {
>>>>                    <&sleep_clk>,
>>>>                    <0>, /* pcie_0_pipe_clk */
>>>>                    <0>, /* pcie_1_pipe_clk */
>>>> -                 <0>, /* ufs_phy_rx_symbol_0_clk */
>>>> -                 <0>, /* ufs_phy_rx_symbol_1_clk */
>>>> -                 <0>, /* ufs_phy_tx_symbol_0_clk */
>>>> +                 <&ufs_mem_phy 0>,
>>>> +                 <&ufs_mem_phy 1>,
>>>> +                 <&ufs_mem_phy 2>,
>>>>                    <0>; /* usb3_phy_wrapper_gcc_usb30_pipe_clk */
>>>>               #clock-cells = <1>;
>>>> @@ -1151,6 +1151,127 @@ aggre2_noc: interconnect@1700000 {
>>>>               qcom,bcm-voters = <&apps_bcm_voter>;
>>>>           };
>>>> +        ufs_mem_phy: phy@1d80000 {
>>>> +            compatible = "qcom,milos-qmp-ufs-phy";
>>>> +            reg = <0x0 0x01d80000 0x0 0x2000>;
>>>> +
>>>> +            clocks = <&rpmhcc RPMH_CXO_CLK>,
>>>> +                 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
>>>> +                 <&tcsr TCSR_UFS_CLKREF_EN>;
>>>> +            clock-names = "ref",
>>>> +                      "ref_aux",
>>>> +                      "qref";
>>>> +
>>>> +            resets = <&ufs_mem_hc 0>;
>>>> +            reset-names = "ufsphy";
>>>> +
>>>> +            power-domains = <&gcc UFS_MEM_PHY_GDSC>;
>>>> +
>>>> +            #clock-cells = <1>;
>>>> +            #phy-cells = <0>;
>>>> +
>>>> +            status = "disabled";
>>>> +        };
>>>> +
>>>> +        ufs_mem_hc: ufshc@1d84000 {
>>>> +            compatible = "qcom,milos-ufshc", "qcom,ufshc", "jedec,ufs-2.0";
>>>> +            reg = <0x0 0x01d84000 0x0 0x3000>;
>>>> +
>>>> +            interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH 0>;
>>>> +
>>>> +            clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
>>>> +                 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
>>>> +                 <&gcc GCC_UFS_PHY_AHB_CLK>,
>>>> +                 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
>>>> +                 <&tcsr TCSR_UFS_PAD_CLKREF_EN>,
>>>> +                 <&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
>>>> +                 <&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
>>>> +                 <&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
>>>> +            clock-names = "core_clk",
>>>> +                      "bus_aggr_clk",
>>>> +                      "iface_clk",
>>>> +                      "core_clk_unipro",
>>>> +                      "ref_clk",
>>>> +                      "tx_lane0_sync_clk",
>>>> +                      "rx_lane0_sync_clk",
>>>> +                      "rx_lane1_sync_clk";
>>>> +
>>>> +            resets = <&gcc GCC_UFS_PHY_BCR>;
>>>> +            reset-names = "rst";
>>>> +
>>>> +            interconnects = <&aggre1_noc MASTER_UFS_MEM QCOM_ICC_TAG_ALWAYS
>>>> +                     &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
>>>> +                    <&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
>>>> +                     &cnoc_cfg SLAVE_UFS_MEM_CFG QCOM_ICC_TAG_ACTIVE_ONLY>;
>>>> +            interconnect-names = "ufs-ddr",
>>>> +                         "cpu-ufs";
>>>> +
>>>> +            power-domains = <&gcc UFS_PHY_GDSC>;
>>>> +            required-opps = <&rpmhpd_opp_nom>;
>>>> +
>>>> +            operating-points-v2 = <&ufs_opp_table>;
>>>> +
>>>> +            iommus = <&apps_smmu 0x60 0>;
>>>
>>> dma-coherent ?
> 
> 
> Given that downstream volcano.dtsi has dma-coherent in the ufshc@1d84000
> node, looks like this is missing in my patch.

Seems that way

>>>
>>> and no MCQ support ?
> 
> Not sure, I could only find one reference to MCQ on createpoint for
> milos, but given there's no mcq_sqd/mcq_vs reg defined downstream, and I
> couldn't find anything for the same register values in the .FLAT file, I
> don't think Milos has MCQ? Feel free to prove me wrong though.
> 
>>
>> So, people just ignore my comment ?
>>
>> Milos is based on SM8550, so it should have dma-coherent, for the MCQ
>> I hope they used the fixed added to the SM8650 UFS controller for MCQ.
> 
> Not sure what this should mean regarding MCQ...

This platform doesn't support MCQ

Konrad

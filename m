Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37531FCFE5
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2025 10:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737973413; cv=none; b=txEbH6UyylxXngzeHbi6qnf+XE26Wy0Gev7ZFUAeNpJMglwsu0fSOwV7MaM7kaElKXsuOXQQHghcEkVNHm4aK6SALUO3kCTM58nNVuoV+ZxnqGB0CRfAxLciUXUArHTTHQBCIjNbwvYRPAf7efCEh0CyDDlpbL61ktC9n+SuuC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737973413; c=relaxed/simple;
	bh=/ziQCxNO8jspCZEWeweEbldQZWZOoyzeslfitT30Ucs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OzLrlFpYT0TCiAxkjQRUzCJlTCmLJKm8U/BZOmbmR2TVflMKB38qzdgtmsNAt0SJwo8wH9Qay+qH+21HT0Gkxe3/fBxXl6GAuZsKZC+gLWRA5SlbRabPk29PTQJTmJ4mdIsoZpZM6uy1P5PTssDGq4POtcsNgd5uGrKDWZ1baDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DJFwnw47; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DJFwnw47"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50R4sw4A024775
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2025 10:23:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hGB5OVb68LNt8gE8AS+bpnEVv8dQ+ZWfbCKV+Fgql1s=; b=DJFwnw47aPPLlcK9
	HWN/KcRu8+0A34vgbRvLmEldSMPh61ljyB/ekcDy+FL3+geO6HqAyWgMRDuI0fYb
	yLY+szCFQQD60ymx13gFrE2Wgd+fapD/uLeu0jBCL4+cZCmcnujYIis3+SMoVj/v
	d0RHHqAZ8+IgKFt2juXwKcQrrCiZ2mp+Hbejtc5HTir3FdL7S5YIFKPNVYKiaQmC
	VZVoefqy5JaV8/K1eGqSln3oDHCSBMrsi3gz8/+JxdR/HvIxhfDGIDhnQp8NgtTB
	qIYLtgHRfUasMIxWRJO8KZvcwRTGmutW3QUbeAJNnP2aRo5QvnLRHTBdkHqBBSQH
	lJo43A==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 44e3h2rm0c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2025 10:23:30 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-467975f1b53so12995391cf.3
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2025 02:23:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737973409; x=1738578209;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hGB5OVb68LNt8gE8AS+bpnEVv8dQ+ZWfbCKV+Fgql1s=;
        b=Nv4zhvvMdr0ym6Ai7OVHw8shyDCEq/5IDXmer/fzvWKY40VMWj80S1YOVVV2zpXM7R
         InWQLDtTITyQNxsvXTOccCwgkcIQQTWx2EZ6CZg/8ThZnBdlV3Sj+8DEAQ1mS3cqtw35
         +AcdEPO7sGwoWED0K1Qbq88Hl+5Hst+iWX5lSsR+2PrUZe51jEq+TCbMR7ZNVm77J17P
         FTkhOrtVdnyLRaw87aZWf6vr5iOXiFcKxdyoxgcJFz5kadaxW7rR1aHqmQAUNSBk/Yzi
         Fibft9G3KbmaK3YDgbVGjHAePYov9VcmGMeixXnGMfe0oWxNH9fgQkh06TaxFHu1zmne
         ocJg==
X-Forwarded-Encrypted: i=1; AJvYcCXFgNKHzxz4tGGDVr/Rp8xasNCC+AR5K1sSqcKBW1yV/6QdwNUmArkRzXhREWhXGZT0m51inK+oTAtu@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6P9S4LO/iCisQhwGbrBWyaJu1tirBfx4vEQW2PkrKTI4AyCz/
	/eNXdF3jt+yYkqBuOMDRdkIMxzXIJnc8nxR0/7xMadX9ONzZJjEWGn0MGkGH0SpIk6roGUnSlOY
	8W6iHoWllJg3EsQeWTxpMWXipciM3Z6w+NcVlKscOtYFqlnNSCormOoCqzVht
X-Gm-Gg: ASbGnctG62rTK83+u/Fx3Qgy9lOpiExZNboac8tDCbtOHlQlXJgNr4x7hoNyIdSbhAO
	F1BbpYzyP6ejU5Zlers6vLoni9Fux7Yw5nMldHSJl2cWOsEnPLnJAQNdB2OsHQJtNurF9Mnhdz6
	lwsB3w13gMbUDDIwLXrKyD4NbnWmvdTZrC2CdA3ryyV/GtE7svX2vBTkAA4OJMlYfmgQYczsTGh
	ygbjBUl58cSVG2BW9mxt3grsRMKDKoLTFVfcLkQts1VEcCzugx0TaQapdRfOkh2Cod2UF7A7yEv
	N/jP31eD2uF8QI8JdCr75YOvC4Z4s0dBbyiTaVVPAJ4QuwIiVXIRlgX1S6Q=
X-Received: by 2002:a05:622a:1aa0:b0:467:825e:133b with SMTP id d75a77b69052e-46e12ba1478mr227274491cf.13.1737973409367;
        Mon, 27 Jan 2025 02:23:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHhhZmUefm+tAZLgJqV2ZW+k6GYLfZ7Ycaf8L6tOGjzPWuZ8gyIBxlMk/OY2hdBHc96AIiM+Q==
X-Received: by 2002:a05:622a:1aa0:b0:467:825e:133b with SMTP id d75a77b69052e-46e12ba1478mr227274371cf.13.1737973408993;
        Mon, 27 Jan 2025 02:23:28 -0800 (PST)
Received: from [192.168.65.90] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab675e11a1esm562672266b.33.2025.01.27.02.23.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2025 02:23:28 -0800 (PST)
Message-ID: <3ed5858c-3030-4edc-847d-28ff54ea5aea@oss.qualcomm.com>
Date: Mon, 27 Jan 2025 11:23:25 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] arm64: dts: qcom: sm8750: Add UFS nodes for SM8750
 SoC
To: Melody Olvera <quic_molvera@quicinc.com>, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson
 <andersson@kernel.org>,
        Andy Gross <agross@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>,
        Satya Durga Srinivasu Prabhala <quic_satyap@quicinc.com>,
        Trilok Soni <quic_tsoni@quicinc.com>
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Nitin Rawat <quic_nitirawa@quicinc.com>,
        Manish Pandey <quic_mapa@quicinc.com>
References: <20250113-sm8750_ufs_master-v1-0-b3774120eb8c@quicinc.com>
 <20250113-sm8750_ufs_master-v1-4-b3774120eb8c@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250113-sm8750_ufs_master-v1-4-b3774120eb8c@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: pLp-ihetJo1_hGX0UdIAHetVw4mBxqKi
X-Proofpoint-ORIG-GUID: pLp-ihetJo1_hGX0UdIAHetVw4mBxqKi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-27_04,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 phishscore=0 lowpriorityscore=0 adultscore=0 spamscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=999 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501270083

On 13.01.2025 10:46 PM, Melody Olvera wrote:
> From: Nitin Rawat <quic_nitirawa@quicinc.com>
> 
> Add UFS host controller and PHY nodes for SM8750 SoC.
> 
> Co-developed-by: Manish Pandey <quic_mapa@quicinc.com>
> Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> Signed-off-by: Melody Olvera <quic_molvera@quicinc.com>
> ---

I don't see anything wrong per se here, just some style nits
atop the other replies:

[...]

> +		ufs_mem_hc: ufs@1d84000 {
> +			compatible = "qcom,sm8750-ufshc", "qcom,ufshc", "jedec,ufs-2.0";

1 compatible per lines, please

> +			reg = <0x0 0x01d84000 0x0 0x3000>;
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
> +			freq-table-hz = <100000000 403000000>,
> +					<0 0>,
> +					<0 0>,
> +					<100000000 403000000>,
> +					<100000000 403000000>,
> +					<0 0>,
> +					<0 0>,
> +					<0 0>;
> +
> +			resets = <&gcc GCC_UFS_PHY_BCR>;
> +			reset-names = "rst";
> +
> +
> +

stray double \n

Konrad

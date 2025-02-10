Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581B91ACED2
	for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2025 19:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739215235; cv=none; b=WCN9eE3LO+n+E7FiO6Qc1b9mCdvTrtfrCHdY+j/gr7cF8019qLF1ZlISK7d/VM2TnS62ygnSdvyGXF6ti79v0sjC1BXfDuOJwOhLZ9TAa8oZDg9byae9/tRhde7gjlwjx8JVMYEex3gJJoHplbqBdXNb4ieuj0B0Rtpnkdwj6V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739215235; c=relaxed/simple;
	bh=2S8sds+FiM0QeleBbqPHslxZ1ylft5S/XBauMQ/noPc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AkAFE9vGJ3tJlNp4I30qZMT66AwbJt/aZUIYuS8A826q2Q+SK6sPw24XMVyqi+CftDV7J+ktJ04cRGL8BdsCX433WW+nap5eVbnPA7sAvwk7UJQTJlVk2YlmBB/tssUxxOUk9fBBBwofId8/tHrXYyJVEiyMA35tXjcIzlYVRPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=d3onEnb7; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="d3onEnb7"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51AISP88013192
	for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2025 19:20:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UHTGfvXpoiSary/QibcMXc8tUfGDgzwkgTomq3eCaA8=; b=d3onEnb7b6F2REdr
	agGZdVd0ylJuhAB5T1LsBZYP9jou9ZsTxCYsQ7jiqELxet6WR4g7AWTJSYia/CEK
	/RMJhKmHHDDQXVrrva4Y8rOHaecVIcZKY6AMRMw5Ah09H5aqsDNqA3PeRpxg87eV
	4JqHqbTpmwKCj9akV+m7yeBff2yF9YghM2gpAdwCATRTavOSp88Qq+ITX8a1MGCA
	3mp2HlSMglmFR2as9gZhW3cgU/NXxNfUrx6aOXT4mWlVXeLr4ZTIB+OxYCz97BxP
	xQ/VTcJD3DFrDVhrVeFWRyU2E8cvijdrO1AShoCrG5Yp+fGbHfZsqJBGgkk2iV3+
	oWOxsA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 44p0dqdg89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2025 19:20:33 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-46e4842dbd0so13723511cf.1
        for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2025 11:20:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739215232; x=1739820032;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UHTGfvXpoiSary/QibcMXc8tUfGDgzwkgTomq3eCaA8=;
        b=vzxWfTNS23rvBYmsIDoXznxAulyLxnZ0GMOINwu1cfqie5PNha8Nkb5VkQYNde0PrZ
         V40Kg45NylJuO7enou9bKIwDfX3sF7LvGnaO3+tITPH8nCBYyl7xvZ8gUEIYero0F4Mk
         gOmu3KDp+t+D1oDiqqVpYQXdtD+Q3CdhLoNUNoENkKqxr8DFX3vMOzfDwoX2aUgQCppo
         ety0DS5g/J1qnlelzMv9oVUSAEioGGoBB+4+EuQ6E3vnyNNuMVvwWpP0jgzlfu+K40Qp
         9RNEIvsbMgbf19BGkeJuxla5PdrkEuR/x6jPuXMeqpoyN+Engch6YiDxBVX+boqyj/BP
         QITA==
X-Forwarded-Encrypted: i=1; AJvYcCXTC6nRnseJu7ZaQ8P5bEuhWKYWvNoBCSpk2o83VbjAlHuUSFV1J24xFEqGZj2q3RPDHb1/pZE3nmuw@vger.kernel.org
X-Gm-Message-State: AOJu0YxLIVSIHmvu7WMjMr9VgucnF7OU+ozN2sQPHQxsuDQK0cdUGdiv
	DxpGakGhyar9yMWH2D07ha/0IJSX5hXDm8g25S0TOt2wS3eAz4kIObf6ItMuaLG603GR9Cw+HNz
	09c8tjH08fqaNYuMKwtNm6G/s59eD0g1NxNt+1wUOhpByjYGp51kOpdYLgtW0
X-Gm-Gg: ASbGncuLMD690AiA6GWWpWJ/T7lKne6mARuDvMEUf3vMQlpTscItN8Yyy53K8HWG5AW
	oYSVRV7sTXtFxdfmfQ6EXoV1xN9L7yOj7pqeVap/TSsgsB+sd1UhoVzvJIJAy9gkzcdbgKszUqK
	Dwl50uNWd2zm+cxWQXCQMxl8v2vyk/U+91x8meNTJuSg2WCjmWSNff1vqzWCjQMlLjOjp9nx+w6
	IXNyZ86BiUQeKh6Pw5g7yMORurEXHorBDUJZlTkrCwn/8g1+4EHj8PaiWh2tilbKcDYYJDumeo0
	IQoSYvs0dnmOTsxLDJpKqlZkYAMl3p+6vegUMU4Jo781/c4Pyru3OQzzECU=
X-Received: by 2002:a05:622a:1c15:b0:471:8a2a:d9b3 with SMTP id d75a77b69052e-4718a2adb82mr41530301cf.3.1739215232107;
        Mon, 10 Feb 2025 11:20:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGhPZhlsQZyrDwqBCWlfYeWNtHXkddUkvcf5DV4cGq6f1WRrWGhD5y1vSBMq6awgol6oyxogA==
X-Received: by 2002:a05:622a:1c15:b0:471:8a2a:d9b3 with SMTP id d75a77b69052e-4718a2adb82mr41530101cf.3.1739215231617;
        Mon, 10 Feb 2025 11:20:31 -0800 (PST)
Received: from [192.168.65.90] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7a58abd76sm549411266b.26.2025.02.10.11.20.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Feb 2025 11:20:31 -0800 (PST)
Message-ID: <354f8710-a5ec-47b5-bcfa-bff75ac3ca71@oss.qualcomm.com>
Date: Mon, 10 Feb 2025 20:20:27 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] arm64: dts: qcom: sm8750: Add UFS nodes for SM8750
 SoC
To: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: Melody Olvera <quic_molvera@quicinc.com>, Vinod Koul <vkoul@kernel.org>,
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
        Trilok Soni <quic_tsoni@quicinc.com>, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Manish Pandey <quic_mapa@quicinc.com>
References: <20250113-sm8750_ufs_master-v1-0-b3774120eb8c@quicinc.com>
 <20250113-sm8750_ufs_master-v1-4-b3774120eb8c@quicinc.com>
 <vifyx2lcaq3lhani5ovmxxqsknhkx24ggbu7sxnulrxv4gxzsk@bvmk3znm2ivl>
 <be8a4f65-3b36-4740-a4f7-312126cfd547@quicinc.com>
 <ferdaevlfrpf2ewzcct7mqyxltvmt6aaar4fujxfehrmizm3qw@aaroprnpwlxq>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <ferdaevlfrpf2ewzcct7mqyxltvmt6aaar4fujxfehrmizm3qw@aaroprnpwlxq>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: VnsJVnRMcYjzxmtFlFIfMBtSX2LsEd37
X-Proofpoint-ORIG-GUID: VnsJVnRMcYjzxmtFlFIfMBtSX2LsEd37
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-10_10,2025-02-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 phishscore=0 spamscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2501170000
 definitions=main-2502100156

On 8.02.2025 11:06 PM, Dmitry Baryshkov wrote:
> On Sun, Feb 09, 2025 at 12:47:56AM +0530, Nitin Rawat wrote:
>>
>>
>> On 1/14/2025 4:22 PM, Dmitry Baryshkov wrote:
>>> On Mon, Jan 13, 2025 at 01:46:27PM -0800, Melody Olvera wrote:
>>>> From: Nitin Rawat <quic_nitirawa@quicinc.com>
>>>>
>>>> Add UFS host controller and PHY nodes for SM8750 SoC.
>>>>
>>>> Co-developed-by: Manish Pandey <quic_mapa@quicinc.com>
>>>> Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
>>>> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
>>>> Signed-off-by: Melody Olvera <quic_molvera@quicinc.com>
>>>> ---

[...]

>>> Use OPP table instead
>>
>> Currently, OPP is not enabled in the device tree for any previous targets. I
> 
> Excuse me? ufs_opp_table is present on SM8250, SM8550 and SDM845 (and
> QCS615). So this is not correct
> 
>> plan to enable OPP in a separate patch at a later stage. This is because
>> there is an ongoing patch in the upstream that aims to enable multiple-level
>> clock scaling using OPP, which may introduce changes to the device tree
>> entries. To avoid extra efforts, I intend to enable OPP once that patch is
>> merged.
> 
> Whatever changes are introduced, old DT must still continue to work.
> There is no reason to use legacy freq-table-hz if you can use OPP table.
> 
>> Please let me know if you have any concerns.

Go ahead with the OPP table. freq-table-hz is ancient and doesn't describe
e.g. the required RPMh levels for core clock frequencies.

You should then drop required-opps from the UFS node.

>>>> +
>>>> +			resets = <&gcc GCC_UFS_PHY_BCR>;
>>>> +			reset-names = "rst";
>>>> +
>>>> +
>>>> +			interconnects = <&aggre1_noc MASTER_UFS_MEM QCOM_ICC_TAG_ALWAYS
>>>> +					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
>>>> +					<&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ALWAYS
>>>> +					 &config_noc SLAVE_UFS_MEM_CFG QCOM_ICC_TAG_ALWAYS>;
>>>
>>> Shouldn't cpu-ufs be ACTIVE_ONLY?
>>
>> As per ufs driver implementation, Icc voting from ufs driver is removed as
>> part of low power mode (suspend or clock gating) and voted again in
>> resume/ungating path. Hence TAG_ALWAYS will have no power concern.
>> All previous targets have the same configuration.
> 
> arch/arm64/boot/dts/qcom/qcs615.dtsi:                                    &config_noc SLAVE_UFS_MEM_CFG QCOM_ICC_TAG_ACTIVE_ONLY>;
> 
> It might be a mistake for that target though. Your explanation sounds
> fine to me.

Let's use QCOM_ICC_TAG_ACTIVE_ONLY for the CPU path to clear up confusion.

Toggling it from the driver makes sense for UFS-idling-while-CPUs-are-online
cases and accidentally also does what RPMh does internally in the other case.

Konrad

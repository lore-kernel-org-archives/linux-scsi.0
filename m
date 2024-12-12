Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7C62397B1
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 16:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019887; cv=none; b=Wr/2O4SuZt1ByUBm577vhtRHopNUw5F9gsNGQGKnfWm4deIXp40YIbVe99FDdr5BVai/vqYM/MCbiFMyEuWXMfXJZM1ybjC/F93Wceoi3xaPVZk1fL+rEvicFJRYpo8dWFr5haeGEXFzTSr8o4ji5RTEvIK0RpwqInYTdwcWook=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019887; c=relaxed/simple;
	bh=dXF5alr3nkA4sLYcx0ahBi1JmELs74mAg4qLTyQDK0s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZWGSOHc1ppBWa0Ti0RjNgfgDzfZHVjbFvaR/MyiAfUmyZEw2OL3lUTCPTclmstOJ4aGPrnoGNhwURsAjAKfgTHrsN0PgBwl9d9vakyBUFIJYk4K/8j+rR+luHYfdOeH+wmoneIa6PIXaFAmaGfSJEmMpvKldhE5WD0cjP+/S9RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HuYk0AgO; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HuYk0AgO"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BC7u1HG002236
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 16:11:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BiOSCtICkfmA4vxytEAY623sRmhmgOgepKEKhIeGLBE=; b=HuYk0AgORhC7WmiX
	RUNFGvuNWjFQ1qX65CY8SVT9ojxODbmVnAxqQKRainhNLGy5dRD0XhCxAAXFD4rH
	8yWLoVYDNqMycld45sFwLGVGnDiT3UzzkK6ag8tm+NA1ir8CoA/6n/tnCHh0u3iF
	xUTM1NP2c5VyMJLuxy20CYpGx9z02PlICXgdA9m2rosibB7AVW7gtJlRymsDvJ7l
	3J+NE5geetgjFs0q2hEbJyVHsRCOC/IcGjEGvCZxPbUP1hQg0T5jMUjh6aAiV0s1
	u2jVZt2OPw5AS2VeTqzwbvFKPXi8wGxANXcCamDODhMurkt499oljr6KyPJ5EfV0
	26Ib1w==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 43eyg662kf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 16:11:24 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4678aa83043so1968561cf.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 08:11:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734019877; x=1734624677;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BiOSCtICkfmA4vxytEAY623sRmhmgOgepKEKhIeGLBE=;
        b=uLhawjcnBHn++Vna117LaWbDunSc6C81ZzL8c2VDS7rkh0is/xR5yffP/LUIrpjeHy
         2s8j94AVkPaklko8jt67DHypPHwZf3Dh343AnVoeGFgDI1zHAwTnDI6TKJSX7t63ZUVA
         fijEPly0Mb6FfJGIMzQTG+vWm091IwlVKZE33q5he7SeQCc/YvyOJ79QhhtdrdUUB5Yt
         tfabv38kt1XDJy+zYBqxmRX0Ng7/FhrmP1AOEp6MIAdPC6uthDESi4vi2nyGo3e99Oo0
         pKPeOcCuFL/nmfAVkpQfEmW16K70HFSCji5L5AE2x4zOdgDsEu95000B8kZ93lWnl2jP
         k8MQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHlsCAqOuwEZ7ftzB8shas4lTyqCuD5YQqYG0rW+tkXvX+4YN9M06fWcpX5SCr2rFdCqvZPauq+FTq@vger.kernel.org
X-Gm-Message-State: AOJu0YyFDHIOwFQ++qaNGVCr4ATSwnv5tlmSDxHF8flxd3qIRktqLYih
	Fl/cwGVWSHK6qjJXu3Y7iY2hu0w3KblyRubadIg21Y5rnnihWxDB+OPkcTjEd82D/WBr4TdOt2A
	agjeIcLOSUqE/JthHwLUXfslSVNw7V4RdmYivz9xIMLvp3nCNLpg0wnKGR24G
X-Gm-Gg: ASbGncs7bQKqCskmT2Pk+P8baET81pnm4gbyROCwOs+GuD/zd1dZCy6OqUzpdD1Uq2M
	zYQi1XhPb0dr4wvX6Ouu654qa1tay0wuF2IY/pFYYz+OfrLPUM7Saelyq6Vm1NmsPPZldWdFzP/
	KEDVWTcJbCGX3wdPDkHZGuz0u3sQGs1kAIVVn6LQiQljWsDsve+9jcSzq/4uRLJK425+idn6bLO
	JPco71UiZo+b5TYJHRtoJx+uxz29qbPG9LMefEKmKm+vXBNOCXXMwGF/7d2ap4N+nt1sjFhAFZJ
	zp/i7u8FCIlMlLuiCdhYBWW6ekfWqVF3SZkOOg==
X-Received: by 2002:a05:622a:4d43:b0:466:8e17:cd1f with SMTP id d75a77b69052e-467a14eee88mr5929941cf.3.1734019877223;
        Thu, 12 Dec 2024 08:11:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHXG4K2xpTGfNJ6S6PvXxb4g2uE22kte381m+d1ycbDxgdpkjeTWw74mGy0LyTdNM54e5Jl2g==
X-Received: by 2002:a05:622a:4d43:b0:466:8e17:cd1f with SMTP id d75a77b69052e-467a14eee88mr5929771cf.3.1734019876722;
        Thu, 12 Dec 2024 08:11:16 -0800 (PST)
Received: from [192.168.212.120] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d14c7991a5sm10426669a12.58.2024.12.12.08.11.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 08:11:16 -0800 (PST)
Message-ID: <e8e438b3-f60d-4257-956b-a9c77496bf8c@oss.qualcomm.com>
Date: Thu, 12 Dec 2024 17:11:12 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] arm64: dts: qcom: qcs615: add UFS node
To: Xin Liu <quic_liuxin@quicinc.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Rob Herring
 <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
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
References: <20241122064428.278752-1-quic_liuxin@quicinc.com>
 <20241122064428.278752-3-quic_liuxin@quicinc.com>
 <d4f7ca97-b37e-4b8f-918c-9976e4a9cf41@oss.qualcomm.com>
 <677251eb-d3c3-48e1-ba79-fb8ec1e29c6f@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <677251eb-d3c3-48e1-ba79-fb8ec1e29c6f@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: zAF2VJeQmmTyfpZAmPgzPp9OtBji50Ii
X-Proofpoint-ORIG-GUID: zAF2VJeQmmTyfpZAmPgzPp9OtBji50Ii
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412120117

On 9.12.2024 8:56 AM, Xin Liu wrote:
> 
> 
> 在 2024/12/6 5:21, Konrad Dybcio 写道:
>> On 22.11.2024 7:44 AM, Xin Liu wrote:
>>> From: Sayali Lokhande <quic_sayalil@quicinc.com>
>>>
>>> Add the UFS Host Controller node and its PHY for QCS615 SoC.
>>>
>>> Signed-off-by: Sayali Lokhande <quic_sayalil@quicinc.com>
>>> Co-developed-by: Xin Liu <quic_liuxin@quicinc.com>
>>> Signed-off-by: Xin Liu <quic_liuxin@quicinc.com>
>>> ---
>>
>> [...]
>>
>>> +
>>> +            operating-points-v2 = <&ufs_opp_table>;
>>> +            interconnects = <&aggre1_noc MASTER_UFS_MEM QCOM_ICC_TAG_ALWAYS
>>> +                     &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
>>> +                    <&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ALWAYS
>>> +                     &config_noc SLAVE_UFS_MEM_CFG QCOM_ICC_TAG_ALWAYS>;
>>
>> QCOM_ICC_TAG_ACTIVE_ONLY for the cpu path
> I need to ask you for advice. I have reviewed the ufs_mem_hc of many devices and found that all of them use QCOM_ICC_TAG_ALWAYS for their interconnects cpu path. Why do I need to use QCOM_ICC_TAG_ACTIVE_ONLY here?

QCOM_ICC_TAG_ACTIVE_ONLY instructs RPMh to shut off the interconnect
path when the CPUs go offline (without OS intervention) to save power
and bus bandwidth.

It's the natural choice for paths that directly connect hardware to
the CPU, as nothing else should be accessing these ports.

Currently, many platforms do not set that, because nobody cared enough
to point it out :(

One day when we lay some more groundwork on the suspend side, I'll
send a treewide fixup.

>>
>>> +            interconnect-names = "ufs-ddr",
>>> +                         "cpu-ufs";
>>> +
>>> +            power-domains = <&gcc UFS_PHY_GDSC>;
>>> +            required-opps = <&rpmhpd_opp_nom>;
>>
>> this contradicts the levels in the OPP table:
> The required-opps here corresponds to opp-200000000 in the opp_table below. Similarly, I referred to sm8550.dtsi, whose required-opps also corresponds to the opp table.

What I'm saying is, specifying required-opps of NOM here will make
VDD_CX always stay at >= NOM, because the vote is max()-ed

Konrad

Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAC33BB5A
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 05:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767765096; cv=none; b=dZQzbTLaygigF7wpCF2r/tq9yY/9MiWTyGD3mzxZtiyw189up8RKx+gIyNkVH2lVnmJ0UeSvfiiNaq6WNJrqr7ZCCz/8tkZXBac9u100Y3i5akVjKJ76V/do5Jnx40RWIxammETmHGK3/K09UCXjHpgCdj34Tp9keYGQ6t4oOXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767765096; c=relaxed/simple;
	bh=mGyvejjKrq72F3AM25T+UZZAwTgwXHsCXrkSI1uLPFY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=irzAdO1rQMX5jDt3qlU7RPo7KpNALQsVcW/Z/a+MF1jv7zsDOPPVyxlbDBEXG5XATTs9ymMeikEadGUKyjQBZZa3jxR8GSr9sTZqccRs2B3EOoXuoJsLjuc1RJx5Q3SYdwOEusTh7rjoCaFgewViYOTsyFVAtDJe8PLkxGp/nfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JRs1+M3/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HbPXhX5m; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JRs1+M3/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HbPXhX5m"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6073ks4H4091254
	for <linux-scsi@vger.kernel.org>; Wed, 7 Jan 2026 05:51:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nXGAvmSu/51spOzf+pzhcIdBM7PSd+n1sojrUbHh2K4=; b=JRs1+M3/UVWnLr8b
	WfopmPPbqUBF+Pxv+f0rDN3yQ07ILsmzfb4+QosC5crcjBpjG9i2l5ZP9GxQ1eG8
	8qoTR/f3AJQt9qiZu2AkmQ0LItlk0qBsD2/vCLXtJAl/1b+LVons6C5GPigB8v5l
	8cbc0n18Alh2ZBbRj4yX6OoulUTWHO4Y1j+pmwUcU2K4ov0Iu4VqKceO0CnOgg6V
	kMUNSm6x3CeUzwZTB672RDNiMJOWQSHcpJTclfGjCUla8PGC1js+OJQmDJgZ6LHA
	g7/bvrApy2NdHStzXU2Y7CFenlXZgRcmegcEuk8RJ91khtrsBDLUAqqg8OYVmlCL
	bLqP1Q==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bgyunb86u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 05:51:33 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34c7d0c5ed2so1763318a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 21:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767765092; x=1768369892; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nXGAvmSu/51spOzf+pzhcIdBM7PSd+n1sojrUbHh2K4=;
        b=HbPXhX5mFpy1iiTtd5VAugYwrKMSC39FV0RC1ro4+lPctGbgJhnMtHM3abBEIG0kHZ
         A2tpjft0/nJOHRQdbyXJtnwodA/nLPSrbhuYD6cNY3QR1jydV6ofU12ewdDasjESj3r7
         OKOLpnh2KeleH27kkulua/GnHiP1MZa7FwkHsiOyHlfWBbM6A5j77WIBdeDG/8rEx1r3
         EfvuJL90ja1BoJ2DOmj9LELARqheGaFUBb4TL66I7ByTmCog2J5kHsEHeLVtIxxgBtKI
         EpRCKPS8HS2tYzjgtavewdoHp6fA/D5xyLlJiPKVw6ugS/74dmG/ggclKbyBX4qdXgtd
         sYFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767765092; x=1768369892;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nXGAvmSu/51spOzf+pzhcIdBM7PSd+n1sojrUbHh2K4=;
        b=tjS6J11z2iWGOwg7Q9sR6N9Jc1yI5rLMbU3VLWUs5LW21XwUujxDzfBwee8lkgIxL1
         rR9x2NlWXFGsae0B5o28NF+Efqkl5h9s6oiH7u7sC1+YCC0odYqgfsFtyljj6C39/8Vs
         AVoYkp4uLShG6opVU33Vz0IFZR6OTMbnJyr5bSc4qX+wCp31UYgkuDxCj7M3nBW82GY1
         L0Lx5WOp5iWmr8xz2/GURpFhtAvepoefUTa9pIYoUeDTrDlcGHOIH2NdOLYfU+7PLXF4
         qL0nPKtNZMdS6qy3CphS4QaVzVTcu6uUb/K89oGz/A0jW1+PKvZDe8XhZ0EtufYE4AII
         dQAA==
X-Forwarded-Encrypted: i=1; AJvYcCW2y+f+BT9ITIEFX7hT57tT4CGH+1DIaacelhgeHKYUAxL6LH7fMHMiIvRya8871jYLy+8l7KkQ+/Yy@vger.kernel.org
X-Gm-Message-State: AOJu0YwfjuhkPrSbBNnnq3rEauYFQAMc9YVqiKG3SCxwMYeFThoIh4BT
	bcPeujkqunjsfijy/qPq0Y7YC/fAaX4TU12fbPcsqLKQQmSXMQ44SkFAgZVRsaSQUnzUHAngx4X
	uMaAhlUY7Y09cukU0fJYa6e6Az/+o3DDBFrjWdfCRYK/mZAglGfLuoCX5Iy9zXW7B
X-Gm-Gg: AY/fxX6vbDGUZAA9tLS0+LgCL07UVXamqxlivUSwWBbfD9ngm1JlVEyawtiG2sAOsfU
	l8lwVpCi2UNOq/kyK4+cT48P6k5nT0cnyIUOpHu+Ptd382LLeOX4MMbpRSet2p/xTusyzBjxN/j
	AeC5oO6tCW/9xHMSryrhJwaqH+0SaBmlBavxTh9ZGzuKXGUl7FKtQbNX6Ctl3fq738gymlT18A+
	KcHsc9Bk6rX/sQ8vP+xUey8LmfWDOnwKD77JzmUKY1vJ7zNPUqA16QSBL0sFwX7ls2S0FfKEe6+
	R5pws1+6LJE3OIqvP6lBpuKjKB3eBToJ7qMiz/91RpRDQ+bE8BhlvERB3oRz3DSM8QYR6a/07Mt
	RO1QHyznXEvLnlN5yOVbyfloX/6rgvBlPuVZjhQMXThT+Y/GQIqw=
X-Received: by 2002:a17:90b:2251:b0:33e:30e8:81cb with SMTP id 98e67ed59e1d1-34f68b65ff0mr1353229a91.13.1767765092346;
        Tue, 06 Jan 2026 21:51:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHBvUZCcUtaBqJgxkFmXbuj2o5AZhvWJWylevjOCJsxj9FNVU2+6RvoqCZGDUaUXjdVhEEUNA==
X-Received: by 2002:a17:90b:2251:b0:33e:30e8:81cb with SMTP id 98e67ed59e1d1-34f68b65ff0mr1353204a91.13.1767765091848;
        Tue, 06 Jan 2026 21:51:31 -0800 (PST)
Received: from [10.217.216.105] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f6b7b3e7fsm274007a91.2.2026.01.06.21.51.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jan 2026 21:51:31 -0800 (PST)
Message-ID: <530af0fc-9574-4d6f-9469-f08300da1f74@oss.qualcomm.com>
Date: Wed, 7 Jan 2026 11:21:25 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 0/4] Add UFS support for x1e80100 SoC
To: Bjorn Andersson <andersson@kernel.org>
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, vkoul@kernel.org,
        neil.armstrong@linaro.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, martin.petersen@oracle.com,
        konradybcio@kernel.org, taniya.das@oss.qualcomm.com,
        manivannan.sadhasivam@oss.qualcomm.com, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        nitin.rawat@oss.qualcomm.com
References: <20260105144643.669344-1-pradeep.pragallapati@oss.qualcomm.com>
 <y7lm6zqgbhk4243diyotvox75tcmzhgbkypbkaskrtjcjbruwm@ar7kjmiyv2wr>
 <0689ae93-0684-4bf8-9bce-f9f32e56fe06@oss.qualcomm.com>
 <l67bnlyrrirb3rnz7izqpe4soqjuvkbi2xawit5w2wrcc74vdo@exo4mbpac244>
Content-Language: en-US
From: Pradeep Pragallapati <pradeep.pragallapati@oss.qualcomm.com>
In-Reply-To: <l67bnlyrrirb3rnz7izqpe4soqjuvkbi2xawit5w2wrcc74vdo@exo4mbpac244>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA0NSBTYWx0ZWRfXxUus8dBz0WUw
 ug2WhKwKrcWYLf+WWz18HMW3oL5phRmsThJdaht4odNVI4Pg6fmgN6+xuuW35ISnQUIsLv3h9tY
 AZEugjxD7Hs9Kdn7LOOcMSQsQsghw1g/oLiSnXujyc9Yeyw0now4WUC/cOIbhhfukPk4spcxBNX
 xpxfTFhNkgMGwi0jIjpULs/92fwZiBg1rDHAGwbtBfpKx2jHsB7R3JQNQDrUag5eEAyYNGnGPkg
 bykGpfuNbS757wRMDU4+0/SMTh2IWPicJAOQNYKVrh1MH4M1nvcRkdToRoTeC/POWiPHrMNBw/O
 jHMwz4Lr7Tk4jdPcNBQLoV4SCHN+nSPYgiCFYBTVb96y+wT78rL0vg1CGrr/H1BqYq9KK6sK3wD
 o5fYd32fiTEH0EllnHlsBo9G8MQMwSl2S0Jsho/ECuys8ckDTCSaMbyAaJoy1tLgWIaTwV91na3
 gqkzaU/su8a4FLL6c/g==
X-Authority-Analysis: v=2.4 cv=YqIChoYX c=1 sm=1 tr=0 ts=695df465 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=wfhwzJ6r3g_IQgliFxoA:9 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: pzHxwVeo0V_RDWNHSmL-gFke1t8zb-Wo
X-Proofpoint-ORIG-GUID: pzHxwVeo0V_RDWNHSmL-gFke1t8zb-Wo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 impostorscore=0 bulkscore=0 malwarescore=0
 phishscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601070045



On 1/6/2026 10:11 PM, Bjorn Andersson wrote:
> On Tue, Jan 06, 2026 at 06:33:19PM +0530, Pradeep Pragallapati wrote:
>>
>>
>> On 1/6/2026 3:50 AM, Dmitry Baryshkov wrote:
>>> On Mon, Jan 05, 2026 at 08:16:39PM +0530, Pradeep P V K wrote:
>>>> Add UFSPHY, UFSHC compatible binding names and UFS devicetree
>>>> enablement changes for Qualcomm x1e80100 SoC.
>>>>
>>>> Changes in V3:
>>>> - Update all dt-bindings commit messages with concise and informative
>>>>     statements [Krzysztof]
>>>> - keep the QMP UFS PHY order by last compatible in numerical ascending
>>>>     order [Krzysztof]
>>>> - Remove qcom,x1e80100-ufshc from select: enum: list of
>>>>     qcom,sc7180-ufshc.yaml file [Krzysztof]
>>>> - Update subject prefix for all dt-bindings [Krzysztof]
>>>> - Add RB-by for SoC dtsi [Konrad, Abel, Taniya]
>>>> - Add RB-by for board dts [Konrad]
>>>> - Link to V2:
>>>>     https://lore.kernel.org/all/20251231101951.1026163-1-pradeep.pragallapati@oss.qualcomm.com
>>>
>>> Where did the previous changelog go?
>> i missed to amend, i will update all changelog in my next patchset.
> 
> Please just adopt b4, go/upstream provides the documentation you need.
sure, i will adopt to b4 going forward.
> 
> Regards,
> Bjorn
> 
>>>
>>>>
>>>> ---
>>>> Pradeep P V K (4):
>>>>     dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add QMP UFS PHY
>>>>       compatible
>>>>     dt-bindings: ufs: qcom,sc7180-ufshc: Add UFSHC compatible for x1e80100
>>>>     arm64: dts: qcom: hamoa: Add UFS nodes for x1e80100 SoC
>>>>     arm64: dts: qcom: hamoa-iot-evk: Enable UFS
>>>>
>>>>    .../phy/qcom,sc8280xp-qmp-ufs-phy.yaml        |   4 +
>>>>    .../bindings/ufs/qcom,sc7180-ufshc.yaml       |  37 +++---
>>>>    arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts    |  18 +++
>>>>    arch/arm64/boot/dts/qcom/hamoa.dtsi           | 123 +++++++++++++++++-
>>>>    4 files changed, 164 insertions(+), 18 deletions(-)
>>>>
>>>> -- 
>>>> 2.34.1
>>>>
>>>
>>


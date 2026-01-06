Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6323325722
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 13:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767704609; cv=none; b=XuF1gpvOB7rjxisvO3pPaz7kOLGkxEDcdNExqlZ/yQQErSODp7tLz5lWXE6Z8i8JQRE+fi1cYb2K2smoRafLqqPIQ/loIlr9i3lEQ5vS83a+TWB0qV+0rDjbTwr7akIpE2kweph4wf6vZMbU21s9OVlYziMqocNrjINexlRw0V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767704609; c=relaxed/simple;
	bh=ZvJvJvczjV9I6Td3+tXSrXk5/nUWBwcDwT2bwA1Ah6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kh8ek+chCkbswNAIvvlc605KgyfeqpzWOPLUDYIaD2ZKe307/R7EV6d7oce6Gu+hewiSR1BW9jKmJZDnb4uHwweKdXSoSN+gyrx0tc8m6jp6pSpncMZg3SGKBdayuCoK89OFXVEEjMYRHQY2FuphMoNHQeITCzV/6cqvuTRos6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FeDCUPiC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ciR5lEqc; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FeDCUPiC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ciR5lEqc"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606B3ooZ2684965
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jan 2026 13:03:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	KBGbPMXI0BvLnVfHyFlCYvcrUBb2pqokTkHmLNTyKfc=; b=FeDCUPiCIXliNFfh
	EOvsBsDDR1uzOfP51Nfr5qSgs9B0jR0xZtaKRAQoa3HNFFQ7wu42/r7cP9NMS6ks
	scw3+zMN8B7RVPIcl1m3UzFW4ss+OwGBs7D6x38g2WfBa14Iq7UDxTBvQhi47Ky4
	Uqbxge4HxkvV2G4Pmv1J7pSXl5Vz0eKzwYr45Ad+kgZc9zo9Fj9xavc2p6Yljkox
	nVMBu9KQmJc8dn0wj+bFU74tiGpJEZUK+ErnQucEQTe6mTQb4uPifARJTG2aVRu4
	yPScan60JSIvmjwMe1L68tSa5B16XxHIlFejSbSyCB6Abb+Vh8215rboaFf+fsw3
	z0pPUg==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bgty5hes9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 13:03:26 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-815f9dc8f43so1834406b3a.3
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 05:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767704606; x=1768309406; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KBGbPMXI0BvLnVfHyFlCYvcrUBb2pqokTkHmLNTyKfc=;
        b=ciR5lEqcMLPeSM83TbZ7VOn05nXbTu7FN4zdAoQ/Nyns8VnmMB54GFdcnQmukjXuBQ
         hND1cs5yUF16h/EE/3bLcXqd18oKRJdOWjw6pupDHi68N3uykkY2sUtenBtdeKurc4T8
         efmSoFPOtRRuPyWZS1bP9Usst+6b6dy4omt/xiUzGrtmM2kw6wDFVeZ1/XG6B2f3HF6b
         1JC+90QUSrDu0k3ulQ3MzzB4bp2xGKRk5KJEOHGM3ZbBdZNoyS0K+BFglSVfAPP8NdWD
         cwEE6zt1Te3Xahz2+/qoPFW3rNCyy5Gpblyvu4yecUeZqGo06Wn6tx1yt84S5FR0Iioy
         iVZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767704606; x=1768309406;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KBGbPMXI0BvLnVfHyFlCYvcrUBb2pqokTkHmLNTyKfc=;
        b=V3jIrvUdAc21JsipktVOyhVoJmx1Ne6rkKko10OKE/htmC4KwcKjZcdVT/AzwWPK3a
         9AYh0/2SeLzv4GIkLBe3Mun1tXtS1loO/WNG9yoPTnpSY10sWXIPfQvGIbtMTnKETYoK
         vDOoyo7VLfCHF/VBpUFT0P60xG4AmXO7nz6l6o2PheTmupPfzUfoqwJMD2UWnzav4Atf
         MsSprmd1+P8DQ7lwcQTc/CyeLxcxRGfsiCmI/3VLpfeP0bkDR1iMUQR/XE9gZWQFM2t7
         usMlGDYd1mdTmcFPr+khXToFQhaB9UmXjO63yw9rLOb5YTG/y8urtzMPYV+sFLyiEGei
         5o7A==
X-Forwarded-Encrypted: i=1; AJvYcCU+qMELGPhKELB9e+7BHRzEUu2ZffnWseaiAASQ8pv/4BhBIx4oi5DWnCVWzikX8oFkLPyXt9yqcd73@vger.kernel.org
X-Gm-Message-State: AOJu0YzRrth4nS6+GDFn6sfR8iikgNBJMXYn1U8DYOVu+Ngi3bRMIKy8
	S7CzSbLyGxQvOwWrMBKa24sTSekPpjk9c1EDMDpMMHxghjflqr97qzbIVPQuyUqfNZhYAYrDBKz
	eMhgs0/BJqp++7T7YweKIzCbFM+RsvViWP8jOhcMVtK2T/5xadkhkalcLjSnqYlTK
X-Gm-Gg: AY/fxX4FkIxZG1C8vw3UE/zzoVQC9LDKe60lqkfxD6K+b7iMhrWpHATWgYo0cFqfwJs
	MNce5mS4FW0HNMqubNrf4nzO8JNjfgHmBLSJO74fXBCM5BUJC9XpkQg4cFSHJtH7q00k63ijXAM
	WkWP0RTc5RSzYYnX+poe1EVtqOl7N0BH41bVzfBAnFDBJSVa9elOl/caRRNaxzXADlAfQ0roecx
	+sFRRtFgue4X/ciW0G5UWN+dG+oa5gqHyLl0KixDUiU9EXTWUPz+2bYz5E5IFP7AqoDhmFL/m10
	e1zr1w9xSHhawzwVAn7yOIgc9JeUwdz8U/8pPA3pEZx4ov/M8wmCtYnQJKe5ZjLEgBcIaqfVK99
	oglydR4tlf5mCub2crzW6lE8YsZsqcGig8OAGZEZTcXmGAn/fbtM=
X-Received: by 2002:a05:6a00:4096:b0:7fe:788e:4ef6 with SMTP id d2e1a72fcca58-81882dde715mr2922035b3a.62.1767704605539;
        Tue, 06 Jan 2026 05:03:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGrkjoWyrrEREwvfhzeaIr40oLsdxX4uVK6BvsLIlVKmCVj/W5JMswe/eUhMbhpFPzmjU4Oxw==
X-Received: by 2002:a05:6a00:4096:b0:7fe:788e:4ef6 with SMTP id d2e1a72fcca58-81882dde715mr2921991b3a.62.1767704605004;
        Tue, 06 Jan 2026 05:03:25 -0800 (PST)
Received: from [10.217.216.105] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-819c52f8e10sm2233570b3a.44.2026.01.06.05.03.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jan 2026 05:03:24 -0800 (PST)
Message-ID: <0689ae93-0684-4bf8-9bce-f9f32e56fe06@oss.qualcomm.com>
Date: Tue, 6 Jan 2026 18:33:19 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 0/4] Add UFS support for x1e80100 SoC
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, manivannan.sadhasivam@oss.qualcomm.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com
References: <20260105144643.669344-1-pradeep.pragallapati@oss.qualcomm.com>
 <y7lm6zqgbhk4243diyotvox75tcmzhgbkypbkaskrtjcjbruwm@ar7kjmiyv2wr>
Content-Language: en-US
From: Pradeep Pragallapati <pradeep.pragallapati@oss.qualcomm.com>
In-Reply-To: <y7lm6zqgbhk4243diyotvox75tcmzhgbkypbkaskrtjcjbruwm@ar7kjmiyv2wr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDExMyBTYWx0ZWRfX/R5XIfR88P6w
 zO+4FAxQ58IXHPm0/BhuWz85Adgbg0Tz1aORUzF7oLWQBxXZC2kGElsMU6yE4hMwWMxmGuC5WkA
 CIlQ6GOVkCi0pbWJkYUgB0bPrvKukXr6wFHXmjHEYPJMOVad644x/LqHka4ZGWn6xBlbZnlwpTH
 52ISjeiuND/+o+bhvzUpAUs76Te17pqIjWw8FiLBpMc2MMEfl+dISf1A0OVOzmwvv39DDApAXu4
 b8duraflH68VpaP2yUaNftnRnH1f/ZnaEToG1xujCvkicjVuhZb9TjteR+lBgGLaVkyxyPD1hJr
 P0srCQYhMVOF+qossC/yn8RynwbuAwtIEDsrP7498D2g+imTHRu5zD7DTHaTM+NfEWgEDkeMlVB
 HUDillKrSPBLqmXl3F3Y7fyL+QBv9watYqPdlKzWuJX/LLMH38JRFTStVvgXLY+oRy/WCjwDpq6
 PLISaL7DL7pu6a5jGiA==
X-Authority-Analysis: v=2.4 cv=Rfidyltv c=1 sm=1 tr=0 ts=695d081e cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=DDuy_lcDOa8T1pqcGkQA:9 a=QEXdDO2ut3YA:10 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-GUID: 6fUnwf-jza5mjKpJW2eWmeWuG4W-nLsy
X-Proofpoint-ORIG-GUID: 6fUnwf-jza5mjKpJW2eWmeWuG4W-nLsy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 spamscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2601060113



On 1/6/2026 3:50 AM, Dmitry Baryshkov wrote:
> On Mon, Jan 05, 2026 at 08:16:39PM +0530, Pradeep P V K wrote:
>> Add UFSPHY, UFSHC compatible binding names and UFS devicetree
>> enablement changes for Qualcomm x1e80100 SoC.
>>
>> Changes in V3:
>> - Update all dt-bindings commit messages with concise and informative
>>    statements [Krzysztof]
>> - keep the QMP UFS PHY order by last compatible in numerical ascending
>>    order [Krzysztof]
>> - Remove qcom,x1e80100-ufshc from select: enum: list of
>>    qcom,sc7180-ufshc.yaml file [Krzysztof]
>> - Update subject prefix for all dt-bindings [Krzysztof]
>> - Add RB-by for SoC dtsi [Konrad, Abel, Taniya]
>> - Add RB-by for board dts [Konrad]
>> - Link to V2:
>>    https://lore.kernel.org/all/20251231101951.1026163-1-pradeep.pragallapati@oss.qualcomm.com
> 
> Where did the previous changelog go?
i missed to amend, i will update all changelog in my next patchset.
> 
>>
>> ---
>> Pradeep P V K (4):
>>    dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add QMP UFS PHY
>>      compatible
>>    dt-bindings: ufs: qcom,sc7180-ufshc: Add UFSHC compatible for x1e80100
>>    arm64: dts: qcom: hamoa: Add UFS nodes for x1e80100 SoC
>>    arm64: dts: qcom: hamoa-iot-evk: Enable UFS
>>
>>   .../phy/qcom,sc8280xp-qmp-ufs-phy.yaml        |   4 +
>>   .../bindings/ufs/qcom,sc7180-ufshc.yaml       |  37 +++---
>>   arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts    |  18 +++
>>   arch/arm64/boot/dts/qcom/hamoa.dtsi           | 123 +++++++++++++++++-
>>   4 files changed, 164 insertions(+), 18 deletions(-)
>>
>> -- 
>> 2.34.1
>>
> 


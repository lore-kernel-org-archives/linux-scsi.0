Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322BF2DAFAA
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 08:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767600724; cv=none; b=Yim57n2zMMpZOTczMZozgG1LgjGk3+Rkg7DGHtL/65hLBCp5zIKXeoV30Y2UjPh1fSk9b1zPTURbiQ34H0wfXvohu7XFbg/bOTArakEIYl1hUYuI+VrE3lqDLUUvffSgacAZ/SjSSxhiHt3Vf9lQP3bBiPds1XunA65aCb6mjFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767600724; c=relaxed/simple;
	bh=sL9mmiw1Ek3nuTojJp6/bs/wbFVaj40tOMUCFczLO7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kf0HMnt3F01LT7+wORAa6ViVfCF0oa3rER2vm0M2q+mHyK0lHNF6e3QA4LsbP8akqOX0RYgAPxqwDzE6fp2zuoQcrSTVy3Qh1y80phwqFj+RFXRmK0wGuk9idRoZ6Cvm49eLvPndvMPLFeslHZhFaV+sPx/CYjGHoAfyu97tPno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XLZso7zr; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=h9BS8ipN; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XLZso7zr";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="h9BS8ipN"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60556Qia3522063
	for <linux-scsi@vger.kernel.org>; Mon, 5 Jan 2026 08:12:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XvRC78V+Kcb+nz16MxAbPrDUiGsyPydNzbtsD7OPmqk=; b=XLZso7zrivKUnDv9
	NxOu+vqyx28a8ODMzFnjZBgWg6xSsuDSHZjaZeEU7zaHZBm1WVTh3JZDrvnQVEo0
	h+qagLywE8UOtl20FPaMbHr1j1NQF3ODexLJtOJq3GtAy6/0jKzYrJbICWNxrtP9
	nEDKqHsR6+ffAzHYjBfVtIraGclIYXbACH+mlncnZK8KJNGJBGymcFwG7Fl7aIuV
	RNKmOWWIm8Wj03/ctx5lJ5fja56CjRssyOE1QUu9VBGxVvRLMxDD7PXJOSiWhvW/
	/XLGq20AVCnnTxXo9FVpUVMt+F6WjvVgfVC8JWAs1qs/3GOZewbW+huIsbze/NdJ
	PhVqxA==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bg6uu8fuw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 08:12:02 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-815f9dc8f43so1944458b3a.3
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 00:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767600721; x=1768205521; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XvRC78V+Kcb+nz16MxAbPrDUiGsyPydNzbtsD7OPmqk=;
        b=h9BS8ipNSNqknt9lhaz2ZMICOWOJK03fU5K0uC4yyJiPPjRa0kKrswgwQjKPcnvZkb
         zLoi/1KbTZRBeGsB23lKfbjhR50+bcCpCCuDVQtezlvWBQG5/TJ8ERSaLiGd+vzr7pQ6
         xwMTQ4whwFaqG9hSR1hYerhDsZljI46nLz/YT25NsxG7URKhX2T5q97EVu0AEcHxLVX5
         kKbAS8NXuFs0eF9x5X7F/gfB+2EGXp6/2rZiX4wHJkf8VlTIWcWUtAJ+ohtJjqv5HwI9
         NDG2p0ntg1gHZlornyq2CrcGa6VWpcf4f20fFuIvWLjrf/XOOInVbFfoi0fT5WBdRqMP
         /EBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767600721; x=1768205521;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XvRC78V+Kcb+nz16MxAbPrDUiGsyPydNzbtsD7OPmqk=;
        b=MYEshoaOQAc50Za2X0WbW/Ze2vrrdXSHsJWiw5CSdNwIcvy9S5KMQK//XMCpvQxYs9
         QxR1iKKNL3f9nyxjc4XjteC58RgCJwclrpYLASlOKAFgMw/SuNqYVj0uKHMhhG88TYhW
         8qJQS3Eyh89uJ/1M7KJ1wyYjHb6SOotfFkf8FE+WINdYsoHLJls/F2euWplNf0Pn0rW+
         gtWJjzXf28l1excuxaeYJQbrS92OTEZmizOAezeWMNNa4Jt6F73SwStKmYKSWQrP/rta
         MiIXFrIvTrwSUWHP07tbbHCRRm3GNNaPM8Z+CtJ8euunHP8zbVi/hcR62lwhMV2cmdM2
         6pdQ==
X-Forwarded-Encrypted: i=1; AJvYcCUs9abx12ne8w/n8+n/CvzUqIFgbRwSFdj9KSO0236kfFUxtsUKHOAjsf2EuhORbpL3xX+ZubO2VQDX@vger.kernel.org
X-Gm-Message-State: AOJu0YwK8KLcg+DazW6MAMafBBwaNbWsXIZmu0KbgDQtufp8JTOV9lN/
	uP8i/SBkzq5QeQyZ0IIF4YS7wz++jOCR2sXvb4/wNUQCk5v93DJfAhz1LBF8h+musX3gX/6vIWy
	msdCpRnmP2M1kQ4joc/0AzcN51U64PU91+JPEQf5euLLY2an0dwFE5L/H2i6jM9J4
X-Gm-Gg: AY/fxX7yca9Q5pMZpCvkWReDdORfIbQcfBahnetAdRbPCVPu0skQXJcMiSJV30NfIzz
	VXz04QO17yxvsJscn87OU/geqfCWvtpBxH7+DQy2FszxLblOhEGz7Mvj5PzLthQRJW1pbwTaX9c
	uhVrMYPYReKWgT7QyvamlUMsGCnJdKW8jVUpcMOR7LfGFmj2we8tV8IfU0fd4quZ6KkRZeTGrlw
	c9vev0rEdmapv4HjjEi9vTHJplsOkVB8V4GtW+esiF3jKs1luyAq/lFfz4iIGzz0G4Pmc9PYnYy
	pXr2AfPC0ilrREJph33foFtKWA9PMMZZlfxwzdPoMtjlvN6eR5+zjUsizx9Wg8nAPAP39bykf8y
	yY7e3NsKAqcAS2CuF/j62izpkAKociTjDnmK6L5UlXuGDTHRVf1Q=
X-Received: by 2002:a05:6a00:418f:b0:7e8:450c:61d5 with SMTP id d2e1a72fcca58-7ff66d5fe18mr37831959b3a.69.1767600720933;
        Mon, 05 Jan 2026 00:12:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE4pEalQ/S1gzH+PCmh2lNBlkf/m1qweLCoP8v4jj2jAYqu7jgAZHqb7rFgDkAig+pTtomiSw==
X-Received: by 2002:a05:6a00:418f:b0:7e8:450c:61d5 with SMTP id d2e1a72fcca58-7ff66d5fe18mr37831937b3a.69.1767600720455;
        Mon, 05 Jan 2026 00:12:00 -0800 (PST)
Received: from [10.217.216.105] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e88cd71sm47276718b3a.64.2026.01.05.00.11.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jan 2026 00:12:00 -0800 (PST)
Message-ID: <c106658b-7fe4-47cb-95b8-1970b397444a@oss.qualcomm.com>
Date: Mon, 5 Jan 2026 13:41:52 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 1/4] dt-bindings: phy: Add QMP UFS PHY compatible for
 x1e80100
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com,
        manivannan.sadhasivam@oss.qualcomm.com, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        nitin.rawat@oss.qualcomm.com
References: <20251231101951.1026163-1-pradeep.pragallapati@oss.qualcomm.com>
 <20251231101951.1026163-2-pradeep.pragallapati@oss.qualcomm.com>
 <20260102-heretic-angelic-narwhal-5d9d8c@quoll>
Content-Language: en-US
From: Pradeep Pragallapati <pradeep.pragallapati@oss.qualcomm.com>
In-Reply-To: <20260102-heretic-angelic-narwhal-5d9d8c@quoll>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDA3MiBTYWx0ZWRfXwfiGyNkI7nQ8
 h3cNGWAujVDqY/v0vwVj0ffb1tJX5eKX2sob1fnA463VS8x6EyFKQLTczrufCH0hSIuX5qSf3zN
 vZFiyYjBeJGlkx6DCAoPhGkVI/WMTsirXR2dpR34ysvVAqlo7qfVhsA2GdqEwUPpQtbnv3Mv1op
 rm3zRknMSrcKBE/sZ5oVav0raVzotDiuEaN8TU6Wsiwv6NeBcFzkjR7vumSMufNRcYq77QECm2D
 1kpFG9vo2esF2v0rYcRlfUUbAcmC0I9CQ4Ica9jrmYyIdxKqPRWUJ17UT2OA968rbWXta0A+gg8
 PTppSb3Uj/mgcY1NI5HKqr4m6JQd7FZFRI86bY+3c2asLVlWdrxdA7YQ5w1Im7CV9Plg0BCE1Ig
 V5+m+K6R2t82Ly6G1DFn2WkTlCtzJtqxeBxo1B5rIXvCVil+QaK/pBtyqnp0uOtgi+s6G3lHjCK
 ZDzmtT/dBXKUjk7gOHg==
X-Authority-Analysis: v=2.4 cv=eZ8wvrEH c=1 sm=1 tr=0 ts=695b7252 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=ZAgaqRceEw1IiIRpFMgA:9
 a=QEXdDO2ut3YA:10 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-GUID: q_7R3MYEpmPoK_ZAv3AC6habMdMneqgy
X-Proofpoint-ORIG-GUID: q_7R3MYEpmPoK_ZAv3AC6habMdMneqgy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 phishscore=0 clxscore=1015 impostorscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601050072



On 1/2/2026 4:53 PM, Krzysztof Kozlowski wrote:
> On Wed, Dec 31, 2025 at 03:49:48PM +0530, Pradeep P V K wrote:
>> Add the QMP UFS PHY compatible string for Qualcomm x1e80100 SoC to
>> support its physical layer functionality for UFS. Use SM8550 as a
>> fallback since x1e80100 UFS PHY shares the same tech node, allowing
> 
> What is a "tech node"?
At brief - tech node represents a generation (e.g., 7nm, 5nm, 3nm) of 
semiconductor fabrication technology.
> 
>> reuse of existing UFS PHY support.
>>
>> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
>> ---
>>   .../devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml    | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
>> index fba7b2549dde..552dd663b7c9 100644
>> --- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
>> +++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
>> @@ -28,6 +28,10 @@ properties:
>>             - enum:
>>                 - qcom,kaanapali-qmp-ufs-phy
>>             - const: qcom,sm8750-qmp-ufs-phy
>> +      - items:
>> +          - enum:
>> +              - qcom,x1e80100-qmp-ufs-phy
>> +          - const: qcom,sm8550-qmp-ufs-phy
> 
> 85 < 87, keep the order by last compatible. It was already screwed by
> Xin Liu in previous commit but you do not have to grow discouraged
> patterns.
> 
sure, i will update in my next patchset.

> Best regards,
> Krzysztof
> 


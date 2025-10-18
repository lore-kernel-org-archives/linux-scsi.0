Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38201284B26
	for <linux-scsi@vger.kernel.org>; Sat, 18 Oct 2025 06:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760769909; cv=none; b=CTueLvBR9q4WYvd69TUiRaYLhIs5cZjtfSVuOb2LW1SLfSN7cKD7r/0ibLk3wQAbbsdwCxAYXBncThX5pLL5T/X4skAEa9lDK3JSg1pcOmHn0ZunPDm4Knf4vW2KeNpulzO5H+CjnlS1p+GqVGCQfrFTdFa6WtnjaWeGaST5Tbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760769909; c=relaxed/simple;
	bh=83l92vGmnsTeooPFsXEiJR9HzVXaE+jXwSQU0y/tF6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EEHoW8Jo0V0T/8rjJ7TpUWekymofonDd7W+1gAY3n7BmKpa4IuR2/1EoW4fZMpVWsqMOm00YYHQLVGbe00DhCQY79u79h4FaA2BTVDz1EqSaT8VAVSWi8EuAwoRrRu8QXcLZQpdK6pBQbQKVCh9QA20qOF7mUE6hb/yBUeT5wGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Y+wlj0e1; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Y+wlj0e1"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59I35U2S023031
	for <linux-scsi@vger.kernel.org>; Sat, 18 Oct 2025 06:45:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	83l92vGmnsTeooPFsXEiJR9HzVXaE+jXwSQU0y/tF6U=; b=Y+wlj0e174++TBKy
	yiPDXyDSEQf2U01eo7nHIRKk2r3ZqPud+QcgRX1jUgkOnIQ/e32SqTBVSAmtPTU+
	HJCilGA67lkzJmVq/fdrDylSkP961OSS7puYG5/D4g4k+5qMyiltnrzI+/GWwfil
	J5Rqb5Q2vdqTkg3kF7L8j7smmJGSf9XfTUC+qTsZeZWQJYJjC4G0mJLx5IiJu4Uw
	+FZk1gIVB0/HVSmQrNhYSCx7zwYcr63KCzkH57roKOgGwpi8pNCeK0CRBksLZEvj
	3OhRig5ztZOEgO3EdjzYgeT9Swwzyj5snnE3O2+devlxNiIqasQ3Q6VFiANcOvcs
	4WP6xg==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49v08p8j12-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sat, 18 Oct 2025 06:45:06 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-290c9724deeso20349835ad.2
        for <linux-scsi@vger.kernel.org>; Fri, 17 Oct 2025 23:45:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760769904; x=1761374704;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=83l92vGmnsTeooPFsXEiJR9HzVXaE+jXwSQU0y/tF6U=;
        b=PtRk83TUCyctto2qO9cH97jc2aKCO3js7P8N1wWJck0f2mJTPmfGr0S9uYvqY6l3dP
         49fQn9boQNLjUzaWHxpKCdSLQqgsSaG3YqFKo4VW7Pv2Rld8SCP/+tPq953bYxn48N6y
         AFZ5xNcemtKbAIK77x+KUmWWJ5aREnPE9scynPJGDUWaMcn18+tUtdvlb2LvcuB4uGx0
         Tc0j4+xTlUCzb+CC7j+MV/GnqzcpzDhHo9SNGB3IzweAJN50ngb890fMneigNxw8+lRh
         MYn1uEkbcwyJF7Fi2yXKv1WNZAeP5yA8zKa8+wd9x460Jb4Fy8KOpFoPplEIzhh1GG2S
         lN8g==
X-Forwarded-Encrypted: i=1; AJvYcCXWK+pUOTrgNhh1MyYYddlL0x2CKx01TCmCdav64sJcfrW6cgVvtNKQvTwrXgRH6hSQWeFHwOkluwhA@vger.kernel.org
X-Gm-Message-State: AOJu0YxPtpSfLvT+8ePAaSlvmOPnJ2KBbYz1VzqsT+1MLQfWOEZMZtEq
	8+z0QXxNBfCZ0ppUuHE6t6uclwnvqBbTLKmby3Xut+CeoMGFt3BNZptyGwV8cUFOt3wlsMP9bDY
	eCMATesl/HU5bqw4w2K6dektnNdNuPsOCDk3sDTSR3ERZ+cHhH2ZoZBMji4V0KtQn8hNgAPir
X-Gm-Gg: ASbGncus4f36t/KTe5b+hDF95DqsDpQP2c5lJb3F04XAggz6WA1HGBR0v+FnuwHtH1E
	JHvBj4EWjP2wy9BqXFp28TOFaPViTGsFyDStqN3WknbZu+3FhRo0VXw+2O0KZIw499IfogE7YgW
	4/ZWEhceoHKpM58shWYARvh7xBoSTs01H/Y7IQIJf392nVXytO+TCORjUBc+IW8szwihyTRJplp
	QYivYONm6wWxYB55VGxtpAYuKgCVKSkKkiFNWSJ0BMt43CQ7Nym5Z5tQbgpBncdt643L97floiH
	KX1pkKnin+ry+n8VWoUJHtPI/wzZvdPkN6q/mF3hTL0BcipQoUwXhACvUX4Opg48/BwA+b9oCda
	KDK+r30sAM9k+nbS2U+oZg192DUPo
X-Received: by 2002:a17:902:f691:b0:25c:e895:6a75 with SMTP id d9443c01a7336-290ca121a2cmr76756655ad.28.1760769904545;
        Fri, 17 Oct 2025 23:45:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFE46DudyU1Od1eBACT3pMY31QTZQHpLNGdzqT+17P2QerlcjwRKGiUCYVWUl4eUkOU0pL/1g==
X-Received: by 2002:a17:902:f691:b0:25c:e895:6a75 with SMTP id d9443c01a7336-290ca121a2cmr76756345ad.28.1760769904006;
        Fri, 17 Oct 2025 23:45:04 -0700 (PDT)
Received: from [192.168.1.14] ([58.84.62.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29246fcc2e0sm16037715ad.34.2025.10.17.23.44.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 23:45:03 -0700 (PDT)
Message-ID: <677b59f4-5732-43ad-83af-c670f6fb999d@oss.qualcomm.com>
Date: Sat, 18 Oct 2025 12:14:57 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 2/2] ufs: ufs-qcom: Disable AHIT before SQ tail update
 to prevent race in MCQ mode
To: Bart Van Assche <bvanassche@acm.org>
Cc: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        peter.griffin@linaro.org, krzk@kernel.org, peter.wang@mediatek.com,
        beanhuo@micron.com, quic_nguyenb@quicinc.com, adrian.hunter@intel.com,
        ebiggers@kernel.org, neil.armstrong@linaro.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, quic_cang@quicinc.com,
        quic_nitirawa@quicinc.com
References: <20251014060406.1420475-1-palash.kambar@oss.qualcomm.com>
 <20251014060406.1420475-3-palash.kambar@oss.qualcomm.com>
 <f2b56041-b418-4ca9-a84a-ac662a850207@acm.org>
 <CAGbPq5dhUXr59U_J3W4haNHughkaiXpnc4kAZWXB0SjPdFQMhg@mail.gmail.com>
 <bb9c7926-4820-4922-a67d-65a6b1bace9a@acm.org>
Content-Language: en-US
From: Palash Kambar <palash.kambar@oss.qualcomm.com>
In-Reply-To: <bb9c7926-4820-4922-a67d-65a6b1bace9a@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAwMCBTYWx0ZWRfX8+D4DpF0v8VB
 ci8bxq22nJf8K2kisKRxpRPSmoP/BsybXqLJdWUgtX96m1DrfT5Lp0N+PUgjq999J0FZ7uhfqC+
 8NYFeXpVXYYljTx1L61NL3+NevtbGEARLYjcQtmOcnj3QmGbpyzU/ohut+3dWazzzr3tg5uoUhY
 Lo2XkGZZfWzKcVbiavuGYLX+z0ydtaWVS1/dDvFklTv0dcBFqRT28Hae4T34dMfYtxPEMnpaEtA
 7E7p/dFpbh8YtL4MHLvFynVPh0X/buFfHynTTwCJlgqEaRAmxEIyR6bj8a8Kpq1v8bTldani88v
 6LgX44K4Pbi4srswxzX7Mg1ed/meQP/Dg9ZgYRIe5z+d2UWmb4PJcEMZH4+EyDF8bXaYyufTMzU
 yuekg+IFl5upOfKE8NVcX6M2LHusPA==
X-Proofpoint-GUID: YBoNz1kvlL8gIYnN6kEx4RrzRQJCZc4K
X-Authority-Analysis: v=2.4 cv=Up1u9uwB c=1 sm=1 tr=0 ts=68f33772 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=IrkFCgFlEHDHcOs+Gij41Q==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=P3EupyyZPr0bXwnpvzAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: YBoNz1kvlL8gIYnN6kEx4RrzRQJCZc4K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-18_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 impostorscore=0 bulkscore=0 priorityscore=1501 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180000


On 10/15/2025 9:15 PM, Bart Van Assche wrote:
> On 10/15/25 7:08 AM, Palash Kambar wrote:
>> Since AHIT is a hardware-based power-saving feature, disabling it entirely
>> could lead to significant power penalties. Therefore, this patch aims to preserve
>> power efficiency while resolving the race condition.
>> We have tested this change and observed no noticeable performance degradation.
>> Also, adding in RPM callbacks will not solve the power penalty as it autosuspend timer is
>> 3 secs in comparision to AHIT timer which is 5ms.
>
> The runtime power management timeout can be modified. Please verify
> whether the power consumption with AHIT disabled and the runtime power
> management timeout set to 5 ms is acceptable.
>
> Thanks,
>
> Bart.

Thanks for the feedback, Bart. However, I believe setting the runtime suspend delay to 5ms
 might be overly aggressive for the system and may have below side effects:

1. Short autosuspend timeouts can cause the UFS device to enter low-power states even 
during brief idle periods. This results in resume latency, introducing delays when the 
device needs to wake up for subsequent operations.
2. Frequent suspend and resume cycles may disrupt data flow, particularly in workloads
with bursty or intermittent I/O, leading to performance degradation.
3. When the autosuspend timer is overly aggressive, the UFS device may repeatedly 
transition between active and low-power states. These transitions themselves consume power, 
and if they occur too often, they can offset or even negate the intended power savings.

Please let me know your thoughts on this.

Regards,


Palash K

>  

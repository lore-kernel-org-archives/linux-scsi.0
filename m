Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489879443
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 13:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745416028; cv=none; b=nSnWOue+bkjO6MFhQpZbczydP7E0uQjKbSsevkkjV20CDfvLcofKN9t5+XfHy4Sc/si1d3EpkdaT2BwISV7WEAbddGtjYc6EtnJ+834U1W3OvInYPf3rd30tURrOuDzbKxlipC9q4jQoW3bi0ibozZedaJUDsv9XU4CuqIMVSdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745416028; c=relaxed/simple;
	bh=z+eeHIGXfgSgRilFbPbJz13oi5prMWhPbgRl6hzE+CI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mzEoqrIMPJiJKgMpqbIhzJjxHnZvMXmuSjJ6/xDjRS18HzT3KlnZMpgb/Tz0sOyki7FcOPCmbMdwA5WWQAHSIncmywtibIuHa0vijCYv7rDCQunFD+/aEPxDTFDx9NTShRRc4Q8oR+ujhvD8y7nAS6r/91D8/BsphN1tmn0pdPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=S8i7FCPk; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="S8i7FCPk"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53NAdd8r018062
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 13:47:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rccJ163fvQMfzFmJDE9Su9bT/TBQ12k3JHUMjdZJ29A=; b=S8i7FCPkAFszRCcm
	0E5n7TrAYzL6Ya7GMYVKUEoTr9irVJTcLmn6oF9XqUus9aedNsFoiIhvg9442OCi
	AFXVq/HwiYB0I16TfSxL9E4KeJcial9AJCmIN5S2Z2uzTU0SJ0D01nYPVKHOzk+6
	L7GsprnTCxnJsJPcehkNWqdX/oorIjHFz5WI61CAq025XsolYulP4Fnu7wHi1xNE
	Gn7WZ5oQqZJDwuX5h+Sh1ZCMZ5ZlvLTQmdmTTOiF2rr05ZwHjOxLtYTBAVngAaeu
	s8FSngApsCaUi0IAZahyEriLS6BUIjxEDCwvLKPtBYHjjULWSZwXoYi7+mjgmcvG
	Y0yi2Q==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 466jh02a43-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 13:47:05 +0000 (GMT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6ece15fd50fso14383666d6.0
        for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 06:47:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745416025; x=1746020825;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rccJ163fvQMfzFmJDE9Su9bT/TBQ12k3JHUMjdZJ29A=;
        b=NBV2bnMzn+7E7isVNNgM1a1xZisdWBTIoOaiJKca+nAOOKqpTHGCSsvxw4pxCqwHBy
         cQ8v1n4sb/YTm6xsspYlLIPk/dLx/Xx3+mSoye0wJFH5SpYMttQezcDXEfHr7ul4hrC0
         BlY879ogUrCGlFh6dGq5qhv9ouSVTFYKV8cD+bZrOuY25pWrTm1wrVpL8tqufXSYjtB2
         Hhof8JAmIy2cZmfFiDp9LZ45lRVAoOJSjg4L00f+sTRAjKJOxCVfBL4FCPHwiGmOVtJX
         IGtknOh8a+/atzf6ba1frDV3Ijie53igP90W2ov0WIfqlJJ2/eY/6vUbbPfeG5mvm5k/
         TxUg==
X-Forwarded-Encrypted: i=1; AJvYcCVpayY2jx60b7LlzOePkTRq+KAqElG7FubYT3FJxhktLHESM/v6UzrmWBef+V5gXvP+WNzo7UuQB4nq@vger.kernel.org
X-Gm-Message-State: AOJu0YwvoyVO22aZDFDUObLrvqmw8cTkVJi/FlnjxaynsIBnGtL0TOM/
	vtSSnHMbBgmZqDKNSsbwR8vn9y9M5QO4bSOYxACIZzgsj+tzGKnqXbQLXTTBga6nQWeg9aKx73Q
	oBVANBhtVGfyHWL8Tq2Bktb/B/YHRSJ+44ubfcEJE0ac4epHs8prf+jIN/p1m
X-Gm-Gg: ASbGncvkU4bu5K6pFl34jzsxCcg2V2krwDWAfolWfUPykRhwHeAoD+xA14mf90dbZFF
	cq2bSXD/ftnMM5YOV+uh2gPC9qVyiI3y/hna9NKudwufyen4wDNlsCkWMmMPSFa59Cfz/Nsfq/r
	Q53Dw690Cm8C4uHem4fC517XU/9fqe+shTq9QvSNFCfU06782lKYRdFsXCq4c+Pm7T5qPQExukV
	3gl0dXVpV6JU5d9HlkxIhK4twTqocYM+kC0ap3tv2C/BGlSc6Lkk8pFolP4HwC0Khz+vszoPeTZ
	2OQvB61dxZEUVFBqT+JqDyX191CB6E0YkjQWXub4WgKuxnMiO7JFybNiKueCYc2lLrw=
X-Received: by 2002:ad4:4ea5:0:b0:6e8:fa58:85fc with SMTP id 6a1803df08f44-6f2c45382d9mr136299576d6.3.1745416025202;
        Wed, 23 Apr 2025 06:47:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG8MdGQu9WPimGQ7gmBVWx+jYMYlEXhb+dpoDUfI0QxS1ZXNaNpC8Lyx3MI8nCs2MsAlqKO+Q==
X-Received: by 2002:ad4:4ea5:0:b0:6e8:fa58:85fc with SMTP id 6a1803df08f44-6f2c45382d9mr136299136d6.3.1745416024610;
        Wed, 23 Apr 2025 06:47:04 -0700 (PDT)
Received: from [192.168.65.183] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-31090826cafsm17949051fa.69.2025.04.23.06.47.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 06:47:04 -0700 (PDT)
Message-ID: <1adda022-b5d2-43e0-8cf1-de8e72544689@oss.qualcomm.com>
Date: Wed, 23 Apr 2025 15:47:01 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 4/9] phy: qcom-qmp-ufs: Refactor UFS PHY reset
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: vkoul@kernel.org, kishon@kernel.org, manivannan.sadhasivam@linaro.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        bvanassche@acm.org, bjorande@quicinc.com, neil.armstrong@linaro.org,
        quic_rdwivedi@quicinc.com, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20250410090102.20781-1-quic_nitirawa@quicinc.com>
 <20250410090102.20781-5-quic_nitirawa@quicinc.com>
 <pur4y63xhfmqlyymg4pehk37ry4gg22h24zceoqjbsxp3hj4yf@4kptase3c4qp>
 <317faeaa-3130-4e28-8c5d-441a76aa79b4@quicinc.com>
 <CAO9ioeXnnbNzriVOYPUeBiWdrPfYUcMk+pVWYv0vZpJbFeByoQ@mail.gmail.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <CAO9ioeXnnbNzriVOYPUeBiWdrPfYUcMk+pVWYv0vZpJbFeByoQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDIzMDA5NiBTYWx0ZWRfX/iLycpm2Qrnn 8F0JITtjwENhb45W3AD+0ZdJjOosGEqGT0UcybW7hmTuAcQ/DOCSRdroIdVxLTcj5a3Mz5/m0BZ sq+XskkdaJn+DPBOcyJxPbQkTWgAKzNHFQtrkaviQMPdTXupGIG3FIUwQIeCa75IS/eJ5VlTZPO
 bDG4bXo2ym/WnhcHme6OWDCkHTslFfoY7P6FEi/Umfmp1aXt6h2iNdX634iFgwYEYkHRNiym02/ Rgg790GMqvLZLaCV70AAjGFJcvuZtRp1Smx2GVM/9Z7h/h9OwrCNsLjPwx/N7u4jChzck49mHLX SzY+nrlPk+QC5Bi8T1l8JgtYm1uzYVbDa4F2S9Gh+hI1LxvUVkmoU6GsgYPEpR2E2h6aFij7B2l
 yl1ipebQBKc0ApDodP7P0IiXQnOaoWfLZ8V4asUK7ttHMRTt39CcVNxjChdZwz07SAEJeKIN
X-Proofpoint-GUID: J0YxppTvJkatp4Jow_jsr1c2LBAmIYSk
X-Authority-Analysis: v=2.4 cv=ZuTtK87G c=1 sm=1 tr=0 ts=6808ef5a cx=c_pps a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=FpWmc02/iXfjRdCD7H54yg==:17 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=COk6AnOGAAAA:8 a=9yGjJ7AVWo4BwlzXCRMA:9 a=QEXdDO2ut3YA:10
 a=pJ04lnu7RYOZP9TFuWaZ:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: J0YxppTvJkatp4Jow_jsr1c2LBAmIYSk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.80.40
 definitions=2025-04-23_08,2025-04-22_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 impostorscore=0 bulkscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=894 priorityscore=1501 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504230096

On 4/11/25 1:08 PM, Dmitry Baryshkov wrote:
> On Fri, 11 Apr 2025 at 13:50, Nitin Rawat <quic_nitirawa@quicinc.com> wrote:
>>
>>
>>
>> On 4/11/2025 1:38 AM, Dmitry Baryshkov wrote:
>>> On Thu, Apr 10, 2025 at 02:30:57PM +0530, Nitin Rawat wrote:
>>>> Refactor the UFS PHY reset handling to parse the reset logic only once
>>>> during probe, instead of every resume.
>>>>
>>>> Move the UFS PHY reset parsing logic from qmp_phy_power_on to
>>>> qmp_ufs_probe to avoid unnecessary parsing during resume.
>>>
>>> How did you solve the circular dependency issue being noted below?
>>
>> Hi Dmitry,
>> As part of my patch, I moved the parsing logic from qmp_phy_power_on to
>> qmp_ufs_probe to avoid unnecessary parsing during resume. I'm uncertain
>> about the circular dependency issue and whether if it still exists.
> 
> It surely does. The reset controller is registered in the beginning of
> ufs_qcom_init() and the PHY is acquired only a few lines below. It
> creates a very small window for PHY driver to probe.
> Which means, NAK, this patch doesn't look acceptable.

devlink? EPROBE_DEFER? is this really an issue?

Konrad

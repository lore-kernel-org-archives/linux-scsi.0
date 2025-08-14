Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C5A2ECEB1
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 09:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755164788; cv=none; b=HEtW4Gpdhrzn2hHlly0Mx6Q6E1+ImkEKTSVbxzZhkyubRJ9x5fWJg7UujHoezA3h+g/w9szHPn8snVepfqN6hjwczbNzQusylbpMi4r5fJRregMq2K7iz+ODrS0FF5I2ldFuIS+HQxW/0a5Ri24oZgbYSJ2dbiZDmb9W+7ZXSh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755164788; c=relaxed/simple;
	bh=YOPD3+ykr9tdg4N+rbw3pZv9DIXcmhCUR349Ger2yqg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VXdbO078hAo2ei6eF0VzWpnt+nKWpQtsEorbajl/t/0Qxv8Lw05uPnEpJI4PcJjiuOHz1/T3KTfVu/pfAm4ovrHYgWeeAdcnuPT2NUDB1r+772RMA0VLRuKSyc8iR+5CBGRchdtB6Ep5mCgjJYrewujSvuR3bEslO0Vmp7KFeCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=c9eY5ndQ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="c9eY5ndQ"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57E9NdXl031866
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 09:46:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rVPjIP0yMiJ7161uXl004pucArZ7+8ApLEfvy0PWY6o=; b=c9eY5ndQYYjG1LG/
	VQqkz+NqQ5jhHWTTWOyo/HM4SjxUobms1lyhpK2O1059TiCKB//N7pDBZ33+oPT2
	Drd0U3QTKyVSM38U+fg4x80SR/FN5SCrunHeNm9IEXKXTyp+qCePCXZjjtxLG4Wu
	SgvPWZjjSmpJUXh9KylUW870Q44N6+/6W2RQffWcv7vGfBKPUFNUd413ks9isQzh
	YWyns9OQkfx8QoArw1FpwOOafGqH4AXIXCeDedAjANYWtMg0jYoxJPWWO4T9zDZF
	ZVNLOy/+GWePxJ9OF2gjqdv+Zn2SbmLQehyHQ8NDQK3G44pRmFNQlUK7oHHx3NzT
	/G0lpA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48fem4k5t5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 09:46:25 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7e87068f8b0so20440185a.3
        for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 02:46:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755164785; x=1755769585;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rVPjIP0yMiJ7161uXl004pucArZ7+8ApLEfvy0PWY6o=;
        b=P5hkSNYtnMPr40c/yEWf5ark/hf2tloYATQDPUygBh23I0qEPvW2DjJS/4ApUd60Ky
         nYsgB8pC4tbT2UKvojaCOypKXym049ef5P5sxvqu8sfPozv0QJkCTpAoM1Aky3L78mQz
         8qmCpdqYJ+KZ3c6gpzNVKDYWUMXE7+2zEE9gMMfJjNAI8qpbhmLRwVBOOV5Wc9r9s5iE
         VouNoXPRKpplcIGIrwjRUuJIdBmutmeMkbW0JfrQfmEA2Xfll7qIVXWPija51vvmbTf6
         lvNida30uuXIVlRj2bTWxjUuNZgQUMDIWKztNDxbj0d3MXp4Hwm2+mozPwpeC2iwsKv+
         6OEA==
X-Forwarded-Encrypted: i=1; AJvYcCW2UKPojxVcLDRyWk4z8ZlUauIUfrqQFPTWQc7p76wAyq/tWGQuW2BTV70Cjjov6NdGDj3qcV5LIQXd@vger.kernel.org
X-Gm-Message-State: AOJu0YwGNHg8tXAj+GWeBTeQY0CAmUxs0ZSaoXburOaVi/kvREu98jII
	IRED477l/u/n30evfwDBle6NDjXfKP1m+J9txkzTb9fjVYRPPX4MH2+gMKwN80vcchKjTQx/gOp
	mRaOUaB4ddcFlnGlzu404IUgidRRbuebM8Cuyx4kEitdJEcvvxIJmS2jIok9MdsyG
X-Gm-Gg: ASbGncs2F9jx+QNDWfB/LHf+TzmduNoeQDgc2Lqyee7d/eOeVLWM2WANTe/Q1DlGIQ0
	XrIy/EAYc2j1XiYPECePJsuCwTcsXOPR+Q4966EzRvwZl4GwYkHhRM54yoAx4p47c35rBwkWFtS
	OKRItVVEF2kw0DafNkKYOJiUQwVqGj+im4WYkZZqLHiydIGUvQ09xSHFMgpHdfeDFmOakKC4Y2I
	pgP+g15kdi3Dfr2P9XN/fCLDl1hrIOCSVOoDJC/x9/uE7rfgMPk7MlVrP3bARt8LlMXHXZxUToE
	Gxqqh7ZoHyimanfjkqcNu1aoV0fGo/Goybxmx3NaS/xd+lDtwg9X2tx1rbY4Au+QVXwZORfEJD1
	1MulEoOOSbG3Q/47mZw==
X-Received: by 2002:a05:620a:4009:b0:7e8:239:f842 with SMTP id af79cd13be357-7e870476a4dmr154621185a.11.1755164785014;
        Thu, 14 Aug 2025 02:46:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEk+rLGT+zfHa/tgAexCcnh+96WIw8Fih6tIlfDVR70Fu5cDFYRswuXAwehpEUOb+at3084kw==
X-Received: by 2002:a05:620a:4009:b0:7e8:239:f842 with SMTP id af79cd13be357-7e870476a4dmr154618585a.11.1755164784511;
        Thu, 14 Aug 2025 02:46:24 -0700 (PDT)
Received: from [192.168.43.16] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a1e833dsm2550194466b.64.2025.08.14.02.46.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Aug 2025 02:46:23 -0700 (PDT)
Message-ID: <aa0ed59a-4eb6-4f7f-b430-4976ee9724d8@oss.qualcomm.com>
Date: Thu, 14 Aug 2025 11:46:21 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] dts: describe x1e80100 ufs
To: Krzysztof Kozlowski <krzk@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Harrison Vanderbyl <harrison.vanderbyl@gmail.com>
Cc: marcus@nazgul.ch, kirill@korins.ky, vkoul@kernel.org, kishon@kernel.org,
        robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
        mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, agross@kernel.org, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20250814005904.39173-1-harrison.vanderbyl@gmail.com>
 <20250814005904.39173-4-harrison.vanderbyl@gmail.com>
 <tlkv63ccpnti367am47ymhaw3agjnyuonqstgtfaazhhptvgsp@q4wzuzdph323>
 <57ce520f-a562-471f-b6b4-44f0766a7556@kernel.org>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <57ce520f-a562-471f-b6b4-44f0766a7556@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: Vqq-m6lXtqvrW8jmkgYDcTahaum-LOBg
X-Proofpoint-ORIG-GUID: Vqq-m6lXtqvrW8jmkgYDcTahaum-LOBg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDA2OCBTYWx0ZWRfXzdvvOcjaO0eB
 qMKCA1df32ZKMG+BlZ7Ynelr2Vv5vUuU8MwLE2DxeChXZL2ZZU+a7qqK/txRrxAECXkdgSEnmXw
 0wnts6d+H6nY43fYRfMgsiVZehp2Gs1dpziVLOb1Rix6hn3dsnl712RMZ8bbKMNqkjF3lcwNHE4
 0OIHbYmQ1AeztILs/IgtZAyD/N90FapfNKGUq0j5fNboZ+kgUF/gHS6n+vCxn443Vjn6vwd6Lxi
 51F9q/R9X7e4/nngQa23fWPOq0a/CLpOcX7U4N7IYnY+i1ODInxxNRXtYkpirzd3bK14rsYyb/o
 i1+GpHcDAduiiBdVqiu1V7hbqcKdDzAkiyX/cMSDuJHobU4nXo5Vctk/xVrP/l3FM4JhQCGB4Xl
 BRUbe/w/
X-Authority-Analysis: v=2.4 cv=YMafyQGx c=1 sm=1 tr=0 ts=689db071 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=tbUJWSx7DgQPHehloyQA:9
 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_02,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 priorityscore=1501 spamscore=0 suspectscore=0
 adultscore=0 impostorscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508110068

On 8/14/25 8:59 AM, Krzysztof Kozlowski wrote:
> On 14/08/2025 04:42, Bjorn Andersson wrote:
>> On Thu, Aug 14, 2025 at 10:59:04AM +1000, Harrison Vanderbyl wrote:
>>
>> Welcome to LKML, Harrison. Some small things to improve.
>>
>> Please extend the subject prefix to match other changes in the files of
>> each patch, e.g. this one would be "arm64: dts: qcom: x1e80100: ".
>>
>> "git log --oneline -- file" is your friend here.
>>
>>> Describe device tree entry for x1e80100 ufs device
> 
> This is duplicating earlier patches:
> https://lore.kernel.org/all/szudb2teaacchrp4kn4swkqkoplgi5lbw7vbqtu5vhds4qat62@2tciswvelbmu/

(that submitter clearly expressed lack of interest in proceeding)

Konrad


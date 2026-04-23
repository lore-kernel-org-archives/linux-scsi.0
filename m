Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49402F0C79
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 13:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776952199; cv=none; b=tPdK0dThAmgKdlFnh45QBzUVBN0/4gDOJmHCRfUxL4PuvgzxP4tCg3bKZzSIQwk2I8zd88EWpauOCfZJ6TDjd47BF2TK4424sZ25v4mdruH2CHZDW6OlFDfyR1civm77V3uXddNil6900/ZtzfnWwIV2Sj+iRWllWQSmS8FM3S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776952199; c=relaxed/simple;
	bh=KWQ7sey/nTnyoLv0JYkF53TFEnPYC0oacWNyHgDCzyo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ugcQdu3BF5Nb64uYpNBMeqqOtdXKPY+DVttd5F6OsouzQvpvNv71sTQw6Z9+vWmfbbRoP4FCW5up8aFqvq2aV2E2teiQGA1sBPw0v5M+o5vMdPTsU4pqu4DY6bscQk0RgmJVhTt4JIf724xpB1UmUdPWPeK5v5dicPxa89qMRfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GHnGh6v+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PI+3GZ5s; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GHnGh6v+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PI+3GZ5s"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63N8u2AZ366204
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 13:49:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9dbrtiBN5wfRX/dGpMkwo4KCgT0s/zfntZC2Cu6gWc8=; b=GHnGh6v+XLj2qYF7
	CpBQUJ5aj2A1qnCyWc3w9TXtIc4Ph54YpdryPuPk7rXQ0qjJLh4l5PoiV9HkqRWE
	ubuzjYnT6pF7LocCJncERm4+3Ak5T6Xn/Ljwu1jKlFHqKNQ6EfZkkLx+cj0Zl3Tf
	urXdUMJ2XKGhFXs85CgA6oUvyW7N6N3nlUCkoL4F48i//w0NwMZOQx1aMKse6iOI
	5T3zXNd4YspOrMgKYyNHt8l2kkmwO/M8bUkywRHTxzoGlygt5Bgh8Q4T9TWwARSL
	yZEJ6fOq2NCAtNJz6Gd5TRk1tgTZ7+TCMLVI/u+NjWSaTtp1relaaqgiGAfdTpVh
	/WVD9g==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dq35rbr6g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 13:49:54 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b24a00d12cso69109515ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 06:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776952194; x=1777556994; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9dbrtiBN5wfRX/dGpMkwo4KCgT0s/zfntZC2Cu6gWc8=;
        b=PI+3GZ5sMWOM7gvUfWeTGs/1UjH9O/Jyf+v2Nasg0M0R7NKM6lwG+9f9KvuxSV4uM1
         DFLqoBJb8pX0YYVr7dXfO6Vx1jSb39otgAgR9t3MSRyXOQyxH7nkGBp8k7NVl2znsHwB
         DalCfN6C7Ns9ObeAMn12cPHiBKdiVXBU57MghL+MR5QYzlrAmu1cfc4PUHwZC1T79yVi
         K+jREKD/KOvM9zJy9ivQGb3Zj50byLKwuNRe6dOWpZEUfxI2+84AwD/Xy1Zd7W9llGbP
         0tHYPwFQMfG8Hgf2D8SRAdIA6yCNnDpl/wKn6WqwVvBH08XifeaJTQdH2rf3io3tmqhr
         lCXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776952194; x=1777556994;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9dbrtiBN5wfRX/dGpMkwo4KCgT0s/zfntZC2Cu6gWc8=;
        b=SAQYoWjZlVzOyFLa0ls+wqptS3hqdKsX84+YgK0L16uATsOK1nDzt+vbOVCxuW8Bez
         ffGmum4dwtIE7M5ObSyQHlCOyf35EVQWT03LpgxFi+nrS8UZPjzVXIRZjkPLCaf60XqF
         pYRTiJ6c1Z6ltlBUbUvBDRrp/X5RcP7vkVKEu9ChodS7pQAbr5mMWTwdP+YoPXPfYo1t
         X9xXWQBZ+cH68lj0vS74UcS+x5jflyA0eNbB+RulTPsfeKlbnct2rKW+JhEyXRAQObGN
         xm44oXK0APcIrmGgp0CP4yM7y7NdgIePNehQRHlfOpw4SMlEUBRtLk+Rk4dnLev3QMx7
         81sA==
X-Gm-Message-State: AOJu0YyTz9Doo3FQur9O7v5psYUHIEOgumnxUuwcev8p7cxGVUrZTkg5
	z5C1dyIMFQnOg+FuxQQKvGF7xRqEo810JJb9sYER5dv2GvGG/H1kHw8piPBNs1F6AHxPsvkEzyK
	r/xxaMgzd2ltc3dmEn/nyFHFrtCdqKltnWWY191aBYv/A8YyLFHCxWo2ifhAl1PRW
X-Gm-Gg: AeBDievKXkcDa3Bavb3rQ34d69m4FeQW6lbQZOhr9Be1cj54LDlUJoU3+ol1WbcjOv9
	eNdDgpmKUkaaGqANmwb4wxB3l0rgBn4NPR5G+io/+Ft1DvzaiKLFv+elE2bzIpjXisG2of6bYoB
	Tkd0SVs5gFDwQ6cmVv+CrmNFCHJ2mi7MCl7IMY5Z4YfIABTQ2+8vPHsETVUj+sWneqHitkntoPh
	QCwKgCtBK9jEcTmKyvfX12Wf7A3z7dY7cGJBR8q9CPjzgBQlWBLtZG6YEoEPLa8Jx13ZJKOBZLa
	f+6KdeacjhmAQb6Pi85naDD1sjmTtR/5eNh6+bwh424RLGLz5t+OrYRjQIUF3Zl1m/Q5oA2wB5p
	IDPun75O4Q2aKbqMisg5Pzm3a8RZsOm/7vC9Sad0f6bCt7a4/v2/1r37VRdU4YFe7exPGyypmU9
	kK9hVy7RU/jFR8WmNzSuWH
X-Received: by 2002:a05:6a20:72a3:b0:3a3:1f85:645f with SMTP id adf61e73a8af0-3a31f857f4cmr3942178637.18.1776952193827;
        Thu, 23 Apr 2026 06:49:53 -0700 (PDT)
X-Received: by 2002:a05:6a20:72a3:b0:3a3:1f85:645f with SMTP id adf61e73a8af0-3a31f857f4cmr3942125637.18.1776952193329;
        Thu, 23 Apr 2026 06:49:53 -0700 (PDT)
Received: from [10.133.33.37] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ebe41cfsm22089628b3a.43.2026.04.23.06.49.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 06:49:52 -0700 (PDT)
Message-ID: <51a6fb68-d7b8-4406-b653-b298efae6a75@oss.qualcomm.com>
Date: Thu, 23 Apr 2026 21:49:47 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Add support to retrieve and store TX
 Equalization settings
To: Bart Van Assche <bvanassche@acm.org>,
        =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "mani@kernel.org"
 <mani@kernel.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "vamshigajjela@google.com" <vamshigajjela@google.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260419135229.1036926-1-can.guo@oss.qualcomm.com>
 <20260419135229.1036926-3-can.guo@oss.qualcomm.com>
 <343283a8281e2fb0ee83622a15028d12e44bd964.camel@mediatek.com>
 <a4792823-5c9c-4a4f-89f2-fde117455506@oss.qualcomm.com>
 <90c86ccf-5820-4937-b595-a8b47cac9ae9@acm.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <90c86ccf-5820-4937-b595-a8b47cac9ae9@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIzMDEzNyBTYWx0ZWRfX73y0KH3Pom+r
 7bdNqdZWJNILLHlkpJJK8WNk8fH/qSXNR+ICsvwRGnpzVQjn3XMH1fHtN3+ZRQq5UA6RafZf8HX
 nAlqB4Fm/BpUYtTs0szgpF4oJHofX42/tTPrRo3a1nIhneCrkO5fUtWoOu6/FixKLgkf7mVhz/i
 9S9eRq4INDbeDwoTmt6xx+8OyNkgeSCwTQFoPCw/IQfKT1GBZ3sGin4ZzVBeH8iXhNlil4FfUuu
 h45ddO/257HunhzFXwzVRXRDbHpwaUGBk2iGRzP+wH3Ve1zZGhTNgXpvNktlerHwuIuxgV9KweN
 7ZsRincllVfj1xwRME4svNXoupqA4MAs2TR5ee155AarEN5Bd8nMXnyF+pQizMFZtq3/UaPL+ua
 fcWku7ts6pWaasbrNrAFLEVB7vNjjfOfbjebz6kJv9b3fzNMl/kkd2N2yRtBHgvtWThM7rB51HG
 m26r6e/RURufJC2MImg==
X-Proofpoint-ORIG-GUID: YCaPPfmLQ2mEHPG_nUU-ThBuHUtNLec9
X-Proofpoint-GUID: YCaPPfmLQ2mEHPG_nUU-ThBuHUtNLec9
X-Authority-Analysis: v=2.4 cv=f5J4wuyM c=1 sm=1 tr=0 ts=69ea2383 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=ru4zZYNuDXd2OUl2SekA:9 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0
 spamscore=0 suspectscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604230137

Hi Bart,

On 4/21/2026 12:28 AM, Bart Van Assche wrote:
> On 4/20/26 6:23 AM, Can Guo wrote:
>> The usage of the two Selectors is not limited to above examples. Yet 
>> it is hard to get
>> aligned on how to use the two Selectors across different companies. 
>> Hence I am adding
>> a module parameter.
>
> These kernel module parameters can be converted into sysfs attributes,
> isn't it? Converting these kernel module parameters into sysfs
> attributes has the advantage that different values can be configured per
> host controller in systems with multiple UFS host controllers.
Thanks for the suggestion.

For this series, these knobs are needed before the first HS-G6 power 
mode change,
which happens during early UFS bring-up in probe. At that point, 
userspace-driven
sysfs attributes are not available yet, so relying only on sysfs would 
miss the first
power mode transition.

That is why this patch uses module parameters (boot-time configurable 
via kernel
command line).

I agree sysfs is better for per-host runtime tuning on multi-controller 
systems.
We can add per-host sysfs controls as a follow-up later on, while 
keeping boot-time
defaults through module parameters for the first-transition requirement.

Thanks,
Can Guo.
>
> Thanks,
>
> Bart.


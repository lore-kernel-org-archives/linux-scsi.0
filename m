Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E868E25A359
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 13:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776952219; cv=none; b=P+Vq9p7yUShPCyeZSIFfGQMeaAwf7fxXYTW5KpB4ydjhC+VXEb7wuucZqIkx0ruOpOkyKF/PWF26WmKPGxNQdjXylrJcCtwB9Ar2aTh1gWPCDNryflrJFHEZ8Mq26Ygr0/vlNlD+3I6LNwHeWDgZjIO4cr0H3i/BZhZqqFnONlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776952219; c=relaxed/simple;
	bh=THUk/U4jSih5RI8wrow5DiqotOM2IDJ3SJpzIkAxXVQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PYEWvgAD0JaW9jppGOahr9/bgS5BCT1dtLmK23WruvUeCyvqwksLicziGBeeKnKaENs9XgfMjvO0CcHLXc9zYuaMIVyddVdbCTGtnlFjxxinmeZMfgJYjmsZwyI5EQPavX59RUS6auJRMkJXq9w9cbK9ftigVTnIcuvgoPA5h+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=K/wX429c; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SMKi9qdu; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="K/wX429c";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SMKi9qdu"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63NBxBVD010547
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 13:50:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ynFtzosuzZSx1mxtdb7if31d5T0yw7m1wUQVLpmJjWw=; b=K/wX429c0cO3qPlq
	NAX3USpAhddN3loKcdY+mTcqyNOHrz+zgdgFdr+yxwv+hcQuaZ73A7+T3knp+7qo
	EboqV0l7xX6mrUzBXv65bGuPxcaM9p6DvbViFruho6Kaot6ijjBPZvjs8lPaR/6X
	dx7GYniFmtab5wbvxg5KeeGfxCoLR7hmqogNujbI3F8obcWSKXpILkrDj0Bsmfyu
	H7vOoXsl3KJ/BcR+67RmX+aY8oPL0IASK8oVhoPCgAUc1bz5RUoQnmS8bOsVEKSx
	WdN5+vVJfhKghmddyAAaMIQcLi8bMQymFtyts85iQhAJkrOvKFbMG+kQ8bSe3JCT
	50MZpQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dqk178cnw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 13:50:16 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-35449510446so7361256a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 06:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776952216; x=1777557016; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ynFtzosuzZSx1mxtdb7if31d5T0yw7m1wUQVLpmJjWw=;
        b=SMKi9qdutE/vhSC7Dm4xP2BaFtQ9pEZr1LUu0TDDTdSuHhEOVBf9MFBTU4LFfkuaV7
         P16WMIua47bAB9ecEycpwfI3/66L12rZpE+5OcMvTKD7dJK6h1lsZ5fg026INwx9ndWg
         Laxc7dVLpo+5JRcDhJzGUIdTV8jbtXICRM+i6+RAkfxlF9YiKIR1ExB3G2jl1Sc1mjEo
         wpBFkjKc0eBMDElzUC2kjP2L2GZuYI60Yx3zUinSN2uZLSVeUb5yQOHAoc3ZuUeLo/Ko
         IrzXEEoPq1xQ7qeBGuPTPtywKZQVkFW9P11iVtckSSbQuQ+FgGvpI7fF6AUk9TA9edE7
         9p/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776952216; x=1777557016;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ynFtzosuzZSx1mxtdb7if31d5T0yw7m1wUQVLpmJjWw=;
        b=TrQkbxCfj1L1ehzgCJw1skQyKXr7oi8Z4ezb2K4jQGQtUT0MOznfZ2aEhaAri30JO+
         DI0SGlDM5vU4aYv82UWfNPed3hUGmSTyBiGAH7L/OindQOx3z/thiFnbqN7JTqBFZE7O
         d43/4ALwORlSMENMCLtZK5Q53nmGlH4e0RXG0hTvpltJKfg6lTqHxpt6NN3+XCrGJGrT
         rWjC7HqnfRijMpydagYnfjCyMGkGsGzdQW82Lt1F8uZ4Y+8RoMjj9GT5SijhKg91n3S2
         bAWrU+20OuWu5mB8eXiDYV3v5az2VJt9mQyxu2sD26SIsGnFXqaCFmCjDxcgG1CJRGhp
         KIEA==
X-Gm-Message-State: AOJu0YwYdAxMofzbJN9ypIXOfl7AuigJfCBWTRf546L+0G68/VnVX6UT
	L+K9Kk+3pM5LCQxKkmtmmnjXM/rJGb1ZiRSH/283Y+6ycp2+tuqYmtRMCH1E9NX55llsBmjo7AL
	eRNYEymUPH/s2FYVfxsSAsxI2xryjM1D/3lc1q5821JuOAnyjcmIiUPMcAhtvl2cb
X-Gm-Gg: AeBDieu9rcFmm1GLa/uSm3/18M2ZuV/uTvHENfFrdfw5VyesBDA2w27VuAG0rjQfFL9
	DSZQkB1fhqN7OXlZC+1/sKIugHn2ezUmsSAiVETKSqj8jmb4jZJAWb3yrCxMLxlNlSFvFfAzTkC
	dVBnMNKarSW0RqHq5MthtG79bYteg8g2krUzonvUor3o0wrrLt/CZR/0+napg9o6AtuyDrgpO2G
	MMXOjHxU4/SpaB8vJ6tapOTTXN/DPWnhnGNiAtdle3HQ7iX3scj0aq3ZX95Z2V57ruuXa0gSeBM
	YC2qiRvBhDmBydJbhfAx1pq2nvYvLpRjPq1P4Ki6slZqgaGSIsbxBKeFmFAaimH9aKC/ub8C4FZ
	i9msW2R/lVaKv1Y78zaE2QT8Z0RQLkTjdLQ5lT/Fuwh/QoJadK5VCpmMVHAPg37uNphAaN5z8Yy
	lRdrM2/VbidyqBSOeV/eRD
X-Received: by 2002:a17:90b:4cc2:b0:35d:a843:6b1f with SMTP id 98e67ed59e1d1-361403f4fcdmr29528291a91.11.1776952215921;
        Thu, 23 Apr 2026 06:50:15 -0700 (PDT)
X-Received: by 2002:a17:90b:4cc2:b0:35d:a843:6b1f with SMTP id 98e67ed59e1d1-361403f4fcdmr29528247a91.11.1776952215452;
        Thu, 23 Apr 2026 06:50:15 -0700 (PDT)
Received: from [10.133.33.37] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3614195a92asm19946750a91.10.2026.04.23.06.50.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 06:50:15 -0700 (PDT)
Message-ID: <bda82d6d-0f72-4c9f-8e40-3068be674180@oss.qualcomm.com>
Date: Thu, 23 Apr 2026 21:50:10 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Add support to retrieve and store TX
 Equalization settings
To: Bart Van Assche <bvanassche@acm.org>, avri.altman@wdc.com,
        beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        vamshi gajjela <vamshigajjela@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260419135229.1036926-1-can.guo@oss.qualcomm.com>
 <20260419135229.1036926-3-can.guo@oss.qualcomm.com>
 <7daff6c5-a0b6-4d52-a115-98cbb1d9abd9@acm.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <7daff6c5-a0b6-4d52-a115-98cbb1d9abd9@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: yHX24EV2EDJuj8ZrsYLfJ9eohip40mHI
X-Authority-Analysis: v=2.4 cv=R98z39RX c=1 sm=1 tr=0 ts=69ea2398 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=Zr3j5_gTT_g7vWEu1ZYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIzMDEzNyBTYWx0ZWRfX1W7JtSNlpLlU
 q4+rQIVqh6ypyanXad/kK09z7Ds7nM74kWunijDA2dno0pKr7VaQR6Df4XABBSms/km8gK1FIkG
 HdOJWnHoL/jGqqVjYdW2RT7PAOGU65hd/YRYeN5cBVD52efzMYvSWz2BVpIO86BCPiQeT7hKMYA
 hLUHoHmFYEy3IdUoy3C5xNfD+DjH8s5mqoJt7HldnO/dEfv5lLqMOR0sWlGA6bIvjKZOMb9ZYMY
 1EgTZhlfAOE8ap6W75JjY3f7shcOl+rcY2eEeDaue+65eFzvkcv9/TTzIVfS8LDANLpCJZCyUEv
 yZh6SYYjTYb9uhh8yAO+q0jijlnAr3qvmA9+b7L6V/CLqXfawZqHW317Px/0dsFppsNpKuBbvKy
 zNwEhbhU1vzdmHdmJkYJ+p+w+6QrFAW6uLoHIsXorq8gTMpBEA2/UH/roDpWTs9TxMZfXg/3GZn
 tCfSGBjm9ID09y+xTiQ==
X-Proofpoint-ORIG-GUID: yHX24EV2EDJuj8ZrsYLfJ9eohip40mHI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 malwarescore=0 impostorscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604230137



On 4/21/2026 1:01 AM, Bart Van Assche wrote:
> On 4/19/26 6:52 AM, Can Guo wrote:
>> +#define TX_EQ_DEVICE_PRESHOOT_DECODE(eq, lane) \
>> +    (((eq) >> ((lane) * TX_HS_PRESHOOT_SHIFT)) & TX_EQ_SETTING_MASK)
>> +#define TX_EQ_DEVICE_DEEMPHASIS_DECODE(eq, lane) \
>> +    (((eq) >> ((lane) * TX_HS_DEEMPHASIS_SHIFT + 16)) & 
>> TX_EQ_SETTING_MASK)
>
> Please convert these two macros and also all the other new macros in
> this patch that accept arguments into inline functions.
Will do.

Thanks,
Can Guo.
>
> Thanks,
>
> Bart.


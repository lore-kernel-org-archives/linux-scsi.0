Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AFE3BE65C
	for <linux-scsi@vger.kernel.org>; Mon, 11 May 2026 09:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778491280; cv=none; b=sVzqL1/chegmZdo58nrVSkOshsMeNm4ojOhdKsllaefAfR7IFKrLajm2nvh1rNq+Je/pfsz4TCmpktoxeO+EGbyy9wBZEI90acAmpQpIFlqV4Sbedg7URgcAcYQtGVVpl+Y50jNMtwL1rpJishEphbVD7AiFngs3DEHuNgX9AG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778491280; c=relaxed/simple;
	bh=h63+St/ga/R0OCsINyxHvIjA0GDWYp4Slhns3A1jr/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QCBZFHBlwZUaxIonDmfYamQ+Whq4wbsa8QVgCBycJ590FI7ykD4EpGFrXV0/Q5sM/guFbcKXS0bOZFGR0GizvAs7hAVTF3p8doJK4pE7JCXmGjZ4VwXZuB+6Z0okTNDUQcdaXW3/f/C4ExZumZWcwSHNOx+jXr/4twgaWRmRkvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mI9BsGkq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GC1+Z4ot; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mI9BsGkq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GC1+Z4ot"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64B76ldb3527931
	for <linux-scsi@vger.kernel.org>; Mon, 11 May 2026 09:21:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UfU9k/y/DIWdHKH7EejvCnBIwe+U7Mfc+q++R+Gq41U=; b=mI9BsGkqIyV5d5JP
	MEVGFWiPycIBh0mnkEcOuOm9mLKfVAd9DSCo/ACXeQ2z3vU09p4AziJtBleKAgd6
	ZY31MBSb9ekD4p7aNqXmuTu/TmGPCC/TWyguBDkWr1ProDcDfkU2xVtfXuVD3IR5
	9VdckrvnMAuOPLPfR606LuttCyxUIjKapmE88+UbId7OcuolU1dkFxgq9dh5QVhJ
	RM8x624JOEaEXdcaRRW2HVUTpvFR762co2/H4sy05TQyF1YdjwCxs3Ttc0FqqPhk
	ev3g0gHVZ7jQhVEjEHiq3RT1LvYvxRTcGqEunhxy+k/JlzpHSqjY4ggak3Hilosf
	1bw/GQ==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e2dkskjfx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 11 May 2026 09:21:18 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-837d0d71c61so2480568b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2026 02:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778491278; x=1779096078; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UfU9k/y/DIWdHKH7EejvCnBIwe+U7Mfc+q++R+Gq41U=;
        b=GC1+Z4otoxFgNKdOmAAdlihIT3ImjFI6+HC5PkkGdD/8EfY89r86EDdBAcYQ+VO7hv
         1LABsNAXtqd6o70QQ6UdGHW8sDyJYfFUTdxDR/y5dqXB1SZC/1Utf7FuSh/MVI75kgvL
         dMRbm5NDeN8CIrz7F2q1rnBo3bZAPM+GirjUOt1VYXW0yBovJchIrHNVyGgfgHEjUft5
         pyZd1IDXuHmoTXjYdN2W2R6hYowPgHcLu/1hFlYSf+cfh76f6FfGD/4wh01MSshmf0MC
         38vTU8LcXCxnOxEFg2N4nR0btOCjFQbpzyd8UosvxVuBmirVL0rlCczM8XnP1B9LEpce
         oIXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778491278; x=1779096078;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UfU9k/y/DIWdHKH7EejvCnBIwe+U7Mfc+q++R+Gq41U=;
        b=ejb9DErSGxQWO67GFQpF1dw5GauozcXf5t1R/TfXhX0aW+wzVNOMlRGTXlc+Zmsv8G
         TEsGSXMF7WJLEaPbGXcPiv3SyIjOgMuKOwJ/Kj3Q8yEDhHk18KPGq1JT6mTnTQ9FEL+0
         lf4AtDYjTX+nya47BUWooVrglTr8k+w3vp6jN7Fm6Jxm1Q2OJKvGBcSILAocLpMAjk4d
         syR65FR57RWNmT9uVRQv6Rj8G3oG2XElpHCCn5iuPPldv7OYR4zRrNs7+qiRZu3Ma+Hf
         NOhdlkWzBAOX1YBm42C1XoXeGF0f4u7cGkqFE5lPoHlMKSKuDfLBPg0VWmtVullOgiRe
         ungg==
X-Forwarded-Encrypted: i=1; AFNElJ9mH/nruxrIUz+jhqU+lIdRHMUvcEvfbOJQpqB6oB01c+XTn87ROWsWVdbA1EKmd4TG3k1kzJD3dOJx@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9OOHM+ycDFuX4JestWienHJyizEVAR6U1ZTxXUO40XOryk6UT
	xsishpJEVJj2iqD7dXJdoepgFNSCH9BaOt1oZUd+/OQwi4+qSfsnQUeG2K75nSemf45P7JUHkb6
	OdSaztits5Hc6uIYrpZsR2L3LkUWUjTQgS72COaoe/vwXEdrgzq/G5igI4jhud3r32snvg55b
X-Gm-Gg: Acq92OEU9WKNkm4YPhCf9cK4pdIBH/9tLX2mtQwsSbn1eoXYJR6PH35XNaRrPXpCG9/
	y3kyc58D8e7Nq7yyuuCznExodsesw/6wxXBlihLsKRkkCII41mD5/f0t98oueXJLGKFcElMO3BM
	w1y83Vzf2J4qcH3wO7S/M1DekFoOaxdx3MVIhQUguB8AEblK9L76y8/+zeMj6620MtgQtwjpKWf
	LydPWTQ4J7nM9X4X0qSd+FQ0DpYfNG6oJnFvUpe41hK3ttYwRfTWn3mKKHmap10a7sw+QDv4cLc
	15cClB8k5Ycq79oRg2i7ogIKTb/bTDRG2/bG2x2+tiMPx7Uw3Fc4mddNxsJFgjIw7Qp9mQg5MGY
	Kn+R7Wx+1BS0JrFF86TvpJNlZ4k9v31e0vSM3wC8FCxV1Dd0D8wtk8WDMbAvCjc3KUT6MEow4BU
	5W6obfmfz1
X-Received: by 2002:a05:6a00:3207:b0:83e:e03a:f926 with SMTP id d2e1a72fcca58-83ee03b1ddamr37341b3a.9.1778491277970;
        Mon, 11 May 2026 02:21:17 -0700 (PDT)
X-Received: by 2002:a05:6a00:3207:b0:83e:e03a:f926 with SMTP id d2e1a72fcca58-83ee03b1ddamr37323b3a.9.1778491277480;
        Mon, 11 May 2026 02:21:17 -0700 (PDT)
Received: from [10.133.33.6] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-839679c8634sm23303595b3a.39.2026.05.11.02.21.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2026 02:21:17 -0700 (PDT)
Message-ID: <7f4996c3-a552-4943-ad9e-099e9c9f8303@oss.qualcomm.com>
Date: Mon, 11 May 2026 17:21:13 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] scsi: ufs: Add persistent TX Equalization settings
 support
To: Brian Kao <powenkao@google.com>
Cc: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org,
        linux-scsi@vger.kernel.org
References: <20260424151420.111675-1-can.guo@oss.qualcomm.com>
 <CA+=0d2bunGi-Ht+3ZZ3-+E2FfMObU27QCMYX+r_5RqoAEQq5Ew@mail.gmail.com>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <CA+=0d2bunGi-Ht+3ZZ3-+E2FfMObU27QCMYX+r_5RqoAEQq5Ew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTExMDEwMiBTYWx0ZWRfX6XN3ixkHtXV7
 LXADEpEbgevNofKLmn1KquRlOvLDlSxMcWh/ca2vJvXuWQzdRok3lxplL0zwvSZAYy1plyotrS9
 FkplxhxixN9ALb0ujUMqslI1n9OVpBhEHznzCs6fy48rI3BdMZJ4C4tm913khw5Blg7kQtRF3OQ
 C96UB6rdh5CD/yDVQu6BhAc4VldCAA7kIQSrtWrj0C8LbosRuzTeJAg8bs0Lu0vpydG4KFkkOmy
 iUykdh62BRsSS6vXUNGm++7qJu2/lNlIGZBrkLi0TE0vbqKF3OOv+k3GO/EndJLDEhubDXZ2V1N
 WcDiC7GEqBZbKHuu04TBKyo4UxpAfrY5inGsRqrG5/wJNRlnTTwnTERJNrmaOVQX1z0jQtE42gb
 7tZgJsbsU2KISaGB/RPmk5ZzdvEe/fTv/219PgmKU0eMMjo95byDdaAyL45sF9EjyUwZjaZEG43
 w+I7WbzaLgKf3BehvuA==
X-Proofpoint-ORIG-GUID: XHRkUBiwPaTkCBzMdZVdGxYSWVn7EjwE
X-Proofpoint-GUID: XHRkUBiwPaTkCBzMdZVdGxYSWVn7EjwE
X-Authority-Analysis: v=2.4 cv=cKjQdFeN c=1 sm=1 tr=0 ts=6a019f8e cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=frVo4jl_XUXs4cjuZP8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_02,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0 clxscore=1015
 spamscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605110102

Hi Brian,

On 5/8/2026 5:08 PM, Brian Kao wrote:
> On Fri, Apr 24, 2026 at 11:18 PM Can Guo <can.guo@oss.qualcomm.com> wrote:
>
>> 2. Add TX EQ settings persistence flow:
>>     - Read stored settings from qTxEQGnSettings & wTxEQGnSettingsExt.
>>     - Decode and populate per-gear TX EQ parameters.
>>     - Use Bit[15] in wTxEQGnSettingsExt as validity indication.
>>     - Store trained settings back to these attributes for future reuse.
>>
> Hi Can Guo
>
> Is using Bit[15] as a validity indicator reliable here? Since this
> isn't part of the JEDEC standard—which defines bits [15:6] as Reserved
> for Future Use (RFU)
> Are there plans to propose this validity indicator in a future
> revision of the standard? If so, I would definitely support that
> proposal.
Thank you for supporting it. I will use my internal Qualcomm email to 
reach to
you and Bart for discussion from standard point of view. It can be discussed
further during JEDEC committee meeting in Sapporo.

Thanks,
Can Guo.
>
> Thanks


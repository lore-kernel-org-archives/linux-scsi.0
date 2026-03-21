Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9C12DF68
	for <linux-scsi@vger.kernel.org>; Sat, 21 Mar 2026 02:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774060218; cv=none; b=sX/b/8gX1o2kasBEvlSUaU7NFeXvTGBuzy1c7DpCjn6OOvqZsxiM67E+frP3r6th2/BUQPd6/MCS5DRys7O2h7TgB+KhAh4B0AxTUP8l0GcTjjeZeuyz2T4hlTouIdpPOwPeoXfmI09f7Lg4vXXbMFDHNuC8nS8i3zHN3b9FPrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774060218; c=relaxed/simple;
	bh=KwnbyL/yi10Sqk1McQtYmWVP9BQbn1znlaxK6r20sXM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qzWsSjOHJSNiw71/yzSFj3QS5SPIz0AYSvz72/H2tu9UhfoJur38DE0CC4qH0+z17qI5IZQ3SFG1j0PGjDyURwcXYmMLiHFqloRZViiE+H9EMkOMFX2d5F09f8brRVLOqMBvPbJ6+TrSAPY9rIQEY5A9lp7dSJci16zDdy/CxiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NlcsIfap; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fi23cqUW; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NlcsIfap";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fi23cqUW"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62KLHWT31473284
	for <linux-scsi@vger.kernel.org>; Sat, 21 Mar 2026 02:30:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UBM4HXyCSzxpXUwFOevSunOj9VR6P5sCTO6jji0QkaI=; b=NlcsIfapGqR5K7fA
	Imszjq1seiSyhm3yVMl2IcaaKHBt6oTuSontc3+gsiNgMqu2JpMOxSpGcCHG6rEi
	YxjLNHYi923s38j2aYk2frV7O2tLbK74OwiIqIVnXpHmv1veUPer9GqlMR8D9gs2
	YuZw4poJxJgEuC8Q+cZ4gBCKTxe5NxRP/0kWQWRavYjJ1QUz5DdKSqXjNLTvrax3
	Ygx7cbQwcAqCvmm40cKqum7CHaAnQGxHKCyYNq9HJKfO9SqmhfkKo0sH9E5UEFqj
	u+B34MPhr54YCLHk/C0baRXqvO1VKpMg4mQxGchhDyM2YitxTUupvmwPb108GzKo
	6hdtUA==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d0sm6kkbp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sat, 21 Mar 2026 02:30:16 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b064884a7cso158238565ad.3
        for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2026 19:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774060216; x=1774665016; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UBM4HXyCSzxpXUwFOevSunOj9VR6P5sCTO6jji0QkaI=;
        b=fi23cqUWgRkZOvs3/H0HlRtqbLPflwJQxlGOOreG2R+tcqjF5z37T2gZ56HN/mJW7C
         l0DFHotCj/cYCpF4sFjHQnlDY+WWgD43ZCUrXdLYwWK1A/5HTfM+xSiOl8mt6FfH4aGL
         eO2TXTnCMLibgVC73FDEYRRXZd6VJEo926/Tgfd2BF091HPVrFZt55cC0gq4EpyhoSuQ
         pAz45cJpQBPRcPdJSrMFLKmf94oq1xO1ZZ5BZwN5847KjLbWc6DmOrjemSSXIuukluIP
         jbOuedEkF+ZllYelLYZqEvZTpChYRwY6gOlhvFn4AYbZ/UJx5RI1uBsxtAYMMWEACgpO
         dSWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774060216; x=1774665016;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UBM4HXyCSzxpXUwFOevSunOj9VR6P5sCTO6jji0QkaI=;
        b=GXuBFmiwwjVomJFmaTy+iy4BsOh/opMW2PqC3OVUqPiVCCpCuTTuiCTwxTF05W2AfM
         4nBiV8LYg6VqaZKrpBM/ixGpK7mej5a/IUbJNjwygRIpWkAkgAPWo16uDQuRVLroWIz4
         xHuw6VPewro2/0Z81Bsc/acbyRymx4bfUmx4gonvFacUKPVPB/+mUvg5N/Aj1VeeeMPf
         j93M+yu+mwxBb0pDpNg7FVZZmt6G7/269kM7FyuZP14lc0ZrxESElDLjmcFlpl+cFu5m
         GD6BqWxTjrkoS7K8NgXqL+Hq3bwg/4WqV87FpQJbxvqh5sMG3hhRvKYrZoBrnOsCtU5q
         yrwQ==
X-Gm-Message-State: AOJu0YzrVqqrSf1R6QKk7GKhZhiapVZHf2iP8x7Rt9vMeiND2sNIRJe/
	30biY+p82tY0Ra8rqkC841LraSp5473ClhdnVHWLtUqlDzLyZZ38L7ZnM78e0s/DEQBM4zPR+e3
	Xn1usPVG4PMc2PDXpCdbimUR2xA92MOMKrmdJo7iJY1NnDE1kl1OHZHsynK6OhyKP
X-Gm-Gg: ATEYQzz2FVVIzyHjA/YA/iI8frS1IAktn4rHymlbHFPewmqWujNw73meUuq3RYqJNcq
	gCJ6Jkj96xUoAIeqqrrRIvjqIEgzCGzH5pRiyN3ncjL6kkiRj2Vr5/fzwFbkmTN1boMSispdfv1
	XYXU7j1v2LfaeET6E27IBZVbQ9ch5uDhh5tt6B1ZCOwAdwzJYMV4WqnZAvdmmRCruNuMpcmSOZB
	+vcWe118gVSwJgeNqSgjYY2CKLm/bUH+n0makDW236k08Qy/kaQNc+E073clWekfBxn2wbkz55k
	QjA/Wlz4owkfjxe+vuGlFOp+MTNXY5Xeh+UTTJbrNivGFvAL/SnRvpMXWlRKDJR4x+mv13J0K/G
	GyfoPeAWtglsT5jtylpkWr8exagI3C7US6Ypt9ahCr45GfJjmc1tju7NdxGHmJoSaGT7mY3YX/U
	VoEDUgxyrS9sY=
X-Received: by 2002:a17:903:283:b0:2ae:6205:2345 with SMTP id d9443c01a7336-2b0827b59e8mr43892405ad.35.1774060216020;
        Fri, 20 Mar 2026 19:30:16 -0700 (PDT)
X-Received: by 2002:a17:903:283:b0:2ae:6205:2345 with SMTP id d9443c01a7336-2b0827b59e8mr43892295ad.35.1774060215500;
        Fri, 20 Mar 2026 19:30:15 -0700 (PDT)
Received: from [10.133.33.199] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08366c4f1sm36774925ad.59.2026.03.20.19.30.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2026 19:30:15 -0700 (PDT)
Message-ID: <9aafc127-976b-4861-a8b1-3afc0e0bdae5@oss.qualcomm.com>
Date: Sat, 21 Mar 2026 10:30:08 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/12] scsi: ufs: core: Add support for TX Equalization
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "mani@kernel.org"
 <mani@kernel.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
        "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
 <20260308151409.3779137-5-can.guo@oss.qualcomm.com>
 <42587e16218f1c51dbcbe6bb1639a843e10bcd80.camel@mediatek.com>
 <fa2a97fd-e17d-4314-b5a7-011b6b16a622@oss.qualcomm.com>
 <fb56d5f1-2b53-4627-ab7a-03db13cd76fd@oss.qualcomm.com>
 <ead714be9dbe88ac66b3ce586498f7ffd734e328.camel@mediatek.com>
 <6e2f03ee-6cde-48ea-9f43-6b911117fe4b@oss.qualcomm.com>
 <ab94f19d6fbe8f987da118d2b84d45aa506d2be4.camel@mediatek.com>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <ab94f19d6fbe8f987da118d2b84d45aa506d2be4.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: LLQ80olu6xC6magzKjd_lxlT2ce4lHnF
X-Authority-Analysis: v=2.4 cv=Rv/I7SmK c=1 sm=1 tr=0 ts=69be02b8 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=lZOxv685zBznO1DyOMIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIxMDAxOCBTYWx0ZWRfX02taCKqq9c4x
 ngb7u+yu/sYg75I5fCAbYiP6uconhn8OQCWlhvT1b66a21k4QO1oHsZveJNt5sUp/8f7/VGqmWz
 cSwxYwZaky/vhPPtwZqxegX8sgrAjF8LKar3zELqE+8jjv07F8VwKjnThzhkCu+dtuGw2a6TaEE
 bDTLhAZJJvyIQhHGvsMGOPilLsaft4j208i+L3dh2ZGh3P/vnxwzahJmim2KCilIze4D81KNS8R
 O9KEyBfVpMCmCp4kach9bCeugI4ltSVAEIO0VUm71PkBeBFqmB3i5uR3dkgG15d+HyzS9a2bUp8
 f62Xl8tlVC55h4Q3vqDj3U8ViA3th/doBVemkyS1JPT8Q2+BtEQNCQY1pRq+Jc/ySB/qKGceey1
 DlDxWAUd8Bcw4HHqSa+fhpm07/mIdqHWC500WFhS0tyFuCv3HXLi6dAHLVnENtTLG8JekvS86Mm
 DcsTtcSLW9c1k5MDoKA==
X-Proofpoint-ORIG-GUID: LLQ80olu6xC6magzKjd_lxlT2ce4lHnF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-21_01,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 spamscore=0 phishscore=0 bulkscore=0
 impostorscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603210018



On 3/19/2026 8:42 PM, Peter Wang (王信友) wrote:
>
> On Thu, 2026-03-19 at 13:49 +0800, Can Guo wrote:
> > Sure, for the lanes too. But I will still keep FOM records as u16,
> > because we
> > need to initialize it to a default value other than 0x0 to 0xFF such
> > that we
> > can differentiate a real FOM value (unit 8, read from RX_FOM) from
> > the
> > default one.
> > 
> > Thanks,
> > Can Guo.
> > 
>
> Hi Can,
>
> It seems keeping UINT16 is only for dumping this line.
> if (fom == 0xFFFFFFFF)
> seq_printf(s, "%8s%s", "-", " ");
>
> if the default scan covers all supported preshoot and
> deemphasis values, should the FOM value always be set based
> on the actual hardware reading and thus bypass the initial
> value check for FOM?
> Furthermore, if use_txeq_presets is true, could you simply
> dump only 8 values and bypass the check if FOM is at its
> initial value?
I figured out a better way to handle this. Please check the next version.
Thank you Peter for advising and providing valuable inputs.

Thanks,
Can Guo.
>
> Thanks.
> Peter
>
>
> ************* MEDIATEK Confidentiality Notice
>   ********************
> The information contained in this e-mail message (including any
> attachments) may be confidential, proprietary, privileged, or otherwise
> exempt from disclosure under applicable laws. It is intended to be
> conveyed only to the designated recipient(s). Any use, dissemination,
> distribution, printing, retaining or copying of this e-mail (including its
> attachments) by unintended recipient(s) is strictly prohibited and may
> be unlawful. If you are not an intended recipient of this e-mail, or believe
>   
> that you have received this e-mail in error, please notify the sender
> immediately (by replying to this e-mail), delete any and all copies of
> this e-mail (including any attachments) from your system, and do not
> disclose the content of this e-mail to any other person. Thank you!


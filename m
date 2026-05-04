Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9458C37C10F
	for <linux-scsi@vger.kernel.org>; Mon,  4 May 2026 12:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777899355; cv=none; b=DAmFyV2toAxKbRb5zyX8jDv2znDZQ1Mq9tfoNIpd90nYTSvjzLU24Ohvrv02AIyRDgZ4v1JFN1rZGYKsCvbObQW3NhKajcb+aCTwg4nvXO582mK5QWQFYgvKsBoPtUQ8OsewnN95MwZsVR0+B6jAJSPRSiVb7lG1b50XRdbnEqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777899355; c=relaxed/simple;
	bh=jdMfO+wVnXO8QtbdIYQW9kPgqzpCibK0jcuCZrC9udA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bkBSD6O7JoTHf5I2EHow7RMmvUdnMQtNnUopaXBkssrTGIbjW83eL1v76bGcxb9gtBcsynmqAiZ9quljHw5sUY2ZtdmPCR1R6oCk+lVgmRCdhaq09mS6VdnKTQWI/rzQnW2o021Gw+L0iN4SBzgfP/P9wvCoXNXbRMY5kFgpihc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Hesuz5Jh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MpHaXl57; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Hesuz5Jh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MpHaXl57"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 644B49L34128668
	for <linux-scsi@vger.kernel.org>; Mon, 4 May 2026 12:55:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	puGm2x20jalWEH3pSnTKZBC2VvUqLgjVbRrcGWaj4m4=; b=Hesuz5Jhgvh16Eib
	fe6XMFBOmmAL58ZYoKgC//G9Z7eKM+cBm8WKX+4ki8G8oOAis1GoEVnAzjy47H9T
	XHvE+UzJFoFynW6lZQGsX6fvN67Z0wBaa3OV71KjkkuBzxGxjsuCxRqlvFnHYTvR
	+MjMci0gdE3UXr2iyGlJLMoTaiwmacyWEjO7Mm1IRg1bZIvi3J80z5EdEEoaYYlQ
	41HjqG/uPe0hi7B4Lv0BmaZ30TTCCM4ZnOcvdj9gJ0cjUKkoTrJgr8801u+a9lIg
	57oEA5Y2ebaEkfjkzEskzXdtu2jHbsH1XmdVm9IG8tjUzwC9Mzr1j4f/Vt8cDwkX
	G76xkQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dxsdw0euu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 04 May 2026 12:55:52 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b4678c6171so39773055ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 04 May 2026 05:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777899352; x=1778504152; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=puGm2x20jalWEH3pSnTKZBC2VvUqLgjVbRrcGWaj4m4=;
        b=MpHaXl571hNsCIo63kQj+7JWJgLV/wZhmsUjKIAXIlo/5N91EMqm6qUo619pJ7unpd
         TjnhnQLfgFcogqAkiFJqhg36RMkc7FH+4hrNmUxklFCZNJi2/+MsJIp+JIslYz6FuFuu
         hI+Xg7p8tFNyvhkGgfNg3HBsJaHkxRPG9altVlwdV5pZId3yMs9qeRz/YiWW2I8IQPpJ
         bZ5qRxYH5iLPWyk1RunUOZ2kG00E0bD3Yz8nJcCoYnFK9RajttDp0hnMV0MJcYk1BSi8
         8NcyesDSUNb/4CD1EQ8h6owiehjnux0b4gEzR9GkhhfdMjn7SIXflBkWwrDpEnRQIm72
         cJoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777899352; x=1778504152;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=puGm2x20jalWEH3pSnTKZBC2VvUqLgjVbRrcGWaj4m4=;
        b=CdbJ+iQzZEMORizKR8hrZOzy+KR/HiES1JCPotVdxsU+XXlgVqmY32sQ0bPFkEJAZo
         wJnwZJpiUZnTLk0DjOlZPFRBTXXbiEQVxwrtOygXDxJNsJLQEJBewbTWSXqSgBYssFeZ
         qQeO8ntxV+L19O3avwkHw2xQM2GXIVVRWx6BlLsywm7Wfzp9fMb5YPIR1861uuC/NzO9
         yS//q9lD4SLea5pSwKAiRF9ftTrT/uvejUOsuJnRiFQUH/6HnNTeu+31GTv1fqGNJZuK
         GUTXDEclogoH9Mz+hXB0AXqq9x2vQBq37klyJtqhTYiDpXsu5BM7FpboH6CJnEZQaMsV
         yDhg==
X-Gm-Message-State: AOJu0YwO4ByKcNfZsS0bHMOK5VlCmRNfaPcSOfKL5LNiUYwEdkxNQRmC
	tU2mS5zDR9V9eBvVhAJxoCMVnaELZ7jvqq5H/2VU2Lzy36wlcSuzO7fyex9thQV9Z0RrV/ZhXEu
	O1ESuD3BwCVTO+CMV+pdhUfJvJURgm3UiS/pWcJ5cZW38b0x5/pZ7Jtta3leoJmHp
X-Gm-Gg: AeBDiesxwTWCWeuo1wguPa0ivmfmpBPmVc0fvl5cvLEw+MvKx1wFVfuCrPiIdcTva82
	+P80X6QUllu7ftHFVkDa7tFAhyYOCqJXyAesQsS9FEK2zHM7FfPz9XCYtKwHPKRlEcjS5CvPmez
	xQjf1Q9/dJjFGnBqtJXV3MvVs1qQU3YDVXfjTXYB5ShWsZqmCeqKk2ZX0kUqASMWBtC6nEBtmtw
	95KT4JZjNCrJGGKj8Sv5qGW5gAkmY50uOfBrJ8aOXRGeqFkhui2GggvdsD027wMYW9yg7s8OKik
	7Novq1L3BA852HlWE/ej9GmN6bDygoFiXc/uUZwNL09sgyHeF1mdvmNGwyOygFpNj5ktrKW/tPG
	1DrqFcF/M+liiOxee7xDDiws2tTCtn7QrqJvm9DA5oQC6p9tuDskMEdRwUcH0RjwyJR2rKAG2bZ
	aDCPsaHagxbkBNaKt8TpfZGg==
X-Received: by 2002:a17:903:1b4f:b0:2b4:5986:cd80 with SMTP id d9443c01a7336-2b9f2812383mr95668755ad.26.1777899351439;
        Mon, 04 May 2026 05:55:51 -0700 (PDT)
X-Received: by 2002:a17:903:1b4f:b0:2b4:5986:cd80 with SMTP id d9443c01a7336-2b9f2812383mr95668525ad.26.1777899350893;
        Mon, 04 May 2026 05:55:50 -0700 (PDT)
Received: from [10.133.33.164] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9caa7e855sm99778495ad.10.2026.05.04.05.55.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 05:55:50 -0700 (PDT)
Message-ID: <8a1cf09d-7293-464e-b581-5337f4087593@oss.qualcomm.com>
Date: Mon, 4 May 2026 20:55:25 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: ufs: core: Add a quirk for extended TX EQTR
 Adapt L0L1L2L3 length
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "mani@kernel.org"
 <mani@kernel.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260501131641.826258-1-can.guo@oss.qualcomm.com>
 <20260501131641.826258-2-can.guo@oss.qualcomm.com>
 <a173bb1733968d41690f8472d13b95028c8975c5.camel@mediatek.com>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <a173bb1733968d41690f8472d13b95028c8975c5.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=a7AAM0SF c=1 sm=1 tr=0 ts=69f89758 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=kDnxYmXqCbPNdaTBimYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: 0YZSfd9-7Kyj_Joa3uDOFZwTysQOrThe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDEzNyBTYWx0ZWRfX+P6DoiBU86Xa
 tPket1SrBaLelaZsLcCQU2ORQ1EidKrGaGf7Xa0BTfY7lkReFz6lWkYd0nnCd9eYCcdKwq/JX5O
 XamP/aM/CxcnUPw/5RNw1+pf5otgoEtYl77b159wzMVbpx9OtXo2+rsEoWv5iRnFwDuGOcKWcYm
 4c13fHXPLBqVFmtX7M61WcX/Ou5OexghSMPCpsU7yePun6ndjwHi3oFuZYEvXjQ+K/k7dRZR/YN
 mmooTIjnTlHpJR15E7CEab9W8OOfpI6QNzqM1W0ar503o9TVysKTPsyDeWrfw8RbQq0ouQWrE8R
 aWc/Lb5YK6y6xUPc6gqrfydmvZb/DgKqKI8N13uxrrUfDY6hTolUPXhmRHmS4vx1sTFWpqOffQH
 AmlTFuqd2dB2u/XvwES+0GAwWF5unfjhtgVlgBM/VyOcwrSTOehc0bXo/VwH8z2j/0pefI3Zpo0
 GaW3rtEjUWntwLSM1Hg==
X-Proofpoint-ORIG-GUID: 0YZSfd9-7Kyj_Joa3uDOFZwTysQOrThe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_04,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605040137


On 5/4/2026 5:19 PM, Peter Wang (王信友) wrote:
>
> On Fri, 2026-05-01 at 06:16 -0700, Can Guo wrote:
> > 
> > diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-
> > txeq.c
> > index b2dc89124353..fe647450a7a1 100644
> > --- a/drivers/ufs/core/ufs-txeq.c
> > +++ b/drivers/ufs/core/ufs-txeq.c
> > @@ -740,7 +740,9 @@ static int
> > ufshcd_setup_tx_eqtr_adapt_length(struct ufs_hba *hba,
> >                 if (adapt_l0l1l2l3_cap_local >
> > ADAPT_L0L1L2L3_LENGTH_MAX) {
> >                         dev_err(hba->dev, "local
> > RX_HS_G%u_ADAPT_INITIAL_L0L1L2L3_CAP (0x%x) exceeds MAX\n",
> >                                 gear, adapt_l0l1l2l3_cap_local);
> > -                       return -EINVAL;
> > +
> > +                       if (!(hba->quirks &
> > UFSHCD_QUIRK_EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3))
> > +                               return -EINVAL;
> >                 }
> > 
> >                 ret = ufshcd_dme_get(hba,
> > UIC_ARG_MIB(PA_PEERRXHSG6ADAPTINITIALL0L1L2L3),
> > @@ -751,7 +753,9 @@ static int
> > ufshcd_setup_tx_eqtr_adapt_length(struct ufs_hba *hba,
> >                 if (adapt_l0l1l2l3_cap_peer >
> > ADAPT_L0L1L2L3_LENGTH_MAX) {
> >                         dev_err(hba->dev, "peer
> > RX_HS_G%u_ADAPT_INITIAL_L0L1L2L3_CAP (0x%x) exceeds MAX\n",
> >                                 gear, adapt_l0l1l2l3_cap_peer);
> > -                       return -EINVAL;
> > +
> > +                       if (!(hba->quirks &
> > UFSHCD_QUIRK_EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3))
> > +                               return -EINVAL;
> > 
>
> Hi Can,
>
> The quirk UFSHCD_QUIRK_EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3
> is defined as a host quirk, but it appears to be used for the
> device (peer) in this context. Is this usage wrong or intended?
Hi Peter,

Thanks for raising this; it is a good question. And I had spent quite 
some time
on this one trying to make it as simple as possible...

Firstly, it is intended. In TX EQTR flow, the host software programs a Adapt
Length value to PA_TXADAPTLENGTH_EQTR and initiates TX EQTR procedure.
With this quirk enabled, the host software is allowed (by Host HW) to 
continue
TX EQTR even with a value which is above the spec max, so the Host software
can attempt an extended (out-of-spec) value.

Then the outcome is naturally determined by the peer device:
1. If the device tolerates the extended value, TX EQTR succeeds.
2. If the device does not, TX EQTR fails as part of normal EQTR behavior.

So the quirk is intentionally host-only.

A separate device quirk could be added, but for this path it would be 
redundant
and would increase maintenance burden (for tracking a list of such 
devices) without
changing the outcome.

I hope I have answered your question and you can understand my 
considerations.

Thanks,
Can Guo.
>
> Thanks
> Peter
>
>
> ************* MEDIATEK Confidentiality Notice ********************
> The information contained in this e-mail message (including any
> attachments) may be confidential, proprietary, privileged, or otherwise
> exempt from disclosure under applicable laws. It is intended to be
> conveyed only to the designated recipient(s). Any use, dissemination,
> distribution, printing, retaining or copying of this e-mail (including its
> attachments) by unintended recipient(s) is strictly prohibited and may
> be unlawful. If you are not an intended recipient of this e-mail, or believe
> that you have received this e-mail in error, please notify the sender
> immediately (by replying to this e-mail), delete any and all copies of
> this e-mail (including any attachments) from your system, and do not
> disclose the content of this e-mail to any other person. Thank you!


Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E525B37C0E5
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 05:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773898938; cv=none; b=mA84ARngpOpelkflWFjCuVTigyimtO02hnlAUEAgXv0VPG0povB1Y76PEb8ywcgL+muvcnnXDH/WTFW8prxoxsOqw8wxc+xQvHl2PimCfp+yekrk//TymIjTppOlTDzBymDBNdAvsfae2Wsr/+2SEQf4vRqLJFkvq3KknlUj4lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773898938; c=relaxed/simple;
	bh=Env9dqP/aHkb5Su4ovq0HDnEj7fbeLxcbgP6xerY6A0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ef6yGoA2vKEVt7PSLWAU0hfHkjUlOSZNE7QDTnSteO2I54+w4musFL/7APkbPzPHVainjXHW3mxlgV8zTy9QfBOuJzRhZUE5q6C9NAPKpQZBSUHDp6v3T1xQWaHlokLyAvRNMlrpVaIT0KKC7ZYCj5RSghVlcxbg4WSiFIK5WJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FaoEoIcf; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YRmDAK7w; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FaoEoIcf";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YRmDAK7w"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62J5XtIK1802752
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 05:42:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5gjmsGsOfj0yQUWzeGx/ne5JG6lmq+6y6xPSztX/m4c=; b=FaoEoIcfwQPRfSOU
	hMeZEDfMqlS++zcxqMHW8jVSaw/Pwza0eTLCQvYx/Zxd3sI3QxoJbMJwLhCt67/C
	whDMLocrFYrU2I6gKPmdsrGiqXsQ+z3UQud8h6U3kNHGFvMOn9iDoAEuPRx1MrI+
	FrHRGUH4kOdTBFeWH4zMHJJ1ON76qriJ2KSZvq9Bsp+CBTxXrrY1r+zRplRzpHY/
	vOaQ2s+HRhxX3Sj92+kLRHWhoq+HBqEcWVvI/Ngqt0QDC8uoJXC3pPAkSvZrv4D9
	N42CNh9HWGPePRmg+RNYQtlj7IrX/BhI8thSWMQvrZUzY8E4cahEAqfVZ/Dx1i86
	O8Nvng==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cyscb3rbu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 05:42:15 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b04293b16cso26463185ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 22:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773898935; x=1774503735; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5gjmsGsOfj0yQUWzeGx/ne5JG6lmq+6y6xPSztX/m4c=;
        b=YRmDAK7wjaTpr1suJfSg2mxsnGudAYYJX9DKdNTL5vUcTQWB7oEukSCdWHZkz/9tK4
         K6seg8Itrg2gFFp9m0DqNDDa+0vvdx6wdA5hgxmVcPV4cIFcNmWYA5R7LMCwdZWlIp8q
         PgN8HcPKbSwcXGKvzcX3AJ3+YyQGIooYGB5gAIIRl6Fs99eXESYrKPjbWoZqb9rwVTkt
         eyl78Zz5WiaaYdAQ8jEN9uDHWltRKdAl17xb61f+zNk7bHi+ROVhqB4dCRcStm9tb7Bf
         Y+iT1GpD5e7qYnpa92AoqiZF41v3AM09pwdjDjkQrIpbYXoJ7AKZ3s0S5Ec9J/C8uYbQ
         wG0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773898935; x=1774503735;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5gjmsGsOfj0yQUWzeGx/ne5JG6lmq+6y6xPSztX/m4c=;
        b=UfTgxhv8UHdf3OmUipXHnNV+Zcpz/nbzM2LyeBkp5OD0edzbMGaM6oQIHJfv2PSeYm
         nKt8HXQmUZ18ls7YTTBgU4MrWjpfCCiaKHHxpGZi0emFyp/qXmYcporjKGbFey8A2i36
         APV5U9WXEhHx4QWlChcX0TaKl+AfUkxJYjJkRi+/m/Brt8XNblHtYJ+rK3plgAB094df
         TJ34VZieNGVIyXw13znV0fuIuU5Yg/DWY3BcQwskUEPvsoUZpPx10mEoiZw51us/xbt2
         SPL7j3th3zCLG6Do58UB6dXwEsH/ZhSzpDHhkmvkTYOc0+eJAWTSfY+WS/u8NN2/s+7w
         lldw==
X-Gm-Message-State: AOJu0Yw/FczD3rNFSq4VJsBt+NKmBxY4vCbG71OjyjI6396vsqgw40NJ
	vawrsv7ChYhYngpT7MhhofsECpsO/OnZ7DSZZL0kGQW0V5Rzxvr2sTlCAMypZAUIl8zpSQzJ8Hc
	WCG/2/D2a7igdtDHsaCG/UNzA9TDZWShrE787VhI7r9nPuMrGk7VT4GZZ8ykS1PNo
X-Gm-Gg: ATEYQzwdE8VrObLJtHucwTe3Ei6ax56Xl8OfhMGKiPs8MjNIA81VziqFTHIudIMRIsF
	4kMjDOFlI8YH22w82DtAnhyr1ZReLYp9m5hG1Q2DOz4MC1Ido5FIAULlmG4v9Zl66YEKhiVBgXW
	j007nB0I0oWN2OBACSUfbYf4aTUS6V68bnqeg+uGRlKOYgjARxHUT9CY/16e2NmfqO17ZFLeuJy
	+tkN0n3PDQn7MgwzyfmKwQ3Nqw+ElaEuhBpGRqvuVkWLIRoRI0ZMvuc+TzCENXNBYPLCu9v7m5Y
	7pVZT6rLsKZ4I10g+5aGJe5SEyDqCn3QHpXc0p4OVPAhgQBv85aq5X3pT7hKB+gS21Lbkjt86Hv
	NcRpS3+Wl3UMtasJ77Ah6eY6maUPVST0uTjKSyC4ybCrxGB9rPF7lNIMyEOQhC2oE928e1CwNy7
	PAS8O4sLNNJA==
X-Received: by 2002:a17:903:2ca:b0:2b0:603e:e147 with SMTP id d9443c01a7336-2b06e357e90mr62221915ad.22.1773898934694;
        Wed, 18 Mar 2026 22:42:14 -0700 (PDT)
X-Received: by 2002:a17:903:2ca:b0:2b0:603e:e147 with SMTP id d9443c01a7336-2b06e357e90mr62221605ad.22.1773898934237;
        Wed, 18 Mar 2026 22:42:14 -0700 (PDT)
Received: from [10.133.33.84] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b06e61cacbsm44735525ad.72.2026.03.18.22.42.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 22:42:13 -0700 (PDT)
Message-ID: <05c818c9-8be7-4680-9902-1ae56f374fc7@oss.qualcomm.com>
Date: Thu, 19 Mar 2026 13:42:10 +0800
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
 <1318f77eca87a01815214e7fb0178281871c9b1f.camel@mediatek.com>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <1318f77eca87a01815214e7fb0178281871c9b1f.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: gBtrr1NIqd25DrRBzghJGpc3EKWG4rBq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE5MDA0MiBTYWx0ZWRfXz7xSCLF2/QDX
 T3xfHuvTcYwFGAftf6yDbv3CUbcQQw7YU9PEBiAGwOrb0XzMSTXj0GWfnyRjvjnCF/5riQk5MBL
 GPcMRmZX7JE8FIay17lo+Lan6UzVyadkAsgvQT+jXDaWOKzo9uggdDCNfT+PNn/+4j17sO6D0KN
 97I6JbkNX5Ij79uWvw5Dr+NgEuUI5x/yM/8qBzXeWsFuzM2bHqUW2ubrbr52NTTl257JiVknWYc
 ko0OYz+Jh9wfHlLw2eFkng5iSQJJ++N/fnEdqqeJqzWC+aR64mpJQrCYw+SpBy2DJiCpBqQU15/
 U9pOoDdJJ2546DDf9RyMOM0Zd+s+QiYFAtmDxGZCnfJYnNZEOsUFb0lVHZhzTIRnwPrC3CzT9pO
 Ba5JaBtDupwLuIPbNKU94crglfJdlxfl4/mqxHxnJfftDzv6a+6xAqs05XM5cmR347RW6pD1S99
 oo6pjH9mYGMHTTSg5gg==
X-Proofpoint-GUID: gBtrr1NIqd25DrRBzghJGpc3EKWG4rBq
X-Authority-Analysis: v=2.4 cv=PtCergM3 c=1 sm=1 tr=0 ts=69bb8cb7 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=8fswfkG2DZOyL5G1xN4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-19_01,2026-03-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603190042

Hi Peter,

On 3/17/2026 9:08 PM, Peter Wang (王信友) wrote:
>
> On Tue, 2026-03-17 at 15:22 +0800, Can Guo wrote:
> > Here is the consideration:
> > 
> > 1. Scanning all 64 PreShoot/DeEmphasis combinations cost (much) more
> > time
> >    a. This could impact bootup KPI
> >    b. During TX EQTR, IOs are paused, when one conducts a re-
> > training,
> > the IOs could
> >         be paused for too long.
> > 
>
> Hi Can,
>
> Yes, it will take some time, but according to the specification,
> we need to find the best FOM, so the default value should still
> follow the specification.
It is just a default value of module parameter , one can change it via boot
cmdline. But since you have asked it twice, I will change the default 
value to
true in next version.
>
>
> > 2. As per our study in the past few months, the optimal/best
> > combination
> > is most
> >      likely within the 8 presets, which is true for both Host TX
> > lanes
> > and Device TX lanes.
> > 
>
> Host may be true, but there are so many devices, and new UFS 5.0
> devices will keep being released in the future. How can we
> guarantee that the optimal/best combination is most likely
> within the 8 presets?
>
>
> > 3. Even if sometime the optimal settings which fall out of the 8
> > presets, they are very
> >      close to optimal one found within the 8 presets.
> > 
>
> Could you share what led you to this conclusion?
>  From the scores reported by each vendor, it’s hard for us to
> determine what a difference of a few points actually means.
>
>
> > So, scanning the 8 presets only is more cost-efficient.
> > > 
> > > > +ufshcd_tx_eqtr_result_examine(struct ufshcd_tx_eq_params
> > > > *old_params,
> > > > +                             struct ufshcd_tx_eq_params
> > > > *new_params)
> > > > +{
> > > > +       int lane;
> > > > +
> > > > +       if (!old_params->is_valid)
> > > > +               return;
> > > 
> > > Is is_valid always false, causing a return here?
> > It can be valid if we are here (again) because one conducts a re-
> > training.
> > > 
>
> Then, should this function be moved to [07/12], which supports
> retraining?
Sure, I will move in next version.

Thanks,
Can Guo.
>
> Thanks.
> Peter
>
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


Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93FF3DB639
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 13:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691449; cv=none; b=q+KcLiGosCgkFAG7l+gIv+mY8bw0dYPrxKHdi5aljOgKiqMJCPwzTVal85X4bSHf14t15ZFqPbAkx0IR7pumSdNK+yRmG6Tp6Q34tw5swSWBRoKIvqyjFos/3HVt6AUwcfJggWTR7u4xKf2BaDqQsDywU39/8Da+k76D1i6jEpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691449; c=relaxed/simple;
	bh=8ylkqti/sSUZdPNlwwSt44ai5eMfB57lPVH9WhXVTjg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hym6lV0vg9G93MS9+s2zSVtBtB2ih7Ln9BySye5eVpHK5PLW+F2qWehZny5vqg76G52B4awasKZGIHMLvgWV5zVlP//dwpMxgDmefXW2RzhUO5MX2Pi2k/5Z5s61iV+hJeT1ouFBkOrJGsE/Lh1274f3/Qe+WOJbKXDd001Ar74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=A2Thtnqc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZC88eT5W; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="A2Thtnqc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZC88eT5W"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63KA4LXD2981443
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 13:24:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Gngp/CETZjF2tD5OHeLeeyMJqQiVJHesXq1xeKIgBeQ=; b=A2ThtnqcEZdzYu3M
	M0FfrQ5Y+pkJC6xT38w6Pf97aMl1s2SvACVW0H/jmKnEmytpTXZKB0j1YibgyM8s
	VWKnQSIi1wB94NGBzlYbPJDGAkl411h/MO0vVTetT2SUuoUk6g8ln9AvoU0obH+9
	XqfUaPm1D8LPF6m8gEoUlk8fpOA5JyZxg+Q1tsyj0r1PWTH320+ntBR0BnIFz4kz
	T3+tjgQeBc1kY5qKafJAJxhHxL/zIz8SG4m18pXNV0DG57gCt+48d9eEVafuS76l
	ilysghGasW8RXUgMYse5+dSzknL/hz16Eb2S1if4cXYruHeSjtcQjSe/F7FCzVJD
	QTZblA==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dnj2prmeb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 13:24:04 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-82f9aa52c92so2393906b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 06:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776691444; x=1777296244; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gngp/CETZjF2tD5OHeLeeyMJqQiVJHesXq1xeKIgBeQ=;
        b=ZC88eT5WguOUlYrmHPJL8CrNnDnkY/cu7JBPoDyB6jmNouuqDJkIjvx5vuPwov9Hcv
         JJVxKGl/FwyFiH7CwnK1gZoe922wOANT7KIRSlUotd7rYqBfC8UlVFayBwQabk3M+Fxh
         dv30d2wyVr5D1DstID+O1Ok0/hgjCM+i8D0EbRMoO42UTE0i2omC0QjXtli21xEwlEqB
         oml7Sy/Mqxji27hDjOaC/qAonargTrou57B9ivZaNsH4A3G/OOs7sKL3uaHlIKFQEZAU
         5DG85sLYCVs19crIDFzXNNqKIr3r8zg6ruPwk3tYtnatnclNI3j+DcNrLc706FqF3DGl
         I1CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776691444; x=1777296244;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gngp/CETZjF2tD5OHeLeeyMJqQiVJHesXq1xeKIgBeQ=;
        b=nvdNCdpiYZdQwNfOiqg2SagvWe8mHBFRzV0Yg4Y36bjoCJLA7/BXDCe73dF+AY2Lgz
         NXzoWBNYYL2VtW9GKRPuiPq6RmyrExQRhlTLOjt3D4KqyznxgIeguettyqBTXnsxQ/8P
         HuoFVL/qwXld+gTNDTG8wEuJXCjzt2dCkXWRfildT7O5l7C7kvziqSXBPsVsogG8np/l
         JCVUQlUU2H9WucboymMtvoi9og5xgGjZY+e1+e+xlfI2GH1Lx2xBjeXjDx700cVdOtBS
         lDAUbsgPvsu54zomkCU8lYS/T1CyI605TiV5U9dIc5RSPSusptiQ6PLAyZo7rRHl83K7
         OY2Q==
X-Gm-Message-State: AOJu0YzYEEd1wGVgH0nT+QZVM5e4Dx43dZpm/MsV4YV1xD4+PcVmH049
	xiWYeqRVvmi7LZiVyY8/7E3RY0FAhNQ3ZCBSFJD5+TkL72IvrWQ4pjRVtndRpiFtJhB+WjnBVzz
	em+K4M1ZaCOYErFkLO0Q/1iflcgCYfLoHK242W849kUDY16iUU8hfg/baV0Ybnk7w
X-Gm-Gg: AeBDietAXidATLYwGt2yYTS34vBBdMCZU+rLzRTkRcipPvJfPZNHw4c648gznshy494
	rJb2/QVE49gVaXCYdEkSHWJZB4bp1H1gO2XMtMuvi3ewQj6gIrnDif41pzugLEtkSqpLP0LBIzw
	t0c4wxKSZ2F4amaM4zRxnqTH5QeFiHANols62+rQzeyQNnijYAPJ2yjf0c0au69d4zwRhItCRqy
	cv6eqGprl5v/9JhcYXTYoKOL9Xd1Lxc242wMWetn8cLagzU5WyXBjfxa9L8O+RxSKUN1bFB4RuK
	T0RubRfWmmgWM+rHfotYnM+GnD69SBI6wlHFpVWGi6osM9lsPmiGkB671z9DcXve0HY2RKI8aID
	MdB4NI3pPYA1QpcRfmtzNdlOaxnGSWHVjUn/ueFsdfDAJEajM0ZWNBLuumFI25PU+GHZ3X5UXx3
	en2AyVEUPg0b4QZEmUq0ZG0A==
X-Received: by 2002:a05:6a00:69a5:b0:82f:a6bf:bed8 with SMTP id d2e1a72fcca58-82fa6bfcb08mr5736681b3a.45.1776691444117;
        Mon, 20 Apr 2026 06:24:04 -0700 (PDT)
X-Received: by 2002:a05:6a00:69a5:b0:82f:a6bf:bed8 with SMTP id d2e1a72fcca58-82fa6bfcb08mr5736647b3a.45.1776691443416;
        Mon, 20 Apr 2026 06:24:03 -0700 (PDT)
Received: from [10.133.33.183] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8e9d2fa9sm11205595b3a.16.2026.04.20.06.23.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2026 06:24:03 -0700 (PDT)
Message-ID: <a4792823-5c9c-4a4f-89f2-fde117455506@oss.qualcomm.com>
Date: Mon, 20 Apr 2026 21:23:57 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Add support to retrieve and store TX
 Equalization settings
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "mani@kernel.org"
 <mani@kernel.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
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
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <343283a8281e2fb0ee83622a15028d12e44bd964.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: EV9konb_rDfW7LNnPKRaxvFEtnpj4DcK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDEzMCBTYWx0ZWRfX5apF8Nb9RBwC
 2oD11/UXPjDO0JZSQGwTFN+clE6X8aZNzR2V1wQUkBjBdrHIy3JnMHC12yzP6w3FDofTggGzzhp
 vL377Qr5rdISeIndaRcwiMC49yYXIcG51gsrU4Yap3qDjm0w7e+O4ewi6ugUdtED5aO35DVlH5h
 xzG1MStolA8E62s0yMYx68XmQrvp74AMmYVd4j34MzNfPbr6w0iw1odL2VD/GOyaLC4wmwN/9KD
 oi2DKwbznsQfK1SgCRwCzzbfo8f2lf/1YUTykXaFZ9qwQFpm9aUajTsWIaraQQTO8P5MC45wf5n
 /WTXW90+P0cq03gsZoyiYzoI15IGql9gPAwctUYFSayoubMswkCjNZ+t5Poujaxk0dzTNTbiPnN
 ESvEnU6eU6+uI7w8jMGft60xlZtJeSqznMzmBC3O0XZSOYcLINJEKrXn+FLy4qB1VHWLnDXmVk7
 RieSFAiV4/nJKYWpyWA==
X-Authority-Analysis: v=2.4 cv=XMoAjwhE c=1 sm=1 tr=0 ts=69e628f4 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=et_n9UT1xrTU5jfS9lkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-GUID: EV9konb_rDfW7LNnPKRaxvFEtnpj4DcK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_03,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 phishscore=0 adultscore=0 spamscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604200130


On 4/20/2026 8:33 PM, Peter Wang (王信友) wrote:
>
> On Sun, 2026-04-19 at 06:52 -0700, Can Guo wrote:
> > Add support for UFS v5.0 JEDEC attributes qTxEQGnSettings and
> > wTxEQGnSettingsExt to enable persistent storage and retrieval of
> > optimal TX Equalization settings.
> > 
> > This provides a fast-path for TX Equalization by reusing previously
> > stored optimal settings, avoiding TX Equalization Training (EQTR)
> > procedures during subsequent Power Mode changes.
> > 
> > When no valid TX Equalization settings are found, fall back to full
> > TX
> > EQTR procedures and optionally save the results for future use.
> > 
> > The validity of one set of TX Equalization settings is indicated by
> > Bit[15] in wTxEQGnSettingsExt.
> > 
> > Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
> > ---
> >  drivers/ufs/core/ufs-txeq.c    | 241
> > +++++++++++++++++++++++++++++++++
> >  drivers/ufs/core/ufshcd-priv.h |   2 +
> >  drivers/ufs/core/ufshcd.c      |   5 +
> >  include/ufs/ufs.h              |   2 +
> >  include/ufs/ufshcd.h           |   2 +
> >  5 files changed, 252 insertions(+)
> > 
> > diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-
> > txeq.c
> > index b2dc89124353..aa9420b0d1c3 100644
> > --- a/drivers/ufs/core/ufs-txeq.c
> > +++ b/drivers/ufs/core/ufs-txeq.c
> > @@ -14,6 +14,83 @@
> >  #include <ufs/unipro.h>
> >  #include "ufshcd-priv.h"
> > 
> > +#define TX_EQ_SETTING_MASK             0x7
> > +#define TX_EQ_SETTINGS_VALID_BIT       BIT(15)
> > +
> > +/*
> > + * Decode Device TX Equalization settings based on qTxEQGnSettings
> > bit assignment:
> > + * bit[3:0]: Device TX Logical LANE 0 PreShoot
> > + * bit[7:4]: Device TX Logical LANE 1 PreShoot
> > + * bit[19:16]: Device TX Logical LANE 0 DeEmphasis
> > + * bit[23:20]: Device TX Logical LANE 1 DeEmphasis
> > + */
> > +#define TX_EQ_DEVICE_PRESHOOT_DECODE(eq, lane) \
> > +       (((eq) >> ((lane) * TX_HS_PRESHOOT_SHIFT)) &
> > TX_EQ_SETTING_MASK)
> > +#define TX_EQ_DEVICE_DEEMPHASIS_DECODE(eq, lane) \
> > +       (((eq) >> ((lane) * TX_HS_DEEMPHASIS_SHIFT + 16)) &
> > TX_EQ_SETTING_MASK)
> > +/*
> > + * Decode Host TX Equalization settings based on qTxEQGnSettings bit
> > assignment:
> > + * bit[35:32]: Host TX Logical LANE 0 PreShoot
> > + * bit[39:36]: Host TX Logical LANE 1 PreShoot
> > + * bit[51:48]: Host TX Logical LANE 0 DeEmphasis
> > + * bit[55:52]: Host TX Logical LANE 1 DeEmphasis
> > + */
> > +#define TX_EQ_HOST_PRESHOOT_DECODE(eq, lane) \
> > +       (((eq) >> ((lane) * TX_HS_PRESHOOT_SHIFT + 32)) &
> > TX_EQ_SETTING_MASK)
> > +#define TX_EQ_HOST_DEEMPHASIS_DECODE(eq, lane) \
> > +       (((eq) >> ((lane) * TX_HS_DEEMPHASIS_SHIFT + 48)) &
> > TX_EQ_SETTING_MASK)
> > +
> > +/*
> > + * Decode Device TX precode_en indication based on
> > dTxEQGnSettingsExt bit assignment:
> > + * bit[0]: PreCodeEn for Device TX Logical LANE 0
> > + * bit[1]: PreCodeEn for Device TX Logical LANE 1
> > + */
> > +#define TX_EQ_DEVICE_PRECODE_EN_DECODE(eq_ext, lane) \
> > +       (!!((eq_ext) & (1 << (lane))))
> > +/*
> > + * Decode Host TX precode_en indication based on dTxEQGnSettingsExt
> > bit assignment:
> > + * bit[4]: PreCodeEn for Device RX Logical LANE 0
> > + * bit[5]: PreCodeEn for Device RX Logical LANE 1
> > + */
> > +#define TX_EQ_HOST_PRECODE_EN_DECODE(eq_ext, lane) \
> > +       (!!((eq_ext) & (1 << ((lane) + 4))))
> > +
> > +/*
> > + * Encode qTxEQGnSettings based on bit assignment:
> > + * bit[3:0]: Device TX Logical LANE 0 PreShoot
> > + * bit[7:4]: Device TX Logical LANE 1 PreShoot
> > + * bit[19:16]: Device TX Logical LANE 0 DeEmphasis
> > + * bit[23:20]: Device TX Logical LANE 1 DeEmphasis
> > + */
> > +#define TX_EQ_DEVICE_PRESHOOT_ENCODE(val, lane) \
> > +       (((val) & TX_EQ_SETTING_MASK) << ((lane) *
> > TX_HS_PRESHOOT_SHIFT))
> > +#define TX_EQ_DEVICE_DEEMPHASIS_ENCODE(val, lane) \
> > +       (((val) & TX_EQ_SETTING_MASK) << ((lane) *
> > TX_HS_DEEMPHASIS_SHIFT + 16))
> > +/*
> > + * Encode qTxEQGnSettings based on bit assignment:
> > + * bit[35:32]: Host TX Logical LANE 0 PreShoot
> > + * bit[39:36]: Host TX Logical LANE 1 PreShoot
> > + * bit[51:48]: Host TX Logical LANE 0 DeEmphasis
> > + * bit[55:52]: Host TX Logical LANE 1 DeEmphasis
> > + */
> > +#define TX_EQ_HOST_PRESHOOT_ENCODE(val, lane) \
> > +       (((val) & TX_EQ_SETTING_MASK) << ((lane) *
> > TX_HS_PRESHOOT_SHIFT + 32))
> > +#define TX_EQ_HOST_DEEMPHASIS_ENCODE(val, lane) \
> > +       (((val) & TX_EQ_SETTING_MASK) << ((lane) *
> > TX_HS_DEEMPHASIS_SHIFT + 48))
> > +
> > +/*
> > + * Encode dTxEQGnSettingsExt based on bit assignment:
> > + * bit[0]: PreCodeEn for Device TX Logical LANE 0
> > + * bit[1]: PreCodeEn for Device TX Logical LANE 1
> > + */
> > +#define TX_EQ_DEVICE_PRECODE_EN_ENCODE(val, lane)      ((val) <<
> > (lane))
> > +/*
> > + * Encode dTxEQGnSettingsExt based on bit assignment:
> > + * bit[4]: PreCodeEn for Device RX Logical LANE 0
> > + * bit[5]: PreCodeEn for Device RX Logical LANE 1
> > + */
> > +#define TX_EQ_HOST_PRECODE_EN_ENCODE(val, lane)               
> > ((val) << ((lane) + 4))
> > +
> > 
>
> Hi Can,
>
> Could you remove redundant parentheses, such as
> (val), (lane), (eq_ext), and (eq)?
>
>
> > +static unsigned int txeq_setting_sel;
> > +module_param_cb(txeq_setting_sel, &txeq_setting_sel_ops,
> > &txeq_setting_sel, 0644);
> > +MODULE_PARM_DESC(txeq_setting_sel, "The qTxEQGnSettings and
> > dTxEQGnSettingsExt Attributes selector used to retrieve and store TX
> > Equalization settings");
>
> Why is this selection necessary? Shouldn't we follow
> the JEDEC specification? As Bart said, introducing new
> kernel module parameters is easy, but removing them is hard.
Hi Peter,

I proposed the two Attributes to JEDEC spec with two Selectors supported 
initially
to provide flexibility for use cases where we want to keep two different 
settings for
the same HS-Gear, for example:

1. 0 for Room temperature, 1 for high temperature.
2. 0 for Rate-A, 1 for Rate-B.
3. 0 for Linux, 1 for SBL.

The usage of the two Selectors is not limited to above examples. Yet it 
is hard to get
aligned on how to use the two Selectors across different companies. 
Hence I am adding
a module parameter.

Thanks,
Can Guo.
>
> Thanks
> Peter
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


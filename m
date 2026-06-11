Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E4072621
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 14:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781187313; cv=none; b=RzIMiGOoBZHklOy1Wz+lI1rhEjA1rxAE7g4VxPhRsJeua3UucI+eJ7eSFNe3qt/phYSrxFdPLA2RFACAsGeH+qQjIzYuxWl0ofsPD0661lDZPrdCXqREOzaEefIZPq+wUeEU1/4R1inBbC7Z0XNLS0mC4Sn/+0V3E1xDFfabrhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781187313; c=relaxed/simple;
	bh=v8/2NAdTh3grkGL1fYKcTRoCCCKZ021jFd0nHDLmyH8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RZxgHgaPuPusPDIF6W3hC7Dw5+V3pKxsE+W96fi0PCyWgiX73uOVAIxyqSw1p+0lZfsIwghj3ipygLK/hiCgNgyY1to+tcCh340Uwq65Xu3z+hx5RekEDyysMSwxTotmd+FZJAgSZVnbWj7knBiuU2ygeLPUYq4adXOnDcKRy3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cMpQxwQD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gzd7dwuc; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cMpQxwQD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gzd7dwuc"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65BCT1fx650326
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 14:15:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	u39HCuL04RPljzA7VhkpK4vvo4WxMV7hzM5njFq5G/M=; b=cMpQxwQD3f/DWVzU
	+2CGynB6NttbqMrCZjmlZnrgq3Znr50wNSLACx4RHSres+tRevHX1igJuMDUBZ5p
	rihJ2NpZm888jY3+k/OPSGyO2j0dJ7hf437UAOL9RTB1+2h+Kd0M57113P+eYrZL
	tjS62ObanoabRPfPPeH4v7HSxMtcf1rdxewCBxoLdgr+k1w+REz4BdEkjc5W/sQW
	nTD43zVJVf2n3Juffwb7jMhFtghVKajzIRcMR10mHrF8IRVGlAcYKEXDcYvXAUYs
	fKBQ4iNeWdByCZv9ZnNxUlZiAvosAXEE16O+6UHcSW41rl2D0JFwa4BkhiO7tUUh
	JiKKRA==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eqe6skumf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 14:15:11 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-842cb4c62f9so927274b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 07:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781187310; x=1781792110; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u39HCuL04RPljzA7VhkpK4vvo4WxMV7hzM5njFq5G/M=;
        b=gzd7dwucKWVa99nkZec+qpSkkkpxwdRoZRhESy6fsmVrJ1xxXhgMs+g4KaHfXelR//
         8wm3CEKdpxPDj7dZWjduaGbxmMu/QDYk4yqPjvl008A5bBfJ11KFV912IIjlYLf6T/t9
         VVXsRRWOmGpQgTquwEjPkKyYHQ1qarTw40kgMTteBJ0ywOUNaUQuxLFJC4EOioYF6gjO
         yGhE1DpFUVCr3Mszadgu2jTvkcwRz2yUYciU+AscdnC1VcztfSkaqL+KrCr9FRRlE6Re
         86TGWBF1/I6Pjm++Vbbbr/m+CbyugBb3Z+Lr060LaDsxXd9hL9Ma7UnIRH97me5KKOST
         x1ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781187310; x=1781792110;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u39HCuL04RPljzA7VhkpK4vvo4WxMV7hzM5njFq5G/M=;
        b=Nr/fDFs58OJw5bAfCrYquRtidLbbVh+eyxend7V9mS4ySVdHWWKqQMk11yztjlz07A
         petJZxbvoxXbEEtvmhW7/GLB3l0ZQVwlSdR0jdfpuse+k/PZETvB62D0H6g/IAK/sbbg
         7BmdhSuy+H1TuX4CLnpfg46Qh42z8cLbNyfEMapi5jU1w33PJ4lNr18L29Ec7DrD41ii
         kvq/UdEfkEQDKyKDgc05jmiTw4HcRo6hwRypNWq1mtdux2R57uNV8ADYS3oc1AQAcaMq
         mbmnKjL3006Gh7xSu/xPJ8yTUumxSBujnnEGr8pgl/6HYXUkzygrdJrKSlqaNSQ5XLBf
         RT7w==
X-Gm-Message-State: AOJu0YwYJf3o4EycCglNZzBHVrSPoEa6je7ylGPAYjK4vIWGBUH2BB/1
	/z1KSJFBHDxbcaOPeP0pBRP4xfBtiPOqo3l+7Uw5u4wH466MSW/2w50tGTCq7AUctDvWa2aaHf3
	lhiRLJiijH+wcWy6SwZx4gV6pOtdHA1wLsnOYK73sRbKkW1qff91687SNU/ptzqEK
X-Gm-Gg: Acq92OHAex3N5td/Mt/wFKEcaW315Z+PoIvfyIJV3fpJVpFBfb8a9pOh+/fL1hMzmWJ
	VZWz0ltRuM9n6E7dcPVjGL8r6/obkztjEmDfiKGAm9m/n2mErZac7b4V1k5tb7GVdKQ8vCp9Ph+
	3tMx+MDGkVKsHinY5PPP14VAtNI0QRkOffaWQbbMX63kboyeFFsPNXoTHsbJqdEnf0tUa/tLDIe
	y9FoFRMtxNzhN63orDIUtxPLn5ZWyY+k/iiSNPiV73//kUypp1c5AFBeVkpLDzRNjLyIka/eWmp
	qhPMzO+jdirzM+ajfThRN81oQumFyT9FwtvdhQRyBWMKQcAAuM17SqamCRnVDADPNjfc1dG1dB+
	I2Rkz9CenfR+bdDO+QXtsQhmoQFfu/t6koUIewyerml7XP2z/rtqK1SMQFEm8JEfCfN3CK38rCf
	ZYdqCHsd9434IJ3wEuXi5BnQ==
X-Received: by 2002:a05:6a00:300b:b0:842:3d8d:babb with SMTP id d2e1a72fcca58-84335ca5886mr2719586b3a.2.1781187310177;
        Thu, 11 Jun 2026 07:15:10 -0700 (PDT)
X-Received: by 2002:a05:6a00:300b:b0:842:3d8d:babb with SMTP id d2e1a72fcca58-84335ca5886mr2719532b3a.2.1781187309567;
        Thu, 11 Jun 2026 07:15:09 -0700 (PDT)
Received: from [10.133.33.231] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-843380c96a5sm2351132b3a.38.2026.06.11.07.15.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 07:15:09 -0700 (PDT)
Message-ID: <8f4aa04a-08fc-41a8-94be-2443dc845fd7@oss.qualcomm.com>
Date: Thu, 11 Jun 2026 22:15:05 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "mani@kernel.org"
 <mani@kernel.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "krzk@kernel.org" <krzk@kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "quic_rdwivedi@quicinc.com" <quic_rdwivedi@quicinc.com>,
        "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>
References: <20260610071516.3763916-1-can.guo@oss.qualcomm.com>
 <20260610071516.3763916-3-can.guo@oss.qualcomm.com>
 <5a1e01dda55af091204c430ff383c97c8dd69ed6.camel@mediatek.com>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <5a1e01dda55af091204c430ff383c97c8dd69ed6.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: CvgeNasB6sTn4LeQpH1NstfhQgm5ogeM
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjExMDE0MyBTYWx0ZWRfX8J2/zOAWLuGc
 Rq+PEpnGXop0Ppi3b5LF3Y7kzI15hsfSNxguz1dMZrkl4rFaAAZYsFGVwftEIV5Os3E12dHmzZa
 62n76SldTWZdU03x9SPgzoEW0FnEe6c=
X-Proofpoint-ORIG-GUID: CvgeNasB6sTn4LeQpH1NstfhQgm5ogeM
X-Authority-Analysis: v=2.4 cv=Kux9H2WN c=1 sm=1 tr=0 ts=6a2ac2ef cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=XlE0QtBvFGsAfR79B8cA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDE0MyBTYWx0ZWRfX7A3z8+e9xKvQ
 PDXnzmD8ru3HugjErEHfZJdFx+7b4sjBBnR6Ccf0+CG5VdvgqErAaTbcS9Y8U5B7pz4rJhg/0Rv
 Y8NQo0gEvZIklid2QfMussF6N32o7Rqsz4pfvwwT6amL4vamD/cuaQfqt+2mdnKSTOEpaCYRgA3
 dLhv+KPnNyP4dJWeD8g476fKBqjIo/aU0jOw8dopSjQaS35HDR0fv/IM29tnZqIjY71FmKR0Esy
 k0DKrLNz6Uy95bAQ4rFoTN1H3G0OT1EsC/NRwxB4yWHPaIIcYhx3K8x2z5jSmmMH5uKuYQz+kMC
 /SZvPhALvZtDdxVGfa3d+zCc9bgFx+Y+BJUfEbNNtiNFDbwo+LzsZiT7tbEyHmymBU2axCM350K
 NkcPdzGdAUV//DTHLswFwm/2V2sTolHz7vtF0Sw2rv0XCfylrjb1P+M3atT/JuN/eOc7gX1qnVb
 +G0sDAJPacVsU2OPMJg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-11_02,2026-06-11_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606110143



On 6/11/2026 6:11 PM, Peter Wang (王信友) wrote:
>
> On Wed, 2026-06-10 at 00:15 -0700, Can Guo wrote:
> > +static int ufshcd_parse_tx_eq_value_array(struct ufs_hba *hba,
> > +                                         const char *prop_name,
> > +                                         const u32 max_value,
> > +                                         u32 values[UFS_MAX_LANES *
> > 2])
> > +{
> > +       u32 num_elems = 2 * hba->lanes_per_direction;
> > +       struct device *dev = hba->dev;
> > +       int count, err, i;
> > +
> > +       count = of_property_count_u32_elems(dev->of_node, prop_name);
> > +       if (count <= 0)
> > +               return count ? count : -ENOENT;
> > 
>
> Hi Can,
>
> Returning -ENOENT when count == 0 is not correct.
> count == 0 means "empty property," whereas -ENOENT means "property
> not present."
> I suggest only checking for < 0 as follows:
> if (count < 0)
>      return count;
>
> and letting the count == 0 case be handled below:
> if (count != num_elems) {
>      ...
>      return -EINVAL;
> }
Thanks for your review and suggestions, I will update accordingly in 
next version.

Best Regards,
Can Guo.
>
> Thanks.
> Peter
>
>
> > +
> > +       if (count != num_elems) {
> > +               dev_err(dev, "Property %s has invalid count (%d),
> > expecting %u\n",
> > +                       prop_name, count, num_elems);
> > +               return -EINVAL;
> > +       }
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


Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B409E327BF8
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 12:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770725302; cv=none; b=OKBkolA4rh21h9WEHQdyDeHIxX5n1fObxu3alUKbllLVzRMoyz5mjefYnxWa1guuega7dBDCKzPVPqxlmaiB0dhlQHO12U5xIGXpwvMmma8fhhNZTNSH7rAJCqPvNxqout8Bcm5MyraFCX9b7x0/J0NDiWsxWdcKtiCZtZgnAQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770725302; c=relaxed/simple;
	bh=5UT2E8ZZlh13a8f6t1/M9YfC2QQX1bYYDvLcmDN5PoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JRvup7IKuh2+YePGbav3Kk7FTVIp0dOJT3mq+KkNTi+9ddPya93C0HixGwoVNYdANjjDIesRqNwkNNYECaayS4yMooLgIlDnIk4Q1/MXRJgdW6c8ut1I484/kneJO6a+8bdqhDvn8ViwM5IK96MDCwAlI2kXmMcxbFISvzLH+vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=U5hEFujF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FJTqnn90; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="U5hEFujF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FJTqnn90"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A9dxDC4102820
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 12:08:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=fWHE9U4c8zXdsFbS55+J+Lip
	A5jF7lK6n2fI5kcxHAE=; b=U5hEFujFHao714hvYHxeDvR3IYZfLHShlYlri1/5
	gbcu3cDen0ujho9WLqBRuzizwkAagw3xB8+0p61+8jWJ8oCbglfdRg0VrwnDVmDJ
	H6FfB3ZI1pQDs8bMo4E/xiDpS3s2dTdNQ15nU4RUm5ed8lya4ciR1vRk8W6TOXth
	vyyVTsDb+d/IeppPSo9i0vkzm181XuqiMKJcMqJMw6UU2hyC0yGuMrjMqfyhydb4
	RSzlVcV7LNt6xSlsi6KxY6AeG4G3haXuP/mYr2Re+GkWIxwUSFlXJynpLQkq/Dis
	PIHAmCprEdhuFwBV86BRqkPVsNMMDdE1Bjzfz58VLKY3gw==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c7k61kffx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 12:08:20 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8cb0595def4so1200573885a.0
        for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 04:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770725300; x=1771330100; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fWHE9U4c8zXdsFbS55+J+LipA5jF7lK6n2fI5kcxHAE=;
        b=FJTqnn90CP/UdqBkcHjzhFX1AJRW1WzHeB7ayBr6hmhkMbDk8flcrjA3u3Q6nWpilU
         dchYGfJQZ1/Zs4J/lmkxE1dRQR2u8qODR1sKLM3MKAhutEiTIQPkGznBekyyrwswAFut
         u5Aiu00XFoOeO8SYDB87f1l69MZoBwaT8YuLjjdQVGaxdgMpqj58Ef0sbk+jRow9MUpq
         VxfxewgGymiyvWcSM1YxZ9/gTDMmni0cmURGfCs0WXEM1hNrFJUp6tT0GroS7/FY5nn6
         udhd353OJQ2HPf7+r9M0k6eg59CeRzM21YgT1C/DDaYFTgdcVSxukZRelb387DD/1842
         4Tmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770725300; x=1771330100;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fWHE9U4c8zXdsFbS55+J+LipA5jF7lK6n2fI5kcxHAE=;
        b=WtgseI4uwproWlMexiU3Sh7E/XBLt82JrfPQcX15poZt5S63cH8c7kaK3ZMc22dNiu
         aklvbVwsULdnB6az2hf+vov3l5lS5Z4pONcaSkTSrwMwc13aiAJGn1f6fjbXllGZqwfj
         Y4klVevO6czM2G/ctevnIPNqOdwhJ2S2Ti07/5UAU0zMFLCM6iT4Hi62EhyGLjErLa6M
         s57SXw/7tBQ5EyrN8rxF/vpfmDcusjAARyVq1IJprhmKiuD636qelWbPjnimLkigXZwx
         8Pcq2pwXV1EBlUBOTU9KCWa66frVGQ97V8A0tNJ+PXLZ+UoaBoomaD5DmJOh5Xp0GPOw
         LxMg==
X-Forwarded-Encrypted: i=1; AJvYcCWc/Xn1e8NDy6PuINRq3sv2sifJAi1MV3X+E48vNcLIKGqErNCUd5tgF1Qe55DQjzLg/WkxcGPrjasc@vger.kernel.org
X-Gm-Message-State: AOJu0YxMHKy/V2kAxFLGR0frNvOfFCi1Vuk1pB9GEBjw6Sk0uDyvjqh8
	j4vLUYPhRbzIoOVnofHTEuKWnEWZlqu+4o8RqwJE6SYiAr++gIvePxcsYt4IREY655NGVBhlbX2
	kewkfT8oWdz+iIvBUQ5SjFhqlYUfc4/PPxJCMhqdfPCRKAuw5Y2th06uZEp8dYVs8
X-Gm-Gg: AZuq6aJ0eehDB+isW4VemzpqCGXpGqqHVYVwpaoCJxlYZEowpubu1WHOvbILmERmewF
	gAteFfO2sXx/XY4Oxm+XogO3N5K4s2yoqmrYl31NSbRVs1E9i3RZ2Q/MC+7cY7plkoiBu4wIZVC
	Cfywf7KB81zPBgEs1rdNnKMWE6It3CdoNAwwTXsr0zl8FPZtRS+doG6e7t1gYf2+RaTUcsk2Tol
	pJuAqH+iwXTbEwewMQjaGwe/+euRYJOIdGglCqitCcEK8eWBhzyjOSXL6OKEl2nByaQ2pO4xhO2
	vdu/D3g0/fJSO97iF5Xf7NJonly06AcNovIIgCma/Q7dZYR0zWG4UR0WptlNm94VU12nsYmSHMQ
	0EmzgsrtdWtYicSgk7jepyaZRYPuBgd/IXXUd
X-Received: by 2002:a05:620a:1786:b0:8ca:3715:eea5 with SMTP id af79cd13be357-8cb1ed7477cmr236203085a.14.1770725299664;
        Tue, 10 Feb 2026 04:08:19 -0800 (PST)
X-Received: by 2002:a05:620a:1786:b0:8ca:3715:eea5 with SMTP id af79cd13be357-8cb1ed7477cmr236199285a.14.1770725299050;
        Tue, 10 Feb 2026 04:08:19 -0800 (PST)
Received: from oss.qualcomm.com ([86.121.162.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4376ab6e4c0sm18572329f8f.0.2026.02.10.04.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 04:08:18 -0800 (PST)
Date: Tue, 10 Feb 2026 14:08:16 +0200
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: manivannan.sadhasivam@oss.qualcomm.com,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Sumit Garg <sumit.garg@oss.qualcomm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] soc: qcom: ice: Remove platform_driver support
 and expose as a pure library
Message-ID: <etbknbm4fwcsejnu4cqcfvmdwmzlobgki5ynrbp2m5w4yiyw2n@ztz6wbr2shbb>
References: <20260210-qcom-ice-fix-v2-0-9c1ab5d6502c@oss.qualcomm.com>
 <20260210-qcom-ice-fix-v2-1-9c1ab5d6502c@oss.qualcomm.com>
 <7d61d324-0d26-47ce-aac6-d17abdcf05cd@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d61d324-0d26-47ce-aac6-d17abdcf05cd@oss.qualcomm.com>
X-Authority-Analysis: v=2.4 cv=M8lA6iws c=1 sm=1 tr=0 ts=698b1fb4 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=oauzzCmhM186DRC0Y2yWPg==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=EUspDBNiAAAA:8 a=sslwbFw0vO9QQOdamQ4A:9 a=CjuIK1q_8ugA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEwMiBTYWx0ZWRfX0y+CYgKwIrhu
 x7HQUQAkzI3Q9l7t+K+mc3DtUW2Jva3lidqM6Gnacyz3rC66MGrEH38OplPwXuDctyz6+QZmZe5
 oPSfY6E+pSFVwlylK8HLHrw03Y6ydF5Ik9y4vEfgbdOHBFcdeGevEl0hTEJzx2AY2PaITBS/NAw
 FMvE0I5KzIOe6OdzA4BYK/bPZ8U7JaTBVjZULMhydnad18lZAd6J6sdU0rpppwmGLqEAR8+FRFM
 BAiKJAjU7vlinOiyR9QFXnTNJR56WCwNvYbCv/jKJARTkrbSbiLLpOZsBj0BEBfJ1PA9QiTE1CD
 scgHnU8UHkXcOezoWKDmR+C+L+JnrctcfsNuCtkryGthKrbBHk0FTxiI83KtPt1zbCSJQJe1c4Q
 cmBIhiNEHEJJKa3iGUmonWID35zcA2NrxyeguvW9Ofu+lpS1/XL2MPGW01/uWCvTcwYqnTS+uAV
 Bdq/gc9JR3Ek8OwT/eg==
X-Proofpoint-GUID: PE0gs0IxAuEx2aTI1SyZFPOef2L7KVe7
X-Proofpoint-ORIG-GUID: PE0gs0IxAuEx2aTI1SyZFPOef2L7KVe7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602100102

On 26-02-10 10:39:54, Konrad Dybcio wrote:
> On 2/10/26 7:56 AM, Manivannan Sadhasivam via B4 Relay wrote:
> > From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> > 
> > The current platform driver design causes probe ordering races with
> > consumers (UFS, eMMC) due to ICE's dependency on SCM firmware calls. If ICE
> > probe fails (missing ICE SCM or DT registers), devm_of_qcom_ice_get() loops
> > with -EPROBE_DEFER, leaving consumers non-functional even when ICE should
> > be gracefully disabled. devm_of_qcom_ice_get() cannot know if the ICE
> > driver probe has failed due to above reasons or it is waiting for the SCM
> > driver.
> 
> [...]
> 
> > -static void qcom_ice_put(const struct qcom_ice *ice)
> > +static void qcom_ice_put(struct kref *kref)
> >  {
> > -	struct platform_device *pdev = to_platform_device(ice->dev);
> > -
> > -	if (!platform_get_resource_byname(pdev, IORESOURCE_MEM, "ice"))
> > -		platform_device_put(pdev);
> > +	platform_device_put(to_platform_device(ice_handle->dev));
> > +	ice_handle = NULL;
> >  }
> >  
> >  static void devm_of_qcom_ice_put(struct device *dev, void *res)
> >  {
> > -	qcom_ice_put(*(struct qcom_ice **)res);
> > +	const struct qcom_ice *ice = *(struct qcom_ice **)res;
> > +	struct platform_device *pdev = to_platform_device(ice->dev);
> > +
> > +	if (!platform_get_resource_byname(pdev, IORESOURCE_MEM, "ice"))
> > +		kref_put(&ice_handle->refcount, qcom_ice_put);
> 
> IIUC this makes the refcount go down only in the legacy DT case - why?

Good point. I think it needs to go down unconditionally here.

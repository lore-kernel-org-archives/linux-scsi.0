Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382DD343D8A
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 02:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784687143; cv=none; b=dFyVH7BfRvQsqAZ1RzXXlsvsFovQ2p6PbxhsXdJljz4lq9WPjl266Zc9CgFPKtpcJq7HE94FK7PYlUasCS04bvJJU+iwSTr9Lk2cNPwH0sMRQtMPjyltdxFAVFYyZRxEAOOy52kbPz2i5cKfV/4i+AKiLaS9xdYJWfoAU0bjurg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784687143; c=relaxed/simple;
	bh=XMt+oHSBIYHeDgb+G+E4FlZi3kL/8T0nN7ry8+HsjjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fafb5DT83S5jojiVSgR4ITDDddCCbBWXPjjRWEHAlMFndnnFV//SgI1UBc0Shx4xunJuBfSenr1ebuoQvogXmhC1dxozp2vnK7OJEpP8uu6ikEklOZCUZrDYh6SRJPUHDrD+PfFxmtcpebMC3QeyHVUmVvGmYq8J5tVGfFWZKAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WEnXx0Qs; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cjmwpKR6; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WEnXx0Qs";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cjmwpKR6"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66M1CIeo3536260
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 02:25:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MgZfS+DnAyFYoUCXxLOPV0UVnqmhd00WX8pZs+xw1v0=; b=WEnXx0Qsxn/8D6eF
	lZMkT8V49TvVjdjonY65I0OPcKhcG5OwWhru0ZP8iCX/WrgTVglkkcX2yJv7AxKg
	PER1B3y1auWnfca50lFSsPqc269V14FvdZC9VA0jjJQO3JDod7+1uku///DFte0I
	0vrCxR9q0yVXEY2Aq9o1uzvVe1RpV5WWseaMFVg7g1m9J8c4Va8GcnTC5dBVVOWS
	NNiVjLxfhijjHqOaRpc+8/XoLc6Q5GYBsXdjgsqF2PwQArm6sWDD0QGbu1+kw+K4
	KgmWTBKPItTn4Z4j1JUQbFjj0/6J7mPRqn53qJUyylujsu86y8y8UB2MAbfXszpL
	25kU+g==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fj6863yuh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 02:25:40 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c892143db7fso7612320a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2026 19:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784687140; x=1785291940; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MgZfS+DnAyFYoUCXxLOPV0UVnqmhd00WX8pZs+xw1v0=;
        b=cjmwpKR6iMqPF87kqpaJV8usHVvplglN/HYeGbCJ+gBCbb7un14CcW0KsXw34GpYes
         ThoJ+Xwk34e8vUmveSBGxyfTRhv9X3ApfYkIFZPpUqb0prJcVrPud4k/6bvxEZTwQ25M
         PU5pdy8bZ5x27u+lxtrrSyGZY1g3gMqSPqmbJsKRy0AnR+0+uBCTlvgIADMA99czuzs5
         bwPCS5OOLDhsFWIOR3tKmuXlc11Jvf7PdmCDoX9zSWBsT5c8eExtGXtf6Bplk75F+1Ox
         gSg1lutth2PfSJlfPBCsxR9DtXhxN7sAOa5z0EhSdw8WAf3XkSaG5sJYAxuCys457jGC
         Uh5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784687140; x=1785291940;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=MgZfS+DnAyFYoUCXxLOPV0UVnqmhd00WX8pZs+xw1v0=;
        b=jX98/3nFnkkS6UtMnSuNsYPGcqPagqnVwJRSxV9ESS5hLEqIEYBmI4HfEGBS5KT+CU
         cv5W46rrKxnVSXBuZ5UZa1Cww4wfnX3VjthTkMmh5hlWaFEgwDz33xy/UPqjWimER3nr
         bP50XgOiejzgrXJRhxOYI54vB/zy+8iibGXlLYbPMZPmoa3Q066t+0SlsAEQW3CupC0a
         jU3woD+ZRjXgd64FE5v9wujqnvSreud/Tr5CQaAuVCfxhKcu28j18cZMJxQumG8jbD/V
         mZIN0kpEmB7990v7zhRX2gPSbMPLOBSkpUXloTbmLxyvk461HsF7TTu+dvfpEAaP0wOe
         DZXQ==
X-Forwarded-Encrypted: i=1; AHgh+RoTCTj+oJXOFpHtNwzF+Y110lVJGyuAllPVahW6cwU0+lP4dItMPuGrkMCa7/EMt+z8LoBfcAmljt5a@vger.kernel.org
X-Gm-Message-State: AOJu0Yzyaa4muQDJ2XF6437e74c63WK9ra61FCEj2okoPwpbrrU9Pcqs
	n4dKzZDIXl5IjEZHd1+bi3lna/jjhrKsTIy0WXTtED8OudG5D43iVDv+haNovhiK+DHqHhqfpqL
	RzxyaIjMVVDRab9ZV2Mb9TgLNbnIIki0CW6Y9k4GA83c8UOlYXayuwNn7YX/HgttK
X-Gm-Gg: AR+sD11zQ+hJ9QLT+pctB9z/mnDkJeg3YeFlKzmzvI+FPy4CoGG+4ML89x4pLPkZDxw
	XXo2+tRv1TUtrxZWi8wekILpG+cY11a82/qz+/22k11BwWfJ8fa8ynoVmp51HbE30t+8fO92AYb
	cwlzOHmDMjb1AfQJnc4Bnn5t5laEa83lnhPWoRJAeEbREwVp75JMFNWysCe8ftdR20pgTO+JuKa
	jHDMWMr+C4QIAGDYIrxiEmS4vTlO1v5efwq5eXuSjtptCqiu1IcG742H0MF5b7V3XFnVr19rlCw
	wtDjBlATRpKKplPysNIitDTaOGhLq18WRO7um7LpsWgXlSqWYzKws9G2M+94L3cym9ZrdIxWvYe
	dseegcBbdC7zQxgztCart9r+p8k9LnjGfs0/Yv4dPt0c=
X-Received: by 2002:a05:6a20:5484:b0:3c4:3672:ba2 with SMTP id adf61e73a8af0-3c4367217e8mr64324637.71.1784687139944;
        Tue, 21 Jul 2026 19:25:39 -0700 (PDT)
X-Received: by 2002:a05:6a20:5484:b0:3c4:3672:ba2 with SMTP id adf61e73a8af0-3c4367217e8mr64307637.71.1784687139520;
        Tue, 21 Jul 2026 19:25:39 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e081978sm3133250eec.24.2026.07.21.19.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 19:25:39 -0700 (PDT)
Date: Wed, 22 Jul 2026 10:25:32 +0800
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: Peter Wang =?utf-8?B?KOeOi+S/oeWPiyk=?= <peter.wang@mediatek.com>,
        Manivannan Sadhasivam <mani@kernel.org>
Cc: CC Chou =?utf-8?B?KOWRqOW/l+adsCk=?= <cc.chou@mediatek.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Eddie Huang =?utf-8?B?KOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
        "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
        Chaotian Jing =?utf-8?B?KOS6leacneWkqSk=?= <Chaotian.Jing@mediatek.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        Naomi Chu =?utf-8?B?KOacseipoOeUsCk=?= <Naomi.Chu@mediatek.com>,
        Alice Chao =?utf-8?B?KOi2meePruWdhyk=?= <Alice.Chao@mediatek.com>,
        Ed Tsai =?utf-8?B?KOiUoeWul+i7kik=?= <Ed.Tsai@mediatek.com>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Tun-yu Yu =?utf-8?B?KOa4uOaVpuiBvyk=?= <Tun-yu.Yu@mediatek.com>,
        Chun-Hung Wu =?utf-8?B?KOW3q+mnv+Wujyk=?= <Chun-hung.Wu@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: Remove unnecessary block I/O quiesce for
 clock scaling
Message-ID: <amAqHFOgPQQY-3rI@QCOM-aGQu4IUr3Y>
References: <20260604133503.2049288-1-peter.wang@mediatek.com>
 <al8YkXydXJQZrl_Y@QCOM-aGQu4IUr3Y>
 <29b5f4368a63847b84b87e36a1e358f5991b694c.camel@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <29b5f4368a63847b84b87e36a1e358f5991b694c.camel@mediatek.com>
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDAyMCBTYWx0ZWRfX8GjiuD86C5cL
 SXfNAhIivHh/2xbr4jCKPKKI1SB/qzt9qxGIM6WCFOtvM0dipJxyEN4tqrMFsaGeBlgIdljajEe
 lAz2lCQHz/bPNccXXBRao6N6GWMXBsk=
X-Proofpoint-ORIG-GUID: lBK-PzgjPwwiF1SCt1tDNEduIFZ7UGTc
X-Proofpoint-GUID: lBK-PzgjPwwiF1SCt1tDNEduIFZ7UGTc
X-Authority-Analysis: v=2.4 cv=X75i7mTe c=1 sm=1 tr=0 ts=6a602a24 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=inPtic0riIV1Bx39OKkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDAyMCBTYWx0ZWRfX9wrkTlvlwJg7
 C7BGziN8Q3MZvD0pyreFQJz6qdwkEIXn2JnR3KzyqRMRSo0epzjjkCXaWtax90XNbU+CfknvAYG
 YCEgzBkIlMOgO6sAIVkp8vvSoqyBurZHRnuR4Zb++fnfwLg6TQJxT7xl4AZeP0YfQTMYXDzcLQE
 eV59clk0nyIrT4nMNzJU3Dg+p9V1MOU3ElaxGeMtvAEvOpckJuSNuu2hdkiRNRrDdOsaliQaGGs
 U4K2qfKmO9eklPXgzhjLoX7C/rTf1do8CSo4oPt2Zs4MJ4K5nbvJTCGeDpHx+MYnysAK5t2RRWt
 B+yrGTYDFW8O4rU6vCOlEdq6Nx0lVApIAKoNIgGWmDsEBQoWoamDpcFX4xWqtOwTviIwbfQjRbI
 5ruUMNxLzPxpdKOmKpXhp8LRlNvqheQw+s1lghlAsckLRq50GMkZtdXOMN4CqlyOHrXbxNsHbT1
 K+3IVvJI4rK+NGX/9Zw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_01,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220020

On Tue, Jul 21, 2026 at 12:54:01PM +0000, Peter Wang (王信友) wrote:
> On Tue, 2026-07-21 at 14:58 +0800, Shawn Guo wrote:
> > A revert of commit 85b2b9662854 ("scsi: ufs: core: Remove unnecessary
> > block I/O quiesce for clock scaling") fixes the regression for me.
> > 
> > Shawn
> 
> Hi Shawn,

Hi Peter,

> What is the probability of this issue occurring?

It seems 100% per my testing.

> Is this a design limitation of the Qualcomm platform or?

I cannot tell. I copied Manivannan who is our UFS expert, for possible
input.

Shawn

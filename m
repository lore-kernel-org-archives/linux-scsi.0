Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C5C2E091E
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 09:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769506689; cv=none; b=Ac6lii2jDLMECaK0Z+udyem9b2hkpVtoiSsuupXLVnKHiTrwDcz5U9RIf/C99gwbmmrl/W6fOBupNfUV8q8gMcjmRUI3i6n3O9X3EHRzavWghsXD95wMsLtqea/8HOGGLIwVHiiHXuHJl2DgBiQJSxbR2KYwKDZitH5rcDbup/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769506689; c=relaxed/simple;
	bh=GYGOUtyADGsv0KpQrM6S7wBKne9COcR7J6drzhKdUjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eufO2LdeC03KCMWAZ1rVDUnH3+cBLu1+nK2c7tQkoC4DVUwzLERe0dJ2K+bz3GoqpLIWs1OG4jmZtgapYj6KwN+qmiY0nTwRxF3TEHbKYJ0/H3n/btIFal4oBi+aCzrCRJlQPhzfWuaAU43Rwy1KNb5jHtOqe/D4A5pswNQ8wUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PZuKPyBn; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=X+omophY; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PZuKPyBn";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="X+omophY"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60R876eh2378873
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 09:38:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=0gH301sgId3YAlETF7y119rA
	piUMWVRjkOXADa65XqQ=; b=PZuKPyBnyRjZy5gnVK5dQcDWOOyIDLPzFnC24pWk
	UYtbcL7TuoQCO9MalIQp8V5KAEBjC1GfzDy6AkUWclIzPon+P+/wnBSzYzZAzwgQ
	aPf41RM+G3eGjz9OayGBs6U9Zo/rRrqXWAVuQVtS3u1HW37mCsUm98JUu4wV+X75
	Ag20VYOQ6MfP3sse+m/GYtxy7V7n68olgHK0yFqwzr7oJoFP1g1pTpzkaNu36HuJ
	n9OjkI0RNAb4sgXtE6Pj5Xrf0yi7XTZI3AitVxMShqkm0j5oAmCspa3LJ1NEF3lm
	yW/AEyD4tF0YitbY/kggek/pG7tiavyB11+/2+TyNDdotQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bxsjr8a8g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 09:38:07 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a863be8508so24698925ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 01:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769506687; x=1770111487; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0gH301sgId3YAlETF7y119rApiUMWVRjkOXADa65XqQ=;
        b=X+omophYABxl0iPpU6Rb7gOfKMrqUNdIKIY+RSaxQ71kv1muoXsRcoIMfUIwPCCnQP
         E1PS99kj4lpJ1LRInF2hkzVaqaqAtfogfI3ojhFs0nHLPZVU+Pf5v4NE47hVFv0vxTLP
         gVN4eB57YceKNNllyT8scGhZpaoGrUCcjjKXDVrpEsf27WpWP7MVA6h/dEX0ZYsV3N2F
         ZBCbCtAQxKmtt3o2Zwga3GFsCEfOXjzto0atiFaAK0TohaBtkcMd/BaWeE4dnOCVK3l4
         WvvFCn2+bGIAvJ0VI6FmxDgHeUcvKnZbZzIHTNFM4RikMn3MwekKF4XaHH9Md3Bv5K2Y
         J+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769506687; x=1770111487;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0gH301sgId3YAlETF7y119rApiUMWVRjkOXADa65XqQ=;
        b=tiNYN1tYzfxiGOH/jNnG1Ly/CNGKwxNU4hav2qqL7KNd6EgtYmETMfjsd2VgH1GVF3
         Y0T/E+lwPIUMu8HF+v6tlqdxE7tGDg1Kdf7aVQxBjJBoKUfLwbpwGR/mSbiZiOaLJSOc
         WNshcx3qOxiUhPapRwflAuKN03De+++FYS9wUM+J4d5DekgFMWSWuXN96H5Qe6FkXWUI
         TqekRtA5Gpb4OfU5t3vLEo7BaFxc1HdcUWvqOp+EOG5JVAKncCxsSkOjF9wcSHB2LJWq
         alQVH81KW463lwBd1YSFLgk1dPS3mGhPecDRzga294z2yI6JcQFqikYCRlQsr68rrz4E
         Rhfg==
X-Forwarded-Encrypted: i=1; AJvYcCUtnAWSSD8r9DWOexdx/ABc4wshUsQEFRXFwSg4YuqMFY9lLKvmjH13xJbJYyN7vYTGORn5lfDjE1kT@vger.kernel.org
X-Gm-Message-State: AOJu0YwiQzTVhkRJEXl/GtJtXfsJoRN4cqjaFgDmifmxvp+peNWGcjki
	4UqYSKpvSMcyJLZYcp9P4yEiOjhEvtyvqNxKVOcT3jt4jMI2NCESqUymTsAf13sGNfR/edOwSVQ
	poWBB/dWLf37YY0+wKMPGjmp0jv7JlHgtDpIj3kN5jIH5DrFELPevqkPNIYPtju3T
X-Gm-Gg: AZuq6aKuTbLVMnOCv5ClcsEIGdvwiBm5S3xSrezRFavOD3gMOEpVQddhW0GWld1tDss
	5BMITi9baCThJ6tmMiEucUxgnpW6UvrXLSv0lTirXjUA7nOG/sLCkC/h8n8A3H8mtECJ+vLHp0Q
	8aVqVwZLsLZDEMTwRAixOdqNvGkFoD4MDSWkS8oSAiUr5BMW5KkVeiJuu7PptAgoDf5sa4tx4WZ
	YeuwFVebniLNdeTR0e6uPrP4KBkvL/oq/7LzgSgfqMaMSLx3DcB+dfYu5rQ6O8O1uMAd6nLRTOu
	x4lmZQqCbFsF5MNZQagPsKTbBa/9KGQrhln05IUXol0BnZlAv+I1p5AuCKRHQU7JBG5U1YDW3ph
	T9ryqG9c7YTYxltANG4EfUkPKJspfc0YSgfMVrPP7By7F8zg=
X-Received: by 2002:a17:90b:2dc9:b0:341:6164:c27d with SMTP id 98e67ed59e1d1-353fecc66admr1183080a91.3.1769506686621;
        Tue, 27 Jan 2026 01:38:06 -0800 (PST)
X-Received: by 2002:a17:90b:2dc9:b0:341:6164:c27d with SMTP id 98e67ed59e1d1-353fecc66admr1183061a91.3.1769506686092;
        Tue, 27 Jan 2026 01:38:06 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-353f5f96293sm2017007a91.0.2026.01.27.01.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 01:38:05 -0800 (PST)
Date: Tue, 27 Jan 2026 15:08:00 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 1/3] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
Message-ID: <aXiHeMcQiF8X1ANZ@hu-arakshit-hyd.qualcomm.com>
References: <20260123-enable-ufs-ice-clock-scaling-v3-0-d0d8532abd98@oss.qualcomm.com>
 <20260123-enable-ufs-ice-clock-scaling-v3-1-d0d8532abd98@oss.qualcomm.com>
 <gfqpfzulzptkrbcrc2zcnqv6kmtdgwwxqc2rxnbq3rlh7azilj@srzlycd7wv4d>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gfqpfzulzptkrbcrc2zcnqv6kmtdgwwxqc2rxnbq3rlh7azilj@srzlycd7wv4d>
X-Proofpoint-GUID: 5n772kaK65HHm39q-S61pSemdhYJwnQ6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDA3OCBTYWx0ZWRfX6k6kCxbnNcK7
 mdOmFF2sPKUSsA8alauHytGUM21lFiQzqfQ4rMYWUEUHuWwR+BPcUGTkZW0gomKLpzBBI3gJVh3
 a4d4UHxYoufwfR0bxfVWdFp5vO211eKyQC3R6yhvRqKf+2ASeyB0J9hZvw0c6Ulff/Kvx4aAvWN
 NQf4lmaTUNUVjLS+rZd4cgxKAhFU/JP2fDWiqZ+NHVePodY2oCeThXa035HkncRKIFTyNChnZff
 Kk62ktoX4p8cuWHBSGlkbyoTXWrP+U6GhZLZQR0bv91rxwdP9ORsIdb2f/Encm0WWnEa4hHw1Tl
 2QY8vS4uZU6NwlYCv5pb9XCdgTO3Gaq8mUYmTXfh9sje7cUrvd8C8i6x5Xx83NbB8WkTOTcK0ZR
 o5sFUrBsCifMGWctt1Xn2U7ZFY9PUiD+VD2qcN5UZ0UP9eslr7QeQ1ucZUraxwQY6mb8sX8/PvZ
 PH16TxQmHvIkyK9Q3WQ==
X-Authority-Analysis: v=2.4 cv=b+i/I9Gx c=1 sm=1 tr=0 ts=6978877f cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=J-iJWbdkTBbMhk0S1ZMA:9
 a=CjuIK1q_8ugA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: 5n772kaK65HHm39q-S61pSemdhYJwnQ6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-27_01,2026-01-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 impostorscore=0 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601270078

On Fri, Jan 23, 2026 at 09:21:40PM +0200, Dmitry Baryshkov wrote:
> On Fri, Jan 23, 2026 at 12:42:12PM +0530, Abhinaba Rakshit wrote:
> > Register optional operation-points-v2 table for ICE device
> > and aquire its minimum and maximum frequency during ICE
> > device probe.
> > 
> > Introduce clock scaling API qcom_ice_scale_clk which scale ICE
> > core clock if valid (non-zero) frequencies are obtained from
> > OPP-table. Disable clock scaling if OPP-table is not registered.
> > 
> > When an ICE-device specific OPP table is available, use the PM OPP
> > framework to manage frequency scaling and maintain proper power-domain
> > constraints.
> > 
> > Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> > ---
> >  drivers/soc/qcom/ice.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  include/soc/qcom/ice.h |  1 +
> >  2 files changed, 64 insertions(+)
> > 
> > diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> > index b203bc685cadd21d6f96eb1799963a13db4b2b72..ca6a7df7a6827378af1f013c7e62a835d1b80cc5 100644
> > --- a/drivers/soc/qcom/ice.c
> > +++ b/drivers/soc/qcom/ice.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/of.h>
> >  #include <linux/of_platform.h>
> >  #include <linux/platform_device.h>
> > +#include <linux/pm_opp.h>
> >  
> >  #include <linux/firmware/qcom/qcom_scm.h>
> >  
> > @@ -111,6 +112,9 @@ struct qcom_ice {
> >  	bool use_hwkm;
> >  	bool hwkm_init_complete;
> >  	u8 hwkm_version;
> > +	unsigned long max_freq;
> > +	unsigned long min_freq;
> > +	bool has_opp;
> >  };
> >  
> >  static bool qcom_ice_check_supported(struct qcom_ice *ice)
> > @@ -549,10 +553,29 @@ int qcom_ice_import_key(struct qcom_ice *ice,
> >  }
> >  EXPORT_SYMBOL_GPL(qcom_ice_import_key);
> >  
> > +int qcom_ice_scale_clk(struct qcom_ice *ice, bool scale_up)
> > +{
> > +	int ret = 0;
> > +
> > +	if (!ice->has_opp)
> > +		return ret;
> > +
> > +	if (scale_up && ice->max_freq)
> > +		ret = dev_pm_opp_set_rate(ice->dev, ice->max_freq);
> > +	else if (!scale_up && ice->min_freq)
> > +		ret = dev_pm_opp_set_rate(ice->dev, ice->min_freq);
> 
> Do we expect that there allways will be only two entries in the OPP?
> If so, it should be a part of the bindings. If not, please design the
> API with more flexibility in mind.

No.
Thanks for pointing this out. With OPP v2 being used we can indeed,
support multiple frequencies.

Also UFS core using devfreq clock scaling can scale among
multiple-frequencies depending on the load.

Will update the patch-set, with multi-frequency scale support.

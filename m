Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785A93EBF37
	for <linux-scsi@vger.kernel.org>; Mon,  2 Feb 2026 06:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770013960; cv=none; b=sLP8zEyylDWtXvEH9u+oeK8m+aZO+pJuqpo//Aa1B8sZQ+kAfobcwvVggR5irYlS8sFjoHPo+MHAn3OECIrw28FA0pZ2fxhWfttac5+wqJEHAptbKzVGhgWzS6mI5vW/ft7afo29pJl24SsMXflP+E3lP5Ba8Qz8zu5HOs+EYuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770013960; c=relaxed/simple;
	bh=GNhVTBlnouzaVaIZbBjia4fDeb1Ma0W34R3FR6sNPMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V/vFemDzlpcdVsfRAuaHCkAlkVdfKPG8HOjEU/5sVyx15cR5kx8d4MFZ32ayGjy3qFAjiUmaA0eyvWo26tIuo/CuqtHrzLAHMems5jqjJXFvaVgyAUGewgKg+2dT62YT3xhu24dUZjkOhzu6w7QQruKWQpgVVcA0BHFXTSCPgNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nYkIi2fO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QCfCmP/R; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nYkIi2fO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QCfCmP/R"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 611M02Xi1603107
	for <linux-scsi@vger.kernel.org>; Mon, 2 Feb 2026 06:32:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=4X/ebpbZHKXJ3uGpBJiYRdCR
	+Q1zwA07WypTogytST8=; b=nYkIi2fOHCkyijd2EuOfdE2/ikXn4xRIVbjjDgS5
	3lAO0avhLk8xQJkYyKByyaaKgJRKvUzETm9QpwCUMJ1xQcZVRT0XFJ/l5YRlmMyL
	GQJONHM9tQwBmI1CXzHy2+XLyoFTuWaDCaCeZRt/ZRMuh4nBdSZWKX8rtVH/d3I9
	Xw3LhxEU2m04gvfds3Y4zL6Pfsrgbi/Z0+AVbJKF/af6tl9fXQA0JPfpf1El9b6d
	iUkhRFUot7w+HGR3T6hMbM+vEqlVMVlYFjsj0oQuQOppZeoymvu0ZQJgr6U7LBkf
	Ou5pOTY3fNaN2N3SIG6h5cQXppARMtm4feI4d+hBZ5gruw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c23h1hwqh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 02 Feb 2026 06:32:38 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2a7701b6353so42462035ad.3
        for <linux-scsi@vger.kernel.org>; Sun, 01 Feb 2026 22:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770013958; x=1770618758; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4X/ebpbZHKXJ3uGpBJiYRdCR+Q1zwA07WypTogytST8=;
        b=QCfCmP/RS8J201LOb2/0XAgY+mlzljgHmsPBCScF1RvuSqtQl5jI4JM88GgFB099Ug
         hgFZO1TxeIiS8ZYXXUvcfgH5FYoEfM8uTZYpwLSVThQaur6ROVnjif6JA3lYrethnIIg
         UtDfLdrP4QKeRa+hN0zRLRzoJqXZ/Q9Yozw0bmqb0rXTaPHEdCt+F9tX0aOobjkJ68wI
         NNlpmJxSNqCvxBoWWrl2m7mZQIzl3jSz7hvvTWC+O/huvZyGNCLLFWgSFxqG88TCIJdj
         LStzg0xiU1jgBNcS7CywZHZnGQrPMpUtEZC0d+FfSORhMUeHpXR1oSkkRKgPK7jNb7Og
         XMrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770013958; x=1770618758;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4X/ebpbZHKXJ3uGpBJiYRdCR+Q1zwA07WypTogytST8=;
        b=Ibhfd6FKdMssR7sqiAwIoWNl3akW2qZV/DtIT3wu72u/i824rvB1cKTXmEkg1cOEJR
         xcTlImi4NJParA9iQjD2Z9thvdehHrxbZlUrI6gk8mUUHYVL/wsnYsGGlMSYep7dUbu7
         S7TXXl1PoSyJe6yTT7Kyg9m5cBOm1Qpfh8AVaOuyYRcMJQ64WSCDgPEOOlQeEztp7Phr
         mlrU9RGFwxZ9d4nnA0FhLFDdkCPLJIwiTCOO3Q/3N2hQOZxTOzCYY6YBSvMyC4ghqPG8
         CY401TQVqNMEmq5FunCElv2SrNQf9BRFNbcDLVRX1sI1zAhrVll+VmYcCc/fzDLapnlT
         DMxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUf6D64R0eDbl5Ow+MXadf77wvWHaXB7f9U0FmoHIbCgSFCoVqRx0rP4YIyggbwKZ164iA9BMcn7KYv@vger.kernel.org
X-Gm-Message-State: AOJu0YwzfA0JELEJyjVm48k34B2ztwGeZOfmhrAyk6YSKohBkOzMeBwX
	TDB/B0rjxQp67tPLM0BGEtNSbJLNgyt6jniI/ZW+MKGURIM+V586GULXe4fOZ0QEBfZabUb1mp0
	bZBzRhj+nyhe3sukZDJ2xW7HY13p+SeHpsTzxQyjzYDzAUrLPebpC5FQX5rOTG/61
X-Gm-Gg: AZuq6aJmf9KX82dsesQMsZ28iV4VmMVS0jqUxdfyEpnu70ivWAOxSWfwVJVXKJnPMEp
	K3RpQipg5cnmIMuzf8bP1gZtidyT0C+OorqXrA+f8/DNTw53vgEQb/18fZAN6w7pL1K+9rA/FbF
	d67tzSlaCR00lW76/9EXGcIujHBpVVqnXiQS5NXjy6p7vP8/r4caK6t+ZywNyEshhRkjfoqd1aP
	bpGNKCx41jucrLeH67YBQB1iaHEINw12F56w3brobCX/a//XuT4t/3lVb6zAvvV7urfzs4oVciE
	Ftq4ldLVfY1AldIv0BCLtSw0mmwjnkF1m0F+amruDzQkqANumKvPf4+/HbHgNL9foeVaye8YR8x
	ZZChVGjiIHrMxNpt04eH67s7Rg5aeSuUnHfI93LcEWC0MJ3M=
X-Received: by 2002:a17:903:38d0:b0:295:4936:d1e9 with SMTP id d9443c01a7336-2a8d8037b2amr118684335ad.36.1770013958138;
        Sun, 01 Feb 2026 22:32:38 -0800 (PST)
X-Received: by 2002:a17:903:38d0:b0:295:4936:d1e9 with SMTP id d9443c01a7336-2a8d8037b2amr118683915ad.36.1770013957630;
        Sun, 01 Feb 2026 22:32:37 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b426a64sm131346685ad.45.2026.02.01.22.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 22:32:37 -0800 (PST)
Date: Mon, 2 Feb 2026 12:02:29 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 2/4] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
Message-ID: <aYBE/VljJTUNx3LK@hu-arakshit-hyd.qualcomm.com>
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
 <20260128-enable-ufs-ice-clock-scaling-v4-2-260141e8fce6@oss.qualcomm.com>
 <20260128-daft-seriema-of-promotion-c50eb5@quoll>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128-daft-seriema-of-promotion-c50eb5@quoll>
X-Proofpoint-GUID: 8dyKDNUhuqT_OIGaGFKDBOJq5l0hSdxu
X-Proofpoint-ORIG-GUID: 8dyKDNUhuqT_OIGaGFKDBOJq5l0hSdxu
X-Authority-Analysis: v=2.4 cv=Fu8IPmrq c=1 sm=1 tr=0 ts=69804506 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=skofDwuNRHh9mWMyy48A:9 a=CjuIK1q_8ugA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDA1NSBTYWx0ZWRfX8rL+T8/AZezP
 gz1lOj8bCdXyIkglgBwiujVV4hM9HOOXZrs9W30Bxth2a0xAsPU9GY9O1CIGmKl5ntGROfpn4zH
 OSWLuM1vIgGKjVeKmiK0CtEcgXKcgMi+xfd7TNyJGAINvygWz/buGQrrJzY2UKh6hk/aGWmZNOI
 w5/IgUFkLGiQ3AIAhmNbS0Nq8ARiPJ4VgXVsZOBesXi5jarbgaSFPRprj2eTKyJNpPtLCoirlzv
 QsGfT5BnQC/ywwx4fJbAmkf95HFztuL34sBTnlYxC/cgBPZSyM6QCUVwwz/Bxtm07HhM2ZZCiv7
 Luh4cJwF+NSJBkAamQWE396L6+G4NclTtH/oOU2Tt5i+/KXXhuQqQAmVfqVAK4XCAYLjRr+DVEI
 HHl7ff8Vr/fCO3omxG+Ryi+EfAWMQoqaz4UTjOs6gaYW/iY3ipoJTNdhxApMWCY/ENAI3ViyUE8
 tPHE57qni+RpZrRfqZA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_02,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 suspectscore=0 bulkscore=0 malwarescore=0 adultscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602020055

On Wed, Jan 28, 2026 at 12:04:26PM +0100, Krzysztof Kozlowski wrote:
> On Wed, Jan 28, 2026 at 02:16:41PM +0530, Abhinaba Rakshit wrote:
> >  	struct qcom_ice *engine;
> > +	struct dev_pm_opp *opp;
> > +	int err;
> > +	unsigned long rate;
> >  
> >  	if (!qcom_scm_is_available())
> >  		return ERR_PTR(-EPROBE_DEFER);
> > @@ -584,6 +651,46 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
> >  	if (IS_ERR(engine->core_clk))
> >  		return ERR_CAST(engine->core_clk);
> >  
> > +	/* Register the OPP table only when ICE is described as a standalone
> 
> This is not netdev...

Okay, if I understand it correct, its not conventional to use of_device_is_compatible
outside netdev subsystem. Will update as mentioned below.

> 
> > +	 * device node. Older platforms place ICE inside the storage controller
> > +	 * node, so they don't need an OPP table here, as they are handled in
> > +	 * storage controller.
> > +	 */
> > +	if (of_device_is_compatible(dev->of_node, "qcom,inline-crypto-engine")) {
> 
> Just add additional argument to qcom_ice_create().

Sure, that makes more sense.
Will update in the next patchset.

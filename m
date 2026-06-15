Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836873C0A08
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 08:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781510648; cv=none; b=Su6KMx0jiG+BWjv+pQL0uROkp9xbbLrNfk8382fbFs5uqtcI4lj3JMZPiITREZhzyZU3YWj3BOY5Tzz62BhynhHntduNdcWtJWYUVsTCxLneqPUaM+V7Ns7jxfpjCEv/qLiClhJJWSNcVTuIYL65uylmq07BTX1YPOdI8Fu2Ig4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781510648; c=relaxed/simple;
	bh=306+Dnl51wBPqV9cZtf8UkZPlQZgUUwTx4NzKjshApY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XhT3+gwkOTS00Zel3tCi5NUeoF6rgh8k8rGKE8htaiRq9UGVts6Kox4BOwgbZLyRMLjp2rCIzR54MJUTAJnL8qjvWdbSYE2pDmAgfeji8FqNE8v+jQQ4P2wG4kk/py9/N1WwXD71wNLvkziLxMrGyexQDGRxEPdy2oyWquIqJXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DXRHMoLH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ahSGmyEs; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DXRHMoLH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ahSGmyEs"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65F6Kual3828083
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 08:04:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=69HrKwFmXz8riMg7FP9KtF3p
	naP2sJ3u7cfriQzChOQ=; b=DXRHMoLHX+vrQ7nXmhsOc5Loakb5Kvri1bCKc4hQ
	Uv+aHRsWgnIxDpa7w7s/w7QcuF9aD2POvYKMjqe+BNh4z78z58BtLgi/fhPiG4bn
	AWhpwYIF2YmMaz8dHfb4judSrC4hWhYdPsJ3Ytl0FGfiyuJjwsBrmHbyzEgd63eH
	kgOwB7OEWknBID/VNDCOIOiUNZ4DgXIlZMBZCOOR8uynqf1u+oalnetw7u7TWgMW
	c5i9CCViBnGozoQGCEcx5OHgZSHDeQ0g526RPYZqCxvHPrc+3iKPIXeyCB8dYgLT
	dzl7mSRNKawoWdvpLrjG5Y7Nv24ToyZB8npMx6qMsZyHvQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ery7u6aa3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 08:04:06 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-36d97955899so3010998a91.0
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 01:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781510645; x=1782115445; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=69HrKwFmXz8riMg7FP9KtF3pnaP2sJ3u7cfriQzChOQ=;
        b=ahSGmyEstd7Dcu3Is5mpsp+u3u987f0L9z7rUWWf6rH171B2SwJVJ3WaLx2a0Tb66/
         8MGeENUHWxuUc8N3G2zcDcsf8YI4wcNP4cy3fQEfQFWg6vdXzMGKC1ROKmMKsgKUh8HU
         d6eYQAUVHousVacHuf2/vXzsM4pxI3VMuiO975DrxfH5QhD2GrX6wHRiON52ZYvB15Lk
         OrCXhm1x7MXbX5zDNwvD3tgjGD8SnXGUiYwa931EahRwBmRzSUChwtc3dTHBVJ+1vA+f
         QJslb0niz9Kt1jR1+r8SFTuOX/RrsGvnWelgM3JkdDmF9Mqj2lwjGcWBEYKW6yO2Ai5y
         z4+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781510645; x=1782115445;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=69HrKwFmXz8riMg7FP9KtF3pnaP2sJ3u7cfriQzChOQ=;
        b=DbZDDXYYNACiCr96ZJ3xISRvpziabzzweDq2DXcx2P/b76z+uU/32z5EXwI0ot9xBx
         /1gGOq6OKKWsdnC+receuZlCgwmaoeQrs8fiiv2n2H/4DJQ973HbrYmgfeNbzQXVSgxR
         D3HDZHeEUuzQk8RzmaEP6uqCnwa0GIpYa1JEI6uQ4wDfhpImYbtNvBObMwWPGrYTHwrs
         EPCaHYGV9COc0jPCYqaqG0p16/eNqVf7YGdRmwEwkHWApEEKGJKr3StShCigxVTZsgmw
         tDLO4JhyKH9b65JhontYozhoSBplIhM21ugdRy/CZ0JjAATtkL/6T2iyQRIXNFPLGThV
         SdZQ==
X-Forwarded-Encrypted: i=1; AFNElJ9NsONRcOj9muklZ8irKyUDQt27YmG153H7SXecq/1KSUbu3+YyhlF04XXjLz6tQmU1Em4x/MLcCNew@vger.kernel.org
X-Gm-Message-State: AOJu0YwXXYFWTaJ1JppQet3Dywt4KUPzCMivgcJ4c8r1E3y90GWxRLnI
	Ct2208518CSrNPULVzM1ovsdJTsvC82XxSacBLzAC1mdjm0Pe+KaW1BFiHPhc+fdjvNXmy5Y8RW
	M7gvyJ2sR+M4e5F/mdDRBWAbL1MlxFF9tCsCdSPlkGSg30EzwBVvAAWj8Zwl4X7fe
X-Gm-Gg: Acq92OFwqUrkIXUaNQey1mMQOkv6TeDtCTd3PFnEMmvJCr+eC+uYzRgJOpaI3ESutQ2
	HP6f4woNwat/8foovcBkF+qDvP1uTF8RITIQ2TuQDI34nw4oqMDuXqDemWM0e/mAv4Uk06Hizvt
	/IPzxpaxzSCPU+9S5+QDWGbGidl8M3TrmU44zjbBk6pWNY0mxX0v07S8JLKOTowP/dIMYV6Zhrr
	xG07u4P5d6XuPeAAo6NnPSGEXUS3EKCMkqyRNSUrWsCDRcJKHwvf4slKFonlo0Ib+3gwSLmVh3t
	h9SCmR2UV6KUfSXSbekQ/ijQEXle2XJ10n8I0RdKsreAdTJaacdhnRfHCnPDdThRu5PL4c6NzOc
	VXwClPafsvPk+gyNcRMTq8SeLgrNhigJcSc4fb8uf+qx7ciTvnbYt0JaPfa4=
X-Received: by 2002:a17:90a:c890:b0:36d:a510:f8eb with SMTP id 98e67ed59e1d1-37a01846de6mr14273916a91.3.1781510645450;
        Mon, 15 Jun 2026 01:04:05 -0700 (PDT)
X-Received: by 2002:a17:90a:c890:b0:36d:a510:f8eb with SMTP id 98e67ed59e1d1-37a01846de6mr14273878a91.3.1781510644980;
        Mon, 15 Jun 2026 01:04:04 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37a2668cce5sm15354774a91.16.2026.06.15.01.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 01:04:04 -0700 (PDT)
Date: Mon, 15 Jun 2026 13:33:56 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v11 4/6] arm64: dts: qcom: kodiak: Add OPP-table for ICE
 UFS and ICE eMMC nodes
Message-ID: <ai+x7Ovc9/pPTu9f@hu-arakshit-hyd.qualcomm.com>
References: <20260609-enable-ice-clock-scaling-v11-0-1cebc8b3275b@oss.qualcomm.com>
 <20260609-enable-ice-clock-scaling-v11-4-1cebc8b3275b@oss.qualcomm.com>
 <184dfbd2-4781-4dc2-9165-66b3617bde0e@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <184dfbd2-4781-4dc2-9165-66b3617bde0e@oss.qualcomm.com>
X-Authority-Analysis: v=2.4 cv=F8BnsKhN c=1 sm=1 tr=0 ts=6a2fb1f6 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=FjpnKfaMezcxXxbuv6AA:9 a=CjuIK1q_8ugA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: 2majUiUwdOOyoRWRs4EwSYn15sD5flCb
X-Proofpoint-ORIG-GUID: 2majUiUwdOOyoRWRs4EwSYn15sD5flCb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDA4MyBTYWx0ZWRfX6TVpRD5XCsoy
 KOO2o1Rjx84/nCmNHrqHSh4trkqVHqkDGQFhwCrytmUEqn785Y9C+UtpjgFQSYnqijXQ7KFknH2
 7cPaujqNkhOFJPLbAGjhUC9idOstTY6UXfz/2DRSyRfbFktHJDAD6bJcZZEREN2pcrkd4BckZvN
 7ZGNU0fu1loFIYE88xvkKEbB4tnMuBY+ds9Nl5dBMT0uCkW6vCTyIBMhMsPaA9Zf4C2UjfnHbZD
 8mF5grccoNjcDwHlCL7M7YzNCks2yoBjoQcEG3VE5Sd1UH5c5IUdj4EmTNj2loYxvVWj99Aj9u/
 zX/ZDyrlVi1hZQ7Fq5hGnk5hkOS04oTrYki0IJL9Vl/riwphlHXthqqJdot4ko1zZSW+qxvzcLa
 +34rNf28Mq52Q+8u2E7vP+jRoPhSXMrptLUPkxsyqAvzGMjVp9r1X7D4yvtySVZPvppyOaP6fDu
 QdmAOV1hPZamq4rOVAw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDA4MyBTYWx0ZWRfX7pDX/MigTUnP
 6y1FJya+0QvXXN6XwehvgbK7Sh+4TM7QUukQy7XQQy44RbBVrtw7TONZ8gCc4TxULOjynYmDbGS
 bpyFGICJRzTva4dEg3masnq216whtMM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_02,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 phishscore=0 impostorscore=0 spamscore=0 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606150083

On Thu, Jun 11, 2026 at 05:42:10PM +0530, Kuldeep Singh wrote:
> On 09-06-2026 03:17, Abhinaba Rakshit wrote:
> > Qualcomm Inline Crypto Engine (ICE) platform driver now, supports
> > an optional OPP-table.
> > 
> > Add OPP-table for ICE UFS and ICE eMMC device nodes for Kodiak
> > platform.
> 
> s/eMMC/sdhc
> 
> > 
> > Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> > ---
> >  arch/arm64/boot/dts/qcom/kodiak.dtsi | 42 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 42 insertions(+)
> > 
> > diff --git a/arch/arm64/boot/dts/qcom/kodiak.dtsi b/arch/arm64/boot/dts/qcom/kodiak.dtsi
> > index ecf4790f3415c46781c8e790d7892a41300ee7a0..cd76da7e49d8c664df6a60b5c18418c4e97a3ba4 100644
> > --- a/arch/arm64/boot/dts/qcom/kodiak.dtsi
> > +++ b/arch/arm64/boot/dts/qcom/kodiak.dtsi
> > @@ -1087,6 +1087,27 @@ sdhc_ice: crypto@7c8000 {
> >  			clock-names = "core",
> >  				      "iface";
> >  			power-domains = <&rpmhpd SC7280_CX>;
> > +
> > +			operating-points-v2 = <&ice_mmc_opp_table>;
> 
> To align with sdhc_ice(as label name), can we rename to ice_sdhc_opp_table?

Do you mean sdhc_ice_opp_table?

Abhinaba Rakshit

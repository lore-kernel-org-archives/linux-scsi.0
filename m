Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E7D33343C
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 05:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776750646; cv=none; b=AR06NBEjc1syoYNdXyn4IrUU0xNPi6qksQvfYZaxB0zt4rXudhkS6YdDsnVal3paPMNfoXtCYkrJo9WkjV8MgIb+5+PmAMCHxfKhavSLFoPGNxts/QNW6P3PqlvKx2aJAVT8Iq92OiYAJGCLmpk2EFXBd9uXrxH3CU9vH038Xyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776750646; c=relaxed/simple;
	bh=Ma2F8m/bDMhSI7Ffwjbd7H0bWVVF1mYXZaXGnaO6JrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cGVzw6XuNTQb0gO4Ym5VFH9IvjSaVbpBhvBfHBhVh7EPXV4ePdLn6DYrLXszgY7M95RdopRn8X/l2I3VJALlMSk4H6kmQGh8a+PWO2Nxexy6RigXkbqAuRbwFcpbPZ6TDi2dNDWvAjzEi/fbk2nssIE2FA7fLnnYCbmBcZ82pys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oz50KCKw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jgD5ds1F; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oz50KCKw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jgD5ds1F"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63KKSM403456412
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 05:50:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=VDMTCJt9tkGymDiOnHfYrtpW
	tA3tQv0mZLbj4noOZd0=; b=oz50KCKwAA1y7tlWZhNpgOE57wXZJ61yZGcPi5ii
	URgmtf7oUJGVEht30bNAnNSid4Gx7mRv0LEpZCp1JG47YnOscmSXl5uXCEsAEzuC
	Vai85BnWbJTJXmMVVDbXDj0mu7T1Z2yIQDuT2xgSm/vvy6jFmtd7Cav5t4Tv0CgZ
	MvHFgaqcbbr6Zb4sWEADl3JK6D6UAHZfqWzKlWEGVsscw5XndB8DEyV7imUteOon
	Zni8nHgPkbVTbKBXCKAaFumeql/onrQgp7SP68CXKTjaLNrX9aYkOPrBMlcdDBI5
	jv/NCygmh03HAZ8cdHiVBAWPhO99glPlW3NvaDJh/1mw8w==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dnfvjvgwx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 05:50:44 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-82f0e12d375so2295192b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 22:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776750643; x=1777355443; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VDMTCJt9tkGymDiOnHfYrtpWtA3tQv0mZLbj4noOZd0=;
        b=jgD5ds1FmtqTsyi08u4BOdMnKESim87rENJ/+rLtbtMrACWSXae5Zu8q9l8gLpTT7G
         oPJaMfyFU8CtMkBbfMVHC0d//BiG8n4kaZZl455pweSqQFWW7mbpPd1jrpXy3gqdZ+fp
         60HKboxApFoei1vwHv18/3NhcA6PP8t5W4CuwamaxV+ZF+o8Z3B7CvrORoCQ5eIUDCqw
         dz1Amwwf40OfHkfuAGhOESvgbWvNuwq05xdPXLgV5VGOfnvARlbKKp109IpsKJGM05oG
         fJW1j+baRzB3ywGeS59bVZrzVJXVTMYbb+Uonx/2DM/gsBrpl3o6WbrKLr/2xQb9uck5
         0UlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776750643; x=1777355443;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VDMTCJt9tkGymDiOnHfYrtpWtA3tQv0mZLbj4noOZd0=;
        b=oQZqmFVWmXpAqYxM0YQOJu+6FLIMoNEXzCgxub9xelenyH7yQ/7d7is+YqO3gPRJ6T
         mp5HAHgmVFr8SWQH28UOridVea01UbcMJTNawxe/Lieiue0jx04SMeAJmvAnAI4Svjz9
         TPP69FnRvMCeOLCpeYQevP0eQ1ihFnQoYb79zx6y7lhN1pX5k7E6kJEiTUxvL7u4De4H
         u16HY/2OdRcNPHUwLaIt2VQr7rYFe3bvMMrRFn8Va0F8K6yB0E89sxuhAVuskdCE7Ys9
         Cd4yMx6eYlfMEi5fCqXYM3OxvUEDXCXqy0SyfJLm9ltZC6ERDQpZC4glklzcANVh8Wjy
         Qh5A==
X-Forwarded-Encrypted: i=1; AFNElJ8gZWOtZ/W6GSW+xx250Cu2vG6wAXChflsl+g5J3xex2odfLD69DdxE3pM12TMxStUW+OMzSLByDIf4@vger.kernel.org
X-Gm-Message-State: AOJu0YzHabuWsquov/SFnQ1PhrV38iy669H6HUZ2qtZQ5R6Wro6BwREN
	df2e4W6szBcc+vcIw9NQ/AMgCIbTRTbuoE3SqNh/Gp9AUUsxj65yazx+EWECQH6iVrI0r1HBDjT
	mIJuGXQQApMxzGebl5qdPeyYiS1qOTw/Q4Nm9SRKw40Zzew1YO11RmPRyp05lO5di
X-Gm-Gg: AeBDietaLbmqnyGdnXwArOikCCiRvyKKMpHGHWg9VxtHA0eej5TzkKQ5S3+pkGw6+La
	p84w89CDFcwy8afBKpfvuJzQi3FMnsWQWKPJDAT7Hl4H0SKNJYKwz584WiRsHa9jPHiO/iffPz3
	neDVdZyVuDYC8MkCUt/Ax1391Ncq4v7M0J0xUruYGsz9yHnoqaAXaUIqa9ryc9b8YMVN8fVwyv2
	VgsO0TWxeP0tYGnoddU+Nxkjsk98kKPlHN/6ymwnE6zHPDjpq+HY5203m9tGJcGrAyQljJY5kM8
	xkuBCg2JJSscsChvQIh/HZOPrYxA1XRBWftFGLrJKbeUre8ZjMWGH2Z6Ig8f4B1zVSUN1X3SJpA
	s0q5hpNxctKyylRkYOjeLpelSdf8AKXsGCb40FXeRX1EZ/RuzDsAiiOn7BgS8A3oZ5PpQPw==
X-Received: by 2002:a05:6a00:1993:b0:82f:6841:8733 with SMTP id d2e1a72fcca58-82f8c998ba9mr17278525b3a.48.1776750643193;
        Mon, 20 Apr 2026 22:50:43 -0700 (PDT)
X-Received: by 2002:a05:6a00:1993:b0:82f:6841:8733 with SMTP id d2e1a72fcca58-82f8c998ba9mr17278498b3a.48.1776750642707;
        Mon, 20 Apr 2026 22:50:42 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8e9cbb1dsm13700652b3a.14.2026.04.20.22.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 22:50:41 -0700 (PDT)
Date: Tue, 21 Apr 2026 11:20:34 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v8 5/5] arm64: dts: qcom: monaco: Add OPP-table for ICE
 UFS and ICE eMMC nodes
Message-ID: <aecQKiWBMHBYMt83@hu-arakshit-hyd.qualcomm.com>
References: <20260409-enable-ice-clock-scaling-v8-0-ca1129798606@oss.qualcomm.com>
 <20260409-enable-ice-clock-scaling-v8-5-ca1129798606@oss.qualcomm.com>
 <71c6c453-4a6b-414e-a039-80f36e948489@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71c6c453-4a6b-414e-a039-80f36e948489@oss.qualcomm.com>
X-Proofpoint-ORIG-GUID: A0IDPjRynXLhcb-yyzmOmjBl-RjIiu-D
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDA1NSBTYWx0ZWRfX7Rgy6Ft/v7Ut
 zaU0PZ3zHYnEnQ/HdBNeXfHm5vKPs2OC1VPC4af4vmdU/nIOaymZwcaHIZrhEnHB3q9g8KXVP/P
 0TgKdUeZo3v4MrGJJ672V+xyFTErhfstMRwlZRJMpVLofAueu/mtrWCNGgb1gUtRnnxLxLONn44
 TKhHzSZWGnMGIHSOi+zg7lMX0G/udRrcj3LzI/WiFx01k6xhoqhAdkKwiMZj4k7mBI4EYObSYPo
 SeJTmWvMTyZx2Fbv9h8mTX41tg8BN8g5edPdPvEh3ABkuBukVHGhCagi7WGKU27CTzujFYPajCI
 JcQ79cyCzXH9pQWDJYQ694nq2CZDThgsPuFr8VCB5MU/jKn7inqcbAGyiCrwg9s06Puelo4WYgV
 A1P8qwG2ZAybGNjhspJt5KOLjr9TUjX0tkw7NKs9hxjzJI8tuLIfKWKUBZx7v6iE1gkgrR9GyGx
 0OPC8CpfseXB3bieJjQ==
X-Authority-Analysis: v=2.4 cv=XNMAjwhE c=1 sm=1 tr=0 ts=69e71034 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=FjpnKfaMezcxXxbuv6AA:9 a=CjuIK1q_8ugA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-GUID: A0IDPjRynXLhcb-yyzmOmjBl-RjIiu-D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_01,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604210055

On Fri, Apr 10, 2026 at 04:27:35PM +0530, Kuldeep Singh wrote:
> 
> 
> On 4/9/2026 5:14 PM, Abhinaba Rakshit wrote:
> > Qualcomm Inline Crypto Engine (ICE) platform driver now, supports
> > an optional OPP-table.
> > 
> > Add OPP-table for ICE UFS and ICE eMMC device nodes for Monaco
> > platform.
> > 
> > Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> > ---
> >  arch/arm64/boot/dts/qcom/monaco.dtsi | 32 ++++++++++++++++++++++++++++++++
> >  1 file changed, 32 insertions(+)
> > 
> > diff --git a/arch/arm64/boot/dts/qcom/monaco.dtsi b/arch/arm64/boot/dts/qcom/monaco.dtsi
> > index 487bb682ae8620b819f022162edd11023ed07be8..cb0e554e94d237b0adccb55fa9ed967bae9eea05 100644
> > --- a/arch/arm64/boot/dts/qcom/monaco.dtsi
> > +++ b/arch/arm64/boot/dts/qcom/monaco.dtsi
> > @@ -2730,6 +2730,22 @@ ice: crypto@1d88000 {
> >  			clock-names = "core",
> >  				      "iface";
> >  			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
> > +
> > +			operating-points-v2 = <&ice_opp_table>;
> > +
> > +			ice_opp_table: opp-table {
> > +				compatible = "operating-points-v2";
> > +
> 
> 75MHz is supported too. Please add that entry.

Sure, will add the entry in the next patchset.

Abhinaba Rakshit 

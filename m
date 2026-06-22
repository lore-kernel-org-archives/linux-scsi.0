Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D0E36CE1E
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2026 07:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782113896; cv=none; b=TZORtUjdmTcIKOmTkhNa2dimevOUmwxBPEPSOuDkOnheH39HM+QGeHJ+JFNO8ok/ExyhxU4Hiq/Y8XRLprsL7ysaj3ErtNnsSA3VbMoamQ221OfnT2kvuZ1r4/SPBiwDRY77bQ/UTIdwNa8UJOcSxTpxgvn2kVklf2PLhSlz+EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782113896; c=relaxed/simple;
	bh=BS9AQVWy8TOmpnea/+4LmE8sR3+CCphPYN6ZLhsapag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fVJm/llnTDjHkbUp87UPq+hTi0Tl2KNmaj0jDG6zFQL6Z8GUTxy45TC3ic8+Plithr2wvGNb4kpeFRimSCShG/+8r9EAgZ/5ky+v/fFzbwCbTX5RH++2Zip7kfWSMjlReRqvz1GihAIjw23HLa9H8eELiUsXqnnKYe1zgT+IfgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kVCoqM4i; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PDOr2BaW; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kVCoqM4i";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PDOr2BaW"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65M5BP95255465
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2026 07:38:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=M4jwyS0eGc3NAZijuRwJeMg7
	4OO8FYkEkOVQqhLxmf0=; b=kVCoqM4iNHQz3go2qKGZLbB3EcI7Xyc/5KnZTPHv
	8gpyeqFc7pXuVPF1Z04D9VJ2ZvY2vPam4tmE9nt5x+YBVfgeT2y8ywRoKiT0pPiP
	8Q75dFj6vupc9aBAFh/JORxAH9QHTCJGxLxLxT3wYja39Lmsohpwyx2F7cku2MgD
	zpZOzv5FA5P881fLpZAlEpjaep6RYKsw3WkqCktmdEUnRTzzA3J++VwUonvY72yF
	3o53NvLie+Jl7FYbHm/ejC+SGS2q/MerWV66paukdJjyueNkAP9M3x1T9fKxvWGQ
	rPldabPpEU8R63orQ5T2I3/j4il3KaRxDRzcXxIB3RD6LA==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ewhv5nejr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2026 07:38:13 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-842446a3851so2089799b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2026 00:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782113893; x=1782718693; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M4jwyS0eGc3NAZijuRwJeMg74OO8FYkEkOVQqhLxmf0=;
        b=PDOr2BaW8eWC4jVyGukIUWNn4iIwJla7QfIhDg9PSEECZkYDkSfLDRlO3bOAHWGyG8
         8b6Zr8hYpaDAC4k5zw8yNw1Wkaw0mlROcBFgOilv1TLVEMuq+MxBf//dAX0fG8XoPyu7
         rhmda0XDYvowEnmTeQc5XGynQMBevoWNsVefsPwSG+0WiUTSusZcDjGP+5wHC+UndTUi
         MnNwoTL/Ty9tlrjlhK8iv3x/ghc2ysfIeokgIhbPanyt6i05U+KYiiB/f+c0ZK1SBD3f
         jpvSaj9CSyA5j/JitK47y8Thp0V83MtUC1rUC2Bb4lqWeyAiZ6nHfSwrTqfwxBvIq+5p
         AkTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782113893; x=1782718693;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M4jwyS0eGc3NAZijuRwJeMg74OO8FYkEkOVQqhLxmf0=;
        b=tUSVxAUfssYe0OdcRcv6Q/T7rdKOepXxpbzi/lElE+mnifLebd6tZbbIgM9dGVCJ26
         I/IOUleIfhZJHt/5slUMmbQ+pTKTkVhtWihI3Lwfn/1bd5CNtyGlm0IrgbKMGQxr27Ul
         HTjnfSAzcKyGr/TQnXIoT88eySpwKujSiqaMvG0VGcUild6UCNxvmZcSfyYD7i+3BCMn
         A/XXxwY+YGEiach5bxOTEUXE4EPozG9ktdg1w+tcmXYPYAPnK5fcfwvnMJvutIyt/Vzl
         kAhDrYYsi2XluXjRoSdMc7DPIMUHakiv7zYQla00w7L42ZrrzjPnDTW+1GOe3jbpHiSf
         +WIg==
X-Forwarded-Encrypted: i=1; AFNElJ9KhLXbvQMZ74Rn7sBUzFCSX4aIrUSFGS2+i74smBP+VEeqAN5JrNnTOdCwQIoW8Ev4CtirayuR/o7x@vger.kernel.org
X-Gm-Message-State: AOJu0Yy45MhrZDvBNddiBGK+oIVsiJ2txcxB+rpi3QUILlW3epWMs7fC
	9d9Ibw5GheIsdzI1Rayt7bUXolWSFfJC2c/Iy3pJBfTn7j9JDVAPhzVTQNu6gLOpDjC5TsAgige
	f273W5PTzpPPDIvDnwkCyaTaqSGf8EM9CvfQ/0asj+w2PDH6f0+4K2M1dLtvFj0y0
X-Gm-Gg: AfdE7cmQ+I6bUDXNsPT6hzXlzFU/4M7o3kLosQtrsaP8cVvAgOulRQEMdRI5k2QiGK5
	j/gE6Rs9mN3L3FOLWrB4XHhoPoqQWwTTxiCh3JMawNHeqJ5AcL0LP+iyAtv5qywIxvIuUMq2sxO
	ZycTFozT9WnN74hRR9ZJgs8ZyVF3n8rAOL8y3HuYiavJRTK/tqDvgIyVxg/A6/22g0aL7IkL7b0
	8AtVVaFiYWF9QshpcVgX9kVYd3Yc1GaQAuzPXRsLD+2dV40EUCLBqA4CV1xrF+rfOSzz5RcfBLA
	OjDl08vgyr5VJ2l2j09nkDpng9275VlNvY/rwqlNGuGInVbHG7A4VbQ+o0m5rZg+oU1TLC2mi0T
	gGLfmWD9LhHE/ddpIykGl0VwJwTD0yVy/1jFhF9MXiBFaO/Ob
X-Received: by 2002:a05:6a00:1ad2:b0:838:a46:ce96 with SMTP id d2e1a72fcca58-8455087235amr14531854b3a.27.1782113892883;
        Mon, 22 Jun 2026 00:38:12 -0700 (PDT)
X-Received: by 2002:a05:6a00:1ad2:b0:838:a46:ce96 with SMTP id d2e1a72fcca58-8455087235amr14531837b3a.27.1782113892422;
        Mon, 22 Jun 2026 00:38:12 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84564e745besm6303006b3a.28.2026.06.22.00.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 00:38:12 -0700 (PDT)
Date: Mon, 22 Jun 2026 13:08:04 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
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
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v11 5/6] arm64: dts: qcom: monaco: Add OPP-table for ICE
 UFS and ICE eMMC nodes
Message-ID: <ajjmXMKdWzae5qqk@hu-arakshit-hyd.qualcomm.com>
References: <20260609-enable-ice-clock-scaling-v11-0-1cebc8b3275b@oss.qualcomm.com>
 <20260609-enable-ice-clock-scaling-v11-5-1cebc8b3275b@oss.qualcomm.com>
 <d8fd7888-cf7d-47e2-8e77-3ba705c88502@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8fd7888-cf7d-47e2-8e77-3ba705c88502@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIyMDA3NCBTYWx0ZWRfX34ixP8KR1fvJ
 I5qrFVgv+ioNe6soZzSKJsG9ADlIjyDP0mbI4e1WHNAdftpGh/Alb2QZyUjRcRRjam+aB23TCV7
 Q95Zjg3yEGNj8Sb/wheBRA5BSuOqnIgFqfCK/yCHoDZnCfio+QEPKoMytPKqfqRaV+8yv/EyH4b
 OouYDx7Yb75Au1cDQuFvZ/iASDADJ7NaCrKLhe2pWCzKF5Za0NnfDm6TpNC/O8VlL8JhVC55D5p
 kAAJpC1jTgKderiSW9yZvF2hC5kwzSWbL9FXRhiZA70nEaS2EQEmrU6hYSXRWaw0UF7WUtPek+/
 utnVvjVrOGioSGcUmJ/mtY6CpJag7/nhZrO27ofTFvVnKK0l8r2SjjrGXuxhRtsZsVNzw0Lzml8
 kd8kIMLKUCyexNByCtssROxFzHsSmmn3oaFynk/rqrgpS40rmKCl88pPRPhCHmdGQaJoyK/tLDq
 xAo4T5MGmfgSSOMQmBw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIyMDA3NCBTYWx0ZWRfX+W2CbxgNc0C5
 yipbKxfDhkUA6nce39HH3OFgdkmwM0B5QgrAG73Yzpm2B8URPZ0KTPW/kPF0AAGHH/0615RZwbL
 ehdlag8t61vx0KxqeRC8PaL0Qr+1Dg8=
X-Proofpoint-ORIG-GUID: SFXMgJ6POBRWhe_YQJSK_XptpPe5GiLT
X-Proofpoint-GUID: SFXMgJ6POBRWhe_YQJSK_XptpPe5GiLT
X-Authority-Analysis: v=2.4 cv=UrZT8ewB c=1 sm=1 tr=0 ts=6a38e665 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=FjpnKfaMezcxXxbuv6AA:9 a=CjuIK1q_8ugA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-22_01,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 bulkscore=0 suspectscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606220074

On Thu, Jun 18, 2026 at 03:04:57PM +0200, Konrad Dybcio wrote:
> On 6/8/26 11:47 PM, Abhinaba Rakshit wrote:
> > Qualcomm Inline Crypto Engine (ICE) platform driver now, supports
> > an optional OPP-table.
> > 
> > Add OPP-table for ICE UFS and ICE eMMC device nodes for Monaco
> > platform.
> > 
> > Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> > ---
> >  arch/arm64/boot/dts/qcom/monaco.dtsi | 37 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 37 insertions(+)
> > 
> > diff --git a/arch/arm64/boot/dts/qcom/monaco.dtsi b/arch/arm64/boot/dts/qcom/monaco.dtsi
> > index a1b6e6211b84d0d5008231c55613a0ccd61b9450..d9298d8b7874b8669b2cded2a28a99dce6eadbda 100644
> > --- a/arch/arm64/boot/dts/qcom/monaco.dtsi
> > +++ b/arch/arm64/boot/dts/qcom/monaco.dtsi
> > @@ -2742,6 +2742,27 @@ ice: crypto@1d88000 {
> >  			clock-names = "core",
> >  				      "iface";
> >  			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
> > +
> > +			operating-points-v2 = <&ice_opp_table>;
> > +
> > +			ice_opp_table: opp-table {
> > +				compatible = "operating-points-v2";
> > +
> > +				opp-75000000 {
> > +					opp-hz = /bits/ 64 <75000000>;
> > +					required-opps = <&rpmhpd_opp_svs_l1>;
> > +				};
> > +
> > +				opp-201600000 {
> > +					opp-hz = /bits/ 64 <201600000>;
> > +					required-opps = <&rpmhpd_opp_svs_l1>;
> > +				};
> 
> Since 75 MHz and 201.6 Mhz require the same power level, is the former
> OPP any useful?

Yes, both use the same power requirements. However recommended by the ICE team,
the DT should include all opp/freq supported by the hardware.

Abhinaba Rakshit

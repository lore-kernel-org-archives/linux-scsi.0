Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2C24508E4
	for <linux-scsi@vger.kernel.org>; Tue, 20 Jan 2026 14:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768920771; cv=none; b=KpEc1kD23CRZO/9WoRc6bWnHFtum1uHYmZDzpE/ezUqOuPQ69XW8xBsOHqOsaQXddfWzOXYqEh3ugB42CUInEbTQZGR4Wzbt0hI9g0YLfNUqMU25GeeGF3rmJft1ZPO0OdSGn0dMSPX0REDY6/S3fqXAPIGhrMeO/Ys6GQibq5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768920771; c=relaxed/simple;
	bh=YblBCSIO+Ze+wW74gpCOTjlIUF9aS7ZvTbmSmHD67Bc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VeguV3f0I3ANClBIiuG7x40SNtfl0VGYL7wcNvvbCg1sUghaxOo5t+/O0niQgYDYdGxdfH3G8V3msOkpCS4chC++RzssMZq8wJ4CbyZX/vwuzeNJO3CN6BEMM6lxmENCJVVMDkoTYar+O49CSMFpZ9yRSDUYBEeeLSBQshBEfl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UkIRZ1G4; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ujhyk9sQ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UkIRZ1G4";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ujhyk9sQ"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60KE5xna1408593
	for <linux-scsi@vger.kernel.org>; Tue, 20 Jan 2026 14:52:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=ZgHrGhKoJPUcO1Zkr5HE9E2/
	XP1B6ll6VlqYUNqZux8=; b=UkIRZ1G4RJdh5FiKLLcXcE0ptLhxgnPZFJhJFJQz
	7hrUlHbmMPf2cW5yBpGiUPBDX5Ge6EqjecjwzbqHEKX14OqtaCvwOdXBYFiztJCS
	aF15JpCL9iyIFsaixCtS5WsRkx088RP0onUTvXgS9mvtjp1Kv+AnnVCRe6CLdQg1
	APiwP173WVJ9Q0umBxqK9fi4qmPWbI6e2NUzW0U+p9XKTZ+xki2LROgq13xTMy2S
	ac/Ch6KYd2FC7KstduBhpODXeoAaxNsWr0RvfHMaIokqdEIiB1oPEQ7EcpDNcQ6R
	KAgZezL6FsOcVsWxSyG2XkPU4PMHojo0FmERpZ6OpO+FDw==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bt4y2sdfh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 20 Jan 2026 14:52:48 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8c52f07fbd0so164109985a.2
        for <linux-scsi@vger.kernel.org>; Tue, 20 Jan 2026 06:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1768920767; x=1769525567; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZgHrGhKoJPUcO1Zkr5HE9E2/XP1B6ll6VlqYUNqZux8=;
        b=Ujhyk9sQhR+1vu0e+S74gaRtvWCvQJ/+eeK2Zs2UK3hitZHPLeKeaZSMO7LRyPF+j3
         /7xeD92u5w8/e66fm0CwUgne0faURqNOh8yWLr3rFU4+WNg3u42+gWpAPNgNbmHOsvva
         hl04A/Kfyi+SHS6oQ4eRL9bu0juJJBjHcXwQI6Zrg1DFOGxxQH+t7o9abqQmJheA3mVp
         09hj3wEV3w6/oK58S1GQS1vzqRJihOF8wikOMyWYC0DSXWPAUHxoZ7sm5wXqAEHn1Qxx
         Ec+ZSLj53FpwN3xGgnUQwEM7+wBQVEdG7rPhpgajfaYN9eQWtcz82OMWUaQ82hPYqOKP
         1znw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768920767; x=1769525567;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZgHrGhKoJPUcO1Zkr5HE9E2/XP1B6ll6VlqYUNqZux8=;
        b=kT+3ZTVjCWm1Gv5B/6yslXeJMzCaotDLuP/t+INya7G/XNKTfXBHv8HDANKYa5lSyi
         1kjyTqkM5mpSqtvNv2Zsn0JAp9DLmyZe06nLl/gRafEpMgPXwH2FiLQ5hSkQHrBGydE8
         g1c0LHAWRiy45PXHkTdTQw7b1cYwVzE65bejl5AxUrna9Io2Un63lGNLkmE36SriXwVy
         8OLFqCIrxB1t7snW3q1AqjHxh9HO2NpPQdBCshsZtzkVcurgxpI9pW56FTguudlnAB9m
         8ZwvGlOzqujTvpV5/hoM5K/3Z0tjcgEXSkvxbGK7ZKz2VPbmEvAJUJTWvw3wkfnswYl4
         RGEA==
X-Forwarded-Encrypted: i=1; AJvYcCXtAZbEgfiWWc6aeGW4IFM3BwDABI7RvWuEykslBRtpe3Xki1r6ANAvuoiadpkq0g3gzukJ3gGtB6SC@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9fVajtJdrF3o9it1XIvQFUM9YfIC489a4Ad2ew69E+QtKSILe
	dmP+fklgDDAOWPKivZzHSyYnIzMZrmGu8V1T6mvcqF0pa0AmINQmQ6o1VI7VXg8izu9WX1FPXdZ
	OQfYoO2sDnR+6GtNGdeT/AAdBBxoWe5k4UwvYp83gYXlpIeT3YXg9ufUNW1IBL1mX
X-Gm-Gg: AY/fxX5ySGtuGnk6SL3L5xF3QyAGEByX2drA/m17gYMwLrTtZcyI5Jl+2ynk5j896Mw
	N9CCllRj1uJd+AJsSDOx9Ygy+ho958Zjrbj3Wjidtnum4tPJzbSZcN2Ci9ynqxQoGJCxe4EEY2N
	CdicJ8tjAz8XUHv1hVwpLVcpE/7RLV1c+AQCeaGMLRC1ggC1+NXltn51bR2K0I299ZIXlPcuHgS
	LIU5HUdq3GfEO4Ogl8jKGDcPtlBXf0WgZ++rjhPIZfJOuLU+kqVEPNrUw60vX3EHQPb5bdt3G+x
	g9r6jGKe2kaYajkFT7yZjKg1IUQe91+0JkY7GPg4EmfRbTHhS0oo1BpnCqBbBIly/7cpt6DVROt
	5X2Ge0dyMEW+ro6UPF+I+aujj
X-Received: by 2002:a05:620a:3944:b0:8c5:2ce6:dca with SMTP id af79cd13be357-8c6a68d3547mr1953249785a.6.1768920766935;
        Tue, 20 Jan 2026 06:52:46 -0800 (PST)
X-Received: by 2002:a05:620a:3944:b0:8c5:2ce6:dca with SMTP id af79cd13be357-8c6a68d3547mr1953245885a.6.1768920766241;
        Tue, 20 Jan 2026 06:52:46 -0800 (PST)
Received: from oss.qualcomm.com ([86.121.163.152])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43596b62700sm761202f8f.42.2026.01.20.06.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 06:52:45 -0800 (PST)
Date: Tue, 20 Jan 2026 16:52:43 +0200
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Luca Weiss <luca.weiss@fairphone.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Vinod Koul <vkoul@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: Re: [PATCH v2 5/6] arm64: dts: qcom: milos: Add UFS nodes
Message-ID: <7zdyb2wnojudnrnomnx4aiwvni3e6i52kfioflb3gslztsizkw@ofvvkvrv5f3s>
References: <20260112-milos-ufs-v2-0-d3ce4f61f030@fairphone.com>
 <20260112-milos-ufs-v2-5-d3ce4f61f030@fairphone.com>
 <zvagnaxqgrpm6bagw6zuov4oi6o4b7vmy673oh5st22tec2swl@abvblxgray2s>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <zvagnaxqgrpm6bagw6zuov4oi6o4b7vmy673oh5st22tec2swl@abvblxgray2s>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIwMDEyMyBTYWx0ZWRfXwl9Qkk/CrZ+z
 HnC6HoKfV9gLQgeABnFrp6EXMq8MFune3VeUXV7o4wiUg/rwZX4eNtakj+35jT2EeIKb1necz8G
 7Rzy1wvdCt97wJnIm5o9RelLXTLKyqq+GbjiYzIPvQPNxy/GdZbthoBWjlb68bs0R8PqFdX1QYA
 80u7i+piNw9ekd7LKllUWXJ27C4S0vUpX7o7OltAKHJ0/XqaI34bjLrZ/skczThicHdcGX0+u4x
 /PN2Zy/rkjd+Y2dsWPZ78seGYOpX2AVfPKqGtq5NXx7TMEHZlSm0ze1NkjNrNfuX1mnCV2I8UFF
 Cxdpu5ang+AkfH4DydEkNaUOKpLus42/8GhkP7gtyUmo3T0YN2t0W7uI8s6wN65r4UIRRad4gtK
 hzazrYm3qAkH46by+aSZ1ME+A1OuaqmIR4iyg+bPAv8cnj59vvIcHlHRq83YoKF1vypiFA3TjaT
 s1I+u5sJxXJDnRPGO4A==
X-Authority-Analysis: v=2.4 cv=Ds1bOW/+ c=1 sm=1 tr=0 ts=696f96c0 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=RUlelSpolvTNyr7Sls5SJA==:17
 a=kj9zAlcOel0A:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=6H0WHjuAAAAA:8
 a=3ktymktcbobz44Ac5DoA:9 a=CjuIK1q_8ugA:10 a=PEH46H7Ffwr30OY-TuGO:22
 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-GUID: g5IhT-C6H-u906eHPcl5-ZHtt5ufts10
X-Proofpoint-ORIG-GUID: g5IhT-C6H-u906eHPcl5-ZHtt5ufts10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-20_04,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 clxscore=1015 impostorscore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2601200123

On 26-01-20 16:49:26, Abel Vesa wrote:
> On 26-01-12 14:53:18, Luca Weiss wrote:
> > Add the nodes for the UFS PHY and UFS host controller, along with the
> > ICE used for UFS.
> > 
> > Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> > Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> > Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> > ---
> >  arch/arm64/boot/dts/qcom/milos.dtsi | 129 +++++++++++++++++++++++++++++++++++-
> >  1 file changed, 126 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/boot/dts/qcom/milos.dtsi b/arch/arm64/boot/dts/qcom/milos.dtsi
> > index e1a51d43943f..7c8a84bfaee1 100644
> > --- a/arch/arm64/boot/dts/qcom/milos.dtsi
> > +++ b/arch/arm64/boot/dts/qcom/milos.dtsi
> > @@ -1151,6 +1151,129 @@ aggre2_noc: interconnect@1700000 {
> >  			qcom,bcm-voters = <&apps_bcm_voter>;
> >  		};
> >  
> > +		ufs_mem_phy: phy@1d80000 {
> > +			compatible = "qcom,milos-qmp-ufs-phy";
> > +			reg = <0x0 0x01d80000 0x0 0x2000>;
> > +
> > +			clocks = <&rpmhcc RPMH_CXO_CLK>,
> > +				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
> > +				 <&tcsr TCSR_UFS_CLKREF_EN>;
> > +			clock-names = "ref",
> > +				      "ref_aux",
> > +				      "qref";
> > +
> > +			resets = <&ufs_mem_hc 0>;
> > +			reset-names = "ufsphy";
> > +
> > +			power-domains = <&gcc UFS_MEM_PHY_GDSC>;
> > +
> > +			#clock-cells = <1>;
> > +			#phy-cells = <0>;
> > +
> > +			status = "disabled";
> > +		};
> > +
> > +		ufs_mem_hc: ufshc@1d84000 {
> > +			compatible = "qcom,milos-ufshc", "qcom,ufshc", "jedec,ufs-2.0";
> > +			reg = <0x0 0x01d84000 0x0 0x3000>;
> > +
> > +			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH 0>;
> > +
> > +			clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
> > +				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
> > +				 <&gcc GCC_UFS_PHY_AHB_CLK>,
> > +				 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
> > +				 <&tcsr TCSR_UFS_PAD_CLKREF_EN>,
> 
> Maybe I'm looking at the wrong documentation, but it doesn't seem to exist
> such clock on Milos. It does exist on SM8650 though. So maybe the TCSR CC
> driver is not really that much compatible between these two platforms.
> 
> I take it that the UFS works. Maybe because the actual TCSR UFS clkref
> is left enabled at boot?

Oh, nevemind. I think I was looking at the wrong SoC.

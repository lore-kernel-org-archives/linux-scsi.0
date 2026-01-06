Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9849630DED7
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 08:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767686776; cv=none; b=iXaqUwNxQP9BhY3Fcqqe0Y89s7JVFNjW7T1Bsnoux7WwQF4PVwoqHCnWWTzW41hbgTA8fE5gYlaapaaFfpMfZxHVBeAzdHYAxn183TK6VbCiiljfVUph/qwr6a8Szvxdzg3R/drwLX/b9LD6YKjMoW1S6JcXNcdUV7flQQ4MISE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767686776; c=relaxed/simple;
	bh=JliHDsyED+nvyuQdO2GfM/Iwne0NQIQy5a33rxLtIJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G960mJR/ezVrtWLqyhIRcVUwDjz9aCu8rK3RxpA46bRcn/HiqvXc5ANIc25DsBYmlS+Q33mpRgkVwXoXim2NszY89UXCwbfBbmiTd6unZGQ9IPCkqkJZxMJ/M4rlDldM1tWaha+8d+l4gBwCyIcUhsXYFmjrSdh8ghs8KhQJPfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lY4Bdotd; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AaGtXGHG; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lY4Bdotd";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AaGtXGHG"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6066t4LP3295000
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jan 2026 08:06:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fBLvYbjia7Zx15toxuviBzFdghPbIpWd7juKJdfiCV8=; b=lY4BdotdIPWJvDRN
	qhx5ZUs9w9vfsvZEI/1BVeFOeDYdcph4nMFD1RUuv60XQ7Gn2e0UYIbkY6FtLXU5
	PwPXRGsUowDTu+R+sDPweINeto3DBjiATDi1dzqADdESSlS84bUxTJa7eCB3BwmE
	CL0ejNjraD+CDNUZV8DI7pUTcy5kyoKEkseF5Rdo3x33zQFAokS6f3Gj0TYgs9W/
	CUuIwpss27V5wjtHZASCh2NPKO3FIKJjZH1dOOA5I9qi6ByQSya5C7EQ6djn6GQm
	Dq85OgjS4CBi8IATqyTTfZCL/ugd0FNSOEVs5K0Jv6D4bRcY/p0F50Nz0V5SDkL5
	AXLzrg==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bgwj006gy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 08:06:13 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-7d5564057d0so2231849b3a.0
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 00:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767686773; x=1768291573; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fBLvYbjia7Zx15toxuviBzFdghPbIpWd7juKJdfiCV8=;
        b=AaGtXGHG/5IfSKS5ta+I/ekUoyQ+yJLoTl9vUc9LGkb1BeT9ebZKfEqv3ODDosH6L4
         FoQWSx9j1/x4Ez/a9tWzIL/QxcxeHBVAg5C9Cl49U6gc+StL+tPWdXcAsaxbwQEz9pV5
         sa1QnbfqEGU5ltcZvqUEkzphtWqtZs6qoZ49oC3jecj7aZfwPaDPKlxBilyUFd4T0tD/
         uGhirzvOOtv4MFroV94Gd5gS40jNDatEhCTIAhb0455pn4wD+yDtVVjaAoLn0pHXG2ZZ
         5PLJEEoz5AA96xhKZ1ucfhLhg6RfRP9G9mg+yDuIwu0vBywSaIObgiknSORR21h4Y3Ef
         X+5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767686773; x=1768291573;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fBLvYbjia7Zx15toxuviBzFdghPbIpWd7juKJdfiCV8=;
        b=WF6pazXR5nlDZkTGWIrXQoh0GW18oYQoPn3/J2TMkZ4W8pHg+W1djqbssYl71El7BJ
         kVa76oP2wEsdNtQctS0CWEHEnz/MCXsAwxO1B7tW7jTg8j/5jpk2/G5GTgOj4O/ltLLE
         s6qEzp+yxZd7x9JLoMcXlr5cRMrn9cB+ryQUaVlZRYK4HiHY/z3ECmPAdux6CJuhRH+L
         mL6ewpe1EWEFMoz0CZ8dlTD81BvSj1QgUfAI5ffuiibX2QjQjN6ymBi8amHFLw2IvRoL
         vr+Ff97WzdtPCD/gDPZ6FP0+6Ysb487QQhB+zqqkco9at+1bHXz5kEu30BJB4Ze70Tl8
         WEYg==
X-Forwarded-Encrypted: i=1; AJvYcCWrj2PgrCPzKCJVucNNVaDKnfiMbAkA0S1E0e93Qx0aeKhjEEOP1uTw0GrdaWO3+C0TFXBVSU6pfuAB@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8rCNhVqnv4MVEhdM1kjj+jW0z7dsHIlhzrPwz1npZ2Pvt63SD
	SKUlZffhcHyKh0Pc1dYcC9RiSMempVFhf1AbLZMw2s1NDBozy2MU/2Fp5nPqq4HXspeJM1zpPex
	nvPoM/fzd7OmaIudMWeSUPXJcq7AJQoBqGQG2GC+oIVG3yl6mDBVjD3Q4Em2t7e6z
X-Gm-Gg: AY/fxX7FBc1r/esakkp0Var6bOgoPl+gVaAQR58xEF0uQ6q/jUe3T5IGYftEUYWgAoo
	29mnOMZHdu2BPgeNkAqnYXGFnSfY3xEvKvGzewIcrCqQ24oOQX2uyt7fzxgXcUj5IPczTTGCIeZ
	Im4VQ231TtwsFyRc2l0pXtG2yNDdp7PPEf7+SMKx2XyBOAJZR35WVYRaqWQD2FZOhr94wiqhdL3
	ZeCJ2nSIIBMbet/lsUQ7ddHzqUlP0HDoxa1MirGtdSs3bvRZ74P3k/UuJBgaBbPMrT36wRbPUkb
	2mgELtRBRjxNx4eb5RdVHPLuEHqg872bEbr5HCE5xs8I7EikLQnkxe2ievXI3YTH/frqJEZRYOy
	hjYF8wtk11fcbLnuEXzpvsfyl
X-Received: by 2002:a05:6a00:4aca:b0:7ab:5e68:e204 with SMTP id d2e1a72fcca58-81881c1cbe5mr2106316b3a.29.1767686773350;
        Tue, 06 Jan 2026 00:06:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHnIvU+mez27fS+2D8szOamRUo7e/Jgvc5qiA358vWvyrCdGSG0aUyAo1P8uI6IzXwYa5/Wxg==
X-Received: by 2002:a05:6a00:4aca:b0:7ab:5e68:e204 with SMTP id d2e1a72fcca58-81881c1cbe5mr2106283b3a.29.1767686772845;
        Tue, 06 Jan 2026 00:06:12 -0800 (PST)
Received: from work ([120.60.56.175])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-819c5adf1cfsm1310881b3a.57.2026.01.06.00.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 00:06:12 -0800 (PST)
Date: Tue, 6 Jan 2026 13:36:06 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
To: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Cc: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>
Subject: Re: [PATCH V3 3/4] arm64: dts: qcom: hamoa: Add UFS nodes for
 x1e80100 SoC
Message-ID: <7gi7sh5psh5v4y5mrbgln6j2cjeu5mogdw2n3a6znjtqyjcyuk@kxpe566v57p3>
References: <20260105144643.669344-1-pradeep.pragallapati@oss.qualcomm.com>
 <20260105144643.669344-4-pradeep.pragallapati@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260105144643.669344-4-pradeep.pragallapati@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDA2OCBTYWx0ZWRfX+DvI/WAtMfqI
 P20mnmebdpYkro1iGpuPiprLLTg5NJpdpK7B7w+iW+kc6cf/XgyYqjPnx1HG7g2VZwCLiu4d5qf
 Fc2Smgc5w8gyhELt8St3q0qf0rh5+gefjyV1WEJKqEdDVT+WpIS/NNAj4+oE/rMxkmHFr1Mow12
 kcjtV20T00FZ67myFwY8YNfRrVS1nIpM0QROnvLTbaYgVLLEwXm+iXL1rJSMUcvGRnkchnM8x2h
 fOaJ2NVg64xUZ3CphezFKF2KNYV6e2aHIGRkiueJ+5ntQdHGEXGmavWpSWFWA46ZMQf/qZH1KDV
 Po3P0l8qoCrT0J7yDmhFTEECZe+jNXgT4sq9E0LJpvpRX/B0PqpeOF7kPi7AomtbcphjdpjDyj2
 GxYuYe4glwdqy2s+eRWo7dECpJPNe87qZWcvfO/M34V5+hrcT/tHBlAXe1XL8Nw/XZhwc9RG7v3
 k1zKxYiqvE6n26TNgkA==
X-Authority-Analysis: v=2.4 cv=bdBmkePB c=1 sm=1 tr=0 ts=695cc276 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=JR4DBjdY6jk8CmbmB73bTw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=Xq6n2yl2rRB09oYrCm4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-ORIG-GUID: 1rqH4bFNXh2pXql35BtRwW4oEPWwLBzn
X-Proofpoint-GUID: 1rqH4bFNXh2pXql35BtRwW4oEPWwLBzn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_02,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 impostorscore=0 clxscore=1011 phishscore=0
 spamscore=0 suspectscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601060068

On Mon, Jan 05, 2026 at 08:16:42PM +0530, Pradeep P V K wrote:
> Add UFS host controller and PHY nodes for x1e80100 SoC.
> 

Minor nits below. With those fixed,

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
> Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
> ---
>  arch/arm64/boot/dts/qcom/hamoa.dtsi | 123 +++++++++++++++++++++++++++-
>  1 file changed, 120 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/hamoa.dtsi b/arch/arm64/boot/dts/qcom/hamoa.dtsi
> index f7d71793bc77..33899fa06aa4 100644
> --- a/arch/arm64/boot/dts/qcom/hamoa.dtsi
> +++ b/arch/arm64/boot/dts/qcom/hamoa.dtsi
> @@ -835,9 +835,9 @@ gcc: clock-controller@100000 {
>  				 <0>,
>  				 <0>,
>  				 <0>,
> -				 <0>,
> -				 <0>,
> -				 <0>;
> +				 <&ufs_mem_phy 0>,
> +				 <&ufs_mem_phy 1>,
> +				 <&ufs_mem_phy 2>;
>  
>  			power-domains = <&rpmhpd RPMHPD_CX>;
>  			#clock-cells = <1>;
> @@ -3848,6 +3848,123 @@ pcie4_phy: phy@1c0e000 {
>  			status = "disabled";
>  		};
>  
> +		ufs_mem_phy: phy@1d80000 {
> +			compatible = "qcom,x1e80100-qmp-ufs-phy",
> +				     "qcom,sm8550-qmp-ufs-phy";
> +			reg = <0x0 0x01d80000 0x0 0x2000>;
> +
> +			clocks = <&rpmhcc RPMH_CXO_CLK>,
> +				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
> +				 <&tcsr TCSR_UFS_PHY_CLKREF_EN>;
> +
> +			clock-names = "ref",
> +				      "ref_aux",
> +				      "qref";
> +			resets = <&ufs_mem_hc 0>;
> +			reset-names = "ufsphy";
> +
> +			power-domains = <&gcc GCC_UFS_MEM_PHY_GDSC>;
> +
> +			#clock-cells = <1>;
> +			#phy-cells = <0>;
> +
> +			status = "disabled";
> +		};
> +
> +		ufs_mem_hc: ufs@1d84000 {

ufshc@

> +			compatible = "qcom,x1e80100-ufshc",
> +				     "qcom,sm8550-ufshc",
> +				     "qcom,ufshc",
> +				     "jedec,ufs-2.0";

Drop jedec compatible as Qcom UFS controller cannot fallback to generic ufshc
driver.

- Mani

-- 
மணிவண்ணன் சதாசிவம்

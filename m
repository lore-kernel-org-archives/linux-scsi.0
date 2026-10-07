Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB424192F9
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 07:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791359025; cv=none; b=XJbXxAnsHjJEVrHVrucrWji/FsPt7r3Cj8FVv5IEBml1IYkrht257xIEeWnuvzd0o2zeNZMeOJF3vlkLRrfBeH2ROCvuKp0IiiBeeAEI6YSM29ek6u0kFu2vG+QNcplP1Bd/eVeWIoUZ+wXyYMYH2O1ZUMRWskJeXQzE4dd4+5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791359025; c=relaxed/simple;
	bh=miqA6xiMgK7cuLadHlIunkZP1rECVzeUoiuWXv1Op08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PlEnC90TrJ3zOdmDBsiPNZR8Cyc0Yuj2T0wVJ3QBeiTpwBv8WCYCj1tZ2ZPUi2WNMfVKgiE3jVAlKw7eIpuZosAb36J5D+cmodwEOu/LRlDPOtldYTBBE0kiVbCpTxG2GLGz0MrxwIxh/g9L06S/2zwaz3neU5y+4hsBGK+yJKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CKmrYUaU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=H/Y0ZZ9Y; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CKmrYUaU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="H/Y0ZZ9Y"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6974U5AQ2916034
	for <linux-scsi@vger.kernel.org>; Wed, 7 Oct 2026 07:43:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=clJPVUXl0viASw+vzSccwoxb
	ts2uNZ+Y1lfR96jzEPs=; b=CKmrYUaUgtKQafmZ1Ex4PS9c1Q86XcXIu3H1czts
	o1V2PpiP3XImQAzXSGWBZfivErBqf6TrlkpRt5MrSNW4jFkCgV0BS9PVEmRbiXxu
	3C0cPvGmdZY+8XlE4wr7Vnsd/ZzDNvSlMflfAl5vUI/PjyZlTUJU8t4/CzWm0yR8
	zPWZw4600KfqNttxg8ndkLce88sig9Ob9Q3APe1lcahBERkV1yJIzGEeBFbEZR5g
	lGOV1Kcm3VmprCLJKyIYE4uJH/B9Lpv95FaXhm22NS5QOQYGQ+wBGlVobWjyHVaV
	P13XERN2/1VpPriD1YDC6A+oAkKnSfsjdDmg1FJw/ZezoA==
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com [209.85.222.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h546232p0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 07:43:39 +0000 (GMT)
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-98c46da4b04so2879322241.0
        for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 00:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791359019; x=1791963819; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=clJPVUXl0viASw+vzSccwoxbts2uNZ+Y1lfR96jzEPs=;
        b=H/Y0ZZ9YLQNe6UZIgcf89QMKZBoiY6XXk+Aw2GFpNFmhyAOMBc+MSGuQlq+WKcdIU7
         pdLJYd3/P1So5OVHZXCms9v9VhVRu/jfBBeTmmsyeU9L5AEIBHDNysxDQ4mo9hfzyUXF
         j66Q3ZhhDA3r93PJS5M6fJIa21MEPHcwvSXZOOP3nd5ujw1RQdjKcc0VE8LviXl7fqMe
         JGLeWcTvYt8HyEXDY2Nmi71Y+QVHXWmQKALZhZNJ3I+fQNslvScRH0sDyJWvOZbxsDyN
         pl4X+OvqWXAOr0KXtkmtNzgzML0UTLQC4EPMPvcBMEg0gE6xhpcSoGQ09ggqi0tnj7rv
         wZ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791359019; x=1791963819;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=clJPVUXl0viASw+vzSccwoxbts2uNZ+Y1lfR96jzEPs=;
        b=F3ms0YCLzU7pbbshrvqyfg4KkaCaJ+ux+arOia5yVRALBsTyca37zpRaAbVaGvJHlc
         rYrJm2xuF1V7FKKf52+IjI2IovRryeBGS7NEuzWrO1h8hPa9rNH6A0ZbdFr850aYctqc
         Czs5eOqp1P8RUtyH4v6wWsPKfSYrgWTCqpCcVfcaAlmuB1mhgmyuihsHaZidbz6oIBjE
         qxXX0upxUbZSy3dxG5Z1bZdaii+pmfbMdhIwbmsJ9kejz1rnVxvBHs0mgScgdjVZKK+T
         MNewILCrtBb4tQLX708JnOZDcs7fwvS6hv7noeYLFyRbhaYvU2108bK953qhWC/vmcsO
         iUMw==
X-Forwarded-Encrypted: i=1; AKwUvByI3SL4cKWrssuadxoBTfopnK0hfpNm0kKiTjMFTgWqCRC1eAS38BVMF4g69XirqkKRPc7qhzus7t6L@vger.kernel.org
X-Gm-Message-State: AFq9FYIGBrqg8lbO2erAriJyT8GATECwjlpIAvJbeTbumC+0FPaNonFO
	zRl17xlzEETOkg3kNURByex3u7HVCgZ0dJr8OKZlngCDVU5HIz4ISkrIsE3sfOyNOUQWLuHQ96B
	VZG5GAAugkgQGJjksPU6LPKijRJm+hpnxdJhPFQK/TJ6UPbpm1mGO+eOhQz9KLrLW
X-Gm-Gg: AYBFou1h+4IslXDiUZAXkXoxn+qPXi0Q6SfaSacH0bm5IHWidlylp3qHOmIXIqSfryQ
	elhyHCndSSEbiTn5XH1xUKyeNPmr6NXz048rOWfbpxmOMhThULl9qVUWwxVCfsZZ2XqvXjBH+I1
	YMcVaTmvd94FLdccYVF0/rjxbKUAGPFfPkqWtjxS/stXv0PnnDOcMktdB4JlU2xTL1c1M9wUbNX
	o4pQQDXhZ0jN9e52kf76r0sLXZwpgj29pWCj/V9Kr57u7SF5uqESNsd0ajP+FKPkJo4VZW9xc2O
	7VKa3bIysVj6Li4ymkm7mUVu+rFUTp3N+qTIoOetNNlv6EgkJ0Jrz2wzyx53Nf0S8D4FY+D6MHn
	Plvq/juHx0MLlw0Ce0sMvrkHZN4DocmCTrty5quGOO3aOOkzb7iPwgPEq4VLwPhqtonnzEiE7Yz
	CMJoFe7BPSDVq+
X-Received: by 2002:a05:6102:5109:b0:7c3:3f26:8785 with SMTP id ada2fe7eead31-7ca3891236fmr444221137.7.1791359018856;
        Wed, 07 Oct 2026 00:43:38 -0700 (PDT)
X-Received: by 2002:a05:6102:5109:b0:7c3:3f26:8785 with SMTP id ada2fe7eead31-7ca3891236fmr444204137.7.1791359018395;
        Wed, 07 Oct 2026 00:43:38 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a9a1d3370csm3856801fa.13.2026.10.07.00.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 00:43:37 -0700 (PDT)
Date: Wed, 7 Oct 2026 10:43:33 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Cc: Vinod Koul <vkoul@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Abel Vesa <abelvesa@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        nitin.rawat@oss.qualcomm.com, sibi.sankar@oss.qualcomm.com,
        Taniya Das <taniya.das@oss.qualcomm.com>
Subject: Re: [PATCH v3 3/5] arm64: dts: qcom: glymur: Add UFS nodes
Message-ID: <a5p5gszuadvnvqcwffg6y55khdfhacwhegaxmmiwm72sfid6ex@cdwuo6sdmkgy>
References: <20261007-glymur_ufs_qcb_enablement-v3-0-84cf4f861415@oss.qualcomm.com>
 <20261007-glymur_ufs_qcb_enablement-v3-3-84cf4f861415@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007-glymur_ufs_qcb_enablement-v3-3-84cf4f861415@oss.qualcomm.com>
X-Proofpoint-GUID: OPcD48wyaxSqEb-g3yIiN1-Y-FFac0iS
X-Authority-Analysis: v=2.4 cv=ZZiIpcVA c=1 sm=1 tr=0 ts=6ac5f82b cx=c_pps
 a=KB4UBwrhAZV1kjiGHFQexw==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8
 a=PwKYEXKgugi0Ob49dLQA:9 a=CjuIK1q_8ugA:10 a=o1xkdb1NAhiiM49bd1HK:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDAzMCBTYWx0ZWRfX4jQWHgq3VmTR
 Ve58yqK6ixG+n/gD1pNvInZEhW1eZ2bzWyVgw9ZQ7nYhkZc9ic15rHmOyNSkZdZHJUyfzFqZ6xQ
 hrke83wO4XBIXGu4N2k+dz7zR9JI6fI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDAzMCBTYWx0ZWRfX80vk66T7o/QI
 eKZ5lh5RarJ/yaZtz+OrmEdzVBny4OSyMEb7XuXqz+AQ7QWzhC2TzipWah3TodD7uzwm9S5IiHp
 KVD8TqqYrZFCfL9bEkz8hPD3h06lv1Ytpl0bpLyLPCYfBOnjfyY9KT4FPFX1UBsVagsXLmpJRE1
 DXGBXQ2L9rj/9wcUuRieLMTZGz4fKmFN+FuJ07HCeioZghILrBPGrc65m2Y1KBs050Qj6a/Pe8P
 KFqJ4hQ6yw2/ssXOGkcX0KvNri6v2hqFdKSqqkbDdHEbWtB5hmtcOKpvYq6EO8xJk7yUPammUP7
 80V4KnPF9S+ykiWgo0D0gksBALYEmzIeQPNhqqpBfQVscQAsj7gFykSkeR7xvGH8PNhJ4z15b13
 NUAuG9x4tSbyAhnj9mxu4Nje59MLfncmHf1G8Gayef1zsZWOa1HBuXWqyYESrZ4hf3GpVDpez2T
 79DhdYieDRMoEGlsCtQ==
X-Proofpoint-ORIG-GUID: OPcD48wyaxSqEb-g3yIiN1-Y-FFac0iS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_02,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070030

On Wed, Oct 07, 2026 at 11:59:36AM +0530, Pradeep P V K wrote:
> Add UFS PHY and UFS host controller nodes for Glymur SoC.
> 
> Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
> ---
>  arch/arm64/boot/dts/qcom/glymur.dtsi | 125 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 122 insertions(+), 3 deletions(-)
> 
> @@ -4102,6 +4102,125 @@ rng: rng@10c3000 {
>  			reg = <0x0 0x010c3000 0x0 0x1000>;
>  		};
>  
> +		ufs_mem_phy: phy@1d80000 {
> +			compatible = "qcom,glymur-qmp-ufs-phy";
> +			reg = <0x0 0x01d80000 0x0 0x2000>;
> +
> +			clocks = <&rpmhcc RPMH_CXO_CLK>,
> +				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
> +				 /* UFS and PCIE4 share the same clkref */
> +				 <&tcsr TCSR_PCIE_4_CLKREF_EN>;
> +
> +			clock-names = "ref",
> +				      "ref_aux",
> +				      "qref";
> +
> +			resets = <&ufs_mem_hc 0>;
> +			reset-names = "ufsphy";

power-domains = <&gcc GCC_UFS_PHY_GDSC> ? Or is there
GCC_UFS_MEM_PHY_GDSC, which is simply not described in gcc?

If there are none, it should be reflected in the DT bindings, together
with the explanation in the commit message.

> +
> +			#clock-cells = <1>;
> +			#phy-cells = <0>;
> +
> +			status = "disabled";
> +		};
> +

-- 
With best wishes
Dmitry

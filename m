Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C13B2D73A0
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 09:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789377279; cv=none; b=k/dlUBgA1qmWo7TXeXQDQbFSQ2O/gzVsa7WIg/b0d9y/FZNxyjSupYnw476Lwp6zjLyOmR/R8stuH2P92XLmLj2D6xgLE+BMztNQ1ZY2h4BPNQ86+1FZMhDNPArIR1sq0L/aJ1Ub8MGGqu2rYtV+o4pTgLuWY+LDVGcG8WSOA8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789377279; c=relaxed/simple;
	bh=5UMPd77YYaMzlyCdkt2wpYn7O9XfHpcJHpQhBTQ53Zk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N/fLqLDaVcvIXtQY128AT5n/bTrh5dK24H8VKsU9VPWJ9nlRMwV1fzIdMsbGOTw6nMutZFnMcZ8nyu4XfN3ukofSD0MMs67G6dZgJ2hKmwOIRhJGaGFGUjTjpwEWsdJbbbXdyX5KHHPil3Jmu89cpVbbuZ/pSosaZo4Jj60elhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=M19LdAge; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bJ/nPFVY; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="M19LdAge";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bJ/nPFVY"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68E5ijYj793264
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 09:14:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	apiWvG/cVrKbyxPjcX7GS2bKLCGReZfKKJQBHctENrg=; b=M19LdAgePLsZdUaK
	opzsXgh4h+5ZMcsGZ7O4Bt4OVn3Ka4VZpUPBxdarzu35WQ+fp0aNzNPNOqs4ljwe
	vulXr9ttHkE8R6eDV6XqqVMqPnI7xnX03dX6wm7fVg+GmrgcBsVyy0DLsSLSZkT9
	/2mB3AnxuBh5psVifZHwnZXfEm17wSd2sGLmMCZziuxq9X8iDDwFtbuypi82oPHh
	i0A3VHjNuhev/PrDd3xvmd38ZbpxhEw95EFauqiPy5yau+kcvbf6k7LeZqbMNZrU
	OM+ER/NouQW19n93wQIGFprUNEENpZ3J7HBttUb5GF0MycyH0pO+Sf1iFiMTSc+o
	o78QzQ==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gmy9cnv1q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 09:14:37 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93495488976so53269385a.3
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 02:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789377276; x=1789982076; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=apiWvG/cVrKbyxPjcX7GS2bKLCGReZfKKJQBHctENrg=;
        b=bJ/nPFVYkYx5dC3X3G/HWuBLYNFLI4fTWsV1bQiJLKIr/SvdpOUfm8c8X6Z6zBVXfc
         t7ff2G8yE3ybHiO/8bMK533kyKnY7UHOGTxorQmqQCWX5lvKsLuvX6BSPCqv6YEDjkl6
         Midit+DdmkOV4iSahNHZD9WKGv6JPP5CuxjCDwQ82t46GvWme9w9ZcZy2H/C63BAhAUI
         VV4JwrfwCuCMs39Q5SOnrMafDLJQqc/sR/3VwZcV0lXrsl6nWWS+ZXlXyTZjTKMROR3p
         pYl8LZxRKdnrR2C3D6X70L3nWW8JjJK+jPrNFOnPmC4zgEEDqwrVdaOAvnBKX1Au5Am6
         0BUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789377276; x=1789982076;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=apiWvG/cVrKbyxPjcX7GS2bKLCGReZfKKJQBHctENrg=;
        b=GFRWuOVyGTwP9TRmYRIazfN/HI3cb90ukrY76+g2mveJb3nItcGIj6Q3A25bfa9y3f
         Dk+jlMqnMvOJk+pceLrtWq9WcRTJYc9Gvwz0I61VUJJtxb5PehqlMom3OyxTMbtkDfPK
         WygNY6XTBwcXqiI0cLbUgGB62rH24cLWtUKIbKfj1W1hvuSjU5heshQ6EiyrU+svMZ2g
         DHkqXGfCzxGCv91UzA8OQ568KGkbYgG6gB3TkonSQAU4O6lOAohqDzye/29rKhhBbejN
         pbvBBK4fhmrArVO0bS3LE+yGfovTOJQyk/8UEEwKOLONfX56+lzE37bZWyP1O+NbuB5+
         tg2g==
X-Forwarded-Encrypted: i=1; AKwUvBzGiqVvoJlBHBe8lNRgQdql1wDs2OYFCNgsN59bUKqz0whrOvG9wj4+GtFWuZ4DdJ5ZjCabD9PEq3D7@vger.kernel.org
X-Gm-Message-State: AFuF++nA2qJaLTk6qjTe61QZHflg9GK7fqIh4CoK5NqIuETr3Ts8kC44
	JFBj9bMPYk+ot34cOoNZnhaM/cg4K0xN2tPFkDrBe8U/dmbcCua5iWx/PUQ+qq+dewZFZzkKM1q
	BVyKjo+BDEUnmMN3aOjTYkTgE/LMd+WHXUSFig1vHmQSZhYv3V9x2G/iYorxFbqka
X-Gm-Gg: AYBFou2afk/8UuxkrOmWWWLtNeu0vzhns801O1g2K5hSYUAqLJG6oS0wm37vBWNQlSd
	Ila2y6TdWC7hC2Y5HD7JeJaJudsjlcEGDORZ+1lN6r3OgXRHwT7AXh4Sv3xsIS3cDTXwuh911nt
	kRyA4Q11RR20y9oPgarPcx70oFgUX2z7OhnaUS2awB/PmQxts3BcMf8f5EVj9eWiwZECfsaWY+8
	kK17N+wicQiCCd4AuZjRvjQTV2ZI4goMYHfvE62qrlp6xMYjJ9IViUudQUiDhVosSRRxuIixrI2
	oeox31/KO+DwViyQTzlrW2w8w/WUEKoSc/kgG0L47tsLE9XPu4JIGv1QmcN2ucu8nO5TPfXTPtH
	ieDJTqQMnu4Z7b9/vr28Lww==
X-Received: by 2002:a05:620a:8394:b0:939:eb09:4458 with SMTP id af79cd13be357-93a29bad63cmr164413885a.3.1789377276418;
        Mon, 14 Sep 2026 02:14:36 -0700 (PDT)
X-Received: by 2002:a05:620a:8394:b0:939:eb09:4458 with SMTP id af79cd13be357-93a29bad63cmr164409485a.3.1789377275991;
        Mon, 14 Sep 2026 02:14:35 -0700 (PDT)
Received: from [192.168.202.12] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a9b5960c17sm3831428a12.27.2026.09.14.02.14.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 02:14:35 -0700 (PDT)
Message-ID: <c3bc5b6c-f929-4576-9d7a-d5fb9cc80aef@oss.qualcomm.com>
Date: Mon, 14 Sep 2026 11:14:32 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] arm64: dts: qcom: glymur-qcb: Enable UFS
To: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        sibi.sankar@oss.qualcomm.com, Taniya Das <taniya.das@oss.qualcomm.com>
References: <20260911-glymur_ufs_qcb_enablement-v1-0-b9fc5e2ee99a@oss.qualcomm.com>
 <20260911-glymur_ufs_qcb_enablement-v1-4-b9fc5e2ee99a@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260911-glymur_ufs_qcb_enablement-v1-4-b9fc5e2ee99a@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE0MDEzMSBTYWx0ZWRfX8evo/jUh1VtG
 y7qW6/o4vRwFoYeevWCPVDO+gDXZKIFCx5iag653iL58iqYHMzmVbe7EcOlHv5LXzqltN/ZovsH
 7ZElDMLYM144CkOJWle0HdWfHocxP0v7NIM8FGusgTrRb/ttClMn4avESB7myjeYnLd4mCyaJ4+
 p5sNWMJny5lx2BqwG8IjCT7ZYFwwdHDCmj9SHuU1fzq7yHkM+EG74iWDrSPskJJ4lS+0rgaDdR3
 bsjWRQ1fzVuMqCxo5OqIrJ6tyyVb3tnEx4TsiFkC8hY98iZJWMuxhBJHGUB+hE6fagLI1ymD28L
 lxuvJ+O9vIY88DVTfWGSD4++csS962ksMxCiokaA5Xl+0ESg4vk+ttRq5prdMHZHZXWWSP+evDk
 dBbTx9dYFkXfbPQoUQJ5fq2AVezxe7Bne0ArY7JABVl/ASvxR2UfOcNuEaoDDVBt2ywuTthGM/F
 YK4ntGdWgYlIYf7NIZA==
X-Authority-Analysis: v=2.4 cv=EMyTQFZC c=1 sm=1 tr=0 ts=6aa7bafd cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=IZYJNoHwoc_Ow-rSWkcA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE0MDEzMSBTYWx0ZWRfX5Z8DIhQ1m/u8
 QQJQSHJQvBkHhZkr4N9orAHrgQnQuh+aIjNAGLGBuk6ESCuV7gDPxiu/fzkPSKYTwy9CUZboBwR
 mgIoz/8+bjU1PwENH3ADid+wh1TaFz8=
X-Proofpoint-GUID: z-8r75EMJ3oBAQRgAQL0KnYGrFMfbBWq
X-Proofpoint-ORIG-GUID: z-8r75EMJ3oBAQRgAQL0KnYGrFMfbBWq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-14_02,2026-09-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 bulkscore=0 clxscore=1011 malwarescore=0 suspectscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609140131

On 9/11/26 6:47 PM, Pradeep P V K wrote:
> Enable UFS for glymur-qcb board.
> 
> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
> ---
>  arch/arm64/boot/dts/qcom/glymur-qcb.dts | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/glymur-qcb.dts b/arch/arm64/boot/dts/qcom/glymur-qcb.dts
> index 17d8ff3aed23..b6e384024dff 100644
> --- a/arch/arm64/boot/dts/qcom/glymur-qcb.dts
> +++ b/arch/arm64/boot/dts/qcom/glymur-qcb.dts
> @@ -697,3 +697,21 @@ bluetooth {
>  		vddrfa1p8-supply = <&vreg_pmu_rfa_1p8>;
>  	};
>  };
> +
> +&ufs_mem_phy {
> +	vdda-phy-supply = <&vreg_l1c_e1_0p82>;
> +	vdda-pll-supply = <&vreg_l4f_e1_1p08>;
> +
> +	status = "okay";
> +};
> +
> +&ufs_mem_hc {

Please keep the label references sorted alphabetically

Konrad

> +	reset-gpios = <&tlmm 250 GPIO_ACTIVE_LOW>;
> +
> +	vcc-supply = <&vreg_l17b_e0_2p4>;
> +	vcc-max-microamp = <1200000>;
> +	vccq-supply = <&vreg_l12b_e0_1p14>;
> +	vccq-max-microamp = <1200000>;
> +
> +	status = "okay";
> +};
> 

Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C9B3451A7
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 12:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781179942; cv=none; b=OUlFfpGc25G5osKlnZ8va5FmMXva7OjYrx1c+Y4QuXrU06jdsN8Pfvr8EIYsoQX2xlC4qnFCdAQxw+0VRfdW7ItT79WXLPPMovoFjgKSEyrckxSMDVEhDmPt9/Z80LUeL/rAry4E1Sto+TCdmGjTjMZHxPoOqJ26sHPiCE4DKDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781179942; c=relaxed/simple;
	bh=EA0AUAvk35NQY6LEzUqKFoDKZRbUWX0Uj3FBO1tYFHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G7gQKD3+Q6g2a0oB5L37RDRGmjNtzz0pHeK7AX1PpqGeW1Y1UtXgHrMBRZV1selW2wPRncE8MeKHx1kz8kfDW2PNgGEx9sRo632j04rZ1rEd21jeKTGTbTB/q5E5at1rFMdx9E0YWD+mBUUhS+dETamv+KTwiocz5yTb1xLhon4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YKxjK0mF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EvpqSYIo; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YKxjK0mF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EvpqSYIo"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65B9xSgN174190
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 12:12:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	QhpDgrlDLbFb+gFJWSuBHVMi+xPJTrQFLIJftKry41k=; b=YKxjK0mFYbpZHDzE
	GEyMKy8QPifImiJ5OX/OSrAmNm1Id0OPwHENm99gxOxfO2vjpGspb4R4Wbwv6Izi
	vsG9+PN4KhqkqEFju0YzWna11qHFt7XBFcmj7/BNyYi45IkaZ6Bhx9ibffn6tza8
	np7NXZT37f0dpgjIn84eKqT0ko9EtUTHiJ8PhEiUWFWEkTs5h8WRB/1iCCNcT7Kb
	vPtde36RHuCpcUcCdX/O88Yw6NH+a/FcaDzNpJFxbP3AnvV/EzeEYSNZ2yDcBuvs
	6Csg8VrjLvxsnjg5Cp4V5K9VMbVs1S4lu7NjrhgFMQdwXwCrd4IJusZtsMf4Lx37
	x5+OOQ==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eqe6vb81y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 12:12:20 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8421ffff8a3so9702215b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 05:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781179940; x=1781784740; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QhpDgrlDLbFb+gFJWSuBHVMi+xPJTrQFLIJftKry41k=;
        b=EvpqSYIoCiDZW10fHKlaDIPBVn3JNe+b6YyCnhJzNoGy2YfruMd0SRQx457iJRh8Qk
         yV/Vr8gj9DnUbYb7o5zSTFscIaoDy8GdLwD6ED2tR12Q3rthgK1EimPs2ZhBjdcqxtfL
         AxVMBMCr9+tQKSmtsQTb8DZ7pMrGPNHsybgcaDRTW2s9Qp3fC9+Yh36g62qPoGZaxaed
         lhHiXnydz6jbXlKQEc15cROPS4moHnXrzK2rDAeZx7FDbGBQTWDOE3fFziQoKhGXnQEQ
         fXO09Ak8Urz1q0mmNDsLiptfeZUuOut7LpjF1CnlnRKT+qmh3EwrisLhpSJww1tMUhoV
         Lf1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781179940; x=1781784740;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QhpDgrlDLbFb+gFJWSuBHVMi+xPJTrQFLIJftKry41k=;
        b=pzPUunDMjT67qDFupgb2OOrMOFaFUdEMK45T1h2eWm6dIzzJloX1ZIqrkUlqaQ0wAa
         GGAJSZLanU4flc/FZOxKBg1Ox7joKTylUzBfXOYZXYiWlZhmhjmvu+z7EW86thjrB3o2
         eRQW+n9SF1BsWj68UwpTtVyIAVwzij27IEEZVwcSPt2QNHRqcMf4Sq56x5XuBb6iCIfK
         MQdxVAKSj5HK5ZEGIkN9P0UwMp9J2k9d39kRUM91R60HS44E2auWuxOffWa/idbDp40S
         Nggh0McH0CMVFMo02lW0gRXilfxVBNIbKrNQJvPnECa0HujObasQRHakrNC1gsEiKpkX
         Ptcg==
X-Forwarded-Encrypted: i=1; AFNElJ8YntPCPN3RqBb1UdnIkrriaXaL1o7tGs+XWHLuJM5FD03sLqkWs+48nwEbYcol8Yri93fgCbIgAa0K@vger.kernel.org
X-Gm-Message-State: AOJu0Yyvkjju1VEDoPVMocNxMzr8iUg8bum/EOpagldhwXNhr+qsyWHY
	SAYYaU+tyhfq4rjm5rFb4o/GGg7M8RnNH2Bbwqr9QeBRmx+LUa2p5j20mv+2hP3pgpbN4rnoXt/
	UO16Kta12Rh97jNXzSFR27eHviRROAU6bjiO3PYNWTEr3+wgmm2kFbPqU2iw90rEX
X-Gm-Gg: Acq92OGPCFV46GEsTaXGt1FGoqhHZ5WkSAFtkyGDlsmAdiJOlKtFawzuc02wr3jYuba
	50ww4p383/3ZySvlJswZlf5vRk+99+Q3HN9P/MxwEBTYxgAnlb9qERM1HjYMmqpV57MWPRK4Y7u
	1IDb4QF4V1aGLQ49HqlS/L67lV9RWTakw/qgWAa55T2mKp7NpwKN6UpcYXDjEzFdRudVSqB8sXI
	f4RMtvE/OrF5HGuD19fDzuPbh7n7GTnQvz+jHcus553aZyrZtjV3W+q9ii2H4uO9xG3hCuNATF5
	DwskqhwwKkLB8HSIn0EMuGGmURcMePn2cqQu4DhsO5ePWmt98AMxkHvVc1o3jp/so9iI2eYt46u
	lvTLSKPmdPHxp+SgxyA7T7PvH12gUljuR1jwL7bqJEW5B6FxzKNIC778NwtDodUE=
X-Received: by 2002:a05:6a00:1905:b0:841:dc8d:8066 with SMTP id d2e1a72fcca58-84336bdb046mr2759790b3a.39.1781179939981;
        Thu, 11 Jun 2026 05:12:19 -0700 (PDT)
X-Received: by 2002:a05:6a00:1905:b0:841:dc8d:8066 with SMTP id d2e1a72fcca58-84336bdb046mr2759747b3a.39.1781179939535;
        Thu, 11 Jun 2026 05:12:19 -0700 (PDT)
Received: from [10.92.167.195] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84337bba740sm1926825b3a.23.2026.06.11.05.12.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 05:12:17 -0700 (PDT)
Message-ID: <184dfbd2-4781-4dc2-9165-66b3617bde0e@oss.qualcomm.com>
Date: Thu, 11 Jun 2026 17:42:10 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 4/6] arm64: dts: qcom: kodiak: Add OPP-table for ICE
 UFS and ICE eMMC nodes
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20260609-enable-ice-clock-scaling-v11-0-1cebc8b3275b@oss.qualcomm.com>
 <20260609-enable-ice-clock-scaling-v11-4-1cebc8b3275b@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260609-enable-ice-clock-scaling-v11-4-1cebc8b3275b@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: _Er2SQRw3ZU_vJYJLOgOfjVNZAgLJajh
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjExMDEyMiBTYWx0ZWRfX8LVd2fTGj5Rp
 vSBzXoCD4VGw6KnOCoILQEUKkOoouv+YbSN7GhqFhc8H1s/W/5u17aUd2WfrxyWmSygCa20g+X7
 7K2if5pBOSRfRVjYdAhzEV+w/8/RL/o=
X-Proofpoint-GUID: _Er2SQRw3ZU_vJYJLOgOfjVNZAgLJajh
X-Authority-Analysis: v=2.4 cv=UsRT8ewB c=1 sm=1 tr=0 ts=6a2aa624 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=QRdWpJMrku1fmPn5X40A:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDEyMiBTYWx0ZWRfX+jpAGZQPfdcZ
 D408N+Y18Pdry3nJ1Txn5zUPzIa4pTVm+bICtowGQCobE372QKvVYvNu5VGMhaBPKX3lCZ2KgFd
 VyvCqTQRKmPNbnoxtl/vepsaRRcXnIpW0avGcgHKy8RoNVSH0B/Fa/WIfOzmYHcgLftf3Tju450
 GW9ldVGmdW4v5bpHn3VEjefran6/DfMo2dW57znPSFJYsZInvOPDeVpNDppar6WsGj9wBRd4dvs
 WXxmyhue0yx0UhqDTx4zeSbLSKwNYxqz0FWpbjP0Wpuc5T6znYJtmf8oyo3XZIYmpB1w5B6UqpN
 Wx/rZv0g9593l2/79DdbyVv4/Lvc7Q3v0bNjef41YrPVpIb55Mnf745okqsjeFSiMgydappJgW+
 nZ1i/lLKi+fOQMaM+8/QJspiE9aF51V5HtH3GDcgsPZX5S4WBA7QYauhcARF0UXlfdklN9juV5a
 RAFPATCD32S4gByB7mA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-11_02,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 clxscore=1011 lowpriorityscore=0 spamscore=0
 adultscore=0 bulkscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606110122

On 09-06-2026 03:17, Abhinaba Rakshit wrote:
> Qualcomm Inline Crypto Engine (ICE) platform driver now, supports
> an optional OPP-table.
> 
> Add OPP-table for ICE UFS and ICE eMMC device nodes for Kodiak
> platform.

s/eMMC/sdhc

> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---
>  arch/arm64/boot/dts/qcom/kodiak.dtsi | 42 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/kodiak.dtsi b/arch/arm64/boot/dts/qcom/kodiak.dtsi
> index ecf4790f3415c46781c8e790d7892a41300ee7a0..cd76da7e49d8c664df6a60b5c18418c4e97a3ba4 100644
> --- a/arch/arm64/boot/dts/qcom/kodiak.dtsi
> +++ b/arch/arm64/boot/dts/qcom/kodiak.dtsi
> @@ -1087,6 +1087,27 @@ sdhc_ice: crypto@7c8000 {
>  			clock-names = "core",
>  				      "iface";
>  			power-domains = <&rpmhpd SC7280_CX>;
> +
> +			operating-points-v2 = <&ice_mmc_opp_table>;

To align with sdhc_ice(as label name), can we rename to ice_sdhc_opp_table?

With this udpate,
Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

-- 
Regards
Kuldeep


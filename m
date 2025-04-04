Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDD419CC05
	for <linux-scsi@vger.kernel.org>; Fri,  4 Apr 2025 23:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743807969; cv=none; b=lJOhuxRbnVKxFzzo/Y4hCkwq6o8oQqTz6sw9/YPD7bmVLMA8CIWIPyhnrrb/xhwa0MAfejN0mfkRSu20JhRpXrtcDijhg9/961bYMi2jOzHgaIVrM1Xgu6s6lBIuhMpov83smm3ivXAKisXN6bdDfA7hagtKDKcvOKgq7rfexV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743807969; c=relaxed/simple;
	bh=e7s/wQf6biP/QLI2PC9Jk4SqZU8AvZa0ftX6e/SnlEs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gy6hmgU4xizHHDQOQ2EQOnVWvKA0fqJkFVCK0NzgMqdOzs6NYnvGKBVpLKRQKLMpimXjhgvQ4AnOsg0zVHN+Qt4WD+JpU36pldlXT67P9AZe3MiwJxXIVtlYCFtxAxNAFiTH0ErjnVoGmSx+rJFKvaZivFI3Gm320PJIKUaTEmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=li8BdDl4; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="li8BdDl4"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 534JEaQt029245
	for <linux-scsi@vger.kernel.org>; Fri, 4 Apr 2025 23:06:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	pqZtD6HyViLcLmaA3AKsytIF9cWBf63Uq1fPzpIpZX8=; b=li8BdDl4XKae48Sc
	cEP/ciYDlBBzSPfUypJjeJx3Y8/sTosv2B7GZ+S10hG9yphjJN5cbatSeuCEYQXZ
	ckqXPhi+rVULLBGCErcKxl8MEuONklx8Vh+Q3/ACu444q0HjN6eKT5L9AAz8CoVk
	LFQDKEqQqrRH6281FcsTq1jcnrIqUErPdFpaydn8sbjxvdnJZk0M+/QF42GaL1MH
	gTXD6W0nSaGznMohbzRKm/iQPAEQj9Cat0P3fISZDcy+vHTN3RA+7wn1T9uDDB6Y
	HW6Bg0d6HJr30kg1dqpRPLlAzxgPWdrKjjKVUEp+NdxbeG5WwjkjZi69nMh5m3A4
	pbHdCw==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45tbnkt1dt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 04 Apr 2025 23:06:07 +0000 (GMT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6e8f3766737so5057966d6.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 Apr 2025 16:06:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743807966; x=1744412766;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pqZtD6HyViLcLmaA3AKsytIF9cWBf63Uq1fPzpIpZX8=;
        b=Q7Vu8RCRkgLZLJ/68o4HVJixI+ujB5NuHe28wDEuyWWRkgfl6iXSVKIQw1IH+WTJSy
         2jcmfnHYifWZA5SDbmlKLC7zK219oXSeLtMDMxOWy6FyJYzkutbl0kPSjg1LnJJdbHkg
         TvgPxrGkt01/szQEOQUewmXEuAS38pmI8GG1nXHFmGAL4Z3rA6BIi0b+txT12XYCMPUT
         77JwX8CQcnKgc+FI1tbFeCmv0UNW4QPD+xEMeXdEXyZJMsJSa9k+AA5UKqgLaieZb5N1
         sB/CVVqz60VXD6NAuNogR87/RNEhP6z59prcWPQb2yh6oZagfQyA2a//MsXl/SjGc+RG
         V+kg==
X-Forwarded-Encrypted: i=1; AJvYcCXvCMlrZYDRs/K3yWDYNl52pab805faBSMC9aYm6l+o0SAHEG7+Sxv5P2KH0SqWJodzxd0Uod2qn7Vp@vger.kernel.org
X-Gm-Message-State: AOJu0Ywl57K7fUEf6WoeLSVOo8B03felbzZrFY0bBp4q5ocEHojcHxvY
	eggKutz3g9McWcOs8WIQrm87IeO4eb/3opxmNjwbW94gt+eGDgzq4NNTtxYtgpvngNf9+8HP/mk
	G5RRKAbahfCccYLP8ZKVVDXxZJIIHRXWdHyxCLQC7O20zGtVp/jU5Q9Iicaen
X-Gm-Gg: ASbGnctaU8Bgtn4im4SzC8mDxhk8qVu4pqw+vyo/CXhqPVR0J6AycWU/gcJSMkZRFD7
	p675aYsdybtx3j2VFdUluPfX4AkGUMFwC1pkm9egutLGld7/TojuBbHSK+LPaLfxqULzH6Q/zKJ
	RmhS/wlsqS3AIvTBUHFUWo7zlYknYD9wArKz1u4JCgEbTv11+rhWUGnZBeJB77yrCjkgpu3zKsG
	XekjVABc8a7AHXXOg7wsucvaakAhvo2W1pwd2S7laNBrCe/rWaTBbjTMRVQqxQ/qzRAISGjxbl7
	E1Yw+rRXDAESruLRLETiuhRMxQPONaTKEJyBFKLl4eNgV8Hwbid7Jty7YDLGN/L6Lf/kJA==
X-Received: by 2002:a05:6214:400f:b0:6e4:501d:4129 with SMTP id 6a1803df08f44-6f01e7816d4mr24617416d6.11.1743807966294;
        Fri, 04 Apr 2025 16:06:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEr35w740KZpw0xQvptnZ8MF+cYGIpMx6tB/EaxbG6zx0PxVe/i/z/b2Y4U7Nu22q2EIDnbuQ==
X-Received: by 2002:a05:6214:400f:b0:6e4:501d:4129 with SMTP id 6a1803df08f44-6f01e7816d4mr24617286d6.11.1743807965905;
        Fri, 04 Apr 2025 16:06:05 -0700 (PDT)
Received: from [192.168.65.90] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfe5d794sm329756966b.11.2025.04.04.16.06.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 16:06:05 -0700 (PDT)
Message-ID: <fa5fdd73-fe76-4c06-a18a-7b06b87b05f2@oss.qualcomm.com>
Date: Sat, 5 Apr 2025 01:06:03 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] arm64: dts: qcom: sm8750: Add UFS nodes for SM8750
 SoC
To: Melody Olvera <melody.olvera@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>, Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nitin Rawat <quic_nitirawa@quicinc.com>,
        Manish Pandey <quic_mapa@quicinc.com>
References: <20250327-sm8750_ufs_master-v3-0-bad1f5398d0a@oss.qualcomm.com>
 <20250327-sm8750_ufs_master-v3-2-bad1f5398d0a@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250327-sm8750_ufs_master-v3-2-bad1f5398d0a@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: EgH81xfH2R_K_Ve9sm7KhFjX623f5Yna
X-Proofpoint-GUID: EgH81xfH2R_K_Ve9sm7KhFjX623f5Yna
X-Authority-Analysis: v=2.4 cv=X9xSKHTe c=1 sm=1 tr=0 ts=67f065df cx=c_pps a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=FpWmc02/iXfjRdCD7H54yg==:17 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=DTz9NSAdtq1ik8-Tc7kA:9 a=QEXdDO2ut3YA:10
 a=pJ04lnu7RYOZP9TFuWaZ:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-04_10,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=650 impostorscore=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0 clxscore=1015
 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504040160

On 3/27/25 9:54 PM, Melody Olvera wrote:
> From: Nitin Rawat <quic_nitirawa@quicinc.com>
> 
> Add UFS host controller and PHY nodes for SM8750 SoC.
> 
> Co-developed-by: Manish Pandey <quic_mapa@quicinc.com>
> Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> Signed-off-by: Melody Olvera <melody.olvera@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad

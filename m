Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F48A1B393B
	for <linux-scsi@vger.kernel.org>; Thu,  5 Dec 2024 21:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733433701; cv=none; b=b1n+r89VZLFsoPCvNSo6D8RRnJWe3WFLUFZNlQ/otzBkczIv3EpbzBWYwN71GQOIfIgYj5hVkacRs+i/LRSIHiQkC8z/DrScDnkyEiOjptwPWq9ubMe4ABf2jDG+tiXB7goy3nrMXKhyZt8qzgBIEow+jTSSvtXj+e6I+tzdZ6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733433701; c=relaxed/simple;
	bh=OXG1ROAvB8Ka+BpsxdTrr6f/QoqTagXp322JhE/Jub8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sCN5GxjIiNGhU3F+dzQ+teP3j5YGv2r9iZczPMffwbkbrkHcraKrniVm7XXOcyyT9Y5q5snc29EQcgqtJKSzLSA2IxD2rF6eRNwjT7uApDtl3xNdvSRb+oimuMy/gunHE8pdWLuO1y+Rv1uYQpnMRAy++/bB/TMQjgW5VX6yPOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=c72aI9GE; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="c72aI9GE"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5HaLPK006894
	for <linux-scsi@vger.kernel.org>; Thu, 5 Dec 2024 21:21:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9wSKuFAw0pvLNlawQARI7JAUgvlhJLy4giEcuIJ/xFE=; b=c72aI9GE3h1hgefA
	yh2mdztFSppkAR1fa4zj5DaMbyqGfRj0jPqj8JIhkp99f1WQXpukx4oahsSqLJYu
	7M7osg8nhVjzrMu1Wv6eAPeNbQ6Ky5xYBnw1Dsq2l2u8BPAWVWdTrkrNpUR/HCnB
	d6YLbqz3zE5ij5+6ke9BtAcA4qyoiZtdmvVFK3nbr9cDaovu5ezWHcRdpeFjSC2b
	M1kAiz5sKqEPwkkCMs5pql4RVnVSd5YSVMdWYBcLKxnRJcSKaB/XqvOCd2EleTK8
	lEMTH0H/bvkjqWnXB5e7vrXL5KUbCGqept2xv9qktFLzsQTtk+/tKfLlki45OBSn
	q6/CiQ==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 43ben88wnc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 05 Dec 2024 21:21:39 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7b67127ab77so12418385a.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Dec 2024 13:21:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733433698; x=1734038498;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9wSKuFAw0pvLNlawQARI7JAUgvlhJLy4giEcuIJ/xFE=;
        b=Fg5VRHzSlJ9KYAjRzm9zOPdQLUXsaUBkxkE6dQQYJvyIbYm39GT4rezzNjl+7FwhAz
         hF8Yxodwo0S6ZDwTSnZ1lU3szzZYhifGK5I1ae7z9RJfEXA0PS3NxerDbJuvssPBwRV6
         FriSZTYZcSZbkyWHYDdjSJSW553aMHUZcbW4hSDQni9DSWOv6E7Mm9qYJ9TL+PgoMjVl
         omSEFc2gMKRw0NdYvHrEnmB3hxyvjsS7hCyG5Io0SexkmwwtAboobExbPt0MeckuPfKW
         QcH9M1/MvVmt/fu8VV/v9VAer+LMK3up6J5nKS0NGbqLSvU9WE2cxZK1HlC7+OreMw+w
         eAJg==
X-Forwarded-Encrypted: i=1; AJvYcCW82ipjQIFwV0BjG3i4xqUjy3QFs/MKMH8X1akiVvYUJLry5iUHarQaP/KvOxp/2Di7BAJQLoZdni92@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1JsvuXD5FMwPXzdf/UMi+gJqYavTLEo6VDvcIAmiL4Xq5TuDQ
	zko+M/pyU6GIXeoT/Mg9HSO5k0ByGjvorCd8Wic2yE6jTvNfjLhNjtro3MOrH5IbBGa3LCF1AoV
	LQY49fKYLAe5UGNcut6vNe8TCsQcBpcr4s9U4To4UJLi5fQnKULJBzk3oxE3x
X-Gm-Gg: ASbGncu1HqYTa56oDkYi35tgMGRmAycJ6iv20aNdnkgVrYpNQ+0Gytx5Xu8wvlPul5p
	lqrnr5FNrexvb0IrJHTrBVFAO3n9jJX1jG28nNmFFQDE4OYQBbrLGpLacC+u8DOL6a3mXtCEldL
	NS3uZunRIOo6+sQdorFRmQGcvAyHTUtEud8vVbbwfjkczQlpyeD4imfj4nxkZJqdGQ9PvLfqCGS
	mDKdfUjHs+1l60bAHuRDsMHsNL5y6TLDBCRzSrOnFrep0ufQ0Go8QDCb5DyqilwtfOlsmTN4R2m
	h+FjZxkm6117H2lXJom343I84TU5olA=
X-Received: by 2002:a05:620a:40d1:b0:7b3:2107:2eef with SMTP id af79cd13be357-7b6bcbb4a89mr43688485a.16.1733433698198;
        Thu, 05 Dec 2024 13:21:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGP2eroqw5GjfjqU4teCdxLTjTM2852lowFJw5191BqDO0Ct4lPnhyAhDYPqgGpdYtEezYmZg==
X-Received: by 2002:a05:620a:40d1:b0:7b3:2107:2eef with SMTP id af79cd13be357-7b6bcbb4a89mr43685085a.16.1733433697790;
        Thu, 05 Dec 2024 13:21:37 -0800 (PST)
Received: from [192.168.212.120] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa625e4dbfesm142253866b.6.2024.12.05.13.21.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2024 13:21:37 -0800 (PST)
Message-ID: <d4f7ca97-b37e-4b8f-918c-9976e4a9cf41@oss.qualcomm.com>
Date: Thu, 5 Dec 2024 22:21:35 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] arm64: dts: qcom: qcs615: add UFS node
To: Xin Liu <quic_liuxin@quicinc.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: Vinod Koul <vkoul@kernel.org>, Kishon Vijay Abraham I
 <kishon@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Andy Gross <agross@kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, quic_jiegan@quicinc.com,
        quic_aiquny@quicinc.com, quic_tingweiz@quicinc.com,
        quic_sayalil@quicinc.com
References: <20241122064428.278752-1-quic_liuxin@quicinc.com>
 <20241122064428.278752-3-quic_liuxin@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20241122064428.278752-3-quic_liuxin@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: vx6pB-nzeLhbtOSTrkv1OcCspqIwmJog
X-Proofpoint-GUID: vx6pB-nzeLhbtOSTrkv1OcCspqIwmJog
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 clxscore=1015
 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412050159

On 22.11.2024 7:44 AM, Xin Liu wrote:
> From: Sayali Lokhande <quic_sayalil@quicinc.com>
> 
> Add the UFS Host Controller node and its PHY for QCS615 SoC.
> 
> Signed-off-by: Sayali Lokhande <quic_sayalil@quicinc.com>
> Co-developed-by: Xin Liu <quic_liuxin@quicinc.com>
> Signed-off-by: Xin Liu <quic_liuxin@quicinc.com>
> ---

[...]

> +
> +			operating-points-v2 = <&ufs_opp_table>;
> +			interconnects = <&aggre1_noc MASTER_UFS_MEM QCOM_ICC_TAG_ALWAYS
> +					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
> +					<&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ALWAYS
> +					 &config_noc SLAVE_UFS_MEM_CFG QCOM_ICC_TAG_ALWAYS>;

QCOM_ICC_TAG_ACTIVE_ONLY for the cpu path

> +			interconnect-names = "ufs-ddr",
> +					     "cpu-ufs";
> +
> +			power-domains = <&gcc UFS_PHY_GDSC>;
> +			required-opps = <&rpmhpd_opp_nom>;

this contradicts the levels in the OPP table:

> +
> +			iommus = <&apps_smmu 0x300 0x0>;
> +			dma-coherent;
> +
> +			lanes-per-direction = <1>;
> +
> +			phys = <&ufs_mem_phy>;
> +			phy-names = "ufsphy";
> +
> +			#reset-cells = <1>;
> +
> +			status = "disabled";
> +
> +			ufs_opp_table: opp-table {
> +				compatible = "operating-points-v2";
> +
> +				opp-50000000 {
> +					opp-hz = /bits/ 64 <50000000>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <37500000>,
> +						 /bits/ 64 <75000000>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <0>;
> +					required-opps = <&rpmhpd_opp_low_svs>;
> +				};
> +

Konrad

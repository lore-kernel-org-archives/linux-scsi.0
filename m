Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C4442123F
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 07:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791359331; cv=none; b=sJigVZ2rcHDuaqb1+cgaCWD31vbM6fGiqhP2hh37yHe8gY4c6nyQVWemb2EzhuJWLyp+EvEiRiwrT/12bEngA1TPBuNR56FKYV/yVtIlYbVwJH0Z/VHEyHm0tfaqzAwKYjh4VTmJjIvI1GxtVKHDGGdIXWdSMtw9fSRWXQNj1VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791359331; c=relaxed/simple;
	bh=6utujesN3gBDkB6EXPDDR5CLOd6jQ6lyXe/vePhF3yY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W9IKlU+AATWnZuizBZVle0ZjUFKVnNtwGQWe5bnFQHwerEtbxkBVjDlnM7qCTatpeFWYCVGGWwR+AXMR2OOXckCqKXeCBOMUcBJoMvrv9uPcOuozuLEu3+QaV6RQw7dP8+bka3rT8mS5ORsKc5bSSttKkFLIOxsHDcsRPP3d9qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PSZMAxOg; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Z0Q6awI4; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PSZMAxOg";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Z0Q6awI4"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6977jdrA3194040
	for <linux-scsi@vger.kernel.org>; Wed, 7 Oct 2026 07:48:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=oKC0olzQ/PU2CfzdnylEFRaa
	rNGXMHbrSZbNQIRuiC0=; b=PSZMAxOgGEQEhm89sbEvTLpFWOb5QWK00OPBYrc2
	A+zE3XSaPZ1e2Duxm4SodKC91gIMcqojDtj9ItSOuB7D3UP5YGEYXzVRsiGINVyu
	mDFobZS0Ia+VVYR5Lbr/1YHMoOhcQG7woLFKK4hMHgzqv5UvFf6L7tq25ZU8AmKN
	biQ4yfs3GDusTtpcyBfi2g3Kpos5aoIXqp4QsObFzcIlXOsCdX4REqyyIv4u88bm
	KKurEAfa58ivg8ucxHkbkKFmY+8o2L5hxcPSTlY8D/iyl9lItBNoWZv2yOUKCZGy
	JxmBUDrhKcLKmeFx6OYYjvGPgYRBfR511/d+eFVtbD0Upw==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h541uk957-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 07:48:48 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93cb98809caso526633485a.1
        for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 00:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791359327; x=1791964127; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oKC0olzQ/PU2CfzdnylEFRaarNGXMHbrSZbNQIRuiC0=;
        b=Z0Q6awI4yU1MaMn3yz4JCIODiWk2t6s4mBeCT0jBeAUHBSYjfvhSerg7hINi/8mQ8t
         JDuwTWLRAsGLldxkrqEjNaJThF1Ss1bcvZ4TcOa0o4xjFoyjuqI7k2o3vwPJKtOi5thL
         nSs0OCt+PDFlasBFP4DbtS5BdJF8Tj8A2NcEdmBXP69kEqhEQwViFLsSWSVOPf5vaFaf
         QQmK6X+6xZvW7iw5oCTIap15UmBW2NJfNwU3RtrOv1loAXDVc1hbHux+zOb4wCtWhM4C
         zLTCT2N8pEThc3by49bq2X0VqU4TRSf0edNuilGYyiCzrg8Ef2CP+C/8xBTyHOKJ5Jgn
         Y+Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791359327; x=1791964127;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oKC0olzQ/PU2CfzdnylEFRaarNGXMHbrSZbNQIRuiC0=;
        b=2vum3zIMJ5vGJJPQwA5vYNxFzTVoAknrbk2TaZUSgg094hC4ADoA/WWH91XTZgnLOY
         gF/GzohIeI/TgFmTfXfrJIz8sfRUaZLHu6RPJniQ+9+GrO5RMw0OBqeJ61hG/1O3lLNh
         CCWoT3yK4cbD1L0uD6L9cbfRy5Cz6HOSzjQc0t5CZNZuAiOqu8S1kGnwr8MK+v7J9WRL
         BOxfbk9nGh1dRJhDa02v/AcrmII27GnOavnV9Erk+ms43Ql3W9q2zOC7cluHYxMVafCF
         GdT7D3hgS94YOhPLgesQ1FdRfYYRr028LdFe3m/FZK/qFpABAFuwbf155+5hsSumkhOr
         imXA==
X-Forwarded-Encrypted: i=1; AKwUvByLSnv7oYBsrior6xGG4zAoDYl5CN3NuJHw7CLrbdchogEC8Sl41VVNdzyo7AKSnay7YaVx8rRWiJK9@vger.kernel.org
X-Gm-Message-State: AFuF++lxPtTZeUTpir89DZx82lLOtVMOkuWjfzQ8Ca5XKL5PqnD98sqx
	tMEz+3VqV4kedNTNlqWiCCsrb/Yu18zSVgIF+YeInVUgcVGWtlTl6+cpTm5P4XtAbVCwdca49mq
	piI0dcNPJtXEcOZgMQqy+VlKBlL4dxZZm6gL35kNQrf+nOUZemuja0V26IH853mr0
X-Gm-Gg: AYBFou0AOfYo/anAFQlOuVgrN0oJYIk9pSaKYNLdlDBxKCbpRc7DzSiiHG/F+ueZ7In
	It0tTfpiDJl0492oRFZU0K8pN1tzu5wvN9BWFtLBjXqMdhstTCMqwW2LdSuxE+rKS0TiFQPSkOF
	Te+LtaAMFLyHxksQgrMQNi7qmh4ZIQs1Ef+wPEAA1eHEcRQ6kHYaIwaXYwRXTVgaPYGKnVy/dgV
	foXLjP1CQyEgaQItBpFEJ1XXy4LjLeTv9hJkq1WmoXscdfxYpGbd/HaJq50hMH5Fav/KjL7Sb2p
	cA4rebUOnCesG863MoNCg4LCVnqkpatkBxBuCfBkRYd8iJmP7R0I/vLKPgzZhfoIuHpicha8swG
	nCYl8UbUFU0HExluMbdhpt8c8TN7nvudqMIqduNd0e1m/zSEU7Dd4Cuwt1bMQP+HA6+xtx7Dsre
	oFIYQkXNIJ0RrP
X-Received: by 2002:a05:620a:4802:b0:93e:9834:3863 with SMTP id af79cd13be357-93e9b775f0bmr271075885a.15.1791359327206;
        Wed, 07 Oct 2026 00:48:47 -0700 (PDT)
X-Received: by 2002:a05:620a:4802:b0:93e:9834:3863 with SMTP id af79cd13be357-93e9b775f0bmr271070585a.15.1791359326627;
        Wed, 07 Oct 2026 00:48:46 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bccfe9c6e5sm448023e87.55.2026.10.07.00.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 00:48:44 -0700 (PDT)
Date: Wed, 7 Oct 2026 10:48:42 +0300
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
        Taniya Das <taniya.das@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v3 5/5] phy: qcom-qmp-ufs: Add Glymur support
Message-ID: <zovl7lrhlleflaewk32o4wofr4bzm2bmkdnakev47peijrnkfe@p3ixrxltdpcm>
References: <20261007-glymur_ufs_qcb_enablement-v3-0-84cf4f861415@oss.qualcomm.com>
 <20261007-glymur_ufs_qcb_enablement-v3-5-84cf4f861415@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007-glymur_ufs_qcb_enablement-v3-5-84cf4f861415@oss.qualcomm.com>
X-Proofpoint-GUID: oatEFZh5mePyT-3RLB7CUNdNDEnq9N98
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDAzMCBTYWx0ZWRfXy2sehI72LlVF
 XwvIXGDjmCnGAl8S+gCZm+vV2xpImdkrjgfemdiP+VphUoZT7Q/lhrNoH6WJClT2PuZIW0IVbOJ
 jFZGv8Y9pyMAE/xyGcuExQoohNq0cpM=
X-Authority-Analysis: v=2.4 cv=XZYcX455 c=1 sm=1 tr=0 ts=6ac5f960 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=BBNwevgwxSeHGHzN-EcA:9 a=CjuIK1q_8ugA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDAzMCBTYWx0ZWRfX4J2RhMcOic0b
 bdmsTit2a50k+dDOlQw38xd1WLZj4ggjubq6J8N5YvGI+ddmm6AtrZbATJunt1zliXrYnxGtnJS
 9+FsvMWKRQJogvFun6YCfA1rFHriCuNt7sh3Gwdcogxg8kzix8/NY2hyFnrqOvfzKyiOHxN+w8n
 cj2WCnUSGlpdVlJwWsZM0Z8yaeUk/7k2Ru8cxSm7W9wWW4j3lBIxOY09jp8kAx6tIyx8UCxSdS6
 OxVih9TI9+Xyo43FXyf8IKqRX9t4d8rWuByYgqkL7z/qTUXbnvA5wtub14VXhlZyu/9PkRg/PuD
 m+/JbmmShLPtTGKxjynW+4JTPEu8HTgcuyjkY4TSvZwQ3IG61YGbTzy6Z6YsKIke1n1BuJ8y6hj
 qTOqGVZMmCdd2D+Wbe74dYbUja3/5r8YhLaDJlexQVv9hpr013e0H0Tlw+QnMGqVwfZzaR28HO8
 Sofs4mXymGMhp0ErR7A==
X-Proofpoint-ORIG-GUID: oatEFZh5mePyT-3RLB7CUNdNDEnq9N98
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070030

On Wed, Oct 07, 2026 at 11:59:38AM +0530, Pradeep P V K wrote:
> Add the init sequence tables and config for the UFS QMP phy found in
> the Glymur SoC.
> 
> Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
> Acked-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
> ---
>  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 99 +++++++++++++++++++++++++++++++++
>  1 file changed, 99 insertions(+)
> 
> +	.offsets		= &qmp_ufs_offsets_v6,

So, is it a PHY using v6 offsets, but v7 registers inside?

> +	.max_supported_gear	= UFS_HS_G5,
> +
> +	.vreg_list		= glymur_ufsphy_vreg_l,
> +	.num_vregs		= ARRAY_SIZE(glymur_ufsphy_vreg_l),
> +	.regs			= ufsphy_v6_regs_layout,

v7

> +};
> +
>  static const struct qmp_phy_cfg milos_ufsphy_cfg = {
>  	.lanes			= 2,
>  

-- 
With best wishes
Dmitry

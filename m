Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F24204C22
	for <linux-scsi@vger.kernel.org>; Thu, 10 Apr 2025 20:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744315763; cv=none; b=sqoEsxEVrFnamqfbMNJUHgrtbEpfC7b0p7pFQtCRRObrbwaNxFYH7jtpVJW8tU0U+N7nIXpCo/tsS0PRJYy4qGQZ1Nob46Tu1gTlS1gMhPKEgJBxs9JEU1ssNfnmPtfRZP+hGPjIZVaKZiOnSm6lmLofRyUWOJMC7ttPJOTd+fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744315763; c=relaxed/simple;
	bh=768uy86Qlyfv4yQIcxTVg6okW0F9hy6AK6vdWrc6x3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QI2XJ1IFoECPZKW+/WNo8DUA7ipzQ8zj5LAnI+mRXc9umRkCc+gyX39HV+/OhpIcTlF485Omk0ODDEU9j3AXtAAVoj6cjHH4Y5rrl/LlfG2OEHNHLXTwBRNsHu3rIRJqBdDz5YgAACMbYMXuDvYgDA1uqDpINQEOTGclsyTe6og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GOxUIxeC; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GOxUIxeC"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53AFt5dw019629
	for <linux-scsi@vger.kernel.org>; Thu, 10 Apr 2025 20:09:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=cCEd/9oYHxkcPEhimIejZIIz
	IOlQjiZILHCRW9pgvQ8=; b=GOxUIxeCP78CiPRcfisEbENewWDuMHZq6XcltgHA
	d1kAL7kZh3/qIKpTTd+Og7m9+1GQwUA8COfStq+eEOuOSJVzWxqiwMRYi7/NPSP9
	bay2buJge4u3LX/4G8DotnrSiWHfCwT4jkz8WIGeiXLC7RsmAiNm+7ra+BfjKIrF
	edRyGPmHBvrc5mD4mEg0wIx+TbCewNLZ6U6a+6oKPn2L4xWSOSPifP4y/59Whjds
	x1ZJNwecA/qG5SyWDN2Kmz2hIJ3RfL/fmC6H3IVz8TxldL56FSHUNo1SjmXA3zqj
	pcYEwDRFhhvoYQZQzKiotMSU9T2Px4DWUZJLDVvMkEJ/zw==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45twcrrcec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 10 Apr 2025 20:09:20 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c791987cf6so264824585a.0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Apr 2025 13:09:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744315760; x=1744920560;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cCEd/9oYHxkcPEhimIejZIIzIOlQjiZILHCRW9pgvQ8=;
        b=fx9EU7tHuS2bQAHECag610VuZtXMNchwoie/JVhhqWoXfGIg6Ifnos9/rA/F78zqit
         T8nfT8VnECVC91d1zPSHG/y50vGO0FfjfeooVvzYWz6oetnj9roK1E6VMLF5vAz63JBz
         YnyYSZ2ueZA3Wp+qexHKbB/70rRHfNlZJNQWuebqUZRiGmkbcL+Jk/t7An4PviZAu3K6
         8ywuTy4cLAxVcPhvoSucEH4zPT2x9MUrVOpmEMx4d10yckfdH5UgfzVr6I/flNp+h+EA
         rm1zhFbO5HS8VGVLh3V2PVxiuzYkQPZvYMoNjBiyS7F7pkpvAABlGIB/Mfk+nvIhExgP
         5NEA==
X-Forwarded-Encrypted: i=1; AJvYcCUhXDmJlh2UDaW9B4EH6Kg7dobl8Fw9pM5W6lDuoOHHZhcOGH++cO1rGePYNJQ5DnZ9Ckv+hwFdtXfu@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9nPy5ZwAqAWIDe5PIVphnc2k2zBhO7QPh+4Kv9kH9fg3LC0c9
	Z2NdXbG9FkQaR1E5x2h4mYp74KrE1Ib4ZgtQCK6ePihRCzR0I8jMdvslgh+z85VPc84hyLCMjlR
	6v/05RC3m/MLhGK04ksePhJkAWNnbwm8z1TpbIbBCFQVsrwVfz6d8sr0UHnQh
X-Gm-Gg: ASbGnctbv0UazqIHdXlAF+cyZt/Z5UEmacambxczTRfEMqxISSErkAXuh1FhutUNaaR
	ZZv6kcc5dzsULL8TcZ3d74S6JDaldFBnfs0rXrEWZ0NwlhhqskkCj0QxsPMU61M0C030t9UBlh+
	mQIFd9vpIxOhjH8+bFPaF4NfNaJrKpOnmkwex2A8tivShfhfn8wHRN+3vR+xLUbEZmHh1UW3hZB
	oz6WBEoM4NEKHkCBQd0Kvcs3lC2bc6Wummr+jr7Nanan0ZXpoBa6qrzCmXYOd2FCyzGSg4X0es3
	2aZJlbptk+LE7Z90GLcPfv5ziyosvR0GxUmYTmCZgKvn19S+7bwunddkRFAF7842cZrcb9wT47Q
	=
X-Received: by 2002:a05:620a:25c8:b0:7c5:48bc:8c77 with SMTP id af79cd13be357-7c7af0f7486mr42170285a.12.1744315759738;
        Thu, 10 Apr 2025 13:09:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFF5PL1gguzYgueXqfskPS3BDB/9kZoEF+bGl5gtL5TFWlHZx9cNMm6owbgOWc0ZWNJJpiKOw==
X-Received: by 2002:a05:620a:25c8:b0:7c5:48bc:8c77 with SMTP id af79cd13be357-7c7af0f7486mr42165785a.12.1744315759322;
        Thu, 10 Apr 2025 13:09:19 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54d3d238b8bsm233238e87.88.2025.04.10.13.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Apr 2025 13:09:18 -0700 (PDT)
Date: Thu, 10 Apr 2025 23:09:16 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: vkoul@kernel.org, kishon@kernel.org, manivannan.sadhasivam@linaro.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        bvanassche@acm.org, bjorande@quicinc.com, neil.armstrong@linaro.org,
        konrad.dybcio@oss.qualcomm.com, quic_rdwivedi@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V3 5/9] phy: qcom-qmp-ufs: Remove qmp_ufs_com_init()
Message-ID: <zvc3gf7mek7u46wlcrjak3j2hihj4vfgdwpdzjhvnxxowuyvsr@hlra5bmz5ign>
References: <20250410090102.20781-1-quic_nitirawa@quicinc.com>
 <20250410090102.20781-6-quic_nitirawa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410090102.20781-6-quic_nitirawa@quicinc.com>
X-Proofpoint-ORIG-GUID: 2qE6WpUptorS0xcDPhsxF6lgIl6ziIM1
X-Authority-Analysis: v=2.4 cv=QuVe3Uyd c=1 sm=1 tr=0 ts=67f82570 cx=c_pps a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=XR8D0OoHHMoA:10 a=COk6AnOGAAAA:8 a=U4jezyStByDUBB0whBUA:9 a=CjuIK1q_8ugA:10 a=PEH46H7Ffwr30OY-TuGO:22
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: 2qE6WpUptorS0xcDPhsxF6lgIl6ziIM1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-10_06,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501
 clxscore=1015 phishscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504100145

On Thu, Apr 10, 2025 at 02:30:58PM +0530, Nitin Rawat wrote:
> Simplify the qcom ufs phy driver by inlining qmp_ufs_com_init() into
> qmp_ufs_power_on(). This change removes unnecessary function calls and
> ensures that the initialization logic is directly within the power-on
> routine, maintaining the same functionality.

Which problem is this patch trying to solve?

> 
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> ---
>  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 44 ++++++++++---------------
>  1 file changed, 18 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> index 12dad28cc1bd..2cc819089d71 100644
> --- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> @@ -1757,31 +1757,6 @@ static void qmp_ufs_init_registers(struct qmp_ufs *qmp, const struct qmp_phy_cfg
>  	qmp_ufs_init_all(qmp, &cfg->tbls_hs_b);
>  }
> 
> -static int qmp_ufs_com_init(struct qmp_ufs *qmp)
> -{
> -	const struct qmp_phy_cfg *cfg = qmp->cfg;
> -	void __iomem *pcs = qmp->pcs;
> -	int ret;
> -
> -	ret = regulator_bulk_enable(cfg->num_vregs, qmp->vregs);
> -	if (ret) {
> -		dev_err(qmp->dev, "failed to enable regulators, err=%d\n", ret);
> -		return ret;
> -	}
> -
> -	ret = clk_bulk_prepare_enable(qmp->num_clks, qmp->clks);
> -	if (ret)
> -		goto err_disable_regulators;
> -
> -	qphy_setbits(pcs, cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL], SW_PWRDN);
> -
> -	return 0;
> -
> -err_disable_regulators:
> -	regulator_bulk_disable(cfg->num_vregs, qmp->vregs);
> -
> -	return ret;
> -}
> 
>  static int qmp_ufs_com_exit(struct qmp_ufs *qmp)
>  {
> @@ -1799,10 +1774,27 @@ static int qmp_ufs_com_exit(struct qmp_ufs *qmp)
>  static int qmp_ufs_power_on(struct phy *phy)
>  {
>  	struct qmp_ufs *qmp = phy_get_drvdata(phy);
> +	const struct qmp_phy_cfg *cfg = qmp->cfg;
> +	void __iomem *pcs = qmp->pcs;
>  	int ret;
> +
>  	dev_vdbg(qmp->dev, "Initializing QMP phy\n");
> 
> -	ret = qmp_ufs_com_init(qmp);
> +	ret = regulator_bulk_enable(cfg->num_vregs, qmp->vregs);
> +	if (ret) {
> +		dev_err(qmp->dev, "failed to enable regulators, err=%d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = clk_bulk_prepare_enable(qmp->num_clks, qmp->clks);
> +	if (ret)
> +		goto err_disable_regulators;
> +
> +	qphy_setbits(pcs, cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL], SW_PWRDN);
> +	return 0;
> +
> +err_disable_regulators:
> +	regulator_bulk_disable(cfg->num_vregs, qmp->vregs);
>  	return ret;
>  }
> 
> --
> 2.48.1
> 

-- 
With best wishes
Dmitry

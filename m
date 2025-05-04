Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A98014900B
	for <linux-scsi@vger.kernel.org>; Sun,  4 May 2025 15:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746373070; cv=none; b=jctIrSJXsVWiEgBW1SSLit+0F5f8Mc7+414wMVfrF2lOBEuYvPgONmj+4V7ZOsnRSw19Ew800irQfQPT6wLaTxsRzDmMnFWLfrkLhtRCu6q17O3s2wESMT5S93dEmLDm/83Bokn75RL1eN//NfOHwDqbKMnKJuHjObEL7LOA5nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746373070; c=relaxed/simple;
	bh=R2xutr1iGnl0AlRF1VlT1gNU2BcrsrOnuHKMneK4Z10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i0N7YaJu7W2td9aOGVguHyC4tEZu42eb/BwMSKFyDqibQf99SUaszZjwuFEdcCOkgC+jjBqc3MbnyCPn59HLcuqFPeqn7PjfNe/tElDq2S8d2IxcLPGRkzRVW7ew2GHDGU74TRSDU2ufU/Mj1eg0K9y0tTa+RBzyJB5y5RH1S7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=aZN6DvX1; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="aZN6DvX1"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 544Dp3de006327
	for <linux-scsi@vger.kernel.org>; Sun, 4 May 2025 15:37:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=8J8bGYOZSSA8D5P45JYX64wP
	eN7udZjhNxZL/UmjYmI=; b=aZN6DvX1jDnCqpajUand/dpLN4Nl9CO92sapqSN+
	wj0OTPmz13n7k1RmnImj+ea64rVUJmBW4tX9KNxraW/C/zIlqYqNxz/YTPMmwhLS
	HNzpeBDN/abDm0GUWQKVe4+5sF6p7KGFbMvkg0F5Fz8YJJuq7vXohAAKZZb1FmoY
	cIDKBg8oiavceAUxaJfPtrN792CLpPq0ipNaNMBi+5kI9OENOcSFnIqZJGz3swYl
	CXUpot1UOaCvIQswPl3Nip1WUnao5+10EpKk5y0YERjb13oed72sk+hsBuBv145V
	L+RVxFV8Hvi+OGniFZ5F6QjE/zv9sAh7iDqmU4ugPqjgcQ==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46dbc5a52h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sun, 04 May 2025 15:37:47 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c790dc38b4so659293085a.0
        for <linux-scsi@vger.kernel.org>; Sun, 04 May 2025 08:37:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746373066; x=1746977866;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8J8bGYOZSSA8D5P45JYX64wPeN7udZjhNxZL/UmjYmI=;
        b=GKE2BFkQyXPGhfHTS3P6VEDqt9KQxIuHnaiWIOx2HPeNfFPOfdbX2XlZk9IOQv9WPD
         syRmm1j8wNEVTSNBmpMaK3zZ6T6Ejnld1K02TjwCAZS6eLHSB10dRMECMjtNcLqyBwmb
         wezAFyrmG9U60WGmzrXtxLJobI3/UCZeASMn4BHH+07KhK/cKkmuesRix45L8I4tNhkF
         QT16rDcmqeZNZTn//AECb0R3L7mJDzkGhuZ6F0j9dT01yDS7G7GzkFiYQVd7xoUF0/tV
         WkHx2mLhA/Qs6Gvxr7bgHVNrqW0yPMvTg9/9dd5RLjwOJH4x6O3FCrhQQb4UlyCvGJHJ
         Ichw==
X-Forwarded-Encrypted: i=1; AJvYcCV5N/jhD7yJE+6sV6k/pzIOo0PKAJdCaPh8oQLu9+ue8zuVJIrcmjHxUzmV/G8M8zG6W1NFLVpGKmrR@vger.kernel.org
X-Gm-Message-State: AOJu0YxbxYfSCpMXZY+7Bniv2KjpowGRrC7bkPR6+rpyZzWIzJB4VKSy
	plulp2SgJ2C2qK0ppneT6nm9Xkyb7WAom84L3WmF6F8oChM+FIePfTJro7BwVZpzqNbOrs/LUbd
	jXBdz/imO4+t/ezeEuX+R+XtdCKiJnXjq/IVTaJD1IUePgoubLrOyTMqSHq63
X-Gm-Gg: ASbGncuFIPkilaqrqo/efcrSmANtw/cIDw+cxgqsXx8ORh0bPDXTSMjdLquBEY75oSR
	nt16VbtHchchOd45H0NcZIljRwmuOgd1sYtY6fRmxo+c4VW715wkS749hAxMw7EnG3+Fz/WX5yI
	WR8olGuEve2hioTsCX2HWxsDk/V0poAZ4D2AZjyBwEcEoi+mHiKRGwhF8rdfN8gfKTwnXGVzPBO
	m19I1z/Ooxyj0o9xvW14cXPzOuHZ0EeU2WnQjCFmpW5JemvPjpTEnXbx5Jdv1lj6xsDcDrNrwxf
	aQZ9r/kxXqaSVEfUlvBwob1plnt7Cx8hGgiGCQn1y4UQkD9RbaHvw8yB4xqxGH216hsuNGkcOs4
	=
X-Received: by 2002:a05:620a:414c:b0:7c2:3f1f:1a15 with SMTP id af79cd13be357-7cace99ed1emr1939685185a.8.1746373065984;
        Sun, 04 May 2025 08:37:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKu/YOLUixhsllPZMz10hB6tnLnnl75sQCaZlpL0pB9iFUtQTIQ1rLugPO1WNiOnmuvG6ZBQ==
X-Received: by 2002:a05:620a:414c:b0:7c2:3f1f:1a15 with SMTP id af79cd13be357-7cace99ed1emr1939682985a.8.1746373065636;
        Sun, 04 May 2025 08:37:45 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54ea94ee087sm1285876e87.147.2025.05.04.08.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 08:37:44 -0700 (PDT)
Date: Sun, 4 May 2025 18:37:41 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: vkoul@kernel.org, kishon@kernel.org, manivannan.sadhasivam@linaro.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        bvanassche@acm.org, andersson@kernel.org, neil.armstrong@linaro.org,
        konrad.dybcio@oss.qualcomm.com, quic_rdwivedi@quicinc.com,
        quic_cang@quicinc.com, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V4 06/11] phy: qcom-qmp-ufs: Rename qmp_ufs_power_off
Message-ID: <prbe2guxzsea6aqonf32m44zp6oa3vzdf5ieazcontv4fmx3d3@2r4tu5nr2k4x>
References: <20250503162440.2954-1-quic_nitirawa@quicinc.com>
 <20250503162440.2954-7-quic_nitirawa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250503162440.2954-7-quic_nitirawa@quicinc.com>
X-Proofpoint-GUID: -brt2O6_0K6mEpigSgeh5fbq-5ZLyICJ
X-Authority-Analysis: v=2.4 cv=O7Y5vA9W c=1 sm=1 tr=0 ts=681789cb cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=dt9VzEwgFbYA:10 a=COk6AnOGAAAA:8 a=xXtjh3xWv7Xu3w3lKiEA:9 a=CjuIK1q_8ugA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: -brt2O6_0K6mEpigSgeh5fbq-5ZLyICJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA0MDE0NyBTYWx0ZWRfX+bajNHLCfnSS
 JPPEd825XKRzFKRvNWnTaP3nt4pn1Fb82ygED/48Q9JV4fAjEFep7G3NLzd8IqraNMwiHTJ84cP
 MVETSQvKi055BZMD3A4a2hP5cWOtT58BzcNpAgUDAkjpezrrvtb9Z+MOBK2hMVMk1JXN1Hc+oJS
 yPeHcRhwTlqgNaP/RqT1cqPko1ddmIAFPMzrLAiexEe8dXYqlUCyki7iS3aHDW1/6qxC73JytT5
 VlBOG+XvNLbQt716UKWHtxl+djcgsNsWD4lGGmwfm2b2XdRXr61BTxOb7RCz/+0ipmgY1L+Qjxk
 W8P7peMuiqN2dMmzSTulG59YijrUi18QMwsCBnSvjNVCENWMxFzsUX+uoWRk2La1hjQBmlp3k1K
 a8/3NoJyTeGAypkLH6OCXZePcD1iCEcg6LAimuNEGsVbzD1UUURIyjimsljti7UJG1uNyuLH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-04_06,2025-04-30_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 phishscore=0 bulkscore=0
 impostorscore=0 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2505040147

On Sat, May 03, 2025 at 09:54:35PM +0530, Nitin Rawat wrote:
> Rename qmp_ufs_disable to qmp_ufs_power_off to better represent its
> functionality. Additionally, move the qmp_ufs_exit() call inside
> qmp_ufs_power_off to preserve the functionality of .power_off.
> 
> There is no functional change.
> 
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> ---
>  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 30 +++++++++----------------
>  1 file changed, 11 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> index 94095393148c..c501223fc5f9 100644
> --- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> @@ -1835,6 +1835,15 @@ static int qmp_ufs_phy_calibrate(struct phy *phy)
>  	return 0;
>  }
> 
> +static int qmp_ufs_exit(struct phy *phy)
> +{
> +	struct qmp_ufs *qmp = phy_get_drvdata(phy);
> +
> +	qmp_ufs_com_exit(qmp);

Just inline it, unless you have any other plans.

> +
> +	return 0;
> +}
> +
>  static int qmp_ufs_power_off(struct phy *phy)
>  {
>  	struct qmp_ufs *qmp = phy_get_drvdata(phy);
> @@ -1851,28 +1860,11 @@ static int qmp_ufs_power_off(struct phy *phy)
>  	qphy_clrbits(qmp->pcs, cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL],
>  			SW_PWRDN);
> 
> -	return 0;
> -}
> -
> -static int qmp_ufs_exit(struct phy *phy)
> -{
> -	struct qmp_ufs *qmp = phy_get_drvdata(phy);
> -
> -	qmp_ufs_com_exit(qmp);
> +	qmp_ufs_exit(phy);
> 
>  	return 0;
>  }
> 
> -static int qmp_ufs_disable(struct phy *phy)
> -{
> -	int ret;
> -
> -	ret = qmp_ufs_power_off(phy);
> -	if (ret)
> -		return ret;
> -	return qmp_ufs_exit(phy);
> -}
> -
>  static int qmp_ufs_set_mode(struct phy *phy, enum phy_mode mode, int submode)
>  {
>  	struct qmp_ufs *qmp = phy_get_drvdata(phy);
> @@ -1921,7 +1913,7 @@ static int qmp_ufs_phy_init(struct phy *phy)
>  static const struct phy_ops qcom_qmp_ufs_phy_ops = {
>  	.init		= qmp_ufs_phy_init,
>  	.power_on	= qmp_ufs_power_on,
> -	.power_off	= qmp_ufs_disable,
> +	.power_off	= qmp_ufs_power_off,
>  	.calibrate	= qmp_ufs_phy_calibrate,
>  	.set_mode	= qmp_ufs_set_mode,
>  	.owner		= THIS_MODULE,
> --
> 2.48.1
> 

-- 
With best wishes
Dmitry

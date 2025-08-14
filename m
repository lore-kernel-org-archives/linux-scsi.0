Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEC025F7A9
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 09:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755162648; cv=none; b=msqNDE3YXlQOd758f5ttt/hvHNXrgF3brqJdzuKM4gykyltu4zXMQb/3hE/u/DsRoWYhkn4VoxRFcwdqFVDt3jISdXwRTul8jnEqEZ6HL/r/JSiNFrYiijTQMwmALiyzXSEc3nrn2+w7Y+hf4E5mdb9NKFSbo8s+uokTy2z7Rqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755162648; c=relaxed/simple;
	bh=tAda8lFFp65pOgTZMvtNSBa945TWBHuTFcLf76W4S4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CTm6iwIdmnJ20wNZl3BI1qMWxE7FjS9oLcZBIe3VbkO3vOmbfMqaMpDPNnHPKBSq3Urc0CNsFqclYjaKeKMgGZVfni484jEsyos7mhxjEleEipubL2I+kdS9k2t9K3Tsji15my53JBJ7U/WUvegy1n0vqPkUU25gUJF6ExaAkqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=InC+QDjJ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="InC+QDjJ"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DN34Da013514
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 09:10:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	t+CK8QBatZxbpeMJRWD+G2VTJdLA1+wNankRYjHTL/I=; b=InC+QDjJwbq+Uy/4
	UEqPy0MgK7Cjtba+GEAfNXm2UHs8WsqsqFBVRuHFCp6OXdtx97zPfLMygvGH11aP
	Hgh28fm0zus87L22fzYY2r+mwmFHbazdcmNKD93LgQGzZ4k/+eaJQsO4JZB2aNpt
	VQykQTySf8sfy4F+ZwBdC2ekeFP9fEJAAcMLzw8FLfUW6CeOqZzSRQVXVp7Mz+ES
	TU+KW83IsJXBKV8y7f96fY2k18yd0oyNMfcoT5VT1D+fA1+mDWVVjEHkh9nnG2j9
	LrQgkL4FWx3LKfTzDzeYGngigfLomrmSXNEqCuBuxJ/Zf71T5t+/gU2K/8M700MN
	stUbNA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48eqhxd873-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 09:10:46 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7e87068f8b0so19633785a.3
        for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 02:10:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755162645; x=1755767445;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t+CK8QBatZxbpeMJRWD+G2VTJdLA1+wNankRYjHTL/I=;
        b=agoi2VHvQt7DF4XW6kqODtB4Clu1b+HrKTWacHZmbv4geg2wtNFcoD/jPahKK3KsSY
         /s5SyUprII9lx1geoVFnPGs3IUz/ajFikSfAqHRnllgZZGV+1VbiQcQey0axomujXtJT
         L2qvkWXzBcaR5UOF1xM9dfPM49t+NdrUALx7YzlFvPX59tuWLx+ERd/1Zi0/DcocgZij
         FgTaveMwxyaaLmHOfYFco9yewxctIcWXYvdALkpm7Q4TsrTeb9DepForM8QEgg51HDw8
         GHby59vMqWP0lhZW8UuNvt06mYuRBuP9rxQOodE0DH9sdUZ3SV3FU/G5d5ElXC/oaTqj
         pBCA==
X-Forwarded-Encrypted: i=1; AJvYcCWVCrIttaHkFeGHyp7tlbsqfSs530dkWiw1KsIYd7KTp5pxgCNHDVtuwjp5c3z5/+t5XBdQC3+cvD/R@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6TWGNf+h1OnFg4Jlg6W6QVQ5PReAYJTC1TGD7L3LeLVr495p0
	8+bfite3Z6QIpPkmRwj+EYzZfYkZ/hChKAVd3VCGUV3uAW6tt8Vqc0q9KckICTSlr7aBERFycj+
	aH3Yvh1vxf6capL/9nrWUEIp/7ZiXODBr7XFZMyh9GhKa5piFbsLXlr16EdXqb4Ib
X-Gm-Gg: ASbGncsiir2nX5V4b8RCrRcoom54WbfVDC/5gkZGRlWt4b2s6UWuBC7HZoDTyo+N538
	ZlsnLgTOKcHJy4//X+J7PPotrzbVUKRrYPS5xSeBd/QLgbtiU0GnFck3AIqap1gnprje7JbIiYN
	FDj8On47Bc0ynL9Jhjn5bmWeSkItunAkCBUC3xutFseN3bppkS0nnMQvWlaBSna8Il3WgSWklT6
	YFTrmzFkFk1PkRdHv8RnOlSjV/oOo8PXk8tB9viGItuzg7quQAb8Fqq6GBhm36oEw8AvScca/9U
	YopD0IPSeTIfWST1hUCw+e216z2nPvSIjKpu/yQhG3XIWl8udTZAD3X22ZZaOEtOINAO/XD5fBW
	xxyyj7MTqpondOozA8Q==
X-Received: by 2002:a05:620a:17a7:b0:7e6:3c4f:fff with SMTP id af79cd13be357-7e8702ff7d0mr181122185a.3.1755162645188;
        Thu, 14 Aug 2025 02:10:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFn35nVFpbW4SQ7GGUjk0NbSwr7QNZskeA5TBdBYhzOrCzf4UEpISooyNIg4+oLGOSan0/jPw==
X-Received: by 2002:a05:620a:17a7:b0:7e6:3c4f:fff with SMTP id af79cd13be357-7e8702ff7d0mr181121085a.3.1755162644705;
        Thu, 14 Aug 2025 02:10:44 -0700 (PDT)
Received: from [192.168.43.16] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a0df2e4sm2547262966b.62.2025.08.14.02.10.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Aug 2025 02:10:44 -0700 (PDT)
Message-ID: <330ba090-8036-4451-a74a-9055a811b2c4@oss.qualcomm.com>
Date: Thu, 14 Aug 2025 11:10:42 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -v4] ufs: ufs-qcom: Align programming sequence of Shared
 ICE for UFS controller v5
To: Palash Kambar <quic_pkambar@quicinc.com>, mani@kernel.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, quic_nitirawa@quicinc.com
References: <20250814065830.3393237-1-quic_pkambar@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250814065830.3393237-1-quic_pkambar@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEwMDA1NyBTYWx0ZWRfX+r8L1/Y20xxH
 palDbSpUpcLEUvbUfYd0fu84rEqWwEQz/xRLQ14Zk9wndYaAJPKMuO+m+vh9hvlTjuSWgK9V69R
 hC+3ukXqrKs3CCQS5b6cHFsyI2+UVhqAeqf3AH6pMpISI1eUPvVZnljB9uivDJAhF+f4BYn70uT
 Q8MkkNjzhIG//ObZKyLLhVHL20WnZg1jmuxoQuApspORr6FRu+sj4zm9uMWhSrXP8wjMJevWymt
 j5T88+5D/k8UysD0aoYqjlti4uZVFLQn5KeGgZy03cL8oZIt+GFeHqPPPLPda7LnuPZJOLHRdEh
 DHJpbfMFo632kUDSO+cbedyn80NYw6rtDSuQTKidWRpqTVEh9d3CX/urzHUcaCNzL7gVEETBesH
 eZ1Uhgww
X-Proofpoint-GUID: wVj9YN7VcO8CeMS2w6KTBfROtMO_PgNx
X-Authority-Analysis: v=2.4 cv=aYNhnQot c=1 sm=1 tr=0 ts=689da816 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=COk6AnOGAAAA:8 a=Nfjzny0KhGhuxlGztiQA:9
 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: wVj9YN7VcO8CeMS2w6KTBfROtMO_PgNx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_02,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 priorityscore=1501 suspectscore=0 phishscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508100057

On 8/14/25 8:58 AM, Palash Kambar wrote:
> Disabling the AES core in Shared ICE is not supported during power
> collapse for UFS Host Controller v5.0, which may lead to data errors
> after Hibern8 exit. To comply with hardware programming guidelines
> and avoid this issue, issue a sync reset to ICE upon power collapse
> exit.
> 
> Hence follow below steps to reset the ICE upon exiting power collapse
> and align with Hw programming guide.
> 
> a. Assert the ICE sync reset by setting both SYNC_RST_SEL and
>    SYNC_RST_SW bits in UFS_MEM_ICE_CFG
> b. Deassert the reset by clearing SYNC_RST_SW in  UFS_MEM_ICE_CFG
> 
> Signed-off-by: Palash Kambar <quic_pkambar@quicinc.com>
> 
> ---
> changes from V1:
> 1) Incorporated feedback from Konrad and Manivannan by adding a delay
>    between ICE reset assertion and deassertion.
> 2) Removed magic numbers and replaced them with meaningful constants.
> 
> changes from V2:
> 1) Addressed Manivannan's comment and moved change to ufs_qcom_resume.
> 
> changes from V3:
> 1) Addressed Manivannan's comments and added bit field values and
>    updated patch description.
> ---
>  drivers/ufs/host/ufs-qcom.c | 19 +++++++++++++++++++
>  drivers/ufs/host/ufs-qcom.h |  2 +-
>  2 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 444a09265ded..9195a5c695a5 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -38,6 +38,9 @@
>  #define DEEMPHASIS_3_5_dB	0x04
>  #define NO_DEEMPHASIS		0x0
>  
> +#define UFS_ICE_SYNC_RST_SEL	BIT(3)
> +#define UFS_ICE_SYNC_RST_SW	BIT(4)
> +
>  enum {
>  	TSTBUS_UAWM,
>  	TSTBUS_UARM,
> @@ -756,6 +759,22 @@ static int ufs_qcom_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  	if (err)
>  		return err;
>  
> +	if ((!ufs_qcom_is_link_active(hba)) &&
> +	    host->hw_ver.major == 5 &&
> +	    host->hw_ver.minor == 0 &&
> +	    host->hw_ver.step == 0) {
> +		ufshcd_writel(hba, UFS_ICE_SYNC_RST_SEL | UFS_ICE_SYNC_RST_SW, UFS_MEM_ICE_CFG);
> +		ufshcd_readl(hba, UFS_MEM_ICE_CFG);
> +		/*
> +		 * HW documentation doesn't recommend any delay between the
> +		 * reset set and clear. But we are enforcing an arbitrary delay
> +		 * to give flops enough time to settle in.
> +		 */
> +		usleep_range(50, 100);
> +		ufshcd_writel(hba, UFS_ICE_SYNC_RST_SEL, UFS_MEM_ICE_CFG);

This was supposed to be '0', IIRC

Konrad

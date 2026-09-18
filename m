Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6DA3A9605
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 01:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789696315; cv=none; b=IVksvQUX3sYoVxdxDI2e7C2n97vQ1n+MqOCZQyrwfkd0AyhUjVuOg2p4uxoDEBRJI7NW7AP/Dxx6joKj8gUGHV14Uz4UtiU9imaIeg8e/Jbc9QX33GwaVzHzw1urJavmHXqDKu26KumNfN/6zJ/s/5RrdSBKX8HDDczJUZanTAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789696315; c=relaxed/simple;
	bh=3c+nv848NmVJd7OUKmVMGg3kEWCy3PSpBAgBNRWZ14Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fohfkJqBY39ujqzdrwBSSzlSfgCdB3yxUlBJKXxZz8CIZkY5RYJLmTAW/UjtjnGlwzH5L07h2b0N/8wmQ1JOvjNrlenLEm0o6fkJa61uDBMJudYRcInjt3R0zDYwAYVMLnpKOLjkFCL5cONbvphgCVYNXIBvx1e7JK1Gvr5Nxlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=h3oZ37LW; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=O0Q41X42; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="h3oZ37LW";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="O0Q41X42"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68I03Q4e144750
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 01:51:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=rHvTaHGzNKtmeUXQ4P4l1GCA
	zOO5LpjiZrRVPNQZEoQ=; b=h3oZ37LWsyB/K/wcoHV4OYOSe8pGt2rcKJHTmvro
	GSzmxrqNfkNjWLgnEr1y3/2fHkj8TVs5skSys1Wrzray/NnOjKONUHglnMoaUYfU
	vpMVKbHDKbckWm71wUbfqNB+DvUK7lsxTKzem5eMtOGC80G3j5P7lbMvK8V1z0kL
	P5s1XLaXSzJUyGg+AKe5vcj+AaWFfvoKZ/PJF91UwblF6ps45k9O+Gsip/sSyg4q
	kudcMYbyxynNrsy1uL+DtxF9gMchCP14eeewcG592v5FYixF0qLier/XC9amiY+S
	wDUPJqElHEBYrXHYlb0bXF67BVuNd2PpkrFR7b0cMqoMNA==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4grtdpray8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 01:51:45 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39de1f85cb2so369833a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 18:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789696305; x=1790301105; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rHvTaHGzNKtmeUXQ4P4l1GCAzOO5LpjiZrRVPNQZEoQ=;
        b=O0Q41X42jhN/5T41zqBUvRhO1y2Cyp453KAIxAxhb5/4CK7KtPprSyNMC6d3PooK2k
         yceWiyk2DOxF1WupnY7EcFywFXXTPHFUZraLiuu5EXZnr2FniByfVKN06TACT1bIMywN
         so0x3G5ZGlQFUyHorrWYZubyi+g6633wGxifKRIQEDVza73EEBkijIQECb+cw3aJdQRT
         oe1oTppVaLUmgrHyUzBYURD4wyF4c0jLH4w+InLRFsA0TMhAM1TOi0cCri7FXJ6j6VpL
         y9kWrMgTIIP0nHh3Xb8lnShKHU9qzDY3Aj9aNbf6lcsl//QcMNEMVeISe8Xh3ZHYCJDE
         dHwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789696305; x=1790301105;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rHvTaHGzNKtmeUXQ4P4l1GCAzOO5LpjiZrRVPNQZEoQ=;
        b=sYaCKs4SO7QCG+mNv3RNb/eB7ETea95zfBPG5iMAOvMbpCyZCLyGXjk7UoXrmjekJx
         VcnGm29puDl8hyD6A4ij8/W0XCEWRpJXO1YS4TUVfBqqZPwApswVwk521fMMOPNevyzt
         W791A7gRPqK/UNtTOUI+ldYJEYP1Jhy9XRupkd6thFu/ku3aqHoM1DrejjQ4eTb00QIe
         B+sZjEbMHbrNVOeHWqY1tRWYbkCnuKB+Hso/eHNnO3oPdvD6nhOE1LJ8KVVp37Ra9Prt
         JnCH9cmdSyT2RYCbzma9jR551l8l/DOBNUuKbSW6sbEAjvRCR6ylR9L/hHCKhdQZnq/Y
         qmQQ==
X-Forwarded-Encrypted: i=1; AKwUvByZxgRmXjIwSdWg7rg6j2CM90GNS0KDGWw2erx//1D5CsohipAzkVcZSCTrX8tNYDMjFctC3P/JX8qE@vger.kernel.org
X-Gm-Message-State: AFuF++nWf7qloFdrfV2yG7LgPFpxLyEUY4Jiwu2tKB0Pu0y3pyp06l0G
	jNsWofYUAQpQhJTT7i7fAYyd7tNUFkeFkpUqnYEdrHx8eKmkWGPkrPmOa4Ou4x9kKpTjJ4zqwZj
	wlzFgrsU7rRAMXjVbBUo1fex9shH6fwTdDSmO+eSiWAgveZQ/1YcgqcGbTlyr5TgqmktI9t2k7k
	k=
X-Gm-Gg: AYBFou273hvKKS7jsG9MjDrJqYHxN63JUxgdKqDePz+/eTV016Tz/417auEsMw7RkQB
	qbtBrKI7n7RwaGq/9RyySCCEIi+VuT80MzkYvFJwvi6ZsWd5uAx5hk8I1nGQRDyZQFXeP/XGVH1
	YxghXsU7QeADumHh+oAcSq/8H4TeeL7yfxzyg/USeS2bhJ4tRltl4gAeJwQGLYvAcmWXUE/Fylz
	CjPLtRx4zC8G1VxudVYqnPRDhx9V2KYwQLwG4HMXkSgT2J/XBAJrr+bYjU1st8U9DSXMizhV52z
	/4TTi2IayQX4dS41xIheoJTWIvS1u1rU2FFz5f8u7kaXtHS5pvf49+YffDKogGTJixYpVIJ7ZdB
	y74FxlgGcmnHO6XR6OVdyVGoGJCHGvTB/muuttApHZWw=
X-Received: by 2002:a17:90b:530f:b0:39d:fcbe:c1ae with SMTP id 98e67ed59e1d1-39e54ff2f17mr2019481a91.23.1789696305126;
        Thu, 17 Sep 2026 18:51:45 -0700 (PDT)
X-Received: by 2002:a17:90b:530f:b0:39d:fcbe:c1ae with SMTP id 98e67ed59e1d1-39e54ff2f17mr2019448a91.23.1789696304701;
        Thu, 17 Sep 2026 18:51:44 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144cdfc3df2sm1145837c88.5.2026.09.17.18.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 18:51:44 -0700 (PDT)
Date: Fri, 18 Sep 2026 09:51:39 +0800
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ufs: host: qcom: Enable MCQ support for sa8255p
Message-ID: <aqyZKy1gMnHud4Vy@QCOM-aGQu4IUr3Y>
References: <20260728051104.675088-1-shengchao.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728051104.675088-1-shengchao.guo@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDAyMSBTYWx0ZWRfX6FwqGUsmn53t
 toysll6aNOLqoccWvYy2KQr6oky7+kVxG6eU0w77lmubvPVX/wErjwQjDNG2R/Dj6GUyRbm1zrR
 SZV2qOZL+y8v/b9cKwinsvlUZckNk3Wd4CMuh0YIfKhwMrZvVIr4m9cqs83PJUjBKxnq6OC1/go
 f7nWW1k4ggUAv5Rf6HvG3jjo02Kt8qrg9e5UdtqWRNld3kZuDSFqB1fSmsbptvinG2g08lFCVX5
 /7zUQYYFKKHYbv5bnk3HGzLZjDZcVvwR105muSMyxjB5raUfgGQ4dYxg9QpjptitKTEGy5gR63V
 pdoCzmldC/A65owNFgz2kHsiOFJy6n2hNKgThTXEbsrnpA4hqgcvTSgupROiuBV9baIIgBlShsJ
 HFL6tIw7BtKtADnZibAaroq9nHxQi/gChS6kFDCG0Z9MTvHnRSx8UXG2lldIxpdeSj0UAzB8LTu
 jLlRwRWi/gu1WiA/DdQ==
X-Authority-Analysis: v=2.4 cv=N+e8hG9B c=1 sm=1 tr=0 ts=6aac9931 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=3YqMR8Xo1YLpbCGl9ZwA:9 a=CjuIK1q_8ugA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDAyMSBTYWx0ZWRfX1VH2Xz7NO3wd
 BlJtHQ3nnI+2ev0yHg+KH2i025WBKLTwZp0Y/JMElo2Hd9BZOv1btu5ZTQJ6H/xdUN8i+G6Igxn
 XMWHGB7wP0JqFqhA+GJOr0Nb2NCwIRg=
X-Proofpoint-ORIG-GUID: nesjCMf9ZfEfbRlZkCcKJ_tIAPiD_vKM
X-Proofpoint-GUID: nesjCMf9ZfEfbRlZkCcKJ_tIAPiD_vKM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-17_05,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 clxscore=1011 spamscore=0 adultscore=0 impostorscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180021

On Tue, Jul 28, 2026 at 01:11:04PM +0800, Shawn Guo wrote:
> The sa8255p vops (fw-managed variant) was missing the MCQ hooks, causing
> the driver to silently fall back to SDB mode even when MCQ resource is
> available. Wire up the same MCQ ops used by the standard qcom vops,
> so that MCQ mode works on sa8255p.
> 
> Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>

Hi Martin,

Did you get a chance to look at this change? It still applies to both
mainline and linux-next.

Shawn

> ---
>  drivers/ufs/host/ufs-qcom.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 0500320545c4..d2acbbe647cb 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -2950,6 +2950,11 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_sa8255p_vops = {
>  	.resume                 = ufs_qcom_fw_managed_resume,
>  	.dbg_register_dump      = ufs_qcom_dump_dbg_regs,
>  	.device_reset           = ufs_qcom_fw_managed_device_reset,
> +	.mcq_config_resource	= ufs_qcom_mcq_config_resource,
> +	.get_hba_mac		= ufs_qcom_get_hba_mac,
> +	.op_runtime_config	= ufs_qcom_op_runtime_config,
> +	.get_outstanding_cqs	= ufs_qcom_get_outstanding_cqs,
> +	.config_esi		= ufs_qcom_config_esi,
>  };
>  
>  /**
> -- 
> 2.43.0
> 
> 

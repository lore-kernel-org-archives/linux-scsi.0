Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B82372ABF
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 10:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763633490; cv=none; b=cUVzuXP63Twb1B5l94u9ZapdXMj7kJnbM+q4/YWwuy6dAOatro8weNil/TIMXu3sAuC95tZghga5//kUePdCNAdARDKTCUi2mntGFtYCo9wlxH9WGS6UQH8ZaJvHErOHvDEVTElWQRISmMKBO0e7DBpZHmWlgpK+nQhQ56MidAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763633490; c=relaxed/simple;
	bh=9uLkA4W4IbkFLHv+Okqtj59tjdBFCUhfyKyASqjkUs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JhJqRSgVOtj6JjwqvXfxH99LpBPOvuxDMPb1UB2Ad9c+aWdk03Kcwph5JM2MJl11jMy1qbiSrd7q4kXHL9erw/p2Y81uTwnyskSa1hVCYNoaumXdFC9clUGLmko0IzraKdc/lgB0F/741XZIgmpQhZZPWfGqcOv3NTEUK5X/xtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GUBynf27; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CCFrv5kQ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GUBynf27";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CCFrv5kQ"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AK651FF3927332
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 10:11:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	B2ybP7s2k5iT1i13ZiiSzbeQ5g0IaqgiAvpSa5BJiFA=; b=GUBynf27TzmZgkSS
	fXg5+2EJ/xcBHTwktJJ8Mzsbefx7PNti1oiEVvXEI/B7JKLGhKqLUx40sZob2oBd
	IQ0aVda6ENBt4V7NboH6EB7CV3mW4zg0D8xVS+MZNL5ME+cN1A4gCLKgbmUxGCcZ
	3SAybd19zP0spPNbEbivk0owruYNXZZPNMnfcfu+DNb35GNmSwingM7+RsfxCJSr
	Adqv8nhoe1ISxWuqI+HoNxCMGDb3Xl0NTTiuqsPDgGrqhZytcmt13/tVCWaIE571
	+oRKnDgfgXIVictlWBMXg3HmUel1Tv1ojlndds9mb757PTWN6dU/0pbuwpwaM+5g
	t93Ang==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ahwd78t69-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 10:11:28 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-343daf0f488so715136a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 02:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1763633487; x=1764238287; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=B2ybP7s2k5iT1i13ZiiSzbeQ5g0IaqgiAvpSa5BJiFA=;
        b=CCFrv5kQC+AuDxdDNe5FCo+Y7qwAA7usQ+JZY4rQCiR9WSbvbGuAtlhoM8QmdUfXnL
         QH4p7r0tojLfaOD8l1HAcDzLNd67IqZ6gi485pSj94Bj+28GhibfWsDEIBJTQmAU0QCH
         lpiYkFNcSuW8DzDYyHpnOrxLT5eX1tvYMVqD8kmVmGMjrzORV+YVkHKjL43mHxSx4z19
         FtsO6hzX07g2alhCk22IL5ZNAdzA6iInQWGvQa1HZrxyz5Aohoc7vixSw8bCyq+xfIvl
         Oy+kmUhAwNGWcoWUos93HS27Gv/60ls1RyEvkarzpNMPwPInZhpfZl+BJE+JRCFcrM8X
         PAlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763633487; x=1764238287;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B2ybP7s2k5iT1i13ZiiSzbeQ5g0IaqgiAvpSa5BJiFA=;
        b=NgaBwN+H+TZXIvNMHdU1XJm7upK+tNUEN7LERAXDHso6dgsbQbApdkKVIPIk2M4Wi5
         QFxj1/89K5VVVuMATXFCwp7u8hIuEKAjMOHTv+73SJqZFp9dqnrqjpmxKLPYgaOHZN+1
         demL+0BTRW5Bv1j8NJW2sgdPR2X/HhwZD5u1R46q1c28faR9YW3NaATErCg+FRPPJBAc
         yEHvSCf4JT1OyRwpwdp6JYc9sQUxpdAHhOuz7meteViJ1R7DujuL3zxJTeSTVVJgMJfV
         MDKoYH4amR2hiYzGW/HEuwYVmN8KxWsdwZuzG9yHu0rGxYS/Bs2KM5VAhk9dZzahdy1p
         Uxtg==
X-Forwarded-Encrypted: i=1; AJvYcCWLpMSdZVn6L6ue6NNvqzjffw0G+EUzGjR8uJ5k2qwoYXBXd2qY+pcK+kOXhdX2uma8VvWA64RS0w8l@vger.kernel.org
X-Gm-Message-State: AOJu0YzuLLu+HzUz7/+J8GAcDpYx8+YqbotgBG/eVwXUFAh/aFQ05ABO
	MRTeCQXw0H2Qzmve/m9k2xUZmqlONmC9weixe4g0CBvSAH5FrG8XJzdM6665I062/znkj344lrV
	rs2PhhXCiXcHmsXxbMJr71QtcmYSu09PFIW/OD3qLTVQ+vsK8me8mUU+YyiOsnxQv
X-Gm-Gg: ASbGnctC9SOWAhCq6UrlPndISr1Cyhq9pjKPoWQW9KObMpU6Oul/Aq50WCkGwBbM/kd
	qmITSoPsA7alTnTm0fiQfxVd4YTvdmIi0ASP128CMZiWz/M8yI8xAQLeIVEVFHVaIAzAXbUdEgh
	mFOjijsvXBkBeMMR87o28eidpbndBHfteU1RLIsKyzuyW76VC3bRqHIW6GZiGVCzCIgjammCerG
	2oMATV2PsqjzRv60+kAST8mOc8IyEdPUDw1IFJkWzShBwv7091qcKvZ1JsnRC54aCT9Km3ZEu+o
	S/i76juR3gSk4QohDeJUANu980h+KGRyAcvR12bMTbc2SMxxuDppKSLaIf8YqhJ5B4CHxjFyU3v
	zNCSGB83EtkRzcm86PGFi2yOWwT7DaZAYOsShF7iOlyY9jBs=
X-Received: by 2002:a17:90b:4a02:b0:321:9366:5865 with SMTP id 98e67ed59e1d1-34727d50dcbmr2823445a91.33.1763633487450;
        Thu, 20 Nov 2025 02:11:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGQB+TA/zta5xrTMxfomqaYjsZRa6IblcMZ6IpKSWQ8LQF0xzZ4Li73qO23C4U756cAPhjZYg==
X-Received: by 2002:a17:90b:4a02:b0:321:9366:5865 with SMTP id 98e67ed59e1d1-34727d50dcbmr2823414a91.33.1763633486966;
        Thu, 20 Nov 2025 02:11:26 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-347267a10b2sm2134517a91.5.2025.11.20.02.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 02:11:26 -0800 (PST)
Date: Thu, 20 Nov 2025 15:41:21 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] soc: qcom: ice: enable ICE clock scaling API
Message-ID: <aR7pSQI4ZNvPmqgF@hu-arakshit-hyd.qualcomm.com>
References: <20251001-enable-ufs-ice-clock-scaling-v1-0-ec956160b696@oss.qualcomm.com>
 <20251001-enable-ufs-ice-clock-scaling-v1-1-ec956160b696@oss.qualcomm.com>
 <izxqjidbslfigzf2jiwavtyousmurrwi6c3i5rxsb3npzyaoxz@3prtbcludlqp>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <izxqjidbslfigzf2jiwavtyousmurrwi6c3i5rxsb3npzyaoxz@3prtbcludlqp>
X-Authority-Analysis: v=2.4 cv=Jtf8bc4C c=1 sm=1 tr=0 ts=691ee950 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=fzFDaW2BCt8HcSSa5e0A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: _e_VCRV7v6HYybVLr7fY6Mabh1RGC21r
X-Proofpoint-GUID: _e_VCRV7v6HYybVLr7fY6Mabh1RGC21r
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIwMDA2MSBTYWx0ZWRfX3xynB9sECjWQ
 wpO6TEdaFaYYFoA/l54lD3Anu9P8lgwJXWocPYJ5WvoSGehF2qZlyRyZpv+76xS+rnHJrq6AUek
 qNRMnzgEQhJCQXEn7VvX5uTnQMglwhSo5gLhmfj0iKr94U5EgbsChi86aRQwMCRf3lfU4y8tlj9
 L9OAx0fvuTxug4kmaZHAWXrqOAPNqjF7xPwaY326w1iVRTcB8QG00bVijDNN4q4kOgPKREaIXiJ
 pucN7KOEEgeoHVZrlO5dWASfadfHkRC4mowSkbgAk1zwvjP26Iye/wDsVzkTbDECFJLgM8ZtATi
 W8ediwnwug8cN3RjrNv/Zs8aszWFGn5NSwD39wtk37pxrvRo/J7nb96pzsH/gX011vrflW5DM1e
 8u/R+D3g9Yn/AhAIvhEGR0teuI/R8g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_03,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2511200061

On Fri, Oct 03, 2025 at 10:10:28PM +0530, Manivannan Sadhasivam wrote:
> On Wed, Oct 01, 2025 at 05:08:19PM +0530, Abhinaba Rakshit wrote:
> > Add ICE clock scaling API based on the parsed clk supported
> > frequencies from dt entry.
> > 
> 
> Explain the purpose.
> 
> > Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> > ---
> >  drivers/soc/qcom/ice.c | 25 +++++++++++++++++++++++++
> >  include/soc/qcom/ice.h |  1 +
> >  2 files changed, 26 insertions(+)
> > 
> > diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> > index c467b55b41744ebec0680f5112cc4bb1ba00c513..ec8d6bb9f426deee1038616282176bfc8e5b9ec1 100644
> > --- a/drivers/soc/qcom/ice.c
> > +++ b/drivers/soc/qcom/ice.c
> > @@ -97,6 +97,8 @@ struct qcom_ice {
> >  	struct clk *core_clk;
> >  	bool use_hwkm;
> >  	bool hwkm_init_complete;
> > +	u32 max_freq;
> > +	u32 min_freq;
> >  };
> >  
> >  static bool qcom_ice_check_supported(struct qcom_ice *ice)
> > @@ -514,10 +516,25 @@ int qcom_ice_import_key(struct qcom_ice *ice,
> >  }
> >  EXPORT_SYMBOL_GPL(qcom_ice_import_key);
> >  
> > +int qcom_ice_scale_clk(struct qcom_ice *ice, bool scale_up)
> > +{
> > +	int ret = 0;
> > +
> > +	if (scale_up && ice->max_freq)
> > +		ret = clk_set_rate(ice->core_clk, ice->max_freq);
> > +	else if (!scale_up && ice->min_freq)
> > +		ret = clk_set_rate(ice->core_clk, ice->min_freq);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(qcom_ice_scale_clk);
> > +
> >  static struct qcom_ice *qcom_ice_create(struct device *dev,
> >  					void __iomem *base)
> >  {
> >  	struct qcom_ice *engine;
> > +	const __be32 *prop;
> > +	int len;
> >  
> >  	if (!qcom_scm_is_available())
> >  		return ERR_PTR(-EPROBE_DEFER);
> > @@ -549,6 +566,14 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
> >  	if (IS_ERR(engine->core_clk))
> >  		return ERR_CAST(engine->core_clk);
> >  
> > +	prop = of_get_property(dev->of_node, "freq-table-hz", &len);
> > +	if (!prop || len < 2 * sizeof(uint32_t)) {
> > +		dev_err(dev, "Freq-hz property not found or invalid length\n");
> 
> We have deprecated the 'freq-table-hz' property in favor of
> 'operating-points-v2'. So you should not be using it in new code. Also, throwing
> error in the absence of this property is a no-go.

Sure, will move the soultion using OPP-table in patchset v2.

> 
> - Mani
> 
> -- 
> மணிவண்ணன் சதாசிவம்

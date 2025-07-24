Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA9F2E2F1E
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 14:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753366806; cv=none; b=mVStrTv4Y6+ciznU1CbvzW2vKGkWoEHUcpS2icidTsh2TVJyKbcddaw4yJfBN7nNrNfQbSjCl6bz2Rfmec3xxXnDeciCoy6deduhqBy+t25rAtQaxEgMWQHZ/nvIhEIdijgCjqGrP60YRd4Mr4YpE8Ii4OR+YnN4En1g7SHCUyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753366806; c=relaxed/simple;
	bh=RB0MXSL9iAdyQfhytAVo156s7TbriQQimjTjISxShuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NHp6RjB1BS4Q4Tbo9J4iLLlvdG++n0SUShsP1QvdwLvopFnC0axLcgt2jE/SGdJDXkEbTZU8+U+Wmv8RIzlqAVhHf67ENVvJHhR5wz4r8u9o2ErNnxVkLgxMXEeHUrVzHG3PD4GDecis+sfDzByCuxZclv7ls7g2NOBhxgKZ3OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Xckxuzj6; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Xckxuzj6"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56O6dpdJ028534
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 14:20:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=A+VdurEKUduQkz+MfAKRObdV
	YePeVHPl1wVvZbZgeJc=; b=Xckxuzj6GDcsD/3rzVHt9pBnkZoBD/6fEgbaUWmZ
	7vx1oTdWAS+aSMsCN5L5w3nHLUQzfMNpW8qeh1dk23Y7oR6z2xgwN+CqOndRAaIT
	FF4Ba2X/m53dxzIWPB8wz2SgsXrk+sogtrC2xcqsHKQZKwL+91Q9lXqK7EArbHdo
	nr0A/aEIIu6WEnvqgPzI5BUKP1D43Qm8ByGQ1GzTHSLVgVuwpiak/d4ITYRphyOY
	Z5wTfuQFX948UOU9nFQevWR2ayHkuDYLU0arv/l1zw0eDaEBjUV++XYRykTvmk/R
	FjigUunVkkwXNhBjDRH75Hgsgjmw6/NiNPuTnEvWqLqIkw==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 483frk1awy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 14:20:03 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7e269587d8eso194067085a.3
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 07:20:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753366802; x=1753971602;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A+VdurEKUduQkz+MfAKRObdVYePeVHPl1wVvZbZgeJc=;
        b=jlg4wjVm8voCjOL8MgMorcmw8C6Jr2mbqGTsz06zAkmFcgW9LtdwBT02xYqYJGX43g
         NTLwijUGp2wtwZTPpHUneGbUvmCP4arPya7NXsyJE6oEN6rgi26bD8BrjGdXCDRW1lCd
         ds5XOVxTh6p1TCvKs9E3bPkTlKrXLF/9UTX3nL1r8zE7nSLhCWNGdUUGRePyZ7Ax6IGH
         fTxLlWgIG516Y/oVdUCiwQPwMsXK9FW+ZpqkNBRHkINHS2IoKH+giGIkz90ejBvEEahc
         NyCWHD7CZ7eeBMSfn8qtDacsdG+v35eXgo5/WA6nj4+j9h0ZWdnY4+zuxde+THeQ/nL2
         rZRg==
X-Forwarded-Encrypted: i=1; AJvYcCWtzjS3B+Pkno0aY1nxwoApDFX1NaDAAvAufWb5o2JU5bnZ737QagXAFd2BP8T07VKLw9fH25fvspXN@vger.kernel.org
X-Gm-Message-State: AOJu0YwcMfxqWaDSx+Q5bdKfYhyMcYWQj623MhDhK5KH+MKmrSkBJj6z
	o/2JR3ULlwSJvQL83GSOsjsefdLpEvUPgQ6e5uos2TEaXu5ln227/W9RrSyZhBFNZ4qhOunr2YR
	RKlcaLipdhCqzTY25ddigW6+9+5huyDUe0jgZBcBc2p+nGvm6OmzRm0Q+N7PT84SH
X-Gm-Gg: ASbGncv8Kp4v7QqD6RixpZaqQbEH4T1wtlulZLN1ctgBcJXdq4HBSftzeqmNniGgMYM
	VQutMLoap+bRkA1crzNv2l6dOQLEhxFmM1HmdQg4UXwXdJUlg+AAD39PdJs3AuvcYfnawjyhHdS
	/k9EpR9nLJM+iQjSXOa4Yk9x/Rmr22+EkQfGN+Sh+XafdGVusHVu1xi6CcH0V0I56uRRmPwBzsN
	FzQj0M9DaWBQ+gX08PFGhnl2u0gGj+fs6Ksy6T28YS6bEBG5sAyRQdqsjKjaqyvSbVPT7+ZPRW+
	2zJnxqLLYnfdV640wnEb1Bt/3SAmlj9Q5fCygg1PRCqySX5QOX7Eue+jhuPPmQmgA8wkkMUvnd4
	Ps+/bSTv6+rgwXcgSrKdq1Bb5vWXg4MLgV+9w7TsdPOEmfy20AZDb
X-Received: by 2002:a05:620a:a918:b0:7e3:46da:9e1f with SMTP id af79cd13be357-7e62a226f8emr851538785a.56.1753366801686;
        Thu, 24 Jul 2025 07:20:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEu82FQZpsw4p0HB44p5QHytv3oARhOYGPxT+kbfN/+yl6AMnXI5Y2W/WXRiHc3PGuzslrCdA==
X-Received: by 2002:a05:620a:a918:b0:7e3:46da:9e1f with SMTP id af79cd13be357-7e62a226f8emr851531285a.56.1753366800903;
        Thu, 24 Jul 2025 07:20:00 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a0c3-3a00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a0c3:3a00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b53ca2066sm375867e87.200.2025.07.24.07.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 07:19:59 -0700 (PDT)
Date: Thu, 24 Jul 2025 17:19:56 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Konrad Dybcio <konradybcio@kernel.org>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH] scsi: ufs: qcom: Drop dead compile guard
Message-ID: <33dxc5kf4m2luijisbdzsxof5yi4hhrbsrfziqsbsqzm3xkkad@ivhyl5ozuyc6>
References: <20250724-topic-ufs_compile_check-v1-1-5ba9e99dbd52@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724-topic-ufs_compile_check-v1-1-5ba9e99dbd52@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI0MDEwOSBTYWx0ZWRfX66HUT9vLrSww
 CZiTaBIxwwws1A0TkxF24szF3E+9ggyzGlPRV1W4HmoBnsHn/i/GGZj402j+AG9o2AR/lscIG3K
 lJP+1QOxo1RRqOrOYzx3IIQIP/RX02oRjTU89lAJfCtE5WFMF0iGuLFqErWPLp4G9XM2bbUWeWG
 1Tg/SovsBDLC53bhR1gKf6M34ALCvIHhkABKTcfzr+Mh5YF8BQVGQotusjaxJyYWi3VsjCXir6D
 gUgWU+Fo50IQs007HDt6bAusSe+FwQX33MvWtD9R6rtiQfSpap1ZXiXrZQZF1MuvKz2W1O0QAh4
 Q2nYy9oZwy7rWu++hFYneeJ/0qxw1PLPOWERTw+v/YzgtppwpOTXpC5y+GqwhIpizej1dagpEoX
 p8vzISuouQuR6DCcAGWGuQMbsy0Rmc/GLJMTUfTdtq4Hf3OCyifsUY1NRh7mna2g3V8Ch2Bs
X-Proofpoint-GUID: Mub7M8HXtXPTWshbphMSncrVmPo-1dK0
X-Authority-Analysis: v=2.4 cv=WbsMa1hX c=1 sm=1 tr=0 ts=68824113 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Wb1JkmetP80A:10 a=EUspDBNiAAAA:8 a=Ts7gs6oRpwORAAbGo2kA:9 a=CjuIK1q_8ugA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-ORIG-GUID: Mub7M8HXtXPTWshbphMSncrVmPo-1dK0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_02,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 mlxlogscore=927 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507240109

On Thu, Jul 24, 2025 at 02:23:52PM +0200, Konrad Dybcio wrote:
> From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> 
> SCSI_UFSHCD already selects DEVFREQ_GOV_SIMPLE_ONDEMAND, drop the
> check.
> 
> Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> ---
> Is this something that could be discovered by our existing static
> checkers?
> ---
>  drivers/ufs/host/ufs-qcom.c | 8 --------
>  1 file changed, 8 deletions(-)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>


-- 
With best wishes
Dmitry

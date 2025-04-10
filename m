Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF0C1AA786
	for <linux-scsi@vger.kernel.org>; Thu, 10 Apr 2025 20:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744315571; cv=none; b=K0sl1tFu/7FLsAP7XeYnDwxDBMfV8TwZGALMuC4K4bade1S78auNjpmS4HAEbBTdX4sSZRKN0wW/xv4kVdbwqZXlRUZqwt/JlHiC057RUBAY3xvqVigSpQcQ3Oyih7eRDVwr/LUTn57WVBDUYsqbZ15DEQ8A9zp9shFpwTst/hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744315571; c=relaxed/simple;
	bh=gJ8md7PQ2OiPGQLW9wdP+YLmyzBHezBVypNSfQMRcnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vd9gLhvFZje58eZPyHr7fEJFfCnqhdpKoa9Gq169RaJkKMoOnolPjFaQtCApfFaNqtMseghwLRqlsYHYmouR16YpG1InGhstwsmlWnDxTjBP84mHEpV82bv4dTvoJrgBEsHrrYYITy2OosaoXJtzCIcgCy14vM1TavnhgAdN3kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UIoz9clY; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UIoz9clY"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53AFojGV018349
	for <linux-scsi@vger.kernel.org>; Thu, 10 Apr 2025 20:06:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=TZVLf8DQJOqLTTY5zbwnNMp8
	Hx3tMMxkt8z9vF08gyk=; b=UIoz9clYmvQhAvShfx9ifABIG9qcnSFNb1HUoZOr
	+XXrAaIDteF8LFXNuBT9IOS0s7Ay/lSIy1FppGlB+vAhNem2JVp3uDK+NkaOR7PD
	aQew5ygeYTaeK4Lc7yE5reIfyjuL8lcmM0/bXJXcaEaA1aYLag35VYlTn468yD/J
	hvDLIxJAFMWBnYEjngeqthoX9ZBZw8PcVx7VfEJNVhF0LqUItVALVg/j9Dlb55AC
	8UkIeLMuJ0QGizKhD2V2FrLBJidLP35sYMMeGmr9BXR18bcWyovrwD6TNx72IacC
	nDEkqadARg+d4Ob+CjWfNfrryh/RaDBtQsU5Uuwe5iURsg==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45twtb8au7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 10 Apr 2025 20:06:09 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7c5c77aff78so368069485a.0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Apr 2025 13:06:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744315568; x=1744920368;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TZVLf8DQJOqLTTY5zbwnNMp8Hx3tMMxkt8z9vF08gyk=;
        b=IJRPJIbdFjg29mBItvS2APnfOI6LeK/fCadCeG9rDVCOPsqJVOK0NnUO9wOBOXPt/U
         0KXV03+TI4+5/4zMK9d8ikww8ZmbCy78pLBkt+jWTynTnGn2ycJ8gEODbjDShwYLq61h
         JVl41k7V67OJtf4/GFG2XpvS2PLovLbQnejbK33X9L5E7w1SxfV72f3A6kUE5rQWUT2y
         TgNTvue1VwFGQh3DiAN0ju5kbGJrdVIEf8nKYRdFXus2lMgqk9rCI+gkbenuVy9yYZhO
         W/gYzMFc5EEm8Z0XnDgQllTgXbh5IkMiGWinir2Cjr0kfqgTMWMV5mYvp0ABl14z4zS2
         sInQ==
X-Forwarded-Encrypted: i=1; AJvYcCUM5KnndMbU8//90KlWNLWvz1hRz7lQtskMTDhJ5EW56KJfBE3ksfNuucW+0Ek1p7HyQjvhZFkxlcAj@vger.kernel.org
X-Gm-Message-State: AOJu0YzhuWNIrxlnR+IYFcxTCcDry9GoeOZyMDxBzwutEKGezTFqSM4S
	am2QZbqZ26H/YbPob/s8g0qdxnRabB946nJ3CzxmQL3nhqoeNOYFStPgtmf2hTRvSCIw+OtoWsl
	c9Hkyih4oTc5OJhSvxpsLpJVXb+liXr9tXbPy+/yga4Pd4eo4Rr/UYF2+m2dN
X-Gm-Gg: ASbGncuTuoSmC+/LCP25YxBRZQRXIKnCgYJjnOzWH9/knJDIHqWtvnhuYL/zC1C3o/K
	Rer+zbtFTNQ6U6a9EAv3Y7Ori+zRInvrH1Qfo4x7PErEBNYtS90FSqE0m1YWkwF7w08PSC5T2Yq
	KzKl9JsYIYPq1ZbiqVo8BYAz8KQL4FQoLq2F2Ik6zU1IiBumEyx6TngHNuthgGHORCeHpvQG+/j
	9+aA0PmxbS9NPGERH2gb7zZpRXKpSh8zwx0g9j+B63L0ChRak18Wd754AWglQkDzrIwxTjp/Zjv
	fo/eyHFfUMmsOEO7y/4dioWO5QfuNxPBSU2yrMhFcLBenfllstBYD5NF1dQyf3NWqRzj5oDYFh8
	=
X-Received: by 2002:a05:620a:2585:b0:7c5:53ab:a722 with SMTP id af79cd13be357-7c7af0c1080mr49122385a.5.1744315567831;
        Thu, 10 Apr 2025 13:06:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHyFCAIZv2SoWtCU+S6mL10ZPcuXspL7BYeiCNpGEUGoqpR1wyjch03Yxp8FlSr3X0GqorOTQ==
X-Received: by 2002:a05:620a:2585:b0:7c5:53ab:a722 with SMTP id af79cd13be357-7c7af0c1080mr49118985a.5.1744315567533;
        Thu, 10 Apr 2025 13:06:07 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54d3d2387cbsm232524e87.68.2025.04.10.13.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Apr 2025 13:06:05 -0700 (PDT)
Date: Thu, 10 Apr 2025 23:06:02 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: vkoul@kernel.org, kishon@kernel.org, manivannan.sadhasivam@linaro.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        bvanassche@acm.org, bjorande@quicinc.com, neil.armstrong@linaro.org,
        konrad.dybcio@oss.qualcomm.com, quic_rdwivedi@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Can Guo <quic_cang@quicinc.com>
Subject: Re: [PATCH V3 3/9] phy: qcom-qmp-ufs: Refactor phy_power_on and
 phy_calibrate callbacks
Message-ID: <yswahfclsulxp6zveueauxtizcrzhgegwff4a55aztebgykawn@kwjrt3j5wswd>
References: <20250410090102.20781-1-quic_nitirawa@quicinc.com>
 <20250410090102.20781-4-quic_nitirawa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410090102.20781-4-quic_nitirawa@quicinc.com>
X-Proofpoint-GUID: fWS-tH2KJeel8PE1YUzGMnI-ib2K4GnC
X-Authority-Analysis: v=2.4 cv=LLlmQIW9 c=1 sm=1 tr=0 ts=67f824b1 cx=c_pps a=qKBjSQ1v91RyAK45QCPf5w==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=XR8D0OoHHMoA:10 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=lFQMB9wLRqEjQFf09QYA:9 a=CjuIK1q_8ugA:10
 a=NFOGd7dJGGMPyQGDc5-O:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: fWS-tH2KJeel8PE1YUzGMnI-ib2K4GnC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-10_06,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 malwarescore=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504100146

On Thu, Apr 10, 2025 at 02:30:56PM +0530, Nitin Rawat wrote:
> Commit 052553af6a31 ("ufs/phy: qcom: Refactor to use phy_init call")
> puts enabling regulators & clks, calibrating UFS PHY, starting serdes
> and polling PCS ready status into phy_power_on.
> 
> In Current code regulators enable, clks enable, calibrating UFS PHY,
> start_serdes and polling PCS_ready_status are part of phy_power_on.
> 
> UFS PHY registers are retained after power collapse, meaning calibrating
> UFS PHY, start_serdes and polling PCS_ready_status can be done only when
> hba is powered_on, and not needed every time when phy_power_on is called
> during resume. Hence keep the code which enables PHY's regulators & clks
> in phy_power_on and move the rest steps into phy_calibrate function.
> 
> Refactor the code to retain PHY regulators & clks in phy_power_on and
> move out rest of the code to new phy_calibrate function.
> 
> Also move reset_control_assert to qmp_ufs_phy_calibrate to align
> with Hardware programming guide.
> 
> Co-developed-by: Can Guo <quic_cang@quicinc.com>
> Signed-off-by: Can Guo <quic_cang@quicinc.com>
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> ---
>  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 26 ++++++-------------------
>  1 file changed, 6 insertions(+), 20 deletions(-)
> 

With the cover letter updated to note the dependencies:


Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>


-- 
With best wishes
Dmitry

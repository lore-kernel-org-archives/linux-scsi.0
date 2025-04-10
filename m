Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466102900A4
	for <linux-scsi@vger.kernel.org>; Thu, 10 Apr 2025 20:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744315545; cv=none; b=U0xcwj7U7FUqG/LTCqjuX5gv0PDmeL3QQYFqDRGQ+1IgUBcRDISlrU1DlwTPiy/uOQ1fWUTomAQEeeae2EgWTjjiZsR/6EUVYZWVya1ndUtVRcAijvYFKHRbRBB86Tpk5My9vzEwndghn8sZiHwSTbayJmP2XvcOkVlMs7NwKeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744315545; c=relaxed/simple;
	bh=kE0juyTpiJRFvY3bhCkubK6oqwgvbhtJEpj29J8UYsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eJtE8uenlM+2J6N3nrc5hoaw22mYKWfn9fxU6eNMyrdxy8si3hxb+hZSPB0LVP61OcP/GOQ+u/DyxYa6MqayWNIi+W++V+eriR0bgHuRDKhNOMTSeNuvRrX/sB5f+I+3TR5QDJQsAvIVn/lN9Qb1T8nC9CJS01M0qD/pz9eT/+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IAvcKzSW; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IAvcKzSW"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53AGGxm7030638
	for <linux-scsi@vger.kernel.org>; Thu, 10 Apr 2025 20:05:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=TXfF9vM+BoIBd/qesq5gNZSO
	9HgKKIqscZ8pGO8kuqM=; b=IAvcKzSWfZBOeARWfvOqiUotdPXWOaEavfq48bcu
	swGb2WHJy0XVTswakGO7TB8Y5YurgV5MqfYNZWaKeO2bHSXB61bGxbZAWFJwKSni
	12xSCl9zI8WAs6X3dfXoB2LTJyRQAECKchgOtghHzMu6a3sd2pfbIh4jkoRrwaRO
	mI2yFmw1TUikbGaNo+8SDHD1CisIXAy3RA5hs3rXL0XFHrV/kTDcwOZ2V0PglAFh
	nM1MH3X8TChqnMWmCne+6B/JUYWeGqiiIyhIiYMaYnQ//9Mzlkt9tOcwBJWoCbq9
	dHCgm8fGQxgZev94yn45I0mTzHSCKmMftZyp2fhKY+3dTA==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45twftr083-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 10 Apr 2025 20:05:43 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c3c8f8ab79so224480585a.2
        for <linux-scsi@vger.kernel.org>; Thu, 10 Apr 2025 13:05:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744315531; x=1744920331;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TXfF9vM+BoIBd/qesq5gNZSO9HgKKIqscZ8pGO8kuqM=;
        b=scD4IDJmddcZ05pZ144PHUwHr9p9tWgjllWR6aLBCznRJNxf+7kuovgdn4mBsGRZWS
         ntvFI3abDRfFaxg/WUmGNz0T3uIBUUKwnKG0UYR8kRcTDR38wVweU7yE2ttwP4sRIaFi
         0OiGx/RGJGjKj8x/f9hItW4v3NAJLJ9eXYGEAqFwi5PBrP3MJO8ocnsHAvjlYJ2z1C0k
         43SqlY9/Cp0U9W30jTHM22MuwQqRdDC55bv1pyxzHx3nfT6ZuLFk9FPeHQL8AQlRR9Te
         6r/SKUq9cZvHmeJzWp24PXC6kVc3Zuf0Y/i3Tqoi21mk1MoJYN8GldZG/kyFtU92229z
         9I4g==
X-Forwarded-Encrypted: i=1; AJvYcCWZsC8OLlhpyYCgdW0uuYJJXSgg9k9f3xB4y73j48guOMWyal2k8eQl8L9jOWOg5ztpEkjdWKSpiRlM@vger.kernel.org
X-Gm-Message-State: AOJu0YxgFx+IwwBle7E4QL+Nko6Zh4sPMiEGhPFYZj07UIUDONUq1eUG
	pouOBYR62GOahGOidOBD9lnSAHE3fUjOy+MArEC05ea8uFJkrM+Jz3Rpiw2dfMV+3hox7BhR8y5
	GrSlyzL36OQs63Zk6t1pQOvH2OCtZgqKaT3Wdhp8xOsGOGieHc5y/R+bde037
X-Gm-Gg: ASbGncuOpLIMbDncjyGXx6CfmMHeKXR3O7fV1+h9XLZ5cCpOSbzs0SqMURqZZ0egNOx
	sMo9vCDMg5FbIV7Ec2i48Zlfd0hstu/SO27X1HR8rd/v+SUlhLfrbJ1SvFccPNuEZezN+SDZ19B
	HH5kyEncIjgYh8AN1flvScmNRB+t4wUpuZlQvpHRDIq5IpLUrCJQEN1CxiBwu39kpzJgQoljioh
	3g8+rVfqzbwLsJJeh8VJwKusmzeYUpZGwgXnH+WAsFI1nSpkJcGWXJqcE+qtFsNAmHRXYsAGG/C
	KivbcQMhaZ60+AvlPEvAnLB9Is8QEwFvZkfw7iI/2sR151zUhtDdeBa2Bpth3Z9s3oLoGvNUpmo
	=
X-Received: by 2002:a05:620a:19a9:b0:7c5:53ab:a74f with SMTP id af79cd13be357-7c7af1f32famr39461185a.39.1744315531602;
        Thu, 10 Apr 2025 13:05:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNwwRD5+XOsvvXwA7FK0l1NN+2EkzlXU5C/nqu3FRHnxldNXsWpsj4tAqkeWZh4iuNHA2zcg==
X-Received: by 2002:a05:620a:19a9:b0:7c5:53ab:a74f with SMTP id af79cd13be357-7c7af1f32famr39457385a.39.1744315531220;
        Thu, 10 Apr 2025 13:05:31 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54d3d52084fsm232846e87.255.2025.04.10.13.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Apr 2025 13:05:30 -0700 (PDT)
Date: Thu, 10 Apr 2025 23:05:28 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: vkoul@kernel.org, kishon@kernel.org, manivannan.sadhasivam@linaro.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        bvanassche@acm.org, bjorande@quicinc.com, neil.armstrong@linaro.org,
        konrad.dybcio@oss.qualcomm.com, quic_rdwivedi@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V3 2/9] phy: qcom-qmp-ufs: Rename qmp_ufs_enable and
 qmp_ufs_power_on
Message-ID: <2hysso6n4f5tnyknmgne2r4wpy72j2taqwuncqdcwqqztr4g7y@a3scnple4tew>
References: <20250410090102.20781-1-quic_nitirawa@quicinc.com>
 <20250410090102.20781-3-quic_nitirawa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410090102.20781-3-quic_nitirawa@quicinc.com>
X-Authority-Analysis: v=2.4 cv=B5+50PtM c=1 sm=1 tr=0 ts=67f82497 cx=c_pps a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=XR8D0OoHHMoA:10 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=hpSo_X1Mu2B5NIsQaEEA:9 a=CjuIK1q_8ugA:10
 a=PEH46H7Ffwr30OY-TuGO:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: OOwYISxYyCc2yVVhLYbtgvb9pGQxm_Xa
X-Proofpoint-ORIG-GUID: OOwYISxYyCc2yVVhLYbtgvb9pGQxm_Xa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-10_06,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=747
 suspectscore=0 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 lowpriorityscore=0
 mlxscore=0 clxscore=1011 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504100146

On Thu, Apr 10, 2025 at 02:30:55PM +0530, Nitin Rawat wrote:
> Rename qmp_ufs_enable to qmp_ufs_power_on and qmp_ufs_power_on to
> qmp_ufs_phy_calibrate to better reflect their functionality. Also
> update function calls and structure assignments accordingly.
> 
> Co-developed-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
> Signed-off-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> ---
>  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

-- 
With best wishes
Dmitry

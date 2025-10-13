Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348C526561E
	for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 12:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760358934; cv=none; b=ClUWCKu+e7B1Q9H+3bM0fRs3/GSZQSD5Yuxss0TXy3EyNNWWg7QUDrQ1QIjl/rgNpN+jwoYN6FAYji8i+Y64CfmAsrDQ9kA3fA7o/XD2Gnhaiz9R6KXq177KZHpeOUI2wpN1oz+2kuyE60AmdupSfdbUDmam+cIknyYmf4ZgZ4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760358934; c=relaxed/simple;
	bh=kXxhkCykLcnXkTZcPHSJpo7nayzyV8cdsyNMW6iYSrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G5LdKk6FlzcQjRZxpsHLd1OyT3aoaXBHvlGQqX+oCXIolP9IvcG79a2lHM68EEix1GT3dy35Xl9E7BZnp5fmtWPyn6NwMOH1haJnZvZ4UYIkuunCrVM1VmEdEwESETVP+8VyO2D79Mue+2pxgfiEBwYdJzFxUTHAyAJcgz7hm1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jZ5vOFEe; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jZ5vOFEe"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59DA16km001242
	for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 12:35:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=m7L3o4Pwi86bgIe35Awo4E+H
	exJtX6srm8LE+iq3Tr8=; b=jZ5vOFEegJlPQpNfq3lTwLEnKM2Ukq9nwYbVRsfM
	XsN1rgjkcOX8zxZOxM4o45s1FEseh78LcztQ+fmeRqquEGP/39OkDCXLVDa7q5La
	+lRHXkqajUk2aR8U5D6n9Q4SmcC+curU7m0ND7GTQC5kok+JNl9UM+1kCXAcNKLS
	/M2Uhl2bsPfo6STYYZ44vvKVk8RCQ8Q7xUEN4KC9RgNujHSfHGJ34ZHFd5WyoDPs
	TgwJbgrZXjTmzbhY9RrZaO52pNzB2GdwdvioGfD5A2X6CvSBGDBZbSoKQ7KA4V06
	BgnMfkx6A4D1htxF2nQFc463c8jd4TBb1b9yxdtas3Rnog==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49qfd8vjcf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 12:35:32 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-872d1a88c7dso234644885a.0
        for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 05:35:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760358931; x=1760963731;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m7L3o4Pwi86bgIe35Awo4E+HexJtX6srm8LE+iq3Tr8=;
        b=n9pyjexVDKDHdjhvHtziG6vpfrMEKpP1zF5/wRdt5Be3g3pshkeZ1mTCIs78herWVi
         aKG+IMMpdP1NbWEpWKCMpir+mLXDiuMkhw50zaqEv1PykCudX7chmQn9hLKvJa1Rse6I
         PXIa1BuUwic40fp8iwCcdq1LG45oIkuawTXd5V/DyPU279ljNrd1jFPN/Smb17o5k+0q
         nPu8Zeud2lpA7sk5cFWIIVmlhSLRkeesx5iUtNEizMU3AXrz/irXRZDNhGQmYMBj+j2F
         UtkPQd6xct6pYdHM/NkQoklws4MnIFpxg8OXR7piRCnO3lOBfNHUuMUqqoxDYGjaXpMG
         KSvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVA1oRZ/WBaeoJVfFh8l2H1BprwTz5xatBW5gYMX1cwyXd5SkZMGrxOwodeKdbKNQv8ycMnPdBU4mzC@vger.kernel.org
X-Gm-Message-State: AOJu0YwP6nolceS72vQH9QWsokGGJ7B6qktr5aGIkp0rHbx+pa/F7Y9v
	Jt1WRDMZp/1/f9lZSpoyh5bfU5RYTzQhfUYV5zNGTvB8e8zcP5Jsab3PVBU9qyEHemwddkd8TNT
	GMg0+JUvX5aQSXybyTjvyM6vgzdIMPrK5tVhRdatsbvhXcJ3PNfjbtWPFSkPsX6A0
X-Gm-Gg: ASbGncuw/KQWApXOlqXSuaH1UXT2ZajmweSCDDjtGqCIyD2q6ujuUh6h7p0dmL+5wUX
	8a+aOPFserJHtZ9AkJ69t4AKazmKxhcWHwow2Yv2iS233kzUEdlyR3GE9UqH7eF7qRNcTgsl3UV
	QcJUP5a02GhcpIx/SBafgr93gQtXUWzpR2KZmnZXN9+YWtTNNhnhDl0cxh6Wi0Fbmp6uFehS3xG
	HzvL35DvoO+mbydhQmNBNmflXFSpNvwqjt2tx/gdCI6IpquTT5TvW9BxlEKUiCDStxJ3HhzhhhI
	bOwQFiKJmngZnaDKD3ghhIUPPmbH5aTnsrA7O9DXAAOF87PMRoXlBFsD84Pvn0MPrMlTcEZc21m
	ia+4VMtdLyEuQeVoxp9h+MR9JVMogVZVTdIAa2Qx/+QLK9YL10bx/
X-Received: by 2002:a05:620a:4411:b0:84f:110c:b6ec with SMTP id af79cd13be357-883546e153fmr2786636785a.76.1760358931033;
        Mon, 13 Oct 2025 05:35:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtTA5MLWXtycAaJRA0YpGMVukU6FtceKKwRiGS0eYpqRLVEiT3h5hR82xs7c3USv5CsJzY1w==
X-Received: by 2002:a05:620a:4411:b0:84f:110c:b6ec with SMTP id af79cd13be357-883546e153fmr2786630085a.76.1760358930475;
        Mon, 13 Oct 2025 05:35:30 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a0c3-3a00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a0c3:3a00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-590881fe5besm4080369e87.50.2025.10.13.05.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 05:35:29 -0700 (PDT)
Date: Mon, 13 Oct 2025 15:35:27 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Ritesh Kumar <quic_riteshk@quicinc.com>
Cc: robin.clark@oss.qualcomm.com, lumag@kernel.org, abhinav.kumar@linux.dev,
        jessica.zhang@oss.qualcomm.com, sean@poorly.run,
        marijn.suijten@somainline.org, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com,
        simona@ffwll.ch, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, quic_mahap@quicinc.com, andersson@kernel.org,
        konradybcio@kernel.org, mani@kernel.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        vkoul@kernel.org, kishon@kernel.org,
        cros-qcom-dts-watchers@chromium.org, linux-phy@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        quic_vproddut@quicinc.com
Subject: Re: [PATCH v2 2/3] dt-bindings: display/msm: qcom, sa8775p-mdss:
 update edp phy example
Message-ID: <cjweltdnffozpi5amqvrfwikw3a4plogjm6ozhbf2lqee2neby@ueoha7dmhpgq>
References: <20251013104806.6599-1-quic_riteshk@quicinc.com>
 <20251013104806.6599-3-quic_riteshk@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013104806.6599-3-quic_riteshk@quicinc.com>
X-Proofpoint-ORIG-GUID: WoLPBwT7_nG1xCMOlFbw98v173Ik2i6M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxOCBTYWx0ZWRfX36xvs2PXegCs
 RKB9QG2mzRCykoLaPQs+oudJJivzEbj9yX+aD9sCupJyU7lZnhJtcDI3u34URO25QtaZW1TgAvz
 msaQzdJFwIGInwL+E0vcFunJMcfdDAxWHFsDuPLBAqfysXDTyYZc7TwuMQybR9QSDZ5PWU9eSh0
 OwCvzzGj8VQRZp+9wLvVm0ABnTo0QEXwqKxjm2C4BD5UgYHcULvDCOLRYvkzuX6oyGNkQbB43Pw
 YvkgrVXhScD/OQOOMgTnMkMJgJbw4z321AO/iazka1n6VfOGFHdnjrnU8FMrDn96H8JwjMtjcXl
 557U/+FjJ4a5Ra3j4V8Scm0n5W7ygVqrayFjw6+qtRbENKkRK8uiRCgRIQe+YNl8ThBoOeXbB5m
 CWDeP4ZRjwYPWD5kw9fAVxOpIgwpLw==
X-Proofpoint-GUID: WoLPBwT7_nG1xCMOlFbw98v173Ik2i6M
X-Authority-Analysis: v=2.4 cv=PdTyRyhd c=1 sm=1 tr=0 ts=68ecf214 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=COk6AnOGAAAA:8 a=en-7mTTXfYbHl6GqnY0A:9 a=CjuIK1q_8ugA:10
 a=IoWCM6iH3mJn3m4BftBB:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_04,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 bulkscore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510020000
 definitions=main-2510110018

On Mon, Oct 13, 2025 at 04:18:05PM +0530, Ritesh Kumar wrote:
> Update clock entry in edp phy example node to add support for edp
> reference clock.

eDP, PHY.

> 
> Signed-off-by: Ritesh Kumar <quic_riteshk@quicinc.com>
> ---
>  .../devicetree/bindings/display/msm/qcom,sa8775p-mdss.yaml  | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 


-- 
With best wishes
Dmitry

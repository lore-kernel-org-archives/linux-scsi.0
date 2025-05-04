Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8BA154425
	for <linux-scsi@vger.kernel.org>; Sun,  4 May 2025 15:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746374267; cv=none; b=g49d/fZy1s75iiJRHRdNuzuKNKKKC3N8Uix1QB7sptBU5W3kCRhe8eMDS2wTJgARmB3CZGiBSgUTn70IXtdD5AtsZJ0UmxYmjA3D0AYCCrgs6cFNyYJEoG2CjmHtDTdcBf+GTzi4Zay2NpRam7zcFSFUx4tKvsOHej37E7YTutU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746374267; c=relaxed/simple;
	bh=Dgx1jva6DzN5ZiPWjqZBOROZ41hVkAHSccmbGgta4qI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y2WcsUxlu8Hd3GLA1UJR5zEBWfVbnoGB+7b2gxKcCYzRwgNM3Sa4GL4I3BJsrF0ktbwP+YT6AqLuH45gs/nBRK6tJlKZAqbHJ6hCRm2DzMfiiBCrPP3+gN3n2sDIbVhI5r1TE/VXWFLbtu2mij1RpGeHJu8JFaOKIE/yUCES6vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Muhs0tLx; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Muhs0tLx"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 544Ac49Y021436
	for <linux-scsi@vger.kernel.org>; Sun, 4 May 2025 15:57:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=+NBQddzgvDX+iZ2tGFQkPQN/
	CB+FVzuOwSU6o3vai0k=; b=Muhs0tLxv4F0GjAsHtYTZwiV0aE1Ojbcs+DMkUy9
	aXJ4pj5l/4i+4GO4tSC02XrC5zsZeRwwSr4vthbo0cIwk5IO3dSxp4FOzJs8Prji
	3i6UxhQDSPKiOQBziC4yFtXe/NZghgLC2CJZHLEMarbctkn4NErxbhOGugXfHfAd
	GyMSa1mygawfFIs9ziSjaQ8oM9Q6HIzkTODSEM28B2uH3+lUxmA3MZBIcwc6BMbL
	TbTmS/lbB29to/muzTgyjjPEN081PnKqQRawsfQL4EHSnuHfTuIvyEAHHJzuS5rD
	gGPddG8+z7dq8tW4mg3C4LQrtzQMbmBUdNw1mCwy2l/8Fg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46dbwfj2ta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sun, 04 May 2025 15:57:45 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4768656f608so77457421cf.1
        for <linux-scsi@vger.kernel.org>; Sun, 04 May 2025 08:57:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746374256; x=1746979056;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+NBQddzgvDX+iZ2tGFQkPQN/CB+FVzuOwSU6o3vai0k=;
        b=V5/o6XrqGQlLIlFnxsdQCydqznpq11W5vtTgLHKI/hSw1lPKVdPFE6dYp/9Tm9sjBn
         Nc0KAeXaiNNujYZx2QhkF++Ui/pzMlJp1TsvV2bHi7wVOE1GvAI7Nf4qFocT/bUqNSRA
         3xYH8HRB9XoFwEginyy/dDSKrclE7tcrxVdXbOp+dWhStrlYkhyVJ1Bvh85z8zmsn8Ne
         5xuu5U4Kvn8zDRQyma5M4FgAotaECunqysJ06UQSXj/3yJluwOUzy7xRSdJ+dc+slLJX
         o9tG/AamnYAN8tto3pEGHWUsS/5zWB3iY/774Tmyba6JQpUnNF7qMZP8+vGzVxqraumz
         IcHw==
X-Forwarded-Encrypted: i=1; AJvYcCUspNV939TKvFMoyXixXZCNXHWeiZghnD9G3OouepbsOiEaNwmBTm5HhXZbRLBdZHNfRIy2vZx2ffCW@vger.kernel.org
X-Gm-Message-State: AOJu0YzqsZ69SULgsPA/SJrHjS8kRmxVPOljtOZVFFcuLqaC8B/JuxZa
	sU+4/3KrRCttDDy+kH9PF+r9YNtcHDg98uEvssxLfpqiyzHkdnrNJJFWbg58gbgM+oqjLursoF6
	V/PuS2d91UnvGSy59Ix+0U/T182BmjY2e7A4Qax095K+t4AKpiQEowUcyvM8U
X-Gm-Gg: ASbGncv4uIgKa117AoWsmoBFFH/sIL02fWsTao+36U0kmwvwj6BIckLYmdd3ngHHud8
	nGH5MYkdBFO3fQTy/K0ykSPRyQpxeZLLuTIH96LFaGWhdjFoF4Ll0J8x3cj4o2TepSDP9yjsR1/
	60tZtrNTisRnofrt/nj3Ue26485NKIbdDrMI5M7vzTdu52fj4vpas+6Q4uxq5WJ3//fRGgqf9i0
	T3bEKeCV8MFa2WjIYSc37tB7h6ZsMazVQwM24fDv0dl3x3LhpK7t5t4IzEYGB+/KSlXtwN6yBBc
	F4LPKkmM8ACo55Sld89pXbfs6GgqsNjnvS/bH0JREOUeywmogjDkVsvrqEmHLi3L40UYuJf/9os
	=
X-Received: by 2002:a05:622a:348:b0:477:1ee2:1260 with SMTP id d75a77b69052e-48dff3e17ebmr59557761cf.1.1746374256686;
        Sun, 04 May 2025 08:57:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4apz9O7p8cmIJktiBqV/ploX2tWp4mathpyShsF97cdRuhrFPCVNENtImRJjdMdTGiCcezw==
X-Received: by 2002:a05:622a:348:b0:477:1ee2:1260 with SMTP id d75a77b69052e-48dff3e17ebmr59557571cf.1.1746374256352;
        Sun, 04 May 2025 08:57:36 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3202ad908aesm12406461fa.96.2025.05.04.08.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 08:57:35 -0700 (PDT)
Date: Sun, 4 May 2025 18:57:33 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: vkoul@kernel.org, kishon@kernel.org, manivannan.sadhasivam@linaro.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        bvanassche@acm.org, andersson@kernel.org, neil.armstrong@linaro.org,
        konrad.dybcio@oss.qualcomm.com, quic_rdwivedi@quicinc.com,
        quic_cang@quicinc.com, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V4 08/11] phy: qcom-qmp-ufs: refactor qmp_ufs_power_off
Message-ID: <vliufhbeztmvgoddhxsla5p4vmr75wmqf6iqlnqe7pnp3bobqi@thrwl33u22yi>
References: <20250503162440.2954-1-quic_nitirawa@quicinc.com>
 <20250503162440.2954-9-quic_nitirawa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250503162440.2954-9-quic_nitirawa@quicinc.com>
X-Proofpoint-ORIG-GUID: Eh5cRDbA-hZwWb_gGp9esbYNWq7fQJIn
X-Proofpoint-GUID: Eh5cRDbA-hZwWb_gGp9esbYNWq7fQJIn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA0MDE1MCBTYWx0ZWRfX9kSw/gRSZSSH
 xrpC0egkdYnMPtKNEKd5I02V5QD7z266523bUsvA1cbyqtiGE6tS26AHauJqSh7drcfq+N8Ljiz
 YyyS7uiUKtIYynsm78GFGOFS+9JYEDCLOyPOfXWuwRxd/pzCmiijP00gmQYrrzQsEJfgXlyisMx
 EQfdQv7uHs+W24b6IKcx7w1IaTiwxgZtH9tjtm7ZAcSIfF0F0PYG0QGfEbrLhgRMmoHat6A+liH
 dQ2EkT0+ml2DpQAa34zFuxgDDIre/At5f+GVuzbgaJ1BeDti9VzY954LDHQv7VCzTj5aAEolBxq
 +YxgpMBqiuTeYXWgbbLOTLRYuq/q7SzvsKMxZjwce9f33IpuNjBXSKw4/TqhDi7n62U7PRpO/yX
 3LPovCg38DALJUGBlBKcjelEwq/vdjxFKD5ilcJEcmAKNBSIcXjwcjiS4zxc5yW8k8dnM5+m
X-Authority-Analysis: v=2.4 cv=AfqxH2XG c=1 sm=1 tr=0 ts=68178e79 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=dt9VzEwgFbYA:10 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=1ySLA9CudziWiy2AdkMA:9
 a=CjuIK1q_8ugA:10 a=a_PwQJl-kcHnX1M80qC6:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-04_06,2025-04-30_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 priorityscore=1501 phishscore=0 impostorscore=0
 mlxscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=684
 spamscore=0 bulkscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2505040150

On Sat, May 03, 2025 at 09:54:37PM +0530, Nitin Rawat wrote:
> In qmp_ufs_power_off, the PHY is already powered down by asserting
> QPHY_PCS_POWER_DOWN_CONTROL. Therefore, additional phy_reset and
> stopping SerDes are unnecessary. Also this approach does not
> align with the phy HW programming guide.
> 
> Thus, refactor qmp_ufs_power_off to remove the phy_reset and stop
> SerDes calls to simplify the code and ensure alignment with the PHY
> HW programming guide.
> 
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> ---
>  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 7 -------
>  1 file changed, 7 deletions(-)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

-- 
With best wishes
Dmitry

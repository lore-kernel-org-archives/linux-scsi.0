Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437862D7805
	for <linux-scsi@vger.kernel.org>; Thu,  9 Oct 2025 09:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760001021; cv=none; b=EqSTM7RnMGV63RxsqVThbyG0b4+HD9d2TuHAX3jFwlk23/G5oir5H2krZrm9w+NHQOvQrOvQ+zXvfRdWbHPQMJqs71PRrTpsmUnLdFsvCjh483WdlKcmqtDtRRP/olBRuh/jTtXsEf2kZX3Ar3DBinGnDMHjwQxr71r7cHvtSGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760001021; c=relaxed/simple;
	bh=1gLto9BCDROKFQE4dD3C8sxYVc2P8E3H62tB0Tiz5aY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oa8sUJM/9ygecndgi5I5wRRnqKGRRMYpO0pBGfHAsEYcrsjwK/UU9HRCX4CQ5512ZaRIx7VCA82bOMxz697Bg2dzE758yVJDUW9VFar+J1xl2XoLdoFSsTGlkoMNelF1G57bn99VSHg1XzgRzi1a2XY9m1AVOZR2p21PXavDKhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=X4WQfNsp; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="X4WQfNsp"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5996EQvk029796
	for <linux-scsi@vger.kernel.org>; Thu, 9 Oct 2025 09:10:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1gLto9BCDROKFQE4dD3C8sxYVc2P8E3H62tB0Tiz5aY=; b=X4WQfNspdGcNJbZr
	DSXD7I7PL3YF1t3vwZYpAGpfgw+Mu1lbIA7nVDCrIFIm1E4oZLZ+1Iz4gfCl6qwR
	+XQQ2B+EuWj3+o4fEwHRRPKu3D5zusxKR8IeO3tyCmtcXBqKKNK4gWlxi1hNM5dl
	kD5fI0QVZxVlTpS6c8Oog0RfYtCkyqwImFsxGlnDBWumvZLtuPVJS4SItj1n//qL
	2ShnL2sun68DlebdMrRZLQw76EnwyaIhpKMdaVT5kQEeSfJpvJ2A26uEDxxi9iKp
	NMBmzzkvbl3d85tcfXYgNPsvk3nf6hOZrSqwgZ7ue+MConDu1ULj1wLbk8J0QUle
	RP9v5A==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49nv4na687-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 09 Oct 2025 09:10:19 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-860fe46b4easo32932085a.0
        for <linux-scsi@vger.kernel.org>; Thu, 09 Oct 2025 02:10:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760001018; x=1760605818;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1gLto9BCDROKFQE4dD3C8sxYVc2P8E3H62tB0Tiz5aY=;
        b=u03z+rUOhvaQ4ja8HsFjweECNiXkD3wNSUP7oyF/BXr7jy2I3g2tn6+Rh8jInXI3Qz
         BKQ7eVaMCeMWQ1PjjH8k4Pb1Npn2Iei9cfVVY67gedNDHvw0D0HdVzyYIUj1Iel+h3km
         WdabZYGluLcS5VXQRy5nxQXDvDNmRfgM4Xkbsw8pbM4K4QxB8sJfhMujdYk0pW8s/6Ec
         bfUhcNrIsmGk3M0WUPhYRwzLxYIiJGXxtwKQAfyXlUn6PG3RCJMrw3VmnWff1wqVZYQG
         QiaNFttw4wvKiZIfHihH8yCvHVLyzEtcXp596Nm2Bo1bm5cIzmbZC3Bk/Y1VUuXmGKUD
         QrZg==
X-Forwarded-Encrypted: i=1; AJvYcCUbexmHRyx9x3/8yq9y/AvHwBfrsO8dRnPo+/nkGL9TZvTy4nA18W5HZAC34rHRCQhS+iGXBnZ8ujyv@vger.kernel.org
X-Gm-Message-State: AOJu0YzTWWjcXd6BiiRq6znFKteI5T0mONFBQgRKF1aBuoFMd0MK+Bss
	Cg5s52etcfobhHcbYydex3eQig6PYzRTJuoBhUKsovf/EKBHeWmbmbH94BMRO+Lu1DaLznT6uAY
	Lld5ThNXeDHKZUQVGS07KdgLFnQVeDss1u4mQnlblcK5wQbQfPmqr+fLGyJZNYdop
X-Gm-Gg: ASbGncsvoMO+CYdeDwLWvEBteAxa2woi6uhz2k5Quhd2uiP50U+0c89O/e6i9alIFAn
	elxMp/73EN8GoB0O8fjbOZqtLaqA/TlUzPuYRDt258KOEn4zUyG73abURBtxXaPyhX8aUOlNsiQ
	9JajTKQOjVwrRT8mVNbLVfSsk5HepiMlO6cf5IBvSFOklSZxv2w/+zhE3toIVm5qbm4a0edBxaL
	4TJX8pWgSvXQgmjKaFAUAZT/Vei4ROHWe1Pj+Hys5lMJVbI9JBtKRRCs8bHQB8fikPCkS1ZcY7N
	0El/L8S9Bn4VHJROqFiMxJe36qDcM8sHqQWySxa3nkH5IT91Z4LPSzvRp4MSou9Jh04p9wgDvBK
	asxi5jWxbX5NgkEqWH/U/R4mKK78=
X-Received: by 2002:a05:620a:7104:b0:835:e76b:ba25 with SMTP id af79cd13be357-88353e1a4e2mr585134285a.9.1760001018039;
        Thu, 09 Oct 2025 02:10:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6MZb6QOnbhBTE/91nRDArgRgqRLTEI+IVWFn1NxgCnvCATzVRomE0Pl/cQ96//aeLXvp+jA==
X-Received: by 2002:a05:620a:7104:b0:835:e76b:ba25 with SMTP id af79cd13be357-88353e1a4e2mr585131285a.9.1760001017473;
        Thu, 09 Oct 2025 02:10:17 -0700 (PDT)
Received: from [192.168.149.223] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b4c83adec08sm1153029466b.56.2025.10.09.02.10.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 02:10:16 -0700 (PDT)
Message-ID: <597ae997-37a4-447b-967c-8fd362098265@oss.qualcomm.com>
Date: Thu, 9 Oct 2025 11:10:13 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] Add eDP reference clock voting support
To: Ritesh Kumar <quic_riteshk@quicinc.com>, robin.clark@oss.qualcomm.com,
        lumag@kernel.org, abhinav.kumar@linux.dev,
        jessica.zhang@oss.qualcomm.com, sean@poorly.run,
        marijn.suijten@somainline.org, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com,
        simona@ffwll.ch, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, quic_mahap@quicinc.com, andersson@kernel.org,
        konradybcio@kernel.org, mani@kernel.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        vkoul@kernel.org, kishon@kernel.org,
        cros-qcom-dts-watchers@chromium.org
Cc: linux-phy@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, quic_vproddut@quicinc.com
References: <20251009071127.26026-1-quic_riteshk@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20251009071127.26026-1-quic_riteshk@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=ZJzaWH7b c=1 sm=1 tr=0 ts=68e77bfb cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=rf8yBW790zp7CXIHNmUA:9
 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-ORIG-GUID: WcGZCuKgJd3McxkNnCzdTFNJt2XATdCF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfXxGeBPjQ0QdB8
 Epj5TYr4us6o9KMs0J9Oaub/S+KbybuKdm97eJt6nGrQ5LaieGI7loCEWfQve+fIwVgovDNx8J7
 jTr2kgfQBWY4wBVyb1ZiYlmVOSFgY3O4rJLJwxP/ZCsA3xnKjhsXhG0Mv3Ecp6lhwE/+E3lrozG
 gIh57EIaO2FT4K/laI4jzuq1nrgszy3bQu88xPTUThy9NJ8CaXy5VvAWbJSNtBF0nBb+M1JyHC4
 LXYgKKizE4FM09vwJin3yjhEmVSU2ZbrTvzhLrXyJ8JEM2xn0lraSf8LEkebz3o73SO6Fxp1M2K
 laka+0rI1Ne6NLEZXIz6/b2q/rURbSNLlcvyQnu8mkOSyIuSYaeS2rrDgYevKOrHjJwcPpJ2oYH
 mPOjiaD5shwZ4/qYDDLzeMNd327wDA==
X-Proofpoint-GUID: WcGZCuKgJd3McxkNnCzdTFNJt2XATdCF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-09_03,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1011 malwarescore=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 suspectscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510080121

On 10/9/25 9:11 AM, Ritesh Kumar wrote:
> eDP reference clock is required to be enabled before eDP PHY
> initialization. On lemans chipset it is being voted from
> qmp ufs phy driver.

?????????????????????????????????????????????????????????

Konrad

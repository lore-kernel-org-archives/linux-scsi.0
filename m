Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4073257440
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 06:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755154664; cv=none; b=eF1lu24AtBMYJ6o583FPC/YDGEU7xtp7XQosi8B2RgD/vUx4zb9kr2yT0SZ2OQlWMixr4rI+SEyMQfvKHBzaleueIF0qtvzun/1Yc+KSJ3CWkiqWVhoS0EvD0QScF5beh+evk7EDtlUZ2uRLzx9BHL06czYFiczNJPcj9fzxx1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755154664; c=relaxed/simple;
	bh=2TlK50ADSnugtMeEFZsEk1xa7yMDhRG+pO5OGKlwYtc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FUo6xFi4h74NkSO/ZxviKcg35ZEgA3hB1NSpkV7M9qq5G/vXe0P/nTqNglT22bYgbjhFlwoG4vB4vYeBYcjmQUVdyM6VlyOR13uuqJJOASzHe/EI94fo5twqeykIc5rsU6fbbnEfD+GDCaSYUhHjj7KF3dRh0sQN2KW9LxSweBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JFwL5LfJ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JFwL5LfJ"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DLHDus027107
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 06:57:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=WH6pheIOBCLhktt4o4IaE6vb
	Qet790mOAdYrq4OwLrA=; b=JFwL5LfJqGhhhv/hky0HR6Ild24Yz2XcjSC/F2Pd
	l/y9dNif1VXOMtJ6jtXx5rUwADOwQ6jsCgYGzoWmVQHYhK+2UCzNA6W5P5tBlEAq
	S03NXM1SShFXLTgr8m3YUKGVlQnUO/tWglYkqgM7Vd/XH8GaZA0AjrlNF7PDUHl2
	GoPb3FmLK5tvFXydN1otaGC4OtOiLUpZ/U6k9ZkVXoXVlQefKx5XnVC92htw8Rr5
	mIYK6XyLNzoV+/SS6UxmZjkBbbkYLuGbV/SPTqU61bwXztnJGN7punGrWrsb8RdC
	dcgvtdDhv1wd92kvz8v7i0rpE3xpo7pS7+jJIwWgitR7+A==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48ffhjthea-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 06:57:41 +0000 (GMT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-70a9f57f950so14597336d6.3
        for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 23:57:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755154661; x=1755759461;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WH6pheIOBCLhktt4o4IaE6vbQet790mOAdYrq4OwLrA=;
        b=JpwmiYHs4rh+z9osYxc7q+2JJ3lUX1yKsG7kMdESY+P/QeRlrloluFkE/a3EviwWyv
         vJ5vGfPqKFPSMAQUCXlPToaytIMqusqrJqOkWupkAbvTfP2cIiSkmIHK3NSflbISCJoO
         6A579OSYAO2CKnwYc2A2qfqXXSKQK4ZP5KpYDp/tKrzXgkwyyyIWgkDyDYp6hvRVkOwy
         a3flwgQiThLHDS0+dcFTPOhEWpGoQAbRefwwe9GEtj0FBW0XlsBan/L0Hw8yeWyWZuZ0
         YhoGJwbL28kbn+E/gOqTwNUUDkrHqOIUXYc60B6ljUdzzpmpeRkLoTUFSM7TWLVOuuNJ
         0Fjw==
X-Forwarded-Encrypted: i=1; AJvYcCUrrWIzO25UISjL5LK7cnfc7+DWl+O1DiPHute5jmZxmUTLISwnnqJ3JMVvAfV/O8YBxEO4Ww7y4GmU@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb54LFg6sJsZuMMFMc6Pb2AaKs5roj5Xq1ouU44kbQ1BT5lCSa
	rWogiwvPbwEr2j5xkIQ0Jel81TAt+R7+PIxReI3tXM6phCrOaKQI7M7rblbqEAYEQxli5P2BUPi
	FvZ+iEbkqyLTxiG2jzqMz95Pp2YnzhovQyzUD/6MDLNcihOMd7F7kV9q/hpy358gw
X-Gm-Gg: ASbGnctz0ondfMvtjclPSoM/Luq1sVIkxwNT6fbGK8s3DoB/WepwrSssQh8VNt8r/b4
	kh9+wyhJsbMggyMQq/fZBBD5O8XsoEtAH3zb7qcnXsrRRiylUBsfmM5W7U8gVVvlaE7iErPrZge
	QKN5zFQSUIJUQW74KDoYc4aLkEBdzY2nbm/hV0p4d/6jOjVL0tM8AqgtkQQhe/YVZL4iFgdTKRS
	OZ9dHY/RqOrWa5HGA5gJq/m0EJfngVq4AU38DSrwopEj/BBOLEDWosf4Rf5rEXK/kS6q3a8Jzl0
	lG98dz97TVs7CxqYjHIG/huYFqoyPtInJajqpNtfsZi/FUaZLly1NVsaT9hRXL3UcP9g6vWuD2D
	Kbt0ve9udJzasURrOjZ6tBi+83Lvkgi0w6+Y/15N/rCggLVtpF072
X-Received: by 2002:ad4:5fc5:0:b0:707:39f7:c607 with SMTP id 6a1803df08f44-70af5b4a03fmr31187076d6.7.1755154661121;
        Wed, 13 Aug 2025 23:57:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBZQ5FEsnMbOmX8KkrKa9+kBE6Os+GRoekHbqN1j+i/35W5BLwx3DVldiMtvDJKOME7rzkJw==
X-Received: by 2002:ad4:5fc5:0:b0:707:39f7:c607 with SMTP id 6a1803df08f44-70af5b4a03fmr31186696d6.7.1755154660637;
        Wed, 13 Aug 2025 23:57:40 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a0c3-3a00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a0c3:3a00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55cc8d64512sm2420634e87.11.2025.08.13.23.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 23:57:39 -0700 (PDT)
Date: Thu, 14 Aug 2025 09:57:38 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>
Cc: marcus@nazgul.ch, kirill@korins.ky, vkoul@kernel.org, kishon@kernel.org,
        robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
        mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, andersson@kernel.org, agross@kernel.org,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/3] ufs: ufs-qcom: describe x1e80100 quirks
Message-ID: <lj7qsbtk5xlmji6eknfv4ffrqypcsfkq5m7icrz4mvplncflpi@5j2opxwb5lft>
References: <20250814005904.39173-1-harrison.vanderbyl@gmail.com>
 <20250814005904.39173-3-harrison.vanderbyl@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814005904.39173-3-harrison.vanderbyl@gmail.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDA3NCBTYWx0ZWRfX0BXOolxRl+vT
 nSkm2sqlQfMSm3Ic2zmK0/Ob3FF/0ru2puW8ec1pM9ZkLXt4c0+dVfrJ0ClApGtuApb/ZbRfQti
 d1I8ljMgSccdYeNrbtKKYFNcbEXQbGIjOiceM1nDfPjqhqvBu+Boqy0fl4fLm1lLLBK67+NJaze
 WuKc2irROM6NuFujE2yvypWM0/z2fsgItrCcIDuJa3a7olxRi3RkEnbH5K7LK5/LIyWWDOqSb+U
 MDLI4UTFIbTzWEslcJA99WTR21bHhoNl4I90Q4xhGdiZeh2vrSgh92ZMNxTuGUkDuysw+9gzPqy
 tUBBLIBXhlDKmW8JMfDMzRPz2zabJTRlBdHTNrsnOnuWqJSx89t6Q0oh0MuF+Lad2eqKwm0Y1+C
 PcUwl6U+
X-Proofpoint-GUID: UX-sN3QZkzqIGDjfOXRiCHze9VOle2T2
X-Authority-Analysis: v=2.4 cv=TJFFS0la c=1 sm=1 tr=0 ts=689d88e5 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=pGLkceISAAAA:8 a=D3Jz6Z15PsX1N0F7-5EA:9 a=CjuIK1q_8ugA:10
 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-ORIG-GUID: UX-sN3QZkzqIGDjfOXRiCHze9VOle2T2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_02,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 adultscore=0 impostorscore=0 malwarescore=0
 phishscore=0 clxscore=1015 spamscore=0 bulkscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508110074

On Thu, Aug 14, 2025 at 10:59:03AM +1000, Harrison Vanderbyl wrote:
> Describe describe driver quirks for x1e80100 ufs device
> Signed-off-by: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>

Again, missing empty line

> ---
>  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 3 +++
>  drivers/ufs/host/ufs-qcom.c             | 1 +
>  2 files changed, 4 insertions(+)

And this also needs to be split into two patches.


-- 
With best wishes
Dmitry

Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02662673BA
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2025 13:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747833048; cv=none; b=qjZweqG7SLKWG0dOTKbyLWwcTItjgV5pJpDQBqIW6iV5tnmDdgLZFVTxgRPRLvtkdHI+VDCo96esdFjWj8qYYCmI3ztJ0XAwINNBbLJ8rpeZZ2/7wqWSJYZN1Ym3kQ1mf+U0psnzTsnn7dh0tsCcFfD27o6Vzp11xus84py8/AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747833048; c=relaxed/simple;
	bh=Pou7Zf1nWdBAa81MsiRtS+CcK5ufoZZj5UNXInbNfnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q5p7TvbkgKTqpGauwXxO2P89pLAXrkexEBFr1Sb0WpBOyBCwjgv1tvC7gAe9Bgtck81Kq3C4+GD8TVEumuv1K7LBkXFhqkQGhkZfBSlVi7Q6F1NziiwAb/6EVzTrXPHAlwTlia7pnYjmqXvVSaXznDXGCd7rN5hXVVqzoV2Jz/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CYAarRUY; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CYAarRUY"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54L9XSDR016644
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2025 13:10:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=3Ny/4RwhOxpOmW4rwp1crSoL
	yoLz1hawgITXEILYp1I=; b=CYAarRUY8eShDDQQXm6E0pYbgAweu46zPiHfIjrr
	usOr/DM0N7EwsWUIg+Iymx3dX0gXNBrol+ymBwYrGpiLPnIVx0hA+R4Jl5iDLrp4
	Bx/c1KspxwplPilU/4XCnFD90aACtX+6zm9BJyYAy/enjoj3EYHAZZYaaiaIYrDU
	qPjrxd0/MnV+XBdeTP17ZvgNtPfIMhdCWb9d1BQ6d1RGi/XKlnxopDNUZm54ck6t
	vjlIcVswgbpWbheZGedHegPoHyVyx/JsBYWOijQMmz6uuFJEHccmvUeX/Q5IS9ce
	F/si2F38Uj9qtChmHpPlXOLWxjMk7WIVwro/6NYo4/G5kA==
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46rwf9u216-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2025 13:10:45 +0000 (GMT)
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3dc88ab5cd6so6382515ab.3
        for <linux-scsi@vger.kernel.org>; Wed, 21 May 2025 06:10:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747833044; x=1748437844;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Ny/4RwhOxpOmW4rwp1crSoLyoLz1hawgITXEILYp1I=;
        b=CeSZ35AQyf2UbP1r5Ba2tTVo0Nj0qNtXhvw3JPjDT0ehSxI1X6LAncbZ3nybSFzNi9
         zS4d1ypKHaO4B245p8dcpF7hA92TqLh+Pn+rUpXuBEjBl0WCaD/QDxqY4c6f6FczvWJk
         sK7PjgnPPbAzAdBm5RfftoFNtcFb67FWjEOhBpS2mjDKyd2TWHXy0xpHnGblTOJYYJcE
         8jvt22tAODghFv+yMKH6YujUWM23JlBcEOYnMeoFZ496yKBoimzyDqVfaDRDcdbKGIlG
         Gpd+fFINSA6iHO+GfyHvvLPL0pXrnAmpFXPR7PS4Pup9L+UjjH5dm9y63rT1yWEh9PY8
         0U6w==
X-Forwarded-Encrypted: i=1; AJvYcCUdGfo8OM20Qmp+OSzIR8N0sLYEsxYEUudrYTauco/+TnsExM82jn7od5p9DEQqkFtz3K2HP6P7lzhr@vger.kernel.org
X-Gm-Message-State: AOJu0Ywo2f2LsafJyPWILhciZSG4EjbZMDheVOpJN3I4ZwmwKXG6+Zsf
	e6wN3lFugjAaCuLTaQ/sEX1083VRU6LzlEpqa+ILpHfTyfULLo/g4UDKEthX3MELOKDwm9smfD/
	yiOOyeMnQ/Tocej+fGzDxMQN6Z1H8tmWJUpBGSPv6IU+GuQeeV1AnprTKwQLFvxAZ
X-Gm-Gg: ASbGncv2ussGaTuOLwEGqWkJ1BAnBcSqU4SZ2uygQijxydSHRtWUw4o7zpd/X6xAXY7
	8meHSTMo65zcGML7+ToiPhz05WFIlzw90Lyj3tIMdMY7hB9f7dWf+X6EZUtUccob0NtJk/sFIYv
	oUAvP5sMif0j58K6OQEHN259hcX63rqI8ahfGYVKDYUGxQMb3IIprzj1SQwx+EQfDYvcedtKX5B
	IH8QpP4Di+Vo8MDwPQ6t0Z4ZQ2qvfEH/8D+PtznXhdIUECETJf4o3KIclV+17ixW4gc01DrSntK
	MbsbtLD7fMP9QK9A+AUEbRynn3qV8ZMEMq23xYJGD9sKmS5M85hu/UNV8Zn4BRnV1ijBy5FCE7M
	=
X-Received: by 2002:a05:6e02:5e07:b0:3dc:757b:3fb2 with SMTP id e9e14a558f8ab-3dc757b446fmr75183505ab.7.1747833044288;
        Wed, 21 May 2025 06:10:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKoNhtb+5owKr4FzQyiElr9BMC7t8S+TkjVWacZxR6aDGOYdAfaPB2hP5Fm4Afpv3YSeiSkw==
X-Received: by 2002:a05:6e02:5e07:b0:3dc:757b:3fb2 with SMTP id e9e14a558f8ab-3dc757b446fmr75183255ab.7.1747833043939;
        Wed, 21 May 2025 06:10:43 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-550e7017e79sm2826647e87.154.2025.05.21.06.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 06:10:43 -0700 (PDT)
Date: Wed, 21 May 2025 16:10:41 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Nitin Rawat <quic_nitirawa@quicinc.com>, vkoul@kernel.org,
        kishon@kernel.org, manivannan.sadhasivam@linaro.org,
        James.Bottomley@hansenpartnership.com, bvanassche@acm.org,
        andersson@kernel.org, neil.armstrong@linaro.org,
        konrad.dybcio@oss.qualcomm.com, quic_rdwivedi@quicinc.com,
        quic_cang@quicinc.com, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V5 00/11] Refactor ufs phy powerup sequence
Message-ID: <ni7kedpcz7vchztb5qrs5msdt37mfdoabtt4gdqsaiwmbxlb2a@im4wurr77z43>
References: <20250515162722.6933-1-quic_nitirawa@quicinc.com>
 <yq1msb6lowo.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1msb6lowo.fsf@ca-mkp.ca.oracle.com>
X-Authority-Analysis: v=2.4 cv=V9990fni c=1 sm=1 tr=0 ts=682dd0d5 cx=c_pps
 a=i7ujPs/ZFudY1OxzqguLDw==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=dt9VzEwgFbYA:10 a=66i0CxVaxzDmHRmSCfsA:9 a=CjuIK1q_8ugA:10
 a=Ti5FldxQo0BAkOmdeC3H:22
X-Proofpoint-ORIG-GUID: tQir3HCnWPmVho_8hUfiGDSdt391gHLL
X-Proofpoint-GUID: tQir3HCnWPmVho_8hUfiGDSdt391gHLL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDEyNyBTYWx0ZWRfX+j2TCrpj/bca
 eLyNQF/IKpJIp0ilBpFZ1iYJSM4KKG0FBgGtSXexJwG2Z2ypOxm9yotFb2DOkboCyKueUnFq1Ya
 YdfH5EtzVaoqVwol1djmG9+1rVPf1SvGWIqCDYW4AS8VRXjcSg0hLH7RZIRmLSry+UJ9D6F0uhz
 0VJIEyO4O5xI5B/+krWLmD34JP8cSv0UeBT/oXJ1R77b/TUyqQjvQz+GHTkCe9fHba5hNWJMOim
 W6PHkm6wx3vijKoIf4fCPzCTxp0aHQO3f7Ap/AWhlD99rdiSkJ6R5sMuY2f0kOS4fzGH9pVkAkq
 G4D/kq+h0guq9whZVxKGZdOA9SZ5unLXjD5w+vnE32pNH6x9csk6LwHFN+QqyveWowUjmc21VYs
 n2sWh8yQnH8Hp1gUAHop8yDJ+pyT3Tg41qIvRERmV2UR5vQlXIIKXbBp/lNsqqjJokmWXV9W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_04,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxlogscore=860 bulkscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505210127

On Tue, May 20, 2025 at 09:45:40PM -0400, Martin K. Petersen wrote:
> 
> Hi Nitin!
> 
> > Nitin Rawat (11):
> >   scsi: ufs: qcom: add a new phy calibrate API call
> >   phy: qcom-qmp-ufs: Rename qmp_ufs_enable and qmp_ufs_power_on
> >   phy: qcom-qmp-ufs: Refactor phy_power_on and phy_calibrate callbacks
> >   phy: qcom-qmp-ufs: Refactor UFS PHY reset
> >   phy: qcom-qmp-ufs: Remove qmp_ufs_com_init()
> >   phy: qcom-qmp-ufs: Rename qmp_ufs_power_off
> >   phy: qcom-qmp-ufs: Remove qmp_ufs_exit() and Inline qmp_ufs_com_exit()
> >   phy: qcom-qmp-ufs: refactor qmp_ufs_power_off
> >   scsi: ufs: qcom : Refactor phy_power_on/off calls
> >   scsi: ufs: qcom : Introduce phy_power_on/off wrapper function
> >   scsi: ufs: qcom: Prevent calling phy_exit before phy_init
> 
> What is your intent wrt. getting this series merged? Can the phy: and
> scsi: patches be merged independently?

Unfortunately PHY patches depend on the first scsi patch.

-- 
With best wishes
Dmitry

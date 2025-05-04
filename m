Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D78A32
	for <linux-scsi@vger.kernel.org>; Sun,  4 May 2025 15:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746372465; cv=none; b=BlcZ/7e2bZXhAaWo7s45ION4cyjIWZGQ4yh2AIsU2QKopVn74ePbqRvbTfxeFTcxKLDpYRaxsHR9bwMB8Whzl5DXd03CwePmKXSdPsufhRI1gn53uIH4HLPQ9v9yw0VVizciizPtqL+N6qjBVuC5mK8zIINnf3zt0VSqAX4x9ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746372465; c=relaxed/simple;
	bh=LUmwgjsGIZY3yOOJYl4bu107Ntl6Jtj40wTSgSGzqeg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OX9yI61URt/4sGOHhBxz+fNyHLiBa+N8YjRBKLDHzGxWuPNsFgNV1qODRasyYAkCOAlM35sQIeSsmyxEBj6J33DLxsdgzN+8QBkl5CwRKro+7xUNOt6guumjh/tIPLSePj/lI6PDQUbkc+zGhZvbKYwMns8bsuDp9jhzxi6hlwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OEjiQ9sv; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OEjiQ9sv"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 544CoEiv014413
	for <linux-scsi@vger.kernel.org>; Sun, 4 May 2025 15:27:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=uMiOZyNbZ5taHnkDse6HWXJ6
	dUdIIbmPQ3Vxz/Yy7xI=; b=OEjiQ9svz1JEfaxj2JOruNUd826815zcljHZNM/i
	MyxtwzNfmBwd3UMcPzkt2dqVE5sfBBjJPA+GYtHqP0XdbjeQL+WIxReGWvCG9JGT
	q0IzTeWwrFRREV58xBnBKgtKHSCAsO6czaGLTZfoZTQmqFNaQfp/Cy30uE4s8iDx
	5baCw6/DIviJNWSaiQRzoPxB5uIrVrJ1wbJsJTr+uI1BmkB4I/3KYcTgSVIDUFnA
	Fh3bWVKzoAOpGGrr3bbayRPXMGvHul5FTP0r8dtFM3kSSQlwSdJs6IhKTBS7SLYM
	oGAl5sXC5Ta8mrUBQSlUhVFtJhGPaS8StNthjlSnISCDtA==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46dd3n1ykq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sun, 04 May 2025 15:27:41 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c9305d29abso715653785a.1
        for <linux-scsi@vger.kernel.org>; Sun, 04 May 2025 08:27:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746372458; x=1746977258;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uMiOZyNbZ5taHnkDse6HWXJ6dUdIIbmPQ3Vxz/Yy7xI=;
        b=Oe1orUq2JYyVZt5zNNkZbN5HS1HsBfMSrwsJRlztlfR1r5LjKz4S5yTjH6O6yYp16u
         JRva86IakCAvryHQ53vuJ3UfsGy6nUCOfaxB63Cjs0Vk02g+BoalLZSFXcA+2p2pKBf/
         6QFA9hYAVEOlkjy9O/2orXxXFf7Aa69gocrKrVkx0ERR7YIVUVV7JQazq4D3V6oiwOwB
         0H02ACOpcgYJjkB5z55dHg2J39NKx6OhGvu0gdLvVV4IZwoiCcBRyq8dqRNKRhZhgqhO
         MC6WyhAxYi7McVjrgVSV5JudD5b91wmd6kbOdNqeBqkQcbbYnBqaGSHPPTk+jcnSYtsg
         stFw==
X-Forwarded-Encrypted: i=1; AJvYcCV62nzX+79Xf4NOWDf2ZLK4B0XOPjaSgvq3VhVpQMEmWoO51K7X08NE9Im1GEp06/WVmXI4v0ts06eU@vger.kernel.org
X-Gm-Message-State: AOJu0YzfebQb/eMucU25sxLEEaqlh3QORiKWA0RmMZda3duwZSMJz7nF
	Yeg944yYQUBw8I5u3EsLuCfaWk1zNV2DM83w6+Luinaj76vRwgTOiFM+79wHnrgoB5RiarFkmZp
	3N1IJWA1S3AcVRaeC1H1y86Hi/xB/6aBeubKZr3mSP/VrR5hEd64VKOepjcZO
X-Gm-Gg: ASbGncv4PPkYsP9zixHsUOylCXboXhHiDK+PW3CGepa6pSt82EallO9WN+Vnn+9Y7Tv
	CAUZ4uhtwololKM/ZPHovrWRNoRVzPyhGsACXa5PT1fUbEV345sJZ2UGZjpVImbOCyCnhs8j9o9
	aSvEgKFWxTiwWbC0WiPWKjCT7PTEZp0GxheVwMAQiVhqIjxHJaYY+XFtxhoTk/XnhY37hDL6F8v
	d2V90V+GT+YWwuRSBnaoLJNjPDLFO34Z3DylWnOrjLlIk6KOhRgtAPXShGaLiPcqN3CD53EuFDm
	zcVS31lK8NPo2nv2TPcvdQQFoKdBK8K7oiF00cdukSE1OEqiFBlGvukHXuOH3wMeCKUk8N8t9pg
	=
X-Received: by 2002:a05:620a:454d:b0:7c9:2537:be51 with SMTP id af79cd13be357-7cadfdd5c66mr743898085a.24.1746372458207;
        Sun, 04 May 2025 08:27:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHVX+z7TEc6vt6ylfXVwNT1h9JQA48LH+Jzgzss3FvyThLUZMiNGTS8I+avTmoIzuwv2wL0/w==
X-Received: by 2002:a05:620a:454d:b0:7c9:2537:be51 with SMTP id af79cd13be357-7cadfdd5c66mr743895685a.24.1746372457874;
        Sun, 04 May 2025 08:27:37 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54ea94b179bsm1291505e87.27.2025.05.04.08.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 08:27:37 -0700 (PDT)
Date: Sun, 4 May 2025 18:27:35 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: vkoul@kernel.org, kishon@kernel.org, manivannan.sadhasivam@linaro.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        bvanassche@acm.org, andersson@kernel.org, neil.armstrong@linaro.org,
        konrad.dybcio@oss.qualcomm.com, quic_rdwivedi@quicinc.com,
        quic_cang@quicinc.com, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V4 04/11] phy: qcom-qmp-ufs: Refactor UFS PHY reset
Message-ID: <4nfhtdavca4aqiqfct2wvqdwq5kskfzh5kffnz7utnyreiichw@giixjxypwdcq>
References: <20250503162440.2954-1-quic_nitirawa@quicinc.com>
 <20250503162440.2954-5-quic_nitirawa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250503162440.2954-5-quic_nitirawa@quicinc.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA0MDE0NSBTYWx0ZWRfX7c7E/7MCpa8C
 dGd5Kt7ilYDy0n2VsQicLyW8oLlzMe8lV9l+dNIfAiqE3UCJ+H0nTIQhvp1BfXv4BOkEhS4T6Mk
 73RBHc/eywywI8QTIcNi17DCRNCTlAwVfSiINdsDumRMEhU+VjEvvjF8UUEQFNvZuHpS4o6yo8w
 kDWqitPETdC3a8QTbpGKxQxiQlHYy09gE60yKwBvWla9xeR/KqRZ7vw3uoB6ui/8ZZqEIHn7CuF
 WzAgMgl1Hwhx187Q9w2zNMDSm5h1COxMOYV5e7zXCC75O9vD4XIDBzsUE0TB0gCxFUdQjGnvAVU
 h+4f2Y1TY+bH2Ypn4il16RuUuL1tpWUj9jiTHl5YLwgjWXirGUyh7xrB3jeVfELVotDFiX0/omm
 VjTJqkt0rk9vJPq40V8LaKrXR5UEOE3u/GCRc2KzFYMA9Yrq9oTygS1W/08SjL9GtZdMMtJJ
X-Proofpoint-GUID: V8jYVqr2ELv7ZDXnlK_iKl4OXnJM7rsF
X-Proofpoint-ORIG-GUID: V8jYVqr2ELv7ZDXnlK_iKl4OXnJM7rsF
X-Authority-Analysis: v=2.4 cv=UNDdHDfy c=1 sm=1 tr=0 ts=6817876d cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=dt9VzEwgFbYA:10 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=eTLblWtPMpn9__zQJdEA:9
 a=CjuIK1q_8ugA:10 a=bTQJ7kPSJx9SKPbeHEYW:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-04_06,2025-04-30_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxlogscore=999 adultscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 mlxscore=0 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 malwarescore=0 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2505040145

On Sat, May 03, 2025 at 09:54:33PM +0530, Nitin Rawat wrote:
> Refactor the UFS PHY reset handling to parse the reset logic only once
> during initialization, instead of every resume.
> 
> As part of this change, move the UFS PHY reset parsing logic from
> qmp_phy_power_on to the new qmp_ufs_phy_init function.
> 
> Co-developed-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
> Signed-off-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> ---
>  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 59 +++++++++++++------------
>  1 file changed, 31 insertions(+), 28 deletions(-)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

-- 
With best wishes
Dmitry

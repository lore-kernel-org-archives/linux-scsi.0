Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A5B27B4E1
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 19:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769195922; cv=none; b=LJ5hL2Nbwkzj/+10/rvPg5I92uMhqtntPxlEubdDI6r+kbwyRqWi0sqIENi1vjAIcP26t7sKGxnFdJ32CMX4OUgOE0tW7TwXL40Agr/u7+r77bxtBKEyUDMHJSooBOJaP6GBgaPM/rBgcQCsLTpoJeiPp+g3KK33NC1W83dTntQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769195922; c=relaxed/simple;
	bh=ueOS/CjOndEkDwZzTX9hBzD3FyQPNBUzVSWENVtt+UE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n7GOKkYMGGxNiakUcxZKPkwwf8AzygGz7d1dhlCYwkxIjF2qGk7U4j+XUGXuZ/+qOPyBQ0HAYzpI9i8PTNdiLZeliTXvxcBlyzWWC8Zae5vqDLYQPwpBGqwKuUVTX4ySiK/SjNPcCnATTyKSgCwjJ7+9i0VVoJvI+m3MId/SS70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=m7kGgDjp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bdwJaidv; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="m7kGgDjp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bdwJaidv"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NH3u6v078356
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 19:18:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+w0KZMnh/DWR/lpOvZ20jorLPPBptXzTStJthYI64T8=; b=m7kGgDjpTokoQDpm
	DK3+qMBxYn7CmwPyuu5EKW0D4IXpdt/3NnyDSHqKXJpaSPAOhtvmUXRxclAvkjkF
	/sgNCLzvFMMQfrRuHCsWpikSlABbvneMy+iPUrIzGnxjbk8XejgGBaLJaqoM6Hxb
	VhAonJBbnfhTZf6odPPzHV+Wo594iWIcIninlcnMh1FUvx4TA5puHDWOSfTtUNvx
	v8mQKWEi7ef8lygG0s9YXewhspWt6hnR81ip9B9bI9DKg33A71ScPgVRQIrylBh6
	/vJGX4KmfjYUZHv4F4X+pfeb/sDEusHoOagnR0fsLzEZYaoRtQjrT9xar6aUwkKJ
	1MjXiA==
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com [209.85.217.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bvd2cgdvw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 19:18:40 +0000 (GMT)
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-5ee83da1811so9775524137.0
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 11:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769195919; x=1769800719; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+w0KZMnh/DWR/lpOvZ20jorLPPBptXzTStJthYI64T8=;
        b=bdwJaidv5vX/7Oe56Jv0U7dFtqHkUGeeXyMBStxvKPlatoYYjE8YOMIAGUf2H45FT6
         6EVRpM9JzLhcU8jD3el+4AIOHZZcGBJKfSN3LNpn2YsXTU/0CShU0Uhbrc8R24VsFCUp
         Mn37NuhssP2DLOpFtnxB7YZcxKlVLocd36E8klUsjj4c6GPNUK+T7aNplHdmgAY/vMx8
         uu711sSrlG66qQZUKeEdPREtCGWs0cQ36pDk+X3qpKEBBi0PQhbzjGdLQjA+p06xz8t3
         J/c6SGs7s2HNsUOOeu6ouz/PKnwuaIAAQM1uDlqC1S3XTP+l20BUFMWoIEj/WG25i9jR
         5w0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769195919; x=1769800719;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+w0KZMnh/DWR/lpOvZ20jorLPPBptXzTStJthYI64T8=;
        b=lwvDghdOiEq7n6geRmuiY40op3HA3J1ZG1MQ70HdQTuzjM3ampz0R4HOeI7mDkL23K
         tSIvdkAywglPPO1kJpdZ95HlfnWWry3c1trdBcEHhqbBaBvmMRGbLgmQAY+OOH4/nUtE
         O+p+LqgSzM2EYlspDTTVnuljYM55g33108+TsUClVlBEgzgryFdz2cIgrKcQ+tdPbQqf
         XA1fgwXtaXGRARidANItHzV1RdWSDUUtWmUmFKui2O/9TwLix2wN8XLbsTXOl+P+eVp+
         rzO41M9asZsP6EZ5vJnAg7hUnNVojlMnSC81oTVSv6zQ71DeLVmWo0kKv9CJ3jFrrMik
         o4+A==
X-Forwarded-Encrypted: i=1; AJvYcCUE8HbKooHkyLKppVAF6d39aC0s4e8yB22FE9z7gS07OiAzlKO3KdeGCZUUEkh58KnTXcY0PSnGN/7U@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0lWZHWJLy5plTjezu0S0dP6Npw3jQIObeZ1jZgVNphzxaAZYT
	9s2+KZB4QWQzHU2Iwn5vG2d9gDu2duu6Hv7st9dg+v0Lv0oEQ51nHdz024ZUPfjl5Resmi3zkq6
	NmslcqqJqzLOvpmKmVoDu/MsJ8DmzlWKB4t6KX12I8yLTV9nB+OfqmNy+WzO4Da0g
X-Gm-Gg: AZuq6aLs2EI2eo7PcnNLBH0krqAGYJyGqnKEPVbOeNVeh/raiqQdDZhEP+NE5F+jhbz
	JyZzLr9TW8lKdvWkaxQT8sKL+6ePicuLrTvt95G7DkyyN4xD1T4T0k3s+7SEm8IROkC8oIiJsJO
	rZII7W3Fh/2sEiSx+8Vo2DvsOG5BFOazN0apQ0bdCUMjN/A4OgdDHK1Zr+JLcmj2vrr6emXEbVj
	XbvYi4MShZpKOOWwBBmCczYTG/Gj0ULeYUfEuzEdN2omJ+ChTzHN1Fxz+Hst/r7NESK91cLjZQq
	35F3mS38MDlLgKZWpw7WHZ25KKJ3qkaShVnImnvEEmWem+Hv4A0QGmiokXMUQGWY7jFz43iqhMi
	KOAhCc0qAE74CsGJkvBWMKUBY3lF3QhciEyrCIgtQp2BiLI7WKsKKcIPaXlpSqrWvufv2fKvXuS
	pe6M9zQP3nhVfDHjLK1caPf/Q=
X-Received: by 2002:a05:6102:441a:b0:5ee:a083:7935 with SMTP id ada2fe7eead31-5f54b9d0e63mr1422182137.1.1769195919028;
        Fri, 23 Jan 2026 11:18:39 -0800 (PST)
X-Received: by 2002:a05:6102:441a:b0:5ee:a083:7935 with SMTP id ada2fe7eead31-5f54b9d0e63mr1422175137.1.1769195918480;
        Fri, 23 Jan 2026 11:18:38 -0800 (PST)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59de492c2fcsm877399e87.97.2026.01.23.11.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 11:18:37 -0800 (PST)
Date: Fri, 23 Jan 2026 21:18:36 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 0/3] Enable ICE clock scaling
Message-ID: <cb6g64efyoauel34hsckp3kwfprw7etag3fthqlkucz4ue5ytf@t4gejdalvvow>
References: <20260123-enable-ufs-ice-clock-scaling-v3-0-d0d8532abd98@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260123-enable-ufs-ice-clock-scaling-v3-0-d0d8532abd98@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDE0NyBTYWx0ZWRfXzzQMsfad/8m4
 ZZyrELJZjA4LI9X4s9ozxj1wJE7452Td/nwZIBLeETjLcfRNGfbe4Buipw0iKkqceZFyJN8AKHJ
 jjHwVz2sxkWwcHfgBgidBMEQe+3qKHKZOXUmy2LNbdqkZ3WFtB0lXbzF2CQmLEDD+NJ+xr1HBPw
 JgXXR235TCZPoPae1QWOwcKu8q5XmaZ6KU7XH10iKyUiz4FMgMLzvqi1ij04zOFjcdM/J8pgpTb
 j0zpc0En5/KYLV0kN6y0+4PLFUM4bXCtYZWspFvJgITUWPiQpa118bAx6SG9YyOm6pHCYOVrd1T
 VYTuO4ZTDmQEoI0zuFiseBYww3Etktgmqax6nTCScvxW1FxK83TS8iWIBhaFTpE8qX2MlK9Q8Fe
 IR6ad6zHWL7sWgVawPqy0fgP6wHeBGGPV3OMjZoglqcqbGOzIHP8rniTtQ461SJ6HYriTgAlRXE
 q3VkKFPdYW8K/nIe+KQ==
X-Proofpoint-GUID: -_T7ZZ2V6M9yy-Af7Cp2DJ46yXzLkTcS
X-Proofpoint-ORIG-GUID: -_T7ZZ2V6M9yy-Af7Cp2DJ46yXzLkTcS
X-Authority-Analysis: v=2.4 cv=bapmkePB c=1 sm=1 tr=0 ts=6973c990 cx=c_pps
 a=5HAIKLe1ejAbszaTRHs9Ug==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=Cmxkgl4FijiPsMXLri4A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=gYDTvv6II1OnSo0itH1n:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_03,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 malwarescore=0 bulkscore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601230147

On Fri, Jan 23, 2026 at 12:42:11PM +0530, Abhinaba Rakshit wrote:
> Introduce support for dynamic clock scaling of the ICE (Inline Crypto Engine)
> using the OPP framework. During ICE device probe, the driver now attempts to
> parse an optional OPP table from the ICE-specific device tree node to
> determine minimum and maximum supported frequencies for DVFS-aware operations.
> API qcom_ice_scale_clk is exposed by ICE driver and is invoked by UFS host
> controller driver in response to clock scaling requests, ensuring coordination
> between ICE and host controller.
> 
> For MMC controllers that do not support clock scaling, the ICE clock frequency
> is kept aligned with the MMC controller’s clock rate (TURBO) to ensure
> consistent operation.
> 
> Dynamic clock scaling based on OPP tables enables better power-performance
> trade-offs. By adjusting ICE clock frequencies according to workload and power
> constraints, the system can achieve higher throughput when needed and
> reduce power consumption during idle or low-load conditions.
> 
> The OPP table remains optional, absence of the table will not cause
> probe failure. However, in the absence of an OPP table, ICE clocks will
> remain at their default rates, which may limit performance under
> high-load scenarios or prevent performance optimizations during idle periods.
> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---
> Changes in v3:
> - Avoid clock scaling in case of legacy bindings as suggested.
> - Use of_device_is_compatible to distinguish between legacy and non-legacy bindings.
> - Link to v2: https://lore.kernel.org/r/20251121-enable-ufs-ice-clock-scaling-v2-0-66cb72998041@oss.qualcomm.com
> 
> Changes in v2:
> - Use OPP-table instead of freq-table-hz for clock scaling.
> - Enable clock scaling for legacy targets as well, by fetching frequencies from storage opp-table.
> - Introduce has_opp variable in qcom_ice structure to keep track, if ICE instance has dedicated OPP-table registered.
> - Combined the changes for patch-series <20251001-set-ice-clock-to-turbo-v1-1-7b802cf61dda@oss.qualcomm.com> as suggested.
> - Link to v1: https://lore.kernel.org/r/20251001-enable-ufs-ice-clock-scaling-v1-0-ec956160b696@oss.qualcomm.com
> 
> ---
> Abhinaba Rakshit (3):

DT binding changes should be a part of the same series.

>       soc: qcom: ice: Add OPP-based clock scaling support for ICE
>       ufs: host: Add ICE clock scaling during UFS clock changes
>       soc: qcom: ice: Set ICE clk to TURBO on probe
> 
>  drivers/soc/qcom/ice.c      | 68 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/ufs/host/ufs-qcom.c | 15 ++++++++++
>  include/soc/qcom/ice.h      |  1 +
>  3 files changed, 84 insertions(+)
> ---
> base-commit: fe4d0dea039f2befb93f27569593ec209843b0f5
> change-id: 20251120-enable-ufs-ice-clock-scaling-b063caf3e6f9
> 
> Best regards,
> -- 
> Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> 

-- 
With best wishes
Dmitry

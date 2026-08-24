Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7C139891D
	for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2026 08:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787558500; cv=none; b=SPzuajjbzkARvVA3GPeEeSoo2TU2x4DgmMFQyeQ1C91YfO6TTrPUq53G8pShZB1NHB9fO66sSR9Vy1n/eh/3jZ+rPFir7fAJmW8ZJISQbfPu26u72oVh6QOMdu54rYW93uXYRP8ATE3mgM81gxE++f7oHshB9Bk8goT6XmA80r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787558500; c=relaxed/simple;
	bh=vP7KFRuxv5/PvNudwnrv8A7AdwTbutFf3LNghXEf8Es=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YGOa2aMlkHu4OseTmDr6B6ShBxuKPRJwCMZavkgGg3sY5Ar5YXalTgQOWca0uhd0IUsXueq5tbavZgPe3+rVN9bgSRM0Pa9dr5XUwKuvQt4j2KuhwmQtX4/yabimjF1pMuseq3xlOVxlISsR7WV7aiFgMyqlyanAhDAk6YZaKQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eQWswynp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=B9JX2uTt; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eQWswynp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="B9JX2uTt"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67O5RGs61008312
	for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2026 08:01:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=ukMn0O890BjOQtEZhd0gOFgJ
	Vu4vFO2RS+3Y7jP/DNA=; b=eQWswynp7awzOnk+lg3cTUgKBINakVAZYttmSMUt
	v5m7b4ljZwERwWvwgY/xuaqkz3W1YmGlUAFfajCkZYqeYBKVHVa/e5ABoFN5SMoN
	yxS3WpI4viKvcGwqP8WB4HKOhYKAxGprYK6I5lmt/OSwgCQFaj2w+rF4YzW8Lu58
	hncuzdWkMrMbK2S7DXluKW/B/HTa4LkR6VPEfAGqUoxl4sVmFq+kvtjG5h2mD0ms
	l56HNY3vHVMkiqZmEcmTkf4dKs0JTx61zgY9aEiqhW0RIjZt44Ja5tKxdu/H1trS
	b5c/9Y1vDZowrMdQkHwu2iXgPUn8utBZHy29DpYp7+bdZA==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g74xhdvjb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2026 08:01:38 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5276aa86d00so34774971cf.2
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2026 01:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787558498; x=1788163298; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ukMn0O890BjOQtEZhd0gOFgJVu4vFO2RS+3Y7jP/DNA=;
        b=B9JX2uTt2+bZCIPWEBqD3uUP8cUOTEhi2kqg1r9QY1/KJnAnQzgIyLy8ElT0YCKJXf
         AwD+IYtyygzgYo6cYgfcgKmTgRAWbWLdCIXS8QKp1Sv3iFl5Q4+sAslocUSYYfulmEOJ
         7k1JIYMIMOIcHdEJDpXMQK3oXtOFGmm4Of06Rm1x25VOup/2y4K9B93scxEx4r0cHOc3
         AuEv9ka7zBdz1NH3Bnc4HhUTNVEVRMj8xb/On6UewgbdqpLV6ruX2vQAMHB35PF4lF5I
         pmKN7n0Ls9M/uEGsPijl+IhWbJaVmkXEe4UTZpGWHZbMO/AsSFOccZq9lwwRm7U/9YtY
         UYwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787558498; x=1788163298;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ukMn0O890BjOQtEZhd0gOFgJVu4vFO2RS+3Y7jP/DNA=;
        b=a+x22HpoJ+K7D59f+Hr/NrtdZfyWuAwVSjm+iw3uaOirEMt6/wuS3566d6HNWdPAZB
         vlhMrKYAVZzRZugW7Wkx+bYxTAddj3HHjBhkFMdFvR2MAkaViU72f/4J70/wwHeeQRrN
         EXx5dLfyu/URegQa0q7PV3SDWAdbdg2zzTwKpzx1hy1T7IPXDTKLxtVZS/dnSb0G+KsT
         aSGzqMBHNOokrQ/7/VKsEmOgsf9WQ670YvuPNGGBg5H5yB1RJzGkeK5THjQ7VPv6vVqd
         ojktxg6WjpaC9ILyYsTp3I7Nl7hncZ9WTGG3N7nEcRV0uoqZlV0sfbnO0gO+NMUDtGP6
         OERw==
X-Forwarded-Encrypted: i=1; AHgh+RpXToKYHamVWtGwTiZw6odHK8z1/lPrKCm+TlKHZRH0D84Y5A4C4cxA/8oyHAz4E0RO4dfROjYe47fM@vger.kernel.org
X-Gm-Message-State: AFuF++mdONtIY5LMMJUCqeE8ewNq7AWJOFR/+QLT8juYVuowJpjEf5Y/
	8y8sFmz+QiEL8BsXU6p5Wx5KTXDaV8R/HvELMS13iGEQnmwh68L8IDzMbgqNtUn+UQ7L3AecS8x
	FhD/5HOn//7iObbALbfFAple/u6RtJ+gyT02u6wtKvBONuztMbr5fJZko4GyqeObW
X-Gm-Gg: AR+sD10zl9Qg2gpr7wrpJamPFycSLytu3AqIsCRPWqCBbVQYSXTIy4PKwmsCgUn5XAF
	/T/+EC8pHKJnQw/me3WbXOmZBNDC2/CEavqOn4dTVEnW6QVKgbX6JgJxw/Dkr/jbsbdcO9z9YAd
	tsnr1VAhK+gbynNRCj+J4KjbFHv6eQeD9wQ82z/p1vSlHnMLSxZPf/2Mg+lRDbmHKbVtGBMvEOL
	7yvwmGadoUITvjlat9QmWglSjr60FWCgqGq6UQt1i0Dxww9ogPQdy6EPO9VegLs1jZuGGBIvTN+
	CUcWTYcPAa9jXVl5N9RuV/A9FnFlts5inXk7xD+lQV+6ITKicjFwOQZmMmiBxXtJdXIZI5CQOUq
	gy/rF7lEcFBTGKP0=
X-Received: by 2002:a05:622a:4c0c:b0:51a:8c79:a2d with SMTP id d75a77b69052e-52df56e5052mr252527001cf.1.1787558497456;
        Mon, 24 Aug 2026 01:01:37 -0700 (PDT)
X-Received: by 2002:a05:622a:4c0c:b0:51a:8c79:a2d with SMTP id d75a77b69052e-52df56e5052mr252526211cf.1.1787558496975;
        Mon, 24 Aug 2026 01:01:36 -0700 (PDT)
Received: from oss.qualcomm.com ([188.27.161.240])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24962bd8fasm1736480866b.28.2026.08.24.01.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 01:01:35 -0700 (PDT)
Date: Mon, 24 Aug 2026 11:01:32 +0300
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v12 2/6] ufs: host: Add ICE clock scaling during UFS
 clock changes
Message-ID: <v7mmy3emjbeorjy7zfrbgqmozu37whvisidk5uba4o5jeqq5t2@ntjncu6bywtx>
References: <20260824-enable-ice-clock-scaling-v12-0-09271f583dc6@oss.qualcomm.com>
 <20260824-enable-ice-clock-scaling-v12-2-09271f583dc6@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824-enable-ice-clock-scaling-v12-2-09271f583dc6@oss.qualcomm.com>
X-Proofpoint-ORIG-GUID: PWomhnaHwHN_wcu4XAzjaZ3sqRrewUdD
X-Authority-Analysis: v=2.4 cv=GdQnWwXL c=1 sm=1 tr=0 ts=6a8bfa62 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=wUpz7uCjLrEXi01cjX+DLw==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=yPCof4ZbAAAA:8 a=8RJfRLJrmUUAMqN4eEsA:9
 a=CjuIK1q_8ugA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI0MDA3MCBTYWx0ZWRfXyDHWf8Gz/ZV8
 OybzPpC9AllgC9YgXTorHYEu1AtmpJNByZ0f5c1nJ6lhbplHUitircxLxIdjJjfh7qlebFRfmjS
 gUgLwxQUzFy54zo8P0/KZzlWsUM6UI8Wcpdc5P3jtz173VWTkLMxcE9ay+sjqqHsCiFOXttu/X8
 b2EF0H4j2NtIZQF4T5dCJYgVBTqEHybWy/bNDufjRD0NoqTlkHinJrJSwR1HLZL81NSOvOTZYmD
 71s1CbhcnUsn8JKs53D7sRsnp0lV1r7K/PPhbP3XzhnObD0RDbiCEPKRfNuWxxbFnvIVmV8zIM8
 8E6nl77kvDFAyRiDmYSWrSUAFKT8ZCv6/mCqz5mPlZMD9Bv0IY18m55TVMs3/ngUuf00J1SjFjG
 xZs+8Xz0bHZRiFCavRBN66MxPSCfrXdq1ajCmDpFkirTveN5/lwwRy6XANHxjoz/j2G3kvO5t5f
 bJaPWoeBpmgXD4YdQOQ==
X-Proofpoint-GUID: PWomhnaHwHN_wcu4XAzjaZ3sqRrewUdD
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI0MDA3MCBTYWx0ZWRfX+pGPyy8O7I2B
 gqz20Ibbs8bxZ5eHbWm0yqrhygo03a1xwGImOYShmha1i77uBzyOxKmkg+FZpG1vdEydzDIlM4w
 yYM+648EZHUQH8KsQaJ6W+yo53GI+Bk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-24_02,2026-08-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608240070

On 26-08-24 01:17:39, Abhinaba Rakshit wrote:
> Implement ICE (Inline Crypto Engine) clock scaling in sync with
> UFS controller clock scaling. This ensures that the ICE operates at
> an appropriate frequency when the UFS clocks are scaled up or down,
> improving performance and maintaining stability for crypto operations.
> 
> For scale_up operation ensure to pass ~round_ceil (round_floor)
> and vice-versa for scale_down operations.
> 
> In case of OPP scaling is not supported by ICE, ensure to not prevent
> devfreq for UFS, as ICE OPP-table is optional.
> 
> Acked-by: Manivannan Sadhasivam <mani@kernel.org>
> Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>

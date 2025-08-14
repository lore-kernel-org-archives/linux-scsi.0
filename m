Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B9A25BEF3
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 06:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755154570; cv=none; b=pY6BNei46ctrgbHi2Gtp+kOpdbTxaK596xn836dO4w11qoMbP0NegdOQRdRYdmbGkRq2u1NUg1IiduWMIh6BC3CnJPv+LyoIcgj4Plm92Fw5uR+qb3vMUvY48/0WfIW6uJ9N5UueJ8QN3Zrf0Mii3TRaHXxRTzkUdiZnOT1mLcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755154570; c=relaxed/simple;
	bh=Z0U7PjtN+kG7WBV1dWh9tbgD5U+ORVUekeXfSD0DKxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GGzzCC+sYgHGMo88wsvSLDLSoGedLZdN65zhLwzi1PDGHtbSGs5KtfzNbwRgObKB5WZfrhcJbmp7pqXdN5iOQKBkiGG/bfgxecS1IBYwKEYy6KLfcJxrLe0t04/Ge2qcRZ89rkgNY1lAVqHhncxzGbr6RPRIHEo0wq4Tq5RaKKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OZD7Az6h; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OZD7Az6h"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DM0wOr012959
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 06:56:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=446NGPC4IHTmfxm6TNEJ0F5d
	cdGOD5iAOKWcZQN3Tyk=; b=OZD7Az6hQdCV3hnFFaBeTxMouTOtSCMGZRTKyvfr
	CkcjX5ZJBlI46LCZnKcLbqGoMfGf1MGiKv6wkjzEPOgT7EhAaT7MG8oCsBwYI+kK
	VNe4AH22aVSyV2fw1q9ZbtrUbkSo6Y26Lm902j9Z1tbaR1tDeCylk4hXm/o9Fz6A
	Fgbr9adslP6BkVhiuRGFFKcQ4HeGxVkbICawX8v6TXxfPGgNybsIFe66VTBcXGh3
	KmZ4szc5c3TPmD9TXM7zcSn8ttke7uRRwT0cWGjXS5vHzBZaCX6KJcdRT4PE0ur/
	+pPJcGP0WQKqkC9B7P79HnhE/Zs0QE0NZPuYcVl3GftKEg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48ffq6theg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 06:56:07 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7e8704d540cso69397385a.1
        for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 23:56:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755154566; x=1755759366;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=446NGPC4IHTmfxm6TNEJ0F5dcdGOD5iAOKWcZQN3Tyk=;
        b=vRqQqE3iUf4do+btTYSdmscgYAGXunctoffHmdaoQ760i1VBSMd+AVLt+Ref/iexd7
         mjfbyWtjsGPeUQxwt6AnrgxF80b++vcfZssQc/eC9HFWWY0oH/OY35C/gkSWCMXkkpGf
         iZPASiBsTDVzUY72llDyGTJAG/3iIHsRUtQzGsPgJaOgLwFBPHK7v+oxwkmxsBnHBc18
         qh+wm3nTFN9cCCPsnSphhPvABhh/Cb3nXEus2bvFsxHpSAM+Ted7ge5pzu0sLe7RMtSX
         UbDaGAbkjCaoT+8mhzQibPsSMguRftbDsdhspCWNRgv/Bwyvq6pmzz26GgldvG0Kwr8S
         qlEg==
X-Forwarded-Encrypted: i=1; AJvYcCXRyYlFKbzr9FkgGnuj8G7TPoMSw8gm77+a9euB6j+8hOX8C4RbpAXS+2bdsBVF/CaFKgmWc+dOa5l6@vger.kernel.org
X-Gm-Message-State: AOJu0YzGhjQcG1b8h6xHkDAcPQuoFnjYyfTyyuiTCeVpXyxOaUfgx9IF
	MTaChXfAsgJjDL920dZB6JE7frAocl5HKXiLNWyBP1mCGX2Hks5DbaacOfJCK76epMtbU8II2kT
	GolAGflpd2z0dUpO9uX6mAN+/FSPNVj67Nv59I+KCGo0An+yS0YNAvyWuCv/s6KZ8
X-Gm-Gg: ASbGncsidI9BbX4I8fl+CyUJUAqIfv6V/z7youTYsHVwW7tny6vK148fmThQaX2qtZA
	77r/vvuC8DpnOPsWG1ZPFjVMqKVbyZ3HJKtxtwNuHG/A1T0DlXo4i48FIHCTzDmCL9YtJzKL04u
	z7oirwrhiNaJJvM+7NolmX2d4dL1NykNEeWf8dbE7+Pl4sOeBrioNji7jbyMjhCuB+vyE86XyxX
	3DKudZd2XGQU93m57sqSOybwSveTP3Zr3JHAMULVGpXLRDXjgQHVgPyHCwJYz4Id8pfPUK7qWFO
	/9mcUcGwoTfPAhAW9bR2G2uYv17cBIE74NrE7BEvbSFmY4gtclnmT/VsJ0yHrHn5pVLS6Ofd7fL
	0jL6wNYbTEKG3jNlVdppw2bc4QITI/CCjXeCY5KD+z53gRMUDhTf6
X-Received: by 2002:a05:622a:1887:b0:4a9:cff3:68a2 with SMTP id d75a77b69052e-4b10aa6271bmr31969081cf.37.1755154565851;
        Wed, 13 Aug 2025 23:56:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEu4eE3QLS9jnWgL6hZSYfORd2c5h9kWoE1NL/aOYxfZybe6CsmPBNHqWg40mW34hJP+Uy4Ww==
X-Received: by 2002:a05:622a:1887:b0:4a9:cff3:68a2 with SMTP id d75a77b69052e-4b10aa6271bmr31968791cf.37.1755154565366;
        Wed, 13 Aug 2025 23:56:05 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a0c3-3a00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a0c3:3a00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55cc859266dsm2374101e87.38.2025.08.13.23.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 23:56:03 -0700 (PDT)
Date: Thu, 14 Aug 2025 09:56:01 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>
Cc: marcus@nazgul.ch, kirill@korins.ky, vkoul@kernel.org, kishon@kernel.org,
        robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
        mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, andersson@kernel.org, agross@kernel.org,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/3] dt-bindings: describe x1e80100 ufs
Message-ID: <iezjm5d5o7ec7jqweyip2vcqtjv3icidw34yq36k7blxuff2sf@ou7ub3cpwx2k>
References: <20250814005904.39173-1-harrison.vanderbyl@gmail.com>
 <20250814005904.39173-2-harrison.vanderbyl@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814005904.39173-2-harrison.vanderbyl@gmail.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDA3NSBTYWx0ZWRfX7+lQxnJcfZ95
 kVuheijiNwZbTGXZKdW/UHRiLvr3txp9wR5xzXxPKgtUTZpKRvAwbEahSzFk/wf1SLlL45pXqSi
 sF8QRqE4qlWgRu7kUy8HT1VVYW4RPKWIECG4kZV7CYOeeO6alU2PJFbVGw1jevTMdURcbIevbsu
 CVPj0FdEGgFKHAvHRPF124TXIPEfXAjy43dpF7cxvqqGERSNuwwMsaC27Cn0kwUVBOpswyJ7dUi
 Y9V76scuegTvr73qOuRYIqoYrRo37BcWwQCw3jppEPqfFXBnBlWwhpcamBXKG/nSS6tnVxcPmVZ
 CjStiEYMmX518n20goLX0d212JIy5FNyarXpAAxe9wlVbVF/o1GxpeELNPwno08jcqUT6/PflVV
 +iBvb1aP
X-Authority-Analysis: v=2.4 cv=TLZFS0la c=1 sm=1 tr=0 ts=689d8887 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=pGLkceISAAAA:8 a=2WfLOqSWa4--05Z-PRIA:9 a=CjuIK1q_8ugA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-GUID: NutrkHv1AFsI9LW_rH5uyVH64MfPqGXu
X-Proofpoint-ORIG-GUID: NutrkHv1AFsI9LW_rH5uyVH64MfPqGXu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_02,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508110075

On Thu, Aug 14, 2025 at 10:59:02AM +1000, Harrison Vanderbyl wrote:
> Describe dt-bindings entries for x1e80100 ufs device
> Signed-off-by: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>

EMpty line before the SoB tag, UFS not ufs.

> ---
>  .../devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml      | 2 ++
>  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml             | 2 ++

These two files are going to be merged by different maintainers through
different trees. Please split into two patches.

>  2 files changed, 4 insertions(+)
> 

-- 
With best wishes
Dmitry

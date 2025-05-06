Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DA52D4414;
	Tue,  6 May 2025 04:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746505564; cv=none; b=oMvfHcCxb4x3BmosIY5rGscxvltom4/HYZvJ6CW3GndPaMwGkJt2XC/1r03HeWpNWbdb7IK4AWsvWyvYq5KfGnIPiBob5Cv1OGjBNZaDwqWkKAFLFJ1ocY5U99wnC+Pk7AtRfyBLRcMULVTR9kF045r3Zmc8kP9IthCSMsVEYbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746505564; c=relaxed/simple;
	bh=6XhzECDVUMB3Tn5K1eDHqsOmvUyFRj+/hbcpeCt5JPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S6K3NvbmXAFcEZXOJJQRgpz6mtjIvS7w5czRKhcFBlP4OMQcbs9yZDXo5BN86anV4HkavsWQyz4uwldjqDmBeM8/5hNWI3152h5jGvStkm2YkYEGSz4SdTjHwVC/ouZZCwfhXeu4itrXIhbELvn086HII598CqvVC3zFx5jpiGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nHuPdBK9; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nHuPdBK9"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54638Cb4002318;
	Tue, 6 May 2025 04:25:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QO48kPvY5xCVh8WLZPWxdbiEaXfMJW3VKCmOMA+t2k0=; b=
	nHuPdBK9z0fgOCgoe/m3/YfTZfGRDvWXgySFs8NH1UUfLZ8t/Xwipj020uS/qmDC
	r2w8IAYLmaFcpnRbMP9Bg0blHCap8mKeGeql0j1z5Oli5iJAzhMa7/cXtqJiT6OV
	4P7tiHRyTV0O2PLzwQGiNNXRTInCdyXLltZKBpOhtAuW5b8cJE8rByyNu7hSRf6q
	wyAuvdXZYROPqMeciJinOvrzU1Jg1lqMZ5f8y0e7kBoRGFnA/FMpKqIhf4P6FDoG
	tatoEpF8dCPM1XmhVi35LHYjqyzmng2RlMzGGKE1X3i73J69fN3Qbnf+bS92Y4xA
	60V77WrfZN18FQPQejWGTg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46fa80r24x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 04:25:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5461enC0036150;
	Tue, 6 May 2025 04:25:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46d9k8gppj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 04:25:57 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5464Pr4C012838;
	Tue, 6 May 2025 04:25:56 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 46d9k8gpmt-4;
	Tue, 06 May 2025 04:25:56 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Nilesh Javali <njavali@marvell.com>, Kees Cook <kees@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: qla4xxx: Remove duplicate struct crb_addr_pair
Date: Tue,  6 May 2025 00:25:22 -0400
Message-ID: <174649624840.3806817.4773433631061640874.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250426062010.work.878-kees@kernel.org>
References: <20250426062010.work.878-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-06_02,2025-05-05_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505060039
X-Authority-Analysis: v=2.4 cv=GqBC+l1C c=1 sm=1 tr=0 ts=68198f56 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=gieQ7GMfMR2A4jGg8wMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: zUM30dJ537Ya5HC_KkWStI7SnBmh7819
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA2MDAzOSBTYWx0ZWRfX8FSdcim2BloV mrAHKVhkKXu/tkzIUhGfN0sFrRxjgwFhfj8dNC1LI+F77wJMgACHJ57sFbq9bMnI70hlR7IFHK3 K93kjdfrwVZHVKr5Sg0SprLo+l90J0LtkR8+O2kJ2UD5Yq4ASz5+kxHev243BzlMnq7oxud/Y4o
 ewHcSuwftZh64//cuZ6Dm3+Ef2Cuye+eZBzbkAHMmyPSZZ7eifoU6y2ItsrO9aiinHUBsIEvMCj O8tAScr0J498BPl6dA44KdTITLRMeMF+626i+PPEhkR4ueC9TljVHxx8733AWkQOIfk/zz2vwbJ 83sEE39ZQDo0MbkBjcEGOPVLRNCr3u7A6fqOd+x5ukCrWMEuk8EFQu1t+UH24O5WqjEntiwEfnT
 lYVSVRVsVg+IIFLeXuzaXt+NQ/shHRP1dsxBxwiUoe0H7aPHHz5LB6EnZX9jjGIc0NCLc0Nm
X-Proofpoint-ORIG-GUID: zUM30dJ537Ya5HC_KkWStI7SnBmh7819

On Fri, 25 Apr 2025 23:20:11 -0700, Kees Cook wrote:

> In preparation for making the kmalloc family of allocators type aware,
> we need to make sure that the returned type from the allocation matches
> the type of the variable being assigned. (Before, the allocator would
> always return "void *", which can be implicitly cast to any pointer type.)
> 
> The assigned type is "struct crb_addr_pair *" and the returned type will
> be a _different_ "struct crb_addr_pair *", causing a warning. This really
> stumped me for a bit. :) Drop the redundant declaration.
> 
> [...]

Applied to 6.16/scsi-queue, thanks!

[1/1] scsi: qla4xxx: Remove duplicate struct crb_addr_pair
      https://git.kernel.org/mkp/scsi/c/3d030e2feb8a

-- 
Martin K. Petersen	Oracle Linux Engineering

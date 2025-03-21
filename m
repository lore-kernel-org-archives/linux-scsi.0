Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656CB2CCDB;
	Fri, 21 Mar 2025 00:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742517449; cv=none; b=SzFKN0UtTvu49yNCL0N1VNK4pmh4idt/fXKXOCdpDiK1oaq0Ebrqvs4c5xgw0k1hy7fAbEffLIfLhcNRP1D+/qZN3Vrqz7TnWRd2kvz2HWFZYFuTPADYrdwiumRsTAMkHPAHImHcXb7XzLjCHV+j30hFb0DxQRt1xhC4YE/AwPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742517449; c=relaxed/simple;
	bh=46roC/Ycs6wPPeW/WUrD74GeQD35/HD9JpUT70E3zrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GRXVOnRs44wyNwblb8rwljEGAIQKLLTYOQsxyqel8b1YmzJODVmcb295/sG4gqvDKKDFWdgPrWlnAX5bhYfpzWVmnrW90TEoNjZPxGDzK34DDbRzLMw2lTwIpbMRmUu1+C8OVMRm80zfWdl/nvvSbBeu5STG8ItTdypHJPJLKe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U1vFUeod; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U1vFUeod"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52KLBTAs020677;
	Fri, 21 Mar 2025 00:37:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=gCBhP/ziZNo5beYM1BWeO3F3w4kU5X8d7uMOH6wKQyM=; b=
	U1vFUeodj8C4qTuV5W4FhDoqNosAewuXcBTIW84vT1U7qkHeILc+AmP2RCTSL6nZ
	XKJLnyEaP+r7/5jDNaCuzHN7hL8mnMyPG7jogBdQd1xth+5ehasQ56pH0awutoWI
	l9RW0qN5HMf1+rWxRueL8V1MkkVbrZEq9uz0f29mbxrv7pil2cAfg7ofrf3i00Ug
	bs/t2ehlF39AMKkq7RGq2rxf1mwbhUU+RZgRX9dO8+d+lnhbb1ygbWs6MljSEmDn
	7NZFXtTMqjE1W7lJsHqYHZmtcZVvte7cuC7aDllvOlCjQw4ckSSPc4K7uJkJAlc2
	osqxnmSN81AWHuXd4wfWfA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1n8q8d2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Mar 2025 00:37:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52KNYNax004848;
	Fri, 21 Mar 2025 00:37:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45ftmxt6us-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Mar 2025 00:37:19 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52L0bHsg024893;
	Fri, 21 Mar 2025 00:37:19 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 45ftmxt6tx-5;
	Fri, 21 Mar 2025 00:37:19 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chen Ni <nichen@iscas.ac.cn>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: fnic: Remove redundant 'flush_workqueue()' calls
Date: Thu, 20 Mar 2025 20:36:53 -0400
Message-ID: <174251737515.2240574.11609887080073706550.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250312074320.1430175-1-nichen@iscas.ac.cn>
References: <20250312074320.1430175-1-nichen@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-20_09,2025-03-20_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=706 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503210002
X-Proofpoint-ORIG-GUID: 9pza1RW5cgi6l14kgkProE22teJxGs98
X-Proofpoint-GUID: 9pza1RW5cgi6l14kgkProE22teJxGs98

On Wed, 12 Mar 2025 15:43:20 +0800, Chen Ni wrote:

> 'destroy_workqueue()' already drains the queue before destroying it, so
> there is no need to flush it explicitly.
> 
> Remove the redundant 'flush_workqueue()' calls.
> 
> This was generated with coccinelle:
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: fnic: Remove redundant 'flush_workqueue()' calls
      https://git.kernel.org/mkp/scsi/c/160d6ec69f40

-- 
Martin K. Petersen	Oracle Linux Engineering

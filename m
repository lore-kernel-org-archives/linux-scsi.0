Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79FF2F52
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jul 2024 03:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720151652; cv=none; b=lNfpFM/DHuJtmYijYw6leQh00WRuAhLR2UpbViN3otufe1w3zE7+HT4DZ6VBONkk5jxlyYF3Ddkw2B0Yn8e0ZbbIsT/W4km+CPenHqyZnULZSPXJ3EvvgdM9OzN3DX/WBowgIpVdNLJFr4HQEdobalFZI5Fwei47LVNPcFqoAr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720151652; c=relaxed/simple;
	bh=CCv07O9YQ6Hl6dN+gH1YCILEORrxiFX4q8b0viJoU/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n6mfcfYXdm0mWUqDNR+z3MhEcRBeVdu6lVCUeyuHwMLdVk8rlLrgffelQcrkBiZI6hQdhPCIrUv2ilHaKePfCYb4ft2AZQvgd+z+K+mFfpxz9s6Pqih4PG2EPJIwvg/1rtfixXpFVHFS3cgo8d3Hn/Xwr8s5ySX9AejJWi0HwXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=I0o8TIMB; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I0o8TIMB"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 464JYYWn021658;
	Fri, 5 Jul 2024 03:54:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=CVtwouV5xt/LmBQ+2YFccIYXSMibnFYlvzLR3/YcUK0=; b=
	I0o8TIMBQiLccKb56Iqdu6V4N2PJCxPsPkVa09yfuNmTq2kOiRDlyi2kTKogQvmu
	ZotpIM2aCpmQIQQlU/+xTxD9zNworgd5sB/oJzlBOHjXf/5BTsp0pFcvaRUogNAi
	ZSKAw4m2Rwm0qu56FPPpKzbVxAPU2uY4vqAHBMGh6/uYl1vevETMWM13M1foJbIb
	QRrLonTRLq5iEJQ2m+4t5siAjdRtN7K697uRZ9QLOmUk2OmOL6zKID1d/5fJnp1r
	zUTBD5BwQ7SStQQKEANdH1SwA4qweJhjZCRwQhH61j5jTweynXnxiGiLywwdMgow
	JGdGPP/hyMzmUIrzt1MoEA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 404nxgmkw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Jul 2024 03:54:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4653dsUr010315;
	Fri, 5 Jul 2024 03:54:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4028qh9y0g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Jul 2024 03:54:08 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4653s6dO010018;
	Fri, 5 Jul 2024 03:54:07 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4028qh9xyf-4;
	Fri, 05 Jul 2024 03:54:07 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        prayas.patel@broadcom.com
Subject: Re: [PATCH v6 0/4] mpi3mr: Host diag buffer support
Date: Thu,  4 Jul 2024 23:53:30 -0400
Message-ID: <172014707940.1511036.2773685828284418991.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240626102646.14298-1-ranjan.kumar@broadcom.com>
References: <20240626102646.14298-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-04_21,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407050027
X-Proofpoint-GUID: TWY_sS8grFLRCHllN7aj7NG81zfNa1vT
X-Proofpoint-ORIG-GUID: TWY_sS8grFLRCHllN7aj7NG81zfNa1vT

On Wed, 26 Jun 2024 15:56:42 +0530, Ranjan Kumar wrote:

> The controllers managed by mpi3mr driver requires system memory to
> save hardware and firmware diagnostic information, this patch set
> enhances the drivers to provide host memory to the controller for
> diagnostic information.  This patch set also provides driver changes
> to push kernel messages into the diagnostic buffers reserved for the
> driver, so that the information will be available as part of debug
> data fetched from the controller.  In addition, support for
> configuring automatic diagnostic information is added in the driver.
> 
> [...]

Applied to 6.11/scsi-queue, thanks!

[1/4] mpi3mr: HDB allocation and posting for hardware and Firmware buffers
      https://git.kernel.org/mkp/scsi/c/fc4444941140
[2/4] mpi3mr: Trigger support
      https://git.kernel.org/mkp/scsi/c/d8d08d1638ce
[3/4] mpi3mr: ioctl support for HDB
      https://git.kernel.org/mkp/scsi/c/78b506984ebe
[4/4] mpi3mr: Update driver version to 8.9.1.0.50
      https://git.kernel.org/mkp/scsi/c/3f7e469987f8

-- 
Martin K. Petersen	Oracle Linux Engineering

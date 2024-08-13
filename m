Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC49125B9
	for <linux-scsi@vger.kernel.org>; Tue, 13 Aug 2024 02:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723515342; cv=none; b=qcAd5DauMvedW4kl0SyIhhYt9h3YG1ExzTC6du2qZ7xUgE2cxDlGGx3MfbRMa1dM5hnj8e45LdodNygvIHkM3SZqHuJFpw/0Ous+teNeloEz/3oNIJWohG7ibMFtiS3aK98u5Z6uiai8LeHULQ9dgTUWodc8AK6cKSyY8AMva5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723515342; c=relaxed/simple;
	bh=uNp0gt0y3LS91G+Fy0nCtL4sWDIOb8qviZSe6ViwRvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q1PhchexrnISuXhLk2N6QCX7MgFN8U9aTbpMBkj10SJZY2XMSzXWr5tzdHSB23Vf3q8O35lnLeRchSnz1WFg9A+WbXkF2Bzis4ch8puIEG97linxJ9/f0zZmoJeomNfUm4tugH1//vsy/+9t6l7+7J0xRYaGcadXP5QAY+jOFTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cRqs5x9S; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cRqs5x9S"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CL7JFi015027;
	Tue, 13 Aug 2024 02:15:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=H2JM5fMvx36gTYpKEWst3SQx8rL//P6auK5HeassHiU=; b=
	cRqs5x9S9Wncc5BWy1Z6EwWeLwEtV8IeN/3oEz5HhegkyOWrF2PZUphUN/9PFj4I
	H7Etc7AFvHFPASbegM4+n4MFZWC0oSSVtmrKul/7HnF3sDew4st4yB9AxnAbWkEl
	nMprWOUqaC8QrFT4pPETD6ugJ1Pn2/vEM/QaFMcLehUIM48ApejQFXyFHutk94OH
	QajRNj2/d/aEWkgMed7CTuvKMvk362COi/BS5jXr3atz9iUrmhJyA0F7ksZoCRYj
	iaZO1S5imcSE+d7vpPnUXhwuoZ75bJdxuuJkuXCAxl+BI0hyBzaSAkFn9zB3KbKG
	8o2DZHL5WCXqMUfeQZGJ/w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40x0rtmxn0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 02:15:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47D2FF3p017753;
	Tue, 13 Aug 2024 02:15:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40wxn8ssh5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 02:15:36 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 47D2FaOB018550;
	Tue, 13 Aug 2024 02:15:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 40wxn8ssgm-1;
	Tue, 13 Aug 2024 02:15:36 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com,
        Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH 0/2] scsi: mpi3mr: Fix two bugs in the new buffer allocation code
Date: Mon, 12 Aug 2024 22:14:48 -0400
Message-ID: <172351521255.2723613.14035428877387642263.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240810042701.661841-1-shinichiro.kawasaki@wdc.com>
References: <20240810042701.661841-1-shinichiro.kawasaki@wdc.com>
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
 definitions=2024-08-12_12,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=983
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408130013
X-Proofpoint-ORIG-GUID: taPFbp4-VWLmNrWSAokKqyH3Dtwa_Vi0
X-Proofpoint-GUID: taPFbp4-VWLmNrWSAokKqyH3Dtwa_Vi0

On Sat, 10 Aug 2024 13:26:59 +0900, Shin'ichiro Kawasaki wrote:

> The commit fc4444941140 ("scsi: mpi3mr: HDB allocation and posting for
> hardware and firmware buffers") in the kernel version v6.11-rc1
> triggered an INFO and a WARN. Two patches in this series address them
> respectively.
> 
> Shin'ichiro Kawasaki (2):
>   scsi: mpi3mr: Add missing spin_lock_init() for mrioc->trigger_lock
>   scsi: mpi3mr: Avoid MAX_PAGE_ORDER WARNING for buffer allocations
> 
> [...]

Applied to 6.11/scsi-fixes, thanks!

[1/2] scsi: mpi3mr: Add missing spin_lock_init() for mrioc->trigger_lock
      https://git.kernel.org/mkp/scsi/c/6b9935da2a6b
[2/2] scsi: mpi3mr: Avoid MAX_PARE_ORDER WARNING for buffer allocations
      https://git.kernel.org/mkp/scsi/c/8c6b808c8c2a

-- 
Martin K. Petersen	Oracle Linux Engineering

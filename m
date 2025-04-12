Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6115339D
	for <linux-scsi@vger.kernel.org>; Sat, 12 Apr 2025 10:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744453774; cv=none; b=NidmFgBxoNOS3NmJayQGjjQ7MhZPAI5Rh13cCkd9ouWl8OSnahW9p4XjT+kBwrYK6rI3gMfmjbq3M3SHVHTGefnA1HSzU5kr6lRLFOvlR6DTByzkzM8Jh9LtOQBOq2JSeNCwg6d8fw0z4zrohN7yTYlStfH3iDyvPwu2h1fuhNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744453774; c=relaxed/simple;
	bh=Flr9PdWLOp6A+helb4AmTsqfh9l/fiGBf4DBvDdYy0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RFPSBflklwgkuwihyfWijG9yuZIsQcWXpsgZR1+UIkCtekq5e4TL6hIedGkStLf2PBL4VeJz8EQne26riPJJ8EQOyKMKttnOVWTSIOVg1y8CZEafOGcsoS74bsUtqN3oUJ4itRpqEs/llRDu4/7ePdXFxPApqVpM/ugHzVOOVwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EkJin1Ne; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EkJin1Ne"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53C9W4ml009974;
	Sat, 12 Apr 2025 10:29:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=OSVFezC0i8fBW8f3wEsne2bfr6Gr36hGvmC6poK6vr0=; b=
	EkJin1NexbJq98p+FgUfdgYZn5Uh4Zo5gi0bbjxCpopY0efoZbaESW+sdNrluF/O
	iMakwgjdYjUxEeOxc/bNooHkvHjxoD+4uPqJszHtF1kZqjCFCnCIOw2wEH7qQ0Xl
	UCtKdEv52OJsljMhehP+lVYSHB/u6WapVMgtmcPt4Uv3NSp0lQBNRGJ1+XIaXLNh
	AlrDwRMUQyLtLiuyZ6wdRFjDK86g1AhPrjzqvq7GzjVrGVMCiwtz3XuWio/pIXE2
	eEfwHMZw236DxvgthjiMdLL3FJ3W6MvG2JoctOSPhovHyD7oQzLrWEGFQbppypVA
	Jjk4MhCZi0XkaxZbVGxaUQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45ynmeg0wv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 12 Apr 2025 10:29:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53C75XIM032167;
	Sat, 12 Apr 2025 10:29:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45yem69s1k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 12 Apr 2025 10:29:28 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 53CATROg038043;
	Sat, 12 Apr 2025 10:29:28 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 45yem69s0s-3;
	Sat, 12 Apr 2025 10:29:28 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        prayas.patel@broadcom.com, tadamsjr@google.com, vishakhavc@google.com
Subject: Re: [PATCH v1 0/2] mpi3mr: Few minor bug fixes
Date: Sat, 12 Apr 2025 06:28:55 -0400
Message-ID: <174445370239.1751018.7098450908356520634.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250411111419.135485-1-ranjan.kumar@broadcom.com>
References: <20250411111419.135485-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-12_04,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=946 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504120077
X-Proofpoint-GUID: _i2I81u9TtcEcWtTIN-kZYXUajKS19FM
X-Proofpoint-ORIG-GUID: _i2I81u9TtcEcWtTIN-kZYXUajKS19FM

On Fri, 11 Apr 2025 16:44:17 +0530, Ranjan Kumar wrote:

> Few minor fixes of mpi3mr driver.
> 
> Ranjan Kumar (2):
>   Regression fix: Fix pending IOs counter per reply queue
>   mpi3mr: resets the pending interrupt flag
> 
> drivers/scsi/mpi3mr/mpi3mr_fw.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> [...]

Applied to 6.15/scsi-fixes, thanks!

[1/2] Regression fix: Fix pending IOs counter per reply queue
      https://git.kernel.org/mkp/scsi/c/cdd445258db9
[2/2] mpi3mr: resets the pending interrupt flag
      https://git.kernel.org/mkp/scsi/c/3b5091fee49f

-- 
Martin K. Petersen	Oracle Linux Engineering

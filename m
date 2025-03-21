Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED793D3B8;
	Fri, 21 Mar 2025 00:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742517452; cv=none; b=Z/LXW7SUv3PMZVuBzuoSGZtVHXCnOIRyf6IavKKuG7Qnah+qUNM/FpJK+Qt9laD+M8t1B8iOZge6/pJ7SNx0Np0nBvBwAHv4wyeRZ7BFPRtB+olTbqg6fxEzHdwQjrgdWv4HYQRNYsf4LbajJqjxrs4QCWmVkogtGRETp8HakEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742517452; c=relaxed/simple;
	bh=Wn9sdykgVuVb0p0u6RYov8qab8zpmmw1HO/w2gL1Vsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U8LKyB5kZNn68cNDqnpt81HzZl7A3TWtK7WgKF6s86P/ftS6Yy9nAeOjGJg4UTC1SFwFlD99c7UTNS00JjxXPVzhqd0A8QKR96/c2mROtnnWsu6zv0mkfFLHl48NTs2D+9zxWLWW/bmMeTBBqxep8fWkkbEpJOl82Y/caRm4zAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A81doXkB; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A81doXkB"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52KLB9TU023357;
	Fri, 21 Mar 2025 00:37:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=mduNjyoW3sBGYNQhbPVGMbXCuXPdG93WAzYB2HB/lkM=; b=
	A81doXkBzdPNBzPUx/rWL4qF7+RUDx8XBIo0mIUPcj7tZpwpRD+3N3qEbTDohn97
	PyecJ6F5erILsBk/1JGFbQj+Ow0UoPGygbCrl/tnf/z8LSlg6YEuFLTH2o22hMkD
	1MpTICIKZtk0UKKIkpOWTIfyheVoWVFlE4A00f4vnytmMP3aLjRC1an47dxk6FuO
	B29mK1FE9z8rfroa2Mg/m6+qcNgFxqaaSaWUqh8L4gYh5EKNOPjUba220tRh2D1k
	u7nkvjpkFsFZXEiv2aSZ9t0XW/84twg6VBmHRmKFylxT4QeG5f6068svlp66P3Lu
	/5u3o0aoBCvoBw6ZIwUPRQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1m17fpg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Mar 2025 00:37:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52KNjAi1004495;
	Fri, 21 Mar 2025 00:37:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45ftmxt6ux-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Mar 2025 00:37:20 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52L0bHsi024893;
	Fri, 21 Mar 2025 00:37:19 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 45ftmxt6tx-6;
	Fri, 21 Mar 2025 00:37:19 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Satish Kharat <satishkh@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Thorsten Blum <thorsten.blum@linux.dev>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fnic: Remove unnecessary NUL-terminations
Date: Thu, 20 Mar 2025 20:36:54 -0400
Message-ID: <174251737533.2240574.17214367115238701645.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250314221626.43174-2-thorsten.blum@linux.dev>
References: <20250314221626.43174-2-thorsten.blum@linux.dev>
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
 mlxlogscore=831 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503210002
X-Proofpoint-GUID: 0D70a6Vug9JTv-S70I6TScB-gxy7COqu
X-Proofpoint-ORIG-GUID: 0D70a6Vug9JTv-S70I6TScB-gxy7COqu

On Fri, 14 Mar 2025 23:16:26 +0100, Thorsten Blum wrote:

> strscpy_pad() already NUL-terminates 'data' at the corresponding
> indexes. Remove any unnecessary NUL-terminations.
> 
> No functional changes intended.
> 
> 

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: fnic: Remove unnecessary NUL-terminations
      https://git.kernel.org/mkp/scsi/c/bd067766ee2a

-- 
Martin K. Petersen	Oracle Linux Engineering

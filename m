Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571305684
	for <linux-scsi@vger.kernel.org>; Fri, 21 Mar 2025 00:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742517459; cv=none; b=HR5hcYa6TbKEymBZuGSzjozNZpaJLKVko7syv+bTPtbXq2HUFQt60rt0t62DAxL+ErTjtJdGOUO78le+O1FrMKDsTzU3zky6x1RHzeJKNrWvV29nFhF+Om+N3zsQWk6D7RORrojt75NMxFlch6qvJhOPnT5PjkZuRQ/p6AK/o9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742517459; c=relaxed/simple;
	bh=zUgXaRrUm5NDUCU9aGb4a2gYYAKBmSJMSbCAID4fYnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NVqS+0QYKMzvbwoIb/Mr3Hpbf31djS6B0dlEnYVRHV0fDGENjKn9No9/GlTTDZOClzS8RByqSFhD26oUUxiJvGn+olaMY1WALJaE8/bVvnkqlRiJtf7cLpEmKFWYcU3VlvFwUqHYXw21jRtizjq9sAF8me7KWC+mVnu0yFBo8cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PvZ4yTuM; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PvZ4yTuM"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52KLBkpI001294;
	Fri, 21 Mar 2025 00:37:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=sucFb9SrJOiz47eXybHTVXgovimQFDep+0DioSfG4Ro=; b=
	PvZ4yTuMsn+SqgoMaIARzeTqwFpWSWFFVUc9bqD9Hba4BohIhU/iSmq5A5h2PMNU
	GA5uKjZESANSH13ORBZlgkWJ12Ijfgp0Th9FdNGcAvyB52gNo+ZJjJrJe4D/HqWw
	0vwNXU8et/BvAG65M2OHoGM1XKOYh62w/nFQFXG1/YECR1fc+FBzEutxBgHPLjjW
	pxLplR97jTNDNaCpP88TclI6GPd/OfZqUE6pxk2tcPWfyPIgz6gMuS1dhmxZEmRm
	lyARQINiuX66pNw5Mn78K3E/UJm4UrqsGTVMlLJnKu1PZHVjaStJvjx8axdjSVON
	xdCTkwK3ALoSqTpwf+xmxQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1hg7gd9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Mar 2025 00:37:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52KLmujb004511;
	Fri, 21 Mar 2025 00:37:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45ftmxt6un-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Mar 2025 00:37:19 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52L0bHse024893;
	Fri, 21 Mar 2025 00:37:18 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 45ftmxt6tx-4;
	Fri, 21 Mar 2025 00:37:18 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, Yihang Li <liyihang9@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linuxarm@huawei.com,
        liuyonglong@huawei.com, prime.zeng@hisilicon.com
Subject: Re: [PATCH] scsi: hisi_sas: Fixed failure to issue vendor specific commands
Date: Thu, 20 Mar 2025 20:36:52 -0400
Message-ID: <174251737521.2240574.15203226992211435694.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250220090011.313848-1-liyihang9@huawei.com>
References: <20250220090011.313848-1-liyihang9@huawei.com>
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
 mlxlogscore=883 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503210002
X-Proofpoint-GUID: sanXa6tZaBlUp56pW4FQr--xY4qBtCMh
X-Proofpoint-ORIG-GUID: sanXa6tZaBlUp56pW4FQr--xY4qBtCMh

On Thu, 20 Feb 2025 17:00:11 +0800, Yihang Li wrote:

> At present, we determine the protocol through the cmd type, but other
> cmd types, such as vendor-specific commands, default to the pio protocol.
> This strategy often causes the execution of different vendor-specific
> commands to fail. In fact, for these commands, a better way is to use the
> protocol configured by the command's tf to determine its protocol.
> 
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: hisi_sas: Fixed failure to issue vendor specific commands
      https://git.kernel.org/mkp/scsi/c/750d4fbe2c20

-- 
Martin K. Petersen	Oracle Linux Engineering

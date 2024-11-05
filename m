Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE87433B5;
	Tue,  5 Nov 2024 02:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730774029; cv=none; b=lnL0ciBdtiuy//wR0/GU6v6y0qOC9SKK8cMDlGCSKrnYT66ZuplsV/ECT4FhsqY7b1HcrZdWRp8tPUYbOgqw97yVBIw9dd7vARYb7z1MdTiBpmh7thmyUxIyQ/vozXvNkKfzCSxL/sc/hwWA7FUuw9KSY7CGsiPO3QILi1QF6aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730774029; c=relaxed/simple;
	bh=ZZWoR6zO/csMBsOYzaeQYVI7ffgZur123IkcRjtdc0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k+cQmfCqJc1nFRHerW+4VcupowJBYgZN/6W33w4zkXnrowuH2QSiiOapW7qd6GCbHyH+MlTjPPa4kOw8/DAZBucEv3101vanmMzdT8HzcPCl4OsqbbfVNj7M5t7gFUMBaVJUCxZdaM6PGeDPs7IS9uFNO9cwAxi6k22AT6Kd5cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nHbzy9I1; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nHbzy9I1"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A52NdXg021615;
	Tue, 5 Nov 2024 02:33:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=fJ7VNB992qhr070QddIkm+cETzvzg0XmzsqYjkmFuxQ=; b=
	nHbzy9I1Rogb7qMMY41i4D/ox6kCfz8PcrnKX189MkhuvuGUlwhVaioZOmMIlmsq
	gf8xK1a7ZOr9ZRAgFAUfEdAvmtugdADcWrFjR+c/cpDLg3i4rcyt7gXWX+HVzfvf
	EVDBfIgisxob1T9E1nFWYbz2q/mGi2Xf28YU54FDL4EC9beQhK5IF+eccI9GazT9
	zboQZkGJNyUv7gmSsp2ctzd7XYbY1+4TUwuAT2wTYx1gWA1ZkJ04EJBXZZIlxTbT
	PvnqB/SKfye7nXOXzYZbfxTRPEmgz6xcErN1Ix/gLURwbbZIxJae1ZJwZQjwzJe5
	A5eX6KvAxzJ+gjmIgH88Dg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nby8v7mv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 02:33:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A4NEAKM036847;
	Tue, 5 Nov 2024 02:33:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nah6g2kh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 02:33:32 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4A52XVFo017503;
	Tue, 5 Nov 2024 02:33:31 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 42nah6g2k1-2;
	Tue, 05 Nov 2024 02:33:31 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 0/3] Untie the host lock entanglement - part 1
Date: Mon,  4 Nov 2024 21:32:48 -0500
Message-ID: <173077364682.2354920.13530203204903244087.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241024075033.562562-1-avri.altman@wdc.com>
References: <20241024075033.562562-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-04_22,2024-11-04_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=949
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411050019
X-Proofpoint-ORIG-GUID: WnBKKj9LpviJUJr77bLBt03yF1ww8OFW
X-Proofpoint-GUID: WnBKKj9LpviJUJr77bLBt03yF1ww8OFW

On Thu, 24 Oct 2024 10:50:30 +0300, Avri Altman wrote:

> While trying to simplify the ufs core driver with the guard() macro [1],
> Bart made note of the abuse of the scsi host lock in the ufs driver.
> Indeed, the host lock is deeply entangled in various flows across the
> driver, as if it was some occasional default synchronization mean.
> 
> Here is the first part of defusing it, remove some of those calls around
> host registers accesses, which needs no protection.
> 
> [...]

Applied to 6.13/scsi-queue, thanks!

[1/3] scsi: ufs: core: Remove redundant host_lock calls around UTMRLDBR.
      https://git.kernel.org/mkp/scsi/c/2b314e182caa
[2/3] scsi: ufs: core: Remove redundant host_lock calls around UTMRLCLR
      https://git.kernel.org/mkp/scsi/c/5824e18b3db4
[3/3] scsi: ufs: core: Remove redundant host_lock calls around UTRLCLR.
      https://git.kernel.org/mkp/scsi/c/2a330f16ad30

-- 
Martin K. Petersen	Oracle Linux Engineering

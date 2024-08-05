Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7FC16EC18
	for <linux-scsi@vger.kernel.org>; Mon,  5 Aug 2024 21:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722892719; cv=none; b=iwkIcIY+DCWVjA+JK7YfkKfcXSO6H7HXYwYX9W4Dx4mFkz7dhAivO+jwAupyl/A236JNoUqdGzsGKYhwvowf8t3uFAIFnfiU1l1wOPHQLrtAfv0DczrtPg6MVyXAqxKW60mv8BayNv1ni9gHHOkA2xLyqvDso922S8Hvv/7/dBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722892719; c=relaxed/simple;
	bh=Q7HqedhLBOMEex3Jl2iGO1QXQW4HUAdoF7tfI+Y4uxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ewHaHBdTBx3COwS6Q3CYsXQKulZ+evGKb1KQnLB/BNx3wFlUy92QvMGMPMJS5x0+cFwIVV7TGjbj4UkD0em1JA0pKcuZbXn3f5ECMfTg0s7QZY6hnM537e0Kko2E8U9aJmudOdqD/ls7z0g7jQLWlx1Tv88Zh1YUI6Z5RbJTIU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GrT13SqH; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GrT13SqH"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 475Kix26021842;
	Mon, 5 Aug 2024 21:18:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=0gKPjHe1GSSNHYjI81HZO03QnFiP0CxFXhL0l8va4uM=; b=
	GrT13SqHxLzKbDRBXX0YBbTgmWfVrEZpoSTXg7FwYeDA6yZbXQeUacj0UkDZvX0t
	AcxwQe5sLhL7onFg4DDW9oOgm7wnzMUkYRrly88zVJvOWrYXki/G1CC8pzhc8FwD
	ZUSLe1Ukv6fN/54ztavr8+BCHsqyxLD57RGDf54lu4uGJh7NRpM4L7kRK1NP8+L6
	4ezFF0BcB5z1ENNeaqwCmhdvcfU1kzdfvpOLod7CvhkNw9QxKx/eYZ3nMS6L3WF/
	Qyo/h2QdLEbSnA1Bn6yy/CI3sCr1RDoExAz6Gu+zbdJuf9cGwWcXYQtlRUXAzxv0
	AzdFnbAZPim+/glUOyGgCg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40sc5tbq54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 21:18:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 475KCOT8035103;
	Mon, 5 Aug 2024 21:18:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40sb07ydgb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 21:18:24 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 475LINEJ035403;
	Mon, 5 Aug 2024 21:18:23 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 40sb07ydcw-1;
	Mon, 05 Aug 2024 21:18:23 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Kevin.Barnett@microchip.com, scott.teel@microchip.com,
        Justin.Lindley@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        mike.mcgowen@microchip.com, murthy.bhat@microchip.com,
        kumar.meiyappan@microchip.com, jeremy.reeves@microchip.com,
        david.strahan@microchip.com, hch@infradead.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        joseph.szczypek@hpe.com, POSWALD@suse.com,
        Don Brace <don.brace@microchip.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/5] smartpqi updates
Date: Mon,  5 Aug 2024 17:17:25 -0400
Message-ID: <172289240522.2008326.13388956756613992292.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240711194704.982400-1-don.brace@microchip.com>
References: <20240711194704.982400-1-don.brace@microchip.com>
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
 definitions=2024-08-05_09,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408050151
X-Proofpoint-ORIG-GUID: iaYgEKH1lHczBjo16O_jURdF4VLK3q49
X-Proofpoint-GUID: iaYgEKH1lHczBjo16O_jURdF4VLK3q49

On Thu, 11 Jul 2024 14:46:59 -0500, Don Brace wrote:

> These patches are based on Martin Petersen's 6.11/scsi-queue tree
>   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
>   6.11/scsi-queue
> 
> The functional changes of note to smartpqi are for: multipath failover
> and improving the accuracy of our RAID bypass counter.
> 
> [...]

Applied to 6.12/scsi-queue, thanks!

[1/5] smartpqi: add new controller PCI IDs
      https://git.kernel.org/mkp/scsi/c/0e21e73384d3
[2/5] smartpqi: improve accuracy/performance of raid-bypass-counter.
      https://git.kernel.org/mkp/scsi/c/bb0f5445b27f
[3/5] smartpqi: revert propagate-the-multipath-failure-to-SML-quickly
      https://git.kernel.org/mkp/scsi/c/f1393d52e6cd
[4/5] smartpqi: fix improve handling of multipath failover
      https://git.kernel.org/mkp/scsi/c/57abab70a5e0
[5/5] smartpqi: update driver version to 2.1.28-025
      https://git.kernel.org/mkp/scsi/c/5b4ded3f35d5

-- 
Martin K. Petersen	Oracle Linux Engineering

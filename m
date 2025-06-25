Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688C6A31
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2025 01:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750815879; cv=none; b=VLZOIk39FDJ8U5SghDTYsG1ibgzFDNVx5TYgNbchaLRd6zjVCkvvkZDsJ8gx4RvEA9buvgQraZ3XkZ9OGLaPREZ7PEmm0FW5mLP6Ga/YzfNco7/1xE39nPidlQf+OiBbto2ZXoQqGHXWFrTXE8Knu9zOO7l5SMuZc5gBFCPGDwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750815879; c=relaxed/simple;
	bh=ZK2CoxS5SFnhJZdtnxAvV2Q6LtPbnXXHT4GrjFDQqTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mpyNIAQqXvEtZ1nCLAMBmkiEgNB+rJ6u9psQBdapYk3crz1hYH3n5guZRu4PrX96ypd8xLU8Cp2Iiy2lXikH6Dx+BIcsWPdfMkWVbVwYVdHEtPGTUtyZW2nwmcuBWo3Ah2D8TxgmCuYnXFjq1SXCVITYEm2Yx2vzwgIR1bKBLxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Gz8eVsAW; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gz8eVsAW"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55OMiexP002612;
	Wed, 25 Jun 2025 01:44:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=eYqTlYIUDwY6kHCG5n2G/O+38xXwmYQmFR12BZtAKLw=; b=
	Gz8eVsAWcT22q5yectCp1o6ItddMRWa8JE6dfBe0EYrkx4QCZQcCuxhFhFP8mSA9
	02MlklgBJ/EP7z5Wt3OGLsDnlEHkY33QNne7rq0OlA/hqWSNOZ8JlmeNgDMj3jZn
	PKZ4n+gDKXlbBAM5rbhXDCp9w6opRLOI7zskLyFkrNTuXVQhmKWpya3A3ZNUw+rN
	yPq6jP3RdvBBBW4VN4WpBNSATqVyYuuc7eWs2EgCCrnK4bUK8bKYu/bdnbWkRxyf
	VYsjScOChofWH7Vgmi2As7uempTjcIUmxefnu511JVxszlVFsCr9XPQDR5uzgu+J
	afkH0OdhlMcPS7+RhoOJQA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds87xdjw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 01:44:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55P1W2ku007396;
	Wed, 25 Jun 2025 01:44:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ehq4e6qn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 01:44:32 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55P1iVGA007157;
	Wed, 25 Jun 2025 01:44:32 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 47ehq4e6pm-2;
	Wed, 25 Jun 2025 01:44:32 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH 0/2] Improve ATA NCQ command error in mpt3sas and mpi3mr
Date: Tue, 24 Jun 2025 21:44:01 -0400
Message-ID: <175069824522.1717808.2776717283685058098.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250606052747.742998-1-dlemoal@kernel.org>
References: <20250606052747.742998-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-24_06,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=998
 spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506250012
X-Authority-Analysis: v=2.4 cv=a8gw9VSF c=1 sm=1 tr=0 ts=685b5481 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=JPAjQeBRIeFM5zRoB7QA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI1MDAxMiBTYWx0ZWRfX+OVQK9Mxqn2r TMJxrT9vfBbOq58/2M21mxSlTkwGNWPOZ0eoLaB9UNheJEksKEZ68eosdaroqQAu9OA+sUPkd0X jsJGKKlPWG5/I2tftlAJzlmy/3JUYTX3BdXd37Gd4uZt8vGcpJuBU+XXMOhkc1uYnVQAhh49CRu
 EsRNz1OcOYa98yvuEPpD4Y3KnDsaDUpZYSzlVdtufv88AOjWRUjdgsLQX4pxCLq7hrC3JfB7uH/ KhDRDUj7J3mfqpIuDhRBV5AR0oI9AMMUkDz7fY0PUWUf4TLtPAYikFMBLew6YTqokMmJFFFbz7I LFsxNJCY9NY4LPn+4zaQcEO5Utxi2W/1fitTrLggLXfwScWRULduXLiK4XZSi6RLRwYOuTYMsm6
 PVEjHOy4LDCKjpdSH9NEh/a6/b5UNPZy3n6BTQC6RqrQCZmcrRS/KoBWFemMFbPnXbz61DIo
X-Proofpoint-GUID: 4pb8fvwwc5BLIt8yPv2gdkhODKmcnbhg
X-Proofpoint-ORIG-GUID: 4pb8fvwwc5BLIt8yPv2gdkhODKmcnbhg

On Fri, 06 Jun 2025 14:27:45 +0900, Damien Le Moal wrote:

> Martin,
> 
> Two similar patches for the mpt3sas and mpi3mr drivers to improve the
> handling of NCQ command terminated due to an NCQ command failure. These
> so-called collateral aborts must be retried immediately but that must be
> done without incrementing the command retry counter. Otherwise, these
> collateral abort commands may endup being failed due to other NCQ
> command errors.
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[1/2] scsi: mpi3mr: Correctly handle ATA device errors
      https://git.kernel.org/mkp/scsi/c/04caad5a7ba8
[2/2] scsi: mpt3sas: Correctly handle ATA device errors
      https://git.kernel.org/mkp/scsi/c/15592a11d5a5

-- 
Martin K. Petersen	Oracle Linux Engineering

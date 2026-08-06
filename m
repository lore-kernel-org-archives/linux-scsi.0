Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDA0394EB7
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 19:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786043186; cv=none; b=bcCNaLvT7McLmNAu3fb0FHy67I/t30em3+alip0tNdgXPF59VluY2oSH+pR6xP9uQovlmG7YeUtlCaVuhtE/8DhiapWAo6MukfqW557GylyIjbkS595ZXkfM68fBKnk900tSlaeNRYJdDi3mAX3EeRpj4IaBBiq4+bg+rRwMg9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786043186; c=relaxed/simple;
	bh=wrnU1yvuo6Y1BWUiF8itKKc+W5g0SD+i4qUFfAHKan8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dJLiffW0aqkfr9oTr6iik0mvlZk8xxMFAZrvXM4WJSVD0LKt04s+1+79Y3cVXkG4dCPSf6uWYWScp5LC6cPXDtMKjV97QhNet96NACjoVEu56sEpUxR7faPbHqnPlwpD4RWrNvW7nCm40SnwSkQM+0T3rPIu+Fuft5qNFDdCtGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=keP8Suwl; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="keP8Suwl"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676Ftorj3074693;
	Thu, 6 Aug 2026 19:06:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VEzSeoGfpZEM0R1wv2Wrb93kRiVmXEjzOXYSxd5vAzk=; b=
	keP8SuwlOV22vg7+UKbw9aYlN/d/szb/Wke2eGC12HZmK1K8VLiGL17NBnmnBxri
	nOBjO7a312LEs1EUnB47989ec/cYVow+3usBS0kcBUGW/wLqEMT8RSQJTvVAqIJg
	OADuuBccQLenFFHFK2OxPBj2hQl/vS44cBE1l7z8jPU5h1dSZN4MuYG/2vFE8oUF
	0X+Bhfe8lue7lAd4KMfnikHCSTLbNysh3mNbn9DWASGXh1djK3IlKRXstoRaCYIp
	exTfauwFaalWVJ/IF1DrFGnignqJv6qpVNQ5oIwi8joP+tdDtQz3SZsIUXudy0QP
	D+i3VFFx1iMpspRUU3Q+4w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs8e56kt6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 19:06:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 676J0cYp024709;
	Thu, 6 Aug 2026 19:06:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78w56by-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 19:06:22 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 676J6LgW011247;
	Thu, 6 Aug 2026 19:06:21 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fs78w56b9-2;
	Thu, 06 Aug 2026 19:06:21 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, David Strahan <david.strahan@microchip.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        David Strahan <David.Strahan@microchip.com>
Subject: Re: [PATCH v1 0/4] smartpqi: fixes and updates for 2.1.42-011
Date: Thu,  6 Aug 2026 15:06:07 -0400
Message-ID: <178589207059.336697.14044367611229567227.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260722220401.6357-1-david.strahan@microchip.com>
References: <20260722220401.6357-1-david.strahan@microchip.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-06_02,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 mlxlogscore=972 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608060149
X-Proofpoint-ORIG-GUID: Vl2eQPWB8ZSfI0SshxkVLvsQV3bOVIea
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDE0OSBTYWx0ZWRfXy1HfU6CCDO+o
 yQODTWPeopL2+GLE0I5L4Q43uyzGovfXHw4Su7apZM32l+L3XnlK4UGg2mdRkbhJNLiT5EGSPbU
 U6uUub2t/2G2W6PAiIeLXlzStueYsBpI5VUxUGmEISp9kJDeGlY1
X-Proofpoint-GUID: Vl2eQPWB8ZSfI0SshxkVLvsQV3bOVIea
X-Authority-Analysis: v=2.4 cv=M/t97Sws c=1 sm=1 tr=0 ts=6a74db2e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=btsfxEtQ8LFeGGKtxScA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13510
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDE0OSBTYWx0ZWRfX2lnrLxo//2QT
 LJW6NxZMs9lIN3sudMGrfdxC/Yhr3crSMon8K2BPj2tE0FN5YGcWE3xSxkbI0bqqonqAg2+knfo
 Rebx0p4yT/VLLlr0BIboSBIPHUp1hqcT4BEJT9C/7tTuqaqoOx11bEBrgz87fC10bIKND/iFgnb
 +qXjislZbHyNBgVgdgUxWIdPUdE4d77vep733Tj1BuDTA9OvY0pcUAM1JquAJHcRxYs7JiXY+Q2
 ZPIbbfb/QS2o90N+3YcQWseK/4NaMp8ufyTGF3IpJU86uQSAGVNYA9upq0R45DKRRAqWjWzj4d+
 ySSK7b4wSm2A9zQW6heDtsrqihg0FdSRq8Dl8CmdH7zjNBxt/ioAjznoATGkpmGDDdmS3+xQjSI
 3XaLSs3pnGJgj2LwIpsZDtJU+xH/hd/h0RXEkyAkjS+6fq+hXpEb3IzwxMVP0OIbIeejdofv5Jl
 RUAX3Vavr1Pl95JXpiS5+AKQjVnp4S/aWUi5F3CI=

On Wed, 22 Jul 2026 17:03:57 -0500, David Strahan wrote:

> These patches are based on Martin Petersen's 7.2/scsi-queue tree
> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
>  7.2/scsi-queue
> 
> This patch series includes four patches, with two main functional changes:
> 
> 1. smartpqi-Fix-AIO-retry-marker-cleared-by-SCSI-core-between-dispatches
> 
> [...]

Applied to 7.3/scsi-queue, thanks!

[1/4] smartpqi: Fix AIO retry marker cleared by SCSI core between dispatches.
      https://git.kernel.org/mkp/scsi/c/225548863f0a
[2/4] smartpqi: add support for CCISS_BIG_PASSTHRU ioctl
      https://git.kernel.org/mkp/scsi/c/c64b2ab2ff51
[3/4] smartpqi: add new pci device-ids
      https://git.kernel.org/mkp/scsi/c/1a220e6e87a3
[4/4] smartpqi: update version to 2.1.42-011
      https://git.kernel.org/mkp/scsi/c/913337c48e6a

-- 
Martin K. Petersen

Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0771E51E3
	for <linux-scsi@vger.kernel.org>; Tue, 13 May 2025 02:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747104553; cv=none; b=iuRPQi5wtD74s6/yI/dp11I80sPK6iPHUp2L/w7RyCnCIt0+kidq9+Z1RShDyhpUh4fGUfNNvCajhNE7SBa4kUF2YN8SvNA2FlAVzjpT6DbPoBycbmJwXvBX6StuxGci4Jjf8LZrXCtw/z07PN+Pe30EggDVYUxt7iUqXXG3VmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747104553; c=relaxed/simple;
	bh=qg88ZZVxpFt8GgXZhKrergpXPJ98ycQczjU8aRH0/Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l1apvBsqLO+LBK8lbylC5QjHXipkuJ9fUCChmetB0gNLqR1edx7ArV7I4XMO2YN34AWuwVGomvAqLzGPrRRaiXZ5ncWY9/6nqI1AyeRk7oo+QfpI53J73tNiLQEfn+bF+FpO04icwa8eor9pbmARr9NQW4dNe/W3qknkHI1A7JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n3Lksjlq; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n3Lksjlq"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54D1BuA9007570;
	Tue, 13 May 2025 02:49:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kG78jM8gUMf0ii/e4dbCJc7ii/b1TnYWDx6NeWCpJ2w=; b=
	n3LksjlqzEra0BQ84azNRkvBjeSkwsbiqth8jAv97T2sloJE91ENbROmLNoFY7zg
	v6SHCHvNTDGZ7+LKaojEBJskWKPJ20BLPXzydP5SF+W2IHoswe+54X+qHeu7V5CF
	8q1OGn/VQ3HdwgPmu8GO3ZzGNQkGFdsjYSWs8w2JLAo1pI75dT3MRwdhZL3VpCsG
	2Q0PkH696luUPYYBdSNrbVIf8iZVHILTE5ytyF29uzc0cECiIfjI7c6IelDNi6yJ
	ixvNdIPIGfX+IUD7IL2eN2rEdiMs78rGS1Pc1FGekKXC2mMbHpeJ+ADaaUzu4Ww3
	TpKYGQtvszo30ZAo6a568Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46j1663uuq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 02:49:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54D2gEDR016012;
	Tue, 13 May 2025 02:49:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46hw8841hn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 02:49:00 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 54D2muXA003994;
	Tue, 13 May 2025 02:48:59 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 46hw8841cw-4;
	Tue, 13 May 2025 02:48:59 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Oliver Neukum <oneukum@suse.com>, Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        Nathan Chancellor <nathan@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Colin Ian King <colin.i.king@gmail.com>, linux-scsi@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] scsi: dc395x: Remove leftover if statement in reselect()
Date: Mon, 12 May 2025 22:48:13 -0400
Message-ID: <174710241019.4089939.13582359968111970288.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250429-scsi-dc395x-fix-uninit-var-v1-1-25215d481020@kernel.org>
References: <20250429-scsi-dc395x-fix-uninit-var-v1-1-25215d481020@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505130025
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDAyNCBTYWx0ZWRfX0w66UhKiW5vU Vhv3BXCSQZMQj3MiTY/yJ+njyTAfR9hE1y6zgiNVvBBKywAHJD1M79AMMMaQ/xZDk0XPTtRQKqd cKaRL3dlF/eW/BekBvDewr6s8+snEAlSzZRtsqs8DpKWXq/bASLQq/lI9s9AOXDF5qMZ+zE/snF
 7d0aIlOg7RLE8sK9paeHJrN2NW5NIACttoIiqT0SMnFJF3hB86Qf+CERwQodlZgOq4/vCAPwzD8 MrawQiCcjqXIdOvOTwt4Z+/ehshzp5tVqfWzAC2Ha/bTjo8jSzg6PBsZ4k8gRhdkCCJRRfGPlJk 8OCaSD7bRlUu5AnyeIkaFUWn+i5+djy6eNjUmNi5KWBn6Yho2QrRHnhfQJ3w0zsYDZfWv0Egr28
 FeumjUB57nZxgOVQu/a2aqbAexrrj1uym7ai5TjJKHPQcl+xLW9vlS9jP/uCov/ZtJlvgsWj
X-Authority-Analysis: v=2.4 cv=VMDdn8PX c=1 sm=1 tr=0 ts=6822b31c cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=nScL1aOB0x_2kgwzweYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: ezbPkgPuUCRHnAxAh80yvmh2xOy9neC3
X-Proofpoint-GUID: ezbPkgPuUCRHnAxAh80yvmh2xOy9neC3

On Tue, 29 Apr 2025 17:46:49 -0700, Nathan Chancellor wrote:

> Clang warns (or errors with CONFIG_WERROR=y):
> 
>   drivers/scsi/dc395x.c:2553:6: error: variable 'id' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>    2553 |         if (!(rsel_tar_lun_id & (IDENTIFY_BASE << 8)))
>         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   drivers/scsi/dc395x.c:2556:22: note: uninitialized use occurs here
>    2556 |         dcb = find_dcb(acb, id, lun);
>         |                             ^~
>   drivers/scsi/dc395x.c:2553:2: note: remove the 'if' if its condition is always true
>    2553 |         if (!(rsel_tar_lun_id & (IDENTIFY_BASE << 8)))
>         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    2554 |         id = rsel_tar_lun_id & 0xff;
> 
> [...]

Applied to 6.16/scsi-queue, thanks!

[1/1] scsi: dc395x: Remove leftover if statement in reselect()
      https://git.kernel.org/mkp/scsi/c/bf6971a2b3ee

-- 
Martin K. Petersen	Oracle Linux Engineering

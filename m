Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D3C440C;
	Sat, 17 Aug 2024 01:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723858585; cv=none; b=hhKsBdsMDDGPRPtFRgIkjIBqmcps36ivpiZ7rxw+H09zfhNKCJVc+xTbIwm0xjUlgXL1WDzMLql8uPPpPVXxupvH9xdGZTw6MD1B6F5eMFuY5QQfw9g0FF3x2Z/3S4FitgeWqs/5rDcAgTGoB8Ozk2Ty94LE+qlUSkLoABtNqTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723858585; c=relaxed/simple;
	bh=0O25Mm60bYKwOEosx4Bdj6CUTx7itBATQEbDySgKMYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dzNVZen4YojZm2QrJrqdKROeZt8e6juDlz57y9hL/4x+ZLBqJoEMm7ZqIgoaIPs3Mfvqo+FJhcaabp4BRgdm2+tI2H+DXiaybIqLSTmi1H+3v3Xr6/0ED5qJI5SVvoGRZvpGo27jESQTwCuVPkVGwWoI0XlShXBPIPu5fbqcLsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DIfpCkpV; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DIfpCkpV"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47GLBvTm007647;
	Sat, 17 Aug 2024 01:36:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=nJHU3XZ9N/yLVO8iZKjEAxNp8c+CiMSiSuBerZyTsh4=; b=
	DIfpCkpV181Ku5XWqpW+79s3t46uCM/tUhmlXAjESJJkOOgBKan9zWD1b2IYy8eA
	i1UoMLggo4SfvORlk5w9/z90u6gBxUP1UZb5zONR42f7YyxcxyXIYwtT31NLQ/Nx
	vsKfGmzoEED5fn8pKsQWjf9+t0FAd6a2Y9m0PsinovB5PoYYXfIkUqBQH4RG5pkf
	O0GCGOEnQa4tLfLPdJQz9FcW6MGzCg1ue9mzJ6zoCU0FMdTvqioqjY+LjZF/Iaat
	YyDVgz5SnL7WO6epR8NPzS9YRIBDBfo2avx/DwM80CaNEjUEc0yl63OueLxeCE04
	7FC6TuQ3hyFLSkWczNsBKA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wy4bnux7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 01:36:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47H1XVPI023564;
	Sat, 17 Aug 2024 01:36:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 412ja5r10t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 01:36:20 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 47H1aJsf029132;
	Sat, 17 Aug 2024 01:36:19 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 412ja5r0yx-1;
	Sat, 17 Aug 2024 01:36:19 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: axboe@kernel.dk, James.Bottomley@HansenPartnership.com,
        John Garry <john.g.garry@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] block atomic writes tidy-ups/fix
Date: Fri, 16 Aug 2024 21:35:39 -0400
Message-ID: <172385819627.3430749.3510957430404257870.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240805113315.1048591-1-john.g.garry@oracle.com>
References: <20240805113315.1048591-1-john.g.garry@oracle.com>
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
 definitions=2024-08-16_18,2024-08-16_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408170009
X-Proofpoint-GUID: 0rRPNMD9u9Dc7t7KlC-HNvXy4YD_aUEu
X-Proofpoint-ORIG-GUID: 0rRPNMD9u9Dc7t7KlC-HNvXy4YD_aUEu

On Mon, 05 Aug 2024 11:33:13 +0000, John Garry wrote:

> These two minor patches are tidy-ups for atomic write support.
> 
> Both are related to ignoring that REQ_ATOMIC can only be set for writes.
> 
> The block change could be considered a fix, as we are needlessly
> checking for REQ_ATOMIC in fastpath.
> 
> [...]

Applied to 6.12/scsi-queue, thanks!

[1/2] scsi: sd: Don't check if a write for REQ_ATOMIC
      https://git.kernel.org/mkp/scsi/c/0c150b30d3d5
[2/2] block: Don't check REQ_ATOMIC for reads
      https://git.kernel.org/mkp/scsi/c/ea6787c695ab

-- 
Martin K. Petersen	Oracle Linux Engineering

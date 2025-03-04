Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6BF1DED76
	for <linux-scsi@vger.kernel.org>; Tue,  4 Mar 2025 03:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741058399; cv=none; b=hTHhq2s8g9jlLSMZS8WLOPUUDMKqTwRUyODJVYKDUouTRsLuUlbsWShjJhSGznv1ePjYtcSII9mewGNMfHAfHmTtGuGxZ6iabHGEG9ygxH2D5e2U1mg8jjelMehSWsmp0N9Vu8R/mSobH6hO/XxzNmizxfaPft47TDKyGUo8kM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741058399; c=relaxed/simple;
	bh=PVUYXsDzM7+vy0Sf6rwgw8p4bZbOP404vCpF7v/fQZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NZvwRn++GPY7dWs9Wty7zQ4OK9lzbti1mh+Q5Ful3WlYCQWuiYPK0mG8+/aJNvNLNAFmueLZfUq+m8Dpo5lkPlnke8F99uSNM3herTk3Yt/nKp+on/lQgYj2rgJ1KeOAIOYV70nFyc5eZ9LKOwoxscIlvi4U8r6gI7TjLIQkw3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Uvye60lJ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Uvye60lJ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5241NHDY025797;
	Tue, 4 Mar 2025 03:19:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=VHyABJ0/rI3bQZ6Ili2av9c7HHcAp09j87Gkc7E5dUo=; b=
	Uvye60lJOFfqIg+SVKqEuiQJpIgtWLUC0vKiwGjvlVamccPbd2gJQ99OdTweMtBr
	Crf/Z4ZKar6ilqvCenY+GIwWJRRffiTAicUpnQWHmjy9Dae5dh0YEqA0Y5fBVCIy
	qjK/ZNeRbPYdVQHsz02MUimftwwkVCh3eEJWGk56CWUIJWcKe+y7xwz/vm86rLC+
	Dq7uFLBmYxn1zA8fiwxcVhD2V0lt9VElLF0OkG2NA0tL1s7bvxbL8OFlTbMal4nN
	hxKpxfVzXpBNrY33G/QxmXN/e8grVlFnAuLxu6oH5AI3+X9YNiRufG5jYfOWGkhh
	nNKutHDzhvPbMbZaUCowNQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u8wm1ym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 03:19:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5241QGCV039728;
	Tue, 4 Mar 2025 03:19:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rp92shj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 03:19:53 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5243Jl4k029873;
	Tue, 4 Mar 2025 03:19:53 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 453rp92set-5;
	Tue, 04 Mar 2025 03:19:52 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Yuichiro Tsuji <yuichtsu@amazon.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: qla2xxx: Fix typos in a comment
Date: Mon,  3 Mar 2025 22:19:19 -0500
Message-ID: <174105384026.3860046.8845031604250690182.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224075907.2505-1-yuichtsu@amazon.com>
References: <20250224075907.2505-1-yuichtsu@amazon.com>
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
 definitions=2025-03-04_02,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 mlxlogscore=807 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503040026
X-Proofpoint-ORIG-GUID: rMeIhUBtvAF6gBSWbIt-lqKnmWeWUUF3
X-Proofpoint-GUID: rMeIhUBtvAF6gBSWbIt-lqKnmWeWUUF3

On Mon, 24 Feb 2025 16:59:07 +0900, Yuichiro Tsuji wrote:

> Fix typos in a comment.
> 
> hapens -> happens
> recommeds -> recommends
> 
> 

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Fix typos in a comment
      https://git.kernel.org/mkp/scsi/c/0107fb8686b2

-- 
Martin K. Petersen	Oracle Linux Engineering

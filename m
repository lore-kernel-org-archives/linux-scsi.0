Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E7230146C
	for <linux-scsi@vger.kernel.org>; Tue,  9 Dec 2025 03:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765250485; cv=none; b=QwwxSQ6wQGTBhPtJWpzn1lHBkAg4/9LWK2bNddIlD0HS2Hs8PtRx1kplCzqVK94WwOP8tPR16cb9bokg0/YN9yElRPBuGv3j3obsJCNdR8VMEQ8bQD3ZzINtQi1SuAQ83TmHi3ubpN/kHkfXdWJ4/0eRVrAk4eRW8GGIIvTZ8MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765250485; c=relaxed/simple;
	bh=zmd+gpIRLmMD8+E9+NOOPx5zgn6cWYGVy3Lz1Ys807U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JP/I8tWuiJQ78DwtauGst4LIQe52YaXmESGB/kveUmUFRPSV1O2seVwj3WCSAYSTBHajvzygW8q/X4M1gjUUWQr6ORm0cp+T1CNGd+jI/HJHsDdOoUjWUsO9Bm+eK11vRcGsB8B8LO036g6APcwltJgPSkSNqbOWo9zJSkH4434=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nF18Z0nV; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nF18Z0nV"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B93BTG13981448;
	Tue, 9 Dec 2025 03:21:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ouKHCH45vdMR0dNJm2Sav6r8kbe1nNY6sAvINzwasdQ=; b=
	nF18Z0nV1m8U2NWRd4hvBPX89in/pZrT/F2J46Ksj38/MmFfeFfpxtnW85RNK7wP
	RByTRUoBAI/KqoO3MX6AExMQcNSnFkAykXX2Q7q52Iudwiy0IAmi8vyzKNcGBcJa
	dKlw5fkLpQo3y/Pkcji83DcKSSofEfWtv0DzLY5OSv+pyqOxW/0vLhcNt7i+3vFq
	OFzX1JXOoIbCi77UUzvqc6nERe/2din5HOh1yvbPu8jpl+WEAO8u+du7a2OINvLT
	NTG53sjdZdnZzClj83kDkVGixJy74X3MIxySMC0u3pSjSSEy04JNWMF4RvLhhsnZ
	EqxWt6otxqUu4TKWDIfyxA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4axbn7r08a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:21:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B92AthM038112;
	Tue, 9 Dec 2025 03:21:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4avax8j012-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:21:18 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5B93I4FU022652;
	Tue, 9 Dec 2025 03:21:18 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4avax8hyys-4;
	Tue, 09 Dec 2025 03:21:18 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Chris Boot <bootc@bootc.net>, Heiko Carstens <hca@linux.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: target: sbp: Remove KMSG_COMPONENT macro
Date: Mon,  8 Dec 2025 22:21:03 -0500
Message-ID: <176524933129.418581.13940667675808206575.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251126144027.2213895-1-hca@linux.ibm.com>
References: <20251126144027.2213895-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-08_07,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=915 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512090023
X-Proofpoint-ORIG-GUID: mzkQg3Z6EBZw8XZRq6XkGpOkg93WIPdd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA5MDAyMyBTYWx0ZWRfX60M3kBCGzCaZ
 GisGaF9hMCAtUBrGAwCcpRWfZlfu5fxn8arb1l9c99XvlipW1NIwnOrvmDuoYeeRXUiLDt6riTl
 dSRWd0lsFDtY3Rtl2ygD6lbiAlas8J7O2+8ORPBBBiLATzV0YsWynFn8uR6+QqhWZJmCMWxqgan
 qBh8B8FyDbYx1i/ePP6evhY6HtiL/ykhmbUoiMkuxcBKIJhw6hhzPcc7SfmH8/91PQ9RXzCIYFP
 orrLA7afQ0Uc7eL94AdEt5J9kFcs4bdi7nMNZxQo1QdD7a6AUvJdfS7zVwK63mRSEfPoQcYXt5X
 UBGGNMBA7Sm+SiCqEKTD0907HHQHC79U+ko0b6WG8yTwNhOAPC0HxHB7fq904g7Pi9BLzZeToJK
 lkAEFTMKNS2MEzqrPU2Vvx/ot71TTg==
X-Authority-Analysis: v=2.4 cv=NtncssdJ c=1 sm=1 tr=0 ts=693795af b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=UzYemIi4oM-TtD-D_kAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: mzkQg3Z6EBZw8XZRq6XkGpOkg93WIPdd

On Wed, 26 Nov 2025 15:40:27 +0100, Heiko Carstens wrote:

> The KMSG_COMPONENT macro is a leftover of the s390 specific "kernel message
> catalog" from 2008 [1] which never made it upstream.
> 
> The macro was added to s390 code to allow for an out-of-tree patch which
> used this to generate unique message ids. Also this out-of-tree doesn't
> exist anymore.
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: target: sbp: Remove KMSG_COMPONENT macro
      https://git.kernel.org/mkp/scsi/c/971bb08704e2

-- 
Martin K. Petersen

Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A581CD00;
	Fri, 23 Aug 2024 01:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724378211; cv=none; b=d6dJClOxSI58B7jSHh/W1UfmTJgWU49A+LlNw1uF4ZHBAnBigcxBlaG9IKw6iujqMKfhs1GmOqRvOo/3Xnovn2gU8uWtoX2fXbQTc8tZl5S/V6Dq002PRUDcIFubUxqzSZAu59izjOqNCijr7peIUFS8Jbt41Ka+4e9Q4/z56lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724378211; c=relaxed/simple;
	bh=78ppxU2DrcTP4h2rajHNIVga77Utrr1L21C0Cez+C5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uUTUQ5TNpsB53OKF+JIcSjD0BA0oqIl8ZFy0JQRLTd0R+U2vstFQzgyFSyKkpwtNtHvyaEyz8lPBFHCS1lCSVPx1wS/Vse29G288S+lzHZtA1GaLeHfpyW+N8amzByAiN2GM334SWJSw45kRBxI72tSpjxAhA9n4VBeEyHs9OY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MJCXrCIE; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MJCXrCIE"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47N0BUZw026907;
	Fri, 23 Aug 2024 01:56:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=V5djnhEUpPQwDTbcUtQo9lJiA5uCN1pFKUt6h7Xfgp4=; b=
	MJCXrCIEpJyw2g4vWRu5JrBf3urS66r1Hh5suuyaWukiZ53HeD9ZggsBJcaut8wn
	AYnyFmL8cZE/pYnlgWyA/2jUCYVxIQkVJRVyPID8f5Lplx304cEIlNmc9gZXvbPZ
	uGvzJm2h2G8f/j3z36Oqd1YnjabgkkRRQZ6fMC/eQyPbB3f5MfuNBih3II+3xf3u
	2Aa8vv+pchuKS+KOvmkeGAuo06eE4kbikZoOaKtvrb5zphCE9UePgBS7o1P7aGF5
	x5ZKBxpiipU5Oxc6nbsCc7RyWT3Gi/Mrc03YfDjpdF2+tWEgv5cSKo3IsFlvPnAn
	1EUbMxZvRJMCHjre2v00fA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 412m2dke88-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Aug 2024 01:56:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47N0Y9WZ012035;
	Fri, 23 Aug 2024 01:56:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 416g0e9qnf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Aug 2024 01:56:44 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 47N1ugAu033471;
	Fri, 23 Aug 2024 01:56:43 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 416g0e9qmh-2;
	Fri, 23 Aug 2024 01:56:43 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: james.smart@broadcom.com, dick.kennedy@broadcom.com,
        James.Bottomley@HansenPartnership.com,
        Sherry Yang <sherry.yang@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: fix overflow build issue
Date: Thu, 22 Aug 2024 21:56:03 -0400
Message-ID: <172437814913.4018943.7804520176988407566.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240821065131.1180791-1-sherry.yang@oracle.com>
References: <20240821065131.1180791-1-sherry.yang@oracle.com>
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
 definitions=2024-08-23_01,2024-08-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408230010
X-Proofpoint-GUID: oOU0im97jwUWzAICyTrndUHYVFxPameN
X-Proofpoint-ORIG-GUID: oOU0im97jwUWzAICyTrndUHYVFxPameN

On Tue, 20 Aug 2024 23:51:31 -0700, Sherry Yang wrote:

> Build failed while enabling "CONFIG_GCOV_KERNEL=y" and
> "CONFIG_GCOV_PROFILE_ALL=y" with following error:
> 
> BUILDSTDERR: drivers/scsi/lpfc/lpfc_bsg.c: In function 'lpfc_get_cgnbuf_info':
> BUILDSTDERR: ./include/linux/fortify-string.h:114:33: error: '__builtin_memcpy' accessing 18446744073709551615 bytes at offsets 0 and 0 overlaps 9223372036854775807 bytes at offset -9223372036854775808 [-Werror=restrict]
> BUILDSTDERR:   114 | #define __underlying_memcpy     __builtin_memcpy
> BUILDSTDERR:       |                                 ^
> BUILDSTDERR: ./include/linux/fortify-string.h:637:9: note: in expansion of macro '__underlying_memcpy'
> BUILDSTDERR:   637 |         __underlying_##op(p, q, __fortify_size);                        \
> BUILDSTDERR:       |         ^~~~~~~~~~~~~
> BUILDSTDERR: ./include/linux/fortify-string.h:682:26: note: in expansion of macro '__fortify_memcpy_chk'
> BUILDSTDERR:   682 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
> BUILDSTDERR:       |                          ^~~~~~~~~~~~~~~~~~~~
> BUILDSTDERR: drivers/scsi/lpfc/lpfc_bsg.c:5468:9: note: in expansion of macro 'memcpy'
> BUILDSTDERR:  5468 |         memcpy(cgn_buff, cp, cinfosz);
> BUILDSTDERR:       |         ^~~~~~
> 
> [...]

Applied to 6.11/scsi-fixes, thanks!

[1/1] scsi: lpfc: fix overflow build issue
      https://git.kernel.org/mkp/scsi/c/3417c9574e36

-- 
Martin K. Petersen	Oracle Linux Engineering

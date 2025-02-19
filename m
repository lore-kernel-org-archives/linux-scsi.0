Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415381E4AB;
	Wed, 19 Feb 2025 01:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927249; cv=none; b=YqgMEt4y1C9rv+/T+IjgKrUDY8iBU0Lmj8O++1GmwEB9myUsOb23DAj/nOF9B2MbG0Ef7rDGETLht3EOMUnyqLnE0grOy4YF3dksD41CDzpxsLE/t1sSwUX9rDARjls7tXh9+HqWTrLmxlMO5w13nZELSxe4mRC3sLfv00N7LFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927249; c=relaxed/simple;
	bh=/Rf65F85pkUiV5nrOq8Au0uE/3xruaDXFJ2mQw85668=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NsMELqWkgbRwuOwswVOKhiz+Guk5IpdxmgAb7J+aECFg8OzNb6+mHMAlHHHZZijxGEiCjXxqeo/OfnWa+0WsBFjq0XvV3rOi9SnrgemWTtL0c/TLT2IfRrk5BXJks1X5ngRN2/QXip0gtVetEHxf+PgfkpG6s6IFuahFKC020JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nop5DK9y; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nop5DK9y"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51IMfWXM006244;
	Wed, 19 Feb 2025 01:07:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=gsjkC1bMzt9H36MIm7lCtfrmrPip0k5gLjrM6k3FpCk=; b=
	nop5DK9yrBOOETguhc0hiB+NEocRd5ExX62rNZNnGEVa9M2GKr7b8vnLl/I5c2OH
	uXO4nZERvMgviLDoZEfdcYItI0YGlBnrTZ3FTZ2UL/1RF9pJkDfB/4ukDymxhbLN
	tn3V0OFXMXJaU3W99rbSL6rlZYElk5cNiUNnUb6366FVRHrACN4xUp5dY8i2wqjU
	QxRpr4uF2xqoUk+IGr01eSTpGhAQwcmPIC8FuQHmYPdfZicJ2SWzi9EBbrAziZs8
	GhvUm9NaCi5IU0KC0+pFseL019e9fk6A3MDZqp0jmBW2KhYAsW+l9InRJI5Z/ROr
	+FZwrSzAII/43OctZBGPrQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00n0jy8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 01:07:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51J0EZSi002092;
	Wed, 19 Feb 2025 01:07:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44w0tk1rrj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 01:07:23 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 51J17KeR000669;
	Wed, 19 Feb 2025 01:07:23 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 44w0tk1rq5-5;
	Wed, 19 Feb 2025 01:07:23 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        Colin Ian King <colin.i.king@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: mpi3mr: Fix spelling mistake "skiping" -> "skipping"
Date: Tue, 18 Feb 2025 20:06:53 -0500
Message-ID: <173992713064.526057.3708376196614857729.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205091119.715630-1-colin.i.king@gmail.com>
References: <20250205091119.715630-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-18_11,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 mlxlogscore=863
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502190006
X-Proofpoint-ORIG-GUID: fa9Ey9byn7A8mJvTZMOM7WDgrM6Y6Li7
X-Proofpoint-GUID: fa9Ey9byn7A8mJvTZMOM7WDgrM6Y6Li7

On Wed, 05 Feb 2025 09:11:18 +0000, Colin Ian King wrote:

> There is a spelling mistake in a dprint_bsg_err message. Fix it.
> 
> 

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: mpi3mr: Fix spelling mistake "skiping" -> "skipping"
      https://git.kernel.org/mkp/scsi/c/7c1b882ccb13

-- 
Martin K. Petersen	Oracle Linux Engineering

Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138516F06B
	for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2025 02:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739156356; cv=none; b=PYGfKEEe6VL6pWZr5SxO1LpB/lxg51O3C4YFcab5mfbxdHBxbs240a3xtuD+sHoUP9FgTnkmn6WBaQdfpZpOarDOgoCYwf6FIzSjCs3MtzBytRoRaiJCOw9WiouRD0NNgrN7kLDuumzRc+NTp6qVp+pdr3IPRVJ75H9p7bsfgbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739156356; c=relaxed/simple;
	bh=eXdGT2gk0EVpItgdFTL+OpCsz7mvIQsQja73EnQBXbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z6Gw/9rGwuTISWiI3AOoTZnhxOux+ik8Go5lsKBermRV3xFQ6Bqp5T+Bqzs3McUauXk9gqPnafwgmp40LJRrQICIp4K6cfC4F9fdbYX48Bhi3PwFiyka6+vFE4H+x0//Njaq0A6gcTY69qpkfVGWgUn02hcbfCNBcuu+oicrGY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZeIHI+us; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZeIHI+us"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 519Mn6N5009399;
	Mon, 10 Feb 2025 02:59:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=9JPtSfrDTA2wHbCkLnLkBl0b0ynrafz21m8G11sGejk=; b=
	ZeIHI+usvDC1Z6+Ad4oAnzpZB4l6uVJsZ3xjbRS68My7oFn3CILXXCW7pOXxl4sn
	+t0Zm0X0XjlQ6pDtMARTjMPm+2WpxAkwlm+PI50p8H6jQQUtxAtTacUh/pQ60iB9
	aJ+DU97a36FbTc6xzxdKgjXAf4GK7PA47tTjsQP20tSwGrSZIzJ80riTaLuGJqML
	qN1EBxsgEQv7m18t//OQE5RaGfjzoO+CA8G+Kia9xelj6jdnC1awq4Vjv52JslbX
	fjIIy7JYEqM1okjRlBwYj/us6G3Ak+3dh6c9UxWZmAynOf+2Ju+BaZ2rbWglpDCQ
	QdnFh7jtdzsSCC0nTqPBSQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0qaa39k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Feb 2025 02:59:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51A2XqSU012644;
	Mon, 10 Feb 2025 02:59:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44nwq6uafx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Feb 2025 02:59:11 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 51A2vwAl033952;
	Mon, 10 Feb 2025 02:59:11 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44nwq6uacs-8;
	Mon, 10 Feb 2025 02:59:11 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        prayas.patel@broadcom.com
Subject: Re: [PATCH v1 0/4] mpi3mr: Few Enhancements and minor fixes
Date: Sun,  9 Feb 2025 21:58:30 -0500
Message-ID: <173915612142.10716.325633758479355386.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250129100850.25430-1-ranjan.kumar@broadcom.com>
References: <20250129100850.25430-1-ranjan.kumar@broadcom.com>
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
 definitions=2025-02-10_02,2025-02-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=952 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502100023
X-Proofpoint-GUID: 9e1P8FJhx2DIaFC_3UlQQYvx3JEaYLPn
X-Proofpoint-ORIG-GUID: 9e1P8FJhx2DIaFC_3UlQQYvx3JEaYLPn

On Wed, 29 Jan 2025 15:38:46 +0530, Ranjan Kumar wrote:

> Few Enhancements and minor fixes of mpi3mr driver.
> 
> Ranjan Kumar (4):
>   mpi3mr: Avoid reply queue full condition
>   mpi3mr: Support for Segmented Hardware Trace buffer
>   mpi3mr: synchronous access b/w reset and tm thread for reply queue
>   mpi3mr: Update driver version to 8.12.1.0.50
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/4] mpi3mr: Avoid reply queue full condition
      https://git.kernel.org/mkp/scsi/c/f08b24d82749
[2/4] mpi3mr: Support for Segmented Hardware Trace buffer
      https://git.kernel.org/mkp/scsi/c/339a7b32a371
[3/4] mpi3mr: synchronous access b/w reset and tm thread for reply queue
      https://git.kernel.org/mkp/scsi/c/f195fc060c73
[4/4] mpi3mr: Update driver version to 8.12.1.0.50
      https://git.kernel.org/mkp/scsi/c/35a0437d9f33

-- 
Martin K. Petersen	Oracle Linux Engineering

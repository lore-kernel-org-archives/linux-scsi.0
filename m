Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346FF76025;
	Mon, 10 Feb 2025 02:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739156356; cv=none; b=gN7LaAzC3SrDhRozY3l4AiHr4ATwIMHiQRK1hxsAWTwL+dG80MOfvcIasGi2LXralDAo8mYoA5bF37VUSGcZK5q0Upl5Np7Z6w4WO5XeqEUKxJPvGWubqfDUGDyCbwLqTLxcZl7DcqBNzngJoOFQw3eUd4DqZNphqJL8jnkA0x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739156356; c=relaxed/simple;
	bh=Fm4/UmLj2CJtZ41eeypoqHTNIsX8PHVbAsgLysyA4WI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iJjzAURnf+etLKAOibV3n6GnJrs6DkLQZX9cYouiiP8H4u9AgfBxBJ6cKJCKrtEjBelkZAL4lNIg293Bnsk84Uve4/8Yqxv6No2XfzAn7W3R3YTUOzxOimN1tIPs8fXbo9+gIXx+Wd/hp56JFKwUwWZOXgJrjNCNKV4mwCwaL08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m0twaQJ7; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m0twaQJ7"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 519MmNta016108;
	Mon, 10 Feb 2025 02:59:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=C1jk4s78mWdrhadyucq1L5kpymEDOjPWUbx5RMvvmU4=; b=
	m0twaQJ7Ba/oEQaiJe/tlSvCb/VzYfG4LUgWogSzRlI9LXl05D6URxn5e391Ri3q
	OcZsKYREdelXYp4zTeQK91JoqqPoGDIr2dpbw5H87niBW8nKo+XCu8mT26d/vE8u
	xhYv+zE+QWLYyDl/zYkea1pLq9Xm/5o3/Lqk/X6CnTEtVu8EXGnR7SFkXDc5ZhDZ
	I8xlTEwOOGU5O9/fcfLHnQXOQoB9R0Zlx1DWmIcSHYrrAdXo2Q45Az0XWU4tXkeD
	cR1RUUvhb2jSU+l7/pWUteErlR7K6B4SihOMH/g4Y8017ZqmR0b97QOH4mOsB7X7
	TINgUhvlNEcDc3hQgp61wA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0qyj40k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Feb 2025 02:59:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51A2HQmU012498;
	Mon, 10 Feb 2025 02:59:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44nwq6uaf9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Feb 2025 02:59:09 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 51A2vwAh033952;
	Mon, 10 Feb 2025 02:59:09 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44nwq6uacs-6;
	Mon, 10 Feb 2025 02:59:08 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com,
        James.Bottomley@HansenPartnership.com, linux@treblig.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: Remove unused config functions
Date: Sun,  9 Feb 2025 21:58:28 -0500
Message-ID: <173915612136.10716.15105185942582612368.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250127002851.113711-1-linux@treblig.org>
References: <20250127002851.113711-1-linux@treblig.org>
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
 mlxlogscore=913 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502100023
X-Proofpoint-ORIG-GUID: 70Xe1hTbm9kkP13PxAOCmHw7bjKtjCF1
X-Proofpoint-GUID: 70Xe1hTbm9kkP13PxAOCmHw7bjKtjCF1

On Mon, 27 Jan 2025 00:28:51 +0000, linux@treblig.org wrote:

> mpt3sas_config_get_manufacturing_pg7() and
> mpt3sas_config_get_sas_device_pg1() were added as part of 2012's
> commit f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")
> but haven't been used.
> 
> Remove them.
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: mpt3sas: Remove unused config functions
      https://git.kernel.org/mkp/scsi/c/08795f4c096c

-- 
Martin K. Petersen	Oracle Linux Engineering

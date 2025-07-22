Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFC91E377F
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 03:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753156064; cv=none; b=OpvMhLvxT62aB/QJX9M6Eq8+B3mJ8cn2oT6oRLL7T7DqkPEcHuSqY+BQ+WDIwMjKaYXZa+GVscj5fS1FthoA4X5G1tX6OGhEgi1u34fmr23lGEWRnAVNb7Oh8B/g6TmG+QHZyWYljg/kFCLkiTtRrkcCNMpSgdyHP5Bz+zoDw2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753156064; c=relaxed/simple;
	bh=Jv1NdbU63aFO4LFAFTApNMXLRj2oKAg1Cp72TMRwX7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c7PMDWLhXEtqOj0Pnh8KJ+1piwKe8+73rd1bM3/nKyuLU4L4rAxqWeUPgK1GkfOjOJy40SG+kdiqR/z+v74kJTt9aTavbsmBEEXz7jdVJU1GDgr4UTrwUY/JXGZwKVqnQATAqc82e9VzM+cUvt1irZA7BxZRZmk6/gi2mN47wZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fst7qAyM; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fst7qAyM"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56M1Bx9K019815;
	Tue, 22 Jul 2025 03:47:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=9JbZhKxD0dAMYNcOgXPC0t6qAT/uP9zdDDoGDlhfb30=; b=
	fst7qAyM3/wrLukm5+Ufvb+vfQbp8fBe24OG3grJhmS1KXNWrSYTCfsADjDh3W0d
	e0OizmUGhBEFjcX3uqd3huy/RYWPJEJ1j0d9+Vg7qstZBn7Zbi660k6+qNt3MTa8
	U07K9dvxqSmG3Z49SD/bWYeL9cH1q4AbOPEJPcoFn7pNCjm7idhcy6tw3yPKzZi6
	u2HlBtlPEDKMDP0QOiuqVMRix4aGjMqqrR2O8R+szIO7vhp9bMj/4YWW7jmcmCHY
	vVnJ7LHnWKR+BtNBTj96+q0bGlzol1EPWG4NvqGQGWmhCsldT8GYL0zlF4mmsbIU
	+LSBPmQxuHz9P2nsnXvxPA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805hpc8st-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:47:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56M2UJU8038327;
	Tue, 22 Jul 2025 03:47:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801t8teay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:47:40 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56M3lZjJ031915;
	Tue, 22 Jul 2025 03:47:39 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4801t8te8u-11;
	Tue, 22 Jul 2025 03:47:39 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        prayas.patel@broadcom.com
Subject: Re: [PATCH v1 0/4] mpi3mr: Few minor bug fixes
Date: Mon, 21 Jul 2025 23:47:04 -0400
Message-ID: <175315388516.3946361.4116237666902442423.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250627194539.48851-1-ranjan.kumar@broadcom.com>
References: <20250627194539.48851-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-21_05,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507220028
X-Proofpoint-ORIG-GUID: -rPSodqr-IK3ji4jsSxa1OcGxKnaiwF9
X-Authority-Analysis: v=2.4 cv=YY+95xRf c=1 sm=1 tr=0 ts=687f09dc b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=FvYuZSQ2nueQyQtoWbsA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12062
X-Proofpoint-GUID: -rPSodqr-IK3ji4jsSxa1OcGxKnaiwF9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDAyOCBTYWx0ZWRfXy/UX3mGOOvNo
 fXP4oYapPcIb8ZUBurYuvOOi50Hk3vThOWD8fGMjrv3RTs4+yKqVRXC1296Kjlnjjn8HskFgmST
 UsdItm24mfR6O4trLLIVF5Hbf5F/gXXNzyxCOEQET5g0p0bhzVzkE7FlR4db5u66+7xORwI3i+E
 Y1FKVoPXEvBdKXPPSBCCUmabEB+D0/LjdURHgFEpixZpmH6mI2cjWd8CVCL8NoKxfQ6blH3aMvu
 YV1m8RgHyq0eEKfFKiwvEsvNYylVCTUjVGwDDqanLKi5NkUGly/WHt9BLn9CrKIftyDMcStmHQz
 Q+qCr8ran5vw8urG/4DSg2BZLlq8oxkFqx/WDMl85p/utjXql264JacCvrX+ILKsUg4JYrG9lk8
 ougTC9B4BAMoLE5asGtde6Ak8iXiebWU0dQI78Lb9gcDozMaR9IFMY0hdj6RbkWAUeeeBhi7

On Sat, 28 Jun 2025 01:15:35 +0530, Ranjan Kumar wrote:

> Few minor fixes of mpi3mr driver.
> 
> Ranjan Kumar (4):
>   mpi3mr: Fix race between config read submit and interrupt completion
>   mpi3mr: Drop unnecessary volatile from __iomem pointers
>   mpi3mr: Serialize admin queue BAR writes on 32-bit systems
>   mpi3mr: Update driver version to 8.14.0.5.50
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[1/4] mpi3mr: Fix race between config read submit and interrupt completion
      https://git.kernel.org/mkp/scsi/c/e6327c4acf92
[2/4] mpi3mr: Drop unnecessary volatile from __iomem pointers
      https://git.kernel.org/mkp/scsi/c/6853885b21cb
[3/4] mpi3mr: Serialize admin queue BAR writes on 32-bit systems
      https://git.kernel.org/mkp/scsi/c/c91e140c82eb
[4/4] mpi3mr: Update driver version to 8.14.0.5.50
      https://git.kernel.org/mkp/scsi/c/e1c9a704f2c5

-- 
Martin K. Petersen	Oracle Linux Engineering

Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1301DED76
	for <linux-scsi@vger.kernel.org>; Tue,  4 Mar 2025 03:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741058396; cv=none; b=RQh+t75Z9vyNg2scwNyxXb07Wd+9IDJDXKQ3FEcW49PT6aG+eN9C9qdrrZi6FvC6+wTtdAxeA0OE8FAk6xckSCj3DkAJujseWxeoBSOwmK0VpL/4SXZb9S5cQ1rovVQE4Z1S9Kdd+nrt/0O9nVwjWhDGtzGlTkXlmvHh7h393uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741058396; c=relaxed/simple;
	bh=mN73M9qI9BEvQEvmdHacyIO1OQ6U1MpJ+z3XYel/zU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C8ENFa0dhfi7R4J0ShxtlF6LKIykU+vnBe0GfjgJ/ywMMSoJMkcVyB4mgFjn0f6A/dMeiIpL/JNbZ4+jExaxmkeMojnhNysvdJkjD9l6UrQbbBv6uEdVhqmSfgTa2o6Urul7oQRM85MWUA1PVHk9z7iWz1+fW2XeAQd8rRBfoa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hmy5inO1; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hmy5inO1"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5241NHEr011342;
	Tue, 4 Mar 2025 03:19:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=n36Z4A/gXorpOnv6PqUCRd2jkuLGKwWwAkfTPyhZm6g=; b=
	hmy5inO1K2Un9oStylmP87hHdYdm2zmwDiYUIdgG3e5793HhcwrEmI9/2mz7TlaQ
	weeF8qyBX6vjsettHZSXyxUV4ERQ2GxeMkFcHgQccCzr9fOLGz89LnnwCF6fxOeT
	d32Bzn8c+kK1A11Wa49Uqk4l/oKlQdrt+Z0Gqg5zo7RMJP2nXMy0+0gWozS/ww79
	Pj0kt+NGwRM8Xza6M1fRXiBD3zIv7nkmK0bWU/HO+YTOjnrQwLqGvnOrY0G+GMaQ
	aE17ZnMY/AyevuUiBBdSPJomQc1/4o3lXuYSzr2/EiETFD1s8CRH4S8usrEjAr29
	fQXbT6Kz4nYwZec5qtiibg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u8hc3vq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 03:19:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52420Tf1039093;
	Tue, 4 Mar 2025 03:19:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rp92sge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 03:19:50 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5243Jl4g029873;
	Tue, 4 Mar 2025 03:19:50 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 453rp92set-3;
	Tue, 04 Mar 2025 03:19:50 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        prayas.patel@broadcom.com
Subject: Re: [PATCH v1 0/4] mpi3mr: Few Enhancements and minor fixes
Date: Mon,  3 Mar 2025 22:19:17 -0500
Message-ID: <174105384021.3860046.16120384173483149548.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250220142528.20837-1-ranjan.kumar@broadcom.com>
References: <20250220142528.20837-1-ranjan.kumar@broadcom.com>
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
 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503040026
X-Proofpoint-GUID: 5zQojIB03RfTAUVewDYPoq9LqDg5P8PJ
X-Proofpoint-ORIG-GUID: 5zQojIB03RfTAUVewDYPoq9LqDg5P8PJ

On Thu, 20 Feb 2025 19:55:24 +0530, Ranjan Kumar wrote:

> Few Enhancements and minor fixes of mpi3mr driver.
> 
> Ranjan Kumar (4):
>   mpi3mr: Update MPI Headers to revision 35
>   mpi3mr: Update timestamp only for supervisor IOCs
>   mpi3mr: Check admin reply queue from Watchdog
>   mpi3mr: Update driver version to 8.13.0.5.50
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/4] mpi3mr: Update MPI Headers to revision 35
      https://git.kernel.org/mkp/scsi/c/b9287574323a
[2/4] mpi3mr: Update timestamp only for supervisor IOCs
      https://git.kernel.org/mkp/scsi/c/83a9d30d29f2
[3/4] mpi3mr: Check admin reply queue from Watchdog
      https://git.kernel.org/mkp/scsi/c/ca41929b2ed5
[4/4] mpi3mr: Update driver version to 8.13.0.5.50
      https://git.kernel.org/mkp/scsi/c/95dc5b979f4b

-- 
Martin K. Petersen	Oracle Linux Engineering

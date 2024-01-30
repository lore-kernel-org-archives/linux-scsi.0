Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C5A38394
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 02:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706581665; cv=none; b=bxulhgrM8DFCElv+y7G7kvxdALcUSO3MvDEmQBsk4p0Kc6/7zAFBEPP5TytofJz/c0+4CD0aG92pN+yiK+rFEazBSL3fFGUH5uKB6M+28HJFKBKhs1a0NxYGygS7+F3WWqg/a2+eGaFup+0blGooJ5iYa3DBtVVeD/ycut2jRqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706581665; c=relaxed/simple;
	bh=NtVXLN9TS2pjf3A6ryMjHWkdoOQQt7mgdDsBPYoAzuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rveTA/BxloTtwN9bFuLQu0Dkpk6N1IXPIsFQW4ygIEXod6ojdC3syYQlsV8Q32NEjvk69FERcJm4GUgupFeGpAjJY51mV7YuGa7o1cPhlbvk2U+mgQxZNAf6nlGiucQqyeT63Hy/R26VlwmFmThHViQBYOw5BrQR0XjipnwDJe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UGuWFXyE; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UGuWFXyE"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40TJiILo021858;
	Tue, 30 Jan 2024 02:27:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=b3c22P6Gzd7RQR1Fzn9bXmeu7DXuBf0425v718hNx7s=;
 b=UGuWFXyEz1L+/RT+VTSVH+8fBoSJS6zNlZR2x40VGMrCM3c9lWPWx/sPle4Oqt9gE3xr
 uXLTMFdUI4CgPg7GRdTx6h4mqtBWSRrPOLbzoKHtbE7+irH3HvjLxdjCUyeBq7NMLOeU
 Q3XdXXSrMbMkxh1znHP8T/nb9N6kqLBgB0W1qHs/aAHHtRxIN1f8umW5pV0jrEjIo9WJ
 iXSg2nOYPxEq7LLM45joPLgcJdrx9H7WWuCalBCa/KOQAqfx9rM2GRVayjpfdXSFnonY
 E79yUC9MVTDfsMLXtR8B3Ds9l+GzpbXLRvk6ibLx8uIpJl/TVBA0hBpNcBQswvS0n1s9 Yg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvre2dke3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Jan 2024 02:27:38 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40U02XYV014555;
	Tue, 30 Jan 2024 02:27:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr96g52b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Jan 2024 02:27:37 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40U2RPxu040916;
	Tue, 30 Jan 2024 02:27:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3vvr96g4y7-9;
	Tue, 30 Jan 2024 02:27:36 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: sathya.prakash@broadcom.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, sreekanth.reddy@broadcom.com,
        jejb@linux.ibm.com, Guixin Liu <kanie@linux.alibaba.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2] scsi: mpi3mr: use ida to manage mrioc's id
Date: Mon, 29 Jan 2024 21:27:05 -0500
Message-ID: <170657812679.784857.2804214005937814048.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231229040331.52518-1-kanie@linux.alibaba.com>
References: <20231229040331.52518-1-kanie@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-29_15,2024-01-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=586 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401300015
X-Proofpoint-GUID: YMpwAw3_IQw4S24FTWcfV-gaCr0IgDrn
X-Proofpoint-ORIG-GUID: YMpwAw3_IQw4S24FTWcfV-gaCr0IgDrn

On Fri, 29 Dec 2023 12:03:31 +0800, Guixin Liu wrote:

> To ensure that the same id is not obtained during concurrent
> execution of the probe, an ida is used to manage the mrioc's
> id.
> 
> 

Applied to 6.9/scsi-queue, thanks!

[1/1] scsi: mpi3mr: use ida to manage mrioc's id
      https://git.kernel.org/mkp/scsi/c/29b75184f721

-- 
Martin K. Petersen	Oracle Linux Engineering

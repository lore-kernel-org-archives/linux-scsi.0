Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C82C1E7C34;
	Thu, 14 Nov 2024 02:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731552659; cv=none; b=pGSbzkeBB9kYJZ+nAKPcO6L2AFoJix5Nufx81agI2zvqoHHvIAkSNwze5I4Gw2ahIhmNTZY0IB5naC+B5KSoSq9D43916GJWsyDUe0LH0nFj3WdjprkuZTbSqRhDR1lsCnMOWxn+hi0nRiN2rTghBA+LAFmOKhLPvInv6GZCwMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731552659; c=relaxed/simple;
	bh=Sm3O18kCJAiCplIr9Q8PpkEP88HE6Xz86++Yxts+mN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ciphhk71b9ryo4LI41BWnud1LNl1OwcRcXFB9yrM8P9iGK52pp5RQT/FtbGJZwtQNHzeIPbNLj8wLVbkA3aKfreeHqaGR3YbUqlAbapsmnJ0Y1cCUOGv6gYHeS9aTgAaH8ZTKL86yvd/6qgIxXIaLeRmCCv0Go4zbG7GExDiwdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QqXSzxkG; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QqXSzxkG"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1gKZQ015862;
	Thu, 14 Nov 2024 02:50:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=I8/XvmSJebdDHMY2qR1K8kQYxbrHcB6kuMzONiFP+4I=; b=
	QqXSzxkGGbQNdsSnFE1tbUBfhfWrFKtr0DGM9OHPIsIYSXIk+qRpr61O1aVjbyn7
	FazkkwOISb6/iYWUh61Kyz0Ee43h2HY0fCVFrDoBwFiPch3y00Je8LKbZs5U0NWg
	WdN2ypjNoZvuj2SU/I0DsK/5cjKY3X68Fa4H5VUuJnS3kNJyx7POMyt3H6XnsfIS
	+1D1pr9f3+J0qpa1+Eyee55SdpK6QTxMW8GsXIP5w2aIrHkuDV1a2KZzlGBaXBKy
	A0q7PE9AGhFqs0crBlZsYNs5uTYDJOlj2BAg5iJo4s/V2Nu6bNKT5qbdNdXl5HaA
	RQaV3cZp5WOQpVaLOsP5jw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0k2873v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:50:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE13NV3022682;
	Thu, 14 Nov 2024 02:50:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42vuw0p20u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:50:53 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4AE2ojYu003527;
	Thu, 14 Nov 2024 02:50:52 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 42vuw0p1vg-7;
	Thu, 14 Nov 2024 02:50:52 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linuxdrivers@attotech.com, James.Bottomley@HansenPartnership.com,
        linux@treblig.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: esas2r: Remove unused esas2r_build_cli_req
Date: Wed, 13 Nov 2024 21:50:00 -0500
Message-ID: <173155154793.970810.11566993785670730823.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241102220336.80541-1-linux@treblig.org>
References: <20241102220336.80541-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-14_01,2024-11-13_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=719 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411140021
X-Proofpoint-ORIG-GUID: t0CnvMFEA0RyOWV3vz1L4CTrUCCs5_5e
X-Proofpoint-GUID: t0CnvMFEA0RyOWV3vz1L4CTrUCCs5_5e

On Sat, 02 Nov 2024 22:03:36 +0000, linux@treblig.org wrote:

> esas2r_build_cli_req() has been unused since it was added
> in 2013 by
> commit 26780d9e12ed ("[SCSI] esas2r: ATTO Technology ExpressSAS 6G SAS/SATA
> RAID Adapter Driver")
> 
> Remove it.
> 
> [...]

Applied to 6.13/scsi-queue, thanks!

[1/1] scsi: esas2r: Remove unused esas2r_build_cli_req
      https://git.kernel.org/mkp/scsi/c/2e8375df8649

-- 
Martin K. Petersen	Oracle Linux Engineering

Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B08276058;
	Tue, 26 Aug 2025 02:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756175653; cv=none; b=dJYedwffQoKiDvEm6kdqMCN2jsKhaaPLzFrXwoA7k1Cokx+hmUYujXOWkJAhEL4ejkU3Q1LsA0Gtjvay+/gVqwC0EhiBte4Oaj9pPtHFUtJclVxxqrOSMPJFm6kZKeltA/18gri7C3N75TJaEWj2w/GEQoc+2FMQe4FTZqi43Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756175653; c=relaxed/simple;
	bh=7bqzoo9uz0c++Yk+LmiBQRxdNpY6//K6bsy7Ob6RZaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MblzUPMpj6mlbunH964BPyonImH68Po5d5k2tSoxyfYoTWBFIro6/fb+KMJ6COBF5FOTyI0z9+eshYc7I2n1hKXYS7BdkaSoZAepbI1eJZm3jyn7WDS9uS7bm+ONlgQ6+KhGia2mk0QrOzEI0+bt6HyqRIZlRUDWS3lp3s5tZHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pl/RYWQP; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pl/RYWQP"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q2WFEP001937;
	Tue, 26 Aug 2025 02:34:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kgJjoWTU9YSPTeEYNe0qMYzga/t00pxXHMEwVeJ7fxo=; b=
	pl/RYWQPI3UGqJCxs4KRpmJpvTREgnFCYYEn+fkUOEKbQtKhfdrCCZ6MqJl45wY2
	O/GXa4l/+dZAwIMw3BHHQLfvo2KtFvqHzxHcmU0+47vOCUZ9pck15t3HOdM2o+gI
	mshE1QAIOB86/xymEsU0KD9Ytb/qYlloxlrgebuPVnsKynXE4FqCiS6CoGpkzld9
	uj9C7NxFs8tgeTibvEGbR9Y5bVpq/FlkdCBPtbfQWPih3YRYhdyIgILUbLY3I3+8
	+5+vstRPdjtAElexa1//qHVVBAYTeA7PRPh0e66X9t3mAr4VnlEpe5p5zIsNjFuK
	mtCgMtqrwucmccYIEAQ7jQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4jakefy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 02:34:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q1QuwC012230;
	Tue, 26 Aug 2025 02:34:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q438xc41-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 02:34:04 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57Q2Y2s4010861;
	Tue, 26 Aug 2025 02:34:03 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48q438xc0n-3;
	Tue, 26 Aug 2025 02:34:03 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Cryolitia PukNgae <cryolitia@uniontech.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        storagedev@microchip.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, wangyuli@uniontech.com,
        zhanjun@uniontech.com, guanwentao@uniontech.com
Subject: Re: [PATCH] scsi: hpsa: fix incorrect comment format
Date: Mon, 25 Aug 2025 22:33:55 -0400
Message-ID: <175613417227.1984137.3595488011495758582.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250806-scsi_typo-v1-1-ec353a303b31@uniontech.com>
References: <20250806-scsi_typo-v1-1-ec353a303b31@uniontech.com>
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
 definitions=2025-08-26_01,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=700 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508260021
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxOCBTYWx0ZWRfX2TK8/kTN54YD
 ptSZfB4dP7fC/fDyspVESZdhg7TWoGmb78qgGStlu4tdxEvmlxvLsZIEDRP1U55mRfl/vE+5yTs
 8Tub/lqQZirhOb/yMrkgwOoXHMJdyNcp2MwKp/8wDGYIij+GYGMlMOzfnyO41mCNHP6EEOvCcXL
 WkNXcVn1k2w86efKsFaTH6twQcRH72gQRSfAmYiotcI2NW4KOiPRLIOXVdRdWzEVrb8uKGZNixz
 VDwO1MbaUiOUubb1EJhRbqYO6lt+Uhne1BAi/nTRM8X22OhcU7vLRdgdEUHWlmoejDzAEhfFnAE
 HVi1G6zhX8306VTdS/AhKmRevzdupnzysylfbaq1ZK3vFhWaoyrjTJK7UrburQ79bm0cu5XDMX7
 NnIIz6g01bJ+uipxEAvfSS8kgD4+SQ==
X-Proofpoint-GUID: aEBrAAkTa_UC3oVv0ZusyV9BErsGQ3NW
X-Authority-Analysis: v=2.4 cv=IZWHWXqa c=1 sm=1 tr=0 ts=68ad1d1d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=bSXfQp6gECA6npzpU4cA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12070
X-Proofpoint-ORIG-GUID: aEBrAAkTa_UC3oVv0ZusyV9BErsGQ3NW

On Wed, 06 Aug 2025 11:13:16 +0800, Cryolitia PukNgae wrote:

> Comments should not have a leading plus sign.
> 
> 

Applied to 6.18/scsi-queue, thanks!

[1/1] scsi: hpsa: fix incorrect comment format
      https://git.kernel.org/mkp/scsi/c/e115d3d70ecc

-- 
Martin K. Petersen

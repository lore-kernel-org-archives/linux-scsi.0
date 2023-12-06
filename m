Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lXSiaKwa"
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E087F1AA
	for <linux-scsi@vger.kernel.org>; Tue,  5 Dec 2023 19:16:25 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B61xxeD006715;
	Wed, 6 Dec 2023 03:16:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=qZp1Q9e0HJh/N/Tp9vuRmCWzBy8SIjp2yhpB1BukQls=;
 b=lXSiaKwaWL/yAAvsDOTxFVTxFvbYDyYc1nWbZiepCJODCuFicB0Fjje35xuluR0Psa4O
 17XIew5w8MBihLItR2QEJB+3ZOF11f++T40i/8Ax7X84JBJbYoS2170OKO0zaDAeiFMW
 N4ElbXIjQ2hGMUZYqnhmFHuYPyzAj0Cj8r4AhZ9PZ9ZAjpFIR+cgILBZc4u8TQCqrv1n
 T3JvZKhhUqbyBZQJjDLtoaPsgVRkblocC8z64EidGny2XC13M+7usIqDJhUeIVc3USZB
 NbJai8x6DfhKtspmiIwtvkDY+a/K3E2h1FI5/UeKxi7blPuY1m2WyM+uUKRYXiMHxBXi 9Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3utd0mg8gc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Dec 2023 03:16:14 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3B62A0FL035367;
	Wed, 6 Dec 2023 03:16:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3utan9684m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Dec 2023 03:16:12 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B63GCYJ014062;
	Wed, 6 Dec 2023 03:16:12 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3utan9684d-1;
	Wed, 06 Dec 2023 03:16:12 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        jejb@linux.ibm.com
Subject: Re: [PATCH] scsi: ufs: core: make fault-injection dynamically configurable per HBA
Date: Tue,  5 Dec 2023 22:15:58 -0500
Message-ID: <170182644878.1446429.5040870287877114124.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231118124443.1007116-1-akinobu.mita@gmail.com>
References: <20231118124443.1007116-1-akinobu.mita@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-06_01,2023-12-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312060026
X-Proofpoint-GUID: H3eoAUdl9zEJY3GyWW0Hi0sB_Aa4kfYj
X-Proofpoint-ORIG-GUID: H3eoAUdl9zEJY3GyWW0Hi0sB_Aa4kfYj

On Sat, 18 Nov 2023 21:44:43 +0900, Akinobu Mita wrote:

> The UFS driver has two driver-specific fault injection mechanisms.
> (trigger_eh and timeout)
> Each fault injection configuration can only be specified by a module
> parameter and cannot be reconfigured without reloading the driver.
> Also, each configuration is common to all HBAs.
> 
> This change adds the following subdirectories for each UFS HBA when
> debugfs is enabled.
> 
> [...]

Applied to 6.8/scsi-queue, thanks!

[1/1] scsi: ufs: core: make fault-injection dynamically configurable per HBA
      https://git.kernel.org/mkp/scsi/c/045da3077bc5

-- 
Martin K. Petersen	Oracle Linux Engineering

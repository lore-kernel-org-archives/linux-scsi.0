Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UPvvHWex"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC77115;
	Wed, 13 Dec 2023 20:29:30 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE0S8PR014198;
	Thu, 14 Dec 2023 04:29:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=La3FDC+FVLuna1Gw6JvfBPdRwExheS89kmqvyKHvjG0=;
 b=UPvvHWexB06FS1Db3VnCmQXTXiwrPmOpHGVUyOa4YnxIFAjshAVvYdXGPF8G65yOMyAt
 Iav6Y/Mjot9KTmmvtV0sRCJgBKA4HV7siMkkoR+qJvMov/WaEoizaVAUFCwW3afPU6P6
 uH1QhK2GtJGRmuoC0kELrG4cdM6qUfU+TIpJBSqeAa+rto+BtJXY4eb09WYHKkwQ8GEa
 9i6TBMquW4wdOeBaLdI3+MJjobdiD2h/JHiFDPvyjUoI9xt8qIdH9oM0NquXBuQbB+ie
 uYv108tF9d/FAG4i3NEev5OtEqSipqsKRKVC5BY0en+8tR5KVvX0Z6flFvxQpigeHlaF mQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uwfrrr80k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 04:29:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE3iRAb009808;
	Thu, 14 Dec 2023 04:29:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uvep9ev1s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 04:29:27 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BE4TQM8035965;
	Thu, 14 Dec 2023 04:29:27 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3uvep9ev0g-3;
	Thu, 14 Dec 2023 04:29:27 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Benjamin Coddington <bcodding@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: enable READ CAPACITY for PR EARO
Date: Wed, 13 Dec 2023 23:29:08 -0500
Message-ID: <170205513087.1790765.1315741306487108744.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <ad095388dbc550c5b199a1dfa71bcbfc575a7abe.1701272679.git.bcodding@redhat.com>
References: <ad095388dbc550c5b199a1dfa71bcbfc575a7abe.1701272679.git.bcodding@redhat.com>
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
 definitions=2023-12-14_01,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=512 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312140024
X-Proofpoint-GUID: A1gBwpldf1KTv-qP9o-e16TyiqC_0Xy4
X-Proofpoint-ORIG-GUID: A1gBwpldf1KTv-qP9o-e16TyiqC_0Xy4

On Wed, 29 Nov 2023 11:13:54 -0500, Benjamin Coddington wrote:

> SBC-4, Table 13 allows READ CAPACITY for all PR types.
> 
> 

Applied to 6.8/scsi-queue, thanks!

[1/1] scsi: target: enable READ CAPACITY for PR EARO
      https://git.kernel.org/mkp/scsi/c/28c58f8a0947

-- 
Martin K. Petersen	Oracle Linux Engineering

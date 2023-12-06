Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QZmGGr+j"
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5591BC
	for <linux-scsi@vger.kernel.org>; Tue,  5 Dec 2023 19:16:27 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B61xA0c029543;
	Wed, 6 Dec 2023 03:16:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=CLpCj6Nn/N7Yog/QZem914m7T2h/9mIPxtFChFcp4Qs=;
 b=QZmGGr+jelZsgBfX694FOppezbCHh5VXg4fpWmBoOqszTaq2kwCYJKfmiKjhcTEVdOh9
 jdEHixFkUjJB+7AdT91yyjtl3ykIdhslevjwOuSuZ7nQ7utitfb14jcwM8ajVF64sxe1
 h9TeQVFUFcoZyIZicabhhiXRij7PmvD4wcvYEm6qobiqFvVAukgfPDmgvrRDgdjWL25i
 rXSXlV9aFpG1Yx9hwxWa1mEGbT4unehx+pyb9g9gPc55SGKxk/utPADS2SxnMx9O8IXC
 HbZ2BhiDeX6tFrkzWym/KUPo3IOWM19ItAdWQyIzWfLzU+7DTxYkqGxjdhtsKz0oWNKE KQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3utdda07ea-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Dec 2023 03:16:14 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3B62S2RR036605;
	Wed, 6 Dec 2023 03:16:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3utan9684s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Dec 2023 03:16:12 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B63GCYL014062;
	Wed, 6 Dec 2023 03:16:12 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3utan9684d-2;
	Wed, 06 Dec 2023 03:16:12 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: bfa: Use the proper data type for BLIST flags
Date: Tue,  5 Dec 2023 22:15:59 -0500
Message-ID: <170182644879.1446429.15530001044411628072.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115193338.2261972-1-bvanassche@acm.org>
References: <20231115193338.2261972-1-bvanassche@acm.org>
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
 mlxlogscore=445 suspectscore=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312060026
X-Proofpoint-GUID: x_9MO7pTLmxXYY5JRwzvZ1KTZJ5pM3Du
X-Proofpoint-ORIG-GUID: x_9MO7pTLmxXYY5JRwzvZ1KTZJ5pM3Du

On Wed, 15 Nov 2023 11:33:38 -0800, Bart Van Assche wrote:

> Fix the following sparse warning:
> 
> drivers/scsi/bfa/bfad_bsg.c:2553:50: sparse: sparse: incorrect type in initializer (different base types)
> 
> 

Applied to 6.8/scsi-queue, thanks!

[1/1] scsi: bfa: Use the proper data type for BLIST flags
      https://git.kernel.org/mkp/scsi/c/0349be31e4ff

-- 
Martin K. Petersen	Oracle Linux Engineering

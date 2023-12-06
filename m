Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Co1DVdD8"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F3AC6;
	Tue,  5 Dec 2023 19:26:01 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B61xYpg017584;
	Wed, 6 Dec 2023 03:15:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=faQsfCR32SmynHzxms7TMiEndrZGrhEhdsB18uSNh3s=;
 b=Co1DVdD8Cs29G4m+RqMH4P9ZsEorgYHC0z1Uad7nlkK9ogNovIDwq3X/Kf6rJIrg5gkF
 lb1fmHUkiKQ5sGLX6mD93J1PB2XIG04MzifsXHuUV0if1vGE36vvr0qzZgi8SyfX8Umw
 m6mON2snqkkPOx6mQs+CDKQm6z4A0Gnb0Kkt9V+Ze1j15jaFUAmw0ps6W+ArK4OzWn82
 TzZtNia1faeY2WyIzslhA9qCQwzH4Lm90XNYXBip1abeHGAVwVfqTbxvladOi5sEcm0R
 oUvTOSzWVB2VLT7c0iddoc5uaXxfb1QL0w9ihTX0O5cdwgHaWc8b4xorefaUy0a+AHZl OQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3utdmbg6tt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Dec 2023 03:15:42 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3B62So2G039465;
	Wed, 6 Dec 2023 03:15:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3utan56ayw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Dec 2023 03:15:41 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B63FeNO029625;
	Wed, 6 Dec 2023 03:15:41 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3utan56axn-1;
	Wed, 06 Dec 2023 03:15:40 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        John Soni Jose <sony.john-n@emulex.com>,
        Jayamohan Kallickal <jayamohank@gmail.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: be2iscsi: fix a memleak in beiscsi_init_wrb_handle
Date: Tue,  5 Dec 2023 22:15:33 -0500
Message-ID: <170183237805.1755281.6903745084335290167.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231123081941.24854-1-dinghao.liu@zju.edu.cn>
References: <20231123081941.24854-1-dinghao.liu@zju.edu.cn>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 bulkscore=0 mlxlogscore=556
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312060026
X-Proofpoint-ORIG-GUID: xFgCyMNec_q89i1gb7heEGh5MP2DBYDe
X-Proofpoint-GUID: xFgCyMNec_q89i1gb7heEGh5MP2DBYDe

On Thu, 23 Nov 2023 16:19:41 +0800, Dinghao Liu wrote:

> When an error occurs in the for loop of beiscsi_init_wrb_handle(),
> we should free phwi_ctxt->be_wrbq before returning an error code
> to prevent potential memleak.
> 
> 

Applied to 6.7/scsi-fixes, thanks!

[1/1] scsi: be2iscsi: fix a memleak in beiscsi_init_wrb_handle
      https://git.kernel.org/mkp/scsi/c/235f2b548d7f

-- 
Martin K. Petersen	Oracle Linux Engineering

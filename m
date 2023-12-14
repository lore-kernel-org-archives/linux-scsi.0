Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SYu4gdI1"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A731C121;
	Wed, 13 Dec 2023 20:29:35 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE0S5XO004531;
	Thu, 14 Dec 2023 04:29:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=qLo4F9bKbXaifxLi8iqNoDBZ23Xqd57qPgu1xnIoFao=;
 b=SYu4gdI1DkZ7jRlbX6SVsyrHjavmO5ybf4eGhOU6gTszOeTgKC34ggM75lobVWyleXyG
 Va1rBq5O5sN34k5qs2pRDYzq4zDv16UysOkzPS7Us4tE6bYuZUca6bft2fXew9a6O91p
 pzWq7331etHoLBR7L630jS3OIgWV98p6yzRZzjLaIAOqx4laOOoPIje4ThBBOnWquneP
 hkf960bACbKdrlH/ZTguiR4tPF9PPNuL/w6T6W21FLciH7Q+bt53Nrbvm4KyBZtS2LnH
 dGiGYdTlVeD8sq+Pk7+8xBK2RBVJcgfDxgnTfufFWu6mnswO6VdeNYLnEOhok6ztphdx ww== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uvg9d9x67-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 04:29:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE4OpQr010147;
	Thu, 14 Dec 2023 04:29:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uvep9ev1c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 04:29:27 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BE4TQM6035965;
	Thu, 14 Dec 2023 04:29:26 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3uvep9ev0g-2;
	Thu, 14 Dec 2023 04:29:26 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Artem Chernyshev <artem.chernyshev@red-soft.ru>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] scsi: isci: Remove redundant check in isci_task_request_build()
Date: Wed, 13 Dec 2023 23:29:07 -0500
Message-ID: <170205513100.1790765.12899400140723714931.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231128121159.2373975-1-artem.chernyshev@red-soft.ru>
References: <20231128121159.2373975-1-artem.chernyshev@red-soft.ru>
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
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=694 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312140024
X-Proofpoint-GUID: utGaaMgoq3zbU9IOdwtezrU9gMvlvGYS
X-Proofpoint-ORIG-GUID: utGaaMgoq3zbU9IOdwtezrU9gMvlvGYS

On Tue, 28 Nov 2023 15:11:59 +0300, Artem Chernyshev wrote:

>  sci_task_request_construct_ssp() have invariant return. Change
>  this function to void and get rid of unnecessary checks.
> 
>  Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> 

Applied to 6.8/scsi-queue, thanks!

[1/1] scsi: isci: Remove redundant check in isci_task_request_build()
      https://git.kernel.org/mkp/scsi/c/25cba909ade2

-- 
Martin K. Petersen	Oracle Linux Engineering

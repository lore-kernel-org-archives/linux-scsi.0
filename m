Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XpzH+r8P"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9A7120
	for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2023 20:29:30 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE0S6XB015214;
	Thu, 14 Dec 2023 04:29:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=INgbnCodzyNnFra7u5+L3I3vKQxlW+4wUWS6OKZ2PjI=;
 b=XpzH+r8Planym0g3ZaUvlk7VIdfJ1gMUYEfpPw3UB3NIfKRlETugOd0v941GFtedi55o
 EIJ1WA8AfD2XxxeJMyljy14Pt76VTnfEvg0vKcEAK3jDnybM+zawcU/p1AYCRXVRmwsg
 QV8hdO7DBoviXEUgk1VCG0o28nhaQdeWHBEn+5M0gOoatkVF//W1wvlM1QQTwZmAaJ82
 zjr5Y2QIBxraMXXI12R3XbEc15nNMQD0/NlpYugrzFlhFANVcHOpxfHDbbsqE6RwYl4E
 gppRNLduTZSQJ+EDfCr2IyUiZQuL/9ACorPusQdhQdABA/bgeK5iopiRQ8sffdQ9zM5w jg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uwgn3r25e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 04:29:29 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE3OdLF009843;
	Thu, 14 Dec 2023 04:29:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uvep9ev2g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 04:29:28 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BE4TQMC035965;
	Thu, 14 Dec 2023 04:29:28 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3uvep9ev0g-5;
	Thu, 14 Dec 2023 04:29:27 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, sumit.saxena@broadcom.com,
        sathya.prakash@broadcom.com, ranjan.kumar@broadcom.com,
        prayas.patel@broadcom.com,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/4] Support for preallocation of SGL BSG data buffers
Date: Wed, 13 Dec 2023 23:29:10 -0500
Message-ID: <170205513110.1790765.3232347303851232446.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231205191630.12201-1-chandrakanth.patil@broadcom.com>
References: <20231205191630.12201-1-chandrakanth.patil@broadcom.com>
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
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=762 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312140024
X-Proofpoint-ORIG-GUID: cgIHgTQnZ9aIqz86Td_cM8m4n-wHcOu8
X-Proofpoint-GUID: cgIHgTQnZ9aIqz86Td_cM8m4n-wHcOu8

On Wed, 06 Dec 2023 00:46:26 +0530, Chandrakanth patil wrote:

> This set of patches includes a new feature and version update.
> 
> The initial three patches are related to "Support for preallocation of SGL
> BSG data buffers" and patches are interdependent. The fourth patch updates
> the driver version.
> 
> Chandrakanth patil (4):
>   mpi3mr: Support for preallocation of SGL BSG data buffers part-1
>   mpi3mr: Support for preallocation of SGL BSG data buffers part-2
>   mpi3mr: Support for preallocation of SGL BSG data buffers part-3
>   mpi3mr: Update driver version to 8.5.1.0.0
> 
> [...]

Applied to 6.8/scsi-queue, thanks!

[1/4] mpi3mr: Support for preallocation of SGL BSG data buffers part-1
      https://git.kernel.org/mkp/scsi/c/c432e1675239
[2/4] mpi3mr: Support for preallocation of SGL BSG data buffers part-2
      https://git.kernel.org/mkp/scsi/c/fb231d7deffb
[3/4] mpi3mr: Support for preallocation of SGL BSG data buffers part-3
      https://git.kernel.org/mkp/scsi/c/9536af615dc9
[4/4] mpi3mr: Update driver version to 8.5.1.0.0
      https://git.kernel.org/mkp/scsi/c/d0a60e3edaa4

-- 
Martin K. Petersen	Oracle Linux Engineering

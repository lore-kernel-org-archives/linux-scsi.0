Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134BC8F4D
	for <linux-scsi@vger.kernel.org>; Tue, 19 Dec 2023 02:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S5R0vdpw"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJ0J00g017103;
	Tue, 19 Dec 2023 02:19:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=AR3c1uDJ/PxnZqncYngCAyjxGAryWXtDJWQKaKs54FU=;
 b=S5R0vdpwP3y3Pp+z9jlB6u5sLAUo0QmbPMMUj7qdsy9mDBSrVLSvljKAZtRq/c1oXW2L
 9Dgtp4ejoXeJPkQ2ANTCHgZ5RiAXC8kTADlMQiI92BqfDNrL82a0ozS96RNQ6hqUz33K
 Muu+MdRhttxgaykEsMbXVtSG6b1ljcIcMUELCUUw8tRcPgWDw4hpVdVSM8SmXsGI5roH
 4oin1NoPXF1N+PCeqsTpAPZZEMZjbmAgoPxi+sLCv98V/B28oSHFXMmTWxIiHZOMrl2e
 OqQsC+V4/jWrtLnVIttG8DpHbk17Joei3qWiY0GELWV8TpFpOsN4dVPg+9r4YPb13uzF Fw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3v13guctee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Dec 2023 02:19:11 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJ01t9G021009;
	Tue, 19 Dec 2023 02:19:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3v12b69t6f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Dec 2023 02:19:10 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BJ2J7Z7012682;
	Tue, 19 Dec 2023 02:19:09 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3v12b69t3t-3;
	Tue, 19 Dec 2023 02:19:09 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: jejb@linux.ibm.com, chenxiang <chenxiang66@hisilicon.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linuxarm@huawei.com,
        linux-scsi@vger.kernel.org
Subject: Re: [RESEND PATCH 0/5] scsi: hisi_sas: Minor fixes and cleanups
Date: Mon, 18 Dec 2023 21:18:47 -0500
Message-ID: <170294822184.2675590.505018493872530260.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <1702525516-51258-1-git-send-email-chenxiang66@hisilicon.com>
References: <1702525516-51258-1-git-send-email-chenxiang66@hisilicon.com>
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
 definitions=2023-12-18_15,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=832 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312190017
X-Proofpoint-ORIG-GUID: x8PfP1lKO9w_yIstOzp1X8vmI_P_DM0Q
X-Proofpoint-GUID: x8PfP1lKO9w_yIstOzp1X8vmI_P_DM0Q

On Thu, 14 Dec 2023 11:45:11 +0800, chenxiang wrote:

> This series contain some fixes and cleanups including:
> - Set .phy_attached before notifying phyup event HISI_PHYEE_PHY_UP_PM;
> - Use standard error code instead of hardcode;
> - Check before using pointer variable;
> - Rollback some operations if FLR failed;
> - Correct the number of global debugfs registers;
> 
> [...]

Applied to 6.8/scsi-queue, thanks!

[1/5] scsi: hisi_sas: Set .phy_attached before notifing phyup event HISI_PHYE_PHY_UP_PM
      https://git.kernel.org/mkp/scsi/c/ce26497c745d
[2/5] scsi: hisi_sas: Replace with standard error code return value
      https://git.kernel.org/mkp/scsi/c/d34ee535705e
[3/5] scsi: hisi_sas: Check before using pointer variables
      https://git.kernel.org/mkp/scsi/c/8dd10296be85
[4/5] scsi: hisi_sas: Rollback some operations if FLR failed
      https://git.kernel.org/mkp/scsi/c/7ea3e7763c50
[5/5] scsi: hisi_sas: Correct the number of global debugfs registers
      https://git.kernel.org/mkp/scsi/c/73e33f969ef0

-- 
Martin K. Petersen	Oracle Linux Engineering

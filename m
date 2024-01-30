Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77636376F2
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 02:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706581882; cv=none; b=Peyth9pQQw7CLJ03k3DT3mBMdjjmjrgzTrCRZztI5xm7tP376A4Jt38ULyamiGaKkmuKaBUJSXKo6Vc0XJs0PrdHbdy8qV/QGDgoS+z7qx1NtWGG5S6tBbbh7UN6lWK2vT2tN/dc/k8xF7BBblpFKWTqhgZRrf5SnrVMGd4Qtwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706581882; c=relaxed/simple;
	bh=LOE35My5y6VoogfKxp/b8vuQ2oAMOPrNOqd7/mJNpew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kgLi4AWzvu6qXCkHBUqx33xi8zvFLPQ47HZkp0l437Gk/ykJgl59118/Q5GmPDqPSlkw0lOm7il0UWz7dkr8blgeGIFAtz/FqcociBKdO/oEeg9Q9ul/ctV/tzR1UjjRAm7rnu3eQL9aNYIBpNCJBqxTgfIuEwtzon3yyZ7YMxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ueq5FAC8; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ueq5FAC8"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40TJidvD030870;
	Tue, 30 Jan 2024 02:27:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=MnxB/1JpnE07mK7KrT82Rv+Vrde3dBoswy5F4UjH020=;
 b=Ueq5FAC8NKz247obRDuWueKXxPSqiggvk7Uc6owFEvJJ0Q61+NXPeCUiPVFmwGOEWysi
 hVBa2g2apfV2Wh1iIHIURvBP2uIsppgH3ZqOH8Z6yr0I+Tj+v5QpDGkv6IgeYrv1ZxuF
 o3Y+FrNUAZ0MOe9rePAynf1OoeMoHm+R6O02ofdg8OOBXcRfv25teR3UgsvvBqtE20Ik
 4QXbwgOr6vlLtxk+oWtzzzTxtVqEU/u0XFQKmDMAW73L8L8Pp4veKbR1im7nGhQCaQat
 nlGTlgPv/gPXdVe9DsbinrPoHuUuF+J08Rlevpegy8tN/ECpb9HLrM89KSSbqMysO+ET Wg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvrrcdjrj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Jan 2024 02:27:40 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40U1XwGg014604;
	Tue, 30 Jan 2024 02:27:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr96g530-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Jan 2024 02:27:39 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40U2RPxw040916;
	Tue, 30 Jan 2024 02:27:39 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3vvr96g4y7-10;
	Tue, 30 Jan 2024 02:27:39 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, avri.altman@wdc.com, alim.akhtar@samsung.com,
        jejb@linux.ibm.com, peter.wang@mediatek.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
        eddie.huang@mediatek.com, naomi.chu@mediatek.com,
        chu.stanley@gmail.com
Subject: Re: [PATCH v1 0/2] scsi: allow host change auto suspend timer
Date: Mon, 29 Jan 2024 21:27:06 -0500
Message-ID: <170657812663.784857.12611066657183542555.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20240109124015.31359-1-peter.wang@mediatek.com>
References: <20240109124015.31359-1-peter.wang@mediatek.com>
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
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=961 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401300015
X-Proofpoint-ORIG-GUID: bdDsH0aN5LS1W9Yg2a8SiJji-r_S0rvv
X-Proofpoint-GUID: bdDsH0aN5LS1W9Yg2a8SiJji-r_S0rvv

On Tue, 09 Jan 2024 20:40:13 +0800, peter.wang@mediatek.com wrote:

> This patch allow MediaTek platform driver change auto suspend timer.
> 
> Peter Wang (2):
>   scsi: core: move auto suspend timer to Scsi_Host
>   ufs: host: mediatek: change default auto suspend timer
> 
> drivers/scsi/sd.c               | 2 +-
>  drivers/ufs/core/ufshcd.c       | 9 +++++++--
>  drivers/ufs/host/ufs-mediatek.c | 4 ++++
>  drivers/ufs/host/ufs-mediatek.h | 3 +++
>  include/scsi/scsi_host.h        | 6 +++---
>  5 files changed, 18 insertions(+), 6 deletions(-)
> 
> [...]

Applied to 6.9/scsi-queue, thanks!

[1/2] scsi: core: move auto suspend timer to Scsi_Host
      https://git.kernel.org/mkp/scsi/c/4380e64a94e1
[2/2] ufs: host: mediatek: change default auto suspend timer
      https://git.kernel.org/mkp/scsi/c/332973850054

-- 
Martin K. Petersen	Oracle Linux Engineering

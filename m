Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DC1170826;
	Sat, 17 May 2025 19:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747509870; cv=none; b=pR2CtSWZudgxCNl7HIBvxtJ/XslGM4rTmnlMaFW/lNxQFJPCUNN1Xdo6FsrQLI/SHl4qtNjh0kQToeBo6setpACbCRZ7cOX/V7kcS69gWh/d4UQO+BRmqiAN8e32qLXqiORbC4AP3qV5bf8Iq+xUCcNPY44V4QyKnCMBjlCEx6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747509870; c=relaxed/simple;
	bh=ppe0iizIww3veT1AyxmEFcfYQ5htktshyLO8xyPT5sY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fzk8lK4GwcMxyNjhlxP7YQI1RKpusxIwgIKZcCgWnKEJFDvFVULsvLEfJcMOmqmwGZ6m3B1w6JHhN79vRx/HhY4bquzdvtHKRcdkExkRcS5l7xMY0VOINMAzXbd14t91+Xk0aw0H1NNYEAUjh9GJ13BfiaeUK/Upzwt2824abOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IVpub/yr; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IVpub/yr"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54H1i0HJ009182;
	Sat, 17 May 2025 19:24:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=CqDeGvkugP/Widj2LVbUK3kpkBICk
	P9RdZUz0rTOzkA=; b=IVpub/yr80VbLQowMJmf0Mvl2AK9qCXGnFDyh4sZ6EnTW
	Ox13jbdS7cZQTkT9SW0Qr/xLWJnYB79+QDcPsPAyfl07oGJGj+mFeMlhk+qvcmm7
	ujv0ZHkwoF9Vd/nhAUSfXvzRH0XQQYHwpxYJjN/kibrRe+cQPHsDLZbYG5da3PMG
	m72nzhzOEiH8IhPx0RJtc0m5GQOMVMSFI9hinjp06KJ1UBUcQuCAqGR76LMMrgAh
	zxlPeH9ysyQE03X1orZxUwZZIjjCk5QXSDQcnAEhAMYxtEB1zdjUaDIu0B8faLDD
	lmtXLNGSl1kZQwCWeA6WhNtSoERSN7IhNGV/Wh+jQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46ph238jta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 May 2025 19:24:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54HJ7V6N029063;
	Sat, 17 May 2025 19:24:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46pgw55she-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 May 2025 19:24:25 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 54HJOPAh023681;
	Sat, 17 May 2025 19:24:25 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 46pgw55sh9-1;
	Sat, 17 May 2025 19:24:25 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc: alok.a.tiwari@oracle.com, linux-kernel@vger.kernel.org,
        darren.kenny@oracle.com
Subject: [PATCH] scsi: mvsas: fix typos in SAS/SATA VSP register comments
Date: Sat, 17 May 2025 12:24:10 -0700
Message-ID: <20250517192422.310489-1-alok.a.tiwari@oracle.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-17_09,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=996 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505170192
X-Authority-Analysis: v=2.4 cv=GN4IEvNK c=1 sm=1 tr=0 ts=6828e26a cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=dt9VzEwgFbYA:10 a=yPCof4ZbAAAA:8 a=PKyxXqJ4jqzQODs3vaIA:9
X-Proofpoint-ORIG-GUID: 659OlvL-UoIvZPbVd_i3U566ZLZjiMeS
X-Proofpoint-GUID: 659OlvL-UoIvZPbVd_i3U566ZLZjiMeS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE3MDE5MiBTYWx0ZWRfX5L9wsgB55Ae2 8qmWpqlRoUWCNYV6cKlTq7e/mi89ZdHjWjMwYswGpgu+A2Px4c+ecwXg+wO8/WsRgekYesYY96G z7mxY7AvHV1HLitw1tZLYD/9a0b+ABna3BFrpREwNV932LQ44IVJC+a+dtya92JMzVzdSehzrgm
 J9B4KXbNRyzWjPFIAe3jR8I62R6GyI7i0F944aFZ27XB+jex+YEU9B26DKKNgx81gO1RVkMlbUe 2aglCJ1Cw918KsrzqlxfxmbkPPehEQy0FDLVp76slE6eSf1qTmhevZQd1PrbM0RgiZmviwh323b 4kzx9ab/NoII5qyVjJuLCFiZUIXy32UnK07Ebo3w5qk8yL9gh9DsiBzOLlhLpBfMb5x95pYcVXx
 igW4CIlYrB5/U+UlHaIG4OEEc9ASOZdB6Z74hIrmGLcTRj6o1rRaEpnwCyMwjfOgGiwGSxP0

Correct spelling mistakes of the SAS/SATA Vendor Specific Port Registers.
Fixed "Vednor" to "Vendor" in VSR_PHY_VS0 and VSR_PHY_VS1 comments.
This is a non-functional change aimed at improving code clarity.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
---
 drivers/scsi/mvsas/mv_64xx.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_64xx.h b/drivers/scsi/mvsas/mv_64xx.h
index c25a5dfe7889..749f616b21af 100644
--- a/drivers/scsi/mvsas/mv_64xx.h
+++ b/drivers/scsi/mvsas/mv_64xx.h
@@ -101,8 +101,8 @@ enum sas_sata_vsp_regs {
 	VSR_PHY_MODE9		= 0x09, /* Test */
 	VSR_PHY_MODE10		= 0x0A, /* Power */
 	VSR_PHY_MODE11		= 0x0B, /* Phy Mode */
-	VSR_PHY_VS0		= 0x0C, /* Vednor Specific 0 */
-	VSR_PHY_VS1		= 0x0D, /* Vednor Specific 1 */
+	VSR_PHY_VS0		= 0x0C, /* Vendor Specific 0 */
+	VSR_PHY_VS1		= 0x0D, /* Vendor Specific 1 */
 };
 
 enum chip_register_bits {
-- 
2.47.1


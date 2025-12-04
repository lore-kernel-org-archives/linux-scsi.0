Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE5D2D7DEC
	for <linux-scsi@vger.kernel.org>; Thu,  4 Dec 2025 15:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764861517; cv=none; b=HUkqd6mvQF9jRnztBdDDDUqJJRziUXcP1m2lAL/Bq1bSISXQaaTLczJSSwYZ4NuwoOdiUijOrgdr3B4KISWMs5TXc5/+xLSTKuJNOH109C4PrJtIg3j38cCWc4ytGvSQDEohTcca/mOqQcoIZNi7UWkMxT1sPLKI4ElOV/BxpeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764861517; c=relaxed/simple;
	bh=lW7mw0IysPtOlhwi/J+QQlmlrbaNNqz0M38EhU5XJ7w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VveJd8oQ9lwkpjsYOPVFeiooqZjbKipUFN4lCFspaf380UC1mNJm9du42wQ11LC5kRje6nuQXRngu1l7lWX2x2gVD8ZiiGAvCURLxVi31pg97yjpc9JUjdP0z6o1CMmdxtdQj6h447jlGnh+ko81Vlcvz99xmFiQQrY+oNdoL1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Cxzy4kDN; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Cxzy4kDN"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B4ERnS81545674;
	Thu, 4 Dec 2025 07:18:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=A
	nSpYzKwP7THpcRijjVZlit/T4Zr7gOuClPlzNzHOQs=; b=Cxzy4kDNL9CsxVYjR
	D5A51jZ1RxdabgjIMHudJlsF2wWwKB0Ey+xkTOFCc19TCFFHUU4NdfpqqdgtsWnR
	rYZupWZeOjx0xEOHcGPsr6x0k5TDSzKgEqlsff6+lVhVcpShIOXNMChjTKSU2MQO
	QJBBca/aWh3tWlrBJDsVVLAKuSShY95m/YBaA2ozNjP1dmXsrRkJMxNNRHhlxkcy
	dyz4XXQMuss6OdJ5CJeyCqajxKCs8ptc8kvGnei/FSyApQpCciE2RDxIE416C3LV
	K1M/efZCRecCfgacFFMjSrQqRxgD53G38MEfZPj83KkVlKW2X/CRySd/+Gp9WEXH
	/oTFQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4auc2ur4cy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Dec 2025 07:18:30 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 4 Dec 2025 07:18:42 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 4 Dec 2025 07:18:42 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B70FB3F7074;
	Thu,  4 Dec 2025 07:18:27 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 12/12] qla2xxx: Update version to 10.02.10.100-k
Date: Thu, 4 Dec 2025 20:47:51 +0530
Message-ID: <20251204151751.2321801-13-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20251204151751.2321801-1-njavali@marvell.com>
References: <20251204151751.2321801-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=A4Fh/qWG c=1 sm=1 tr=0 ts=6931a646 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8 a=pGLkceISAAAA:8
 a=HJKeYLzhmGgdqKWla5EA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: URiU1tjQHJv6Y6Y3Ou1vEpv8FAiTBcL6
X-Proofpoint-ORIG-GUID: URiU1tjQHJv6Y6Y3Ou1vEpv8FAiTBcL6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA0MDEyNCBTYWx0ZWRfX0r1zbpP5LA0C
 bYXX0c+U53N0+5ANeCOjc8xkcZulbeEojGjlkpmqBfxsBwBoivocB3kTETlMB5aKaCGLwqKfGPD
 BZW2fWSsXWoGWJnav6UVQLWkQwWMe/1RsfGxfFlUmW6uTU2/3D/oR2xgmrcCqikBc3UQakrFz7m
 MQPmR6sGfq9zsKijIM+AjO8mfMXGWcDNpRc/bat6t2JV0Gz57RNZOKz6PGfXRT2jMCsthzYdlky
 +VW1R85NS0jhftqlmcNjwR4VHhVHxV+qydzNpRTDWUpg48ADuorV2r7ksx9di1t2GDstOoX9N2E
 /dBtf/UQIDlU48IFZCWPA5udkvcQ2v+vDIcytQ08G0k9obfh2x4nOaDJgF+8tmK8AIINkL1dkWQ
 8pnT86jhtPSDSMRdrLdY65KUy17FgA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-04_03,2025-12-04_01,2025-10-01_01

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index a491d6ee5c94..9564beafdab7 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.09.400-k"
+#define QLA2XXX_VERSION      "10.02.10.100-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
-#define QLA_DRIVER_MINOR_VER	2
-#define QLA_DRIVER_PATCH_VER	9
-#define QLA_DRIVER_BETA_VER	400
+#define QLA_DRIVER_MINOR_VER	02
+#define QLA_DRIVER_PATCH_VER	10
+#define QLA_DRIVER_BETA_VER	100
-- 
2.23.1


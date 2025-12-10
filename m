Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E210313556
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 10:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765361814; cv=none; b=rX6d8eimO4NJ/pf/WlJdgru2SEZVmGjYzxDYY1N3XqG7Hm/IQUkAmOsHXnfy6XVwXWrnvqaEzNWTq+SqWHKjN17Y+RpuQjKZBTk+WT6qUtxrOVxsd+gYm3wro5mDuCHs7spKqRdwFhDhUwFaGFJB1jClSRutPv8CCpNxLoPzTHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765361814; c=relaxed/simple;
	bh=lW7mw0IysPtOlhwi/J+QQlmlrbaNNqz0M38EhU5XJ7w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qnjAs/SpNuprKdJENtZ2TDy7KLiqKUgNjjp2qNkOODZ8bW7JJWv2QyUEbq3s+KLd0remtEu1dWgDUl6lKXtbjH+lT5zOvELyuhAuKZsRZ/oDBtH1ATZ5YskhdVtvBBxZViXLsuQP6xlMGdCiMYFj17rptM3iy4gxQ50OmGak5Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=dcKvJCYz; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="dcKvJCYz"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BA4aL6T3329366;
	Wed, 10 Dec 2025 02:16:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=A
	nSpYzKwP7THpcRijjVZlit/T4Zr7gOuClPlzNzHOQs=; b=dcKvJCYz9Qe72lIZi
	hJkYwf+0zKQmF4Tz89gCWPKlMQaOMRXY1e1tixirx4oyCQvdsr7S8IJ6MXu+8yJy
	P4ivuJJC56mjc26OvLYxIUkBZtzPqo4akpgV7WeXrUA/9Q8kXeDfqS8/czMCzuEA
	97f9V5bIWTlVuDF1BVLEGCwt9XGcQPorLjr1AR9uLEtILcu62BOpr3t+9+dsU2cL
	RcoLuobnDoCN6qnj/rIupvRE6Q8CEvP6gGpCD/uZvlIYCD5Z9V7jCDSWEp/AU5VU
	8cT0Z4OsTTNmv0cIB5mphliZE6g9A+qF/HFZQazct6aC2vEHCM7GaoA7q0gROIBd
	A5uTw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4axuknhj1r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Dec 2025 02:16:50 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 10 Dec 2025 02:17:03 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 10 Dec 2025 02:17:03 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id DA5E73F709D;
	Wed, 10 Dec 2025 02:16:47 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v3 12/12] qla2xxx: Update version to 10.02.10.100-k
Date: Wed, 10 Dec 2025 15:46:04 +0530
Message-ID: <20251210101604.431868-13-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20251210101604.431868-1-njavali@marvell.com>
References: <20251210101604.431868-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: i6pEQUfxlYztvEIUaMOQjeolTMrseVV2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDA4NSBTYWx0ZWRfX2E7pKxLDZ0CA
 7Vq7Wwty6SsMpKw9fK8KtOwQ8fYuOQRuFWyqXdfLhOtJ5PthycMmnSLJvAfyPIemwOaUsYOZCEs
 5fkCjoDrh3CS5uGqaZF/tjqF6+g9icyrc41M2iENE8EZf4sLuOaRWattejrvRMwaz8wmaHAqWsb
 oLORGTmQwLS4nQCe+7eWennRdvm6QNBvFnR2MLEQVbYtIvZSd82mZWfxaHplS3eRHnWLx1bASWm
 2HBrNFsfx963adeZSh4n5vNogfOynJCdAMMPMtB65jWi0oyFc58/ImhGMUgdyoBV0A63gk44kXf
 pHMqbrpAQrLa3XF4dDhuOyCSVp+9R3khhVl5VIZD6bHqStzA9o3mlIZybNMB/RD0Fo4rMm+E+AL
 5MOFocwy/qa9rEUQuHKmgbQjQGTBIQ==
X-Proofpoint-ORIG-GUID: i6pEQUfxlYztvEIUaMOQjeolTMrseVV2
X-Authority-Analysis: v=2.4 cv=P483RyAu c=1 sm=1 tr=0 ts=69394893 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8 a=pGLkceISAAAA:8
 a=HJKeYLzhmGgdqKWla5EA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-09_05,2025-12-09_03,2025-10-01_01

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


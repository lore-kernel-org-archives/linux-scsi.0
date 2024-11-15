Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70191BBBEB
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 13:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731675834; cv=none; b=ovK2iS2L6er7/0nLvw24ZP+bDQXYkm+ty+x6OQTqPu13FIOXDmGonOvwD1e9soK0URYmWaETQq8WFNpF1oM3oVgL4oaCOGbG7J7tdy9C3pB4JjstD1MfVczSUHfhQJEjfMsQ6rTcD+BWYEyTLYsobt07eF1EWt0fGKBgdtB30q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731675834; c=relaxed/simple;
	bh=aEF8N5pGPeym4vSjg99iLtc50iUOBqACsqlnMg7nlec=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sP/0HNQEIXijMLgkF0ozyFUwTimK90NPzolHQkh4C1szdStqrIsu8mAoKgASyYW6hYTwXvZZBKYbpwkvmXtc6gmEMsX1sNwxY4ahfp44cLM3Phk2GOsAIqVq29PGCbwwZtePqR33qsZ2113dCo8x6m2bS13hNCvXHkPWeLANedI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=N9+1P+uW; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="N9+1P+uW"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFCdUUj024754;
	Fri, 15 Nov 2024 05:03:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=+
	NLDBdwQJwTh6xLU4U5EtMhWjQMpfksd05AaqQCVo9c=; b=N9+1P+uW+EJuNZOAx
	CihoHtLyqvYYiuj8Wcs5pibzBbTyACMrt9TlD1aKy8u972Ogk0glkr1Pyi9hYVEo
	DHQLhF/obsROBj7202Ee6lJtCagLpIbvul7BAmELpgFJNl3HTWuHop176Xn6eUGW
	bdlIPFvMIGgnA4yuWhMw7gik8tZ1axecUMcfuGf4mBHa6DsYxn0r5yQsiI4pYyFA
	APUfGvrcwQc33gipC1U27VXlMBois5IAtLNqMwmrEerQkQEpSjaP1kTux9eiiGqH
	6QIDQje+ZaagQmg77By1dCNWNz6Ar4yZkPb9vpWypsY/kvT/DBQfnK4y8c+8g4v6
	wJoiw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 42x1jk8f3r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 05:03:49 -0800 (PST)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 15 Nov 2024 05:03:48 -0800
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 15 Nov 2024 05:03:48 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 4CD123F7075;
	Fri, 15 Nov 2024 05:03:46 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 7/7] qla2xxx: Update version to 10.02.09.400-k
Date: Fri, 15 Nov 2024 18:33:13 +0530
Message-ID: <20241115130313.46826-8-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20241115130313.46826-1-njavali@marvell.com>
References: <20241115130313.46826-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: KbWYcvda7GZZRm110oa0J2RZam-o4Zal
X-Proofpoint-ORIG-GUID: KbWYcvda7GZZRm110oa0J2RZam-o4Zal
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index cf0f9d9db645..a491d6ee5c94 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.09.300-k"
+#define QLA2XXX_VERSION      "10.02.09.400-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
 #define QLA_DRIVER_PATCH_VER	9
-#define QLA_DRIVER_BETA_VER	300
+#define QLA_DRIVER_BETA_VER	400
-- 
2.23.1


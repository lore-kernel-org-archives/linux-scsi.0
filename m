Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35361849FE
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 13:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718717911; cv=none; b=YHJAFoqGnyR8fQ1rjGk0cK2dBRtS39NORWwLYtPDTTdrg238WTwK8L4/jXPxTxUF8HHidxRFpGe0QF5T2VQ0dc84BH2s9mRp9T9+qGHcaICayZFYrh251TXNzTg6d2uXy5vsMCeS32kTjDn0AnHeuH2/7Py6CowZZIWszHZqR60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718717911; c=relaxed/simple;
	bh=wHJsj8vkaJmkM6If4eTmx9bUqiUEXn5vIu1fpQlTk+I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GKh9bFpMXgtcfsc56btGvKUsJFwqHj5Tu9ytA21yVRGfLZ2haWBBd1WgVZnCf5RT8lIe46Uv7ywLDOPv4RqGjmBlegO7+6VxB+fvKEkT4ycWFMBOEWYPsGVXX2oKWbUJ/l12qli45LRKjaX5ORXtF9nskL6Dq2811x42sZzp0jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Awk7/wrC; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Awk7/wrC"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45IBxJt5015585;
	Tue, 18 Jun 2024 06:38:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=y
	Hc4b0pA/PU7PkxHBoH6qlXdpeOfM7NquuQdxLbQeww=; b=Awk7/wrC+DDulvAy3
	ccXPg5LpXZpjBVjooWYJAznRJEY4HvhfvSfdKLCJfEtsHR3upuLM+KuUGLZ3BeNL
	Vj/CDTk944RZ/sNGtlU4tv9HsrA6PBxe9c5mxV6glJwb4uX8SsoNOeQwUWb1Xz1g
	5FmjQNRZnmynSnJJrhQNs50EL9n6leUjKts4llhslxQG1i+jmtkED5gUN3A61RZ5
	oB4Hq9EUP5oomh3tkJ2sl2kKd1LeL8zFPRM2TTRrL0XcFQ9QPv+K/9LIDVA9g0Ht
	z8BD0GyADcIJrJO1iAGpvPR3YUeK6UYWcCMoqgTdGHhJtozru03TxIyzmpLYsSze
	bJcKg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3yu0nwt3q8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Jun 2024 06:38:25 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 18 Jun 2024 06:38:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 18 Jun 2024 06:38:24 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id D92C23F706D;
	Tue, 18 Jun 2024 06:38:21 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 11/11] qla2xxx: Update version to 10.02.09.300-k
Date: Tue, 18 Jun 2024 19:07:39 +0530
Message-ID: <20240618133739.35456-12-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240618133739.35456-1-njavali@marvell.com>
References: <20240618133739.35456-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: bWJYP9PTTylVWhh-yTwmNmotzV0qISuJ
X-Proofpoint-ORIG-GUID: bWJYP9PTTylVWhh-yTwmNmotzV0qISuJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-18_02,2024-06-17_01,2024-05-17_01

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 7627fd807bc3..cf0f9d9db645 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.09.200-k"
+#define QLA2XXX_VERSION      "10.02.09.300-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
 #define QLA_DRIVER_PATCH_VER	9
-#define QLA_DRIVER_BETA_VER	200
+#define QLA_DRIVER_BETA_VER	300
-- 
2.23.1


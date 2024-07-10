Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A38A1922E3
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2024 17:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720631508; cv=none; b=aZd9r5GobAEewphkaw5TM+v3BGsR5RRZB1Ik2MFyFnL2E4mB0bfc5k6XKjQLusAMHtNhBQhZtxqF3v6MRqlp4gRE0HQbmrgb0JbE/BPsj/L/EZG5atX0INV8vUX5zbWBIFEALny+rJ/ejfmtefch1iXcjMrA4+iouDBiaA4PGB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720631508; c=relaxed/simple;
	bh=wHJsj8vkaJmkM6If4eTmx9bUqiUEXn5vIu1fpQlTk+I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PyAZlXMoYEzaE/bXeYtpIiS2u8tXzkL2uejpdOmOF7XpyZp5jEyYKEheS4nZj3MBzUCiHibY3kHN9te6tnwIzNZfiWoX4fd2u9lmTn5HhNItr5dsGuiiNoULbMrpRz8Mq7CH8IZs7msY948jc30tzsk+8hxv/oMxuleU+JCOWhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Il3o3MGB; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Il3o3MGB"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46A9l5GT023787;
	Wed, 10 Jul 2024 10:11:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=y
	Hc4b0pA/PU7PkxHBoH6qlXdpeOfM7NquuQdxLbQeww=; b=Il3o3MGB5JyB3ENM/
	29kxIsqjoKhIq8/K5OWlVsgNISYgna/WZo6w5MT3zZcovh0UHsZJ9XzeCnRGyvoW
	KSwKg6O2L61bjzLKvqqX4GMLWXzGdyRIqq3ZZNSBtsxM0hbrXing+IhafhkoZOEW
	GWX5xJ75dy6hFV4tMSmmu8NPnyA3kJbdcw4BdT5oVBOf8MM25UNWY7s7UUCEde0J
	Tv3zW7x/nS3MzSZvSoxu6pf/Jfro/+dT6uQ/2ehuUBQaFR+RatSNgDCTRGYUV8d2
	rKpObpu8mwsgRCdEh1+2gc9FrBbROYKCPHDMeasSi48atplbkiZNo5fBGG2JTJQ9
	V+RLw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 409qyf21rm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 10:11:44 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 10 Jul 2024 10:11:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 10 Jul 2024 10:11:43 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 7E2473F708F;
	Wed, 10 Jul 2024 10:11:40 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 11/11] qla2xxx: Update version to 10.02.09.300-k
Date: Wed, 10 Jul 2024 22:40:57 +0530
Message-ID: <20240710171057.35066-12-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240710171057.35066-1-njavali@marvell.com>
References: <20240710171057.35066-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: F6BQ6-C7PkhWl9cmtnEABR_8qfP8ZTwN
X-Proofpoint-GUID: F6BQ6-C7PkhWl9cmtnEABR_8qfP8ZTwN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_12,2024-07-10_01,2024-05-17_01

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


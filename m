Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE20208B6
	for <linux-scsi@vger.kernel.org>; Tue, 27 Feb 2024 16:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709052136; cv=none; b=r4vKcx5CKfeMea+UJs6YZkXY6rcTv6z9x5hw5vCzpcGtvHnJtM0Rkd3mFu1BjEbmKIZmiZZ6B5ALEMsOvHQRScR0FL4IbAo04QEFmL/91t1loggwpg7Pw64FkwVECgpGpcJ2/eFQ/+7HVFg/VLIp+jOv5RU/SXHY3pJJ5lrRVGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709052136; c=relaxed/simple;
	bh=rqRxOPUgZiL4m/2VCymj2tq1amESmFjEA24f4rcRMbs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G99FRuk08RMuUxcOnMrKMsXrs3KNE2tO6ooWGrC9N1m3X0aeatUcYfNLFGGE5kL3iZA9UXnt6oSwVBTKz1mmMrtdbzmYBr0vhJb5V8kkYcYXHQbTEwHuYCWWKexhNuo2nJ8cZE268ckahm14cjU+hsIEJFItCYn3ue+8byPXq7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=SLt37VmO; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="SLt37VmO"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41RFgU0J004861;
	Tue, 27 Feb 2024 08:42:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=B0NkoqgcaT3Q+8EY1GRkYjWvWHfyUfsL4BBVvb81rWs=; b=SLt
	37VmOjNFAPiIJgPPg0xhugh+UmPTufHd0MXr7eFoEelNMTw6x2S2q18BFkwcluk/
	zZoq42KIsVunLv3mZq6let4O3Z+yHVrXSwSdYyr7iU8oW7YxcTJ/G5Y3e3P9ks93
	TnwjGiq1ugVId90xzNXHUOea9IaLTMdJhSLt0TdEH2tbZF64PXwNmS4dprboaWyJ
	cGMiyK9Mtm/1LoDP9l9lI3PPn8WjZzroodltNYtXopQp99lqzvVarPBlsY4MmhB7
	arGf9FfdxJ2gcgFFcK3xHttN7vbJzWRr/aBTt2t7DarxSFdjaYnPxz5dXcM4qzET
	vbdkWFY3B5f0mPwiPNg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3whjm689j4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Feb 2024 08:42:12 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Tue, 27 Feb 2024 08:42:10 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1258.12 via Frontend
 Transport; Tue, 27 Feb 2024 08:42:10 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 62F923F7099;
	Tue, 27 Feb 2024 08:42:08 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 11/11] qla2xxx: Update version to 10.02.09.200-k
Date: Tue, 27 Feb 2024 22:11:27 +0530
Message-ID: <20240227164127.36465-12-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240227164127.36465-1-njavali@marvell.com>
References: <20240227164127.36465-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: p7N-R9zvNuAqjSa0evDKqoQXgVh8yMKy
X-Proofpoint-GUID: p7N-R9zvNuAqjSa0evDKqoQXgVh8yMKy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-27_03,2024-02-27_01,2023-05-22_02

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index d903563e969e..7627fd807bc3 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.09.100-k"
+#define QLA2XXX_VERSION      "10.02.09.200-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
 #define QLA_DRIVER_PATCH_VER	9
-#define QLA_DRIVER_BETA_VER	100
+#define QLA_DRIVER_BETA_VER	200
-- 
2.23.1


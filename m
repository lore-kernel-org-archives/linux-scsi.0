Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC40B27466A
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403960; cv=none; b=U3qWwE4lxhAkDenk89v+37fH/uKmW84BcR4+t6I3oAhk70TGHOyfGNxcqHAPX+G/Rr4BH5YZcPztoL31UDq24HTpbigMdYI7jX3Tf9xBj7Wf/b5hfPjHQ1gTHeOcJI7wcnAzoKmeuLsqrDHUNoiOv8772GAV08LB94SXfmyCL/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403960; c=relaxed/simple;
	bh=z1OG++VA2DZC0ndvEW/Mn4o/qYcKQ4QDLEOG6NA0fKo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cuATsv8cFPvEO6pbR8x5xtK4tWDtvUYLYuW4i+4H40VMjuYwI4QELRDt9r7IekwZbRvwVit3fOQh7Y084Ja1B3tWizBfGymfImVRL9lKRvf+8yw5M1bygVtIt3KRc1C3CuYSjprMlTgOGF2hJJMv5jATlWNR4949WynEyinVHOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=YiW2VSu9; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="YiW2VSu9"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 667481QK872631;
	Mon, 6 Jul 2026 22:59:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=P
	Z8KuWBuTohPk3rqHF5P7xyNSJpfEqLHxxSIDgjTm+8=; b=YiW2VSu9oP2PatXmc
	gKMDUlTlHPE73RI4SCwrK8j87d8g7wMsCRxNpT7MwiAfSk4jls8Y6dvvq8sWyP5J
	kiHiBQKtTj7YwwvpHakej/U9yjd4pZY4GLgZyWb9c3RH3uuM7+nM1XVvK0W2D3f3
	pS8JTUtIaPdMmuFd8OoCnkVJFyrUMhhNAV2c2NN2ydFOf/K+v6Ot3diz4nKE2DP0
	Sk9QVQstf6xXuJ0vqAfupJJwG6Is+K1Jr/wIL2XHVfoqP85GKur5qjHsVxnPbSbf
	N62tfBrRiRVmXGo9JMKe+aET+Z4wn9FHAjWynM5LC0UKCuhcBcDCOda9LJthRhjw
	lEOGA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f8f9waacx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:59:16 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:59:15 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:59:15 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 2DA6F3F7066;
	Mon,  6 Jul 2026 22:59:12 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 88/88] scsi: qla2xxx: Update version to 12.00.00.2607b1
Date: Tue, 7 Jul 2026 11:24:35 +0530
Message-ID: <20260707055435.2680300-89-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260707055435.2680300-1-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: totyBfqUH4fzGQa39HuuDRzh8HDGU665
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX5a8GahIrk6Nw
 9jsac04fr8y8edfcE9I1MQz9aU4bXDt5lFrWhOUnFi2tQD6Z+PYr0mdBs3lzUW6XzGaXzvkcAN8
 i5tliuGR0uTEWHSue6q0J6djNEfS6u6/OWTjnAweyu/p+fi0Bqqe9hKUCq9uXrjgoD62iN93LcD
 srQWzX9U/Enjq5cgB5WnwfeKtzxtFLnLLVScpMpvzDe6FDHztIcbvqStQL6tG+SWuu1Fg2pUmpy
 /j27LLQW6py+SRodPr5eZtFwAVCAy/8nFWkJVtAgLwnxg9BwojbG6mO+0UUzj2eQNpx3HqqjlLq
 UXoWilFKReaocdBqc01VLCWp1ARtlAIbinU03Clfn2p9kbm2xmF9VBSb5geEPEREVXYCUuYpx7z
 D/FBZFqcDtFipXxcBbgwNWPw14lH0i2ci92JdVptWYP2ZOeqegLsiQCrCLtn7TD+H66gfZ3TO8x
 ZhphiknTBVMPnhROzJg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX0zJj1xcpiLkU
 YzpLZExq27OwCUxXwxCREXbywZ9KI7Tg0IaLx5SXlnxdb5asuLPg77rNYeD6SAG+tBHHraReSQq
 Gk+MxB5cvkFKlkdgHNcUZ3eV7McLv64=
X-Proofpoint-GUID: totyBfqUH4fzGQa39HuuDRzh8HDGU665
X-Authority-Analysis: v=2.4 cv=SY/HsPRu c=1 sm=1 tr=0 ts=6a4c95b4 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=A3DpSSew800dloXByJsA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 9564beafdab7..1c0b01d70350 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.10.100-k"
+#define QLA2XXX_VERSION      "12.00.00.2607b1"
 
-#define QLA_DRIVER_MAJOR_VER	10
-#define QLA_DRIVER_MINOR_VER	02
-#define QLA_DRIVER_PATCH_VER	10
-#define QLA_DRIVER_BETA_VER	100
+#define QLA_DRIVER_MAJOR_VER	12
+#define QLA_DRIVER_MINOR_VER	00
+#define QLA_DRIVER_PATCH_VER	00
+#define QLA_DRIVER_BETA_VER	2607
-- 
2.47.3


Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0845456458
	for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 09:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715764279; cv=none; b=C8/b9w9+p9JsKGGPspxkw3b5MEm5QHRUXB3Z+/grK20mDVALLVQTza2exHLsMVkyGCADE0ubjwszMnuMx0ZToUAK5/6kxN8OmnrQtmwU1YI9k0IGfUDAobi7AA3T7ZbqwfofhRwjmLI+kAVLCO9ctdHiRf8qYf6FatYn3b6uqFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715764279; c=relaxed/simple;
	bh=nu0b3xnDAiKxSPWvwDRVABvSZQZvAsF3h1rQQVya6Bo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W0PXTSXf35aPGy3BSI16JUHfEBiG58EARpZrD+ZHHxkCs/knFHktfJy+h8DwiwKnHlCHqe75G9wIqGLOUeD/m0wPQigjOu2Nxh7SuuUHbp4yLflVWfcZVLnb4IPokmml2hu42AhQim/mJxGvIk/WNFrjDb5lnZHdvCuUzQeTO70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=fKQZbMJV; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="fKQZbMJV"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44F5Tapi031900
	for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 02:11:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=N4HlhqWmZ4PlFewpNj6rrdVRzPeVIUSH1mcjYqMedQA=; b=fKQ
	ZbMJV03uD3eIuCLLLAutOPMYCVfFmBvphmWugCWl0PhLkcVRC9YtBiEwGkrcm4Z8
	aNL3CqBu8KhJz9MyemYUSB2beBfZpIY4JwaNtrDy2TRgNHBXnquHndq4uakRkB5y
	MhTJ8WXh4aNVYu0REIEE5n70EIFxCe0V9yJPtGGZwb0d8tHbHkBM5v00xUgACo/w
	KYH3oa6/sLqULxFUVVFSU0b/8nS96dQpEFH7msFczoAVKmugBg34aGTcoFPGOCZQ
	kNLabkAHRMV+h/njL/N/pH53sKosRVtrO8lmVYd3EIWAtgb0k1Djxp8Ci2D/HmW2
	02YS51ibC88q8bbv1CA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3y4pxtrj8t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 02:11:11 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 15 May 2024 02:11:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 15 May 2024 02:11:10 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 7593F3F705C;
	Wed, 15 May 2024 02:11:08 -0700 (PDT)
From: Saurav Kashyap <skashyap@marvell.com>
To: <martin.petersen@oracle.com>
CC: <GR-QLogic-Storage-Upstream@marvell.com>, <linux-scsi@vger.kernel.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: [PATCH v2 1/3] qedf: Don't process stag work during unload and recovery.
Date: Wed, 15 May 2024 14:40:59 +0530
Message-ID: <20240515091101.18754-2-skashyap@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240515091101.18754-1-skashyap@marvell.com>
References: <20240515091101.18754-1-skashyap@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: O0tJ-EdBfcHQHQNiTExnFa6sCCcwuOKN
X-Proofpoint-GUID: O0tJ-EdBfcHQHQNiTExnFa6sCCcwuOKN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-15_04,2024-05-14_01,2023-05-22_02

Stag work can cause issues during unload and recovery,
hence don't process it.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index a58353b7b4e8..e882aec86765 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3997,6 +3997,22 @@ void qedf_stag_change_work(struct work_struct *work)
 	struct qedf_ctx *qedf =
 	    container_of(work, struct qedf_ctx, stag_work.work);
 
+	if (!qedf) {
+		QEDF_ERR(&qedf->dbg_ctx, "qedf is NULL");
+		return;
+	}
+
+	if (test_bit(QEDF_IN_RECOVERY, &qedf->flags)) {
+		QEDF_ERR(&qedf->dbg_ctx,
+			 "Already is in recovery, hence not calling software context reset.\n");
+		return;
+	}
+
+	if (test_bit(QEDF_UNLOADING, &qedf->flags)) {
+		QEDF_ERR(&qedf->dbg_ctx, "Driver unloading\n");
+		return;
+	}
+
 	printk_ratelimited("[%s]:[%s:%d]:%d: Performing software context reset.",
 			dev_name(&qedf->pdev->dev), __func__, __LINE__,
 			qedf->dbg_ctx.host_no);
-- 
2.23.1


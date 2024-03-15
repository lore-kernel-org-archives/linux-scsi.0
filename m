Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F8A18059
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 10:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710497189; cv=none; b=IIwO06y1soRyKiqG4bk97japIe8qf0J7MPBTDaSia+il+9pt1MmijknT8bhptj6pUyebXRTqP/DzxvJ0LlciXhu0FUMJxj6UeiqtVrVPBOJrJZXzM+zKCnAjB7fO46+PBHPhjzTT9GYEvo5s+hO1uLrm5ApmfYZ8tYrz8GoGRlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710497189; c=relaxed/simple;
	bh=nu0b3xnDAiKxSPWvwDRVABvSZQZvAsF3h1rQQVya6Bo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T6jHSL5m+wSJede/6pnoc7otjVLD60ZDzl4SwCDWEHFgRlxkVDTM88zYQJIVeF4dvuA1BRBcHoglLDnBfxF8nvJqmIeWF/bIjcMJimUlSK8BaKuvcqYH3Mr7H+I7rKJ6fN6jCAIApEDfCnpr2XOC4biOIAaa1JW/FSOy+K+ONls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=eyZ8KovS; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="eyZ8KovS"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 42F8euio006306
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 03:06:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=N4HlhqWmZ4PlFewpNj6rrdVRzPeVIUSH1mcjYqMedQA=; b=eyZ
	8KovSD8mmtcacYLZGpKYR7ij8FF4holeLoQUICoL2zV0GoZivxTUxFlPySnpbgQN
	mNVgjR+pzSDqRWfoTG+8usTbbBp2KhytVkrEN4PNbs6us7fxjqbNRiAV/geERYd7
	kqPtDsXEkSg68sWyTABF7TvdYRc9m/u8FJefI9BNJmLBHdAa1veVnhhtNCrF1r35
	98uPg2MgNlvSSgdhDZNcQB3l2BNSHmkg3XriohHqR5N7B1TIm5HW3w603e9hRj/F
	6E9XoLjuGI4eiwF94irNsb7xO6ni0g9yFfEdSJ/21UwF4jMMTMMwhs4AbPUP0mSr
	k3r8mCfTiyUXYlBQiPw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3wvk1c080m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 03:06:26 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Fri, 15 Mar 2024 03:06:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1258.12 via Frontend
 Transport; Fri, 15 Mar 2024 03:06:25 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 6E37B3F703F;
	Fri, 15 Mar 2024 03:06:23 -0700 (PDT)
From: Saurav Kashyap <skashyap@marvell.com>
To: <martin.petersen@oracle.com>
CC: <GR-QLogic-Storage-Upstream@marvell.com>, <linux-scsi@vger.kernel.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: [PATCH 1/3] qedf: Don't process stag work during unload and recovery.
Date: Fri, 15 Mar 2024 15:35:58 +0530
Message-ID: <20240315100600.19568-2-skashyap@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240315100600.19568-1-skashyap@marvell.com>
References: <20240315100600.19568-1-skashyap@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: peAvQh4KbIEDfVKr715qnkCgOruqJkop
X-Proofpoint-ORIG-GUID: peAvQh4KbIEDfVKr715qnkCgOruqJkop
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-14_13,2024-03-13_01,2023-05-22_02

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


Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D65257CAB
	for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 09:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715764283; cv=none; b=EFYcHAXcHRumDcuQ6PKCr5Rs5uCyVDxdAy1bU/UuBA6ldU6T0XmtFfizTrpPGKh2rbfd9p5cObaZkMntwuV/Wo0TlT71pp0L+aztIf5oDCCzdxo9OG2JqyIakwb0FFEMx4iBwuO9ttBqcsIKV6PQWmYzrM1iB8Ak++fTNZjwOtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715764283; c=relaxed/simple;
	bh=OYm8WDWL0EjTBx7B9e60vgRgip+YJ257i52ew/zu3Wc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mY2fXOCDmll6h+V19vQ61NBqb0M1w/jErGsDmQA0dqeJaDnDyxT0b8lUbEJthpkhcKvrKDZhiK3ooTwKjlZe1xhwgT+Ehdo6lHIt6bYH9d1eMF67yf5NpZ0P+b+CqaYNWDduEORvuf4NPi3xrHBxA4QsKyvsNaRh3qUHZM8VDRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=ga2j2DZY; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ga2j2DZY"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44F5TTMD031884
	for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 02:11:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=Q8W2JD7WXR4kIrD7/52Y4+m23e2NScFVECoutPhErEY=; b=ga2
	j2DZYbFFqBkjLodxmO10dHkU0UddxPqCR7ejR4eoso++/niDi6GWRMngg5/B0jzl
	67idf6TQ4Xbpk67ScGwSt3aSdxeltE6azmdwAyV1nXiGXv46Udu5IXRXoUxZ7gKC
	3NTtX9plU6HVKgcY0VaWq8wloumeOSsiYVgTsXJ3AOuhIXebSTWPb0D4P8EUsX9i
	XZzO/IiNFrsLxosHRcGLCBKxZoJcjJ+7t1tOiCLG2xXm7IzmAZIqpNmGUYRf0IvW
	L6w8JUa3eagWEn28ZH+fXhVSRxs1RBVUM1tl7/jYjmYY6ieqknfX9sSj9xUA0IPF
	1FLUF1bmdPQ5nZMUgZA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3y4pxtrj93-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 02:11:15 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 15 May 2024 02:11:15 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 15 May 2024 02:11:15 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 281A23F705C;
	Wed, 15 May 2024 02:11:12 -0700 (PDT)
From: Saurav Kashyap <skashyap@marvell.com>
To: <martin.petersen@oracle.com>
CC: <GR-QLogic-Storage-Upstream@marvell.com>, <linux-scsi@vger.kernel.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: [PATCH v2 3/3] qedf: Memset qed_slowpath_params to zero before use.
Date: Wed, 15 May 2024 14:41:01 +0530
Message-ID: <20240515091101.18754-4-skashyap@marvell.com>
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
X-Proofpoint-ORIG-GUID: lr2d8jVTY9FGQ61q3ot9d7FbGTvo9bx1
X-Proofpoint-GUID: lr2d8jVTY9FGQ61q3ot9d7FbGTvo9bx1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-15_04,2024-05-14_01,2023-05-22_02

- Memset qed_slowpath_params to zero before use.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index c98cc666e3e9..b97a8712d3f6 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3473,6 +3473,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	}
 
 	/* Start the Slowpath-process */
+	memset(&slowpath_params, 0, sizeof(struct qed_slowpath_params));
 	slowpath_params.int_mode = QED_INT_MODE_MSIX;
 	slowpath_params.drv_major = QEDF_DRIVER_MAJOR_VER;
 	slowpath_params.drv_minor = QEDF_DRIVER_MINOR_VER;
-- 
2.23.1


Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587E9182DD
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 10:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710497192; cv=none; b=LkRB0OSjjl9yO7N5Md7j+GIVsIGQTWvc2gntkvyAL7dTqMHSCKyuyfdEDArBlb6tNQNc1QABsoGFCrhTMnwXYYK6glLR+djfAvGf/DPW6feAIQgFfxGWgvRIoXG2eGur/tCL+PyYA2yaeSeth2AbDRTKPp/EZ0y24MHdDSbeFK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710497192; c=relaxed/simple;
	bh=RZnADJR9OFwINzBDdZNjbWc6SKgv4W6NRS756H4j7kM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cyHf6uItjdusabv444KXPxRwC5soejd7DLA23Fknd/th9e/9JDG8ah3h2jZAJGGT1Hm11oRSYezJi+a76H26b5TVgZAc9wO3O1wgrkECqcq4Usq4RtDCoYj6vRBIpDF0581+tw6uvzt/OZfx2c/IFvl5kuTlaKg41jb3OsEaNsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=KhkIxZQH; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="KhkIxZQH"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 42F8eKU0005204
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 03:06:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=7aDhix89tQbHT8GZM7+G3mTZObm9s/SBHaY3NHB0dfc=; b=Khk
	IxZQHEhLW+5yU6DcZNZ4qePU7qrA4GrjHegdWjFiirccHrjW9rUDePAnJShjopLY
	bYOxipcQ4NuYq/jogmuA9H41a2DEZkznz+4ntLmla3UeI0D7ED/Pt/StZoIcXGNo
	FIM2zG8ne8h3d7a2GXWDpScRwEm/LUkFxX39Y1xQ9QgTlwHI9PMw19CapJTjyBH4
	hg6FzCThCu+oWBhB281HyMBhfkRlmBRGjSBNKA45Tpr8jULDj3G6oIvpYrR8g5k1
	CGfbJN0ZLsyEwDLpQXkN6x26H+Fg+wTHDk2ZkPVOLwpsaKCl3kxJv0UOtXUAZqUd
	82mLpyLOdpPdsMYRgZw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3wvk1c080t-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 03:06:30 -0700 (PDT)
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Fri, 15 Mar
 2024 03:06:30 -0700
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Fri, 15 Mar 2024 03:06:30 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1258.12 via Frontend
 Transport; Fri, 15 Mar 2024 03:06:30 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 268733F703F;
	Fri, 15 Mar 2024 03:06:27 -0700 (PDT)
From: Saurav Kashyap <skashyap@marvell.com>
To: <martin.petersen@oracle.com>
CC: <GR-QLogic-Storage-Upstream@marvell.com>, <linux-scsi@vger.kernel.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: [PATCH 3/3] qedf: Memset qed_slowpath_params to zero before use.
Date: Fri, 15 Mar 2024 15:36:00 +0530
Message-ID: <20240315100600.19568-4-skashyap@marvell.com>
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
X-Proofpoint-GUID: WZEwoohyULQ4hITBmYfDlAVErbdQTIt4
X-Proofpoint-ORIG-GUID: WZEwoohyULQ4hITBmYfDlAVErbdQTIt4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-14_13,2024-03-13_01,2023-05-22_02

- Memset qed_slowpath_params to zero before use.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index d441054dadb7..d4563d28d98f 100644
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


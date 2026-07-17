Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DFF1E5B68
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302312; cv=none; b=RSnyCubnjn9TqeT5WHL68CNQ8SP6o3y3TntMKIvqaczfzbLIVsLYMKalYZQCFdG1YdHDELQvA0uFYeALRWK+6BEvB6+PBERX1c8AE5c9yPEhDUtTsrGf1azwKokBKkmdK5XEvGrkst5MrxVvYFWv16vlYwoo3HP/vCIbOe3GZo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302312; c=relaxed/simple;
	bh=8EFJVBpLd9yVK+B/EWVFlt4qfAyHG0OgNl+9icrZYIQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LD2EjNUgWc8+Hw4zE2ZUFavuvuhyZPIAsw0QDtYCoqgTxIJJDiVBpsckc8y79Ec25ACGE5GKqzrZ5/AzbwFmfi8NEHTJmj15xFJkWG1oZo4kewzBGx1yZQs2mBJ2Pp+jPo5aqK6vgqMvnBYoDJQoiKOv0SDIaQ5/atUAEDeqmdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Gl2PEgQs; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Gl2PEgQs"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE5tAS113139;
	Fri, 17 Jul 2026 08:31:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=1
	/GEZ4C5NmGKWyDf1qbY8ZcOKdqrA0zvifLdQXLS3Ys=; b=Gl2PEgQs4QEd+iBI8
	YZAeexqvjW9XWBqWBQAQetbLVylewmB29MVWv2oj5W61MPaUTWaOSyA5F/yiv0OJ
	dkAZA7Ys2rP6yiB7MLPc1snOkN6NTgRGqypshNJdFSiy2Xg0yWygNjfRs14YN8Fp
	or9qQWdlShFvvIEPtc7RlM3NVohnxqRykwc3dCJnBeLu0me1geNRgoOTyxkIWbWI
	rSO6Kw4SfxU6DPQxaTPgYjQDSy5pXyPnCoKXI9Wt+wT2w9KvJ3naMLjjIsFiS879
	knvOEUcUqJQwl8WGx/6OvogHsfHrVQY83fZCD/MwdtomncPve9q2WMkiyDBwUhoy
	Nw3pA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fetcbn1cn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:31:48 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:31:47 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:31:47 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 2430D5B693B;
	Fri, 17 Jul 2026 08:31:44 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 56/56] scsi: qla2xxx: Update version to 12.00.00.2607b1
Date: Fri, 17 Jul 2026 20:59:04 +0530
Message-ID: <20260717152904.3155730-57-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260717152904.3155730-1-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: gewkgyfU86KBa1n1b0ZtM8lfHuOQghGH
X-Authority-Analysis: v=2.4 cv=Y7jIdBeN c=1 sm=1 tr=0 ts=6a5a4ae4 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=A3DpSSew800dloXByJsA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfXx/lB4Sb7jhnm
 gsJeUMdwk431hXH8ot9DOHT9fRoKJgzP4t4UghRh3fvXPZocrfBQ/etR3bVkzPeWPTjCF00Y5TW
 xn4UMBO6RLCnXHenLshgPnmfiSYudK8=
X-Proofpoint-GUID: gewkgyfU86KBa1n1b0ZtM8lfHuOQghGH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX+Eu8PPcNU1U3
 tl52SiSGWSb6Iuvnv6B1Rc0FWgTYld8qOpGfcSHDlObmjFs6y2NI8c73NGCRb8l4IcbythhwKzk
 TDC04wD9bKpZopcTI3up86brHR8wjmPFUyJrARELNvyiaAkqVtwuGnjy9PK7yH8rZGVLwTElwp4
 6nI0peBVM0xJJWa74LGmyX+tsLO/7gdAMInF5HM3KTY6QxdD4TkkNRgRDOymS0JZu6s2EYTBkDo
 DFwR6I3H/wqy3neHzZxqg4kIq8I1O7db5xFdNxk6rg1tXYR85zpBjhw+CfOSW5EuJi5Bz95ptGa
 cx/d0lWN2Bk7cLDIc6dcS7HIJva5OdSF+Rph8IV0b9RUJIvDlr00cG/3+c95mN7vZjzFUIyM6dz
 MrGd2DCWm5qk/sw5zGL0QnbRDqHwz+J1QQeFlrVGO5Rv5eWRNtC7VDaq3AbRFHEKNLjWwiAH+pN
 td/B8if+xML+6yn7h2A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
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


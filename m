Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98ED9176FB1
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302185; cv=none; b=TEsGWDpfOe8YQJLPPm0DsCeHqxNQXaQ3tZ5hO0nnoXbq4g7ds0wFrap2IKJw82UW2aKxsbO1ZdMrw+Z3xPbQJPY1nBpczNzQTEclN4109E6+mkR3KBvWcZ/zDY6VRqm1XiKfPkEaxilnmVOdDoUMu6j7Pdsei48AdksJTLWTt/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302185; c=relaxed/simple;
	bh=DKAK4FzQFJjtr93oMn2GdrKhOQiOIdGxWXOsXN31vLU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nODBhW/wX+lM6cKoL3naj4asFaykS/55hSU/HwZ2jQi7emWg8sYioDbgcO1gTtz4hEeRWAGy0B/flJewC4gypSGl4mlrrn7GJdstJDeaPcOt2cniUpmaHjd+Lwn8cSSezf2dHE1qp8ULWbh75aMINdFkZk5ftOAcTqdNccuciRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=AeEpQMfr; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="AeEpQMfr"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE4VXS2774323;
	Fri, 17 Jul 2026 08:29:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=W
	pi8ja6Hyud0EEdQppYcX+Xxt1ceueqP/psUTHAQuRQ=; b=AeEpQMfro157bWaTh
	N/LjdvfJyq1lOg8/EztFo15COAqZnTjK1MtRKgl5GpsAK0H8V7mCItWvNG4OKPvO
	tuVxL6LosXlam2fBVPChUnNt/ffcz/kKN3Z+TQvOUahxrUqSon9hRr6SBQFw62yt
	oRGVISAlIuOV511JjA4T9BkxX/hM07VQjbiSiwwYXLKQ5oK/z/vAEnZ5Fk7GUhug
	bE0DFnH0oC8rJuE6iv1b5HFltq2DAVo94eQXgAaoOYLb5DHxpOLHC/h9QrxIf4Dx
	nDyjPN1YLfc/4g1IQbptWhBEd7m+52TElVLgGUmer4xpmZxm4ewNrEyMxQRoZiwn
	W35Ug==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ffm6p0h9s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:29:40 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:29:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:29:40 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id D57295B693E;
	Fri, 17 Jul 2026 08:29:37 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 10/56] scsi: qla2xxx: Add extended status continuation and marker IOCBs
Date: Fri, 17 Jul 2026 20:58:18 +0530
Message-ID: <20260717152904.3155730-11-njavali@marvell.com>
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
X-Proofpoint-GUID: e2A306TM1wzkA_OSWyZeyoAdh52LFxwj
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfXwhC+vEl5AQY+
 xDWdLM6ePJGU+g0QYh+D+AOAmnO4ZMblmArnsFJBZir4m1uFnoRGspRnv3j1PAjfUc7xLuI4YGk
 mtIaMsmzSHHJrGfZfIH3rqjgkH8kBIk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX9DgwKwj0AIpw
 yMa5iKFWhQUPf5kvhw15/6VT8DFujgb4NPTWz+5ivePFSBXIaP3so3PaqwTt/apernUc3K1f5gf
 HEwDAFAKa7bkbVGf47XF2Y6aM8+TYzBK3XCLbGVgAU6bCTb0dk7q8y+x7EKKIz93UETPf0yRnOF
 PzTdmsh/yILqXCZu7vlGg33b4Ms6LuB8PWZtg8vCIuML7CA+Rk/WUw8bN0WUVEsSrguL81B8sMF
 3wfYuqBXykA4cE+8/k1ZCy7MOsRo1i6LcWzu+mv+SPppWDokuVLTG5e37gXRL7Z5dbK10Chuqb2
 xAsILh+gmVyT9dR5NF0YkAECXj7ar1cJVXGpL5WDjO01SVL3W5280qaenta/XcrrEedlZjEAx6p
 4+db0sB9Wu2DvI8N66VAYIaLVN8bzLS5V9LLbsMwKcKNk38KO0Ku1yk5AXZMmxKse/wEQVAfFxI
 ve7er6zyx3cBYWTrPiw==
X-Authority-Analysis: v=2.4 cv=Wa88rUhX c=1 sm=1 tr=0 ts=6a5a4a64 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=Tm6tI7QPiOij7-9VwpMA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: e2A306TM1wzkA_OSWyZeyoAdh52LFxwj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

From: Anil Gurumurthy <agurumurthy@marvell.com>

Add the 128-byte sts_cont_entry_ext_t and mrk_entry_ext_t
structures required by 29xx firmware.  Include the qla_fw29.h
header from qla_def.h so the new types are available throughout
the driver.

Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 7423687578dc..4de0de5cccc8 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -337,6 +337,7 @@ static inline void wrt_reg_dword(volatile __le32 __iomem *addr, u32 data)
 
 #define MAX_CMDSZ	16		/* SCSI maximum CDB size. */
 #include "qla_fw.h"
+#include "qla_fw29.h"
 
 struct name_list_extended {
 	struct get_name_list_extended *l;
@@ -2360,6 +2361,15 @@ typedef struct {
 	uint8_t reserved_2[48];
 } mrk_entry_t;
 
+/* 29xx definitions */
+struct sts_cont_entry_ext {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System defined. */
+	uint8_t entry_status;		/* Entry Status. */
+	uint8_t data[124];		/* data */
+};
+
 /*
  * ISP queue - Management Server entry structure definition.
  */
-- 
2.47.3


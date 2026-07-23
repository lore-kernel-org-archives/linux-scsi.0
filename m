Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15456256C84
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783101; cv=none; b=G10VzH6e1OUbs75aCHuHIfyjegkAIWRvI+qp+NexcgTGMzrMbKpvPsenZg2ndbzZwSLWZFA6UwbLUVSBO8fMclMv6HHXfuGpoVv2DeC/yUBx1nEc8FYeFpQJ+zbxIIIhWNU2UKUjMU7/nECjfqBcwWMO7V5zv0wukrn5N7Ed5rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783101; c=relaxed/simple;
	bh=DKAK4FzQFJjtr93oMn2GdrKhOQiOIdGxWXOsXN31vLU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A32mal+X2lI6VFhc2OLyGNjoZW3iDNAtEC6uZ5M7RCwYX4kRPkImXjgSmXVm6y+xlZPyBCK8BrazLYNcH7yLStb1neqRvhdZF+/mMqLb5SMbtm/tmMnnqVSKY4QnHn2B/65xFsipA29cdZaIPsbwapt0hPC7b9gian3IPBcFVlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=QryjCoCG; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="QryjCoCG"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4vlkB2441570;
	Wed, 22 Jul 2026 22:04:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=W
	pi8ja6Hyud0EEdQppYcX+Xxt1ceueqP/psUTHAQuRQ=; b=QryjCoCGM3uD966/1
	34VBkImTI8GU3tZepP/mUxNzxMqKjnZtRW6RB9hBTcKUBw/DqJ+omLsV7KEPj8P5
	2UJjN+KhG3ROoXPMyGwsiq2vZnw6ZghicsvPDqG3UwppL/o+I4iKwAGSIow5URuT
	pFrUU4QPH88tAGZw54BjvXW5aq0Jtb7PlChyps5A27Jl26v8CDfQuJsBApJ82/IR
	IZ2Xlzfi1cooTJkq1wdA1TVIrYD+wyJPEANfGM4N1bZAzBj4DpAB8p0cKeDvHYhy
	2mjOBnGV+odR3D9jzo20mJD8Dh0pgCP49mBSa1gJMAPqEBEiezWUetawShw8Dk0a
	s51uQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fk7jkrm0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:04:55 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:04:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:04:54 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id A14095C68E6;
	Wed, 22 Jul 2026 22:04:51 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 10/56] scsi: qla2xxx: Add extended status continuation and marker IOCBs
Date: Thu, 23 Jul 2026 10:33:27 +0530
Message-ID: <20260723050413.3897522-11-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260723050413.3897522-1-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX4oZYXwf7VRZH
 gbLij11odxQuqx2MoUSYPsW2tO1qkG0Ss62K8Oocbn7qBzrpdUBOUxxOjI5iYzml5VK/jDVSVCp
 Bv+X3MVX1Dx6MIKxvsoZNiG+2K89dc4g3+V+yW/iX4MCtX1BH5RMsOA6TNJcgGCcFrP2sFBT5Zm
 lsx2CuUP+j/J4OwbnidAwxZ+SlDGW3EPJz44AlNRH8TSovGYVbRDXO+1CwE0Y2j2Aqug0D2yP8L
 5CohiUn29UJEgGr9JYWU3uORDf6GGc9t8vxRbt33W2T8uz/v9YK4L47fgjdrkNbU8UB4bWKEH3J
 tCQzRSm65tBHwEtObhN55yJ1Lb8wPER4UWUByHAUBZ6IzlTvC23Vr1FrzDiAsO2AEZ6hdYPDonn
 LKRZLRgWy8j6zSgxi1UR62y6t00Wb3YLhYauIAeCKeH1Rdq11zr6sRP+LwdIEgVuJ1jMVX+qKxr
 /7YgQ4/bkFNUu/5TubA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX7p4LfjWKb2sD
 ReDBhd0MnwDKNZtbtpvzh5c3o3Ow6KjGXcOVFwU+sOroib8jky/8kfMGgHGKjiVIQuczZ7umd7c
 p6Ju9VT1tmHLLX464sd7+iYFNohQi5E=
X-Proofpoint-GUID: iqBZYuQp36aryzlnwyMh9NK4IcMUYeQJ
X-Proofpoint-ORIG-GUID: iqBZYuQp36aryzlnwyMh9NK4IcMUYeQJ
X-Authority-Analysis: v=2.4 cv=Zrzd7d7G c=1 sm=1 tr=0 ts=6a61a0f7 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=Tm6tI7QPiOij7-9VwpMA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

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


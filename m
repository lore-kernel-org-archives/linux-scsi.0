Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6EA44471F
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022883; cv=none; b=qdXKapHrGJYfPyDtoYA+dojslTl0Oj6aLXoRUaY7VEwtN8/IJvamGBiWCVTvYXZTVBNqBLDAVRkJ6bwSeONXC97RG21hokxBmU89CtXVOZ4EBxb/3NQ6OAOTaB/g1cjjeIV0HCeYardLoIbVbNzurKn0zUL/G17kd+d7Y8Jp9Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022883; c=relaxed/simple;
	bh=DKAK4FzQFJjtr93oMn2GdrKhOQiOIdGxWXOsXN31vLU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eBs6XgvYDo4AAujGs9simjEZiU0pomXyNtnPjRVuk45ZZ45RgSIYcDXLHzcLdRibYRT/VHDrPDbv8xajg5PpydhbxtNxGUZW1zBlAFnjXN5vscB+3hSSMAmxenulPBwUNkChGuEgdEJ/UpIQiAFcsP61TAUkP4mTgeithPwiyTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=GDYr1pVB; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="GDYr1pVB"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UEWr3668034;
	Tue, 14 Jul 2026 02:54:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=W
	pi8ja6Hyud0EEdQppYcX+Xxt1ceueqP/psUTHAQuRQ=; b=GDYr1pVBRjX9qjDor
	A+8To5+6HWxsyKjbyGzi6kjAjRZCDJAzc1mBstcO5wma5Si0Dd6246Mn+oiaGTlj
	z4a3VHrQZeTjDLCqPx1E/0Hj8sEuj06KsXf3JB7GffSxv2pLS5wN23L+HyfRPLsf
	bcb31EWqjP9XOIXSeFqsqnVztOonCPCPAFYWsqdtBIaD2D0kNdjZOjHgsVJa/934
	YRUEHIqlr9y1QQyOf/kgrDp3kd5/m/wBHp9ff/XkcH3sx81fWHttKqlIlF8uSmx8
	JQyk8hMbO9r43hFLwDbwC7jedW0zd15rMFFQo2nzJZWfnJmlWuF+Pn7lVG0OkfCh
	3eLqA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fcwvc3eky-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:54:35 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:54:35 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:54:35 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B7C145E6867;
	Tue, 14 Jul 2026 02:54:32 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 10/56] scsi: qla2xxx: Add extended status continuation and marker IOCBs
Date: Tue, 14 Jul 2026 15:23:07 +0530
Message-ID: <20260714095353.289460-11-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260714095353.289460-1-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: xWdL4_61k_ylRHyMOWcW9Jk1HRgHKM7-
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX9BytKGnoaxBg
 jNgQbv11It85iyfz8ljz+JLedYosX+oyGI18+5tbZXFsGlqTwY+h7xTzcQIZvDCAF3F1tT1TxUT
 K/tXIX8XQ5OEZwyThnsQm8CbKzJF3qQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX5LVcgJyiPMbj
 3HkUjKgkKnNaZdkNH8dlQMUy+FRfR12rrJXFHVUSrDL8oawty+6HTcnotxmjkYZBu2vTUopf+ez
 UnCCa5uyqCUDFaVRrdMMmMq7kkHFttWxQ7uw0AA132LOXB5yxchrL0YSzzLqn5IvA8UvWDZmIrQ
 aJcLAwt0qWpRcQUt2ACzqqEJu/GakuxETKR+AFFtx1eZGQR5yFbYP1/tTd5vQQL2BRhYZEnoRmx
 Bu/K3/hUMCu+wBhfApYBLUfP6r12ocbqvEr44dE7Evi6hWygK837IWflx4RuKTbomiOS/INLERj
 F1SnR4wAW0SUb3xmiOZjzrYwoLH2bh+7Y1ehGyk39+gRLbXTnBJMtEQD5IlR4epI4Pw3xmNypAX
 bmZIHyGB/I+aRbRatjlHO5/MC5L9RTqcR4Z9mIGYtmvWO+wQLsj/tsIfJk6v/rAa+jBoU7mybR5
 1ag1E7Ie4ss2veLTyxg==
X-Authority-Analysis: v=2.4 cv=cIXQdFeN c=1 sm=1 tr=0 ts=6a56075b cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=Tm6tI7QPiOij7-9VwpMA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: xWdL4_61k_ylRHyMOWcW9Jk1HRgHKM7-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

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


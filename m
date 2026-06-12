Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F22E258CE5
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258071; cv=none; b=R5nZqUE1c+76DP/xKgGwuixzEhOWmYMj118+LcrLs9CPqv8Y/TKcEbXk73xZRcJXYjWcdeN9IEH31d1eUkYCsVqrlLNPkcKRAkWAbHarRiMYOJTsgPDmssv8YRF5jOXEuu/U/232EF3RjRa/t5RaTwh1vhkcw9qIJYH1XFFHAVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258071; c=relaxed/simple;
	bh=iyj04sHUFdrqHIqKGET9LTvX2A4AfpFTYJIz6PVjD00=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GsQ/3GHF5pjy9rEewE17RVmWdKdyz8kI7cvUDxtk0S3g+2FXh3XTZ9oDvVSuM4uKDubKq4ShSMc6y4+ilFk1/IlGlyIH5WDgya8pqIxQ1Aw5eBgx0ermh/EOCe6TYMlZunu3G/bG/O+/81/Z4UHhedU3Ez3wBA2rBQlDZ2A4L/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=OrGLK30g; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="OrGLK30g"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C3ASqZ071190;
	Fri, 12 Jun 2026 02:54:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=1
	dPhjhWP8RnnaYj5sqtPBovIvE8+5lur1OZ6esp9peE=; b=OrGLK30ga5vvJMwpS
	Oz80IICsdRK5dwXoTuIP2f3tPWbdHe5iGRgQNpeOAO6QFC8yEBZhUjMzufFLtnNb
	fVYm12IOEpoqEMBzS9zcBfLob3aLYGOF6DJ7o5T+cWrv0q4P4wVOQTB9xybiTl//
	TImpuMd2gle3qOmUDkT8WUqF6dHIml6Ce5DJokTA3WEO7LLxMRqB5aycuLLMPdyJ
	hCMc/pPQN48u1JIEUUR41H9n1ZXJQZ9NAXNgc1lRHc2TYBsQ32eDv7jZRr29ZXL3
	aPzKpKFhCuByVHAq6g0Nn+G7Fh3mzrQnXX2mGEu0IOrZTWbBde6YUv5DD+WiPam1
	yiEQA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4eqe5vxrjh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:54:26 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:54:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:54:25 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 32DC73F7040;
	Fri, 12 Jun 2026 02:54:22 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 10/60] scsi: qla2xxx: Add extended status continuation and marker IOCBs
Date: Fri, 12 Jun 2026 15:22:43 +0530
Message-ID: <20260612095333.1666592-11-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260612095333.1666592-1-njavali@marvell.com>
References: <20260612095333.1666592-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX2y7OyngfwGKW
 gwIEb0OgddcMqkCHEtip0wXkuCj+JSJXkmXQlBxOWM5ClKgIrR/lu+6npxs8xRn+GNv39dporJL
 PKl2llDGPy2omLD9fa5qSu25uQ7z2S8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfXzQ9azZ3Gn7Sc
 44OWAm49Q47xTdpz4JfBOw2bbDcIM8McRIrrG1QSSK3lpiIgKQoB19mkplJXfq4KgHLKD2MiOsX
 Ce3ZNElePANVd4X59Fv1OGBelMLYDgfUrB/m5A5Mb/S0IAg+NASlLp9a1nRtjpf7hZZOSo+tsG/
 wTX8fm/z1gnjSutpBEwPaea5zQzF+djjaTbDY6zJLD9bHNIAAgeyMEX3a5XxjOyKdSsU+1QHNpJ
 wYB9ujIFYHKYlDSWiRrHkAiYtM81L9bnLf22M/To2PcA6203OYQtombGaLa/iu2cL17iEMqAWNV
 AIt0ZkArDgbsdqWmf5hwI6wKE7IaUhbmRZSJsRH4MTAA5yabUF4FIzswbe8D4618ca42JunPYBA
 URpyS4O0G7tdfWunEjYlys2ozEV62WXffBKuUb8dAzT9pVlHStS/32/1lhaKOuqtqt1CwxAb3U9
 xQ+j/hLtlVRcKB7xMKw==
X-Authority-Analysis: v=2.4 cv=UPDt2ify c=1 sm=1 tr=0 ts=6a2bd752 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=Tm6tI7QPiOij7-9VwpMA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: xchMdiKHFUQc3ToJ8GT6rd_V7m14n5o_
X-Proofpoint-GUID: xchMdiKHFUQc3ToJ8GT6rd_V7m14n5o_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

From: Anil Gurumurthy <agurumurthy@marvell.com>

Add the 128-byte sts_cont_entry_ext_t and mrk_entry_ext_t
structures required by 29xx firmware.  Include the qla_fw29.h
header from qla_def.h so the new types are available throughout
the driver.

Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
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


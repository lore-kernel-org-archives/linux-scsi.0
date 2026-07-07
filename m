Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D92E33DED9
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403733; cv=none; b=XIppSJLq6iXK7CsNNIVOl0vWJxdwBs0Bn0fU4k9dBaN+iq79T+6XZoxOhFutDtYEg0CLoEs/Drmag3SVTvcTop30OMBLjb5UICRYB+WlxKv7OoxtNcMuNdaW7YAbumKhsDh6ooVa5NKYrfnEkfzVMECfTwQxKG6d10/0HJHqvzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403733; c=relaxed/simple;
	bh=DKAK4FzQFJjtr93oMn2GdrKhOQiOIdGxWXOsXN31vLU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lAzGfD57LonA+A55EoCyjI/N+hXyYJxIzrWrUAEl8ArAqU2ouh6+c0rGkggy7pHx1LFc7ciIHUXsRMkvb+Jbbr+NwjHBQ5x4YPc1qkrpR0F7sO1d+IDFK0iaZbK4VKqLhNFWKpTj2zngconH+SkF02GKV5izI8tLcC6eTsOwPVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=DDeEKTa6; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="DDeEKTa6"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748buX1656070;
	Mon, 6 Jul 2026 22:55:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=W
	pi8ja6Hyud0EEdQppYcX+Xxt1ceueqP/psUTHAQuRQ=; b=DDeEKTa6JV1+9gemW
	qjFNSWKiPt3TLhz3JKZ2Np4ICYqrHm8gtcfSkkNyEK9FGBZ5E8wUIOQQuPIxhBxu
	TOHbZ7nyaejBiptbRrcqDhfiz1GEB6OxypdcGlEkElcdf0Nng2qUU7RkvXxeSPje
	A8zg0bwYc5pMbDTNxD5zvEzePWhDPS9UKeHzb0pe3RgSFSE8vufffHlKj2yZ6ZLR
	cwCerwmUef8qg42mltS6VmJ6YNKUqgQcup9mFgTRARlMuVeqEBjOmU8kFTIUyI8p
	UbY8Flg9O/OiNDQD9HyJEXODKLa8Zf7B6aNtOR4MHvK1IlT/kW7LdUl92igokbqP
	Eb7wA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqds0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:55:29 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:55:29 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:55:29 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 7EC763F7066;
	Mon,  6 Jul 2026 22:55:26 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 10/88] scsi: qla2xxx: Add extended status continuation and marker IOCBs
Date: Tue, 7 Jul 2026 11:23:17 +0530
Message-ID: <20260707055435.2680300-11-njavali@marvell.com>
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
X-Proofpoint-GUID: YeygNTF-pbn0uLGolC5MUEhOjk4IECyE
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c94d1 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=Tm6tI7QPiOij7-9VwpMA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: YeygNTF-pbn0uLGolC5MUEhOjk4IECyE
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfX/PDP32nz574x
 o1dRur9VLYwjEurnNswTfmObgtIIt6QAACMbNs3pFP3f2m6OhxAlN5KnPZy9ws6uvB80WMNbjsr
 Hgp4FnuVPuOJSxQRZ6O6gKekEuLD61U=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfX1N2lG/dtZnwd
 F6j5WeVEjlvD6RDz5n3ZEb1Ghrf27CBB6MXpimX167q5KHZIcbsOpaWrX0ZJbt205SLCF7CxUrL
 NP3gpjhjJJ4HkWevM36H58lkWSR6eeJQng6lyFVfiq1vYZftfgDRzUR76hs/8BAiXH8IHJgCivy
 exgLCh5SRCNgT4WNjd2sV1Nn4oySim5l+zgBiNKCyuui4WCF9nZ0gwij273n0VlUlAH+kVyr3GN
 o7fxCrXefZGKW3A3x2KmgXvVcbnnVWJPa+NAPzmU9iyyzAoasL3NBwxwtjxYn6HbGttLDD5xyyx
 LufzmWMcxpqHSloTdIe1GdmpKqJhVCZIPDI1V4eL1G7cR4xxDIShumiHoH7ZPLvlWCgqugPqIXH
 HQgNzLbxwzorv8P1sQqf75B+1RuCnvsmulm1PKZIp6a2P2k0/GLhrD31XQ7WDcOSH2iLe2ejYf7
 2UZghVcUTzKRy2smm7A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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


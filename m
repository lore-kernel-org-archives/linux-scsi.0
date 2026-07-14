Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F33E3D7D8B
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022988; cv=none; b=vGcYa5GIOOV0qc6vq3nEvUyNyN7lA205DnBd2R+203kKKFjyFZZX4r6EkKg91haHP8BebK2ExTtd9T9Rbs9DQ3TZttRaC2BFqSmproJ6FVyRxwK25UB9hhyt+eIgnZOYJrdWF0ZGM1ibrmtBW5QY2EYMSO4eSgaF0W6j+duykw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022988; c=relaxed/simple;
	bh=O4sQGQU4b6fdPzFyaZTPQlMCOUzyLU24c2nhRqRW8Wo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D8LyR2KNJjT/QiL3cpUScxSvCDlXg+WzHLC37ZEWRFU/0NoLBU6Nt75i31oZ1aXgajMU0fR4kolKZpCjRZybUJA2F3aq/wJIv8ljZOxBIOWYR6QSOXGsja5Z3KfdPol+87NWfa2otqES4YXxsudxd7lZx84eMCn8mfzl5QOKYWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=cdJlwFs8; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="cdJlwFs8"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UiIZ3693335;
	Tue, 14 Jul 2026 02:56:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=/
	6Cb0dgXoIC1ZIaQTn5yCtTjRGgeiWdgD+BYAFNDpYA=; b=cdJlwFs8u9t285mHA
	9oboJdXPFsla36eWyOWXJ3ezX0TxuMwbzlR5az16W6EpImtpJQt5c/WvN4T+zSb5
	KKuVqlhgYg5pDUnIHNAG9vzFBR4BaufyxPVNXsAPRe3HNbqIm/H3nspif+VMVA4n
	LlW+e/M9+eGRqq0aINQJIDkTvAC55ROFJhvbdYPTNtv+meZ6fiV/fac+RrATriE1
	AVI+cgtXbvwTVDoMBCCX5+ML/h1e6oxqrSYqVevXwMsgrLn7wfR+X8zOMizxNd86
	oCkr87SKRZX/o/UmbnDudWY3XjMt4BDCbmE+ofwLsSlAYQZBTccjV+JXzBJL6z8m
	kDoDQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fbnbey8wj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:56:23 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:56:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:56:22 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 20B625E6867;
	Tue, 14 Jul 2026 02:56:19 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 45/56] scsi: qla2xxx: Fix 64G link speed reporting in get_data_rate
Date: Tue, 14 Jul 2026 15:23:42 +0530
Message-ID: <20260714095353.289460-46-njavali@marvell.com>
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
X-Proofpoint-GUID: ceSYP2MbLKmzpNhLMr67Oq8_deNH8pj4
X-Authority-Analysis: v=2.4 cv=WOdPmHsR c=1 sm=1 tr=0 ts=6a5607c7 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=utjVkuT23_eo-L5YqD0A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: ceSYP2MbLKmzpNhLMr67Oq8_deNH8pj4
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfXzI+0gyZLRlZu
 XmIEiQtqpoVGJXJQxBSM8gbiMrUENKwYxSQIAOMp6t49rGmCpnUOVe/L/pXs0bYaXSjojFRI6LC
 LvxSxJsm6Kwl2HdtSo677eWGKu9Z/5E=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfXx5tozyXepiO7
 T3/XP1UZmwH3JhMYT5RUQ5GjeeLO4/uCiR1xQODbmr3g92OEyaqbZMoESHVp5wWGKgaEnYfmZnM
 hXFZEas1cYKsKTQ0yam/0jCOYs9tEVFasYnJnRIJ2IJjVcnuc24D4CODU0Q3hMwXegcaSH8wjQl
 Npt0sN5yCkoKPoRymGYE3zRq9g5m0WNLRPkPaFcdml4zSSWeq40M1v6u/Ht2RdKMytUzAoE3/ZF
 U7Af54WLHPGsFR4ZtA2A7iZPAREO3EymTi5LvNikHdZZ4DgLo/djvczjzIZ5b6n1iOlYWSGtf9o
 Qd8w0Q2qiAOczWIDDvA4F8R2Y6h+aD+QuZ0VXzb9eDtWYpIAQKy7C7NxwSKTwtKp5FYmMLQlSXA
 WTOy5F0drpPovjiLYBKgxH5B/AQxCJo7xXptq1IXrDrzXe8tvivp8IITCzqEPD2TQCYAg+3dT/b
 IF7ub/hU3rOAlhVIKBg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

qla2x00_get_data_rate() skips updating ha->link_data_rate when the
firmware returns mcp->mb[1] == 0x7.  That value was a legacy sentinel
from before 64G hardware existed, but PORT_SPEED_64GB is now defined as
0x07 and ha->link_data_rate is decoded with the PORT_SPEED_* encoding.
On a 64G-capable adapter a genuine 64G link is therefore dropped, and
the port speed is misreported (port_speed sysfs, fc_host speed, FDMI).

Only 28xx and 29xx support 64G, so accept 0x07 on those adapters while
keeping the legacy filter for older ones.  Also drop the duplicate
copy of the check at the end of the success branch; it repeated the
first assignment with no intervening change.

Fixes: ecc89f25e225 ("scsi: qla2xxx: Add Device ID for ISP28XX")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ba822c196894..b32ca8ed274d 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5785,10 +5785,11 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 		ql_dbg(ql_dbg_mbx, vha, 0x1107,
 		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 	} else {
-		if (mcp->mb[1] != 0x7)
+		if (mcp->mb[1] != 0x7 || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 			ha->link_data_rate = mcp->mb[1];
 
-		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
+		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
+		    IS_QLA29XX(ha)) {
 			if (mcp->mb[4] & BIT_0)
 				ql_log(ql_log_info, vha, 0x11a2,
 				    "FEC=enabled (data rate).\n");
@@ -5796,8 +5797,6 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 
 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1108,
 		    "Done %s.\n", __func__);
-		if (mcp->mb[1] != 0x7)
-			ha->link_data_rate = mcp->mb[1];
 	}
 
 	return rval;
-- 
2.47.3


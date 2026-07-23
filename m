Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650523246EC
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783134; cv=none; b=cuf1HzahXTHzNBn8/f9RHP2m+m/tXpLdsEMjwc92z3mPxupW51PlWNqgMTItCpbDSb1rKo2cn+sG9D2Th+iVcTYmWLv+1VlUXp+ty96DFVbYgq9aW5Poh2NZ9ZWJlUnAQUBenAmDQ55PizaT3I+SDpUA54m/5uq5UmAuWRNoN1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783134; c=relaxed/simple;
	bh=Xfy9uLdNjUEc2nD+QPUu0NBTmq/9tt9lpIVRGQG/4pA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hctr8PtsOc+FvvGzpjv/aaxqskddbfrzbRLxxP5RSU0sVSin81dTF1Ta/9gKja/GFhEXxckJmgNQzSlHk/zpPIlywn8Nhu4T6gkKGAJeU9R/qomJH5aGKrs7LRLVsxgZ6+JNfXukYte42CwqJZ6d/wyTKtI6/87qseCRaWE3Cn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=RhSJU0/R; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="RhSJU0/R"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4wAFe486587;
	Wed, 22 Jul 2026 22:05:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=g
	IlgUz5/LX1h9XgPYAlGT4HN+RslK3jts+4+taAZt88=; b=RhSJU0/RVxdoZVb7H
	yi3rDyzs60nRzIMk5BGF+LtyufOwNs3XFLT6AY2+omX3AoWlvYd/O8g2FpFammsO
	U3FRRMvONKM2cKxGTb6a/OX2LY7FFa7YIcPGDYUPThZcfSRdkdht0owAieFbDlol
	tsNirIQRhNhq0u29MhuhbfKZ9a5FTbTWbQtP0XoXh90XyZ8EPBNI4rRL/gKKHG60
	2c6ClNXMkxptMpWjRsvCZ9NHm8xsiAJQ+CTT5AqglID5HWD0lo4uc9P2imRguMjB
	U+jtebHhTqIfCxAupg8OqAZWifwiJEGU2oxezZGNK3FG6pe/DP2xP5Xi4JFg4NBK
	QCi+A==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fjn9jurk1-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:05:29 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:05:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:05:28 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 15CE35C68E6;
	Wed, 22 Jul 2026 22:05:25 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 21/56] scsi: qla2xxx: Add support for QLA29XX in data rate functions
Date: Thu, 23 Jul 2026 10:33:38 +0530
Message-ID: <20260723050413.3897522-22-njavali@marvell.com>
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
X-Authority-Analysis: v=2.4 cv=Je6Ma0KV c=1 sm=1 tr=0 ts=6a61a119 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=5V5adwN8R4nwDDm8v28A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX+UCDHHm2HORf
 XHCju/+wo/+tZ+3ozRAL5TwQRx+tYWVSwNGBaHEOR5OHbrhU/ZcdA5cVrPTtwSjU2o4vbSRjhfi
 83/2O+mRhDu7ok+V8eKvzx+0Nu1koog=
X-Proofpoint-ORIG-GUID: SSdm1qZTbJrHXScKHwUKcPo1jipEk3x6
X-Proofpoint-GUID: SSdm1qZTbJrHXScKHwUKcPo1jipEk3x6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX6Y7d7ZHHp2KL
 NlSaoURxUXk1B+XOGKh8YgzMIf5KI0k+hfO75TerZN5OhJ+X2TnKebBw1thkSmz3iyVfuvi3ZsG
 7t+XqFaxJJhzVl8QlnZZzewMb2a+dSZNf8iYedSwx6PuewHcsSBohwm2/OsS21vNe5amtU8CxS1
 D9Fg/xqIWG3Dd6DbhY4a/FfKBxO4jE4ruHG00Sf0iscLF7ACxhatWqL0whWncggXVLbJG0WdWk9
 eMQjXMYFkyQ7QkZkuK34ZDOwGSkIxhnYzmgbnbPRyLfAC91swYCGD22L9ZW7I9Kw4mKAhI0Vsf7
 G5+5aGLOWmOjvfba5uVNGvYpdZ1S1NV4F+WpfD6qMIfacbHRhzPkxZIjlLytUrpx9LRKWvKCOYq
 eZd3Y52DGQrx89YqHy+xudkck8oic6GLyAWV1ZW3eoMLy8QLCH8uaC/PCvO/8BXc9StOYpGNw0Z
 CNZ9vdHiljVujEieFWA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

Enhance the qla2x00_set_data_rate and qla2x00_get_data_rate
functions to include checks for the QLA29XX series adapters.
This modification ensures that the mailbox commands are correctly
configured for the 29xx series, improving functionality and
compatibility.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 5a934f40323e..c32930f9e9f9 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1824,7 +1824,7 @@ qla2x00_port_speed_store(struct device *dev, struct device_attribute *attr,
 	int mode = QLA_SET_DATA_RATE_LR;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha)) {
+	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha)) {
 		ql_log(ql_log_warn, vha, 0x70d8,
 		    "Speed setting not supported \n");
 		return -EINVAL;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index a8dd01cb9a9a..c073dc35ef8e 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5683,7 +5683,7 @@ qla2x00_set_data_rate(scsi_qla_host_t *vha, uint16_t mode)
 
 	mcp->out_mb = MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
-	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		mcp->in_mb |= MBX_4|MBX_3;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
@@ -5721,7 +5721,7 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 	mcp->mb[1] = QLA_GET_DATA_RATE;
 	mcp->out_mb = MBX_1|MBX_0;
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
-	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		mcp->in_mb |= MBX_4|MBX_3;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
@@ -5733,7 +5733,7 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 		if (mcp->mb[1] != 0x7)
 			ha->link_data_rate = mcp->mb[1];
 
-		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 			if (mcp->mb[4] & BIT_0)
 				ql_log(ql_log_info, vha, 0x11a2,
 				    "FEC=enabled (data rate).\n");
-- 
2.47.3


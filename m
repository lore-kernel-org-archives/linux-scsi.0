Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B78915278E
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302218; cv=none; b=sFn7TUPY1+AW4cPYA/c3Jiu3B0/ZftEiiuWvG28qU8dHLzIQpwET2bAVPgkiTPZR1TXtlzncnM5VPjvdk8XgI4PT48uzOKLDhIzIppBo0Po2bm+Y5vptepRIriRKUGUE+WvQa8yec88gY3h++9kT1vffHEySZQqhBrlR3XxeeEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302218; c=relaxed/simple;
	bh=Xfy9uLdNjUEc2nD+QPUu0NBTmq/9tt9lpIVRGQG/4pA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XwoOVTVdACahQtS0xRBiEC6fNYC1t7xMtD2S/9eVnygvFX8+NSEXGuh2QkKPIbeZOU6YCpN1gkMaLlWz1U32Uc7Y/w42nHi/MD7x3d3aDavxk7I2UQM0npPUK3NWzx7iTvJvW2py8BzbT2XTb+QscZe/Im9Nnw7Yk+75gZspOVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=H3SyvALD; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="H3SyvALD"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE5Qm42729475;
	Fri, 17 Jul 2026 08:30:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=g
	IlgUz5/LX1h9XgPYAlGT4HN+RslK3jts+4+taAZt88=; b=H3SyvALDUwh7YE5+E
	2+F0earyYTjv7fDKd2B/PZPR+fVrKhKk7slCSGR5DZQmmPCtmA8+jTqcJ397gIdL
	JeR6Qvb4OkrxD/+OzgqGXEq71aR/wBt/t3uqOxmaKbqnGJS/nS7aXlqns4hsuTOB
	IknK7qVt4jEjCFnaw3yfSEcFlA4SE4aZVrC32JR/7HbskazyOS2BzB5294VNyXwM
	N/rqME9648B2g/3OvuZofRmx3LvTHXy9WLvhf0rHftA9sEY0ul4LBz03iNCrNlzk
	J7eRkKvuxKy8skdr/Oiixr37o7D28vGQ6SaA/QXsinyW9VZwZNqG9CfLWBt0+G7X
	kVlHw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fewjwmj19-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:30:12 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:30:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:30:11 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B8C265B6946;
	Fri, 17 Jul 2026 08:30:08 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 21/56] scsi: qla2xxx: Add support for QLA29XX in data rate functions
Date: Fri, 17 Jul 2026 20:58:29 +0530
Message-ID: <20260717152904.3155730-22-njavali@marvell.com>
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
X-Proofpoint-GUID: yDYP5d0EkbFW4-t2EDO3j_iluk-LnupL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX5nqkD0BmaCgH
 hYW+e5qb6l3niX2zZkjc8siadpLD3gIoQWERbeaX5Av0AeHO4rKzswzLcjXnZjn1tNNBKyM31Ay
 wVVlDQIci8EHYSwOe482ncV4bVQoXugA/jqFwVhQK2Km20vJCr/4u5SE7Ww1ZO6P1Fq1f8DM63o
 xWboGOpBdticRJpr/q0aXRMkSYfcQXxo9NRQDds3Gabxasef/35ApAc8TldsT3/fCQskc7+JsP9
 P/iGcNJQ1e9lZfAmy/sVst7h6mQY0fwiNetgO0wZlumIgkRaBy78fVzguhfCVyvTWT6N9ny1S24
 RkKCv9jSE3CV2MAfT/409vsFdVyJ+83p/c40O5coAQe9fGlrkgjXERO8BwT8/JMkrINIlPmpeS7
 genMXlzXzRJyA+quUG+mgKo2oz5F4oqtTZEg9ayVB8ZUz6hR7cfkPL6OfPs55I7MG2+TSdLpna7
 X/wt6a+uS0vf44p3Lyw==
X-Authority-Analysis: v=2.4 cv=Pa3PQChd c=1 sm=1 tr=0 ts=6a5a4a84 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=5V5adwN8R4nwDDm8v28A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: yDYP5d0EkbFW4-t2EDO3j_iluk-LnupL
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX9FR4ClggTLjh
 mYvaEmJ6RN3Ye0wi8R0vSAQqghMlDbo8JRkSvALOQskqD5mF+0rFspiIePou6I9VXBpMRv2DUl9
 LGA8bmJsOfsOv+juxM9HBSp66cmA2LE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

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


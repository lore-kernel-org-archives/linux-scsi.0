Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06BB258CE5
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258113; cv=none; b=bCgzx3IYBR874DOW/9ffFUm19cbqRlksY/j4/NKnhTh+Jxr07NX+XwWDq+fCOavD3dOmcU6pT+Bx1TrHIkCZrwTkWhtmO7BgOmPqk7zF2v6hVXkJx3f/zNg6po68cFydM4bgHKMSNYBDxqx4uJZ+8hOgEX/h0FmpyD6Iv5KAw2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258113; c=relaxed/simple;
	bh=RKc+U7jdA7OqVprf3r4MfRdJVmLh2LtW2aXvlEjnLU0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QF96HC9aROWzJB+9UqkybeDjAp5eo2FzyFdpXtio14Z3Knt9/YmXsVyL/Re8L2jQGmFkv+TUdDqRjddKZFcw59IPuYZ/9/IXCapVYMUD0v11DI9iNIp6MDM/7pAp5gNSKHEbZpBOaCHXo/tCDvMqAEjkVktdLM9PNFdOzuNELgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=CKEZUFOy; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="CKEZUFOy"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C399013678829;
	Fri, 12 Jun 2026 02:55:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=9
	tPytRP0leMrylVnJozf4Id6w5vKUQsXq2sc7HBgrIQ=; b=CKEZUFOyO26YVC6dH
	CZT6HHN5on97qT07F6aXOwnjmKZ6JNavkbvsyKcohIyQeZwR/oIt3gu2Gr1A/K3O
	g5gLOAq0xfPT8KRA1bxDEwAt3UMNOIrC0kVLlc/0SjLxEwUqpBC2DlQdggjT3Bsy
	hTjnr9WI30Mr0kxdiOx5k6J3RvtlKmEAYLfv3J8ZfMCf3VgpTz9Sz0n9rJhSOk2O
	Ivg1bRjq6KPUtUQbN8hwnLxNG6Rz+CFOcCk+de6ioqZprZWD2wuT5RPLfBvoz8eW
	ghTDXeoF4xEeIfZr5Y5ZtFpg+gnz+d3v0TdSJvXUDeG/IXLOH6vwqh6XwP/qQ1mL
	Fzz5w==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4er9qn92j1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:55:08 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:55:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:55:07 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B374A3F7040;
	Fri, 12 Jun 2026 02:55:04 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 23/60] scsi: qla2xxx: Add support for QLA29XX in data rate functions
Date: Fri, 12 Jun 2026 15:22:56 +0530
Message-ID: <20260612095333.1666592-24-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: 6RbAMv-6ChCTSHtkT0-80J_lanuFdHys
X-Authority-Analysis: v=2.4 cv=Y9HIdBeN c=1 sm=1 tr=0 ts=6a2bd77c cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=5V5adwN8R4nwDDm8v28A:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX2BgR9s80iSR7
 KMzsNEzEmU4f7UbchyJFqsLmlG17HRrvU7itdmOu5qs9zMW8WnJOKmEZqkd2cge/fMzQokx/15F
 LyFNIHyM6lWTiOAHKMzKGE4qusncywQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX3Vazv+jv8sqh
 aGTxXWenix1WbFxchUd2wcM3/MVGL2eM05aVwjJ0btl58BzAEOF5m+ywu8Hkl5uvZ1GBZGxHmoT
 SiTyxjm55gARWd7xvQ2b8QheSoJ9oZ1A3YAtasUqjw9BBQFLBDPRWPVqIxPIFSFyhymGUEnzgfi
 dkRzuSixyJAyyC/wFykjAnCo32/OdHn/3fp8ExUFLTaRn1zeQlI8vA99utZwROoDpLwfEzESZKu
 065QROv3xKuPm+1VgSayumLaNAHSXCMt3Y2xhlnKhqqzVHbZaz8Tb8c4RRNT04LJBi0LlkSGzQN
 4eZAGH0ZruZNl6/WCXoMwXtXO8nD9BjvrF+03rQZwao5pvk66RZI/DBIZRe3aghN+yE+/atTalm
 dBRaqe6QXbSzuTbKZTjXA0uzvVfnDAxGi1QceTPVgtajhCopNILDW+ROtkC5yZVgovvczQ1ERn9
 tVdHcBQ971HVlyQDiFQ==
X-Proofpoint-GUID: 6RbAMv-6ChCTSHtkT0-80J_lanuFdHys
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

Enhance the qla2x00_set_data_rate and qla2x00_get_data_rate
functions to include checks for the QLA29XX series adapters.
This modification ensures that the mailbox commands are correctly
configured for the 29xx series, improving functionality and
compatibility.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index ee6bf8302991..37478af9cdec 100644
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


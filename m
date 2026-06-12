Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1AB364EB6
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258107; cv=none; b=Cdyd0o2zZ7JQO2sckLkW3jZp+J1NXBxwC14YpPZmkIdVcGbY/kJjZ3DKEmzzZszY59YyB0XyUH9iaaQVQ2u3+PpdBJHcf8fU2tEum1kSnv/lywNz47/fmIBkxnJa2dhfetEbZyqL+JEJuEYmAUeK7JHUuFCqIpp5+/FicKh6r7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258107; c=relaxed/simple;
	bh=E1afuDc2WmIAqSihZt+sSp5GPv1hqDAH++3Ot3WIJh4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fHXTBXtMqwnUN5pKM2s5IDSOpwjjcbWUXLchZhEUfv7kBDCk4AWycOi+2Mk4CmUnwkGbBYpvd7/jBK6SxiC2Kmz890ZB9UgiDeH+EWRmp1UbJTd2qrgEssyhAVjjbz+DXHihcPYlrT0+cxmUJHzB4f9cRncMNguU+QFOesvtDfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=a4N3t21I; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="a4N3t21I"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C38rYe3678283;
	Fri, 12 Jun 2026 02:54:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=S
	W9OKWEjEiDdsQhe4zsZaeSzHTarKHe53/YgcA3zWq4=; b=a4N3t21Ixb5eYcohX
	ojd6lXur1n7FQ+CZ+uixdC18fQRlaVUsi6pICWy/bAW+paZle+iJDQ/UE2+Upug1
	6Gta7EAc/Vbm6KfdBbtbjkchlLSn5vTM40Gx3joF6W4E3pFhqbDkCRy2B77hGXGO
	x8SN0fvrTEprwCKR7qe/IzIbf81iU04HZdayH0NqgE94G12cquQQfo8xnFSMlKU8
	796j3MPg19OqN7AUXkoGBDJPzIAW3pEXDGmWP7MEltHmAejELIJfd3Cgbinz3TyH
	ztkLT3MKIB0DKnqgWJF25fmqrq8AYlaCyNPgZkp4d2psTMQexeADfGZRLCvHveqy
	W+T1w==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4er9qn92hp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:54:59 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:54:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:54:57 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B573E3F7040;
	Fri, 12 Jun 2026 02:54:55 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 20/60] scsi: qla2xxx: Enable get_firmware_state for 29xx
Date: Fri, 12 Jun 2026 15:22:53 +0530
Message-ID: <20260612095333.1666592-21-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: b6bcaXHX2Aoo2JPXMGi2jZEdbp8YjQOi
X-Authority-Analysis: v=2.4 cv=Y9HIdBeN c=1 sm=1 tr=0 ts=6a2bd773 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=jXld2Aqxrx9nTAx2xuoA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX3Mut/j9Yho9W
 ay+o6ugldTF0mqAMwsu1Qobz4Ng0D5Na1RkN7Crb27EG7i6Avo8EXQS7Jn9hIbh+z844W4nI0Bl
 /GJaCvo2cw9ucvPldlpmKF6Rsjy8/4c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX98vqaDFSdJTY
 akTIBKXRpYe8Er7Q4iiQLCbM/RRf/hp+44RJSeiEsoBiowyukzNC4t7/91uwUI682dqaztspxNe
 kYFmb4rhCapf+wE15VwivIOGE+Z93ObZRKJooZQvlfGXuWVGYAWoVPx+RGN6SJfCuSq11dCw02g
 OyQZ+w3A2PMsXt2thIjnJ/O8lKHG7hUKXmZUQlU/zCSNfRVlBWKoI9WrjQ4GXX2EtSFHWXCkkoz
 TgFo+OWjSrVyGjYlZbZBkZd8HzMOQBp2KY+BVu240VjOlm/qnhH5FjRzeywm0tx4lkT9DDSmH/g
 mE4DIwDFL3184QLReB5S1/6E7za6eLBGc6FyRFxK1aJ8eU4P5xBZpBK4jGR612ttIvdFSDR2nrF
 drjUL+W0xfZ4GtTS+7Uh8jH4aEPMu8Q2fK8v6OzXqgyZMf6n4WuXfz14TjqwxSnXn4uIAui1VDa
 so87pynuDV8RU4IE4tg==
X-Proofpoint-GUID: b6bcaXHX2Aoo2JPXMGi2jZEdbp8YjQOi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

Enable get_firmware_state mailbox command for 29xx adapters by adding
IS_QLA29XX() checks alongside existing IS_QLA27XX/IS_QLA28XX checks.
This ensures MBX_12 (MPI state) is properly set up and reported for
29xx adapters.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 742becc0dadf..ee6bf8302991 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2436,7 +2436,7 @@ qla2x00_mpi_fw_state_show(struct device *dev, struct device_attribute *attr,
 	u16 mpi_state;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!(IS_QLA27XX(ha) || IS_QLA28XX(ha)))
+	if (!(IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)))
 		return scnprintf(buf, PAGE_SIZE,
 				"MPI state reporting is not supported for this HBA.\n");
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 9c78aa66e12b..a91ac59dd9c0 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2283,7 +2283,7 @@ qla2x00_get_firmware_state(scsi_qla_host_t *vha, uint16_t *states)
 	else
 		mcp->in_mb = MBX_1|MBX_0;
 
-	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+	if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 		mcp->mb[12] = 0;
 		mcp->out_mb |= MBX_12;
 		mcp->in_mb |= MBX_12;
@@ -2301,7 +2301,7 @@ qla2x00_get_firmware_state(scsi_qla_host_t *vha, uint16_t *states)
 		states[3] = mcp->mb[4];
 		states[4] = mcp->mb[5];
 		states[5] = mcp->mb[6];  /* DPORT status */
-		if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
+		if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 			states[11] = mcp->mb[12]; /* MPI state. */
 	}
 
@@ -2309,7 +2309,7 @@ qla2x00_get_firmware_state(scsi_qla_host_t *vha, uint16_t *states)
 		/*EMPTY*/
 		ql_dbg(ql_dbg_mbx, vha, 0x1055, "Failed=%x.\n", rval);
 	} else {
-		if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 			if (mcp->mb[2] == 6 || mcp->mb[3] == 2)
 				ql_dbg(ql_dbg_mbx, vha, 0x119e,
 				    "Invalid SFP/Validation Failed\n");
-- 
2.47.3


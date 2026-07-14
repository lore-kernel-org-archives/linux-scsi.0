Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0D018DB2A
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022906; cv=none; b=n5BALEYt2u79dskxmynHtoj/DfygWUf0MI2s1prACEyXZPQq4D2Gj/SfztcRvhVzArY6/BScPFWg8WPYYoubNNfQ8PEFGLG6ERa5yXcq9Yf35CJYAgY/lXHWs7d9pmcb97YQbk4aYATNdcRU95Yz5fu6vGuf+fuqBYrNP2MmnLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022906; c=relaxed/simple;
	bh=5Uv2VISuFc1Jw30YYEiSN3UTSTHEIOyzev20Aup5LmY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U8O2/j7LtZ9yBY86NpubEC5lj/qxUsBPjcdPdNlCs2DFPXKJBN4FaWJH1sEP2OO8ihiNyiVz3YB6svxFhbjVRqbYh6vgNdO8WznefOilnxN/6imtBj+7250xGYS6+H/ONVCXAONxNvmkF6qc7IQAAE0jyqQ3AZtibtircGF9sxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Oi+Y8Man; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Oi+Y8Man"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UEdM3668030;
	Tue, 14 Jul 2026 02:55:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=b
	bDQoWqcIw8F0oDgP94QVM68xhJfvX/JABEGzuMRVV4=; b=Oi+Y8ManKGt6FIaEG
	fGDPoTzE1I25lx3XXJ0/h7IHxJBlmfdihnBwAFlsImItGmSxTZZBICdUlSUKWeBr
	PZJsTA+Er7F1Yfm3PZhaEe3P6D5OWyX0BrF3eSqf0GbNNGaKBtCCw+JxzKc4xk0w
	T7amYoV2VzhujhYBkH8rO7tgnN/t6kDRr4X7ub6N8NBz+/9vowibUT/4jwTjaNfw
	LSaG4lL0w1PQpnzskP3MtPicwT0iW5QHXFwLqwClBlfms8aiNfIRKkOfvjJXTxW3
	u31k4QJ+/LH9Kh8iaP8awpCW0OuS+7JRtUvMKxKuKBXMnk3eS11GqCfN5uiGSxOJ
	SxnSQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fcwvc3ems-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:55:01 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:55:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:55:00 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 409315E6867;
	Tue, 14 Jul 2026 02:54:58 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 18/56] scsi: qla2xxx: Enable get_firmware_state for 29xx
Date: Tue, 14 Jul 2026 15:23:15 +0530
Message-ID: <20260714095353.289460-19-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: _asoVD1548PCBczVP0tBahGtzFw-5UOS
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX8WqCJlj9VcAP
 1yGjHew2MEULSVpfbGHk+juMmFg/Dc97evhFWXuok+k8E0wLi6PiL+LMe6vciFkcKMGW5FeJW0D
 0PYE2xv9sjiPN1B8aMMpfvyq0FGMKUk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX35nMDe2LJlA/
 zjtODjeg3qkc2bT94rWNIgvvEVMEWLpOKZvJwSG50deqicyeAxp8pzuD5ltYKSntU2d9lBe9wvb
 1r3fqQikMQl6w7ED+yk8xD8RSeHklrwFJBYIUgK6ba5IZjKtXFvo0SX0LbhpGdaZYso1zxDTXdO
 WTsbi3j9pg9SnJv/eYwDDadgPo8PGOYU2IK3pxg0Uzsass7DYZPIu+J3HQ1dls2x7eh55V4lWiK
 GmZxoNwe2lNE2eVVZqSFfk4o6pnrctIgUfk/tGSZTCLenLbYvZxGlY/CWM3GCCZKhBj6XDRjmNw
 ipgKtjj1S8Vi1ULu8M4f2/mp3xdKz3z/B/guQRpTPUSPgwK7Lwgoci9zbG4IEWEgbmLAHRWNjCj
 HviUfRuUse3nDeVTwTLJXu2BzDYkhah6Nu+2CchphR9d6EsiAQWXveLfuyVygeCVtcLxbyAO1PN
 +zeMlquZvhEQVrh3j4w==
X-Authority-Analysis: v=2.4 cv=cIXQdFeN c=1 sm=1 tr=0 ts=6a560775 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=jXld2Aqxrx9nTAx2xuoA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: _asoVD1548PCBczVP0tBahGtzFw-5UOS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

Enable get_firmware_state mailbox command for 29xx adapters by adding
IS_QLA29XX() checks alongside existing IS_QLA27XX/IS_QLA28XX checks.
This ensures MBX_12 (MPI state) is properly set up and reported for
29xx adapters.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 7b7722de2844..5a934f40323e 100644
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


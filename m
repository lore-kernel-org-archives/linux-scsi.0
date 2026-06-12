Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0DD258CE5
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258091; cv=none; b=SCspnuWeZPZtith77OWEq+sIVWJ3vIQ7cdHcFUWVeDUUv9gVhN8BCNDLYDLOwc6W3+r648XwVBjIpoEWdEP5OCYyVwNtDYY2PfnFvh5NtuquDC2qwz+OPNJgYeXK8Zu/6VivVtshQs9k6Q5bu6PwVn+1lpOstN/cdO/32wMtYXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258091; c=relaxed/simple;
	bh=ipI6DnAEU0FNu4z8t6eIcHNT1alEsSy/MOsgGCRRM/k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S5EeOkgNuRTvwcOPS1RJllnMPB7ZCKcerMdpnWrIJ2MokdicYk83O4l8eOJlVAzgYcTxJ/+EZuFKU4NeYeAuNxt4pn/bc4n/rtwWsExXPOvy6YL8QVG9nyWXzbR9KIyBNT0UMQgpl2hRRW946xHZHNWzPuYzNBsBFPuS/obTkv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=GXwyIPVt; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="GXwyIPVt"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C3ASqb071190;
	Fri, 12 Jun 2026 02:54:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=j
	Ez6/7OHFCP+cuGe6SwwHadGwrFC90ekE2V+yQhZckc=; b=GXwyIPVthmHNw0g3h
	xY3PPop5dvnasCU706cDV8wjtLO2Fee4vq7nxJlSqUXDMzoO88ZgHVD1lYJryDYe
	SrTIdNH0GBjMoSvsxFCKCam63Mcv8uVNh3CCCBBy1kFLCysJtmIpD7wPsmbVsvAZ
	dwMQsu4xQF1oFoXlBHpTu3GFTyBtfPrZBWbuUZkomfaa39sUheFzG9Ko0QBcYBE7
	9FSov1p8YSlwT2JkyrMHZ0+Nt6ohqmFhP95FcYAyRoGk6rkzw4yYhhUBZzJBut0f
	/HkFGSO6Fbk4CSeUchKiGj6YphjgzlB6Ger7EwvqKTj5CpmwCZHUg4aqm4IvlW0H
	lf1Xg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4eqe5vxrk9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:54:47 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:54:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:54:45 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 2A48D3F7040;
	Fri, 12 Jun 2026 02:54:42 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 16/60] scsi: qla2xxx: Enable get_fw_version mailbox for 29xx
Date: Fri, 12 Jun 2026 15:22:49 +0530
Message-ID: <20260612095333.1666592-17-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX6fCdSyMXZ6yh
 l5PK3CZXWG+A3x0KXLe3qaOAXKNCuUS4FaqMkFu4YUXHlHFmq5Bx5K9P4+X83wgBPRyLYgLBow8
 a5ryVEJoVkMBpSY2IrSqyCr77io9R3I=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX0rqAMDJs94PQ
 RnjsZVbsr/FNg2wQVRniioCf/k+w0Z2Wcx4FYRhukRGZmbrm/5DlNFMNyQ4K5XVfXhiVHMCnHqM
 ZmzBCtdaHfNBrvvCYyEIMcwghNtN8YiTiz/EH4C+JzEsqegClQFxerv1OaxaKYveKoZZXd3r2v5
 JGItg2ZY6tVg6YRks+CUJPucVhxoHh+RT5wXY1O1gtJeNKzAKfjeThz68RZA2sHApsErilAq1fO
 y0b0w51yq5kcSHPoxwXqT/aDkq7FHWbR9B3DOmWWCS6vPGJIdwtiNNDJtTpaZtqIkYdHRx/9j5V
 p28Pdzf33Pk0U590gBw5cGW6m0i3KGXoqQYzG1Ja57Z1aTrUC6ilodHu3WVYtQeyCU6dMsc3Sgo
 Bo8Qxt1Jw/jKqUTj0C+mDHmXkk2OVzSgNJhEg/cMP67MGLiAY0w9kNHqzLTbRj3/0hjrZhRqhfo
 xhFIBKJ4jAwAIYpZTzw==
X-Authority-Analysis: v=2.4 cv=UPDt2ify c=1 sm=1 tr=0 ts=6a2bd767 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=nMT6ZNUuZrDJHrgKV8cA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: tgHeZvu9PRi6EvHvoydb2roS1avbRfq0
X-Proofpoint-GUID: tgHeZvu9PRi6EvHvoydb2roS1avbRfq0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

The serdes_version and several firmware capability fields were not
populated for 29xx because the get_fw_version mailbox path
excluded it from the 27xx/28xx checks.  Add IS_QLA29XX() to
the relevant conditionals so that firmware version, EDIF, and
serdes information are correctly retrieved on 29xx adapters.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index e8755ab86b6a..3bf7123fe057 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1526,7 +1526,7 @@ qla2x00_serdes_version_show(struct device *dev, struct device_attribute *attr,
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		return scnprintf(buf, PAGE_SIZE, "\n");
 
 	return scnprintf(buf, PAGE_SIZE, "%d.%02d.%02d\n",
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 9c2633ca5036..0feb98b83293 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1136,7 +1136,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 		mcp->in_mb |= MBX_13|MBX_12|MBX_11|MBX_10|MBX_9|MBX_8;
 	if (IS_FWI2_CAPABLE(ha))
 		mcp->in_mb |= MBX_17|MBX_16|MBX_15;
-	if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		mcp->in_mb |=
 		    MBX_25|MBX_24|MBX_23|MBX_22|MBX_21|MBX_20|MBX_19|MBX_18|
 		    MBX_14|MBX_13|MBX_11|MBX_10|MBX_9|MBX_8|MBX_7;
@@ -1212,7 +1212,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 			vha->flags.nvme2_enabled = 1;
 		}
 
-		if (IS_QLA28XX(ha) && ha->flags.edif_hw && ql2xsecenable &&
+		if ((IS_QLA28XX(ha) || IS_QLA29XX(ha)) && ha->flags.edif_hw && ql2xsecenable &&
 		    (ha->fw_attributes_ext[0] & FW_ATTR_EXT0_EDIF)) {
 			ha->flags.edif_enabled = 1;
 			ql_log(ql_log_info, vha, 0xffff,
@@ -1220,7 +1220,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 		}
 	}
 
-	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+	if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 		ha->serdes_version[0] = mcp->mb[7] & 0xff;
 		ha->serdes_version[1] = mcp->mb[8] >> 8;
 		ha->serdes_version[2] = mcp->mb[8] & 0xff;
@@ -1234,7 +1234,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 		ha->fw_shared_ram_end = (mcp->mb[21] << 16) | mcp->mb[20];
 		ha->fw_ddr_ram_start = (mcp->mb[23] << 16) | mcp->mb[22];
 		ha->fw_ddr_ram_end = (mcp->mb[25] << 16) | mcp->mb[24];
-		if (IS_QLA28XX(ha)) {
+		if (IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 			if (mcp->mb[16] & BIT_10)
 				ha->flags.secure_fw = 1;
 
-- 
2.47.3


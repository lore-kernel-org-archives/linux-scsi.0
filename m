Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA3D176FB1
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302197; cv=none; b=Y671/Uwpd8aUxan2ue5aD9wW64+Fh6TT7ACBjbyNeu31nkwhXwa172JTjNaoF24zf9wtw60Gt3dbLfw3thsGulDd5E7vLn3Ug8d/y3ddJhWVK9Y6YWRLrclHcN2i4A7jbAY1QnR7l+dNRoqx7FMLLRm3p7JgmjJN8HW/gB39hPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302197; c=relaxed/simple;
	bh=+QvULlatdvMHv9pECySc0fcJvPRzpEAKvqRA8XtQDho=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cGF5eIithMDfyIISS+GuiQlNGx4djCGzm6QY9hPF6IrAJFUkxaFr15spO1exOsEwIg5H427CFM19V8RNWkC9lxvn0IUEIcC1GhwADjicP3MM7DIkg3IDBpjIWhNNhm6LROSjx5V0W5Zsufo7J85VmGD/Nq0ZLx0ZZWHoiFoVM5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=gVCpiZqJ; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="gVCpiZqJ"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE4Ut02774305;
	Fri, 17 Jul 2026 08:29:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=w
	1q1cOpG5eFmSjjtGeSG+HSkDtdRC5QcyYRP69HvUj0=; b=gVCpiZqJrK/Qu1izb
	XLGoBjh/x/hpalJ+3bIE0epPhrLR4ylahg59aBMa9MQ8YJMF9fcASPhtaGoP6XbU
	Z4Dm8GfadxYXKpPHtn6EI1+TEJ3l/jaMDvpwP82SuAfsqyvdbd3XEqGrIBeO//tw
	QrIu3zfHbrYB5gWIjGDINhNva50MDrShNWQBnLn46wLZrMHANtXA2lqgETMjbSI5
	p1Zd4AxBf3GBMrSb6U5TCx/Qdeh3/q7+fWy+iF2Mg4MXxKK/qCjep3lNM/bJHHgQ
	ahbTDTvc1Ewx7n8va8RnTX6S3sScqLRcfFJxwUU90t3x3cJomJIX4pxkCrFwqe2H
	ULUFA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ffm6p0hae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:29:52 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:29:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:29:52 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id D275F5B693B;
	Fri, 17 Jul 2026 08:29:49 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 14/56] scsi: qla2xxx: Enable get_fw_version mailbox for 29xx
Date: Fri, 17 Jul 2026 20:58:22 +0530
Message-ID: <20260717152904.3155730-15-njavali@marvell.com>
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
X-Proofpoint-GUID: fRd7qwOuBLicd2-4SpyxQmHoZnDSEqWL
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfXzw0PEZgYY4QH
 LtA29Z9L2BrpFWzkwyEuDGMMM+9jAVkd4PhtSPieb1nCqhcK8rCzFDWRxqJLJ7NvtlCDnrEu7YW
 mRbRQA0EK/7GqLOpT3F7odVPRWGUpI0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfXzdLRyLzRKslI
 K1TUFcHzT6IP9V+RHivEUUIPrE5PjONiTZO4RLWllzpQO+wi9Aa9eVkIORqtEcjGOZ+NVhIoD+0
 4Ypie7eZE1rC4CABUTeuMJ2b0dYqyUoQoa7+D7C+XcZumYuicdyt3PPMy1Ul+8jlVcYn2QfHgsw
 cJ71+9fXXpcg1Jq3uTC601xL83XMUK+NY747foztPjN6ylPEE0ZNB+jrBolpubTe7y0DirftBFi
 5gD6frc1/lTb63c6IqlQhkP/+oU8wG3nm1QtPFDi8FLnYOlnajBvVLg/g8aDv3QqSAFU6J0MLSK
 NI4RiSwtBs2XFQOAdhAYQOn3iZT49Bs8aa/YD0YzTeMB7g13cIhLTDkHeXJSrJILtVyPQkbb/Py
 K8jEMSII+fpcDvWCYx843CXHicBEbjToA0gjHAwgOpNr2emHGhU1sSSxuzoX35ryw8CT4PjHfSG
 tgAHsJd2QOct67JhjsQ==
X-Authority-Analysis: v=2.4 cv=Wa88rUhX c=1 sm=1 tr=0 ts=6a5a4a70 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=bXaJlivqrgYIT1gw71sA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: fRd7qwOuBLicd2-4SpyxQmHoZnDSEqWL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

The serdes_version and several firmware capability fields were not
populated for 29xx because the get_fw_version mailbox path
excluded it from the 27xx/28xx checks.  Add IS_QLA29XX() to
the relevant conditionals so that firmware version, EDIF, and
serdes information are correctly retrieved on 29xx adapters.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 4 ++--
 drivers/scsi/qla2xxx/qla_mbx.c  | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index e8755ab86b6a..c44f5282abb3 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1526,7 +1526,7 @@ qla2x00_serdes_version_show(struct device *dev, struct device_attribute *attr,
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		return scnprintf(buf, PAGE_SIZE, "\n");
 
 	return scnprintf(buf, PAGE_SIZE, "%d.%02d.%02d\n",
@@ -2386,7 +2386,7 @@ qla2x00_fw_attr_show(struct device *dev,
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
 		return scnprintf(buf, PAGE_SIZE, "\n");
 
 	return scnprintf(buf, PAGE_SIZE, "%llx\n",
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


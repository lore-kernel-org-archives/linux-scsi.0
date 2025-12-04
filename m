Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9974B2C027E
	for <linux-scsi@vger.kernel.org>; Thu,  4 Dec 2025 15:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764861496; cv=none; b=nq1L9w48C2i4FzzmODZqcfsm4FhLFhmJmYphyLOaD1uM9AvowpH0k+uHWwZbFSlZkpietG7QLOkP0x21wCV0YCq0jJR1YSjkeOHYOHKf46mBAFzmpM06HuEgdGVuN+OA05VkckPZLQwhSl83nuAAbLyZnVa1QU8PkeLP8hH3YkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764861496; c=relaxed/simple;
	bh=PbHKovYo9LnRHX6JfUp2DjWtwH8I6ZcSvfZcvDlK3J8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mSQ6PmOyxYiU+TiRFdy3P59GBLY3J2jC6oTw9M3FgL2hM3XfXGYZsozCQHlUQGt97mP5L94vV2cYLdl4liAvSEhQVR+IC6wXGqIwOb432JaemGnJpvpjptBAoYD7hQpjV5mkPsDAhS+mvsih4tbj4c2FVdTH1mZmzjIKuTTXuuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=icr8tTIa; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="icr8tTIa"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B3NrmJ31015282;
	Thu, 4 Dec 2025 07:18:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=y
	dVyYtQoQmGRhkSyNxAS5ZYXvKA80A8wMtRo7pzDHXM=; b=icr8tTIa/kBfZvYU7
	kZeYJ/YZjDlCg3Ct7VDJXra23cZLXAY2M6Qls6XC8kj0SvgqXSv7T6s75KDIN39w
	vgQgR+OEcOyv0xOD7nG08qWCXyP/IA3Pj/DU/iDFBMOY+1RlXHiB2fgVszVqI0lE
	+zoGA9lNn4IolvDjE7gbhFvhXYb7Mk/QskUvtUUSwq050OQ5XnnI5c0m0zY06F+j
	dFlvK5iV46QsxiD+i8mJQ6xk7VQdilySTjad619+d/V3NO6DhGf2jUpYOpbktIba
	8PSv7T1Kn7DGRAD8lO4Kn0WTh8vKakF9ApBF59J/KY0Oyu9U7uLUb6K7ljAhsPIa
	sE71g==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4atjuu3n44-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Dec 2025 07:18:11 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 4 Dec 2025 07:18:21 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 4 Dec 2025 07:18:21 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 9AFE93F7090;
	Thu,  4 Dec 2025 07:18:06 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 04/12] qla2xxx: Validate MCU signature before executing MBC 03h
Date: Thu, 4 Dec 2025 20:47:43 +0530
Message-ID: <20251204151751.2321801-5-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20251204151751.2321801-1-njavali@marvell.com>
References: <20251204151751.2321801-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA0MDEyMyBTYWx0ZWRfX0/fcf41aSO/v
 Xst6XFl4GbKV6hMiGGWtYpsD+FgSfMJDzn/OzPZvP0fDDLspfut4Hj6/lb9YzjBSyYHYSDre1P2
 sf2LjSgFPzFvG3G75JHzw228fmrfyTRxKf7tEhFeHYVFamBuxkDNQFoRQwasE2B5qduyAmE5hTF
 wbhOL9i1o1vhptRGLor2LfCelmELHFXImRn/jamB89zZlyswcr9JvGZv53X1lC4v2XXqOArNj74
 71xV+RfCe611M0+GNvVOZKISdt78fJL3QMzctfH/2AeGKnOMa1EKaZ30YfZ9XOMTW8yoEdBmh6O
 POtgy+sXq1k59kI2voXZFnzOFIiAL2VZ83comxaMycKoCYhOWh7SphbwwXW+eURJ55CUhT7ZtIa
 qVr9O7wSTO1ivuBPg5AIptIyUikuKA==
X-Proofpoint-ORIG-GUID: a9lGg3StyqXUXi1Ed1CsD56ylcmZvZaQ
X-Proofpoint-GUID: a9lGg3StyqXUXi1Ed1CsD56ylcmZvZaQ
X-Authority-Analysis: v=2.4 cv=E/nAZKdl c=1 sm=1 tr=0 ts=6931a633 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8 a=pGLkceISAAAA:8
 a=HMVHDlugHIozVGofra8A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-04_03,2025-12-04_01,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

FC firmware does not come online during on-the-fly
upgrade i.e. on soft reset.
To limit Load flash firmware i.e. mbc 3 changes validate
MCU signature before executing MBC 03h

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |  3 +++
 drivers/scsi/qla2xxx/qla_init.c |  2 +-
 drivers/scsi/qla2xxx/qla_nx.h   |  1 +
 drivers/scsi/qla2xxx/qla_sup.c  | 29 +++++++++++++++++++++++++++++
 4 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 184a66b8633e..cac4745b012e 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4151,6 +4151,7 @@ struct qla_hw_data {
 		uint32_t	eeh_flush:2;
 #define EEH_FLUSH_RDY  1
 #define EEH_FLUSH_DONE 2
+		uint32_t	secure_mcu:1;
 	} flags;
 
 	uint16_t max_exchg;
@@ -4416,6 +4417,8 @@ struct qla_hw_data {
 	((IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) &&\
 	 (ha->zio_mode == QLA_ZIO_MODE_6))
 
+#define IS_QLA28XX_SECURED(ha)	(IS_QLA28XX(ha) && ha->flags.secure_mcu)
+
 	/* HBA serial number */
 	uint8_t		serial0;
 	uint8_t		serial1;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 82879fb8b565..4582a92c742a 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -9058,7 +9058,7 @@ qla81xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 	qla27xx_get_active_image(vha, &active_regions);
 
 	/* For 28XXX, always load the flash firmware using rom mbx */
-	if (IS_QLA28XX(ha)) {
+	if (IS_QLA28XX_SECURED(ha)) {
 		rval = qla28xx_load_flash_firmware(vha);
 		if (rval != QLA_SUCCESS) {
 			ql_log(ql_log_fatal, vha, 0x019e,
diff --git a/drivers/scsi/qla2xxx/qla_nx.h b/drivers/scsi/qla2xxx/qla_nx.h
index 5d1bdc15b75c..8e7a7f5f0adb 100644
--- a/drivers/scsi/qla2xxx/qla_nx.h
+++ b/drivers/scsi/qla2xxx/qla_nx.h
@@ -892,6 +892,7 @@ struct ct6_dsd {
 #define	FA_VPD_SIZE_82XX	0x400
 
 #define FA_FLASH_LAYOUT_ADDR_82	0xFC400
+#define FA_FLASH_MCU_OFF	0x13000
 
 /******************************************************************************
 *
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 9e7a407ba1b9..b6c36a8a2d60 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -1084,6 +1084,32 @@ qla2xxx_get_idc_param(scsi_qla_host_t *vha)
 	return;
 }
 
+static int qla28xx_validate_mcu_signature(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req_q_map[0];
+	uint32_t *dcode = (uint32_t *)req->ring;
+	uint32_t signature[2] = {0x000c0000, 0x00050000};
+	int ret = QLA_SUCCESS;
+
+	ret = qla24xx_read_flash_data(vha, dcode, FA_FLASH_MCU_OFF >> 2, 2);
+	if (ret) {
+		ql_log(ql_log_fatal, vha, 0x01ab,
+		       "-> Failed to read flash mcu signature.\n");
+		ret = QLA_FUNCTION_FAILED;
+		goto done;
+	}
+
+	ql_dbg(ql_dbg_init, vha, 0x01ac,
+		"Flash data 0x%08x 0x%08x.\n", dcode[0], dcode[1]);
+
+	if (!(dcode[0] == signature[0] && dcode[1] == signature[1]))
+		ret = QLA_FUNCTION_FAILED;
+
+done:
+	return ret;
+}
+
 int
 qla2xxx_get_flash_info(scsi_qla_host_t *vha)
 {
@@ -1096,6 +1122,9 @@ qla2xxx_get_flash_info(scsi_qla_host_t *vha)
 	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
 		return QLA_SUCCESS;
 
+	if (IS_QLA28XX(ha) && !qla28xx_validate_mcu_signature(vha))
+		ha->flags.secure_mcu = 1;
+
 	ret = qla2xxx_find_flt_start(vha, &flt_addr);
 	if (ret != QLA_SUCCESS)
 		return ret;
-- 
2.23.1


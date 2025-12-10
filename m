Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF303126A3
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 10:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765361799; cv=none; b=HpUxr/eDqfAMe6MogGtboYnAnpX3cq9y0YW5r6jRJGNcaNPdTeqEgYpgNSFQlHdbLEELgjGM1aA4Kh8+hd9TI9oBrNQyYv8cAoeiObthWxZMMyvh+32uva23mzRHweaFs/iOfpI1T4n3EUPywDzmWaBKEIIgPQujOth9xS6odWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765361799; c=relaxed/simple;
	bh=PbHKovYo9LnRHX6JfUp2DjWtwH8I6ZcSvfZcvDlK3J8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fHTZEQVezP93+FZswoZYPCOeuqYLCH8v3nFIHZoaYVfgSaMbeENo3lGZqomBgHv53hx27iu9cAWzGJQs8uFxEi7qjIRNbQABIsom7GW7qRrPhWOG4rsWKmAWJggZPG6/ZllekPO02wGLGaTmRno5joGgmHB5E69YKIaD5TNabj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=fail smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=DOVLu5Ll; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="DOVLu5Ll"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BA4afgD3664264;
	Wed, 10 Dec 2025 02:16:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=y
	dVyYtQoQmGRhkSyNxAS5ZYXvKA80A8wMtRo7pzDHXM=; b=DOVLu5Ll3h1RJZTAz
	tXU/oqQtYIQci29qbM5NZPqhJU+Z+ZCUZ7EKAa3O4Yd0Vder2t1llHe5q+UZK+8a
	ViCgcnva5KsxmEP98n90HH5dEsHu1UigFHvj+ZyFoIKHqxKBN1h0Iq0IbJuRxa9f
	dzuBsXVFS5+zeQ7HkQg4RAShI1shntA/xQWymx/HQquqLTYhdVCK4AzW94oaBZW4
	W0b40H6oMUsTMPGeR22YZ4sFQq4GBrMOvu91W5Yw4vFRvhvT9vgGhWLLn9abHL/W
	pMP4m7xTIbE8dq+WcpMtTRs1B257JEPfCqzeXXXqBMlicMwJBQL/wbzUmjkPWdl7
	ZMJXg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4ax8ckg5yj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Dec 2025 02:16:29 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 10 Dec 2025 02:16:42 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 10 Dec 2025 02:16:42 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id AA63D3F709D;
	Wed, 10 Dec 2025 02:16:26 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v3 04/12] qla2xxx: Validate MCU signature before executing MBC 03h
Date: Wed, 10 Dec 2025 15:45:56 +0530
Message-ID: <20251210101604.431868-5-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20251210101604.431868-1-njavali@marvell.com>
References: <20251210101604.431868-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=W8c1lBWk c=1 sm=1 tr=0 ts=6939487d cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8 a=pGLkceISAAAA:8
 a=HMVHDlugHIozVGofra8A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDA4NSBTYWx0ZWRfX8INaecmKGi3k
 mJeOy6RsnrMwdev44ehCPo/WZxd91ceXi3re2w/Aeo9g6f/v7ih6t90eqdtyrSxh4c2CGlkoz7T
 c8fglPWIkg7x6ZsrClr9gFC5SvPl5BPx7npdnrF/gh3Du7p3notS33mJVQOP9Jf3GdF/hBxCm1u
 9fck9Wzn1S3pT16lEPPJAw9qUuJ9NMXsy7lrWas/sEFrFdEWm1lboBWQmdwlF8bGJOzAl+h9e2e
 QWr8yOnUVf6uEbj3sWnhFE0nmPz23jcQACPD6PgmCuVTOWk8PKU547hMFbpJPwbJOXrPw15Z9sy
 Ij5sNqChgp16f0DTGpgpte3PzA0MyCVBUme8OAeoVDrrRzmZBEoymRgm6PsrrgezP59z6kY94eq
 acBxlZw5ixMz7b3Y3JVpFNDbxV3MCw==
X-Proofpoint-ORIG-GUID: 8Gx1PkmOeQk7d6gC6d7k_L7H-IluOa4G
X-Proofpoint-GUID: 8Gx1PkmOeQk7d6gC6d7k_L7H-IluOa4G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-09_05,2025-12-09_03,2025-10-01_01

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


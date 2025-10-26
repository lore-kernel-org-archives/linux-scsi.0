Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335B121767C;
	Sun, 26 Oct 2025 19:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761506004; cv=none; b=G24gIIreIvpi9YqKCwsbIi00eB6vPrGRBNP/LoFheQo34ksNXEyTs6xef5zaQvQXG8K84z05OwsMWKJHg4SAoluaNO8k6c2oxEfHSnYptmytegD5M93TqDqODC7YyCN1TcTu6MVZWVTg8soij4DzjuQXHYYVi7fYIXCfqwqPjvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761506004; c=relaxed/simple;
	bh=YQJrQZtKC6qcthbKGN9i3tlsIUKA9iPjXIL+ttcf4ao=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=LEbymcP/kgVKjOnVc95qtd4GxuCGC/MblLaHaiC/mDzGr5mqWW6glQhRrK6WRzjjPHucPINA5qlpMEkrIcumpKfMiICBBxGnfBMlDh5QcFN9DWNyZfa65CYnVsLgYOS4hoE8Pqx2OPEJDHilZqK7ThovqJkIxnXmCYPV342AYbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HL0e2mnM; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HL0e2mnM"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59Q6Cs0o022347;
	Sun, 26 Oct 2025 19:13:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=wX9+a6daoQks5MpE/nIFHVCuKFTPv
	wgMI6gFnmkC9xI=; b=HL0e2mnMTObY1De9+ebOPCKT4PdHjvWPJNQJie3mAihEK
	V33kymzKn/WpwpoI3P4QKke+vO/KMVAcECbyB7Qy4og4cZ1iuSF//8Cuiu+8NDih
	5RbTVfYHG/sKuvROJ7IQG47ZWHSbK4eO+aTarYRAEqlqXl05AxkmmD7yRW3WWzSF
	sAvN8HcCyx+Rxep1pftigTzgNPmnumdLIfEaaTlmD01+zQbvNp7IUko5qvDuoD3M
	mukx8P4B2SvKrG4j9qOn2bTAem7AkzSCSAKl1bMJBxRitKctB8X5+vzMd8j9wvOA
	zn3fgjjkK6Sd3rZAPDXMIcrVb5CnL+xwUbBNsNWSQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a0myc1w5u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 26 Oct 2025 19:13:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59QEQsrY038681;
	Sun, 26 Oct 2025 19:13:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n061wrk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 26 Oct 2025 19:13:18 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 59QJDId9038300;
	Sun, 26 Oct 2025 19:13:18 GMT
Received: from gms-bm-13185-1.osdevelopmeniad.oraclevcn.com (gms-bm-13185-1.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.252.35])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4a0n061wq4-1;
	Sun, 26 Oct 2025 19:13:18 +0000
From: Gulam Mohamed <gulam.mohamed@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 6.19/scsi-queue] scsi: target: core: Add emulation for REPORT_IDENTIFICATION_INFORMATION
Date: Sun, 26 Oct 2025 19:13:09 +0000
Message-ID: <20251026191309.34968-1-gulam.mohamed@oracle.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-26_07,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510260185
X-Authority-Analysis: v=2.4 cv=fIg0HJae c=1 sm=1 tr=0 ts=68fe72cf cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=V6UrBLdeg1_xNK5wq5sA:9
X-Proofpoint-GUID: 38ziOfiie1Bvp_QMLW8q1zi3ii7GIDVl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAxMiBTYWx0ZWRfX4rFJwUHXaueR
 knbK3dSAOpCp6sAYEhTkFdS12fHvk5ZiQYTXlNxXHoNBjiG9BKMVCBa8OKrur2IHUGh+C2GBMFr
 43M+uhdwNBc0G3ildChLgEJVEzeCvYFSLCZegsZ7uCqF0+ZrzpAoYBO+WAkUMm9blUjC0jDu9Np
 N+Szb2CVSn+HgGu2V2ejQC25fvO75JAi0KG7kQaEymg0pWMHwDzBP/XpXTVfO3yZi5JWQvr3AAr
 X5n8OLEERR+UnMtUjezoNUlKlAXoeU00a1g4/WrpEqOXxOo5SKaYM3cF4lRESMFMiU68cH3Dfm8
 q3s1PxctT0Gp+efQQJkIeoMdkYPMcFNUGoFgrmI3cpwKHmg8OV3QrbkSKyarGKA7NlCT+Id3paP
 FxDydmbmns9Ylh5vYjRWh8G82G0iHA==
X-Proofpoint-ORIG-GUID: 38ziOfiie1Bvp_QMLW8q1zi3ii7GIDVl

This patch will implement the REPORT_IDENTIFICATION_INFORMATION using the
configfs file pd_text_id_info in target core module. The configfs file is
created in /sys/kernel/config/target/core/<backend type>/
<backing_store_name>/wwn/. The user can set the peripheral device text
identification string to the file pd_text_id_info. An emulation function
"spc_emulate_report_id_info()" is defined in target_core_spc.c which
returns the device text id whenever the user requests the same.

Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
---
 drivers/target/target_core_configfs.c | 55 ++++++++++++++++++
 drivers/target/target_core_spc.c      | 82 +++++++++++++++++++++++++++
 include/target/target_core_base.h     |  4 ++
 3 files changed, 141 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index b19acd662726..ac78a106e0f3 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1726,6 +1726,59 @@ static ssize_t target_wwn_vpd_protocol_identifier_show(struct config_item *item,
 	return len;
 }
 
+static ssize_t target_wwn_pd_text_id_info_show(struct config_item *item,
+		char *page)
+{
+	return sprintf(page, "%s\n", &to_t10_wwn(item)->pd_text_id_info[0]);
+}
+
+static ssize_t target_wwn_pd_text_id_info_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct t10_wwn *t10_wwn = to_t10_wwn(item);
+	struct se_device *dev = t10_wwn->t10_dev;
+
+	/* +2 to allow for a trailing (stripped) '\n' and null-terminator */
+	unsigned char buf[PD_TEXT_ID_INFO_LEN + 2];
+	char *stripped = NULL;
+	ssize_t len;
+
+	len = strscpy(buf, page, sizeof(buf));
+	if (len > 0) {
+		/* Strip any newline added from userspace. */
+		stripped = strstrip(buf);
+		len = strlen(stripped);
+	}
+
+	if (len < 0 || len >= PD_TEXT_ID_INFO_LEN) {
+		pr_err("Emulated peripheral device text id info exceeds"
+			" PD_TEXT_ID_INFO_LEN: " __stringify(PD_TEXT_ID_INFO_LEN)
+			"\n");
+		return -EOVERFLOW;
+	}
+
+	/*
+	 * Check to see if any active exports exist.  If they do exist, fail
+	 * here as changing this information on the fly (underneath the
+	 * initiator side OS dependent multipath code) could cause negative
+	 * effects.
+	 */
+	if (dev->export_count) {
+		pr_err("Unable to set the peripheral device text id info while"
+			" active %d exports exist\n", dev->export_count);
+		return -EINVAL;
+	}
+
+	BUILD_BUG_ON(sizeof(dev->t10_wwn.pd_text_id_info) != PD_TEXT_ID_INFO_LEN);
+	strscpy(dev->t10_wwn.pd_text_id_info, stripped,
+	       sizeof(dev->t10_wwn.pd_text_id_info));
+
+	pr_debug("Target_Core_ConfigFS: Set emulated peripheral dev text id info:"
+		  " %s\n", dev->t10_wwn.pd_text_id_info);
+
+	return count;
+}
+
 /*
  * Generic wrapper for dumping VPD identifiers by association.
  */
@@ -1782,6 +1835,7 @@ CONFIGFS_ATTR_RO(target_wwn_, vpd_protocol_identifier);
 CONFIGFS_ATTR_RO(target_wwn_, vpd_assoc_logical_unit);
 CONFIGFS_ATTR_RO(target_wwn_, vpd_assoc_target_port);
 CONFIGFS_ATTR_RO(target_wwn_, vpd_assoc_scsi_target_device);
+CONFIGFS_ATTR(target_wwn_, pd_text_id_info);
 
 static struct configfs_attribute *target_core_dev_wwn_attrs[] = {
 	&target_wwn_attr_vendor_id,
@@ -1793,6 +1847,7 @@ static struct configfs_attribute *target_core_dev_wwn_attrs[] = {
 	&target_wwn_attr_vpd_assoc_logical_unit,
 	&target_wwn_attr_vpd_assoc_target_port,
 	&target_wwn_attr_vpd_assoc_scsi_target_device,
+	&target_wwn_attr_pd_text_id_info,
 	NULL,
 };
 
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index aad0096afa21..9fa84202ee4b 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1963,6 +1963,18 @@ static const struct target_opcode_descriptor tcm_opcode_report_supp_opcodes = {
 	.enabled = spc_rsoc_enabled,
 };
 
+static struct target_opcode_descriptor tcm_opcode_report_identifying_information = {
+	.support = SCSI_SUPPORT_FULL,
+	.serv_action_valid = 1,
+	.opcode = MAINTENANCE_IN,
+	.service_action = MI_REPORT_IDENTIFYING_INFORMATION,
+	.cdb_size = 12,
+	.usage_bits = {MAINTENANCE_IN, MI_REPORT_IDENTIFYING_INFORMATION,
+		       0x00, 0x00,
+		       0x00, 0x00, 0xff, 0xff,
+		       0xff, 0xff, 0xff, SCSI_CONTROL_MASK},
+};
+
 static bool tcm_is_set_tpg_enabled(const struct target_opcode_descriptor *descr,
 				   struct se_cmd *cmd)
 {
@@ -2049,6 +2061,7 @@ static const struct target_opcode_descriptor *tcm_supported_opcodes[] = {
 	&tcm_opcode_report_target_pgs,
 	&tcm_opcode_report_supp_opcodes,
 	&tcm_opcode_set_tpg,
+	&tcm_opcode_report_identifying_information,
 };
 
 static int
@@ -2266,6 +2279,70 @@ spc_emulate_report_supp_op_codes(struct se_cmd *cmd)
 	return ret;
 }
 
+static sense_reason_t
+spc_fill_pd_text_id_info(struct se_cmd *cmd, u8 *cdb)
+{
+	struct se_device *dev = cmd->se_dev;
+	unsigned char *buf;
+	unsigned char *rbuf;
+	u32 header_len = 4;
+	u32 actual_data_len;
+	u32 buf_len;
+	u16 id_len;
+
+	buf_len = get_unaligned_be32(&cdb[6]);
+	if (buf_len < header_len)
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+	id_len = strlen(dev->t10_wwn.pd_text_id_info);
+	if (id_len > 0)
+		/* trailing null */
+		id_len += 1;
+
+	actual_data_len = id_len + header_len;
+
+	if (actual_data_len < buf_len)
+		buf_len = actual_data_len;
+
+	buf = kzalloc(buf_len, GFP_KERNEL);
+	if (!buf) {
+		pr_err("Unable to allocate response buffer for IDENTITY INFO\n");
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+
+	scnprintf(&buf[header_len], buf_len - header_len, "%s",
+		 dev->t10_wwn.pd_text_id_info);
+
+	put_unaligned_be16(id_len, &buf[2]);
+
+	rbuf = transport_kmap_data_sg(cmd);
+	if (rbuf) {
+		memcpy(rbuf, buf, buf_len);
+		transport_kunmap_data_sg(cmd);
+	}
+	kfree(buf);
+
+	target_complete_cmd_with_length(cmd, SAM_STAT_GOOD, buf_len);
+	return TCM_NO_SENSE;
+}
+
+static sense_reason_t
+spc_emulate_report_id_info(struct se_cmd *cmd)
+{
+	u8 *cdb = cmd->t_task_cdb;
+	sense_reason_t rc;
+
+	switch ((cdb[10] >> 1)) {
+	case 2:
+		rc = spc_fill_pd_text_id_info(cmd, cdb);
+		break;
+	default:
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	return rc;
+}
+
 sense_reason_t
 spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 {
@@ -2405,6 +2482,11 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 			    MI_REPORT_SUPPORTED_OPERATION_CODES)
 				cmd->execute_cmd =
 					spc_emulate_report_supp_op_codes;
+			if ((cdb[1] & 0x1f) ==
+			    MI_REPORT_IDENTIFYING_INFORMATION) {
+				cmd->execute_cmd =
+					spc_emulate_report_id_info;
+			}
 			*size = get_unaligned_be32(&cdb[6]);
 		} else {
 			/*
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index c4d9116904aa..c9b5edcce1eb 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -108,6 +108,9 @@
 #define SE_MODE_PAGE_BUF			512
 #define SE_SENSE_BUF				96
 
+/* Peripheral Device Text Identification Information */
+#define PD_TEXT_ID_INFO_LEN			256
+
 enum target_submit_type {
 	/* Use the fabric driver's default submission type */
 	TARGET_FABRIC_DEFAULT_SUBMIT,
@@ -347,6 +350,7 @@ struct t10_wwn {
 	struct se_device *t10_dev;
 	struct config_group t10_wwn_group;
 	struct list_head t10_vpd_list;
+	char pd_text_id_info[PD_TEXT_ID_INFO_LEN];
 };
 
 struct t10_pr_registration {
-- 
2.47.3


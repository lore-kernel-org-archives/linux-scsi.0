Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57AD3242B7;
	Thu, 27 Nov 2025 11:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764243293; cv=none; b=t0uMoquJgmN1eeAjfPYYSsdFH0ABsg9aagvf0I/JEmma3f82TxZBsIgwZhGwXYYFaxw/xMSam87lp483kvpEAk3tIlLpGyzY8idz3H3SgmImXluiFrTRPJgpyowBVTGFtrigR5UgCpATARqZrUH3WZp875O+7nEkyKn+zsCxSks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764243293; c=relaxed/simple;
	bh=fVxy5hYK36KxAw7mL/u68HLlEsrtQCCkYMI+6HWjxUw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZtBAEzhTSuRVrJsz0GKx1J+fUIdhQ+VdqNTNm+X4ygW6EaYnN6gBtbyCguVrhH2XtZh6QxhJvOeHta2vtRtziBOjCkS5hgZBy2VH1XsfYunP1HWUokEUwFJBKdIwm5nx7EunfUEMuM4UUs3YYAt0wc0QVBx2L72RJSq79+CXi84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FH4hoBre; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FH4hoBre"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AR9kT4T771294;
	Thu, 27 Nov 2025 11:34:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=oPpRu0ETTe+bYdOVa6tSSWwy8OABj
	A1OO0GUNiZg1ag=; b=FH4hoBre2kL+F9bv9qD927Dxm7aJr9va3lLuFn61b8aP9
	xAYDOizkXQOUvzip07FnE8bERU/FoTWHVK5+XYbeeXkPdlyRmA04rZMY27VF0QdC
	6Et/q67whboOF98HN3z7uFlc9HvjjIq07A7RpqJJDgchNgdYpbe/7EZUoukfeK6S
	ay4wWKRAysu6iINa7BmzaAf4vIdK0VMisGSkFQfae7/lL/0gF8K1OUhqvQwAFkyQ
	2TAjQFs3PbO0QhafYrqlBrqyFR67IQF069iHxC0vQlxjj5Mo2DZRPZIePsXtGnIz
	k/qbMZ2Ib93IYUJgOK5hgQAg/ZFRlQuqhjQSPcMUw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4apma9r52v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 11:34:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ARB92w1022131;
	Thu, 27 Nov 2025 11:34:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mfxv52-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 11:34:49 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5ARBYnGc002564;
	Thu, 27 Nov 2025 11:34:49 GMT
Received: from gms-bm-13185-1.osdevelopmeniad.oraclevcn.com (gms-bm-13185-1.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.252.35])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4ak3mfxv4v-1;
	Thu, 27 Nov 2025 11:34:49 +0000
From: Gulam Mohamed <gulam.mohamed@oracle.com>
To: john.g.garry@oracle.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: gulam.mohamed@oracle.com
Subject: [PATCH V2 6.19/scsi-queue] scsi: target: core: Add emulation for REPORT_IDENTIFYING_INFORMATION
Date: Thu, 27 Nov 2025 11:34:48 +0000
Message-ID: <20251127113448.17526-1-gulam.mohamed@oracle.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511270085
X-Proofpoint-GUID: -fvEoqYFM-eksGP_75RcH5fvIrLGgNu6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI3MDA4NSBTYWx0ZWRfXzDresFzJ2iiC
 fbZZliq+0mZymgnPso6aOget2T3bmbO2/VyY+89Vy3F7B4HDlT07alnHG1ZDirlJaq6Qq18EQ8j
 WQlHJsdt/HolFrY/AOQbQ/YNVeszV9cqwXfgFIJUwYvR8RxZwrJ5IoKTmeWiKTGZp6DzmqZ5LZo
 5sLV9auXtBLIvnEB4zFw2NDCYXIQVoOQwHY/NcHlENyxRn3ZDwXLk2OPwoTysO+byJyKdrv+1C4
 D9ro0SagkNR9bnKaKbIgiJkQMnYkUtH3zuUHohJM5aWpYxEFZeOsuij1qR1SuCSV7U5jsYvRKaR
 tXD0TNMxFnvCSO80evrRO0RBLVBXN8AuVUJumvT2sOTnxGPgP7/FZGsFeQVVKrdF/lZAvp5C5f1
 3YDEHiHXbhY4QyK2Y3e9AZBdck98OOoaF4mMa//225uepkTLCvY=
X-Proofpoint-ORIG-GUID: -fvEoqYFM-eksGP_75RcH5fvIrLGgNu6
X-Authority-Analysis: v=2.4 cv=Sr+dKfO0 c=1 sm=1 tr=0 ts=6928375a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=Lj9PeItD_u0TUzI_VegA:9 cc=ntf awl=host:12098

Add the emulation for REPORT_IDENTIFYING_INFORMATION command using the
configfs file pd_text_id_info in target core module. The configfs file is
created in /sys/kernel/config/target/core/<backend type>/
<backing_store_name>/wwn/. The user can set the peripheral device text
identification string to the file pd_text_id_info. An emulation function
"spc_emulate_report_id_info()" is defined in target_core_spc.c which
returns the device text id whenever the user requests the same.

The details of the REPORT_IDENTIFYING_INFORMATION command is mentioned
in the section 6.32 of spc4r37 specification document of SCSI Primary
Commands.

Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
---
Changes in V2:
	1. Corrected the command name to REPORT_IDENTIFYING_INFORMATION
	2. Included the spec reference to the command
	3. In function target_wwn_pd_text_id_info_store, return early if
	   the string is too short
	4. Check the export count before string correctness in 
	   the function target_wwn_pd_text_id_info_store
	5. Fixed strings in single line for print statements
	6. In function spc_fill_pd_text_id_info, return error when
	   transport_kmap_data_sg fails to map the command data	   
Link to V1:
https://lore.kernel.org/all/20251026191309.34968-1-gulam.mohamed@oracle.com/
---
 drivers/target/target_core_configfs.c | 50 ++++++++++++++++
 drivers/target/target_core_spc.c      | 86 +++++++++++++++++++++++++++
 include/target/target_core_base.h     |  4 ++
 3 files changed, 140 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 77da1fc82b8d..c2855f4048cc 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1741,6 +1741,54 @@ static ssize_t target_wwn_vpd_protocol_identifier_show(struct config_item *item,
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
+
+	/*
+	 * Check to see if any active exports exist.  If they do exist, fail
+	 * here as changing this information on the fly (underneath the
+	 * initiator side OS dependent multipath code) could cause negative
+	 * effects.
+	 */
+	if (dev->export_count) {
+		pr_err("Unable to set the peripheral device text id info while active %d exports exist\n",
+			dev->export_count);
+		return -EINVAL;
+	}
+
+	if (strscpy(buf, page, sizeof(buf)) < 0)
+		return -EOVERFLOW;
+
+	/* Strip any newline added from userspace. */
+	stripped = strstrip(buf);
+	if (strlen(stripped) >= PD_TEXT_ID_INFO_LEN) {
+		pr_err("Emulated peripheral device text id info exceeds PD_TEXT_ID_INFO_LEN: " __stringify(PD_TEXT_ID_INFO_LEN "\n"));
+		return -EOVERFLOW;
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
@@ -1797,6 +1845,7 @@ CONFIGFS_ATTR_RO(target_wwn_, vpd_protocol_identifier);
 CONFIGFS_ATTR_RO(target_wwn_, vpd_assoc_logical_unit);
 CONFIGFS_ATTR_RO(target_wwn_, vpd_assoc_target_port);
 CONFIGFS_ATTR_RO(target_wwn_, vpd_assoc_scsi_target_device);
+CONFIGFS_ATTR(target_wwn_, pd_text_id_info);
 
 static struct configfs_attribute *target_core_dev_wwn_attrs[] = {
 	&target_wwn_attr_vendor_id,
@@ -1808,6 +1857,7 @@ static struct configfs_attribute *target_core_dev_wwn_attrs[] = {
 	&target_wwn_attr_vpd_assoc_logical_unit,
 	&target_wwn_attr_vpd_assoc_target_port,
 	&target_wwn_attr_vpd_assoc_scsi_target_device,
+	&target_wwn_attr_pd_text_id_info,
 	NULL,
 };
 
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index fe2b888bcb43..a2e9031474bf 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1999,6 +1999,18 @@ static const struct target_opcode_descriptor tcm_opcode_report_supp_opcodes = {
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
@@ -2086,6 +2098,7 @@ static const struct target_opcode_descriptor *tcm_supported_opcodes[] = {
 	&tcm_opcode_report_target_pgs,
 	&tcm_opcode_report_supp_opcodes,
 	&tcm_opcode_set_tpg,
+	&tcm_opcode_report_identifying_information,
 };
 
 static int
@@ -2303,6 +2316,74 @@ spc_emulate_report_supp_op_codes(struct se_cmd *cmd)
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
+	if (!rbuf) {
+		pr_err("transport_kmap_data_sg() failed in spc_fill_pd_text_id_info\n");
+		kfree(buf);
+		return TCM_OUT_OF_RESOURCES;
+	}
+
+	memcpy(rbuf, buf, buf_len);
+	transport_kunmap_data_sg(cmd);
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
@@ -2442,6 +2523,11 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
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
index 7016d93fa383..b62d5fcce950 100644
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
@@ -348,6 +351,7 @@ struct t10_wwn {
 	struct se_device *t10_dev;
 	struct config_group t10_wwn_group;
 	struct list_head t10_vpd_list;
+	char pd_text_id_info[PD_TEXT_ID_INFO_LEN];
 };
 
 struct t10_pr_registration {
-- 
2.47.3


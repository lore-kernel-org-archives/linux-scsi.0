Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B97E7C6FD1C
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Mar 2023 18:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbjCXSU6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 14:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbjCXSUv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 14:20:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAE21F92C;
        Fri, 24 Mar 2023 11:20:38 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OHorg2021424;
        Fri, 24 Mar 2023 18:18:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=P9Lzi/ZtfXnWhqP/2lFsblJTFnvLSerrPfLluzUW4fw=;
 b=fDvYn+3S0XpnHAr4lkWK/1/HuyquwnJUgPlJ7mex6X0o9Wss2gJqERaFa7GJGwCIqZAq
 9MXE/KEF3mpiUKCRr+uAWnbVbgZ5yRRZCwIOtpxmR9Sqf8Ggf6O8h2WNqEwue3L/X4Lo
 ngPUlEEsPdxZuGlpO/e2s44zk0TCaAqcjzNFoj+uj/6lBit2j0TbTpGSj/cMwEpSUlxb
 xIJ+YT49MVDo5dWMU0MaIS09fPO3HJQvLVnlQabcrZzwkZd9rTIjN3mZgiHSYH2hSCsZ
 SzY+vyQ+vpbBWv/jzULpUJVie8NoVZJRcxwvDFX6KLrd7+cFmd2XjLBZ+3vV4kvMTli1 TA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3phgku039w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 18:18:24 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32OGZV3K001643;
        Fri, 24 Mar 2023 18:18:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pgxk4bxrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 18:18:23 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OIHiEp021017;
        Fri, 24 Mar 2023 18:18:22 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-153-54.vpn.oracle.com [10.154.153.54])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3pgxk4bx19-17;
        Fri, 24 Mar 2023 18:18:22 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 16/18] scsi: target: Pass struct target_opcode_descriptor to enabled
Date:   Fri, 24 Mar 2023 13:17:39 -0500
Message-Id: <20230324181741.13908-17-michael.christie@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324181741.13908-1-michael.christie@oracle.com>
References: <20230324181741.13908-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240143
X-Proofpoint-ORIG-GUID: A46DEWlW5mWXniqlTvt6kz-DGpIeqHPI
X-Proofpoint-GUID: A46DEWlW5mWXniqlTvt6kz-DGpIeqHPI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The iblock pr_ops support does not support commands that require port or
I_T Nexus info. This adds a struct target_opcode_descriptor as an argument
to the enabled callout so we can still have the common tcm_is_pr_enabled
and tcm_is_scsi2_reservations_enabled functions and also determine if the
command is supported based on the command and service action and device
settings.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_spc.c  | 40 +++++++++++++++++++------------
 include/target/target_core_base.h |  3 ++-
 2 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 00d34616df5d..caf8d1325007 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1429,7 +1429,8 @@ static struct target_opcode_descriptor tcm_opcode_write_verify16 = {
 	.update_usage_bits = set_dpofua_usage_bits,
 };
 
-static bool tcm_is_ws_enabled(struct se_cmd *cmd)
+static bool tcm_is_ws_enabled(struct target_opcode_descriptor *descr,
+			      struct se_cmd *cmd)
 {
 	struct exec_cmd_ops *ops = cmd->protocol_data;
 	struct se_device *dev = cmd->se_dev;
@@ -1456,7 +1457,8 @@ static struct target_opcode_descriptor tcm_opcode_write_same32 = {
 	.update_usage_bits = set_dpofua_usage_bits32,
 };
 
-static bool tcm_is_caw_enabled(struct se_cmd *cmd)
+static bool tcm_is_caw_enabled(struct target_opcode_descriptor *descr,
+			       struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
@@ -1496,7 +1498,8 @@ static struct target_opcode_descriptor tcm_opcode_read_capacity16 = {
 		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
 };
 
-static bool tcm_is_rep_ref_enabled(struct se_cmd *cmd)
+static bool tcm_is_rep_ref_enabled(struct target_opcode_descriptor *descr,
+				   struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
@@ -1507,7 +1510,6 @@ static bool tcm_is_rep_ref_enabled(struct se_cmd *cmd)
 	}
 	spin_unlock(&dev->t10_alua.lba_map_lock);
 	return true;
-
 }
 
 static struct target_opcode_descriptor tcm_opcode_read_report_refferals = {
@@ -1542,7 +1544,8 @@ static struct target_opcode_descriptor tcm_opcode_sync_cache16 = {
 		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
 };
 
-static bool tcm_is_unmap_enabled(struct se_cmd *cmd)
+static bool tcm_is_unmap_enabled(struct target_opcode_descriptor *descr,
+				 struct se_cmd *cmd)
 {
 	struct exec_cmd_ops *ops = cmd->protocol_data;
 	struct se_device *dev = cmd->se_dev;
@@ -1664,7 +1667,8 @@ static struct target_opcode_descriptor tcm_opcode_pri_read_resrv = {
 		       0xff, SCSI_CONTROL_MASK},
 };
 
-static bool tcm_is_pr_enabled(struct se_cmd *cmd)
+static bool tcm_is_pr_enabled(struct target_opcode_descriptor *descr,
+			      struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
@@ -1793,7 +1797,9 @@ static struct target_opcode_descriptor tcm_opcode_pro_register_move = {
 	.enabled = tcm_is_pr_enabled,
 };
 
-static bool tcm_is_scsi2_reservations_enabled(struct se_cmd *cmd)
+static bool
+tcm_is_scsi2_reservations_enabled(struct target_opcode_descriptor *descr,
+				  struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
@@ -1854,7 +1860,8 @@ static struct target_opcode_descriptor tcm_opcode_inquiry = {
 		       0xff, SCSI_CONTROL_MASK},
 };
 
-static bool tcm_is_3pc_enabled(struct se_cmd *cmd)
+static bool tcm_is_3pc_enabled(struct target_opcode_descriptor *descr,
+			       struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
@@ -1915,8 +1922,8 @@ static struct target_opcode_descriptor tcm_opcode_report_target_pgs = {
 		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
 };
 
-
-static bool spc_rsoc_enabled(struct se_cmd *cmd)
+static bool spc_rsoc_enabled(struct target_opcode_descriptor *descr,
+			     struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
@@ -1936,7 +1943,8 @@ static struct target_opcode_descriptor tcm_opcode_report_supp_opcodes = {
 	.enabled = spc_rsoc_enabled,
 };
 
-static bool tcm_is_set_tpg_enabled(struct se_cmd *cmd)
+static bool tcm_is_set_tpg_enabled(struct target_opcode_descriptor *descr,
+				   struct se_cmd *cmd)
 {
 	struct t10_alua_tg_pt_gp *l_tg_pt_gp;
 	struct se_lun *l_lun = cmd->se_lun;
@@ -2123,7 +2131,7 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 			if (descr->serv_action_valid)
 				return TCM_INVALID_CDB_FIELD;
 
-			if (!descr->enabled || descr->enabled(cmd))
+			if (!descr->enabled || descr->enabled(descr, cmd))
 				*opcode = descr;
 			break;
 		case 0x2:
@@ -2137,7 +2145,8 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 			 */
 			if (descr->serv_action_valid &&
 			    descr->service_action == requested_sa) {
-				if (!descr->enabled || descr->enabled(cmd))
+				if (!descr->enabled || descr->enabled(descr,
+								      cmd))
 					*opcode = descr;
 			} else if (!descr->serv_action_valid)
 				return TCM_INVALID_CDB_FIELD;
@@ -2150,7 +2159,8 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 			 * be returned in the one_command parameter data format.
 			 */
 			if (descr->service_action == requested_sa)
-				if (!descr->enabled || descr->enabled(cmd))
+				if (!descr->enabled || descr->enabled(descr,
+								      cmd))
 					*opcode = descr;
 			break;
 		}
@@ -2207,7 +2217,7 @@ spc_emulate_report_supp_op_codes(struct se_cmd *cmd)
 
 		for (i = 0; i < ARRAY_SIZE(tcm_supported_opcodes); i++) {
 			descr = tcm_supported_opcodes[i];
-			if (descr->enabled && !descr->enabled(cmd))
+			if (descr->enabled && !descr->enabled(descr, cmd))
 				continue;
 
 			response_length += spc_rsoc_encode_command_descriptor(
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 12c9ba16217e..04646b3dbf75 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -878,7 +878,8 @@ struct target_opcode_descriptor {
 	u8			specific_timeout;
 	u16			nominal_timeout;
 	u16			recommended_timeout;
-	bool			(*enabled)(struct se_cmd *cmd);
+	bool			(*enabled)(struct target_opcode_descriptor *descr,
+					   struct se_cmd *cmd);
 	void			(*update_usage_bits)(u8 *usage_bits,
 						     struct se_device *dev);
 	u8			usage_bits[];
-- 
2.25.1


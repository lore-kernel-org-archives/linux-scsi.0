Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0ACFC6FA96
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Sep 2022 10:47:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239697AbiIFKr0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Sep 2022 06:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239838AbiIFKqe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2022 06:46:34 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBB57C199;
        Tue,  6 Sep 2022 03:45:27 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 8A0A25657B;
        Tue,  6 Sep 2022 10:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1662461113; x=1664275514; bh=Iu8xowrnP3iP6weKdChSttsa1
        NjdGhwaxwjCiL3aTGE=; b=iUrAUH95bFPCCJmvL1VSJ3L3xOBDViK0Ou1VtXlZR
        bxJM42F/j49lUzeHA5OSYRgX/MJIrwiSP918el94Ik5mLL2RZ4XCuo4eS2wWXo5O
        43vlLe/biT9QY1KxPZnfn0liTJ0U0ADYIkcPl/VL26rsftYr3M0piW905DPkcU42
        F0=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dK9AZ7jCRYwZ; Tue,  6 Sep 2022 13:45:13 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id A0C9256592;
        Tue,  6 Sep 2022 13:34:44 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 6 Sep 2022 13:34:44 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Tue, 6 Sep 2022 13:34:41 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 3/6] scsi: target: core: dynamic opcode support in RSOC
Date:   Tue, 6 Sep 2022 13:34:18 +0300
Message-ID: <20220906103421.22348-4-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220906103421.22348-1-d.bogdanov@yadro.com>
References: <20220906103421.22348-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Report supported opcodes depending on a dynamic device configuration.

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
v2:
  fix tcm_is_ws_enabled
  fix sparse warnings
  remove extra space
---
 drivers/target/target_core_spc.c  | 120 ++++++++++++++++++++++++++++--
 include/target/target_core_base.h |   1 +
 2 files changed, 116 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 043c08abf338..93adf9594b1a 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1399,6 +1399,15 @@ static struct target_opcode_descriptor tcm_opcode_write_verify16 = {
 		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
 };
 
+static bool tcm_is_ws_enabled(struct se_cmd *cmd)
+{
+	struct sbc_ops *ops = cmd->protocol_data;
+	struct se_device *dev = cmd->se_dev;
+
+	return (dev->dev_attrib.emulate_tpws && !!ops->execute_unmap) ||
+	       !!ops->execute_write_same;
+}
+
 static struct target_opcode_descriptor tcm_opcode_write_same32 = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
@@ -1413,8 +1422,16 @@ static struct target_opcode_descriptor tcm_opcode_write_same32 = {
 		       0x00, 0x00, 0x00, 0x00,
 		       0x00, 0x00, 0x00, 0x00,
 		       0xff, 0xff, 0xff, 0xff},
+	.enabled = tcm_is_ws_enabled,
 };
 
+static bool tcm_is_caw_enabled(struct se_cmd *cmd)
+{
+	struct se_device *dev = cmd->se_dev;
+
+	return dev->dev_attrib.emulate_caw;
+}
+
 static struct target_opcode_descriptor tcm_opcode_compare_write = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = COMPARE_AND_WRITE,
@@ -1423,6 +1440,7 @@ static struct target_opcode_descriptor tcm_opcode_compare_write = {
 		       0xff, 0xff, 0xff, 0xff,
 		       0xff, 0xff, 0x00, 0x00,
 		       0x00, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_caw_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_read_capacity = {
@@ -1446,6 +1464,20 @@ static struct target_opcode_descriptor tcm_opcode_read_capacity16 = {
 		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
 };
 
+static bool tcm_is_rep_ref_enabled(struct se_cmd *cmd)
+{
+	struct se_device *dev = cmd->se_dev;
+
+	spin_lock(&dev->t10_alua.lba_map_lock);
+	if (list_empty(&dev->t10_alua.lba_map_list)) {
+		spin_unlock(&dev->t10_alua.lba_map_lock);
+		return false;
+	}
+	spin_unlock(&dev->t10_alua.lba_map_lock);
+	return true;
+
+}
+
 static struct target_opcode_descriptor tcm_opcode_read_report_refferals = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
@@ -1456,6 +1488,7 @@ static struct target_opcode_descriptor tcm_opcode_read_report_refferals = {
 		       0x00, 0x00, 0x00, 0x00,
 		       0x00, 0x00, 0xff, 0xff,
 		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_rep_ref_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_sync_cache = {
@@ -1477,6 +1510,14 @@ static struct target_opcode_descriptor tcm_opcode_sync_cache16 = {
 		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
 };
 
+static bool tcm_is_unmap_enabled(struct se_cmd *cmd)
+{
+	struct sbc_ops *ops = cmd->protocol_data;
+	struct se_device *dev = cmd->se_dev;
+
+	return ops->execute_unmap && dev->dev_attrib.emulate_tpu;
+}
+
 static struct target_opcode_descriptor tcm_opcode_unmap = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = UNMAP,
@@ -1484,6 +1525,7 @@ static struct target_opcode_descriptor tcm_opcode_unmap = {
 	.usage_bits = {UNMAP, 0x00, 0x00, 0x00,
 		       0x00, 0x00, SCSI_GROUP_NUMBER_MASK, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_unmap_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_write_same = {
@@ -1493,6 +1535,7 @@ static struct target_opcode_descriptor tcm_opcode_write_same = {
 	.usage_bits = {WRITE_SAME, 0xe8, 0xff, 0xff,
 		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_ws_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_write_same16 = {
@@ -1503,6 +1546,7 @@ static struct target_opcode_descriptor tcm_opcode_write_same16 = {
 		       0xff, 0xff, 0xff, 0xff,
 		       0xff, 0xff, 0xff, 0xff,
 		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_ws_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_verify = {
@@ -1588,6 +1632,13 @@ static struct target_opcode_descriptor tcm_opcode_pri_read_resrv = {
 		       0xff, SCSI_CONTROL_MASK},
 };
 
+static bool tcm_is_pr_enabled(struct se_cmd *cmd)
+{
+	struct se_device *dev = cmd->se_dev;
+
+	return dev->dev_attrib.emulate_pr;
+}
+
 static struct target_opcode_descriptor tcm_opcode_pri_read_caps = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
@@ -1597,6 +1648,7 @@ static struct target_opcode_descriptor tcm_opcode_pri_read_caps = {
 	.usage_bits = {PERSISTENT_RESERVE_IN, PRI_REPORT_CAPABILITIES, 0x00, 0x00,
 		       0x00, 0x00, 0x00, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_pri_read_full_status = {
@@ -1608,6 +1660,7 @@ static struct target_opcode_descriptor tcm_opcode_pri_read_full_status = {
 	.usage_bits = {PERSISTENT_RESERVE_IN, PRI_READ_FULL_STATUS, 0x00, 0x00,
 		       0x00, 0x00, 0x00, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_pro_register = {
@@ -1619,6 +1672,7 @@ static struct target_opcode_descriptor tcm_opcode_pro_register = {
 	.usage_bits = {PERSISTENT_RESERVE_OUT, PRO_REGISTER, 0xff, 0x00,
 		       0x00, 0xff, 0xff, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_pro_reserve = {
@@ -1630,6 +1684,7 @@ static struct target_opcode_descriptor tcm_opcode_pro_reserve = {
 	.usage_bits = {PERSISTENT_RESERVE_OUT, PRO_RESERVE, 0xff, 0x00,
 		       0x00, 0xff, 0xff, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_pro_release = {
@@ -1641,6 +1696,7 @@ static struct target_opcode_descriptor tcm_opcode_pro_release = {
 	.usage_bits = {PERSISTENT_RESERVE_OUT, PRO_RELEASE, 0xff, 0x00,
 		       0x00, 0xff, 0xff, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_pro_clear = {
@@ -1652,6 +1708,7 @@ static struct target_opcode_descriptor tcm_opcode_pro_clear = {
 	.usage_bits = {PERSISTENT_RESERVE_OUT, PRO_CLEAR, 0xff, 0x00,
 		       0x00, 0xff, 0xff, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_pro_preempt = {
@@ -1663,6 +1720,7 @@ static struct target_opcode_descriptor tcm_opcode_pro_preempt = {
 	.usage_bits = {PERSISTENT_RESERVE_OUT, PRO_PREEMPT, 0xff, 0x00,
 		       0x00, 0xff, 0xff, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_pro_preempt_abort = {
@@ -1674,6 +1732,7 @@ static struct target_opcode_descriptor tcm_opcode_pro_preempt_abort = {
 	.usage_bits = {PERSISTENT_RESERVE_OUT, PRO_PREEMPT_AND_ABORT, 0xff, 0x00,
 		       0x00, 0xff, 0xff, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_pro_reg_ign_exist = {
@@ -1687,6 +1746,7 @@ static struct target_opcode_descriptor tcm_opcode_pro_reg_ign_exist = {
 		0xff, 0x00,
 		0x00, 0xff, 0xff, 0xff,
 		0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_pro_register_move = {
@@ -1698,14 +1758,23 @@ static struct target_opcode_descriptor tcm_opcode_pro_register_move = {
 	.usage_bits = {PERSISTENT_RESERVE_OUT, PRO_REGISTER_AND_MOVE, 0xff, 0x00,
 		       0x00, 0xff, 0xff, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_pr_enabled,
 };
 
+static bool tcm_is_scsi2_reservations_enabled(struct se_cmd *cmd)
+{
+	struct se_device *dev = cmd->se_dev;
+
+	return dev->dev_attrib.emulate_pr;
+}
+
 static struct target_opcode_descriptor tcm_opcode_release = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = RELEASE,
 	.cdb_size = 6,
 	.usage_bits = {RELEASE, 0x00, 0x00, 0x00,
 		       0x00, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_scsi2_reservations_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_release10 = {
@@ -1715,6 +1784,7 @@ static struct target_opcode_descriptor tcm_opcode_release10 = {
 	.usage_bits = {RELEASE_10, 0x00, 0x00, 0x00,
 		       0x00, 0x00, 0x00, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_scsi2_reservations_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_reserve = {
@@ -1723,6 +1793,7 @@ static struct target_opcode_descriptor tcm_opcode_reserve = {
 	.cdb_size = 6,
 	.usage_bits = {RESERVE, 0x00, 0x00, 0x00,
 		       0x00, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_scsi2_reservations_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_reserve10 = {
@@ -1732,6 +1803,7 @@ static struct target_opcode_descriptor tcm_opcode_reserve10 = {
 	.usage_bits = {RESERVE_10, 0x00, 0x00, 0x00,
 		       0x00, 0x00, 0x00, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_scsi2_reservations_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_request_sense = {
@@ -1750,6 +1822,13 @@ static struct target_opcode_descriptor tcm_opcode_inquiry = {
 		       0xff, SCSI_CONTROL_MASK},
 };
 
+static bool tcm_is_3pc_enabled(struct se_cmd *cmd)
+{
+	struct se_device *dev = cmd->se_dev;
+
+	return dev->dev_attrib.emulate_3pc;
+}
+
 static struct target_opcode_descriptor tcm_opcode_extended_copy_lid1 = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
@@ -1759,6 +1838,7 @@ static struct target_opcode_descriptor tcm_opcode_extended_copy_lid1 = {
 		       0x00, 0x00, 0x00, 0x00,
 		       0x00, 0x00, 0xff, 0xff,
 		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_3pc_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_rcv_copy_res_op_params = {
@@ -1772,6 +1852,7 @@ static struct target_opcode_descriptor tcm_opcode_rcv_copy_res_op_params = {
 		       0x00, 0x00, 0x00, 0x00,
 		       0x00, 0x00, 0xff, 0xff,
 		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_3pc_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_report_luns = {
@@ -1814,6 +1895,26 @@ static struct target_opcode_descriptor tcm_opcode_report_supp_opcodes = {
 		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
 };
 
+static bool tcm_is_set_tpg_enabled(struct se_cmd *cmd)
+{
+	struct t10_alua_tg_pt_gp *l_tg_pt_gp;
+	struct se_lun *l_lun = cmd->se_lun;
+
+	rcu_read_lock();
+	l_tg_pt_gp = rcu_dereference(l_lun->lun_tg_pt_gp);
+	if (!l_tg_pt_gp) {
+		rcu_read_unlock();
+		return false;
+	}
+	if (!(l_tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICIT_ALUA)) {
+		rcu_read_unlock();
+		return false;
+	}
+	rcu_read_unlock();
+
+	return true;
+}
+
 static struct target_opcode_descriptor tcm_opcode_set_tpg = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
@@ -1823,6 +1924,7 @@ static struct target_opcode_descriptor tcm_opcode_set_tpg = {
 	.usage_bits = {MAINTENANCE_OUT, MO_SET_TARGET_PGS, 0x00, 0x00,
 		       0x00, 0x00, 0xff, 0xff,
 		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_set_tpg_enabled,
 };
 
 static struct target_opcode_descriptor *tcm_supported_opcodes[] = {
@@ -1976,7 +2078,9 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 			 */
 			if (descr->serv_action_valid)
 				return TCM_INVALID_CDB_FIELD;
-			*opcode = descr;
+
+			if (!descr->enabled || descr->enabled(cmd))
+				*opcode = descr;
 			break;
 		case 0x2:
 			/*
@@ -1988,9 +2092,10 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 			 * and the additional sense code set to INVALID FIELD IN CDB.
 			 */
 			if (descr->serv_action_valid &&
-			    descr->service_action == requested_sa)
-				*opcode = descr;
-			else if (!descr->serv_action_valid)
+			    descr->service_action == requested_sa) {
+				if (!descr->enabled || descr->enabled(cmd))
+					*opcode = descr;
+			} else if (!descr->serv_action_valid)
 				return TCM_INVALID_CDB_FIELD;
 			break;
 		case 0x3:
@@ -2001,10 +2106,12 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 			 * be returned in the one_command parameter data format.
 			 */
 			if (descr->service_action == requested_sa)
-				*opcode = descr;
+				if (!descr->enabled || descr->enabled(cmd))
+					*opcode = descr;
 			break;
 		}
 	}
+
 	return 0;
 }
 
@@ -2053,6 +2160,9 @@ spc_emulate_report_supp_op_codes(struct se_cmd *cmd)
 
 		for (i = 0; i < ARRAY_SIZE(tcm_supported_opcodes); i++) {
 			descr = tcm_supported_opcodes[i];
+			if (descr->enabled && !descr->enabled(cmd))
+				continue;
+
 			response_length += spc_rsoc_encode_command_descriptor(
 					&buf[response_length], rctd, descr);
 		}
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index d93c65bcbc11..329f88680367 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -876,6 +876,7 @@ struct target_opcode_descriptor {
 	u8			specific_timeout;
 	u16			nominal_timeout;
 	u16			recommended_timeout;
+	bool			(*enabled)(struct se_cmd *cmd);
 	u8			usage_bits[];
 };
 
-- 
2.25.1


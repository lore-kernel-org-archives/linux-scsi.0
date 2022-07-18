Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33796CCA479
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 12:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234623AbiGRMDV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 08:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234620AbiGRMDS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 08:03:18 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EF823BE8;
        Mon, 18 Jul 2022 05:03:14 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id D9A8341237;
        Mon, 18 Jul 2022 12:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1658145790; x=1659960191; bh=quOr/Izg+Y8KKcfIv+EaXX7lO
        0G/nsd/qnodla8Dr4Q=; b=HwwLSQo/lEohARDoa5DgvanTxs9WGbrpnqihbL7m8
        +/xALB1cBPiEYXIAzHbWNb4jK8ACATFGmaqByfVFWREf2AL0tvD+yz485RGNP1dC
        dwbLS6OFCdGFKxpMmB0zRLAO7ugOZeFn4mcNxtLWmKn8iym9NClG65svOx4W/qN9
        HU=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id qnhfLuUcYaxZ; Mon, 18 Jul 2022 15:03:10 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 15A3B41253;
        Mon, 18 Jul 2022 15:03:09 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 18 Jul 2022 15:03:08 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Mon, 18 Jul 2022 15:03:07 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 3/6] scsi: target: core: dynamic opcode support in RSOC
Date:   Mon, 18 Jul 2022 15:01:14 +0300
Message-ID: <20220718120117.4435-4-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718120117.4435-1-d.bogdanov@yadro.com>
References: <20220718120117.4435-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Report supported opcodes depending on a dynamic device configuration

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_spc.c  | 118 ++++++++++++++++++++++++++++--
 include/target/target_core_base.h |   1 +
 2 files changed, 114 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 506e28b14e5a..cf516136b933 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1424,6 +1424,13 @@ static struct target_opcode_descriptor tcm_opcode_xdwriteread32 = {
 		       0xff, 0xff, 0xff, 0xff},
 };
 
+static bool tcm_is_ws_enabled(struct se_cmd *cmd)
+{
+	struct se_device *dev = cmd->se_dev;
+
+	return dev->dev_attrib.emulate_tpws;
+}
+
 static struct target_opcode_descriptor tcm_opcode_write_same32 = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
@@ -1438,8 +1445,16 @@ static struct target_opcode_descriptor tcm_opcode_write_same32 = {
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
@@ -1448,6 +1463,7 @@ static struct target_opcode_descriptor tcm_opcode_compare_write = {
 		       0xff, 0xff, 0xff, 0xff,
 		       0xff, 0xff, 0x00, 0x00,
 		       0x00, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_caw_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_read_capacity = {
@@ -1471,6 +1487,20 @@ static struct target_opcode_descriptor tcm_opcode_read_capacity16 = {
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
@@ -1481,6 +1511,7 @@ static struct target_opcode_descriptor tcm_opcode_read_report_refferals = {
 		       0x00, 0x00, 0x00, 0x00,
 		       0x00, 0x00, 0xff, 0xff,
 		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_rep_ref_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_sync_cache = {
@@ -1502,6 +1533,14 @@ static struct target_opcode_descriptor tcm_opcode_sync_cache16 = {
 		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
 };
 
+static bool tcm_is_unmap_enabled(struct se_cmd *cmd)
+{
+	struct sbc_ops *ops = cmd->protocol_data;
+	struct se_device *dev = cmd->se_dev;
+
+	return ops->execute_unmap  && dev->dev_attrib.emulate_tpu;
+}
+
 static struct target_opcode_descriptor tcm_opcode_unmap = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = UNMAP,
@@ -1509,6 +1548,7 @@ static struct target_opcode_descriptor tcm_opcode_unmap = {
 	.usage_bits = {UNMAP, 0x00, 0x00, 0x00,
 		       0x00, 0x00, SCSI_GROUP_NUMBER_MASK, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_unmap_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_write_same = {
@@ -1518,6 +1558,7 @@ static struct target_opcode_descriptor tcm_opcode_write_same = {
 	.usage_bits = {WRITE_SAME, 0xe8, 0xff, 0xff,
 		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_ws_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_write_same16 = {
@@ -1528,6 +1569,7 @@ static struct target_opcode_descriptor tcm_opcode_write_same16 = {
 		       0xff, 0xff, 0xff, 0xff,
 		       0xff, 0xff, 0xff, 0xff,
 		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_ws_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_verify = {
@@ -1613,6 +1655,13 @@ static struct target_opcode_descriptor tcm_opcode_pri_read_resrv = {
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
@@ -1622,6 +1671,7 @@ static struct target_opcode_descriptor tcm_opcode_pri_read_caps = {
 	.usage_bits = {PERSISTENT_RESERVE_IN, PRI_REPORT_CAPABILITIES, 0x00, 0x00,
 		       0x00, 0x00, 0x00, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_pri_read_full_status = {
@@ -1633,6 +1683,7 @@ static struct target_opcode_descriptor tcm_opcode_pri_read_full_status = {
 	.usage_bits = {PERSISTENT_RESERVE_IN, PRI_READ_FULL_STATUS, 0x00, 0x00,
 		       0x00, 0x00, 0x00, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_pro_register = {
@@ -1644,6 +1695,7 @@ static struct target_opcode_descriptor tcm_opcode_pro_register = {
 	.usage_bits = {PERSISTENT_RESERVE_OUT, PRO_REGISTER, 0xff, 0x00,
 		       0x00, 0xff, 0xff, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_pro_reserve = {
@@ -1655,6 +1707,7 @@ static struct target_opcode_descriptor tcm_opcode_pro_reserve = {
 	.usage_bits = {PERSISTENT_RESERVE_OUT, PRO_RESERVE, 0xff, 0x00,
 		       0x00, 0xff, 0xff, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_pro_release = {
@@ -1666,6 +1719,7 @@ static struct target_opcode_descriptor tcm_opcode_pro_release = {
 	.usage_bits = {PERSISTENT_RESERVE_OUT, PRO_RELEASE, 0xff, 0x00,
 		       0x00, 0xff, 0xff, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_pro_clear = {
@@ -1677,6 +1731,7 @@ static struct target_opcode_descriptor tcm_opcode_pro_clear = {
 	.usage_bits = {PERSISTENT_RESERVE_OUT, PRO_CLEAR, 0xff, 0x00,
 		       0x00, 0xff, 0xff, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_pro_preempt = {
@@ -1688,6 +1743,7 @@ static struct target_opcode_descriptor tcm_opcode_pro_preempt = {
 	.usage_bits = {PERSISTENT_RESERVE_OUT, PRO_PREEMPT, 0xff, 0x00,
 		       0x00, 0xff, 0xff, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_pro_preempt_abort = {
@@ -1699,6 +1755,7 @@ static struct target_opcode_descriptor tcm_opcode_pro_preempt_abort = {
 	.usage_bits = {PERSISTENT_RESERVE_OUT, PRO_PREEMPT_AND_ABORT, 0xff, 0x00,
 		       0x00, 0xff, 0xff, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_pro_reg_ign_exist = {
@@ -1712,6 +1769,7 @@ static struct target_opcode_descriptor tcm_opcode_pro_reg_ign_exist = {
 		0xff, 0x00,
 		0x00, 0xff, 0xff, 0xff,
 		0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_pro_register_move = {
@@ -1723,14 +1781,23 @@ static struct target_opcode_descriptor tcm_opcode_pro_register_move = {
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
@@ -1740,6 +1807,7 @@ static struct target_opcode_descriptor tcm_opcode_release10 = {
 	.usage_bits = {RELEASE_10, 0x00, 0x00, 0x00,
 		       0x00, 0x00, 0x00, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_scsi2_reservations_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_reserve = {
@@ -1748,6 +1816,7 @@ static struct target_opcode_descriptor tcm_opcode_reserve = {
 	.cdb_size = 6,
 	.usage_bits = {RESERVE, 0x00, 0x00, 0x00,
 		       0x00, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_scsi2_reservations_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_reserve10 = {
@@ -1757,6 +1826,7 @@ static struct target_opcode_descriptor tcm_opcode_reserve10 = {
 	.usage_bits = {RESERVE_10, 0x00, 0x00, 0x00,
 		       0x00, 0x00, 0x00, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_scsi2_reservations_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_request_sense = {
@@ -1775,6 +1845,13 @@ static struct target_opcode_descriptor tcm_opcode_inquiry = {
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
@@ -1784,6 +1861,7 @@ static struct target_opcode_descriptor tcm_opcode_extended_copy_lid1 = {
 		       0x00, 0x00, 0x00, 0x00,
 		       0x00, 0x00, 0xff, 0xff,
 		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_3pc_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_rcv_copy_res_op_params = {
@@ -1797,6 +1875,7 @@ static struct target_opcode_descriptor tcm_opcode_rcv_copy_res_op_params = {
 		       0x00, 0x00, 0x00, 0x00,
 		       0x00, 0x00, 0xff, 0xff,
 		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_3pc_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_report_luns = {
@@ -1839,6 +1918,26 @@ static struct target_opcode_descriptor tcm_opcode_report_supp_opcodes = {
 		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
 };
 
+static bool tcm_is_set_tpg_enabled(struct se_cmd *cmd)
+{
+	struct t10_alua_tg_pt_gp *l_tg_pt_gp;
+	struct se_lun *l_lun = cmd->se_lun;
+
+	spin_lock(&l_lun->lun_tg_pt_gp_lock);
+	l_tg_pt_gp = l_lun->lun_tg_pt_gp;
+	if (!l_tg_pt_gp) {
+		spin_unlock(&l_lun->lun_tg_pt_gp_lock);
+		return false;
+	}
+	if (!(l_tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICIT_ALUA)) {
+		spin_unlock(&l_lun->lun_tg_pt_gp_lock);
+		return false;
+	}
+	spin_unlock(&l_lun->lun_tg_pt_gp_lock);
+
+	return true;
+}
+
 static struct target_opcode_descriptor tcm_opcode_set_tpg = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
@@ -1848,6 +1947,7 @@ static struct target_opcode_descriptor tcm_opcode_set_tpg = {
 	.usage_bits = {MAINTENANCE_OUT, MO_SET_TARGET_PGS, 0x00, 0x00,
 		       0x00, 0x00, 0xff, 0xff,
 		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_set_tpg_enabled,
 };
 
 static struct target_opcode_descriptor *tcm_supported_opcodes[] = {
@@ -2003,7 +2103,9 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
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
@@ -2015,9 +2117,10 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
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
@@ -2028,10 +2131,12 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
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
 
@@ -2080,6 +2185,9 @@ spc_emulate_report_supp_op_codes(struct se_cmd *cmd)
 
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


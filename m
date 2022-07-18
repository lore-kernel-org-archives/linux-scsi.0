Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C44CCA489
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 12:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbiGRMDW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 08:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234616AbiGRMDS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 08:03:18 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6076F23BC1;
        Mon, 18 Jul 2022 05:03:17 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id E11E841243;
        Mon, 18 Jul 2022 12:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1658145790; x=1659960191; bh=0UipmKlEVSZpOdJ1kLDoCcLvt
        3GLc7DWU/ZXydBphsk=; b=sKeA3iz7AJDI5pbjqVvH8cJC7HFmnq46BO7utL3AW
        iMSmMiccVIV27xGjre+xGI5Ov1Br50kt0snOC9otw95RBFix3Tcp1KLL2hM6VKxj
        apvadhuMW1jz9uIZEOx2VWouI+mYpN4JMk2vj90lr40yMM6YKpj1HcPC0YMUxuwH
        Z8=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id acTENU3WBE07; Mon, 18 Jul 2022 15:03:10 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 4F6A541242;
        Mon, 18 Jul 2022 15:03:07 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 18 Jul 2022 15:03:07 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Mon, 18 Jul 2022 15:03:06 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 1/6] scsi: target: core: add support of RSOC command
Date:   Mon, 18 Jul 2022 15:01:12 +0300
Message-ID: <20220718120117.4435-2-d.bogdanov@yadro.com>
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

Add support of REPORT SUPPORTED OPERATION CODES command according
to SPC4.

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_spc.c  | 200 ++++++++++++++++++++++++++++++
 include/scsi/scsi_proto.h         |   7 ++
 include/target/target_core_base.h |  12 ++
 3 files changed, 219 insertions(+)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index c14441c89bed..4157f73977cf 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1308,6 +1308,202 @@ spc_emulate_testunitready(struct se_cmd *cmd)
 	return 0;
 }
 
+
+static struct target_opcode_descriptor *tcm_supported_opcodes[] = {
+};
+
+static int
+spc_rsoc_encode_command_timeouts_descriptor(unsigned char *buf, u8 ctdp,
+				struct target_opcode_descriptor *descr)
+{
+	if (!ctdp)
+		return 0;
+
+	put_unaligned_be16(0xa, buf);
+	buf[3] = descr->specific_timeout;
+	put_unaligned_be32(descr->nominal_timeout, &buf[4]);
+	put_unaligned_be32(descr->recommended_timeout, &buf[8]);
+
+	return 12;
+}
+
+static int
+spc_rsoc_encode_command_descriptor(unsigned char *buf, u8 ctdp,
+				   struct target_opcode_descriptor *descr)
+{
+	int td_size = 0;
+
+	buf[0] = descr->opcode;
+
+	put_unaligned_be16(descr->service_action, &buf[2]);
+
+	buf[5] = (ctdp << 1) | descr->serv_action_valid;
+	put_unaligned_be16(descr->cdb_size, &buf[6]);
+
+	td_size = spc_rsoc_encode_command_timeouts_descriptor(&buf[8], ctdp,
+							      descr);
+
+	return 8 + td_size;
+}
+
+static int
+spc_rsoc_encode_one_command_descriptor(unsigned char *buf, u8 ctdp,
+				       struct target_opcode_descriptor *descr)
+{
+	int td_size = 0;
+
+	if (!descr) {
+		buf[1] = (ctdp << 7) | SCSI_SUPPORT_NOT_SUPPORTED;
+		return 2;
+	}
+
+	buf[1] = (ctdp << 7) | SCSI_SUPPORT_FULL;
+	put_unaligned_be16(descr->cdb_size, &buf[2]);
+	memcpy(&buf[4], descr->usage_bits, descr->cdb_size);
+
+	td_size = spc_rsoc_encode_command_timeouts_descriptor(
+			&buf[4 + descr->cdb_size], ctdp, descr);
+
+	return 4 + descr->cdb_size + td_size;
+}
+
+static sense_reason_t
+spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
+{
+	struct target_opcode_descriptor *descr;
+	struct se_session *sess = cmd->se_sess;
+	unsigned char *cdb = cmd->t_task_cdb;
+	u8 opts = cdb[2] & 0x3;
+	u8 requested_opcode;
+	u16 requested_sa;
+	int i;
+
+	requested_opcode = cdb[3];
+	requested_sa = ((u16)cdb[4]) << 8 | cdb[5];
+	*opcode = NULL;
+
+	if (opts > 3) {
+		pr_debug("TARGET_CORE[%s]: Invalid REPORT SUPPORTED OPERATION CODES"
+			" with unsupported REPORTING OPTIONS %#x for 0x%08llx from %s\n",
+			cmd->se_tfo->fabric_name, opts,
+			cmd->se_lun->unpacked_lun,
+			sess->se_node_acl->initiatorname);
+		return TCM_INVALID_CDB_FIELD;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(tcm_supported_opcodes); i++) {
+		descr = tcm_supported_opcodes[i];
+		if (descr->opcode != requested_opcode)
+			continue;
+
+		switch (opts) {
+		case 0x1:
+			/*
+			 * If the REQUESTED OPERATION CODE field specifies an
+			 * operation code for which the device server implements
+			 * service actions, then the device server shall
+			 * terminate the command with CHECK CONDITION status,
+			 * with the sense key set to ILLEGAL REQUEST, and the
+			 * additional sense code set to INVALID FIELD IN CDB
+			 */
+			if (descr->serv_action_valid)
+				return TCM_INVALID_CDB_FIELD;
+			*opcode = descr;
+			break;
+		case 0x2:
+			/*
+			 * If the REQUESTED OPERATION CODE field specifies an
+			 * operation code for which the device server does not
+			 * implement service actions, then the device server
+			 * shall terminate the command with CHECK CONDITION
+			 * status, with the sense key set to ILLEGAL REQUEST,
+			 * and the additional sense code set to INVALID FIELD IN CDB.
+			 */
+			if (descr->serv_action_valid &&
+			    descr->service_action == requested_sa)
+				*opcode = descr;
+			else if (!descr->serv_action_valid)
+				return TCM_INVALID_CDB_FIELD;
+			break;
+		case 0x3:
+			/*
+			 * The command support data for the operation code and
+			 * service action a specified in the REQUESTED OPERATION
+			 * CODE field and REQUESTED SERVICE ACTION field shall
+			 * be returned in the one_command parameter data format.
+			 */
+			if (descr->service_action == requested_sa)
+				*opcode = descr;
+			break;
+		}
+	}
+	return 0;
+}
+
+static sense_reason_t
+spc_emulate_report_supp_op_codes(struct se_cmd *cmd)
+{
+	int descr_num = ARRAY_SIZE(tcm_supported_opcodes);
+	struct target_opcode_descriptor *descr = NULL;
+	unsigned char *cdb = cmd->t_task_cdb;
+	u8 rctd = (cdb[2] >> 7) & 0x1;
+	unsigned char *buf = NULL;
+	int response_length = 0;
+	u8 opts = cdb[2] & 0x3;
+	unsigned char *rbuf;
+	int ret = 0;
+	int i;
+
+	rbuf = transport_kmap_data_sg(cmd);
+	if (cmd->data_length && !rbuf) {
+		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		goto out;
+	}
+
+	if (opts == 0)
+		response_length = 4 + (8 + rctd * 12) * descr_num;
+	else {
+		ret = spc_rsoc_get_descr(cmd, &descr);
+		if (ret)
+			goto out;
+
+		if (descr)
+			response_length = 4 + descr->cdb_size + rctd * 12;
+		else
+			response_length = 2;
+	}
+
+	buf = kzalloc(response_length, GFP_KERNEL);
+	if (!buf) {
+		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		goto out;
+	}
+	response_length = 0;
+
+	if (opts == 0) {
+		response_length += 4;
+
+		for (i = 0; i < ARRAY_SIZE(tcm_supported_opcodes); i++) {
+			descr = tcm_supported_opcodes[i];
+			response_length += spc_rsoc_encode_command_descriptor(
+					&buf[response_length], rctd, descr);
+		}
+		put_unaligned_be32(response_length - 3, buf);
+	} else {
+		response_length = spc_rsoc_encode_one_command_descriptor(
+				&buf[response_length], rctd, descr);
+	}
+
+	memcpy(rbuf, buf, min_t(u32, response_length, cmd->data_length));
+out:
+	kfree(buf);
+	transport_kunmap_data_sg(cmd);
+
+	if (!ret)
+		target_complete_cmd_with_length(cmd, SAM_STAT_GOOD, response_length);
+	return ret;
+}
+
 sense_reason_t
 spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 {
@@ -1433,6 +1629,10 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 				cmd->execute_cmd =
 					target_emulate_report_target_port_groups;
 			}
+			if ((cdb[1] & 0x1f) ==
+			    MI_REPORT_SUPPORTED_OPERATION_CODES)
+				cmd->execute_cmd =
+					spc_emulate_report_supp_op_codes;
 			*size = get_unaligned_be32(&cdb[6]);
 		} else {
 			/*
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index c03e35fc382c..651b5183451c 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -342,4 +342,11 @@ enum scsi_version_descriptor {
 	SCSI_VERSION_DESCRIPTOR_SRP	= 0x0940
 };
 
+enum scsi_support_opcode {
+	SCSI_SUPPORT_NO_INFO		= 0,
+	SCSI_SUPPORT_NOT_SUPPORTED	= 1,
+	SCSI_SUPPORT_FULL		= 3,
+	SCSI_SUPPORT_VENDOR		= 5,
+};
+
 #endif /* _SCSI_PROTO_H_ */
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index c2b36f7d917d..d93c65bcbc11 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -867,6 +867,18 @@ struct se_device {
 	struct se_device_queue	*queues;
 };
 
+struct target_opcode_descriptor {
+	u8			support:3;
+	u8			serv_action_valid:1;
+	u8			opcode;
+	u16			service_action;
+	u32			cdb_size;
+	u8			specific_timeout;
+	u16			nominal_timeout;
+	u16			recommended_timeout;
+	u8			usage_bits[];
+};
+
 struct se_hba {
 	u16			hba_tpgt;
 	u32			hba_id;
-- 
2.25.1


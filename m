Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76107C6FA9D
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Sep 2022 10:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239817AbiIFKr3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Sep 2022 06:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239841AbiIFKqf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2022 06:46:35 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560E77C191;
        Tue,  6 Sep 2022 03:45:27 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id DC59D448FE;
        Tue,  6 Sep 2022 10:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1662461112; x=1664275513; bh=GMxfsHa4lO98PsGtvn+1GQMtd
        +lPCms68TzX9MmBgBM=; b=B1BbJeHHPE5O0nOiSQIU06sIHzhdLHQPPMgvrv55d
        um593uv1qCVBY2kxgjpFmDndHXoAww1X3TZTdzkV4+W8426M5Tiu5pepql2YqWBt
        DGkgrmoNe8dN2Me16wbwPm6p8/fn89XfohMXQzPBN+50H9mEbhcWutRPtCXLVdcl
        N4=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pfM_uf6tFTOk; Tue,  6 Sep 2022 13:45:12 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 9AA9556591;
        Tue,  6 Sep 2022 13:34:44 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 6 Sep 2022 13:34:44 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Tue, 6 Sep 2022 13:34:40 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 2/6] scsi: target: core: add list of opcodes for RSOC
Date:   Tue, 6 Sep 2022 13:34:17 +0300
Message-ID: <20220906103421.22348-3-d.bogdanov@yadro.com>
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

Fill the strucures for supported Opcodes and Usage Bits that is reported
in REPORT SUPPORTED OPERATION CODES command response.

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
v2:
  remove XDWRITEREAD_*
---
 drivers/target/target_core_spc.c | 568 +++++++++++++++++++++++++++++++
 include/scsi/scsi_proto.h        |   3 +
 2 files changed, 571 insertions(+)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 7e61c0e45034..043c08abf338 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1308,8 +1308,576 @@ spc_emulate_testunitready(struct se_cmd *cmd)
 	return 0;
 }
 
+static struct target_opcode_descriptor tcm_opcode_read6 = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = READ_6,
+	.cdb_size = 6,
+	.usage_bits = {READ_6, 0x1f, 0xff, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_read10 = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = READ_10,
+	.cdb_size = 10,
+	.usage_bits = {READ_10, 0xf8, 0xff, 0xff,
+		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_read12 = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = READ_12,
+	.cdb_size = 12,
+	.usage_bits = {READ_12, 0xf8, 0xff, 0xff,
+		       0xff, 0xff, 0xff, 0xff,
+		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_read16 = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = READ_16,
+	.cdb_size = 16,
+	.usage_bits = {READ_16, 0xf8, 0xff, 0xff,
+		       0xff, 0xff, 0xff, 0xff,
+		       0xff, 0xff, 0xff, 0xff,
+		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_write6 = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = WRITE_6,
+	.cdb_size = 6,
+	.usage_bits = {WRITE_6, 0x1f, 0xff, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_write10 = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = WRITE_10,
+	.cdb_size = 10,
+	.usage_bits = {WRITE_10, 0xf8, 0xff, 0xff,
+		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_write_verify10 = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = WRITE_VERIFY,
+	.cdb_size = 10,
+	.usage_bits = {WRITE_VERIFY, 0xf0, 0xff, 0xff,
+		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_write12 = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = WRITE_12,
+	.cdb_size = 12,
+	.usage_bits = {WRITE_12, 0xf8, 0xff, 0xff,
+		       0xff, 0xff, 0xff, 0xff,
+		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_write16 = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = WRITE_16,
+	.cdb_size = 16,
+	.usage_bits = {WRITE_16, 0xf8, 0xff, 0xff,
+		       0xff, 0xff, 0xff, 0xff,
+		       0xff, 0xff, 0xff, 0xff,
+		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_write_verify16 = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = WRITE_VERIFY_16,
+	.cdb_size = 16,
+	.usage_bits = {WRITE_VERIFY_16, 0xf0, 0xff, 0xff,
+		       0xff, 0xff, 0xff, 0xff,
+		       0xff, 0xff, 0xff, 0xff,
+		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_write_same32 = {
+	.support = SCSI_SUPPORT_FULL,
+	.serv_action_valid = 1,
+	.opcode = VARIABLE_LENGTH_CMD,
+	.service_action = WRITE_SAME_32,
+	.cdb_size = 32,
+	.usage_bits = {VARIABLE_LENGTH_CMD, SCSI_CONTROL_MASK, 0x00, 0x00,
+		       0x00, 0x00, SCSI_GROUP_NUMBER_MASK, 0x18,
+		       0x00, WRITE_SAME_32, 0xe8, 0x00,
+		       0xff, 0xff, 0xff, 0xff,
+		       0xff, 0xff, 0xff, 0xff,
+		       0x00, 0x00, 0x00, 0x00,
+		       0x00, 0x00, 0x00, 0x00,
+		       0xff, 0xff, 0xff, 0xff},
+};
+
+static struct target_opcode_descriptor tcm_opcode_compare_write = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = COMPARE_AND_WRITE,
+	.cdb_size = 16,
+	.usage_bits = {COMPARE_AND_WRITE, 0x18, 0xff, 0xff,
+		       0xff, 0xff, 0xff, 0xff,
+		       0xff, 0xff, 0x00, 0x00,
+		       0x00, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_read_capacity = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = READ_CAPACITY,
+	.cdb_size = 10,
+	.usage_bits = {READ_CAPACITY, 0x00, 0xff, 0xff,
+		       0xff, 0xff, 0x00, 0x00,
+		       0x01, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_read_capacity16 = {
+	.support = SCSI_SUPPORT_FULL,
+	.serv_action_valid = 1,
+	.opcode = SERVICE_ACTION_IN_16,
+	.service_action = SAI_READ_CAPACITY_16,
+	.cdb_size = 16,
+	.usage_bits = {SERVICE_ACTION_IN_16, SAI_READ_CAPACITY_16, 0x00, 0x00,
+		       0x00, 0x00, 0x00, 0x00,
+		       0x00, 0x00, 0xff, 0xff,
+		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_read_report_refferals = {
+	.support = SCSI_SUPPORT_FULL,
+	.serv_action_valid = 1,
+	.opcode = SERVICE_ACTION_IN_16,
+	.service_action = SAI_REPORT_REFERRALS,
+	.cdb_size = 16,
+	.usage_bits = {SERVICE_ACTION_IN_16, SAI_REPORT_REFERRALS, 0x00, 0x00,
+		       0x00, 0x00, 0x00, 0x00,
+		       0x00, 0x00, 0xff, 0xff,
+		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_sync_cache = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = SYNCHRONIZE_CACHE,
+	.cdb_size = 10,
+	.usage_bits = {SYNCHRONIZE_CACHE, 0x02, 0xff, 0xff,
+		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_sync_cache16 = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = SYNCHRONIZE_CACHE_16,
+	.cdb_size = 16,
+	.usage_bits = {SYNCHRONIZE_CACHE_16, 0x02, 0xff, 0xff,
+		       0xff, 0xff, 0xff, 0xff,
+		       0xff, 0xff, 0xff, 0xff,
+		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_unmap = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = UNMAP,
+	.cdb_size = 10,
+	.usage_bits = {UNMAP, 0x00, 0x00, 0x00,
+		       0x00, 0x00, SCSI_GROUP_NUMBER_MASK, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_write_same = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = WRITE_SAME,
+	.cdb_size = 10,
+	.usage_bits = {WRITE_SAME, 0xe8, 0xff, 0xff,
+		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_write_same16 = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = WRITE_SAME_16,
+	.cdb_size = 16,
+	.usage_bits = {WRITE_SAME_16, 0xe8, 0xff, 0xff,
+		       0xff, 0xff, 0xff, 0xff,
+		       0xff, 0xff, 0xff, 0xff,
+		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_verify = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = VERIFY,
+	.cdb_size = 10,
+	.usage_bits = {VERIFY, 0x00, 0xff, 0xff,
+		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_verify16 = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = VERIFY_16,
+	.cdb_size = 16,
+	.usage_bits = {VERIFY_16, 0x00, 0xff, 0xff,
+		       0xff, 0xff, 0xff, 0xff,
+		       0xff, 0xff, 0xff, 0xff,
+		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_start_stop = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = START_STOP,
+	.cdb_size = 6,
+	.usage_bits = {START_STOP, 0x01, 0x00, 0x00,
+		       0x01, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_mode_select = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = MODE_SELECT,
+	.cdb_size = 6,
+	.usage_bits = {MODE_SELECT, 0x10, 0x00, 0x00,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_mode_select10 = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = MODE_SELECT_10,
+	.cdb_size = 10,
+	.usage_bits = {MODE_SELECT_10, 0x10, 0x00, 0x00,
+		       0x00, 0x00, 0x00, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_mode_sense = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = MODE_SENSE,
+	.cdb_size = 6,
+	.usage_bits = {MODE_SENSE, 0x08, 0xff, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_mode_sense10 = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = MODE_SENSE_10,
+	.cdb_size = 10,
+	.usage_bits = {MODE_SENSE_10, 0x18, 0xff, 0xff,
+		       0x00, 0x00, 0x00, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_pri_read_keys = {
+	.support = SCSI_SUPPORT_FULL,
+	.serv_action_valid = 1,
+	.opcode = PERSISTENT_RESERVE_IN,
+	.service_action = PRI_READ_KEYS,
+	.cdb_size = 10,
+	.usage_bits = {PERSISTENT_RESERVE_IN, PRI_READ_KEYS, 0x00, 0x00,
+		       0x00, 0x00, 0x00, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_pri_read_resrv = {
+	.support = SCSI_SUPPORT_FULL,
+	.serv_action_valid = 1,
+	.opcode = PERSISTENT_RESERVE_IN,
+	.service_action = PRI_READ_RESERVATION,
+	.cdb_size = 10,
+	.usage_bits = {PERSISTENT_RESERVE_IN, PRI_READ_RESERVATION, 0x00, 0x00,
+		       0x00, 0x00, 0x00, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_pri_read_caps = {
+	.support = SCSI_SUPPORT_FULL,
+	.serv_action_valid = 1,
+	.opcode = PERSISTENT_RESERVE_IN,
+	.service_action = PRI_REPORT_CAPABILITIES,
+	.cdb_size = 10,
+	.usage_bits = {PERSISTENT_RESERVE_IN, PRI_REPORT_CAPABILITIES, 0x00, 0x00,
+		       0x00, 0x00, 0x00, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_pri_read_full_status = {
+	.support = SCSI_SUPPORT_FULL,
+	.serv_action_valid = 1,
+	.opcode = PERSISTENT_RESERVE_IN,
+	.service_action = PRI_READ_FULL_STATUS,
+	.cdb_size = 10,
+	.usage_bits = {PERSISTENT_RESERVE_IN, PRI_READ_FULL_STATUS, 0x00, 0x00,
+		       0x00, 0x00, 0x00, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_pro_register = {
+	.support = SCSI_SUPPORT_FULL,
+	.serv_action_valid = 1,
+	.opcode = PERSISTENT_RESERVE_OUT,
+	.service_action = PRO_REGISTER,
+	.cdb_size = 10,
+	.usage_bits = {PERSISTENT_RESERVE_OUT, PRO_REGISTER, 0xff, 0x00,
+		       0x00, 0xff, 0xff, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_pro_reserve = {
+	.support = SCSI_SUPPORT_FULL,
+	.serv_action_valid = 1,
+	.opcode = PERSISTENT_RESERVE_OUT,
+	.service_action = PRO_RESERVE,
+	.cdb_size = 10,
+	.usage_bits = {PERSISTENT_RESERVE_OUT, PRO_RESERVE, 0xff, 0x00,
+		       0x00, 0xff, 0xff, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_pro_release = {
+	.support = SCSI_SUPPORT_FULL,
+	.serv_action_valid = 1,
+	.opcode = PERSISTENT_RESERVE_OUT,
+	.service_action = PRO_RELEASE,
+	.cdb_size = 10,
+	.usage_bits = {PERSISTENT_RESERVE_OUT, PRO_RELEASE, 0xff, 0x00,
+		       0x00, 0xff, 0xff, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_pro_clear = {
+	.support = SCSI_SUPPORT_FULL,
+	.serv_action_valid = 1,
+	.opcode = PERSISTENT_RESERVE_OUT,
+	.service_action = PRO_CLEAR,
+	.cdb_size = 10,
+	.usage_bits = {PERSISTENT_RESERVE_OUT, PRO_CLEAR, 0xff, 0x00,
+		       0x00, 0xff, 0xff, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_pro_preempt = {
+	.support = SCSI_SUPPORT_FULL,
+	.serv_action_valid = 1,
+	.opcode = PERSISTENT_RESERVE_OUT,
+	.service_action = PRO_PREEMPT,
+	.cdb_size = 10,
+	.usage_bits = {PERSISTENT_RESERVE_OUT, PRO_PREEMPT, 0xff, 0x00,
+		       0x00, 0xff, 0xff, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_pro_preempt_abort = {
+	.support = SCSI_SUPPORT_FULL,
+	.serv_action_valid = 1,
+	.opcode = PERSISTENT_RESERVE_OUT,
+	.service_action = PRO_PREEMPT_AND_ABORT,
+	.cdb_size = 10,
+	.usage_bits = {PERSISTENT_RESERVE_OUT, PRO_PREEMPT_AND_ABORT, 0xff, 0x00,
+		       0x00, 0xff, 0xff, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_pro_reg_ign_exist = {
+	.support = SCSI_SUPPORT_FULL,
+	.serv_action_valid = 1,
+	.opcode = PERSISTENT_RESERVE_OUT,
+	.service_action = PRO_REGISTER_AND_IGNORE_EXISTING_KEY,
+	.cdb_size = 10,
+	.usage_bits = {
+		PERSISTENT_RESERVE_OUT, PRO_REGISTER_AND_IGNORE_EXISTING_KEY,
+		0xff, 0x00,
+		0x00, 0xff, 0xff, 0xff,
+		0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_pro_register_move = {
+	.support = SCSI_SUPPORT_FULL,
+	.serv_action_valid = 1,
+	.opcode = PERSISTENT_RESERVE_OUT,
+	.service_action = PRO_REGISTER_AND_MOVE,
+	.cdb_size = 10,
+	.usage_bits = {PERSISTENT_RESERVE_OUT, PRO_REGISTER_AND_MOVE, 0xff, 0x00,
+		       0x00, 0xff, 0xff, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_release = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = RELEASE,
+	.cdb_size = 6,
+	.usage_bits = {RELEASE, 0x00, 0x00, 0x00,
+		       0x00, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_release10 = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = RELEASE_10,
+	.cdb_size = 10,
+	.usage_bits = {RELEASE_10, 0x00, 0x00, 0x00,
+		       0x00, 0x00, 0x00, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_reserve = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = RESERVE,
+	.cdb_size = 6,
+	.usage_bits = {RESERVE, 0x00, 0x00, 0x00,
+		       0x00, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_reserve10 = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = RESERVE_10,
+	.cdb_size = 10,
+	.usage_bits = {RESERVE_10, 0x00, 0x00, 0x00,
+		       0x00, 0x00, 0x00, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_request_sense = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = REQUEST_SENSE,
+	.cdb_size = 6,
+	.usage_bits = {REQUEST_SENSE, 0x00, 0x00, 0x00,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_inquiry = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = INQUIRY,
+	.cdb_size = 6,
+	.usage_bits = {INQUIRY, 0x01, 0xff, 0xff,
+		       0xff, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_extended_copy_lid1 = {
+	.support = SCSI_SUPPORT_FULL,
+	.serv_action_valid = 1,
+	.opcode = EXTENDED_COPY,
+	.cdb_size = 16,
+	.usage_bits = {EXTENDED_COPY, 0x00, 0x00, 0x00,
+		       0x00, 0x00, 0x00, 0x00,
+		       0x00, 0x00, 0xff, 0xff,
+		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_rcv_copy_res_op_params = {
+	.support = SCSI_SUPPORT_FULL,
+	.serv_action_valid = 1,
+	.opcode = RECEIVE_COPY_RESULTS,
+	.service_action = RCR_SA_OPERATING_PARAMETERS,
+	.cdb_size = 16,
+	.usage_bits = {RECEIVE_COPY_RESULTS, RCR_SA_OPERATING_PARAMETERS,
+		       0x00, 0x00,
+		       0x00, 0x00, 0x00, 0x00,
+		       0x00, 0x00, 0xff, 0xff,
+		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_report_luns = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = REPORT_LUNS,
+	.cdb_size = 12,
+	.usage_bits = {REPORT_LUNS, 0x00, 0xff, 0x00,
+		       0x00, 0x00, 0xff, 0xff,
+		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_test_unit_ready = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = TEST_UNIT_READY,
+	.cdb_size = 6,
+	.usage_bits = {TEST_UNIT_READY, 0x00, 0x00, 0x00,
+		       0x00, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_report_target_pgs = {
+	.support = SCSI_SUPPORT_FULL,
+	.serv_action_valid = 1,
+	.opcode = MAINTENANCE_IN,
+	.service_action = MI_REPORT_TARGET_PGS,
+	.cdb_size = 12,
+	.usage_bits = {MAINTENANCE_IN, 0xE0 | MI_REPORT_TARGET_PGS, 0x00, 0x00,
+		       0x00, 0x00, 0xff, 0xff,
+		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_report_supp_opcodes = {
+	.support = SCSI_SUPPORT_FULL,
+	.serv_action_valid = 1,
+	.opcode = MAINTENANCE_IN,
+	.service_action = MI_REPORT_SUPPORTED_OPERATION_CODES,
+	.cdb_size = 12,
+	.usage_bits = {MAINTENANCE_IN, MI_REPORT_SUPPORTED_OPERATION_CODES,
+		       0x87, 0xff,
+		       0xff, 0xff, 0xff, 0xff,
+		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
+};
+
+static struct target_opcode_descriptor tcm_opcode_set_tpg = {
+	.support = SCSI_SUPPORT_FULL,
+	.serv_action_valid = 1,
+	.opcode = MAINTENANCE_OUT,
+	.service_action = MO_SET_TARGET_PGS,
+	.cdb_size = 12,
+	.usage_bits = {MAINTENANCE_OUT, MO_SET_TARGET_PGS, 0x00, 0x00,
+		       0x00, 0x00, 0xff, 0xff,
+		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
+};
 
 static struct target_opcode_descriptor *tcm_supported_opcodes[] = {
+	&tcm_opcode_read6,
+	&tcm_opcode_read10,
+	&tcm_opcode_read12,
+	&tcm_opcode_read16,
+	&tcm_opcode_write6,
+	&tcm_opcode_write10,
+	&tcm_opcode_write_verify10,
+	&tcm_opcode_write12,
+	&tcm_opcode_write16,
+	&tcm_opcode_write_verify16,
+	&tcm_opcode_write_same32,
+	&tcm_opcode_compare_write,
+	&tcm_opcode_read_capacity,
+	&tcm_opcode_read_capacity16,
+	&tcm_opcode_read_report_refferals,
+	&tcm_opcode_sync_cache,
+	&tcm_opcode_sync_cache16,
+	&tcm_opcode_unmap,
+	&tcm_opcode_write_same,
+	&tcm_opcode_write_same16,
+	&tcm_opcode_verify,
+	&tcm_opcode_verify16,
+	&tcm_opcode_start_stop,
+	&tcm_opcode_mode_select,
+	&tcm_opcode_mode_select10,
+	&tcm_opcode_mode_sense,
+	&tcm_opcode_mode_sense10,
+	&tcm_opcode_pri_read_keys,
+	&tcm_opcode_pri_read_resrv,
+	&tcm_opcode_pri_read_caps,
+	&tcm_opcode_pri_read_full_status,
+	&tcm_opcode_pro_register,
+	&tcm_opcode_pro_reserve,
+	&tcm_opcode_pro_release,
+	&tcm_opcode_pro_clear,
+	&tcm_opcode_pro_preempt,
+	&tcm_opcode_pro_preempt_abort,
+	&tcm_opcode_pro_reg_ign_exist,
+	&tcm_opcode_pro_register_move,
+	&tcm_opcode_release,
+	&tcm_opcode_release10,
+	&tcm_opcode_reserve,
+	&tcm_opcode_reserve10,
+	&tcm_opcode_request_sense,
+	&tcm_opcode_inquiry,
+	&tcm_opcode_extended_copy_lid1,
+	&tcm_opcode_rcv_copy_res_op_params,
+	&tcm_opcode_report_luns,
+	&tcm_opcode_test_unit_ready,
+	&tcm_opcode_report_target_pgs,
+	&tcm_opcode_report_supp_opcodes,
+	&tcm_opcode_set_tpg,
 };
 
 static int
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index 651b5183451c..cb722225b3bc 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -349,4 +349,7 @@ enum scsi_support_opcode {
 	SCSI_SUPPORT_VENDOR		= 5,
 };
 
+#define SCSI_CONTROL_MASK 0
+#define SCSI_GROUP_NUMBER_MASK 0
+
 #endif /* _SCSI_PROTO_H_ */
-- 
2.25.1


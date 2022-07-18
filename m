Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5AE7CCA488
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 12:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbiGRMDX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 08:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234617AbiGRMDT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 08:03:19 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5412023BDD;
        Mon, 18 Jul 2022 05:03:18 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id CF39A412C3;
        Mon, 18 Jul 2022 12:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1658145795; x=1659960196; bh=emVX6gZZl8+ClSdRYIIaA168a
        UJ16Hj1tjQJc9rQ5LA=; b=f0heVDtSNkX/LA/yUVzaABCVFUv82wtKY1mY6JBYh
        hsPytB9JU5P5OxxxlbrF5WeWfSiVUkvHyNLZgSPvxvpncf1RuQO5cpZSaG6PD9Je
        yudtNiyUgqudRwdDdeF4+eurT3GMq4BvyvwUN/M/uKyyXVBqN8aFAXVgoqu52bnI
        tc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ze-xgADi2bcG; Mon, 18 Jul 2022 15:03:15 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 1C30841257;
        Mon, 18 Jul 2022 15:03:10 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
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
Subject: [PATCH 4/6] scsi: target: core: add emulate_rsoc attribute
Date:   Mon, 18 Jul 2022 15:01:15 +0300
Message-ID: <20220718120117.4435-5-d.bogdanov@yadro.com>
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

Make support of RSOC turned off by emulate_rsoc attibute.

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_configfs.c | 20 ++++++++++++++++++++
 drivers/target/target_core_device.c   |  1 +
 drivers/target/target_core_spc.c      | 12 ++++++++++++
 include/target/target_core_base.h     |  3 +++
 4 files changed, 36 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index bbcbbfa72b07..0c1fb222c9da 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -547,6 +547,7 @@ DEF_CONFIGFS_ATTRIB_SHOW(unmap_granularity);
 DEF_CONFIGFS_ATTRIB_SHOW(unmap_granularity_alignment);
 DEF_CONFIGFS_ATTRIB_SHOW(unmap_zeroes_data);
 DEF_CONFIGFS_ATTRIB_SHOW(max_write_same_len);
+DEF_CONFIGFS_ATTRIB_SHOW(emulate_rsoc);
 
 #define DEF_CONFIGFS_ATTRIB_STORE_U32(_name)				\
 static ssize_t _name##_store(struct config_item *item, const char *page,\
@@ -1175,6 +1176,23 @@ static ssize_t pgr_support_store(struct config_item *item,
 	return count;
 }
 
+static ssize_t emulate_rsoc_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct se_dev_attrib *da = to_attrib(item);
+	bool flag;
+	int ret;
+
+	ret = strtobool(page, &flag);
+	if (ret < 0)
+		return ret;
+
+	da->emulate_rsoc = flag;
+	pr_debug("dev[%p]: SE Device REPORT_SUPPORTED_OPERATION_CODES_EMULATION flag: %d\n",
+			da->da_dev, flag);
+	return count;
+}
+
 CONFIGFS_ATTR(, emulate_model_alias);
 CONFIGFS_ATTR(, emulate_dpo);
 CONFIGFS_ATTR(, emulate_fua_write);
@@ -1187,6 +1205,7 @@ CONFIGFS_ATTR(, emulate_tpws);
 CONFIGFS_ATTR(, emulate_caw);
 CONFIGFS_ATTR(, emulate_3pc);
 CONFIGFS_ATTR(, emulate_pr);
+CONFIGFS_ATTR(, emulate_rsoc);
 CONFIGFS_ATTR(, pi_prot_type);
 CONFIGFS_ATTR_RO(, hw_pi_prot_type);
 CONFIGFS_ATTR(, pi_prot_format);
@@ -1250,6 +1269,7 @@ struct configfs_attribute *sbc_attrib_attrs[] = {
 	&attr_max_write_same_len,
 	&attr_alua_support,
 	&attr_pgr_support,
+	&attr_emulate_rsoc,
 	NULL,
 };
 EXPORT_SYMBOL(sbc_attrib_attrs);
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 25f33eb25337..600f038217c0 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -795,6 +795,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	dev->dev_attrib.emulate_caw = DA_EMULATE_CAW;
 	dev->dev_attrib.emulate_3pc = DA_EMULATE_3PC;
 	dev->dev_attrib.emulate_pr = DA_EMULATE_PR;
+	dev->dev_attrib.emulate_rsoc = DA_EMULATE_RSOC;
 	dev->dev_attrib.pi_prot_type = TARGET_DIF_TYPE0_PROT;
 	dev->dev_attrib.enforce_pr_isids = DA_ENFORCE_PR_ISIDS;
 	dev->dev_attrib.force_pr_aptpl = DA_FORCE_PR_APTPL;
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index cf516136b933..a86f4d917aad 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1906,6 +1906,14 @@ static struct target_opcode_descriptor tcm_opcode_report_target_pgs = {
 		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
 };
 
+
+static bool spc_rsoc_enabled(struct se_cmd *cmd)
+{
+	struct se_device *dev = cmd->se_dev;
+
+	return dev->dev_attrib.emulate_rsoc;
+}
+
 static struct target_opcode_descriptor tcm_opcode_report_supp_opcodes = {
 	.support = SCSI_SUPPORT_FULL,
 	.serv_action_valid = 1,
@@ -1916,6 +1924,7 @@ static struct target_opcode_descriptor tcm_opcode_report_supp_opcodes = {
 		       0x87, 0xff,
 		       0xff, 0xff, 0xff, 0xff,
 		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
+	.enabled = spc_rsoc_enabled,
 };
 
 static bool tcm_is_set_tpg_enabled(struct se_cmd *cmd)
@@ -2154,6 +2163,9 @@ spc_emulate_report_supp_op_codes(struct se_cmd *cmd)
 	int ret = 0;
 	int i;
 
+	if (!cmd->se_dev->dev_attrib.emulate_rsoc)
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+
 	rbuf = transport_kmap_data_sg(cmd);
 	if (cmd->data_length && !rbuf) {
 		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 329f88680367..8f8b51d2bc7b 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -91,6 +91,8 @@
 #define DA_EMULATE_ALUA				0
 /* Emulate SCSI2 RESERVE/RELEASE and Persistent Reservations by default */
 #define DA_EMULATE_PR				1
+/* Emulation for REPORT SUPPORTED OPERATION CODES */
+#define DA_EMULATE_RSOC				1
 /* Enforce SCSI Initiator Port TransportID with 'ISID' for PR */
 #define DA_ENFORCE_PR_ISIDS			1
 /* Force SPC-3 PR Activate Persistence across Target Power Loss */
@@ -690,6 +692,7 @@ struct se_dev_attrib {
 	bool		emulate_caw;
 	bool		emulate_3pc;
 	bool		emulate_pr;
+	bool		emulate_rsoc;
 	enum target_prot_type pi_prot_type;
 	enum target_prot_type hw_pi_prot_type;
 	bool		pi_prot_verify;
-- 
2.25.1


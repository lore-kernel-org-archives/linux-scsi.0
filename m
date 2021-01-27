Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B0CECAAD5
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Sep 2022 17:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbiIERj4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Sep 2022 13:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbiIERjn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Sep 2022 13:39:43 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62684165B8;
        Mon,  5 Sep 2022 10:39:42 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id EC2AB43B3C;
        Mon,  5 Sep 2022 17:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1662399579; x=1664213980; bh=BB1TdETqg5zCRH9LjO+G+MEgc
        sB4brab9zeIzmRozEI=; b=CHclnY3VovfwF4Dmp3TYX5RtvsdpNokwfMXFP+eqf
        mEdvc86HBDRR3rCbNREVq6qVJGa5tY9OWm2RolxNne78Z7yXhKn/KlC5FHXnoBTj
        DRABju5r75mNbm2fndlPbBPBvARw9ypy+w1UQCuKEkfzWiMQRcgH6gL43+gBFc2J
        0Y=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id C4pya6f59Etl; Mon,  5 Sep 2022 20:39:39 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id DA35243B56;
        Mon,  5 Sep 2022 20:38:49 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 5 Sep 2022 20:38:47 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Mon, 5 Sep 2022 20:38:46 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 4/6] scsi: target: core: add emulate_rsoc attribute
Date:   Wed, 27 Jan 2021 13:42:37 +0300
Message-ID: <20220905173837.2383-5-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220905173837.2383-1-d.bogdanov@yadro.com>
References: <20220905173837.2383-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make support of RSOC turned off by emulate_rsoc attibute.
That is just for testing purposes.

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_configfs.c | 20 ++++++++++++++++++++
 drivers/target/target_core_device.c   |  1 +
 drivers/target/target_core_spc.c      | 12 ++++++++++++
 include/target/target_core_base.h     |  3 +++
 4 files changed, 36 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 416514c5c7ac..533524299ed6 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -547,6 +547,7 @@ DEF_CONFIGFS_ATTRIB_SHOW(unmap_granularity);
 DEF_CONFIGFS_ATTRIB_SHOW(unmap_granularity_alignment);
 DEF_CONFIGFS_ATTRIB_SHOW(unmap_zeroes_data);
 DEF_CONFIGFS_ATTRIB_SHOW(max_write_same_len);
+DEF_CONFIGFS_ATTRIB_SHOW(emulate_rsoc);
 
 #define DEF_CONFIGFS_ATTRIB_STORE_U32(_name)				\
 static ssize_t _name##_store(struct config_item *item, const char *page,\
@@ -1186,6 +1187,23 @@ static ssize_t pgr_support_store(struct config_item *item,
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
@@ -1198,6 +1216,7 @@ CONFIGFS_ATTR(, emulate_tpws);
 CONFIGFS_ATTR(, emulate_caw);
 CONFIGFS_ATTR(, emulate_3pc);
 CONFIGFS_ATTR(, emulate_pr);
+CONFIGFS_ATTR(, emulate_rsoc);
 CONFIGFS_ATTR(, pi_prot_type);
 CONFIGFS_ATTR_RO(, hw_pi_prot_type);
 CONFIGFS_ATTR(, pi_prot_format);
@@ -1261,6 +1280,7 @@ struct configfs_attribute *sbc_attrib_attrs[] = {
 	&attr_max_write_same_len,
 	&attr_alua_support,
 	&attr_pgr_support,
+	&attr_emulate_rsoc,
 	NULL,
 };
 EXPORT_SYMBOL(sbc_attrib_attrs);
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index b7f16ee8aa0e..e7d202b57405 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -785,6 +785,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	dev->dev_attrib.emulate_caw = DA_EMULATE_CAW;
 	dev->dev_attrib.emulate_3pc = DA_EMULATE_3PC;
 	dev->dev_attrib.emulate_pr = DA_EMULATE_PR;
+	dev->dev_attrib.emulate_rsoc = DA_EMULATE_RSOC;
 	dev->dev_attrib.pi_prot_type = TARGET_DIF_TYPE0_PROT;
 	dev->dev_attrib.enforce_pr_isids = DA_ENFORCE_PR_ISIDS;
 	dev->dev_attrib.force_pr_aptpl = DA_FORCE_PR_APTPL;
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 93adf9594b1a..828251163cf0 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1883,6 +1883,14 @@ static struct target_opcode_descriptor tcm_opcode_report_target_pgs = {
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
@@ -1893,6 +1901,7 @@ static struct target_opcode_descriptor tcm_opcode_report_supp_opcodes = {
 		       0x87, 0xff,
 		       0xff, 0xff, 0xff, 0xff,
 		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
+	.enabled = spc_rsoc_enabled,
 };
 
 static bool tcm_is_set_tpg_enabled(struct se_cmd *cmd)
@@ -2129,6 +2138,9 @@ spc_emulate_report_supp_op_codes(struct se_cmd *cmd)
 	sense_reason_t ret = 0;
 	int i;
 
+	if (!cmd->se_dev->dev_attrib.emulate_rsoc)
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+
 	rbuf = transport_kmap_data_sg(cmd);
 	if (cmd->data_length && !rbuf) {
 		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 7542a8de8fb5..062ee8b6c433 100644
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


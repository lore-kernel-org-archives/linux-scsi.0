Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7335C2BB9A
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 12:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 919902360D
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 12:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgLQMig (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 07:38:36 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:36318 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725988AbgLQMif (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Dec 2020 07:38:35 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 0833141386;
        Thu, 17 Dec 2020 12:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1608208670; x=
        1610023071; bh=rRx2knbPTQMq9gJOBQmFMJ3Gn2cNjKuZZ5/RF9SRFbA=; b=X
        XIZuirNZfaytEmYfLh/QLQBKhccu8q7n6+r+w2Vz83bUKZpFgc1c0si+NlKnKzUH
        d/XGn1TWJNU8H7QQrEpGlsEIs+ti1YFXfBP5oNmKl4hggyRSj1Dm3sxEh0fuAA3g
        Tb2JXSJJ7GAWzYPUQA7y0qeQcRig8y2NGEYNwyJTKk=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EXsSTdrUYeyp; Thu, 17 Dec 2020 15:37:50 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id DAAD141373;
        Thu, 17 Dec 2020 15:37:50 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.0.224) by
 T-EXCH-03.corp.yadro.com (172.17.100.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 17 Dec 2020 15:37:50 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH] scsi: target: core: check SR field in REPORT LUNS
Date:   Thu, 17 Dec 2020 15:37:31 +0300
Message-ID: <20201217123731.7313-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.224]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now REPORT LUNS for software device servers always reports all luns
regardless of SELECT REPORT field.
Add handling of that field according to SPC-4:
* accept known values,
* reject unknown values.

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
patch to 5.11/scsi-queue

 drivers/target/target_core_spc.c | 26 ++++++++++++++++++++++++++
 include/scsi/scsi_proto.h        | 10 ++++++++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index ca5579ebc81d..6af6272efce3 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1210,10 +1210,12 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 {
 	struct se_dev_entry *deve;
 	struct se_session *sess = cmd->se_sess;
+	unsigned char *cdb = cmd->t_task_cdb;
 	struct se_node_acl *nacl;
 	struct scsi_lun slun;
 	unsigned char *buf;
 	u32 lun_count = 0, offset = 8;
+	u8 sr = cdb[2];
 	__be32 len;
 
 	buf = transport_kmap_data_sg(cmd);
@@ -1230,6 +1232,27 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 
 	nacl = sess->se_node_acl;
 
+	switch (sr) {
+	case SCSI_SELECT_WELLKNOWN:
+	case SCSI_SELECT_ADMINISTRATIVE:
+	case SCSI_SELECT_SUBSIDIARY:
+		/* report empty lun list */
+		goto out;
+	case SCSI_SELECT_TOP_LEVEL:
+		if (cmd->se_lun->unpacked_lun != 0)
+			goto out;
+		fallthrough;
+	case SCSI_SELECT_REGULAR:
+	case SCSI_SELECT_ALL_ACCESSIBLE:
+		break;
+	default:
+		pr_debug("TARGET_CORE[%s]: Invalid REPORT LUNS with unsupported "
+				 "SELECT REPORT %#x for 0x%08llx from %s\n",
+				 cmd->se_tfo->fabric_name, sr, cmd->se_lun->unpacked_lun,
+				 sess->se_node_acl->initiatorname);
+		return TCM_INVALID_CDB_FIELD;
+	}
+
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
 		/*
@@ -1252,6 +1275,8 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 	 * See SPC3 r07, page 159.
 	 */
 done:
+	if ((sr != SCSI_SELECT_REGULAR) && (sr != SCSI_SELECT_ALL_ACCESSIBLE))
+		goto out;
 	/*
 	 * If no LUNs are accessible, report virtual LUN 0.
 	 */
@@ -1263,6 +1288,7 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 		lun_count = 1;
 	}
 
+out:
 	if (buf) {
 		len = cpu_to_be32(lun_count * 8);
 		memcpy(buf, &len, min_t(int, sizeof len, cmd->data_length));
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index c36860111932..280169c75d85 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -341,4 +341,14 @@ enum zbc_zone_cond {
 	ZBC_ZONE_COND_OFFLINE		= 0xf,
 };
 
+/* Select Report fot REPORT LUNS */
+enum scsi_select_report {
+	SCSI_SELECT_REGULAR		= 0x0,
+	SCSI_SELECT_WELLKNOWN		= 0x1,
+	SCSI_SELECT_ALL_ACCESSIBLE	= 0x2,
+	SCSI_SELECT_ADMINISTRATIVE	= 0x10,
+	SCSI_SELECT_TOP_LEVEL		= 0x11,
+	SCSI_SELECT_SUBSIDIARY		= 0x12,
+};
+
 #endif /* _SCSI_PROTO_H_ */
-- 
2.25.1


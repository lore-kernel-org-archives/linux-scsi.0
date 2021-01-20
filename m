Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4DDC4332B
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 11:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45A8123139
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 11:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729833AbhATL0e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 06:26:34 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:56834 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731202AbhATK20 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Jan 2021 05:28:26 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id C5B7E4131A;
        Wed, 20 Jan 2021 10:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1611138460; x=
        1612952861; bh=0pfwqfY7Ux9Ix9qH2pGi82YIRSXr3Jkz7ov3Ieo3+ms=; b=L
        DvMphQyxF/lLK4CJyiXkyxng3pj4BAkNQ4RG8ChYOvio7So3oPlvxH/MChQPXRpr
        qY4asD/Nb1l25XViLOrsLhGq1cOcgYCEX42BdMP16E4Ow8oZh3D6ZeraymNDJdVe
        QWOmng0XycyOzelH9PIx1BRF0sHMgAdmgg2c63a3Uw=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gih6k22tpeyH; Wed, 20 Jan 2021 13:27:40 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 935B5412E7;
        Wed, 20 Jan 2021 13:27:40 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.0.234) by
 T-EXCH-03.corp.yadro.com (172.17.100.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 20 Jan 2021 13:27:40 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2] scsi: target: core: check SR field in REPORT LUNS
Date:   Wed, 20 Jan 2021 13:27:00 +0300
Message-ID: <20210120102700.5514-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.234]
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

Changes since v1:
- unmap transport data in error handling case

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
patch to 5.11/scsi-queue

 drivers/target/target_core_spc.c | 27 +++++++++++++++++++++++++++
 include/scsi/scsi_proto.h        | 10 ++++++++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index ca5579ebc81d..044ac45cdf47 100644
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
@@ -1230,6 +1232,28 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 
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
+		transport_kunmap_data_sg(cmd);
+		return TCM_INVALID_CDB_FIELD;
+	}
+
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
 		/*
@@ -1252,6 +1276,8 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 	 * See SPC3 r07, page 159.
 	 */
 done:
+	if ((sr != SCSI_SELECT_REGULAR) && (sr != SCSI_SELECT_ALL_ACCESSIBLE))
+		goto out;
 	/*
 	 * If no LUNs are accessible, report virtual LUN 0.
 	 */
@@ -1263,6 +1289,7 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
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


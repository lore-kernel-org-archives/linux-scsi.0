Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75059C433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 12:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AFAB206B5
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 12:36:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="DMNdeqNu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgHRMgc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Aug 2020 08:36:32 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:64278 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726483AbgHRMga (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Aug 2020 08:36:30 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07ICTuZG027575
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2020 05:36:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=TzphQR68ysIKTZpnQFkOZAofgsOrxOqvESscmf5Tuuw=;
 b=DMNdeqNuN5uN9/q4ESuAF15BFyH5+Byg8A0WrEYP7JN1LWH7LQPZ4DRnaue7qVMwUCXh
 ynFhjE+DF9QdzPLltrtgksO09PDWg+zKKon2NkgE8Iy79YlZ372gXmEMrUwViWOW6Yzi
 GZyhZCmSejs6y3DjDJ6qi51wmIbZ1WVzrkl1P3r0plBLtc6WTyAZhRc5+zVv2c3cIBPE
 nogmT+WrYuoa+nuS6L2xc26HbQ7MWKMTBr2Dl9npWvJxk9H47JfoajBDv+MbD3rEWVFh
 cKlq0FMI+Wkhidgi3WkDnFF5dOWgTeNJ73blrSPjJNJVKrCE4QV0foMHpoADpNz34vif BQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 3304fhjevr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2020 05:36:29 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 Aug
 2020 05:36:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 18 Aug 2020 05:36:28 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A853E3F703F;
        Tue, 18 Aug 2020 05:36:28 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 07ICaS43020470;
        Tue, 18 Aug 2020 05:36:28 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 07ICaSFd020469;
        Tue, 18 Aug 2020 05:36:28 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 10/12] qla2xxx: Add rport fields in debugfs
Date:   Tue, 18 Aug 2020 05:32:01 -0700
Message-ID: <20200818123203.20361-11-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200818123203.20361-1-njavali@marvell.com>
References: <20200818123203.20361-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_07:2020-08-18,2020-08-18 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

This patch adds rport fields in debugfs.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_dfs.c | 53 ++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 610440c647a6..b9b3a3dd93db 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -61,13 +61,53 @@ DEFINE_DEBUGFS_ATTRIBUTE(qla_dfs_rport_##_attr##_fops,		\
 		qla_dfs_rport_##_attr##_get,			\
 		qla_dfs_rport_##_attr##_set, "%llu\n")
 
+/*
+ * Wrapper for getting fc_port fields.
+ *
+ * _attr    : Attribute name.
+ * _get_val : Accessor macro to retrieve the value.
+ */
+#define DEFINE_QLA_DFS_RPORT_FIELD_GET(_attr, _get_val)			\
+static int qla_dfs_rport_field_##_attr##_get(void *data, u64 *val)	\
+{									\
+	struct fc_port *fp = data;					\
+	*val = _get_val;						\
+	return 0;							\
+}									\
+DEFINE_DEBUGFS_ATTRIBUTE(qla_dfs_rport_field_##_attr##_fops,		\
+		qla_dfs_rport_field_##_attr##_get,			\
+		NULL, "%llu\n")
+
+#define DEFINE_QLA_DFS_RPORT_ACCESS(_attr, _get_val) \
+	DEFINE_QLA_DFS_RPORT_FIELD_GET(_attr, _get_val)
+
+#define DEFINE_QLA_DFS_RPORT_FIELD(_attr) \
+	DEFINE_QLA_DFS_RPORT_FIELD_GET(_attr, fp->_attr)
+
 DEFINE_QLA_DFS_RPORT_RW_ATTR(QLA_DFS_RPORT_DEVLOSS_TMO, dev_loss_tmo);
 
+DEFINE_QLA_DFS_RPORT_FIELD(disc_state);
+DEFINE_QLA_DFS_RPORT_FIELD(scan_state);
+DEFINE_QLA_DFS_RPORT_FIELD(fw_login_state);
+DEFINE_QLA_DFS_RPORT_FIELD(login_pause);
+DEFINE_QLA_DFS_RPORT_FIELD(flags);
+DEFINE_QLA_DFS_RPORT_FIELD(nvme_flag);
+DEFINE_QLA_DFS_RPORT_FIELD(last_rscn_gen);
+DEFINE_QLA_DFS_RPORT_FIELD(rscn_gen);
+DEFINE_QLA_DFS_RPORT_FIELD(login_gen);
+DEFINE_QLA_DFS_RPORT_FIELD(loop_id);
+DEFINE_QLA_DFS_RPORT_FIELD_GET(port_id, fp->d_id.b24);
+DEFINE_QLA_DFS_RPORT_FIELD_GET(sess_kref, kref_read(&fp->sess_kref));
+
 void
 qla2x00_dfs_create_rport(scsi_qla_host_t *vha, struct fc_port *fp)
 {
 	char wwn[32];
 
+#define QLA_CREATE_RPORT_FIELD_ATTR(_attr)			\
+	debugfs_create_file(#_attr, 0400, fp->dfs_rport_dir,	\
+		fp, &qla_dfs_rport_field_##_attr##_fops)
+
 	if (!vha->dfs_rport_root || fp->dfs_rport_dir)
 		return;
 
@@ -78,6 +118,19 @@ qla2x00_dfs_create_rport(scsi_qla_host_t *vha, struct fc_port *fp)
 	if (NVME_TARGET(vha->hw, fp))
 		debugfs_create_file("dev_loss_tmo", 0600, fp->dfs_rport_dir,
 				    fp, &qla_dfs_rport_dev_loss_tmo_fops);
+
+	QLA_CREATE_RPORT_FIELD_ATTR(disc_state);
+	QLA_CREATE_RPORT_FIELD_ATTR(scan_state);
+	QLA_CREATE_RPORT_FIELD_ATTR(fw_login_state);
+	QLA_CREATE_RPORT_FIELD_ATTR(login_pause);
+	QLA_CREATE_RPORT_FIELD_ATTR(flags);
+	QLA_CREATE_RPORT_FIELD_ATTR(nvme_flag);
+	QLA_CREATE_RPORT_FIELD_ATTR(last_rscn_gen);
+	QLA_CREATE_RPORT_FIELD_ATTR(rscn_gen);
+	QLA_CREATE_RPORT_FIELD_ATTR(login_gen);
+	QLA_CREATE_RPORT_FIELD_ATTR(loop_id);
+	QLA_CREATE_RPORT_FIELD_ATTR(port_id);
+	QLA_CREATE_RPORT_FIELD_ATTR(sess_kref);
 }
 
 void
-- 
2.19.0.rc0


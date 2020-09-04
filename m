Return-Path: <SRS0=dnbB=CN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 963C4C43461
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 04:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68907206F2
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 04:55:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="EM1iO3MB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbgIDEz5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Sep 2020 00:55:57 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39124 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725812AbgIDEz4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2020 00:55:56 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0844odnS011254
        for <linux-scsi@vger.kernel.org>; Thu, 3 Sep 2020 21:55:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=NyhnUe57huXvan+P4y+gmThFSwFg1vZiP0bNnGFMe0s=;
 b=EM1iO3MBtgAr0gDV/l9YbqvESZlkTVciaygHO4561p2f30UFPwqrPX2ys6OHSQ+Cjegm
 Q1KCIr8Dc2HeaEASLMHDyICV5iuhpznbHrQPhtCdI4TqQQXXaXIwcauPNWnYLy6XwLUW
 1a+YXYydb+kiA+PJbVVHoOPfIlV3t8rdVIf6LtlPLIb/0Cq7++ZsUCWxgN3ZakolLD76
 hIX1KNB3mCLlf7M9vzgTVLxTTdvohHFsvbQ2io38VZ2921mN5sHDpo0JUsIu8mJMwBHq
 Lpm8W3B6ehspSfImiab0OkGdCEr5LUm4/8ZRBkM2O9AZFPfnYmIvhgVuuaqMOz1pYEJ9 3A== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 337mcqrqfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2020 21:55:55 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Sep
 2020 21:55:55 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Sep
 2020 21:55:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Sep 2020 21:55:54 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id DFE4C3F703F;
        Thu,  3 Sep 2020 21:55:53 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0844trGG023740;
        Thu, 3 Sep 2020 21:55:53 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0844tr8o023739;
        Thu, 3 Sep 2020 21:55:53 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 10/13] qla2xxx: Add rport fields in debugfs
Date:   Thu, 3 Sep 2020 21:51:25 -0700
Message-ID: <20200904045128.23631-11-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200904045128.23631-1-njavali@marvell.com>
References: <20200904045128.23631-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_02:2020-09-03,2020-09-04 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

This patch adds rport fields in debugfs.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_dfs.c | 53 ++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 1e9db568aee3..118f2b223531 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -65,13 +65,53 @@ DEFINE_DEBUGFS_ATTRIBUTE(qla_dfs_rport_##_attr##_fops,		\
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
 
@@ -82,6 +122,19 @@ qla2x00_dfs_create_rport(scsi_qla_host_t *vha, struct fc_port *fp)
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


Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD379C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 07:27:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90B592072A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 07:27:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ksMc9nTL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgIBH1F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 03:27:05 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11336 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726323AbgIBH1E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 03:27:04 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0827Pbrf023781
        for <linux-scsi@vger.kernel.org>; Wed, 2 Sep 2020 00:27:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=SuH0Ybw/2xH4PYH/7tCX7RwbZ2Odvz7YDag3tQu0m0E=;
 b=ksMc9nTL0BOCF2P45rFyz6j1kxvpd+2CSW4aU7zn487Ksv4PmFn94Re5aj8geBBHc9CH
 aot2TJJvSPMUvM0qyfhy5i5bnfvvTd+mTmiLBDNKwLM20YcEXiUjpqmjfjDhnrlwhZak
 1v1ml7ZGXBaMsxIxjiza0MCFRUQZovhvVWz4nkpUZnMKIHToPrSj+HN/6pl4hIBSezok
 l7uC7EVC4v4r2aIdcQ7rCUz8fZtre+PcDCw8HcT9qpC00ePSKqDOTq5YCb8BLZKcLjks
 pDbgghDfn9D9VcYqRgUkpAdOkYfAi/MdmC8SAGljSvUjL0xpFL9bU2EJK+mojyAO6a0a Aw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 337phq5461-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Sep 2020 00:27:02 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 00:27:01 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 00:27:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Sep 2020 00:27:01 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 15E843F7043;
        Wed,  2 Sep 2020 00:27:01 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0827R0WL011542;
        Wed, 2 Sep 2020 00:27:00 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0827R0G8011541;
        Wed, 2 Sep 2020 00:27:00 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 02/13] qla2xxx: Setup debugfs entries for remote ports
Date:   Wed, 2 Sep 2020 00:25:37 -0700
Message-ID: <20200902072548.11491-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200902072548.11491-1-njavali@marvell.com>
References: <20200902072548.11491-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_03:2020-09-02,2020-09-02 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Create a base for adding remote port related entries in debugfs.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |  4 +++
 drivers/scsi/qla2xxx/qla_dfs.c    | 42 ++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_gbl.h    |  2 ++
 drivers/scsi/qla2xxx/qla_init.c   |  2 ++
 drivers/scsi/qla2xxx/qla_target.c |  2 ++
 5 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 1bc090d8a71b..074d8753cfc3 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2544,6 +2544,8 @@ typedef struct fc_port {
 	u8 last_login_state;
 	u16 n2n_link_reset_cnt;
 	u16 n2n_chip_reset;
+
+	struct dentry *dfs_rport_dir;
 } fc_port_t;
 
 enum {
@@ -4780,6 +4782,8 @@ typedef struct scsi_qla_host {
 	uint16_t ql2xexchoffld;
 	uint16_t ql2xiniexchg;
 
+	struct dentry *dfs_rport_root;
+
 	struct purex_list {
 		struct list_head head;
 		spinlock_t lock;
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index e62b2115235e..3c4b9b549b17 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -12,6 +12,29 @@
 static struct dentry *qla2x00_dfs_root;
 static atomic_t qla2x00_dfs_root_count;
 
+void
+qla2x00_dfs_create_rport(scsi_qla_host_t *vha, struct fc_port *fp)
+{
+	char wwn[32];
+
+	if (!vha->dfs_rport_root || fp->dfs_rport_dir)
+		return;
+
+	sprintf(wwn, "pn-%016llx", wwn_to_u64(fp->port_name));
+	fp->dfs_rport_dir = debugfs_create_dir(wwn, vha->dfs_rport_root);
+	if (!fp->dfs_rport_dir)
+		return;
+}
+
+void
+qla2x00_dfs_remove_rport(scsi_qla_host_t *vha, struct fc_port *fp)
+{
+	if (!vha->dfs_rport_root || !fp->dfs_rport_dir)
+		return;
+	debugfs_remove_recursive(fp->dfs_rport_dir);
+	fp->dfs_rport_dir = NULL;
+}
+
 static int
 qla2x00_dfs_tgt_sess_show(struct seq_file *s, void *unused)
 {
@@ -473,9 +496,21 @@ qla2x00_dfs_setup(scsi_qla_host_t *vha)
 	ha->tgt.dfs_tgt_sess = debugfs_create_file("tgt_sess",
 		S_IRUSR, ha->dfs_dir, vha, &dfs_tgt_sess_ops);
 
-	if (IS_QLA27XX(ha) || IS_QLA83XX(ha) || IS_QLA28XX(ha))
+	if (IS_QLA27XX(ha) || IS_QLA83XX(ha) || IS_QLA28XX(ha)) {
 		ha->tgt.dfs_naqp = debugfs_create_file("naqp",
 		    0400, ha->dfs_dir, vha, &dfs_naqp_ops);
+		if (!ha->tgt.dfs_naqp) {
+			ql_log(ql_log_warn, vha, 0xd011,
+			       "Unable to create debugFS naqp node.\n");
+			goto out;
+		}
+	}
+	vha->dfs_rport_root = debugfs_create_dir("rports", ha->dfs_dir);
+	if (!vha->dfs_rport_root) {
+		ql_log(ql_log_warn, vha, 0xd012,
+		       "Unable to create debugFS rports node.\n");
+		goto out;
+	}
 out:
 	return 0;
 }
@@ -515,6 +550,11 @@ qla2x00_dfs_remove(scsi_qla_host_t *vha)
 		ha->dfs_fce = NULL;
 	}
 
+	if (vha->dfs_rport_root) {
+		debugfs_remove_recursive(vha->dfs_rport_root);
+		vha->dfs_rport_root = NULL;
+	}
+
 	if (ha->dfs_dir) {
 		debugfs_remove(ha->dfs_dir);
 		ha->dfs_dir = NULL;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 0ced18f3104e..36c210c24f72 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -935,6 +935,8 @@ void qlt_clr_qp_table(struct scsi_qla_host *vha);
 void qlt_set_mode(struct scsi_qla_host *);
 int qla2x00_set_data_rate(scsi_qla_host_t *vha, uint16_t mode);
 extern void qla24xx_process_purex_list(struct purex_list *);
+extern void qla2x00_dfs_create_rport(scsi_qla_host_t *vha, struct fc_port *fp);
+extern void qla2x00_dfs_remove_rport(scsi_qla_host_t *vha, struct fc_port *fp);
 
 /* nvme.c */
 void qla_nvme_unregister_remote_port(struct fc_port *fcport);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 57a2d76aa691..b4d53eb4e53e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5486,6 +5486,8 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 
 	qla2x00_iidma_fcport(vha, fcport);
 
+	qla2x00_dfs_create_rport(vha, fcport);
+
 	if (NVME_TARGET(vha->hw, fcport)) {
 		qla_nvme_register_remote(vha, fcport);
 		qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_COMPLETE);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 1237d952973d..e28a977b0770 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1111,6 +1111,8 @@ void qlt_free_session_done(struct work_struct *work)
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	sess->free_pending = 0;
 
+	qla2x00_dfs_remove_rport(vha, sess);
+
 	ql_dbg(ql_dbg_disc, vha, 0xf001,
 	    "Unregistration of sess %p %8phC finished fcp_cnt %d\n",
 		sess, sess->port_name, vha->fcport_count);
-- 
2.19.0.rc0


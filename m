Return-Path: <SRS0=dnbB=CN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F23C43461
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 04:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7E57206E7
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 04:52:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="InkTARcn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgIDEwq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Sep 2020 00:52:46 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52912 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725765AbgIDEwo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2020 00:52:44 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0844nsrU015101
        for <linux-scsi@vger.kernel.org>; Thu, 3 Sep 2020 21:52:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=tD6egU1SjjKzd0xn5MhkJtHiJMh+zAjKQjAVC6rYQcE=;
 b=InkTARcn2HxBM6e7rkipsS87InvvWpdMepVyHSoMW3dyCsxEEGS7fAxmoRxoO6B6Pget
 dQc2BQ8rhtUNWQ05m68Pqgv5Qo99AruwXAPwZ6sUEEO993KCRDhqtdNXdPT8RCpmZDYl
 uw4LHyah7nZvB4zzyGFgEdZKz86zXVH7JzrW2Kh9nFFFoTiB99Tt8+neXtAwVJwusG7q
 QKtnGMav+q/ZdO/5RVhwHmnvyHrRBdnPinjNryBm/i0p54a3jo0wH/6eAwB61ky6dSid
 67YTL3+84URqSqDSsb7xPZ/TsHYffcy5/q9WLbTSBO4Ofq8QtVX2TbgCoDQr02dH2VIo LA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 337phqfutj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2020 21:52:43 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Sep
 2020 21:52:42 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Sep
 2020 21:52:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Sep 2020 21:52:41 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C2F513F703F;
        Thu,  3 Sep 2020 21:52:40 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0844qehb023683;
        Thu, 3 Sep 2020 21:52:40 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0844qeWf023682;
        Thu, 3 Sep 2020 21:52:40 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 02/13] qla2xxx: Setup debugfs entries for remote ports
Date:   Thu, 3 Sep 2020 21:51:17 -0700
Message-ID: <20200904045128.23631-3-njavali@marvell.com>
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

Create a base for adding remote port related entries in debugfs.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |  4 +++
 drivers/scsi/qla2xxx/qla_dfs.c    | 42 ++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_gbl.h    |  2 ++
 drivers/scsi/qla2xxx/qla_init.c   |  2 ++
 drivers/scsi/qla2xxx/qla_target.c |  2 ++
 5 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index a165120d2976..6d6d74e3546c 100644
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
index 4ff75d9fc125..b5804916b233 100644
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
index 90289162dbd4..7711f95033c0 100644
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


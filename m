Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A2CC433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 12:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 720EC2065D
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 12:33:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="HvftL1/g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgHRMdm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Aug 2020 08:33:42 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:23032 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726653AbgHRMdl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Aug 2020 08:33:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07ICTLwQ027326
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2020 05:33:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=I2zn+rppTgBgUrNNhqoAGGmEK5VXHzAizTnQoxJ014E=;
 b=HvftL1/gkW+zhaVBf8BnRmA7mNxbwFqWnyuTTh7QZ3k1VYAjEax4cTWDOAkaXVJirPnZ
 onu2TDJUr/f8KM4dsseyh29AyelQCJc4+VT52lOzTs0D2C89XY6bvdUH5lLck+2YOYRy
 l8pn64IgCqC4kG68eBZM0kEUee7OyVuDh8+Ae3RnmrPnCjbIu5A1P+GGMIlCCPc7kYfa
 DdcI4zarcsiPXPCs1HeeME6tLo8sXrDv9H/0MCjjZ7ScYB/tPf6r55Hu53iVKxavH0Fb
 +watY8MR1ls+eTQvy5+9hzG2sK3LjN33V8GMQ8UzQzLCSR+WxsZ6XfQXKy/atK1S0fr0 gg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 3304fhjeht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2020 05:33:40 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 Aug
 2020 05:33:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 18 Aug 2020 05:33:39 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A5F783F7043;
        Tue, 18 Aug 2020 05:33:39 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 07ICXdge020417;
        Tue, 18 Aug 2020 05:33:39 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 07ICXdcD020416;
        Tue, 18 Aug 2020 05:33:39 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 03/12] qla2xxx: Allow dev_loss_tmo setting for FC-NVMe devices
Date:   Tue, 18 Aug 2020 05:31:54 -0700
Message-ID: <20200818123203.20361-4-njavali@marvell.com>
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

Add a remote port debugfs entry to get/set dev_loss_tmo for NVMe
devices.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_dfs.c | 54 ++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 3c4b9b549b17..7482e6bf7f7f 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -12,6 +12,57 @@
 static struct dentry *qla2x00_dfs_root;
 static atomic_t qla2x00_dfs_root_count;
 
+#define QLA_DFS_RPORT_DEVLOSS_TMO	1
+
+static int
+qla_dfs_rport_get(struct fc_port *fp, int attr_id, u64 *val)
+{
+	switch (attr_id) {
+	case QLA_DFS_RPORT_DEVLOSS_TMO:
+		/* Only supported for FC-NVMe devices that are registered. */
+		if (!(fp->nvme_flag & NVME_FLAG_REGISTERED))
+			return -EIO;
+		*val = fp->nvme_remote_port->dev_loss_tmo;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int
+qla_dfs_rport_set(struct fc_port *fp, int attr_id, u64 val)
+{
+	switch (attr_id) {
+	case QLA_DFS_RPORT_DEVLOSS_TMO:
+		/* Only supported for FC-NVMe devices that are registered. */
+		if (!(fp->nvme_flag & NVME_FLAG_REGISTERED))
+			return -EIO;
+		return nvme_fc_set_remoteport_devloss(fp->nvme_remote_port,
+						      val);
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+#define DEFINE_QLA_DFS_RPORT_RW_ATTR(_attr_id, _attr)		\
+static int qla_dfs_rport_##_attr##_get(void *data, u64 *val)	\
+{								\
+	struct fc_port *fp = data;				\
+	return qla_dfs_rport_get(fp, _attr_id, val);		\
+}								\
+static int qla_dfs_rport_##_attr##_set(void *data, u64 val)	\
+{								\
+	struct fc_port *fp = data;				\
+	return qla_dfs_rport_set(fp, _attr_id, val);		\
+}								\
+DEFINE_DEBUGFS_ATTRIBUTE(qla_dfs_rport_##_attr##_fops,		\
+		qla_dfs_rport_##_attr##_get,			\
+		qla_dfs_rport_##_attr##_set, "%llu\n")
+
+DEFINE_QLA_DFS_RPORT_RW_ATTR(QLA_DFS_RPORT_DEVLOSS_TMO, dev_loss_tmo);
+
 void
 qla2x00_dfs_create_rport(scsi_qla_host_t *vha, struct fc_port *fp)
 {
@@ -24,6 +75,9 @@ qla2x00_dfs_create_rport(scsi_qla_host_t *vha, struct fc_port *fp)
 	fp->dfs_rport_dir = debugfs_create_dir(wwn, vha->dfs_rport_root);
 	if (!fp->dfs_rport_dir)
 		return;
+	if (NVME_TARGET(vha->hw, fp))
+		debugfs_create_file("dev_loss_tmo", 0600, fp->dfs_rport_dir,
+				    fp, &qla_dfs_rport_dev_loss_tmo_fops);
 }
 
 void
-- 
2.19.0.rc0


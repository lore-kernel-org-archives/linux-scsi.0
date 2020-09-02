Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7351C433E7
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 07:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5FFF2072A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 07:27:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="X5i7xlK1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgIBH1d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 03:27:33 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:13126 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726968AbgIBH12 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 03:27:28 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0827Pbrh023781
        for <linux-scsi@vger.kernel.org>; Wed, 2 Sep 2020 00:27:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=EWwQBcTDZhWPih78oYDnA7hOu/19oLEPOohIpbP/06k=;
 b=X5i7xlK1SDr6VpC2p1rEUmO4Zf4DgGJ1MbgFzISS0+DdD0HQqB0xC0ly3dN/0GL9Ny2a
 ArcvxeYf4fFmNVwndJGQm6Fneus4/ypp/QdUL7SKyrID3gSDjaRWJaSGb/QT9BiS4PaH
 7o1ty+IUf9tKm1/Y1xAWwh/caEiYSCTTMJWD8t1i9AfaueOaqB7wuMQzO5Yq24+lit00
 UoypE3xH/Ojh7jSO15xmEe/GNunYyUWAnShAlI+qO6ce+24RL2naqDNavK53qlvHXSRm
 eCdFx9IffgLymFT3HXKY9bzHYUbW1ddNECRe/3v7oAajcPBNR39HyaIHuJRDb+ocD9n7 lQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 337phq547c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Sep 2020 00:27:27 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 00:27:25 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 00:27:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Sep 2020 00:27:25 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 330943F703F;
        Wed,  2 Sep 2020 00:27:25 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0827RPt9011555;
        Wed, 2 Sep 2020 00:27:25 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0827RPgx011545;
        Wed, 2 Sep 2020 00:27:25 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 03/13] qla2xxx: Allow dev_loss_tmo setting for FC-NVMe devices
Date:   Wed, 2 Sep 2020 00:25:38 -0700
Message-ID: <20200902072548.11491-4-njavali@marvell.com>
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

Add a remote port debugfs entry to get/set dev_loss_tmo for NVMe
devices.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 drivers/scsi/qla2xxx/qla_dfs.c | 58 ++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 3c4b9b549b17..616ce891818d 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -12,6 +12,61 @@
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
+#if (IS_ENABLED(CONFIG_NVME_FC))
+		return nvme_fc_set_remoteport_devloss(fp->nvme_remote_port,
+						      val);
+#else /* CONFIG_NVME_FC */
+		return -EINVAL;
+#endif /* CONFIG_NVME_FC */
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
@@ -24,6 +79,9 @@ qla2x00_dfs_create_rport(scsi_qla_host_t *vha, struct fc_port *fp)
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


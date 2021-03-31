Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80D5CC43462
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 16:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A21561074
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 16:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbhCaQui (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 12:50:38 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30510 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229486AbhCaQuM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Mar 2021 12:50:12 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12VGg7eS027842
        for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2021 09:50:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=cusdSQfIgX1d+ycKYkv3IkPGTNh72AXkncI0vnbxWVQ=;
 b=EqoYhf64D5AmcUlLaceO0wQb5tw5+dbT7rz6isRlTwT9bzw3oMeg68Tlyt/137wtQQfs
 zOvKarBk51pep+DR+GP5w51nS8QJpghwhA2zUpiNBfx3OZe4Jis4o5tI2VOXeNOOD8oj
 jmjea2Ya9VVcvjklGmkejQdeUzEvUYz92fmnckbdHKMTXAZUbwor0f2OZDPZE/WOrp83
 CpS6Ax2/+tdKRGR5ei+R8SN0mpTFrO9d7qiJySOcBnK8nzGfeXkEW7NB//qOFC4ydNcl
 +semZd4viE+Zuo/WazSoqd7xe4AVCDq3jwEWHfCALStV3poHmMY0ZxBcM120ifZ5g1LJ 6w== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 37ma9ju8f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2021 09:50:12 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 31 Mar
 2021 09:50:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 31 Mar 2021 09:50:11 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id F22A33F7076;
        Wed, 31 Mar 2021 09:50:05 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 12VGo5Ce024765;
        Wed, 31 Mar 2021 09:50:05 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 12VGo5uc024700;
        Wed, 31 Mar 2021 09:50:05 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 1/2] qedf: Enable devlink support
Date:   Wed, 31 Mar 2021 09:49:16 -0700
Message-ID: <20210331164917.24662-2-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210331164917.24662-1-jhasan@marvell.com>
References: <20210331164917.24662-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: zRn6r6s_6kBU2y5MR4OmnQ_h224N1DFD
X-Proofpoint-ORIG-GUID: zRn6r6s_6kBU2y5MR4OmnQ_h224N1DFD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-31_08:2021-03-31,2021-03-31 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Devlink instance lifecycle was linked to qed_dev object,
that caused devlink to be recreated on each recovery.

Changing it by making higher level driver (qede) responsible for its
life. This way devlink now survives recoveries.

qede now stores devlink structure pointer as a part of its device
object, devlink private data contains a linkage structure,
qed_devlink.

Signed-off-by: Javed Hasan <jhasan@marvell.com>
---
 drivers/scsi/qedf/qedf.h      |  1 +
 drivers/scsi/qedf/qedf_main.c | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index 88a592d09433..36dde38608dd 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -335,6 +335,7 @@ struct qedf_ctx {
 	unsigned int curr_conn_id;
 	struct workqueue_struct *ll2_recv_wq;
 	struct workqueue_struct *link_update_wq;
+	struct devlink *devlink;
 	struct delayed_work link_update;
 	struct delayed_work link_recovery;
 	struct completion flogi_compl;
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 46d185cb9ea8..6b6c3fd97798 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3408,6 +3408,14 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 		goto err2;
 	}
 
+	if (mode != QEDF_MODE_RECOVERY) {
+		qedf->devlink = qed_ops->common->devlink_register(qedf->cdev);
+		if (IS_ERR(qedf->devlink)) {
+			QEDF_ERR(&qedf->dbg_ctx, "Cannot register devlink\n");
+			qedf->devlink = NULL;
+		}
+	}
+
 	/* Record BDQ producer doorbell addresses */
 	qedf->bdq_primary_prod = qedf->dev_info.primary_dbq_rq_addr;
 	qedf->bdq_secondary_prod = qedf->dev_info.secondary_bdq_rq_addr;
@@ -3789,6 +3797,11 @@ static void __qedf_remove(struct pci_dev *pdev, int mode)
 		QEDF_ERR(&(qedf->dbg_ctx),
 			"Failed to send drv state to MFW.\n");
 
+	if (mode != QEDF_MODE_RECOVERY && qedf->devlink) {
+		qed_ops->common->devlink_unregister(qedf->devlink);
+		qedf->devlink = NULL;
+	}
+
 	qed_ops->common->slowpath_stop(qedf->cdev);
 	qed_ops->common->remove(qedf->cdev);
 
-- 
2.18.2


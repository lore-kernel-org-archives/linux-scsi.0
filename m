Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 850F3C4CEC8
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 18:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FCFF2081B
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 18:09:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="JFHTqJni"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfILSJy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 14:09:54 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51222 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726918AbfILSJx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Sep 2019 14:09:53 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8CI9Plh019909;
        Thu, 12 Sep 2019 11:09:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=XtTGV+F7SHmN+6r3hizzHhL6y9HGOp5UaIm8C8et7uQ=;
 b=JFHTqJniH6l1rvI5qigWXWRiymgMXIR1zNDtGhoUVVcjZeaNhkrMyPTrVevV/CDhnlhu
 t3P3xRaCKZYV7TCfrBGFSP6fd3edL8USjCpWvWHLryM8PmqUDvNrkX7nbI7RO4w7ZcfL
 lW3/VeR+UIptHDu2VONSUlwEdr3GjOOVMz6yQhH8S48lk39vY++cMflmyRciGR3VYLhT
 LF7q+5E+39SeV32A6TRo6pZNUoco2hmLZbRhbo0Z75hpWQBIHWBPKyspRXhM0Z4oCSgo
 eyssL9K/hs16D89OPKXoQa3h1LaBFPc/UrOvApKZQHBRDadsjT6wBhWFUkK15MQtgZU9 ag== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uytdfg5qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Sep 2019 11:09:50 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 12 Sep
 2019 11:09:48 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 12 Sep 2019 11:09:48 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 2037F3F703F;
        Thu, 12 Sep 2019 11:09:48 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x8CI9lBl006511;
        Thu, 12 Sep 2019 11:09:47 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x8CI9lip006510;
        Thu, 12 Sep 2019 11:09:47 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 10/14] qla2xxx: Set remove flag for all VP
Date:   Thu, 12 Sep 2019 11:09:14 -0700
Message-ID: <20190912180918.6436-11-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190912180918.6436-1-hmadhani@marvell.com>
References: <20190912180918.6436-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-12_09:2019-09-11,2019-09-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

During driver unload, the remove flag will be set for all
scsi_qla_host/NPIV. This allows each NPIV to see the flag
instead of reaching for base_vha to search for it.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c2ec8ee5df79..6e627e521562 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3480,6 +3480,29 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ret;
 }
 
+static void __qla_set_remove_flag(scsi_qla_host_t *base_vha)
+{
+	scsi_qla_host_t *vp;
+	unsigned long flags;
+	struct qla_hw_data *ha;
+
+	if (!base_vha)
+		return;
+
+	ha = base_vha->hw;
+
+	spin_lock_irqsave(&ha->vport_slock, flags);
+	list_for_each_entry(vp, &ha->vp_list, list)
+		set_bit(PFLG_DRIVER_REMOVING, &vp->pci_flags);
+
+	/*
+	 * Indicate device removal to prevent future board_disable
+	 * and wait until any pending board_disable has completed.
+	 */
+	set_bit(PFLG_DRIVER_REMOVING, &base_vha->pci_flags);
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
+}
+
 static void
 qla2x00_shutdown(struct pci_dev *pdev)
 {
@@ -3496,7 +3519,7 @@ qla2x00_shutdown(struct pci_dev *pdev)
 	 * Prevent future board_disable and wait
 	 * until any pending board_disable has completed.
 	 */
-	set_bit(PFLG_DRIVER_REMOVING, &vha->pci_flags);
+	__qla_set_remove_flag(vha);
 	cancel_work_sync(&ha->board_disable);
 
 	if (!atomic_read(&pdev->enable_cnt))
@@ -3652,10 +3675,7 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	ha = base_vha->hw;
 	ql_log(ql_log_info, base_vha, 0xb079,
 	    "Removing driver\n");
-
-	/* Indicate device removal to prevent future board_disable and wait
-	 * until any pending board_disable has completed. */
-	set_bit(PFLG_DRIVER_REMOVING, &base_vha->pci_flags);
+	__qla_set_remove_flag(base_vha);
 	cancel_work_sync(&ha->board_disable);
 
 	/*
-- 
2.12.0


Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B07EEB64DD
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Aug 2023 09:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbjHGJhk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Aug 2023 05:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjHGJhj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2023 05:37:39 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F53310C0
        for <linux-scsi@vger.kernel.org>; Mon,  7 Aug 2023 02:37:35 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 376MwDDZ019408;
        Mon, 7 Aug 2023 02:37:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=j0vsDv85MqSHMqrok656+DQsxJQup7VvcS92cmFaP7c=;
 b=iTEpLnInWYZWQ6N1js7KY0Hu6xBfPJeeNKn6XtSrtCRgDdVJ5GyF0/0uQbWipIt38yPp
 /9Ll0iynhXhFZc/oNBMmB+yW7wle8+Aws94ZL9YOWsG3zRKU0J0FZR1aQFiu6Iu8GEDs
 IXcy4ewirWflPmI8GH9JQC2urFPTnnRhmHTAbE4b43OZ0XkbeLePrE0QhaEgo175oBID
 laq1KWKcNy7jcNgaKUQw4/vzoYfmG7hdh5c72A4vj86k1HNXCx+D9M0aVrFFkn/jC/4J
 nbZpCkr18hszqgVN4FJRch7XGm3gydg5n3Q2aAe2IKBOr9xT8iATLeKF4XFUH/YVFK7J 2A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3s9ksscxve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 07 Aug 2023 02:37:30 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 7 Aug
 2023 02:37:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Mon, 7 Aug 2023 02:37:28 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 4B12C3F704B;
        Mon,  7 Aug 2023 02:37:26 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jmeneghi@redhat.com>
Subject: [PATCH] qedf: fix firmware halt over suspend and resume
Date:   Mon, 7 Aug 2023 15:07:24 +0530
Message-ID: <20230807093725.46829-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: pbeATTZRE03V0CzLeB-ubAYRVNnCcWIi
X-Proofpoint-ORIG-GUID: pbeATTZRE03V0CzLeB-ubAYRVNnCcWIi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-07_08,2023-08-03_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

While performing certain power-off sequences, PCI drivers are
called to suspend and resume their underlying devices through
PCI PM (power management) interface. However the hardware
does not support PCI PM suspend/resume operations so system wide
suspend/resume leads to bad MFW (management firmware) state which
causes various follow-up errors in driver when communicating with
the device/firmware.

To fix this driver implements PCI PM suspend handler to indicate
unsupported operation to the PCI subsystem explicitly, thus avoiding
system to go into suspended/standby mode.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 2a31ddc99dde..7825765c936c 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -31,6 +31,7 @@ static void qedf_remove(struct pci_dev *pdev);
 static void qedf_shutdown(struct pci_dev *pdev);
 static void qedf_schedule_recovery_handler(void *dev);
 static void qedf_recovery_handler(struct work_struct *work);
+static int qedf_suspend(struct pci_dev *pdev, pm_message_t state);
 
 /*
  * Driver module parameters.
@@ -3271,6 +3272,7 @@ static struct pci_driver qedf_pci_driver = {
 	.probe = qedf_probe,
 	.remove = qedf_remove,
 	.shutdown = qedf_shutdown,
+	.suspend = qedf_suspend,
 };
 
 static int __qedf_probe(struct pci_dev *pdev, int mode)
@@ -4000,6 +4002,22 @@ static void qedf_shutdown(struct pci_dev *pdev)
 	__qedf_remove(pdev, QEDF_MODE_NORMAL);
 }
 
+static int qedf_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct qedf_ctx *qedf;
+
+	if (!pdev) {
+		QEDF_ERR(NULL, "pdev is NULL.\n");
+		return -ENODEV;
+	}
+
+	qedf = pci_get_drvdata(pdev);
+
+	QEDF_ERR(&qedf->dbg_ctx, "%s: Device does not support suspend operation\n", __func__);
+
+	return -EPERM;
+}
+
 /*
  * Recovery handler code
  */
-- 
2.23.1


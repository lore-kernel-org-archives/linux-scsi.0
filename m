Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF14EB64DD
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Aug 2023 09:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbjHGJhp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Aug 2023 05:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjHGJhm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2023 05:37:42 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A74D10C1
        for <linux-scsi@vger.kernel.org>; Mon,  7 Aug 2023 02:37:38 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 376Mpo3c006010;
        Mon, 7 Aug 2023 02:37:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=Da48bVDWgFIuGHkRQxOTlDxIzzBI7qpP/BasRiF0KeE=;
 b=aaZKIIFD8D0bGjPqFn9DqdF8hZf8AW6ijELEKrHvXSVBKRzOJIs1jJ8VFec4MZDpSp4P
 Ca+Y0PGta9mQylSdmAx9niI2+pLGy/mcsfs36CxShT6i284uXmDpG8kiOl8rshm5s10G
 i/qXJ2ChkZ+io7RznJ1Mb0F3TJby+DHtJdB2JUk4qhmA2msC8BG+zQsoWc1fYtoco3DW
 8E22AX8xvfG0tg9Tu2gUaIJ5vVprTP2ChF8ZTXsfJErY4FHyXHkRuhiaD5zbs9D8GEfT
 nn+TNW2rAHpiiUjfnzg5wkdEpAPAtm909KvntmnkLlazYbkzV+os5VvzA9ZvqM1zOO7y 7w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3s9ksscxvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 07 Aug 2023 02:37:32 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 7 Aug
 2023 02:37:31 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Mon, 7 Aug 2023 02:37:31 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 062763F708D;
        Mon,  7 Aug 2023 02:37:28 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jmeneghi@redhat.com>
Subject: [PATCH] qedi: fix firmware halt over suspend and resume
Date:   Mon, 7 Aug 2023 15:07:25 +0530
Message-ID: <20230807093725.46829-2-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230807093725.46829-1-njavali@marvell.com>
References: <20230807093725.46829-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 1EYF91T8j_P3GtGH7gGa12iCHciCuMrq
X-Proofpoint-ORIG-GUID: 1EYF91T8j_P3GtGH7gGa12iCHciCuMrq
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

Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qedi/qedi_main.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 450522b204d6..f94ea5d9b4c1 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -69,6 +69,7 @@ static struct nvm_iscsi_block *qedi_get_nvram_block(struct qedi_ctx *qedi);
 static void qedi_recovery_handler(struct work_struct *work);
 static void qedi_schedule_hw_err_handler(void *dev,
 					 enum qed_hw_err_type err_type);
+static int qedi_suspend(struct pci_dev *pdev, pm_message_t state);
 
 static int qedi_iscsi_event_cb(void *context, u8 fw_event_code, void *fw_handle)
 {
@@ -2510,6 +2511,22 @@ static void qedi_shutdown(struct pci_dev *pdev)
 	__qedi_remove(pdev, QEDI_MODE_SHUTDOWN);
 }
 
+static int qedi_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct qedi_ctx *qedi;
+
+	if (!pdev) {
+		QEDI_ERR(NULL, "pdev is NULL.\n");
+		return -ENODEV;
+	}
+
+	qedi = pci_get_drvdata(pdev);
+
+	QEDI_ERR(&qedi->dbg_ctx, "%s: Device does not support suspend operation\n", __func__);
+
+	return -EPERM;
+}
+
 static int __qedi_probe(struct pci_dev *pdev, int mode)
 {
 	struct qedi_ctx *qedi;
@@ -2868,6 +2885,7 @@ static struct pci_driver qedi_pci_driver = {
 	.remove = qedi_remove,
 	.shutdown = qedi_shutdown,
 	.err_handler = &qedi_err_handler,
+	.suspend = qedi_suspend,
 };
 
 static int __init qedi_init(void)
-- 
2.23.1


Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B21DC4363D
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 14:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30000206A5
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 14:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388237AbgJBOew (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 10:34:52 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14798 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387893AbgJBOej (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Oct 2020 10:34:39 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B53B1E11F28F1232E044;
        Fri,  2 Oct 2020 22:34:34 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 2 Oct 2020 22:34:26 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 3/7] scsi: hisi_sas: Add controller runtime PM support for v3 hw
Date:   Fri, 2 Oct 2020 22:30:34 +0800
Message-ID: <1601649038-25534-4-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1601649038-25534-1-git-send-email-john.garry@huawei.com>
References: <1601649038-25534-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Add controller runtime PM support for v3 hw.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  2 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 56 +++++++++++++++++++++++++-
 2 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index c617ac8d8315..961842ee8906 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -19,6 +19,7 @@
 #include <linux/of_address.h>
 #include <linux/pci.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/property.h>
 #include <linux/regmap.h>
 #include <linux/timer.h>
@@ -32,6 +33,7 @@
 #define HISI_SAS_MAX_DEVICES HISI_SAS_MAX_ITCT_ENTRIES
 #define HISI_SAS_RESET_BIT	0
 #define HISI_SAS_REJECT_CMD_BIT	1
+#define HISI_SAS_PM_BIT		2
 #define HISI_SAS_MAX_COMMANDS (HISI_SAS_QUEUE_SLOTS)
 #define HISI_SAS_RESERVED_IPTT  96
 #define HISI_SAS_UNRESERVED_IPTT \
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index e73c124355e5..fa9db57cc3fc 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3314,6 +3314,17 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	scsi_scan_host(shost);
 
+	/*
+	 * For the situation that there are ATA disks connected with SAS
+	 * controller, it addtionly creates ata_port which will affect the
+	 * child_count of hisi_hba->dev. Even if suspended all the disks,
+	 * ata_port is still and the child_count of hisi_hba->dev is not 0.
+	 * So use pm_suspend_ignore_children() to ignore the affect to
+	 * hisi_hba->dev.
+	 */
+	pm_suspend_ignore_children(dev, true);
+	pm_runtime_put_noidle(&pdev->dev);
+
 	return 0;
 
 err_out_register_ha:
@@ -3353,6 +3364,7 @@ static void hisi_sas_v3_remove(struct pci_dev *pdev)
 	struct hisi_hba *hisi_hba = sha->lldd_ha;
 	struct Scsi_Host *shost = sha->core.shost;
 
+	pm_runtime_get_noresume(dev);
 	if (timer_pending(&hisi_hba->timer))
 		del_timer(&hisi_hba->timer);
 
@@ -3407,7 +3419,7 @@ enum {
 	hip08,
 };
 
-static int suspend_v3_hw(struct device *device)
+static int _suspend_v3_hw(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
@@ -3453,7 +3465,7 @@ static int suspend_v3_hw(struct device *device)
 	return 0;
 }
 
-static int resume_v3_hw(struct device *device)
+static int _resume_v3_hw(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
@@ -3492,6 +3504,34 @@ static int resume_v3_hw(struct device *device)
 	return 0;
 }
 
+static int suspend_v3_hw(struct device *device)
+{
+	struct pci_dev *pdev = to_pci_dev(device);
+	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
+	struct hisi_hba *hisi_hba = sha->lldd_ha;
+	int rc;
+
+	set_bit(HISI_SAS_PM_BIT, &hisi_hba->flags);
+
+	rc = _suspend_v3_hw(device);
+	if (rc)
+		clear_bit(HISI_SAS_PM_BIT, &hisi_hba->flags);
+
+	return rc;
+}
+
+static int resume_v3_hw(struct device *device)
+{
+	struct pci_dev *pdev = to_pci_dev(device);
+	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
+	struct hisi_hba *hisi_hba = sha->lldd_ha;
+	int rc = _resume_v3_hw(device);
+
+	clear_bit(HISI_SAS_PM_BIT, &hisi_hba->flags);
+
+	return rc;
+}
+
 static const struct pci_device_id sas_v3_pci_table[] = {
 	{ PCI_VDEVICE(HUAWEI, 0xa230), hip08 },
 	{}
@@ -3503,8 +3543,20 @@ static const struct pci_error_handlers hisi_sas_err_handler = {
 	.reset_done	= hisi_sas_reset_done_v3_hw,
 };
 
+static int runtime_suspend_v3_hw(struct device *dev)
+{
+	return suspend_v3_hw(dev);
+}
+
+static int runtime_resume_v3_hw(struct device *dev)
+{
+	return resume_v3_hw(dev);
+}
+
 static const struct dev_pm_ops hisi_sas_v3_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(suspend_v3_hw, resume_v3_hw)
+	SET_RUNTIME_PM_OPS(runtime_suspend_v3_hw,
+			   runtime_resume_v3_hw, NULL)
 };
 
 static struct pci_driver sas_v3_pci_driver = {
-- 
2.26.2


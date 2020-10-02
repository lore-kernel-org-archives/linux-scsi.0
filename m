Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03FAAC4363D
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 14:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4DBF206FA
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 14:34:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388135AbgJBOei (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 10:34:38 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14796 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387807AbgJBOei (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Oct 2020 10:34:38 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id ACF00CFFD81C78F9AE78;
        Fri,  2 Oct 2020 22:34:34 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 2 Oct 2020 22:34:26 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 2/7] scsi: hisi_sas: Switch to new framework to support suspend and resume
Date:   Fri, 2 Oct 2020 22:30:33 +0800
Message-ID: <1601649038-25534-3-git-send-email-john.garry@huawei.com>
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

For v3 hw, we will add support for runtime PM which is only supported in
new framework. Legacy PM support and new framework are not allowed to be
used together. So switch to new framework to support suspend and resume.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 0cc186fcbca8..e73c124355e5 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3407,8 +3407,9 @@ enum {
 	hip08,
 };
 
-static int hisi_sas_v3_suspend(struct pci_dev *pdev, pm_message_t state)
+static int suspend_v3_hw(struct device *device)
 {
+	struct pci_dev *pdev = to_pci_dev(device);
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct hisi_hba *hisi_hba = sha->lldd_ha;
 	struct device *dev = hisi_hba->dev;
@@ -3439,7 +3440,7 @@ static int hisi_sas_v3_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	hisi_sas_init_mem(hisi_hba);
 
-	device_state = pci_choose_state(pdev, state);
+	device_state = pci_choose_state(pdev, PMSG_SUSPEND);
 	dev_warn(dev, "entering operating state [D%d]\n",
 			device_state);
 	pci_save_state(pdev);
@@ -3452,8 +3453,9 @@ static int hisi_sas_v3_suspend(struct pci_dev *pdev, pm_message_t state)
 	return 0;
 }
 
-static int hisi_sas_v3_resume(struct pci_dev *pdev)
+static int resume_v3_hw(struct device *device)
 {
+	struct pci_dev *pdev = to_pci_dev(device);
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct hisi_hba *hisi_hba = sha->lldd_ha;
 	struct Scsi_Host *shost = hisi_hba->shost;
@@ -3501,14 +3503,17 @@ static const struct pci_error_handlers hisi_sas_err_handler = {
 	.reset_done	= hisi_sas_reset_done_v3_hw,
 };
 
+static const struct dev_pm_ops hisi_sas_v3_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(suspend_v3_hw, resume_v3_hw)
+};
+
 static struct pci_driver sas_v3_pci_driver = {
 	.name		= DRV_NAME,
 	.id_table	= sas_v3_pci_table,
 	.probe		= hisi_sas_v3_probe,
 	.remove		= hisi_sas_v3_remove,
-	.suspend	= hisi_sas_v3_suspend,
-	.resume		= hisi_sas_v3_resume,
 	.err_handler	= &hisi_sas_err_handler,
+	.driver.pm	= &hisi_sas_v3_pm_ops,
 };
 
 module_pci_driver(sas_v3_pci_driver);
-- 
2.26.2


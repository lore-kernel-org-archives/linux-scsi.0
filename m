Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A902C47423
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 14:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 435E9206B2
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 14:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388094AbgJBOeh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 10:34:37 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14799 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387688AbgJBOeh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Oct 2020 10:34:37 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B0EDB35FC4E5610DA197;
        Fri,  2 Oct 2020 22:34:34 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 2 Oct 2020 22:34:26 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 4/7] scsi: hisi_sas: Add the check of the definition of method _PS0 and _PR0
Date:   Fri, 2 Oct 2020 22:30:35 +0800
Message-ID: <1601649038-25534-5-git-send-email-john.garry@huawei.com>
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

To support system suspend/resume or runtime suspend/resume, need to use
the function pci_set_power_state() to change the power state which requires
at least method _PS0 or _PR0 be filled by platform for v3 hw. So check
whether the method is supported, if not, add a print to remind.

A Kconfig dependency is added as there is no stub for
acpi_device_power_manageable().

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/Kconfig          | 1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
index 13ed9073fc72..b8148b1733f8 100644
--- a/drivers/scsi/hisi_sas/Kconfig
+++ b/drivers/scsi/hisi_sas/Kconfig
@@ -15,5 +15,6 @@ config SCSI_HISI_SAS_PCI
 	tristate "HiSilicon SAS on PCI bus"
 	depends on SCSI_HISI_SAS
 	depends on PCI
+	depends on ACPI
 	help
 		This driver supports HiSilicon's SAS HBA based on PCI device
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index fa9db57cc3fc..708b5661b127 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -903,6 +903,7 @@ static int reset_hw_v3_hw(struct hisi_hba *hisi_hba)
 static int hw_init_v3_hw(struct hisi_hba *hisi_hba)
 {
 	struct device *dev = hisi_hba->dev;
+	struct acpi_device *acpi_dev;
 	union acpi_object *obj;
 	guid_t guid;
 	int rc;
@@ -933,6 +934,9 @@ static int hw_init_v3_hw(struct hisi_hba *hisi_hba)
 	else
 		ACPI_FREE(obj);
 
+	acpi_dev = ACPI_COMPANION(dev);
+	if (!acpi_device_power_manageable(acpi_dev))
+		dev_notice(dev, "neither _PS0 nor _PR0 is defined\n");
 	return 0;
 }
 
-- 
2.26.2


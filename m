Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEFEFC47426
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 14:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 711E0206FA
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 14:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388222AbgJBOev (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 10:34:51 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14797 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388177AbgJBOeu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Oct 2020 10:34:50 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A8DAC878B689628BA97D;
        Fri,  2 Oct 2020 22:34:34 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 2 Oct 2020 22:34:27 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 5/7] scsi: hisi_sas: Add device link between SCSI devices and hisi_hba
Date:   Fri, 2 Oct 2020 22:30:36 +0800
Message-ID: <1601649038-25534-6-git-send-email-john.garry@huawei.com>
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

Runtime PM of SCSI devices are already supported in SCSI layer, we can
suspend/resume every SCSI device separately. But if there is not link
between hisi_hba and SCSI devices or SCSI targets, it will cause issues
if the controller is suspended while SCSI devices are still resuming.
If only when all the SCSI devices under the controller are suspended,
the controller can be suspended. So add the device link between
SCSI devices and the controller.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 29 +++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 708b5661b127..c9353e02fdd5 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2758,6 +2758,33 @@ static ssize_t intr_coal_count_v3_hw_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(intr_coal_count_v3_hw);
 
+static int slave_configure_v3_hw(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = dev_to_shost(&sdev->sdev_gendev);
+	struct domain_device *ddev = sdev_to_domain_dev(sdev);
+	struct hisi_hba *hisi_hba = shost_priv(shost);
+	struct device *dev = hisi_hba->dev;
+	int ret = sas_slave_configure(sdev);
+
+	if (ret)
+		return ret;
+	if (!dev_is_sata(ddev))
+		sas_change_queue_depth(sdev, 64);
+
+	if (sdev->type == TYPE_ENCLOSURE)
+		return 0;
+
+	if (!device_link_add(&sdev->sdev_gendev, dev,
+			     DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE)) {
+		if (pm_runtime_enabled(dev)) {
+			dev_info(dev, "add device link failed, disable runtime PM for the host\n");
+			pm_runtime_disable(dev);
+		}
+	}
+
+	return 0;
+}
+
 static struct device_attribute *host_attrs_v3_hw[] = {
 	&dev_attr_phy_event_threshold,
 	&dev_attr_intr_conv_v3_hw,
@@ -3114,7 +3141,7 @@ static struct scsi_host_template sht_v3_hw = {
 	.queuecommand		= sas_queuecommand,
 	.dma_need_drain		= ata_scsi_dma_need_drain,
 	.target_alloc		= sas_target_alloc,
-	.slave_configure	= hisi_sas_slave_configure,
+	.slave_configure	= slave_configure_v3_hw,
 	.scan_finished		= hisi_sas_scan_finished,
 	.scan_start		= hisi_sas_scan_start,
 	.change_queue_depth	= sas_change_queue_depth,
-- 
2.26.2


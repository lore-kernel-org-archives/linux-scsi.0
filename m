Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D6E9C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0727D22CB3
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgHEBsZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 21:48:25 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:34844 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726579AbgHEBsZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 Aug 2020 21:48:25 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 574E27CB4CDC4D671110;
        Wed,  5 Aug 2020 09:48:23 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Wed, 5 Aug 2020 09:48:14 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH v2 plinth/topic-sas-5.8] {topost} scsi: hisi_sas: ignore adding device link for enclosure device
Date:   Wed, 5 Aug 2020 09:44:34 +0800
Message-ID: <1596591874-60814-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

For enclosure device, it is not necessary to add device link as it is not
a real disk, so check scsi device's type to ignore adding device link for it.
As scsi device's type is initialized in function scsi_add_lun() which is
after function shost->hostt->slave_alloc(), so move adding device link and
the check to host->hostt->slave_configure() which is after the function
scsi_add_lun().

Fixes: d73be9b32942 ("{topost} scsi: hisi_sas: Add device link between SCSI devices and
hisi_hba")
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 187a307..d056d5c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3076,11 +3076,21 @@ static int debugfs_set_bist_v3_hw(struct hisi_hba *hisi_hba, bool enable)
 	return 0;
 }
 
-static int slave_alloc_v3_hw(struct scsi_device *sdev)
+static int slave_configure_v3_hw(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = dev_to_shost(&sdev->sdev_gendev);
+	struct domain_device *ddev = sdev_to_domain_dev(sdev);
 	struct hisi_hba *hisi_hba = shost_priv(shost);
 	struct device *dev = hisi_hba->dev;
+	int ret = sas_slave_configure(sdev);
+
+	if (ret)
+		return ret;
+	if (!dev_is_sata(ddev))
+		sas_change_queue_depth(sdev, 64);
+
+	if (sdev->type == TYPE_ENCLOSURE)
+		return 0;
 
 	if (!device_link_add(&sdev->sdev_gendev, dev,
 			     DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE))
@@ -3098,8 +3108,7 @@ static struct scsi_host_template sht_v3_hw = {
 	.module			= THIS_MODULE,
 	.queuecommand		= sas_queuecommand,
 	.target_alloc		= sas_target_alloc,
-	.slave_alloc		= slave_alloc_v3_hw,
-	.slave_configure	= hisi_sas_slave_configure,
+	.slave_configure	= slave_configure_v3_hw,
 	.scan_finished		= hisi_sas_scan_finished,
 	.scan_start		= hisi_sas_scan_start,
 	.change_queue_depth	= sas_change_queue_depth,
-- 
2.8.1


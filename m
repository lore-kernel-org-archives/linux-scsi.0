Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00ED9C678D5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 05:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjCGFjT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Mar 2023 00:39:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjCGFjO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2023 00:39:14 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871443B858
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 21:39:13 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PW42W3zgxzKqJs;
        Tue,  7 Mar 2023 13:37:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 13:38:35 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 4/4] scsi: hisi_sas: Add device attribute experimental_iopoll_q_cnt for v3 hw
Date:   Tue, 7 Mar 2023 14:09:15 +0800
Message-ID: <1678169355-76215-5-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1678169355-76215-1-git-send-email-chenxiang66@hisilicon.com>
References: <1678169355-76215-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Add device attribute experimental_iopoll_q_cnt to indicate how many
iopoll queues are used for v3 hw.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 1f6c026..8d0e2dd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2855,6 +2855,18 @@ static ssize_t intr_coal_count_v3_hw_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(intr_coal_count_v3_hw);
 
+static ssize_t iopoll_q_cnt_v3_hw_show(struct device *dev,
+					  struct device_attribute
+					  *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct hisi_hba *hisi_hba = shost_priv(shost);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n",
+			 hisi_hba->iopoll_q_cnt);
+}
+static DEVICE_ATTR_RO(iopoll_q_cnt_v3_hw);
+
 static int slave_configure_v3_hw(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = dev_to_shost(&sdev->sdev_gendev);
@@ -2884,6 +2896,7 @@ static struct attribute *host_v3_hw_attrs[] = {
 	&dev_attr_intr_conv_v3_hw.attr,
 	&dev_attr_intr_coal_ticks_v3_hw.attr,
 	&dev_attr_intr_coal_count_v3_hw.attr,
+	&dev_attr_iopoll_q_cnt_v3_hw.attr,
 	NULL
 };
 
-- 
2.8.1


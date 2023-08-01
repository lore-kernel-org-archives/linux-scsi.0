Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 158B6C0015E
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Aug 2023 09:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbjHAJiO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Aug 2023 05:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbjHAJhp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2023 05:37:45 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227742134
        for <linux-scsi@vger.kernel.org>; Tue,  1 Aug 2023 02:36:06 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RFV0k4QMLz1GDNX;
        Tue,  1 Aug 2023 17:19:02 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.174.202) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 17:20:03 +0800
From:   Zhu Wang <wangzhu9@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <gregkh@suse.de>, <kay.sievers@vrfy.org>,
        <James.Bottomley@HansenPartnership.com>,
        <linux-scsi@vger.kernel.org>
CC:     <wangzhu9@huawei.com>
Subject: [PATCH -next] scsi: core: fix error handling for dev_set_name
Date:   Tue, 1 Aug 2023 17:19:33 +0800
Message-ID: <20230801091933.31794-1-wangzhu9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.202]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver do not handle the possible returning error of dev_set_name,
if it returned fail, some operations should be rollback or there may be
possible memory leak. We use put_device to free the device and use kfree
to free the memory in the error handle path.

Fixes: 71610f55fa4d ("[SCSI] struct device - replace bus_id with dev_name(), dev_set_name()")
Signed-off-by: Zhu Wang <wangzhu9@huawei.com>
---
 drivers/scsi/scsi_scan.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index aa13feb17c62..36808a52ab09 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -509,7 +509,13 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	device_initialize(dev);
 	kref_init(&starget->reap_ref);
 	dev->parent = get_device(parent);
-	dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
+	error = dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
+	if (error) {
+		dev_err(dev, "%s: dev_set_name failed, error %d\n", __func__, error);
+		put_device(dev);
+		kfree(starget);
+		return NULL;
+	}
 	dev->bus = &scsi_bus_type;
 	dev->type = &scsi_target_type;
 	scsi_enable_async_suspend(dev);
-- 
2.17.1


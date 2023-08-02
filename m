Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DAA6C0015E
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Aug 2023 03:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbjHBDKu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Aug 2023 23:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbjHBDKs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2023 23:10:48 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867BF1706
        for <linux-scsi@vger.kernel.org>; Tue,  1 Aug 2023 20:10:43 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RFxm26fg1z1GDPb;
        Wed,  2 Aug 2023 11:09:38 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.174.202) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 2 Aug 2023 11:10:40 +0800
From:   Zhu Wang <wangzhu9@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <kay.sievers@vrfy.org>, <gregkh@suse.de>,
        <James.Bottomley@HansenPartnership.com>,
        <linux-scsi@vger.kernel.org>, <bvanassche@acm.org>
CC:     <wangzhu9@huawei.com>
Subject: [PATCH -next v2] scsi: core: fix error handling for dev_set_name
Date:   Wed, 2 Aug 2023 11:10:10 +0800
Message-ID: <20230802031010.14340-1-wangzhu9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.202]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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
Reviewed-by: Bart Van Assche <bvanassche@acm.org>

---
Changes in v2:
- Add put_device(parent) in the error path.
---
 drivers/scsi/scsi_scan.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index aa13feb17c62..de7e503bfcab 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -509,7 +509,14 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	device_initialize(dev);
 	kref_init(&starget->reap_ref);
 	dev->parent = get_device(parent);
-	dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
+	error = dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
+	if (error) {
+		dev_err(dev, "%s: dev_set_name failed, error %d\n", __func__, error);
+		put_device(parent);
+		put_device(dev);
+		kfree(starget);
+		return NULL;
+	}
 	dev->bus = &scsi_bus_type;
 	dev->type = &scsi_target_type;
 	scsi_enable_async_suspend(dev);
-- 
2.17.1


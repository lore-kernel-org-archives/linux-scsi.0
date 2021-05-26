Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A098EC47087
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 01:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7390D6142C
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 01:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbhEZBkb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 21:40:31 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6710 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbhEZBka (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 21:40:30 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FqYRS3dgzzpfSC;
        Wed, 26 May 2021 09:35:16 +0800 (CST)
Received: from dggeme756-chm.china.huawei.com (10.3.19.102) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 26 May 2021 09:38:53 +0800
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 26 May 2021 09:38:52 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <axboe@kernel.dk>, <tj@kernel.org>, <martin.petersen@oracle.com>
CC:     <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH] libata: configure max sectors properly
Date:   Wed, 26 May 2021 09:34:22 +0800
Message-ID: <1621992862-114264-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Max sectors of limitations for scsi host can be set through
scsi_host_template->max_sectors in scsi driver. But we find that max
sectors may exceed scsi_host_template->max_sectors for SATA disk even
if we set it. We find that it may be overwrote in some scsi drivers
(which calls the callback slave_configure and also calls function
ata_scsi_dev_config in it). The invoking relationship is as follows:

scsi_probe_and_add_lun
    ...
    scsi_alloc_sdev
	scsi_mq_alloc_queue
	    ...
	    __scsi_init_queue
		blk_queue_max_hw_sectors(q, shost->max_sectors) //max_sectors coming from sht->max_sectors
	    scsi_change_queue_depth
	    scsi_sysfs_device_initialize
	    shost->hostt->slave_alloc()
		xxx_salve_configure
		    ...
		    ata_scsi_dev_config
			blk_queue_max_hw_sectors(q, dev->max_sectors) //max_sectors is overwrote by dev->max_sectors

To avoid the issue, set q->limits.max_sectors with the minimum value between
dev->max_sectors and q->limits.max_sectors.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/ata/libata-scsi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 48b8934..fb7b243 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1026,12 +1026,15 @@ EXPORT_SYMBOL_GPL(ata_scsi_dma_need_drain);
 int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
 {
 	struct request_queue *q = sdev->request_queue;
+	unsigned int max_sectors;
 
 	if (!ata_id_has_unload(dev->id))
 		dev->flags |= ATA_DFLAG_NO_UNLOAD;
 
 	/* configure max sectors */
-	blk_queue_max_hw_sectors(q, dev->max_sectors);
+	max_sectors = min_t(unsigned int, dev->max_sectors,
+			q->limits.max_sectors);
+	blk_queue_max_hw_sectors(q, max_sectors);
 
 	if (dev->class == ATA_DEV_ATAPI) {
 		sdev->sector_size = ATA_SECT_SIZE;
-- 
2.8.1


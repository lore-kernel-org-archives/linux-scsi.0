Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9054C4708F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 06:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B37561370
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 06:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbhFAHAS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 03:00:18 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2923 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbhFAHAS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 03:00:18 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FvNGL6rCsz67Tx;
        Tue,  1 Jun 2021 14:55:38 +0800 (CST)
Received: from dggpeml500009.china.huawei.com (7.185.36.209) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 14:58:35 +0800
Received: from huawei.com (10.175.101.6) by dggpeml500009.china.huawei.com
 (7.185.36.209) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 1 Jun 2021
 14:58:35 +0800
From:   Yufen Yu <yuyufen@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <john.garry@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <yanaijie@huawei.com>,
        <wubo40@huawei.com>, <yuyufen@huawei.com>
Subject: [PATCH] scsi: libsas: check lun number valid for ata device in sas_queuecommand()
Date:   Tue, 1 Jun 2021 03:04:39 -0400
Message-ID: <20210601070439.1236679-1-yuyufen@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500009.china.huawei.com (7.185.36.209)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We found that offline a ata device on hisi sas control and then
scanning the host can probe 255 not exist devices into system.
It can be reproduced easily as following:

Some ata devices on hisi sas v3 control:
  [root@localhost ~]# lsscsi
  [2:0:0:0]    disk    ATA      Samsung SSD 860  2B6Q  /dev/sda
  [2:0:1:0]    disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdb
  [2:0:2:0]    disk    SEAGATE  ST600MM0006      B001  /dev/sdc

 1) echo "offline" > /sys/block/sdb/device/state
 2) echo "- - -" > /sys/class/scsi_host/host2/scan

Then, we can see another 255 not exist device in system:
  [root@localhost ~]# lsscsi
  [2:0:0:0]    disk    ATA      Samsung SSD 860  2B6Q  /dev/sda
  [2:0:1:0]    disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdb
  [2:0:1:1]    disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdh
  ...
  [2:0:1:254]  disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdja
  [2:0:1:255]  disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdjb

When we try to scan the host, REPORT LUN command issued to the
offline device (sdb) will return fail. Then it tries to do a
sequential scan. Since only one ata device, any INQUIRY command
will be issued to the only device (i.e. lun 0) and return success,
no matter the lun number. So, the device whose lun number is not
zero will also be probed into system.

We fix the probe by checking lun number valid in sas_queuecommand.
Any lun number is not equal '0' will return fail.

Signed-off-by: Wu Bo <wubo40@huawei.com>
Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/scsi/libsas/sas_scsi_host.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 1bf939818c98..62a01d11df96 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -174,6 +174,12 @@ int sas_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	}
 
 	if (dev_is_sata(dev)) {
+		/* sas ata just have one lun */
+		if (cmd->device->lun != 0) {
+			cmd->result = (DID_BAD_TARGET << 16);
+			cmd->scsi_done(cmd);
+			return res;
+		}
 		spin_lock_irq(dev->sata_dev.ap->lock);
 		res = ata_sas_queuecmd(cmd, dev->sata_dev.ap);
 		spin_unlock_irq(dev->sata_dev.ap->lock);
-- 
2.25.4


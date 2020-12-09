Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA7F3C4361B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 12:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D28123C17
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 12:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731703AbgLIMbs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 07:31:48 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9566 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730948AbgLIMbs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 07:31:48 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Crbwv6K1WzM1BY;
        Wed,  9 Dec 2020 20:30:23 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 20:30:58 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH] scsi: sd: fill the interface revalidate_disk of sd_fops
Date:   Wed, 9 Dec 2020 20:27:15 +0800
Message-ID: <1607516835-218244-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

If formatting a normal SAS disk to a DIF disk, it will revalidate the disk
through function bdev_disk_changed() at last which will call
disk->fops->revalidate_disk() (sd_revalidate_disk() for sd driver).
It is DIF type if querying the disk. Log is as follows:

[root@Euler ~]# sg_format --format --fmtpinfo=2 /dev/sdb
    HGST      HUSMM1640ASS204   C2D0   peripheral_type: disk [0x0]
    << supports protection information>>
    Mode Sense (block descriptor) data, prior to changes:
    Number of blocks=781422768 [0x2e9390b0]
    Block size=512 [0x200]
    A FORMAT will commence in 10 seconds
    ALL data on /dev/sdb will be DESTROYED
    Press control-C to abort
    A FORMAT will commence in 5 seconds													  ALL data on /dev/sdb will be DESTROYED
    Press control-C to abort

    Format has started															  FORMAT Complete
[  140.082146] sd 3:0:1:0: [sdb] Disabling DIF Type 1 protection
[root@Euler ~]# lsscsi -p
[3:0:0:0]    disk    ATA      ST4000NM0035-1V4 TN03  /dev/sda   -          none
[3:0:1:0]    disk    HGST     HUSMM1640ASS204  C2D0  /dev/sdb   DIF/Type1  none
[3:0:2:0]    disk    HGST     HUSMM1640ASS204  C2D0  /dev/sdc   -          none
[3:0:3:0]    disk    HGST     HUSMM1640ASS204  C2D0  /dev/sdd   -          none
[3:0:4:0]    disk    HGST     HUSMM1640ASS204  C2D0  /dev/sde   -          none
[3:0:5:0]    disk    HGST     HUSMM1640ASS204  C2D0  /dev/sdf   -          none

But as the commit (471bd0af544b ("sd: use bdev_check_media_change")), it
removes the interface revalidate_disk of sd_fops, so it will not 
revalidate the disk after formatting the disk, so if querying the disk, 
it is still not DIF type but actually it is already formatted as DIF disk.

To solve the issue, still use sd_revalidate_disk() to fill the interface
revalidate_disk of sd_fops.

Fixes: 471bd0af544b ("sd: use bdev_check_media_change")
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/sd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 656bcf4..01eaac1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1888,6 +1888,7 @@ static const struct block_device_operations sd_fops = {
 	.compat_ioctl		= sd_compat_ioctl,
 #endif
 	.check_events		= sd_check_events,
+	.revalidate_disk	= sd_revalidate_disk,
 	.unlock_native_capacity	= sd_unlock_native_capacity,
 	.report_zones		= sd_zbc_report_zones,
 	.pr_ops			= &sd_pr_ops,
-- 
2.8.1


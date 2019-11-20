Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 578EDC432C3
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 09:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 396EF223D1
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 09:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfKTJmh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 04:42:37 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:44330 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726757AbfKTJmh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 04:42:37 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id F03FEEF849C56F642FB0;
        Wed, 20 Nov 2019 17:42:34 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Wed, 20 Nov 2019 17:42:27 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>,
        <hch@lst.de>
CC:     <linux-scsi@vger.kernel.org>, <chenxiang66@hisilicon.com>,
        <linux-kernel@vger.kernel.org>, <yanaijie@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: scsi_transport_sas: Fix memory leak when removing devices
Date:   Wed, 20 Nov 2019 17:39:15 +0800
Message-ID: <1574242755-94156-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Removing a non-host rphy causes a memory leak:

root@(none)$ echo 0 > /sys/devices/platform/HISI0162:01/host0/port-0:0/expander-0:0/port-0:0:10/phy-0:0:10/sas_phy/phy-0:0:10/enable
[   79.857888] hisi_sas_v2_hw HISI0162:01: dev[7:1] is gone
root@(none)$ echo scan > /sys/kernel/debug/kmemleak
[  131.656603] kmemleak: 3 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
root@(none)$ more /sys/kernel/debug/kmemleak
unreferenced object 0xffff041da5c66000 (size 256):
  comm "kworker/u128:1", pid 549, jiffies 4294898543 (age 113.728s)
  hex dump (first 32 bytes):
    00 5e c6 a5 1d 04 ff ff 01 00 00 00 00 00 00 00  .^..............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<(____ptrval____)>] kmem_cache_alloc+0x188/0x260
    [<(____ptrval____)>] bsg_setup_queue+0x48/0x1a8
    [<(____ptrval____)>] sas_rphy_add+0x108/0x2d0
    [<(____ptrval____)>] sas_probe_devices+0x168/0x208
    [<(____ptrval____)>] sas_discover_domain+0x660/0x9c8
    [<(____ptrval____)>] process_one_work+0x3f8/0x690
    [<(____ptrval____)>] worker_thread+0x70/0x6a0
    [<(____ptrval____)>] kthread+0x1b8/0x1c0
    [<(____ptrval____)>] ret_from_fork+0x10/0x18
unreferenced object 0xffff041d8c075400 (size 128):
  comm "kworker/u128:1", pid 549, jiffies 4294898543 (age 113.728s)
  hex dump (first 32 bytes):
    00 40 25 97 1d 00 ff ff 00 00 00 00 00 00 00 00  .@%.............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<(____ptrval____)>] __kmalloc_node+0x1a8/0x2c8
    [<(____ptrval____)>] blk_mq_realloc_tag_set_tags.part.70+0x48/0xd8
    [<(____ptrval____)>] blk_mq_alloc_tag_set+0x1dc/0x530
    [<(____ptrval____)>] bsg_setup_queue+0xe8/0x1a8
    [<(____ptrval____)>] sas_rphy_add+0x108/0x2d0
    [<(____ptrval____)>] sas_probe_devices+0x168/0x208
    [<(____ptrval____)>] sas_discover_domain+0x660/0x9c8
    [<(____ptrval____)>] process_one_work+0x3f8/0x690
    [<(____ptrval____)>] worker_thread+0x70/0x6a0
    [<(____ptrval____)>] kthread+0x1b8/0x1c0
    [<(____ptrval____)>] ret_from_fork+0x10/0x18
unreferenced object 0xffff041da5c65e00 (size 256):
  comm "kworker/u128:1", pid 549, jiffies 4294898543 (age 113.728s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<(____ptrval____)>] __kmalloc_node+0x1a8/0x2c8
    [<(____ptrval____)>] blk_mq_alloc_tag_set+0x254/0x530
    [<(____ptrval____)>] bsg_setup_queue+0xe8/0x1a8
    [<(____ptrval____)>] sas_rphy_add+0x108/0x2d0
    [<(____ptrval____)>] sas_probe_devices+0x168/0x208
    [<(____ptrval____)>] sas_discover_domain+0x660/0x9c8
    [<(____ptrval____)>] process_one_work+0x3f8/0x690
    [<(____ptrval____)>] worker_thread+0x70/0x6a0
    [<(____ptrval____)>] kthread+0x1b8/0x1c0
    [<(____ptrval____)>] ret_from_fork+0x10/0x18
root@(none)$

It turns out that we don't clean up the request queue fully for bsg
devices, as the blk mq tags for the request queue are not freed.

Fix by doing the queue removal in one place - in sas_rphy_remove() -
instead of unregistering the queue in sas_rphy_remove() and finally
cleaning up the queue in calling blk_cleanup_queue() from
sas_end_device_release() or sas_expander_release().

Function bsg_remove_queue() can handle a NULL pointer q, so remove the
precheck in sas_rphy_remove().

Fixes: 651a013649943 ("scsi: scsi_transport_sas: switch to bsg-lib for SMP passthrough")
Signed-off-by: John Garry <john.garry@huawei.com>

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index ef138c57e2a6..182fd25c7c43 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1391,9 +1391,6 @@ static void sas_expander_release(struct device *dev)
 	struct sas_rphy *rphy = dev_to_rphy(dev);
 	struct sas_expander_device *edev = rphy_to_expander_device(rphy);
 
-	if (rphy->q)
-		blk_cleanup_queue(rphy->q);
-
 	put_device(dev->parent);
 	kfree(edev);
 }
@@ -1403,9 +1400,6 @@ static void sas_end_device_release(struct device *dev)
 	struct sas_rphy *rphy = dev_to_rphy(dev);
 	struct sas_end_device *edev = rphy_to_end_device(rphy);
 
-	if (rphy->q)
-		blk_cleanup_queue(rphy->q);
-
 	put_device(dev->parent);
 	kfree(edev);
 }
@@ -1634,8 +1628,7 @@ sas_rphy_remove(struct sas_rphy *rphy)
 	}
 
 	sas_rphy_unlink(rphy);
-	if (rphy->q)
-		bsg_unregister_queue(rphy->q);
+	bsg_remove_queue(rphy->q);
 	transport_remove_device(dev);
 	device_del(dev);
 }
-- 
2.17.1


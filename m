Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6992EC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 06:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A69523120
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 06:26:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbhAMGZo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 01:25:44 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10718 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbhAMGZo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 01:25:44 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DFy7f04gfzl3jM;
        Wed, 13 Jan 2021 14:23:42 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.498.0; Wed, 13 Jan 2021
 14:24:49 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>
Subject: [PATH v2] scsi: scsi_dh_rdac: Avoid crash during rdac_bus_attach
Date:   Wed, 13 Jan 2021 14:31:03 +0800
Message-ID: <20210113063103.2698953-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We get follow BUG_ON when rdac scan:
[595952.944297] kernel BUG at drivers/scsi/device_handler/scsi_dh_rdac.c:427!
[595952.951143] Internal error: Oops - BUG: 0 [#1] SMP
......
[595953.251065] Call trace:
[595953.259054]  check_ownership+0xb0/0x118
[595953.269794]  rdac_bus_attach+0x1f0/0x4b0
[595953.273787]  scsi_dh_handler_attach+0x3c/0xe8
[595953.278211]  scsi_dh_add_device+0xc4/0xe8
[595953.282291]  scsi_sysfs_add_sdev+0x8c/0x2a8
[595953.286544]  scsi_probe_and_add_lun+0x9fc/0xd00
[595953.291142]  __scsi_scan_target+0x598/0x630
[595953.295395]  scsi_scan_target+0x120/0x130
[595953.299481]  fc_user_scan+0x1a0/0x1c0 [scsi_transport_fc]
[595953.304944]  store_scan+0xb0/0x108
[595953.308420]  dev_attr_store+0x44/0x60
[595953.312160]  sysfs_kf_write+0x58/0x80
[595953.315893]  kernfs_fop_write+0xe8/0x1f0
[595953.319888]  __vfs_write+0x60/0x190
[595953.323448]  vfs_write+0xac/0x1c0
[595953.326836]  ksys_write+0x74/0xf0
[595953.330221]  __arm64_sys_write+0x24/0x30

BUG_ON code is in check_ownership:
                list_for_each_entry_rcu(tmp, &h->ctlr->dh_list, node) {
                        /* h->sdev should always be valid */
                        BUG_ON(!tmp->sdev);
                        tmp->sdev->access_state = access_state;
                }
rdac_bus_attach
	initialize_controller
		list_add_rcu(&h->node, &h->ctlr->dh_list);
		h->sdev = sdev;
rdac_bus_detach
	list_del_rcu(&h->node);
	h->sdev = NULL;

Test as follow steps:
(1) Find IO error, remove disk;
(2) Insert disk back;
(3) trigger scan disk;

There is race between rdac_bus_attach and rdac_bus_detach, maybe access
rdac_dh_data which h->sdev has been set NULL when process rdac attach. And also
find that "h->sdev" set value after add list, this may lead to reference NULL ptr.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 5efc959493ec..85a71bafaea7 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -453,8 +453,8 @@ static int initialize_controller(struct scsi_device *sdev,
 		if (!h->ctlr)
 			err = SCSI_DH_RES_TEMP_UNAVAIL;
 		else {
-			list_add_rcu(&h->node, &h->ctlr->dh_list);
 			h->sdev = sdev;
+			list_add_rcu(&h->node, &h->ctlr->dh_list);
 		}
 		spin_unlock(&list_lock);
 		err = SCSI_DH_OK;
@@ -778,11 +778,11 @@ static void rdac_bus_detach( struct scsi_device *sdev )
 	spin_lock(&list_lock);
 	if (h->ctlr) {
 		list_del_rcu(&h->node);
-		h->sdev = NULL;
 		kref_put(&h->ctlr->kref, release_controller);
 	}
 	spin_unlock(&list_lock);
 	sdev->handler_data = NULL;
+	synchronize_rcu();
 	kfree(h);
 }
 
-- 
2.25.4


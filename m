Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C6DC4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Nov 2022 06:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbiKMGqs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Nov 2022 01:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiKMGqr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Nov 2022 01:46:47 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD7110FEC
        for <linux-scsi@vger.kernel.org>; Sat, 12 Nov 2022 22:46:45 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N92ys0gzCzHvlR;
        Sun, 13 Nov 2022 14:46:13 +0800 (CST)
Received: from huawei.com (10.175.100.227) by kwepemi500016.china.huawei.com
 (7.221.188.220) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 13 Nov
 2022 14:46:40 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <brking@us.ibm.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <wayneb@linux.vnet.ibm.com>,
        <James.Bottomley@suse.de>, <linux-scsi@vger.kernel.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH] scsi: ipr: Fix WARNING in ipr_init()
Date:   Sun, 13 Nov 2022 14:45:13 +0800
Message-ID: <20221113064513.14028-1-shangxiaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ipr_init() will not call unregister_reboot_notifier() when
pci_register_driver() failed, which causes the WARNING. Call
unregister_reboot_notifier() when pci_register_driver() failed.

notifier callback ipr_halt [ipr] already registered
WARNING: CPU: 3 PID: 299 at kernel/notifier.c:29
notifier_chain_register+0x16d/0x230
Modules linked in: ipr(+) xhci_pci_renesas xhci_hcd ehci_hcd usbcore
led_class gpu_sched drm_buddy video wmi drm_ttm_helper ttm
drm_display_helper drm_kms_helper drm drm_panel_orientation_quirks
agpgart cfbft
CPU: 3 PID: 299 Comm: modprobe Tainted: G        W
6.1.0-rc1-00190-g39508d23b672-dirty #332
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
RIP: 0010:notifier_chain_register+0x16d/0x230
Call Trace:
 <TASK>
 __blocking_notifier_chain_register+0x73/0xb0
 ipr_init+0x30/0x1000 [ipr]
 do_one_initcall+0xdb/0x480
 do_init_module+0x1cf/0x680
 load_module+0x6a50/0x70a0
 __do_sys_finit_module+0x12f/0x1c0
 do_syscall_64+0x3f/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: f72919ec2bbb ("[SCSI] ipr: implement shutdown changes and remove obsolete write cache parameter")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
---
 drivers/scsi/ipr.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 9d01a3e3c26a..2022ffb45041 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -10872,11 +10872,19 @@ static struct notifier_block ipr_notifier = {
  **/
 static int __init ipr_init(void)
 {
+	int rc;
+
 	ipr_info("IBM Power RAID SCSI Device Driver version: %s %s\n",
 		 IPR_DRIVER_VERSION, IPR_DRIVER_DATE);
 
 	register_reboot_notifier(&ipr_notifier);
-	return pci_register_driver(&ipr_driver);
+	rc = pci_register_driver(&ipr_driver);
+	if (rc) {
+		unregister_reboot_notifier(&ipr_notifier);
+		return rc;
+	}
+
+	return 0;
 }
 
 /**
-- 
2.17.1


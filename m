Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A51CC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 02:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiKDCPp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Nov 2022 22:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiKDCPo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Nov 2022 22:15:44 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607FC1A5
        for <linux-scsi@vger.kernel.org>; Thu,  3 Nov 2022 19:15:43 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N3PNm10Ldz15MMQ;
        Fri,  4 Nov 2022 10:15:36 +0800 (CST)
Received: from huawei.com (10.175.100.227) by kwepemi500016.china.huawei.com
 (7.221.188.220) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 4 Nov
 2022 10:15:41 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH] scsi: scsi_transport_spi: Fix page fault in spi_transport_init()
Date:   Fri, 4 Nov 2022 10:14:30 +0800
Message-ID: <20221104021430.25486-1-shangxiaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

spi_transport_init() will call transport_class_register() twice. If the
2nd transport_class_register() failed, it won't unregister
spi_transport_class, which will causes the failed module cannot insert
anymore. Besides, spi_device_class is also not unregistered, which will
causes the page fault when another module calls
attribute_container_register().

Unregister spi_transport_class and spi_transport_class in fail path to
prevent page fault, and the problem that cannot insert anymore.

The bug is found when sym53c8xx failed in 2nd transport_class_register()
and then insert myrb:

BUG: unable to handle page fault for address: fffffbfff4001e4e
PGD 123ff2067 P4D 123ff2067 PUD 123f0e067 PMD 10d0a7067 PTE 0
Oops: 0000 [#1] SMP KASAN PTI
CPU: 3 PID: 20290 Comm: modprobe Tainted: G        W
6.1.0-rc1-00180-g5d7833433b64 #253
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
RIP: 0010:attribute_container_register+0xcf/0x130
Call Trace:
 <TASK>
 ? 0xffffffffa0038000
 raid_class_attach+0x10d/0x218 [raid_class]
 myrb_init_module+0x1c/0x1000 [myrb]
 do_one_initcall+0xdb/0x480
 ? trace_event_raw_event_initcall_level+0x1c0/0x1c0
 ? rcu_read_lock_sched_held+0xa5/0xd0
 ? rcu_read_lock_bh_held+0xc0/0xc0
 ? __kmem_cache_alloc_node+0x3a8/0x7b0
 ? kasan_unpoison+0x23/0x50
 ? 0xffffffffa0038000
 do_init_module+0x1cf/0x680
 load_module+0x6a50/0x70a0
 ...
 do_syscall_64+0x3f/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
---
 drivers/scsi/scsi_transport_spi.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index f569cf0095c2..a0dbc5ce29c9 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -1622,7 +1622,20 @@ static __init int spi_transport_init(void)
 	if (error)
 		return error;
 	error = anon_transport_class_register(&spi_device_class);
-	return transport_class_register(&spi_host_class);
+	if (error)
+		goto unregister_transport;
+
+	error = transport_class_register(&spi_host_class);
+	if (error)
+		goto unregister_device;
+
+	return 0;
+
+unregister_device:
+	anon_transport_class_unregister(&spi_device_class);
+unregister_transport:
+	transport_class_unregister(&spi_transport_class);
+	return error;
 }
 
 static void __exit spi_transport_exit(void)
-- 
2.17.1


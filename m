Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F76C4363D
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 14:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AAF0206DB
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 14:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388232AbgJBOew (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 10:34:52 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14802 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388123AbgJBOek (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Oct 2020 10:34:40 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C1FF6A9EE2D0BBA35BB3;
        Fri,  2 Oct 2020 22:34:34 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 2 Oct 2020 22:34:27 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 6/7] scsi: hisi_sas: Filter out new PHYs up events during suspended
Date:   Fri, 2 Oct 2020 22:30:37 +0800
Message-ID: <1601649038-25534-7-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1601649038-25534-1-git-send-email-john.garry@huawei.com>
References: <1601649038-25534-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Currently sas_resume_ha() is called in the last process of resuming the
controller which waits all suspended PHYs up and all the libsas event
completed. But there is a situation which will cause task hung: for
directly attached situation, two disks are connected with two PHYs, disable phy0
before suspended the disk on phy1 and the controller, then enable phy0
and resume the controller, and task hung occurs as follows:

[  591.901463] hisi_sas_v3_hw 0000:b4:02.0: resuming from operating state [D0]
[  593.113525] hisi_sas_v3_hw 0000:b4:02.0: neither _PS0 nor _PR0 is defined
[  593.120301] hisi_sas_v3_hw 0000:b4:02.0: waiting up to 25 seconds for 1 phy to resume
[  593.120836] hisi_sas_v3_hw 0000:b4:02.0: phyup: phy0 link_rate=10(sata)
[  593.134680] hisi_sas_v3_hw 0000:b4:02.0: phyup: phy1 link_rate=10(sata)
[  593.134733] sas: phy-2:0 added to port-2:0, phy_mask:0x1 (5000000000000200)
[  593.148350] sas: DOING DISCOVERY on port 0, pid:948
[  593.153227] hisi_sas_v3_hw 0000:b4:02.0: dev[3:5] found
[  593.159840] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[  593.165663] sas: ata7: end_device-2:0: dev error handler
[  593.165730] sas: ata2: end_device-2:1: dev error handler
[  593.172532] hisi_sas_v3_hw 0000:b4:02.0: phydown: phy0 phy_state=0x2
[  593.182570] hisi_sas_v3_hw 0000:b4:02.0: ignore flutter phy0 down
[  593.331277] hisi_sas_v3_hw 0000:b4:02.0: phyup: phy0 link_rate=10(sata)
[  593.498956] ata7.00: ATA-11: SAMSUNG MZ7LH960HAJR-00005, HXT7404Q, max UDMA/133
[  593.506235] ata7.00: 1875385008 sectors, multi 16: LBA48 NCQ (depth 32)
[  593.514295] ata7.00: configured for UDMA/133
[  593.518557] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[  593.528613] sas: ata7: end_device-2:0: model:SAMSUNG MZ7LH960HAJR-00005
serial:S45NNA0M712225
[  593.537520] device_link_add 316: dev=2:0:2:0 supplier:2 consumer:0
[  593.543674] device_link_add 324
[  593.546801] device_link_add 352
[  593.549930] device_link_add 406
[  593.553058] device_link_add 440: dev=2:0:2:0 supplier:2 consumer:0
[  593.559208] device_link_add 444
[  593.562335] device_link_add 455
[  593.565517] scsi 2:0:2:0: Direct-Access     ATA      SAMSUNG MZ7LH960 404Q PQ: 0
ANSI: 5
[  620.057464]  phy-2:1: resume timeout
[  738.841445] INFO: task kworker/u256:0:8 blocked for more than 120 seconds.
[  738.848295]       Not tainted 5.8.0-rc1-76154-g0d52b59-dirty #744
[  738.854361] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  738.862155] kworker/u256:0  D    0     8      2 0x00000028
[  738.867626] Workqueue: 0000:b4:02.0_event_q sas_port_event_worker
[  738.873693] Call trace:
[  738.876133]  __switch_to+0xf4/0x148
[  738.879613]  __schedule+0x270/0x5d8
[  738.883091]  schedule+0x78/0x110
[  738.886307]  schedule_timeout+0x1ac/0x280
[  738.890299]  wait_for_completion+0x94/0x138
[  738.894472]  flush_workqueue+0x114/0x438
[  738.898377]  sas_porte_bytes_dmaed+0x400/0x500
[  738.902801]  sas_port_event_worker+0x28/0x40
[  738.907053]  process_one_work+0x1e8/0x360
[  738.911046]  worker_thread+0x44/0x478
[  738.914698]  kthread+0x150/0x158
[  738.917915]  ret_from_fork+0x10/0x1c
[  738.921534] INFO: task kworker/u256:1:948 blocked for more than 120 seconds.
[  738.928550]       Not tainted 5.8.0-rc1-76154-g0d52b59-dirty #744
[  738.934614] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  738.942408] kworker/u256:1  D    0   948      2 0x00000028
[  738.947873] Workqueue: 0000:b4:02.0_disco_q sas_discover_domain
[  738.953766] Call trace:
[  738.956203]  __switch_to+0xf4/0x148
[  738.959678]  __schedule+0x270/0x5d8
[  738.963152]  schedule+0x78/0x110
[  738.966368]  rpm_resume+0xcc/0x550
[  738.969757]  __pm_runtime_resume+0x3c/0x88
[  738.973836]  rpm_get_suppliers+0x50/0x148
[  738.977829]  __pm_runtime_set_status+0x124/0x2f0
[  738.982427]  scsi_sysfs_add_sdev+0x1a0/0x2a8
[  738.986679]  scsi_probe_and_add_lun+0x888/0xab0
[  738.991190]  __scsi_scan_target+0xec/0x520
[  738.995268]  scsi_scan_target+0x11c/0x128
[  738.999261]  sas_rphy_add+0x15c/0x1e8
[  739.002907]  sas_probe_devices+0xe4/0x150
[  739.006899]  sas_discover_domain+0x33c/0x588
[  739.011150]  process_one_work+0x1e8/0x360
[  739.015143]  worker_thread+0x44/0x478
[  739.018789]  kthread+0x150/0x158
[  739.022003]  ret_from_fork+0x10/0x1c
...

We find that if extra phy0 up during resuming SAS controller, it will bring
new libsas event of phy0 (event PORTE_BYTES_DMAED and event
DISCE_DISCOVER_DOMAIN). It will call function scsi_sysfs_add_sdev() in
event DISCE_DISCOVER_DOMAIN, which will call __pm_runtime_set_status() to
resume supplier(host controller). For runtime PM core, if device is in the
resuming status, the later resume request of the device will wait for
previous resume request completed in sync mode. So at that time the
status of the controller is still resuming as it waits for all libsas
event completed, while libsas event DISCE_DISCOVER_DOMAIN is blocked as
the status of the controller is resuming which causes a deadlock.

To avoid the issue, filter out new PHYs up events during suspended time
of the controller.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index f18452942508..ef3922ad70c0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -619,6 +619,12 @@ static void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no)
 	if (!phy->phy_attached)
 		return;
 
+	if (test_bit(HISI_SAS_PM_BIT, &hisi_hba->flags) &&
+	    !sas_phy->suspended) {
+		dev_warn(hisi_hba->dev, "phy%d during suspend filtered out\n", phy_no);
+		return;
+	}
+
 	sas_ha = &hisi_hba->sha;
 	sas_ha->notify_phy_event(sas_phy, PHYE_OOB_DONE);
 
-- 
2.26.2


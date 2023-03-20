Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFEAAC7618A
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Mar 2023 03:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjCTDDv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Mar 2023 23:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCTDDt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Mar 2023 23:03:49 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3B45271
        for <linux-scsi@vger.kernel.org>; Sun, 19 Mar 2023 20:03:48 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Pfzyz1ycQzKs3X;
        Mon, 20 Mar 2023 11:01:31 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 11:03:46 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        Yihang Li <liyihang9@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 3/4] scsi: hisi_sas: Ensure all enabled PHYs up during controller reset
Date:   Mon, 20 Mar 2023 11:34:24 +0800
Message-ID: <1679283265-115066-4-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1679283265-115066-1-git-send-email-chenxiang66@hisilicon.com>
References: <1679283265-115066-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Yihang Li <liyihang9@huawei.com>

For the controller reset operation, hisi_sas_phy_enable() is executed for
each enabled local PHY, and refresh the port id of each device based on
the latest hisi_sas_phy->port_id after 1 second sleep,
hisi_sas_phy->port_id is configured in the interrupt processing function
phy_up_v3_hw(). However, in directly attached scenario, for some SATA
disks the amount of time for phyup more than 1s sometimes. In this case,
incorrect port id may be configured in hisi_sas_refresh_port_id().
As a result, all the internal IOs fail and disk lost, such as follows:

[10717.666565] hisi_sas_v3_hw 0000:74:02.0: phyup: phy1 link_rate=10(sata)
[10718.826813] hisi_sas_v3_hw 0000:74:02.0: erroneous completion iptt=63
task=00000000c1ab1c2b dev id=200 addr=5000000000000501 CQ hdr: 0x8000007 0xc8003f 0x0
0x0 Error info: 0x0 0x0 0x0 0x0
[10718.843428] sas: TMF task open reject failed  5000000000000501
[10718.849242] hisi_sas_v3_hw 0000:74:02.0: erroneous completion iptt=64
task=00000000c1ab1c2b dev id=200 addr=5000000000000501 CQ hdr: 0x8000007 0xc80040 0x0
0x0 Error info: 0x0 0x0 0x0 0x0
[10718.865856] sas: TMF task open reject failed  5000000000000501
[10718.871670] hisi_sas_v3_hw 0000:74:02.0: erroneous completion iptt=65
task=00000000c1ab1c2b dev id=200 addr=5000000000000501 CQ hdr: 0x8000007 0xc80041 0x0
0x0 Error info: 0x0 0x0 0x0 0x0
[10718.888284] sas: TMF task open reject failed  5000000000000501
[10718.894093] sas: executing TMF for 5000000000000501 failed after 3 attempts!
[10718.901114] hisi_sas_v3_hw 0000:74:02.0: ata disk 5000000000000501 reset failed
[10718.908410] hisi_sas_v3_hw 0000:74:02.0: controller reset complete
.....
[10773.298633] ata216.00: revalidation failed (errno=-19)
[10773.303753] ata216.00: disable device

So the time of waitting for PHYs up is 1s which may be not enough. To
solve the issue, running hisi_sas_phy_enable() in parallel through
async operations and use wait_for_completion_timeout() to wait for PHYs
come up instead of directly sleep for 1 second.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d2e94979..412431c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1520,13 +1520,41 @@ void hisi_sas_controller_reset_prepare(struct hisi_hba *hisi_hba)
 }
 EXPORT_SYMBOL_GPL(hisi_sas_controller_reset_prepare);
 
+static void hisi_sas_async_init_wait_phyup(void *data, async_cookie_t cookie)
+{
+	struct hisi_sas_phy *phy = data;
+	struct hisi_hba *hisi_hba = phy->hisi_hba;
+	struct device *dev = hisi_hba->dev;
+	DECLARE_COMPLETION_ONSTACK(completion);
+	int phy_no = phy->sas_phy.id;
+
+	phy->reset_completion = &completion;
+	hisi_sas_phy_enable(hisi_hba, phy_no, 1);
+	if (!wait_for_completion_timeout(&completion,
+					 HISI_SAS_WAIT_PHYUP_TIMEOUT))
+		dev_warn(dev, "phy%d wait phyup timed out\n", phy_no);
+
+	phy->reset_completion = NULL;
+}
+
 void hisi_sas_controller_reset_done(struct hisi_hba *hisi_hba)
 {
 	struct Scsi_Host *shost = hisi_hba->shost;
+	ASYNC_DOMAIN_EXCLUSIVE(async);
+	int phy_no;
 
 	/* Init and wait for PHYs to come up and all libsas event finished. */
-	hisi_hba->hw->phys_init(hisi_hba);
-	msleep(1000);
+	for (phy_no = 0; phy_no < hisi_hba->n_phy; phy_no++) {
+		struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+
+		if (!(hisi_hba->phy_state & BIT(phy_no)))
+			continue;
+
+		async_schedule_domain(hisi_sas_async_init_wait_phyup,
+				      phy, &async);
+	}
+
+	async_synchronize_full_domain(&async);
 	hisi_sas_refresh_port_id(hisi_hba);
 	clear_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
 
-- 
2.8.1


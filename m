Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F005C7EE25
	for <linux-scsi@archiver.kernel.org>; Mon, 15 May 2023 02:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbjEOCK4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 May 2023 22:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbjEOCKy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 May 2023 22:10:54 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB12910F0
        for <linux-scsi@vger.kernel.org>; Sun, 14 May 2023 19:10:51 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QKN7K31q9zLpql;
        Mon, 15 May 2023 10:07:57 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 10:10:49 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        Xingui Yang <yangxingui@huawei.com>,
        Yihang Li <liyihang9@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 2/3] scsi: hisi_sas: Change DMA setup lock timeout to 2.5s
Date:   Mon, 15 May 2023 10:41:20 +0800
Message-ID: <1684118481-95908-3-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1684118481-95908-1-git-send-email-chenxiang66@hisilicon.com>
References: <1684118481-95908-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xingui Yang <yangxingui@huawei.com>

DMA setup lock timeout protection is added when DMA setup frames are
received, it's a function outside the protocol and used to prevent SATA
disk I/Os from being delivered for a long time. The default value is 100ms,
it's too strict and easily triggered timeout when the disk is overloaded
or faulty. Based on the average I/O latency of 300 disks, we adjust the
value to 2.5s.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index e279c9c..3d1869c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -30,6 +30,7 @@
 #define SATA_INITI_D2H_STORE_ADDR_LO	0x60
 #define SATA_INITI_D2H_STORE_ADDR_HI	0x64
 #define CFG_MAX_TAG			0x68
+#define TRANS_LOCK_ICT_TIME		0X70
 #define HGC_SAS_TX_OPEN_FAIL_RETRY_CTRL	0x84
 #define HGC_SAS_TXFAIL_RETRY_CTRL	0x88
 #define HGC_GET_ITV_TIME		0x90
@@ -634,6 +635,8 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 	hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE,
 			 (u32)((1ULL << hisi_hba->queue_count) - 1));
 	hisi_sas_write32(hisi_hba, CFG_MAX_TAG, 0xfff0400);
+	/* time / CLK_AHB = 2.5s / 2ns = 0x4A817C80 */
+	hisi_sas_write32(hisi_hba, TRANS_LOCK_ICT_TIME, 0x4A817C80);
 	hisi_sas_write32(hisi_hba, HGC_SAS_TXFAIL_RETRY_CTRL, 0x108);
 	hisi_sas_write32(hisi_hba, CFG_AGING_TIME, 0x1);
 	hisi_sas_write32(hisi_hba, INT_COAL_EN, 0x1);
@@ -3006,6 +3009,7 @@ static const struct hisi_sas_debugfs_reg_lu debugfs_global_reg_lu[] = {
 	HISI_SAS_DEBUGFS_REG(SATA_INITI_D2H_STORE_ADDR_LO),
 	HISI_SAS_DEBUGFS_REG(SATA_INITI_D2H_STORE_ADDR_HI),
 	HISI_SAS_DEBUGFS_REG(CFG_MAX_TAG),
+	HISI_SAS_DEBUGFS_REG(TRANS_LOCK_ICT_TIME),
 	HISI_SAS_DEBUGFS_REG(HGC_SAS_TX_OPEN_FAIL_RETRY_CTRL),
 	HISI_SAS_DEBUGFS_REG(HGC_SAS_TXFAIL_RETRY_CTRL),
 	HISI_SAS_DEBUGFS_REG(HGC_GET_ITV_TIME),
-- 
2.8.1


Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87191EE57CC
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 02:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235284AbjIMCP5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 22:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbjIMCP4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 22:15:56 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE94170A
        for <linux-scsi@vger.kernel.org>; Tue, 12 Sep 2023 19:15:52 -0700 (PDT)
Received: from kwepemd500002.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RlkXL2h0tz1N82q;
        Wed, 13 Sep 2023 10:13:54 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemd500002.china.huawei.com (7.221.188.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1258.23; Wed, 13 Sep 2023 10:15:49 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        Yihang Li <liyihang9@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 2/3] scsi: hisi_sas: Directly calling register snapshot instead of workqueue
Date:   Wed, 13 Sep 2023 10:15:26 +0800
Message-ID: <1694571327-78697-3-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1694571327-78697-1-git-send-email-chenxiang66@hisilicon.com>
References: <1694571327-78697-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemd500002.china.huawei.com (7.221.188.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Yihang Li <liyihang9@huawei.com>

Currently, register information dump is performed via workqueue,
regardless of the trigger mode (automatic or manual), there is a delay in
dumping register through workqueue, the register information at the
trigger time cannot be obtained. So, directly calling register snapshot
instead of calling them through workqueue.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  1 -
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  7 +++++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 14 +++-----------
 3 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 9e73e9c..3d511c4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -451,7 +451,6 @@ struct hisi_hba {
 	const struct hisi_sas_hw *hw;	/* Low level hw interface */
 	unsigned long sata_dev_bitmap[BITS_TO_LONGS(HISI_SAS_MAX_DEVICES)];
 	struct work_struct rst_work;
-	struct work_struct debugfs_work;
 	u32 phy_state;
 	u32 intr_coal_ticks;	/* Time of interrupt coalesce in us */
 	u32 intr_coal_count;	/* Interrupt count to coalesce */
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 9472b97..d50058b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1958,8 +1958,11 @@ static bool hisi_sas_internal_abort_timeout(struct sas_task *task,
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
 	struct hisi_sas_internal_abort_data *timeout = data;
 
-	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct)
-		queue_work(hisi_hba->wq, &hisi_hba->debugfs_work);
+	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct) {
+		down(&hisi_hba->sem);
+		hisi_hba->hw->debugfs_snapshot_regs(hisi_hba);
+		up(&hisi_hba->sem);
+	}
 
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
 		pr_err("Internal abort: timeout %016llx\n",
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index f326d2d..b61547b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -558,7 +558,6 @@ static int experimental_iopoll_q_cnt;
 module_param(experimental_iopoll_q_cnt, int, 0444);
 MODULE_PARM_DESC(experimental_iopoll_q_cnt, "number of queues to be used as poll mode, def=0");
 
-static void debugfs_work_handler_v3_hw(struct work_struct *work);
 static void debugfs_snapshot_regs_v3_hw(struct hisi_hba *hisi_hba);
 
 static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
@@ -3388,7 +3387,6 @@ hisi_sas_shost_alloc_pci(struct pci_dev *pdev)
 	hisi_hba = shost_priv(shost);
 
 	INIT_WORK(&hisi_hba->rst_work, hisi_sas_rst_work_handler);
-	INIT_WORK(&hisi_hba->debugfs_work, debugfs_work_handler_v3_hw);
 	hisi_hba->hw = &hisi_sas_v3_hw;
 	hisi_hba->pci_dev = pdev;
 	hisi_hba->dev = dev;
@@ -3910,7 +3908,9 @@ static ssize_t debugfs_trigger_dump_v3_hw_write(struct file *file,
 	if (buf[0] != '1')
 		return -EFAULT;
 
-	queue_work(hisi_hba->wq, &hisi_hba->debugfs_work);
+	down(&hisi_hba->sem);
+	debugfs_snapshot_regs_v3_hw(hisi_hba);
+	up(&hisi_hba->sem);
 
 	return count;
 }
@@ -4542,14 +4542,6 @@ static void debugfs_fifo_init_v3_hw(struct hisi_hba *hisi_hba)
 	}
 }
 
-static void debugfs_work_handler_v3_hw(struct work_struct *work)
-{
-	struct hisi_hba *hisi_hba =
-		container_of(work, struct hisi_hba, debugfs_work);
-
-	debugfs_snapshot_regs_v3_hw(hisi_hba);
-}
-
 static void debugfs_release_v3_hw(struct hisi_hba *hisi_hba, int dump_index)
 {
 	struct device *dev = hisi_hba->dev;
-- 
2.8.1


Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44ADBEE49B7
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 02:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbjIMCP5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 22:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjIMCP4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 22:15:56 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EF1170E
        for <linux-scsi@vger.kernel.org>; Tue, 12 Sep 2023 19:15:52 -0700 (PDT)
Received: from kwepemd500002.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RlkXL3k3Zz1N82t;
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
Subject: [PATCH 3/3] scsi: hisi_sas: Allocate DFX memory during dump trigger
Date:   Wed, 13 Sep 2023 10:15:27 +0800
Message-ID: <1694571327-78697-4-git-send-email-chenxiang66@hisilicon.com>
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

Currently, if CONFIG_SCSI_HISI_SAS_DEBUGFS_DEFAULT_ENABLE is enabled, the
memory space used by DFX is allocated during device initialization, which
occupies a large number of memory resources. The memory usage before and
after the driver is loaded is as follows:

Memory usage before the driver is loaded:
$ free -m
         total        used        free      shared  buff/cache   available
Mem:     867352        2578      864037          11         735  861681
Swap:    4095           0        4095

Memory usage after the driver which include 4 HBAs is loaded:
$ insmod hisi_sas_v3_hw.ko
$ free -m
         total        used        free      shared  buff/cache	available
Mem:     867352        4760      861848          11	743      859495
Swap:    4095           0        4095

By the way, the sas driver with 4 HBAs will costs about 110 MB of memory
without enabling debugfs.

Therefore, to avoid wasting memory resources, DFX memory is allocated
during dump triggering, and the dump will fail due to memory allocation
failure. After this change, each dump costs about 10 MB of memory, and
each dump lasts about 100 ms.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 93 ++++++++++++++++------------------
 2 files changed, 46 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 3d511c4..1e45501 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -343,7 +343,7 @@ struct hisi_sas_hw {
 				u8 reg_index, u8 reg_count, u8 *write_data);
 	void (*wait_cmds_complete_timeout)(struct hisi_hba *hisi_hba,
 					   int delay_ms, int timeout_ms);
-	void (*debugfs_snapshot_regs)(struct hisi_hba *hisi_hba);
+	int (*debugfs_snapshot_regs)(struct hisi_hba *hisi_hba);
 	int complete_hdr_size;
 	const struct scsi_host_template *sht;
 };
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index b61547b..d8437a9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -558,7 +558,7 @@ static int experimental_iopoll_q_cnt;
 module_param(experimental_iopoll_q_cnt, int, 0444);
 MODULE_PARM_DESC(experimental_iopoll_q_cnt, "number of queues to be used as poll mode, def=0");
 
-static void debugfs_snapshot_regs_v3_hw(struct hisi_hba *hisi_hba);
+static int debugfs_snapshot_regs_v3_hw(struct hisi_hba *hisi_hba);
 
 static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
 {
@@ -3858,37 +3858,6 @@ static void debugfs_create_files_v3_hw(struct hisi_hba *hisi_hba)
 			    &debugfs_ras_v3_hw_fops);
 }
 
-static void debugfs_snapshot_regs_v3_hw(struct hisi_hba *hisi_hba)
-{
-	int debugfs_dump_index = hisi_hba->debugfs_dump_index;
-	struct device *dev = hisi_hba->dev;
-	u64 timestamp = local_clock();
-
-	if (debugfs_dump_index >= hisi_sas_debugfs_dump_count) {
-		dev_warn(dev, "dump count exceeded!\n");
-		return;
-	}
-
-	do_div(timestamp, NSEC_PER_MSEC);
-	hisi_hba->debugfs_timestamp[debugfs_dump_index] = timestamp;
-
-	debugfs_snapshot_prepare_v3_hw(hisi_hba);
-
-	debugfs_snapshot_global_reg_v3_hw(hisi_hba);
-	debugfs_snapshot_port_reg_v3_hw(hisi_hba);
-	debugfs_snapshot_axi_reg_v3_hw(hisi_hba);
-	debugfs_snapshot_ras_reg_v3_hw(hisi_hba);
-	debugfs_snapshot_cq_reg_v3_hw(hisi_hba);
-	debugfs_snapshot_dq_reg_v3_hw(hisi_hba);
-	debugfs_snapshot_itct_reg_v3_hw(hisi_hba);
-	debugfs_snapshot_iost_reg_v3_hw(hisi_hba);
-
-	debugfs_create_files_v3_hw(hisi_hba);
-
-	debugfs_snapshot_restore_v3_hw(hisi_hba);
-	hisi_hba->debugfs_dump_index++;
-}
-
 static ssize_t debugfs_trigger_dump_v3_hw_write(struct file *file,
 						const char __user *user_buf,
 						size_t count, loff_t *ppos)
@@ -3896,9 +3865,6 @@ static ssize_t debugfs_trigger_dump_v3_hw_write(struct file *file,
 	struct hisi_hba *hisi_hba = file->f_inode->i_private;
 	char buf[8];
 
-	if (hisi_hba->debugfs_dump_index >= hisi_sas_debugfs_dump_count)
-		return -EFAULT;
-
 	if (count > 8)
 		return -EFAULT;
 
@@ -3909,7 +3875,10 @@ static ssize_t debugfs_trigger_dump_v3_hw_write(struct file *file,
 		return -EFAULT;
 
 	down(&hisi_hba->sem);
-	debugfs_snapshot_regs_v3_hw(hisi_hba);
+	if (debugfs_snapshot_regs_v3_hw(hisi_hba)) {
+		up(&hisi_hba->sem);
+		return -EFAULT;
+	}
 	up(&hisi_hba->sem);
 
 	return count;
@@ -4576,7 +4545,7 @@ static int debugfs_alloc_v3_hw(struct hisi_hba *hisi_hba, int dump_index)
 {
 	const struct hisi_sas_hw *hw = hisi_hba->hw;
 	struct device *dev = hisi_hba->dev;
-	int p, c, d, r, i;
+	int p, c, d, r;
 	size_t sz;
 
 	for (r = 0; r < DEBUGFS_REGS_NUM; r++) {
@@ -4656,11 +4625,48 @@ static int debugfs_alloc_v3_hw(struct hisi_hba *hisi_hba, int dump_index)
 
 	return 0;
 fail:
-	for (i = 0; i < hisi_sas_debugfs_dump_count; i++)
-		debugfs_release_v3_hw(hisi_hba, i);
+	debugfs_release_v3_hw(hisi_hba, dump_index);
 	return -ENOMEM;
 }
 
+static int debugfs_snapshot_regs_v3_hw(struct hisi_hba *hisi_hba)
+{
+	int debugfs_dump_index = hisi_hba->debugfs_dump_index;
+	struct device *dev = hisi_hba->dev;
+	u64 timestamp = local_clock();
+
+	if (debugfs_dump_index >= hisi_sas_debugfs_dump_count) {
+		dev_warn(dev, "dump count exceeded!\n");
+		return -EINVAL;
+	}
+
+	if (debugfs_alloc_v3_hw(hisi_hba, debugfs_dump_index)) {
+		dev_warn(dev, "failed to alloc memory\n");
+		return -ENOMEM;
+	}
+
+	do_div(timestamp, NSEC_PER_MSEC);
+	hisi_hba->debugfs_timestamp[debugfs_dump_index] = timestamp;
+
+	debugfs_snapshot_prepare_v3_hw(hisi_hba);
+
+	debugfs_snapshot_global_reg_v3_hw(hisi_hba);
+	debugfs_snapshot_port_reg_v3_hw(hisi_hba);
+	debugfs_snapshot_axi_reg_v3_hw(hisi_hba);
+	debugfs_snapshot_ras_reg_v3_hw(hisi_hba);
+	debugfs_snapshot_cq_reg_v3_hw(hisi_hba);
+	debugfs_snapshot_dq_reg_v3_hw(hisi_hba);
+	debugfs_snapshot_itct_reg_v3_hw(hisi_hba);
+	debugfs_snapshot_iost_reg_v3_hw(hisi_hba);
+
+	debugfs_create_files_v3_hw(hisi_hba);
+
+	debugfs_snapshot_restore_v3_hw(hisi_hba);
+	hisi_hba->debugfs_dump_index++;
+
+	return 0;
+}
+
 static void debugfs_phy_down_cnt_init_v3_hw(struct hisi_hba *hisi_hba)
 {
 	struct dentry *dir = debugfs_create_dir("phy_down_cnt",
@@ -4747,7 +4753,6 @@ static void debugfs_exit_v3_hw(struct hisi_hba *hisi_hba)
 static void debugfs_init_v3_hw(struct hisi_hba *hisi_hba)
 {
 	struct device *dev = hisi_hba->dev;
-	int i;
 
 	hisi_hba->debugfs_dir = debugfs_create_dir(dev_name(dev),
 						   hisi_sas_debugfs_dir);
@@ -4764,14 +4769,6 @@ static void debugfs_init_v3_hw(struct hisi_hba *hisi_hba)
 
 	debugfs_phy_down_cnt_init_v3_hw(hisi_hba);
 	debugfs_fifo_init_v3_hw(hisi_hba);
-
-	for (i = 0; i < hisi_sas_debugfs_dump_count; i++) {
-		if (debugfs_alloc_v3_hw(hisi_hba, i)) {
-			debugfs_exit_v3_hw(hisi_hba);
-			dev_dbg(dev, "failed to init debugfs!\n");
-			break;
-		}
-	}
 }
 
 static int
-- 
2.8.1


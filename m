Return-Path: <SRS0=yvfi=XB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD5A9C43331
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 12:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 891992082C
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 12:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404954AbfIFM6U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Sep 2019 08:58:20 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7134 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404909AbfIFM6S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Sep 2019 08:58:18 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D71CF8630273159995E4;
        Fri,  6 Sep 2019 20:58:10 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Fri, 6 Sep 2019 20:58:04 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH 10/13] scsi: hisi_sas: Remove some unused function arguments
Date:   Fri, 6 Sep 2019 20:55:34 +0800
Message-ID: <1567774537-20003-11-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1567774537-20003-1-git-send-email-john.garry@huawei.com>
References: <1567774537-20003-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

Some function arguments are unused, so remove them.

Also move the timeout print in for wait_cmds_complete_timeout_vX_hw()
callsites into that same function.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  4 ++--
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  5 ++---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 11 ++++++-----
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 17 +++++++----------
 4 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index d02ab2699b9b..ccbe4563402a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -306,8 +306,8 @@ struct hisi_sas_hw {
 	u32 (*get_phys_state)(struct hisi_hba *hisi_hba);
 	int (*write_gpio)(struct hisi_hba *hisi_hba, u8 reg_type,
 				u8 reg_index, u8 reg_count, u8 *write_data);
-	int (*wait_cmds_complete_timeout)(struct hisi_hba *hisi_hba,
-					  int delay_ms, int timeout_ms);
+	void (*wait_cmds_complete_timeout)(struct hisi_hba *hisi_hba,
+					   int delay_ms, int timeout_ms);
 	void (*snapshot_prepare)(struct hisi_hba *hisi_hba);
 	void (*snapshot_restore)(struct hisi_hba *hisi_hba);
 	void (*read_iost_itct_cache)(struct hisi_hba *hisi_hba,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index efd0ddf24e99..b96732493137 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1391,8 +1391,7 @@ static void hisi_sas_refresh_port_id(struct hisi_hba *hisi_hba)
 	}
 }
 
-static void hisi_sas_rescan_topology(struct hisi_hba *hisi_hba, u32 old_state,
-			      u32 state)
+static void hisi_sas_rescan_topology(struct hisi_hba *hisi_hba, u32 state)
 {
 	struct sas_ha_struct *sas_ha = &hisi_hba->sha;
 	struct asd_sas_port *_sas_port = NULL;
@@ -1553,7 +1552,7 @@ void hisi_sas_controller_reset_done(struct hisi_hba *hisi_hba)
 	clear_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags);
 
 	state = hisi_hba->hw->get_phys_state(hisi_hba);
-	hisi_sas_rescan_topology(hisi_hba, hisi_hba->phy_state, state);
+	hisi_sas_rescan_topology(hisi_hba, state);
 }
 EXPORT_SYMBOL_GPL(hisi_sas_controller_reset_done);
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index b01ccb38b00a..8e96a257e439 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3498,8 +3498,8 @@ static int write_gpio_v2_hw(struct hisi_hba *hisi_hba, u8 reg_type,
 	return 0;
 }
 
-static int wait_cmds_complete_timeout_v2_hw(struct hisi_hba *hisi_hba,
-					    int delay_ms, int timeout_ms)
+static void wait_cmds_complete_timeout_v2_hw(struct hisi_hba *hisi_hba,
+					     int delay_ms, int timeout_ms)
 {
 	struct device *dev = hisi_hba->dev;
 	int entries, entries_old = 0, time;
@@ -3513,12 +3513,13 @@ static int wait_cmds_complete_timeout_v2_hw(struct hisi_hba *hisi_hba,
 		msleep(delay_ms);
 	}
 
-	if (time >= timeout_ms)
-		return -ETIMEDOUT;
+	if (time >= timeout_ms) {
+		dev_dbg(dev, "Wait commands complete timeout!\n");
+		return;
+	}
 
 	dev_dbg(dev, "wait commands complete %dms\n", time);
 
-	return 0;
 }
 
 static struct device_attribute *host_attrs_v2_hw[] = {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 0a159df87d7b..e4db85b8af3e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2576,8 +2576,8 @@ static int write_gpio_v3_hw(struct hisi_hba *hisi_hba, u8 reg_type,
 	return 0;
 }
 
-static int wait_cmds_complete_timeout_v3_hw(struct hisi_hba *hisi_hba,
-					    int delay_ms, int timeout_ms)
+static void wait_cmds_complete_timeout_v3_hw(struct hisi_hba *hisi_hba,
+					     int delay_ms, int timeout_ms)
 {
 	struct device *dev = hisi_hba->dev;
 	int entries, entries_old = 0, time;
@@ -2591,12 +2591,12 @@ static int wait_cmds_complete_timeout_v3_hw(struct hisi_hba *hisi_hba,
 		msleep(delay_ms);
 	}
 
-	if (time >= timeout_ms)
-		return -ETIMEDOUT;
+	if (time >= timeout_ms) {
+		dev_dbg(dev, "Wait commands complete timeout!\n");
+		return;
+	}
 
 	dev_dbg(dev, "wait commands complete %dms\n", time);
-
-	return 0;
 }
 
 static ssize_t intr_conv_v3_hw_show(struct device *dev,
@@ -2877,14 +2877,11 @@ static const struct hisi_sas_debugfs_reg debugfs_ras_reg = {
 
 static void debugfs_snapshot_prepare_v3_hw(struct hisi_hba *hisi_hba)
 {
-	struct device *dev = hisi_hba->dev;
-
 	set_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
 
 	hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE, 0);
 
-	if (wait_cmds_complete_timeout_v3_hw(hisi_hba, 100, 5000) == -ETIMEDOUT)
-		dev_dbg(dev, "Wait commands complete timeout!\n");
+	wait_cmds_complete_timeout_v3_hw(hisi_hba, 100, 5000);
 
 	hisi_sas_kill_tasklets(hisi_hba);
 }
-- 
2.17.1


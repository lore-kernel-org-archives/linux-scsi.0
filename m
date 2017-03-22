From: John Garry <john.garry@huawei.com>
Subject: [PATCH 18/23] scsi: hisi_sas: rename hisi_sas_link_timeout_{enable, disable}_link
Date: Thu, 23 Mar 2017 01:25:34 +0800
Message-ID: <1490203539-228029-19-git-send-email-john.garry@huawei.com>
References: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:4369 "EHLO
        dggrg02-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1760780AbdCVQ6R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Mar 2017 12:58:17 -0400
In-Reply-To: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>

For consistency, remove the "hisi_sas_" prefix.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 45bd69d..e9c7188 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -549,7 +549,7 @@ enum {
 #define ERR_ON_RX_PHASE(err_phase) (err_phase == 0x10 || \
 		err_phase == 0x20 || err_phase == 0x40)
 
-static void hisi_sas_link_timeout_disable_link(unsigned long data);
+static void link_timeout_disable_link(unsigned long data);
 
 static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
 {
@@ -1006,7 +1006,7 @@ static void init_reg_v2_hw(struct hisi_hba *hisi_hba)
 			 upper_32_bits(hisi_hba->initial_fis_dma));
 }
 
-static void hisi_sas_link_timeout_enable_link(unsigned long data)
+static void link_timeout_enable_link(unsigned long data)
 {
 	struct hisi_hba *hisi_hba = (struct hisi_hba *)data;
 	int i, reg_val;
@@ -1020,11 +1020,11 @@ static void hisi_sas_link_timeout_enable_link(unsigned long data)
 		}
 	}
 
-	hisi_hba->timer.function = hisi_sas_link_timeout_disable_link;
+	hisi_hba->timer.function = link_timeout_disable_link;
 	mod_timer(&hisi_hba->timer, jiffies + msecs_to_jiffies(900));
 }
 
-static void hisi_sas_link_timeout_disable_link(unsigned long data)
+static void link_timeout_disable_link(unsigned long data)
 {
 	struct hisi_hba *hisi_hba = (struct hisi_hba *)data;
 	int i, reg_val;
@@ -1038,14 +1038,14 @@ static void hisi_sas_link_timeout_disable_link(unsigned long data)
 		}
 	}
 
-	hisi_hba->timer.function = hisi_sas_link_timeout_enable_link;
+	hisi_hba->timer.function = link_timeout_enable_link;
 	mod_timer(&hisi_hba->timer, jiffies + msecs_to_jiffies(100));
 }
 
 static void set_link_timer_quirk(struct hisi_hba *hisi_hba)
 {
 	hisi_hba->timer.data = (unsigned long)hisi_hba;
-	hisi_hba->timer.function = hisi_sas_link_timeout_disable_link;
+	hisi_hba->timer.function = link_timeout_disable_link;
 	hisi_hba->timer.expires = jiffies + msecs_to_jiffies(1000);
 	add_timer(&hisi_hba->timer);
 }
-- 
1.9.1

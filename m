Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 980A2C48BCD
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 09:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79023611C2
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 09:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhFGJgM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 05:36:12 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3160 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbhFGJgL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 05:36:11 -0400
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Fz7M071g1z6G7Kr;
        Mon,  7 Jun 2021 17:27:40 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 11:34:19 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 10:34:16 +0100
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 3/5] scsi: hisi_sas: Include HZ in timer macros
Date:   Mon, 7 Jun 2021 17:29:37 +0800
Message-ID: <1623058179-80434-4-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623058179-80434-1-git-send-email-john.garry@huawei.com>
References: <1623058179-80434-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

Include HZ in timer macros to make the code more concise.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  4 ++--
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 17 ++++++++++-------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  2 +-
 4 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index fbecdf756c77..8f2492d0d49e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -91,8 +91,8 @@
 
 #define HISI_SAS_PROT_MASK (HISI_SAS_DIF_PROT_MASK | HISI_SAS_DIX_PROT_MASK)
 
-#define HISI_SAS_WAIT_PHYUP_TIMEOUT 20
-#define CLEAR_ITCT_TIMEOUT	20
+#define HISI_SAS_WAIT_PHYUP_TIMEOUT	(20 * HZ)
+#define HISI_SAS_CLEAR_ITCT_TIMEOUT	(20 * HZ)
 
 struct hisi_hba;
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 856cdc1b32d5..37ccbc1103b3 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -915,7 +915,7 @@ void hisi_sas_phy_oob_ready(struct hisi_hba *hisi_hba, int phy_no)
 		if (phy->wait_phyup_cnt < HISI_SAS_WAIT_PHYUP_RETRIES) {
 			phy->wait_phyup_cnt++;
 			phy->timer.expires = jiffies +
-					     HISI_SAS_WAIT_PHYUP_TIMEOUT * HZ;
+					     HISI_SAS_WAIT_PHYUP_TIMEOUT;
 			add_timer(&phy->timer);
 		} else {
 			dev_warn(dev, "phy%d failed to come up %d times, giving up\n",
@@ -1193,9 +1193,9 @@ static void hisi_sas_tmf_timedout(struct timer_list *t)
 		complete(&task->slow_task->completion);
 }
 
-#define TASK_TIMEOUT 20
-#define TASK_RETRY 3
-#define INTERNAL_ABORT_TIMEOUT 6
+#define TASK_TIMEOUT			(20 * HZ)
+#define TASK_RETRY			3
+#define INTERNAL_ABORT_TIMEOUT		(6 * HZ)
 static int hisi_sas_exec_internal_tmf_task(struct domain_device *device,
 					   void *parameter, u32 para_len,
 					   struct hisi_sas_tmf_task *tmf)
@@ -1223,7 +1223,7 @@ static int hisi_sas_exec_internal_tmf_task(struct domain_device *device,
 		task->task_done = hisi_sas_task_done;
 
 		task->slow_task->timer.function = hisi_sas_tmf_timedout;
-		task->slow_task->timer.expires = jiffies + TASK_TIMEOUT * HZ;
+		task->slow_task->timer.expires = jiffies + TASK_TIMEOUT;
 		add_timer(&task->slow_task->timer);
 
 		res = hisi_sas_task_exec(task, GFP_KERNEL, 1, tmf);
@@ -1761,6 +1761,8 @@ static int hisi_sas_clear_aca(struct domain_device *device, u8 *lun)
 	return rc;
 }
 
+#define I_T_NEXUS_RESET_PHYUP_TIMEOUT  (2 * HZ)
+
 static int hisi_sas_debug_I_T_nexus_reset(struct domain_device *device)
 {
 	struct sas_phy *local_phy = sas_get_local_phy(device);
@@ -1795,7 +1797,8 @@ static int hisi_sas_debug_I_T_nexus_reset(struct domain_device *device)
 			sas_ha->sas_phy[local_phy->number];
 		struct hisi_sas_phy *phy =
 			container_of(sas_phy, struct hisi_sas_phy, sas_phy);
-		int ret = wait_for_completion_timeout(&phyreset, 2 * HZ);
+		int ret = wait_for_completion_timeout(&phyreset,
+						I_T_NEXUS_RESET_PHYUP_TIMEOUT);
 		unsigned long flags;
 
 		spin_lock_irqsave(&phy->lock, flags);
@@ -2079,7 +2082,7 @@ _hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 	task->task_proto = device->tproto;
 	task->task_done = hisi_sas_task_done;
 	task->slow_task->timer.function = hisi_sas_tmf_timedout;
-	task->slow_task->timer.expires = jiffies + INTERNAL_ABORT_TIMEOUT * HZ;
+	task->slow_task->timer.expires = jiffies + INTERNAL_ABORT_TIMEOUT;
 	add_timer(&task->slow_task->timer);
 
 	res = hisi_sas_internal_abort_task_exec(hisi_hba, sas_dev->device_id,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 46f60fc2a069..670013bfe333 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -994,7 +994,7 @@ static int clear_itct_v2_hw(struct hisi_hba *hisi_hba,
 		reg_val = ITCT_CLR_EN_MSK | (dev_id & ITCT_DEV_MSK);
 		hisi_sas_write32(hisi_hba, ITCT_CLR, reg_val);
 		if (!wait_for_completion_timeout(sas_dev->completion,
-						 CLEAR_ITCT_TIMEOUT * HZ)) {
+						 HISI_SAS_CLEAR_ITCT_TIMEOUT)) {
 			dev_warn(dev, "failed to clear ITCT\n");
 			return -ETIMEDOUT;
 		}
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 499c770d405c..85ced22ee6ca 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -843,7 +843,7 @@ static int clear_itct_v3_hw(struct hisi_hba *hisi_hba,
 	hisi_sas_write32(hisi_hba, ITCT_CLR, reg_val);
 
 	if (!wait_for_completion_timeout(sas_dev->completion,
-					 CLEAR_ITCT_TIMEOUT * HZ)) {
+					 HISI_SAS_CLEAR_ITCT_TIMEOUT)) {
 		dev_warn(dev, "failed to clear ITCT\n");
 		return -ETIMEDOUT;
 	}
-- 
2.26.2


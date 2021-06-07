Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC7ECC47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 09:34:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0FF3611C1
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 09:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhFGJgK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 05:36:10 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3159 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhFGJgI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 05:36:08 -0400
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Fz7Ly23vWz6G7L8;
        Mon,  7 Jun 2021 17:27:38 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 11:34:16 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 10:34:13 +0100
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 2/5] scsi: hisi_sas: Run I_T nexus resets in parallel for clear nexus reset
Date:   Mon, 7 Jun 2021 17:29:36 +0800
Message-ID: <1623058179-80434-3-git-send-email-john.garry@huawei.com>
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

For a clear nexus reset operation, the I_T nexus resets are executed
serially for each device. For devices attached through an expander, this
may take 2s per device; so, in total, could take a long time.

Reduce the total time by running the I_T nexus resets in parallel through
async operations.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c | 23 +++++++++++++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 8e36ede12cf1..fbecdf756c77 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -8,6 +8,7 @@
 #define _HISI_SAS_H_
 
 #include <linux/acpi.h>
+#include <linux/async.h>
 #include <linux/blk-mq.h>
 #include <linux/blk-mq-pci.h>
 #include <linux/clk.h>
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 50420741fc81..856cdc1b32d5 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1886,12 +1886,24 @@ static int hisi_sas_lu_reset(struct domain_device *device, u8 *lun)
 	return rc;
 }
 
+static void hisi_sas_async_I_T_nexus_reset(void *data, async_cookie_t cookie)
+{
+	struct domain_device *device = data;
+	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
+	int rc;
+
+	rc = hisi_sas_debug_I_T_nexus_reset(device);
+	if (rc != TMF_RESP_FUNC_COMPLETE)
+		dev_info(hisi_hba->dev, "I_T_nexus reset fail for dev:%016llx rc=%d\n",
+			 SAS_ADDR(device->sas_addr), rc);
+}
+
 static int hisi_sas_clear_nexus_ha(struct sas_ha_struct *sas_ha)
 {
 	struct hisi_hba *hisi_hba = sas_ha->lldd_ha;
-	struct device *dev = hisi_hba->dev;
 	HISI_SAS_DECLARE_RST_WORK_ON_STACK(r);
-	int rc, i;
+	ASYNC_DOMAIN_EXCLUSIVE(async);
+	int i;
 
 	queue_work(hisi_hba->wq, &r.work);
 	wait_for_completion(r.completion);
@@ -1906,12 +1918,11 @@ static int hisi_sas_clear_nexus_ha(struct sas_ha_struct *sas_ha)
 		    dev_is_expander(device->dev_type))
 			continue;
 
-		rc = hisi_sas_debug_I_T_nexus_reset(device);
-		if (rc != TMF_RESP_FUNC_COMPLETE)
-			dev_info(dev, "clear nexus ha: for device[%d] rc=%d\n",
-				 sas_dev->device_id, rc);
+		async_schedule_domain(hisi_sas_async_I_T_nexus_reset,
+				      device, &async);
 	}
 
+	async_synchronize_full_domain(&async);
 	hisi_sas_release_tasks(hisi_hba);
 
 	return TMF_RESP_FUNC_COMPLETE;
-- 
2.26.2


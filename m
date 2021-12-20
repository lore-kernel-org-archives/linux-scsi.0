Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C43FC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 11:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbhLTL06 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 06:26:58 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:33873 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbhLTL0v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 06:26:51 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JHcjc2lbszcc46;
        Mon, 20 Dec 2021 19:26:28 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Mon, 20 Dec 2021 19:26:49 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH v2 09/15] scsi: libsas: Resume host while sending SMP IOs
Date:   Mon, 20 Dec 2021 19:21:32 +0800
Message-ID: <1639999298-244569-10-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1639999298-244569-1-git-send-email-chenxiang66@hisilicon.com>
References: <1639999298-244569-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

When sending SMP IOs to the host we need to ensure that the host is not
suspended and may handle the commands. This is a better approach than
replying on the host to resume itself to handle such commands. So use
pm_runtime_get_sync() and pm_runtime_put_sync() calls for the host when
executing SMP IOs.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Reviewed-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/libsas/sas_expander.c | 3 +++
 drivers/scsi/libsas/sas_internal.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index c2150a818423..6abce9dfc17b 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -58,7 +58,9 @@ static int smp_execute_task_sg(struct domain_device *dev,
 	struct sas_task *task = NULL;
 	struct sas_internal *i =
 		to_sas_internal(dev->port->ha->core.shost->transportt);
+	struct sas_ha_struct *ha = dev->port->ha;
 
+	pm_runtime_get_sync(ha->dev);
 	mutex_lock(&dev->ex_dev.cmd_mutex);
 	for (retry = 0; retry < 3; retry++) {
 		if (test_bit(SAS_DEV_GONE, &dev->state)) {
@@ -131,6 +133,7 @@ static int smp_execute_task_sg(struct domain_device *dev,
 		}
 	}
 	mutex_unlock(&dev->ex_dev.cmd_mutex);
+	pm_runtime_put_sync(ha->dev);
 
 	BUG_ON(retry == 3 && task != NULL);
 	sas_free_task(task);
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index d7a1fb5c10c6..ad9764a976c3 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -14,6 +14,7 @@
 #include <scsi/scsi_transport_sas.h>
 #include <scsi/libsas.h>
 #include <scsi/sas_ata.h>
+#include <linux/pm_runtime.h>
 
 #ifdef pr_fmt
 #undef pr_fmt
-- 
2.33.0


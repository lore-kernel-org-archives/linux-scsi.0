Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98DB1C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 11:27:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhLTL1B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 06:27:01 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:30143 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbhLTL0v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 06:26:51 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4JHcgM6Ygpz8vyg;
        Mon, 20 Dec 2021 19:24:31 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Mon, 20 Dec 2021 19:26:50 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH v2 11/15] scsi: libsas: Refactor sas_queue_deferred_work()
Date:   Mon, 20 Dec 2021 19:21:34 +0800
Message-ID: <1639999298-244569-12-git-send-email-chenxiang66@hisilicon.com>
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

In the second part of function __sas_drain_work(), it queues deferred work.
This functionality would be duplicated in other places, so refactor out
into sas_queue_deferred_work().

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Reviewed-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/libsas/sas_event.c    | 25 ++++++++++++++-----------
 drivers/scsi/libsas/sas_internal.h |  1 +
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index af605620ea13..01e544ca518a 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -41,12 +41,23 @@ static int sas_queue_event(int event, struct sas_work *work,
 	return rc;
 }
 
-
-void __sas_drain_work(struct sas_ha_struct *ha)
+void sas_queue_deferred_work(struct sas_ha_struct *ha)
 {
 	struct sas_work *sw, *_sw;
 	int ret;
 
+	spin_lock_irq(&ha->lock);
+	list_for_each_entry_safe(sw, _sw, &ha->defer_q, drain_node) {
+		list_del_init(&sw->drain_node);
+		ret = sas_queue_work(ha, sw);
+		if (ret != 1)
+			sas_free_event(to_asd_sas_event(&sw->work));
+	}
+	spin_unlock_irq(&ha->lock);
+}
+
+void __sas_drain_work(struct sas_ha_struct *ha)
+{
 	set_bit(SAS_HA_DRAINING, &ha->state);
 	/* flush submitters */
 	spin_lock_irq(&ha->lock);
@@ -55,16 +66,8 @@ void __sas_drain_work(struct sas_ha_struct *ha)
 	drain_workqueue(ha->event_q);
 	drain_workqueue(ha->disco_q);
 
-	spin_lock_irq(&ha->lock);
 	clear_bit(SAS_HA_DRAINING, &ha->state);
-	list_for_each_entry_safe(sw, _sw, &ha->defer_q, drain_node) {
-		list_del_init(&sw->drain_node);
-		ret = sas_queue_work(ha, sw);
-		if (ret != 1)
-			sas_free_event(to_asd_sas_event(&sw->work));
-
-	}
-	spin_unlock_irq(&ha->lock);
+	sas_queue_deferred_work(ha);
 }
 
 int sas_drain_work(struct sas_ha_struct *ha)
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index ad9764a976c3..acd515c01861 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -57,6 +57,7 @@ void sas_unregister_ports(struct sas_ha_struct *sas_ha);
 
 void sas_disable_revalidation(struct sas_ha_struct *ha);
 void sas_enable_revalidation(struct sas_ha_struct *ha);
+void sas_queue_deferred_work(struct sas_ha_struct *ha);
 void __sas_drain_work(struct sas_ha_struct *ha);
 
 void sas_deform_port(struct asd_sas_phy *phy, int gone);
-- 
2.33.0


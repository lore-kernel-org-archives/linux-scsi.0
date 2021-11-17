Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81917C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 02:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ADBC61C12
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 02:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbhKQCxV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 21:53:21 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:15832 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232716AbhKQCxL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 21:53:11 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Hv6pl1t78z915N;
        Wed, 17 Nov 2021 10:49:51 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Wed, 17 Nov 2021 10:50:11 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 14/15] scsi: libsas: Keep sas host active until finished some work
Date:   Wed, 17 Nov 2021 10:45:07 +0800
Message-ID: <1637117108-230103-15-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

For those works from event queue, if executing them such as
PORTE_BROADCAST_RCVD when sas host is suspended, it will resume sas host
firstly as SMP IOs are sent in the process. So phyup will occur and it
will call work PORTE_BYTES_DMAED. But the original work (such as
PORTE_BROADCAST_RCVD) and the work PORTE_BYTES_DMAED are in the same
singlethread workqueue, so the complete of original work waits for
the complete of work PORTE_BYTES_DMAED while the complete of work
PORTE_BYTES_DMAED wait for the complete of original and it is blocked.

So call pm_runtime_get_noresume() to keep sas host active until
finished those works.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Reviewed-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/libsas/sas_event.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index 626ef96b9348..3613b9b315bc 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -50,8 +50,10 @@ void sas_queue_deferred_work(struct sas_ha_struct *ha)
 	list_for_each_entry_safe(sw, _sw, &ha->defer_q, drain_node) {
 		list_del_init(&sw->drain_node);
 		ret = sas_queue_work(ha, sw);
-		if (ret != 1)
+		if (ret != 1) {
+			pm_runtime_put(ha->dev);
 			sas_free_event(to_asd_sas_event(&sw->work));
+		}
 	}
 	spin_unlock_irq(&ha->lock);
 }
@@ -126,16 +128,22 @@ void sas_enable_revalidation(struct sas_ha_struct *ha)
 static void sas_port_event_worker(struct work_struct *work)
 {
 	struct asd_sas_event *ev = to_asd_sas_event(work);
+	struct asd_sas_phy *phy = ev->phy;
+	struct sas_ha_struct *ha = phy->ha;
 
 	sas_port_event_fns[ev->event](work);
+	pm_runtime_put(ha->dev);
 	sas_free_event(ev);
 }
 
 static void sas_phy_event_worker(struct work_struct *work)
 {
 	struct asd_sas_event *ev = to_asd_sas_event(work);
+	struct asd_sas_phy *phy = ev->phy;
+	struct sas_ha_struct *ha = phy->ha;
 
 	sas_phy_event_fns[ev->event](work);
+	pm_runtime_put(ha->dev);
 	sas_free_event(ev);
 }
 
@@ -170,14 +178,19 @@ int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event,
 	if (!ev)
 		return -ENOMEM;
 
+	/* Call pm_runtime_put() with pairs in sas_port_event_worker() */
+	pm_runtime_get_noresume(ha->dev);
+
 	INIT_SAS_EVENT(ev, sas_port_event_worker, phy, event);
 
 	if (sas_defer_event(phy, ev))
 		return 0;
 
 	ret = sas_queue_event(event, &ev->work, ha);
-	if (ret != 1)
+	if (ret != 1) {
+		pm_runtime_put(ha->dev);
 		sas_free_event(ev);
+	}
 
 	return ret;
 }
@@ -196,14 +209,19 @@ int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event,
 	if (!ev)
 		return -ENOMEM;
 
+	/* Call pm_runtime_put() with pairs in sas_phy_event_worker() */
+	pm_runtime_get_noresume(ha->dev);
+
 	INIT_SAS_EVENT(ev, sas_phy_event_worker, phy, event);
 
 	if (sas_defer_event(phy, ev))
 		return 0;
 
 	ret = sas_queue_event(event, &ev->work, ha);
-	if (ret != 1)
+	if (ret != 1) {
+		pm_runtime_put(ha->dev);
 		sas_free_event(ev);
+	}
 
 	return ret;
 }
-- 
2.33.0


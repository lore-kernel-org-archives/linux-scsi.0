Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D51C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 11:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbhLTL1E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 06:27:04 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:15946 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbhLTL0w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 06:26:52 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JHcfS2jdKzZdkQ;
        Mon, 20 Dec 2021 19:23:44 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Mon, 20 Dec 2021 19:26:50 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH v2 14/15] scsi: libsas: Keep host active while processing events
Date:   Mon, 20 Dec 2021 19:21:37 +0800
Message-ID: <1639999298-244569-15-git-send-email-chenxiang66@hisilicon.com>
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

Processing events such as PORTE_BROADCAST_RCVD may cause dependency issues
for runtime power management support.
Such a problem would be that handling a PORTE_BROADCAST_RCVD event requires
that the host is resumed to send SMP commands. However, in resuming the
host, the phyup events generated from re-enabling the phys are processed in
the same workqueue as the original PORTE_BROADCAST_RCVD event. As such, the
host will never finish resuming (as it waits for the phyup event 
processing), and then the PORTE_BROADCAST_RCVD event can't be processed 
as the SMP commands are blocked, and so we have a deadlock.
Solve this problem by ensuring that libsas keeps the host active until
completely finished phy or port events, such as PORTE_BYTES_DMAED. As such,
we don't have to worry about resuming the host for processing individual
SMP commands in this example.

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


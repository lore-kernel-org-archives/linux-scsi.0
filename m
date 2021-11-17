Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F1D9C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 02:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84517613DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 02:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbhKQCxL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 21:53:11 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:15828 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232649AbhKQCxJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 21:53:09 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Hv6pj1CTYz9155;
        Wed, 17 Nov 2021 10:49:49 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Wed, 17 Nov 2021 10:50:09 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>
Subject: [PATCH 01/15] libsas: Don't always drain event workqueue for HA resume
Date:   Wed, 17 Nov 2021 10:44:54 +0800
Message-ID: <1637117108-230103-2-git-send-email-chenxiang66@hisilicon.com>
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

From: John Garry <john.garry@huawei.com>

For the hisi_sas driver, if a directly attached disk is removed during
suspend, a hang will occur in the resume process:

The background is that in commit 16fd4a7c5917 ("scsi: hisi_sas: Add device
link between SCSI devices and hisi_hba"), it is ensured that the HBA
device cannot be runtime suspended when any SCSI device associated is
active.

Other drivers which use libsas don't worry about this as none support
runtime suspend.

The mentioned hang occurs when an disk is removed during suspend. In the
removal process - from PHYE_RESUME_TIMEOUT event processing - we call into
scsi_remove_device(), which is being processed in the HA event workqueue.
Here we wait for all suppliers of the SCSI device to resume, which
includes the HBA device (from the above commit). However the HBA device
cannot resume, as it is waiting for the PHYE_RESUME_TIMEOUT to be processed
(from calling sas_resume_ha() -> sas_drain_work()). This is the deadlock.

There does not appear to be any need for the sas_drain_work() to be called
at all in sas_resume_ha() as it is not syncing against anything, so allow
LLDDs to avoid this by providing a variant of sas_resume_ha() which does
"sync", i.e. doesn't drain the event workqueue.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 10 +++++++++-
 drivers/scsi/libsas/sas_init.c         | 17 +++++++++++++++--
 include/scsi/libsas.h                  |  1 +
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 9ae47d1d9897..5a83373ac0b1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4942,7 +4942,15 @@ static int _resume_v3_hw(struct device *device)
 		return rc;
 	}
 	phys_init_v3_hw(hisi_hba);
-	sas_resume_ha(sha);
+
+	/*
+	 * If a directly-attached disk is removed during suspend, a deadlock
+	 * may occur, as the PHYE_RESUME_TIMEOUT processing will require the
+	 * hisi_hba->device to be active, which can only happen when resume
+	 * completes. So don't wait for the HA event workqueue to drain upon
+	 * resume.
+	 */
+	sas_resume_ha_no_sync(sha);
 	clear_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);
 
 	return 0;
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index b640e09af6a4..43509d139241 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -387,7 +387,7 @@ static int phys_suspended(struct sas_ha_struct *ha)
 	return rc;
 }
 
-void sas_resume_ha(struct sas_ha_struct *ha)
+static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
 {
 	const unsigned long tmo = msecs_to_jiffies(25000);
 	int i;
@@ -417,10 +417,23 @@ void sas_resume_ha(struct sas_ha_struct *ha)
 	 * flush out disks that did not return
 	 */
 	scsi_unblock_requests(ha->core.shost);
-	sas_drain_work(ha);
+	if (drain)
+		sas_drain_work(ha);
+}
+
+void sas_resume_ha(struct sas_ha_struct *ha)
+{
+	_sas_resume_ha(ha, true);
 }
 EXPORT_SYMBOL(sas_resume_ha);
 
+/* A no-sync variant, which does not call sas_drain_ha(). */
+void sas_resume_ha_no_sync(struct sas_ha_struct *ha)
+{
+	_sas_resume_ha(ha, false);
+}
+EXPORT_SYMBOL(sas_resume_ha_no_sync);
+
 void sas_suspend_ha(struct sas_ha_struct *ha)
 {
 	int i;
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 79e4903bd414..a795a2d9e5b1 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -660,6 +660,7 @@ extern int sas_register_ha(struct sas_ha_struct *);
 extern int sas_unregister_ha(struct sas_ha_struct *);
 extern void sas_prep_resume_ha(struct sas_ha_struct *sas_ha);
 extern void sas_resume_ha(struct sas_ha_struct *sas_ha);
+extern void sas_resume_ha_no_sync(struct sas_ha_struct *sas_ha);
 extern void sas_suspend_ha(struct sas_ha_struct *sas_ha);
 
 int sas_set_phy_speed(struct sas_phy *phy, struct sas_phy_linkrates *rates);
-- 
2.33.0


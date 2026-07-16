Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076AB2DC79B;
	Thu, 16 Jul 2026 08:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784189516; cv=none; b=Y2JAfxKZh02O3GfSVCwp9VEw8yKQUpCE0m0fZnhKjnjgBwa4EykpqABlEsOWrYba21YK6Z5FEY8x2Mq5Cawp6ybyXW1o/4fKOfr2oENwdoVMN64ptfCFOTCk7fyMLjFcXg7pDw7DImdk/VpvEiNuOmvop2ksZaSmom8YYvex+zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784189516; c=relaxed/simple;
	bh=IOiAHp1B01s47N8W5r+sFfWF7H3oA3vjMfnloWMwTmM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aXOZq08p7Tl627pDjpWkQyO23IBeOHvS+V+U78haUPaNm7fYXgZWVyqY+eq/tCVPPM3BRssL63WE4hXe4T919Da91KZsYsv5F9c9g8RtjFcBFDh8oiwXk2q0iaSt9lMqD++EFmvWjdwVvXBUDrwwYeetNC440u7aznZIisJWIAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=lCvUlyov; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="lCvUlyov"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=6TB6mMOFB6oZwWL6BKoW0v0I1AAm+I6WU8sQ0ZySRV0=;
	b=lCvUlyovwPEL+dyzzkwTbKj2L2Hdfsdo9lomEeg4ReT85XXSLb9bHYlR6ZUqoDO5HD3XEZCCP
	d4Gq15GjamhVlgY3UAhA6b3Ttl+V1BvTkX8v90lIYI2f0Gza170ed4iIzvuwu0FDrOkcgP/BZBd
	C7PphstLLCWet4l8BALw8YM=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4h159c5l76z12LGl;
	Thu, 16 Jul 2026 16:02:12 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 0E6CD40537;
	Thu, 16 Jul 2026 16:11:50 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 16 Jul 2026 16:11:49 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <yangxingui@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
Subject: [PATCH v3] scsi: libsas: fix HA resume deadlock and hisi_sas disk-wake race
Date: Thu, 16 Jul 2026 16:11:45 +0800
Message-ID: <20260716081145.3950172-1-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemj100018.china.huawei.com (7.202.194.12)

Commit fbefe22811c3140 ("scsi: libsas: Don't always drain event workqueue
for HA resume") introduced sas_resume_ha_no_sync() to avoid a deadlock:
the PHYE_RESUME_TIMEOUT handler, running on the HA event workqueue, calls
sas_deform_port() -> sas_destruct_devices(), which removes SCSI devices and
waits for the host to become runtime-active. But the host cannot resume
until sas_resume_ha() -> sas_drain_work() returns, and the drain is blocked
on that very handler.

However skipping the drain reintroduces a race: hisi_sas returns from
resume before all PHY UP work and libsas discovery work finish. The
controller may then autosuspend while disks are still waking up. The disks
issue IO to a suspended controller, the IO fails, and the disks get
disabled.

Fix the deadlock at its source by moving the PHYE_RESUME_TIMEOUT
notification to after sas_drain_work(). By then the host resume is about to
complete, so device removal through device_link no longer blocks on the
resume and the cycle is broken.

With the deadlock gone, restore sas_resume_ha() (the draining variant) in
hisi_sas and remove sas_resume_ha_no_sync().

The reorder is safe for the other libsas consumers (isci, pm8001, aic94xx,
mvsas). During suspend, sas_suspend_devices() calls
sas_notify_lldd_dev_gone() for each device, which sets dev->lldd_dev to
NULL. When scsi_unblock_requests re-enables I/O in resume, any I/O to a
timed-out phy's disk is immediately rejected by the LLDD before reaching
hardware: isci returns SAS_DEVICE_UNKNOWN (mapped to DID_BAD_TARGET), and
pm8001 returns SAS_PHY_DOWN (mapped to DID_NO_CONNECT). Both complete
directly via scsi_done() without entering SCSI EH. This is identical in
both the old and new ordering since lldd_dev_gone runs during suspend,
before resume. The reorder only affects when the PHYE_RESUME_TIMEOUT
handler runs (synchronized by sas_drain_work() vs. asynchronous after
resume returns), not whether I/O can reach the device. aic94xx and mvsas
do not register any PM ops and never reach this code path.

Fixes: fbefe22811c3140 ("scsi: libsas: Don't always drain event workqueue for HA resume")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
Changes since v2:
- Fix comment formatting: proper multi-line style, capitalize, add periods
  (feedback from John Garry).
- Fold _sas_resume_ha() into sas_resume_ha() since the wrapper is now
  redundant (feedback from John Garry).
- Expand commit message with analysis of why the reorder is safe for
  other libsas consumers (feedback from John Garry).
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 10 +------
 drivers/scsi/libsas/sas_init.c         | 37 +++++++++++++-------------
 include/scsi/libsas.h                  |  1 -
 3 files changed, 19 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 213d5b5dea94..8a2500993e19 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -5261,15 +5261,7 @@ static int _resume_v3_hw(struct device *device)
 		return rc;
 	}
 	phys_init_v3_hw(hisi_hba);
-
-	/*
-	 * If a directly-attached disk is removed during suspend, a deadlock
-	 * may occur, as the PHYE_RESUME_TIMEOUT processing will require the
-	 * hisi_hba->device to be active, which can only happen when resume
-	 * completes. So don't wait for the HA event workqueue to drain upon
-	 * resume.
-	 */
-	sas_resume_ha_no_sync(sha);
+	sas_resume_ha(sha);
 	clear_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);
 
 	dev_warn(dev, "end of resuming controller\n");
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 0bec236f0fb5..c3f3d05b46de 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -410,7 +410,7 @@ static void sas_resume_insert_broadcast_ha(struct sas_ha_struct *ha)
 	}
 }
 
-static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
+void sas_resume_ha(struct sas_ha_struct *ha)
 {
 	const unsigned long tmo = msecs_to_jiffies(25000);
 	int i;
@@ -426,6 +426,23 @@ static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
 		dev_info(ha->dev, "waiting up to 25 seconds for %d phy%s to resume\n",
 			 i, i > 1 ? "s" : "");
 	wait_event_timeout(ha->eh_wait_q, phys_suspended(ha) == 0, tmo);
+
+	/*
+	 * All phys are back up or timed out. Turn on I/O and drain
+	 * pending work.
+	 */
+	scsi_unblock_requests(ha->shost);
+	sas_drain_work(ha);
+
+	/*
+	 * Send PHYE_RESUME_TIMEOUT after sas_drain_work(). The handler
+	 * calls sas_deform_port() -> sas_destruct_devices(), which removes
+	 * SCSI devices and, for LLDDs using device_link() PM sync, waits
+	 * for the host to be runtime-active. Sending it before the drain
+	 * would deadlock: the drain waits for the handler, the handler
+	 * waits for host resume, and host resume waits for the drain to
+	 * finish.
+	 */
 	for (i = 0; i < ha->num_phys; i++) {
 		struct asd_sas_phy *phy = ha->sas_phy[i];
 
@@ -436,12 +453,6 @@ static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
 		}
 	}
 
-	/* all phys are back up or timed out, turn on i/o so we can
-	 * flush out disks that did not return
-	 */
-	scsi_unblock_requests(ha->shost);
-	if (drain)
-		sas_drain_work(ha);
 	clear_bit(SAS_HA_RESUMING, &ha->state);
 
 	sas_queue_deferred_work(ha);
@@ -450,20 +461,8 @@ static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
 	 */
 	sas_resume_insert_broadcast_ha(ha);
 }
-
-void sas_resume_ha(struct sas_ha_struct *ha)
-{
-	_sas_resume_ha(ha, true);
-}
 EXPORT_SYMBOL(sas_resume_ha);
 
-/* A no-sync variant, which does not call sas_drain_ha(). */
-void sas_resume_ha_no_sync(struct sas_ha_struct *ha)
-{
-	_sas_resume_ha(ha, false);
-}
-EXPORT_SYMBOL(sas_resume_ha_no_sync);
-
 void sas_suspend_ha(struct sas_ha_struct *ha)
 {
 	int i;
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 163f23c92b41..36d4cb567837 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -680,7 +680,6 @@ extern int sas_register_ha(struct sas_ha_struct *);
 extern int sas_unregister_ha(struct sas_ha_struct *);
 extern void sas_prep_resume_ha(struct sas_ha_struct *sas_ha);
 extern void sas_resume_ha(struct sas_ha_struct *sas_ha);
-extern void sas_resume_ha_no_sync(struct sas_ha_struct *sas_ha);
 extern void sas_suspend_ha(struct sas_ha_struct *sas_ha);
 
 int sas_phy_reset(struct sas_phy *phy, int hard_reset);
-- 
2.43.0


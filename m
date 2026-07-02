Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B28305670;
	Thu,  2 Jul 2026 03:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782963157; cv=none; b=h97JshjJFS1bOxjAPZv+5SdudaDFc7nsVy4zLqZZ4mkPyYY+/6qx+ds+dHmrcazEL+wgXvOwuvCDVTifBwwmR57M/OBC63kOgZf/Q6Le4XEmFrHqerFMYYwTekvsLJmvICMLme2P64cRbuFZ072p3vINqiZnZc+Wo5Hp0BiNZEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782963157; c=relaxed/simple;
	bh=KaZ0N2jms9SXwiPTloY6bTscFQeJJN8gi3RHO4xvfwA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ABJ1qZt2YG1yMwqf5gEj2RO4EGNY71OjkBN4HRBnEeUrmJl0gDQtxbLNTKKn/VxJaJPAUyPC+NALE5LD3TeawfK/+U0wdbi1JzCeI7UlXyrHvXEIG3/RnzqdnXnZAlEfvlEHkI3oJv6yicztXvQ/I6ZblpJ+TYPTYE/ndww6eHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=kWAYo1+e; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="kWAYo1+e"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=o3GpnPOpIBlEdsiauRU8gf3kGeoKu3JcXBhebkY17qk=;
	b=kWAYo1+ePjBQMtPesdeiHBqPefcCfZohNQwi3A8orev6kXWhx2Dxd6j9j2n/9Stzx279E9VpN
	bj++uv7ZFV7AhayELSjNgxce124HkFQqauxMbv/RJ6bECvMGvvLOCbbMcxbEAclQhdSu3hXKgK4
	kS+bu9d8wOp8LiTY45dP/Sg=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4grMfm4ZFFznTVw;
	Thu,  2 Jul 2026 11:23:44 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 321DD4057A;
	Thu,  2 Jul 2026 11:32:24 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 2 Jul 2026 11:32:23 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <yangxingui@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
Subject: [PATCH v2] scsi: libsas: fix HA resume deadlock and hisi_sas disk-wake race
Date: Thu, 2 Jul 2026 11:32:11 +0800
Message-ID: <20260702033211.1743313-1-yangxingui@huawei.com>
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
for HA resume") introduced sas_resume_ha_no_sync() to avoid a deadlock: the
PHYE_RESUME_TIMEOUT handler, running on the HA event workqueue, calls
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

Fixes: fbefe22811c3140 ("scsi: libsas: Don't always drain event workqueue for HA resume")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  9 +-------
 drivers/scsi/libsas/sas_init.c         | 32 ++++++++++++++------------
 include/scsi/libsas.h                  |  1 -
 3 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 0687bdefcd63..c8673ae4e472 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -5263,14 +5263,7 @@ static int _resume_v3_hw(struct device *device)
 	}
 	phys_init_v3_hw(hisi_hba);
 
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
index 0bec236f0fb5..624850f1483d 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -410,7 +410,7 @@ static void sas_resume_insert_broadcast_ha(struct sas_ha_struct *ha)
 	}
 }
 
-static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
+static void _sas_resume_ha(struct sas_ha_struct *ha)
 {
 	const unsigned long tmo = msecs_to_jiffies(25000);
 	int i;
@@ -426,6 +426,21 @@ static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
 		dev_info(ha->dev, "waiting up to 25 seconds for %d phy%s to resume\n",
 			 i, i > 1 ? "s" : "");
 	wait_event_timeout(ha->eh_wait_q, phys_suspended(ha) == 0, tmo);
+
+	/* all phys are back up or timed out, turn on i/o so we can
+	 * flush out disks that did not return
+	 */
+	scsi_unblock_requests(ha->shost);
+	sas_drain_work(ha);
+
+	/* Send PHYE_RESUME_TIMEOUT after sas_drain_work(). The handler
+	 * calls sas_deform_port() -> sas_destruct_devices(), which removes
+	 * SCSI devices and, for LLDDs using device_link() PM sync, waits
+	 * for the host to be runtime-active. Sending it before the drain
+	 * would deadlock: the drain waits for the handler, the handler
+	 * waits for host resume, and host resume waits for the drain to
+	 * finish.
+	 */
 	for (i = 0; i < ha->num_phys; i++) {
 		struct asd_sas_phy *phy = ha->sas_phy[i];
 
@@ -436,12 +451,6 @@ static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
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
@@ -453,17 +462,10 @@ static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
 
 void sas_resume_ha(struct sas_ha_struct *ha)
 {
-	_sas_resume_ha(ha, true);
+	_sas_resume_ha(ha);
 }
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


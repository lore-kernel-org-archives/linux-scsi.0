Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A6B2882D7;
	Tue, 30 Jun 2026 06:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782802479; cv=none; b=IiBAkqO4lc/XVdx0aql9EKZKZGcVwnu1p5/EhRDg5qix0lufRMGXEVevbklSR+yzwDRstk1N7c31UAPXn0yD72l3OZI7iSl6ZiXXiOwOVCreZYGKltYOxaYx8DxJ/HMRHX5gP+Rbm5j2wg2ZoaspG0xrOtEGVkxxeP48hKCxpjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782802479; c=relaxed/simple;
	bh=BlR32P5xMTF9t8lwgP3sTijibVk3k1z2eedpeuT9Oow=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dlL227SRZQA5pdzr93jJ6LiFD1Avk7yEkNF6tkdwClTnz8C9Gr1ku4LHsz8SIvVgjojL/WSA0ygjmNJU8GkqsUYcF4SeJNWjmUBpFbNrpKHRXWrsdce75NSxsSFLCvxlPb5QzXLi2LCHt3ZEbh9FPrwsQIuPFHUG/HKlrVAaOrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=hvUtGZAM; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="hvUtGZAM"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=rrutzCx6fsukODFoYg8Uy/+C6Ihv7Yo5LP7iCWhVRQI=;
	b=hvUtGZAMbW/aXfc2NxTVmUwCVg8Ul+HR8WS2cFzQ7nEqA7BMXksjDewI4+a37WihZr1mmxbQ/
	/beC4h0coORh5+P6fldlO4ky56gVjjB5Bhk6oGYWKj5w9AP4GFVPUXEekveXrlu3viV9Q013e9Z
	GJetx3+7Z8zoZe8SEGFS/4w=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4gqDDC4hXjz1prKy;
	Tue, 30 Jun 2026 14:45:15 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id A0EB640537;
	Tue, 30 Jun 2026 14:54:26 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 30 Jun 2026 14:54:26 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <yangxingui@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
Subject: [PATCH] scsi: libsas: fix HA resume deadlock and hisi_sas disk-wake race
Date: Tue, 30 Jun 2026 14:51:57 +0800
Message-ID: <20260630065157.421203-1-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemj100018.china.huawei.com (7.202.194.12)

Commit fbefe22811c3140 ("scsi: libsas: Don't always drain event
workqueue for HA resume") introduced sas_resume_ha_no_sync() to avoid a
deadlock: the PHYE_RESUME_TIMEOUT handler, running on the HA event
workqueue, calls sas_deform_port() -> sas_destruct_devices(), which
removes SCSI devices and waits for the host to become runtime-active
through the device_link established by hisi_sas. But the host cannot
resume until sas_resume_ha() -> sas_drain_work() returns, and the drain
is blocked on that very handler.

However skipping the drain reintroduces a race: hisi_sas returns from
resume before all PHY UP work and libsas discovery work finish. The
controller may then autosuspend while disks are still waking up. The
disks issue IO to a suspended controller, the IO fails, and the disks
get disabled.

Fix the deadlock at its source by moving the PHYE_RESUME_TIMEOUT
notification to after sas_drain_work(). By then the host resume is
about to complete, so device removal through device_link no longer
blocks on the resume and the cycle is broken.

With the deadlock gone, restore sas_resume_ha() (the draining variant)
in hisi_sas and remove sas_resume_ha_no_sync().

Additionally flush the hisi_sas private workqueue after sas_resume_ha().
sas_drain_work() only drains the libsas event and discovery workqueues;
it cannot wait for hisi_sas_phyup_pm_work(), which runs on the driver's
own workqueue and holds a runtime PM reference taken in the phy_up ISR.
Without this flush, the controller may autosuspend before all phyup PM
works complete.

Fixes: fbefe22811c3140 ("scsi: libsas: Don't always drain event workqueue for HA resume")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 10 ++-------
 drivers/scsi/libsas/sas_init.c         | 29 +++++++++++++-------------
 include/scsi/libsas.h                  |  1 -
 3 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 213d5b5dea94..901f508e8be7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -5262,14 +5262,8 @@ static int _resume_v3_hw(struct device *device)
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
+	flush_workqueue(hisi_hba->wq);
 	clear_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);
 
 	dev_warn(dev, "end of resuming controller\n");
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 0bec236f0fb5..61348d4167b4 100644
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
@@ -426,6 +426,18 @@ static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
 		dev_info(ha->dev, "waiting up to 25 seconds for %d phy%s to resume\n",
 			 i, i > 1 ? "s" : "");
 	wait_event_timeout(ha->eh_wait_q, phys_suspended(ha) == 0, tmo);
+
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
 
@@ -436,12 +448,6 @@ static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
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
@@ -453,17 +459,10 @@ static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
 
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


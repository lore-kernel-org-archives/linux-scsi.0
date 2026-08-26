Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4193112BD;
	Wed, 26 Aug 2026 03:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787714934; cv=none; b=r7WBFudcViOFp0pCPfUGcUveF589Bz1Tbx9FRrfZ1HRAMgZY7XoNtMsEoPfJ8n3G4aF5+rscun2Vkj5B6Pj/rp6jKOqiWp+diXT9LfdIFvJSr2Z8zjuKVRFB+7M93ydcm3MsOMXV9o232/5/QB5x/AXXkIuLapbB8+Eh66gBmOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787714934; c=relaxed/simple;
	bh=DthfDNhoV1XNJsV+1yH2/m1B+rdlEdq3+ZvznYtLAv4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=e1noGHP0kn9TpjQdACjIMWkiYe3fw8XkVOAMkoItwcYrTuIFB4dIldS4bPkbhHDGV/WovF0jrgXDRF5ZDS4GThbVxrnydtlWSYN7nVyXSEDK60zw6XsP+QOOfQ/OKkUsTv+IF/oPDjfHftExKSN5uprH4aQ93hVrTAFnuZeAuzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=gY75Mhjv; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="gY75Mhjv"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=tdGPxB0y0XRY73OfcAYt8lQ0bNMrdjCTEoyOt8zPMto=;
	b=gY75MhjvMYL2ObsjpBi1LCwSxGZPjzD8jnmkYFobVigzwDwhtPuPfV5VRcyRwC5clcoq9vGJ1
	RFxOzuy+Z0Z0eqDOgnmqqt1vU3ETuY18c0R9p7VGZkdDVGq6O2EwED2x/1Wxod5g0k5A2sU0X3X
	7JtED+4R50/ISm26Uc5am5o=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hV8wm5FsLz1K96b;
	Wed, 26 Aug 2026 11:18:00 +0800 (CST)
Received: from kwepemp200011.china.huawei.com (unknown [7.202.194.174])
	by mail.maildlp.com (Postfix) with ESMTPS id 5B31A4055B;
	Wed, 26 Aug 2026 11:28:46 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp200011.china.huawei.com (7.202.194.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 26 Aug 2026 11:28:46 +0800
Received: from localhost.localdomain (10.50.163.32) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 26 Aug 2026 11:28:45 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <yangxingui@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
Subject: [PATCH] scsi: libsas: Fix SMP IO deadlock during HA resume
Date: Wed, 26 Aug 2026 11:28:45 +0800
Message-ID: <20260826032845.1632348-1-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemp500015.china.huawei.com (7.202.195.9)

During sas_resume_ha() -> sas_drain_work(), ATA EH will trigger SMP IOs via
sas_phy_reset() -> sas_smp_phy_control() for expander-attached ATA devices.
Since ha->dev is RPM_RESUMING at that point, pm_runtime_get_sync() blocks
waiting for the resume to finish, but the resume is blocked in
sas_drain_work() waiting for the SMP IO — a deadlock.

Skip the PM get/put when SAS_HA_RESUMING is set. The hardware is already
initialized by the LLDD resume callback before sas_resume_ha() runs, so no
explicit resume is needed.

Only hisi_sas enables runtime PM among libsas LLDDs, so other drivers
(pm8001, isci, aic94xx, mvsas) are unaffected.

Fixes: 0da7ca4c4fd9 ("scsi: libsas: Resume host while sending SMP I/Os")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/libsas/sas_expander.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 811c9eb4fef1..77ae2ae7b2c4 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -61,8 +61,17 @@ static int smp_execute_task_sg(struct domain_device *dev,
 	struct sas_internal *i =
 		to_sas_internal(dev->port->ha->shost->transportt);
 	struct sas_ha_struct *ha = dev->port->ha;
-
-	pm_runtime_get_sync(ha->dev);
+	bool skip_pm = test_bit(SAS_HA_RESUMING, &ha->state);
+
+	/*
+	 * Skip PM get/put during HA resume to avoid deadlock: the host is
+	 * RPM_RESUMING and the drain waits for this SMP IO to finish, but
+	 * pm_runtime_get_sync() would block on RPM_RESUMING. Safe because
+	 * hardware is already initialized by the LLDD before call
+	 * sas_resume_ha().
+	 */
+	if (!skip_pm)
+		pm_runtime_get_sync(ha->dev);
 	mutex_lock(&dev->ex_dev.cmd_mutex);
 	for (retry = 0; retry < 3; retry++) {
 		if (test_bit(SAS_DEV_GONE, &dev->state)) {
@@ -135,7 +144,8 @@ static int smp_execute_task_sg(struct domain_device *dev,
 		}
 	}
 	mutex_unlock(&dev->ex_dev.cmd_mutex);
-	pm_runtime_put_sync(ha->dev);
+	if (!skip_pm)
+		pm_runtime_put_sync(ha->dev);
 
 	BUG_ON(retry == 3 && task != NULL);
 	sas_free_task(task);
-- 
2.43.0


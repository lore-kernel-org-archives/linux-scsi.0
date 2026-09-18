Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7FD31E857;
	Fri, 18 Sep 2026 07:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789715001; cv=none; b=mUL+U0BCavimihbinuJgX8UUTppY3cVmPL9Ln9nEZ5cythvKOfaWksRf9HCL54C/m5utUHbgsvq/jPY5zVuJL7iU5FU60HCootDRoQK7B46lNSd3Wodpogfw9D0gUz3cL/5KXc8AWvBkySwkqcq7ayY4NjQMVMsHxNVehG0PVU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789715001; c=relaxed/simple;
	bh=2LOaQR4JlbZn7aLRdToMdL5mIjIcL/5xMPl+nMEXaXI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MFRnMGXbBLGSz/6bIy8VVpmXDy+G+lqagcD7dnEOvA+YWQHxFfykeuVy88W7BemXpmJvVXOQsw667SG0wF7zg/WgE1p43NNug6afIntYYpz451WSrWFetdG9pY9uAEak1njtzN5zNAuLvS8Q/nIxhwsCm7OwMIAqdiHFk0MEJ7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=p2aFhi4g; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="p2aFhi4g"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=N1GcyRNtHdRTu5TiGzPOCZQaPlbdEFhtfkpRCs5i7/M=;
	b=p2aFhi4ggavAOZ3bqL0jkYt1kQya1PvPUQsCTbO1Y0P115gA1rnq9zLZV9HcsPj2r3DaSlaTz
	rdOHZlWHTeAMUELlg8cCe5GIPdHDulMVQsFpUMYh9n0CFGGgTf+1VEsu1xdNWq2nZDyIjVDV8cV
	rYaWJekt9Qs7bvUp7mATsWM=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hmNb86wgXzKm8V;
	Fri, 18 Sep 2026 14:52:04 +0800 (CST)
Received: from kwepemp100010.china.huawei.com (unknown [7.202.195.10])
	by mail.maildlp.com (Postfix) with ESMTPS id 7BFFB4057C;
	Fri, 18 Sep 2026 15:03:08 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp100010.china.huawei.com (7.202.195.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 18 Sep 2026 15:03:08 +0800
Received: from localhost.localdomain (10.50.163.32) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 18 Sep 2026 15:03:07 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.garry@linux.dev>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<mkp@kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <yangxingui@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
Subject: [PATCH v3] scsi: libsas: Fix SMP IO deadlock during HA resume
Date: Fri, 18 Sep 2026 15:03:07 +0800
Message-ID: <20260918070307.381207-1-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemp500015.china.huawei.com (7.202.195.9)

When the controller resumes, sas_resume_ha() -> sas_drain_work()
processes the DISCE_RESUME work, which restores the ATA ports through
the libata error handler (ata_sas_port_resume() requests ATA_EH_RESET)
and waits for it in sas_ata_flush_pm_eh(). For an expander-attached
ATA device the hard reset in that recovery is an SMP PHY CONTROL
command sent to the expander:

  ata_eh_recover() -> ata_eh_reset() -> sas_ata_hard_reset()
    -> lldd_I_T_nexus_reset() -> sas_phy_reset()
      -> sas_smp_phy_control() -> smp_execute_task_sg()

For a runtime resume ha->dev is still RPM_RESUMING while the callback
runs, so the pm_runtime_get_sync() in smp_execute_task_sg() blocks
waiting for the resume to complete, but the resume is blocked in
sas_drain_work() waiting for that very SMP IO — a deadlock.

Use pm_runtime_get_noresume() to take the reference while
SAS_HA_RESUMING is set, and pm_runtime_put() to drop it. The hardware
is already initialized by the LLDD before sas_resume_ha() runs.
SAS_HA_RESUMING is also set during a system sleep resume, where the
usage counter is still held from the sleep prepare and the put is
harmless.

Outside of the resume window, convert the pm_runtime_get_sync() call
to pm_runtime_resume_and_get() and check the result, so that an SMP IO
is not submitted to a host whose runtime resume failed (the return
value was previously ignored).

Only hisi_sas enables runtime PM among libsas LLDDs, so other drivers
(pm8001, isci, aic94xx, mvsas) are unaffected.

Fixes: 0da7ca4c4fd9 ("scsi: libsas: Resume host while sending SMP I/Os")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
Changes since v2:
- Drop the reference with pm_runtime_put() instead of
  pm_runtime_put_noidle().

Changes since v1:
- Use pm_runtime_get_noresume()/put_noidle() during HA resume instead
  of skipping the PM reference entirely, so an in-flight SMP IO always
  keeps autosuspend away.
- Convert pm_runtime_get_sync() to pm_runtime_resume_and_get() and
  check the result (pre-existing issue flagged by sashiko).

 drivers/scsi/libsas/sas_expander.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 811c9eb4fef1..5a8cdd3682fe 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -61,8 +61,22 @@ static int smp_execute_task_sg(struct domain_device *dev,
 	struct sas_internal *i =
 		to_sas_internal(dev->port->ha->shost->transportt);
 	struct sas_ha_struct *ha = dev->port->ha;
-
-	pm_runtime_get_sync(ha->dev);
+	bool ha_resuming = test_bit(SAS_HA_RESUMING, &ha->state);
+
+	/*
+	 * While the host is resuming, ha->dev may be RPM_RESUMING and
+	 * the resume blocked in sas_drain_work() waiting for this very
+	 * SMP IO, so waiting for the host to resume here would deadlock.
+	 * Hold the reference without resuming, the hardware is already
+	 * initialized by the LLDD before sas_resume_ha() runs.
+	 */
+	if (ha_resuming) {
+		pm_runtime_get_noresume(ha->dev);
+	} else {
+		res = pm_runtime_resume_and_get(ha->dev);
+		if (res)
+			return res;
+	}
 	mutex_lock(&dev->ex_dev.cmd_mutex);
 	for (retry = 0; retry < 3; retry++) {
 		if (test_bit(SAS_DEV_GONE, &dev->state)) {
@@ -135,7 +149,7 @@ static int smp_execute_task_sg(struct domain_device *dev,
 		}
 	}
 	mutex_unlock(&dev->ex_dev.cmd_mutex);
-	pm_runtime_put_sync(ha->dev);
+	pm_runtime_put(ha->dev);
 
 	BUG_ON(retry == 3 && task != NULL);
 	sas_free_task(task);
-- 
2.43.0


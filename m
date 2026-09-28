Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17FA3C1A;
	Mon, 28 Sep 2026 04:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790568167; cv=none; b=LVae/2dvVZeobnKMohoJDZEsQ4gh0lm7G2xRwqlPZve1s0cHHSyS+KlMDvRGSFERrJkf7XmYdReFA0Fy7mxFWDc/IUPmDGd7nWzLpssT1LdE2cdsv/StdRHGcuRBs37OwRRhfq8Y5qRd4oKEExvNHu2G6xIJYleQA+1lrBikSD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790568167; c=relaxed/simple;
	bh=Z+mvgAlTWve9a34B6geQMtcolETCJQL5RW6eymR/JJ4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MnKAcGzbd3KSB72E/ZBEY1uzYLwag3RoDFGpoaEIhBFU5Yzpa9ebkHIN2B7MQIJ3hmj/jjNSxsMWAHmx+nIyzTWCeeVun/gZf1qg6oyojeU1JiFb4007Qe2N1p0wlnoiKT9V7y3LimK/sqeJpu3mniL6usDLdAJIfZSmEP0EqFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=aNZYwyBR; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="aNZYwyBR"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xc3XtV6XQDfYDs7/ceu14FTonZTK2jB4QtyFIuz0B6A=;
	b=aNZYwyBRXbb1+PMNuewJGKap7oVa5Gv3jW+h/k0tmGihCShRu0VKT0GKofYa6P8aifAMqyx7j
	MLDe17AN9i4UpC8P88iESqnPcKW4SNIPu+vXfb0oAoahRr+/bGKD1UawbIZwb0WLPpS/88GIV5K
	NQX38oVQzPMKo0ENIoviiQc=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4htS4x5kmwz1prlG;
	Mon, 28 Sep 2026 11:50:25 +0800 (CST)
Received: from kwepemp100001.china.huawei.com (unknown [7.202.195.79])
	by mail.maildlp.com (Postfix) with ESMTPS id CC7CE4057D;
	Mon, 28 Sep 2026 12:02:35 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp100001.china.huawei.com (7.202.195.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 28 Sep 2026 12:02:35 +0800
Received: from localhost.localdomain (10.50.163.32) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 28 Sep 2026 12:02:35 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.garry@linux.dev>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<mkp@kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <yangxingui@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
Subject: [PATCH v4] scsi: libsas: Fix SMP IO deadlock during HA resume
Date: Mon, 28 Sep 2026 12:02:34 +0800
Message-ID: <20260928040234.992912-1-yangxingui@huawei.com>
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
 kwepemp500015.china.huawei.com (7.202.195.9)

smp_execute_task_sg() calls pm_runtime_get_sync() on the host before
issuing an SMP command. When that command is itself issued from the
HA resume path, the get_sync() deadlocks: it waits for the ongoing
resume (the device is RPM_RESUMING), while the resume is blocked in
sas_drain_work() waiting for that same SMP IO to complete.

The deadlock needs an expander-attached SATA disk. During
sas_resume_ha() -> sas_drain_work(), DISCE_RESUME ->
sas_resume_sata() -> ata_sas_port_resume() requests ATA_EH_RESET,
and the hard reset for such a disk is done via SMP PHY CONTROL
(sas_ata_hard_reset() -> sas_phy_reset() -> sas_smp_phy_control() ->
smp_execute_task_sg()). Direct-attached SATA resets through
lldd_control_phy() and SSP devices use TMFs, so neither hits this.

Replace the get_sync()/put_sync() pair with
pm_runtime_get_noresume()/pm_runtime_put(). smp_execute_task_sg()
only needs to hold off autosuspend while the SMP is in flight, and it
must not try to resume the host: a sync resume issued from the HA
resume path itself is what deadlocks, and by the time sas_resume_ha()
runs, hw_init has already reinitialized the hardware, so the device
is accessible without one.

The usage reference is still required. Discovery work normally runs
inside an event worker's PM reference, taken at
sas_notify_port_event() notify time and held until the handler has
flushed the disco queue. sas_rediscover_ex_phy() however requeues
DISCE_REVALIDATE_DOMAIN from within the revalidation worker itself,
and flush_workqueue() does not wait for work items queued during
execution, so that chained revalidation runs with no outer PM
reference - without the get_noresume(), its SMP could race
autosuspend.

For the BSG path, sas_smp_handler() is the only caller which may
find the host autosuspended: expander SMP requests do not go through
any SCSI device request queue, so nothing else in that path holds
the host awake. Resume it there with pm_runtime_resume_and_get()
and check the result.

Fixes: 3dbbbf656b850 ("scsi: libsas: Fix HA resume deadlock and hisi_sas disk-wake race")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
Changes since v3:
- Move the host resume to sas_smp_handler(), the only caller which may
  find the host autosuspended, as suggested by John Garry
- Replace get_sync()/put_sync() with get_noresume()/put() in
  smp_execute_task_sg(): a blocking resume issued from the HA resume
  path itself is what deadlocks
- Drop the racy SAS_HA_RESUMING check

Changes since v2:
- Drop the reference with pm_runtime_put() instead of
  pm_runtime_put_noidle().

Changes since v1:
- Use pm_runtime_get_noresume()/put_noidle() during HA resume instead
  of skipping the PM reference entirely, so an in-flight SMP IO always
  keeps autosuspend away.
- Convert pm_runtime_get_sync() to pm_runtime_resume_and_get() and
  check the result (pre-existing issue flagged by sashiko).

 drivers/scsi/libsas/sas_expander.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 811c9eb4fef1..26c2099c28b9 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -62,7 +62,11 @@ static int smp_execute_task_sg(struct domain_device *dev,
 		to_sas_internal(dev->port->ha->shost->transportt);
 	struct sas_ha_struct *ha = dev->port->ha;
 
-	pm_runtime_get_sync(ha->dev);
+	/*
+	 * Non-blocking: a sync resume here would deadlock against
+	 * sas_drain_work() during HA resume.
+	 */
+	pm_runtime_get_noresume(ha->dev);
 	mutex_lock(&dev->ex_dev.cmd_mutex);
 	for (retry = 0; retry < 3; retry++) {
 		if (test_bit(SAS_DEV_GONE, &dev->state)) {
@@ -135,7 +139,7 @@ static int smp_execute_task_sg(struct domain_device *dev,
 		}
 	}
 	mutex_unlock(&dev->ex_dev.cmd_mutex);
-	pm_runtime_put_sync(ha->dev);
+	pm_runtime_put(ha->dev);
 
 	BUG_ON(retry == 3 && task != NULL);
 	sas_free_task(task);
@@ -2222,6 +2226,11 @@ void sas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 		goto out;
 	}
 
+	/* The host may have autosuspended, resume it here. */
+	ret = pm_runtime_resume_and_get(dev->port->ha->dev);
+	if (ret)
+		goto out;
+
 	ret = smp_execute_task_sg(dev, job->request_payload.sg_list,
 			job->reply_payload.sg_list);
 	if (ret >= 0) {
@@ -2229,6 +2238,7 @@ void sas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 		rcvlen = job->reply_payload.payload_len - ret;
 		ret = 0;
 	}
+	pm_runtime_put(dev->port->ha->dev);
 
 out:
 	bsg_job_done(job, ret, rcvlen);
-- 
2.43.0


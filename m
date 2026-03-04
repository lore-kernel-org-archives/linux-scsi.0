Received: from out30-84.freemail.mail.aliyun.com (out30-84.freemail.mail.aliyun.com [115.124.30.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D681A6821;
	Wed,  4 Mar 2026 09:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772616591; cv=none; b=Bqi1r5zl0SvzAHmZItkqtVy/l/ggAI403/aygcW5E8lvEliPthfqgZkMgNfZ7+Asskm2QcsWiCR9iPW9qquzmL7rXoZGriP/8GkYzsfE+7L4PAnqAr3mVjeD48Dvq5VUwCqFK/WmrTrnxXKBSg2e8p6R8SQ6mDRzcTG6BfIzBlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772616591; c=relaxed/simple;
	bh=QpG5DznfSRg1C2rjMlRdmA8DLuSgq1NQONpDIgYImP8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EXlAwu4ZzvXMt5S03xdSas1E2BKgQEZNDkfLmIN87eEmCvr+ojBuKlLOyncR2ei6ap7uePS2CaQlNkxWHi5VI/fFBEFg12DsIzboFg4iYlukcuPbb1h87+/UED+p96f0YBfbcCmrR4me8z/FIQHeU1u0FXya45VceDwtP8fz//4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com; spf=pass smtp.mailfrom=aliyun.com; dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b=a5EVJBDS; arc=none smtp.client-ip=115.124.30.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliyun.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="a5EVJBDS"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=aliyun.com; s=s1024;
	t=1772616587; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=f1OuP1gSk44FJ9ffTn8N1kcHWGp9vDBzm9sY0Q00uyc=;
	b=a5EVJBDSyPJ1xWlJpC/Q3m3zI47F6rULq3i0OaWUtRCYd0vzFZU5MZI+e8n4zntpOGVvdXIoS9hgHFQ5pndugm1fotFOnHOGfkLMvI7MNu/8ENu6YsNfHi13HMYZaHoqeZiukRDdNTwvEhfi2otxHjFUDrmWXRWlCyunQnOmMUk=
Received: from localhost.localdomain(mailfrom:wdhh6@aliyun.com fp:SMTPD_---0X-Ec3KD_1772616582 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 04 Mar 2026 17:29:46 +0800
From: Chaohai Chen <wdhh6@aliyun.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	dlemoal@kernel.org,
	bvanassche@acm.org,
	hch@infradead.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chaohai Chen <wdhh6@aliyun.com>
Subject: [PATCH v4] scsi: core: Fix async_scan race condition with READ_ONCE/WRITE_ONCE
Date: Wed,  4 Mar 2026 17:29:39 +0800
Message-ID: <20260304092939.3092102-1-wdhh6@aliyun.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previously, host_lock was used to prevent bit-set conflicts in async_scan,
but this approach introduced naked reads in some code paths.

Convert async_scan from a bitfield to a bool type to eliminate bit-level
conflicts entirely. Use READ_ONCE() and WRITE_ONCE() to ensure proper
memory ordering on Alpha and satisfy KCSAN requirements.

Signed-off-by: Chaohai Chen <wdhh6@aliyun.com>
---

v1->v3:
- use READ_ONCE()/WRITE_ONCE() to fix the issue. (Christoph Hellwig, Damien Le Moal)

v3->v4:
- move async_scan before the bit field in the structure to avoid holes.(Damien Le Moal)

 drivers/scsi/scsi_scan.c | 22 ++++++++--------------
 include/scsi/scsi_host.h |  7 ++++---
 2 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 60c06fa4ec32..892be54dacc6 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1298,7 +1298,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 		goto out_free_result;
 	}
 
-	res = scsi_add_lun(sdev, result, &bflags, shost->async_scan);
+	res = scsi_add_lun(sdev, result, &bflags, READ_ONCE(shost->async_scan));
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (bflags & BLIST_KEY) {
 			sdev->lockable = 0;
@@ -1629,7 +1629,7 @@ struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
 	scsi_autopm_get_target(starget);
 
 	mutex_lock(&shost->scan_mutex);
-	if (!shost->async_scan)
+	if (!READ_ONCE(shost->async_scan))
 		scsi_complete_async_scans();
 
 	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
@@ -1839,7 +1839,7 @@ void scsi_scan_target(struct device *parent, unsigned int channel,
 		return;
 
 	mutex_lock(&shost->scan_mutex);
-	if (!shost->async_scan)
+	if (!READ_ONCE(shost->async_scan))
 		scsi_complete_async_scans();
 
 	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
@@ -1896,7 +1896,7 @@ int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
 		return -EINVAL;
 
 	mutex_lock(&shost->scan_mutex);
-	if (!shost->async_scan)
+	if (!READ_ONCE(shost->async_scan))
 		scsi_complete_async_scans();
 
 	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
@@ -1943,13 +1943,12 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
 static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 {
 	struct async_scan_data *data = NULL;
-	unsigned long flags;
 
 	if (strncmp(scsi_scan_type, "sync", 4) == 0)
 		return NULL;
 
 	mutex_lock(&shost->scan_mutex);
-	if (shost->async_scan) {
+	if (READ_ONCE(shost->async_scan)) {
 		shost_printk(KERN_DEBUG, shost, "%s called twice\n", __func__);
 		goto err;
 	}
@@ -1962,9 +1961,7 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 		goto err;
 	init_completion(&data->prev_finished);
 
-	spin_lock_irqsave(shost->host_lock, flags);
-	shost->async_scan = 1;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	WRITE_ONCE(shost->async_scan, true);
 	mutex_unlock(&shost->scan_mutex);
 
 	spin_lock(&async_scan_lock);
@@ -1992,7 +1989,6 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 static void scsi_finish_async_scan(struct async_scan_data *data)
 {
 	struct Scsi_Host *shost;
-	unsigned long flags;
 
 	if (!data)
 		return;
@@ -2001,7 +1997,7 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
 
 	mutex_lock(&shost->scan_mutex);
 
-	if (!shost->async_scan) {
+	if (!READ_ONCE(shost->async_scan)) {
 		shost_printk(KERN_INFO, shost, "%s called twice\n", __func__);
 		dump_stack();
 		mutex_unlock(&shost->scan_mutex);
@@ -2012,9 +2008,7 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
 
 	scsi_sysfs_add_devices(shost);
 
-	spin_lock_irqsave(shost->host_lock, flags);
-	shost->async_scan = 0;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	WRITE_ONCE(shost->async_scan, false);
 
 	mutex_unlock(&shost->scan_mutex);
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f6e12565a81d..ad745462f5ec 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -660,6 +660,10 @@ struct Scsi_Host {
 	 */
 	unsigned nr_hw_queues;
 	unsigned nr_maps;
+
+	/* Asynchronous scan in progress */
+	bool async_scan;
+
 	unsigned active_mode:2;
 
 	/*
@@ -678,9 +682,6 @@ struct Scsi_Host {
 	/* Task mgmt function in progress */
 	unsigned tmf_in_progress:1;
 
-	/* Asynchronous scan in progress */
-	unsigned async_scan:1;
-
 	/* Don't resume host in EH */
 	unsigned eh_noresume:1;
 
-- 
2.43.7


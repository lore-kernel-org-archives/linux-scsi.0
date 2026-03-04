Received: from out30-65.freemail.mail.aliyun.com (out30-65.freemail.mail.aliyun.com [115.124.30.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34375382F31;
	Wed,  4 Mar 2026 07:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772611049; cv=none; b=rKvHDOUZTKT7iUcQJ5xlTpCs+cAFPslJs+vsO4BxVI9LI6oLEqDRs9fqEHrzh4f9S7YJic2pz9oju0PiB4NORwkWpv0g66qSnsBfxAIGIeCBkbADJTx5J2w4caoqLtBzxcj7U9n9H6+uOZk/cyhTM8/C3wnxRNi626WKziBVyw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772611049; c=relaxed/simple;
	bh=Jys2tm4wdsFkaXHimIspWlP8VMjjv8Lce2XRhukObyI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H4YwQcMhjW0m++DrtNvO7rS+3Z9iWY2CKf7+fxA7yUiCzaUwyWhzjjrt6AexQ74rlrrIXOYn1Y06XqscRSuQxWmfZGR6usunw0dDJiZcvIqvMF557PeBCbULyCICkLSdcz4OJHLqWonfiSh2mTFdwm/S683S7nzMu+K1d6HnhHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com; spf=pass smtp.mailfrom=aliyun.com; dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b=eDrys2js; arc=none smtp.client-ip=115.124.30.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliyun.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="eDrys2js"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=aliyun.com; s=s1024;
	t=1772611039; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=kKWlY/Al6Bn7Vqp7QnoBuuIAht21Xl6dFtbJrhF04P8=;
	b=eDrys2js/DSJc88uI8TIHnZIQSuFe7qD5UWT2o2Qt748VSC4lk7cT4/8QhryxP+5hLtiYwPpeva+esTIfFgXiLBhmXcWEvE7stFEM4pn1uU81WcnQOrmLAALk4jyGkteGKwiuwHyOBV3FVs3X1dGBVwwi6lFclnlpuHOxUfX8uU=
Received: from localhost.localdomain(mailfrom:wdhh6@aliyun.com fp:SMTPD_---0X-DNxS7_1772611034 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 04 Mar 2026 15:57:18 +0800
From: Chaohai Chen <wdhh6@aliyun.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	dlemoal@kernel.org,
	bvanassche@acm.org,
	hch@infradead.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chaohai Chen <wdhh6@aliyun.com>
Subject: [PATCH v3] scsi: core: Fix async_scan race condition with READ_ONCE/WRITE_ONCE
Date: Wed,  4 Mar 2026 15:57:12 +0800
Message-ID: <20260304075712.3039960-1-wdhh6@aliyun.com>
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
use READ_ONCE()/WRITE_ONCE() to fix the issue (Christoph Hellwig, Damien Le Moal)

v1: https://lore.kernel.org/all/20260302121343.1630837-1-wdhh6@aliyun.com/

 drivers/scsi/scsi_scan.c | 22 ++++++++--------------
 include/scsi/scsi_host.h |  6 +++---
 2 files changed, 11 insertions(+), 17 deletions(-)

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
index f6e12565a81d..668ec9a1b33c 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -678,9 +678,6 @@ struct Scsi_Host {
 	/* Task mgmt function in progress */
 	unsigned tmf_in_progress:1;
 
-	/* Asynchronous scan in progress */
-	unsigned async_scan:1;
-
 	/* Don't resume host in EH */
 	unsigned eh_noresume:1;
 
@@ -699,6 +696,9 @@ struct Scsi_Host {
 	/* The transport requires the LUN bits NOT to be stored in CDB[1] */
 	unsigned no_scsi2_lun_in_cdb:1;
 
+	/* Asynchronous scan in progress */
+	bool async_scan;
+
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */
-- 
2.43.7


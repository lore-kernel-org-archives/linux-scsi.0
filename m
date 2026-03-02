Received: from out30-86.freemail.mail.aliyun.com (out30-86.freemail.mail.aliyun.com [115.124.30.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77657365A1D;
	Mon,  2 Mar 2026 12:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772453643; cv=none; b=pk+8TH9OY29o+urK1ZvYB8Zv27KsLCrEFvI/Ol9YiKAtmkeP92mPuvvnJRWpyld9bk/VxYjiJ4eC/W5+is280lpfGlunMkgvYp1oLyACsaERyczTmQXvuApREha99oI5gv54K9Z8ua1T2bhMWkAmNWo1qoAbLcIjCYySC6NaK4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772453643; c=relaxed/simple;
	bh=kk5zLB88AiJotVEEpvLVDaiv8QbA6pGshW2sNGH2744=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UCfzaTBXaeii6EpK40GhhOySR/jZHrHTHsjWzBBk/1yax12Vus7ExxpESkrUJoeoYf/9vbOPN2UUMBtPTXtPirwaJVJVALcGoAzXltfv8YOAXvjNVuRoiUUGoW/cniKmnlPeYGKJmRuagYWeip4kV9xhIpFfcgIIXFVmlA1pESc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com; spf=pass smtp.mailfrom=aliyun.com; dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b=VLMS9tg7; arc=none smtp.client-ip=115.124.30.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliyun.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="VLMS9tg7"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=aliyun.com; s=s1024;
	t=1772453639; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=b1ydDh/CzskCWGnXmFXVg+oYU4xCxWpVS6/7z71fW5U=;
	b=VLMS9tg71oNxHmoxDQYDweU03NjgRb9GXGooiQIf4uUlOJVYCur2BzQc7WaUexp+aIk8U1J/yw+w1aNMURL1e3+Cy6ApqmjT9+P9lqsnvGOfqCKBK2Ec2UylhiBrfQTb1tNhaZYNK7SeRbtF0RBgwzBsxarqCh+uGnKUDYeTnqk=
Received: from localhost.localdomain(mailfrom:wdhh6@aliyun.com fp:SMTPD_---0X-4I6s._1772453633 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 02 Mar 2026 20:13:58 +0800
From: Chaohai Chen <wdhh6@aliyun.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chaohai Chen <wdhh6@aliyun.com>
Subject: [PATCH] scsi: core: Fix missing lock when read async_scan in Scsi_Host
Date: Mon,  2 Mar 2026 20:13:43 +0800
Message-ID: <20260302121343.1630837-1-wdhh6@aliyun.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When setting the async_scan flag in host, the host lock was locked,
but it is not locked during reading. Encapsulate the corresponding
API to fix this issue.

Signed-off-by: Chaohai Chen <wdhh6@aliyun.com>
---
 drivers/scsi/scsi_scan.c | 60 +++++++++++++++++++++++++++++-----------
 1 file changed, 44 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 60c06fa4ec32..8b63130ef2e5 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -122,6 +122,42 @@ struct async_scan_data {
 	struct completion prev_finished;
 };
 
+static bool scsi_test_async_scan(struct Scsi_Host *shost)
+{
+	bool async;
+	unsigned long flags;
+
+	lockdep_assert_not_held(shost->host_lock);
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	async = shost->async_scan;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	return async;
+}
+
+static void scsi_set_async_scan(struct Scsi_Host *shost)
+{
+	unsigned long flags;
+
+	lockdep_assert_not_held(shost->host_lock);
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	shost->async_scan = 1;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+}
+
+static void scsi_clear_async_scan(struct Scsi_Host *shost)
+{
+	unsigned long flags;
+
+	lockdep_assert_not_held(shost->host_lock);
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	shost->async_scan = 0;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+}
+
 /*
  * scsi_enable_async_suspend - Enable async suspend and resume
  */
@@ -1298,7 +1334,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 		goto out_free_result;
 	}
 
-	res = scsi_add_lun(sdev, result, &bflags, shost->async_scan);
+	res = scsi_add_lun(sdev, result, &bflags, scsi_test_async_scan(shost));
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (bflags & BLIST_KEY) {
 			sdev->lockable = 0;
@@ -1629,7 +1665,7 @@ struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
 	scsi_autopm_get_target(starget);
 
 	mutex_lock(&shost->scan_mutex);
-	if (!shost->async_scan)
+	if (!scsi_test_async_scan(shost))
 		scsi_complete_async_scans();
 
 	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
@@ -1839,7 +1875,7 @@ void scsi_scan_target(struct device *parent, unsigned int channel,
 		return;
 
 	mutex_lock(&shost->scan_mutex);
-	if (!shost->async_scan)
+	if (!scsi_test_async_scan(shost))
 		scsi_complete_async_scans();
 
 	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
@@ -1896,7 +1932,7 @@ int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
 		return -EINVAL;
 
 	mutex_lock(&shost->scan_mutex);
-	if (!shost->async_scan)
+	if (!scsi_test_async_scan(shost))
 		scsi_complete_async_scans();
 
 	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
@@ -1943,13 +1979,12 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
 static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 {
 	struct async_scan_data *data = NULL;
-	unsigned long flags;
 
 	if (strncmp(scsi_scan_type, "sync", 4) == 0)
 		return NULL;
 
 	mutex_lock(&shost->scan_mutex);
-	if (shost->async_scan) {
+	if (scsi_test_async_scan(shost)) {
 		shost_printk(KERN_DEBUG, shost, "%s called twice\n", __func__);
 		goto err;
 	}
@@ -1961,10 +1996,7 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 	if (!data->shost)
 		goto err;
 	init_completion(&data->prev_finished);
-
-	spin_lock_irqsave(shost->host_lock, flags);
-	shost->async_scan = 1;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	scsi_set_async_scan(shost);
 	mutex_unlock(&shost->scan_mutex);
 
 	spin_lock(&async_scan_lock);
@@ -1992,7 +2024,6 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 static void scsi_finish_async_scan(struct async_scan_data *data)
 {
 	struct Scsi_Host *shost;
-	unsigned long flags;
 
 	if (!data)
 		return;
@@ -2001,7 +2032,7 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
 
 	mutex_lock(&shost->scan_mutex);
 
-	if (!shost->async_scan) {
+	if (!scsi_test_async_scan(shost)) {
 		shost_printk(KERN_INFO, shost, "%s called twice\n", __func__);
 		dump_stack();
 		mutex_unlock(&shost->scan_mutex);
@@ -2011,10 +2042,7 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
 	wait_for_completion(&data->prev_finished);
 
 	scsi_sysfs_add_devices(shost);
-
-	spin_lock_irqsave(shost->host_lock, flags);
-	shost->async_scan = 0;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	scsi_clear_async_scan(shost);
 
 	mutex_unlock(&shost->scan_mutex);
 
-- 
2.43.7


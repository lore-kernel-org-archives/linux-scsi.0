Received: from out30-76.freemail.mail.aliyun.com (out30-76.freemail.mail.aliyun.com [115.124.30.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A5337CD21;
	Tue,  3 Mar 2026 03:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772508409; cv=none; b=JNDGbrc4FhCh1ME/jUAPCNNHNWjr6Zy6Pq25FWeAFbptQObcM92kfVKdzmEhD/3s6SfObagqNPvnqdzZqkke7x3r9Tic8ExeZ0myMuAPs/JdKLSLb6vxu2zeMFQEDKTI/XV3qZlpFUz4++MCPV5xU6snMU6EHdWmP7/Paw99+ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772508409; c=relaxed/simple;
	bh=wElVhhXD92YmOW6drPglNKGkPxw8IDd4u+v54+NTAwY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CzRQpTV82RMIqrkDivyc6foCXKFbvOGKhKNqaXJ43jUj2NpCgIppalw5vCfh3fmg+ST7B/5Zzy4PzejPEXQMtQV6ZaaCxh0rkEldR+QlEyvyxvkrz+QMRXaIdicJLsGEvB/qzzASnZLP2ADlQJ5iTJggDYQFLBCWYzJxMyN25ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com; spf=pass smtp.mailfrom=aliyun.com; dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b=vw5HhJgs; arc=none smtp.client-ip=115.124.30.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliyun.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="vw5HhJgs"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=aliyun.com; s=s1024;
	t=1772508405; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=jfAGiQZ4KGwTIXPNyXSB//+EWTyBGs4JSHkon7Rp624=;
	b=vw5HhJgsjB++FMBZGronZzH4V07TXsKVS/+NOWKHUk7g72IfqmD0znuvFJJt5DWBcsPShLQrtSV4CB4p2w0yxrfsh/N+9AdPfJRp1cqWOMseloTRdnp9QirF6QSuiVj9VGNVf2mnOdbtXw9/Rzc4qgSjNQ2Kz1ouvrpbEbiK9jU=
Received: from localhost.localdomain(mailfrom:wdhh6@aliyun.com fp:SMTPD_---0X-8KnQw_1772508399 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Mar 2026 11:26:44 +0800
From: Chaohai Chen <wdhh6@aliyun.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	bvanassche@acm.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chaohai Chen <wdhh6@aliyun.com>
Subject: [PATCH v2] scsi: core: Fix missing lock when read async_scan in Scsi_Host
Date: Tue,  3 Mar 2026 11:26:35 +0800
Message-ID: <20260303032635.2118221-1-wdhh6@aliyun.com>
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

v1->v2:
- Use scoped_guard() in scsi_scan_async(). (Bart Van Assche)
- Drop the scsi_set_async_scan() and scsi_clear_async_scan. (Bart Van Assche)

v1: https://lore.kernel.org/all/20260302121343.1630837-1-wdhh6@aliyun.com/

 drivers/scsi/scsi_scan.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 60c06fa4ec32..d09b896d07d1 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -122,6 +122,14 @@ struct async_scan_data {
 	struct completion prev_finished;
 };
 
+static bool scsi_test_async_scan(struct Scsi_Host *shost)
+{
+	lockdep_assert_not_held(shost->host_lock);
+
+	scoped_guard(spinlock_irqsave, shost->host_lock)
+		return shost->async_scan;
+}
+
 /*
  * scsi_enable_async_suspend - Enable async suspend and resume
  */
@@ -1298,7 +1306,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 		goto out_free_result;
 	}
 
-	res = scsi_add_lun(sdev, result, &bflags, shost->async_scan);
+	res = scsi_add_lun(sdev, result, &bflags, scsi_test_async_scan(shost));
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (bflags & BLIST_KEY) {
 			sdev->lockable = 0;
@@ -1629,7 +1637,7 @@ struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
 	scsi_autopm_get_target(starget);
 
 	mutex_lock(&shost->scan_mutex);
-	if (!shost->async_scan)
+	if (!scsi_test_async_scan(shost))
 		scsi_complete_async_scans();
 
 	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
@@ -1839,7 +1847,7 @@ void scsi_scan_target(struct device *parent, unsigned int channel,
 		return;
 
 	mutex_lock(&shost->scan_mutex);
-	if (!shost->async_scan)
+	if (!scsi_test_async_scan(shost))
 		scsi_complete_async_scans();
 
 	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
@@ -1896,7 +1904,7 @@ int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
 		return -EINVAL;
 
 	mutex_lock(&shost->scan_mutex);
-	if (!shost->async_scan)
+	if (!scsi_test_async_scan(shost))
 		scsi_complete_async_scans();
 
 	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
@@ -1949,7 +1957,7 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 		return NULL;
 
 	mutex_lock(&shost->scan_mutex);
-	if (shost->async_scan) {
+	if (scsi_test_async_scan(shost)) {
 		shost_printk(KERN_DEBUG, shost, "%s called twice\n", __func__);
 		goto err;
 	}
@@ -2001,7 +2009,7 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
 
 	mutex_lock(&shost->scan_mutex);
 
-	if (!shost->async_scan) {
+	if (!scsi_test_async_scan(shost)) {
 		shost_printk(KERN_INFO, shost, "%s called twice\n", __func__);
 		dump_stack();
 		mutex_unlock(&shost->scan_mutex);
-- 
2.43.7


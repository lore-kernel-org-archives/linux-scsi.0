Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1808E28507E
	for <linux-scsi@vger.kernel.org>; Thu,  2 Oct 2025 19:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759433133; cv=none; b=ZkMsB8X23BUKpBWYQfSSttHLq4Siw6S4tH2PPUigdDaY3i6TogccIBM1teiSpM+nY9qG7ZHO0B8X/ehm44z+OuChH1LR7RtdLJf/AQgB9fpsYnua64/KCjWNrUfnplsq+wA/ZetHlelrBrfcQTMbdB3fqYFB91a3rmr8Hwz5fAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759433133; c=relaxed/simple;
	bh=MRuQBqOhpq+/gGBDPLnMxyGYEjxumfkpaDSIX4W9Ucs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKtCi4W5+t1FnpaIrSrEkAFb4Bfc3UIYaxFZsc3/CH087RIYtewO6uATYhrD03FQ2vrmQiDjMul1RtslOAxUQsJRsmqqt4AtfvkT3kXd5kEOkI6y73ADReRCcvfPg6XiTKhQYNbjl1EK1kGvJ1aUSZ7kwfGkYgjm/xEpC4d9k3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ULHT5E7p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ULHT5E7p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759433131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xAE5xJoSMFPSXuKmIQAnn8y8nULwMA1WK/o6yTOpQkc=;
	b=ULHT5E7pTGUssjGFGkvl6FsXqM613s54aej6SOQzysuYe/m2ZSZZj6CEH7jc1o71d6RwmN
	4axscKLQk9iZh9vZE4lWKkYsY0zAzt0ye86TJzUQnN6coRvVqAuRnZyvoNz2IB91FjTrRn
	hkn8/zPDeqbnBEpxoip0TAj76SfgA0Q=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-561-HPN-mRj0Om6uIS_rkGpTuw-1; Thu,
 02 Oct 2025 15:25:28 -0400
X-MC-Unique: HPN-mRj0Om6uIS_rkGpTuw-1
X-Mimecast-MFC-AGG-ID: HPN-mRj0Om6uIS_rkGpTuw_1759433127
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DBB28180057F;
	Thu,  2 Oct 2025 19:25:26 +0000 (UTC)
Received: from emilne-na.ibmlowe.csb (unknown [10.17.17.93])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AC5121955F19;
	Thu,  2 Oct 2025 19:25:25 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com,
	bvanassche@acm.org,
	dlemoal@kernel.org,
	hare@suse.de
Subject: [PATCH v4 9/9] scsi: scsi_debug: Add "only_once" module option to inject an error one time
Date: Thu,  2 Oct 2025 15:25:10 -0400
Message-ID: <20251002192510.1922731-10-emilne@redhat.com>
In-Reply-To: <20251002192510.1922731-1-emilne@redhat.com>
References: <20251002192510.1922731-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

The "every_nth" module option allows either periodic injection of errors
every N commands, or injection of errors on all commands after N commands.
It does not allow injection of a single error after N commands, which is
useful for testing things like code in the device probe path.

Add a new "only_once" module option that allows injection of a single error.
The "every_nth" module options are still used to control when the error
is injected, to simplify the code.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_debug.c | 50 +++++++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 2c49aadaef80..cbe022142b60 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -134,6 +134,7 @@ static const char *sdebug_version_date = "20210520";
 #define DEF_PER_HOST_STORE false
 #define DEF_D_SENSE   0
 #define DEF_EVERY_NTH   0
+#define DEF_ONLY_ONCE 0
 #define DEF_FAKE_RW	0
 #define DEF_GUARD 0
 #define DEF_HOST_LOCK 0
@@ -909,6 +910,7 @@ static int sdebug_dif = DEF_DIF;
 static int sdebug_dix = DEF_DIX;
 static int sdebug_dsense = DEF_D_SENSE;
 static int sdebug_every_nth = DEF_EVERY_NTH;
+static bool sdebug_only_once = DEF_ONLY_ONCE;
 static int sdebug_fake_rw = DEF_FAKE_RW;
 static unsigned int sdebug_guard = DEF_GUARD;
 static int sdebug_host_max_queue;	/* per host */
@@ -1005,6 +1007,8 @@ static int dix_writes;
 static int dix_reads;
 static int dif_errors;
 
+static bool injected;
+
 /* ZBC global data */
 static bool sdeb_zbc_in_use;	/* true for host-aware and host-managed disks */
 static int sdeb_zbc_zone_cap_mb;
@@ -7161,7 +7165,7 @@ static void clear_queue_stats(void)
 
 static bool inject_on_this_cmd(void)
 {
-	if (sdebug_every_nth == 0)
+	if (sdebug_every_nth == 0 || (sdebug_only_once && injected))
 		return false;
 	return (atomic_read(&sdebug_cmnd_count) % abs(sdebug_every_nth)) == 0;
 }
@@ -7205,7 +7209,9 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 
 		if ((num_in_q == qdepth) &&
 		    (atomic_inc_return(&sdebug_a_tsf) >=
-		     abs(sdebug_every_nth))) {
+		     abs(sdebug_every_nth)) &&
+		    !(sdebug_only_once && injected)) {
+			injected = true;
 			atomic_set(&sdebug_a_tsf, 0);
 			scsi_result = device_qfull_result;
 
@@ -7341,6 +7347,7 @@ module_param_named(dif, sdebug_dif, int, S_IRUGO);
 module_param_named(dix, sdebug_dix, int, S_IRUGO);
 module_param_named(dsense, sdebug_dsense, int, S_IRUGO | S_IWUSR);
 module_param_named(every_nth, sdebug_every_nth, int, S_IRUGO | S_IWUSR);
+module_param_named(only_once, sdebug_only_once, bool, S_IRUGO | S_IWUSR);
 module_param_named(fake_rw, sdebug_fake_rw, int, S_IRUGO | S_IWUSR);
 module_param_named(guard, sdebug_guard, uint, S_IRUGO);
 module_param_named(host_lock, sdebug_host_lock, bool, S_IRUGO | S_IWUSR);
@@ -7424,6 +7431,7 @@ MODULE_PARM_DESC(dif, "data integrity field type: 0-3 (def=0)");
 MODULE_PARM_DESC(dix, "data integrity extensions mask (def=0)");
 MODULE_PARM_DESC(dsense, "use descriptor sense format(def=0 -> fixed)");
 MODULE_PARM_DESC(every_nth, "timeout every nth command(def=0)");
+MODULE_PARM_DESC(only_once, "timeout only once after the nth command(def=0)");
 MODULE_PARM_DESC(fake_rw, "fake reads/writes instead of copying (def=0)");
 MODULE_PARM_DESC(guard, "protection checksum: 0=crc, 1=ip (def=0)");
 MODULE_PARM_DESC(host_lock, "host_lock is ignored (def=0)");
@@ -7567,9 +7575,9 @@ static int scsi_debug_show_info(struct seq_file *m, struct Scsi_Host *host)
 	seq_printf(m, "num_tgts=%d, %ssize=%d MB, opts=0x%x, every_nth=%d\n",
 		   sdebug_num_tgts, "shared (ram) ", sdebug_dev_size_mb,
 		   sdebug_opts, sdebug_every_nth);
-	seq_printf(m, "delay=%d, ndelay=%d, max_luns=%d, sector_size=%d %s\n",
+	seq_printf(m, "delay=%d, ndelay=%d, max_luns=%d, sector_size=%d %s, only_once=%d\n",
 		   sdebug_jdelay, sdebug_ndelay, sdebug_max_luns,
-		   sdebug_sector_size, "bytes");
+		   sdebug_sector_size, "bytes", sdebug_only_once);
 	seq_printf(m, "cylinders=%d, heads=%d, sectors=%d, command aborts=%d\n",
 		   sdebug_cylinders_per, sdebug_heads, sdebug_sectors_per,
 		   num_aborts);
@@ -7933,6 +7941,24 @@ static ssize_t every_nth_store(struct device_driver *ddp, const char *buf,
 }
 static DRIVER_ATTR_RW(every_nth);
 
+static ssize_t only_once_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", !!sdebug_only_once);
+}
+static ssize_t only_once_store(struct device_driver *ddp, const char *buf,
+			       size_t count)
+{
+	int n;
+
+	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
+		sdebug_only_once = (n > 0);
+		injected = false;
+		return count;
+	}
+	return -EINVAL;
+}
+static DRIVER_ATTR_RW(only_once);
+
 static ssize_t lun_format_show(struct device_driver *ddp, char *buf)
 {
 	return scnprintf(buf, PAGE_SIZE, "%d\n", (int)sdebug_lun_am);
@@ -8440,6 +8466,7 @@ static struct attribute *sdebug_drv_attrs[] = {
 	&driver_attr_dev_size_mb.attr,
 	&driver_attr_num_parts.attr,
 	&driver_attr_every_nth.attr,
+	&driver_attr_only_once.attr,
 	&driver_attr_lun_format.attr,
 	&driver_attr_max_luns.attr,
 	&driver_attr_max_queue.attr,
@@ -8997,6 +9024,9 @@ static int sdebug_change_qdepth(struct scsi_device *sdev, int qdepth)
 
 static bool fake_timeout(struct scsi_cmnd *scp)
 {
+	if (sdebug_only_once && injected)
+		return false;
+
 	if (0 == (atomic_read(&sdebug_cmnd_count) % abs(sdebug_every_nth))) {
 		if (sdebug_every_nth < -1)
 			sdebug_every_nth = -1;
@@ -9297,8 +9327,10 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 		sdev_printk(KERN_INFO, sdp, "%s: tag=%#x, cmd %s\n", my_name,
 			    blk_mq_unique_tag(scsi_cmd_to_rq(scp)), b);
 	}
-	if (unlikely(inject_now && (sdebug_opts & SDEBUG_OPT_HOST_BUSY)))
+	if (unlikely(inject_now && (sdebug_opts & SDEBUG_OPT_HOST_BUSY))) {
+		injected = true;
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 	has_wlun_rl = (sdp->lun == SCSI_W_LUN_REPORT_LUNS);
 	if (unlikely(lun_index >= sdebug_max_luns && !has_wlun_rl))
 		goto err_out;
@@ -9334,8 +9366,10 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 		return ret;
 	}
 
-	if (unlikely(inject_now && !atomic_read(&sdeb_inject_pending)))
+	if (unlikely(inject_now && !atomic_read(&sdeb_inject_pending))) {
+		injected = true;
 		atomic_set(&sdeb_inject_pending, 1);
+	}
 
 	na = oip->num_attached;
 	r_pfp = oip->pfp;
@@ -9412,8 +9446,10 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 	if (sdebug_fake_rw && (F_FAKE_RW & flags))
 		goto fini;
 	if (unlikely(sdebug_every_nth)) {
-		if (fake_timeout(scp))
+		if (fake_timeout(scp)) {
+			injected = true;
 			return 0;	/* ignore command: make trouble */
+		}
 	}
 	if (likely(oip->pfp))
 		pfp = oip->pfp;	/* calls a resp_* function */
-- 
2.47.1


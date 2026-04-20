Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC13839E184
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 11:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776683386; cv=none; b=ALpdpwHq6BZG4EW7yhiJgTw6rzUPpdkYJwITkcrypB+Ykf1sMXDScx7Sx51+5p+piAEtPz9ZanB6WYku7bAY+iWirgujmpGQBO5jBgzWu/jM8H9B6nPwgj6NJaL76z+rpYgN0eT17SV+C6e2aQrCwhzS2l2zYiIhFf4GfjE9148=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776683386; c=relaxed/simple;
	bh=dj8PD0bV7WxDaz50jZsoJvVW74sj3zxOrvB0e5eyf7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gwr7FqSgjiecz2l+me1LJGhGMcXtG03uTCxpQYdqFDr1EyYD2q0aZ6JjnXXFnOaAF2ChreQU6kR/HmhMFoZfYeX5MM+hKUrztA03rf6DIDBEECPCqntkOEFo0IxwqbdpMQaWXC+mJQwKnMHWG5xQpCCmt8WzNKQwUPg3OzBLzqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Bd05GOhO; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Bd05GOhO"
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2addb31945aso18912045ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 04:09:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776683377; x=1777288177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=75yCVnzGKfJT2emEspO0FE+TDcVr+9HkteEyYz8G0CI=;
        b=pMiGWKxaJvdHgv5bQ7LbAs6RFVf4l2FCowkJQJeA5yWZFO93Jsg4dwokGfcvn95bEd
         v4x5uav+JcYThxkIT7DQXgo6OiQiXOiYq8Sh6cpe2wqRxbPIdt7L4QqO5Grtm09bZRYw
         1YfqGQulU+e2ObX0jQ/TqqW6Nt3KFz3b2JSajakjum/sVUnjorR+x69GY3Cz5qSxishW
         p2L6bQGzpvg29BKcYzPCPXrAgDdvAh3a/vpNSUxaCB9uasJb1wfnqGAmpVqibhM2wRuf
         nL0DVDb9BbK9EClC1iIFub45+IibR+uHBED7+JFyTF+8kAHep6P2UjiZeJTfPXi8ukEA
         SJ1w==
X-Gm-Message-State: AOJu0YxeGZ97Tg4c+CE2+L98c2ttPNF9qCjGxG4RN7w9YsQ7pplsE/Xz
	XKMSyneO3f+40vPICbkgGs32gBHyN5kULQ8QNxuNP4gCR+HUUPN3GJopt8Lyv16nwUxyzEjLb3I
	Y+eevnRgS90u+w5thNyZQyO0n4W7aJPA0wuOqn/VjxYtRvtQcngBH0HAfZV+rwSKBOvDZ9My9Vl
	MzfPDo2Utp8IZ/ujxusUgTxTtGfVncLfW0yAMq4pH/Eikq//ltzDA9fQUWTETR9ZpvI75xpWxwX
	jjD/fhKQKrbGeA7
X-Gm-Gg: AeBDietqSU9pbgh5K78pNcp13K2K7fQRblAtDF6ymwhWgjkzuW8C721Dve3EdZV1sXa
	LQ8jUJFHKlB7Vj18guE0EYrgzBBQTb7Fp9YJvGjsds1K91rFRx6MUzcJUfMrMblI4cfGL3iFHQZ
	81gMYVIp30pCk6/fEmr41XglD55mx5FEZDjCS5zaXNBuoz+lMAUOcaeceBvpPaJkIFGoUdbG0yk
	qD6b0L+FkatmXtW7gUUgJ4PDkGoScapF6vHkZK8Dq2vXrYyVbFyUXsTVDieVsV7iHEq1u/pUikB
	JZgYrVsOjBZL08jk+WKEMzRF/7uAopH6dx7tmU+R4iiLS+tjrvI73xl6L40brd0oYiiZbPDarPa
	+9IdWGsDq2K7rbWCDrUTvowsjtGXz3hepnorIa5TDtNgmhxuwLG9TQMYPC7dhikE8QK5X80/I2A
	/f3IvlDaURtKV5GJIns1x/BhmOkeoCfqw7wUhSSCRs4bnfg+1O2C8xiFcaNBUss8XCZG8=
X-Received: by 2002:a17:903:1988:b0:2b4:5cea:f618 with SMTP id d9443c01a7336-2b5f9e7823fmr135363425ad.3.1776683376585;
        Mon, 20 Apr 2026 04:09:36 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-15.dlp.protect.broadcom.com. [144.49.247.15])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2b5faa0fa70sm6352645ad.14.2026.04.20.04.09.36
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Apr 2026 04:09:36 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2b2e8bba2e6so39550925ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 04:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1776683375; x=1777288175; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=75yCVnzGKfJT2emEspO0FE+TDcVr+9HkteEyYz8G0CI=;
        b=Bd05GOhOu8lCZI3y9bydzYdSIAw7mNbSylb8+jZR3eOp+4x8Bg8A/QCNQ1d9X3er68
         A8diatdK0uQKX01B3N44iTgIkdEeAnXwMbOw6/7ReebAGjJxdW2F7y0wztKRROv0J5LU
         g+cbU1wJgFWY6juoGk+jucncIIHwmSL3tvpI0=
X-Received: by 2002:a17:902:b493:b0:2b0:c451:ae8a with SMTP id d9443c01a7336-2b5f9eaf437mr84032045ad.13.1776683374895;
        Mon, 20 Apr 2026 04:09:34 -0700 (PDT)
X-Received: by 2002:a17:902:b493:b0:2b0:c451:ae8a with SMTP id d9443c01a7336-2b5f9eaf437mr84031865ad.13.1776683374415;
        Mon, 20 Apr 2026 04:09:34 -0700 (PDT)
Received: from sumit_ws.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5faa1739fsm103115415ad.22.2026.04.20.04.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 04:09:33 -0700 (PDT)
From: Sumit Saxena <sumit.saxena@broadcom.com>
To: martin.petersen@oracle.com,
	axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 3/3] scsi: use percpu counters for iorequest_cnt and iodone_cnt
Date: Mon, 20 Apr 2026 17:08:39 +0530
Message-ID: <20260420113846.1401374-4-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260420113846.1401374-1-sumit.saxena@broadcom.com>
References: <20260420113846.1401374-1-sumit.saxena@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

iorequest_cnt and iodone_cnt are updated on every command dispatch and
completion, often from different CPUs on high queue depth workloads.
Using adjacent atomic_t fields caused cache line contention between the
submission and completion paths.

Represent these statistics with struct percpu_counter so increments are
mostly local to each CPU, avoiding false sharing without growing
struct scsi_device further for cache-line padding.

Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/scsi_error.c  |  2 +-
 drivers/scsi/scsi_lib.c    |  8 ++++----
 drivers/scsi/scsi_scan.c   |  9 +++++++++
 drivers/scsi/scsi_sysfs.c  | 27 +++++++++++++++++++++++----
 include/scsi/scsi_device.h |  5 +++--
 5 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 147127fb4db9..c7424ce92f3e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -370,7 +370,7 @@ enum blk_eh_timer_return scsi_timeout(struct request *req)
 	 */
 	if (test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state))
 		return BLK_EH_DONE;
-	atomic_inc(&scmd->device->iodone_cnt);
+	percpu_counter_inc(&scmd->device->iodone_cnt);
 	if (scsi_abort_command(scmd) != SUCCESS) {
 		set_host_byte(scmd, DID_TIME_OUT);
 		scsi_eh_scmd_add(scmd);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6e8c7a42603e..0b05cb63f630 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1554,7 +1554,7 @@ static void scsi_complete(struct request *rq)
 
 	INIT_LIST_HEAD(&cmd->eh_entry);
 
-	atomic_inc(&cmd->device->iodone_cnt);
+	percpu_counter_inc(&cmd->device->iodone_cnt);
 	if (cmd->result)
 		atomic_inc(&cmd->device->ioerr_cnt);
 
@@ -1592,7 +1592,7 @@ static enum scsi_qc_status scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	struct Scsi_Host *host = cmd->device->host;
 	int rtn = 0;
 
-	atomic_inc(&cmd->device->iorequest_cnt);
+	percpu_counter_inc(&cmd->device->iorequest_cnt);
 
 	/* check if the device is still usable */
 	if (unlikely(cmd->device->sdev_state == SDEV_DEL)) {
@@ -1614,7 +1614,7 @@ static enum scsi_qc_status scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		 */
 		SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
 			"queuecommand : device blocked\n"));
-		atomic_dec(&cmd->device->iorequest_cnt);
+		percpu_counter_dec(&cmd->device->iorequest_cnt);
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 
@@ -1647,7 +1647,7 @@ static enum scsi_qc_status scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	trace_scsi_dispatch_cmd_start(cmd);
 	rtn = host->hostt->queuecommand(host, cmd);
 	if (rtn) {
-		atomic_dec(&cmd->device->iorequest_cnt);
+		percpu_counter_dec(&cmd->device->iorequest_cnt);
 		trace_scsi_dispatch_cmd_error(cmd, rtn);
 		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
 		    rtn != SCSI_MLQUEUE_TARGET_BUSY)
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 9749a8dbe964..0b4fa89149af 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -351,6 +351,15 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 
 	scsi_sysfs_device_initialize(sdev);
 
+	ret = percpu_counter_init(&sdev->iorequest_cnt, 0, GFP_KERNEL);
+	if (ret)
+		goto out_device_destroy;
+	ret = percpu_counter_init(&sdev->iodone_cnt, 0, GFP_KERNEL);
+	if (ret) {
+		percpu_counter_destroy(&sdev->iorequest_cnt);
+		goto out_device_destroy;
+	}
+
 	if (scsi_device_is_pseudo_dev(sdev))
 		return sdev;
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index dfc3559e7e04..1f5b2dc156a8 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -516,6 +516,10 @@ static void scsi_device_dev_release(struct device *dev)
 	if (vpd_pgb7)
 		kfree_rcu(vpd_pgb7, rcu);
 	kfree(sdev->inquiry);
+	if (percpu_counter_initialized(&sdev->iodone_cnt))
+		percpu_counter_destroy(&sdev->iodone_cnt);
+	if (percpu_counter_initialized(&sdev->iorequest_cnt))
+		percpu_counter_destroy(&sdev->iorequest_cnt);
 	kfree(sdev);
 
 	if (parent)
@@ -936,11 +940,26 @@ static ssize_t
 show_iostat_counterbits(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
-	return snprintf(buf, 20, "%d\n", (int)sizeof(atomic_t) * 8);
+	/*
+	 * iorequest_cnt and iodone_cnt are per-CPU sums (s64); ioerr_cnt and
+	 * iotmo_cnt remain atomic_t.  Report the widest counter for tools.
+	 */
+	return snprintf(buf, 20, "%zu\n", sizeof(s64) * 8);
 }
 
 static DEVICE_ATTR(iocounterbits, S_IRUGO, show_iostat_counterbits, NULL);
 
+#define show_sdev_iostat_percpu(field)					\
+static ssize_t								\
+show_iostat_##field(struct device *dev, struct device_attribute *attr,	\
+		    char *buf)						\
+{									\
+	struct scsi_device *sdev = to_scsi_device(dev);			\
+	unsigned long long count = percpu_counter_sum(&sdev->field);	\
+	return snprintf(buf, 20, "0x%llx\n", count);			\
+}									\
+static DEVICE_ATTR(field, 0444, show_iostat_##field, NULL)
+
 #define show_sdev_iostat(field)						\
 static ssize_t								\
 show_iostat_##field(struct device *dev, struct device_attribute *attr,	\
@@ -950,10 +969,10 @@ show_iostat_##field(struct device *dev, struct device_attribute *attr,	\
 	unsigned long long count = atomic_read(&sdev->field);		\
 	return snprintf(buf, 20, "0x%llx\n", count);			\
 }									\
-static DEVICE_ATTR(field, S_IRUGO, show_iostat_##field, NULL)
+static DEVICE_ATTR(field, 0444, show_iostat_##field, NULL)
 
-show_sdev_iostat(iorequest_cnt);
-show_sdev_iostat(iodone_cnt);
+show_sdev_iostat_percpu(iorequest_cnt);
+show_sdev_iostat_percpu(iodone_cnt);
 show_sdev_iostat(ioerr_cnt);
 show_sdev_iostat(iotmo_cnt);
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9c2a7bbe5891..ad80b500ced9 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -8,6 +8,7 @@
 #include <linux/blk-mq.h>
 #include <scsi/scsi.h>
 #include <linux/atomic.h>
+#include <linux/percpu_counter.h>
 #include <linux/sbitmap.h>
 
 struct bsg_device;
@@ -271,8 +272,8 @@ struct scsi_device {
 	unsigned int max_device_blocked; /* what device_blocked counts down from  */
 #define SCSI_DEFAULT_DEVICE_BLOCKED	3
 
-	atomic_t iorequest_cnt;
-	atomic_t iodone_cnt;
+	struct percpu_counter iorequest_cnt;
+	struct percpu_counter iodone_cnt;
 	atomic_t ioerr_cnt;
 	atomic_t iotmo_cnt;
 
-- 
2.43.7


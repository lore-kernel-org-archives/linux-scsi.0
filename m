Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961CA2980C7
	for <linux-scsi@vger.kernel.org>; Tue, 22 Apr 2025 18:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745345860; cv=none; b=QcnmUQYxL/TbLz5rx8Cve5bw4G5W6fWB0S0DvwxhXmeTgSdz/0MhyYv4n9NNi5jcEmSUCB/X8F76BMAY4Zzkc/JCKqXWSDM1MG4qUdH0aa0M8C2K/N5MOJMcjfhj5Ot/Wf1pX0TXuVJsP15Nmyn/ilnP9ucJ0eabvlHglzzVugE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745345860; c=relaxed/simple;
	bh=bHp9Kny3ewRpTLYzXBL8fgN5lC9P3VLGo+mqNKDUf50=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Hr1H8wUTGhaPYISJ31vFJrCBXqpzdf0oqmqXKS7Gm0W1fYCLcVd3QiHLDQnlfLwyFynVCrxCakslJGPnnc6qNj/MKyUOnpR6lzCGW0m5bdgkslOxqxZ/6pK1D9nJYv0eQ4gOrUJn9PlYj4PtZGUTGwNz3W0oqWuK4jkgjsgI6aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--salomondush.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JvUvcOxN; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--salomondush.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JvUvcOxN"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff7f9a0b9bso4851573a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 22 Apr 2025 11:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745345857; x=1745950657; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PBdoNuZNaH4pr2rowaqiMV0ON4Tg0iuLu7WB7J4ehb8=;
        b=JvUvcOxNRL7NqDDmnPPMuzQ33paDaiVJo8u4+kNlj5HqE8TQNqntgIzU9OZiwAYBzU
         Vn3I0gwySYbVrrOwxtZ8oyOltzSokmqhp8YEQWFeC6gRmC4CfOHcazJ5pOXgFT88I40/
         RR8uHIgSKQ4gC7TOHfeV612eITM8Bx8KXMJS/8xjfiKQtFFo8LH3wYLeOioSxf3W+77b
         PHtnEOfDzfOLvPjGN+Cl515AKF95LfKEixyWX4Q5HqSQVnWRLgcM5xPNfodqgc9GEZUk
         l7p1926yXsqEpYvwKztIoqWBs1HmoKkM0sTRPEFVFL0TolPV15nlX8YMT7YRmH7y2QH3
         Q1ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745345857; x=1745950657;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PBdoNuZNaH4pr2rowaqiMV0ON4Tg0iuLu7WB7J4ehb8=;
        b=uunVi3R/SgiSSr/JvhR7tAIdLTVhEZji+q76mSMZLkqQbOWQn58Ihb418WZaEW87Hy
         +k+2//gJK968vzWDRbTJ3T/ikqTvZKsxgWugGdu/n5zskWTTl83R9/MTfrfb4FXgCB+d
         iOX25WATaW75Mo5GxXJOAZi/olRgaB30iQqnpE5f+tv0fb6BHD1Gq/7xEYtZyBddriE0
         Co8iba/L8ZDabzAQTHrimLyxrguSXo2l2aJ5zrfSGf1dfOi9JRLLGNF0Yq9AY4GZsaCt
         tKiFak9KGu5l/laoddslioIs/1DcsdWiYy5gEuFQBHG2QTfdhNeCYHXSHa+9hShu/rHs
         wvDQ==
X-Gm-Message-State: AOJu0Yz86pyOc0D7FaXEkVIDtDl/NjE0ySCI629lCdEQOWghJOoWbKr2
	is+rO9VCOblDRvLeUE4MFOvM6mcEpIhps7iprf7tw3wfOZ98NatN3C6apdyJ0+MeF6LMrRsrZrB
	KPzlPD7lEFyTb8vDOelZxBA==
X-Google-Smtp-Source: AGHT+IEgnjh5SLahWd3XPytmlvByFb6HnCrpXqV+gcSOGL34RZYASA5fnogNPp11jkB3hz+w0nqfNIwPv57s9NoeLA==
X-Received: from pjbpb7.prod.google.com ([2002:a17:90b:3c07:b0:2e9:38ea:ca0f])
 (user=salomondush job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:d00f:b0:301:9f62:a944 with SMTP id 98e67ed59e1d1-3087bbbb7admr25802856a91.33.1745345856909;
 Tue, 22 Apr 2025 11:17:36 -0700 (PDT)
Date: Tue, 22 Apr 2025 18:17:28 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.805.g082f7c87e0-goog
Message-ID: <20250422181729.2792081-1-salomondush@google.com>
Subject: [PATCH] scsi: Add SCSI error events, sent as kobject uevents by mid-layer
From: Salomon Dushimirimana <salomondush@google.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Salomon Dushimirimana <salomondush@google.com>
Content-Type: text/plain; charset="UTF-8"

Adds a new function scsi_emit_error(), called when a command is placed
back on the command queue for retry by the error handler, or when a
command completes.

The scsi_emit_error() function uses the kobject_uevent_env() mechanism
to emit a KOBJ_CHANGE event with details about the SCSI error.

The event has the following key/value pairs set in the environment:
- SDEV_ERROR: Always set to 1, to distinguish disk errors
  from media change events, which have SDEV_MEDIA_CHANGE=1
- SDEV_ERROR_RETRY: 0 if this is an error in the completion
  path in scsi_io_completion(), 1 if the command is going to be
  placed back on the queue
- SDEV_ERROR_RESULT: Host byte of result code
- SDEV_ERROR_SK: Sense key
- SDEV_ERROR_ASC: Additional sense code
- SDEV_ERROR_ASCQ: Additional sense code qualifier

Error events are filtered under specific conditions:
- DID_BAD_TARGET: Avoids uevent storms if a removed device is repeatedly
  accessed and is not responding.
- DID_IMM_RETRY: Avoids reporting temporary transport errors where the
  command is immediately retried. This is a temporary error that should
  not be forwarded to userspace.

scsi_emit_error() can be invoked from vairous atomic contexts, where
sleeping is not permitted, so GFP_ATOMIC is used to ensure allocations
can safely occur in these contexts.

A per-device ratelimiting mechanism is added to prevent flooding
userspace during persistent error conditions. The ratelimit is checked
before scheduling the event work.

Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
---
 drivers/scsi/Kconfig       |  17 +++++++
 drivers/scsi/scsi_error.c  |  66 ++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c    | 100 ++++++++++++++++++++++++++++++++-----
 drivers/scsi/scsi_priv.h   |   1 +
 drivers/scsi/scsi_scan.c   |   4 ++
 drivers/scsi/scsi_sysfs.c  |   2 +
 include/scsi/scsi_device.h |  22 +++++++-
 7 files changed, 199 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 5a3c670aec27d..36a156ad6afd2 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -240,6 +240,23 @@ config SCSI_SCAN_ASYNC
 	  Note that this setting also affects whether resuming from
 	  system suspend will be performed asynchronously.
 
+config SCSI_ERROR_UEVENT
+	bool "Enable SCSI error uevent reporting"
+	depends on SCSI
+	default n
+	help
+	  If enabled, the SCSI mid-layer will emit kobject uevents when
+	  SCSI commands fail or are retried by the error handler. These
+	  events provide details about the error, including the command
+	  result (host byte), sense key (SK), additional sense code (ASC),
+	  additional sense code qualifier (ASCQ), and whether the command
+	  is being retried (SDEV_ERROR_RETRY=1) or finally failing because
+	  of error in completion path (SDEV_ERROR_RETRY=0).
+
+	  Events are filtered for certain conditions (e.g., DID_BAD_TARGET,
+	  DID_IMM_RETRY) and are also ratelimited per device to prevent
+	  excessive noise.
+
 config SCSI_PROTO_TEST
 	tristate "scsi_proto.h unit tests" if !KUNIT_ALL_TESTS
 	depends on SCSI && KUNIT
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 376b8897ab90a..327a012f328ff 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2227,6 +2227,9 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 				scmd_printk(KERN_INFO, scmd,
 					     "%s: flush retry cmd\n",
 					     current->comm));
+#ifdef CONFIG_SCSI_ERROR_UEVENT
+				scsi_emit_error(scmd);
+#endif
 				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
 				blk_mq_kick_requeue_list(sdev->request_queue);
 		} else {
@@ -2595,3 +2598,66 @@ bool scsi_get_sense_info_fld(const u8 *sense_buffer, int sb_len,
 	}
 }
 EXPORT_SYMBOL(scsi_get_sense_info_fld);
+
+/**
+ * scsi_emit_error - Emit an error event.
+ *
+ * May be called from scsi_softirq_done(). Cannot sleep.
+ *
+ * @cmd: the scsi command
+ */
+void scsi_emit_error(struct scsi_cmnd *cmd)
+{
+	struct scsi_sense_hdr sshdr;
+	u8 result, sk, asc, ascq;
+	int sense_valid;
+	int retry;
+
+	if (unlikely(cmd->result)) {
+		result = host_byte(cmd->result);
+		if (result == DID_BAD_TARGET ||
+		    result == DID_IMM_RETRY)
+			/*
+			 * Do not report an error upstream, the situation is
+			 * not stable. Will report once the IO really fails.
+			 */
+			return;
+		sk = 0;
+		asc = 0;
+		ascq = 0;
+
+		if (result == DID_OK) {
+			sense_valid = scsi_command_normalize_sense(cmd, &sshdr);
+			if (!sense_valid) {
+				/*
+				 * With libata, this happens when the error
+				 * handler is called but the error causes are
+				 * not identified yet.
+				 */
+				return;
+			}
+
+			sk = sshdr.sense_key;
+			asc = sshdr.asc;
+			ascq = sshdr.ascq;
+
+			/*
+			 * asc == 0 && ascq == 0x1D means "ATA pass through
+			 * information available"; this is not an error, but
+			 * rather the driver returning some data.
+			 */
+			if (sk == NO_SENSE ||
+			    (sk == RECOVERED_ERROR &&
+			     asc == 0x0 &&
+			     ascq == 0x1D)) {
+				return;
+			}
+		}
+
+		retry = (!scsi_noretry_cmd(cmd) &&
+			 cmd->retries > 0 &&
+			 cmd->retries <= cmd->allowed);
+		sdev_evt_send_error(cmd->device, GFP_ATOMIC,
+				    retry, result, sk, asc, ascq);
+	}
+}
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0d29470e86b0b..2a2fae00e9f1c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1029,6 +1029,9 @@ static int scsi_io_completion_nz_result(struct scsi_cmnd *cmd, int result,
 		result = 0;
 		*blk_statp = BLK_STS_OK;
 	}
+#ifdef CONFIG_SCSI_ERROR_UEVENT
+	scsi_emit_error(cmd);
+#endif
 	return result;
 }
 
@@ -1544,6 +1547,9 @@ static void scsi_complete(struct request *rq)
 		scsi_finish_command(cmd);
 		break;
 	case NEEDS_RETRY:
+#ifdef CONFIG_SCSI_ERROR_UEVENT
+		scsi_emit_error(cmd);
+#endif
 		scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY);
 		break;
 	case ADD_TO_MLQUEUE:
@@ -2559,43 +2565,77 @@ EXPORT_SYMBOL(scsi_device_set_state);
  */
 static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
 {
-	int idx = 0;
-	char *envp[3];
+	struct kobj_uevent_env *env;
+
+	env = kzalloc(sizeof(struct kobj_uevent_env), GFP_KERNEL);
+	if (!env)
+		return;
 
 	switch (evt->evt_type) {
 	case SDEV_EVT_MEDIA_CHANGE:
-		envp[idx++] = "SDEV_MEDIA_CHANGE=1";
+		if (add_uevent_var(env, "SDEV_MEDIA_CHANGE=1"))
+			goto exit;
 		break;
 	case SDEV_EVT_INQUIRY_CHANGE_REPORTED:
 		scsi_rescan_device(sdev);
-		envp[idx++] = "SDEV_UA=INQUIRY_DATA_HAS_CHANGED";
+		if (add_uevent_var(env,	"SDEV_UA=INQUIRY_DATA_HAS_CHANGED"))
+			goto exit;
 		break;
 	case SDEV_EVT_CAPACITY_CHANGE_REPORTED:
-		envp[idx++] = "SDEV_UA=CAPACITY_DATA_HAS_CHANGED";
+		if (add_uevent_var(env,	"SDEV_UA=CAPACITY_DATA_HAS_CHANGED"))
+			goto exit;
 		break;
 	case SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED:
-	       envp[idx++] = "SDEV_UA=THIN_PROVISIONING_SOFT_THRESHOLD_REACHED";
+		if (add_uevent_var(env,
+			"SDEV_UA=THIN_PROVISIONING_SOFT_THRESHOLD_REACHED"))
+			goto exit;
 		break;
 	case SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED:
-		envp[idx++] = "SDEV_UA=MODE_PARAMETERS_CHANGED";
+		if (add_uevent_var(env, "SDEV_UA=MODE_PARAMETERS_CHANGED"))
+			goto exit;
 		break;
 	case SDEV_EVT_LUN_CHANGE_REPORTED:
-		envp[idx++] = "SDEV_UA=REPORTED_LUNS_DATA_HAS_CHANGED";
+		if (add_uevent_var(env,
+			"SDEV_UA=REPORTED_LUNS_DATA_HAS_CHANGED"))
+			goto exit;
 		break;
 	case SDEV_EVT_ALUA_STATE_CHANGE_REPORTED:
-		envp[idx++] = "SDEV_UA=ASYMMETRIC_ACCESS_STATE_CHANGED";
+		if (add_uevent_var(env,
+			"SDEV_UA=ASYMMETRIC_ACCESS_STATE_CHANGED"))
+			goto exit;
+		break;
+	case SDEV_EVT_ERROR:
+		if (add_uevent_var(env, "SDEV_ERROR=1"))
+			goto exit;
+		if (add_uevent_var(env, "SDEV_ERROR_RETRY=%u",
+					evt->error_evt.retry))
+			goto exit;
+		if (add_uevent_var(env, "SDEV_ERROR_RESULT=%u",
+					evt->error_evt.result))
+			goto exit;
+		if (add_uevent_var(env, "SDEV_ERROR_SK=%u",
+					evt->error_evt.sk))
+			goto exit;
+		if (add_uevent_var(env, "SDEV_ERROR_ASC=%u",
+					evt->error_evt.asc))
+			goto exit;
+		if (add_uevent_var(env, "SDEV_ERROR_ASCQ=%u",
+					evt->error_evt.ascq))
+			goto exit;
 		break;
 	case SDEV_EVT_POWER_ON_RESET_OCCURRED:
-		envp[idx++] = "SDEV_UA=POWER_ON_RESET_OCCURRED";
+		if (add_uevent_var(env, "SDEV_UA=POWER_ON_RESET_OCCURRED"))
+			goto exit;
 		break;
 	default:
 		/* do nothing */
 		break;
 	}
 
-	envp[idx++] = NULL;
+	kobject_uevent_env(&sdev->sdev_gendev.kobj, KOBJ_CHANGE, env->envp);
 
-	kobject_uevent_env(&sdev->sdev_gendev.kobj, KOBJ_CHANGE, envp);
+exit:
+	kfree(env);
 }
 
 /**
@@ -2693,6 +2733,7 @@ struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
 	case SDEV_EVT_LUN_CHANGE_REPORTED:
 	case SDEV_EVT_ALUA_STATE_CHANGE_REPORTED:
 	case SDEV_EVT_POWER_ON_RESET_OCCURRED:
+	case SDEV_EVT_ERROR:
 	default:
 		/* do nothing */
 		break;
@@ -2724,6 +2765,41 @@ void sdev_evt_send_simple(struct scsi_device *sdev,
 }
 EXPORT_SYMBOL_GPL(sdev_evt_send_simple);
 
+/**
+ *	sdev_evt_send_error - send error event to uevent thread
+ *	@sdev: scsi_device event occurred on
+ *	@gfpflags: GFP flags for allocation
+ *	@retry: if non-zero, command failed, will retry, otherwise final attempt
+ *	@result: host byte of result
+ *	@sk: sense key
+ *	@asc: additional sense code
+ *	@ascq: additional sense code qualifier
+ *
+ *	Assert scsi device error event asynchronously.
+ */
+void sdev_evt_send_error(struct scsi_device *sdev, gfp_t gfpflags,
+			 u8 retry, u8 result, u8 sk, u8 asc, u8 ascq)
+{
+	struct scsi_event *evt;
+
+	evt = sdev_evt_alloc(SDEV_EVT_ERROR, gfpflags);
+	if (!evt) {
+		sdev_printk(KERN_ERR, sdev, "error event eaten due to OOM: retry=%u result=%u sk=%u asc=%u ascq=%u\n",
+			    retry, result, sk, asc, ascq);
+		return;
+	}
+
+	evt->error_evt.retry = retry;
+	evt->error_evt.result = result;
+	evt->error_evt.sk = sk;
+	evt->error_evt.asc = asc;
+	evt->error_evt.ascq = ascq;
+
+	if (___ratelimit(&sdev->error_ratelimit, "SCSI error"))
+		sdev_evt_send(sdev, evt);
+}
+EXPORT_SYMBOL_GPL(sdev_evt_send_error);
+
 /**
  *	scsi_device_quiesce - Block all commands except power management.
  *	@sdev:	scsi device to quiesce.
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 9fc397a9ce7a4..8519b563e2feb 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -101,6 +101,7 @@ int scsi_eh_get_sense(struct list_head *work_q,
 		      struct list_head *done_q);
 bool scsi_noretry_cmd(struct scsi_cmnd *scmd);
 void scsi_eh_done(struct scsi_cmnd *scmd);
+extern void scsi_emit_error(struct scsi_cmnd *scmd);
 
 /* scsi_lib.c */
 extern void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 4833b8fe251b8..5c311dfc501c3 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -310,6 +310,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	mutex_init(&sdev->inquiry_mutex);
 	INIT_WORK(&sdev->event_work, scsi_evt_thread);
 	INIT_WORK(&sdev->requeue_work, scsi_requeue_run_queue);
+	ratelimit_state_init(&sdev->error_ratelimit, 5 * HZ, 10);
 
 	sdev->sdev_gendev.parent = get_device(&starget->dev);
 	sdev->sdev_target = starget;
@@ -363,6 +364,9 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 
 	scsi_change_queue_depth(sdev, depth);
 
+	/* All devices support error events */
+	set_bit(SDEV_EVT_ERROR, sdev->supported_events);
+
 	scsi_sysfs_device_initialize(sdev);
 
 	if (shost->hostt->sdev_init) {
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index d772258e29ad2..20a537490e9f2 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1025,6 +1025,7 @@ DECLARE_EVT(capacity_change_reported, CAPACITY_CHANGE_REPORTED)
 DECLARE_EVT(soft_threshold_reached, SOFT_THRESHOLD_REACHED_REPORTED)
 DECLARE_EVT(mode_parameter_change_reported, MODE_PARAMETER_CHANGE_REPORTED)
 DECLARE_EVT(lun_change_reported, LUN_CHANGE_REPORTED)
+DECLARE_EVT(error, ERROR)
 
 static ssize_t
 sdev_store_queue_depth(struct device *dev, struct device_attribute *attr,
@@ -1345,6 +1346,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 	REF_EVT(soft_threshold_reached),
 	REF_EVT(mode_parameter_change_reported),
 	REF_EVT(lun_change_reported),
+	REF_EVT(error),
 	NULL
 };
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 68dd49947d041..5485d3b5853e2 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -64,7 +64,8 @@ enum scsi_scan_mode {
 };
 
 enum scsi_device_event {
-	SDEV_EVT_MEDIA_CHANGE	= 1,	/* media has changed */
+	SDEV_EVT_MEDIA_CHANGE	= 0,	/* media has changed */
+	SDEV_EVT_ERROR		= 1,	/* command failed */
 	SDEV_EVT_INQUIRY_CHANGE_REPORTED,		/* 3F 03  UA reported */
 	SDEV_EVT_CAPACITY_CHANGE_REPORTED,		/* 2A 09  UA reported */
 	SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED,	/* 38 07  UA reported */
@@ -79,6 +80,19 @@ enum scsi_device_event {
 	SDEV_EVT_MAXBITS	= SDEV_EVT_LAST + 1
 };
 
+struct scsi_error_event {
+	/* A retry event */
+	u8 retry;
+	/* Host byte */
+	u8 result;
+	/* Sense key */
+	u8 sk;
+	/* Additional sense code */
+	u8 asc;
+	/* Additional sense code qualifier */
+	u8 ascq;
+};
+
 struct scsi_event {
 	enum scsi_device_event	evt_type;
 	struct list_head	node;
@@ -86,6 +100,9 @@ struct scsi_event {
 	/* put union of data structures, for non-simple event types,
 	 * here
 	 */
+	union {
+		struct scsi_error_event error_evt;
+	};
 };
 
 /**
@@ -269,6 +286,7 @@ struct scsi_device {
 				sdev_dev;
 
 	struct work_struct	requeue_work;
+	struct ratelimit_state	error_ratelimit;
 
 	struct scsi_device_handler *handler;
 	void			*handler_data;
@@ -474,6 +492,8 @@ extern struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
 extern void sdev_evt_send(struct scsi_device *sdev, struct scsi_event *evt);
 extern void sdev_evt_send_simple(struct scsi_device *sdev,
 			  enum scsi_device_event evt_type, gfp_t gfpflags);
+extern void sdev_evt_send_error(struct scsi_device *sdev, gfp_t gfpflags,
+	u8 retry, u8 result, u8 sk, u8 asc, u8 ascq);
 extern int scsi_device_quiesce(struct scsi_device *sdev);
 extern void scsi_device_resume(struct scsi_device *sdev);
 extern void scsi_target_quiesce(struct scsi_target *);
-- 
2.49.0.805.g082f7c87e0-goog


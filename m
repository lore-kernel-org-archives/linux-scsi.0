Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9518016C854
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jan 2025 10:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738145601; cv=none; b=ATyuYIf1GfhJHPs0c6OOyYEp9uTZCrwyoMxgicnOubrzpeNEo7uBpL73tPWMBuzQUE2aQvB6IvjvGaFbyg8cL76zTEbePQZfUGAF2DYrcbHI7ke/eHe4CF/oZAPYw2GQM9SstWFkMZr3TVfkCgXHMnrTO+YqrhygyazS/wkDeSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738145601; c=relaxed/simple;
	bh=qjxP11cQHXqoZrdmBZ+UP6CaepJ8f7dkrIygD2FoFCQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FfWhh+9RtWBkSZNZ2KvWs44cvWWui8dnkWvAQM3Sm+dLV4p5Tpdcxtkd2+3iQ8BqkOjwlnLAsn5x7na59fMhLvyEV4UY8NqUQIBGVsh9FPNI2iSSv5NtftMtWyqRmKlCtVrplu/+YnujmHP4FViRBTLNahAaeTx5BYubPc7v000=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=OOUkaWre; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="OOUkaWre"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2162c0f6a39so9518115ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jan 2025 02:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1738145598; x=1738750398; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A4zxnMNdPu/lFg1n/LiG9siEWbLoFpRx2EJq45tJj+8=;
        b=OOUkaWreapiMVnxU/lySr1DrbY/6ZwrZyrfs8awIFBvKNUVZZrOSk3z3TSdL/nZMT5
         VSMOETneg4tHVSh/7NImhakQXfpAofrSk9/eg8fZG44ZuwEJyqcAwJZAdrj/Z6oAdPzQ
         sPZuekPyR4eAVHzM1eH6lleMgeNdrlSjGr8Ok=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738145598; x=1738750398;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A4zxnMNdPu/lFg1n/LiG9siEWbLoFpRx2EJq45tJj+8=;
        b=qf8HvCTAs72a9uN0ySGIFqdNbEPnQMmJpahHVH1UgyQCD9trAe2gvaZjUhaDNnos+S
         +WwyBFfE2e9E9TKaVebz38LMuic+9nN4UOrJWzuWCnQj1Ofct+jM0X92GmQnlCASDPJ6
         3i6oY2xvUwqyeoxJiE2YYI1eHxiQV5Zl/naTkweACP8s6vGMDGqjgHIjx0tmxWLy3mYo
         jZxHicsMPfXzfbVmuAQsY26R8xGWuACRHJ5ZLIcIffJmGiM47qLYwb6Nhu3i2LxmuH+n
         KnfF7CJ43Qk4M3lRbOU339H9GZDNT3J+rWnnN3E7qtWoDtDe91HizxvUeP+jf4uKc7LM
         VTKw==
X-Gm-Message-State: AOJu0YwKIQgQk9lqz0Fy4Vt6juJ/VpBg8vf49K0tpagX7u5rWUQPvQDV
	Jk3MYdyqAR0MmrjFMfpLlo8qnUtILx5Wx9GiZ/AiR1zwN7hVa4/7MCDrNHcMdAy3t2p5arlC67T
	N0pZ31CyS7FUpoTVHNSzF6cHgnJo5VLII2OLrY2MKIt7pzA5jnE9vewVZqzSdWRyQ8B4MxVrhDA
	gabvJF/Qv8KDwWGfVblhdDF/BGow12tzQEXWdPipFyIdH5g5RX
X-Gm-Gg: ASbGncv2XGGVUg1+e6QNPWCTwtNPnGgBIWId1jkSQSz6aU8uX40PR/LUtbjkzP1rv0X
	SoIi2H9HOaDVSUyoQO3emllg43Vpy7CnK6FOJMCavqKdroHk+QStixccgW+OMD6n+SVLoHGoLi7
	VLEbmgvcky0ZbGHNZ2+U5yb5iX9Fjb7z0tOwDuq2ipMdnf81bglds8/yJgPsN58Jyo6nwtvMWeS
	+D/nEE3Pm6GLrXt6MqA6iD6xxINg1P+wz2qobA2/GHFtL79/MeALz5cBtwAkGW2yGEdbYS85w+h
	Mg7f3FzFGH4vqVlRQX0tt/xub3lU/X5KlpN+ym5ZaqIkEAGgxN+EiVxvqY0=
X-Google-Smtp-Source: AGHT+IGtCkZgBF5pqtMmLUMVrqw32b4CdgnFah5aeNUHSeLlSjf8Ut4Hm04yUEafLCxrD2bsG9Xdhg==
X-Received: by 2002:a17:903:110d:b0:215:7e49:8202 with SMTP id d9443c01a7336-21dd7787cf4mr47776465ad.13.1738145598194;
        Wed, 29 Jan 2025 02:13:18 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da424eb96sm96579015ad.222.2025.01.29.02.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2025 02:13:17 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 3/4] mpi3mr: synchronous access b/w reset and tm thread for reply queue
Date: Wed, 29 Jan 2025 15:38:49 +0530
Message-Id: <20250129100850.25430-4-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250129100850.25430-1-ranjan.kumar@broadcom.com>
References: <20250129100850.25430-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

when the task management thread processes reply queues
while the reset thread resets them. The task management thread accesses
an invalid queue ID (0xFFFF), set by the reset thread, which points to
unallocated memory, causing a crash.

Flag "io_admin_reset_sync" is added to synchronize access
between the reset, IO, and admin threads. Before a reset, the
reset handler sets this flag to block IO and admin processing
threads. If any thread bypasses the initial check, the reset thread
waits up to 10 seconds for processing to finish. If the wait exceeds
10 seconds, the controller is marked as unrecoverable.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  2 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 67 +++++++++++++++++++++++++++++++--
 2 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 98db83e1cd12..8978c201c6f0 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1101,6 +1101,7 @@ struct scmd_priv {
  * @ts_update_interval: Timestamp update interval
  * @reset_in_progress: Reset in progress flag
  * @unrecoverable: Controller unrecoverable flag
+ * @io_admin_reset_sync: Manage state of I/O ops during an admin reset process
  * @prev_reset_result: Result of previous reset
  * @reset_mutex: Controller reset mutex
  * @reset_waitq: Controller reset  wait queue
@@ -1293,6 +1294,7 @@ struct mpi3mr_ioc {
 	u16 ts_update_interval;
 	u8 reset_in_progress;
 	u8 unrecoverable;
+	u8 io_admin_reset_sync;
 	int prev_reset_result;
 	struct mutex reset_mutex;
 	wait_queue_head_t reset_waitq;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 106f806b2c3d..08277ac992a6 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -17,7 +17,7 @@ static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
 	struct mpi3_ioc_facts_data *facts_data);
 static void mpi3mr_pel_wait_complete(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_drv_cmd *drv_cmd);
-
+static int mpi3mr_check_op_admin_proc(struct mpi3mr_ioc *mrioc);
 static int poll_queues;
 module_param(poll_queues, int, 0444);
 MODULE_PARM_DESC(poll_queues, "Number of queues for io_uring poll mode. (Range 1 - 126)");
@@ -459,7 +459,7 @@ int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
 	}
 
 	do {
-		if (mrioc->unrecoverable)
+		if (mrioc->unrecoverable || mrioc->io_admin_reset_sync)
 			break;
 
 		mrioc->admin_req_ci = le16_to_cpu(reply_desc->request_queue_ci);
@@ -554,7 +554,7 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 	}
 
 	do {
-		if (mrioc->unrecoverable)
+		if (mrioc->unrecoverable || mrioc->io_admin_reset_sync)
 			break;
 
 		req_q_idx = le16_to_cpu(reply_desc->request_queue_id) - 1;
@@ -4411,6 +4411,7 @@ int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
 		goto out_failed_noretry;
 	}
 
+	mrioc->io_admin_reset_sync = 0;
 	if (is_resume || mrioc->block_on_pci_err) {
 		dprint_reset(mrioc, "setting up single ISR\n");
 		retval = mpi3mr_setup_isr(mrioc, 1);
@@ -5289,6 +5290,55 @@ void mpi3mr_pel_get_seqnum_complete(struct mpi3mr_ioc *mrioc,
 	drv_cmd->retry_count = 0;
 }
 
+/**
+ * mpi3mr_check_op_admin_proc -
+ * @mrioc: Adapter instance reference
+ *
+ * It checks if any of the operation reply queues
+ * or the admin reply queue are currently in use.
+ * If any queue is in use, the function waits for
+ * a maximum of 10 seconds for them to become available.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+static int mpi3mr_check_op_admin_proc(struct mpi3mr_ioc *mrioc)
+{
+
+	u16 timeout = 10 * 10;
+	u16 elapsed_time = 0;
+	bool op_admin_in_use = false;
+
+	do {
+		op_admin_in_use = false;
+
+		/* Check admin_reply queue first to exit early */
+		if (atomic_read(&mrioc->admin_reply_q_in_use) == 1)
+			op_admin_in_use = true;
+		else {
+			/* Check op_reply queues */
+			int i;
+
+			for (i = 0; i < mrioc->num_queues; i++) {
+				if (atomic_read(&mrioc->op_reply_qinfo[i].in_use) == 1) {
+					op_admin_in_use = true;
+					break;
+				}
+			}
+		}
+
+		if (!op_admin_in_use)
+			break;
+
+		msleep(100);
+
+	} while (++elapsed_time < timeout);
+
+	if (op_admin_in_use)
+		return 1;
+
+	return 0;
+}
+
 /**
  * mpi3mr_soft_reset_handler - Reset the controller
  * @mrioc: Adapter instance reference
@@ -5369,6 +5419,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	mpi3mr_wait_for_host_io(mrioc, MPI3MR_RESET_HOST_IOWAIT_TIMEOUT);
 
 	mpi3mr_ioc_disable_intr(mrioc);
+	mrioc->io_admin_reset_sync = 1;
 
 	if (snapdump) {
 		mpi3mr_set_diagsave(mrioc);
@@ -5396,6 +5447,16 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 		ioc_err(mrioc, "Failed to issue soft reset to the ioc\n");
 		goto out;
 	}
+
+	retval = mpi3mr_check_op_admin_proc(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "soft reset is failed due to an Admin or I/O queue polling\n"
+				"thread was still processing replies even after 10 seconds\n"
+				"timeout, marking the controller as unrecoverable\n");
+
+		goto out;
+	}
+
 	if (mrioc->num_io_throttle_group !=
 	    mrioc->facts.max_io_throttle_group) {
 		ioc_err(mrioc,
-- 
2.31.1


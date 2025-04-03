Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299F4269CF2;
	Thu,  3 Apr 2025 19:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743707174; cv=none; b=JBoTbVhUowzQ2QUE9CrisBJ037As0mT9tH55QgTg+oRhJvHlgXq7JxSVoGDY0V60B5X8O1W9Hc+QelAsm03w32jz4s7Asxr7GlL6yxP61ZBxIMc37z4VBoqdvg18OLZAXMNRAjqc2uwo5qqeh/xVwntKPQ1RhT7W70F5NDcEPDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743707174; c=relaxed/simple;
	bh=LjR34AB69UXKxY+aOq9i9TK2nzzh8cR3idkYxkiERQU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eSUXuMZW8QltEu3smaYhsr0Fw7xQ3VZWd52a1n1JNzP6BHKjmzr3W7pyi+gB7WYHlEEankTLlCwS3exCb6p/06Rm90kNG7QXh5aV+wr2KYLq0KLKjN/M0IosijG8ayUp8OcdMjwFtFIZ9TVH3Wmi/NqLjmzAFTA6E+IC/qpwWsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S8zTiGWW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S8zTiGWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8723BC4CEE3;
	Thu,  3 Apr 2025 19:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743707174;
	bh=LjR34AB69UXKxY+aOq9i9TK2nzzh8cR3idkYxkiERQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S8zTiGWW1OlPvbYyldJoUeaWR1cOvQSGc9XGWWG7PhsSPGqckv60y87dGoaOaGndP
	 ueCxdv0vINa8Rm3VyzA0z5Y9bDZDAIf570azitdXbeVMHLMop0a1u6dJo3Y87AXlb4
	 3mwaLNZ0ya7IjaFJuA285gsCk9YI6UPOgviKnr30JLI663TTz7t7YM+pUxEgL4W6nZ
	 uABvMHFVqV0MKhRWrqjSJ9wOzkjcxkdT7ojIT87y1FU41+xidFOec1UsHbx05pK1SP
	 bbs54TIfdrNB+jOFc0TO7/DZsuDwLaaDpARWRt1Whx9Pj2YPZzPqlC1Rz9XxYs8vYf
	 Oe2+0NNexJXbg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com,
	sreekanth.reddy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 07/47] scsi: mpi3mr: Synchronous access b/w reset and tm thread for reply queue
Date: Thu,  3 Apr 2025 15:05:15 -0400
Message-Id: <20250403190555.2677001-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250403190555.2677001-1-sashal@kernel.org>
References: <20250403190555.2677001-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.21
Content-Transfer-Encoding: 8bit

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit f195fc060c738d303a21fae146dbf85e1595fb4c ]

When the task management thread processes reply queues while the reset
thread resets them, the task management thread accesses an invalid queue ID
(0xFFFF), set by the reset thread, which points to unallocated memory,
causing a crash.

Add flag 'io_admin_reset_sync' to synchronize access between the reset,
I/O, and admin threads. Before a reset, the reset handler sets this flag to
block I/O and admin processing threads. If any thread bypasses the initial
check, the reset thread waits up to 10 seconds for processing to finish. If
the wait exceeds 10 seconds, the controller is marked as unrecoverable.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20250129100850.25430-4-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  2 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 67 +++++++++++++++++++++++++++++++--
 2 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 1b049cea98e1f..ee5a75a4b3bb8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1097,6 +1097,7 @@ struct scmd_priv {
  * @ts_update_interval: Timestamp update interval
  * @reset_in_progress: Reset in progress flag
  * @unrecoverable: Controller unrecoverable flag
+ * @io_admin_reset_sync: Manage state of I/O ops during an admin reset process
  * @prev_reset_result: Result of previous reset
  * @reset_mutex: Controller reset mutex
  * @reset_waitq: Controller reset  wait queue
@@ -1285,6 +1286,7 @@ struct mpi3mr_ioc {
 	u16 ts_update_interval;
 	u8 reset_in_progress;
 	u8 unrecoverable;
+	u8 io_admin_reset_sync;
 	int prev_reset_result;
 	struct mutex reset_mutex;
 	wait_queue_head_t reset_waitq;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 656108dd2ee30..ec5b1ab287177 100644
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
@@ -4394,6 +4394,7 @@ int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
 		goto out_failed_noretry;
 	}
 
+	mrioc->io_admin_reset_sync = 0;
 	if (is_resume || mrioc->block_on_pci_err) {
 		dprint_reset(mrioc, "setting up single ISR\n");
 		retval = mpi3mr_setup_isr(mrioc, 1);
@@ -5252,6 +5253,55 @@ void mpi3mr_pel_get_seqnum_complete(struct mpi3mr_ioc *mrioc,
 	drv_cmd->retry_count = 0;
 }
 
+/**
+ * mpi3mr_check_op_admin_proc -
+ * @mrioc: Adapter instance reference
+ *
+ * Check if any of the operation reply queues
+ * or the admin reply queue are currently in use.
+ * If any queue is in use, this function waits for
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
@@ -5332,6 +5382,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	mpi3mr_wait_for_host_io(mrioc, MPI3MR_RESET_HOST_IOWAIT_TIMEOUT);
 
 	mpi3mr_ioc_disable_intr(mrioc);
+	mrioc->io_admin_reset_sync = 1;
 
 	if (snapdump) {
 		mpi3mr_set_diagsave(mrioc);
@@ -5359,6 +5410,16 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 		ioc_err(mrioc, "Failed to issue soft reset to the ioc\n");
 		goto out;
 	}
+
+	retval = mpi3mr_check_op_admin_proc(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "Soft reset failed due to an Admin or I/O queue polling\n"
+				"thread still processing replies even after a 10 second\n"
+				"timeout. Marking the controller as unrecoverable!\n");
+
+		goto out;
+	}
+
 	if (mrioc->num_io_throttle_group !=
 	    mrioc->facts.max_io_throttle_group) {
 		ioc_err(mrioc,
-- 
2.39.5


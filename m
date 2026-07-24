Received: from mail-vs1-f98.google.com (mail-vs1-f98.google.com [209.85.217.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB84138E5C8
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 10:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889171; cv=none; b=mtHYaUPjpO/VDMOSdc4c5lm8mQYxYjZ2nZABiFd/G34ejwwUhlIR57EGipVyzqSWptfVJwqu4/UmIQL8HOjvtBzCNYN/hsU+5WrARJhtgYtK/5VYwc36YUSqa7CHnkpFf6zN2Udn3PfEccWcyWXQemYBc5LCfS+YYwscsFFstRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889171; c=relaxed/simple;
	bh=Yk9MdCgAjXuTSbAwbafnR6XtwA1+2MW7qP2BxEHa+2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=quNk1nDb0NSWGG+nbKTVcnzxMmjbt1q0dKU517LvgV0a5Ie89qei48ZRUPu7YIdonDXyPqrMmFq3LOwAPPWGOymTy090OXooLNNMmhEAOYG07xPl/if/AOE3lX4Jx9609itf2NkRAxd1J77ekouHuNhl3IbHlvDe+RcrizSm0SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=F5lflAZH; arc=none smtp.client-ip=209.85.217.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="F5lflAZH"
Received: by mail-vs1-f98.google.com with SMTP id ada2fe7eead31-74ab99038afso181250137.3
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:32:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784889169; x=1785493969;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=afRH7sumgUkyFjn5HdDUGSH+z1OaYk4zhTI2kHrwOtQ=;
        b=N8BXP6ms9+5bYaer+rDwAxiVS5Shb3rqSdfSmu6el6VFsb6VGmZTvrYYiEp+l1vVZs
         mRxd+ibvf0UC4azLKIYaf1pIq6jZy5VS62FDs7/JxZf7LboNWT6rzpdRDJueDDkNfFsf
         tFf7ROl0Er8gEfW00Rk1VcVgcWOcBamqd3hHfC1jGhgN3tcc9jyDkbaEpK76fA8cgYI7
         O+7+KXfptBOxIQojNdwTP1r2tPa0WWRVW6/o10rpwL/Idvr+v5cbnixoTsHFsDYxBsrm
         SCMRVjGeTipNicK7UO8rkIxIzf2g5lLtf8C832R/bAJytvY0Sy+u152GaV2Xqk95CH5P
         SfFw==
X-Gm-Message-State: AOJu0YyM2in99twHJumf8HNtW/Kcy3ejJ54L6pvA0l6p28MLTcamb86v
	Cg/s1d7n8Hu4/bUsKeWWJQ0erCeFWCD5Osq1wnjEbRLJ12NG9y6HUPZf+WT7oDHs9O9i7tjLXH3
	I5z0XtwK3a8Qq1taF6cEe3iIM9a5Je8vIMPDjFFyh6l3WC/vlw+s1/8WwDMwkZ6Ve109iGARfX8
	HWwAvq2VEV50quGnsIX+17ucp4Isejus0SsAtlsQXAs2ODqMKqzejvwC15PGoQPBwZol5NCJ1Wx
	hGyC9UpM7nYMeNo
X-Gm-Gg: AR+sD10D8BOVvI3zMkn9NUX9XXkqb5jrPELvwDWs/JAQdJUGDxXDhLzQM1Hyu7Y5/tm
	Nh0N5I9wFppHQqIQ2WbvL6Af5qzqtEQvOWVfmfMpj3ap4U1J1mdH9o8myp1vDiBjG4r2c9NoP5U
	LqFryeBtTJybw6F0w2W7RvJbTOzHUtFMIqFuCE1gSOA4ygK1PRx2FSDyJ40jTwDhT39LzjB/JUj
	VNlLVit61qncYxRQhnyqp4kT/0Fjr/0tx+SunluA9EnDGqXh+/lXRUDsqi1/0G5KpYO6PKwWdwa
	5gVLWXwFQVOYmJbAMNP4J9MNMMeIPtdivApbQFsCW1JHPmZ6oFgF0TYhQCYiS4J8BHl3X6AnkxS
	HWwczyHVolkeh7cIojmlr207yc71dUi5cnZiWHXDBMbFJ9L9p/xIaGoDdnbJ+akAi4EXCU0Ik0C
	UATARn2BiDGT8hmpv2ZfUiULx2OdH6Lvx90ck=
X-Received: by 2002:a05:6102:808c:b0:728:aa5f:dc5f with SMTP id ada2fe7eead31-74d60b24496mr3542863137.25.1784889168638;
        Fri, 24 Jul 2026 03:32:48 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-22.dlp.protect.broadcom.com. [144.49.247.22])
        by smtp-relay.gmail.com with ESMTPS id ada2fe7eead31-74ad32478ddsm758380137.9.2026.07.24.03.32.48
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jul 2026 03:32:48 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb5cc1e13f8so371891a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784889167; x=1785493967; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=afRH7sumgUkyFjn5HdDUGSH+z1OaYk4zhTI2kHrwOtQ=;
        b=F5lflAZHvmfBpjx7gALIq6LkcVPvzBWYqALGiGTm8+Sm/sg2oaLS3ipbxc6v0xktVb
         j1BjqAvI25rOLRH0mIIrC+ucf/Wvzrk6ENHaTrMYxhyu2i8aH7vnRkAeMiiTNFH0sU5I
         xRB65o9RqMIjqa1n0gyc0090RlSdIiOPXgJ6Y=
X-Received: by 2002:a05:6a21:4ccb:b0:3c3:f371:1ea9 with SMTP id adf61e73a8af0-3c44afb570fmr7771085637.10.1784889167459;
        Fri, 24 Jul 2026 03:32:47 -0700 (PDT)
X-Received: by 2002:a05:6a21:4ccb:b0:3c3:f371:1ea9 with SMTP id adf61e73a8af0-3c44afb570fmr7771052637.10.1784889166903;
        Fri, 24 Jul 2026 03:32:46 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e1cf8fasm30233211eec.31.2026.07.24.03.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 03:32:46 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v3 05/10] mpi3mr: Fix performance regression caused by extended IRQ poll sleep
Date: Fri, 24 Jul 2026 15:55:00 +0530
Message-ID: <20260724102505.115136-6-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260724102505.115136-1-ranjan.kumar@broadcom.com>
References: <20260724102505.115136-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Commit 24d7071d9645 ("scsi: mpi3mr: A performance fix") increased the
threaded IRQ poll sleep range from 2-20 us to 20-21 us to work around a
timer slack issue.

On kernels unaffected by the timer slack issue, the longer sleep interval
reduces reply queue processing efficiency and causes an approximately 7%
throughput regression on NVMe direct-attached RAID10 configurations.

Restore the IRQ poll sleep range to 2-20 us to recover the lost
throughput.

Additionally, resolve the following issues in the reply queue processing
and polling logic:

1. Add missing dma_rmb() memory barriers in the admin and operational
   reply queue processing loops. This ensures that the descriptor
   payload is only read after the phase bit check is complete, preventing
   weakly ordered architectures from speculatively processing stale data.

2. Add bounds checking for `request_queue_id` in
   mpi3mr_process_op_reply_q() to prevent out-of-bounds memory
   corruption if the hardware provides an invalid queue ID.

3. Fix a TOCTOU race condition in mpi3mr_process_op_reply_q() by
   implementing a double-check pattern with dma_rmb() and
   atomic_add_unless() when exiting the loop. This prevents lost
   interrupts if a descriptor arrives exactly as the thread drops the
   in_use lock.

4. Replace a direct panic() call with a safe ioc_err() log and abort in
   mpi3mr_process_op_reply_desc() when mpi3mr_get_reply_virt_addr()
   returns NULL. This prevents a single malformed DMA reply address from
   crashing the entire host OS.

Note: The unbounded busy-wait loop (usleep_range) in mpi3mr_isr_poll()
flagged by automated review is intentionally retained. This short sleep
polling mechanism is critical for batching completions and achieving the
target throughput on high-performance NVMe configurations.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@broadcom.com?part=5
Closes: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar@broadcom.com?part=5
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  2 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 56 ++++++++++++++++++++++++++++++---
 drivers/scsi/mpi3mr/mpi3mr_os.c |  3 +-
 3 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 1f2f0951b560..1d11d7c69536 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -178,7 +178,7 @@ extern atomic64_t event_counter;
 #define MPI3MR_DEFAULT_SDEV_QD	32
 
 /* Definitions for Threaded IRQ poll*/
-#define MPI3MR_IRQ_POLL_SLEEP			20
+#define MPI3MR_IRQ_POLL_SLEEP			2
 #define MPI3MR_IRQ_POLL_TRIGGER_IOCOUNT		8
 
 /* Definitions for the controller security status*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 434b66f7b502..9f7cee26ebcd 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -473,6 +473,12 @@ int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
 		return 0;
 	}
 
+	/*
+	 * Ensure that the descriptor payload is read only after
+	 * the phase bit check is complete.
+	 */
+	dma_rmb();
+
 	do {
 		if (mrioc->unrecoverable || mrioc->io_admin_reset_sync)
 			break;
@@ -493,6 +499,13 @@ int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
 		if ((le16_to_cpu(reply_desc->reply_flags) &
 		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) != exp_phase)
 			break;
+
+		/*
+		 * Ensure that the descriptor payload is read only after
+		 * the phase bit check is complete.
+		 */
+		dma_rmb();
+
 		if (threshold_comps == MPI3MR_THRESHOLD_REPLY_COUNT) {
 			writel(admin_reply_ci,
 			    &mrioc->sysif_regs->admin_reply_queue_ci);
@@ -565,14 +578,33 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 	if ((le16_to_cpu(reply_desc->reply_flags) &
 	    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) != exp_phase) {
 		atomic_dec(&op_reply_q->in_use);
+		/* Check for a TOCTOU race condition */
+		dma_rmb();
+		if ((le16_to_cpu(reply_desc->reply_flags) &
+		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) == exp_phase) {
+			if (atomic_add_unless(&op_reply_q->in_use, 1, 1))
+				goto process_desc;
+		}
 		return 0;
 	}
+process_desc:
+	/*
+	 * Ensure that the descriptor payload is read only after
+	 * the phase bit check is complete.
+	 */
+	dma_rmb();
 
 	do {
 		if (mrioc->unrecoverable || mrioc->io_admin_reset_sync)
 			break;
 
 		req_q_idx = le16_to_cpu(reply_desc->request_queue_id) - 1;
+
+		if (unlikely(req_q_idx >= mrioc->num_op_req_q)) {
+			ioc_err(mrioc, "Invalid request queue id %d\n", req_q_idx + 1);
+			break;
+		}
+
 		op_req_q = &mrioc->req_qinfo[req_q_idx];
 
 		WRITE_ONCE(op_req_q->ci, le16_to_cpu(reply_desc->request_queue_ci));
@@ -592,8 +624,23 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 		reply_desc = mpi3mr_get_reply_desc(op_reply_q, reply_ci);
 
 		if ((le16_to_cpu(reply_desc->reply_flags) &
-		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) != exp_phase)
+		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) != exp_phase) {
+			atomic_dec(&op_reply_q->in_use);
+			/* Check for a TOCTOU race condition */
+			dma_rmb();
+			if ((le16_to_cpu(reply_desc->reply_flags) &
+			    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) == exp_phase) {
+				/* Descriptor arrived, try to reclaim ownership */
+				if (atomic_add_unless(&op_reply_q->in_use, 1, 1))
+					continue;
+			}
 			break;
+		}
+		/*
+		 * Ensure that the descriptor payload is read only after
+		 * the phase bit check is complete.
+		 */
+		dma_rmb();
 #ifndef CONFIG_PREEMPT_RT
 		/*
 		 * Exit completion loop to avoid CPU lockup
@@ -743,11 +790,12 @@ static irqreturn_t mpi3mr_isr_poll(int irq, void *privdata)
 			num_op_reply +=
 			    mpi3mr_process_op_reply_q(mrioc,
 				intr_info->op_reply_q);
+		if (!atomic_read(&intr_info->op_reply_q->pend_ios))
+			break;
 
-		usleep_range(MPI3MR_IRQ_POLL_SLEEP, MPI3MR_IRQ_POLL_SLEEP + 1);
+		usleep_range(MPI3MR_IRQ_POLL_SLEEP, 10 * MPI3MR_IRQ_POLL_SLEEP);
 
-	} while (atomic_read(&intr_info->op_reply_q->pend_ios) &&
-	    (num_op_reply < mrioc->max_host_ios));
+	} while (num_op_reply < mrioc->max_host_ios);
 
 	intr_info->op_reply_q->enable_irq_poll = false;
 	enable_irq(intr_info->os_irq);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 7b86152922ba..39624fae9131 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3426,8 +3426,7 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 		scsi_reply = mpi3mr_get_reply_virt_addr(mrioc,
 		    *reply_dma);
 		if (!scsi_reply) {
-			panic("%s: scsi_reply is NULL, this shouldn't happen\n",
-			    mrioc->name);
+			ioc_err(mrioc, "scsi_reply is NULL, invalid reply_frame_address\n");
 			goto out;
 		}
 		host_tag = le16_to_cpu(scsi_reply->host_tag);
-- 
2.47.3


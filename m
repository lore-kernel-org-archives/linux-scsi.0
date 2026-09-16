Received: from mail-ot1-f99.google.com (mail-ot1-f99.google.com [209.85.210.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D5F4734EF
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 08:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547731; cv=none; b=sx3Ldd6I3lAxe0+POz1Ptqk1wn1ELXHI5FpeJXLzD7ZYE4RG82Wz33jOYuRRPdIcQIx3wHwFv7XYu4YN89Y20HFdS0XmfyYJRusBV1GBIWUBIQ1UL94jHPU7KxElTOW0faawkoT3qcmQVxC36TdNGpBVa+x6hlAP5k4Gx1oyKG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547731; c=relaxed/simple;
	bh=5MwsggpjuRyP7fsNqpQdNQ+864KC93v6Wh7Ktslcljg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRgEYMvJPBPHhsqwTMCQf5fhNQY17hC6RZ7g/niLpH5TsTSHwAaSfE/3LujFJ5yN5IG3ozhLSmtBkYa+JMCeK7rigxSG54PQnE4h8tBjn8HKNwYz3AKoJxOgBL79qR5Qvp/lFTE4fpxYvU9pQu6yXJ4/XVoHt1Kyyt/qNW712Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=T3p0hbZ0; arc=none smtp.client-ip=209.85.210.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="T3p0hbZ0"
Received: by mail-ot1-f99.google.com with SMTP id 46e09a7af769-80638c24bedso1333332a34.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 01:35:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789547727; x=1790152527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QE0VDIWIrRtmhSEit+f3BHKahXtNTGRkGeD0ixWnHnA=;
        b=QHDIZacXHNPDHwXZv9FCnzLVOX1WsSExFXBKjYs0t/zgYlcd34o4d6SbIRd1p2wJep
         b96WgSn9VeuKewprVEA/3AnXRtIjKAVPW9vkqZLOczu5KTsgcptNdrr4PcTka1mMp9YH
         Ok79wO7Dcf/d6LHs3CzTNdtXRxcFFLWjmUTZypKO+TaqOevSCnfz0ibFqGfTnMF07mWf
         U+PJpsriAVvH5txHgB2Ohrm13eHVECO4i6WNPldV9UgfxRtHRGS6mUXKUmoTd+8KRtmb
         n7YiQelnKudPl7C61/MgyVGxQ4R8z0kg3Vvlxh2ZiLrstn4mXhmjb7BjamSwYBu+BPem
         EeWA==
X-Gm-Message-State: AFuF++k+IVNSLTqZ+e2LlQiDITYgWRoWINuOiDfwVWVimdzCOBlknFql
	CXmieIWei71nMYsdqn+JvOJR26VvKRnD+NUKphUigBlVS8eXr4YfT2w13hQbWuAAoiCmiLR6A+j
	MDfArL9a0LIFJdL57jBFFL6JyLFkh0IzAJ3GssMfaNyJry8R1UXowtr+A2YkQYNpGF+j087/3Ch
	HMG5TCFbWOcbBS3iDGSuioJslvL7cS/0PXICT3eoyR7wKAHTHOarBOqZZJbAeE/N03Tze6VsUDS
	oZHifjM0ZhsV612
X-Gm-Gg: AYBFou0vVw9kvz73Q+ai9YJUtUS2cGp2pb0EUBnUkYvraXuE7jasKMfrrCSSbJurw1U
	oAZj9SE6lIsjO/izfHLN8QHAO5I6pikXNDLBntXIjdzZIgAyaF7VKeUOotFiDI3HJprmulMQQgp
	8LIHvhKmv/Ji4t8kln1iEINoqMEUC8RC1NzQWkRy2BpOi4hVyYKyWpyzUNNpAKSX03yfGLE+KZC
	uCY1BNCIBnu0ybDsy00HgERD6t626pgs0LaVcrbDzp45lrlcMQEnEommR9kObDTQ9RwiOUJ/3pQ
	CIuiuffplZexnpAgk6gzsalqniskr7xpNBkUgpBDD6IUI6d/EdVu6daVLGtKDkoH2+V2o1tAHVk
	LNbreaxVnwS3bRI3P2K9qXahsk73Ahi44L2dFnKAD+Nv3acT6fsHJmJwdwvgktpPS//3wN6Eg37
	/fN2+1q5evHx7Pxbxyd/GrkahzSa736QwyO5gIXw==
X-Received: by 2002:a05:6830:18c7:b0:7f9:5a3:c246 with SMTP id 46e09a7af769-80984aa09afmr3529896a34.29.1789547727511;
        Wed, 16 Sep 2026 01:35:27 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-80b06cafc58sm1025496a34.3.2026.09.16.01.35.27
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2026 01:35:27 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-39af92138f9so3421763a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 01:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789547726; x=1790152526; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QE0VDIWIrRtmhSEit+f3BHKahXtNTGRkGeD0ixWnHnA=;
        b=T3p0hbZ09WYdZ0wPz9sAUqWhznBjGcs/NhXUYpXjHKJc5fpPKa1R6J3iU+2Pj3+Imx
         m4PUxDNLQNRpCPq0057idt7m3rdMJ6/OGMW88uZ1f2e2eUo91eC/DNueYPMAaqxxr9u6
         gWis8Ys8FJ4QoAdwEtM2w1HuzGWpEd/XxOxqo=
X-Received: by 2002:a17:90b:33c8:b0:398:c6e1:dceb with SMTP id 98e67ed59e1d1-39dfe036433mr10791089a91.9.1789547725899;
        Wed, 16 Sep 2026 01:35:25 -0700 (PDT)
X-Received: by 2002:a17:90b:33c8:b0:398:c6e1:dceb with SMTP id 98e67ed59e1d1-39dfe036433mr10791021a91.9.1789547725215;
        Wed, 16 Sep 2026 01:35:25 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5ac47cfsm5226261eec.17.2026.09.16.01.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 01:35:24 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v5 05/10] mpi3mr: Fix performance regression caused by extended IRQ poll sleep
Date: Wed, 16 Sep 2026 13:57:00 +0530
Message-ID: <20260916082705.44712-6-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260916082705.44712-1-ranjan.kumar@broadcom.com>
References: <20260916082705.44712-1-ranjan.kumar@broadcom.com>
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

Restore the IRQ poll sleep base to 2 us (widening the usleep_range() upper
bound to 10x the base instead of a fixed +1 us) to recover the lost
throughput, and skip the sleep entirely once pend_ios reaches 0 so the
poll loop exits immediately at the tail of a completion burst.

Additionally, resolve the following issues in the reply queue processing
and polling logic:

1. Add missing dma_rmb() memory barriers in the admin and operational
   reply queue processing loops. This ensures that the descriptor
   payload is only read after the phase bit check is complete, preventing
   weakly ordered architectures from speculatively processing stale data.

2. Add bounds checking for `request_queue_id` in
   mpi3mr_process_op_reply_q(). An out-of-range id is now logged and the
   descriptor is retired (consumer index advanced, phase toggled on
   wraparound) rather than aborting the loop in place, which previously
   left the same corrupted descriptor at the head of the ring forever
   and stalled polling indefinitely. It is not counted toward pend_ios,
   since no real completion was processed for it.
3. Recheck for a late-arriving descriptor via dma_rmb() while still
   holding op_reply_q->in_use, instead of releasing it and reclaiming
   it afterward, which could race and reprocess a descriptor with
   stale indices or double-decrement in_use.
4. Replace a direct panic() call with a safe ioc_err() log and abort in
   mpi3mr_process_op_reply_desc() when mpi3mr_get_reply_virt_addr()
   returns NULL. This prevents a single malformed DMA reply address from
   crashing the entire host OS. The reply_dma output parameter is also
   cleared before returning, since it was already populated with the
   unvalidated address before the NULL check. Leaving it set would make
   the caller repost that unvalidated address back to the hardware.

Note: The unbounded busy-wait loop (usleep_range) in mpi3mr_isr_poll()
flagged by automated review is intentionally retained. This short sleep
polling mechanism is critical for batching completions and achieving the
target throughput on high-performance NVMe configurations.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@broadcom.com?part=5
Closes: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar@broadcom.com?part=5
Closes: https://sashiko.dev/#/patchset/20260724102505.115136-1-ranjan.kumar@broadcom.com?part=5
Closes: https://sashiko.dev/#/patchset/20260805110634.346670-1-ranjan.kumar@broadcom.com?part=5
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  2 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 54 ++++++++++++++++++++++++++++++---
 drivers/scsi/mpi3mr/mpi3mr_os.c |  8 +++--
 3 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 6128b30112e2..4d19a9460d38 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -179,7 +179,7 @@ extern atomic64_t event_counter;
 #define MPI3MR_DEFAULT_SDEV_QD	32
 
 /* Definitions for Threaded IRQ poll*/
-#define MPI3MR_IRQ_POLL_SLEEP			20
+#define MPI3MR_IRQ_POLL_SLEEP			2
 #define MPI3MR_IRQ_POLL_TRIGGER_IOCOUNT		8
 
 /* Definitions for the controller security status*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index d8a68d7fdf19..51ddcc1008c2 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -489,6 +489,12 @@ int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
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
@@ -509,6 +515,13 @@ int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
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
@@ -580,15 +593,33 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 	reply_desc = mpi3mr_get_reply_desc(op_reply_q, reply_ci);
 	if ((le16_to_cpu(reply_desc->reply_flags) &
 	    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) != exp_phase) {
+		/* Recheck under in_use before releasing, to avoid a reclaim race */
+		dma_rmb();
+		if ((le16_to_cpu(reply_desc->reply_flags) &
+		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) == exp_phase)
+			goto process_desc;
 		atomic_dec(&op_reply_q->in_use);
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
+			ioc_err(mrioc, "Invalid request queue id %d, skipping reply\n",
+			    req_q_idx + 1);
+			goto next_reply;
+		}
+
 		op_req_q = &mrioc->req_qinfo[req_q_idx];
 
 		WRITE_ONCE(op_req_q->ci, le16_to_cpu(reply_desc->request_queue_ci));
@@ -597,8 +628,9 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 
 		if (reply_dma)
 			mpi3mr_repost_reply_buf(mrioc, reply_dma);
-		num_op_reply++;
 		threshold_comps++;
+next_reply:
+		num_op_reply++;
 
 		if (++reply_ci == op_reply_q->num_replies) {
 			reply_ci = 0;
@@ -608,8 +640,19 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 		reply_desc = mpi3mr_get_reply_desc(op_reply_q, reply_ci);
 
 		if ((le16_to_cpu(reply_desc->reply_flags) &
-		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) != exp_phase)
+		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) != exp_phase) {
+			dma_rmb();
+			if ((le16_to_cpu(reply_desc->reply_flags) &
+			    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) == exp_phase)
+				goto reply_ready;
 			break;
+		}
+reply_ready:
+		/*
+		 * Ensure that the descriptor payload is read only after
+		 * the phase bit check is complete.
+		 */
+		dma_rmb();
 #ifndef CONFIG_PREEMPT_RT
 		/*
 		 * Exit completion loop to avoid CPU lockup
@@ -759,11 +802,12 @@ static irqreturn_t mpi3mr_isr_poll(int irq, void *privdata)
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
index 5506fc87f1ca..7e59773c0276 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3493,8 +3493,12 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 		scsi_reply = mpi3mr_get_reply_virt_addr(mrioc,
 		    *reply_dma);
 		if (!scsi_reply) {
-			panic("%s: scsi_reply is NULL, this shouldn't happen\n",
-			    mrioc->name);
+			ioc_err(mrioc, "scsi_reply is NULL, invalid reply_frame_address\n");
+			/*
+			 * Do not let the caller repost an address that
+			 * failed virt-addr lookup back to the hardware.
+			 */
+			*reply_dma = 0;
 			goto out;
 		}
 		host_tag = le16_to_cpu(scsi_reply->host_tag);
-- 
2.47.3


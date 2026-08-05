Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2CC4314AE
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 11:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785928470; cv=none; b=cALz0bOnuMH9m2QfZUDMdVTA2C0JdOtJrHmm7V0g4yGgLMrP35fkLull5ePI/StxNOahVJvap9mINdN5W/5/lisX7CxLLRnBrxL+2t66Qg6/2w2wkn4wwb5gHw88L4WjvL8IJKWG1ZNhq5rfxLT9F9kbVzX0RoIrE9wF5k/Z9M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785928470; c=relaxed/simple;
	bh=yC45xs2GKPojCVnbGXVenfKiaVOWf5JNz7YTsX8XC1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evbUCgwA4Vvn1Ygt/TwKz9rCDlaHUAo36NXPMNBZWyndZN1gY/MG/PP21P87B5fx99xf+Jt1kjbUIAUH1wMotitEXA88lzBVi+Rx7R2QB90m2OPwNn496m7ligyMg9Gs5uNGoaxQXCMbLvCXAhI4lD9YQu35ByUsMRSZCSKFbEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=FJuQz1qO; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="FJuQz1qO"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-38dcbade417so661701a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2026 04:14:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785928468; x=1786533268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ThfBF1H8cB/CTsva5VCXoR1f/Qt1tCliQHBOivaqZks=;
        b=aFysX6CukMAHdF7CawIhqReb/uaa4ORetRSIXwmQTn/rCOrazH7kSCCh9dMF2vmc7O
         +HJX49CRxXVZIhTnxWkk8s++SaibKpV6dlpoklsazFIFT90wHwV4rvTib6mL0nagDdvf
         jjoaRMJk4IgenRkXU4TNbbmE4BZRKlcwdyKeKbFTCZhyApoNdYf/3Bxsl1aAW/8Ea4II
         dZ1fJnNnqfzD2XpoGxjDjRApQaB+fB/21knkvd+IEMpjZegWQ6VWGIYF1dEnoc3Y401X
         81fDdmitGVA9lap+LWcZ0mCOggoUcs52wuzTGwRKYT0FyAnqIIcQA4QESE6xKpDRhdlH
         pxjg==
X-Gm-Message-State: AOJu0Yxrhyer4D6GkpqNh8zlBHk05Vh6eX0peLjI2X0qCR4cUWwFtlzz
	2AqLc5TXwSDXsS2m2EnD2m0+yAa66ebs3JSM38MBHh38ha4sgP1r+x9bBKLPDUTlJN7EJCUhQCQ
	PoG+tOtS1cVgj1VUFjuQwRAopozJrzL5HIzzI288l1sVNVqWASUY1IUyiXBrYOyHP3I2bUyg/lM
	w/FTO4uV27Qry/Pto1CADPU5wDFF6Do3GDpzS+4YyJsS+NcwVUGadUeoxhb6jLJ6LS/BNro8yyQ
	4P42ilI8bZyWacb
X-Gm-Gg: AR+sD13+xA67no3YO/KjZuc0f77JAVt2+RYR843wBf1rEXPmlx4z+pySuDfkc646Zfg
	/sJ+ocLnXFBR2TGHDYxa9aaQglMb5hUW2OCRpEoJBE21iqjeDzaRJMJdMDzwxEkJ0/1wgeGvTd6
	7pjusbPJJB9NoYJvfTtZNmP4PGbaFol7tLA48P58VkMhL4x6MyKefCtX9VtbIUqGu+2Ks0AOtrs
	FTyj6h0AK3Uszyodq+E4jYAsiTwYmOeVwTZWBCPWhKEwS/kxuK/tAigh0NHE/RxjD0ZtCR88J1u
	F78ct4815/d3bwvn9x8r0i/TVo/UZLWD/UyYWJN3n55gr0rVV65X7MzXukr5SG4O8e1IotLhwmH
	lhmL8jXshDjyq5VRfWnAfi8lZ7cUJUJFvzbb8GgA5WPKx0FVsHDtWnrC/GFkX2y/Tybs1hfZ8nK
	B60WQzaN5HHa8hwmlMX7G8grIPUBBnnCNJUf4=
X-Received: by 2002:a17:90b:4d8c:b0:381:6c5:3f63 with SMTP id 98e67ed59e1d1-3903c544f17mr5106888a91.6.1785928467886;
        Wed, 05 Aug 2026 04:14:27 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-22.dlp.protect.broadcom.com. [144.49.247.22])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-38febce7bc6sm1102355a91.0.2026.08.05.04.14.27
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Aug 2026 04:14:27 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cb7d6ba548eso996010a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2026 04:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785928466; x=1786533266; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ThfBF1H8cB/CTsva5VCXoR1f/Qt1tCliQHBOivaqZks=;
        b=FJuQz1qOu470ot47y2fdxogORZJzsCGC4RBS+3LWvMpEn8DUu3YZE8QUmuo/pVmIDz
         xzSS7LFSZRDXv2ZeOzswpwHAZEaoDr63uFCC0zAITuHFlEzw1bMcuGCObn3QKSvMo44b
         ccgFIbyqdXFbpa3sGQd7FtDXPC/SWj9aLMt70=
X-Received: by 2002:a05:6300:220a:b0:3c3:7cfe:b32a with SMTP id adf61e73a8af0-3cb85ea6fb0mr7647426637.27.1785928466000;
        Wed, 05 Aug 2026 04:14:26 -0700 (PDT)
X-Received: by 2002:a05:6300:220a:b0:3c3:7cfe:b32a with SMTP id adf61e73a8af0-3cb85ea6fb0mr7647340637.27.1785928465438;
        Wed, 05 Aug 2026 04:14:25 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3158673b7f4sm16740227eec.17.2026.08.05.04.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 04:14:24 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v4 05/10] mpi3mr: Fix performance regression caused by extended IRQ poll sleep
Date: Wed,  5 Aug 2026 16:36:29 +0530
Message-ID: <20260805110634.346670-6-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260805110634.346670-1-ranjan.kumar@broadcom.com>
References: <20260805110634.346670-1-ranjan.kumar@broadcom.com>
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
   wraparound, pend_ios/threshold accounted) rather than aborting the
   loop in place, which previously left the same corrupted descriptor
   at the head of the ring forever and stalled polling indefinitely.

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
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  2 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 52 ++++++++++++++++++++++++++++++---
 drivers/scsi/mpi3mr/mpi3mr_os.c |  8 +++--
 3 files changed, 55 insertions(+), 7 deletions(-)

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
index 434b66f7b502..e6050b41e15a 100644
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
@@ -564,15 +577,33 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
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
@@ -581,6 +612,7 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 
 		if (reply_dma)
 			mpi3mr_repost_reply_buf(mrioc, reply_dma);
+next_reply:
 		num_op_reply++;
 		threshold_comps++;
 
@@ -592,8 +624,19 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
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
@@ -743,11 +786,12 @@ static irqreturn_t mpi3mr_isr_poll(int irq, void *privdata)
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
index 88b1d6360dac..23a6a5e3df5f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3430,8 +3430,12 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
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


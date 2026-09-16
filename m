Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0065F477E3B
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 08:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547733; cv=none; b=lCdpKal7C+vW2JwkBz5xMbTJ78vGmPUFof0cbWE6eqpOw4hkVmR7977+E9HInLUw4CKAaSST/fffHqWHEQR8h7z5J15oo/YesYCOH6c0IgRCEIkbDgzUMPhzrhOJaSeDJm4wR0T/u9UG71yxzBj5OzDOp38JLX4tQBWgydiT460=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547733; c=relaxed/simple;
	bh=NZaju0GnL+ry7GLvIuKXJBKbbN0Kn5R4KiHZziSs1M4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLFjeZHx8xtmxcMrsfu34/mnxuX1081vzifjPzrk7XdYkB9MVewzmLVksiuqBz5aPxc0Cv7ZrnxEyjQw4YfhkL81KlH/cTKimiDmCSQFPtP2KU2/FFluV3K46BidSMCeQl/3x3McrCLjYEz9xUk5pC+bZLI9k/Y7yPJdZmuDfB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=ft3GwJGa; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ft3GwJGa"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-39b24d114d4so3116540a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 01:35:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789547731; x=1790152531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xlf3FbQnyoFnHpFPbud+QdmlSV/+u4Ji6zKVcJ6ltt8=;
        b=VYqiCF1Lck6jkjC3MPUUsF0DuougBxlyBVArlNcKa7ylorhuj0jsi3LB09I+yNpRJt
         cAe1EoGGOAcKWxLO6g37AIqBUEv4uQFyUxfOc6dVbmsDreuNRWVmKxSFA9LV1jIswdAH
         6aO9AiaJPYZM797LCvv7ziWWO0/KOtArWlpaEmRX4RS7p5fOk0q4/JxeTeWTyMWbJH3W
         vGo+MectwcLDIAjNU6uFkI2I0OoC3W9pkW4pJ1z4BfZ+EW47atHrPaZ0wOp06T/b/0GQ
         E3Av35M6I7IEXVM5JtadQIsycKZnZN/uB/1XDEhLg43oaHEfAuTIoGnA/91fC5Uzi42o
         TxXw==
X-Gm-Message-State: AFuF++lRPo3o17mkeIO/ywcpyRjKfaLR8TR+NeWbjpjXBm20uIK4jTEU
	UwPqZLdoLG1cAsIvZyiQKj6GcblAdPAaogshoSY1RgiPyR/QcCmyUNyt/NHNG/ZaDA33TGzr0+u
	fmyB/ynZsaFo8lp0rbwGeOMRgoIF0/HC+bF+GE3sgrVaY72l2KZP+N38/4sqGB2ax9xqrAhaNwM
	8V08MLvkCG50JImgrDrb0r0NZszpNVcJ2y4FHlYOngA1FlWsjHXhNQt9EavJFTVvtNT5ZpXUIIT
	Kj+FEibfHZQtFeJ
X-Gm-Gg: AYBFou3i46S/ybFG7q0VjpA31/y0OJwi5rZPjNlXznTnLRx787gRK9UKjLspwhlIUkT
	B6FJZsxluURhDow+UddNYb+JFMt3lNJDcjiV1vDumAbL+qvndDRUFY0aIjPvwUlvf8v/Udw+lt8
	pzOSl+Yfm1Y8f6+8lBLeh5oI233qKawxViJGe/ic8Ys0t9N1mwKVOYTn3XNvDK/glMunbaOUe2b
	8ys5bxlsowzsFqPhIzCrf2PY5h2xVyA91vtXHadcuT8+13KNrS8TxmUkV8UhIn47FzHB1BrYAYd
	PRupkfgjSqzUfdV9gw4XyuRofbdK3cCx36CMVGVX63wmzO5VkhFXcg9hUu+oqylwYlSpz6xJkUB
	PD781eA2GwUkIpK/VdQSBQMIPfPjJvc1bE7wiy/yxpXTjS/GHoxjkIxjLImqruCXUuhrrwIA4h+
	vazFFYiUOT5aCN9SU4BaG5qUXnSEJF1YU+w/g=
X-Received: by 2002:a17:90b:54cb:b0:37f:c22a:c188 with SMTP id 98e67ed59e1d1-39e1e25ac28mr4241531a91.4.1789547731127;
        Wed, 16 Sep 2026 01:35:31 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39e1b6e46e6sm1053838a91.3.2026.09.16.01.35.30
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2026 01:35:31 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4b28d9206f8so3175503b6e.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 01:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789547729; x=1790152529; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xlf3FbQnyoFnHpFPbud+QdmlSV/+u4Ji6zKVcJ6ltt8=;
        b=ft3GwJGa64/dJS4qZlfq/w5pD6d+1eUP/dBeSJh6TApC4jyuDc4NkTQ8GumeHzwZoF
         dUeNWWA3b+3AKEMH7nelUtXyZjP+jKmgLB9DhFp0M3jFoeLgaZmcEIeJ6ZBOmnyVSi6l
         uDXN3cD2APYFdhiM5nGPZ/TN7MghSQx7NlrMI=
X-Received: by 2002:a05:6808:1443:b0:4b9:e5fa:8a16 with SMTP id 5614622812f47-4ca4b9701a8mr1762825b6e.27.1789547729477;
        Wed, 16 Sep 2026 01:35:29 -0700 (PDT)
X-Received: by 2002:a05:6808:1443:b0:4b9:e5fa:8a16 with SMTP id 5614622812f47-4ca4b9701a8mr1762801b6e.27.1789547728871;
        Wed, 16 Sep 2026 01:35:28 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5ac47cfsm5226261eec.17.2026.09.16.01.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 01:35:28 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v5 06/10] mpi3mr: Fix memory leak on operational queue creation failure
Date: Wed, 16 Sep 2026 13:57:01 +0530
Message-ID: <20260916082705.44712-7-ranjan.kumar@broadcom.com>
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

When operational queue creation fails after one or more queues have
been created, the error path frees the queue information arrays but
does not release the DMA memory segments associated with the created
queues, resulting in a memory leak. Fix this by ensuring that partially
allocated segments are freed immediately if a queue fails to create.

Additionally, resolve the following issues in the queue segment
free/alloc paths:

1. Clear mrioc->intr_info[].op_reply_q with WRITE_ONCE() and follow it
   with synchronize_irq() before freeing segments, and have the ISR
   paths read it once via READ_ONCE() into a local, to close a race
   where the ISR could use the pointer while it is being freed.

2. Free q_segment_list before checking q_segments in both free
   functions, since a kzalloc_objs() failure on q_segments left
   q_segment_list leaked via the early return.

3. The threaded poll handler returned without re-enabling the
   interrupt when the reply queue was already gone, leaving that
   interrupt line permanently masked. It now re-enables it before
   returning.

4. Two other callers read the same pointer without a NULL check,
   which could now be reached with a NULL value. Add the check at
   the single point they both call through, and read the pointer
   consistently with the writer above.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@broadcom.com?part=6
Closes: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar@broadcom.com?part=6
Closes: https://sashiko.dev/#/patchset/20260724102505.115136-1-ranjan.kumar@broadcom.com?part=6
Closes: https://sashiko.dev/#/patchset/20260805110634.346670-1-ranjan.kumar@broadcom.com?part=6
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 91 ++++++++++++++++++++++++---------
 drivers/scsi/mpi3mr/mpi3mr_os.c |  2 +-
 2 files changed, 68 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 51ddcc1008c2..d63870b087bc 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -582,6 +582,9 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 	struct mpi3_default_reply_descriptor *reply_desc;
 	u16 req_q_idx = 0, reply_qidx, threshold_comps = 0;
 
+	if (!op_reply_q)
+		return 0;
+
 	reply_qidx = op_reply_q->qid - 1;
 
 	if (!atomic_add_unless(&op_reply_q->in_use, 1, 1))
@@ -714,6 +717,7 @@ static irqreturn_t mpi3mr_isr_primary(int irq, void *privdata)
 {
 	struct mpi3mr_intr_info *intr_info = privdata;
 	struct mpi3mr_ioc *mrioc;
+	struct op_reply_qinfo *op_reply_q;
 	u16 midx;
 	u32 num_admin_replies = 0, num_op_reply = 0;
 
@@ -729,9 +733,9 @@ static irqreturn_t mpi3mr_isr_primary(int irq, void *privdata)
 
 	if (!midx)
 		num_admin_replies = mpi3mr_process_admin_reply_q(mrioc);
-	if (intr_info->op_reply_q)
-		num_op_reply = mpi3mr_process_op_reply_q(mrioc,
-		    intr_info->op_reply_q);
+	op_reply_q = READ_ONCE(intr_info->op_reply_q);
+	if (op_reply_q)
+		num_op_reply = mpi3mr_process_op_reply_q(mrioc, op_reply_q);
 
 	if (num_admin_replies || num_op_reply)
 		return IRQ_HANDLED;
@@ -744,6 +748,7 @@ static irqreturn_t mpi3mr_isr_primary(int irq, void *privdata)
 static irqreturn_t mpi3mr_isr(int irq, void *privdata)
 {
 	struct mpi3mr_intr_info *intr_info = privdata;
+	struct op_reply_qinfo *op_reply_q;
 	int ret;
 
 	if (!intr_info)
@@ -756,11 +761,12 @@ static irqreturn_t mpi3mr_isr(int irq, void *privdata)
 	 * If more IOs are expected, schedule IRQ polling thread.
 	 * Otherwise exit from ISR.
 	 */
-	if ((threaded_isr_poll == false) || !intr_info->op_reply_q)
+	op_reply_q = READ_ONCE(intr_info->op_reply_q);
+	if ((threaded_isr_poll == false) || !op_reply_q)
 		return ret;
 
-	if (!intr_info->op_reply_q->enable_irq_poll ||
-	    !atomic_read(&intr_info->op_reply_q->pend_ios))
+	if (!op_reply_q->enable_irq_poll ||
+	    !atomic_read(&op_reply_q->pend_ios))
 		return ret;
 
 	disable_irq_nosync(intr_info->os_irq);
@@ -782,12 +788,19 @@ static irqreturn_t mpi3mr_isr_poll(int irq, void *privdata)
 {
 	struct mpi3mr_intr_info *intr_info = privdata;
 	struct mpi3mr_ioc *mrioc;
+	struct op_reply_qinfo *op_reply_q;
 	u16 midx;
 	u32 num_op_reply = 0;
 
-	if (!intr_info || !intr_info->op_reply_q)
+	if (!intr_info)
 		return IRQ_NONE;
 
+	op_reply_q = READ_ONCE(intr_info->op_reply_q);
+	if (!op_reply_q) {
+		enable_irq(intr_info->os_irq);
+		return IRQ_HANDLED;
+	}
+
 	mrioc = intr_info->mrioc;
 	midx = intr_info->msix_index;
 
@@ -796,20 +809,23 @@ static irqreturn_t mpi3mr_isr_poll(int irq, void *privdata)
 		if (!mrioc->intr_enabled || mrioc->unrecoverable)
 			break;
 
+		op_reply_q = READ_ONCE(intr_info->op_reply_q);
+		if (!op_reply_q)
+			break;
+
 		if (!midx)
 			mpi3mr_process_admin_reply_q(mrioc);
-		if (intr_info->op_reply_q)
-			num_op_reply +=
-			    mpi3mr_process_op_reply_q(mrioc,
-				intr_info->op_reply_q);
-		if (!atomic_read(&intr_info->op_reply_q->pend_ios))
+		num_op_reply +=
+		    mpi3mr_process_op_reply_q(mrioc, op_reply_q);
+		if (!atomic_read(&op_reply_q->pend_ios))
 			break;
 
 		usleep_range(MPI3MR_IRQ_POLL_SLEEP, 10 * MPI3MR_IRQ_POLL_SLEEP);
 
 	} while (num_op_reply < mrioc->max_host_ios);
 
-	intr_info->op_reply_q->enable_irq_poll = false;
+	if (op_reply_q)
+		op_reply_q->enable_irq_poll = false;
 	enable_irq(intr_info->os_irq);
 
 	return IRQ_HANDLED;
@@ -1993,10 +2009,6 @@ static void mpi3mr_free_op_req_q_segments(struct mpi3mr_ioc *mrioc, u16 q_idx)
 	int size;
 	struct segments *segments;
 
-	segments = mrioc->req_qinfo[q_idx].q_segments;
-	if (!segments)
-		return;
-
 	if (mrioc->enable_segqueue) {
 		size = MPI3MR_OP_REQ_Q_SEG_SIZE;
 		if (mrioc->req_qinfo[q_idx].q_segment_list) {
@@ -2010,6 +2022,10 @@ static void mpi3mr_free_op_req_q_segments(struct mpi3mr_ioc *mrioc, u16 q_idx)
 		size = mrioc->req_qinfo[q_idx].segment_qd *
 		    mrioc->facts.op_req_sz;
 
+	segments = mrioc->req_qinfo[q_idx].q_segments;
+	if (!segments)
+		return;
+
 	for (j = 0; j < mrioc->req_qinfo[q_idx].num_segments; j++) {
 		if (!segments[j].segment)
 			continue;
@@ -2036,10 +2052,17 @@ static void mpi3mr_free_op_reply_q_segments(struct mpi3mr_ioc *mrioc, u16 q_idx)
 	u16 j;
 	int size;
 	struct segments *segments;
+	u16 midx = REPLY_QUEUE_IDX_TO_MSIX_IDX(q_idx, mrioc->op_reply_q_offset);
 
-	segments = mrioc->op_reply_qinfo[q_idx].q_segments;
-	if (!segments)
-		return;
+	/*
+	 * Stop the ISR/poll thread from picking up this queue before its
+	 * segments are freed below, and wait for any in-flight handler
+	 * that already has the old pointer to finish using it.
+	 */
+	if (midx < mrioc->intr_info_count) {
+		WRITE_ONCE(mrioc->intr_info[midx].op_reply_q, NULL);
+		synchronize_irq(pci_irq_vector(mrioc->pdev, midx));
+	}
 
 	if (mrioc->enable_segqueue) {
 		size = MPI3MR_OP_REP_Q_SEG_SIZE;
@@ -2054,6 +2077,10 @@ static void mpi3mr_free_op_reply_q_segments(struct mpi3mr_ioc *mrioc, u16 q_idx)
 		size = mrioc->op_reply_qinfo[q_idx].segment_qd *
 		    mrioc->op_reply_desc_sz;
 
+	segments = mrioc->op_reply_qinfo[q_idx].q_segments;
+	if (!segments)
+		return;
+
 	for (j = 0; j < mrioc->op_reply_qinfo[q_idx].num_segments; j++) {
 		if (!segments[j].segment)
 			continue;
@@ -2520,7 +2547,7 @@ static int mpi3mr_create_op_req_q(struct mpi3mr_ioc *mrioc, u16 idx,
 static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
 {
 	int retval = 0;
-	u16 num_queues = 0, i = 0, msix_count_op_q = 1;
+	u16 num_queues = 0, i = 0, j = 0, msix_count_op_q = 1;
 	u32 ioc_status;
 	enum mpi3mr_iocstate ioc_state;
 
@@ -2572,6 +2599,13 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
 		}
 	}
 
+	if (i < num_queues) {
+		for (j = i; j < num_queues; j++) {
+			mpi3mr_free_op_req_q_segments(mrioc, j);
+			mpi3mr_free_op_reply_q_segments(mrioc, j);
+		}
+	}
+
 	if (i == 0) {
 		/* Not even one queue is created successfully*/
 		retval = -1;
@@ -2593,11 +2627,19 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
 
 	return retval;
 out_failed:
-	kfree(mrioc->req_qinfo);
-	mrioc->req_qinfo = NULL;
+	if (mrioc->req_qinfo) {
+		for (j = 0; j < i; j++) {
+			mpi3mr_free_op_req_q_segments(mrioc, j);
+			mpi3mr_free_op_reply_q_segments(mrioc, j);
+		}
+		kfree(mrioc->req_qinfo);
+		mrioc->req_qinfo = NULL;
+	}
+	mrioc->num_op_req_q = 0;
 
 	kfree(mrioc->op_reply_qinfo);
 	mrioc->op_reply_qinfo = NULL;
+	mrioc->num_op_reply_q = 0;
 
 	return retval;
 }
@@ -2641,7 +2683,8 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
 	if (mpi3mr_check_req_qfull(op_req_q)) {
 		midx = REPLY_QUEUE_IDX_TO_MSIX_IDX(
 		    reply_qidx, mrioc->op_reply_q_offset);
-		mpi3mr_process_op_reply_q(mrioc, mrioc->intr_info[midx].op_reply_q);
+		mpi3mr_process_op_reply_q(mrioc,
+		    READ_ONCE(mrioc->intr_info[midx].op_reply_q));
 
 		if (mpi3mr_check_req_qfull(op_req_q)) {
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 7e59773c0276..3412e1e0e8ce 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3993,7 +3993,7 @@ inline void mpi3mr_poll_pend_io_completions(struct mpi3mr_ioc *mrioc)
 
 	for (i = mrioc->op_reply_q_offset; i < num_of_reply_queues; i++)
 		mpi3mr_process_op_reply_q(mrioc,
-		    mrioc->intr_info[i].op_reply_q);
+		    READ_ONCE(mrioc->intr_info[i].op_reply_q));
 }
 
 /**
-- 
2.47.3


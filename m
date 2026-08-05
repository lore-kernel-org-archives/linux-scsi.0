Received: from mail-vk1-f226.google.com (mail-vk1-f226.google.com [209.85.221.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284DE431495
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 11:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785928474; cv=none; b=Mz1ky3/p6oDHGeEQKOynThtk6ENGksu0FnfBklp/y9CNPM6dvehfxE10DZ9rwrGchgICpOqMfxDJ4PCn/qgU0JPIhHq1pfTdrQtktIRIY4bBu7Ur3iD+vhTb2yUHEz8jA/O5Cpz5Pu8BOcWiAPBHUIGSeuW6TbAp1HOIwANkLu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785928474; c=relaxed/simple;
	bh=K5EEivKsI0N65oqkRjYgmUjYgs4yp8uPMTep17M23DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdzLvfxuf9epT4NltDwaSD+Gugu5wfp5lfCIlfRbgiOnDWtQaeJTLDc0oGVtye0J306Iun4VoyFmmQQT7JAOTa4fMxb3YjIgYgBkD9LVsqFMVqN+q8E7RgkOpsS0e2NIBqasFHtELzjwTLvvcJEcQijXaCFt8PK5TCl2V1RD4yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=N4SYJhij; arc=none smtp.client-ip=209.85.221.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="N4SYJhij"
Received: by mail-vk1-f226.google.com with SMTP id 71dfb90a1353d-5bfa4c51c2aso254349e0c.0
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2026 04:14:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785928472; x=1786533272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZyoHhF0lwkExjLQP23UtLF2uu0TuvfRDobB1gf48q+Y=;
        b=p2U9EY3nonKlboq1eb72o24d/zXHrw1LjIaV4s+4pYYvNAvyMpaOpPxmdBTlIJAv91
         tCHHNHkAiq1nWr3QdVnQtilz1k0AHe3OSXV/TEejLUGLRWjG7Yj5N7mCD34aMvSwqxt7
         LAICgM/uAtalggXmNxZ1IReGv/gsQcsdi5H0lujMiY/R/YGiBLZwI2OV4UxgUzXqF85g
         gdU6EaGF5DL9fJj6kU/+sxCp/PeIyxNZpbD+LPBDF6qvbbOYsEGr/LbC6SBpLvJMdw1M
         saHN/yWa4+LwJQkR3XzUne/8pGNiVbZppIGxbrGbQF4RMm58A2fbaVrQEfmoUYGxbR47
         ENKA==
X-Gm-Message-State: AOJu0YwaIEjBNX43pJP6j7KZNviC+mWEZgZpKYIEVUlF5qXmLE9jzD5a
	p3d+DMsQlqyMwYbuY/H2mJNmxSStp3/hy31uBnaRrKmjK2OC+keEJRe7nmGSJP898NLhBbZ12uT
	u+LbeAeJnQ3bs/xDJU1gTbj39atMcpNVNlXW07Bq++DidlUQk+LyK8jKghp7eamqqgHzHex6fqd
	RsfI8Lm1smO/b1s09VWUcRDA7tlwJGuz7jGqrrMvlhh++JR3HOfMSIv6z15tlnHk5GO6vMHd77j
	QV1Vzc0tvWPoCjh
X-Gm-Gg: AR+sD132G3n0zGjHqJEg8HbMyDVQSIVbek2wfY38B7fgq7NI6/bnedD5styCEjJSslQ
	4RRp1u5fT1b7bqf+ufR558ZBdfa8kwZtHyVlYywVuQLjuWp6LYoAMXhTfBpPtKKLiws+rGEn+LW
	D8Nt65sWN1qRmZX+KDbTGYK2WhvovWNVqytYVpBcdjMOqT8NcJVskYuZ617hzZWBeIgVHgEE2ob
	qDuHHQDCFQnuv6SBtUpqaLNdpBalRNwbka3/xpBcuIalPTgMCcO+10UcoI1RN1xewAxohk0PzL4
	dpPC2NIYOKv22hF8/ESMEJUERYqHEqb3wPU0ZSkljLk275Im2kYoQGfweAojOQO9JvJUMFKopng
	pXJe5lbA+hdPzpDdwGGl4YdlFS6YrfMCnPfIj6ikJd9jo9PzNMEViO/r/1WiUh7HQB1nROGj9UL
	3B0xv1kz50hElp0Pwt8SFUgRL1Yi11cbCQP3g=
X-Received: by 2002:a05:6122:d15:b0:5c2:b001:db5b with SMTP id 71dfb90a1353d-5c3d910bacbmr746435e0c.6.1785928471670;
        Wed, 05 Aug 2026 04:14:31 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-5c3d06f1cf6sm555578e0c.5.2026.08.05.04.14.30
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Aug 2026 04:14:31 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38ce7fabf76so1447350a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2026 04:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785928470; x=1786533270; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZyoHhF0lwkExjLQP23UtLF2uu0TuvfRDobB1gf48q+Y=;
        b=N4SYJhijj3WFVHinnRoj+681rNhbJsVKfIKIa/o/bPR/oi3COKdbKtSXeEDlilY7dP
         RF58J0joG0HTR/IgsaQCOjfE1TRBrqDXtjZLGIzVGkjnpASd8HwDJMCGEbGDC7fWgwA4
         EqZN1ZhPmLuma4l1afhX96bDi4USvDXx4l7tY=
X-Received: by 2002:a17:90b:4b84:b0:38e:8021:2ea9 with SMTP id 98e67ed59e1d1-3903c5f6482mr5465293a91.19.1785928469720;
        Wed, 05 Aug 2026 04:14:29 -0700 (PDT)
X-Received: by 2002:a17:90b:4b84:b0:38e:8021:2ea9 with SMTP id 98e67ed59e1d1-3903c5f6482mr5465236a91.19.1785928469117;
        Wed, 05 Aug 2026 04:14:29 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3158673b7f4sm16740227eec.17.2026.08.05.04.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 04:14:28 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v4 06/10] mpi3mr: Fix memory leak on operational queue creation failure
Date: Wed,  5 Aug 2026 16:36:30 +0530
Message-ID: <20260805110634.346670-7-ranjan.kumar@broadcom.com>
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

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@broadcom.com?part=6
Closes: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar@broadcom.com?part=6
Closes: https://sashiko.dev/#/patchset/20260724102505.115136-1-ranjan.kumar@broadcom.com?part=6
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 83 ++++++++++++++++++++++++---------
 1 file changed, 60 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index e6050b41e15a..5a780eb7fd43 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -698,6 +698,7 @@ static irqreturn_t mpi3mr_isr_primary(int irq, void *privdata)
 {
 	struct mpi3mr_intr_info *intr_info = privdata;
 	struct mpi3mr_ioc *mrioc;
+	struct op_reply_qinfo *op_reply_q;
 	u16 midx;
 	u32 num_admin_replies = 0, num_op_reply = 0;
 
@@ -713,9 +714,9 @@ static irqreturn_t mpi3mr_isr_primary(int irq, void *privdata)
 
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
@@ -728,6 +729,7 @@ static irqreturn_t mpi3mr_isr_primary(int irq, void *privdata)
 static irqreturn_t mpi3mr_isr(int irq, void *privdata)
 {
 	struct mpi3mr_intr_info *intr_info = privdata;
+	struct op_reply_qinfo *op_reply_q;
 	int ret;
 
 	if (!intr_info)
@@ -740,11 +742,12 @@ static irqreturn_t mpi3mr_isr(int irq, void *privdata)
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
@@ -766,10 +769,15 @@ static irqreturn_t mpi3mr_isr_poll(int irq, void *privdata)
 {
 	struct mpi3mr_intr_info *intr_info = privdata;
 	struct mpi3mr_ioc *mrioc;
+	struct op_reply_qinfo *op_reply_q;
 	u16 midx;
 	u32 num_op_reply = 0;
 
-	if (!intr_info || !intr_info->op_reply_q)
+	if (!intr_info)
+		return IRQ_NONE;
+
+	op_reply_q = READ_ONCE(intr_info->op_reply_q);
+	if (!op_reply_q)
 		return IRQ_NONE;
 
 	mrioc = intr_info->mrioc;
@@ -780,20 +788,23 @@ static irqreturn_t mpi3mr_isr_poll(int irq, void *privdata)
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
@@ -1973,10 +1984,6 @@ static void mpi3mr_free_op_req_q_segments(struct mpi3mr_ioc *mrioc, u16 q_idx)
 	int size;
 	struct segments *segments;
 
-	segments = mrioc->req_qinfo[q_idx].q_segments;
-	if (!segments)
-		return;
-
 	if (mrioc->enable_segqueue) {
 		size = MPI3MR_OP_REQ_Q_SEG_SIZE;
 		if (mrioc->req_qinfo[q_idx].q_segment_list) {
@@ -1990,6 +1997,10 @@ static void mpi3mr_free_op_req_q_segments(struct mpi3mr_ioc *mrioc, u16 q_idx)
 		size = mrioc->req_qinfo[q_idx].segment_qd *
 		    mrioc->facts.op_req_sz;
 
+	segments = mrioc->req_qinfo[q_idx].q_segments;
+	if (!segments)
+		return;
+
 	for (j = 0; j < mrioc->req_qinfo[q_idx].num_segments; j++) {
 		if (!segments[j].segment)
 			continue;
@@ -2016,10 +2027,17 @@ static void mpi3mr_free_op_reply_q_segments(struct mpi3mr_ioc *mrioc, u16 q_idx)
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
@@ -2034,6 +2052,10 @@ static void mpi3mr_free_op_reply_q_segments(struct mpi3mr_ioc *mrioc, u16 q_idx)
 		size = mrioc->op_reply_qinfo[q_idx].segment_qd *
 		    mrioc->op_reply_desc_sz;
 
+	segments = mrioc->op_reply_qinfo[q_idx].q_segments;
+	if (!segments)
+		return;
+
 	for (j = 0; j < mrioc->op_reply_qinfo[q_idx].num_segments; j++) {
 		if (!segments[j].segment)
 			continue;
@@ -2500,7 +2522,7 @@ static int mpi3mr_create_op_req_q(struct mpi3mr_ioc *mrioc, u16 idx,
 static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
 {
 	int retval = 0;
-	u16 num_queues = 0, i = 0, msix_count_op_q = 1;
+	u16 num_queues = 0, i = 0, j = 0, msix_count_op_q = 1;
 	u32 ioc_status;
 	enum mpi3mr_iocstate ioc_state;
 
@@ -2552,6 +2574,13 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
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
@@ -2573,11 +2602,19 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
 
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
-- 
2.47.3


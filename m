Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F554848B7
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 14:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789742296; cv=none; b=uwR8as+B2roD64YjiczQBHYRVXZVt3MMHqeZ4oLKaHOuHk5iTLPsXaSaILVGcZzHF9pxe44fQchkk6WAZecUlY2Sypjjs0MK+5XBZ91Z5WcNVitOohn2wzIE5Q6Q1BbySS1VovU2T2IYFQroxa6xZoCm3meuIRBaRl9XEFRZaoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789742296; c=relaxed/simple;
	bh=zY8TQGvRR0TfY/4o05gMCbEeECuiInBxdKlJWP9KB1c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=njQAbUx2Yo1o1wiUMbJb/aRrctGJcyjPTzCkxXeINsbnD/zvxgaXxc0a47fs6X1wM6rMZ0Ftyw722C57W/M49P0ivUfk0Cb3QjQ+fY5CyMZ6iVvvhwhIVfY9TOhcr/RKJLx9m7bac3gMQjfP4XG+F27tDFruLQCt28k46LnHiTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JRNdtIcb; arc=none smtp.client-ip=209.85.210.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JRNdtIcb"
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-86261e66700so907205b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 07:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789742293; x=1790347093; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KnLkF7ter7j7ccxH/bbiqxi4gFXxPEmpQ7hBTZwXfuE=;
        b=JRNdtIcbH4nirvkCgf7FcpNAqxfE+GUKAhxoBq3YfDkRwskzvNrw6EsN2JRGp1x9Z3
         8h1iBWwBi9JPO8m/kggeUTQJdTA4U+qRYjOLqerBTxRwQ7/v0pn0VqwXW6LkABmNS1CM
         PWt6DU1Gg0XldPy+bu8HQSfgtNC5ZpSE23mrY6NHrm6j3u61SFLVWdWBhptaSkSYy4ac
         GyPSWtJ71JlUhbYpYgpgMh6lGrGO5wSt/BXnj4PrIgzoupSh1PjSnWwurcItvMI1nQZF
         VzC0c4GeI/2ILWMTVf9jUF3Za8Jh5qielN9mCj5XW8Vz1m5XFXPO+QRHvuvfp9U/Bqti
         X96g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789742293; x=1790347093;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KnLkF7ter7j7ccxH/bbiqxi4gFXxPEmpQ7hBTZwXfuE=;
        b=FdCsG1oM1b+qreJal5gvODNftjjjeCaL9lNRZ2CAMPOVdOJrw1Fe1GgTjtasP2rXnm
         zQ9fHvENV+5wDoAnXVfYUmypR8I7pARFadESt9UHfnAyDoZ76WYXGKiNYqVjfW+c0zpY
         0LKhGq+yuZnVhC4UboWy9YKuUnFgOmdARNRuJkuMBUMoKjzSgNQwVKf4sxxw9auYA5z5
         /9cZoD+B2cJ2aJsiqmzuiw/88rO0J+4/D0I8Qg1314GpmQVe77qGnbeI5Ho1d1peqIsl
         wlNRLa+mrrXf2YE9L28QJaDNkAhjFficHk5LdPnCuYrxIzl9FMjot5xL5Pn/Mb5wdUfi
         E9Qg==
X-Forwarded-Encrypted: i=1; AKwUvBxokUCOSvaDtVRDGemS+m5Tzv2mK+o2sEthfYLr//6KGxbCPp04YNfQ7buHIhqslZsvD+fFPVHVAsac@vger.kernel.org
X-Gm-Message-State: AFuF++mx4fnGly4lAkWx8S7euGQu0+eSdl2kE3ylmksC21Vd21eMIb5m
	oetLQX00CjcD/kyk+++NaydCxIiG4zYy+hggi2JfjeFPRtvxjJJsld9n+oTHocuKEwcy+AGBMpD
	pBXk2xZNhfUH4qk3R4/n6nw==
X-Received: from pfbmu26.prod.google.com ([2002:a05:6a00:6e9a:b0:86b:e98b:a8ab])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:94e3:b0:874:706d:962f with SMTP id d2e1a72fcca58-874de4ff5fdmr5702926b3a.33.1789742293333;
 Fri, 18 Sep 2026 07:38:13 -0700 (PDT)
Date: Fri, 18 Sep 2026 22:38:07 +0800
In-Reply-To: <20260918143809.3034592-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAE14pdek6ynze+muDZrK+yNX-3ioe3vprxOA4W22qokg352tJQ@mail.gmail.com>
 <20260918143809.3034592-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918143809.3034592-2-stanleyjhu@google.com>
Subject: [PATCH v2 1/2] scsi: ufs: core: Avoid unsafe MMIO reads in ufshcd_mcq_compl_all_cqes_lock()
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>, Bean Huo <beanhuo@micron.com>, 
	Bart Van Assche <bvanassche@acm.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Manivannan Sadhasivam <mani@kernel.org>, Peter Wang <peter.wang@mediatek.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stanleyjhu@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

During MCQ host reset, ufshcd_host_reset_and_restore() stops the host
controller via ufshcd_hba_stop() (HCE = 0) before calling
ufshcd_complete_requests(hba, true) ->
ufshcd_mcq_compl_pending_transfer(hba, true) ->
ufshcd_mcq_force_compl_one() -> ufshcd_mcq_compl_all_cqes_lock().
Because ufshcd_mcq_force_compl_one() is its sole caller,
ufshcd_mcq_compl_all_cqes_lock() always runs with HCE = 0.

Despite the comment above ufshcd_mcq_compl_all_cqes_lock() stating that
reading CQTPy may not be safe with the controller disabled, the function
still calls ufshcd_mcq_update_cq_tail_slot() at the end of its sweep:

1. Unsafe CQTPy MMIO read:
   Calling ufshcd_mcq_update_cq_tail_slot() at the end of the sweep
   reads CQTPy over MMIO while HCE = 0, directly contradicting the
   function's documented contract (commit 1373df88d535 ("scsi: ufs:
   core: Add a comment block above ufshcd_mcq_compl_all_cqes_lock()"))
   that reading CQTPy may not be safe with the controller disabled.

2. Spurious error logs on empty slots:
   Sweeping all max_entries slots visits empty entries where
   command_desc_base_addr is 0, causing ufshcd_mcq_process_cqe() to log
   unguarded dev_err(hba->dev, "Abnormal CQ entry!\n") messages.

Fix both issues in ufshcd_mcq_compl_all_cqes_lock():
- Synchronize hwq->cq_tail_slot = hwq->cq_head_slot in software after
  sweeping the ring, avoiding CQTPy MMIO reads while HCE = 0.
- Extract ufshcd_mcq_compl_cqe() and invoke it only on non-empty slots
  during full-ring sweeps, keeping "Abnormal CQ entry!" logging strictly
  for unexpected empty entries in ufshcd_mcq_poll_cqe_lock().

Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
v2:
- Extract ufshcd_mcq_compl_cqe() to skip empty slots inside
  ufshcd_mcq_compl_all_cqes_lock() without double CQE checks (dropped
  Peter Wang's v1 Reviewed-by due to this code change).
- Move hardware queue polling and sweeping deduplication to Patch 2/2.

Link: https://lore.kernel.org/r/CAE14pdek6ynze+muDZrK+yNX-3ioe3vprxOA4W22qokg352tJQ@mail.gmail.com

 drivers/ufs/core/ufs-mcq.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 8106d55f4041..bfc43a6080e7 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -312,20 +312,24 @@ static int ufshcd_mcq_get_tag(struct ufs_hba *hba, struct cq_entry *cqe)
 		UFSHCD_NUM_RESERVED;
 }
 
+static void ufshcd_mcq_compl_cqe(struct ufs_hba *hba, struct cq_entry *cqe)
+{
+	int tag = ufshcd_mcq_get_tag(hba, cqe);
+
+	ufshcd_compl_one_cqe(hba, tag, cqe);
+	/* After processed the cqe, mark it empty (invalid) entry */
+	cqe->command_desc_base_addr = 0;
+}
+
 static void ufshcd_mcq_process_cqe(struct ufs_hba *hba,
 				   struct ufs_hw_queue *hwq)
 {
 	struct cq_entry *cqe = ufshcd_mcq_cur_cqe(hwq);
 
-	if (cqe->command_desc_base_addr) {
-		int tag = ufshcd_mcq_get_tag(hba, cqe);
-
-		ufshcd_compl_one_cqe(hba, tag, cqe);
-		/* After processed the cqe, mark it empty (invalid) entry */
-		cqe->command_desc_base_addr = 0;
-	} else {
+	if (cqe->command_desc_base_addr)
+		ufshcd_mcq_compl_cqe(hba, cqe);
+	else
 		dev_err(hba->dev, "Abnormal CQ entry!\n");
-	}
 }
 
 /*
@@ -333,7 +337,7 @@ static void ufshcd_mcq_process_cqe(struct ufs_hba *hba,
  * controller disabled (HCE = 0). Reading host controller registers, e.g. the
  * CQ tail pointer (CQTPy), may not be safe with the host controller disabled.
  * Hence, iterate over all completion queue entries. This won't result in
- * double completions because ufshcd_mcq_process_cqe() clears a CQE after it
+ * double completions because ufshcd_mcq_compl_cqe() clears a CQE after it
  * has been processed.
  */
 void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *hba,
@@ -344,13 +348,20 @@ void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *hba,
 
 	spin_lock_irqsave(&hwq->cq_lock, flags);
 	while (entries > 0) {
-		ufshcd_mcq_process_cqe(hba, hwq);
+		struct cq_entry *cqe = ufshcd_mcq_cur_cqe(hwq);
+
+		if (cqe->command_desc_base_addr)
+			ufshcd_mcq_compl_cqe(hba, cqe);
 		ufshcd_mcq_inc_cq_head_slot(hwq);
 		entries--;
 	}
 
-	ufshcd_mcq_update_cq_tail_slot(hwq);
-	hwq->cq_head_slot = hwq->cq_tail_slot;
+	/*
+	 * All completion entries have been processed and cleared.
+	 * Synchronize tail to head in software to mark the queue empty,
+	 * avoiding an MMIO read of CQTPy while the controller is disabled.
+	 */
+	hwq->cq_tail_slot = hwq->cq_head_slot;
 	spin_unlock_irqrestore(&hwq->cq_lock, flags);
 }
 
-- 
2.55.0.1082.g2b9226bbc0-goog


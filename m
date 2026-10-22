Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792640689;
	b=BFzMVLrVSFBEmQARaCyGnRtubxsY8QnjYZv7zAz7tu0DKyAbZ0n/sjfZcqqN8ROfizAL
	 NRcYStWSBheHx6PX8YTjAAxYtu0vMHsHiycahhkqXXS5n+2WrpHOQ1VbXZgFoCe+SXPiA
	 xg7zXePJKkVLjvcVzhvF1QtXeXhIpRwnfWgcGEoeEE5PtCZu0Lz19Sn0s4KacKsybu4bM
	 NG5fnFxDRjPYW9eeVe3Q7ok7qdbhPpvDC4MomUjDOlDy8FiK6Z3iQP+u9Tu5qYp2sei8Q
	 gblQAPUlP6t1b9Sti+Uyos/hwV49zUkGZy75LqqszRqFbVB9ou7p0eGc3ylqNowYSeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792640689;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=8T5L2Doo4hafhgE4IIDG7Xgemkp+4Eg0v8OcH6PLgGM=;
	b=cLkGfejIiZHXYHWWMyt5lL1CfCyYJmvCo0cgYPUX8z5KlxhqQnjvxIxbwaQysFaRpxJx
	 rKuNIoAd3UsQS09X73Lt8iptGQ6XA9IJQWbYMkCjzLgzTKU5vEFqzGkd/SYOMxpz+HRtD
	 CUxne+LsdNHiyjhckNefKxF1bzaGXSZaE8trRDdiO5X/gFgNbfS56E6Qc5DIndiRxTTdP
	 OeWE69vmyQUtYazVkejQdyzjMkdTy26cYMzcZZYxHkyV+LJCZ525Z2YyYtaksiMYv07+u
	 1nENIjhMXbMbadRQo/QLip2Bx423rIPY4IhnxWySmIjigStiIZl69OqwxXlIRqU5NsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=kqW3zQRB;
	arc=none smtp.remote-ip=209.85.216.69
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB89606A32F
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 03:44:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BB89606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=kqW3zQRB
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3a4aa263a4aso1268470a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 20:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792640689; x=1793245489; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8T5L2Doo4hafhgE4IIDG7Xgemkp+4Eg0v8OcH6PLgGM=;
        b=kqW3zQRBOvd8I2Jq+gdYfLCHqX9hdeBCX9rrNtPdsQ9l9EWTsenYVI3Xi1yPaMw4Jl
         MyCLwDwZDu15WwiOzm6CarutKDjUNyBO1gglmooNCunQP2XX2KUhgbzCSLDvN3oC1FTq
         4GpJtC2T/DXCD7jggVgnvEhOn91VGe1HL+SPjqrKsMi1Y+Wijtwez/rhmizLgtwzXKPo
         5qeF4iyCOhiQwj/q4/kYzqHO9TPJQmcPqvCuNpTt6veKxmJb2rhKupB244xNsVxq7GfH
         HJqbkYUjk0ylTZ0uV9iD7kq4+gio5zYYapsT+1XmfrCmaAyt44RJRmcoQy9F0z3QlmHw
         b1Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792640689; x=1793245489;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8T5L2Doo4hafhgE4IIDG7Xgemkp+4Eg0v8OcH6PLgGM=;
        b=iyVzBw2TGsSZf8hvfObJk50mQJQwCOMESxm9MTH0uypx/EZU74pLleiHktF9YtOHvk
         dPr/t2O3VS3NxmrVmb++zWvYHxeij017wsCSq8efkFjhlLY5Ez8xEJ8Y9MuzKDSWGrox
         0Rwo8VXKtl7QOSYGvbXe4Oq7kJp6quopYitJ9oGbLKdOyeTFz0gJYT/9raaubXJ6qBo8
         ELtFMgpv+ibf9oQHqlaT4Q9m0gYAN6tmcnKLjlT/96Pxn4txAuA1UXXnb4MAUC9Nr34h
         OPY4QPYw6BhlPKIsS2G40/QGZsp2rIlX9P/8F9iSSYynYsf1z9H6ORvmBEz6gpx8k4FX
         cnMg==
X-Forwarded-Encrypted: i=1; AKwUvBzxV+2W2M3h0ZfnxSHFte0wXbFmryz32+b4Q76ypY7YYyDl7IOUCaYi5YWHEO6gkyAmQF1PdBriW7Ir@vger.kernel.org
X-Gm-Message-State: AFq9FYL8FS0r15Q2Bm7iJlwQJsqGnFk2tAanZOpEjYoWbyQL69UTwVlM
	/lw3cn7yA6XyIiVM8tEseQ8C4vYNXmnhw20TVg2ExN/jn1h80Kx/K/ug0DZjE3SQf0nWFcjlhLV
	2ZwLe32bcyjhro7X0CbwTQg==
X-Received: from pgbd23-n2.prod.google.com ([2002:a05:6a02:64d7:20b0:cd6:261d:5bde])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5251:b0:3aa:fc22:8aa7 with SMTP id 98e67ed59e1d1-3ad86dc12eemr3420030a91.53.1792640688818;
 Wed, 21 Oct 2026 20:44:48 -0700 (PDT)
Date: Thu, 22 Oct 2026 11:44:39 +0800
In-Reply-To: <20261022034443.3034432-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261022034443.3034432-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <20261022034443.3034432-3-stanleyjhu@google.com>
Subject: [PATCH v5 2/6] scsi: ufs: core: Add a helper for clearing hba->outstanding_reqs
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

ufshcd_poll() and ufshcd_abort() each have their own copy of the code
that clears bits in hba->outstanding_reqs under hba->outstanding_lock.

Move that code into ufshcd_clear_outstanding_reqs() and its locked
variant __ufshcd_clear_outstanding_reqs(), and use them in both
functions. No functional change.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/3779e125-9acc-42c8-9489-51b9e3c6716d@acm.org
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 48 +++++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 12 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 12aafcf1f9b3..1db572f84971 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6052,6 +6052,37 @@ static void ufshcd_clear_polled(struct ufs_hba *hba,
 	}
 }
 
+/*
+ * Return a bitmask of the transfer requests cleared from
+ * @hba->outstanding_reqs.
+ */
+static unsigned long __ufshcd_clear_outstanding_reqs(struct ufs_hba *hba,
+						     unsigned long mask,
+						     bool from_irq)
+	__must_hold(&hba->outstanding_lock)
+{
+	unsigned long completed_reqs = mask & hba->outstanding_reqs;
+
+	if (from_irq) {
+		/* Do not complete polled requests from interrupt context. */
+		ufshcd_clear_polled(hba, &completed_reqs);
+	}
+	hba->outstanding_reqs &= ~completed_reqs;
+
+	return completed_reqs;
+}
+
+/*
+ * Return a bitmask of the transfer requests cleared from
+ * @hba->outstanding_reqs.
+ */
+static unsigned long ufshcd_clear_outstanding_reqs(struct ufs_hba *hba,
+						   unsigned long mask)
+{
+	guard(spinlock_irqsave)(&hba->outstanding_lock);
+	return __ufshcd_clear_outstanding_reqs(hba, mask, false);
+}
+
 /*
  * Return: > 0 if one or more commands have been completed or 0 if no
  * requests have been completed.
@@ -6062,6 +6093,7 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
 	unsigned long completed_reqs, flags;
 	u32 tr_doorbell;
 	struct ufs_hw_queue *hwq;
+	bool from_irq;
 
 	if (hba->mcq_enabled) {
 		hwq = &hba->uhq[queue_num];
@@ -6071,12 +6103,9 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
 
 	spin_lock_irqsave(&hba->outstanding_lock, flags);
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
-	if (queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT) {
-		/* Do not complete polled requests from interrupt context. */
-		ufshcd_clear_polled(hba, &completed_reqs);
-	}
-	hba->outstanding_reqs &= ~completed_reqs;
+	from_irq = queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT;
+	completed_reqs = __ufshcd_clear_outstanding_reqs(hba, ~tr_doorbell,
+							 from_irq);
 	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
 
 	if (completed_reqs)
@@ -8111,7 +8140,6 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
 	unsigned long flags;
 	int err = FAILED;
-	bool outstanding;
 	u32 reg;
 
 	ufshcd_hold(hba);
@@ -8206,11 +8234,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	 * Clear the corresponding bit from outstanding_reqs since the command
 	 * has been aborted successfully.
 	 */
-	spin_lock_irqsave(&hba->outstanding_lock, flags);
-	outstanding = __test_and_clear_bit(tag, &hba->outstanding_reqs);
-	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
-
-	if (outstanding)
+	if (ufshcd_clear_outstanding_reqs(hba, BIT(tag)))
 		ufshcd_release_scsi_cmd(hba, cmd);
 
 	err = SUCCESS;
-- 
2.56.0.218.g1ec904b173-goog


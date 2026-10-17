Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4636B3D2FEC
	for <linux-scsi@vger.kernel.org>; Sat, 17 Oct 2026 08:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792226650; cv=none; b=hby4XgQ3VckjhMrhAlMDvFqgyixembTMlWKiLcRNCxza4VCtib8dUAIO0sQcKONOR9K+ivzqvbbwTZRphkexUp86TPDzsA5v1NVDxpkIzJFgerLcvEhZfI6OT+Mq/biU7UOr0S7Il0kHPAVVvzmVw/Jau44a39IJqWllPk6OnYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792226650; c=relaxed/simple;
	bh=t+rPDyaXR43NUuKqM+DHsvqolGp6JjYXlb5sDdMydvk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KbFnkSut0xAXnAbroba0w8OkM/UFXhgmRdatFtGKqnoiBSp22mAgNgHwmbXl5tA3CMfO8EwChXJLrx/u2J5gRxjEbGyiZ+TAmrKh+iB4CzIX5WQqC0kYxTqsLYJz95bc0F6kCC0U8bA7VH1hszQmZGVRhTOHsEdGZC2yKY0cgBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ixNHFmMR; arc=none smtp.client-ip=209.85.215.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ixNHFmMR"
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cd5ca3840c5so705395a12.2
        for <linux-scsi@vger.kernel.org>; Sat, 17 Oct 2026 01:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792226648; x=1792831448; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZDczfTEMVNXX8ypwJnRuxvfRrqGlS2E1C1kChOy0r7Q=;
        b=ixNHFmMRmbptFaY1VztZEfLScsbbcyaNp71OnmFy1NJY8x072T+FIzCEvB6fgRAWbs
         0rUR2mfTHqjsRMc3FAXmiT/0uLZ/cxbJ++3Hdh/gbW4wldRwPJPEH+7XGNGJma+3pKRM
         ZUsv/SFYFsmA554rZQO2D1VlDUeEDbyxuTmgsQgFoPllwXfwaiGkBzWrUJu+UH2Fm1NN
         dNAAYDEwzGJEI7oKYqYo+qhQD6wFDoLak/kvrbWcYgGVYs8UP/4LuOcKbj/dA63MT/pf
         HVtln5G2xipjhuQx1AB/UPTIngVKyBLakAW0pns60yUQFO4JJxJ6FFRtTAMse7EJSAVr
         MttQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792226648; x=1792831448;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZDczfTEMVNXX8ypwJnRuxvfRrqGlS2E1C1kChOy0r7Q=;
        b=JampoHrXWAeq2TrKMEzV539juVM0FCisiqHxfLV6Q/O0azrqf9RIi7Vr2/+VSC6XRn
         PgNwFUqziKMXsP+R5dxONi1BbKb+9p+sNzoguR32o2V2NwnXQPAR79kLs+6oUS4gnfZ0
         7ZAnJzjoWt3B96jAKNVl/TDD+TPcJg5N98vQD56/lMbWjnQ8EEUHEZVFqYyHnb5rJaIt
         OFGV5SdbxiHnlwHE8QpQWr4JK+tfswg3vLpxYNnwKzOoU9RT9YTSvNKok7Huoyw9shYj
         8pxvdgPKKqSMAIgeIOS1LLXdzYJr0DyI1IhEpY6d1Di7k2IrbvdyNX6OZllLUb85iOy9
         MxuQ==
X-Forwarded-Encrypted: i=1; AKwUvByi0AvuAnS3x4vxCz1EvI1mZ0WS410iJeaLobiZa2/Y6vls17UY0YWVobW6GB+Vzv/6IppSRxkzZ4A+@vger.kernel.org
X-Gm-Message-State: AFq9FYIVcvGPCUD7Ly2eJ3tLf5Y2/yIt7SAXdOV5z455yqTDyQVnhflK
	dPm/3H6RqogdBg2yaQk3MgfsM7BH4nw1YQnumUOgyUpjulC7nBg4B5CyHYXV/de8GD/zv2tZy1q
	Y7mvsPLAYCI79GcScvRVF8A==
X-Received: from pfwy14.prod.google.com ([2002:a05:6a00:1c8e:b0:88b:8b90:725d])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6300:670a:b0:3e1:549d:eedb with SMTP id adf61e73a8af0-3e225af40d8mr1465995637.0.1792226647481;
 Sat, 17 Oct 2026 01:44:07 -0700 (PDT)
Date: Sat, 17 Oct 2026 16:44:00 +0800
In-Reply-To: <20261017084403.875420-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261017084403.875420-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261017084403.875420-2-stanleyjhu@google.com>
Subject: [PATCH v2 1/4] scsi: ufs: core: Add a helper for clearing hba->outstanding_reqs
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
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/3779e125-9acc-42c8-9489-51b9e3c6716d@acm.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 50 +++++++++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 15 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bcc2512bf34b..71f4b9d0a850 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6052,6 +6052,37 @@ static void ufshcd_clear_polled(struct ufs_hba *hba,
 	}
 }
 
+static unsigned long __ufshcd_clear_outstanding_reqs(struct ufs_hba *hba,
+						     unsigned long mask,
+						     bool from_irq)
+{
+	unsigned long completed_reqs = mask & hba->outstanding_reqs;
+
+	lockdep_assert_held(&hba->outstanding_lock);
+	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
+		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
+		  hba->outstanding_reqs);
+	if (from_irq) {
+		/* Do not complete polled requests from interrupt context. */
+		ufshcd_clear_polled(hba, &completed_reqs);
+	}
+	hba->outstanding_reqs &= ~completed_reqs;
+
+	return completed_reqs;
+}
+
+static unsigned long ufshcd_clear_outstanding_reqs(struct ufs_hba *hba,
+						   unsigned long mask)
+{
+	unsigned long completed_reqs, flags;
+
+	spin_lock_irqsave(&hba->outstanding_lock, flags);
+	completed_reqs = __ufshcd_clear_outstanding_reqs(hba, mask, false);
+	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+
+	return completed_reqs;
+}
+
 /*
  * Return: > 0 if one or more commands have been completed or 0 if no
  * requests have been completed.
@@ -6071,15 +6102,9 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
 
 	spin_lock_irqsave(&hba->outstanding_lock, flags);
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
-	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
-		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
-		  hba->outstanding_reqs);
-	if (queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT) {
-		/* Do not complete polled requests from interrupt context. */
-		ufshcd_clear_polled(hba, &completed_reqs);
-	}
-	hba->outstanding_reqs &= ~completed_reqs;
+	completed_reqs =
+		__ufshcd_clear_outstanding_reqs(hba, ~tr_doorbell,
+						queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT);
 	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
 
 	if (completed_reqs)
@@ -8114,7 +8139,6 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
 	unsigned long flags;
 	int err = FAILED;
-	bool outstanding;
 	u32 reg;
 
 	ufshcd_hold(hba);
@@ -8209,11 +8233,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
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
2.56.0.176.g3575e65682-goog


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792554897;
	b=xKzTPM21dB4UlzWysR7T8NEKPe9OnVQvhBKBGL2GFr+U39mzSP/+YcI6eN7rVVf0e+cp
	 CbA5DwPR+I8jvDL7aB9y67P9bwxJCrX/Uz3AURoQfeptsRve06bcS2G8tPJkbUzg1ftFy
	 peqCj+0NoPCggwO0PWsQe+afr79pdiHZZc7z5ay/ewdzkk0V7XFC+Zvc+W7PC+PWK+5/I
	 rZt74LbGI2nn0VBMarpJoJz6kGUvdTTDXDuSNdVXjWtfnslIJR7dqCQRjUgTaxW3ciH4w
	 faXegBMsjirEJEpzA/UztprLOZu6MzbrZxXw+pfXqdYq5TFDde6RyOxKz6+UKqB881A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792554897;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=WwcZhsMFt/apL5mEt1XweWG8RyzKB1xDE1OfQpTu8h8=;
	b=J0VZ+iwRr7ZtTRGeIOU1Me7i7+mRjhuyS+YfuwTdK4lZ4Lz30+QAqbRG7E7HS/hBHsKc
	 SdrlNSaAHljn07/WxqzuhSS4NKBjFi2gqr7Cpm7NvQLqo+HUleSIlGA+hhQHoNPnGLMjn
	 PDLJXYUURypMRLvZ8jj1DlcCMvNAOtSra6h96v9PS3PSZa9AL4eY3CmPdqfJwfSvZcHoQ
	 awSBh4pZtTxiMIFN0QuQf3RO/C0UgmULXwGprg8XOx7VghIOWiMZGNEpylfKn6NMlSR65
	 rrgtQXNrBSLvCV0SjyTruBKMXTud0FbAfyrSYIeJ2SSwiA7wC4CtOmNS07nD+oJnjMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Z8lTzLRP;
	arc=none smtp.remote-ip=209.85.215.200
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F70606A319
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 03:54:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3F70606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Z8lTzLRP
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc7e0321ec1so255942a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 20:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792554896; x=1793159696; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WwcZhsMFt/apL5mEt1XweWG8RyzKB1xDE1OfQpTu8h8=;
        b=Z8lTzLRPnWfrXP2L3M9hvGN7+vNqk/JArPo16UvXNIJNjrUEe47Lu2A753zDNK+Ifm
         0Z0fo5sECDprjMZrgx017qiGBjFiJuD7T8hTh3G4BrSFmf87ifINmg98qQZeeRSFuN3Z
         iVNvWj+OofcEcFF653WvHycDJs4ysKQGY+l2vxmK3lAorv4qgvZBKk8yTYG1ukl67/yy
         B77dGPMN1LgIwgNVVCbwbk4Y952eTrP9YhvKtMKO6y+QaspzX5byEQBeO+CFOCLk1xUw
         NR37RimIqWtXaUYnZ6JK+ab6/9G9aq3Bt+XIdAHNWKVyf2nFyC6XQVhWdEw7npkf2y+R
         2bXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792554896; x=1793159696;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WwcZhsMFt/apL5mEt1XweWG8RyzKB1xDE1OfQpTu8h8=;
        b=Hd7dBYI8gs93YPsxNVWLSgUkyAjVeYzKzH1fn88pkp3JNAVm/8tBXdYusBMtpjXT4/
         Gth9VtH6L4I3HZeOkSgX5eqbkpEFJ3yY03UoHwLtE0DGOFK28KBo0H6ALL/uPe1rwmJ1
         hl2jSnhunGHPOQCS3reMTzuSO60c/eulQkasG6OMUDdH3mDNX8iwL4O0wsl9GNUUm2sE
         YcyaYF1ZAkU/Fv6LQL20a/whbkMa69GTGQ0qL5YejnRLg3piMuEZ5NeV3c3qsOAn2bJ1
         LzcflD7Zi37hy8KhW5qRGQguo2i13BFXR5O+6emuZGqw3uN866b0fcQhkU7zM0loEQQx
         12yA==
X-Forwarded-Encrypted: i=1; AKwUvBwRVxP0jyJJFfucFPFMhrEamfCYaJjK8sg6y3nBHszfP2xXqXUjXyipYwn5H++U+BbolpoWvgl3bidN@vger.kernel.org
X-Gm-Message-State: AFq9FYLulkDjCzs3IkPHq8qjJmDr5Yb4Kmlq0sdlK2CdOXUt/aszFa+9
	JDID7oytQiWJpEaKtQ0Uh7BoF+7cqyyoa+Fjq8a7FDsJxuoh4vyKyOjits698G0LnTsGUo8xQ13
	ulR+NscC5umuptHzRUBeRtA==
X-Received: from plwg6.prod.google.com ([2002:a17:902:f746:b0:2e8:531a:afe2])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:b45:b0:2e9:4008:6fda with SMTP id d9443c01a7336-2ea43da223fmr7140255ad.28.1792554896111;
 Tue, 20 Oct 2026 20:54:56 -0700 (PDT)
Date: Wed, 21 Oct 2026 11:54:46 +0800
In-Reply-To: <20261021035450.3488805-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261021035450.3488805-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261021035450.3488805-3-stanleyjhu@google.com>
Subject: [PATCH v4 2/6] scsi: ufs: core: Add a helper for clearing hba->outstanding_reqs
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
2.56.0.212.g129ede20d9-goog


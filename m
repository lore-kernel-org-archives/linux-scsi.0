Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792484475;
	b=HCxp1gWN52izwGanBZnkNrydq8B3rAYumyj56yALXA2/Q1xssqWcl0vy1X/+lwo2dF6A
	 uRBlCw6QB5j25mDFn/aOOBDaE1jZNON/475tOUAa73z2BdB/TH3sKL1OW1wOV8KqzgdGF
	 q0jFZ2UHaaSxRM3OCCROLUb+3KtreeZFSbR9ra9erzU40CyJU3r0sZYmwt5TRB1PHPLtf
	 MHrmwczrWi5FKVaKSGy1KqZ0AeuJnuweyOI1QkBrxjSnN+CNj7PnW1VjMSlY8+jWmCnOs
	 6qA9QlUiX7IJe8++mhNdhFFymnAVRnAizxslTF36nX8KIhMivRcKNzkzVFw8nCR6ojw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792484475;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=Ab3Ppi5U2ZBtscUyANpv309FwIIv3hXfnmRHZqkMu2E=;
	b=H1sFVlKEh6dC+UsgrXOQ9s7LUQtg4hsLdeS1SdxGP3QA5jiKZo3dJRMKkjXiPgbX4N/K
	 bNJ5y3aMfB67980NaiN+xjZb9ZQb2Tc/4MaLRiUOA0GLOsVzAuaw4AZ0D3Vpzt9OnMzrU
	 /WFUCWef/n0Xngt5ISepcJ9NYYfZxmbKe7JWo0xDyqSB/leWtvueDTQJmgf5whrIL+F8F
	 vd5nB3pmbdr4e/DEjL6KrF1t9V+7AVxuZhH8Regleim6x8cmutJLWyweXaMuVi5QGBr3R
	 zQCsj5SZwQWlBmhMcjpdVnqup9yAgREF/4WD81NLpuCMu8KDIElFiNmrG8YcGf8dOug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=nGgmHFlG;
	arc=none smtp.remote-ip=209.85.216.71
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6D2606A331
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 08:21:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB6D2606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=nGgmHFlG
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ac16335199so3254949a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 01:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792484474; x=1793089274; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ab3Ppi5U2ZBtscUyANpv309FwIIv3hXfnmRHZqkMu2E=;
        b=nGgmHFlGOHR/4CdMZ9jRrEtoCBGol5VD2dAbWN9yFfQhpgsZaXtFMH7yOTkmmfS2Nt
         I0BZUsdfeim80nDPaju41SSmHv1KiU1Ly9Fz3P8e4y5ZftrH0iFWzxg8tuhgdG7Ux1tB
         /Xju31a7cc96C5aBB+DFKXop4o94CNo05NUZfCmEqBPBcSN7V7CsNzpGwDo+7Xmdsb2E
         F+H/BzYfOCXRIxnfwBfSnBw+M2CtwxDhq06PI7EVCbG5PI7DvtYrRa+8WmxV9t5xo1eC
         gUyKduYKozgxFeB+2uckyvSOo12NgY9NFKalozeufUynOX5SoSafwrSMfSizp9l81Ab3
         jdbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792484474; x=1793089274;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ab3Ppi5U2ZBtscUyANpv309FwIIv3hXfnmRHZqkMu2E=;
        b=JNBU42NQRtb/KnBzBlDnUVnIE7H8VZnU9e1ML3aze0nUR/jgJ7dPjXWqAhJJCwH9fQ
         I/idiESI1Qkk/J1sZ9jlagTDlWVpSfPhzCxAS2h0+slNNUUnWCkpTK6YMwXjROeHkYP5
         NM9uhClWiO2HD9bRf2rgBxeM8ipa9ocQm4pFjA5l0ZBW7ZxTJ3MNogXgD36OPfukUNJV
         9KZwo2kJRIcbvZo8DNnr6WXTqfclRVf2424GuLD81i0Id7Uz2dH4Jl00ZNMNZ8iWjo5+
         q4Pewe3BxsvovX5ytpr6cP5++tnaTuCSs4pL94NTbhtZ+rHqQPA/YPicrUaJPSmgffx9
         LnNw==
X-Forwarded-Encrypted: i=1; AKwUvBxWH9v/7y5Ym10YVDDAefCHWCaYxX+6sH+JkHox+lAUbP2kOBgZ216ckKX3KddVkf/hXoz70Z80Pz0d@vger.kernel.org
X-Gm-Message-State: AFq9FYLCv9Xc6imTPRFna1RG5wLBFv9MMMFgNLLbOGeKerqrNfjcaph6
	Ae6ja1uzx4KmmoJpAEOUgiw0UJtafIxZjO5cmbBJ1OZrrR0cWGqRBI0diXUwTa5vqqqp25F8oKn
	ytLcNc96l62B6f1cuiV2jLQ==
X-Received: from pjbpb2.prod.google.com ([2002:a17:90b:3c02:b0:3ab:54fb:2a3d])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4d0d:b0:3aa:fdad:7d6c with SMTP id 98e67ed59e1d1-3acef5b08bamr8689912a91.58.1792484474134;
 Tue, 20 Oct 2026 01:21:14 -0700 (PDT)
Date: Tue, 20 Oct 2026 16:21:04 +0800
In-Reply-To: <20261020082110.3511797-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261020082110.3511797-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261020082110.3511797-2-stanleyjhu@google.com>
Subject: [PATCH v3 1/7] scsi: ufs: core: Remove an always-false WARN_ONCE()
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The WARN_ONCE() in ufshcd_poll() can never fire. completed_reqs is set
to ~tr_doorbell & hba->outstanding_reqs on the line above, and
hba->outstanding_reqs cannot change in between because ufshcd_poll()
holds hba->outstanding_lock. So completed_reqs & ~hba->outstanding_reqs
is always zero. Remove it. No functional change.

Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bcc2512bf34b..12aafcf1f9b3 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6072,9 +6072,6 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
 	spin_lock_irqsave(&hba->outstanding_lock, flags);
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
-	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
-		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
-		  hba->outstanding_reqs);
 	if (queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT) {
 		/* Do not complete polled requests from interrupt context. */
 		ufshcd_clear_polled(hba, &completed_reqs);
-- 
2.56.0.212.g129ede20d9-goog


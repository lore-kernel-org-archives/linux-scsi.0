Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2BA3D1CD7
	for <linux-scsi@vger.kernel.org>; Sat, 17 Oct 2026 08:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792226655; cv=none; b=luM6e5EIX80sMXpaYSePlNZfFOVgbpG5PM4jVBed+O5Wk5x3d484Mm1MwJaJIt/DGKOm1vOqKJ88m4+Mx98QSEaJekM2pWpvUsGWWyk/Udt2pTYKF1cbXPdvY2Ikqdyobpe4W+4F7A6YvbYiYOquENWDp2TpOCZRlJhevNmy1BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792226655; c=relaxed/simple;
	bh=nNGZPxGajGScZteR3AEZleUpWmZWOj/MZH2azt7bWWA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DXMDnGRqTSPLV9q+h/WOlSExl/f9gx2JjJqdO5MCMUnsfWBAwMLLIVazdhhCayyYrhTSE40Lkj7poS03Bt9lrDlzNCfR86hZK7J+04TrRXNUIk9qQOC5WcGidc9jZBNRl/eQ51lnHfB+tXQrE4ZmhddFN8dSKRNrGAuGL1/r1TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D3jbykSu; arc=none smtp.client-ip=209.85.215.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D3jbykSu"
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cb11535e6a1so541755a12.0
        for <linux-scsi@vger.kernel.org>; Sat, 17 Oct 2026 01:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792226654; x=1792831454; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RI1tfjYq23KVY/xwmwRN46w/ZXhzGsWBQ9x8Pqo81Ko=;
        b=D3jbykSuHNZmLeN5NkFYE1CGIy9WcB1MMBPVPsA09EOzoZmNKTTqwlO5Xv27BKl+2J
         uL8tq4xOf+XOa5tZ3BJBtbd45aYlIQpFUM5fv7wRSmFU6x9RFM+tCX/Dk7jwTYIaAD62
         twHJKgVuNuRSiEZFJ92S5SMDYzMQw4GNZirb0FLbukT/WuHDWkEmJf9jdsI629KBGb8k
         gd0Yn+enBgwhsVoxYP7OZFXC+aX4le8f9aKsCnIOwn2FQxaIYzW7rdf0YuH/mN+SIsZ8
         GtIrKWdZ/O3O37yFR0eYIJB9Hrnr6OCQ4ea4I5OzIz63S4Z/tv2rplzprJwX/8jywabO
         g6GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792226654; x=1792831454;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RI1tfjYq23KVY/xwmwRN46w/ZXhzGsWBQ9x8Pqo81Ko=;
        b=lwMmpKkW0o0E9CsYGGeqg7Fk/mZ/mshTfLf/2Vj6DkKRzCBHAdlqsZ1aLFnZZD5wxS
         gdg/tJtlaAS87u/R8Hv0j6WGqG0vujnZiIweUGzt2xVaz+ISX8WrbwXOsXAnNcE1OxDg
         CsJSIyDdpH0poYAySk9u6hbfGMQgTjCLE7u8CgoSrX7U+zktI5p1a5+hQR3nQgHvjweu
         r7JCPxSOq5/vzqRYa6XyaLy5mBYhKVI4sQLUWWnnlM4tqQnihx6WXtWVRdHl8mtyAhyW
         E62crNj1Izvh1uRh1XFhsEs5f2SR4DYUZNknTZfqGasHEkJBkx+6GykRDipSKUjNRbZr
         +iHQ==
X-Forwarded-Encrypted: i=1; AKwUvBz215nLXRVzJS3QWi1HDclgzzZPuucF3sroZmaeuCU2EwkyZL8zbq8MuSNC3xUClLOPvcE97COcSlZr@vger.kernel.org
X-Gm-Message-State: AFq9FYJUBdr3dSgaAn7VnAy2b/Fy3mmJ5cnBViHaFvQCZpT2NFL209/9
	itlE7H1Dxzo/sN1ge+KQez9MzqzBdhz1yhvF4atDlQMnCmgB3KoNkmVIjW3tuh+zagOY5pNY3a8
	evhZqouh6Rx/Q0SL8slckTA==
X-Received: from pgcz8.prod.google.com ([2002:a63:7e08:0:b0:cd0:bb2c:3923])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:244e:b0:3e2:799:f2dc with SMTP id adf61e73a8af0-3e226080597mr1399659637.40.1792226653445;
 Sat, 17 Oct 2026 01:44:13 -0700 (PDT)
Date: Sat, 17 Oct 2026 16:44:03 +0800
In-Reply-To: <20261017084403.875420-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261017084403.875420-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261017084403.875420-5-stanleyjhu@google.com>
Subject: [PATCH v2 4/4] scsi: ufs: core: Remove an always-false WARN_ONCE()
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The WARN_ONCE() in __ufshcd_clear_outstanding_reqs() can never fire.
completed_reqs is set to mask & hba->outstanding_reqs on the line above,
and hba->outstanding_reqs cannot change in between because the caller
holds hba->outstanding_lock. So completed_reqs & ~hba->outstanding_reqs
is always zero. Remove it. No functional change.

Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 44e571757535..716dab2352e9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6059,9 +6059,6 @@ static unsigned long __ufshcd_clear_outstanding_reqs(struct ufs_hba *hba,
 	unsigned long completed_reqs = mask & hba->outstanding_reqs;
 
 	lockdep_assert_held(&hba->outstanding_lock);
-	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
-		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
-		  hba->outstanding_reqs);
 	if (from_irq) {
 		/* Do not complete polled requests from interrupt context. */
 		ufshcd_clear_polled(hba, &completed_reqs);
-- 
2.56.0.176.g3575e65682-goog


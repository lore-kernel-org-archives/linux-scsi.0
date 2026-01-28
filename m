Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688D734DB4F;
	Wed, 28 Jan 2026 09:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769594163; cv=none; b=tz2xPbtiXfZ3v1ERYk+WMteoAWW37pgp9kgKgMfmESpLdIZVa7XeL69onmputJLOeKuw+/WuZGBRkcwHVo9/kdO0tADA5v/OeL0gqhEv2058j/fo77AMdH0fsOuapPOddR6rEIEzC1OKiaFdl56iMz1GSwwVhidEHqWkLXSpds4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769594163; c=relaxed/simple;
	bh=kAYhzYUCG6EZznpIaohCcnuhrLdzkqfcRINK9xYw4jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vr+2u/buj3Ycm46gQtLW5+uysPIA1vHPLyZSZaF6Ivg4rtXK+fspuCN8vW+QgXdWm3v0F40JdJJvP4JvVhIRchpCVfBYCLkk5D2z7f9oKgfWGHIx/qpz3wWJfQF2CmjrZ9vai437sS0IlH6uOjRrzaegH7sNSIaR54LsSurXK7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=DQv24yyP; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Vz5fFTB5; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="DQv24yyP";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Vz5fFTB5"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1769594159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7E9srkZlzV0RaeI0Fc1FXkJoZJJK+GqLTBxgkhDhRlI=;
	b=DQv24yyP1W94j/w2nNfH1auBtPpgzHdH8ZJRxdfKvJWCRPKIDem15dHQHmbiULAGsg1XT9
	AroX320Kx2U4Qvy5YK+Dd2io1IzujVytvz4ee/tDad6F3Ln5a6Go/2GnVIcN/HAHixVo8B
	I3c+4qqLNqWz1vMyIV6RYzshBkNN3e1mYYLZFkqalIWtNssHCfYaoqBKWqeOVajZDIiWWa
	+lgd6iHBWcFo1G8H8d9z+o0j7jK+fe5rhlJ3GocYgVmH/FiuqYl02qXDjtZZY5ZRHnvp5D
	ycu/QvkVwP902k71YwOBHy+7Gxoi+j6cCuHc5NOLOLyDB0nhFqjJpPNM7/bcqQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1769594159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7E9srkZlzV0RaeI0Fc1FXkJoZJJK+GqLTBxgkhDhRlI=;
	b=Vz5fFTB5QFJuPcwecysb8hVUn/Tch3fQI5HeIfzwp5e2U5I8wCk6KoZULbsta/k529fDb6
	ioddQdldPQAdSGBQ==
To: linux-kernel@vger.kernel.org
Cc: "Thomas Gleixner" <tglx@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH v2 07/20] scsi: efct: Use IRQF_ONESHOT and default primary handler
Date: Wed, 28 Jan 2026 10:55:27 +0100
Message-ID: <20260128095540.863589-8-bigeasy@linutronix.de>
In-Reply-To: <20260128095540.863589-1-bigeasy@linutronix.de>
References: <20260128095540.863589-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

There is no added value in efct_intr_msix() compared to
irq_default_primary_handler().

Using a threaded interrupt without a dedicated primary handler mandates
the IRQF_ONESHOT flag to mask the interrupt source while the threaded
handler is active. Otherwise the interrupt can fire again before the
threaded handler had a chance to run.

Use the default primary interrupt handler by specifying NULL and set
IRQF_ONESHOT so the interrupt source is masked until the secondary
handler is done.

Fixes: 4df84e8466242 ("scsi: elx: efct: Driver initialization routines")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
Cc: Ram Vegesna <ram.vegesna@broadcom.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org
---
 drivers/scsi/elx/efct/efct_driver.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/ef=
ct_driver.c
index 1bd42f7db1773..528399f725d42 100644
--- a/drivers/scsi/elx/efct/efct_driver.c
+++ b/drivers/scsi/elx/efct/efct_driver.c
@@ -415,12 +415,6 @@ efct_intr_thread(int irq, void *handle)
 	return IRQ_HANDLED;
 }
=20
-static irqreturn_t
-efct_intr_msix(int irq, void *handle)
-{
-	return IRQ_WAKE_THREAD;
-}
-
 static int
 efct_setup_msix(struct efct *efct, u32 num_intrs)
 {
@@ -450,7 +444,7 @@ efct_setup_msix(struct efct *efct, u32 num_intrs)
 		intr_ctx->index =3D i;
=20
 		rc =3D request_threaded_irq(pci_irq_vector(efct->pci, i),
-					  efct_intr_msix, efct_intr_thread, 0,
+					  NULL, efct_intr_thread, IRQF_ONESHOT,
 					  EFCT_DRIVER_NAME, intr_ctx);
 		if (rc) {
 			dev_err(&efct->pci->dev,
--=20
2.51.0


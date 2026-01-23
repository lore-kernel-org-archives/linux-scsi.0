Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4238322B63;
	Fri, 23 Jan 2026 11:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769168242; cv=none; b=sKFUImnGboZ0jJSyqxPYlAt2DBqJ/7sQdLtjR5+A1mb0m1NnnQB7OdIwsmlWIFkxr83dDLpZd882FOYbYT85DFzWlW6ize5TKt9WmfRI9Zrf504ZH83JQI6bE5IbEVJjHmtjIGoj1kaqBBFLDIYmFop0V48F4g7ipwPzrxZ3XE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769168242; c=relaxed/simple;
	bh=M5c3tXigRIz1ko/jRr/tyGr0A5Rrlc8uX70DDQEzMb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0POUcIVmwXDrLDoj/UOJK5p1qIdNVtSmRZRlzh3ksZeLa5sBMRPGdG6k4rCmFvO8p1zhFHFuvskF6gjou0+4r7Tj3yKyd6EN3RzdBTCl5h+sgSDONDw/GdbzkFLyIo1QzP4Yd1KU3sbwRb81J3GC4Zml3QpOjlnTTAljFdRovo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=FLBA+VVF; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=DxErlska; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="FLBA+VVF";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="DxErlska"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1769168235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c12/WiBOl4+VRMfczalP737Fey9tqb3UHR0QHYUaIoI=;
	b=FLBA+VVFXW6I6FPGBSSgqlEaZ9HAesjOkNAPZZhXBtrc33gFGDd3WV5cYa6N9Fuded/d19
	PMz4rLsr7PemXQd9cFUR+XWV4uSQmTKXQrdYBjiJedGE42ofX4C3DuDcSj2VmOTvakCSSf
	1kEnRU92cin87wUgq++7Ut/famllZ9eRhzvl0HsNyuweUpWyKxxUa2k87zri5dQXVCyMcs
	T9t6d2R+0Ov3KJZC3gp22Tlf2hhnSde0QgWX+5UMdT74NPdGpxHZ9lQ5u+Rp9JlzCBJSD0
	+/3T4IcYq8jOyqKb/l03Dpfo9IrmceO4EDA+kNjEWTVv9z2UDB11a0VTF5btNw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1769168235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c12/WiBOl4+VRMfczalP737Fey9tqb3UHR0QHYUaIoI=;
	b=DxErlskavT9kX1FQ63dwResmsEBBLI83P0C4MDTGTR2vpZ0mphL3P5ynEzNsf8yBE7zHeK
	sTDeTCZXPk+mjuAg==
To: linux-kernel@vger.kernel.org
Cc: linux-rt-devel@lists.linux.dev,
	Thomas Gleixner <tglx@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH 07/21] scsi: efct: Use IRQF_ONESHOT and default primary handler
Date: Fri, 23 Jan 2026 12:36:53 +0100
Message-ID: <20260123113708.416727-8-bigeasy@linutronix.de>
In-Reply-To: <20260123113708.416727-1-bigeasy@linutronix.de>
References: <20260123113708.416727-1-bigeasy@linutronix.de>
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

Cc: Ram Vegesna <ram.vegesna@broadcom.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org
Fixes: 4df84e8466242 ("scsi: elx: efct: Driver initialization routines")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
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


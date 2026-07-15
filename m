Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A41143A7E5
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2026 17:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784135577; cv=none; b=GJig7EsxADRor8BlrPUjgtzwhgYugHGGagH3TIsyLj563v3uBlkP6gV8WyPu9c9qzJVJJrA1uDlZQOXknKOXRL+kfqlLf843BXGJgwS6jvag84fqR7rtXDNW7wWxvabSWoPL6oKqbuOxiUvRqHox5C6t6vTkVJUOPaXWZvmScQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784135577; c=relaxed/simple;
	bh=H27oK54k8C87IHe+cgArUtwo/nGKySf3g36b1Kn+w68=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rxpkykZST+RGRGFzq0lNJL7alltZT8j0CCJ2sCRG/BBpU/I1iJoOWkOKQkmHEVMCNWulqBNp6PsEPmp+kh8aqsE2tsqpCAEG5ma66ujmcPAVMje7cLW2xAVXi+ltQazq9TO/w32Hfq50szv+QQYFBZUv3DEFv97ImqcyGUvZxro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qjeMbGlw; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qjeMbGlw"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4h0jRN6V4lz1XM6JS;
	Wed, 15 Jul 2026 17:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:mime-version
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1784135562; x=1786727563; bh=zXlC/
	KIPL4IRXlfqH+gGr13V0IirDa6aDxdsv2d83nU=; b=qjeMbGlwCM4WH85QlnnFO
	W91mPeiBUZWE6BjrdvoYeezB0inGXZEDn5f+4epyWmuqzzYlPGzjt2nxB1Lnb3Pq
	GM2T/1qp+BspTRYjoCv+VAgGPFoSZUy4bL2c+zK0HoNp65s/S+yGcKY/Wkg5pIXi
	qzIWGurogR6muqoF6t2pzV431MLfEKy7nGzOJInOPGeYhwDHLslxfer5W4ei5FXA
	Wk8rt1whvax1H/rrEPsn2KKKPVCoeyhQKqXeiz1uURZakBN5LaFKTLXR767PHtTJ
	vxOzjrJH6+V8lq1MblHFQeG5gYUNtYWsC0qIcmzyHlt8/JFL6Hn0aGp9VLcBAmz0
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JgTcI53ItPsM; Wed, 15 Jul 2026 17:12:42 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4h0jRD1B29z1XM5kD;
	Wed, 15 Jul 2026 17:12:39 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	=?UTF-8?q?=E5=AD=99=E9=AD=81=20=28Kui=20Sun=29?= <kui.sun@unisoc.com>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] ufs: core: Revert "Delegate the interrupt service routine to a threaded IRQ handler"
Date: Wed, 15 Jul 2026 10:12:28 -0700
Message-ID: <b70eb60a01f971bed68c42c5b555929db5f835df.1784135511.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

There have been multiple reports of performance regressions caused by
commit 3c7ac40d7322. Hence this revert.

This patch reverts most of the following commits:
* 3c7ac40d7322 ("scsi: ufs: core: Delegate the interrupt service routine =
to
  a threaded IRQ handler")
* 6475cfb81fc4 ("scsi: ufs: core: Avoid IRQ thread wakeup during active U=
IC
  command")

This patch preserves the following commits:
* 034d319c8899 ("scsi: ufs: core: Fix interrupt handling for MCQ Mode")
* eabcac808ca3 ("scsi: ufs: core: Fix IRQ lock inversion for the SCSI hos=
t
  lock")

Neil, please check whether this patch series fixes the stalls that you
reported: [f2fs-dev] [PATCH 0/4] Reduce the time spent in interrupt conte=
xt
(https://sourceforge.net/p/linux-f2fs/mailman/linux-f2fs-devel/thread/4b3=
37c7f-2fbd-47b6-9c8c-587e7b5513f1%40kernel.org/#msg59345049).

Cc: Neil Armstrong <neil.armstrong@linaro.org>
Cc: =E5=AD=99=E9=AD=81 (Kui Sun) <kui.sun@unisoc.com>
Cc: Andr=C3=A9 Draszik <andre.draszik@linaro.org>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Fixes: 3c7ac40d7322 ("scsi: ufs: core: Delegate the interrupt service rou=
tine to a threaded IRQ handler")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 39 +++------------------------------------
 1 file changed, 3 insertions(+), 36 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 79331c2bd38d..56c96a3b10e2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7356,7 +7356,7 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *h=
ba, u32 intr_status)
 }
=20
 /**
- * ufshcd_threaded_intr - Threaded interrupt service routine
+ * ufshcd_intr - Main interrupt service routine
  * @irq: irq number
  * @__hba: pointer to adapter instance
  *
@@ -7364,7 +7364,7 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *h=
ba, u32 intr_status)
  *  IRQ_HANDLED - If interrupt is valid
  *  IRQ_NONE    - If invalid interrupt
  */
-static irqreturn_t ufshcd_threaded_intr(int irq, void *__hba)
+static irqreturn_t ufshcd_intr(int irq, void *__hba)
 {
 	u32 last_intr_status, intr_status, enabled_intr_status =3D 0;
 	irqreturn_t retval =3D IRQ_NONE;
@@ -7403,38 +7403,6 @@ static irqreturn_t ufshcd_threaded_intr(int irq, v=
oid *__hba)
 	return retval;
 }
=20
-/**
- * ufshcd_intr - Main interrupt service routine
- * @irq: irq number
- * @__hba: pointer to adapter instance
- *
- * Return:
- *  IRQ_HANDLED     - If interrupt is valid
- *  IRQ_WAKE_THREAD - If handling is moved to threaded handled
- *  IRQ_NONE        - If invalid interrupt
- */
-static irqreturn_t ufshcd_intr(int irq, void *__hba)
-{
-	struct ufs_hba *hba =3D __hba;
-	u32 intr_status, enabled_intr_status;
-
-	/*
-	 * Handle interrupt in thread if MCQ or ESI is disabled,
-	 * and no active UIC command.
-	 */
-	if ((!hba->mcq_enabled || !hba->mcq_esi_enabled) &&
-	    !hba->active_uic_cmd)
-		return IRQ_WAKE_THREAD;
-
-	intr_status =3D ufshcd_readl(hba, REG_INTERRUPT_STATUS);
-	enabled_intr_status =3D intr_status & ufshcd_readl(hba, REG_INTERRUPT_E=
NABLE);
-
-	ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
-
-	/* Directly handle interrupts since MCQ ESI handlers does the hard job =
*/
-	return ufshcd_sl_intr(hba, enabled_intr_status);
-}
-
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
 {
 	int err =3D 0;
@@ -11233,8 +11201,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
 	ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
=20
 	/* IRQ registration */
-	err =3D devm_request_threaded_irq(dev, irq, ufshcd_intr, ufshcd_threade=
d_intr,
-					IRQF_ONESHOT | IRQF_SHARED, UFSHCD, hba);
+	err =3D devm_request_irq(dev, irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hb=
a);
 	if (err) {
 		dev_err(hba->dev, "request irq failed\n");
 		goto out_disable;

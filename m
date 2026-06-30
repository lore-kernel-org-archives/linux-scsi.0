Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880563C5DBE
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2026 09:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782813373; cv=none; b=gr0ppKlhBZIsLKxA/3IFxEikDI8e20LsjtMWM/d9iZexm9AnWAFpfChMbjxpPfaMK/UKB+uE19NiYMIoJyP27YvYcGlDN8Ih7PRBpbri/sdUz/mXsM370oZJoOzQkpw90Q1QhaRGzTDyDS6nQGZ65OXEmvxWR84/iefYaY1tYiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782813373; c=relaxed/simple;
	bh=VRmgnQpSg5hIgp1YUN6xAyB6cTIX00rEaR75Vv3U9M0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=IUnFxlHx1ndUDAJISOE8d7lrRz9gWZRgNCxVPJQmcDtmFO7gGFg+jJAuUuwOqMPeUXdgrtXJQpYLFDZPNib19P6D78CYC4BgqpkxbeHdvxHX4UiNUuyRwWnF43qio6POVW8yg7ZOvb/q4lIAh7sL3qgZO4+XAXXxOZ9Wp7fh/A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=Y+8me/s7; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="Y+8me/s7"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id DFB784E40BA4;
	Tue, 30 Jun 2026 09:56:08 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id B09196025A;
	Tue, 30 Jun 2026 09:56:08 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A3F02106F087C;
	Tue, 30 Jun 2026 11:56:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1782813367; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=4nwKNrGzMcaIXvoYBaIBeDI+oTAk2QHGtD6EFpPp5ws=;
	b=Y+8me/s7+wBTeCrPMn5w/9xgcMzgUO+DZSoh4GTmhMNsC6hofliEEsR4a3pGbFl2YIoUUj
	auNGUZnJkHdW2Hi10yRwFzuxwc9VmbZOfVJKtFqBEV+Y4846FdMI+4aSNSDq0sTrrQOZe2
	t4JFwrrUHRc/K0BXZmO0UO2yYpspIwLZf39oYI3H0AYflcqmVNCAlgTUKqWB9wFH2Sbo/e
	Ir0an+Bm035+VzwNrefeaGeEc3+crWBKeSIP98wECwsDc00W+1r4DZhng0i6PbwkzcRXUH
	xk1tu6TJk6b1R+z9o/6+ApJkvAGU0yz+mdudTJcn4M66Ma1rmUAV6J9K0L0HPg==
From: Gregory CLEMENT <gregory.clement@bootlin.com>
Date: Tue, 30 Jun 2026 11:55:23 +0200
Subject: [PATCH] scsi: ufs: core: Avoid sleeping in hard interrupt context
 when PREEMP_RT is enabled.
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260630-ufshcd-spinlock-sleep-fix-v1-1-339b05a1c6f4@bootlin.com>
X-B4-Tracking: v=1; b=H4sIAIqSQ2oC/x2MQQqAIBAAvxJ7bkEtSvpKdAhdaylMXIog+nvSc
 QZmHhDKTAJD9UCmi4WPWEDXFbh1jgsh+8JglOlU1yg8g6zOoySO++E2lJ0oYeAbbWut1sHY2fd
 Q+pSp6P89Tu/7AcEVnfFrAAAA
X-Change-ID: 20260630-ufshcd-spinlock-sleep-fix-848811f28ad7
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Vladimir Kondratiev <vladimir.kondratiev@mobileye.com>, 
 =?utf-8?q?Beno=C3=AEt_Monin?= <benoit.monin@bootlin.com>, 
 =?utf-8?q?Th=C3=A9o_Lebrun?= <theo.lebrun@bootlin.com>, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-rt-devel@lists.linux.dev, 
 Gregory CLEMENT <gregory.clement@bootlin.com>
X-Mailer: b4 0.14.3
X-Last-TLS-Session-Version: TLSv1.3

PREEMPT_RT turns spinlock in a mutex that cannot be used in interrupt
context. Since commit 3c7ac40d7322 ("scsi: ufs: core: Delegate the
interrupt service routine to a threaded IRQ handler"), the hard
interrupt handler is not converted into a threaded interrupt handler
(due to the IRQF_ONESHOT flag). This can lead to the use of a sleeping
function inside the interrupt context.

[    0.654017] scsi host0: ufshcd
[    0.659867] BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
[    0.659878] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 0, name: swapper/0
[    0.659882] preempt_count: 10001, expected: 0
[    0.659885] RCU nest depth: 0, expected: 0
[    0.659892] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.1.0-rc3 #1 PREEMPT_RT
[    0.659903] Call Trace:
[    0.659907] [<ffffffff800148fe>] dump_backtrace+0x1c/0x24
[    0.659924] [<ffffffff80001580>] show_stack+0x28/0x34
[    0.659931] [<ffffffff8000ea7c>] dump_stack_lvl+0x5e/0x86
[    0.659937] [<ffffffff8000eab8>] dump_stack+0x14/0x1c
[    0.659942] [<ffffffff8005d07e>] __might_resched+0x138/0x142
[    0.659956] [<ffffffff808bea82>] rt_spin_lock+0x38/0x144
[    0.659965] [<ffffffff806d4b0a>] ufshcd_sl_intr+0x30a/0x622
[    0.659973] [<ffffffff806d50bc>] ufshcd_intr+0x86/0x9c
[    0.659979] [<ffffffff8009f072>] __handle_irq_event_percpu+0xa6/0x370
[    0.659987] [<ffffffff8009f3d2>] handle_irq_event+0x42/0x98
[    0.659992] [<ffffffff800a43ce>] handle_fasteoi_irq+0x11a/0x244
[    0.660002] [<ffffffff8009e718>] handle_irq_desc+0x38/0x46
[    0.660007] [<ffffffff8009e764>] generic_handle_irq+0x26/0x2e
[    0.660013] [<ffffffff8054f1e2>] aplic_direct_handle_irq+0xa0/0x158
[    0.660022] [<ffffffff8009e718>] handle_irq_desc+0x38/0x46
[    0.660027] [<ffffffff8009e7f2>] generic_handle_domain_irq+0x12/0x1a
[    0.660032] [<ffffffff8054df10>] riscv_intc_irq+0x2a/0x64
[    0.660038] [<ffffffff808b2708>] handle_riscv_irq+0x52/0x82
[    0.660048] [<ffffffff808c2fca>] call_on_irq_stack+0x32/0x40

This commit mitigates the issue by directly registering the thread
interrupt handler without involving a hard IRQ handler. This will only
be done when PREEMP_RT is enabled, which automatically turns all
interrupt handlers into threaded interrupt handlers.

Fixes: 3c7ac40d7322 ("scsi: ufs: core: Delegate the interrupt service routine to a threaded IRQ handler")
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
---
 drivers/ufs/core/ufshcd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d3044a3089b53..6d82658a1a66b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -11235,9 +11235,17 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	 */
 	ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
 
-	/* IRQ registration */
+	/* IRQ registration
+	 * In the case of PREMMP_RT, directly use the threaded
+	 * interrupt to avoid using a spinlock (which could sleep)
+	 * in the hard IRQ handler.
+	 */
+#ifdef CONFIG_PREEMPT_RT
+	err = devm_request_irq(dev, irq, ufshcd_threaded_intr, IRQF_SHARED, UFSHCD, hba);
+#else
 	err = devm_request_threaded_irq(dev, irq, ufshcd_intr, ufshcd_threaded_intr,
 					IRQF_ONESHOT | IRQF_SHARED, UFSHCD, hba);
+#endif
 	if (err) {
 		dev_err(hba->dev, "request irq failed\n");
 		goto out_disable;

---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260630-ufshcd-spinlock-sleep-fix-848811f28ad7

Best regards,
-- 
Grégory CLEMENT, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com


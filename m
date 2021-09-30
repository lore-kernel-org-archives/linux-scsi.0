Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64C48C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 10:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E76F615E0
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 10:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350026AbhI3Kjr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 06:39:47 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49346 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349928AbhI3Kjr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Sep 2021 06:39:47 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1632998283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gXKSd/eksGYlMXTl37jwPIp0QpmS4EnfQLz9qLhbL+U=;
        b=dZsaYk14rnWbCheFjm1+76wdyt/mIC1xLKu7Ir8lYv2GEWuYHjdnJHkBihfkAvgYGVv6QN
        X18KDfTlmlbwoKZSdlWru0djfrBi7o9/2ZeHTbe4b0Nq9uGz4n8WdptxtRXLrVozd+vrs0
        +/Z73pr5RlgFacCx9nsDbnSgOgL+H8OqTGDSDpP4XqqyqdAIzoFOJW/bqdCvCZP6HPmyWi
        qJ8kjtfnYj93vUxBK5pind1qJcOJsoLEDtsw6mRqads1uS36IYTjXl0FfS+XcSLGepMDX6
        wiQSuwSus6W7EUCYRwNRyAUAp17FZix4sOYqtj85v9Zbul5fAgesN0J8B2VEhA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1632998283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gXKSd/eksGYlMXTl37jwPIp0QpmS4EnfQLz9qLhbL+U=;
        b=Jo5akA/m700YnlHuygrlIKeSG5iI2vbZRNNbjYACd75zuZiXisT/Gkfnt6+ZyRgLYS+8IF
        F3MvWQI5ANOT+2AQ==
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] irq_poll: Use raise_softirq_irqoff() in cpu_dead notifier
Date:   Thu, 30 Sep 2021 12:37:54 +0200
Message-Id: <20210930103754.2128949-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

__raise_softirq_irqoff() adds a bit to the pending sofirq mask and this
is it. The softirq won't be handled in a deterministic way but randomly
when an interrupt fires and handles softirq in its irq_exit() routine or
if something randomly checks and handles pending softirqs in the call
chain before the CPU goes idle.

Add a local_bh_disable/enable() around the IRQ-off section which will
handle pending softirqs.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 lib/irq_poll.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/irq_poll.c b/lib/irq_poll.c
index 2f17b488d58e1..2b9f797642f60 100644
--- a/lib/irq_poll.c
+++ b/lib/irq_poll.c
@@ -191,11 +191,13 @@ static int irq_poll_cpu_dead(unsigned int cpu)
 	 * If a CPU goes away, splice its entries to the current CPU
 	 * and trigger a run of the softirq
 	 */
+	local_bh_disable();
 	local_irq_disable();
 	list_splice_init(&per_cpu(blk_cpu_iopoll, cpu),
 			 this_cpu_ptr(&blk_cpu_iopoll));
 	__raise_softirq_irqoff(IRQ_POLL_SOFTIRQ);
 	local_irq_enable();
+	local_bh_enable();
=20
 	return 0;
 }
--=20
2.33.0


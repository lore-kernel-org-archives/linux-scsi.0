From: akpm@linux-foundation.org
Subject: [patch 32/33] SCSI-BusLogic: local_irq_disable() is redundant after local_irq_save()
Date: Mon, 05 Feb 2007 16:39:03 -0800
Message-ID: <200702060040.l160e7tT005059@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41811 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965341AbXBFAkM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Feb 2007 19:40:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jkosina@suse.cz

From: Jiri Kosina <jkosina@suse.cz>

drivers/scsi/BusLogic.c::BusLogic_Command() contains local_irq_disable() call
after local_irq_save().  This looks redundant.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/BusLogic.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/scsi/BusLogic.c~scsi-buslogic-local_irq_disable-is-redundant-after-local_irq_save drivers/scsi/BusLogic.c
--- a/drivers/scsi/BusLogic.c~scsi-buslogic-local_irq_disable-is-redundant-after-local_irq_save
+++ a/drivers/scsi/BusLogic.c
@@ -362,10 +362,8 @@ static int BusLogic_Command(struct BusLo
 	   interrupt could occur if the IRQ Channel was previously enabled by another
 	   BusLogic Host Adapter or another driver sharing the same IRQ Channel.
 	 */
-	if (!HostAdapter->IRQ_ChannelAcquired) {
+	if (!HostAdapter->IRQ_ChannelAcquired)
 		local_irq_save(ProcessorFlags);
-		local_irq_disable();
-	}
 	/*
 	   Wait for the Host Adapter Ready bit to be set and the Command/Parameter
 	   Register Busy bit to be reset in the Status Register.
_

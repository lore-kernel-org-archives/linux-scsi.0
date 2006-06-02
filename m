From: akpm@osdl.org
Subject: [patch 18/25] mpt_interrupt() should return IRQ_NONE when appropriate
Date: Thu, 01 Jun 2006 20:42:44 -0700
Message-ID: <200606020338.k523cPtr029258@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:53175 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751235AbWFBDip (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2006 23:38:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, jbeulich@novell.com, Eric.Moore@lsil.com


From: "Jan Beulich" <jbeulich@novell.com>

The way mpt_interrupt() was coded, it was impossible for the unhandled
interrupt detection logic to ever trigger. All interrupt handlers should
return IRQ_NONE when they have nothing to do.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/message/fusion/mptbase.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~mpt_interrupt-should-return-irq_none-when drivers/message/fusion/mptbase.c
--- devel/drivers/message/fusion/mptbase.c~mpt_interrupt-should-return-irq_none-when	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/message/fusion/mptbase.c	2006-06-01 20:41:51.000000000 -0700
@@ -372,20 +372,21 @@ static irqreturn_t
 mpt_interrupt(int irq, void *bus_id, struct pt_regs *r)
 {
 	MPT_ADAPTER *ioc = bus_id;
-	u32 pa;
+	u32 pa = CHIPREG_READ32_dmasync(&ioc->chip->ReplyFifo);
+
+	if (pa == 0xFFFFFFFF)
+		return IRQ_NONE;
 
 	/*
 	 *  Drain the reply FIFO!
 	 */
-	while (1) {
-		pa = CHIPREG_READ32_dmasync(&ioc->chip->ReplyFifo);
-		if (pa == 0xFFFFFFFF)
-			return IRQ_HANDLED;
-		else if (pa & MPI_ADDRESS_REPLY_A_BIT)
+	do {
+		if (pa & MPI_ADDRESS_REPLY_A_BIT)
 			mpt_reply(ioc, pa);
 		else
 			mpt_turbo_reply(ioc, pa);
-	}
+		pa = CHIPREG_READ32_dmasync(&ioc->chip->ReplyFifo);
+	} while (pa != 0xFFFFFFFF);
 
 	return IRQ_HANDLED;
 }
_

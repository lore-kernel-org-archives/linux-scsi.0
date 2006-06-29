From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH] mptbase: mpt_interrupt should return IRQ_NONE
Date: Thu, 29 Jun 2006 17:38:43 -0600
Message-ID: <20060629233842.GB22380@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:5772 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750779AbWF2XvQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jun 2006 19:51:16 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: akpm@osdl.com

The way mpt_interrupt() was coded, it was impossible for the unhandled
interrupt detection logic to ever trigger. All interrupt handlers should
return IRQ_NONE when they have nothing to do.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@osdl.com>
Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


diff -uarpN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2006-06-29 15:57:54.000000000 -0600
+++ a/drivers/message/fusion/mptbase.c	2006-06-29 15:59:46.000000000 -0600
@@ -369,20 +369,21 @@ static irqreturn_t
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

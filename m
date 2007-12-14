From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] [SCSI] sym53c8xx: fix "irq X: nobody cared" regression in
 2.6.24
Date: Fri, 14 Dec 2007 15:45:16 -0500
Message-ID: <4762EB5C.9080100@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host06.cybernetics.com ([206.246.200.22]:3960 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbXLNUpD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Dec 2007 15:45:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

The patch described by the following excerpt from ChangeLog-2.6.24-rc1
eventually causes a "irq X: nobody cared" error after a while:

commit 99c9e0a1d6cfe1ba1169a7a81435ee85bc00e4a1
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Fri Oct 5 15:55:12 2007 -0400

    [SCSI] sym53c8xx: Make interrupt handler capable of returning IRQ_NONE

After this happens, the kernel disables the IRQ, causing the SCSI card
to stop working until the next reboot.  The problem is caused by the
interrupt handler returning IRQ_NONE instead of IRQ_HANDLED after
handling an interrupt-on-the-fly (INTF) condition.  The following patch
fixes the problem.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

James, please queue for scsi-rc-fixes-2.6.  Thanks!

--- linux-2.6.24-rc5-git3/drivers/scsi/sym53c8xx_2/sym_hipd.c.orig	2007-12-14 15:07:09.000000000 -0500
+++ linux-2.6.24-rc5-git3/drivers/scsi/sym53c8xx_2/sym_hipd.c	2007-12-14 15:07:31.000000000 -0500
@@ -2791,7 +2791,7 @@ irqreturn_t sym_interrupt(struct Scsi_Ho
 	istat = INB(np, nc_istat);
 	if (istat & INTF) {
 		OUTB(np, nc_istat, (istat & SIGP) | INTF | np->istat_sem);
-		istat = INB(np, nc_istat);		/* DUMMY READ */
+		istat |= INB(np, nc_istat);		/* DUMMY READ */
 		if (DEBUG_FLAGS & DEBUG_TINY) printf ("F ");
 		sym_wakeup_done(np);
 	}



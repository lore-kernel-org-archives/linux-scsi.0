From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] [SCSI] sym53c8xx: fix free_irq() regression in 2.6.24
Date: Tue, 06 Nov 2007 14:40:54 -0500
Message-ID: <4730C346.4050701@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host06.cybernetics.com ([206.246.200.22]:1114 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbXKFTlG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Nov 2007 14:41:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

The following commit changed the pointer passed to request_irq(), but
failed to change the pointer passed to free_irq():

commit 99c9e0a1d6cfe1ba1169a7a81435ee85bc00e4a1
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Fri Oct 5 15:55:12 2007 -0400

    [SCSI] sym53c8xx: Make interrupt handler capable of returning IRQ_NONE

    ...

The result is that free_irq() doesn't actually take any action.  This
patch fixes it.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
--- linux-2.6.24-rc1-git15/drivers/scsi/sym53c8xx_2/sym_glue.c.orig	2007-11-06 14:22:43.000000000 -0500
+++ linux-2.6.24-rc1-git15/drivers/scsi/sym53c8xx_2/sym_glue.c	2007-11-06 14:22:59.000000000 -0500
@@ -1243,7 +1243,7 @@ static void sym_free_resources(struct sy
 	 *  Free O/S specific resources.
 	 */
 	if (pdev->irq)
-		free_irq(pdev->irq, np);
+		free_irq(pdev->irq, np->s.host);
 	if (np->s.ioaddr)
 		pci_iounmap(pdev, np->s.ioaddr);
 	if (np->s.ramaddr)



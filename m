From: Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: Re: [PATCH] sym53_8xx_2: fixes two bugs related to chip reset
Date: Fri, 11 Jan 2008 21:50:46 +0100
Message-ID: <20080111215046.6c4a3c80.krzysztof.h1@poczta.fm>
References: <20080109235944.34333eb6.krzysztof.h1@poczta.fm>
	<1199922703.3493.76.camel@localhost.localdomain>
	<20080110233118.d2b137ba.krzysztof.h1@poczta.fm>
	<1200005221.3141.118.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:26259 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759335AbYAKUrW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jan 2008 15:47:22 -0500
In-Reply-To: <1200005221.3141.118.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, matthew@wil.cx

From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch fixes two bugs pointed by James Bottomley:

 1. the if (!sym_data->io_reset).  That variable is only ever filled
    by a stack based completion.  If we find it non empty it means
    this code has been entered twice and we have a severe problem,
    so that should just become a BUG_ON(!sym_data->io_reset).
 2. sym_data->io_reset should be set to NULL before the routine is
    exited otherwise the PCI recovery code could end up completing
    what will be a bogus pointer into the stack.

Big thanks to James Bottomley for help with the patch.

Signed-off-by: Krzysztof Helt <krzysztof.h1@w.pl>

---
This is the second version with clearing io_reset value
under lock. I haven't got that it was a race between resume
and handler functions.

diff -urp linux-ref/drivers/scsi/sym53c8xx_2/sym_glue.c linux-new/drivers/scsi/sym53c8xx_2/sym_glue.c
--- linux-ref/drivers/scsi/sym53c8xx_2/sym_glue.c	2007-12-23 20:39:44.000000000 +0100
+++ linux-new/drivers/scsi/sym53c8xx_2/sym_glue.c	2008-01-10 21:26:32.000000000 +0100
@@ -609,22 +609,24 @@ static int sym_eh_handler(int op, char *
 	 */
 #define WAIT_FOR_PCI_RECOVERY	35
 	if (pci_channel_offline(pdev)) {
-		struct completion *io_reset;
 		int finished_reset = 0;
 		init_completion(&eh_done);
 		spin_lock_irq(shost->host_lock);
 		/* Make sure we didn't race */
 		if (pci_channel_offline(pdev)) {
-			if (!sym_data->io_reset)
-				sym_data->io_reset = &eh_done;
-			io_reset = sym_data->io_reset;
+			BUG_ON(!sym_data->io_reset);
+			sym_data->io_reset = &eh_done;
 		} else {
 			finished_reset = 1;
 		}
 		spin_unlock_irq(shost->host_lock);
 		if (!finished_reset)
-			finished_reset = wait_for_completion_timeout(io_reset,
+			finished_reset = wait_for_completion_timeout
+						(sym_data->io_reset,
 						WAIT_FOR_PCI_RECOVERY*HZ);
+		spin_lock_irq(shost->host_lock);
+		sym_data->io_reset = NULL;
+		spin_unlock_irq(shost->host_lock);
 		if (!finished_reset)
 			return SCSI_FAILED;
 	}
@@ -1879,7 +1881,6 @@ static void sym2_io_resume(struct pci_de
 	spin_lock_irq(shost->host_lock);
 	if (sym_data->io_reset)
 		complete_all(sym_data->io_reset);
-	sym_data->io_reset = NULL;
 	spin_unlock_irq(shost->host_lock);
 }
 

----------------------------------------------------------------------
Rozdajemy nagrody! 

Sprawdz >> http://link.interia.pl/f1cbf



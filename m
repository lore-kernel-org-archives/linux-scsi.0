From: Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: [PATCH] sym8xx_2: Fixes call to wait_for_completion_timeout() with
 NULL argument
Date: Mon, 7 Jan 2008 22:56:19 +0100
Message-ID: <20080107225619.59621db7.krzysztof.h1@poczta.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:49674 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751827AbYAGW0g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jan 2008 17:26:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: matthew@wil.cx

From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch fixes call to wait_for_completion_timeout()
with NULL argument.

Signed-off-by: Krzysztof Helt <krzysztof.h1@w.pl>

---

diff -urp linux-ref/drivers/scsi/sym53c8xx_2/sym_glue.c linux-new/drivers/scsi/sym53c8xx_2/sym_glue.c
--- linux-ref/drivers/scsi/sym53c8xx_2/sym_glue.c	2007-10-28 11:11:02.000000000 +0100
+++ linux-new/drivers/scsi/sym53c8xx_2/sym_glue.c	2007-10-28 14:25:08.000000000 +0100
@@ -609,8 +609,7 @@ static int sym_eh_handler(int op, char *
 	 */
 #define WAIT_FOR_PCI_RECOVERY	35
 	if (pci_channel_offline(pdev)) {
-		struct completion *io_reset;
-		int finished_reset = 0;
+		struct completion *io_reset = NULL;
 		init_completion(&eh_done);
 		spin_lock_irq(shost->host_lock);
 		/* Make sure we didn't race */
@@ -618,15 +617,12 @@ static int sym_eh_handler(int op, char *
 			if (!sym_data->io_reset)
 				sym_data->io_reset = &eh_done;
 			io_reset = sym_data->io_reset;
-		} else {
-			finished_reset = 1;
 		}
 		spin_unlock_irq(shost->host_lock);
-		if (!finished_reset)
-			finished_reset = wait_for_completion_timeout(io_reset,
-						WAIT_FOR_PCI_RECOVERY*HZ);
-		if (!finished_reset)
-			return SCSI_FAILED;
+		if (io_reset &&
+		    !wait_for_completion_timeout(io_reset,
+						 WAIT_FOR_PCI_RECOVERY * HZ))
+				return SCSI_FAILED;
 	}
 
 	spin_lock_irq(shost->host_lock);


----------------------------------------------------------------------
Walcz z zombie jako kosmiczny marine!
Kliknij >>> http://link.interia.pl/f1cc3


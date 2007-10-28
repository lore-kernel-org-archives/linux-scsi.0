From: Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: [PATCH] sym53c8xx_2: compilation warning fix
Date: Sun, 28 Oct 2007 17:15:09 +0100
Message-ID: <20071028171509.2d785753.krzysztof.h1@wp.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.wp.pl ([212.77.101.5]:19763 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbXJ1PFE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Oct 2007 11:05:04 -0400
Received: from host-87-99-61-239.lanet.net.pl (HELO krzysio.net) (krzysztof.h1@[87.99.61.239])
          (envelope-sender <krzysztof.h1@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with SMTP
          for <linux-scsi@vger.kernel.org>; 28 Oct 2007 16:05:00 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: matthew@wil.cx

From: Krzysztof Helt <krzysztof.h1@wp.pl>

Small code rearrangement to kill this compilation warning:

drivers/scsi/sym53c8xx_2/sym_glue.c:612: warning: io_reset
may be used uninitialized in this function

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>

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

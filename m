From: Jean Delvare <khali@linux-fr.org>
Subject: [PATCH] scsi/sym53c8xx: Fix a warning in sym_eh_handler
Date: Wed, 24 Oct 2007 11:59:20 +0200
Message-ID: <20071024115920.6728832c@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-dmz-233-wednesday.dmz.nerim.net ([195.5.254.233]:56118
	"EHLO kellthuzad.dmz.nerim.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751226AbXJXKY3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2007 06:24:29 -0400
Received: from kraid.nerim.net (smtp-103-wednesday.nerim.net [62.4.16.103])
	by kellthuzad.dmz.nerim.net (Postfix) with ESMTP id BD844248CC
	for <linux-scsi@vger.kernel.org>; Wed, 24 Oct 2007 12:01:18 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

In 2.6.24-rc1 I see the following warning:
drivers/scsi/sym53c8xx_2/sym_glue.c: In function "sym_eh_handler":
drivers/scsi/sym53c8xx_2/sym_glue.c:612: warning: "io_reset" may be used uninitialized in this function

Although gcc is wrong and the code is actually correct, it can easily
be made more obvious to keep the compiler quiet.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- linux-2.6.24-rc1.orig/drivers/scsi/sym53c8xx_2/sym_glue.c	2007-10-24 09:59:46.000000000 +0200
+++ linux-2.6.24-rc1/drivers/scsi/sym53c8xx_2/sym_glue.c	2007-10-24 11:53:14.000000000 +0200
@@ -609,8 +609,8 @@ static int sym_eh_handler(int op, char *
 	 */
 #define WAIT_FOR_PCI_RECOVERY	35
 	if (pci_channel_offline(pdev)) {
-		struct completion *io_reset;
-		int finished_reset = 0;
+		struct completion *io_reset = NULL;
+		int finished_reset;
 		init_completion(&eh_done);
 		spin_lock_irq(shost->host_lock);
 		/* Make sure we didn't race */
@@ -618,15 +618,14 @@ static int sym_eh_handler(int op, char *
 			if (!sym_data->io_reset)
 				sym_data->io_reset = &eh_done;
 			io_reset = sym_data->io_reset;
-		} else {
-			finished_reset = 1;
 		}
 		spin_unlock_irq(shost->host_lock);
-		if (!finished_reset)
+		if (io_reset) {
 			finished_reset = wait_for_completion_timeout(io_reset,
 						WAIT_FOR_PCI_RECOVERY*HZ);
-		if (!finished_reset)
-			return SCSI_FAILED;
+			if (!finished_reset)
+				return SCSI_FAILED;
+		}
 	}
 
 	spin_lock_irq(shost->host_lock);


-- 
Jean Delvare

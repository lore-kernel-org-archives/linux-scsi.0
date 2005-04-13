From: Tobias Klauser <tklauser@nuerscht.ch>
Subject: [PATCH] scsi/a100u2w: Remove custom msecs_to_jiffies and jiffies_to_msecs macros
Date: Wed, 13 Apr 2005 14:11:20 +0200
Message-ID: <20050413121104.GA9419@argon.tklauser.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from idmailgate1.unizh.ch ([130.60.68.105]:55379 "EHLO
	idmailgate1.unizh.ch") by vger.kernel.org with ESMTP
	id S261320AbVDMMLe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2005 08:11:34 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kernel-janitors@lists.osdl.org
Cc: linux-scsi@vger.kernel.org

Replace the MS_TO_JIFFIES() macro with msecs_to_jiffies() from jiffies.h
The current macro is incorrect because HZ can have different values on
different architectures.
The patch also removes the JIFFIES_TO_MS() macro which is not used
anymore in the code.

Signed-off-by: Tobias Klauser <tklauser@nuerscht.ch>

diff -urpN linux-2.6.12-rc2-mm3/drivers/scsi/a100u2w.c linux-2.6.12-rc2-mm3-tk/drivers/scsi/a100u2w.c
--- linux-2.6.12-rc2-mm3/drivers/scsi/a100u2w.c	2005-03-02 08:38:12.000000000 +0100
+++ linux-2.6.12-rc2-mm3-tk/drivers/scsi/a100u2w.c	2005-04-13 13:53:19.000000000 +0200
@@ -100,10 +100,6 @@
 
 #include "a100u2w.h"
 
-
-#define JIFFIES_TO_MS(t) ((t) * 1000 / HZ)
-#define MS_TO_JIFFIES(j) ((j * HZ) / 1000)
-
 static ORC_SCB *orc_alloc_scb(ORC_HCS * hcsp);
 static void inia100SCBPost(BYTE * pHcb, BYTE * pScb);
 
@@ -160,7 +156,7 @@ static UCHAR dftNvRam[64] =
 /***************************************************************************/
 static void waitForPause(unsigned amount)
 {
-	ULONG the_time = jiffies + MS_TO_JIFFIES(amount);
+	ULONG the_time = jiffies + msecs_to_jiffies(amount);
 	while (time_before_eq(jiffies, the_time))
 		cpu_relax();
 }

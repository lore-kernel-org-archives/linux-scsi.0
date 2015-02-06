From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 18/36] aha1542: Call wait_mask from aha1542_out
Date: Fri,  6 Feb 2015 23:11:39 +0100
Message-ID: <1423260717-15944-19-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56975 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758292AbbBFWQS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:16:18 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8G-0006fF-0T
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:12 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

aha1542_out call is always followed by wait_mask.
Move the call into aha1542_out to simplify code.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index b8e4952..4849d02 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -185,6 +185,8 @@ static int aha1542_out(unsigned int base, u8 *cmdp, int len)
 		outb(*cmdp++, DATA(base));
 	}
 	spin_unlock_irqrestore(&aha1542_lock, flags);
+	if (!wait_mask(INTRFLAGS(base), INTRMASK, HACC, 0, 0))
+		return 1;
 
 	return 0;
 }
@@ -650,8 +652,7 @@ static void setup_mailboxes(int bse, struct Scsi_Host *shpnt)
 	};
 	aha1542_intr_reset(bse);	/* reset interrupts, so they don't block */
 	any2scsi((cmd + 2), isa_virt_to_bus(mb));
-	aha1542_out(bse, cmd, 5);
-	if (!wait_mask(INTRFLAGS(bse), INTRMASK, HACC, 0, 0))
+	if (aha1542_out(bse, cmd, 5))
 		printk(KERN_ERR "aha1542_detect: failed setting up mailboxes\n");
 	aha1542_intr_reset(bse);
 }
@@ -744,8 +745,7 @@ static int aha1542_mbenable(int base)
 		if ((mbenable_result[0] & 0x08) && (mbenable_result[1] & 0x03))
 			retval = BIOS_TRANSLATION_25563;
 
-		aha1542_out(base, mbenable_cmd, 3);
-		if (!wait_mask(INTRFLAGS(base), INTRMASK, HACC, 0, 0))
+		if (aha1542_out(base, mbenable_cmd, 3))
 			goto fail;
 	};
 	while (0) {
@@ -879,19 +879,16 @@ static void aha1542_set_bus_times(int indx)
 		offcmd[1] = setup_busoff[indx];
 	}
 	aha1542_intr_reset(base_io);
-	aha1542_out(base_io, oncmd, 2);
-	if (!wait_mask(INTRFLAGS(base_io), INTRMASK, HACC, 0, 0))
+	if (aha1542_out(base_io, oncmd, 2))
 		goto fail;
 	aha1542_intr_reset(base_io);
-	aha1542_out(base_io, offcmd, 2);
-	if (!wait_mask(INTRFLAGS(base_io), INTRMASK, HACC, 0, 0))
+	if (aha1542_out(base_io, offcmd, 2))
 		goto fail;
 	if (setup_dmaspeed[indx] >= 0) {
 		u8 dmacmd[] = {CMD_DMASPEED, 0};
 		dmacmd[1] = setup_dmaspeed[indx];
 		aha1542_intr_reset(base_io);
-		aha1542_out(base_io, dmacmd, 2);
-		if (!wait_mask(INTRFLAGS(base_io), INTRMASK, HACC, 0, 0))
+		if (aha1542_out(base_io, dmacmd, 2))
 			goto fail;
 	}
 	aha1542_intr_reset(base_io);
-- 
Ondrej Zary


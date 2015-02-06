From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 11/36] aha1542: Unify aha1542_in and aha1542_in1
Date: Fri,  6 Feb 2015 23:11:32 +0100
Message-ID: <1423260717-15944-12-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56957 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758107AbbBFWPo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:15:44 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8E-0006fF-T2
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:11 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Unify aha1542_in and aha1542_in1 functions, they differ only in timeout
and printk.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   33 +++++++--------------------------
 1 file changed, 7 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 0e58cef..b4ada24 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -191,34 +191,13 @@ fail:
 /* Only used at boot time, so we do not need to worry about latency as much
    here */
 
-static int aha1542_in(unsigned int base, u8 *cmdp, int len)
+static int aha1542_in(unsigned int base, u8 *cmdp, int len, int timeout)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&aha1542_lock, flags);
 	while (len--) {
-		if (!wait_mask(STATUS(base), DF, DF, 0, 0))
-			goto fail;
-		*cmdp++ = inb(DATA(base));
-	}
-	spin_unlock_irqrestore(&aha1542_lock, flags);
-	return 0;
-fail:
-	spin_unlock_irqrestore(&aha1542_lock, flags);
-	printk(KERN_ERR "aha1542_in failed(%d): ", len + 1);
-	return 1;
-}
-
-/* Similar to aha1542_in, except that we wait a very short period of time.
-   We use this if we know the board is alive and awake, but we are not sure
-   if the board will respond to the command we are about to send or not */
-static int aha1542_in1(unsigned int base, u8 *cmdp, int len)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&aha1542_lock, flags);
-	while (len--) {
-		if (!wait_mask(STATUS(base), DF, DF, 0, 100))
+		if (!wait_mask(STATUS(base), DF, DF, 0, timeout))
 			goto fail;
 		*cmdp++ = inb(DATA(base));
 	}
@@ -226,6 +205,8 @@ static int aha1542_in1(unsigned int base, u8 *cmdp, int len)
 	return 0;
 fail:
 	spin_unlock_irqrestore(&aha1542_lock, flags);
+	if (timeout == 0)
+		printk(KERN_ERR "aha1542_in failed(%d): ", len + 1);
 	return 1;
 }
 
@@ -730,7 +711,7 @@ static int aha1542_getconfig(int base_io, unsigned char *irq_level, unsigned cha
 		i = inb(DATA(base_io));
 	};
 	aha1542_out(base_io, inquiry_cmd, 1);
-	aha1542_in(base_io, inquiry_result, 3);
+	aha1542_in(base_io, inquiry_result, 3, 0);
 	if (!wait_mask(INTRFLAGS(base_io), INTRMASK, HACC, 0, 0))
 		goto fail;
 	while (0) {
@@ -800,7 +781,7 @@ static int aha1542_mbenable(int base)
 
 	mbenable_cmd[0] = CMD_EXTBIOS;
 	aha1542_out(base, mbenable_cmd, 1);
-	if (aha1542_in1(base, mbenable_result, 2))
+	if (aha1542_in(base, mbenable_result, 2, 100))
 		return retval;
 	if (!wait_mask(INTRFLAGS(base), INTRMASK, HACC, 0, 100))
 		goto fail;
@@ -837,7 +818,7 @@ static int aha1542_query(int base_io, int *transl)
 		i = inb(DATA(base_io));
 	};
 	aha1542_out(base_io, inquiry_cmd, 1);
-	aha1542_in(base_io, inquiry_result, 4);
+	aha1542_in(base_io, inquiry_result, 4, 0);
 	if (!wait_mask(INTRFLAGS(base_io), INTRMASK, HACC, 0, 0))
 		goto fail;
 	while (0) {
-- 
Ondrej Zary


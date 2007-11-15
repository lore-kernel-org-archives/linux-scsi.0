From: Roel Kluin <12o3l@tiscali.nl>
Subject: [PATCH] priority fix in do_abort(); drivers/scsi/{atari,sun3}_NCR5380.c
Date: Thu, 15 Nov 2007 21:13:46 +0100
Message-ID: <473CA87A.9000906@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:45319 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbXKOUNw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 15:13:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

This patch was not tested.
--
SR_REQ is defined 0x20, but bitanding has no effect because '!' has a higher
priority than '&'

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index 03dbe60..5696588 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -1870,7 +1870,7 @@ static int do_abort(struct Scsi_Host *host)
 	 * the target sees, so we just handshake.
 	 */
 
-	while (!(tmp = NCR5380_read(STATUS_REG)) & SR_REQ)
+	while (!((tmp = NCR5380_read(STATUS_REG)) & SR_REQ))
 		;
 
 	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(tmp));
diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index 98e3fe1..19852c5 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -1864,7 +1864,7 @@ static int do_abort (struct Scsi_Host *host)
      * the target sees, so we just handshake.
      */
     
-    while (!(tmp = NCR5380_read(STATUS_REG)) & SR_REQ);
+    while (!((tmp = NCR5380_read(STATUS_REG)) & SR_REQ));
 
     NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(tmp));
 

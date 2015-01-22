From: Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] scsi: ncr5380: use msecs_to_jiffies for conversions
Date: Thu, 22 Jan 2015 12:42:17 +0100
Message-ID: <1421926937-1535-1-git-send-email-der.herr@hofr.at>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:43083 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbbAVLuU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2015 06:50:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>

This is only an API consolidation to make things more readable

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

Converting milliseconds to jiffies by "val * HZ / 1000" is technically
ok but msecs_to_jiffies(val) is the cleaner solution and handles all 
corner cases correctly. This is a minor API cleanup only.

This patch was only compile tested with i386_defconfig + CONFIG_ISA=y,
CONFIG_SCSI_LOWLEVEL=y, CONFIG_SCSI_GENERIC_NCR5380=m

Patch is against 3.19.0-rc5 -next-20150119

 drivers/scsi/NCR5380.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 36244d6..5008a0e 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -474,11 +474,11 @@ static void NCR5380_print_phase(struct Scsi_Host *instance)
  */
 #ifndef USLEEP_SLEEP
 /* 20 ms (reasonable hard disk speed) */
-#define USLEEP_SLEEP (20*HZ/1000)
+#define USLEEP_SLEEP msecs_to_jiffies(20)
 #endif
 /* 300 RPM (floppy speed) */
 #ifndef USLEEP_POLL
-#define USLEEP_POLL (200*HZ/1000)
+#define USLEEP_POLL msecs_to_jiffies(200)
 #endif
 #ifndef USLEEP_WAITLONG
 /* RvC: (reasonable time to wait on select error) */
@@ -576,7 +576,7 @@ static int __init __maybe_unused NCR5380_probe_irq(struct Scsi_Host *instance,
 		if ((mask & possible) && (request_irq(i, &probe_intr, 0, "NCR-probe", NULL) == 0))
 			trying_irqs |= mask;
 
-	timeout = jiffies + (250 * HZ / 1000);
+	timeout = jiffies + msecs_to_jiffies(250);
 	probe_irq = NO_IRQ;
 
 	/*
@@ -1348,7 +1348,7 @@ static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 	 * selection.
 	 */
 
-	timeout = jiffies + (250 * HZ / 1000);
+	timeout = jiffies + msecs_to_jiffies(250);
 
 	/* 
 	 * XXX very interesting - we're seeing a bounce where the BSY we 
-- 
1.7.10.4


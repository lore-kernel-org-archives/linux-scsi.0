From: Valentin Rothberg <valentinrothberg@gmail.com>
Subject: [PATCH] drivers/scsi/arm/acornscsi.c: rename CONFIG_ACORNSCSI_CONSTANTS
Date: Tue, 28 Apr 2015 16:15:11 +0200
Message-ID: <1430230511-10869-1-git-send-email-valentinrothberg@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:35020 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965659AbbD1OPT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2015 10:15:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, linux@arm.linux.org.uk, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Valentin Rothberg <valentinrothberg@gmail.com>

CONFIG_ACORNSCSI_CONSTANTS is a file local CPP identifier and thereby
violates the naming convention of Kconfig options in Make and CPP
syntax; only Kconfig options should carry the 'CONFIG_' prefix.

This patch removes the 'CONFIG_' prefix to apply to this convention and
to make static analysis tools happy.

Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>
---
I detected this issue with ./scripts/checkkconfigsymbols.py
---
 drivers/scsi/arm/acornscsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index deaaf84989cd..ce764c3ed99c 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -96,7 +96,7 @@
  * Define this if you want to have verbose explanation of SCSI
  * status/messages.
  */
-#undef CONFIG_ACORNSCSI_CONSTANTS
+#undef ACORNSCSI_CONSTANTS
 /*
  * Define this if you want to use the on board DMAC [don't remove this option]
  * If not set, then use PIO mode (not currently supported).
@@ -399,7 +399,7 @@ void acornscsi_resetcard(AS_Host *host)
 /*=============================================================================================
  * Utility routines (eg. debug)
  */
-#ifdef CONFIG_ACORNSCSI_CONSTANTS
+#ifdef ACORNSCSI_CONSTANTS
 static char *acornscsi_interrupttype[] = {
   "rst",  "suc",  "p/a",  "3",
   "term", "5",	  "6",	  "7",
@@ -477,7 +477,7 @@ void print_scsi_status(unsigned int ssr)
 static
 void print_sbic_status(int asr, int ssr, int cmdphase)
 {
-#ifdef CONFIG_ACORNSCSI_CONSTANTS
+#ifdef ACORNSCSI_CONSTANTS
     printk("sbic: %c%c%c%c%c%c ",
 	    asr & ASR_INT ? 'I' : 'i',
 	    asr & ASR_LCI ? 'L' : 'l',
-- 
2.1.4


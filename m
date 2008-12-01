From: akpm@linux-foundation.org
Subject: [patch 09/10] esp: fix section mismatch warning
Date: Mon, 01 Dec 2008 14:32:15 -0800
Message-ID: <200812012232.mB1MWFXR019557@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752613AbYLAWdv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Dec 2008 17:33:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, randy.dunlap@oracle.com, arobinso@nyx.net

From: Randy Dunlap <randy.dunlap@oracle.com>

Not critical.

WARNING: drivers/char/esp.o(.text+0x278): Section mismatch in reference from the function show_serial_version() to the variable .init.data:serial_version
The function show_serial_version() references
the variable __initdata serial_version.
This is often because show_serial_version lacks a __initdata
annotation or the annotation of serial_version is wrong.

WARNING: drivers/char/esp.o(.text+0x27d): Section mismatch in reference from the function show_serial_version() to the variable .init.data:serial_name
The function show_serial_version() references
the variable __initdata serial_name.
This is often because show_serial_version lacks a __initdata
annotation or the annotation of serial_name is wrong.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew J. Robinson <arobinso@nyx.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/esp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/esp.c~esp-fix-section-mismatch-warning drivers/char/esp.c
--- a/drivers/char/esp.c~esp-fix-section-mismatch-warning
+++ a/drivers/char/esp.c
@@ -2258,7 +2258,7 @@ static int esp_open(struct tty_struct *t
  * driver.
  */
 
-static void show_serial_version(void)
+static void __init show_serial_version(void)
 {
 	printk(KERN_INFO "%s version %s (DMA %u)\n",
 		serial_name, serial_version, dma);
_

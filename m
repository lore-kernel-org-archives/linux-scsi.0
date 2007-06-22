From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] dtc: Coding police and printk levels
Date: Fri, 22 Jun 2007 14:26:29 +0100
Message-ID: <20070622142629.52519e47@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52106 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754147AbXFVNUj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jun 2007 09:20:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

Seems printk levels hadn't been invented last time this driver was tidied
up.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc4-mm2/drivers/scsi/dtc.c linux-2.6.22-rc4-mm2/drivers/scsi/dtc.c
--- linux.vanilla-2.6.22-rc4-mm2/drivers/scsi/dtc.c	2007-06-07 14:24:28.000000000 +0100
+++ linux-2.6.22-rc4-mm2/drivers/scsi/dtc.c	2007-06-14 13:43:37.000000000 +0100
@@ -137,11 +137,9 @@
 #ifdef OVERRIDE
 [] __initdata = OVERRIDE;
 #else
-[4] __initdata = { {
-0, IRQ_AUTO}, {
-0, IRQ_AUTO}, {
-0, IRQ_AUTO}, {
-0, IRQ_AUTO}};
+[4] __initdata = { 
+	{ 0, IRQ_AUTO }, { 0, IRQ_AUTO }, { 0, IRQ_AUTO }, { 0, IRQ_AUTO }
+};
 #endif
 
 #define NO_OVERRIDES ARRAY_SIZE(overrides)
@@ -176,7 +174,7 @@
  * Inputs : str - unused, ints - array of integer parameters with ints[0]
  *	equal to the number of ints.
  *
-*/
+ */
 
 static void __init dtc_setup(char *str, int *ints)
 {
@@ -233,7 +231,7 @@
 		} else
 			for (; !addr && (current_base < NO_BASES); ++current_base) {
 #if (DTCDEBUG & DTCDEBUG_INIT)
-				printk("scsi-dtc : probing address %08x\n", bases[current_base].address);
+				printk(KERN_DEBUG "scsi-dtc : probing address %08x\n", bases[current_base].address);
 #endif
 				if (bases[current_base].noauto)
 					continue;
@@ -244,7 +242,7 @@
 					if (check_signature(base + signatures[sig].offset, signatures[sig].string, strlen(signatures[sig].string))) {
 						addr = bases[current_base].address;
 #if (DTCDEBUG & DTCDEBUG_INIT)
-						printk("scsi-dtc : detected board.\n");
+						printk(KERB_DEBUG "scsi-dtc : detected board.\n");
 #endif
 						goto found;
 					}
@@ -253,7 +251,7 @@
 			}
 
 #if defined(DTCDEBUG) && (DTCDEBUG & DTCDEBUG_INIT)
-		printk("scsi-dtc : base = %08x\n", addr);
+		printk(KERN_DEBUG "scsi-dtc : base = %08x\n", addr);
 #endif
 
 		if (!addr)

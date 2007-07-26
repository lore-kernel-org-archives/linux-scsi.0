From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] dtc: Clean up indent damage and add printk levels
Date: Thu, 26 Jul 2007 18:47:56 +0100
Message-ID: <20070726184756.797c9095@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [81.2.110.250] ([81.2.110.250]:54399 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759344AbXGZRlE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 13:41:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, akpm@osdl.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/drivers/scsi/dtc.c linux-2.6.23rc1-mm1/drivers/scsi/dtc.c
--- linux.vanilla-2.6.23rc1-mm1/drivers/scsi/dtc.c	2007-07-26 15:01:45.000000000 +0100
+++ linux-2.6.23rc1-mm1/drivers/scsi/dtc.c	2007-07-26 15:29:19.000000000 +0100
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

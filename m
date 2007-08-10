From: akpm@linux-foundation.org
Subject: [patch 14/30] dtc: clean up indent damage and add printk levels
Date: Fri, 10 Aug 2007 14:50:41 -0700
Message-ID: <200708102150.l7ALogV5011357@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38224 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761812AbXHJWCK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 18:02:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, alan@redhat.com

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/dtc.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff -puN drivers/scsi/dtc.c~dtc-clean-up-indent-damage-and-add-printk-levels drivers/scsi/dtc.c
--- a/drivers/scsi/dtc.c~dtc-clean-up-indent-damage-and-add-printk-levels
+++ a/drivers/scsi/dtc.c
@@ -137,11 +137,9 @@ static struct override {
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
@@ -176,7 +174,7 @@ static const struct signature {
  * Inputs : str - unused, ints - array of integer parameters with ints[0]
  *	equal to the number of ints.
  *
-*/
+ */
 
 static void __init dtc_setup(char *str, int *ints)
 {
@@ -233,7 +231,7 @@ static int __init dtc_detect(struct scsi
 		} else
 			for (; !addr && (current_base < NO_BASES); ++current_base) {
 #if (DTCDEBUG & DTCDEBUG_INIT)
-				printk("scsi-dtc : probing address %08x\n", bases[current_base].address);
+				printk(KERN_DEBUG "scsi-dtc : probing address %08x\n", bases[current_base].address);
 #endif
 				if (bases[current_base].noauto)
 					continue;
@@ -244,7 +242,7 @@ static int __init dtc_detect(struct scsi
 					if (check_signature(base + signatures[sig].offset, signatures[sig].string, strlen(signatures[sig].string))) {
 						addr = bases[current_base].address;
 #if (DTCDEBUG & DTCDEBUG_INIT)
-						printk("scsi-dtc : detected board.\n");
+						printk(KERB_DEBUG "scsi-dtc : detected board.\n");
 #endif
 						goto found;
 					}
@@ -253,7 +251,7 @@ static int __init dtc_detect(struct scsi
 			}
 
 #if defined(DTCDEBUG) && (DTCDEBUG & DTCDEBUG_INIT)
-		printk("scsi-dtc : base = %08x\n", addr);
+		printk(KERN_DEBUG "scsi-dtc : base = %08x\n", addr);
 #endif
 
 		if (!addr)
_

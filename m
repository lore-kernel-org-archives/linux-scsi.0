From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] SCSI/fdomain: fix PCMCIA-related warnings
Date: Sun, 27 May 2007 08:52:12 -0400
Message-ID: <20070527125212.GA13893@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:33346 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbXE0MwN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 May 2007 08:52:13 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, faith@cs.unc.edu, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>


fdomain is one of those drivers that is compiled twice, once for PCMCIA
and once for non-PCMCIA.  The resultant two-driver setup leaves a bit of
dead code and data in the non-PCMCIA case, which gcc complains about.

Shuffle ifdefs a bit to eliminate the conditionally-dead code, and
the compiler warnings.

Signed-off-by: Jeff Garzik <jeff@garzik.org>

diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 5d4ea6f..02801b9 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -410,6 +410,8 @@ static irqreturn_t       do_fdomain_16x0_intr( int irq, void *dev_id );
 static char * fdomain = NULL;
 module_param(fdomain, charp, 0);
 
+#ifndef PCMCIA
+
 static unsigned long addresses[] = {
    0xc8000,
    0xca000,
@@ -426,6 +428,8 @@ static unsigned short ports[] = { 0x140, 0x150, 0x160, 0x170 };
 
 static unsigned short ints[] = { 3, 5, 10, 11, 12, 14, 15, 0 };
 
+#endif /* !PCMCIA */
+
 /*
 
   READ THIS BEFORE YOU ADD A SIGNATURE!
@@ -458,6 +462,8 @@ static unsigned short ints[] = { 3, 5, 10, 11, 12, 14, 15, 0 };
 
 */
 
+#ifndef PCMCIA
+
 static struct signature {
    const char *signature;
    int  sig_offset;
@@ -503,6 +509,8 @@ static struct signature {
 
 #define SIGNATURE_COUNT ARRAY_SIZE(signatures)
 
+#endif /* !PCMCIA */
+
 static void print_banner( struct Scsi_Host *shpnt )
 {
    if (!shpnt) return;		/* This won't ever happen */
@@ -633,6 +641,8 @@ static int fdomain_test_loopback( void )
    return 0;
 }
 
+#ifndef PCMCIA
+
 /* fdomain_get_irq assumes that we have a valid MCA ID for a
    TMC-1660/TMC-1680 Future Domain board.  Now, check to be sure the
    bios_base matches these ports.  If someone was unlucky enough to have
@@ -667,7 +677,6 @@ static int fdomain_get_irq( int base )
 
 static int fdomain_isa_detect( int *irq, int *iobase )
 {
-#ifndef PCMCIA
    int i, j;
    int base = 0xdeadbeef;
    int flag = 0;
@@ -786,11 +795,22 @@ found:
    *iobase = base;
 
    return 1;			/* success */
-#else
-   return 0;
-#endif
 }
 
+#else /* PCMCIA */
+
+static int fdomain_isa_detect( int *irq, int *iobase )
+{
+	if (irq)
+		*irq = 0;
+	if (iobase)
+		*iobase = 0;
+	return 0;
+}
+
+#endif /* !PCMCIA */
+
+
 /* PCI detection function: int fdomain_pci_bios_detect(int* irq, int*
    iobase) This function gets the Interrupt Level and I/O base address from
    the PCI configuration registers. */

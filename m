From: Yang Shi <yang.shi@linaro.org>
Subject: [PATCH] scsi: fdomain: add missing CONFIG_ to PCMCIA
Date: Tue,  9 Feb 2016 14:16:49 -0800
Message-ID: <1455056209-1696-1-git-send-email-yang.shi@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linaro-kernel@lists.linaro.org, yang.shi@linaro.org
List-Id: linux-scsi@vger.kernel.org

There are some "#ifdef PCMCIA" in the driver code, but all of them missed
CONFIG_ prefix. Correct PCMCIA to CONFIG_PCMCIA.

Signed-off-by: Yang Shi <yang.shi@linaro.org>
---

I happened to find this problem when I was tracking down another problem,
however this driver looks very old, not sure if anybody cares about it or not.
Anyway, it is harmless to come up with a patch to get it corrected.

 drivers/scsi/fdomain.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index eefe14d..ffc9187 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -290,7 +290,7 @@
 #include <scsi/scsi_ioctl.h>
 #include "fdomain.h"
 
-#ifndef PCMCIA
+#ifndef CONFIG_PCMCIA
 MODULE_AUTHOR("Rickard E. Faith");
 MODULE_DESCRIPTION("Future domain SCSI driver");
 MODULE_LICENSE("GPL");
@@ -414,7 +414,7 @@ static irqreturn_t       do_fdomain_16x0_intr( int irq, void *dev_id );
 static char * fdomain = NULL;
 module_param(fdomain, charp, 0);
 
-#ifndef PCMCIA
+#ifndef CONFIG_PCMCIA
 
 static unsigned long addresses[] = {
    0xc8000,
@@ -432,7 +432,7 @@ static unsigned short ports[] = { 0x140, 0x150, 0x160, 0x170 };
 
 static unsigned short ints[] = { 3, 5, 10, 11, 12, 14, 15, 0 };
 
-#endif /* !PCMCIA */
+#endif /* !CONFIG_PCMCIA */
 
 /*
 
@@ -466,7 +466,7 @@ static unsigned short ints[] = { 3, 5, 10, 11, 12, 14, 15, 0 };
 
 */
 
-#ifndef PCMCIA
+#ifndef CONFIG_PCMCIA
 
 static struct signature {
    const char *signature;
@@ -513,7 +513,7 @@ static struct signature {
 
 #define SIGNATURE_COUNT ARRAY_SIZE(signatures)
 
-#endif /* !PCMCIA */
+#endif /* !CONFIG_PCMCIA */
 
 static void print_banner( struct Scsi_Host *shpnt )
 {
@@ -645,7 +645,7 @@ static int fdomain_test_loopback( void )
    return 0;
 }
 
-#ifndef PCMCIA
+#ifndef CONFIG_PCMCIA
 
 /* fdomain_get_irq assumes that we have a valid MCA ID for a
    TMC-1660/TMC-1680 Future Domain board.  Now, check to be sure the
@@ -801,7 +801,7 @@ found:
    return 1;			/* success */
 }
 
-#else /* PCMCIA */
+#else /* CONFIG_PCMCIA */
 
 static int fdomain_isa_detect( int *irq, int *iobase )
 {
@@ -812,7 +812,7 @@ static int fdomain_isa_detect( int *irq, int *iobase )
 	return 0;
 }
 
-#endif /* !PCMCIA */
+#endif /* !CONFIG_PCMCIA */
 
 
 /* PCI detection function: int fdomain_pci_bios_detect(int* irq, int*
@@ -1767,7 +1767,7 @@ struct scsi_host_template fdomain_driver_template = {
 	.use_clustering		= DISABLE_CLUSTERING,
 };
 
-#ifndef PCMCIA
+#ifndef CONFIG_PCMCIA
 #ifdef CONFIG_PCI
 
 static struct pci_device_id fdomain_pci_tbl[] = {
-- 
2.0.2

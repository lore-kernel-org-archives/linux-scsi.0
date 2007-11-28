From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: [patch 12/23] MegaRAID driver management char device moved to misc
Date: Wed, 28 Nov 2007 14:45:01 -0700
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229D9040F@NAMAIL2.ad.lsil.com>
References: <200711212312.lALNCOCj014139@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:35005 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757246AbXK1VqS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Nov 2007 16:46:18 -0500
Content-class: urn:content-classes:message
In-Reply-To: <200711212312.lALNCOCj014139@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thomas@horsten.com, "Kolli, Neela" <Neela.Kolli@lsi.com>, Seokmann.Ju@lsil.com, thomas.horsten@gmail.com

ACK.

Thanks Thomas.

Regards,

Sumant 

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of
akpm@linux-foundation.org
Sent: Wednesday, November 21, 2007 3:12 PM
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org; akpm@linux-foundation.org;
thomas@horsten.com; Kolli, Neela; Seokmann.Ju@lsil.com;
thomas.horsten@gmail.com
Subject: [patch 12/23] MegaRAID driver management char device moved to
misc

From: Thomas Horsten <thomas@horsten.com>

The MegaRAID driver's common management module (megaraid_mm.c) creates a
char device used by the management tool "megarc" from LSI Logic (and
possibly other management tools).

In 2.6 with udev, this device doesn't get created because it is not
registered in sysfs.

I first fixed this by registering a class "megaraid_mm", but realized
that this should probably be moved to misc devices, instead of taking up
a char major.  This is because only 1 device is used, even if there are
multiple adapters - the minor is never used (the adapter info is in the
ioctl block sent to the driver, not detected based on the minor number
as one might think).  So it is a complete waste to have an entire major
taken by this.

So it now uses a misc device which I named "megadev0" (the name that
megarc expects), and has a dynamic minor (previoulsy a dynamic major was
used).

I have tested this on my own system with the megarc tool, and it works
just as fine as before (only now the device gets created correctly by
udev).

Cc: <thomas.horsten@gmail.com>
Cc: Neela Syam Kolli <Neela.Kolli@engenio.com>
Cc: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_mm.c |   20 +++++++++++++-------
 drivers/scsi/megaraid/megaraid_mm.h |    1 +
 2 files changed, 14 insertions(+), 7 deletions(-)

diff -puN
drivers/scsi/megaraid/megaraid_mm.c~megaraid-driver-management-char-devi
ce-moved-to-misc drivers/scsi/megaraid/megaraid_mm.c
---
a/drivers/scsi/megaraid/megaraid_mm.c~megaraid-driver-management-char-de
vice-moved-to-misc
+++ a/drivers/scsi/megaraid/megaraid_mm.c
@@ -59,7 +59,6 @@ EXPORT_SYMBOL(mraid_mm_register_adp);
 EXPORT_SYMBOL(mraid_mm_unregister_adp);
 EXPORT_SYMBOL(mraid_mm_adapter_app_handle);
 
-static int majorno;
 static uint32_t drvr_ver	= 0x02200207;
 
 static int adapters_count_g;
@@ -76,6 +75,12 @@ static const struct file_operations lsi_
 	.owner	= THIS_MODULE,
 };
 
+static struct miscdevice megaraid_mm_dev = {
+	.minor	= MISC_DYNAMIC_MINOR,
+	.name   = "megadev0",
+	.fops   = &lsi_fops,
+};
+
 /**
  * mraid_mm_open - open routine for char node interface
  * @inode	: unused
@@ -1184,15 +1189,16 @@ mraid_mm_teardown_dma_pools(mraid_mmadp_
 static int __init
 mraid_mm_init(void)
 {
+	int err;
+
 	// Announce the driver version
 	con_log(CL_ANN, (KERN_INFO "megaraid cmm: %s %s\n",
 		LSI_COMMON_MOD_VERSION, LSI_COMMON_MOD_EXT_VERSION));
 
-	majorno = register_chrdev(0, "megadev", &lsi_fops);
-
-	if (majorno < 0) {
-		con_log(CL_ANN, ("megaraid cmm: cannot get major\n"));
-		return majorno;
+	err = misc_register(&megaraid_mm_dev);
+	if (err < 0) {
+		con_log(CL_ANN, ("megaraid cmm: cannot register misc
device\n"));
+		return err;
 	}
 
 	init_waitqueue_head(&wait_q);
@@ -1230,7 +1236,7 @@ mraid_mm_exit(void)  {
 	con_log(CL_DLEVEL1 , ("exiting common mod\n"));
 
-	unregister_chrdev(majorno, "megadev");
+	misc_deregister(&megaraid_mm_dev);
 }
 
 module_init(mraid_mm_init);
diff -puN
drivers/scsi/megaraid/megaraid_mm.h~megaraid-driver-management-char-devi
ce-moved-to-misc drivers/scsi/megaraid/megaraid_mm.h
---
a/drivers/scsi/megaraid/megaraid_mm.h~megaraid-driver-management-char-de
vice-moved-to-misc
+++ a/drivers/scsi/megaraid/megaraid_mm.h
@@ -22,6 +22,7 @@
 #include <linux/moduleparam.h>
 #include <linux/pci.h>
 #include <linux/list.h>
+#include <linux/miscdevice.h>
 
 #include "mbox_defs.h"
 #include "megaraid_ioctl.h"
_
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html

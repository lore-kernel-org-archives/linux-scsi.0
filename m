From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fix aic7xxx probing
Date: 25 Jun 2004 08:29:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1088170181.2217.12.camel@mulgrave>
References: <1088117341.2174.67.camel@mulgrave>
	<Pine.LNX.4.58.0406250036000.3261@montezuma.fsmlabs.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:59279 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266339AbUFYNcr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jun 2004 09:32:47 -0400
In-Reply-To: <Pine.LNX.4.58.0406250036000.3261@montezuma.fsmlabs.com>
List-Id: linux-scsi@vger.kernel.org
To: Zwane Mwaikambo <zwane@linuxpower.ca>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, William Lee Irwin III <wli@holomorphy.com>

On Thu, 2004-06-24 at 23:56, Zwane Mwaikambo wrote:
> This patch applied against 2.6.7-mm2 doesn't detect my PCI HBA whereas
> 2.6.7-mm2 currently does.

Thanks, had another look at the code and it seems that the meaning of
the return value for ahc_linux_pci_init() is different depending on
kernel version, sigh.  For < 2.4.0 it means number of boards found,
otherwise it's zero or error.

We really need to scrub this 2.2 code out of the driver, but in the
meantime, can you test the attached? (backing out the original).  It
just makes the return of ahc_linux_pci_init() consistent.

Thanks,

James

===== aic7xxx_osm.c 1.54 vs edited =====
--- 1.54/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-04-26 02:09:37 -04:00
+++ edited/aic7xxx_osm.c	2004-06-25 09:22:30 -04:00
@@ -842,9 +842,7 @@
 static int
 ahc_linux_detect(Scsi_Host_Template *template)
 {
-	struct	ahc_softc *ahc;
 	int     found = 0;
-	int	eisa_err, pci_err;
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 	/*
@@ -892,13 +890,11 @@
 	 */
 	ahc_list_lockinit();
 
-	pci_err = ahc_linux_pci_init();
-	eisa_err = ahc_linux_eisa_init();
-
-	if(pci_err && eisa_err)
-		goto out;
-
-
+	found = ahc_linux_pci_init();
+	if (!ahc_linux_eisa_init())
+		found++;
+	
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 	/*
 	 * Register with the SCSI layer all
 	 * controllers we've found.
@@ -908,9 +904,7 @@
 		if (ahc_linux_register_host(ahc, template) == 0)
 			found++;
 	}
-out:
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 	spin_lock_irq(&io_request_lock);
 #endif
 	aic7xxx_detect_complete++;
===== aic7xxx_osm.h 1.54 vs edited =====
--- 1.54/drivers/scsi/aic7xxx/aic7xxx_osm.h	2004-05-12 11:46:27 -04:00
+++ edited/aic7xxx_osm.h	2004-06-24 18:41:49 -04:00
@@ -940,7 +940,7 @@
 }
 #else
 static inline int ahc_linux_pci_init(void) {
-	return -ENODEV;
+	return 0;
 }
 static inline void ahc_linux_pci_exit(void) {
 }
===== aic7xxx_osm_pci.c 1.12 vs edited =====
--- 1.12/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2003-12-19 16:31:43 -05:00
+++ edited/aic7xxx_osm_pci.c	2004-06-25 09:24:54 -04:00
@@ -198,7 +198,8 @@
 ahc_linux_pci_init(void)
 {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-	return (pci_module_init(&aic7xxx_pci_driver));
+	/* Translate error or zero return into zero or one */
+	return pci_module_init(&aic7xxx_pci_driver) ? 0 : 1;
 #else
 	struct pci_dev *pdev;
 	u_int class;


From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] [2.4] sym2 module option to behave like 2.6
Date: Wed, 1 Dec 2004 04:23:09 +0000
Message-ID: <20041201042309.GD5752@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:53205 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261230AbULAEXN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2004 23:23:13 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kyle@debian.org
Cc: linux-scsi@vger.kernel.org


Several people have expressed dissatisfaction with their scsi drives
rearranging when they switch between 2.4 and 2.6.  It's particularly
gruesome for people with an HP A500 as the internal discs swap positions.

I can't make the 2.6 driver behave like the 2.4 driver, so here's an
alternative: add an option to make the 2.4 driver detect hosts in the
same order as the 2.6 driver.  This patch is only compile tested, so is
probably buggy.

Index: drivers/scsi/sym53c8xx_2/sym53c8xx.h
===================================================================
RCS file: /var/cvs/linux-2.4/drivers/scsi/sym53c8xx_2/sym53c8xx.h,v
retrieving revision 1.4
diff -u -p -r1.4 sym53c8xx.h
--- drivers/scsi/sym53c8xx_2/sym53c8xx.h	13 Nov 2002 15:15:44 -0000	1.4
+++ drivers/scsi/sym53c8xx_2/sym53c8xx.h	1 Dec 2004 04:15:56 -0000
@@ -268,6 +268,7 @@ struct sym_driver_setup {
 	u_short	debug;
 	u_char	settle_delay;
 	u_char	use_nvram;
+	u_char	probe_26;
 	u_long	excludes[8];
 	char	tag_ctrl[100];
 };
@@ -313,6 +314,7 @@ struct sym_driver_setup {
 	0,	/* debug */			\
 	3,	/* settle_delay */		\
 	1,	/* use_nvram */			\
+	0,	/* probe_26 */			\
 }
 
 /*
@@ -342,6 +344,7 @@ struct sym_driver_setup {
 	0,	/* debug */			\
 	10,	/* settle_delay */		\
 	1,	/* use_nvram */			\
+	0,	/* probe_26 */			\
 }
 
 /*
Index: drivers/scsi/sym53c8xx_2/sym_glue.c
===================================================================
RCS file: /var/cvs/linux-2.4/drivers/scsi/sym53c8xx_2/sym_glue.c,v
retrieving revision 1.6
diff -u -p -r1.6 sym_glue.c
--- drivers/scsi/sym53c8xx_2/sym_glue.c	16 Nov 2002 06:10:46 -0000	1.6
+++ drivers/scsi/sym53c8xx_2/sym_glue.c	1 Dec 2004 04:15:57 -0000
@@ -2282,6 +2282,7 @@ MDELAY(5000);
 #define OPT_USE_NVRAM		19
 #define OPT_EXCLUDE		20
 #define OPT_SAFE_SETUP		21
+#define OPT_PROBE_26		22
 
 static char setup_token[] __initdata =
 	"mpar:"		"spar:"
@@ -2294,7 +2295,7 @@ static char setup_token[] __initdata =
 	"revprob:"	"verb:"
 	"debug:"	"settle:"
 	"nvram:"	"excl:"
-	"safe:"
+	"safe:"		"probe26:"
 	;
 
 #ifdef MODULE
@@ -2383,6 +2384,7 @@ int __init sym53c8xx_setup(char *str)
 		__SIMPLE_OPTION(MAX_LUN, max_lun)
 		__SIMPLE_OPTION(PCI_FIX_UP, pci_fix_up)
 		__SIMPLE_OPTION(REVERSE_PROBE, reverse_probe)
+		__SIMPLE_OPTION(PROBE_26, probe_26)
 		__SIMPLE_OPTION(VERBOSE, verbose)
 		__SIMPLE_OPTION(DEBUG, debug)
 		__SIMPLE_OPTION(SETTLE_DELAY, settle_delay)
@@ -2721,6 +2723,47 @@ static u_short sym_chip_ids[] __initdata
  	PCI_ID_LSI53C1010_2
 };
 
+static struct pci_dev * sym_get_next_dev_24(struct pci_dev *pdev)
+{
+	static int j = 0;
+	const int chips	= sizeof(sym_chip_ids)	/ sizeof(sym_chip_ids[0]);
+	while (1) {
+		int i;
+		if (j >= chips)
+			break;
+		i = sym_driver_setup.reverse_probe ? chips - 1 - j : j;
+		pdev = pci_find_device(PCI_VENDOR_ID_NCR, sym_chip_ids[i],
+				pdev);
+		if (pdev)
+			break;
+		++j;
+		continue;
+	}
+	return pdev;
+}
+
+static struct pci_dev * sym_get_next_dev_26(struct pci_dev *pdev)
+{
+	const int chips	= sizeof(sym_chip_ids)	/ sizeof(sym_chip_ids[0]);
+	while (1) {
+		int i;
+		pdev = pci_find_device(PCI_VENDOR_ID_NCR, PCI_ANY_ID, pdev);
+		if (!pdev)
+			return NULL;
+		for (i = 0; i < chips; i++) {
+			if (pdev->device == sym_chip_ids[i])
+				return pdev;
+		}
+	}
+}
+
+static struct pci_dev * sym_get_next_dev(struct pci_dev *pdev)
+{
+	if (sym_driver_setup.probe_26)
+		return sym_get_next_dev_26(pdev);
+	return sym_get_next_dev_24(pdev);
+}
+
 /*
  *  Detect all 53c8xx hosts and then attach them.
  *
@@ -2734,7 +2777,7 @@ static u_short sym_chip_ids[] __initdata
 int __init sym53c8xx_detect(Scsi_Host_Template *tpnt)
 {
 	pcidev_t pcidev;
-	int i, j, chips, hosts, count;
+	int i, j, hosts, count;
 	int attach_count = 0;
 	sym_device *devtbl, *devp;
 	sym_nvram  nvram;
@@ -2793,7 +2836,6 @@ if (sym53c8xx)
 	 *  Save the first Symbios NVRAM content if any 
 	 *  for the boot order.
 	 */
-	chips	= sizeof(sym_chip_ids)	/ sizeof(sym_chip_ids[0]);
 	hosts	= PAGE_SIZE		/ sizeof(*devtbl);
 #if SYM_CONF_NVRAM_SUPPORT
 	nvp = (sym_driver_setup.use_nvram & 0x1) ? &nvram0 : 0;
@@ -2805,15 +2847,9 @@ if (sym53c8xx)
 		char *msg = "";
 		if (count >= hosts)
 			break;
-		if (j >= chips)
+		pcidev = sym_get_next_dev(pcidev);
+		if (!pcidev)
 			break;
-		i = sym_driver_setup.reverse_probe ? chips - 1 - j : j;
-		pcidev = pci_find_device(PCI_VENDOR_ID_NCR, sym_chip_ids[i],
-					 pcidev);
-		if (pcidev == PCIDEV_NULL) {
-			++j;
-			continue;
-		}
 		/* This one is guaranteed by AC to do nothing :-) */
 		if (pci_enable_device(pcidev))
 			continue;

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain

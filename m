From: Matthew Wilcox <willy@debian.org>
Subject: [PATCH] C3000 support in sym53c8xx
Date: Thu, 20 Mar 2003 13:41:10 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030320134110.GA14520@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Gerard Roudier <groudier@free.fr>
Cc: linux-scsi@vger.kernel.org


This patch adds support for the HP firmware call pdc_get_initiator().
This is necessary to support the narrow SCSI port on machines such as
the C3000 which use one channel of the 896 in narrow mode and one in
wide mode.  The only way to figure this out is to ask firmware how it's
configured.

diff -urN --exclude-from=/tmp/dont26845.2827 ../prev/linux-2.5/drivers/scsi/sym53c8xx.c linux-2.5/drivers/scsi/sym53c8xx.c
--- ../prev/linux-2.5/drivers/scsi/sym53c8xx.c	Tue Mar 18 09:41:09 2003
+++ linux-2.5/drivers/scsi/sym53c8xx.c	Wed Mar  5 14:17:53 2003
@@ -4901,6 +4901,11 @@
 	u_long	period;
 	int i;
 
+#ifdef CONFIG_PARISC
+	char scsi_mode = -1;
+	struct hardware_path hwpath;
+#endif
+
 	/*
 	**	Wide ?
 	*/
@@ -4972,6 +4977,31 @@
 	 */
 
 	period = (4 * div_10M[0] + np->clock_khz - 1) / np->clock_khz;
+
+#ifdef CONFIG_PARISC
+	/* Host firmware (PDC) keeps a table for crippling SCSI capabilities.
+	 * Many newer machines export one channel of 53c896 chip
+	 * as SE, 50-pin HD.  Also used for Multi-initiator SCSI clusters
+	 * to set the SCSI Initiator ID.
+	 */
+	get_pci_node_path(np->pdev, &hwpath);
+	if (pdc_get_initiator(&hwpath, &np->myaddr, &period, &np->maxwide, &scsi_mode))
+	{
+		if (np->maxwide) 
+			np->features |= FE_WIDE;
+		if (scsi_mode >= 0) {
+			/* C3000 PDC reports period/mode */
+			driver_setup.diff_support = 0;
+			switch(scsi_mode) {
+			case 0:	np->scsi_mode = SMODE_SE; break;
+			case 1:	np->scsi_mode = SMODE_HVD; break;
+			case 2:	np->scsi_mode = SMODE_LVD; break;
+			default:	break;
+			}
+		}
+	}
+#endif
+
 	if	(period <= 250)		np->minsync = 10;
 	else if	(period <= 303)		np->minsync = 11;
 	else if	(period <= 500)		np->minsync = 12;

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk

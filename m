From: Matthew Wilcox <willy@debian.org>
Subject: [PATCH] Remove naked GFP_DMA from drivers/scsi/sd.c
Date: Fri, 28 Feb 2003 06:34:29 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030228063429.C23865@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: Trivial Kernel Patches <trivial@rustcorp.com.au>, linux-scsi@vger.kernel.org


This GFP_DMA can be GFP_KERNEL because sd_init_onedisk calls sd_spinup_disk
calls scsi_wait_req which can sleep.

diff -urpNX dontdiff linux-2.5.63/drivers/scsi/sd.c linux-2.5.63-gfpdma/drivers/scsi/sd.c
--- linux-2.5.63/drivers/scsi/sd.c	2003-02-24 13:05:39.000000000 -0600
+++ linux-2.5.63-gfpdma/drivers/scsi/sd.c	2003-02-27 16:10:40.000000000 -0600
@@ -1197,7 +1197,7 @@ sd_init_onedisk(struct scsi_disk * sdkp,
 		return;
 	}
 
-	buffer = kmalloc(512, GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
 	if (!buffer) {
 		printk(KERN_WARNING "(sd_init_onedisk:) Memory allocation "
 		       "failure.\n");

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk

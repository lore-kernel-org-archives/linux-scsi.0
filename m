From: Matthew Wilcox <willy@debian.org>
Subject: [PATCH] Remove naked GFP_DMA from drivers/scsi/sr.c
Date: Fri, 28 Feb 2003 06:35:29 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030228063529.D23865@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: Trivial Kernel Patches <trivial@rustcorp.com.au>, linux-scsi@vger.kernel.org, Janitors <kernel-janitor-discuss@lists.sourceforge.net>


In get_sectorsize(), we can already sleep in scsi_wait_req().
In get_capabilities(), we can use GFP_KERNEL because it is only called
from sr_attach() which already does a GFP_KERNEL allocation.

diff -urpNX dontdiff linux-2.5.63/drivers/scsi/sr.c linux-2.5.63-gfpdma/drivers/scsi/sr.c
--- linux-2.5.63/drivers/scsi/sr.c	2003-02-24 13:05:13.000000000 -0600
+++ linux-2.5.63-gfpdma/drivers/scsi/sr.c	2003-02-27 16:17:59.000000000 -0600
@@ -604,7 +604,7 @@ static void get_sectorsize(struct scsi_c
 	struct scsi_request *SRpnt = NULL;
 	request_queue_t *queue;
 
-	buffer = kmalloc(512, GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
 	if (!buffer)
 		goto Enomem;
 	SRpnt = scsi_allocate_request(cd->device);
@@ -698,7 +698,7 @@ Enomem:
 	goto out;
 }
 
-void get_capabilities(struct scsi_cd *cd)
+static void get_capabilities(struct scsi_cd *cd)
 {
 	struct cdrom_generic_command cgc;
 	unsigned char *buffer;
@@ -716,9 +716,8 @@ void get_capabilities(struct scsi_cd *cd
 		""
 	};
 
-	buffer = kmalloc(512, GFP_DMA);
-	if (!buffer)
-	{
+	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	if (!buffer) {
 		printk(KERN_ERR "sr: out of memory.\n");
 		return;
 	}

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk

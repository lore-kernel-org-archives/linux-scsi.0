From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: [PATCH] 2.4.25-pre8: tight SCSI DMA pool due to incorrect resizing
Date: Mon, 2 Feb 2004 18:40:25 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFEF763A75.586B658C-ONC1256E2C.000FF8F7-C1256E2E.00618B36@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:27602 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP id S265732AbUBBRkr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Feb 2004 12:40:47 -0500
List-Id: linux-scsi@vger.kernel.org
To: marcelo.tosatti@cyclades.com, dledford@redhat.com
Cc: linux-scsi@vger.kernel.org, andmike@us.ibm.com, axboe@suse.de, garloff@suse.de





Marcelo, Doug,

while running extensive SCSI tests with SUSE kernels and the zfcp
driver we hit bugs which stem from the vanilla 2.4 kernel.
This particular problem causes unnecessary memory constraints
in the SCSI subsystem. The SCSI midlayer holds out a pool of
upto 32 MB which is the exclusive memory source for SCSI operation.
Due to a faulty calculation 2.4 kernels might end up with a
fraction amount. This has been especially observed with large
SCSI configurations which demand more than 32 MB, and which
are in turn hit hardest.
This patch has been blessed by Jens Axboe, Mike Anderson,
and Kurt Garloff, who helped straightening this out.

Please apply.

Cheers,
Martin

IBM Deutschland Entwicklung GmbH
Linux for eServer Development


--- linux-2.4.21/drivers/scsi/scsi_dma.c.orig   2002-02-25 20:38:04.000000000 +0100
+++ linux-2.4.21/drivers/scsi/scsi_dma.c  2004-01-25 16:45:24.000000000 +0100
@@ -287,7 +287,7 @@
 #endif

      /* limit DMA memory to 32MB: */
-     new_dma_sectors = (new_dma_sectors + 15) & 0xfff0;
+     new_dma_sectors = min(new_dma_sectors + 15, 0xffffU) & 0xfff0;

      /*
       * We never shrink the buffers - this leads to
@@ -348,7 +348,7 @@
                  if (new_dma_sectors < (8 * SECTORS_PER_PAGE))
                        break;      /* pretty well hopeless ... */
                  new_dma_sectors = (new_dma_sectors * 3) / 4;
-                 new_dma_sectors = (new_dma_sectors + 15) & 0xfff0;
+                 new_dma_sectors = min(new_dma_sectors + 15, 0xffffU) & 0xfff0;
                  if (new_dma_sectors <= dma_sectors)
                        break;      /* stick with what we have got */
            } else


From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] gdth: don't map zero-length requests
Date: Sun, 5 Feb 2006 16:36:23 +0100
Message-ID: <20060205153623.GA14143@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:15261 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751765AbWBEPgd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Feb 2006 10:36:33 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org, axboe@suse.de

From: Jenx Axboe <axboe@suse.de>

Don't map zero-length requests in gdth, zome architectures don't like
that in their dma mapping routines.

[ I'm pretty sure Jens posted this before, but for some reason it got
  forgotten  --hch ]


Index: linux-2.6/drivers/scsi/gdth.c
===================================================================
--- linux-2.6.orig/drivers/scsi/gdth.c	2006-01-16 16:19:38.000000000 +0100
+++ linux-2.6/drivers/scsi/gdth.c	2006-02-05 16:34:12.000000000 +0100
@@ -2816,7 +2816,7 @@
             }
 #endif
 
-        } else {
+        } else if (scp->request_bufflen) {
             scp->SCp.Status = GDTH_MAP_SINGLE;
             scp->SCp.Message = (read_write == 1 ? 
                 PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);

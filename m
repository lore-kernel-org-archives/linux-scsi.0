From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] esp: fix eh locking
Date: Wed, 22 Feb 2006 16:36:15 +0100
Message-ID: <20060222153615.GA23488@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
Sender: sparclinux-owner@vger.kernel.org
To: davem@davemloft.net, weeve@gentoo.org
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

esp_reset didn't get fixed when the EH locking changed.
->eh_bus_reset_handler is now called without the host lock held.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-2.6.x/drivers/scsi/esp.c
===================================================================
--- xfs-2.6.x.orig/drivers/scsi/esp.c	2005-10-30 22:00:21.000000000 +0100
+++ xfs-2.6.x/drivers/scsi/esp.c	2006-02-22 16:34:09.000000000 +0100
@@ -2068,14 +2068,12 @@
 {
 	struct esp *esp = (struct esp *) SCptr->device->host->hostdata;
 
+	spin_lock_irq(esp->ehost->host_lock);
 	(void) esp_do_resetbus(esp);
-
 	spin_unlock_irq(esp->ehost->host_lock);
 
 	wait_event(esp->reset_queue, (esp->resetting_bus == 0));
 
-	spin_lock_irq(esp->ehost->host_lock);
-
 	return SUCCESS;
 }
 

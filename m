From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] SCSI: aic7xxx_osm_pci resource leak fix.
Date: Sun, 23 Apr 2006 20:16:02 +0200
Message-ID: <200604232016.02979.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0102.google.com ([64.233.162.193]:10120 "EHLO
	nz-out-0102.google.com") by vger.kernel.org with ESMTP
	id S1751438AbWDWSPV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Apr 2006 14:15:21 -0400
Received: by nz-out-0102.google.com with SMTP id n1so905424nzf
        for <linux-scsi@vger.kernel.org>; Sun, 23 Apr 2006 11:15:20 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, Jesper Juhl <jesper.juhl@gmail.com>


Fix resource leak in 
drivers/scsi/aic7xxx/aic7xxx_osm_pci.c::ahc_linux_pci_dev_probe()

Found by the coverity checker (#668)


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c |    1 +
 1 files changed, 1 insertion(+)

--- linux-2.6.17-rc2-git4-orig/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2006-03-20 06:53:29.000000000 +0100
+++ linux-2.6.17-rc2-git4/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2006-04-23 20:05:50.000000000 +0200
@@ -219,6 +219,7 @@ ahc_linux_pci_dev_probe(struct pci_dev *
 		ahc->flags |= AHC_39BIT_ADDRESSING;
 	} else {
 		if (dma_set_mask(dev, DMA_32BIT_MASK)) {
+			ahc_free(ahc);
 			printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
                 	return (-ENODEV);
 		}




(please keep replies CC'ed to me)



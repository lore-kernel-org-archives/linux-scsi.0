From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] sas: clear parent->rphy in sas_rphy_delete
Date: Wed, 11 Jan 2006 14:20:43 +0100
Message-ID: <20060111132043.GA9583@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:28378 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751492AbWAKNUr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jan 2006 08:20:47 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

We need to clear the backpointer on rphy removal, else we'll run into
problems with host removal after a device has been hot unplugged.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/scsi/scsi_transport_sas.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_transport_sas.c	2006-01-06 14:45:03.000000000 +0100
+++ scsi-misc-2.6/drivers/scsi/scsi_transport_sas.c	2006-01-06 14:45:31.000000000 +0100
@@ -707,6 +707,8 @@
 	list_del(&rphy->list);
 	spin_unlock(&sas_host->lock);
 
+	parent->rphy = NULL;
+
 	put_device(&parent->dev);
 }
 EXPORT_SYMBOL(sas_rphy_delete);

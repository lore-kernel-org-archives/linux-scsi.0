From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] make sym2 scan devices again
Date: Fri, 8 Aug 2003 21:08:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030808190841.GC17983@lst.de>
References: <20030808190754.GB17983@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:52354 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S271972AbTHHTIo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2003 15:08:44 -0400
Content-Disposition: inline
In-Reply-To: <20030808190754.GB17983@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Aug 08, 2003 at 09:07:54PM +0200, Christoph Hellwig wrote:
> It needs a call to scsi_scan_host to find devices.  Also remove the
> superflous scsi_set_device call - scsi_add_host does that for us.

Sorry, wrong patch - this was my whole sym2 pending queue.

diff -Nru a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c	Fri Aug  8 11:11:33 2003
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c	Fri Aug  8 11:11:33 2003
@@ -2015,17 +2015,17 @@
 
 	SYM_UNLOCK_HCB(np, flags);
 
-	scsi_set_device(instance, &dev->pdev->dev);
-
 	/*
 	 *  Now let the generic SCSI driver
 	 *  look for the SCSI devices on the bus ..
 	 */
-	scsi_add_host(instance, &dev->pdev->dev);
+	scsi_add_host(instance, &dev->pdev->dev); /* XXX: handle failure */
+	scsi_scan_host(instance);
 	return 0;
 
 attach_failed:
-	if (!instance) return -1;
+	if (!instance)
+		return -1;
 	printf_info("%s: giving up ...\n", sym_name(np));
 	if (np)
 		sym_free_resources(np);

From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] cciss: handler scsi_add_host failure
Date: Mon, 3 Jan 2005 14:24:31 +0100
Message-ID: <20050103132431.GA22309@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:43926 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261440AbVACNYg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jan 2005 08:24:36 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

--- 1.23/drivers/block/cciss_scsi.c	2004-10-14 16:15:25 +02:00
+++ edited/drivers/block/cciss_scsi.c	2004-12-31 14:42:51 +01:00
@@ -691,14 +691,13 @@ static int
 cciss_scsi_detect(int ctlr)
 {
 	struct Scsi_Host *sh;
+	int error;
 
 	sh = scsi_host_alloc(&cciss_driver_template, sizeof(struct ctlr_info *));
 	if (sh == NULL)
-		return 0;
-
+		goto fail;
 	sh->io_port = 0;	// good enough?  FIXME, 
 	sh->n_io_port = 0;	// I don't think we use these two...
-
 	sh->this_id = SELF_SCSI_ID;  
 
 	((struct cciss_scsi_adapter_data_t *) 
@@ -706,10 +705,16 @@ cciss_scsi_detect(int ctlr)
 	sh->hostdata[0] = (unsigned long) hba[ctlr];
 	sh->irq = hba[ctlr]->intr;
 	sh->unique_id = sh->irq;
-	scsi_add_host(sh, &hba[ctlr]->pdev->dev); /* XXX handle failure */
+	error = scsi_add_host(sh, &hba[ctlr]->pdev->dev);
+	if (error)
+		goto fail_host_put;
 	scsi_scan_host(sh);
-
 	return 1;
+
+ fail_host_put:
+	scsi_host_put(sh);
+ fail:
+	return 0;
 }
 
 static void __exit cleanup_cciss_module(void);

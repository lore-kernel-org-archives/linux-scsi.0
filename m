From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH 5/8] aacraid: error return checking  (Updated)
Date: Mon, 12 Sep 2005 10:35:30 -0700
Message-ID: <1126546530.7407.16.camel@markh1.pdx.osdl.net>
References: <1126212624.7479.23.camel@markh1.pdx.osdl.net>
	 <20050910191925.GC3662@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:54930 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751089AbVILRfi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 13:35:38 -0400
In-Reply-To: <20050910191925.GC3662@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Sat, 2005-09-10 at 20:19 +0100, Christoph Hellwig wrote:
> > @@ -929,9 +932,14 @@
> >  	printk(KERN_INFO "Adaptec %s driver (%s)\n",
> >  	  AAC_DRIVERNAME, aac_driver_version);
> >  
> > -	error = pci_module_init(&aac_pci_driver);
> > -	if (error)
> > +	error = pci_register_driver(&aac_pci_driver);
> > +	if (error < 0 || list_empty(&aac_devices)) {
> > +		if (error >= 0) {
> > +			pci_unregister_driver(&aac_pci_driver);
> > +			error = -ENODEV;
> > +		}
> >  		return error;
> 
> The list_empty check is wrong.  I driver should stay loaded even if
> no devices have been found.

Here is an updated patch with the suggested change.

- - - - 
Received from Mark Salyzyn from Adaptec

This patch adds some additional error return checking and error return
value propagation during initialization. Also, the deprecation of
pci_module_init with pci_register_driver along with the change in return
values.

Applies to the scsi-misc-2.6 git tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>



Index: scsi-misc-aac-2/drivers/scsi/aacraid/linit.c
===================================================================
--- scsi-misc-aac-2.orig/drivers/scsi/aacraid/linit.c	2005-09-12 08:58:32.000000000 -0700
+++ scsi-misc-aac-2/drivers/scsi/aacraid/linit.c	2005-09-12 09:01:05.000000000 -0700
@@ -748,7 +748,8 @@
 		unique_id++;
 	}
 
-	if (pci_enable_device(pdev))
+	error = pci_enable_device(pdev);
+	if (error)
 		goto out;
 
 	if (pci_set_dma_mask(pdev, 0xFFFFFFFFULL) || 
@@ -801,7 +802,9 @@
 			goto out_free_fibs;
 
 	aac->maximum_num_channels = aac_drivers[index].channels;
-	aac_get_adapter_info(aac);
+	error = aac_get_adapter_info(aac);
+	if (error < 0)
+		goto out_deinit;
 
 	/*
  	 * Lets override negotiations and drop the maximum SG limit to 34
@@ -929,8 +932,8 @@
 	printk(KERN_INFO "Adaptec %s driver (%s)\n",
 	  AAC_DRIVERNAME, aac_driver_version);
 
-	error = pci_module_init(&aac_pci_driver);
-	if (error)
+	error = pci_register_driver(&aac_pci_driver);
+	if (error < 0)
 		return error;
 
 	aac_cfg_major = register_chrdev( 0, "aac", &aac_cfg_fops);

-- 
Mark Haverkamp <markh@osdl.org>


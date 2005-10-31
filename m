From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] megaraid_sas: fix EH locking
Date: Mon, 31 Oct 2005 19:51:24 +0100
Message-ID: <20051031185124.GA16303@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:45472 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932480AbVJaSvb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Oct 2005 13:51:31 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, Sreenivas.Bagalkote@lsil.com
Cc: linux-scsi@vger.kernel.org

recent kernels call the eh_ methods without the host lock held.
megaraid_sas doesn't need it but drops it before calling a sleeping
routine and reqcquires it afterwards.  Just remove the
spin_unlock/spin_lock calls.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/megaraid/megaraid_sas.c
===================================================================
--- linux-2.6.orig/drivers/scsi/megaraid/megaraid_sas.c	2005-10-11 19:53:19.000000000 +0200
+++ linux-2.6/drivers/scsi/megaraid/megaraid_sas.c	2005-10-31 11:01:39.000000000 +0100
@@ -768,17 +764,12 @@
 		return FAILED;
 	}
 
-	spin_unlock(scmd->device->host->host_lock);
-
 	ret_val = megasas_wait_for_outstanding(instance);
-
 	if (ret_val == SUCCESS)
 		printk(KERN_NOTICE "megasas: reset successful \n");
 	else
 		printk(KERN_ERR "megasas: failed to do reset\n");
 
-	spin_lock(scmd->device->host->host_lock);
-
 	return ret_val;
 }
 

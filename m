From: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>
Subject: RE: [PATCH] megaraid_sas: fix EH locking
Date: Mon, 31 Oct 2005 13:52:57 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57060CD2BF@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:19939 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932481AbVJaSxW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Oct 2005 13:53:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@lst.de>, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

>Subject: [PATCH] megaraid_sas: fix EH locking
>
>recent kernels call the eh_ methods without the host lock held.
>megaraid_sas doesn't need it but drops it before calling a sleeping
>routine and reqcquires it afterwards.  Just remove the
>spin_unlock/spin_lock calls.
>

Thank you.

>
>Signed-off-by: Christoph Hellwig <hch@lst.de>
>
>Index: linux-2.6/drivers/scsi/megaraid/megaraid_sas.c
>===================================================================
>--- linux-2.6.orig/drivers/scsi/megaraid/megaraid_sas.c	
>2005-10-11 19:53:19.000000000 +0200
>+++ linux-2.6/drivers/scsi/megaraid/megaraid_sas.c	
>2005-10-31 11:01:39.000000000 +0100
>@@ -768,17 +764,12 @@
> 		return FAILED;
> 	}
> 
>-	spin_unlock(scmd->device->host->host_lock);
>-
> 	ret_val = megasas_wait_for_outstanding(instance);
>-
> 	if (ret_val == SUCCESS)
> 		printk(KERN_NOTICE "megasas: reset successful \n");
> 	else
> 		printk(KERN_ERR "megasas: failed to do reset\n");
> 
>-	spin_lock(scmd->device->host->host_lock);
>-
> 	return ret_val;
> }
> 
>

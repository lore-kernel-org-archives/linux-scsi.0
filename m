From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 3/8] fusion - setting timeouts in eh threads appropiatley for fc/sas/spi
Date: Tue, 17 Jan 2006 09:13:57 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1AAD12@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:49572 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751265AbWAQQOe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2006 11:14:34 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Tuesday, January 17, 2006 6:43 AM,  Christoph Hellwig wrote:

> The timeout selection should probably be done in a little 
> helper instead
> of duplicated in a few places.  Updated patch below:
> 
> 
> Index: linux-2.6/drivers/message/fusion/mptscsih.c
> ===================================================================
> --- linux-2.6.orig/drivers/message/fusion/mptscsih.c	
> 2006-01-17 14:07:57.000000000 +0100
> +++ linux-2.6/drivers/message/fusion/mptscsih.c	
> 2006-01-17 14:10:55.000000000 +0100
> @@ -1719,6 +1719,20 @@
>  	return retval;
>  }
>  
> +static int
> +mptscsih_get_tm_timeout(MPT_ADAPTER *ioc)
> +{
> +	switch (ioc->bus_type) {
> +	case FC:
> +		return 40;
> +	case SAS:
> +		return 10;
> +	case SPI:
> +	default:
> +		return 2;
> +	}
> +}
> +
>  

Good idea to combine everything into mptscsih_get_tm_timeout.
However the SPI timeout is 2 seconds for eh_abort_handler,
and 5 seconds for eh_device_reset_handler and eh_bus_reset_handler. 
It would be better to go with 5 seconds in the SPI case, as the
driver timeout needs to be be longer than the firmware timeout.


Index: linux-2.6/drivers/message/fusion/mptscsih.c
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptscsih.c	2006-01-17
14:07:57.000000000 +0100
+++ linux-2.6/drivers/message/fusion/mptscsih.c	2006-01-17
14:10:55.000000000 +0100
@@ -1719,6 +1719,20 @@
 	return retval;
 }
 
+static int
+mptscsih_get_tm_timeout(MPT_ADAPTER *ioc)
+{
+	switch (ioc->bus_type) {
+	case FC:
+		return 40;
+	case SAS:
+		return 10;
+	case SPI:
+	default:
+		return 5;
+	}
+}
+
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=-=-=*/
 /**
  *	mptscsih_abort - Abort linux scsi_cmnd routine, new_eh variant
@@ -1790,7 +1804,7 @@
 	vdev = SCpnt->device->hostdata;
 	retval = mptscsih_TMHandler(hd,
MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
 		vdev->bus_id, vdev->target_id, vdev->lun,
-		ctx2abort, 2 /* 2 second timeout */);
+		ctx2abort, mptscsih_get_tm_timeout(ioc));
 
 	printk (KERN_WARNING MYNAM ": %s: task abort: %s (sc=%p)\n",
 		hd->ioc->name,
@@ -1841,7 +1855,7 @@
 	vdev = SCpnt->device->hostdata;
 	retval = mptscsih_TMHandler(hd,
MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
 		vdev->bus_id, vdev->target_id,
-		0, 0, 5 /* 5 second timeout */);
+		0, 0, mptscsih_get_tm_timeout(hd->ioc));
 
 	printk (KERN_WARNING MYNAM ": %s: target reset: %s (sc=%p)\n",
 		hd->ioc->name,
@@ -1891,7 +1905,7 @@
 
 	vdev = SCpnt->device->hostdata;
 	retval = mptscsih_TMHandler(hd,
MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
-		vdev->bus_id, 0, 0, 0, 5 /* 5 second timeout */);
+		vdev->bus_id, 0, 0, 0,
mptscsih_get_tm_timeout(hd->ioc));
 
 	printk (KERN_WARNING MYNAM ": %s: bus reset: %s (sc=%p)\n",
 		hd->ioc->name,

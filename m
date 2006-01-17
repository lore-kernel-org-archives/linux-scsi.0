From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] fusion - setting timeouts in eh threads appropiatley for fc/sas/spi
Date: Tue, 17 Jan 2006 13:43:14 +0000
Message-ID: <20060117134314.GB9152@infradead.org>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F1AAC7F@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:5832 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932483AbWAQNnP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2006 08:43:15 -0500
Content-Disposition: inline
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F1AAC7F@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Jan 16, 2006 at 06:53:13PM -0700, Moore, Eric wrote:
> The task managment request timeout in the eh threads was set 
> for U320 timing, which is between 2-5 seconds. 
> This is too small for FC and SAS.
> According to the firmware engineers, Fibre needs to be 40 seconds
> and SAS needs to be 10 seconds.

The timeout selection should probably be done in a little helper instead
of duplicated in a few places.  Updated patch below:


Index: linux-2.6/drivers/message/fusion/mptscsih.c
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptscsih.c	2006-01-17 14:07:57.000000000 +0100
+++ linux-2.6/drivers/message/fusion/mptscsih.c	2006-01-17 14:10:55.000000000 +0100
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
+		return 2;
+	}
+}
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mptscsih_abort - Abort linux scsi_cmnd routine, new_eh variant
@@ -1790,7 +1804,7 @@
 	vdev = SCpnt->device->hostdata;
 	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
 		vdev->bus_id, vdev->target_id, vdev->lun,
-		ctx2abort, 2 /* 2 second timeout */);
+		ctx2abort, mptscsih_get_tm_timeout(ioc));
 
 	printk (KERN_WARNING MYNAM ": %s: task abort: %s (sc=%p)\n",
 		hd->ioc->name,
@@ -1841,7 +1855,7 @@
 	vdev = SCpnt->device->hostdata;
 	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
 		vdev->bus_id, vdev->target_id,
-		0, 0, 5 /* 5 second timeout */);
+		0, 0, mptscsih_get_tm_timeout(hd->ioc));
 
 	printk (KERN_WARNING MYNAM ": %s: target reset: %s (sc=%p)\n",
 		hd->ioc->name,
@@ -1891,7 +1905,7 @@
 
 	vdev = SCpnt->device->hostdata;
 	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
-		vdev->bus_id, 0, 0, 0, 5 /* 5 second timeout */);
+		vdev->bus_id, 0, 0, 0, mptscsih_get_tm_timeout(hd->ioc));
 
 	printk (KERN_WARNING MYNAM ": %s: bus reset: %s (sc=%p)\n",
 		hd->ioc->name,

From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] Add Domain Validation to 53c700 driver
Date: 14 Mar 2004 00:35:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079242515.1759.90.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:60898 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263291AbUCNFfT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 00:35:19 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/linuxconf) with ESMTP id i2E5ZHa12225
	for <linux-scsi@vger.kernel.org>; Sun, 14 Mar 2004 00:35:17 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This simply throws out the 53c700 driver's optimistic setting of the
best possible transport parameters and replaces it with DV
determination.  It also adds a missing report_bus_reset() callback and
finally does a delayed DV on device errors.

James

===== drivers/scsi/53c700.c 1.48 vs edited =====
--- 1.48/drivers/scsi/53c700.c	Fri Mar 12 06:52:13 2004
+++ edited/drivers/scsi/53c700.c	Sat Mar 13 23:17:21 2004
@@ -1522,6 +1522,8 @@
 			printk(KERN_ERR "scsi%d: Bus Reset detected, executing command %p, slot %p, dsp %08x[%04x]\n",
 			       host->host_no, SCp, SCp == NULL ? NULL : SCp->host_scribble, dsp, dsp - hostdata->pScript);
 
+			scsi_report_bus_reset(host, 0);
+
 			/* clear all the negotiated parameters */
 			__shost_for_each_device(SDp, host)
 				SDp->hostdata = 0;
@@ -1967,6 +1969,9 @@
 	wait_for_completion(&complete);
 	spin_lock_irq(SCp->device->host->host_lock);
 	hostdata->eh_complete = NULL;
+	/* Revalidate the transport parameters of the failing device */
+	if(hostdata->fast)
+		spi_schedule_dv_device(SCp->device);
 	return SUCCESS;
 }
 
@@ -2051,9 +2056,11 @@
 		scsi_adjust_queue_depth(SDp, 0, SDp->host->cmd_per_lun);
 	}
 	if(hostdata->fast) {
-		NCR_700_set_period(SDp, hostdata->min_period);
-		NCR_700_set_offset(SDp, hostdata->chip710
-				   ? NCR_710_MAX_OFFSET : NCR_700_MAX_OFFSET);
+		/* Find the correct offset and period via domain validation */
+		spi_dv_device(SDp);
+	} else {
+		spi_offset(SDp) = 0;
+		spi_period(SDp) = 0;
 	}
 	return 0;
 }


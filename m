From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] update the 53c700 use of transport attributes
Date: 12 Mar 2004 16:09:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079125796.1877.39.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:31134 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262885AbUCLVJ7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2004 16:09:59 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/linuxconf) with ESMTP id i2CL9wa32167
	for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2004 16:09:58 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This patch just brings it up to date with the previous transport
attribute patch, moving it to the model where it sets the min/max of the
attribute if asked for something outside its range.  It also only makes
period and offset visible (it doesn't care about any of the others).

James

===== drivers/scsi/53c700.c 1.47 vs edited =====
--- 1.47/drivers/scsi/53c700.c	Sun Mar  7 17:44:25 2004
+++ edited/drivers/scsi/53c700.c	Fri Mar 12 12:52:13 2004
@@ -1998,9 +2002,12 @@
 	struct NCR_700_Host_Parameters *hostdata = 
 		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
 	
-	if(!hostdata->fast || period < hostdata->min_period)
+	if(!hostdata->fast)
 		return;
 
+	if(period < hostdata->min_period)
+		period = hostdata->min_period;
+
 	spi_period(SDp) = period;
 	NCR_700_clear_flag(SDp, NCR_700_DEV_NEGOTIATED_SYNC);
 	NCR_700_clear_flag(SDp, NCR_700_DEV_BEGIN_SYNC_NEGOTIATION);
@@ -2012,12 +2019,15 @@
 {
 	struct NCR_700_Host_Parameters *hostdata = 
 		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
+	int max_offset = hostdata->chip710
+		? NCR_710_MAX_OFFSET : NCR_700_MAX_OFFSET;
 	
-	if(!hostdata->fast ||
-	   offset > (hostdata->chip710
-		     ? NCR_710_MAX_OFFSET : NCR_700_MAX_OFFSET))
+	if(!hostdata->fast)
 		return;
 
+	if(offset > max_offset)
+		offset = max_offset;
+
 	/* if we're currently async, make sure the period is reasonable */
 	if(spi_offset(SDp) == 0 && (spi_period(SDp) < hostdata->min_period ||
 				    spi_period(SDp) > 0xff))
@@ -2107,8 +2119,10 @@
 EXPORT_SYMBOL(NCR_700_intr);
 
 static struct spi_function_template NCR_700_transport_functions =  {
-	.set_period = NCR_700_set_period,
-	.set_offset = NCR_700_set_offset,
+	.set_period	= NCR_700_set_period,
+	.show_period	= 1,
+	.set_offset	= NCR_700_set_offset,
+	.show_offset	= 1,
 };
 
 static int __init NCR_700_init(void)


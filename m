From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] aic7xxx: remove inquiry sniffing leftovers
Date: Tue, 19 Apr 2005 19:40:35 +0200
Message-ID: <20050419174035.GA22235@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:27777 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261451AbVDSRkk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2005 13:40:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

--- 1.66/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-04-17 19:03:05 +02:00
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-04-19 21:33:10 +02:00
@@ -2335,8 +2335,6 @@
 		      AHC_TRANS_GOAL, /*paused*/FALSE);
 	ahc_update_neg_request(ahc, &devinfo, tstate, tinfo, AHC_NEG_ALWAYS);
 	ahc->platform_data->targets[target_offset] = NULL;
-	if (targ->inq_data != NULL)
-		free(targ->inq_data, M_DEVBUF);
 	free(targ, M_DEVBUF);
 }
 
--- 1.60/drivers/scsi/aic7xxx/aic7xxx_osm.h	2005-04-17 19:03:06 +02:00
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.h	2005-04-19 21:33:46 +02:00
@@ -423,10 +423,6 @@
 	struct			ahc_linux_target *target;
 };
 
-typedef enum {
-	AHC_INQ_VALID		 = 0x02,
-} ahc_linux_targ_flags;
-
 struct ahc_linux_target {
 	struct ahc_linux_device	 *devices[AHC_NUM_LUNS];
 	int			  channel;
@@ -434,8 +430,6 @@
 	int			  refcount;
 	struct ahc_transinfo	  last_tinfo;
 	struct ahc_softc	 *ahc;
-	ahc_linux_targ_flags	  flags;
-	struct scsi_inquiry_data *inq_data;
 };
 
 /********************* Definitions Required by the Core ***********************/

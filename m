From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Use spi_display_xfer_agreement() in 53c700
Date: Sun, 6 Mar 2005 17:25:09 +0000
Message-ID: <20050306172509.GT28741@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:55249 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261435AbVCFRZK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Mar 2005 12:25:10 -0500
Received: from willy by parcelfarce.linux.theplanet.co.uk with local (Exim 4.33)
	id 1D7zV8-0001AS-0j
	for linux-scsi@vger.kernel.org; Sun, 06 Mar 2005 17:25:10 +0000
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Convert 53c700 to use spi_display_xfer_agreement()

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

Index: ./drivers/scsi/53c700.c
===================================================================
RCS file: /var/lib/cvs/linux-2.6/drivers/scsi/53c700.c,v
retrieving revision 1.15.2.1
retrieving revision 1.15
diff -u -p -r1.15.2.1 -r1.15
--- ./drivers/scsi/53c700.c	2 Mar 2005 11:19:13 -0000	1.15.2.1
+++ ./drivers/scsi/53c700.c	24 Feb 2005 14:48:28 -0000	1.15
@@ -824,6 +825,7 @@ process_extended_message(struct Scsi_Hos
 	switch(hostdata->msgin[2]) {
 	case A_SDTR_MSG:
 		if(SCp != NULL && NCR_700_is_flag_set(SCp->device, NCR_700_DEV_BEGIN_SYNC_NEGOTIATION)) {
+			struct scsi_target *starget = SCp->device->sdev_target;
 			__u8 period = hostdata->msgin[3];
 			__u8 offset = hostdata->msgin[4];
 
@@ -831,22 +833,15 @@ process_extended_message(struct Scsi_Hos
 				offset = 0;
 				period = 0;
 			}
+
+			spi_offset(starget) = offset;
+			spi_period(starget) = period;
 			
 			if(NCR_700_is_flag_set(SCp->device, NCR_700_DEV_PRINT_SYNC_NEGOTIATION)) {
-				if(spi_offset(SCp->device->sdev_target) != 0)
-					printk(KERN_INFO "scsi%d: (%d:%d) Synchronous at offset %d, period %dns\n",
-					       host->host_no, pun, lun,
-					       offset, period*4);
-				else
-					printk(KERN_INFO "scsi%d: (%d:%d) Asynchronous\n",
-					       host->host_no, pun, lun);
+				spi_display_xfer_agreement(starget);
 				NCR_700_clear_flag(SCp->device, NCR_700_DEV_PRINT_SYNC_NEGOTIATION);
 			}
-				
-			spi_offset(SCp->device->sdev_target) = offset;
-			spi_period(SCp->device->sdev_target) = period;
 			
-
 			NCR_700_set_flag(SCp->device, NCR_700_DEV_NEGOTIATED_SYNC);
 			NCR_700_clear_flag(SCp->device, NCR_700_DEV_BEGIN_SYNC_NEGOTIATION);
 			

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain

From: Jamie Lenehan <lenehan@twibble.org>
Subject: [PATCH] dc395x - 2/3 remove-static-adapter-list
Date: Sun, 3 Aug 2003 18:28:36 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030803082836.GB4611@twibble.org>
References: <20030803082718.GA4594@twibble.org> <20030803082759.GA4611@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:37811 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S271080AbTHCI2h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Aug 2003 04:28:37 -0400
Content-Disposition: inline
In-Reply-To: <20030803082759.GA4611@twibble.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dc395x@twibble.org

Remove the static list of adapters and the code related to keeping
this up to date. The only remaining use for the static list was for
the proc info function to find the scsi_host, but that's passed as a
parameter anyway.

diff -r -du a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	2003-08-03 18:08:11.097370376 +1000
+++ b/drivers/scsi/dc395x.c	2003-08-03 18:08:20.215984136 +1000
@@ -387,7 +387,6 @@
   -----------------------------------------------------------------------*/
 struct AdapterCtlBlk {
 	struct Scsi_Host *scsi_host;
-	struct AdapterCtlBlk *next_acb;
 
 	u16 IOPortBase;
 
@@ -515,8 +514,6 @@
 /*---------------------------------------------------------------------------
                                  Static Data
  ---------------------------------------------------------------------------*/
-static struct AdapterCtlBlk *acb_list_head = NULL;
-static struct AdapterCtlBlk *acb_list_tail = NULL;
 static u16 current_sync_offset = 0;
 static char monitor_next_irq = 0;
 
@@ -5502,15 +5499,7 @@
 	}
  	print_config(acb);
 
- 	if (!init_adapter(host, io_port, irq)) {
- 		if (!acb_list_head) {
- 			acb_list_head = acb;
-  		} else {
- 			acb_list_tail->next_acb = acb;
-  		}
- 		acb_list_tail = acb;
- 		acb->next_acb = NULL;
-	} else {
+ 	if (init_adapter(host, io_port, irq)) {
 		dprintkl(KERN_INFO, "DC395x_initAdapter initial ERROR\n");
 		goto failed;
 	}
@@ -5557,25 +5546,15 @@
  else SPRINTF(" No  ")
 
 static
-int dc395x_proc_info(struct Scsi_Host *shpnt, char *buffer, char **start, off_t offset, int length,
+int dc395x_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset, int length,
 		     int inout)
 {
+	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)host->hostdata;
 	int dev, spd, spd1;
 	char *pos = buffer;
-	struct AdapterCtlBlk *acb;
 	struct DeviceCtlBlk *dcb;
 	unsigned long flags;
 
-	acb = acb_list_head;
-
-	while (acb) {
-  		if (acb->scsi_host == shpnt)
-  			break;
-		acb = acb->next_acb;
-  	}
-	if (!acb)
-		return -ESRCH;
-
 	if (inout)		/* Has data been written to the file ? */
 		return -EPERM;
 
@@ -5584,15 +5563,15 @@
 
 	DC395x_LOCK_IO(acb->scsi_host, flags);
 
-	SPRINTF("SCSI Host Nr %i, ", shpnt->host_no);
+	SPRINTF("SCSI Host Nr %i, ", host->host_no);
 	SPRINTF("DC395U/UW/F DC315/U %s\n",
 		(acb->config & HCC_WIDE_CARD) ? "Wide" : "");
 	SPRINTF("IOPortBase 0x%04x, ", acb->IOPortBase);
 	SPRINTF("irq_level 0x%02x, ", acb->irq_level);
 	SPRINTF(" SelTimeout %ims\n", (1638 * acb->sel_timeout) / 1000);
 
-	SPRINTF("MaxID %i, MaxLUN %i, ", shpnt->max_id, shpnt->max_lun);
-	SPRINTF("AdapterID %i\n", shpnt->this_id);
+	SPRINTF("MaxID %i, MaxLUN %i, ", host->max_id, host->max_lun);
+	SPRINTF("AdapterID %i\n", host->this_id);
 
 	SPRINTF("tag_max_num %i", acb->tag_max_num);
 	/*SPRINTF(", DMA_Status %i\n", DC395x_read8(acb, TRM_S1040_DMA_STATUS)); */

-- 
 Jamie Lenehan              Work Phone: +61 3 9843 8817
 lenehan@twibble.org        Work Email: jamie.lenehan@activcard.com.au

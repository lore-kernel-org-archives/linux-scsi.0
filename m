From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill 53c700 ->proc_info
Date: Mon, 9 Jun 2003 20:28:58 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030609182858.GA3544@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:34192 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264144AbTFISPW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2003 14:15:22 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

All information is provided in sysfs nowdays.


diff -Nru a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
--- a/drivers/scsi/53c700.c	Sun Jun  8 22:37:49 2003
+++ b/drivers/scsi/53c700.c	Sun Jun  8 22:37:49 2003
@@ -168,7 +168,6 @@
 STATIC int NCR_700_bus_reset(Scsi_Cmnd * SCpnt);
 STATIC int NCR_700_dev_reset(Scsi_Cmnd * SCpnt);
 STATIC int NCR_700_host_reset(Scsi_Cmnd * SCpnt);
-STATIC int NCR_700_proc_directory_info(struct Scsi_Host *, char *, char **, off_t, int, int);
 STATIC void NCR_700_chip_setup(struct Scsi_Host *host);
 STATIC void NCR_700_chip_reset(struct Scsi_Host *host);
 STATIC int NCR_700_slave_configure(Scsi_Device *SDpnt);
@@ -281,7 +280,6 @@
 	tpnt->sg_tablesize = NCR_700_SG_SEGMENTS;
 	tpnt->cmd_per_lun = NCR_700_CMD_PER_LUN;
 	tpnt->use_clustering = DISABLE_CLUSTERING;
-	tpnt->proc_info = NCR_700_proc_directory_info;
 	tpnt->slave_configure = NCR_700_slave_configure;
 	tpnt->slave_destroy = NCR_700_slave_destroy;
 	tpnt->use_blk_tcq = 1;
@@ -1708,35 +1706,6 @@
  out_unlock:
 	spin_unlock_irqrestore(host->host_lock, flags);
 	return IRQ_RETVAL(handled);
-}
-
-STATIC int
-NCR_700_proc_directory_info(struct Scsi_Host *host, char *proc_buf, char **startp,
-			 off_t offset, int bytes_available, int write)
-{
-	static char buf[4096];	/* 1 page should be sufficient */
-	int len = 0;
-	struct NCR_700_Host_Parameters *hostdata;
-	Scsi_Device *SDp;
-
-	if(write) {
-		/* FIXME: Clear internal statistics here */
-		return 0;
-	}
-	hostdata = (struct NCR_700_Host_Parameters *)host->hostdata[0];
-	len += sprintf(&buf[len], "Total commands outstanding: %d\n", hostdata->command_slot_count);
-	len += sprintf(&buf[len],"\
-Target	Active  Next Tag\n\
-======	======  ========\n");
-	list_for_each_entry(SDp, &host->my_devices, siblings) {
-		len += sprintf(&buf[len]," %2d:%2d   %4d      %4d\n", SDp->id, SDp->lun, NCR_700_get_depth(SDp), SDp->current_tag);
-	}
-	if((len -= offset) <= 0)
-		return 0;
-	if(len > bytes_available)
-		len = bytes_available;
-	memcpy(proc_buf, buf + offset, len);
-	return len;
 }
 
 STATIC int

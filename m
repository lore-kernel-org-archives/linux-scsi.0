From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 2/11] aacraid: Track command ownership in driver
Date: Mon, 27 Mar 2006 09:43:40 -0800
Message-ID: <1143481420.21975.37.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:22463 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751035AbWC0Rnn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Mar 2006 12:43:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received from Mark Salyzyn

The loss of the ownership flags, despite their flaws, in the scsi
command were sorely missed and are reinstated more accurately in the
aacraid driver to track commands and permit us to properly handle error
recovery actions.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---
Applies to the scsi-misc-2.6 git tree.

--- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	2006-03-22 11:17:34.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	2006-03-22 11:17:41.000000000 -0800
@@ -386,6 +386,7 @@
 	struct scsi_cmnd * scsicmd;
 
 	scsicmd = (struct scsi_cmnd *) context;
+	scsicmd->SCp.phase = AAC_OWNER_MIDLEVEL;
 
 	dprintk((KERN_DEBUG "get_container_name_callback[cpu %d]: t = %ld.\n", smp_processor_id(), jiffies));
 	if (fibptr == NULL)
@@ -452,8 +453,10 @@
 	/*
 	 *	Check that the command queued to the controller
 	 */
-	if (status == -EINPROGRESS) 
+	if (status == -EINPROGRESS) {
+		scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
 		return 0;
+	}
 		
 	printk(KERN_WARNING "aac_get_container_name: aac_fib_send failed with status: %d.\n", status);
 	aac_fib_complete(cmd_fibcontext);
@@ -906,6 +909,7 @@
 	u32 cid;
 
 	scsicmd = (struct scsi_cmnd *) context;
+	scsicmd->SCp.phase = AAC_OWNER_MIDLEVEL;
 
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 	cid = scmd_id(scsicmd);
@@ -1150,8 +1154,10 @@
 	/*
 	 *	Check that the command queued to the controller
 	 */
-	if (status == -EINPROGRESS) 
+	if (status == -EINPROGRESS) {
+		scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
 		return 0;
+	}
 		
 	printk(KERN_WARNING "aac_read: aac_fib_send failed with status: %d.\n", status);
 	/*
@@ -1317,8 +1323,8 @@
 	/*
 	 *	Check that the command queued to the controller
 	 */
-	if (status == -EINPROGRESS)
-	{
+	if (status == -EINPROGRESS) {
+		scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
 		return 0;
 	}
 
@@ -1340,6 +1346,7 @@
 	struct scsi_cmnd *cmd;
 
 	cmd = context;
+	cmd->SCp.phase = AAC_OWNER_MIDLEVEL;
 
 	dprintk((KERN_DEBUG "synchronize_callback[cpu %d]: t = %ld.\n", 
 				smp_processor_id(), jiffies));
@@ -1385,12 +1392,12 @@
 	unsigned long flags;
 
 	/*
-	 * Wait for all commands to complete to this specific
-	 * target (block).
+	 * Wait for all outstanding queued commands to complete to this
+	 * specific target (block).
 	 */
 	spin_lock_irqsave(&sdev->list_lock, flags);
 	list_for_each_entry(cmd, &sdev->cmd_list, list)
-		if (cmd != scsicmd && cmd->serial_number != 0) {
+		if (cmd != scsicmd && cmd->SCp.phase == AAC_OWNER_FIRMWARE) {
 			++active;
 			break;
 		}
@@ -1433,8 +1440,10 @@
 	/*
 	 *	Check that the command queued to the controller
 	 */
-	if (status == -EINPROGRESS)
+	if (status == -EINPROGRESS) {
+		scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
 		return 0;
+	}
 
 	printk(KERN_WARNING 
 		"aac_synchronize: aac_fib_send failed with status: %d.\n", status);
@@ -1457,7 +1466,6 @@
 	struct Scsi_Host *host = scsicmd->device->host;
 	struct aac_dev *dev = (struct aac_dev *)host->hostdata;
 	struct fsa_dev_info *fsa_dev_ptr = dev->fsa_dev;
-	int ret;
 	
 	/*
 	 *	If the bus, id or lun is out of range, return fail
@@ -1728,24 +1736,19 @@
 			 *	containers to /dev/sd device names
 			 */
 			 
-			spin_unlock_irq(host->host_lock);
 			if (scsicmd->request->rq_disk)
 				strlcpy(fsa_dev_ptr[cid].devname,
 				scsicmd->request->rq_disk->disk_name,
 			  	min(sizeof(fsa_dev_ptr[cid].devname),
 				sizeof(scsicmd->request->rq_disk->disk_name) + 1));
-			ret = aac_read(scsicmd, cid);
-			spin_lock_irq(host->host_lock);
-			return ret;
+
+			return aac_read(scsicmd, cid);
 
 		case WRITE_6:
 		case WRITE_10:
 		case WRITE_12:
 		case WRITE_16:
-			spin_unlock_irq(host->host_lock);
-			ret = aac_write(scsicmd, cid);
-			spin_lock_irq(host->host_lock);
-			return ret;
+			return aac_write(scsicmd, cid);
 
 		case SYNCHRONIZE_CACHE:
 			/* Issue FIB to tell Firmware to flush it's cache */
@@ -1890,6 +1893,7 @@
 	struct scsi_cmnd *scsicmd;
 
 	scsicmd = (struct scsi_cmnd *) context;
+	scsicmd->SCp.phase = AAC_OWNER_MIDLEVEL;
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 
 	if (fibptr == NULL)
@@ -2161,7 +2165,8 @@
 	/*
 	 *	Check that the command queued to the controller
 	 */
-	if (status == -EINPROGRESS){
+	if (status == -EINPROGRESS) {
+		scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
 		return 0;
 	}
 
--- scsi-misc-aac.orig/drivers/scsi/aacraid/aacraid.h	2006-03-22 11:17:34.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/aacraid.h	2006-03-22 11:17:41.000000000 -0800
@@ -1770,6 +1770,11 @@
 }
 
 struct scsi_cmnd;
+/* SCp.phase values */
+#define AAC_OWNER_MIDLEVEL	0x101
+#define AAC_OWNER_LOWLEVEL	0x102
+#define AAC_OWNER_ERROR_HANDLER	0x103
+#define AAC_OWNER_FIRMWARE	0x106
 
 const char *aac_driverinfo(struct Scsi_Host *);
 struct fib *aac_fib_alloc(struct aac_dev *dev);
--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2006-03-22 11:12:24.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2006-03-22 11:17:41.000000000 -0800
@@ -242,6 +242,7 @@
 static int aac_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
 	cmd->scsi_done = done;
+	cmd->SCp.phase = AAC_OWNER_LOWLEVEL;
 	return (aac_scsi_cmd(cmd) ? FAILED : 0);
 } 
 
@@ -470,7 +471,8 @@
 		__shost_for_each_device(dev, host) {
 			spin_lock_irqsave(&dev->list_lock, flags);
 			list_for_each_entry(command, &dev->cmd_list, list) {
-				if (command->serial_number) {
+				if ((command != cmd) &&
+				    (command->SCp.phase == AAC_OWNER_FIRMWARE)) {
 					active++;
 					break;
 				}

-- 
Mark Haverkamp <markh@osdl.org>


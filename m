From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] kill libata scsi_wait_req usage (make libata compile in
	scsi-misc)
Date: Mon, 07 Nov 2005 17:53:55 -0600
Message-ID: <1131407635.19822.2.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:61597 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S965110AbVKHB5P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2005 20:57:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com, linux-scsi@vger.kernel.org

scsi_wait_req does not exist in scsi-misc. This patch makes it
so libata can compile in scsi-misc. This patch has only been compile
tested.

Patch was made against scsi-misc.

diff --git a/drivers/scsi/libata-scsi.c b/drivers/scsi/libata-scsi.c
index 0613d3e..c224e6f 100644
--- a/drivers/scsi/libata-scsi.c
+++ b/drivers/scsi/libata-scsi.c
@@ -147,7 +147,8 @@ int ata_cmd_ioctl(struct scsi_device *sc
 	u8 scsi_cmd[MAX_COMMAND_SIZE];
 	u8 args[4], *argbuf = NULL;
 	int argsize = 0;
-	struct scsi_request *sreq;
+	struct scsi_sense_hdr sshdr;
+	enum dma_data_direction data_dir;
 
 	if (NULL == (void *)arg)
 		return -EINVAL;
@@ -155,10 +156,6 @@ int ata_cmd_ioctl(struct scsi_device *sc
 	if (copy_from_user(args, arg, sizeof(args)))
 		return -EFAULT;
 
-	sreq = scsi_allocate_request(scsidev, GFP_KERNEL);
-	if (!sreq)
-		return -EINTR;
-
 	memset(scsi_cmd, 0, sizeof(scsi_cmd));
 
 	if (args[3]) {
@@ -172,11 +169,11 @@ int ata_cmd_ioctl(struct scsi_device *sc
 		scsi_cmd[1]  = (4 << 1); /* PIO Data-in */
 		scsi_cmd[2]  = 0x0e;     /* no off.line or cc, read from dev,
 		                            block count in sector count field */
-		sreq->sr_data_direction = DMA_FROM_DEVICE;
+		data_dir = DMA_FROM_DEVICE;
 	} else {
 		scsi_cmd[1]  = (3 << 1); /* Non-data */
 		/* scsi_cmd[2] is already 0 -- no off.line, cc, or data xfer */
-		sreq->sr_data_direction = DMA_NONE;
+		data_dir = DMA_NONE;
 	}
 
 	scsi_cmd[0] = ATA_16;
@@ -194,9 +191,8 @@ int ata_cmd_ioctl(struct scsi_device *sc
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	scsi_wait_req(sreq, scsi_cmd, argbuf, argsize, (10*HZ), 5);
-
-	if (sreq->sr_result) {
+	if (scsi_execute_req(scsidev, scsi_cmd, data_dir, argbuf, argsize,
+			     &sshdr, (10*HZ), 5)) {
 		rc = -EIO;
 		goto error;
 	}
@@ -207,8 +203,6 @@ int ata_cmd_ioctl(struct scsi_device *sc
 	 && copy_to_user((void *)(arg + sizeof(args)), argbuf, argsize))
 		rc = -EFAULT;
 error:
-	scsi_release_request(sreq);
-
 	if (argbuf)
 		kfree(argbuf);
 
@@ -231,7 +225,7 @@ int ata_task_ioctl(struct scsi_device *s
 	int rc = 0;
 	u8 scsi_cmd[MAX_COMMAND_SIZE];
 	u8 args[7];
-	struct scsi_request *sreq;
+	struct scsi_sense_hdr sshdr;
 
 	if (NULL == (void *)arg)
 		return -EINVAL;
@@ -250,26 +244,13 @@ int ata_task_ioctl(struct scsi_device *s
 	scsi_cmd[12] = args[5];
 	scsi_cmd[14] = args[0];
 
-	sreq = scsi_allocate_request(scsidev, GFP_KERNEL);
-	if (!sreq) {
-		rc = -EINTR;
-		goto error;
-	}
-
-	sreq->sr_data_direction = DMA_NONE;
 	/* Good values for timeout and retries?  Values below
-	   from scsi_ioctl_send_command() for default case... */
-	scsi_wait_req(sreq, scsi_cmd, NULL, 0, (10*HZ), 5);
-
-	if (sreq->sr_result) {
+	   from scsi_ioctl_send_command() for default case... */	
+	if (scsi_execute_req(scsidev, scsi_cmd, DMA_NONE, NULL, 0, &sshdr,
+			     (10*HZ), 5))
 		rc = -EIO;
-		goto error;
-	}
 
 	/* Need code to retrieve data from check condition? */
-
-error:
-	scsi_release_request(sreq);
 	return rc;
 }
 



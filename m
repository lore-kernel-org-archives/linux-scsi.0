From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi_ioctl.c codingstyle fixes
Date: Tue, 3 Jun 2003 23:05:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030603210503.GB9336@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:15785 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261216AbTFCUvj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jun 2003 16:51:39 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

dito

diff -Nru a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
--- a/drivers/scsi/scsi_ioctl.c	Sun Jun  1 21:27:11 2003
+++ b/drivers/scsi/scsi_ioctl.c	Sun Jun  1 21:27:11 2003
@@ -90,75 +90,70 @@
  * The output area is then filled in starting from the command byte. 
  */
 
-static int ioctl_internal_command(Scsi_Device * dev, char *cmd,
+static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 				  int timeout, int retries)
 {
+	struct scsi_request *sreq;
 	int result;
-	Scsi_Request *SRpnt;
-	Scsi_Device *SDpnt;
 
+	SCSI_LOG_IOCTL(1, printk("Trying ioctl with scsi command %d\n", *cmd));
 
-	SCSI_LOG_IOCTL(1, printk("Trying ioctl with scsi command %d\n", cmd[0]));
-	if (NULL == (SRpnt = scsi_allocate_request(dev))) {
+	sreq = scsi_allocate_request(sdev);
+	if (!sreq) {
 		printk("SCSI internal ioctl failed, no memory\n");
 		return -ENOMEM;
 	}
 
-	SRpnt->sr_data_direction = SCSI_DATA_NONE;
-        scsi_wait_req(SRpnt, cmd, NULL, 0, timeout, retries);
+	sreq->sr_data_direction = SCSI_DATA_NONE;
+        scsi_wait_req(sreq, cmd, NULL, 0, timeout, retries);
 
-	SCSI_LOG_IOCTL(2, printk("Ioctl returned  0x%x\n", SRpnt->sr_result));
+	SCSI_LOG_IOCTL(2, printk("Ioctl returned  0x%x\n", sreq->sr_result));
 
-	if (driver_byte(SRpnt->sr_result) != 0)
-		switch (SRpnt->sr_sense_buffer[2] & 0xf) {
+	if (driver_byte(sreq->sr_result)) {
+		switch (sreq->sr_sense_buffer[2] & 0xf) {
 		case ILLEGAL_REQUEST:
 			if (cmd[0] == ALLOW_MEDIUM_REMOVAL)
-				dev->lockable = 0;
+				sdev->lockable = 0;
 			else
 				printk("SCSI device (ioctl) reports ILLEGAL REQUEST.\n");
 			break;
 		case NOT_READY:	/* This happens if there is no disc in drive */
-			if (dev->removable && (cmd[0] != TEST_UNIT_READY)) {
+			if (sdev->removable && (cmd[0] != TEST_UNIT_READY)) {
 				printk(KERN_INFO "Device not ready.  Make sure there is a disc in the drive.\n");
 				break;
 			}
 		case UNIT_ATTENTION:
-			if (dev->removable) {
-				dev->changed = 1;
-				SRpnt->sr_result = 0;	/* This is no longer considered an error */
-				/* gag this error, VFS will log it anyway /axboe */
-				/* printk(KERN_INFO "Disc change detected.\n"); */
+			if (sdev->removable) {
+				sdev->changed = 1;
+				sreq->sr_result = 0;	/* This is no longer considered an error */
 				break;
 			}
 		default:	/* Fall through for non-removable media */
 			printk("SCSI error: host %d id %d lun %d return code = %x\n",
-			       dev->host->host_no,
-			       dev->id,
-			       dev->lun,
-			       SRpnt->sr_result);
+			       sdev->host->host_no,
+			       sdev->id,
+			       sdev->lun,
+			       sreq->sr_result);
 			printk("\tSense class %x, sense error %x, extended sense %x\n",
-			       sense_class(SRpnt->sr_sense_buffer[0]),
-			       sense_error(SRpnt->sr_sense_buffer[0]),
-			       SRpnt->sr_sense_buffer[2] & 0xf);
+			       sense_class(sreq->sr_sense_buffer[0]),
+			       sense_error(sreq->sr_sense_buffer[0]),
+			       sreq->sr_sense_buffer[2] & 0xf);
 
 		}
+	}
 
-	result = SRpnt->sr_result;
-
+	result = sreq->sr_result;
 	SCSI_LOG_IOCTL(2, printk("IOCTL Releasing command\n"));
-	SDpnt = SRpnt->sr_device;
-	scsi_release_request(SRpnt);
-	SRpnt = NULL;
-
+	scsi_release_request(sreq);
 	return result;
 }
 
-int scsi_set_medium_removal(Scsi_Device *dev, char state)
+int scsi_set_medium_removal(struct scsi_device *sdev, char state)
 {
 	char scsi_cmd[MAX_COMMAND_SIZE];
 	int ret;
 
-	if (!dev->removable || !dev->lockable)
+	if (!sdev->removable || !sdev->lockable)
 	       return 0;
 
 	scsi_cmd[0] = ALLOW_MEDIUM_REMOVAL;
@@ -168,11 +163,10 @@
 	scsi_cmd[4] = state;
 	scsi_cmd[5] = 0;
 
-	ret = ioctl_internal_command(dev, scsi_cmd, IOCTL_NORMAL_TIMEOUT, NORMAL_RETRIES);
-
+	ret = ioctl_internal_command(sdev, scsi_cmd,
+			IOCTL_NORMAL_TIMEOUT, NORMAL_RETRIES);
 	if (ret == 0)
-		dev->locked = state == SCSI_REMOVAL_PREVENT;
-
+		sdev->locked = (state == SCSI_REMOVAL_PREVENT);
 	return ret;
 }
 
@@ -209,13 +203,13 @@
  */
 #define OMAX_SB_LEN 16		/* Old sense buffer length */
 
-int scsi_ioctl_send_command(Scsi_Device * dev, Scsi_Ioctl_Command * sic)
+int scsi_ioctl_send_command(struct scsi_device *sdev,
+			    struct scsi_ioctl_command *sic)
 {
 	char *buf;
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	char *cmd_in;
-	Scsi_Request *SRpnt;
-	Scsi_Device *SDpnt;
+	struct scsi_request *sreq;
 	unsigned char opcode;
 	unsigned int inlen, outlen, cmdlen;
 	unsigned int needed, buf_needed;
@@ -225,7 +219,7 @@
 	if (!sic)
 		return -EINVAL;
 
-	if (dev->host->unchecked_isa_dma)
+	if (sdev->host->unchecked_isa_dma)
 		gfp_mask |= GFP_DMA;
 
 	/*
@@ -259,11 +253,11 @@
 		buf_needed = (buf_needed + 511) & ~511;
 		if (buf_needed > MAX_BUF)
 			buf_needed = MAX_BUF;
-		buf = (char *) kmalloc(buf_needed, gfp_mask);
+		buf = kmalloc(buf_needed, gfp_mask);
 		if (!buf)
 			return -ENOMEM;
 		memset(buf, 0, buf_needed);
-		if( inlen == 0 ) {
+		if (inlen == 0) {
 			data_direction = SCSI_DATA_READ;
 		} else if (outlen == 0 ) {
 			data_direction = SCSI_DATA_WRITE;
@@ -327,62 +321,34 @@
 		break;
 	}
 
-#ifndef DEBUG_NO_CMD
-
-
-	SRpnt = scsi_allocate_request(dev);
-        if( SRpnt == NULL )
-        {
+	sreq = scsi_allocate_request(sdev);
+        if (sreq) {
                 result = -EINTR;
                 goto error;
         }
 
-	SRpnt->sr_data_direction = data_direction;
-        scsi_wait_req(SRpnt, cmd, buf, needed, timeout, retries);
+	sreq->sr_data_direction = data_direction;
+        scsi_wait_req(sreq, cmd, buf, needed, timeout, retries);
 
 	/* 
 	 * If there was an error condition, pass the info back to the user. 
 	 */
-
-	result = SRpnt->sr_result;
-
-	if (SRpnt->sr_result) {
-		int sb_len = sizeof(SRpnt->sr_sense_buffer);
+	result = sreq->sr_result;
+	if (result) {
+		int sb_len = sizeof(sreq->sr_sense_buffer);
 
 		sb_len = (sb_len > OMAX_SB_LEN) ? OMAX_SB_LEN : sb_len;
-		if (copy_to_user(cmd_in, SRpnt->sr_sense_buffer, sb_len))
+		if (copy_to_user(cmd_in, sreq->sr_sense_buffer, sb_len))
 			result = -EFAULT;
 	} else {
 		if (copy_to_user(cmd_in, buf, outlen))
 			result = -EFAULT;
 	}	
 
-	SDpnt = SRpnt->sr_device;
-	scsi_release_request(SRpnt);
-	SRpnt = NULL;
-
+	scsi_release_request(sreq);
 error:
-	if (buf)
-		kfree(buf);
-
-
+	kfree(buf);
 	return result;
-#else
-	{
-		int i;
-		printk("scsi_ioctl : device %d.  command = ", dev->id);
-		for (i = 0; i < cmdlen; ++i)
-			printk("%02x ", cmd[i]);
-		printk("\nbuffer =");
-		for (i = 0; i < 20; ++i)
-			printk("%02x ", buf[i]);
-		printk("\n");
-		printk("inlen = %d, outlen = %d, cmdlen = %d\n",
-		       inlen, outlen, cmdlen);
-		printk("buffer = %d, cmd_in = %d\n", buffer, cmd_in);
-	}
-	return 0;
-#endif
 }
 
 /*
@@ -395,14 +361,13 @@
  *                  device)
  *          any copy_to_user() error on failure there
  */
-static int
-scsi_ioctl_get_pci(Scsi_Device * sdev, void *arg)
+static int scsi_ioctl_get_pci(struct scsi_device *sdev, void *arg)
 {
 	struct device *dev = scsi_get_device(sdev->host);
 
-        if (!dev) return -ENXIO;
-        return copy_to_user(arg, dev->bus_id,
-                            sizeof(dev->bus_id));
+        if (!dev)
+		return -ENXIO;
+        return copy_to_user(arg, dev->bus_id, sizeof(dev->bus_id));
 }
 
 
@@ -411,12 +376,12 @@
  * not take a major/minor number as the dev field.  Rather, it takes
  * a pointer to a scsi_devices[] element, a structure. 
  */
-int scsi_ioctl(Scsi_Device * dev, int cmd, void *arg)
+int scsi_ioctl(struct scsi_device *sdev, int cmd, void *arg)
 {
 	char scsi_cmd[MAX_COMMAND_SIZE];
 
 	/* No idea how this happens.... */
-	if (!dev)
+	if (!sdev)
 		return -ENXIO;
 
 	/*
@@ -425,24 +390,24 @@
 	 * may try and take the device offline, in which case all further
 	 * access to the device is prohibited.
 	 */
-	if (!scsi_block_when_processing_errors(dev)) {
+	if (!scsi_block_when_processing_errors(sdev))
 		return -ENODEV;
-	}
 
 	switch (cmd) {
 	case SCSI_IOCTL_GET_IDLUN:
-		if (verify_area(VERIFY_WRITE, arg, sizeof(Scsi_Idlun)))
+		if (verify_area(VERIFY_WRITE, arg, sizeof(struct scsi_idlun)))
 			return -EFAULT;
 
-		__put_user((dev->id & 0xff)
-			 + ((dev->lun & 0xff) << 8)
-			 + ((dev->channel & 0xff) << 16)
-			 + ((dev->host->host_no & 0xff) << 24),
-			 &((Scsi_Idlun *) arg)->dev_id);
-		__put_user(dev->host->unique_id, &((Scsi_Idlun *) arg)->host_unique_id);
+		__put_user((sdev->id & 0xff)
+			 + ((sdev->lun & 0xff) << 8)
+			 + ((sdev->channel & 0xff) << 16)
+			 + ((sdev->host->host_no & 0xff) << 24),
+			 &((struct scsi_idlun *)arg)->dev_id);
+		__put_user(sdev->host->unique_id,
+			 &((struct scsi_idlun *)arg)->host_unique_id);
 		return 0;
 	case SCSI_IOCTL_GET_BUS_NUMBER:
-		return put_user(dev->host->host_no, (int *) arg);
+		return put_user(sdev->host->host_no, (int *)arg);
 	/*
 	 * The next two ioctls either need to go or need to be changed to
 	 * pass tagged queueing changes through the low level drivers.
@@ -454,61 +419,56 @@
 	case SCSI_IOCTL_TAGGED_ENABLE:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
-		if (!dev->tagged_supported)
+		if (!sdev->tagged_supported)
 			return -EINVAL;
-		dev->tagged_queue = 1;
-		dev->current_tag = 1;
+		sdev->tagged_queue = 1;
+		sdev->current_tag = 1;
 		return 0;
 	case SCSI_IOCTL_TAGGED_DISABLE:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
-		if (!dev->tagged_supported)
+		if (!sdev->tagged_supported)
 			return -EINVAL;
-		dev->tagged_queue = 0;
-		dev->current_tag = 0;
+		sdev->tagged_queue = 0;
+		sdev->current_tag = 0;
 		return 0;
 	case SCSI_IOCTL_PROBE_HOST:
-		return ioctl_probe(dev->host, arg);
+		return ioctl_probe(sdev->host, arg);
 	case SCSI_IOCTL_SEND_COMMAND:
 		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 			return -EACCES;
-		return scsi_ioctl_send_command((Scsi_Device *) dev,
-					     (Scsi_Ioctl_Command *) arg);
+		return scsi_ioctl_send_command(sdev,
+				(struct scsi_ioctl_command *)arg);
 	case SCSI_IOCTL_DOORLOCK:
-		return scsi_set_medium_removal(dev, SCSI_REMOVAL_PREVENT);
+		return scsi_set_medium_removal(sdev, SCSI_REMOVAL_PREVENT);
 	case SCSI_IOCTL_DOORUNLOCK:
-		return scsi_set_medium_removal(dev, SCSI_REMOVAL_ALLOW);
+		return scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
 	case SCSI_IOCTL_TEST_UNIT_READY:
 		scsi_cmd[0] = TEST_UNIT_READY;
 		scsi_cmd[1] = 0;
 		scsi_cmd[2] = scsi_cmd[3] = scsi_cmd[5] = 0;
 		scsi_cmd[4] = 0;
-		return ioctl_internal_command((Scsi_Device *) dev, scsi_cmd,
+		return ioctl_internal_command(sdev, scsi_cmd,
 				   IOCTL_NORMAL_TIMEOUT, NORMAL_RETRIES);
-		break;
 	case SCSI_IOCTL_START_UNIT:
 		scsi_cmd[0] = START_STOP;
 		scsi_cmd[1] = 0;
 		scsi_cmd[2] = scsi_cmd[3] = scsi_cmd[5] = 0;
 		scsi_cmd[4] = 1;
-		return ioctl_internal_command((Scsi_Device *) dev, scsi_cmd,
+		return ioctl_internal_command(sdev, scsi_cmd,
 				     START_STOP_TIMEOUT, NORMAL_RETRIES);
-		break;
 	case SCSI_IOCTL_STOP_UNIT:
 		scsi_cmd[0] = START_STOP;
 		scsi_cmd[1] = 0;
 		scsi_cmd[2] = scsi_cmd[3] = scsi_cmd[5] = 0;
 		scsi_cmd[4] = 0;
-		return ioctl_internal_command((Scsi_Device *) dev, scsi_cmd,
+		return ioctl_internal_command(sdev, scsi_cmd,
 				     START_STOP_TIMEOUT, NORMAL_RETRIES);
-		break;
         case SCSI_IOCTL_GET_PCI:
-                return scsi_ioctl_get_pci(dev, arg);
-                break;
+                return scsi_ioctl_get_pci(sdev, arg);
 	default:
-		if (dev->host->hostt->ioctl)
-			return dev->host->hostt->ioctl(dev, cmd, arg);
-		return -EINVAL;
+		if (sdev->host->hostt->ioctl)
+			return sdev->host->hostt->ioctl(sdev, cmd, arg);
 	}
 	return -EINVAL;
 }
@@ -518,13 +478,13 @@
  * fs segment fiddling.
  */
 
-int kernel_scsi_ioctl(Scsi_Device * dev, int cmd, void *arg)
+int kernel_scsi_ioctl(struct scsi_device *sdev, int cmd, void *arg)
 {
 	mm_segment_t oldfs;
 	int tmp;
 	oldfs = get_fs();
 	set_fs(get_ds());
-	tmp = scsi_ioctl(dev, cmd, arg);
+	tmp = scsi_ioctl(sdev, cmd, arg);
 	set_fs(oldfs);
 	return tmp;
 }


From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] add scsi_mode_select to scsi_lib.c
Date: Sat, 18 Mar 2006 14:10:35 -0600
Message-ID: <1142712635.3773.1.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:42692 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750841AbWCRUKh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Mar 2006 15:10:37 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k2IKAa222413
	for <linux-scsi@vger.kernel.org>; Sat, 18 Mar 2006 15:10:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This complements the scsi_mode_sense() function

James

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9a05076..ede158d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1811,6 +1811,84 @@ void scsi_exit_queue(void)
 		kmem_cache_destroy(sgp->slab);
 	}
 }
+
+/**
+ *	scsi_mode_select - issue a mode select
+ *	@sdev:	SCSI device to be queried
+ *	@pf:	Page format bit (1 == standard, 0 == vendor specific)
+ *	@sp:	Save page bit (0 == don't save, 1 == save)
+ *	@modepage: mode page being requested
+ *	@buffer: request buffer (may not be smaller than eight bytes)
+ *	@len:	length of request buffer.
+ *	@timeout: command timeout
+ *	@retries: number of retries before failing
+ *	@data: returns a structure abstracting the mode header data
+ *	@sense: place to put sense data (or NULL if no sense to be collected).
+ *		must be SCSI_SENSE_BUFFERSIZE big.
+ *
+ *	Returns zero if successful; negative error number or scsi
+ *	status on error
+ *
+ */
+int
+scsi_mode_select(struct scsi_device *sdev, int pf, int sp, int modepage,
+		 unsigned char *buffer, int len, int timeout, int retries,
+		 struct scsi_mode_data *data, struct scsi_sense_hdr *sshdr)
+{
+	unsigned char cmd[10];
+	unsigned char *real_buffer;
+	int ret;
+
+	memset(cmd, 0, sizeof(cmd));
+	cmd[1] = (pf ? 0x10 : 0) | (sp ? 0x01 : 0);
+
+	if (sdev->use_10_for_ms) {
+		if (len > 65535)
+			return -EINVAL;
+		real_buffer = kmalloc(8 + len, GFP_KERNEL);
+		if (!real_buffer)
+			return -ENOMEM;
+		memcpy(real_buffer + 8, buffer, len);
+		len += 8;
+		real_buffer[0] = 0;
+		real_buffer[1] = 0;
+		real_buffer[2] = data->medium_type;
+		real_buffer[3] = data->device_specific;
+		real_buffer[4] = data->longlba ? 0x01 : 0;
+		real_buffer[5] = 0;
+		real_buffer[6] = data->block_descriptor_length >> 8;
+		real_buffer[7] = data->block_descriptor_length;
+
+		cmd[0] = MODE_SELECT_10;
+		cmd[7] = len >> 8;
+		cmd[8] = len;
+	} else {
+		if (len > 255 || data->block_descriptor_length > 255 ||
+		    data->longlba)
+			return -EINVAL;
+
+		real_buffer = kmalloc(4 + len, GFP_KERNEL);
+		if (!real_buffer)
+			return -ENOMEM;
+		memcpy(real_buffer + 4, buffer, len);
+		len += 4;
+		real_buffer[0] = 0;
+		real_buffer[1] = data->medium_type;
+		real_buffer[2] = data->device_specific;
+		real_buffer[3] = data->block_descriptor_length;
+		
+
+		cmd[0] = MODE_SELECT;
+		cmd[4] = len;
+	}
+
+	ret = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, real_buffer, len,
+			       sshdr, timeout, retries);
+	kfree(real_buffer);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(scsi_mode_select);
+
 /**
  *	scsi_mode_sense - issue a mode sense, falling back from 10 to 
  *		six bytes if necessary.
@@ -1832,7 +1910,8 @@ void scsi_exit_queue(void)
 int
 scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 		  unsigned char *buffer, int len, int timeout, int retries,
-		  struct scsi_mode_data *data, struct scsi_sense_hdr *sshdr) {
+		  struct scsi_mode_data *data, struct scsi_sense_hdr *sshdr)
+{
 	unsigned char cmd[12];
 	int use_10_for_ms;
 	int header_length;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f2193cd..895d212 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -261,6 +261,11 @@ extern int scsi_mode_sense(struct scsi_d
 			   unsigned char *buffer, int len, int timeout,
 			   int retries, struct scsi_mode_data *data,
 			   struct scsi_sense_hdr *);
+extern int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
+			    int modepage, unsigned char *buffer, int len,
+			    int timeout, int retries,
+			    struct scsi_mode_data *data,
+			    struct scsi_sense_hdr *);
 extern int scsi_test_unit_ready(struct scsi_device *sdev, int timeout,
 				int retries);
 extern int scsi_device_set_state(struct scsi_device *sdev,



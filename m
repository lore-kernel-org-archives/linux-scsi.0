From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] fix Sony USB mass storage - pass larger receive buffer
Date: Wed, 12 Nov 2003 15:50:29 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031112155029.A20986@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:48105 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261777AbTKLXv3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Nov 2003 18:51:29 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net
Cc: ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

James - can you please apply? This should not affect other devices since
we are not changing the requested length, just the size of the receive
buffer.

This patch against a recent 2.6 bk fixes problems with Sony USB mass
storage devices: they are sending back 10 bytes even when we ask for 8
bytes (USB babble).

Just use a larger receive buffer for MODE SENSE even though we are
requesting 8 bytes.

Tested by Ronald Kuetemei with his Sony camera, also tested with a USB CF
card reader.

diff -uprN -X /home/patman/dontdiff bl-25/drivers/scsi/scsi_lib.c modesense-bufflen-bk-2.5/drivers/scsi/scsi_lib.c
--- bl-25/drivers/scsi/scsi_lib.c	Mon Sep 29 12:21:09 2003
+++ modesense-bufflen-bk-2.5/drivers/scsi/scsi_lib.c	Mon Nov 10 15:42:03 2003
@@ -1348,8 +1348,9 @@ void scsi_exit_queue(void)
  *	@sreq:	SCSI request to fill in with the MODE_SENSE
  *	@dbd:	set if mode sense will allow block descriptors to be returned
  *	@modepage: mode page being requested
- *	@buffer: request buffer (may not be smaller than eight bytes)
- *	@len:	length of request buffer.
+ *	@buffer: request buffer
+ *	@len:	length passed in to scsi command
+ *	@buf_len: length of request buffer (may not be smaller than eight)
  *	@timeout: command timeout
  *	@retries: number of retries before failing
  *	@data: returns a structure abstracting the mode header data
@@ -1357,15 +1358,24 @@ void scsi_exit_queue(void)
  *	Returns zero if unsuccessful, or the header offset (either 4
  *	or 8 depending on whether a six or ten byte command was
  *	issued) if successful.
+ *
+ *	Note: buf_len is passed in as a separate value because some
+ *	devices return more data than requested.
  **/
 int
 __scsi_mode_sense(struct scsi_request *sreq, int dbd, int modepage,
-		  unsigned char *buffer, int len, int timeout, int retries,
-		  struct scsi_mode_data *data) {
+		  unsigned char *buffer, int len, int buf_len, int timeout,
+		  int retries, struct scsi_mode_data *data) {
 	unsigned char cmd[12];
 	int use_10_for_ms;
 	int header_length;
 
+	WARN_ON((buf_len < 8) || (buf_len < len));
+	if (buf_len > 255)
+		buf_len = 255;
+	if (len > 255)
+		len = 255;
+
 	memset(data, 0, sizeof(*data));
 	memset(&cmd[0], 0, 12);
 	cmd[1] = dbd & 0x18;	/* allows DBD and LLBA bits */
@@ -1395,9 +1405,9 @@ __scsi_mode_sense(struct scsi_request *s
 	sreq->sr_sense_buffer[2] = 0;
 	sreq->sr_data_direction = DMA_FROM_DEVICE;
 
-	memset(buffer, 0, len);
+	memset(buffer, 0, buf_len);
 
-	scsi_wait_req(sreq, cmd, buffer, len, timeout, retries);
+	scsi_wait_req(sreq, cmd, buffer, buf_len, timeout, retries);
 
 	/* This code looks awful: what it's doing is making sure an
 	 * ILLEGAL REQUEST sense return identifies the actual command
@@ -1439,8 +1449,9 @@ __scsi_mode_sense(struct scsi_request *s
  *	@sdev:	scsi device to send command to.
  *	@dbd:	set if mode sense will disable block descriptors in the return
  *	@modepage: mode page being requested
- *	@buffer: request buffer (may not be smaller than eight bytes)
- *	@len:	length of request buffer.
+ *	@buffer: request buffer
+ *	@len:	length passed in to scsi command
+ *	@buf_len: length of request buffer (may not be smaller than eight)
  *	@timeout: command timeout
  *	@retries: number of retries before failing
  *
@@ -1450,8 +1461,8 @@ __scsi_mode_sense(struct scsi_request *s
  **/
 int
 scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
-		unsigned char *buffer, int len, int timeout, int retries,
-		struct scsi_mode_data *data)
+		unsigned char *buffer, int len, int buf_len, int timeout,
+		int retries, struct scsi_mode_data *data)
 {
 	struct scsi_request *sreq = scsi_allocate_request(sdev, GFP_KERNEL);
 	int ret;
@@ -1459,7 +1470,7 @@ scsi_mode_sense(struct scsi_device *sdev
 	if (!sreq)
 		return -1;
 
-	ret = __scsi_mode_sense(sreq, dbd, modepage, buffer, len,
+	ret = __scsi_mode_sense(sreq, dbd, modepage, buffer, len, buf_len,
 				timeout, retries, data);
 
 	scsi_release_request(sreq);
diff -uprN -X /home/patman/dontdiff bl-25/drivers/scsi/sd.c modesense-bufflen-bk-2.5/drivers/scsi/sd.c
--- bl-25/drivers/scsi/sd.c	Mon Oct 27 14:28:18 2003
+++ modesense-bufflen-bk-2.5/drivers/scsi/sd.c	Mon Nov 10 15:38:06 2003
@@ -1073,19 +1073,21 @@ got_data:
 /* called with buffer of length 512 */
 static inline int
 sd_do_mode_sense(struct scsi_request *SRpnt, int dbd, int modepage,
-		 unsigned char *buffer, int len, struct scsi_mode_data *data)
+		 unsigned char *buffer, int len, int buf_len,
+		 struct scsi_mode_data *data)
 {
-	return __scsi_mode_sense(SRpnt, dbd, modepage, buffer, len,
+	return __scsi_mode_sense(SRpnt, dbd, modepage, buffer, len, buf_len,
 				 SD_TIMEOUT, SD_MAX_RETRIES, data);
 }
 
 /*
  * read write protect setting, if possible - called only in sd_revalidate_disk()
- * called with buffer of length 512
  */
 static void
 sd_read_write_protect_flag(struct scsi_disk *sdkp, char *diskname,
-		   struct scsi_request *SRpnt, unsigned char *buffer) {
+		   struct scsi_request *SRpnt, unsigned char *buffer,
+		   int buf_len) 
+{
 	int res;
 	struct scsi_mode_data data;
 
@@ -1099,7 +1101,7 @@ sd_read_write_protect_flag(struct scsi_d
 	 * We have to start carefully: some devices hang if we ask
 	 * for more than is available.
 	 */
-	res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 4, &data);
+	res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 4, buf_len, &data);
 
 	/*
 	 * Second attempt: ask for page 0
@@ -1107,13 +1109,14 @@ sd_read_write_protect_flag(struct scsi_d
 	 * Sense Key 5: Illegal Request, Sense Code 24: Invalid field in CDB.
 	 */
 	if (!scsi_status_is_good(res))
-		res = sd_do_mode_sense(SRpnt, 0, 0, buffer, 4, &data);
+		res = sd_do_mode_sense(SRpnt, 0, 0, buffer, 4, buf_len, &data);
 
 	/*
 	 * Third attempt: ask 255 bytes, as we did earlier.
 	 */
 	if (!scsi_status_is_good(res))
-		res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 255, &data);
+		res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 255, buf_len,
+				       &data);
 
 	if (!scsi_status_is_good(res)) {
 		printk(KERN_WARNING
@@ -1129,11 +1132,12 @@ sd_read_write_protect_flag(struct scsi_d
 
 /*
  * sd_read_cache_type - called only from sd_revalidate_disk()
- * called with buffer of length 512
  */
 static void
 sd_read_cache_type(struct scsi_disk *sdkp, char *diskname,
-		   struct scsi_request *SRpnt, unsigned char *buffer) {
+		   struct scsi_request *SRpnt, unsigned char *buffer,
+		   int buf_len) 
+{
 	int len = 0, res;
 
 	const int dbd = 0;	   /* DBD */
@@ -1144,7 +1148,7 @@ sd_read_cache_type(struct scsi_disk *sdk
 		goto defaults;
 
 	/* cautiously ask */
-	res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, 4, &data);
+	res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, 4, buf_len, &data);
 
 	if (!scsi_status_is_good(res))
 		goto bad_sense;
@@ -1165,7 +1169,8 @@ sd_read_cache_type(struct scsi_disk *sdk
 	len += data.header_length + data.block_descriptor_length;
 
 	/* Get the data */
-	res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, len, &data);
+	res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, len, buf_len,
+			       &data);
 
 	if (scsi_status_is_good(res)) {
 		const char *types[] = {
@@ -1260,8 +1265,8 @@ static int sd_revalidate_disk(struct gen
 		sd_read_capacity(sdkp, disk->disk_name, sreq, buffer);
 		if (sdp->removable)
 			sd_read_write_protect_flag(sdkp, disk->disk_name,
-					sreq, buffer);
-		sd_read_cache_type(sdkp, disk->disk_name, sreq, buffer);
+					sreq, buffer, 512);
+		sd_read_cache_type(sdkp, disk->disk_name, sreq, buffer, 512);
 	}
 		
 	set_capacity(disk, sdkp->capacity);
diff -uprN -X /home/patman/dontdiff bl-25/drivers/scsi/sr.c modesense-bufflen-bk-2.5/drivers/scsi/sr.c
--- bl-25/drivers/scsi/sr.c	Wed Oct 22 13:30:58 2003
+++ modesense-bufflen-bk-2.5/drivers/scsi/sr.c	Mon Nov 10 15:32:16 2003
@@ -751,7 +751,7 @@ static void get_capabilities(struct scsi
 		   SRpnt->sr_sense_buffer[2] == UNIT_ATTENTION)));
 
 	/* ask for mode page 0x2a */
-	rc = scsi_mode_sense(cd->device, 0, 0x2a, buffer, 128,
+	rc = scsi_mode_sense(cd->device, 0, 0x2a, buffer, 128, 512,
 			     SR_TIMEOUT, 3, &data);
 
 	if (!scsi_status_is_good(rc)) {
diff -uprN -X /home/patman/dontdiff bl-25/include/scsi/scsi_device.h modesense-bufflen-bk-2.5/include/scsi/scsi_device.h
--- bl-25/include/scsi/scsi_device.h	Mon Oct 27 14:28:18 2003
+++ modesense-bufflen-bk-2.5/include/scsi/scsi_device.h	Mon Nov 10 15:28:43 2003
@@ -123,6 +123,6 @@ extern int scsi_track_queue_full(struct 
 extern int scsi_set_medium_removal(struct scsi_device *, char);
 
 extern int scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
-			   unsigned char *buffer, int len, int timeout,
-			   int retries, struct scsi_mode_data *data);
+			   unsigned char *buffer, int len, int buf_len,
+			   int timeout, int retries, struct scsi_mode_data *data);
 #endif /* _SCSI_SCSI_DEVICE_H */
diff -uprN -X /home/patman/dontdiff bl-25/include/scsi/scsi_request.h modesense-bufflen-bk-2.5/include/scsi/scsi_request.h
--- bl-25/include/scsi/scsi_request.h	Mon Sep 22 13:09:11 2003
+++ modesense-bufflen-bk-2.5/include/scsi/scsi_request.h	Mon Nov 10 15:26:51 2003
@@ -66,7 +66,7 @@ struct scsi_mode_data {
 
 extern int __scsi_mode_sense(struct scsi_request *SRpnt, int dbd,
 			     int modepage, unsigned char *buffer, int len,
-			     int timeout, int retries,
+			     int buf_len, int timeout, int retries,
 			     struct scsi_mode_data *data);
 
 

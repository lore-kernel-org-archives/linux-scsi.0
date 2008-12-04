From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] add residual argument to scsi_execute and scsi_execute_req
Date: Thu, 4 Dec 2008 14:24:39 +0900
Message-ID: <20081204142454J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, bharrosh@panasas.com, stern@rowland.harvard.edu
List-Id: linux-scsi@vger.kernel.org

This is against scsi-misc (and can be cleanly applied to linux-next
too).

Making bufflen argument a pointer is possible but I chose the safer
option, just adding a new argument.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] add residual argument to scsi_execute and scsi_execute_req

scsi_execute() and scsi_execute_req() discard the residual length
information. Some callers need it. This adds residual argument
(optional) to scsi_execute and scsi_execute_req.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/ata/libata-scsi.c         |    4 ++--
 drivers/scsi/ch.c                 |    2 +-
 drivers/scsi/scsi_ioctl.c         |    2 +-
 drivers/scsi/scsi_lib.c           |   17 +++++++++++------
 drivers/scsi/scsi_scan.c          |    7 ++++---
 drivers/scsi/scsi_transport_spi.c |    3 ++-
 drivers/scsi/sd.c                 |   11 ++++++-----
 drivers/scsi/ses.c                |    9 +++++----
 drivers/scsi/sr.c                 |    4 ++--
 drivers/scsi/sr_ioctl.c           |    2 +-
 include/scsi/scsi_device.h        |    5 +++--
 11 files changed, 38 insertions(+), 28 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 47c7afc..b88e443 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -517,7 +517,7 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
 	cmd_result = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
-				  sensebuf, (10*HZ), 5, 0);
+				  sensebuf, (10*HZ), 5, 0, NULL);
 
 	if (driver_byte(cmd_result) == DRIVER_SENSE) {/* sense data available */
 		u8 *desc = sensebuf + 8;
@@ -603,7 +603,7 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
 	cmd_result = scsi_execute(scsidev, scsi_cmd, DMA_NONE, NULL, 0,
-				sensebuf, (10*HZ), 5, 0);
+				sensebuf, (10*HZ), 5, 0, NULL);
 
 	if (driver_byte(cmd_result) == DRIVER_SENSE) {/* sense data available */
 		u8 *desc = sensebuf + 8;
diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 88ecf94..af97254 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -190,7 +190,7 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd,
 
         result = scsi_execute_req(ch->device, cmd, direction, buffer,
 				  buflength, &sshdr, timeout * HZ,
-				  MAX_RETRIES);
+				  MAX_RETRIES, NULL);
 
 	dprintk("result: 0x%x\n",result);
 	if (driver_byte(result) & DRIVER_SENSE) {
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 2ee49f8..2ae4f8f 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -94,7 +94,7 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 	SCSI_LOG_IOCTL(1, printk("Trying ioctl with scsi command %d\n", *cmd));
 
 	result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0,
-				  &sshdr, timeout, retries);
+				  &sshdr, timeout, retries, NULL);
 
 	SCSI_LOG_IOCTL(2, printk("Ioctl returned  0x%x\n", result));
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4236ad4..111f9e9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -183,13 +183,15 @@ int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
  * @timeout:	request timeout in seconds
  * @retries:	number of times to retry request
  * @flags:	or into request flags;
+ * @resid:	optional residual length
  *
  * returns the req->errors value which is the scsi_cmnd result
  * field.
  */
 int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 		 int data_direction, void *buffer, unsigned bufflen,
-		 unsigned char *sense, int timeout, int retries, int flags)
+		 unsigned char *sense, int timeout, int retries, int flags,
+		 int *resid)
 {
 	struct request *req;
 	int write = (data_direction == DMA_TO_DEVICE);
@@ -224,6 +226,8 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	if (unlikely(req->data_len > 0 && req->data_len <= bufflen))
 		memset(buffer + (bufflen - req->data_len), 0, req->data_len);
 
+	if (resid)
+		*resid = req->data_len;
 	ret = req->errors;
  out:
 	blk_put_request(req);
@@ -235,7 +239,8 @@ EXPORT_SYMBOL(scsi_execute);
 
 int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
 		     int data_direction, void *buffer, unsigned bufflen,
-		     struct scsi_sense_hdr *sshdr, int timeout, int retries)
+		     struct scsi_sense_hdr *sshdr, int timeout, int retries,
+		     int *resid)
 {
 	char *sense = NULL;
 	int result;
@@ -246,7 +251,7 @@ int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
 			return DRIVER_ERROR << 24;
 	}
 	result = scsi_execute(sdev, cmd, data_direction, buffer, bufflen,
-			      sense, timeout, retries, 0);
+			      sense, timeout, retries, 0, resid);
 	if (sshdr)
 		scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, sshdr);
 
@@ -2016,7 +2021,7 @@ scsi_mode_select(struct scsi_device *sdev, int pf, int sp, int modepage,
 	}
 
 	ret = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, real_buffer, len,
-			       sshdr, timeout, retries);
+			       sshdr, timeout, retries, NULL);
 	kfree(real_buffer);
 	return ret;
 }
@@ -2081,7 +2086,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	memset(buffer, 0, len);
 
 	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer, len,
-				  sshdr, timeout, retries);
+				  sshdr, timeout, retries, NULL);
 
 	/* This code looks awful: what it's doing is making sure an
 	 * ILLEGAL REQUEST sense return identifies the actual command
@@ -2163,7 +2168,7 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 	/* try to eat the UNIT_ATTENTION if there are enough retries */
 	do {
 		result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
-					  timeout, retries);
+					  timeout, retries, NULL);
 		if (sdev->removable && scsi_sense_valid(sshdr) &&
 		    sshdr->sense_key == UNIT_ATTENTION)
 			sdev->changed = 1;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 95e3ed9..a622c36 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -216,7 +216,7 @@ static void scsi_unlock_floptical(struct scsi_device *sdev,
 	scsi_cmd[4] = 0x2a;     /* size */
 	scsi_cmd[5] = 0;
 	scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE, result, 0x2a, NULL,
-			 SCSI_TIMEOUT, 3);
+			 SCSI_TIMEOUT, 3, NULL);
 }
 
 /**
@@ -581,7 +581,8 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 		result = scsi_execute_req(sdev,  scsi_cmd, DMA_FROM_DEVICE,
 					  inq_result, try_inquiry_len, &sshdr,
-					  HZ / 2 + HZ * scsi_inq_timeout, 3);
+					  HZ / 2 + HZ * scsi_inq_timeout, 3,
+					  NULL);
 
 		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: INQUIRY %s "
 				"with code 0x%x\n",
@@ -1398,7 +1399,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 
 		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
 					  lun_data, length, &sshdr,
-					  SCSI_TIMEOUT + 4 * HZ, 3);
+					  SCSI_TIMEOUT + 4 * HZ, 3, NULL);
 
 		SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: REPORT LUNS"
 				" %s (try %d) result 0x%x\n", result
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 7c2d289..96361aa 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -111,7 +111,8 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 				      sense, DV_TIMEOUT, /* retries */ 1,
 				      REQ_FAILFAST_DEV |
 				      REQ_FAILFAST_TRANSPORT |
-				      REQ_FAILFAST_DRIVER);
+				      REQ_FAILFAST_DRIVER,
+				      NULL);
 		if (result & DRIVER_SENSE) {
 			struct scsi_sense_hdr sshdr_tmp;
 			if (!sshdr)
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c9e1242..6bc3786 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -884,7 +884,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 		 * flush everything.
 		 */
 		res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
-				       SD_TIMEOUT, SD_MAX_RETRIES);
+				       SD_TIMEOUT, SD_MAX_RETRIES, NULL);
 		if (res == 0)
 			break;
 	}
@@ -1134,7 +1134,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			the_result = scsi_execute_req(sdkp->device, cmd,
 						      DMA_NONE, NULL, 0,
 						      &sshdr, SD_TIMEOUT,
-						      SD_MAX_RETRIES);
+						      SD_MAX_RETRIES, NULL);
 
 			/*
 			 * If the drive has indicated to us that it
@@ -1192,7 +1192,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 					cmd[4] |= 1 << 4;
 				scsi_execute_req(sdkp->device, cmd, DMA_NONE,
 						 NULL, 0, &sshdr,
-						 SD_TIMEOUT, SD_MAX_RETRIES);
+						 SD_TIMEOUT, SD_MAX_RETRIES,
+						 NULL);
 				spintime_expire = jiffies + 100 * HZ;
 				spintime = 1;
 			}
@@ -1306,7 +1307,7 @@ repeat:
 		
 		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
 					      buffer, longrc ? 13 : 8, &sshdr,
-					      SD_TIMEOUT, SD_MAX_RETRIES);
+					      SD_TIMEOUT, SD_MAX_RETRIES, NULL);
 
 		if (media_not_present(sdkp, &sshdr))
 			return;
@@ -1986,7 +1987,7 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 		return -ENODEV;
 
 	res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
-			       SD_TIMEOUT, SD_MAX_RETRIES);
+			       SD_TIMEOUT, SD_MAX_RETRIES, NULL);
 	if (res) {
 		sd_printk(KERN_WARNING, sdkp, "START_STOP FAILED\n");
 		sd_print_result(sdkp, res);
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 1bcf3c3..7f0df29 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -77,7 +77,7 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 	};
 
 	return scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
-				NULL, SES_TIMEOUT, SES_RETRIES);
+				NULL, SES_TIMEOUT, SES_RETRIES, NULL);
 }
 
 static int ses_send_diag(struct scsi_device *sdev, int page_code,
@@ -95,7 +95,7 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 	};
 
 	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
-				  NULL, SES_TIMEOUT, SES_RETRIES);
+				  NULL, SES_TIMEOUT, SES_RETRIES, NULL);
 	if (result)
 		sdev_printk(KERN_ERR, sdev, "SEND DIAGNOSTIC result: %8x\n",
 			    result);
@@ -369,7 +369,8 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 		return;
 
 	if (scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf,
-			     VPD_INQUIRY_SIZE, NULL, SES_TIMEOUT, SES_RETRIES))
+			     VPD_INQUIRY_SIZE, NULL, SES_TIMEOUT, SES_RETRIES,
+			     NULL))
 		goto free;
 
 	vpd_len = (buf[2] << 8) + buf[3];
@@ -380,7 +381,7 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 	cmd[3] = vpd_len >> 8;
 	cmd[4] = vpd_len & 0xff;
 	if (scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf,
-			     vpd_len, NULL, SES_TIMEOUT, SES_RETRIES))
+			     vpd_len, NULL, SES_TIMEOUT, SES_RETRIES, NULL))
 		goto free;
 
 	desc = buf + 4;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 62b6633..892afb6 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -177,7 +177,7 @@ int sr_test_unit_ready(struct scsi_device *sdev, struct scsi_sense_hdr *sshdr)
 	do {
 		the_result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL,
 					      0, sshdr, SR_TIMEOUT,
-					      retries--);
+					      retries--, NULL);
 		if (scsi_sense_valid(sshdr) &&
 		    sshdr->sense_key == UNIT_ATTENTION)
 			sdev->changed = 1;
@@ -681,7 +681,7 @@ static void get_sectorsize(struct scsi_cd *cd)
 		/* Do the command and wait.. */
 		the_result = scsi_execute_req(cd->device, cmd, DMA_FROM_DEVICE,
 					      buffer, sizeof(buffer), NULL,
-					      SR_TIMEOUT, MAX_RETRIES);
+					      SR_TIMEOUT, MAX_RETRIES, NULL);
 
 		retries--;
 
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index ae87d08..d92ff51 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -207,7 +207,7 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 	memset(sense, 0, sizeof(*sense));
 	result = scsi_execute(SDev, cgc->cmd, cgc->data_direction,
 			      cgc->buffer, cgc->buflen, (char *)sense,
-			      cgc->timeout, IOCTL_RETRIES, 0);
+			      cgc->timeout, IOCTL_RETRIES, 0, NULL);
 
 	scsi_normalize_sense((char *)sense, sizeof(*sense), &sshdr);
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 2a1c141..01a4c58 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -365,10 +365,11 @@ extern int scsi_is_target_device(const struct device *);
 extern int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 			int data_direction, void *buffer, unsigned bufflen,
 			unsigned char *sense, int timeout, int retries,
-			int flag);
+			int flag, int *resid);
 extern int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
 			    int data_direction, void *buffer, unsigned bufflen,
-			    struct scsi_sense_hdr *, int timeout, int retries);
+			    struct scsi_sense_hdr *, int timeout, int retries,
+			    int *resid);
 extern int scsi_execute_async(struct scsi_device *sdev,
 			      const unsigned char *cmd, int cmd_len, int data_direction,
 			      void *buffer, unsigned bufflen, int use_sg,
-- 
1.5.5.GIT


From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/6] scsi: merge __scsi_execute into scsi_execute
Date: Tue, 14 Feb 2017 20:15:59 +0100
Message-ID: <20170214191600.17480-6-hch@lst.de>
References: <20170214191600.17480-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170214191600.17480-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernek.dk
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

All but one caller want the decoded sense header, so offer the existing
__scsi_execute helper as the public scsi_execute API to simply the
callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/ata/libata-scsi.c         | 12 ++++------
 drivers/scsi/cxlflash/superpipe.c |  8 +++----
 drivers/scsi/cxlflash/vlun.c      |  4 ++--
 drivers/scsi/scsi_lib.c           | 48 +++++++++++++++++----------------------
 drivers/scsi/scsi_transport_spi.c | 24 ++++++++------------
 drivers/scsi/sr_ioctl.c           | 19 +++-------------
 include/scsi/scsi_device.h        |  5 ++--
 7 files changed, 46 insertions(+), 74 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index c771d4c341ea..0b1e6762c6f9 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -607,6 +607,7 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 	u8 args[4], *argbuf = NULL, *sensebuf = NULL;
 	int argsize = 0;
 	enum dma_data_direction data_dir;
+	struct scsi_sense_hdr sshdr;
 	int cmd_result;
 
 	if (arg == NULL)
@@ -655,7 +656,7 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
 	cmd_result = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
-				  sensebuf, (10*HZ), 5, 0, NULL);
+				  sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
 
 	if (driver_byte(cmd_result) == DRIVER_SENSE) {/* sense data available */
 		u8 *desc = sensebuf + 8;
@@ -664,9 +665,6 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 		/* If we set cc then ATA pass-through will cause a
 		 * check condition even if no error. Filter that. */
 		if (cmd_result & SAM_STAT_CHECK_CONDITION) {
-			struct scsi_sense_hdr sshdr;
-			scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE,
-					     &sshdr);
 			if (sshdr.sense_key == RECOVERED_ERROR &&
 			    sshdr.asc == 0 && sshdr.ascq == 0x1d)
 				cmd_result &= ~SAM_STAT_CHECK_CONDITION;
@@ -714,6 +712,7 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 	int rc = 0;
 	u8 scsi_cmd[MAX_COMMAND_SIZE];
 	u8 args[7], *sensebuf = NULL;
+	struct scsi_sense_hdr sshdr;
 	int cmd_result;
 
 	if (arg == NULL)
@@ -741,7 +740,7 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
 	cmd_result = scsi_execute(scsidev, scsi_cmd, DMA_NONE, NULL, 0,
-				sensebuf, (10*HZ), 5, 0, NULL);
+				sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
 
 	if (driver_byte(cmd_result) == DRIVER_SENSE) {/* sense data available */
 		u8 *desc = sensebuf + 8;
@@ -750,9 +749,6 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 		/* If we set cc then ATA pass-through will cause a
 		 * check condition even if no error. Filter that. */
 		if (cmd_result & SAM_STAT_CHECK_CONDITION) {
-			struct scsi_sense_hdr sshdr;
-			scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE,
-						&sshdr);
 			if (sshdr.sense_key == RECOVERED_ERROR &&
 			    sshdr.asc == 0 && sshdr.ascq == 0x1d)
 				cmd_result &= ~SAM_STAT_CHECK_CONDITION;
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 9636970d9611..005a377a427f 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -305,6 +305,7 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
 	struct device *dev = &cfg->dev->dev;
 	struct glun_info *gli = lli->parent;
+	struct scsi_sense_hdr sshdr;
 	u8 *cmd_buf = NULL;
 	u8 *scsi_cmd = NULL;
 	u8 *sense_buf = NULL;
@@ -332,7 +333,8 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 	/* Drop the ioctl read semahpore across lengthy call */
 	up_read(&cfg->ioctl_rwsem);
 	result = scsi_execute(sdev, scsi_cmd, DMA_FROM_DEVICE, cmd_buf,
-			      CMD_BUFSIZE, sense_buf, to, CMD_RETRIES, 0, NULL);
+			      CMD_BUFSIZE, sense_buf, &sshdr, to, CMD_RETRIES,
+			      0, 0, NULL);
 	down_read(&cfg->ioctl_rwsem);
 	rc = check_state(cfg);
 	if (rc) {
@@ -345,10 +347,6 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 	if (driver_byte(result) == DRIVER_SENSE) {
 		result &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
 		if (result & SAM_STAT_CHECK_CONDITION) {
-			struct scsi_sense_hdr sshdr;
-
-			scsi_normalize_sense(sense_buf, SCSI_SENSE_BUFFERSIZE,
-					    &sshdr);
 			switch (sshdr.sense_key) {
 			case NO_SENSE:
 			case RECOVERED_ERROR:
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 90c5d7f5278e..6d191db1d874 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -454,8 +454,8 @@ static int write_same16(struct scsi_device *sdev,
 		/* Drop the ioctl read semahpore across lengthy call */
 		up_read(&cfg->ioctl_rwsem);
 		result = scsi_execute(sdev, scsi_cmd, DMA_TO_DEVICE, cmd_buf,
-				      CMD_BUFSIZE, sense_buf, to, CMD_RETRIES,
-				      0, NULL);
+				      CMD_BUFSIZE, sense_buf, NULL, to,
+				      CMD_RETRIES, 0, 0, NULL);
 		down_read(&cfg->ioctl_rwsem);
 		rc = check_state(cfg);
 		if (rc) {
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 35b43a8f1bfa..a15c188c2a7f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -213,7 +213,26 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	__scsi_queue_insert(cmd, reason, 1);
 }
 
-static int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
+
+/**
+ * scsi_execute - insert request and wait for the result
+ * @sdev:	scsi device
+ * @cmd:	scsi command
+ * @data_direction: data direction
+ * @buffer:	data buffer
+ * @bufflen:	len of buffer
+ * @sense:	optional sense buffer
+ * @sshdr:	optional decoded sense header
+ * @timeout:	request timeout in seconds
+ * @retries:	number of times to retry request
+ * @flags:	flags for ->cmd_flags
+ * @rq_flags:	flags for ->rq_flags
+ * @resid:	optional residual length
+ *
+ * returns the req->errors value which is the scsi_cmnd result
+ * field.
+ */
+int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 		 int data_direction, void *buffer, unsigned bufflen,
 		 unsigned char *sense, struct scsi_sense_hdr *sshdr,
 		 int timeout, int retries, u64 flags, req_flags_t rq_flags,
@@ -268,31 +287,6 @@ static int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 
 	return ret;
 }
-
-/**
- * scsi_execute - insert request and wait for the result
- * @sdev:	scsi device
- * @cmd:	scsi command
- * @data_direction: data direction
- * @buffer:	data buffer
- * @bufflen:	len of buffer
- * @sense:	optional sense buffer
- * @timeout:	request timeout in seconds
- * @retries:	number of times to retry request
- * @flags:	or into request flags;
- * @resid:	optional residual length
- *
- * returns the req->errors value which is the scsi_cmnd result
- * field.
- */
-int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
-		 int data_direction, void *buffer, unsigned bufflen,
-		 unsigned char *sense, int timeout, int retries, u64 flags,
-		 int *resid)
-{
-	return __scsi_execute(sdev, cmd, data_direction, buffer, bufflen, sense,
-			NULL, timeout, retries, flags, 0, resid);
-}
 EXPORT_SYMBOL(scsi_execute);
 
 int scsi_execute_req_flags(struct scsi_device *sdev, const unsigned char *cmd,
@@ -300,7 +294,7 @@ int scsi_execute_req_flags(struct scsi_device *sdev, const unsigned char *cmd,
 		     struct scsi_sense_hdr *sshdr, int timeout, int retries,
 		     int *resid, u64 flags, req_flags_t rq_flags)
 {
-	return __scsi_execute(sdev, cmd, data_direction, buffer, bufflen,
+	return scsi_execute(sdev, cmd, data_direction, buffer, bufflen,
 			      NULL, sshdr, timeout, retries, flags, rq_flags,
 			      resid);
 }
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 319868f3f674..d0219e36080c 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -123,25 +123,21 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 {
 	int i, result;
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
+	struct scsi_sense_hdr sshdr_tmp;
+
+	if (!sshdr)
+		sshdr = &sshdr_tmp;
 
 	for(i = 0; i < DV_RETRIES; i++) {
-		result = scsi_execute(sdev, cmd, dir, buffer, bufflen,
-				      sense, DV_TIMEOUT, /* retries */ 1,
+		result = scsi_execute(sdev, cmd, dir, buffer, bufflen, sense,
+				      sshdr, DV_TIMEOUT, /* retries */ 1,
 				      REQ_FAILFAST_DEV |
 				      REQ_FAILFAST_TRANSPORT |
 				      REQ_FAILFAST_DRIVER,
-				      NULL);
-		if (driver_byte(result) & DRIVER_SENSE) {
-			struct scsi_sense_hdr sshdr_tmp;
-			if (!sshdr)
-				sshdr = &sshdr_tmp;
-
-			if (scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE,
-						 sshdr)
-			    && sshdr->sense_key == UNIT_ATTENTION)
-				continue;
-		}
-		break;
+				      0, NULL);
+		if (!(driver_byte(result) & DRIVER_SENSE) ||
+		    sshdr->sense_key != UNIT_ATTENTION)
+			break;
 	}
 	return result;
 }
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index dfffdf63e44c..4610c8c5693f 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -187,30 +187,19 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 	struct scsi_device *SDev;
 	struct scsi_sense_hdr sshdr;
 	int result, err = 0, retries = 0;
-	struct request_sense *sense = cgc->sense;
 
 	SDev = cd->device;
 
-	if (!sense) {
-		sense = kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
-		if (!sense) {
-			err = -ENOMEM;
-			goto out;
-		}
-	}
-
       retry:
 	if (!scsi_block_when_processing_errors(SDev)) {
 		err = -ENODEV;
 		goto out;
 	}
 
-	memset(sense, 0, sizeof(*sense));
 	result = scsi_execute(SDev, cgc->cmd, cgc->data_direction,
-			      cgc->buffer, cgc->buflen, (char *)sense,
-			      cgc->timeout, IOCTL_RETRIES, 0, NULL);
-
-	scsi_normalize_sense((char *)sense, sizeof(*sense), &sshdr);
+			      cgc->buffer, cgc->buflen,
+			      (unsigned char *)cgc->sense, &sshdr,
+			      cgc->timeout, IOCTL_RETRIES, 0, 0, NULL);
 
 	/* Minimal error checking.  Ignore cases we know about, and report the rest. */
 	if (driver_byte(result) != 0) {
@@ -261,8 +250,6 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 
 	/* Wake up a process waiting for device */
       out:
-	if (!cgc->sense)
-		kfree(sense);
 	cgc->stat = err;
 	return err;
 }
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 8990e580b278..8c8d243db32b 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -409,8 +409,9 @@ extern int scsi_is_target_device(const struct device *);
 extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
 extern int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 			int data_direction, void *buffer, unsigned bufflen,
-			unsigned char *sense, int timeout, int retries,
-			u64 flags, int *resid);
+			unsigned char *sense, struct scsi_sense_hdr *sshdr,
+			int timeout, int retries, u64 flags,
+			req_flags_t rq_flags, int *resid);
 extern int scsi_execute_req_flags(struct scsi_device *sdev,
 	const unsigned char *cmd, int data_direction, void *buffer,
 	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
-- 
2.11.0

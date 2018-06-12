From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 2/3] scsi: check for equality of result byte values
Date: Tue, 12 Jun 2018 15:53:10 +0200
Message-ID: <20180612135311.13216-3-jthumshirn@suse.de>
References: <20180612135311.13216-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180612135311.13216-1-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

When evaluating a SCSI command's result using the field access macros,
check for equality of the fields and not if a specific bit is set.

This is a preparation patch, for reworking the results field in the
SCSI command.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/ch.c                 |  2 +-
 drivers/scsi/dc395x.c             |  2 +-
 drivers/scsi/scsi.c               |  2 +-
 drivers/scsi/scsi_ioctl.c         |  2 +-
 drivers/scsi/scsi_lib.c           |  4 ++--
 drivers/scsi/scsi_scan.c          |  2 +-
 drivers/scsi/scsi_transport_spi.c |  2 +-
 drivers/scsi/sd.c                 | 12 ++++++------
 drivers/scsi/ufs/ufshcd.c         |  2 +-
 9 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index c535c52e72e5..1c5051b1c125 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -199,7 +199,7 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 				  buflength, &sshdr, timeout * HZ,
 				  MAX_RETRIES, NULL);
 
-	if (driver_byte(result) & DRIVER_SENSE) {
+	if (driver_byte(result) == DRIVER_SENSE) {
 		if (debug)
 			scsi_print_sense_hdr(ch->device, ch->name, &sshdr);
 		errno = ch_find_errno(&sshdr);
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 60ef8df42b95..7eb930b39955 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3474,7 +3474,7 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 	/*if( srb->cmd->cmnd[0] == INQUIRY && */
 	/*  (host_byte(cmd->result) == DID_OK || status_byte(cmd->result) & CHECK_CONDITION) ) */
 		if ((cmd->result == (DID_OK << 16)
-		     || status_byte(cmd->result) &
+		     || status_byte(cmd->result) ==
 		     CHECK_CONDITION)) {
 			if (!dcb->init_tcq_flag) {
 				add_dev(acb, dcb, ptr);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 4c60c260c5da..70ef3c39061d 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -162,7 +162,7 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 		    (level > 1)) {
 			scsi_print_result(cmd, "Done", disposition);
 			scsi_print_command(cmd);
-			if (status_byte(cmd->result) & CHECK_CONDITION)
+			if (status_byte(cmd->result) == CHECK_CONDITION)
 				scsi_print_sense(cmd);
 			if (level > 3)
 				scmd_printk(KERN_INFO, cmd,
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 0a875491f5a7..134a89a5cbca 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -100,7 +100,7 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 	SCSI_LOG_IOCTL(2, sdev_printk(KERN_INFO, sdev,
 				      "Ioctl returned  0x%x\n", result));
 
-	if ((driver_byte(result) & DRIVER_SENSE) &&
+	if ((driver_byte(result) == DRIVER_SENSE) &&
 	    (scsi_sense_valid(&sshdr))) {
 		switch (sshdr.sense_key) {
 		case ILLEGAL_REQUEST:
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 41e9ac9fc138..e989579b3d63 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1031,7 +1031,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			 */
 			if (!level && __ratelimit(&_rs)) {
 				scsi_print_result(cmd, NULL, FAILED);
-				if (driver_byte(result) & DRIVER_SENSE)
+				if (driver_byte(result) == DRIVER_SENSE)
 					scsi_print_sense(cmd);
 				scsi_print_command(cmd);
 			}
@@ -2555,7 +2555,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	 * ILLEGAL REQUEST if the code page isn't supported */
 
 	if (use_10_for_ms && !scsi_status_is_good(result) &&
-	    (driver_byte(result) & DRIVER_SENSE)) {
+	    (driver_byte(result) == DRIVER_SENSE)) {
 		if (scsi_sense_valid(sshdr)) {
 			if ((sshdr->sense_key == ILLEGAL_REQUEST) &&
 			    (sshdr->asc == 0x20) && (sshdr->ascq == 0)) {
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 0880d975eed3..482c51c4f8c4 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -614,7 +614,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			 * INQUIRY should not yield UNIT_ATTENTION
 			 * but many buggy devices do so anyway. 
 			 */
-			if ((driver_byte(result) & DRIVER_SENSE) &&
+			if ((driver_byte(result) == DRIVER_SENSE) &&
 			    scsi_sense_valid(&sshdr)) {
 				if ((sshdr.sense_key == UNIT_ATTENTION) &&
 				    ((sshdr.asc == 0x28) ||
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 2ca150b16764..4d1b4719e0d7 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -136,7 +136,7 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 				      REQ_FAILFAST_TRANSPORT |
 				      REQ_FAILFAST_DRIVER,
 				      0, NULL);
-		if (!(driver_byte(result) & DRIVER_SENSE) ||
+		if (!(driver_byte(result) == DRIVER_SENSE) ||
 		    sshdr->sense_key != UNIT_ATTENTION)
 			break;
 	}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9421d9877730..9245637a3082 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1635,7 +1635,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 	if (res) {
 		sd_print_result(sdkp, "Synchronize Cache(10) failed", res);
 
-		if (driver_byte(res) & DRIVER_SENSE)
+		if (driver_byte(res) == DRIVER_SENSE)
 			sd_print_sense_hdr(sdkp, sshdr);
 
 		/* we need to evaluate the error return  */
@@ -1737,7 +1737,7 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, &data, sizeof(data),
 			&sshdr, SD_TIMEOUT, SD_MAX_RETRIES, NULL);
 
-	if ((driver_byte(result) & DRIVER_SENSE) &&
+	if ((driver_byte(result) == DRIVER_SENSE) &&
 	    (scsi_sense_valid(&sshdr))) {
 		sdev_printk(KERN_INFO, sdev, "PR command failed: %d\n", result);
 		scsi_print_sense_hdr(sdev, NULL, &sshdr);
@@ -2095,10 +2095,10 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			retries++;
 		} while (retries < 3 && 
 			 (!scsi_status_is_good(the_result) ||
-			  ((driver_byte(the_result) & DRIVER_SENSE) &&
+			  ((driver_byte(the_result) == DRIVER_SENSE) &&
 			  sense_valid && sshdr.sense_key == UNIT_ATTENTION)));
 
-		if ((driver_byte(the_result) & DRIVER_SENSE) == 0) {
+		if ((driver_byte(the_result) == DRIVER_SENSE) == 0) {
 			/* no sense, TUR either succeeded or failed
 			 * with a status error */
 			if(!spintime && !scsi_status_is_good(the_result)) {
@@ -2224,7 +2224,7 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 			struct scsi_sense_hdr *sshdr, int sense_valid,
 			int the_result)
 {
-	if (driver_byte(the_result) & DRIVER_SENSE)
+	if (driver_byte(the_result) == DRIVER_SENSE)
 		sd_print_sense_hdr(sdkp, sshdr);
 	else
 		sd_printk(KERN_NOTICE, sdkp, "Sense not available.\n");
@@ -3490,7 +3490,7 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 			SD_TIMEOUT, SD_MAX_RETRIES, 0, RQF_PM, NULL);
 	if (res) {
 		sd_print_result(sdkp, "Start/Stop Unit failed", res);
-		if (driver_byte(res) & DRIVER_SENSE)
+		if (driver_byte(res) == DRIVER_SENSE)
 			sd_print_sense_hdr(sdkp, &sshdr);
 		if (scsi_sense_valid(&sshdr) &&
 			/* 0x3a is medium not present */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3a811c5f70ba..6b6fafae4071 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7290,7 +7290,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 		sdev_printk(KERN_WARNING, sdp,
 			    "START_STOP failed for power mode: %d, result %x\n",
 			    pwr_mode, ret);
-		if (driver_byte(ret) & DRIVER_SENSE)
+		if (driver_byte(ret) == DRIVER_SENSE)
 			scsi_print_sense_hdr(sdp, NULL, &sshdr);
 	}
 
-- 
2.16.4

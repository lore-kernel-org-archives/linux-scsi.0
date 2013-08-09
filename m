From: "Brandt, Todd E" <todd.e.brandt@intel.com>
Subject: [PATCH v2] Hard disk S3 resume time optimization
Date: Fri, 9 Aug 2013 01:09:03 +0000
Message-ID: <11E08D716F0541429B7042699DD5C1A170680F5C@FMSMSX103.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Oliver Neukum <oneukum@suse.de>, Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Stern <stern@rowland.harvard.edu>
List-Id: linux-scsi@vger.kernel.org

This patch essentially removes the disk spinup wait time from the system S3 resume delay. It can be a very significant improvement on systems with large SATA disks which can take several seconds to spin up. On the systems I've tested this patch reduces the resume time to around half a second (assuming no USB devices are consuming that time). Without the patch my systems require anywhere from 5 to 12 seconds to wakeup from S3 resume depending on the size of the disks attached.

This is a rewrite of my first attempt to optimize S3 disk resume time: http://marc.info/?l=linux-ide&m=136874337908364&w=2 . It's vastly simpler in that it doesn't make any alterations at all to the pm subsystem to allow non-blocking resume, it simply enables the ata_port and scsi_disk drivers to do their work in a non-blocking way.

Made some alterations to the first draft of the patch, this is v2.

1) Added scsi cmd error reporting in response to Oliver's comments. The sd_resume_async_end function now prints out the same error information that was printed in the sd_start_stop_device call; including the sense buffer contents. I didn't add any additional error messages for the ata port wakeup since, if the port wakeup fails, the error data is printed out by the error handler process itself, so it doesn't require the ata_port_resume call to check up on it after the failure. The only potential issue is that the ata_port_resume_async call sets the ata port device to RPM_ACTIVE even if the ata_eh_handle_port_resume call fails, but there doesn't appear to be any code which actually calls pm_runtime_set_suspended for ata_ports at the moment, so the ata_port appears to always be set to RPM_AC
 TIVE anyway (please correct me if I'm wrong). 
2) I created a new ata_port_resume_async function just for the "resume" callback so that it wouldn't affect the thaw, restore, or runtime resume callback behaviour (just to be on the safe side). 
3) I also moved the scsi_disk_put call up into the sd_resume_async_end callback since the reference counter shouldn't be decremented until the disk is actually finished starting.

Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>

 drivers/ata/libata-core.c | 19 +++++++++++++++++-
 drivers/scsi/sd.c         | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c24354d..842004c 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -118,6 +118,7 @@ struct ata_force_ent {
 
 static struct ata_force_ent *ata_force_tbl;
 static int ata_force_tbl_size;
+int ata_resume_status;
 
 static char ata_force_param_buf[PAGE_SIZE] __initdata;
 /* param_buf is thrown away after initialization, disallow read */
@@ -5415,6 +5416,22 @@ static int ata_port_resume(struct device *dev)
 	return rc;
 }
 
+static int ata_port_resume_async(struct device *dev)
+{
+	struct ata_port *ap = to_ata_port(dev);
+
+	ata_resume_status = 0;
+	ata_port_request_pm(ap, PMSG_RESUME, ATA_EH_RESET,
+		ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, &ata_resume_status);
+	if (!ata_resume_status) {
+		pm_runtime_disable(dev);
+		pm_runtime_set_active(dev);
+		pm_runtime_enable(dev);
+	}
+
+	return ata_resume_status;
+}
+
 /*
  * For ODDs, the upper layer will poll for media change every few seconds,
  * which will make it enter and leave suspend state every few seconds. And
@@ -5451,7 +5468,7 @@ static int ata_port_runtime_resume(struct device *dev)
 
 static const struct dev_pm_ops ata_port_pm_ops = {
 	.suspend = ata_port_suspend,
-	.resume = ata_port_resume,
+	.resume = ata_port_resume_async,
 	.freeze = ata_port_do_freeze,
 	.thaw = ata_port_resume,
 	.poweroff = ata_port_poweroff,
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 86fcf2c..f5a9800 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -107,6 +107,7 @@ static int  sd_remove(struct device *);
 static void sd_shutdown(struct device *);
 static int sd_suspend(struct device *);
 static int sd_resume(struct device *);
+static int sd_resume_async(struct device *);
 static void sd_rescan(struct device *);
 static int sd_done(struct scsi_cmnd *);
 static int sd_eh_action(struct scsi_cmnd *, unsigned char *, int, int);
@@ -484,7 +485,7 @@ static struct class sd_disk_class = {
 
 static const struct dev_pm_ops sd_pm_ops = {
 	.suspend		= sd_suspend,
-	.resume			= sd_resume,
+	.resume			= sd_resume_async,
 	.poweroff		= sd_suspend,
 	.restore		= sd_resume,
 	.runtime_suspend	= sd_suspend,
@@ -3137,6 +3138,81 @@ done:
 	return ret;
 }
 
+static void sd_resume_async_end(struct request *rq, int error)
+{
+	struct scsi_sense_hdr sshdr;
+	struct scsi_disk *sdkp = rq->end_io_data;
+	char *sense = rq->sense;
+
+	if (error) {
+		sd_printk(KERN_WARNING, sdkp, "START FAILED\n");
+		sd_print_result(sdkp, error);
+		if (sense && (driver_byte(error) & DRIVER_SENSE)) {
+			scsi_normalize_sense(sense,
+				SCSI_SENSE_BUFFERSIZE, &sshdr);
+			sd_print_sense_hdr(sdkp, &sshdr);
+		}
+	} else
+		sd_printk(KERN_NOTICE, sdkp, "START SUCCESS\n");
+
+	kfree(sense);
+	rq->sense = NULL;
+	rq->end_io_data = NULL;
+	__blk_put_request(rq->q, rq);
+	scsi_disk_put(sdkp);
+}
+
+static int sd_resume_async(struct device *dev)
+{
+	unsigned char cmd[6] = { START_STOP };
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	struct request *req;
+	char *sense = NULL;
+
+	if (!sdkp->device->manage_start_stop) {
+		scsi_disk_put(sdkp);
+		return 0;
+	}
+
+	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
+
+	cmd[4] |= 1;
+
+	if (sdkp->device->start_stop_pwr_cond)
+		cmd[4] |= 1 << 4;	/* Active or Standby */
+
+	if (!scsi_device_online(sdkp->device)) {
+		scsi_disk_put(sdkp);
+		return -ENODEV;
+	}
+
+	req = blk_get_request(sdkp->device->request_queue, 0, __GFP_WAIT);
+	if (!req) {
+		scsi_disk_put(sdkp);
+		return DRIVER_ERROR << 24;
+	}
+
+	sense = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_NOIO);
+	if (!sense) {
+		__blk_put_request(req->q, req);
+		scsi_disk_put(sdkp);
+		return DRIVER_ERROR << 24;
+	}
+
+	req->cmd_len = COMMAND_SIZE(cmd[0]);
+	memcpy(req->cmd, cmd, req->cmd_len);
+	req->sense = sense;
+	req->sense_len = 0;
+	req->retries = SD_MAX_RETRIES;
+	req->timeout = SD_TIMEOUT;
+	req->cmd_type = REQ_TYPE_BLOCK_PC;
+	req->cmd_flags |= REQ_PM | REQ_QUIET | REQ_PREEMPT;
+
+	req->end_io_data = sdkp;
+	blk_execute_rq_nowait(req->q, NULL, req, 1, sd_resume_async_end);
+	return 0;
+}
+
 /**
  *	init_sd - entry point for this driver (both when built in or when
  *	a module).


Todd Brandt
Linux Kernel Developer OTC, Hillsboro OR

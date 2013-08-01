From: "Brandt, Todd E" <todd.e.brandt@intel.com>
Subject: [PATCH] Hard disk S3 resume time optimization
Date: Thu, 1 Aug 2013 23:40:03 +0000
Message-ID: <11E08D716F0541429B7042699DD5C1A1706803A6@FMSMSX103.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch is a potential way to reduce the S3 resume time for SATA drives. Essentially this patch removes the hard disk resume time from the total system resume time, with the disks still taking as long to come back online but in the background.

The major bottleneck is in the ata port resume which sends out a wakeup command and then waits up to several seconds for the port to resume. This patch changes the ata_port_resume_common function to be non blocking. The other bottleneck is in the scsi disk resume code, which issues a a command to startup the disk with blk_execute_rq, which then waits for the command to finish (which also depends on the ata port being fully resumed). The patch switches the sd_resume function to use blk_execute_rq_nowait instead (the underlying code is identical to sd_resume, but is changed to non-blocking).

Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
---
 drivers/ata/libata-core.c |  4 +++-
 drivers/scsi/sd.c         | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c24354d..3585092 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -118,6 +118,7 @@ struct ata_force_ent {
 
 static struct ata_force_ent *ata_force_tbl;
 static int ata_force_tbl_size;
+int ata_resume_status;
 
 static char ata_force_param_buf[PAGE_SIZE] __initdata;
 /* param_buf is thrown away after initialization, disallow read */
@@ -5398,7 +5399,8 @@ static int ata_port_resume_common(struct device *dev, pm_message_t mesg)
 {
 	struct ata_port *ap = to_ata_port(dev);
 
-	return __ata_port_resume_common(ap, mesg, NULL);
+	ata_resume_status = 0;
+	return __ata_port_resume_common(ap, mesg, &ata_resume_status);
 }
 
 static int ata_port_resume(struct device *dev)
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 86fcf2c..ee4d7e2 100644
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
@@ -3137,6 +3138,60 @@ done:
 	return ret;
 }
 
+static void sd_resume_async_end(struct request *rq, int error)
+{
+	struct scsi_disk *sdkp = rq->end_io_data;
+
+	sd_printk(KERN_NOTICE, sdkp, "Starting disk complete (async)\n");
+	rq->end_io_data = NULL;
+	__blk_put_request(rq->q, rq);
+}
+
+static int sd_resume_async(struct device *dev)
+{
+	unsigned char cmd[6] = { START_STOP };	/* START_VALID */
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	struct request *req;
+	int ret = 0;
+
+	if (!sdkp->device->manage_start_stop)
+		goto done;
+
+	sd_printk(KERN_NOTICE, sdkp, "Starting disk (async)\n");
+
+	cmd[4] |= 1;	/* START */
+
+	if (sdkp->device->start_stop_pwr_cond)
+		cmd[4] |= 1 << 4;	/* Active or Standby */
+
+	if (!scsi_device_online(sdkp->device)) {
+		ret = -ENODEV;
+		goto done;
+	}
+
+	req = blk_get_request(sdkp->device->request_queue, 0, __GFP_WAIT);
+	if (!req) {
+		ret = DRIVER_ERROR << 24;
+		goto done;
+	}
+
+	req->cmd_len = COMMAND_SIZE(cmd[0]);
+	memcpy(req->cmd, cmd, req->cmd_len);
+	req->sense = NULL;
+	req->sense_len = 0;
+	req->retries = SD_MAX_RETRIES;
+	req->timeout = SD_TIMEOUT;
+	req->cmd_type = REQ_TYPE_BLOCK_PC;
+	req->cmd_flags |= REQ_PM | REQ_QUIET | REQ_PREEMPT;
+
+	req->end_io_data = sdkp;
+	blk_execute_rq_nowait(req->q, NULL, req, 1, sd_resume_async_end);
+
+done:
+	scsi_disk_put(sdkp);
+	return ret;
+}
+
 /**
  *	init_sd - entry point for this driver (both when built in or when
  *	a module).



Todd Brandt
Linux Kernel Developer OTC, Hillsboro OR

From: "Brandt, Todd E" <todd.e.brandt@intel.com>
Subject: [PATCH v3 2/2] Hard disk S3 resume time optimization
Date: Tue, 27 Aug 2013 14:41:08 +0000
Message-ID: <11E08D716F0541429B7042699DD5C1A1706A8339@FMSMSX103.amr.corp.intel.com>
References: <20130823223535.GB11706@todd.e.brandt@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20130823223535.GB11706@todd.e.brandt@intel.com>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is v3 of the non-blocking S3 resume patch. It's been broken into
two pieces, this part is for the scsi subsystem. I've addressed Alan 
Stern's comments in particular by reformatting the call to conform
to the proper style guidelines.

Note - the two patches will function separately but both are required 
to achieve a performance improvement.


Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>

 drivers/scsi/sd.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 81 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 86fcf2c..d4bf784 100644
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
@@ -3137,6 +3138,85 @@ done:
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
+	int ret = 0;
+
+	if (!sdkp->device->manage_start_stop)
+		goto error;
+
+	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
+
+	cmd[4] |= 1;
+
+	if (sdkp->device->start_stop_pwr_cond)
+		cmd[4] |= 1 << 4;	/* Active or Standby */
+
+	if (!scsi_device_online(sdkp->device)) {
+		ret = -ENODEV;
+		goto error;
+	}
+
+	req = blk_get_request(sdkp->device->request_queue, 0, __GFP_WAIT);
+	if (!req) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	sense = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_NOIO);
+	if (!sense) {
+		ret = -ENOMEM;
+		goto error_sense;
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
+
+ error_sense:
+	__blk_put_request(req->q, req);
+ error:
+	scsi_disk_put(sdkp);
+	return ret;
+}
+
 /**
  *	init_sd - entry point for this driver (both when built in or when
  *	a module).



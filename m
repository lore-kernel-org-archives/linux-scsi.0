From: Todd E Brandt <todd.e.brandt@linux.intel.com>
Subject: [PATCH/RESEND v2 2/2] Hard disk resume time optimization,
 asynchronous sd_resume
Date: Tue, 3 Dec 2013 08:28:58 -0800
Message-ID: <20131203162858.GC12554@linux.intel.com>
Reply-To: todd.e.brandt@linux.intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, tj@kernel.org
List-Id: linux-scsi@vger.kernel.org

On resume, the SD driver currently waits until the block driver finishes 
executing a disk start command with blk_execute_rq. This patch changes the 
sd_resume callback to use blk_execute_rq_nowait instead, which allows it to 
return immediately, thus allowing the next device in the pm queue to resume. 
The return value of blk_execute_rq_nowait is handled in the background by 
sd_resume_complete. Any commands issued to the scsi disk during the startup 
will be queued up and executed once the disk is online. Thus no information 
is lost, and although the wait time itself isn't removed, it doesn't hold up 
the rest of the system.

In combination with the ata_port_resume patch, this patch greatly reduces S3 
system resume time on systems with SATA drives. This is accomplished by 
removing the drive spinup time from the system resume delay. Applying these 
two patches allows SATA disks to resume asynchronously without holding up 
system resume; thus allowing the UI to come online sooner. There may be a 
short period after resume where the disks are still spinning up in the 
background, but the user shouldn't notice since the OS can function with the 
data left in RAM.

This patch applies to all three resume callbacks: resume, restore, and 
runtime-resume. There is only a performance benefit for resume, but for 
simplicity both restore and runtime-resume use the same code path.

Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

 drivers/scsi/sd.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 67 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e6c4bff..eed8ea2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3166,18 +3166,82 @@ static int sd_suspend_runtime(struct device *dev)
 	return sd_suspend_common(dev, false);
 }
 
+static void sd_resume_complete(struct request *rq, int error)
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
+	} else {
+		sd_printk(KERN_NOTICE, sdkp, "START SUCCESS\n");
+	}
+
+	kfree(sense);
+	rq->sense = NULL;
+	rq->end_io_data = NULL;
+	__blk_put_request(rq->q, rq);
+	scsi_disk_put(sdkp);
+}
+
 static int sd_resume(struct device *dev)
 {
+	unsigned char cmd[6] = { START_STOP };
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	struct request *req;
+	char *sense = NULL;
 	int ret = 0;
 
 	if (!sdkp->device->manage_start_stop)
-		goto done;
+		goto error;
 
 	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
-	ret = sd_start_stop_device(sdkp, 1);
 
-done:
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
+	blk_execute_rq_nowait(req->q, NULL, req, 1, sd_resume_complete);
+	return 0;
+
+ error_sense:
+	__blk_put_request(req->q, req);
+ error:
 	scsi_disk_put(sdkp);
 	return ret;
 }



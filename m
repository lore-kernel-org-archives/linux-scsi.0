From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2/3] sd: implement START/STOP management
Date: Tue, 20 Mar 2007 12:26:03 -0500
Message-ID: <1174411563.3522.22.camel@mulgrave.il.steeleye.com>
References: <20070320150718.GF6152@htj.dyndns.org>
	 <20070320151359.GG6152@htj.dyndns.org>
	 <1174409899.3522.16.camel@mulgrave.il.steeleye.com>
	 <460014FB.1050703@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <460014FB.1050703@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, djwong@us.ibm.com, hmh@hmh.eng.br
List-Id: linux-scsi@vger.kernel.org

On Wed, 2007-03-21 at 02:08 +0900, Tejun Heo wrote:
> I got too comfortable with libata-dev#upstream and forgot to verify
> patches against scsi-misc-2.6.  Sorry about that.  If you don't have
> objection against the content, I'll resubmit the SCSI part against
> scsi-misc-2.6.  Once it's in scsi-misc-2.6, we can pull it into
> libata-dev#upstream and do the libata part there.  As the SCSI change
> doesn't break libata, they can be done separately.

I should already have it in scsi-misc-2.6 ... you could verify I got the
merge right ...

There'll be an additional piece to put the new sd_printk helpers into
the routines, which I attach below.

James

---
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 49a94ae..b044dcf 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1733,10 +1733,11 @@ static void scsi_disk_release(struct class_device *cdev)
 	kfree(sdkp);
 }
 
-static int sd_start_stop_device(struct scsi_device *sdp, int start)
+static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 {
 	unsigned char cmd[6] = { START_STOP };	/* START_VALID */
 	struct scsi_sense_hdr sshdr;
+	struct scsi_device *sdp = sdkp->device;
 	int res;
 
 	if (start)
@@ -1748,12 +1749,10 @@ static int sd_start_stop_device(struct scsi_device *sdp, int start)
 	res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
 			       SD_TIMEOUT, SD_MAX_RETRIES);
 	if (res) {
-		printk(KERN_WARNING "FAILED\n  status = %x, message = %02x, "
-		       "host = %d, driver = %02x\n  ",
-		       status_byte(res), msg_byte(res),
-		       host_byte(res), driver_byte(res));
+		sd_printk(KERN_WARNING, sdkp, "START_STOP FAILED\n");
+		sd_print_result(sdkp, res);
 		if (driver_byte(res) & DRIVER_SENSE)
-			scsi_print_sense_hdr("sd", &sshdr);
+			sd_print_sense_hdr(sdkp, &sshdr);
 	}
 
 	return res;
@@ -1766,7 +1765,6 @@ static int sd_start_stop_device(struct scsi_device *sdp, int start)
  */
 static void sd_shutdown(struct device *dev)
 {
-	struct scsi_device *sdp = to_scsi_device(dev);
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
 
 	if (!sdkp)
@@ -1777,10 +1775,9 @@ static void sd_shutdown(struct device *dev)
 		sd_sync_cache(sdkp);
 	}
 
-	if (system_state != SYSTEM_RESTART && sdp->manage_start_stop) {
-		printk(KERN_NOTICE "Stopping disk %s: \n",
-		       sdkp->disk->disk_name);
-		sd_start_stop_device(sdp, 0);
+	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
+		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
+		sd_start_stop_device(sdkp, 0);
 	}
 
 	scsi_disk_put(sdkp);
@@ -1788,7 +1785,6 @@ static void sd_shutdown(struct device *dev)
 
 static int sd_suspend(struct device *dev, pm_message_t mesg)
 {
-	struct scsi_device *sdp = to_scsi_device(dev);
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
 	int ret;
 
@@ -1796,17 +1792,16 @@ static int sd_suspend(struct device *dev, pm_message_t mesg)
 		return 0;	/* this can happen */
 
 	if (sdkp->WCE) {
-		printk(KERN_NOTICE "Synchronizing SCSI cache for disk %s: \n",
-				sdkp->disk->disk_name);
+		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
 		ret = sd_sync_cache(sdkp);
 		if (ret)
 			return ret;
 	}
 
-	if (mesg.event == PM_EVENT_SUSPEND && sdp->manage_start_stop) {
-		printk(KERN_NOTICE "Stopping disk %s: \n",
-		       sdkp->disk->disk_name);
-		ret = sd_start_stop_device(sdp, 0);
+	if (mesg.event == PM_EVENT_SUSPEND &&
+	    sdkp->device->manage_start_stop) {
+		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
+		ret = sd_start_stop_device(sdkp, 0);
 		if (ret)
 			return ret;
 	}
@@ -1816,15 +1811,14 @@ static int sd_suspend(struct device *dev, pm_message_t mesg)
 
 static int sd_resume(struct device *dev)
 {
-	struct scsi_device *sdp = to_scsi_device(dev);
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
 
-	if (!sdp->manage_start_stop)
+	if (!sdkp->device->manage_start_stop)
 		return 0;
 
-	printk(KERN_NOTICE "Starting disk %s: \n", sdkp->disk->disk_name);
+	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
 
-	return sd_start_stop_device(sdp, 1);
+	return sd_start_stop_device(sdkp, 1);
 }
 
 /**



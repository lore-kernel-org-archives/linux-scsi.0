From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH RFC] sd: spin down disks on removal or power-down
Date: Sun, 28 Jan 2007 19:47:27 -0600
Message-ID: <45BD522F.3070706@shaw.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=------------010202060101020305060103
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010202060101020305060103
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Here's a patch for sd.c I've cooked up which issues a START STOP UNIT
command to stop the drive when the SCSI disk is removed or the machine
is powered down. The rationale behind this is that apparently on many
drives, simply cutting power to the spinning disk forces it to do an
emergency head park/unload which creates more wear on the drive then a
controlled park/unload with power still applied. This change ensures
that the drive will be spun down if the user shuts down the machine or
if they are about to hot-unplug the drive and have done "scsiadd -r" first.

The main potential concern I have about this implementation is that if
the drive is used in a multi-initiator, iSCSI, etc. environment,
stopping the drive may be undesirable as another initiator may still be
accessing it. I'm not familiar enough with these setups to know if this
problem is likely to come up or not. For this and other reasons we may
want to make this behavior controllable - I'm open to suggestions on how
to do this or whether it's needed.

I've tested that this does work on SATA disks through libata (with my
patch "libata: fix translation for START STOP UNIT" applied). I also
tested with some external USB-to-IDE drive enclosures. The support for
START STOP UNIT on those seems rather poor though, on one enclosure with
a Genesys bridge chip it returned a check condition with "Invalid field
in CDB", and on another with a JMicron chip the request succeeded but it
didn't actually spin the drive down.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/





--------------010202060101020305060103
Content-Type: text/plain;
 name="sd-stop-unit-on-shutdown.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sd-stop-unit-on-shutdown.patch"

--- linux-2.6.20-rc6nv/drivers/scsi/sd.c	2007-01-28 17:00:00.000000000 -0600
+++ linux-2.6.20-rc6nvedit/drivers/scsi/sd.c	2007-01-28 18:08:53.000000000 -0600
@@ -821,6 +821,39 @@ static int sd_sync_cache(struct scsi_dev
 	return res;
 }
 
+static int sd_stop_unit(struct scsi_device *sdp, struct scsi_disk* sdkp)
+{
+	int res;
+	struct scsi_sense_hdr sshdr;
+	unsigned char cmd[10] = { 0 };
+
+	if (!scsi_device_online(sdp))
+		return -ENODEV;
+
+	cmd[0] = START_STOP;
+	/*
+	 * Leave the rest of the command zero to indicate
+	 * transition to stopped power condition and return
+	 * on completion.
+	 */
+	printk(KERN_NOTICE "Stopping SCSI disk %s\n",
+		sdkp->disk->disk_name);
+	res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
+			       SD_TIMEOUT, SD_MAX_RETRIES);
+
+	if (res) {
+		printk(KERN_WARNING "sd stop failed: status = %x, message = %02x, "
+				    "host = %d, driver = %02x\n",
+				    status_byte(res), msg_byte(res),
+				    host_byte(res), driver_byte(res));
+		if (driver_byte(res) & DRIVER_SENSE)
+			scsi_print_sense_hdr("sd", &sshdr);
+	}
+	
+	return res;
+}
+
+
 static int sd_issue_flush(struct device *dev, sector_t *error_sector)
 {
 	int ret = 0;
@@ -1727,11 +1760,13 @@ static int sd_probe(struct device *dev)
  **/
 static int sd_remove(struct device *dev)
 {
+	struct scsi_device *sdp = to_scsi_device(dev);
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
 	class_device_del(&sdkp->cdev);
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
+	sd_stop_unit(sdp,sdkp);
 
 	mutex_lock(&sd_ref_mutex);
 	dev_set_drvdata(dev, NULL);
@@ -1784,6 +1819,9 @@ static void sd_shutdown(struct device *d
 				sdkp->disk->disk_name);
 		sd_sync_cache(sdp);
 	}
+	if(system_state == SYSTEM_POWER_OFF)
+		sd_stop_unit(sdp,sdkp);
+		
 	scsi_disk_put(sdkp);
 }
 



--------------010202060101020305060103--


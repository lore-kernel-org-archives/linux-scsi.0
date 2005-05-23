From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Mon, 23 May 2005 17:10:06 -0500
Message-ID: <1116886206.5021.42.camel@mulgrave>
References: <20050523201535.GA24298@havoc.gtf.org>
	 <1116880875.5021.34.camel@mulgrave>  <20050523204516.GA28058@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20050523204516.GA28058@havoc.gtf.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org, Jens Axboe <axboe@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2005-05-23 at 16:45 -0400, Jeff Garzik wrote:
> On Mon, May 23, 2005 at 03:41:15PM -0500, James Bottomley wrote:
> > The thread petered out before a resolution, however, I think
> > at least disk devices should be doing a synchronize cache on suspend.
> 
> Agreed.

OK, try this as a straw horse.  It plumbs our scsi bus model into
suspend and resume via the driver (which would be the ULD) function.
The only ULD which has an extra function is sd, and all it does is
synchronize the cache if it was writeback.  I believe you translate SYNC
CACHE in libata, so this patch should be sufficient (unless we still
have a problem with ATA devices that lie about their cache types?)

I think this is sufficient, because if the LLD also wants this
information, it can get it from the model of the bus it's attached to.

James

--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -199,10 +200,37 @@ static int scsi_bus_match(struct device 
 	return (sdp->inq_periph_qual == SCSI_INQ_PQ_CON)? 1: 0;
 }
 
+static int scsi_bus_suspend(struct device *dev, pm_message_t state)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int err = scsi_device_quiesce(sdev);
+
+	if (err)
+		return err;
+
+	if(dev->driver && dev->driver->suspend)
+		return dev->driver->suspend(dev, state, 0);
+	return 0;
+}
+
+static int scsi_bus_resume(struct device *dev)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int err = 0;
+
+	if(dev->driver && dev->driver->resume)
+		err = dev->driver->resume(dev, 0);
+
+	scsi_device_resume(sdev);
+	return err;
+}
+
 struct bus_type scsi_bus_type = {
         .name		= "scsi",
         .match		= scsi_bus_match,
+	.suspend	= scsi_bus_suspend,
+	.resume		= scsi_bus_resume
 };
 
 int scsi_sysfs_register(void)
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -119,6 +119,7 @@ static void sd_rw_intr(struct scsi_cmnd 
 static int sd_probe(struct device *);
 static int sd_remove(struct device *);
 static void sd_shutdown(struct device *dev);
+static int sd_suspend(struct device *dev, pm_message_t state, u32 level);
 static void sd_rescan(struct device *);
 static int sd_init_command(struct scsi_cmnd *);
 static int sd_issue_flush(struct device *, sector_t *);
@@ -134,6 +135,7 @@ static struct scsi_driver sd_template = 
 		.probe		= sd_probe,
 		.remove		= sd_remove,
 		.shutdown	= sd_shutdown,
+		.suspend	= sd_suspend,
 	},
 	.rescan			= sd_rescan,
 	.init_command		= sd_init_command,
@@ -1710,7 +1712,28 @@ static void sd_shutdown(struct device *d
 	printk(KERN_NOTICE "Synchronizing SCSI cache for disk %s: \n",
 			sdkp->disk->disk_name);
 	sd_sync_cache(sdp);
-}	
+}
+
+/* Just quietly quiesce the device and SYNCHRONIZE CACHE for suspend too */
+static int sd_suspend(struct device *dev, pm_message_t state, u32 level)
+{
+	struct scsi_device *sdp = to_scsi_device(dev);
+	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+
+	if (!sdkp)
+		return 0;         /* this can happen */
+
+	if (!sdkp->WCE)
+		return 0;
+
+	/* don't try to sync an offline device ... it will only error */
+	if (!scsi_device_online(sdp))
+		return 0;
+
+	if (sd_sync_cache(sdp))
+		return -EIO;
+	return 0;
+}
 
 /**
  *	init_sd - entry point for this driver (both when built in or when



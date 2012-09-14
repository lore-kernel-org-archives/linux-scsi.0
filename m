From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 1/2] scsi: sd: set ready_to_power_off for scsi disk
Date: Fri, 14 Sep 2012 21:54:16 +0800
Message-ID: <20120914135416.GA2730@mint-spring.sh.intel.com>
References: <50519801.6080502@intel.com>
 <1347525466.2720.10.camel@dabdike.int.hansenpartnership.com>
 <50519E08.10800@intel.com>
 <1347526590.2720.15.camel@dabdike.int.hansenpartnership.com>
 <5051A25F.7040704@intel.com>
 <1347528404.2720.28.camel@dabdike.int.hansenpartnership.com>
 <20120914052041.GA5177@mint-spring.sh.intel.com>
 <1347610640.2794.11.camel@dabdike.int.hansenpartnership.com>
 <5052EF5F.3000103@intel.com>
 <1347618389.2450.5.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1347618389.2450.5.camel@dabdike.int.hansenpartnership.com>
Sender: linux-acpi-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, Oliver Neukum <oliver@neukum.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 14, 2012 at 11:26:29AM +0100, James Bottomley wrote:
> On Fri, 2012-09-14 at 16:48 +0800, Aaron Lu wrote:
> > So if we program the device to let it enter standby/stopped power
> > condition with the start_stop_unit command, do we need to sync the
> > cache?
> 
> No, that's what the spec says.  The device must manage the cache in both
> the forced (start stop unit) and timed (power control mode page) cases.
> 
> The reason is the spec doesn't define what idle and standby actually
> mean (just that they're "lower" power states).  So the device
> implementers get to choose if they stop the platter or power off the
> motor.  The spec just means that if they do anything that causes danger
> to data in the cache, they have to deal with it themselves.

Thanks for the clear explanation.

So what about the following change? In sd_suspend, if device supports
start_stop command, then we just need issue this command then both
runtime suspend case and system S3/S4 case are OK, since when the device
enters stopped power condition, the internal cache should be taken care
of by the device and it is also ready to be powered off. And if device
does not support start_stop command, we will sync the cache if we are
doing S3/S4 or runtime suspend with power to be removed.

The sd_shutdown is changed accordingly, when device is already runtime
suspended:
1 If it supports start_stop, it should be in stopped power condition, no
more action required;
2 If it is already powered off, no more action required.

Otherwise, we runtime resume the device and sync cache for WCE device.

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4df73e5..760ce5b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2845,18 +2845,18 @@ static void sd_shutdown(struct device *dev)
 	if (!sdkp)
 		return;         /* this can happen */
 
-	if (pm_runtime_suspended(dev))
+	if (pm_runtime_suspended(dev)
+	    && (sdkp->device->manage_start_stop || sdkp->device->powered_off))
 		goto exit;
 
+	scsi_autopm_get_device(sdkp->device);
+
 	if (sdkp->WCE) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
 		sd_sync_cache(sdkp);
 	}
 
-	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
-		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
-		sd_start_stop_device(sdkp, 0);
-	}
+	scsi_autopm_put_device(sdkp->device);
 
 exit:
 	scsi_disk_put(sdkp);
@@ -2870,16 +2870,18 @@ static int sd_suspend(struct device *dev, pm_message_t mesg)
 	if (!sdkp)
 		return 0;	/* this can happen */
 
-	if (sdkp->WCE) {
-		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		ret = sd_sync_cache(sdkp);
-		if (ret)
-			goto done;
-	}
-
-	if ((mesg.event & PM_EVENT_SLEEP) && sdkp->device->manage_start_stop) {
+	if (sdkp->device->manage_start_stop) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		ret = sd_start_stop_device(sdkp, 0);
+		goto done;
+	}
+
+	if (sdkp->WCE) {
+		if ((PMSG_IS_AUTO(mesg) && sdkp->device->may_power_off) ||
+				(mesg.event & PM_EVENT_SLEEP)) {
+			sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
+			ret = sd_sync_cache(sdkp);
+		}
 	}
 
 done:

Thanks,
Aaron

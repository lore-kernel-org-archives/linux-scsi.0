From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 1/2] scsi: sd: set ready_to_power_off for scsi disk
Date: Mon, 17 Sep 2012 23:01:41 +0800
Message-ID: <20120917150139.GA18759@mint-spring.sh.intel.com>
References: <1347525466.2720.10.camel@dabdike.int.hansenpartnership.com>
 <50519E08.10800@intel.com>
 <1347526590.2720.15.camel@dabdike.int.hansenpartnership.com>
 <5051A25F.7040704@intel.com>
 <1347528404.2720.28.camel@dabdike.int.hansenpartnership.com>
 <20120914052041.GA5177@mint-spring.sh.intel.com>
 <1347610640.2794.11.camel@dabdike.int.hansenpartnership.com>
 <5052EF5F.3000103@intel.com>
 <1347618389.2450.5.camel@dabdike.int.hansenpartnership.com>
 <20120914135416.GA2730@mint-spring.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120914135416.GA2730@mint-spring.sh.intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, Oliver Neukum <oliver@neukum.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 14, 2012 at 09:54:16PM +0800, Aaron Lu wrote:
> On Fri, Sep 14, 2012 at 11:26:29AM +0100, James Bottomley wrote:
> > On Fri, 2012-09-14 at 16:48 +0800, Aaron Lu wrote:
> > > So if we program the device to let it enter standby/stopped power
> > > condition with the start_stop_unit command, do we need to sync the
> > > cache?
> > 
> > No, that's what the spec says.  The device must manage the cache in both
> > the forced (start stop unit) and timed (power control mode page) cases.
> > 
> > The reason is the spec doesn't define what idle and standby actually
> > mean (just that they're "lower" power states).  So the device
> > implementers get to choose if they stop the platter or power off the
> > motor.  The spec just means that if they do anything that causes danger
> > to data in the cache, they have to deal with it themselves.
> 
> Thanks for the clear explanation.
> 
> So what about the following change? In sd_suspend, if device supports
> start_stop command, then we just need issue this command then both
> runtime suspend case and system S3/S4 case are OK, since when the device
> enters stopped power condition, the internal cache should be taken care
> of by the device and it is also ready to be powered off. And if device

This is not the case for ata device, so scsi stop command should
translate to 2 ata commands: flush cache + enter standby.

If flush cache is skipped in sd driver, then ata scsi translate will
need to update to address this issue.

A possible change(not tested) like this:

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 8ec81ca..2de5fac 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1759,6 +1759,19 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 	ata_qc_free(qc);
 }
 
+static int ata_flush_cache(struct ata_device *dev)
+{
+	u8 cmd;
+
+	if (dev->flags & ATA_DFLAG_FLUSH_EXT)
+		cmd = ATA_CMD_FLUSH_EXT;
+	else
+		cmd = ATA_CMD_FLUSH;
+
+	return ata_do_simple_cmd(dev, cmd);
+}
+
+
 /**
  *	ata_scsi_translate - Translate then issue SCSI command to ATA device
  *	@dev: ATA device to which the command is addressed
@@ -1816,6 +1829,13 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 	if (xlat_func(qc))
 		goto early_finish;
 
+	/* scsi stop cmd = flush cache + standby */
+	if (qc->tf.command == ATA_CMD_STANDBYNOW1 && ata_try_flush_cache(dev)) {
+		rc = ata_flush_cache(dev);
+		if (rc)
+			goto err_did;
+	}
+
 	if (ap->ops->qc_defer) {
 		if ((rc = ap->ops->qc_defer(qc)))
 			goto defer;

Thanks,
Aaron

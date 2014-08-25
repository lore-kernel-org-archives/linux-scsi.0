From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented
 and there's not way to prevent the kernel from using the 2nd cdb byte for
 the LUN
Date: Mon, 25 Aug 2014 17:19:06 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1408251634320.1385-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1408251545580.1385-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1408251545580.1385-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, Tiziano Bacocco <tiziano.bacocco-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 25 Aug 2014, Alan Stern wrote:

> On Mon, 25 Aug 2014, James Bottomley wrote:
> 
> > On Mon, 2014-08-25 at 10:44 -0400, Alan Stern wrote:
> > 
> > > James, can you explain how the INQUIRY command in scsi_probe_lun()  
> > > managed to work back in the days when multi-lun SCSI-2 devices were
> > > common?  sdev->scsi_level doesn't get set when sdev is allocated, so it
> > > initially contains 0, so the LUN bits won't get filled in when the
> > > first INQUIRY command is sent.  Then how could the target know which
> > > logical unit the INQUIRY was meant for?
> > 
> > Best guess, some patches over the course of time altered the way we do
> > this and no-one noticed.  I think it was probably the introduction of
> > the unknown SCSI data level that caused the breakage.
> 
> Heh.  The change was made by commit 4d7db04a7a69 ([SCSI] add
> SCSI_UNKNOWN and LUN transfer limit restrictions) back in 2006 -- the
> 2.6.17 kernel.  If nobody has complained in all this time then it's
> probably not worth changing.

It turns out the code is already there, and I didn't realize because I
was looking at the wrong source file.  scsi_sysfs_device_initialize()
already does:

	sdev->scsi_level = starget->scsi_level;

Here's the update to the patch, adding an appropriate comment and
setting the new sdev->lun_in_sdb flag properly:

Alan Stern


Index: usb-3.16/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-3.16.orig/drivers/scsi/scsi_sysfs.c
+++ usb-3.16/drivers/scsi/scsi_sysfs.c
@@ -1238,7 +1238,19 @@ void scsi_sysfs_device_initialize(struct
 	sdev->sdev_dev.class = &sdev_class;
 	dev_set_name(&sdev->sdev_dev, "%d:%d:%d:%d",
 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
+	/*
+	 * Get a default scsi_level from the target (derived from sibling
+	 * devices).  This is the best we can do for guessing how to set
+	 * sdev->lun_in_cdb for the initial INQUIRY command.  For LUN 0 the
+	 * setting doesn't matter, because all the bits are zero anyway.
+	 * But it does matter for higher LUNs.
+	 */
 	sdev->scsi_level = starget->scsi_level;
+	if (sdev->scsi_level <= SCSI_2 &&
+			sdev->scsi_level != SCSI_UNKNOWN &&
+			!shost->no_scsi2_lun_in_cdb)
+		sdev->lun_in_cdb = 1;
+
 	transport_setup_device(&sdev->sdev_gendev);
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_add_tail(&sdev->same_target_siblings, &starget->devices);

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

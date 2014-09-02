From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: [PATCH] SCSI: Don't store LUN bits in CDB[1] for USB mass-storage
 devices
Date: Tue, 2 Sep 2014 11:35:50 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1409021108380.2308-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Tiziano Bacocco <tiziano.bacocco-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

The SCSI specification requires that the second Command Data Byte
should contain the LUN value in its high-order bits if the recipient
device reports SCSI level 2 or below.  Nevertheless, some USB
mass-storage devices use those bits for other purposes in
vendor-specific commands.  Currently Linux has no way to send such
commands, because the SCSI stack always overwrites the LUN bits.

Testing shows that Windows 7 and XP do not store the LUN bits in the
CDB when sending commands to a USB device.  This doesn't matter if the
device uses the Bulk-Only or UAS transports (which virtually all
modern USB mass-storage devices do), as these have a separate
mechanism for sending the LUN value.

Therefore this patch introduces a flag in the Scsi_Host structure to
inform the SCSI midlayer that a transport does not require the LUN
bits to be stored in the CDB, and it makes usb-storage set this flag
for all devices using the Bulk-Only transport.  (UAS is handled by a
separate driver, but it doesn't really matter because no SCSI-2 or
lower device is at all likely to use UAS.)

The patch also cleans up the code responsible for storing the LUN
value by adding a bitflag to the scsi_device structure.  The test for
whether to stick the LUN value in the CDB can be made when the device
is probed, and stored for future use rather than being made over and
over in the fast path.

Signed-off-by: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Reported-by: Tiziano Bacocco <tiziano.bacocco-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Acked-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Acked-by: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Acked-by: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>

---


[as1762]


 drivers/scsi/scsi.c        |    8 ++------
 drivers/scsi/scsi_scan.c   |   10 ++++++++++
 drivers/scsi/scsi_sysfs.c  |   12 ++++++++++++
 drivers/usb/storage/usb.c  |    8 ++++++++
 include/scsi/scsi_device.h |    1 +
 include/scsi/scsi_host.h   |    3 +++
 6 files changed, 36 insertions(+), 6 deletions(-)

Index: usb-3.16/include/scsi/scsi_host.h
===================================================================
--- usb-3.16.orig/include/scsi/scsi_host.h
+++ usb-3.16/include/scsi/scsi_host.h
@@ -692,6 +692,9 @@ struct Scsi_Host {
 	 */
 	struct workqueue_struct *tmf_work_q;
 
+	/* The transport requires the LUN bits NOT to be stored in CDB[1] */
+	unsigned no_scsi2_lun_in_cdb:1;
+
 	/*
 	 * Value host_blocked counts down from
 	 */
Index: usb-3.16/include/scsi/scsi_device.h
===================================================================
--- usb-3.16.orig/include/scsi/scsi_device.h
+++ usb-3.16/include/scsi/scsi_device.h
@@ -174,6 +174,7 @@ struct scsi_device {
 	unsigned wce_default_on:1;	/* Cache is ON by default */
 	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
 	unsigned broken_fua:1;		/* Don't set FUA bit */
+	unsigned lun_in_cdb:1;		/* Store LUN bits in CDB[1] */
 
 	atomic_t disk_events_disable_depth; /* disable depth for disk events */
 
Index: usb-3.16/drivers/scsi/scsi.c
===================================================================
--- usb-3.16.orig/drivers/scsi/scsi.c
+++ usb-3.16/drivers/scsi/scsi.c
@@ -670,14 +670,10 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 
-	/*
-	 * If SCSI-2 or lower, store the LUN value in cmnd.
-	 */
-	if (cmd->device->scsi_level <= SCSI_2 &&
-	    cmd->device->scsi_level != SCSI_UNKNOWN) {
+	/* Store the LUN value in cmnd, if needed. */
+	if (cmd->device->lun_in_cdb)
 		cmd->cmnd[1] = (cmd->cmnd[1] & 0x1f) |
 			       (cmd->device->lun << 5 & 0xe0);
-	}
 
 	scsi_log_send(cmd);
 
Index: usb-3.16/drivers/scsi/scsi_scan.c
===================================================================
--- usb-3.16.orig/drivers/scsi/scsi_scan.c
+++ usb-3.16/drivers/scsi/scsi_scan.c
@@ -736,6 +736,16 @@ static int scsi_probe_lun(struct scsi_de
 		sdev->scsi_level++;
 	sdev->sdev_target->scsi_level = sdev->scsi_level;
 
+	/*
+	 * If SCSI-2 or lower, and if the transport requires it,
+	 * store the LUN value in CDB[1].
+	 */
+	sdev->lun_in_cdb = 0;
+	if (sdev->scsi_level <= SCSI_2 &&
+	    sdev->scsi_level != SCSI_UNKNOWN &&
+	    !sdev->host->no_scsi2_lun_in_cdb)
+		sdev->lun_in_cdb = 1;
+
 	return 0;
 }
 
Index: usb-3.16/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-3.16.orig/drivers/scsi/scsi_sysfs.c
+++ usb-3.16/drivers/scsi/scsi_sysfs.c
@@ -1263,7 +1263,19 @@ void scsi_sysfs_device_initialize(struct
 	sdev->sdev_dev.class = &sdev_class;
 	dev_set_name(&sdev->sdev_dev, "%d:%d:%d:%llu",
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
Index: usb-3.16/drivers/usb/storage/usb.c
===================================================================
--- usb-3.16.orig/drivers/usb/storage/usb.c
+++ usb-3.16/drivers/usb/storage/usb.c
@@ -983,6 +983,14 @@ int usb_stor_probe2(struct us_data *us)
 	if (!(us->fflags & US_FL_SCM_MULT_TARG))
 		us_to_host(us)->max_id = 1;
 
+	/*
+	 * Like Windows, we won't store the LUN bits in CDB[1] for SCSI-2
+	 * devices using the Bulk-Only transport (even though this violates
+	 * the SCSI spec).
+	 */
+	if (us->transport == usb_stor_Bulk_transport)
+		us_to_host(us)->no_scsi2_lun_in_cdb = 1;
+
 	/* Find the endpoints and calculate pipe values */
 	result = get_pipes(us);
 	if (result)

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

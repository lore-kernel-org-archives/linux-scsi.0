From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented
 and there's not way to prevent the kernel from using the 2nd cdb byte for
 the LUN
Date: Fri, 22 Aug 2014 10:53:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1408221044450.967-100000@iolanthe.rowland.org>
References: <20140821215744.GA29651@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140821215744.GA29651-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, Tiziano Bacocco <tiziano.bacocco-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 21 Aug 2014, Christoph Hellwig wrote:

> On Thu, Aug 21, 2014 at 05:43:41PM -0400, Martin K. Petersen wrote:
> > Alan> Okay, here's a patch that implements the suggestion, except that I
> > Alan> put the flag in the Scsi_Host structure instead of the template.
> > Alan> This was to minimize the impact of the change.  Among the various
> > Alan> SCSI-over-USB transports, only the Bulk-Only transport gives the
> > Alan> LUN separately from the CDB.  I don't know if there are any
> > Alan> multi-LUN USB devices that don't use the Bulk-Only transport, but
> > Alan> if there are then they won't work if the LUN isn't stored in
> > Alan> CDB[1].
> > 
> > I'm in agreement with this approach.
> 
> I like it too. One idea to unclutter the fastpath would be to have a
> single flag that controls if the LUN is set which is based on the
> host(-template) flag and the scsi level, which would allow us to remove
> all the clutter around that area.

Good idea.  An enhanced patch is below.  If I can get a Tested-By: from
Tiziano and one or two Acked-By: responses, I'll submit this for the
current and stable kernels.

Sending the initial INQUIRY command to LUNs larger than 0 involves a
chicken-and-egg problem -- we don't know whether to fill in the LUN
bits in the command until we know the SCSI level, and we don't know the
SCSI level until the INQUIRY response is received.  The solution we 
have been using is to store the most recently discovered level in the 
target structure, and use it as a default.  If probing starts with LUN 
0, and if all the LUNs have similar levels, this ought to work.

Except for one thing: The code does store the default level in the
scsi_target, but forgets to copy it back into each newly allocated
scsi_device!  I added a line to do that into the patch.

Alan Stern



Index: usb-3.16/include/scsi/scsi_host.h
===================================================================
--- usb-3.16.orig/include/scsi/scsi_host.h
+++ usb-3.16/include/scsi/scsi_host.h
@@ -695,6 +695,9 @@ struct Scsi_Host {
 	/* The controller does not support WRITE SAME */
 	unsigned no_write_same:1;
 
+	/* The transport requires the LUN bits NOT to be stored in CDB[1] */
+	unsigned no_scsi2_lun_in_cdb:1;
+
 	/*
 	 * Optional work queue to be utilized by the transport
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
@@ -674,14 +674,10 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 		goto out;
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
@@ -257,6 +257,7 @@ static struct scsi_device *scsi_alloc_sd
 
 	sdev->sdev_gendev.parent = get_device(&starget->dev);
 	sdev->sdev_target = starget;
+	sdev->scsi_level = starget->scsi_level;
 
 	/* usually NULL and set by ->slave_alloc instead */
 	sdev->hostdata = hostdata;
@@ -735,6 +736,15 @@ static int scsi_probe_lun(struct scsi_de
 		sdev->scsi_level++;
 	sdev->sdev_target->scsi_level = sdev->scsi_level;
 
+	/*
+	 * If SCSI-2 or lower, and if the transport requires it,
+	 * store the LUN value in CDB[1].
+	 */
+	if (sdev->scsi_level <= SCSI_2 &&
+	    sdev->scsi_level != SCSI_UNKNOWN &&
+	    !sdev->host->no_scsi2_lun_in_cdb)
+		sdev->lun_in_cdb = 1;
+
 	return 0;
 }
 
Index: usb-3.16/drivers/usb/storage/usb.c
===================================================================
--- usb-3.16.orig/drivers/usb/storage/usb.c
+++ usb-3.16/drivers/usb/storage/usb.c
@@ -981,6 +981,14 @@ int usb_stor_probe2(struct us_data *us)
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

From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security
 in usb-storage driver
Date: Tue, 8 Nov 2005 12:09:44 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0511081203280.4438-100000@iolanthe.rowland.org>
References: <1131401153.3333.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1131401153.3333.6.camel@mulgrave>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, thomas schorpp <t.schorpp@gmx.de>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, Timothy Thelin <Timothy.Thelin@wdc.com>, Linux SCSI list <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 7 Nov 2005, James Bottomley wrote:

> > It's quite possible that usb-storage no longer needs to force the 
> > scsi-level to 2.  No one has recently tested what would happen without 
> > it.  Matt probably has the best selection of devices for testing...
> > 
> > There is one problem we have with devices that report themselves as SCSI-3 
> > or SCSI-4 but hang when they receive a REPORT LUNS command.  That's easily 
> > handled by making usb-storage set the NOREPORTLUN flag.  Maybe that's all 
> > we need to do.
> 
> If you could try this out, I'd be grateful.

I tried the patch below on several combinations of SCSI levels and device 
types.  It seems to do exactly what we want; for reads I always saw 
READ(10) and for MODE SENSE I saw either the 6- or 10-byte form, depending 
on the device type and USB subclass value.

The question remains whether pass-thru will now work and whether the patch
will mess up some existing non-compliant device that currently works okay.  
The only way to know is by trying it out.  Matt and Timothy, that's up to
you.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/usb/storage/scsiglue.c
===================================================================
--- usb-2.6.orig/drivers/usb/storage/scsiglue.c
+++ usb-2.6/drivers/usb/storage/scsiglue.c
@@ -94,23 +94,6 @@ static int slave_configure(struct scsi_d
 	 * the end, scatter-gather buffers follow page boundaries. */
 	blk_queue_dma_alignment(sdev->request_queue, (512 - 1));
 
-	/* Set the SCSI level to at least 2.  We'll leave it at 3 if that's
-	 * what is originally reported.  We need this to avoid confusing
-	 * the SCSI layer with devices that report 0 or 1, but need 10-byte
-	 * commands (ala ATAPI devices behind certain bridges, or devices
-	 * which simply have broken INQUIRY data).
-	 *
-	 * NOTE: This means /dev/sg programs (ala cdrecord) will get the
-	 * actual information.  This seems to be the preference for
-	 * programs like that.
-	 *
-	 * NOTE: This also means that /proc/scsi/scsi and sysfs may report
-	 * the actual value or the modified one, depending on where the
-	 * data comes from.
-	 */
-	if (sdev->scsi_level < SCSI_2)
-		sdev->scsi_level = SCSI_2;
-
 	/* According to the technical support people at Genesys Logic,
 	 * devices using their chips have problems transferring more than
 	 * 32 KB at a time.  In practice people have found that 64 KB
@@ -159,10 +142,10 @@ static int slave_configure(struct scsi_d
 		/* Some devices report a SCSI revision level above 2 but are
 		 * unable to handle the REPORT LUNS command (for which
 		 * support is mandatory at level 3).  Since we already have
-		 * a Get-Max-LUN request, we won't lose much by setting the
-		 * revision level down to 2.  The only devices that would be
+		 * a Get-Max-LUN request, we won't lose much by not using
+		 * REPORT LUNS.  The only devices that would be
 		 * affected are those with sparse LUNs. */
-		sdev->scsi_level = SCSI_2;
+		sdev->sdev_target->no_report_lun = 1;
 
 		/* USB-IDE bridges tend to report SK = 0x04 (Non-recoverable
 		 * Hardware Error) when any low-level error occurs,
Index: usb-2.6/include/scsi/scsi_device.h
===================================================================
--- usb-2.6.orig/include/scsi/scsi_device.h
+++ usb-2.6/include/scsi/scsi_device.h
@@ -161,7 +161,8 @@ struct scsi_target {
 	unsigned int		channel;
 	unsigned int		id; /* target id ... replace
 				     * scsi_device.id eventually */
-	unsigned long		create:1; /* signal that it needs to be added */
+	unsigned int		create:1; /* signal that it needs to be added */
+	unsigned int		no_report_lun:1; /* do not use REPORT LUNS */
 	char			scsi_level;
 	void 			*hostdata; /* available to low-level driver */
 	unsigned long		starget_data[0]; /* for the transport */
Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -1078,6 +1078,7 @@ static int scsi_report_lun_scan(struct s
 	 * support more than 8 LUNs.
 	 */
 	if ((bflags & BLIST_NOREPORTLUN) || 
+	     starget->no_report_lun ||
 	     starget->scsi_level < SCSI_2 ||
 	    (starget->scsi_level < SCSI_3 && 
 	     (!(bflags & BLIST_REPORTLUN2) || shost->max_lun <= 8)) )


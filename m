From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented
 and there's not way to prevent the kernel from using the 2nd cdb byte for
 the LUN
Date: Thu, 21 Aug 2014 13:31:34 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1408211326070.918-100000@iolanthe.rowland.org>
References: <20140821144252.GA16226@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:41040 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752129AbaHURbf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Aug 2014 13:31:35 -0400
In-Reply-To: <20140821144252.GA16226@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, Tiziano Bacocco <tiziano.bacocco@gmail.com>, bugzilla-daemon@bugzilla.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Thu, 21 Aug 2014, Christoph Hellwig wrote:

> On Thu, Aug 21, 2014 at 10:41:02AM -0400, Douglas Gilbert wrote:
> > Perhaps we could add another bit flag in struct
> > scsi_host_template such as:
> >     unsigned int transport_says_dont_scsi2_lun_cmd:1;
> > 
> > then drivers/usb/storage/scsiglue.c could set that
> > bit in its usb_stor_host_template and
> > drivers/scsi/scsi.c could take heed (and not mask
> > cmd->cmnd[1] with the LUN).
> 
> Fully agreed.
> 
> (except that I'd shorten the flag name to .no_scsi2lun :))

Okay, here's a patch that implements the suggestion, except that I put
the flag in the Scsi_Host structure instead of the template.  This was
to minimize the impact of the change.  Among the various SCSI-over-USB
transports, only the Bulk-Only transport gives the LUN separately from
the CDB.  I don't know if there are any multi-LUN USB devices that
don't use the Bulk-Only transport, but if there are then they won't 
work if the LUN isn't stored in CDB[1].

Tiziano, does this do what you want?

Alan Stern



Index: usb-3.16/include/scsi/scsi_host.h
===================================================================
--- usb-3.16.orig/include/scsi/scsi_host.h
+++ usb-3.16/include/scsi/scsi_host.h
@@ -695,6 +695,9 @@ struct Scsi_Host {
 	/* The controller does not support WRITE SAME */
 	unsigned no_write_same:1;
 
+	/* The transport requires the LUN bits NOT to be stored in CDB[1] */
+	unsigned no_scsi2_lun:1;
+
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */
Index: usb-3.16/drivers/scsi/scsi.c
===================================================================
--- usb-3.16.orig/drivers/scsi/scsi.c
+++ usb-3.16/drivers/scsi/scsi.c
@@ -678,7 +678,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 	 * If SCSI-2 or lower, store the LUN value in cmnd.
 	 */
 	if (cmd->device->scsi_level <= SCSI_2 &&
-	    cmd->device->scsi_level != SCSI_UNKNOWN) {
+	    cmd->device->scsi_level != SCSI_UNKNOWN &&
+	    !host->no_scsi2_lun) {
 		cmd->cmnd[1] = (cmd->cmnd[1] & 0x1f) |
 			       (cmd->device->lun << 5 & 0xe0);
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
+		us_to_host(us)->no_scsi2_lun = 1;
+
 	/* Find the endpoints and calculate pipe values */
 	result = get_pipes(us);
 	if (result)


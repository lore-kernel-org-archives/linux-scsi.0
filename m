From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Requested changes for the SCSI error handler
Date: Fri, 4 Jun 2004 16:59:57 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0406041655550.843-100000@ida.rowland.org>
References: <1086122775.2061.87.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:11268 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S266010AbUFDU76 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2004 16:59:58 -0400
In-Reply-To: <1086122775.2061.87.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On 1 Jun 2004, James Bottomley wrote:

> On Tue, 2004-06-01 at 15:29, Alan Stern wrote:
> > You mean, in the hostt->eh_{bus|host}_reset_handler() routines?  That
> > would be fine with me.  Isn't it true that we don't even have to block the
> > host, since this all executes in the error-handler thread?
> 
> Actually yes.  The block would only have to be implemented in the
> asynchronous report path.
> 
> > In addition, the settle-time delays would have to be removed from the
> > error handler -- which means adding it to all the low-level drivers.  Is 
> > that doable?
> 
> Well, for 2.6, I think that a simple flag indicating that the driver
> will implement it's own timeout should suffice rather than altering
> every LLD...

How does this look?

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

===== include/scsi/scsi_host.h 1.8 vs edited =====
--- 1.8/include/scsi/scsi_host.h	Fri Mar 12 03:16:47 2004
+++ edited/include/scsi/scsi_host.h	Fri Jun  4 16:51:31 2004
@@ -314,6 +314,11 @@
 	unsigned emulated:1;
 
 	/*
+	 * True if the low-level driver performs its own reset-settle delays.
+	 */
+	unsigned skip_settle_delay:1;
+
+	/*
 	 * Countdown for host blocking with no commands outstanding
 	 */
 	unsigned int max_host_blocked;
===== drivers/scsi/scsi_error.c 1.41 vs edited =====
--- 1.41/drivers/scsi/scsi_error.c	Tue Apr 20 18:22:11 2004
+++ edited/drivers/scsi/scsi_error.c	Fri Jun  4 16:54:06 2004
@@ -1026,7 +1026,8 @@
 	spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
 
 	if (rtn == SUCCESS) {
-		scsi_sleep(BUS_RESET_SETTLE_TIME);
+		if (!scmd->device->host->hostt->skip_settle_delay)
+			scsi_sleep(BUS_RESET_SETTLE_TIME);
 		spin_lock_irqsave(scmd->device->host->host_lock, flags);
 		scsi_report_bus_reset(scmd->device->host, scmd->device->channel);
 		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
@@ -1057,7 +1058,8 @@
 	spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
 
 	if (rtn == SUCCESS) {
-		scsi_sleep(HOST_RESET_SETTLE_TIME);
+		if (!scmd->device->host->hostt->skip_settle_delay)
+			scsi_sleep(HOST_RESET_SETTLE_TIME);
 		spin_lock_irqsave(scmd->device->host->host_lock, flags);
 		scsi_report_bus_reset(scmd->device->host, scmd->device->channel);
 		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
===== drivers/usb/storage/scsiglue.c 1.75 vs edited =====
--- 1.75/drivers/usb/storage/scsiglue.c	Sat May 15 11:48:19 2004
+++ edited/drivers/usb/storage/scsiglue.c	Fri Jun  4 16:52:56 2004
@@ -409,6 +409,9 @@
 	/* emulated HBA */
 	.emulated =			TRUE,
 
+	/* we do our own delay after a device or bus reset */
+	.skip_settle_delay =		1,
+
 	/* sysfs device attributes */
 	.sdev_attrs =			sysfs_device_attr_list,
 


From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Patch: change the serial_number for error-handler commands
Date: Wed, 21 May 2003 11:03:08 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030521180308.GD1116@beaverton.ibm.com>
References: <3ECA9D46.7010301@rogers.com> <Pine.LNX.4.44L0.0305202110520.4914-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:65192 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S262226AbTEURsE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2003 13:48:04 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0305202110520.4914-100000@netrider.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Luben Tuikov <tluben@rogers.com>, linux-scsi@vger.kernel.org

Sorry for the slow response I was under the weather and not doing much
yesterday.

Alan Stern [stern@rowland.harvard.edu] wrote:
> Well, the patch changes the serial number regardless of its initial value,
> but otherwise yes.  It would be okay with me to change scsi_core->sn.  
> But the global serial number is currently a static variable defined in
> scsi.c and my change was to scsi_error.c -- I didn't want to export the
> variable needlessly.
> 
> > Q: Which value does USB Storage reserve for cmdsn, 0 or MAX?
> 
> It doesn't reserve any values.  (I avoided 0 only because I noticed that
> the scsi core uses 0 as a reserved value.)  Usb-storage just requires that
> serial numbers not be repeated.
> 

I agree on the change in SCSI core instead of a change just for scsi
error handling. If you are depending on command serial number to be
unique as the comments in scsi_dispatch_cmd already indicate we have
problems (in USB storage case since can_queue is 1 it would not run into a
issue until scsi error handling).

The patch below is a quick patch that moves the serial_number from a
scsi mid level static to a per scsi host value. In looking at the usage
of command serial_number it appears that moving to a per scsi host name
space should be ok.

I have compile and boot tested it on my system with the ips and aic7xxx
drivers.

The patch needs some more testing and some variable name updates, but
should be ok to test USB and allow for discussion of this type of
change.

-andmike
--
Michael Anderson
andmike@us.ibm.com

DESC
This patch is against scsi-misc-2.5 but also applies against 2.5.69.

Move scsi command serial number to per scsi host serial number. We also
only increment the serial number under a lock now so the race on the value
is removed. A new serial number is also acquired in the scsi_error handler
on new commands.
EDESC


 drivers/scsi/hosts.h      |    7 +++++++
 drivers/scsi/scsi.c       |    7 ++-----
 drivers/scsi/scsi_error.c |    1 +
 3 files changed, 10 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/hosts.h~scsi_serial_number drivers/scsi/hosts.h
--- sysfs-scsi-misc-2.5/drivers/scsi/hosts.h~scsi_serial_number	Wed May 21 08:41:49 2003
+++ sysfs-scsi-misc-2.5-andmike/drivers/scsi/hosts.h	Wed May 21 08:41:49 2003
@@ -487,6 +487,8 @@ struct Scsi_Host
     struct device host_gendev;
     struct class_device class_dev;
 
+    unsigned long serial_number;
+
     /*
      * We should ensure that this is aligned, both for better performance
      * and also because some compilers (m68k) don't automatically force
@@ -532,6 +534,11 @@ static inline struct device *scsi_get_de
         return shost->host_gendev.parent;
 }
 
+static inline unsigned long scsi_get_next_serial(struct Scsi_Host *shost)
+{
+        return (++shost->serial_number) ? shost->serial_number : 1;
+}
+
 struct Scsi_Device_Template
 {
     struct list_head list;
diff -puN drivers/scsi/scsi.c~scsi_serial_number drivers/scsi/scsi.c
--- sysfs-scsi-misc-2.5/drivers/scsi/scsi.c~scsi_serial_number	Wed May 21 08:41:49 2003
+++ sysfs-scsi-misc-2.5-andmike/drivers/scsi/scsi.c	Wed May 21 08:41:49 2003
@@ -83,7 +83,6 @@
  */
 unsigned long scsi_pid;
 struct scsi_cmnd *last_cmnd;
-static unsigned long serial_number;
 
 /*
  * List of all highlevel drivers.
@@ -398,11 +397,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 	unsigned long timeout;
 	int rtn = 1;
 
-	/* Assign a unique nonzero serial_number. */
 	/* XXX(hch): this is racy */
-	if (++serial_number == 0)
-		serial_number = 1;
-	cmd->serial_number = serial_number;
 	cmd->pid = scsi_pid++;
 
 	/* 
@@ -471,6 +466,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 					   host->hostt->queuecommand));
 
 		spin_lock_irqsave(host->host_lock, flags);
+		cmd->serial_number = scsi_get_next_serial(host);
 		rtn = host->hostt->queuecommand(cmd, scsi_done);
 		spin_unlock_irqrestore(host->host_lock, flags);
 		if (rtn) {
@@ -485,6 +481,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 					host->hostt->command));
 
 		spin_lock_irqsave(host->host_lock, flags);
+		cmd->serial_number = scsi_get_next_serial(host);
 		cmd->result = host->hostt->command(cmd);
 		scsi_done(cmd);
 		spin_unlock_irqrestore(host->host_lock, flags);
diff -puN drivers/scsi/scsi_error.c~scsi_serial_number drivers/scsi/scsi_error.c
--- sysfs-scsi-misc-2.5/drivers/scsi/scsi_error.c~scsi_serial_number	Wed May 21 08:41:49 2003
+++ sysfs-scsi-misc-2.5-andmike/drivers/scsi/scsi_error.c	Wed May 21 08:41:49 2003
@@ -456,6 +456,7 @@ static int scsi_send_eh_cmnd(struct scsi
 		scmd->request->rq_status = RQ_SCSI_BUSY;
 
 		spin_lock_irqsave(scmd->device->host->host_lock, flags);
+		scmd->serial_number = scsi_get_next_serial(host);
 		host->hostt->queuecommand(scmd, scsi_eh_done);
 		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
 

_

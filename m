From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: host_self_blocked question/bug?
Date: Tue, 25 Nov 2003 16:32:04 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031125163204.A5150@beaverton.ibm.com>
References: <3FC3CDCF.4030105@us.ibm.com> <1069797320.1787.220.camel@mulgrave> <3FC3D82D.2030604@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:16549 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S263823AbTKZAcJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2003 19:32:09 -0500
Received: from westrelay04.boulder.ibm.com (westrelay04.boulder.ibm.com [9.17.193.32])
	by e32.co.us.ibm.com (8.12.10/8.12.2) with ESMTP id hAQ0W8rE196308
	for <linux-scsi@vger.kernel.org>; Tue, 25 Nov 2003 19:32:08 -0500
Content-Disposition: inline
In-Reply-To: <3FC3D82D.2030604@us.ibm.com>; from brking@us.ibm.com on Tue, Nov 25, 2003 at 04:31:09PM -0600
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Nov 25, 2003 at 04:31:09PM -0600, Brian King wrote:
> James Bottomley wrote:
> > The original design was to allow short hiatuses when the HBA couldn't
> > accept I/O.  It doesn't work if there's I/O pending (unless the stop is
> > very short), because the SCSI timers are still ticking and error
> > recovery doesn't see this flag.
> > 
> > There has been talk of making this interface robust to pending commands
> > (halt the timers and freeze the error handler) for FC HBA's that take
> > ages to process loop events, but no work has been done on this---it's
> > quite a bit more work than simply not allowing the eh to emit TURs.

> I'd like a way to be able to stop the mid-layer from sending me any 
> commands. The scenarios I have today are:
> 
> 1. Fatal error on the adapter.
> 2. microcode download to the adapter.
> 3. Adapter cache recovery commands.
> 
> All of these cases require me to run BIST on the adapter and bring it 
> back up. To do this may take 20-30 seconds. I call scsi_block_requests, 
> fail all pending ops back with DID_ERROR, reset the adapter, then call 
> scsi_unblock_requests. My usage of it gets around the ticking timer 
> problem. I agree that the error recovery thread doesn't see this either 
> and that this is a potential problem. I had planned to work around that 
> by failing abort and device reset, forcing the host_reset to be called, 
> which would wait on the completion of the adapter reset, but it would be 
> nice if I didn't have to do that.

Given the above conditions: could we not start up the eh, and abort the eh
(and start it up again when unblocked) if already running and
we see host_self_blocked is set?

The following blocks the error handler from starting up, then we need code
to abort the error handler.

(There should be locking around all the setting and checking of
host_self_blocked.)

Untested, compiled only patch against main line bk:

===== drivers/scsi/scsi_error.c 1.65 vs edited =====
--- 1.65/drivers/scsi/scsi_error.c	Sun Sep 21 10:49:36 2003
+++ edited/drivers/scsi/scsi_error.c	Tue Nov 25 16:11:01 2003
@@ -47,7 +47,8 @@
 /* called with shost->host_lock held */
 void scsi_eh_wakeup(struct Scsi_Host *shost)
 {
-	if (shost->host_busy == shost->host_failed) {
+	if ((shost->host_busy == shost->host_failed) &&
+	    !shost->host_self_blocked) {
 		up(shost->eh_wait);
 		SCSI_LOG_ERROR_RECOVERY(5,
 				printk("Waking error handler thread\n"));
===== drivers/scsi/scsi_lib.c 1.113 vs edited =====
--- 1.113/drivers/scsi/scsi_lib.c	Sat Sep 20 06:53:02 2003
+++ edited/drivers/scsi/scsi_lib.c	Tue Nov 25 16:12:30 2003
@@ -1303,6 +1303,7 @@
 {
 	shost->host_self_blocked = 0;
 	scsi_run_host_queues(shost);
+	scsi_eh_wakeup(shost);
 }
 
 int __init scsi_init_queue(void)

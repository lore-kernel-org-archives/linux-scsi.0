From: Tim Pepper <tpepper@vato.org>
Subject: Bad reactions to QUEUE FULL
Date: Tue, 29 Apr 2003 22:02:59 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030429220259.A13386@jose.vato.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpe-24-221-186-48.ca.sprintbbd.net ([24.221.186.48]:2568 "HELO
	jose.vato.org") by vger.kernel.org with SMTP id S261722AbTD3Eup
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Apr 2003 00:50:45 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com, axboe@suse.de, olh@suse.de

It seems like there are some nasty reactions to a QUEUE FULL return in the
scsi stack.  A colleague found at least the bit patched below, although
I'm not sure it's 100% right.  Prior to that patch we'd seen crashes with:
	Kernel panic:scsi_free:Bad offset
With it I'm still seeing flakey behaviour...out of six machines with a variety
of kernels each time we drive our disk subsystem to the point of returning
queue full the 6 hosts are randomly but evenly spread across:
- total system lock up
- hung IO threads
- everything fine
I've got lots of syslogs captured that sort of generally show bad things
happening, but don't point me at any particular code in the scsi stack
to start looking at.

The machines are all 2.4 kernels x86 with qlogic and emulex hbas and the
latest drivers from those vendors running SLES7, SLES8, RH7.x, RHAS2.1
(latest errata kernels of each as of a week or two ago anyway).  I could
probably get a recreate on a recent kernel.org 2.4 kernel, but I don't
think the scsi stack is that different between them all (could be
wrong :).

I've trolled up some info that makes it sound like some s390 kernel has
some sort of a work(s?) around...

Anybody interested in having a look at this or is it a known issue?

Tim
-- 
*********************************************************
*  tpepper@vato dot org             * Venimus, Vidimus, *
*  http://www.vato.org/~tpepper     * Dolavimus         *
*********************************************************


--- linux-2.4.20/drivers/scsi/scsi_queue.c.orig	Tue Apr 29 21:29:59 2003
+++ linux-2.4.20/drivers/scsi/scsi_queue.c	Tue Apr 29 21:31:02 2003
@@ -143,6 +143,11 @@
 	spin_unlock_irqrestore(&io_request_lock, flags);
 
 	/*
+	 * Restore the direction
+	 */
+	cmd->sc_data_direction = cmd->sc_old_data_direction;
+
+	/*
 	 * Insert this command at the head of the queue for it's device.
 	 * It will go before all other commands that are already in the queue.
 	 */

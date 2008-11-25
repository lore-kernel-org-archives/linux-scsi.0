From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] Fix SCSI regression in 2.6.27 [was [Bugme-new] [Bug 12099]
 New: Nokia 5310 storage-mode]
Date: Tue, 25 Nov 2008 10:34:58 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0811251026500.2457-100000@iolanthe.rowland.org>
References: <20081125055939.a96796ec.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44640 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751370AbYKYPe7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Nov 2008 10:34:59 -0500
In-Reply-To: <20081125055939.a96796ec.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>, stable@kernel.org

This patch is intended for 2.6.27.stable and 2.6.28.  It's a temporary 
fix for a problem affecting a number of USB mass-storage devices 
(including many Nokia phones): When trying to access a nonexistent 
"last" sector, the SCSI midlayer gets caught in an endless retry loop.

See for example Bugzilla #11843 and #12099.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

On Tue, 25 Nov 2008, Andrew Morton wrote:

> On Tue, 25 Nov 2008 01:07:43 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=12099
> > 
> >            Summary: Nokia 5310 storage-mode
> >            Product: Drivers
> >            Version: 2.5
> >      KernelVersion: 2.6.27
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: USB
> >         AssignedTo: greg@kroah.com
> >         ReportedBy: robsonpeixoto@gmail.com
> > 
> > 
> > Latest working kernel version: 2.6.26
> > Earliest failing kernel version: 2.6.27
> 
> A regression.
> 
> > Distribution: ArchLinux
> > Hardware Environment: USB(ohci,ehci)
> > Software Environment: gcc 4.3.2, glibc 2.8
> > Problem Description: 
> > 
> > When I plug in my Nokia 5310 show a msg in cel "Transferring data" and in
> > computer nothing happend.

Unless we want to keep on receiving regression reports like this one,
this patch or something like it needs to be applied.  We can hope
2.6.29 will work better...  But unhappily, to date James has not
responded to any of my patch submissions in this area.

Alan Stern



Index: 2.6.27.4/drivers/scsi/scsi_lib.c
===================================================================
--- 2.6.27.4.orig/drivers/scsi/scsi_lib.c
+++ 2.6.27.4/drivers/scsi/scsi_lib.c
@@ -611,6 +611,11 @@ static void scsi_requeue_command(struct 
 	struct request *req = cmd->request;
 	unsigned long flags;
 
+	if (--req->retries < 0) {
+		blk_end_request(req, -EIO, blk_rq_bytes(req));
+		scsi_next_command(cmd);
+		return;
+	}
 	scsi_unprep_request(req);
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_requeue_request(q, req);
@@ -690,6 +695,8 @@ static struct scsi_cmnd *scsi_end_reques
 				 * leftovers in the front of the
 				 * queue, and goose the queue again.
 				 */
+				if (bytes > 0)		/* Made progress */
+					++req->retries;
 				scsi_requeue_command(q, cmd);
 				cmd = NULL;
 			}


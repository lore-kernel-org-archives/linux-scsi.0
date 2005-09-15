From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [2.6.14-rc1] sym scsi boot hang
Date: Thu, 15 Sep 2005 13:52:51 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509151210370.4472-100000@iolanthe.rowland.org>
References: <1126792573.4821.18.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932586AbVIORwz@vger.kernel.org>
In-Reply-To: <1126792573.4821.18.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Anton Blanchard <anton@samba.org>, Dipankar Sarma <dipankar@in.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 15 Sep 2005, James Bottomley wrote:

> On Wed, 2005-09-14 at 17:33 -0400, Alan Stern wrote:
> > On Wed, 14 Sep 2005, James Bottomley wrote:
> > > Yes ... really the only case for unprep is when we've partially released
> > > the command (like in scsi_io_completion) where we need to tear the rest
> > > of it down.
> > 
> > In other words, in scsi_requeue_command and nowhere else.
> 
> Pretty much, yes.

I found one other thing that needs to be fixed.  The call to 
scsi_release_buffers in scsi_unprep_request causes an oops, because the 
sgtable has already been freed in scsi_io_completion.  The following patch 
is needed.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Index: usb-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_lib.c
+++ usb-2.6/drivers/scsi/scsi_lib.c
@@ -118,7 +118,6 @@ static void scsi_unprep_request(struct r
 	req->flags &= ~REQ_DONTPREP;
 	req->special = (req->flags & REQ_SPECIAL) ? cmd->sc_request : NULL;
 
-	scsi_release_buffers(cmd);
 	scsi_put_command(cmd);
 }
 
@@ -1514,7 +1513,6 @@ static void scsi_request_fn(struct reque
 	 * cases (host limits or settings) should run the queue at some
 	 * later time.
 	 */
-	scsi_unprep_request(req);
 	spin_lock_irq(q->queue_lock);
 	blk_requeue_request(q, req);
 	sdev->device_busy--;

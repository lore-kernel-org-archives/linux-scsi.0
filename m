From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Sat, 2 Jul 2011 15:59:17 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1107021544550.16190-100000@netrider.rowland.org>
References: <20110702181146.GM23059@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:51741 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753401Ab1GBT7R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jul 2011 15:59:17 -0400
In-Reply-To: <20110702181146.GM23059@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: axboe@kernel.dk, James Bottomley <James.Bottomley@HansenPartnership.com>, Dave Jones <davej@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, USB list <linux-usb@vger.kernel.org>

On Sat, 2 Jul 2011, Andi Kleen wrote:

> > The problem is that blk_peek_request() calls scsi_prep_fn(), which 
> > does this:
> > 
> > 	struct scsi_device *sdev = q->queuedata;
> > 	int ret = BLKPREP_KILL;
> > 
> > 	if (req->cmd_type == REQ_TYPE_BLOCK_PC)
> > 		ret = scsi_setup_blk_pc_cmnd(sdev, req);
> > 	return scsi_prep_return(q, req, ret);
> > 
> > It doesn't check to see if sdev is NULL, nor does 
> > scsi_setup_blk_pc_cmnd().  That accounts for this error:
> 
> I actually added a NULL check in scsi_setup_blk_pc_cmnd early on,
> but that just caused RCU CPU stalls afterwards and then eventually
> a hung system.

The RCU problem is likely to be a separate issue.  It might even be a 
result of the use-after-free problem with the elevator.

At any rate, it's clear that the crash in the refcounting log you
posted occurred because scsi_setup_blk_pc_cmnd() called
scsi_prep_state_check(), which tried to dereference the NULL pointer.

Would you like to try this patch to see if it fixes the problem?  As I 
said before, I'm not certain it's the best thing to do, but it worked 
on my system.

Alan Stern




Index: usb-3.0/drivers/scsi/scsi_lib.c
===================================================================
--- usb-3.0.orig/drivers/scsi/scsi_lib.c
+++ usb-3.0/drivers/scsi/scsi_lib.c
@@ -1247,6 +1247,8 @@ int scsi_prep_fn(struct request_queue *q
 	struct scsi_device *sdev = q->queuedata;
 	int ret = BLKPREP_KILL;
 
+	if (!sdev)
+		return ret;
 	if (req->cmd_type == REQ_TYPE_BLOCK_PC)
 		ret = scsi_setup_blk_pc_cmnd(sdev, req);
 	return scsi_prep_return(q, req, ret);
Index: usb-3.0/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-3.0.orig/drivers/scsi/scsi_sysfs.c
+++ usb-3.0/drivers/scsi/scsi_sysfs.c
@@ -322,6 +322,8 @@ static void scsi_device_dev_release_user
 		kfree(evt);
 	}
 
+	/* Freeing the queue signals to block that we're done */
+	scsi_free_queue(sdev->request_queue);
 	blk_put_queue(sdev->request_queue);
 	/* NULL queue means the device can't be used */
 	sdev->request_queue = NULL;
@@ -936,8 +938,6 @@ void __scsi_remove_device(struct scsi_de
 	/* cause the request function to reject all I/O requests */
 	sdev->request_queue->queuedata = NULL;
 
-	/* Freeing the queue signals to block that we're done */
-	scsi_free_queue(sdev->request_queue);
 	put_device(dev);
 }
 



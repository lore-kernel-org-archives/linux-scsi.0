From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Fix selection of command serial numbers and pids
Date: Sun, 6 Feb 2005 20:07:58 +0000
Message-ID: <20050206200758.GU20386@parcelfarce.linux.theplanet.co.uk>
References: <20050206194123.GF18245@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:30602 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261308AbVBFUIB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Feb 2005 15:08:01 -0500
Content-Disposition: inline
In-Reply-To: <20050206194123.GF18245@wotan.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Sun, Feb 06, 2005 at 08:41:23PM +0100, Andi Kleen wrote:
> This patch fixes one of Christroph's fixme comments in the SCSI midlayer.

If we're going to start fixing problems that Christoph noted, this one seems
obvious to me:

The static device_request_lock doesn't protect anything; remove it.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

--- linux-2.6/drivers/scsi/scsi.c	2005-01-23 21:46:55.000000000 -0500
+++ scsi-2.6/drivers/scsi/scsi.c	2005-02-06 14:57:07.000000000 -0500
@@ -920,12 +920,9 @@ EXPORT_SYMBOL(scsi_finish_command);
  * 		the right thing depending on whether or not the device is
  * 		currently active and whether or not it even has the
  * 		command blocks built yet.
- *
- * XXX(hch):	What exactly is device_request_lock trying to protect?
  */
 void scsi_adjust_queue_depth(struct scsi_device *sdev, int tagged, int tags)
 {
-	static DEFINE_SPINLOCK(device_request_lock);
 	unsigned long flags;
 
 	/*
@@ -934,8 +931,7 @@ void scsi_adjust_queue_depth(struct scsi
 	if (tags <= 0)
 		return;
 
-	spin_lock_irqsave(&device_request_lock, flags);
-	spin_lock(sdev->request_queue->queue_lock);
+	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 
 	/* Check to see if the queue is managed by the block layer
 	 * if it is, and we fail to adjust the depth, exit */
@@ -964,8 +960,7 @@ void scsi_adjust_queue_depth(struct scsi
 			break;
 	}
  out:
-	spin_unlock(sdev->request_queue->queue_lock);
-	spin_unlock_irqrestore(&device_request_lock, flags);
+	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 }
 EXPORT_SYMBOL(scsi_adjust_queue_depth);
 

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain

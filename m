From: Christoph Hellwig <hch@infradead.org>
Subject: Re: blk-mq problem on proliant DL380 G3 (cciss)
Date: Mon, 3 Nov 2014 02:08:16 -0800
Message-ID: <20141103100816.GA16752@infradead.org>
References: <alpine.LRH.2.11.1410291233090.12885@adalberg.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36739 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaKCKIR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Nov 2014 05:08:17 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1410291233090.12885@adalberg.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>

Meelis,

can you give the patch below a try?  This only tries to locked the door
on devices that actually were reset. Given that on a reset device we
fail all commands before resuming operations it should work fine there
as all tags should be released.

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index fa7b5ec..7af43cb 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2016,8 +2016,10 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
 	 * is no point trying to lock the door of an off-line device.
 	 */
 	shost_for_each_device(sdev, shost) {
-		if (scsi_device_online(sdev) && sdev->locked)
+		if (scsi_device_online(sdev) && sdev->was_reset && sdev->locked) {
 			scsi_eh_lock_door(sdev);
+			sdev->was_reset = 0;
+		}
 	}
 
 	/*

From: Christoph Hellwig <hch@lst.de>
Subject: scsi: only re-lock door after EH on devices that were reset
Date: Mon, 3 Nov 2014 19:36:40 +0100
Message-ID: <20141103183640.GA6718@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49657 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbaKCSgo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Nov 2014 13:36:44 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Meelis Roos <meelis.roos@ut.ee>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>

Setups that use the blk-mq I/O path can lock up if a host with a single
device that has its door locked enters EH.  Make sure to only send the
command to re-lock the door to devices that actually were reset and thus
might have lost their state.  Otherwise the EH code might be get blocked
on blk_get_request as all requests for non-reset devices might be in use.

Cc: stable@vger.kernel.org
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Meelis Roos <meelis.roos@ut.ee>
Tested-by: Meelis Roos <meelis.roos@ut.ee>

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

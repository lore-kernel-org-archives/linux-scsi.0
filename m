From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 12207] block reads/writes > 122880 bytes to USB tape
	drive gives EBUSY
Date: Tue, 23 Dec 2008 09:33:07 -0600
Message-ID: <1230046387.3461.10.camel@localhost.localdomain>
References: <20081223135938.30266108042@picon.linux-foundation.org>
	 <1230044124.3461.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60185 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966AbYLWPdK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Dec 2008 10:33:10 -0500
In-Reply-To: <1230044124.3461.1.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Tue, 2008-12-23 at 08:55 -0600, James Bottomley wrote:
> > ------- Comment #6 from stern@rowland.harvard.edu  2008-12-23 05:59 -------
> > You can change the max_sectors setting through sysfs.  However the last time I
> > looked, the block layer limited max_sectors to 512 KB or something on that
> > order, so you can't get too much improvement.
> > 
> > Why is a limit of 120 KB unreasonably small?  All it means is that you have to
> > use more system calls to transfer the same amount of data.  Is anything wrong
> > with that?
> 
> Tapes need large block sizes.
> 
> We can accommodate both:  Just check for TYPE_TAPE in the
> slave_configure() and bump the limit back up.  Any USB tape that doesn't
> do large block transfers will be truly broken.

Following up on this, does this fix it?

I notice that Linus was the one who actually committed this change in
2.6.0-test10, so it's been in the entire 2.6 release.

James

---

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 09779f6..ae4b01c 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -127,7 +127,12 @@ static int slave_configure(struct scsi_device *sdev)
 		if (sdev->request_queue->max_sectors > max_sectors)
 			blk_queue_max_sectors(sdev->request_queue,
 					      max_sectors);
-	}
+	} else if (sdev->type == TYPE_TAPE)
+		/* Tapes need much higher max sector transfers, so just
+		 * raise it to the maximum possible and let the queue
+		 * segment size sort out the real limit
+		 */
+		blk_queue_max_sectors(sdev->request_queue, 0xFFFF);
 
 	/* We can't put these settings in slave_alloc() because that gets
 	 * called before the device type is known.  Consequently these



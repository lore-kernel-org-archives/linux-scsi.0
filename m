From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive gives EBUSY
Date: Tue, 23 Dec 2008 07:33:46 -0800 (PST)
Message-ID: <20081223153347.03658108047@picon.linux-foundation.org>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963AbYLWPeT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Dec 2008 10:34:19 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBNFXlvp019540
	for <linux-scsi@vger.kernel.org>; Tue, 23 Dec 2008 07:33:48 -0800
In-Reply-To: <bug-12207-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12207





------- Comment #12 from anonymous@kernel-bugs.osdl.org  2008-12-23 07:33 -------
Reply-To: James.Bottomley@HansenPartnership.com

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
-       }
+       } else if (sdev->type == TYPE_TAPE)
+               /* Tapes need much higher max sector transfers, so just
+                * raise it to the maximum possible and let the queue
+                * segment size sort out the real limit
+                */
+               blk_queue_max_sectors(sdev->request_queue, 0xFFFF);

        /* We can't put these settings in slave_alloc() because that gets
         * called before the device type is known.  Consequently these


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

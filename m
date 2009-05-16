From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] scsi_error: fix scsi_eh_lock_door() documentation
Date: Sat, 16 May 2009 21:26:21 +0200
Message-ID: <200905162126.22659.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56992 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbZEPTWL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 May 2009 15:22:11 -0400
Received: by ewy24 with SMTP id 24so3212246ewy.37
        for <linux-scsi@vger.kernel.org>; Sat, 16 May 2009 12:22:11 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

Nowadays eh_lock_door_done() uses blk_get_request() instead of
scsi_allocate_request().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
on top of linux-next

 drivers/scsi/scsi_error.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: b/drivers/scsi/scsi_error.c
===================================================================
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1451,7 +1451,7 @@ static void eh_lock_door_done(struct req
  * @sdev:	SCSI device to prevent medium removal
  *
  * Locking:
- * 	We must be called from process context; scsi_allocate_request()
+ * 	We must be called from process context; blk_get_request()
  * 	may sleep.
  *
  * Notes:
@@ -1459,11 +1459,11 @@ static void eh_lock_door_done(struct req
  * 	head of the devices request queue, and continue.
  *
  * Bugs:
- * 	scsi_allocate_request() may sleep waiting for existing requests to
+ * 	blk_get_request() may sleep waiting for existing requests to
  * 	be processed.  However, since we haven't kicked off any request
  * 	processing for this host, this may deadlock.
  *
- *	If scsi_allocate_request() fails for what ever reason, we
+ *	If blk_get_request() fails for what ever reason, we
  *	completely forget to lock the door.
  */
 static void scsi_eh_lock_door(struct scsi_device *sdev)

From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Last SCSI bug fix for 2.6.21
Date: Sat, 14 Apr 2007 09:45:32 -0500
Message-ID: <1176561932.3709.15.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:53114 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030890AbXDNOpm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Apr 2007 10:45:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

After some investigation, there turned out only to be one, so this is
the final bug fix I have in SCSI.

It's in

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

but since there's only one, I also attach it below.

James

----
>From 6e3b2bbb197eb12b2bef35bcf2ac3bd6a5facab2 Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@steeleye.com>
Date: Fri, 6 Apr 2007 11:14:56 -0500
Subject: [SCSI] 3w-xxxx: fix oops caused by incorrect REQUEST_SENSE handling

3w-xxxx emulates a REQUEST_SENSE response by simply returning nothing.
Unfortunately, it's assuming that the REQUEST_SENSE command is
implemented with use_sg == 0, which is no longer the case.  The oops
occurs because it's clearing the scatterlist in request_buffer instead
of the memory region.

This is fixed by using tw_transfer_internal() to transfer correctly to
the scatterlist.

Acked-by: adam radford <aradford@gmail.com>
Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
---
 drivers/scsi/3w-xxxx.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index bf5d63e..656bdb1 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1864,10 +1864,17 @@ static int tw_scsiop_read_write(TW_Device_Extension *tw_dev, int request_id)
 /* This function will handle the request sense scsi command */
 static int tw_scsiop_request_sense(TW_Device_Extension *tw_dev, int request_id)
 {
+	char request_buffer[18];
+
 	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_request_sense()\n");
 
-	/* For now we just zero the request buffer */
-	memset(tw_dev->srb[request_id]->request_buffer, 0, tw_dev->srb[request_id]->request_bufflen);
+	memset(request_buffer, 0, sizeof(request_buffer));
+	request_buffer[0] = 0x70; /* Immediate fixed format */
+	request_buffer[7] = 10;	/* minimum size per SPC: 18 bytes */
+	/* leave all other fields zero, giving effectively NO_SENSE return */
+	tw_transfer_internal(tw_dev, request_id, request_buffer,
+			     sizeof(request_buffer));
+
 	tw_dev->state[request_id] = TW_S_COMPLETED;
 	tw_state_request_finish(tw_dev, request_id);
 
-- 
1.5.0.6




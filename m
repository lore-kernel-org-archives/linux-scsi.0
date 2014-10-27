From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/6] st: call scsi_set_medium_removal directly
Date: Mon, 27 Oct 2014 18:59:04 +0100
Message-ID: <1414432746-12888-5-git-send-email-hch@lst.de>
References: <1414432746-12888-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48705 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbaJ0QxJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2014 12:53:09 -0400
In-Reply-To: <1414432746-12888-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/st.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 7270e3f..f501e5a 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -860,17 +860,16 @@ static int set_mode_densblk(struct scsi_tape * STp, struct st_modedef * STm)
 /* Lock or unlock the drive door. Don't use when st_request allocated. */
 static int do_door_lock(struct scsi_tape * STp, int do_lock)
 {
-	int retval, cmd;
+	int retval;
 
-	cmd = do_lock ? SCSI_IOCTL_DOORLOCK : SCSI_IOCTL_DOORUNLOCK;
 	DEBC_printk(STp, "%socking drive door.\n", do_lock ? "L" : "Unl");
-	retval = scsi_ioctl(STp->device, cmd, NULL);
-	if (!retval) {
+
+	retval = scsi_set_medium_removal(STp->device,
+			do_lock ? SCSI_REMOVAL_PREVENT : SCSI_REMOVAL_ALLOW);
+	if (!retval)
 		STp->door_locked = do_lock ? ST_LOCKED_EXPLICIT : ST_UNLOCKED;
-	}
-	else {
+	else
 		STp->door_locked = ST_LOCK_FAILS;
-	}
 	return retval;
 }
 
-- 
1.9.1


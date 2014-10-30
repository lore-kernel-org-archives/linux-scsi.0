From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/6] osst: call scsi_set_medium_removal directly
Date: Thu, 30 Oct 2014 10:27:08 +0100
Message-ID: <1414661229-15199-6-git-send-email-hch@lst.de>
References: <1414661229-15199-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50950 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758507AbaJ3J1A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 05:27:00 -0400
In-Reply-To: <1414661229-15199-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/osst.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index b6d63d6..8c38464 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -3327,19 +3327,18 @@ static int osst_write_frame(struct osst_tape * STp, struct osst_request ** aSRpn
 /* Lock or unlock the drive door. Don't use when struct osst_request allocated. */
 static int do_door_lock(struct osst_tape * STp, int do_lock)
 {
-	int retval, cmd;
+	int retval;
 
-	cmd = do_lock ? SCSI_IOCTL_DOORLOCK : SCSI_IOCTL_DOORUNLOCK;
 #if DEBUG
 	printk(OSST_DEB_MSG "%s:D: %socking drive door.\n", tape_name(STp), do_lock ? "L" : "Unl");
 #endif
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


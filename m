From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] lk2.5.53 ide-scsi
Date: Tue, 24 Dec 2002 20:03:55 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E0822FB.4070001@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090200070500000005010200"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: wrlk@riede.org

This is a multi-part message in MIME format.
--------------090200070500000005010200
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Willem's main ide-scsi patch got into lk 2.5.53 but not
his rev1.patch (oops on reset). It is re-packaged as the 
ide-scsi_2553wr2.diff attachment. His patch to cleanly
unregister sysfs entries didn't make it into
drivers/ide/ide.c so it is attached as well.

Doug Gilbert

--------------090200070500000005010200
Content-Type: text/plain;
 name="ide-scsi_2553wr2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ide-scsi_2553wr2.diff"

--- linux/drivers/scsi/ide-scsi.c	2002-12-24 18:12:54.000000000 +1100
+++ linux/drivers/scsi/ide-scsi.c2553wr2	2002-12-24 09:30:17.000000000 +1100
@@ -289,6 +289,7 @@
 	pc->timeout = jiffies + WAIT_READY;
 	/* NOTE! Save the failed packet command in "rq->buffer" */
 	rq->buffer = (void *) failed_command->special;
+	pc->scsi_cmd = ((idescsi_pc_t *) failed_command->special)->scsi_cmd;
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
 		printk ("ide-scsi: %s: queue cmd = ", drive->name);
 		hexdump(pc->c, 6);
@@ -876,7 +877,8 @@
 			/* is cmd active?
 			 *  need to lock so this stuff doesn't change under us */
 			spin_lock_irqsave(&ide_lock, flags);
-			if (scsi->pc && scsi->pc->scsi_cmd->serial_number == cmd->serial_number) {
+			if (scsi->pc && scsi->pc->scsi_cmd && 
+					scsi->pc->scsi_cmd->serial_number == cmd->serial_number) {
 				/* yep - let's give it some more time - 
 				 * we can do that, we're in _our_ error kernel thread */
 				spin_unlock_irqrestore(&ide_lock, flags);

--------------090200070500000005010200
Content-Type: text/plain;
 name="ide_2552_wr1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ide_2552_wr1.diff"

--- linux/drivers/ide/ide.c	2002-12-10 17:38:28.000000000 +1100
+++ linux/drivers/ide/ide.c2552willem	2002-12-24 09:10:25.000000000 +1100
@@ -2314,6 +2314,8 @@
 {
 	ide_drive_t *drive;
 
+	driver_unregister(&driver->gen_driver);
+
 	spin_lock(&drivers_lock);
 	list_del(&driver->drivers);
 	spin_unlock(&drivers_lock);

--------------090200070500000005010200--


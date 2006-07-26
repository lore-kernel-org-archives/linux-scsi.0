From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix compile regression for a few scsi drivers
Date: Wed, 26 Jul 2006 09:53:23 +0200
Message-ID: <20060726075323.GA28526@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:46490 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964789AbWGZHyA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Jul 2006 03:54:00 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@osdl.org, jejb@steeleye.com, davem@davemloft.net
Cc: linux-scsi@vger.kernel.org

This fixes three drivers to compile again after my patch that removes
the data_cmnd member from struct scsi_cmnd.

The fas216 change is trivial, it should have been using ->cmnd all the
time.

esp and NCR53C9 which seem to be mostly duplicate drivers (!) are doing
something odd, they should only have looked at ->cmnd before not the
saved copy that is kept for the error handlers sake.   Note that they
really should deal with the sync setting themselves but use the generic
domain validation code that get this right - but that's for later let's
push this simple compile fix for now.

And sorrt for the late fix for this, I have been busy with OLS and
associated activities last week.


Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/drivers/scsi/NCR53C9x.c b/drivers/scsi/NCR53C9x.c
index 085db48..bdc6bb2 100644
--- a/drivers/scsi/NCR53C9x.c
+++ b/drivers/scsi/NCR53C9x.c
@@ -2152,29 +2152,23 @@ static int esp_do_data_finale(struct NCR
  */
 static int esp_should_clear_sync(Scsi_Cmnd *sp)
 {
-	unchar cmd1 = sp->cmnd[0];
-	unchar cmd2 = sp->data_cmnd[0];
+	unchar cmd = sp->cmnd[0];
 
 	/* These cases are for spinning up a disk and
 	 * waiting for that spinup to complete.
 	 */
-	if(cmd1 == START_STOP ||
-	   cmd2 == START_STOP)
+	if(cmd == START_STOP)
 		return 0;
 
-	if(cmd1 == TEST_UNIT_READY ||
-	   cmd2 == TEST_UNIT_READY)
+	if(cmd == TEST_UNIT_READY)
 		return 0;
 
 	/* One more special case for SCSI tape drives,
 	 * this is what is used to probe the device for
 	 * completion of a rewind or tape load operation.
 	 */
-	if(sp->device->type == TYPE_TAPE) {
-		if(cmd1 == MODE_SENSE ||
-		   cmd2 == MODE_SENSE)
-			return 0;
-	}
+	if(sp->device->type == TYPE_TAPE && cmd == MODE_SENSE)
+		return 0;
 
 	return 1;
 }
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 3e1053f..4cf7afc 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2427,7 +2427,7 @@ int fas216_eh_abort(Scsi_Cmnd *SCpnt)
 	info->stats.aborts += 1;
 
 	printk(KERN_WARNING "scsi%d: abort command ", info->host->host_no);
-	__scsi_print_command(SCpnt->data_cmnd);
+	__scsi_print_command(SCpnt->cmnd);
 
 	print_debug_list();
 	fas216_dumpstate(info);
diff --git a/drivers/scsi/esp.c b/drivers/scsi/esp.c
index eaf64c7..c5a8760 100644
--- a/drivers/scsi/esp.c
+++ b/drivers/scsi/esp.c
@@ -2754,29 +2754,22 @@ static int esp_do_data_finale(struct esp
  */
 static int esp_should_clear_sync(struct scsi_cmnd *sp)
 {
-	u8 cmd1 = sp->cmnd[0];
-	u8 cmd2 = sp->data_cmnd[0];
+	u8 cmd = sp->cmnd[0];
 
 	/* These cases are for spinning up a disk and
 	 * waiting for that spinup to complete.
 	 */
-	if (cmd1 == START_STOP ||
-	    cmd2 == START_STOP)
+	if (cmd == START_STOP)
 		return 0;
-
-	if (cmd1 == TEST_UNIT_READY ||
-	    cmd2 == TEST_UNIT_READY)
+	if (cmd == TEST_UNIT_READY)
 		return 0;
 
 	/* One more special case for SCSI tape drives,
 	 * this is what is used to probe the device for
 	 * completion of a rewind or tape load operation.
 	 */
-	if (sp->device->type == TYPE_TAPE) {
-		if (cmd1 == MODE_SENSE ||
-		    cmd2 == MODE_SENSE)
-			return 0;
-	}
+	if (sp->device->type == TYPE_TAPE && cmd == MODE_SENSE)
+		return 0;
 
 	return 1;
 }

From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] libata: improve FORMAT UNIT; minor code cleanups
Date: Fri, 21 Sep 2007 07:26:56 -0400
Message-ID: <20070921112656.GA20981@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:46776 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbXIUL04 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Sep 2007 07:26:56 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org


commit ee67edb0e7701f8ae9114692837a8bbee9f99a35
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Sep 21 07:26:08 2007 -0400

    [libata] SCSI: improve FORMAT UNIT; minor code cleanups
    
    * SAT specifies that FORMAT UNIT should be translated into a series
      of READ and WRITE commands that zero the ATA device.  That is far too
      cumbersome to bother with.
    
      Since we don't actually format the device, the old behavior of
      always returning success was inaccurate.  Change FORMAT UNIT from
      returning success immediately (old behavior) to always returning
      an error (new behavior).
    
    * Add some comments around SYNCHRONIZE CACHE
    
    * Shuffle scsi command code around a bit, so that things are close
      to alphabetic order.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/ata/libata-scsi.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

ee67edb0e7701f8ae9114692837a8bbee9f99a35
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 456b75f..cd192c1 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2961,13 +2961,9 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 	args.done = done;
 
 	switch(scsicmd[0]) {
-		/* no-op's, complete with success */
-		case SYNCHRONIZE_CACHE:
-		case REZERO_UNIT:
-		case SEEK_6:
-		case SEEK_10:
-		case FORMAT_UNIT:		/* FIXME: correct? */
-			ata_scsi_rbuf_fill(&args, ata_scsiop_noop);
+		/* TODO: worth improving? */
+		case FORMAT_UNIT:
+			ata_scsi_invalid_field(cmd, done);
 			break;
 
 		case INQUIRY:
@@ -3025,6 +3021,19 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 			done(cmd);
 			break;
 
+		/* if we reach this, then writeback caching is disabled,
+		 * turning this into a no-op.
+		 */
+		case SYNCHRONIZE_CACHE:
+			/* fall through */
+
+		/* no-op's, complete with success */
+		case REZERO_UNIT:
+		case SEEK_6:
+		case SEEK_10:
+			ata_scsi_rbuf_fill(&args, ata_scsiop_noop);
+			break;
+
 		case SEND_DIAGNOSTIC:
 			tmp8 = scsicmd[1] & ~(1 << 3);
 			if ((tmp8 == 0x4) && (!scsicmd[3]) && (!scsicmd[4]))

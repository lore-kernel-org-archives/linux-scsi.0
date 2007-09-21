From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] libata: slightly improved req-sense, send-diag no-ops
Date: Fri, 21 Sep 2007 06:24:24 -0400
Message-ID: <20070921102424.GA17675@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


commit 8a7a20fb60d9746ec68a876aade1f14c4f2b7b46
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Sep 21 06:23:42 2007 -0400

    [libata] Slightly improved no-op REQUEST SENSE, SEND DIAGNOSTIC
    
    A few pedantic apps care about missing or lame "mandatory" SCSI
    commands, so
    
    REQUEST SENSE -- as we autosense, R.S. just returns zeroes
    
    SEND DIAGNOSTIC -- our default (no-op) self-test succeeds, all
    		   other requests for testing fail.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/ata/libata-scsi.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

8a7a20fb60d9746ec68a876aade1f14c4f2b7b46
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index bb5a5c1..dbe8ac3 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2922,6 +2922,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 {
 	struct ata_scsi_args args;
 	const u8 *scsicmd = cmd->cmnd;
+	u8 tmp8;
 
 	args.dev = dev;
 	args.id = dev->id;
@@ -2936,7 +2937,6 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 		case SEEK_10:
 		case TEST_UNIT_READY:
 		case FORMAT_UNIT:		/* FIXME: correct? */
-		case SEND_DIAGNOSTIC:		/* FIXME: correct? */
 			ata_scsi_rbuf_fill(&args, ata_scsiop_noop);
 			break;
 
@@ -2989,8 +2989,19 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 			ata_scsi_rbuf_fill(&args, ata_scsiop_report_luns);
 			break;
 
-		/* mandatory commands we haven't implemented yet */
 		case REQUEST_SENSE:
+			ata_scsi_set_sense(cmd, 0, 0, 0);
+			cmd->result = (DRIVER_SENSE << 24);
+			done(cmd);
+			break;
+
+		case SEND_DIAGNOSTIC:
+			tmp8 = scsicmd[1] & ~(1 << 3);
+			if ((tmp8 == 0x4) && (!scsicmd[3]) && (!scsicmd[4]))
+				ata_scsi_rbuf_fill(&args, ata_scsiop_noop);
+			else
+				ata_scsi_invalid_field(cmd, done);
+			break;
 
 		/* all other commands */
 		default:

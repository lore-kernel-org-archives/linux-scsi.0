From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] libata: translate INQUIRY VPD page 89h (ATA info)
Date: Fri, 21 Sep 2007 05:48:25 -0400
Message-ID: <20070921094825.GA15940@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


commit a6d5ac6a3a1cfbed2a045928bbadd5285f1df084
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Sep 21 05:07:19 2007 -0400

    [libata] SCSI: support INQUIRY page 89h (ATA info page)
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/ata/libata-scsi.c |   82 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 78 insertions(+), 4 deletions(-)

a6d5ac6a3a1cfbed2a045928bbadd5285f1df084
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 7ad046b..bb5a5c1 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1804,6 +1804,71 @@ unsigned int ata_scsiop_inq_83(struct ata_scsi_args *args, u8 *rbuf,
 }
 
 /**
+ *	ata_scsiop_inq_89 - Simulate INQUIRY VPD page 89, ATA info
+ *	@args: device IDENTIFY data / SCSI command of interest.
+ *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
+ *	@buflen: Response buffer length.
+ *
+ *	Yields SAT-specified ATA VPD page.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+
+unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf,
+			      unsigned int buflen)
+{
+	struct ata_device *dev = args->dev;
+	u8 pbuf[60];
+	bool is_atapi = (dev->class == ATA_DEV_ATAPI);
+	struct ata_taskfile tf;
+	unsigned int i;
+
+	if (!buflen)
+		return 0;
+
+	memset(&pbuf, 0, sizeof(pbuf));
+	memset(&tf, 0, sizeof(tf));
+
+	if (is_atapi)
+		pbuf[0] = 0x5;	/* FIXME: hardcodes MMC */
+
+	pbuf[1] = 0x89;			/* our page code */
+	pbuf[2] = (0x238 >> 8);		/* page size fixed at 238h */
+	pbuf[3] = (0x238 & 0xff);
+
+	memcpy(&pbuf[8], "ATA     ", 8);
+	ata_id_string(args->id, &pbuf[16], ATA_ID_PROD, 16);
+	ata_id_string(args->id, &pbuf[32], ATA_ID_FW_REV, 4);
+
+	/* we don't store the ATA/ATAPI device signature, so we fake it */
+	if (is_atapi) {
+		tf.command = ATA_CMD_ID_ATAPI;
+		tf.lbam = 0x14;
+		tf.lbah = 0xeb;
+	} else {
+		tf.command = ATA_CMD_ID_ATA;
+	}
+	tf.lbal = 0x1;
+	tf.nsect = 0x1;
+
+	/* FIXME: PMP. don't use H2D Reg FIS. */
+	ata_tf_to_fis(&tf, 0, 1, &pbuf[36]);
+
+	pbuf[56] = tf.command;
+
+	i = min(buflen, 60U);
+	memcpy(rbuf, &pbuf[0], i);
+	buflen -= i;
+
+	if (!i)
+		return 0;
+
+	memcpy(&rbuf[60], &args->id[0], min(buflen, 512U));
+	return 0;
+}
+
+/**
  *	ata_scsiop_noop - Command handler that simply returns success.
  *	@args: device IDENTIFY data / SCSI command of interest.
  *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
@@ -2880,14 +2945,23 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 				ata_scsi_invalid_field(cmd, done);
 			else if ((scsicmd[1] & 1) == 0)    /* is EVPD clear? */
 				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_std);
-			else if (scsicmd[2] == 0x00)
+			else switch (scsicmd[2]) {
+			case 0x00:
 				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_00);
-			else if (scsicmd[2] == 0x80)
+				break;
+			case 0x80:
 				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_80);
-			else if (scsicmd[2] == 0x83)
+				break;
+			case 0x83:
 				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_83);
-			else
+				break;
+			case 0x89:
+				ata_scsi_rbuf_fill(&args, ata_scsiop_inq_89);
+				break;
+			default:
 				ata_scsi_invalid_field(cmd, done);
+				break;
+			}
 			break;
 
 		case MODE_SENSE:

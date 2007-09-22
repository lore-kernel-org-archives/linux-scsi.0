From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH v2] libata: translate INQUIRY VPD page 89h (ATA info)
Date: Fri, 21 Sep 2007 20:54:44 -0400
Message-ID: <20070922005444.GA29744@havoc.gtf.org>
References: <20070921094825.GA15940@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070921094825.GA15940@havoc.gtf.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Ditched ATAPI, fixed a bug, a few clean-ups and fixmes taken care of.


commit a1c69f03a85fe6fa1b7f2f3726dd7205eb68a328
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Sep 21 20:38:03 2007 -0400

    [libata] SCSI: support INQUIRY page 89h (ATA info page)
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/ata/libata-scsi.c |   72 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 68 insertions(+), 4 deletions(-)

a1c69f03a85fe6fa1b7f2f3726dd7205eb68a328
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 7ad046b..b399662 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1804,6 +1804,61 @@ unsigned int ata_scsiop_inq_83(struct ata_scsi_args *args, u8 *rbuf,
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
+	u8 pbuf[60];
+	struct ata_taskfile tf;
+	unsigned int i;
+
+	if (!buflen)
+		return 0;
+
+	memset(&pbuf, 0, sizeof(pbuf));
+	memset(&tf, 0, sizeof(tf));
+
+	pbuf[1] = 0x89;			/* our page code */
+	pbuf[2] = (0x238 >> 8);		/* page size fixed at 238h */
+	pbuf[3] = (0x238 & 0xff);
+
+	memcpy(&pbuf[8], "ATA     ", 8);
+	ata_id_string(args->id, &pbuf[16], ATA_ID_PROD, 16);
+	ata_id_string(args->id, &pbuf[32], ATA_ID_FW_REV, 4);
+
+	/* we don't store the ATA device signature, so we fake it */
+
+	tf.command = ATA_DRDY;		/* really, this is Status reg */
+	tf.lbal = 0x1;
+	tf.nsect = 0x1;
+
+	ata_tf_to_fis(&tf, 0, 1, &pbuf[36]);	/* TODO: PMP? */
+	pbuf[36] = 0x34;		/* force D2H Reg FIS (34h) */
+
+	pbuf[56] = ATA_CMD_ID_ATA;
+
+	i = min(buflen, 60U);
+	memcpy(rbuf, &pbuf[0], i);
+	buflen -= i;
+
+	if (!buflen)
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
@@ -2880,14 +2935,23 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
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

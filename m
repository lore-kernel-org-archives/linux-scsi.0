From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/14] libata-scsi: set bit pointer for sense code information
Date: Mon,  4 Apr 2016 11:44:06 +0200
Message-ID: <1459763047-125551-14-git-send-email-hare@suse.de>
References: <1459763047-125551-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59378 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755045AbcDDJoY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2016 05:44:24 -0400
In-Reply-To: <1459763047-125551-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When generating a sense code of 'Invalid field in CDB' we
should be setting the bit pointer where appropriate.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/ata/libata-scsi.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 30ae9a8..d72d78d 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -301,12 +301,12 @@ void ata_scsi_set_sense_information(struct ata_device *dev,
 }
 
 static void ata_scsi_set_invalid_field(struct ata_device *dev,
-				       struct scsi_cmnd *cmd, u16 field)
+				       struct scsi_cmnd *cmd, u16 field, u8 bit)
 {
 	ata_scsi_set_sense(dev, cmd, ILLEGAL_REQUEST, 0x24, 0x0);
 	/* "Invalid field in cbd" */
 	scsi_set_sense_field_pointer(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
-				     field, 0xff, 1);
+				     field, bit, 1);
 }
 
 static ssize_t
@@ -399,7 +399,7 @@ EXPORT_SYMBOL_GPL(ata_common_sdev_attrs);
 static void ata_scsi_invalid_field(struct ata_device *dev,
 				   struct scsi_cmnd *cmd, u16 field)
 {
-	ata_scsi_set_invalid_field(dev, cmd, field);
+	ata_scsi_set_invalid_field(dev, cmd, field, 0xff);
 	cmd->scsi_done(cmd);
 }
 
@@ -1395,6 +1395,7 @@ static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
 	struct ata_taskfile *tf = &qc->tf;
 	const u8 *cdb = scmd->cmnd;
 	u16 fp;
+	u8 bp = 0xff;
 
 	if (scmd->cmd_len < 5) {
 		fp = 4;
@@ -1408,10 +1409,12 @@ static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
 	}
 	if (cdb[4] & 0x2) {
 		fp = 4;
+		bp = 1;
 		goto invalid_fld;       /* LOEJ bit set not supported */
 	}
 	if (((cdb[4] >> 4) & 0xf) != 0) {
 		fp = 4;
+		bp = 3;
 		goto invalid_fld;       /* power conditions not supported */
 	}
 
@@ -1459,7 +1462,7 @@ static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
 	return 0;
 
  invalid_fld:
-	ata_scsi_set_invalid_field(qc->dev, scmd, fp);
+	ata_scsi_set_invalid_field(qc->dev, scmd, fp, bp);
 	return 1;
  skip:
 	scmd->result = SAM_STAT_GOOD;
@@ -1704,7 +1707,7 @@ static unsigned int ata_scsi_verify_xlat(struct ata_queued_cmd *qc)
 	return 0;
 
 invalid_fld:
-	ata_scsi_set_invalid_field(qc->dev, scmd, fp);
+	ata_scsi_set_invalid_field(qc->dev, scmd, fp, 0xff);
 	return 1;
 
 out_of_range:
@@ -1813,7 +1816,7 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 		goto out_of_range;
 	/* treat all other errors as -EINVAL, fall through */
 invalid_fld:
-	ata_scsi_set_invalid_field(qc->dev, scmd, fp);
+	ata_scsi_set_invalid_field(qc->dev, scmd, fp, 0xff);
 	return 1;
 
 out_of_range:
@@ -2470,7 +2473,7 @@ static unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf)
 	};
 	u8 pg, spg;
 	unsigned int ebd, page_control, six_byte;
-	u8 dpofua;
+	u8 dpofua, bp = 0xff;
 	u16 fp;
 
 	VPRINTK("ENTER\n");
@@ -2491,6 +2494,7 @@ static unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf)
 		goto saving_not_supp;
 	default:
 		fp = 2;
+		bp = 6;
 		goto invalid_fld;
 	}
 
@@ -2560,7 +2564,7 @@ static unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf)
 	return 0;
 
 invalid_fld:
-	ata_scsi_set_invalid_field(dev, args->cmd, fp);
+	ata_scsi_set_invalid_field(dev, args->cmd, fp, bp);
 	return 1;
 
 saving_not_supp:
@@ -3214,7 +3218,7 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 	return 0;
 
  invalid_fld:
-	ata_scsi_set_invalid_field(dev, scmd, fp);
+	ata_scsi_set_invalid_field(dev, scmd, fp, 0xff);
 	return 1;
 }
 
@@ -3229,6 +3233,7 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 	u32 size;
 	void *buf;
 	u16 fp;
+	u8 bp = 0xff;
 
 	/* we may not issue DMA commands if no DMA mode is set */
 	if (unlikely(!dev->dma_mode))
@@ -3243,6 +3248,7 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 	/* for now we only support WRITE SAME with the unmap bit set */
 	if (unlikely(!(cdb[1] & 0x8))) {
 		fp = 1;
+		bp = 3;
 		goto invalid_fld;
 	}
 
@@ -3283,7 +3289,7 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 	return 0;
 
 invalid_fld:
-	ata_scsi_set_invalid_field(dev, scmd, fp);
+	ata_scsi_set_invalid_field(dev, scmd, fp, bp);
 	return 1;
 invalid_param_len:
 	/* "Parameter list length error" */
@@ -3406,6 +3412,7 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 	unsigned six_byte, pg_len, hdr_len, bd_len;
 	int len;
 	u16 fp;
+	u8 bp;
 
 	VPRINTK("ENTER\n");
 
@@ -3431,6 +3438,7 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 	/* We only support PF=1, SP=0.  */
 	if ((cdb[1] & 0x11) != 0x10) {
 		fp = 1;
+		bp = (cdb[1] & 0x01) ? 1 : 5;
 		goto invalid_fld;
 	}
 
@@ -3513,7 +3521,7 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 	return 0;
 
  invalid_fld:
-	ata_scsi_set_invalid_field(qc->dev, scmd, fp);
+	ata_scsi_set_invalid_field(qc->dev, scmd, fp, bp);
 	return 1;
 
  invalid_param:
-- 
1.8.5.6


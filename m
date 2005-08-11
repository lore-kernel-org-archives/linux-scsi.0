From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] TEST UNIT READY SCSI command for libata
Date: Thu, 11 Aug 2005 19:47:36 +1000
Message-ID: <42FB1EB8.5020207@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070304060802000107080303"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:38554 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S932325AbVHKJrk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 05:47:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------070304060802000107080303
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jeff,
This patch is against lk 2.6.13-rc6 + SSU_for_libata
(patch #2 that you requested).

ChangeLog:
   - add TEST UNIT READY SCSI command implementation to
     libata, based on SAT draft revision 5

Signed-off-by: Douglas Gilbert <dougg@torque.net>



--------------070304060802000107080303
Content-Type: text/x-patch;
 name="libata2613rc6_ss_tur.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libata2613rc6_ss_tur.diff"

--- linux/drivers/scsi/libata-scsi.c	2005-08-11 15:41:47.000000000 +1000
+++ linux/drivers/scsi/libata-scsi.c2613rc6sstur	2005-08-06 17:53:08.000000000 +1000
@@ -391,6 +391,32 @@
 }
 
 /**
+ *	ata_scsi_tur_xlat - Translate SCSI TEST UNIT READY command
+ *	@qc: Storage for translated ATA taskfile
+ *	@scsicmd: SCSI command to translate (ignored)
+ *
+ *	Sets up an ATA taskfile to issue CHECK POWER MODE.
+ *	[See SAT revision 5 at www.t10.org]
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host_set lock)
+ *
+ *	RETURNS:
+ *	Zero on success, non-zero on error.
+ */
+
+static unsigned int ata_scsi_tur_xlat(struct ata_queued_cmd *qc, u8 *scsicmd)
+{
+	struct ata_taskfile *tf = &qc->tf;
+
+	tf->flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
+	tf->protocol = ATA_PROT_NODATA;
+	tf->command = ATA_CMD_CHK_POWER;
+
+	return 0;
+}
+
+/**
  *	ata_scsi_start_stop_xlat - Translate SCSI START STOP UNIT command
  *	@qc: Storage for translated ATA taskfile
  *	@scsicmd: SCSI command to translate
@@ -686,7 +712,30 @@
 
 	if (unlikely(drv_stat & (ATA_ERR | ATA_BUSY | ATA_DRQ)))
 		ata_to_sense_error(qc, drv_stat);
-	else
+	else if (cmd->cmnd[0] == TEST_UNIT_READY) {
+		unsigned char *sb = cmd->sense_buffer;
+		struct ata_taskfile resp_tf;
+
+		memset(&resp_tf, 0, sizeof(resp_tf));
+		qc->ap->ops->tf_read(qc->ap, &resp_tf);
+		/* result value in sector count field */
+		if (resp_tf.nsect == 0) {
+			/* standby mode, respond as per sat-r05 */
+			sb[0] = 0x70;
+			sb[2] = NOT_READY;
+			sb[7] = 0x0a;
+			sb[12] = 0x4;	/* Logical unit not ready .. */
+			sb[13] = 0x2;	/* .. initializing command required */
+			cmd->result = SAM_STAT_CHECK_CONDITION;
+		} else if (resp_tf.nsect == 0x80) {
+			/* idle mode */
+			DPRINTK("CHECK POWER MODE reports idle\n");
+			cmd->result = SAM_STAT_GOOD;
+		} else {
+			/* nsect should be 0xff implying active or idle */
+			cmd->result = SAM_STAT_GOOD;
+		}
+	} else
 		cmd->result = SAM_STAT_GOOD;
 
 	qc->scsidone(cmd);
@@ -1488,6 +1537,8 @@
 	case VERIFY:
 	case VERIFY_16:
 		return ata_scsi_verify_xlat;
+	case TEST_UNIT_READY:
+		return ata_scsi_tur_xlat;
 	case START_STOP:
 		return ata_scsi_start_stop_xlat;
 	}
@@ -1600,7 +1651,6 @@
 		case REZERO_UNIT:
 		case SEEK_6:
 		case SEEK_10:
-		case TEST_UNIT_READY:
 		case FORMAT_UNIT:		/* FIXME: correct? */
 		case SEND_DIAGNOSTIC:		/* FIXME: correct? */
 			ata_scsi_rbuf_fill(&args, ata_scsiop_noop);

--------------070304060802000107080303--

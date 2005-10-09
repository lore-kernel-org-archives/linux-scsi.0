From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH 1/3] libata: scsi error handling, encore
Date: Sun, 09 Oct 2005 22:24:46 +1000
Message-ID: <43490C0E.50704@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050600010407070505010203"
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, htejun@gmail.com, russb@emc.com
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------050600010407070505010203
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch is against Jeff's libata-dev git repository,
upstream branch.

Changelog:
  - add extern ata_scsi_set_sense() to build SCSI
    fixed sense data and corresponding SCSI status

Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert



--------------050600010407070505010203
Content-Type: text/x-patch;
 name="libata_err1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libata_err1.diff"

--- linux/drivers/scsi/libata.h	2005-10-08 17:20:02.000000000 +1000
+++ linux/drivers/scsi/libata.h1	2005-10-09 15:46:14.000000000 +1000
@@ -80,6 +80,8 @@
 extern void ata_scsi_badcmd(struct scsi_cmnd *cmd,
 			    void (*done)(struct scsi_cmnd *),
 			    u8 asc, u8 ascq);
+extern void ata_scsi_set_sense(struct scsi_cmnd *cmd,
+			       u8 sk, u8 asc, u8 ascq);
 extern void ata_scsi_rbuf_fill(struct ata_scsi_args *args,
                         unsigned int (*actor) (struct ata_scsi_args *args,
                                            u8 *rbuf, unsigned int buflen));
--- linux/drivers/scsi/libata-scsi.c	2005-10-08 17:20:02.000000000 +1000
+++ linux/drivers/scsi/libata-scsi.c1	2005-10-09 15:46:22.000000000 +1000
@@ -1451,6 +1451,34 @@
 }
 
 /**
+ *	ata_scsi_set_sense - Set SCSI sense data and status
+ *	@cmd: SCSI request to be handled
+ *	@sk: SCSI-defined sense key
+ *	@asc: SCSI-defined additional sense code
+ *	@ascq: SCSI-defined additional sense code qualifier
+ *
+ *	Helper function that builds a valid fixed format, current
+ *	response code and the given sense key (sk), additional sense
+ *	code (asc) and additional sense code qualifier (ascq) with
+ *	a SCSI command status of %SAM_STAT_CHECK_CONDITION and
+ *	DRIVER_SENSE set in the upper bits of scsi_cmnd::result .
+ *
+ *	LOCKING:
+ *	Not required
+ */
+
+void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
+{
+	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+
+	cmd->sense_buffer[0] = 0x70;	/* fixed format, current */
+	cmd->sense_buffer[2] = sk;
+	cmd->sense_buffer[7] = 18 - 8;	/* additional sense length */
+	cmd->sense_buffer[12] = asc;
+	cmd->sense_buffer[13] = ascq;
+}
+
+/**
  *	ata_scsi_badcmd - End a SCSI request with an error
  *	@cmd: SCSI request to be handled
  *	@done: SCSI command completion function


--------------050600010407070505010203--

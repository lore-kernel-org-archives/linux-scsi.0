From: Mark Lord <liml@rtr.ca>
Subject: [PATCH] SCSI, libata: add support for ATA_16 commands to libata ATAPI devices
Date: Tue, 2 Jan 2007 19:35:07 -0500
Message-ID: <200701021935.07840.liml@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Linux IDE <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In an ideal world, we would use the existing ATA_12 opcode
to issue 12-byte ATA passthrough commands for libata ATAPI drives
from userspace.

But ATA_12 happens to have the same SCSI opcode value as the older
CD/RW "BLANK" command, widely used by cdrecord and friends.

So, to achieve ATA passthru capability for libata ATAPI,
we have to instead use the ATA_16 opcode: a 16-byte command.

SCSI normally disallows issuing 16-byte commands to 12-byte devices,
so special support has to be added for this.

Introduce an "allow_ata_16" boolean to the scsi_host struct.
This provides a means for libata to signal that 16-byte ATA_16
commands should be permitted even for 12-byte ATAPI devices.

Signed-off-by:  Mark Lord <mlord@pobox.com>

--- old/include/scsi/scsi_host.h	2007-01-02 19:06:45.000000000 -0500
+++ new/include/scsi/scsi_host.h	2007-01-02 19:09:06.000000000 -0500
@@ -608,6 +608,13 @@
 	unsigned async_scan:1;
 
 	/*
+	 * True for libata, to allow issuing ATA_16 16-byte CDBs
+	 * to (otherwise) 12-byte ATAPI drives.  ATAPI cannot use
+	 * the ATA_12 opcode, because it means "BLANK" to CDRW drives.
+	 */
+	unsigned allow_ata_16:1;
+
+	/*
 	 * Optional work queue to be utilized by the transport
 	 */
 	char work_q_name[KOBJ_NAME_LEN];
--- old/drivers/scsi/scsi.c	2007-01-02 19:06:45.000000000 -0500
+++ new/drivers/scsi/scsi.c	2007-01-02 19:09:06.000000000 -0500
@@ -567,12 +567,17 @@
 	 * length exceeds what the host adapter can handle.
 	 */
 	if (CDB_SIZE(cmd) > cmd->device->host->max_cmd_len) {
-		SCSI_LOG_MLQUEUE(3,
+		/* permit ATA_16 passthru to 12-byte ATAPI devices */
+		if (cmd->cmnd[0]  != ATA_16
+		 || CDB_SIZE(cmd) != 16
+		 || !cmd->device->host->allow_ata_16) {
+			SCSI_LOG_MLQUEUE(3,
 				printk("queuecommand : command too long.\n"));
-		cmd->result = (DID_ABORT << 16);
+			cmd->result = (DID_ABORT << 16);
 
-		scsi_done(cmd);
-		goto out;
+			scsi_done(cmd);
+			goto out;
+		}
 	}
 
 	spin_lock_irqsave(host->host_lock, flags);
--- old/drivers/ata/libata-core.c	2007-01-02 19:06:44.000000000 -0500
+++ new/drivers/ata/libata-core.c	2007-01-02 19:09:06.000000000 -0500
@@ -5686,6 +5686,7 @@
 	shost->max_lun = 1;
 	shost->max_channel = 1;
 	shost->max_cmd_len = 12;
+	shost->allow_ata_16 = 1;
 }
 
 /**

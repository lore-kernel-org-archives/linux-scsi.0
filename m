From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5/7] scsi: Add a report opcode helper
Date: Fri, 16 Mar 2012 14:43:17 -0400
Message-ID: <1331923399-30987-6-git-send-email-martin.petersen@oracle.com>
References: <1331923399-30987-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:51643 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937Ab2CPSni (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Mar 2012 14:43:38 -0400
In-Reply-To: <1331923399-30987-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jaxboe@fusionio.com, jbottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

From: "Martin K. Petersen" <martin.petersen@oracle.com>

The REPORT SUPPORTED OPERATION CODES command can be used to query
whether a given opcode is supported by a device. Add a helper function
that allows us to look up commands.

We only issue RSOC if the device reports compliance with SPC-3 or
later. But to err on the side of caution we disable the command for ATA,
FireWire and USB.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/ata/libata-scsi.c      |    1 +
 drivers/firewire/sbp2.c        |    1 +
 drivers/scsi/scsi.c            |   45 ++++++++++++++++++++++++++++++++++++++++
 drivers/usb/storage/scsiglue.c |    3 ++
 include/scsi/scsi_device.h     |    3 ++
 5 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 508a60b..b6db28f 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1052,6 +1052,7 @@ static void ata_scsi_sdev_config(struct scsi_device *sdev)
 {
 	sdev->use_10_for_rw = 1;
 	sdev->use_10_for_ms = 1;
+	sdev->no_report_opcodes = 1;
 
 	/* Schedule policy is determined by ->qc_defer() callback and
 	 * it needs to see every deferred qc.  Set dev_blocked to 1 to
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 80e95aa..d956dd38 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1517,6 +1517,7 @@ static int sbp2_scsi_slave_configure(struct scsi_device *sdev)
 	struct sbp2_logical_unit *lu = sdev->hostdata;
 
 	sdev->use_10_for_rw = 1;
+	sdev->no_report_opcodes = 1;
 
 	if (sbp2_param_exclusive_login)
 		sdev->manage_start_stop = 1;
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2aeb2e9..8d00214 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -54,6 +54,7 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/mutex.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1063,6 +1064,50 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
 EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
 
 /**
+ * scsi_report_opcode - Find out if a given command opcode is supported
+ * @sdp:	scsi device to query
+ * @buffer:	scratch buffer (must be at least 20 bytes long)
+ * @len:	length of buffer
+ * @opcode:	opcode for command to look up
+ *
+ * Uses the REPORT SUPPORTED OPERATION CODES to look up the given
+ * opcode. Returns 0 if RSOC fails or if the command opcode is
+ * unsupported. Returns 1 if the device claims to support the command.
+ */
+int scsi_report_opcode(struct scsi_device *sdp, unsigned char *buffer,
+		       unsigned int len, unsigned char opcode)
+{
+	unsigned char cmd[16];
+	struct scsi_sense_hdr sshdr;
+	int result;
+
+	if (sdp->no_report_opcodes || sdp->scsi_level < SCSI_SPC_3)
+		return 0;
+
+	memset(cmd, 0, 16);
+	cmd[0] = MAINTENANCE_IN;
+	cmd[1] = MI_REPORT_SUPPORTED_OPERATION_CODES;
+	cmd[2] = 1;		/* One command format */
+	cmd[3] = opcode;
+	put_unaligned_be32(len, &cmd[6]);
+	memset(buffer, 0, len);
+
+	result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE, buffer, len,
+				  &sshdr, 30 * HZ, 3, NULL);
+
+	if (result && scsi_sense_valid(&sshdr) &&
+	    sshdr.sense_key == ILLEGAL_REQUEST &&
+	    (sshdr.asc == 0x20 || sshdr.asc == 0x24) && sshdr.ascq == 0x00)
+		return 0;
+
+	if ((buffer[1] & 3) == 3) /* Command supported */
+		return 1;
+
+	return 0;
+}
+EXPORT_SYMBOL(scsi_report_opcode);
+
+/**
  * scsi_device_get  -  get an additional reference to a scsi_device
  * @sdev:	device to get a reference to
  *
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 13b8bcd..61178b8 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -197,6 +197,9 @@ static int slave_configure(struct scsi_device *sdev)
 		 * page x08, so we will skip it. */
 		sdev->skip_ms_page_8 = 1;
 
+		/* Do not attempt to use REPORT SUPPORTED OPERATION CODES */
+		sdev->no_report_opcodes = 1;
+
 		/* Some disks return the total number of blocks in response
 		 * to READ CAPACITY rather than the highest block number.
 		 * If this device makes that mistake, tell the sd driver. */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 77273f2..59f31dc 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -134,6 +134,7 @@ struct scsi_device {
 				     * because we did a bus reset. */
 	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
+	unsigned no_report_opcodes:1;	/* no REPORT SUPPORTED OPERATION CODES */
 	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */
 	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
 	unsigned use_192_bytes_for_3f:1; /* ask for 192 bytes from page 0x3f */
@@ -354,6 +355,8 @@ extern int scsi_test_unit_ready(struct scsi_device *sdev, int timeout,
 				int retries, struct scsi_sense_hdr *sshdr);
 extern int scsi_get_vpd_page(struct scsi_device *, u8 page, unsigned char *buf,
 			     int buf_len);
+extern int scsi_report_opcode(struct scsi_device *sdp, unsigned char *buffer,
+			      unsigned int len, unsigned char opcode);
 extern int scsi_device_set_state(struct scsi_device *sdev,
 				 enum scsi_device_state state);
 extern struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
-- 
1.7.7.6


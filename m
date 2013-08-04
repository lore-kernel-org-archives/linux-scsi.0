From: Giuliano Pochini <pochini@shiny.it>
Subject: Toshiba USB disk stopped working in 3.10.3
Date: Sun, 4 Aug 2013 23:49:31 +0200
Message-ID: <20130804234931.1d792792@wc1>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:34977 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941Ab3HDVsc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Aug 2013 17:48:32 -0400
Received: from wc1 (82.56.166.137) by smtp205.alice.it (8.6.060.28)
        id 51FA21FE00FA6939 for linux-scsi@vger.kernel.org; Sun, 4 Aug 2013 23:48:30 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

My Toshiba 1TB Stor.e basics does not work anymore since 3.10.3. I have
another USB3 disk which works fine. The kernel keeps writing this stuff in
the logs:

Aug  4 16:11:27 wc1 kernel: [  286.384162] usb 4-4: Successful evaluate context command
Aug  4 16:11:27 wc1 kernel: [  286.495466] usb 4-4: reset SuperSpeed USB device number 2 using xhci_hcd
Aug  4 16:11:27 wc1 kernel: [  286.513937] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880215ea3400
Aug  4 16:11:27 wc1 kernel: [  286.513943] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880215ea3440
Aug  4 16:11:27 wc1 kernel: [  286.514026] usb 4-4: Successful Endpoint Configure command
Aug  4 16:11:27 wc1 kernel: [  286.514203] usb 4-4: Successful evaluate context command
Aug  4 16:11:27 wc1 kernel: [  286.514376] usb 4-4: Successful evaluate context command

and /lib/udev/ata_id stays blocked in D state.

The change that causes the problem (below) looks fine, so I'm not sure reverting it is the right fix.



diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2c0d0ec8..3b1ea34e 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1070,8 +1070,8 @@ EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
  * @opcode:	opcode for command to look up
  *
  * Uses the REPORT SUPPORTED OPERATION CODES to look up the given
- * opcode. Returns 0 if RSOC fails or if the command opcode is
- * unsupported. Returns 1 if the device claims to support the command.
+ * opcode. Returns -EINVAL if RSOC fails, 0 if the command opcode is
+ * unsupported and 1 if the device claims to support the command.
  */
 int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 		       unsigned int len, unsigned char opcode)
@@ -1081,7 +1081,7 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 	int result;
 
 	if (sdev->no_report_opcodes || sdev->scsi_level < SCSI_SPC_3)
-		return 0;
+		return -EINVAL;
 
 	memset(cmd, 0, 16);
 	cmd[0] = MAINTENANCE_IN;
@@ -1097,7 +1097,7 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 	if (result && scsi_sense_valid(&sshdr) &&
 	    sshdr.sense_key == ILLEGAL_REQUEST &&
 	    (sshdr.asc == 0x20 || sshdr.asc == 0x24) && sshdr.ascq == 0x00)
-		return 0;
+		return -EINVAL;
 
 	if ((buffer[1] & 3) == 3) /* Command supported */
 		return 1;


-- 
Giuliano.

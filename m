From: Mark Haverkamp <markh@linux-foundation.org>
Subject: [Patch 2/4] aacraid: expanded expose physical device code
Date: Tue, 23 Jan 2007 14:59:50 -0800
Message-ID: <1169593190.10440.23.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33685 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965575AbXAWW7y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Jan 2007 17:59:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn,

Take the expose_physicals flag and allow the user to select default (physicals
available via /dev/sg), exposed (physicals available via /dev/sd for
experimental reasons) and hidden (physicals blocked from all access). This
expands the functionality of the previous expose_physicals insmod parameter
which was added to support some experimental configurations.

Signed-off-by Mark Haverkamp <markh@linux-foundation.org>
---

--- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	2007-01-18 10:06:55.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	2007-01-18 10:11:26.000000000 -0800
@@ -170,9 +170,9 @@
 module_param(acbsize, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(acbsize, "Request a specific adapter control block (FIB) size. Valid values are 512, 2048, 4096 and 8192. Default is to use suggestion from Firmware.");
 
-int expose_physicals = 0;
+int expose_physicals = -1;
 module_param(expose_physicals, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(expose_physicals, "Expose physical components of the arrays. 0=off, 1=on");
+MODULE_PARM_DESC(expose_physicals, "Expose physical components of the arrays. -1=protect 0=off, 1=on");
 /**
  *	aac_get_config_status	-	check the adapter configuration
  *	@common: adapter to query
@@ -1973,7 +1973,41 @@
 	case SRB_STATUS_ERROR_RECOVERY:
 	case SRB_STATUS_PENDING:
 	case SRB_STATUS_SUCCESS:
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+		if ((scsicmd->cmnd[0] == INQUIRY) && (expose_physicals <= 0)) {
+			u8 b;
+			u8 b1;
+			/* We can't expose disk devices because we can't
+			 * tell whether they are the raw container drives
+			 * or stand alone drives.  If they have the removable
+			 * bit set then we should expose them though.
+			 */
+			b = (*(u8*)scsicmd->request_buffer)&0x1f;
+			b1 = ((u8*)scsicmd->request_buffer)[1];
+			if (b == TYPE_TAPE || b == TYPE_WORM ||
+			    b == TYPE_ROM || b==TYPE_MOD ||
+			    b == TYPE_MEDIUM_CHANGER ||
+			    (b == TYPE_DISK && (b1 & 0x80))) {
+				scsicmd->result = DID_OK << 16 |
+					COMMAND_COMPLETE << 8;
+			/*
+			 * We will allow disk devices if in RAID/SCSI mode and
+			 * the channel is 2
+			 */
+			} else if ((dev->raid_scsi_mode) &&
+					(scmd_channel(scsicmd) == 2)) {
+				scsicmd->result = DID_OK << 16 |
+						COMMAND_COMPLETE << 8;
+			} else if (expose_physicals) {
+				scsicmd->device->no_uld_attach = 1;
+				scsicmd->result = DID_OK << 16 |
+						COMMAND_COMPLETE << 8;
+			} else {
+				scsicmd->result = DID_NO_CONNECT << 16 |
+						COMMAND_COMPLETE << 8;
+			}
+		} else {
+			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+		}
 		break;
 	case SRB_STATUS_DATA_OVERRUN:
 		switch(scsicmd->cmnd[0]){
@@ -1993,7 +2027,41 @@
 			scsicmd->result = DID_ERROR << 16 | COMMAND_COMPLETE << 8;
 			break;
 		case INQUIRY: {
+		if (expose_physicals <= 0) {
+			u8 b;
+			u8 b1;
+			/* We can't expose disk devices because we can't tell
+			 * whether they are the raw container drives or
+			 * stand alone drives
+			 */
+			b = (*(u8*)scsicmd->request_buffer)&0x0f;
+			b1 = ((u8*)scsicmd->request_buffer)[1];
+			if (b == TYPE_TAPE || b == TYPE_WORM ||
+			    b == TYPE_ROM || b == TYPE_MOD ||
+			    b == TYPE_MEDIUM_CHANGER ||
+			    (b == TYPE_DISK && (b1&0x80))) {
+				scsicmd->result = DID_OK << 16 |
+					COMMAND_COMPLETE << 8;
+			/*
+			 * We will allow disk devices if in RAID/SCSI mode and
+			 * the channel is 2
+			 */
+			} else if (((dev->raid_scsi_mode) &&
+					(scmd_channel(scsicmd) == 2)) ||
+					(expose_physicals == 1)) {
+				scsicmd->result = DID_OK << 16 |
+						COMMAND_COMPLETE << 8;
+			} else if (expose_physicals) {
+				scsicmd->device->no_uld_attach = 1;
+				scsicmd->result = DID_OK << 16 |
+						COMMAND_COMPLETE << 8;
+			} else {
+				scsicmd->result = DID_NO_CONNECT << 16 |
+						COMMAND_COMPLETE << 8;
+			}
+		} else {
 			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+		}
 			break;
 		}
 		default:
--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2007-01-18 10:06:55.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2007-01-18 10:11:26.000000000 -0800
@@ -396,7 +396,7 @@
 		sdev->skip_ms_page_3f = 1;
 	}
 	if ((sdev->type == TYPE_DISK) &&
-			!expose_physicals &&
+			(expose_physicals < 0) &&
 			(sdev_channel(sdev) != CONTAINER_CHANNEL)) {
 		struct aac_dev *aac = (struct aac_dev *)sdev->host->hostdata;
 		if (!aac->raid_scsi_mode || (sdev_channel(sdev) != 2))

-- 
Mark Haverkamp <markh@linux-foundation.org>


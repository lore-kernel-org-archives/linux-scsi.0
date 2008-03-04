From: akpm@linux-foundation.org
Subject: [patch (for 2.6.25?) 2/2] scsi: arcmsr: update driver version
Date: Tue, 04 Mar 2008 14:56:25 -0800
Message-ID: <200803042256.m24MuQB1001344@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752324AbYCDW4d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 17:56:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, nick.cheng@areca.com.tw

From: Nick Cheng <nick.cheng@areca.com.tw>

Update the driver version of arcmsr and ChangeLog.arcmsr.

Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/scsi/ChangeLog.arcmsr |    6 ++++++
 drivers/scsi/arcmsr/arcmsr.h        |    2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN Documentation/scsi/ChangeLog.arcmsr~scsi-arcmsr-update-driver-version Documentation/scsi/ChangeLog.arcmsr
--- a/Documentation/scsi/ChangeLog.arcmsr~scsi-arcmsr-update-driver-version
+++ a/Documentation/scsi/ChangeLog.arcmsr
@@ -109,4 +109,10 @@
 **						8.replace pci_alloc_consistent()/pci_free_consistent() with kmalloc()/kfree() in arcmsr_iop_message_xfer()
 **						9. fix the release of dma memory for type B in arcmsr_free_ccb_pool()
 **						10.fix the arcmsr_polling_hbb_ccbdone()
+** 1.20.00.15	02/27/2008	Erich Chen & Nick Cheng
+**						1.arcmsr_iop_message_xfer() is called from atomic context under the
+**						queuecommand scsi_host_template handler. James Bottomley pointed out
+**						that the current GFP_KERNEL|GFP_DMA flags are wrong: firstly we are in
+**						atomic context, secondly this memory is not used for DMA.
+**						Also removed some unneeded casts. Thanks to Daniel Drake <dsd@gentoo.org>
 **************************************************************************
diff -puN drivers/scsi/arcmsr/arcmsr.h~scsi-arcmsr-update-driver-version drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h~scsi-arcmsr-update-driver-version
+++ a/drivers/scsi/arcmsr/arcmsr.h
@@ -48,7 +48,7 @@ struct class_device_attribute;
 /*The limit of outstanding scsi command that firmware can handle*/
 #define ARCMSR_MAX_OUTSTANDING_CMD						256
 #define ARCMSR_MAX_FREECCB_NUM							320
-#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 2007/12/24"
+#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 2008/02/27"
 #define ARCMSR_SCSI_INITIATOR_ID						255
 #define ARCMSR_MAX_XFER_SECTORS							512
 #define ARCMSR_MAX_XFER_SECTORS_B						4096
_

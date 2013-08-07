From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 3/8] [SCSI] dc395x: use NULL instead of 0
Date: Wed, 07 Aug 2013 12:55:24 +0900
Message-ID: <001301ce9321$f2157760$d6406620$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:26614 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab3HGDz0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Aug 2013 23:55:26 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MR500E1H6VHOY40@mailout3.samsung.com> for
 linux-scsi@vger.kernel.org; Wed, 07 Aug 2013 12:55:24 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: 'Oliver Neukum' <oliver@neukum.org>, 'Ali Akcaagac' <aliakc@web.de>, 'Jamie Lenehan' <lenehan@twibble.org>, dc395x@twibble.org, 'James Bottomley' <jejb@kernel.org>, linux-scsi@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>

%p is used, thus NULL should be used instead of 0.
Also, bit maskings are added in order to fix the following
sparse warnings:

drivers/scsi/dc395x.c:1525:17: warning: Using plain integer as NULL pointer
drivers/scsi/dc395x.c:4186:48: warning: cast truncates bits from constant value (1de1 becomes e1)
drivers/scsi/dc395x.c:4188:45: warning: cast truncates bits from constant value (391 becomes 91)
drivers/scsi/dc395x.c:4192:44: warning: cast truncates bits from constant value (1de1 becomes e1)
drivers/scsi/dc395x.c:4194:44: warning: cast truncates bits from constant value (391 becomes 91)

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/dc395x.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index e73445b..3b09c16 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -1526,7 +1526,7 @@ static u8 start_scsi(struct AdapterCtlBlk* acb, struct DeviceCtlBlk* dcb,
 			"command while another command (0x%p) is active.",
 			srb->cmd,
 			acb->active_dcb->active_srb ?
-			    acb->active_dcb->active_srb->cmd : 0);
+			    acb->active_dcb->active_srb->cmd : NULL);
 		return 1;
 	}
 	if (DC395x_read16(acb, TRM_S1040_SCSI_STATUS) & SCSIINTERRUPT) {
@@ -4183,15 +4183,17 @@ static void check_eeprom(struct NvRamType *eeprom, unsigned long io_port)
 		 */
 		dprintkl(KERN_WARNING,
 			"EEProm checksum error: using default values and options.\n");
-		eeprom->sub_vendor_id[0] = (u8)PCI_VENDOR_ID_TEKRAM;
+		eeprom->sub_vendor_id[0] = (u8)(PCI_VENDOR_ID_TEKRAM & 0xff);
 		eeprom->sub_vendor_id[1] = (u8)(PCI_VENDOR_ID_TEKRAM >> 8);
-		eeprom->sub_sys_id[0] = (u8)PCI_DEVICE_ID_TEKRAM_TRMS1040;
+		eeprom->sub_sys_id[0] =
+		    (u8)(PCI_DEVICE_ID_TEKRAM_TRMS1040 & 0xff);
 		eeprom->sub_sys_id[1] =
 		    (u8)(PCI_DEVICE_ID_TEKRAM_TRMS1040 >> 8);
 		eeprom->sub_class = 0x00;
-		eeprom->vendor_id[0] = (u8)PCI_VENDOR_ID_TEKRAM;
+		eeprom->vendor_id[0] = (u8)(PCI_VENDOR_ID_TEKRAM & 0xff);
 		eeprom->vendor_id[1] = (u8)(PCI_VENDOR_ID_TEKRAM >> 8);
-		eeprom->device_id[0] = (u8)PCI_DEVICE_ID_TEKRAM_TRMS1040;
+		eeprom->device_id[0] =
+		    (u8)(PCI_DEVICE_ID_TEKRAM_TRMS1040 & 0xff);
 		eeprom->device_id[1] =
 		    (u8)(PCI_DEVICE_ID_TEKRAM_TRMS1040 >> 8);
 		eeprom->reserved = 0x00;
-- 
1.7.10.4



From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V2 3/8] [SCSI] dc395x: use NULL instead of 0
Date: Thu, 08 Aug 2013 10:15:13 +0900
Message-ID: <002601ce93d4$bbbc1b20$33345160$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:18409 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168Ab3HHBPQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2013 21:15:16 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MR600BWXU5E2PC0@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Thu, 08 Aug 2013 10:15:14 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: 'Oliver Neukum' <oliver@neukum.org>, 'Ali Akcaagac' <aliakc@web.de>, 'Jamie Lenehan' <lenehan@twibble.org>, 'James Bottomley' <jejb@kernel.org>, linux-scsi@vger.kernel.org, 'Julian Calaby' <julian.calaby@gmail.com>, Jingoo Han <jg1.han@samsung.com>

%p is used, thus NULL should be used instead of 0.
Also, __constant_cpu_to_le16() is added in order to fix
the following sparse warnings:

drivers/scsi/dc395x.c:1525:17: warning: Using plain integer as NULL pointer
drivers/scsi/dc395x.c:4186:48: warning: cast truncates bits from constant value (1de1 becomes e1)
drivers/scsi/dc395x.c:4188:45: warning: cast truncates bits from constant value (391 becomes 91)
drivers/scsi/dc395x.c:4192:44: warning: cast truncates bits from constant value (1de1 becomes e1)
drivers/scsi/dc395x.c:4194:44: warning: cast truncates bits from constant value (391 becomes 91)

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- Added __constant_cpu_to_le16() suggested by Oliver Neukum
- Replaced u8 with __le16

 drivers/scsi/dc395x.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index e73445b..3ffdba5 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -200,11 +200,11 @@ struct NVRamTarget {
 };
 
 struct NvRamType {
-	u8 sub_vendor_id[2];	/* 0,1  Sub Vendor ID   */
-	u8 sub_sys_id[2];	/* 2,3  Sub System ID   */
+	__le16 sub_vendor_id;	/* 0,1  Sub Vendor ID   */
+	__le16 sub_sys_id;	/* 2,3  Sub System ID   */
 	u8 sub_class;		/* 4    Sub Class       */
-	u8 vendor_id[2];	/* 5,6  Vendor ID       */
-	u8 device_id[2];	/* 7,8  Device ID       */
+	__le16 vendor_id;	/* 5,6  Vendor ID       */
+	__le16 device_id;	/* 7,8  Device ID       */
 	u8 reserved;		/* 9    Reserved        */
 	struct NVRamTarget target[DC395x_MAX_SCSI_ID];
 						/** 10,11,12,13
@@ -1526,7 +1526,7 @@ static u8 start_scsi(struct AdapterCtlBlk* acb, struct DeviceCtlBlk* dcb,
 			"command while another command (0x%p) is active.",
 			srb->cmd,
 			acb->active_dcb->active_srb ?
-			    acb->active_dcb->active_srb->cmd : 0);
+			    acb->active_dcb->active_srb->cmd : NULL);
 		return 1;
 	}
 	if (DC395x_read16(acb, TRM_S1040_SCSI_STATUS) & SCSIINTERRUPT) {
@@ -4183,17 +4183,15 @@ static void check_eeprom(struct NvRamType *eeprom, unsigned long io_port)
 		 */
 		dprintkl(KERN_WARNING,
 			"EEProm checksum error: using default values and options.\n");
-		eeprom->sub_vendor_id[0] = (u8)PCI_VENDOR_ID_TEKRAM;
-		eeprom->sub_vendor_id[1] = (u8)(PCI_VENDOR_ID_TEKRAM >> 8);
-		eeprom->sub_sys_id[0] = (u8)PCI_DEVICE_ID_TEKRAM_TRMS1040;
-		eeprom->sub_sys_id[1] =
-		    (u8)(PCI_DEVICE_ID_TEKRAM_TRMS1040 >> 8);
+		eeprom->sub_vendor_id =
+			__constant_cpu_to_le16(PCI_VENDOR_ID_TEKRAM);
+		eeprom->sub_sys_id =
+			__constant_cpu_to_le16(PCI_DEVICE_ID_TEKRAM_TRMS1040);
 		eeprom->sub_class = 0x00;
-		eeprom->vendor_id[0] = (u8)PCI_VENDOR_ID_TEKRAM;
-		eeprom->vendor_id[1] = (u8)(PCI_VENDOR_ID_TEKRAM >> 8);
-		eeprom->device_id[0] = (u8)PCI_DEVICE_ID_TEKRAM_TRMS1040;
-		eeprom->device_id[1] =
-		    (u8)(PCI_DEVICE_ID_TEKRAM_TRMS1040 >> 8);
+		eeprom->vendor_id =
+			__constant_cpu_to_le16(PCI_VENDOR_ID_TEKRAM);
+		eeprom->device_id =
+			__constant_cpu_to_le16(PCI_DEVICE_ID_TEKRAM_TRMS1040);
 		eeprom->reserved = 0x00;
 
 		for (d_addr = 0, d_eeprom = (u32 *)eeprom->target;
-- 
1.7.10.4



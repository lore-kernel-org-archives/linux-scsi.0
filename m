From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] 2.6.9 aacraid: Support ROMB RAID/SCSI mode - Resend -
Date: Thu, 18 Nov 2004 09:56:26 -0800
Message-ID: <1100800586.6026.31.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:58794 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S262830AbUKRR4c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2004 12:56:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

James,
This is a resend.  I don't know if this got lost, or is still in your
queue.
-----

Another patch from Mark Salyzyn's driver. Supports correct operation of
ROMB (RAID on motherboard) SCSI/RAID.  Applies to the scsi-misc bk tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

===== drivers/scsi/aacraid/aachba.c 1.29 vs edited =====
--- 1.29/drivers/scsi/aacraid/aachba.c	2004-10-01 08:10:08 -07:00
+++ edited/drivers/scsi/aacraid/aachba.c	2004-10-21 09:53:08 -07:00
@@ -645,9 +645,31 @@
 			dev->adapter_info.serial[1]);
 
 	dev->nondasd_support = 0;
+	dev->raid_scsi_mode = 0;
 	if(dev->adapter_info.options & AAC_OPT_NONDASD){
 		dev->nondasd_support = 1;
 	}
+
+	/*
+	 * If the firmware supports ROMB RAID/SCSI mode and we are currently
+	 * in RAID/SCSI mode, set the flag. For now if in this mode we will
+	 * force nondasd support on. If we decide to allow the non-dasd flag
+	 * additional changes changes will have to be made to support
+	 * RAID/SCSI.  the function aac_scsi_cmd in this module will have to be
+	 * changed to support the new dev->raid_scsi_mode flag instead of
+	 * leaching off of the dev->nondasd_support flag. Also in linit.c the
+	 * function aac_detect will have to be modified where it sets up the
+	 * max number of channels based on the aac->nondasd_support flag only.
+	 */
+	if ((dev->adapter_info.options & AAC_OPT_SCSI_MANAGED)
+		&& (dev->adapter_info.options & AAC_OPT_RAID_SCSI_MODE)) {
+		dev->nondasd_support = 1;
+		dev->raid_scsi_mode = 1;
+	}
+	if (dev->raid_scsi_mode != 0)
+		printk(KERN_INFO "%s%d: ROMB RAID/SCSI mode enabled\n",
+				dev->name, dev->id);
+		
 	if(nondasd != -1) {  
 		dev->nondasd_support = (nondasd!=0);
 	}
@@ -1137,7 +1159,7 @@
 		char *cp;
 
 		dprintk((KERN_DEBUG "READ CAPACITY command.\n"));
-		if (fsa_dev_ptr[cid].size <= 0x100000000)
+		if (fsa_dev_ptr[cid].size <= 0x100000000LL)
 			capacity = fsa_dev_ptr[cid].size - 1;
 		else
 			capacity = (u32)-1;
@@ -1446,8 +1468,17 @@
 			if( b==TYPE_TAPE || b==TYPE_WORM || b==TYPE_ROM || b==TYPE_MOD|| b==TYPE_MEDIUM_CHANGER 
 					|| (b==TYPE_DISK && (b1&0x80)) ){
 				scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+			/*
+			 * We will allow disk devices if in RAID/SCSI mode and
+			 * the channel is 2
+			 */
+			} else if ((dev->raid_scsi_mode) &&
+					(scsicmd->device->channel == 2)) {
+				scsicmd->result = DID_OK << 16 | 
+						COMMAND_COMPLETE << 8;
 			} else {
-				scsicmd->result = DID_NO_CONNECT << 16 | COMMAND_COMPLETE << 8;
+				scsicmd->result = DID_NO_CONNECT << 16 | 
+						COMMAND_COMPLETE << 8;
 			}
 		} else {
 			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
@@ -1479,8 +1510,17 @@
 			if( b==TYPE_TAPE || b==TYPE_WORM || b==TYPE_ROM || b==TYPE_MOD|| b==TYPE_MEDIUM_CHANGER
 					|| (b==TYPE_DISK && (b1&0x80)) ){
 				scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+			/*
+			 * We will allow disk devices if in RAID/SCSI mode and
+			 * the channel is 2
+			 */
+			} else if ((dev->raid_scsi_mode) &&
+					(scsicmd->device->channel == 2)) {
+				scsicmd->result = DID_OK << 16 | 
+						COMMAND_COMPLETE << 8;
 			} else {
-				scsicmd->result = DID_NO_CONNECT << 16 | COMMAND_COMPLETE << 8;
+				scsicmd->result = DID_NO_CONNECT << 16 | 
+						COMMAND_COMPLETE << 8;
 			}
 			break;
 		}
===== drivers/scsi/aacraid/aacraid.h 1.24 vs edited =====
--- 1.24/drivers/scsi/aacraid/aacraid.h	2004-10-01 08:09:07 -07:00
+++ edited/drivers/scsi/aacraid/aacraid.h	2004-10-20 13:35:27 -07:00
@@ -807,6 +807,8 @@
 #define AAC_OPT_SGMAP_HOST64		cpu_to_le32(1<<10)
 #define AAC_OPT_ALARM			cpu_to_le32(1<<11)
 #define AAC_OPT_NONDASD			cpu_to_le32(1<<12)
+#define AAC_OPT_SCSI_MANAGED    	cpu_to_le32(1<<13)
+#define AAC_OPT_RAID_SCSI_MODE		cpu_to_le32(1<<14)
 
 struct aac_dev
 {
@@ -879,6 +881,7 @@
 	 */
 	u8			nondasd_support; 
 	u8			dac_support;
+	u8			raid_scsi_mode;
 };
 
 #define AllocateAndMapFibSpace(dev, MapFibContext) \

-- 
Mark Haverkamp <markh@osdl.org>


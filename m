From: akpm@linux-foundation.org
Subject: [patch 24/33] DAC960: kmalloc->kzalloc/Casting cleanups
Date: Mon, 05 Feb 2007 16:38:55 -0800
Message-ID: <200702060039.l160dwFP005023@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41778 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965315AbXBFAkC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Feb 2007 19:40:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, darwish.07@gmail.com

From: "Ahmed S. Darwish" <darwish.07@gmail.com>

A patch to switch kmalloc->kzalloc and to clean unneeded kammloc,
pci_alloc_consistent casts

Signed-off-by: Ahmed Darwish <darwish.07@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/DAC960.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff -puN drivers/block/DAC960.c~dac960-kmalloc-kzalloc-casting-cleanups drivers/block/DAC960.c
--- a/drivers/block/DAC960.c~dac960-kmalloc-kzalloc-casting-cleanups
+++ a/drivers/block/DAC960.c
@@ -1373,8 +1373,7 @@ static boolean DAC960_V2_EnableMemoryMai
   Controller->BounceBufferLimit = DAC690_V2_PciDmaMask;
 
   /* This is a temporary dma mapping, used only in the scope of this function */
-  CommandMailbox =
-	  (DAC960_V2_CommandMailbox_T *)pci_alloc_consistent( PCI_Device,
+  CommandMailbox = pci_alloc_consistent(PCI_Device,
 		sizeof(DAC960_V2_CommandMailbox_T), &CommandMailboxDMA);
   if (CommandMailbox == NULL)
 	  return false;
@@ -1879,8 +1878,8 @@ static boolean DAC960_V2_ReadControllerC
       if (NewLogicalDeviceInfo->LogicalDeviceState !=
 	  DAC960_V2_LogicalDevice_Offline)
 	Controller->LogicalDriveInitiallyAccessible[LogicalDeviceNumber] = true;
-      LogicalDeviceInfo = (DAC960_V2_LogicalDeviceInfo_T *)
-	kmalloc(sizeof(DAC960_V2_LogicalDeviceInfo_T), GFP_ATOMIC);
+      LogicalDeviceInfo = kmalloc(sizeof(DAC960_V2_LogicalDeviceInfo_T),
+				   GFP_ATOMIC);
       if (LogicalDeviceInfo == NULL)
 	return DAC960_Failure(Controller, "LOGICAL DEVICE ALLOCATION");
       Controller->V2.LogicalDeviceInformation[LogicalDeviceNumber] =
@@ -2113,8 +2112,8 @@ static boolean DAC960_V2_ReadDeviceConfi
       if (!DAC960_V2_NewPhysicalDeviceInfo(Controller, Channel, TargetID, LogicalUnit))
 	  break;
 
-      PhysicalDeviceInfo = (DAC960_V2_PhysicalDeviceInfo_T *)
-		kmalloc(sizeof(DAC960_V2_PhysicalDeviceInfo_T), GFP_ATOMIC);
+      PhysicalDeviceInfo = kmalloc(sizeof(DAC960_V2_PhysicalDeviceInfo_T),
+				    GFP_ATOMIC);
       if (PhysicalDeviceInfo == NULL)
 		return DAC960_Failure(Controller, "PHYSICAL DEVICE ALLOCATION");
       Controller->V2.PhysicalDeviceInformation[PhysicalDeviceIndex] =
@@ -2122,8 +2121,8 @@ static boolean DAC960_V2_ReadDeviceConfi
       memcpy(PhysicalDeviceInfo, NewPhysicalDeviceInfo,
 		sizeof(DAC960_V2_PhysicalDeviceInfo_T));
 
-      InquiryUnitSerialNumber = (DAC960_SCSI_Inquiry_UnitSerialNumber_T *)
-	kmalloc(sizeof(DAC960_SCSI_Inquiry_UnitSerialNumber_T), GFP_ATOMIC);
+      InquiryUnitSerialNumber = kmalloc(
+	      sizeof(DAC960_SCSI_Inquiry_UnitSerialNumber_T), GFP_ATOMIC);
       if (InquiryUnitSerialNumber == NULL) {
 	kfree(PhysicalDeviceInfo);
 	return DAC960_Failure(Controller, "SERIAL NUMBER ALLOCATION");
@@ -4949,8 +4948,8 @@ static void DAC960_V2_ProcessCompletedCo
 	      PhysicalDevice.LogicalUnit = NewLogicalDeviceInfo->LogicalUnit;
 	      Controller->V2.LogicalDriveToVirtualDevice[LogicalDeviceNumber] =
 		PhysicalDevice;
-	      LogicalDeviceInfo = (DAC960_V2_LogicalDeviceInfo_T *)
-		kmalloc(sizeof(DAC960_V2_LogicalDeviceInfo_T), GFP_ATOMIC);
+	      LogicalDeviceInfo = kmalloc(sizeof(DAC960_V2_LogicalDeviceInfo_T),
+					  GFP_ATOMIC);
 	      Controller->V2.LogicalDeviceInformation[LogicalDeviceNumber] =
 		LogicalDeviceInfo;
 	      DAC960_Critical("Logical Drive %d (/dev/rd/c%dd%d) "
@@ -5709,14 +5708,14 @@ static boolean DAC960_CheckStatusBuffer(
       unsigned int NewStatusBufferLength = DAC960_InitialStatusBufferSize;
       while (NewStatusBufferLength < ByteCount)
 	NewStatusBufferLength *= 2;
-      Controller->CombinedStatusBuffer =
-	(unsigned char *) kmalloc(NewStatusBufferLength, GFP_ATOMIC);
+      Controller->CombinedStatusBuffer = kmalloc(NewStatusBufferLength,
+						  GFP_ATOMIC);
       if (Controller->CombinedStatusBuffer == NULL) return false;
       Controller->CombinedStatusBufferLength = NewStatusBufferLength;
       return true;
     }
-  NewStatusBuffer = (unsigned char *)
-    kmalloc(2 * Controller->CombinedStatusBufferLength, GFP_ATOMIC);
+  NewStatusBuffer = kmalloc(2 * Controller->CombinedStatusBufferLength,
+			     GFP_ATOMIC);
   if (NewStatusBuffer == NULL)
     {
       DAC960_Warning("Unable to expand Combined Status Buffer - Truncating\n",
_

From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Fix DAC960 driver on machines which don't support 64-bit DMA
Date: Fri, 31 Aug 2007 10:47:46 -0600
Message-ID: <20070831164746.GD14130@parisc-linux.org>
References: <bug-8942-27@http.bugzilla.kernel.org/> <20070831151748.37C39108012@picon.linux-foundation.org> <20070831084259.fc2fd903.akpm@linux-foundation.org> <20070831161733.GC14130@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42108 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758779AbXHaQrs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Aug 2007 12:47:48 -0400
Content-Disposition: inline
In-Reply-To: <20070831161733.GC14130@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>, Greg KH <greg@kroah.com>, alex@nibbles.it, dac@conglom-o.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, linux-scsi@vger.kernel.org

[Note: not tested.  I have a temporary shortage of machines with 5 volt
PCI slots, and in any case, I think the DAC960 that I have is a V1 card]

Use PCI_DMA_* constants instead of own private definitions
Fall back to 32-bit DMA mask if a 64-bit one fails

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 92bf868..504a95d 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -17,8 +17,8 @@
 */
 
 
-#define DAC960_DriverVersion			"2.5.48"
-#define DAC960_DriverDate			"14 May 2006"
+#define DAC960_DriverVersion			"2.5.49"
+#define DAC960_DriverDate			"21 Aug 2007"
 
 
 #include <linux/module.h>
@@ -1165,9 +1165,9 @@ static bool DAC960_V1_EnableMemoryMailboxInterface(DAC960_Controller_T
   int i;
 
   
-  if (pci_set_dma_mask(Controller->PCIDevice, DAC690_V1_PciDmaMask))
+  if (pci_set_dma_mask(Controller->PCIDevice, DMA_32BIT_MASK))
 	return DAC960_Failure(Controller, "DMA mask out of range");
-  Controller->BounceBufferLimit = DAC690_V1_PciDmaMask;
+  Controller->BounceBufferLimit = DMA_32BIT_MASK;
 
   if ((hw_type == DAC960_PD_Controller) || (hw_type == DAC960_P_Controller)) {
     CommandMailboxesSize =  0;
@@ -1368,9 +1368,12 @@ static bool DAC960_V2_EnableMemoryMailboxInterface(DAC960_Controller_T
   dma_addr_t	CommandMailboxDMA;
   DAC960_V2_CommandStatus_T CommandStatus;
 
-  if (pci_set_dma_mask(Controller->PCIDevice, DAC690_V2_PciDmaMask))
-	return DAC960_Failure(Controller, "DMA mask out of range");
-  Controller->BounceBufferLimit = DAC690_V2_PciDmaMask;
+	if (!pci_set_dma_mask(Controller->PCIDevice, DMA_64BIT_MASK))
+		Controller->BounceBufferLimit = DMA_64BIT_MASK;
+	else if (!pci_set_dma_mask(Controller->PCIDevice, DMA_32BIT_MASK))
+		Controller->BounceBufferLimit = DMA_32BIT_MASK;
+	else
+		return DAC960_Failure(Controller, "DMA mask out of range");
 
   /* This is a temporary dma mapping, used only in the scope of this function */
   CommandMailbox = pci_alloc_consistent(PCI_Device,
diff --git a/drivers/block/DAC960.h b/drivers/block/DAC960.h
index f5e2436..85fa9bb 100644
--- a/drivers/block/DAC960.h
+++ b/drivers/block/DAC960.h
@@ -61,13 +61,6 @@
 #define DAC960_V2_MaxPhysicalDevices		272
 
 /*
-  Define the pci dma mask supported by DAC960 V1 and V2 Firmware Controlers
- */
-
-#define DAC690_V1_PciDmaMask	0xffffffff
-#define DAC690_V2_PciDmaMask	0xffffffffffffffffULL
-
-/*
   Define a 32/64 bit I/O Address data type.
 */
 

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] scsi: Switch some more scsi drivers to pci_get_device and
	refcounted pci structures
Date: Fri, 15 Sep 2006 15:34:32 +0100
Message-ID: <1158330872.29932.61.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:11959 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S1751494AbWIOOKt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Sep 2006 10:10:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.18-rc6-mm1/drivers/scsi/aic7xxx_old.c linux-2.6.18-rc6-mm1/drivers/scsi/aic7xxx_old.c
--- linux.vanilla-2.6.18-rc6-mm1/drivers/scsi/aic7xxx_old.c	2006-09-11 17:00:17.000000000 +0100
+++ linux-2.6.18-rc6-mm1/drivers/scsi/aic7xxx_old.c	2006-09-14 16:50:25.000000000 +0100
@@ -9194,7 +9194,7 @@
     for (i = 0; i < ARRAY_SIZE(aic_pdevs); i++)
     {
       pdev = NULL;
-      while ((pdev = pci_find_device(aic_pdevs[i].vendor_id,
+      while ((pdev = pci_get_device(aic_pdevs[i].vendor_id,
                                      aic_pdevs[i].device_id,
                                      pdev))) {
 	if (pci_enable_device(pdev))
@@ -9651,6 +9651,9 @@
            */
           aic7xxx_configure_bugs(temp_p);
 
+          /* Hold a pci device reference */
+          pci_dev_get(temp_p->pdev);
+          
           if ( list_p == NULL )
           {
             list_p = current_p = temp_p;
@@ -10987,8 +10990,10 @@
   if(!p->pdev)
     release_region(p->base, MAXREG - MINREG);
 #ifdef CONFIG_PCI
-  else
+  else {
     pci_release_regions(p->pdev);
+    pci_dev_put(p->pdev);
+  }
 #endif
   prev = NULL;
   next = first_aic7xxx;
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.18-rc6-mm1/drivers/scsi/BusLogic.c linux-2.6.18-rc6-mm1/drivers/scsi/BusLogic.c
--- linux.vanilla-2.6.18-rc6-mm1/drivers/scsi/BusLogic.c	2006-09-11 17:00:17.000000000 +0100
+++ linux-2.6.18-rc6-mm1/drivers/scsi/BusLogic.c	2006-09-14 16:59:39.000000000 +0100
@@ -662,7 +662,7 @@
 	   particular standard ISA I/O Address need not be probed.
 	 */
 	PrimaryProbeInfo->IO_Address = 0;
-	while ((PCI_Device = pci_find_device(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER, PCI_Device)) != NULL) {
+	while ((PCI_Device = pci_get_device(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER, PCI_Device)) != NULL) {
 		struct BusLogic_HostAdapter *HostAdapter = PrototypeHostAdapter;
 		struct BusLogic_PCIHostAdapterInformation PCIHostAdapterInformation;
 		enum BusLogic_ISACompatibleIOPort ModifyIOAddressRequest;
@@ -762,7 +762,7 @@
 			PrimaryProbeInfo->Bus = Bus;
 			PrimaryProbeInfo->Device = Device;
 			PrimaryProbeInfo->IRQ_Channel = IRQ_Channel;
-			PrimaryProbeInfo->PCI_Device = PCI_Device;
+			PrimaryProbeInfo->PCI_Device = pci_dev_get(PCI_Device);
 			PCIMultiMasterCount++;
 		} else if (BusLogic_ProbeInfoCount < BusLogic_MaxHostAdapters) {
 			struct BusLogic_ProbeInfo *ProbeInfo = &BusLogic_ProbeInfoList[BusLogic_ProbeInfoCount++];
@@ -773,7 +773,7 @@
 			ProbeInfo->Bus = Bus;
 			ProbeInfo->Device = Device;
 			ProbeInfo->IRQ_Channel = IRQ_Channel;
-			ProbeInfo->PCI_Device = PCI_Device;
+			ProbeInfo->PCI_Device = pci_dev_get(PCI_Device);
 			NonPrimaryPCIMultiMasterCount++;
 			PCIMultiMasterCount++;
 		} else
@@ -823,7 +823,7 @@
 	   noting the PCI bus location and assigned IRQ Channel.
 	 */
 	PCI_Device = NULL;
-	while ((PCI_Device = pci_find_device(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER_NC, PCI_Device)) != NULL) {
+	while ((PCI_Device = pci_get_device(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER_NC, PCI_Device)) != NULL) {
 		unsigned char Bus;
 		unsigned char Device;
 		unsigned int IRQ_Channel;
@@ -850,7 +850,7 @@
 				ProbeInfo->Bus = Bus;
 				ProbeInfo->Device = Device;
 				ProbeInfo->IRQ_Channel = IRQ_Channel;
-				ProbeInfo->PCI_Device = PCI_Device;
+				ProbeInfo->PCI_Device = pci_dev_get(PCI_Device);
 				break;
 			}
 		}
@@ -874,7 +874,7 @@
 	/*
 	   Interrogate PCI Configuration Space for any FlashPoint Host Adapters.
 	 */
-	while ((PCI_Device = pci_find_device(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_FLASHPOINT, PCI_Device)) != NULL) {
+	while ((PCI_Device = pci_get_device(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_FLASHPOINT, PCI_Device)) != NULL) {
 		unsigned char Bus;
 		unsigned char Device;
 		unsigned int IRQ_Channel;
@@ -923,7 +923,7 @@
 			ProbeInfo->Bus = Bus;
 			ProbeInfo->Device = Device;
 			ProbeInfo->IRQ_Channel = IRQ_Channel;
-			ProbeInfo->PCI_Device = PCI_Device;
+			ProbeInfo->PCI_Device = pci_dev_get(PCI_Device);
 			FlashPointCount++;
 		} else
 			BusLogic_Warning("BusLogic: Too many Host Adapters " "detected\n", NULL);
@@ -1890,6 +1890,7 @@
 	 */
 	if (HostAdapter->MailboxSpace)
 		pci_free_consistent(HostAdapter->PCI_Device, HostAdapter->MailboxSize, HostAdapter->MailboxSpace, HostAdapter->MailboxSpaceHandle);
+	pci_dev_put(HostAdapter->PCI_Device);		
 	HostAdapter->MailboxSpace = NULL;
 	HostAdapter->MailboxSpaceHandle = 0;
 	HostAdapter->MailboxSize = 0;
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.18-rc6-mm1/drivers/scsi/dpt_i2o.c linux-2.6.18-rc6-mm1/drivers/scsi/dpt_i2o.c
--- linux.vanilla-2.6.18-rc6-mm1/drivers/scsi/dpt_i2o.c	2006-09-11 17:00:17.000000000 +0100
+++ linux-2.6.18-rc6-mm1/drivers/scsi/dpt_i2o.c	2006-09-14 16:40:17.000000000 +0100
@@ -184,7 +184,7 @@
 	PINFO("Detecting Adaptec I2O RAID controllers...\n");
 
         /* search for all Adatpec I2O RAID cards */
-	while ((pDev = pci_find_device( PCI_DPT_VENDOR_ID, PCI_ANY_ID, pDev))) {
+	while ((pDev = pci_get_device( PCI_DPT_VENDOR_ID, PCI_ANY_ID, pDev))) {
 		if(pDev->device == PCI_DPT_DEVICE_ID ||
 		   pDev->device == PCI_DPT_RAPTOR_DEVICE_ID){
 			if(adpt_install_hba(sht, pDev) ){
@@ -192,8 +192,11 @@
 				PERROR("Will not try to detect others.\n");
 				return hba_count-1;
 			}
+			pci_dev_get(pDev);
 		}
 	}
+	if (pDev)
+		pci_dev_put(pDev);
 
 	/* In INIT state, Activate IOPs */
 	for (pHba = hba_chain; pHba; pHba = pHba->next) {
@@ -1075,6 +1078,7 @@
 			}
 		}
 	}
+	pci_dev_put(pHba->pDev);
 	kfree(pHba);
 
 	if(hba_count <= 0){


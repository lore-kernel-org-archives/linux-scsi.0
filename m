From: akpm@osdl.org
Subject: [patch 11/19] BusLogic gcc 4.1 warning fixes
Date: Fri, 07 Jul 2006 00:01:03 -0700
Message-ID: <200607070701.k677139k030572@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:55746 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751231AbWGGHBK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jul 2006 03:01:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, dwalker@mvista.com

From: Daniel Walker <dwalker@mvista.com>

- Reworked all the very long lines in that block (this drivers full of
  them though)

- Returns an error in three places that it didn't before.

- Properly clean up after a scsi_add_host() failure.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/BusLogic.c |   46 ++++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff -puN drivers/scsi/BusLogic.c~buslogic-gcc-41-warning-fixes drivers/scsi/BusLogic.c
--- a/drivers/scsi/BusLogic.c~buslogic-gcc-41-warning-fixes
+++ a/drivers/scsi/BusLogic.c
@@ -2176,6 +2176,7 @@ static int __init BusLogic_init(void)
 {
 	int BusLogicHostAdapterCount = 0, DriverOptionsIndex = 0, ProbeIndex;
 	struct BusLogic_HostAdapter *PrototypeHostAdapter;
+	int ret = 0;
 
 #ifdef MODULE
 	if (BusLogic)
@@ -2282,25 +2283,49 @@ static int __init BusLogic_init(void)
 		   perform Target Device Inquiry.
 		 */
 		if (BusLogic_ReadHostAdapterConfiguration(HostAdapter) &&
-		    BusLogic_ReportHostAdapterConfiguration(HostAdapter) && BusLogic_AcquireResources(HostAdapter) && BusLogic_CreateInitialCCBs(HostAdapter) && BusLogic_InitializeHostAdapter(HostAdapter) && BusLogic_TargetDeviceInquiry(HostAdapter)) {
+		    BusLogic_ReportHostAdapterConfiguration(HostAdapter) &&
+		    BusLogic_AcquireResources(HostAdapter) &&
+		    BusLogic_CreateInitialCCBs(HostAdapter) &&
+		    BusLogic_InitializeHostAdapter(HostAdapter) &&
+		    BusLogic_TargetDeviceInquiry(HostAdapter)) {
 			/*
 			   Initialization has been completed successfully.  Release and
 			   re-register usage of the I/O Address range so that the Model
 			   Name of the Host Adapter will appear, and initialize the SCSI
 			   Host structure.
 			 */
-			release_region(HostAdapter->IO_Address, HostAdapter->AddressCount);
-			if (!request_region(HostAdapter->IO_Address, HostAdapter->AddressCount, HostAdapter->FullModelName)) {
-				printk(KERN_WARNING "BusLogic: Release and re-register of " "port 0x%04lx failed \n", (unsigned long) HostAdapter->IO_Address);
+			release_region(HostAdapter->IO_Address,
+				       HostAdapter->AddressCount);
+			if (!request_region(HostAdapter->IO_Address,
+					    HostAdapter->AddressCount,
+					    HostAdapter->FullModelName)) {
+				printk(KERN_WARNING
+					"BusLogic: Release and re-register of "
+					"port 0x%04lx failed \n",
+					(unsigned long)HostAdapter->IO_Address);
 				BusLogic_DestroyCCBs(HostAdapter);
 				BusLogic_ReleaseResources(HostAdapter);
 				list_del(&HostAdapter->host_list);
 				scsi_host_put(Host);
+				ret = -ENOMEM;
 			} else {
-				BusLogic_InitializeHostStructure(HostAdapter, Host);
-				scsi_add_host(Host, HostAdapter->PCI_Device ? &HostAdapter->PCI_Device->dev : NULL);
-				scsi_scan_host(Host);
-				BusLogicHostAdapterCount++;
+				BusLogic_InitializeHostStructure(HostAdapter,
+								 Host);
+				if (scsi_add_host(Host, HostAdapter->PCI_Device
+						? &HostAdapter->PCI_Device->dev
+						  : NULL)) {
+					printk(KERN_WARNING
+					       "BusLogic: scsi_add_host()"
+					       "failed!\n");
+					BusLogic_DestroyCCBs(HostAdapter);
+					BusLogic_ReleaseResources(HostAdapter);
+					list_del(&HostAdapter->host_list);
+					scsi_host_put(Host);
+					ret = -ENODEV;
+				} else {
+					scsi_scan_host(Host);
+					BusLogicHostAdapterCount++;
+				}
 			}
 		} else {
 			/*
@@ -2315,12 +2340,13 @@ static int __init BusLogic_init(void)
 			BusLogic_ReleaseResources(HostAdapter);
 			list_del(&HostAdapter->host_list);
 			scsi_host_put(Host);
+			ret = -ENODEV;
 		}
 	}
 	kfree(PrototypeHostAdapter);
 	kfree(BusLogic_ProbeInfoList);
 	BusLogic_ProbeInfoList = NULL;
-	return 0;
+	return ret;
 }
 
 
@@ -2954,6 +2980,7 @@ static int BusLogic_QueueCommand(struct 
 }
 
 
+#if 0
 /*
   BusLogic_AbortCommand aborts Command if possible.
 */
@@ -3024,6 +3051,7 @@ static int BusLogic_AbortCommand(struct 
 	return SUCCESS;
 }
 
+#endif
 /*
   BusLogic_ResetHostAdapter resets Host Adapter if possible, marking all
   currently executing SCSI Commands as having been Reset.
_

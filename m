From: akpm@osdl.org
Subject: [patch 22/31] BusLogic gcc 4.1 warning fixes
Date: Thu, 08 Jun 2006 22:23:54 -0700
Message-ID: <200606090523.k595Nsq7032323@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:20701 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965177AbWFIFYI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2006 01:24:08 -0400
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
--- devel/drivers/scsi/BusLogic.c~buslogic-gcc-41-warning-fixes	2006-06-01 20:41:52.000000000 -0700
+++ devel-akpm/drivers/scsi/BusLogic.c	2006-06-01 20:41:52.000000000 -0700
@@ -2177,6 +2177,7 @@ static int __init BusLogic_init(void)
 {
 	int BusLogicHostAdapterCount = 0, DriverOptionsIndex = 0, ProbeIndex;
 	struct BusLogic_HostAdapter *PrototypeHostAdapter;
+	int ret = 0;
 
 #ifdef MODULE
 	if (BusLogic)
@@ -2283,25 +2284,49 @@ static int __init BusLogic_init(void)
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
@@ -2316,12 +2341,13 @@ static int __init BusLogic_init(void)
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
 
 
@@ -2955,6 +2981,7 @@ static int BusLogic_QueueCommand(struct 
 }
 
 
+#if 0
 /*
   BusLogic_AbortCommand aborts Command if possible.
 */
@@ -3025,6 +3052,7 @@ static int BusLogic_AbortCommand(struct 
 	return SUCCESS;
 }
 
+#endif
 /*
   BusLogic_ResetHostAdapter resets Host Adapter if possible, marking all
   currently executing SCSI Commands as having been Reset.
_

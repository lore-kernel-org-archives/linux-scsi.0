From: akpm@linux-foundation.org
Subject: [patch 26/30] Fix BusLogic to stop using check_region
Date: Thu, 26 Apr 2007 00:35:29 -0700
Message-ID: <200704260735.l3Q7ZT35024288@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933510AbXDZH6B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Apr 2007 03:58:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, zach@vmware.com

From: Zachary Amsden <zach@vmware.com>

I got so sick of seing the check_region warnings from BusLogic.c I actually
fixed it properly.  Never use check region, reserve it before the probe
with request region instead and check the error result; free region if
setup fails.  Should be functionally identical to the original except for
fixing the potential race.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/BusLogic.c |   73 ++++++++++++++++++++++++--------------
 1 file changed, 48 insertions(+), 25 deletions(-)

diff -puN drivers/scsi/BusLogic.c~fix-buslogic-to-stop-using-check_region drivers/scsi/BusLogic.c
--- a/drivers/scsi/BusLogic.c~fix-buslogic-to-stop-using-check_region
+++ a/drivers/scsi/BusLogic.c
@@ -579,17 +579,17 @@ static void __init BusLogic_InitializePr
 	/*
 	   Append the list of standard BusLogic MultiMaster ISA I/O Addresses.
 	 */
-	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe330 : check_region(0x330, BusLogic_MultiMasterAddressCount) == 0)
+	if (!BusLogic_ProbeOptions.LimitedProbeISA || BusLogic_ProbeOptions.Probe330)
 		BusLogic_AppendProbeAddressISA(0x330);
-	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe334 : check_region(0x334, BusLogic_MultiMasterAddressCount) == 0)
+	if (!BusLogic_ProbeOptions.LimitedProbeISA || BusLogic_ProbeOptions.Probe334)
 		BusLogic_AppendProbeAddressISA(0x334);
-	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe230 : check_region(0x230, BusLogic_MultiMasterAddressCount) == 0)
+	if (!BusLogic_ProbeOptions.LimitedProbeISA || BusLogic_ProbeOptions.Probe230)
 		BusLogic_AppendProbeAddressISA(0x230);
-	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe234 : check_region(0x234, BusLogic_MultiMasterAddressCount) == 0)
+	if (!BusLogic_ProbeOptions.LimitedProbeISA || BusLogic_ProbeOptions.Probe234)
 		BusLogic_AppendProbeAddressISA(0x234);
-	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe130 : check_region(0x130, BusLogic_MultiMasterAddressCount) == 0)
+	if (!BusLogic_ProbeOptions.LimitedProbeISA || BusLogic_ProbeOptions.Probe130)
 		BusLogic_AppendProbeAddressISA(0x130);
-	if (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe134 : check_region(0x134, BusLogic_MultiMasterAddressCount) == 0)
+	if (!BusLogic_ProbeOptions.LimitedProbeISA || BusLogic_ProbeOptions.Probe134)
 		BusLogic_AppendProbeAddressISA(0x134);
 }
 
@@ -795,7 +795,9 @@ static int __init BusLogic_InitializeMul
 	   host adapters are probed.
 	 */
 	if (!BusLogic_ProbeOptions.NoProbeISA)
-		if (PrimaryProbeInfo->IO_Address == 0 && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe330 : check_region(0x330, BusLogic_MultiMasterAddressCount) == 0)) {
+		if (PrimaryProbeInfo->IO_Address == 0 &&
+				(!BusLogic_ProbeOptions.LimitedProbeISA ||
+				 BusLogic_ProbeOptions.Probe330)) {
 			PrimaryProbeInfo->HostAdapterType = BusLogic_MultiMaster;
 			PrimaryProbeInfo->HostAdapterBusType = BusLogic_ISA_Bus;
 			PrimaryProbeInfo->IO_Address = 0x330;
@@ -805,15 +807,25 @@ static int __init BusLogic_InitializeMul
 	   omitting the Primary I/O Address which has already been handled.
 	 */
 	if (!BusLogic_ProbeOptions.NoProbeISA) {
-		if (!StandardAddressSeen[1] && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe334 : check_region(0x334, BusLogic_MultiMasterAddressCount) == 0))
+		if (!StandardAddressSeen[1] &&
+				(!BusLogic_ProbeOptions.LimitedProbeISA ||
+				 BusLogic_ProbeOptions.Probe334))
 			BusLogic_AppendProbeAddressISA(0x334);
-		if (!StandardAddressSeen[2] && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe230 : check_region(0x230, BusLogic_MultiMasterAddressCount) == 0))
+		if (!StandardAddressSeen[2] &&
+				(!BusLogic_ProbeOptions.LimitedProbeISA ||
+				 BusLogic_ProbeOptions.Probe230))
 			BusLogic_AppendProbeAddressISA(0x230);
-		if (!StandardAddressSeen[3] && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe234 : check_region(0x234, BusLogic_MultiMasterAddressCount) == 0))
+		if (!StandardAddressSeen[3] &&
+				(!BusLogic_ProbeOptions.LimitedProbeISA ||
+				 BusLogic_ProbeOptions.Probe234))
 			BusLogic_AppendProbeAddressISA(0x234);
-		if (!StandardAddressSeen[4] && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe130 : check_region(0x130, BusLogic_MultiMasterAddressCount) == 0))
+		if (!StandardAddressSeen[4] &&
+				(!BusLogic_ProbeOptions.LimitedProbeISA ||
+				 BusLogic_ProbeOptions.Probe130))
 			BusLogic_AppendProbeAddressISA(0x130);
-		if (!StandardAddressSeen[5] && (BusLogic_ProbeOptions.LimitedProbeISA ? BusLogic_ProbeOptions.Probe134 : check_region(0x134, BusLogic_MultiMasterAddressCount) == 0))
+		if (!StandardAddressSeen[5] &&
+				(!BusLogic_ProbeOptions.LimitedProbeISA ||
+				 BusLogic_ProbeOptions.Probe134))
 			BusLogic_AppendProbeAddressISA(0x134);
 	}
 	/*
@@ -2220,22 +2232,35 @@ static int __init BusLogic_init(void)
 		HostAdapter->PCI_Device = ProbeInfo->PCI_Device;
 		HostAdapter->IRQ_Channel = ProbeInfo->IRQ_Channel;
 		HostAdapter->AddressCount = BusLogic_HostAdapterAddressCount[HostAdapter->HostAdapterType];
+
+		/*
+		   Make sure region is free prior to probing.
+		 */
+		if (!request_region(HostAdapter->IO_Address, HostAdapter->AddressCount,
+					"BusLogic"))
+			continue;
 		/*
 		   Probe the Host Adapter.  If unsuccessful, abort further initialization.
 		 */
-		if (!BusLogic_ProbeHostAdapter(HostAdapter))
+		if (!BusLogic_ProbeHostAdapter(HostAdapter)) {
+			release_region(HostAdapter->IO_Address, HostAdapter->AddressCount);
 			continue;
+		}
 		/*
 		   Hard Reset the Host Adapter.  If unsuccessful, abort further
 		   initialization.
 		 */
-		if (!BusLogic_HardwareResetHostAdapter(HostAdapter, true))
+		if (!BusLogic_HardwareResetHostAdapter(HostAdapter, true)) {
+			release_region(HostAdapter->IO_Address, HostAdapter->AddressCount);
 			continue;
+		}
 		/*
 		   Check the Host Adapter.  If unsuccessful, abort further initialization.
 		 */
-		if (!BusLogic_CheckHostAdapter(HostAdapter))
+		if (!BusLogic_CheckHostAdapter(HostAdapter)) {
+			release_region(HostAdapter->IO_Address, HostAdapter->AddressCount);
 			continue;
+		}
 		/*
 		   Initialize the Driver Options field if provided.
 		 */
@@ -2247,16 +2272,6 @@ static int __init BusLogic_init(void)
 		 */
 		BusLogic_AnnounceDriver(HostAdapter);
 		/*
-		   Register usage of the I/O Address range.  From this point onward, any
-		   failure will be assumed to be due to a problem with the Host Adapter,
-		   rather than due to having mistakenly identified this port as belonging
-		   to a BusLogic Host Adapter.  The I/O Address range will not be
-		   released, thereby preventing it from being incorrectly identified as
-		   any other type of Host Adapter.
-		 */
-		if (!request_region(HostAdapter->IO_Address, HostAdapter->AddressCount, "BusLogic"))
-			continue;
-		/*
 		   Register the SCSI Host structure.
 		 */
 
@@ -2280,6 +2295,12 @@ static int __init BusLogic_init(void)
 		   Acquire the System Resources necessary to use the Host Adapter, then
 		   Create the Initial CCBs, Initialize the Host Adapter, and finally
 		   perform Target Device Inquiry.
+
+		   From this point onward, any failure will be assumed to be due to a
+		   problem with the Host Adapter, rather than due to having mistakenly
+		   identified this port as belonging to a BusLogic Host Adapter.  The
+		   I/O Address range will not be released, thereby preventing it from
+		   being incorrectly identified as any other type of Host Adapter.
 		 */
 		if (BusLogic_ReadHostAdapterConfiguration(HostAdapter) &&
 		    BusLogic_ReportHostAdapterConfiguration(HostAdapter) &&
@@ -3598,6 +3619,7 @@ static void __exit BusLogic_exit(void)
 
 __setup("BusLogic=", BusLogic_Setup);
 
+#ifdef MODULE
 static struct pci_device_id BusLogic_pci_tbl[] __devinitdata = {
 	{ PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
@@ -3607,6 +3629,7 @@ static struct pci_device_id BusLogic_pci
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ }
 };
+#endif
 MODULE_DEVICE_TABLE(pci, BusLogic_pci_tbl);
 
 module_init(BusLogic_init);
_

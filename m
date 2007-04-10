From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [Fwd: Fix BusLogic to stop using check_region]
Date: Tue, 10 Apr 2007 08:53:08 -0500
Message-ID: <1176213188.3712.0.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:48899 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753778AbXDJNxL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Apr 2007 09:53:11 -0400
Received: from [172.17.6.40] (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id l3ADr9k09987
	for <linux-scsi@vger.kernel.org>; Tue, 10 Apr 2007 09:53:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

-------- Forwarded Message --------
Subject: Fix BusLogic to stop using check_region
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

Patches currently in -mm which might be from zach@vmware.com are

proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
fix-buslogic-to-stop-using-check_region.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
paravirt_ops-update-maintainers.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
paravirt_ops-add-common-patching-machinery.patch
paravirt_ops-revert-map_pt_hook.patch
paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages.patch
i386-relocate-vdso-elf-headers-to-match-mapped-location-with-compat_vdso.patch
i386-make-compat_vdso-runtime-selectable.patch
i386-sysenter-arch-pages-fix.patch
i386-acpi-remove-earlyquirk-warning.patch
i386-mcheck-p4-grotesque-and-needless-warning-fix.patch
i386-pgd-clone-under-lock-fix.patch
vmi-supports-compat-vdso.patch
resurrect-the-vmi-lazy-mode-fixes.patch
vmi-kmap_atomic_pte-fix.patch
vmi-timer-update.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch


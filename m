From: Andi Kleen <ak@suse.de>
Subject: Fwd: [PATCH 23/28] Fix BusLogic to stop using check_region
Date: Mon, 23 Apr 2007 12:35:34 +0200
Message-ID: <200704231235.34341.ak@suse.de>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_2vILGwuH6AUvd93"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:54812 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161364AbXDWKvm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Apr 2007 06:51:42 -0400
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 3D3AB12498
	for <linux-scsi@vger.kernel.org>; Mon, 23 Apr 2007 12:51:41 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--Boundary-00=_2vILGwuH6AUvd93
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


Something for the SCSI tree

-Andi

--Boundary-00=_2vILGwuH6AUvd93
Content-Type: message/rfc822;
  name="forwarded message"
Content-Transfer-Encoding: 7bit
Content-Description: Jeremy Fitzhardinge <jeremy@goop.org>: [PATCH 23/28] Fix BusLogic to stop using check_region
Content-Disposition: inline

Return-Path: <jeremy@goop.org>
Received: from imap.suse.de ([unix socket])
	by imap-dhs (Cyrus v2.1.16) with LMTP; Sat, 14 Apr 2007 23:20:25 +0200
X-Sieve: CMU Sieve 2.2
Received: from Relay2.suse.de (relay2.suse.de [149.44.160.89])
	(using TLSv1 with cipher EDH-RSA-DES-CBC3-SHA (168/168 bits))
	(Client CN "relay.suse.de", Issuer "CAcert Class 3 Root" (verified OK))
	by imap.suse.de (Postfix) with ESMTP id 36E14CF4957
	for <ak@imap-dhs.suse.de>; Sat, 14 Apr 2007 23:20:25 +0200 (CEST)
Received: by Relay2.suse.de (Postfix)
	id 1D563C77F; Sat, 14 Apr 2007 23:20:25 +0200 (CEST)
Received: from Relay2.suse.de (localhost [127.0.0.1])
	by Relay2.suse.de (Postfix) with ESMTP id 10E06C74D
	for <ak@suse.de>; Sat, 14 Apr 2007 23:20:25 +0200 (CEST)
Received: from Relay2.suse.de ([127.0.0.1])
 by Relay2.suse.de (Relay2 [127.0.0.1]) (amavisd-new, port 10026) with ESMTP
 id 27487-14 for <ak@suse.de>; Sat, 14 Apr 2007 23:20:24 +0200 (CEST)
Received: from mx1.suse.de (mail.suse.de [195.135.220.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by Relay2.suse.de (Postfix) with ESMTP id 2B0F5C798
	for <ak@suse.de>; Sat, 14 Apr 2007 23:20:24 +0200 (CEST)
Received: from mail.goop.org (gw.goop.org [64.81.55.164])
	by mx1.suse.de (Postfix) with ESMTP id 35E45122D5
	for <ak@suse.de>; Sat, 14 Apr 2007 23:20:21 +0200 (CEST)
Received: by mail.goop.org (Postfix, from userid 500)
	id 84B8F6383FA; Sat, 14 Apr 2007 14:19:39 -0700 (PDT)
Message-Id: <20070414204925.105615645@goop.org>
References: <20070414204154.871250608@goop.org>
User-Agent: quilt/0.46-1
Date: Sat, 14 Apr 2007 13:42:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 virtualization@lists.osdl.org,
 lkml <linux-kernel@vger.kernel.org>,
 Zachary Amsden <zach@vmware.com>,
 "Lenoard N. Zubkoff" <lnz@dandelion.com>,
 Michael Clay <claym@osuosl.org>
Subject: [PATCH 23/28] Fix BusLogic to stop using check_region
Content-Disposition: inline; filename=buslogic-check-range-fixes.patch
X-Virus-Scanned: by amavisd-new at Relay2.suse.de
X-Spam-Status: No, hits=0.0 tagged_above=-20.0 required=5.0 tests=BAYES_50
X-Spam-Level: 
X-Length: 10672
X-UID: 104148

I got so sick of seing the check_region warnings from BusLogic.c I actually
fixed it properly.  Never use check region, reserve it before the probe
with request region instead and check the error result; free region if
setup fails.  Should be functionally identical to the original except for
fixing the potential race.

From: Zachary Amsden <zach@vmware.com>
Signed-off-by: Zachary Amsden <zach@vmware.com>
CC: Lenoard N. Zubkoff <lnz@dandelion.com>
CC: Michael Clay <claym@osuosl.org>

---
 drivers/scsi/BusLogic.c |   73 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 48 insertions(+), 25 deletions(-)

===================================================================
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
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

-- 


--Boundary-00=_2vILGwuH6AUvd93--

From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Subject: [PATCH] aic94xx: add PCI ID 9005:0416
Date: Thu, 10 May 2007 19:59:23 +0200
Message-ID: <200705101759.l4AHxNmU001798@appel.macroscoop.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mondriaan.macroscoop.nl ([82.94.9.2]:2223 "EHLO
	mondriaan.macroscoop.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526AbXEJSIV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 May 2007 14:08:21 -0400
Received: from appel.macroscoop.nl (appel.macroscoop.nl [IPv6:2001:888:1734:0:219:d1ff:fe39:f483])
	by mondriaan.macroscoop.nl (envelope-from pim@appel.macroscoop.nl) (8.13.8/8.13.8) with ESMTP id l4AHxNJD002886
	for <linux-scsi@vger.kernel.org>; Thu, 10 May 2007 19:59:23 +0200
Received: from appel.macroscoop.nl (localhost [127.0.0.1])
	by appel.macroscoop.nl (8.13.8/8.13.7) with ESMTP id l4AHxNDP001799
	for <linux-scsi@vger.kernel.org>; Thu, 10 May 2007 19:59:23 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

I just received the retail version of an Adaptec 58300 PCI-X SAS adapter
with PCI ID 9005:0416.

Here's the lspci -vvn output:

03:08.0 Class 0107: 9005:0416 (rev 09)
        Subsystem: 9005:0416
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (32000ns min, 26750ns max), Cache Line Size 08
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at fe700000 (64-bit, non-prefetchable) [size=256K]
        Region 2: Memory at fe500000 (64-bit, prefetchable) [size=128K]
        Region 4: I/O ports at bc00 [size=256]
        Expansion ROM at fe600000 [disabled] [size=512K]
        Capabilities: [40] PCI-X non-bridge device.
                Command: DPERE- ERO- RBC=3 OST=4
                Status: Bus=255 Dev=31 Func=0 64bit+ 133MHz+ SCD- USC-, DC=simple, DMMRBC=3, DMOST=4, DMCRS=4, RSCEM-
        Capabilities: [58] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [e0] Message Signalled Interrupts: 64bit+ Queue=0/2 Enable-
                Address: 0000000000000000  Data: 0000

The aic94xx driver in kernel 2.6.21.1 does not recognize the card.
With following patch it does:

--- linux-2.6.21.1.orig/drivers/scsi/aic94xx/aic94xx_hwi.h	2007-05-10 18:29:38.000000000 +0200
+++ linux-2.6.21.1/drivers/scsi/aic94xx/aic94xx_hwi.h	2007-05-03 22:42:35.000000000 +0200
@@ -45,6 +45,7 @@
  */
 #define PCI_DEVICE_ID_ADAPTEC2_RAZOR10 0x410
 #define PCI_DEVICE_ID_ADAPTEC2_RAZOR12 0x412
+#define PCI_DEVICE_ID_ADAPTEC2_RAZOR16 0x416
 #define PCI_DEVICE_ID_ADAPTEC2_RAZOR1E 0x41E
 #define PCI_DEVICE_ID_ADAPTEC2_RAZOR1F 0x41F
 #define PCI_DEVICE_ID_ADAPTEC2_RAZOR30 0x430
--- linux-2.6.21.1.orig/drivers/scsi/aic94xx/aic94xx_init.c	2007-05-10 18:30:14.000000000 +0200
+++ linux-2.6.21.1/drivers/scsi/aic94xx/aic94xx_init.c	2007-05-03 22:43:29.000000000 +0200
@@ -837,6 +837,8 @@
 	 0, 0, 1},
 	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR12),
 	 0, 0, 1},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR16),
+	 0, 0, 1},
 	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR1E),
 	 0, 0, 1},
 	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR1F),

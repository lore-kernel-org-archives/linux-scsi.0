From: Yokota Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Subject: [PATCH 2/13] nsp32, nsp_cs driver update
Date: Tue, 22 Feb 2005 16:03:53 +0900 (JST)
Message-ID: <20050222.160353.41697816.yokota@netlab.is.tsukuba.ac.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Received: from pixy-gw.netlab.cs.tsukuba.ac.jp ([130.158.83.98]:35086 "HELO
	pixy.netlab.cs.tsukuba.ac.jp") by vger.kernel.org with SMTP
	id S262222AbVBVHDy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Feb 2005 02:03:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--- linux-2.6.10/Documentation/scsi/nsp32.txt	1970-01-01 09:00:00.000000000 +0900
+++ linux-2.6.10-nsp/Documentation/scsi/nsp32.txt	2003-11-12 21:42:54.000000000 +0900
@@ -0,0 +1,90 @@
+	<<NinjaSCSI-32Bi/UDE CardBus/PCI card driver for Linux>>
+
+
+1. What's this?
+
+ This is Workbit corp.'s(http://www.workbit.co.jp/) NinjaSCSI-32Bi
+(http://www.workbit.co.jp/ts/z_njsc32bi.html) PCMCIA card and NinjaSCSI-32UDE
+(http://www.workbit.co.jp/ts/z_njscsi32ude.html) PCI card driver module for
+Linux.
+
+
+
+2. Install
+
+[1] This driver requires Kernel 2.4.x/2.6.x or later.
+    And you want to load the module when Ninja card was inserted, you also
+    install "hotplug" (http://linux-hotplug.sourceforge.net/) utility.
+
+[2] Insert Ninja card to your PC, and check your card is NinjaSCSI-32Bi/UDE
+    card.
+
+# lspci
+....
+01:00.0 SCSI storage controller: I-O Data Device, Inc. CBSC-II duo SCSI PCMCIA card (rev 01)
+
+[3] This driver requires Kernel 2.4/2.6's source code. Please install cernel
+    source code.
+
+[4] Please check your kernel have PCI, CardBus, PCMCIA and SCSI support.
+    If not, rebuild your kernel. And also requires PCMCIA-CS if you use
+    CardBus card.
+
+[5] Extract this archive somewhere.
+
+[6] Edit "Makefile" and type "make" to compile the driver.
+
+[7] Copy "nsp32.o" to /lib/modules/<kernel version>/kernel/driver/scsi/pcmcia/ .
+
+[8] Type "depmod -ae" to re-made "/lib/modules/<kernel version>/modules.pcimap"
+
+[9] Ok. Now you can use Ninja card in CardBus mode. Check your Ninja card is in
+    CardBus mode, and insert the card to PC card slot.
+
+
+
+3. Caution
+
+ If you eject card during doing some operation for your SCSI device or
+suspend your computer, you may encount some *BAD* error like disk
+crash.  It works well when we use this driver right way. But we do not
+guarantee your data.  Please backup your data when you use this driver.
+
+
+
+4. Copyright.
+
+ No, no, this is Copyleft software. See GPL.
+
+
+
+5. Module option
+
+ Parameter:	trans_mode
+ Value:		0	BIOS (default)
+		1	Async
+		2	Ultra20M
+ Description: 
+		You can select which transfer speed mode you want to
+		use.  Default is BIOS mode.  This driver automatically
+		reads transfer mode from BIOS (so you can select each
+		SCSI device transfer speed in NinjaSCSI-32Bi/UDE BIOS
+		menu).
+
+		If you select Ultra20M mode, then this driver always
+		tries to optimize the transfer speed for all devices.
+		Even if you set the transfer speed for each devices in
+		BIOS menu, the driver ignores them.  This mode is
+		useful when you find the new NinjaSCSI-32Bi/UDE card
+		but it does not support new BIOS setting with the
+		current device driver.
+
+		If you select Async mode, then this driver always
+		falls back to SCSI asynchronous transfer mode.  The
+		speed of this mode is about 1.5MB/sec.  This mode is
+		useful when you find your SCSI device or SCSI card
+		don't work with this driver.  If you find such
+		devices, please use this mode, and report us.
+
+
+YOKOTA Hiroshi, GOTO Masanori

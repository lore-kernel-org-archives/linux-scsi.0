From: Yokota Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Subject: [PATCH 3/13] nsp32, nsp_cs driver update
Date: Tue, 22 Feb 2005 16:04:48 +0900 (JST)
Message-ID: <20050222.160448.71153322.yokota@netlab.is.tsukuba.ac.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Received: from pixy-gw.netlab.cs.tsukuba.ac.jp ([130.158.83.98]:35854 "HELO
	pixy.netlab.cs.tsukuba.ac.jp") by vger.kernel.org with SMTP
	id S262227AbVBVHEt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Feb 2005 02:04:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--- linux-2.6.10/Documentation/scsi/nsp_cs.txt	1970-01-01 09:00:00.000000000 +0900
+++ linux-2.6.10-nsp/Documentation/scsi/nsp_cs.txt	2005-02-22 08:44:10.000000000 +0900
@@ -0,0 +1,126 @@
+
+         WorkBiT NinjaSCSI-3/32Bi driver for Linux
+
+1. Comment
+ This is Workbit corp.'s(http://www.workbit.co.jp/) NinjaSCSI-3
+(http://www.workbit.co.jp/ts/z_nj3r.html) and NinjaSCSI-32Bi
+(http://www.workbit.co.jp/ts/z_njsc32bi.html) PCMCIA card driver module
+for Linux.
+
+2. My Linux environment
+Linux kernel: 2.6.10
+pcmcia-cs:    3.2.5
+gcc:          gcc-3.3.5
+PC card:      I-O data PCSC-F (NinjaSCSI-3)
+              I-O data CBSC-II in 16 bit mode (NinjaSCSI-32Bi)
+SCSI device:  I-O data CDPS-PX24 (CD-ROM drive)
+              Media Intelligent MMO-640GT (Optical disk drive)
+
+3. Install
+[1] Check your PC card is true "NinjaSCSI-3" card.
+    If you installed pcmcia-cs already, pcmcia reports your card as "unknown"
+    card, and write ["WBT", "NinjaSCSI-3", "R1.0"] or some other string to
+    your console or log file.
+    You can also use "cardctl" program (this program is in pcmcia-cs source
+    code) to get more info.
+
+# cat /var/log/messgaes
+...
+Jan  2 03:45:06 lindberg cardmgr[78]: unsupported card in socket 1
+Jan  2 03:45:06 lindberg cardmgr[78]:   product info: "WBT", "NinjaSCSI-3", "R1.0"
+...
+# cardctl ident
+Socket 0:
+  no product info available
+Socket 1:
+  product info: "IO DATA", "CBSC16       ", "1"
+
+
+[2] Get Linux kernel source, and extract it to /usr/src.
+    Because NinjaSCSI driver requiers some SCSI header files in Linux kernel
+    source. And this driver also requires that your kernel supports
+    PCMCIA subsystem and ISA bus.
+    I recomend rebuilding your kernel.
+$ cd /usr/src
+$ tar -zxvf linux-x.x.x.tar.gz
+$ cd linux
+$ make config
+...
+
+[3] Extract this driver's archive somewhere, and edit Makefile, then do make.
+$ tar -zxvf nsp_cs+nsp32-xxx.tar.gz
+$ cd nsp_cs+nsp32-xxx
+$ emacs Makefile
+...
+$ make
+
+[4] Copy nsp_cs.o(2.4 kernel)/nsp_cs.ko(2.6 kernel) to suitable plase,
+    like "/lib/modules/<Kernel version>/pcmcia/" or 
+    "/lib/modules/<Kernel version>/kernel/driver/scsi/pcmcia/".
+
+[5] Add these lines to /etc/pcmcia/config .
+    If you yse pcmcia-cs-3.1.8 or later, we can use "nsp_cs.conf" file.
+    So, you don't need to edit file. Just copy to /etc/pcmcia/ .
+
+-------------------------------------
+device "nsp_cs"
+  class "scsi" module "nsp_cs"
+
+card "WorkBit NinjaSCSI-3"
+  version "WBT", "NinjaSCSI-3", "R1.0"
+  bind "nsp_cs"
+
+card "WorkBit NinjaSCSI-32Bi (16bit)"
+  version "WORKBIT", "UltraNinja-16", "1"
+  bind "nsp_cs"
+
+# OEM
+card "WorkBit NinjaSCSI-32Bi (16bit) / IO-DATA"
+  version "IO DATA", "CBSC16       ", "1"
+  bind "nsp_cs"
+
+# OEM
+card "WorkBit NinjaSCSI-32Bi (16bit) / KME-1"
+  version "KME    ", "SCSI-CARD-001", "1"
+  bind "nsp_cs"
+card "WorkBit NinjaSCSI-32Bi (16bit) / KME-2"
+  version "KME    ", "SCSI-CARD-002", "1"
+  bind "nsp_cs"
+card "WorkBit NinjaSCSI-32Bi (16bit) / KME-3"
+  version "KME    ", "SCSI-CARD-003", "1"
+  bind "nsp_cs"
+card "WorkBit NinjaSCSI-32Bi (16bit) / KME-4"
+  version "KME    ", "SCSI-CARD-004", "1"
+  bind "nsp_cs"
+-------------------------------------
+
+[6] Start (or restart) pcmcia-cs.
+# /etc/rc.d/rc.pcmcia start        (BSD style)
+or
+# /etc/init.d/pcmcia start         (SYSV style)
+
+
+4. History
+See README.nin_cs .
+
+5. Caution
+ If you eject card when doing some operation for your SCSI device or suspend
+your computer, you encount some *BAD* error like disk crash.
+ It works good when I using this driver right way. But I'm not guarantee
+your data. Please backup your data when you use this driver.
+
+6. Known Bugs
+ Many bugs in this driver. Be careful!
+
+7. Testing
+ Please send me some reports(bug reports etc..) of this software.
+When you send report, please tell me these or more.
+	card name
+	kernel version
+	your SCSI device name(hard drive, CD-ROM, etc...)
+
+8. Copyright
+ See GPL.
+
+
+2005/02/22 yokota (at) netlab.is.tsukuba.ac.jp <YOKOTA Hiroshi>

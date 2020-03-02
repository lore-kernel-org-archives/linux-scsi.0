Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D1D0C3F2D6
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E868D246B9
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583137027;
	bh=qnOcMWBVyOrLDL9qUMoQRMKsUWyqtsUnvIWanywp9n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=MCgWlVoRscsG1s4OfqkuJ6YXRtXfYR6bSHsZCmRdsvvaSE/63jIT2ej8Oec7VX5c7
	 wlLeALbX76l7YXJDPjZ1UC5yz7aP4YEouODxwNSIVsBU7eJPmmlrI43rZcoZV8cbrT
	 b0x0Ev4fCh42T/hDOtacuOesQl6D/l76ieo0XSVY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbgCBIRG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 03:17:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:57232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727386AbgCBIQY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 03:16:24 -0500
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEB29246BE;
        Mon,  2 Mar 2020 08:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583136982;
        bh=qnOcMWBVyOrLDL9qUMoQRMKsUWyqtsUnvIWanywp9n4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n1VkBPKaBgXAEJQYPtTE4ufBXvF6UjpCSkl24qzmKML+J9GzmNn/ps9IWDH1yM+TT
         GhnzBXUNqepjKzJLBJ/lpTZOS2KUfP66DRCFo6Cl9K9uOkYlPWERjofNX9oKlbcPvq
         8E/NDiEOjxnPVNIC9lbnU/Lq0L5e5upq/9tYxjpg=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1j8gFN-0003yR-L9; Mon, 02 Mar 2020 09:16:17 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        GOTO Masanori <gotom@debian.or.jp>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 24/42] docs: scsi: convert NinjaSCSI.txt to ReST
Date:   Mon,  2 Mar 2020 09:15:57 +0100
Message-Id: <6385a411d000dad005b78647629e43700580ecf0.1583136624.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <cover.1583136624.git.mchehab+huawei@kernel.org>
References: <cover.1583136624.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../scsi/{NinjaSCSI.txt => NinjaSCSI.rst}     | 198 +++++++++++-------
 Documentation/scsi/index.rst                  |   1 +
 MAINTAINERS                                   |   4 +-
 drivers/scsi/pcmcia/Kconfig                   |   2 +-
 4 files changed, 121 insertions(+), 84 deletions(-)
 rename Documentation/scsi/{NinjaSCSI.txt => NinjaSCSI.rst} (28%)

diff --git a/Documentation/scsi/NinjaSCSI.txt b/Documentation/scsi/NinjaSCSI.rst
similarity index 28%
rename from Documentation/scsi/NinjaSCSI.txt
rename to Documentation/scsi/NinjaSCSI.rst
index ac8db8ceec77..999a6ed5bf7e 100644
--- a/Documentation/scsi/NinjaSCSI.txt
+++ b/Documentation/scsi/NinjaSCSI.rst
@@ -1,127 +1,163 @@
+.. SPDX-License-Identifier: GPL-2.0
 
-         WorkBiT NinjaSCSI-3/32Bi driver for Linux
+=========================================
+WorkBiT NinjaSCSI-3/32Bi driver for Linux
+=========================================
 
 1. Comment
- This is Workbit corp.'s(http://www.workbit.co.jp/) NinjaSCSI-3
+==========
+
+This is Workbit corp.'s(http://www.workbit.co.jp/) NinjaSCSI-3
 for Linux.
 
 2. My Linux environment
-Linux kernel: 2.4.7 / 2.2.19
-pcmcia-cs:    3.1.27
-gcc:          gcc-2.95.4
-PC card:      I-O data PCSC-F (NinjaSCSI-3)
-              I-O data CBSC-II in 16 bit mode (NinjaSCSI-32Bi)
-SCSI device:  I-O data CDPS-PX24 (CD-ROM drive)
-              Media Intelligent MMO-640GT (Optical disk drive)
+=======================
+
+:Linux kernel: 2.4.7 / 2.2.19
+:pcmcia-cs:    3.1.27
+:gcc:          gcc-2.95.4
+:PC card:      I-O data PCSC-F (NinjaSCSI-3),
+               I-O data CBSC-II in 16 bit mode (NinjaSCSI-32Bi)
+:SCSI device:  I-O data CDPS-PX24 (CD-ROM drive),
+               Media Intelligent MMO-640GT (Optical disk drive)
 
 3. Install
-[1] Check your PC card is true "NinjaSCSI-3" card.
+==========
+
+(a) Check your PC card is true "NinjaSCSI-3" card.
+
     If you installed pcmcia-cs already, pcmcia reports your card as UNKNOWN
     card, and write ["WBT", "NinjaSCSI-3", "R1.0"] or some other string to
     your console or log file.
+
     You can also use "cardctl" program (this program is in pcmcia-cs source
     code) to get more info.
 
-# cat /var/log/messages
-...
-Jan  2 03:45:06 lindberg cardmgr[78]: unsupported card in socket 1
-Jan  2 03:45:06 lindberg cardmgr[78]:   product info: "WBT", "NinjaSCSI-3", "R1.0"
-...
-# cardctl ident
-Socket 0:
-  no product info available
-Socket 1:
-  product info: "IO DATA", "CBSC16       ", "1"
+    ::
 
+	# cat /var/log/messages
+	...
+	Jan  2 03:45:06 lindberg cardmgr[78]: unsupported card in socket 1
+	Jan  2 03:45:06 lindberg cardmgr[78]:   product info: "WBT", "NinjaSCSI-3", "R1.0"
+	...
+	# cardctl ident
+	Socket 0:
+	  no product info available
+	Socket 1:
+	  product info: "IO DATA", "CBSC16       ", "1"
 
-[2] Get the Linux kernel source, and extract it to /usr/src.
+
+(b) Get the Linux kernel source, and extract it to /usr/src.
     Because the NinjaSCSI driver requires some SCSI header files in Linux 
     kernel source, I recommend rebuilding your kernel; this eliminates 
     some versioning problems.
-$ cd /usr/src
-$ tar -zxvf linux-x.x.x.tar.gz
-$ cd linux
-$ make config
-...
 
-[3] If you use this driver with Kernel 2.2, unpack pcmcia-cs in some directory
+    ::
+
+	$ cd /usr/src
+	$ tar -zxvf linux-x.x.x.tar.gz
+	$ cd linux
+	$ make config
+	...
+
+(c) If you use this driver with Kernel 2.2, unpack pcmcia-cs in some directory
     and make & install. This driver requires the pcmcia-cs header file.
-$ cd /usr/src
-$ tar zxvf cs-pcmcia-cs-3.x.x.tar.gz
-...
 
-[4] Extract this driver's archive somewhere, and edit Makefile, then do make.
-$ tar -zxvf nsp_cs-x.x.tar.gz
-$ cd nsp_cs-x.x
-$ emacs Makefile
-...
-$ make
+    ::
 
-[5] Copy nsp_cs.ko to suitable place, like /lib/modules/<Kernel version>/pcmcia/ .
+	$ cd /usr/src
+	$ tar zxvf cs-pcmcia-cs-3.x.x.tar.gz
+	...
+
+(d) Extract this driver's archive somewhere, and edit Makefile, then do make::
+
+	$ tar -zxvf nsp_cs-x.x.tar.gz
+	$ cd nsp_cs-x.x
+	$ emacs Makefile
+	...
+	$ make
+
+(e) Copy nsp_cs.ko to suitable place, like /lib/modules/<Kernel version>/pcmcia/ .
+
+(f) Add these lines to /etc/pcmcia/config .
 
-[6] Add these lines to /etc/pcmcia/config .
     If you use pcmcia-cs-3.1.8 or later, we can use "nsp_cs.conf" file.
     So, you don't need to edit file. Just copy to /etc/pcmcia/ .
 
--------------------------------------
-device "nsp_cs"
-  class "scsi" module "nsp_cs"
-
-card "WorkBit NinjaSCSI-3"
-  version "WBT", "NinjaSCSI-3", "R1.0"
-  bind "nsp_cs"
-
-card "WorkBit NinjaSCSI-32Bi (16bit)"
-  version "WORKBIT", "UltraNinja-16", "1"
-  bind "nsp_cs"
-
-# OEM
-card "WorkBit NinjaSCSI-32Bi (16bit) / IO-DATA"
-  version "IO DATA", "CBSC16       ", "1"
-  bind "nsp_cs"
-
-# OEM
-card "WorkBit NinjaSCSI-32Bi (16bit) / KME-1"
-  version "KME    ", "SCSI-CARD-001", "1"
-  bind "nsp_cs"
-card "WorkBit NinjaSCSI-32Bi (16bit) / KME-2"
-  version "KME    ", "SCSI-CARD-002", "1"
-  bind "nsp_cs"
-card "WorkBit NinjaSCSI-32Bi (16bit) / KME-3"
-  version "KME    ", "SCSI-CARD-003", "1"
-  bind "nsp_cs"
-card "WorkBit NinjaSCSI-32Bi (16bit) / KME-4"
-  version "KME    ", "SCSI-CARD-004", "1"
-  bind "nsp_cs"
--------------------------------------
-
-[7] Start (or restart) pcmcia-cs.
-# /etc/rc.d/rc.pcmcia start        (BSD style)
-or
-# /etc/init.d/pcmcia start         (SYSV style)
+    ::
+
+	device "nsp_cs"
+	  class "scsi" module "nsp_cs"
+
+	card "WorkBit NinjaSCSI-3"
+	  version "WBT", "NinjaSCSI-3", "R1.0"
+	  bind "nsp_cs"
+
+	card "WorkBit NinjaSCSI-32Bi (16bit)"
+	  version "WORKBIT", "UltraNinja-16", "1"
+	  bind "nsp_cs"
+
+	# OEM
+	card "WorkBit NinjaSCSI-32Bi (16bit) / IO-DATA"
+	  version "IO DATA", "CBSC16       ", "1"
+	  bind "nsp_cs"
+
+	# OEM
+	card "WorkBit NinjaSCSI-32Bi (16bit) / KME-1"
+	  version "KME    ", "SCSI-CARD-001", "1"
+	  bind "nsp_cs"
+	card "WorkBit NinjaSCSI-32Bi (16bit) / KME-2"
+	  version "KME    ", "SCSI-CARD-002", "1"
+	  bind "nsp_cs"
+	card "WorkBit NinjaSCSI-32Bi (16bit) / KME-3"
+	  version "KME    ", "SCSI-CARD-003", "1"
+	  bind "nsp_cs"
+	card "WorkBit NinjaSCSI-32Bi (16bit) / KME-4"
+	  version "KME    ", "SCSI-CARD-004", "1"
+	  bind "nsp_cs"
+
+(f) Start (or restart) pcmcia-cs::
+
+	# /etc/rc.d/rc.pcmcia start        (BSD style)
+
+    or::
+
+	# /etc/init.d/pcmcia start         (SYSV style)
 
 
 4. History
+==========
+
 See README.nin_cs .
 
 5. Caution
- If you eject card when doing some operation for your SCSI device or suspend
+==========
+
+If you eject card when doing some operation for your SCSI device or suspend
 your computer, you encount some *BAD* error like disk crash.
- It works good when I using this driver right way. But I'm not guarantee
+
+It works good when I using this driver right way. But I'm not guarantee
 your data. Please backup your data when you use this driver.
 
 6. Known Bugs
- In 2.4 kernel, you can't use 640MB Optical disk. This error comes from
+=============
+
+In 2.4 kernel, you can't use 640MB Optical disk. This error comes from
 high level SCSI driver.
 
 7. Testing
- Please send me some reports(bug reports etc..) of this software.
+==========
+
+Please send me some reports(bug reports etc..) of this software.
 When you send report, please tell me these or more.
-	card name
-	kernel version
-	your SCSI device name(hard drive, CD-ROM, etc...)
+
+	- card name
+	- kernel version
+	- your SCSI device name(hard drive, CD-ROM, etc...)
 
 8. Copyright
+============
+
  See GPL.
 
 
diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
index a2545efbb407..eb2df0e0dcb7 100644
--- a/Documentation/scsi/index.rst
+++ b/Documentation/scsi/index.rst
@@ -28,5 +28,6 @@ Linux SCSI Subsystem
    lpfc
    megaraid
    ncr53c8xx
+   NinjaSCSI
 
    scsi_transport_srp/figures
diff --git a/MAINTAINERS b/MAINTAINERS
index 6d28bfc72259..2f441cf59b4b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11861,7 +11861,7 @@ NINJA SCSI-3 / NINJA SCSI-32Bi (16bit/CardBus) PCMCIA SCSI HOST ADAPTER DRIVER
 M:	YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
 W:	http://www.netlab.is.tsukuba.ac.jp/~yokota/izumi/ninja/
 S:	Maintained
-F:	Documentation/scsi/NinjaSCSI.txt
+F:	Documentation/scsi/NinjaSCSI.rst
 F:	drivers/scsi/pcmcia/nsp_*
 
 NINJA SCSI-32Bi/UDE PCI/CARDBUS SCSI HOST ADAPTER DRIVER
@@ -11869,7 +11869,7 @@ M:	GOTO Masanori <gotom@debian.or.jp>
 M:	YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
 W:	http://www.netlab.is.tsukuba.ac.jp/~yokota/izumi/ninja/
 S:	Maintained
-F:	Documentation/scsi/NinjaSCSI.txt
+F:	Documentation/scsi/NinjaSCSI.rst
 F:	drivers/scsi/nsp32*
 
 NIOS2 ARCHITECTURE
diff --git a/drivers/scsi/pcmcia/Kconfig b/drivers/scsi/pcmcia/Kconfig
index dc9b74c9348a..9696b6b5591f 100644
--- a/drivers/scsi/pcmcia/Kconfig
+++ b/drivers/scsi/pcmcia/Kconfig
@@ -36,7 +36,7 @@ config PCMCIA_NINJA_SCSI
 	help
 	  If you intend to attach this type of PCMCIA SCSI host adapter to
 	  your computer, say Y here and read
-	  <file:Documentation/scsi/NinjaSCSI.txt>.
+	  <file:Documentation/scsi/NinjaSCSI.rst>.
 
 	  Supported cards:
 
-- 
2.21.1


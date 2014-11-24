From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 3/3] wd719x: Add firmware documentation
Date: Mon, 24 Nov 2014 13:11:14 +0100
Message-ID: <1416831074-24282-4-git-send-email-linux@rainbow-software.org>
References: <1416831074-24282-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1416831074-24282-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Kernel development list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Add documentation and script to obtain required firmware.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 Documentation/scsi/wd719x.txt |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/scsi/wd719x.txt

diff --git a/Documentation/scsi/wd719x.txt b/Documentation/scsi/wd719x.txt
new file mode 100644
index 0000000..0816b02
--- /dev/null
+++ b/Documentation/scsi/wd719x.txt
@@ -0,0 +1,21 @@
+Driver for Western Digital WD7193, WD7197 and WD7296 SCSI cards
+---------------------------------------------------------------
+
+The card requires firmware that can be cut out of the Windows NT driver that
+can be downloaded from WD at:
+http://support.wdc.com/product/download.asp?groupid=801&sid=27&lang=en
+
+There is no license anywhere in the file or on the page - so the firmware
+probably cannot be added to linux-firmware.
+
+This script downloads and extracts the firmware, creating wd719x-risc.bin and
+d719x-wcs.bin files. Put them in /lib/firmware/.
+
+#!/bin/sh
+wget http://support.wdc.com/download/archive/pciscsi.exe
+lha xi pciscsi.exe pci-scsi.exe
+lha xi pci-scsi.exe nt/wd7296a.sys
+rm pci-scsi.exe
+dd if=wd7296a.sys of=wd719x-risc.bin bs=1 skip=5760 count=14336
+dd if=wd7296a.sys of=wd719x-wcs.bin bs=1 skip=20096 count=514
+rm wd7296a.sys
-- 
Ondrej Zary

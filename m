From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: [PATCH] advansys section fixes
Date: Thu, 8 Jun 2006 20:46:35 -0700
Message-ID: <20060608204635.376e0641.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:64711 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S965126AbWFIDuY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2006 23:50:24 -0400
Received: from midway.site ([71.245.102.105]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 8 Jun 2006 20:50:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>, akpm <akpm@osdl.org>, bobf@advansys.com

From: Randy Dunlap <rdunlap@xenotime.net>

Priority: not critical.
Mark 3 functions __init.  Saves a little memory.
This makes these functions' calls to AdvWaitEEPCmd() (which is __init)
be clean (i.e., eliminates text -> init -> text call chain).

Fix multiple section mismatch warnings:
WARNING: drivers/scsi/advansys.o - Section mismatch: reference to .init.text: from .text between 'AdvSet3550EEPConfig' (at offset 0x7a22) and 'AdvSet38C0800EEPConfig'
WARNING: drivers/scsi/advansys.o - Section mismatch: reference to .init.text: from .text between 'AdvSet3550EEPConfig' (at offset 0x7a4e) and 'AdvSet38C0800EEPConfig'
WARNING: drivers/scsi/advansys.o - Section mismatch: reference to .init.text: from .text between 'AdvSet3550EEPConfig' (at offset 0x7a79) and 'AdvSet38C0800EEPConfig'
WARNING: drivers/scsi/advansys.o - Section mismatch: reference to .init.text: from .text between 'AdvSet3550EEPConfig' (at offset 0x7aa2) and 'AdvSet38C0800EEPConfig'
WARNING: drivers/scsi/advansys.o - Section mismatch: reference to .init.text: from .text between 'AdvSet3550EEPConfig' (at offset 0x7abb) and 'AdvSet38C0800EEPConfig'
WARNING: drivers/scsi/advansys.o - Section mismatch: reference to .init.text: from .text between 'AdvSet38C0800EEPConfig' (at offset 0x7ae0) and 'AdvSet38C1600EEPConfig'
WARNING: drivers/scsi/advansys.o - Section mismatch: reference to .init.text: from .text between 'AdvSet38C0800EEPConfig' (at offset 0x7b0c) and 'AdvSet38C1600EEPConfig'
WARNING: drivers/scsi/advansys.o - Section mismatch: reference to .init.text: from .text between 'AdvSet38C0800EEPConfig' (at offset 0x7b37) and 'AdvSet38C1600EEPConfig'
WARNING: drivers/scsi/advansys.o - Section mismatch: reference to .init.text: from .text between 'AdvSet38C0800EEPConfig' (at offset 0x7b60) and 'AdvSet38C1600EEPConfig'
WARNING: drivers/scsi/advansys.o - Section mismatch: reference to .init.text: from .text between 'AdvSet38C0800EEPConfig' (at offset 0x7b79) and 'AdvSet38C1600EEPConfig'
WARNING: drivers/scsi/advansys.o - Section mismatch: reference to .init.text: from .text between 'AdvSet38C1600EEPConfig' (at offset 0x7b9e) and 'AdvExeScsiQueue'
WARNING: drivers/scsi/advansys.o - Section mismatch: reference to .init.text: from .text between 'AdvSet38C1600EEPConfig' (at offset 0x7bca) and 'AdvExeScsiQueue'
WARNING: drivers/scsi/advansys.o - Section mismatch: reference to .init.text: from .text between 'AdvSet38C1600EEPConfig' (at offset 0x7bf5) and 'AdvExeScsiQueue'
WARNING: drivers/scsi/advansys.o - Section mismatch: reference to .init.text: from .text between 'AdvSet38C1600EEPConfig' (at offset 0x7c1e) and 'AdvExeScsiQueue'
WARNING: drivers/scsi/advansys.o - Section mismatch: reference to .init.text: from .text between 'AdvSet38C1600EEPConfig' (at offset 0x7c37) and 'AdvExeScsiQueue'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/scsi/advansys.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2617-rc6.orig/drivers/scsi/advansys.c
+++ linux-2617-rc6/drivers/scsi/advansys.c
@@ -17316,7 +17316,7 @@ AdvWaitEEPCmd(AdvPortAddr iop_base)
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-void
+void __init
 AdvSet3550EEPConfig(AdvPortAddr iop_base, ADVEEP_3550_CONFIG *cfg_buf)
 {
     ushort *wbuf;
@@ -17383,7 +17383,7 @@ AdvSet3550EEPConfig(AdvPortAddr iop_base
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-void
+void __init
 AdvSet38C0800EEPConfig(AdvPortAddr iop_base,
                        ADVEEP_38C0800_CONFIG *cfg_buf)
 {
@@ -17451,7 +17451,7 @@ AdvSet38C0800EEPConfig(AdvPortAddr iop_b
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-void
+void __init
 AdvSet38C1600EEPConfig(AdvPortAddr iop_base,
                        ADVEEP_38C1600_CONFIG *cfg_buf)
 {


---

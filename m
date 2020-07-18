Return-Path: <SRS0=8IEi=A5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD68C433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 12:28:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1A7920759
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 12:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgGRM2j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jul 2020 08:28:39 -0400
Received: from smtp.al2klimov.de ([78.46.175.9]:33980 "EHLO smtp.al2klimov.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726493AbgGRM2j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Jul 2020 08:28:39 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 2108ABC062;
        Sat, 18 Jul 2020 12:28:33 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, vigneshr@ti.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, esc.storagedev@microsemi.com
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH] scsi: Replace HTTP links with HTTPS ones
Date:   Sat, 18 Jul 2020 14:28:27 +0200
Message-Id: <20200718122827.19884-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `\bxmlns\b`:
        For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
            If both the HTTP and HTTPS versions
            return 200 OK and serve the same content:
              Replace HTTP with HTTPS.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 Continuing my work started at 93431e0607e5.
 See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
 (Actually letting a shell for loop submit all this stuff for me.)

 If there are any URLs to be removed completely
 or at least not (just) HTTPSified:
 Just clearly say so and I'll *undo my change*.
 See also: https://lkml.org/lkml/2020/6/27/64

 If there are any valid, but yet not changed URLs:
 See: https://lkml.org/lkml/2020/6/26/837

 If you apply the patch, please let me know.

 Sorry again to all maintainers who complained about subject lines.
 Now I realized that you want an actually perfect prefixes,
 not just subsystem ones.
 I tried my best...
 And yes, *I could* (at least half-)automate it.
 Impossible is nothing! :)


 drivers/scsi/Kconfig                  | 40 +++++++++++++--------------
 drivers/scsi/hptiop.h                 |  2 +-
 drivers/scsi/sense_codes.h            |  2 +-
 drivers/scsi/smartpqi/Kconfig         |  2 +-
 drivers/scsi/smartpqi/smartpqi_init.c |  2 +-
 drivers/scsi/ufs/ti-j721e-ufs.c       |  2 +-
 6 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index e9ff4cd5fbe9..87b0d56c0f61 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -75,7 +75,7 @@ config BLK_DEV_SD
 	  USB storage or the SCSI or parallel port version of
 	  the IOMEGA ZIP drive, say Y and read the SCSI-HOWTO,
 	  the Disk-HOWTO and the Multi-Disk-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>. This is NOT for SCSI
+	  <https://www.tldp.org/docs.html#howto>. This is NOT for SCSI
 	  CD-ROMs.
 
 	  To compile this driver as a module, choose M here and read
@@ -93,7 +93,7 @@ config CHR_DEV_ST
 	help
 	  If you want to use a SCSI tape drive under Linux, say Y and read the
 	  SCSI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, and
+	  <https://www.tldp.org/docs.html#howto>, and
 	  <file:Documentation/scsi/st.rst> in the kernel source.  This is NOT
 	  for SCSI CD-ROMs.
 
@@ -107,7 +107,7 @@ config BLK_DEV_SR
 	help
 	  If you want to use a CD or DVD drive attached to your computer
 	  by SCSI, FireWire, USB or ATAPI, say Y and read the SCSI-HOWTO
-	  and the CDROM-HOWTO at <http://www.tldp.org/docs.html#howto>.
+	  and the CDROM-HOWTO at <https://www.tldp.org/docs.html#howto>.
 
 	  Make sure to say Y or M to "ISO 9660 CD-ROM file system support".
 
@@ -130,7 +130,7 @@ config CHR_DEV_SG
 	  (<http://cdrtools.sourceforge.net/>)
 	  and for burning a "disk at once": CDRDAO
 	  (<http://cdrdao.sourceforge.net/>). Cdparanoia is a high
-	  quality digital reader of audio CDs (<http://www.xiph.org/paranoia/>).
+	  quality digital reader of audio CDs (<https://www.xiph.org/paranoia/>).
 	  For other devices, it's possible that you'll have to write the
 	  driver software yourself. Please read the file
 	  <file:Documentation/scsi/scsi-generic.rst> for more information.
@@ -382,7 +382,7 @@ config SCSI_AHA152X
 	  must be manually specified in this case.
 
 	  It is explained in section 3.3 of the SCSI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>. You might also want to
+	  <https://www.tldp.org/docs.html#howto>. You might also want to
 	  read the file <file:Documentation/scsi/aha152x.rst>.
 
 	  To compile this driver as a module, choose M here: the
@@ -394,7 +394,7 @@ config SCSI_AHA1542
 	help
 	  This is support for a SCSI host adapter.  It is explained in section
 	  3.4 of the SCSI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.  Note that Trantor was
+	  <https://www.tldp.org/docs.html#howto>.  Note that Trantor was
 	  purchased by Adaptec, and some former Trantor products are being
 	  sold under the Adaptec name.  If it doesn't work out of the box, you
 	  may have to change some settings in <file:drivers/scsi/aha1542.h>.
@@ -408,7 +408,7 @@ config SCSI_AHA1740
 	help
 	  This is support for a SCSI host adapter.  It is explained in section
 	  3.5 of the SCSI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.  If it doesn't work out
+	  <https://www.tldp.org/docs.html#howto>.  If it doesn't work out
 	  of the box, you may have to change some settings in
 	  <file:drivers/scsi/aha1740.h>.
 
@@ -474,7 +474,7 @@ config SCSI_ARCMSR
 	  This is an ARECA-maintained driver by Erich Chen.
 	  If you have any problems, please mail to: <erich@areca.com.tw>.
 	  Areca supports Linux RAID config tools.
-	  Please link <http://www.areca.com.tw>
+	  Please link <https://www.areca.com.tw>
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called arcmsr (modprobe arcmsr).
@@ -501,7 +501,7 @@ config SCSI_BUSLOGIC
 	help
 	  This is support for BusLogic MultiMaster and FlashPoint SCSI Host
 	  Adapters. Consult the SCSI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, and the files
+	  <https://www.tldp.org/docs.html#howto>, and the files
 	  <file:Documentation/scsi/BusLogic.rst> and
 	  <file:Documentation/scsi/FlashPoint.rst> for more information.
 	  Note that support for FlashPoint is only available for 32-bit
@@ -710,8 +710,8 @@ config SCSI_IPS
 	depends on PCI && SCSI
 	help
 	  This is support for the IBM ServeRAID hardware RAID controllers.
-	  See <http://www.developer.ibm.com/welcome/netfinity/serveraid.html>
-	  and <http://www-947.ibm.com/support/entry/portal/docdisplay?brand=5000008&lndocid=SERV-RAID>
+	  See <https://www.developer.ibm.com/welcome/netfinity/serveraid.html>
+	  and <https://www-947.ibm.com/support/entry/portal/docdisplay?brand=5000008&lndocid=SERV-RAID>
 	  for more information.  If this driver does not work correctly
 	  without modification please contact the author by email at
 	  <ipslinux@adaptec.com>.
@@ -771,7 +771,7 @@ config SCSI_INITIO
 	help
 	  This is support for the Initio 91XXU(W) SCSI host adapter.  Please
 	  read the SCSI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
+	  <https://www.tldp.org/docs.html#howto>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called initio.
@@ -782,7 +782,7 @@ config SCSI_INIA100
 	help
 	  This is support for the Initio INI-A100U2W SCSI host adapter.
 	  Please read the SCSI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
+	  <https://www.tldp.org/docs.html#howto>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called a100u2w.
@@ -806,7 +806,7 @@ config SCSI_PPA
 	  For more information about this driver and how to use it you should
 	  read the file <file:Documentation/scsi/ppa.rst>.  You should also read
 	  the SCSI-HOWTO, which is available from
-	  <http://www.tldp.org/docs.html#howto>.  If you use this driver,
+	  <https://www.tldp.org/docs.html#howto>.  If you use this driver,
 	  you will still be able to use the parallel port for other tasks,
 	  such as a printer; it is safe to compile both drivers into the
 	  kernel.
@@ -833,7 +833,7 @@ config SCSI_IMM
 	  For more information about this driver and how to use it you should
 	  read the file <file:Documentation/scsi/ppa.rst>.  You should also read
 	  the SCSI-HOWTO, which is available from
-	  <http://www.tldp.org/docs.html#howto>.  If you use this driver,
+	  <https://www.tldp.org/docs.html#howto>.  If you use this driver,
 	  you will still be able to use the parallel port for other tasks,
 	  such as a printer; it is safe to compile both drivers into the
 	  kernel.
@@ -900,7 +900,7 @@ config SCSI_STEX
 	  This driver supports Promise SuperTrak EX series storage controllers.
 
 	  Promise provides Linux RAID configuration utility for these
-	  controllers. Please visit <http://www.promise.com> to download.
+	  controllers. Please visit <https://www.promise.com> to download.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called stex.
@@ -1120,7 +1120,7 @@ config SCSI_QLOGIC_FAS
 	  Information about this driver is contained in
 	  <file:Documentation/scsi/qlogicfas.rst>.  You should also read the
 	  SCSI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
+	  <https://www.tldp.org/docs.html#howto>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called qlogicfas.
@@ -1215,7 +1215,7 @@ config SCSI_NSP32
 	help
 	  This is support for the Workbit NinjaSCSI-32Bi/UDE PCI/Cardbus
 	  SCSI host adapter. Please read the SCSI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
+	  <https://www.tldp.org/docs.html#howto>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called nsp32.
@@ -1350,7 +1350,7 @@ config SCSI_ZORRO7XX
 	    - the Amiga 4091 Zorro III SCSI-2 controller,
 	    - the MacroSystem Development's WarpEngine Amiga SCSI-2 controller
 	      (info at
-	      <http://www.lysator.liu.se/amiga/ar/guide/ar310.guide?FEATURE5>),
+	      <https://www.lysator.liu.se/amiga/ar/guide/ar310.guide?FEATURE5>),
 	    - the SCSI controller on the Phase5 Blizzard PowerUP 603e+
 	      accelerator card for the Amiga 1200,
 	    - the SCSI controller on the GVP Turbo 040/060 accelerator.
@@ -1396,7 +1396,7 @@ config MAC_SCSI
 	  This is the NCR 5380 SCSI controller included on most of the 68030
 	  based Macintoshes.  If you have one of these say Y and read the
 	  SCSI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
+	  <https://www.tldp.org/docs.html#howto>.
 
 config SCSI_MAC_ESP
 	tristate "Macintosh NCR53c9[46] SCSI"
diff --git a/drivers/scsi/hptiop.h b/drivers/scsi/hptiop.h
index 35184c2008af..44df5b0f0ac5 100644
--- a/drivers/scsi/hptiop.h
+++ b/drivers/scsi/hptiop.h
@@ -5,7 +5,7 @@
  *
  * Please report bugs/comments/suggestions to linux@highpoint-tech.com
  *
- * For more information, visit http://www.highpoint-tech.com
+ * For more information, visit https://www.highpoint-tech.com
  */
 #ifndef _HPTIOP_H_
 #define _HPTIOP_H_
diff --git a/drivers/scsi/sense_codes.h b/drivers/scsi/sense_codes.h
index 201a536688de..6a2d3c7de5ee 100644
--- a/drivers/scsi/sense_codes.h
+++ b/drivers/scsi/sense_codes.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
  * The canonical list of T10 Additional Sense Codes is available at:
- * http://www.t10.org/lists/asc-num.txt [most recent: 20141221]
+ * https://www.t10.org/lists/asc-num.txt [most recent: 20141221]
  */
 
 SENSE_CODE(0x0000, "No additional sense information")
diff --git a/drivers/scsi/smartpqi/Kconfig b/drivers/scsi/smartpqi/Kconfig
index 8eec241f074b..8709e938702c 100644
--- a/drivers/scsi/smartpqi/Kconfig
+++ b/drivers/scsi/smartpqi/Kconfig
@@ -45,7 +45,7 @@ config SCSI_SMARTPQI
 	help
 	This driver supports Microsemi PQI controllers.
 
-	<http://www.microsemi.com>
+	<https://www.microsemi.com>
 
 	To compile this driver as a module, choose M here: the
 	module will be called smartpqi.
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index cd157f11eb22..6b21989b5745 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2773,7 +2773,7 @@ static void pqi_process_raid_io_error(struct pqi_io_request *io_request)
 				host_byte = DID_NO_CONNECT;
 				break;
 
-			default: /* See http://www.t10.org/lists/asc-num.htm#ASC_3E */
+			default: /* See https://www.t10.org/lists/asc-num.htm#ASC_3E */
 				if (printk_ratelimit())
 					scmd_printk(KERN_ERR, scmd, "received unhandled error %d from controller for scsi %d:%d:%d:%d\n",
 						sshdr.ascq, ctrl_info->scsi_host->host_no, device->bus, device->target, device->lun);
diff --git a/drivers/scsi/ufs/ti-j721e-ufs.c b/drivers/scsi/ufs/ti-j721e-ufs.c
index 46bb905b4d6a..b031113b07c9 100644
--- a/drivers/scsi/ufs/ti-j721e-ufs.c
+++ b/drivers/scsi/ufs/ti-j721e-ufs.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 //
-// Copyright (C) 2019 Texas Instruments Incorporated - http://www.ti.com/
+// Copyright (C) 2019 Texas Instruments Incorporated - https://www.ti.com/
 //
 
 #include <linux/clk.h>
-- 
2.27.0


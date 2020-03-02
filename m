Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA0FAC3F2D9
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A69EC246B4
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583137083;
	bh=mTZXZyNfex88ftiSETcaCC5SMnrKlg50EFJe11w+CZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Yz2glCKbmbB+EbYUG5kvn0O2yAwblzuA6N7pmdD3/YA4rxC79WRFrJpoX71ENYkOL
	 hq0tEV5tpRhjxmJs7x6giTTGHo+Nr+bM8s5rswb/lbzfr5/Dxb/0TxnIHQkhC8YxQy
	 IIQxIMTUAx3ft5Rv8O6k6A4OFKN3/z8mpOWMwJsY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbgCBIQW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 03:16:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:57062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727125AbgCBIQV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 03:16:21 -0500
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15470246C2;
        Mon,  2 Mar 2020 08:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583136979;
        bh=mTZXZyNfex88ftiSETcaCC5SMnrKlg50EFJe11w+CZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xb0kvZ6KN3ieeoRpvRQcneQE4OvWDGFCIIcdLND2awWpOsxYrUH1h8lRifLuCIFYz
         i0bd0ktaepO9xE4pCY6TX1xlH5wQTPzzT6P+WpOMvXPFlp/4D0J29jwDMf3rLzdzCG
         /5gqiXq8K+MSlRhfZtjLxaXpj8aGySoPSR1rm0Lg=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1j8gFN-0003x3-4m; Mon, 02 Mar 2020 09:16:17 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 06/42] docs: scsi: convert aha152x.txt to ReST
Date:   Mon,  2 Mar 2020 09:15:39 +0100
Message-Id: <097cfcc7f25343676a1fedcefed7e3b91b41b4df.1583136624.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <cover.1583136624.git.mchehab+huawei@kernel.org>
References: <cover.1583136624.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../scsi/{aha152x.txt => aha152x.rst}         | 73 ++++++++++++-------
 Documentation/scsi/index.rst                  |  1 +
 Documentation/scsi/scsi-parameters.txt        |  2 +-
 drivers/scsi/Kconfig                          |  2 +-
 drivers/scsi/aha152x.c                        |  4 +-
 5 files changed, 52 insertions(+), 30 deletions(-)
 rename Documentation/scsi/{aha152x.txt => aha152x.rst} (76%)

diff --git a/Documentation/scsi/aha152x.txt b/Documentation/scsi/aha152x.rst
similarity index 76%
rename from Documentation/scsi/aha152x.txt
rename to Documentation/scsi/aha152x.rst
index 94848734ac66..7012b5c46d5d 100644
--- a/Documentation/scsi/aha152x.txt
+++ b/Documentation/scsi/aha152x.rst
@@ -1,7 +1,12 @@
-$Id: README.aha152x,v 1.2 1999/12/25 15:32:30 fischer Exp fischer $
+.. SPDX-License-Identifier: GPL-2.0
+.. include:: <isonum.txt>
+
+=====================================================
 Adaptec AHA-1520/1522 SCSI driver for Linux (aha152x)
+=====================================================
+
+Copyright |copy| 1993-1999 Jürgen Fischer <fischer@norbit.de>
 
-Copyright 1993-1999 Jürgen Fischer <fischer@norbit.de>
 TC1550 patches by Luuk van Dijk (ldz@xs4all.nl)
 
 
@@ -14,8 +19,10 @@ less polling loops), has slightly higher throughput (at
 least on my ancient test box; a i486/33Mhz/20MB).
 
 
-CONFIGURATION ARGUMENTS:
+Configuration Arguments
+=======================
 
+============  ========================================  ======================
 IOPORT        base io address                           (0x340/0x140)
 IRQ           interrupt level                           (9-12; default 11)
 SCSI_ID       scsi id of controller                     (0-7; default 7)
@@ -25,31 +32,38 @@ SYNCHRONOUS   enable synchronous transfers              (0/1; default 1 [on])
 DELAY:        bus reset delay                           (default 100)
 EXT_TRANS:    enable extended translation               (0/1: default 0 [off])
               (see NOTES)
+============  ========================================  ======================
 
-COMPILE TIME CONFIGURATION (go into AHA152X in drivers/scsi/Makefile):
+Compile Time Configuration
+==========================
 
--DAUTOCONF
- use configuration the controller reports (AHA-152x only)
+(go into AHA152X in drivers/scsi/Makefile):
 
--DSKIP_BIOSTEST
- Don't test for BIOS signature (AHA-1510 or disabled BIOS)
+- DAUTOCONF
+    use configuration the controller reports (AHA-152x only)
 
--DSETUP0="{ IOPORT, IRQ, SCSI_ID, RECONNECT, PARITY, SYNCHRONOUS, DELAY, EXT_TRANS }"
- override for the first controller 
+- DSKIP_BIOSTEST
+    Don't test for BIOS signature (AHA-1510 or disabled BIOS)
 
--DSETUP1="{ IOPORT, IRQ, SCSI_ID, RECONNECT, PARITY, SYNCHRONOUS, DELAY, EXT_TRANS }"
- override for the second controller
+- DSETUP0="{ IOPORT, IRQ, SCSI_ID, RECONNECT, PARITY, SYNCHRONOUS, DELAY, EXT_TRANS }"
+    override for the first controller
 
--DAHA152X_DEBUG
- enable debugging output
+- DSETUP1="{ IOPORT, IRQ, SCSI_ID, RECONNECT, PARITY, SYNCHRONOUS, DELAY, EXT_TRANS }"
+    override for the second controller
 
--DAHA152X_STAT
- enable some statistics
+- DAHA152X_DEBUG
+    enable debugging output
 
+- DAHA152X_STAT
+    enable some statistics
 
-LILO COMMAND LINE OPTIONS:
 
-aha152x=<IOPORT>[,<IRQ>[,<SCSI-ID>[,<RECONNECT>[,<PARITY>[,<SYNCHRONOUS>[,<DELAY> [,<EXT_TRANS]]]]]]]
+LILO Command Line Options
+=========================
+
+ ::
+
+    aha152x=<IOPORT>[,<IRQ>[,<SCSI-ID>[,<RECONNECT>[,<PARITY>[,<SYNCHRONOUS>[,<DELAY> [,<EXT_TRANS]]]]]]]
 
  The normal configuration can be overridden by specifying a command line.
  When you do this, the BIOS test is skipped. Entered values have to be
@@ -58,17 +72,21 @@ aha152x=<IOPORT>[,<IRQ>[,<SCSI-ID>[,<RECONNECT>[,<PARITY>[,<SYNCHRONOUS>[,<DELAY
  For two controllers use the aha152x statement twice.
 
 
-SYMBOLS FOR MODULE CONFIGURATION:
+Symbols for Module Configuration
+================================
 
 Choose from 2 alternatives:
 
-1. specify everything (old)
+1. specify everything (old)::
+
+    aha152x=IOPORT,IRQ,SCSI_ID,RECONNECT,PARITY,SYNCHRONOUS,DELAY,EXT_TRANS
 
-aha152x=IOPORT,IRQ,SCSI_ID,RECONNECT,PARITY,SYNCHRONOUS,DELAY,EXT_TRANS
   configuration override for first controller
 
+  ::
+
+    aha152x1=IOPORT,IRQ,SCSI_ID,RECONNECT,PARITY,SYNCHRONOUS,DELAY,EXT_TRANS
 
-aha152x1=IOPORT,IRQ,SCSI_ID,RECONNECT,PARITY,SYNCHRONOUS,DELAY,EXT_TRANS
   configuration override for second controller
 
 2. specify only what you need to (irq or io is required; new)
@@ -101,7 +119,8 @@ exttrans=EXTTRANS0[,EXTTRANS1]
 If you use both alternatives the first will be taken.
 
 
-NOTES ON EXT_TRANS: 
+Notes on EXT_TRANS
+==================
 
 SCSI uses block numbers to address blocks/sectors on a device.
 The BIOS uses a cylinder/head/sector addressing scheme (C/H/S)
@@ -150,8 +169,9 @@ geometry right in most cases:
 - for disks<1GB: use default translation (C/32/64)
 
 - for disks>1GB:
+
   - take current geometry from the partition table
-    (using scsicam_bios_param and accept only `valid' geometries,
+    (using scsicam_bios_param and accept only 'valid' geometries,
     ie. either (C/32/64) or (C/63/255)).  This can be extended translation
     even if it's not enabled in the driver.
 
@@ -161,7 +181,8 @@ geometry right in most cases:
     disks.
 
 
-REFERENCES USED:
+References Used
+===============
 
  "AIC-6260 SCSI Chip Specification", Adaptec Corporation.
 
@@ -177,7 +198,7 @@ REFERENCES USED:
 
  Drew Eckhardt (drew@cs.colorado.edu)
 
- Eric Youngdale (eric@andante.org) 
+ Eric Youngdale (eric@andante.org)
 
  special thanks to Eric Youngdale for the free(!) supplying the
  documentation on the chip.
diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
index df526a0ceccf..8404e991b588 100644
--- a/Documentation/scsi/index.rst
+++ b/Documentation/scsi/index.rst
@@ -10,5 +10,6 @@ Linux SCSI Subsystem
    53c700
    aacraid
    advansys
+   aha152x
 
    scsi_transport_srp/figures
diff --git a/Documentation/scsi/scsi-parameters.txt b/Documentation/scsi/scsi-parameters.txt
index 25a4b4cf04a6..064d6dfcac26 100644
--- a/Documentation/scsi/scsi-parameters.txt
+++ b/Documentation/scsi/scsi-parameters.txt
@@ -16,7 +16,7 @@ parameters may be changed at runtime by the command
 			See header of drivers/scsi/advansys.c.
 
 	aha152x=	[HW,SCSI]
-			See Documentation/scsi/aha152x.txt.
+			See Documentation/scsi/aha152x.rst.
 
 	aha1542=	[HW,SCSI]
 			Format: <portbase>[,<buson>,<busoff>[,<dmaspeed>]]
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index a153444318fb..18af62594bc0 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -383,7 +383,7 @@ config SCSI_AHA152X
 
 	  It is explained in section 3.3 of the SCSI-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>. You might also want to
-	  read the file <file:Documentation/scsi/aha152x.txt>.
+	  read the file <file:Documentation/scsi/aha152x.rst>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called aha152x.
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index eb466c2e1839..90f97df1c42a 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -220,7 +220,7 @@
  *
  **************************************************************************
 
- see Documentation/scsi/aha152x.txt for configuration details
+ see Documentation/scsi/aha152x.rst for configuration details
 
  **************************************************************************/
 
@@ -1249,7 +1249,7 @@ static int aha152x_biosparam(struct scsi_device *sdev, struct block_device *bdev
 				       "aha152x: unable to verify geometry for disk with >1GB.\n"
 				       "         Using default translation. Please verify yourself.\n"
 				       "         Perhaps you need to enable extended translation in the driver.\n"
-				       "         See Documentation/scsi/aha152x.txt for details.\n");
+				       "         See Documentation/scsi/aha152x.rst for details.\n");
 			}
 		} else {
 			info_array[0] = info[0];
-- 
2.21.1


Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E074C3F2DB
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C9682468E
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583137114;
	bh=VSYlwxOgcKmsJPmO9XgVB01Y5bYH9oETiiWJbAEWE84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=OGccFo6GWZct7JU2V0r+/LuJuogHcz79hU4ddI9Cy6A1tIQxpTmKXBOzNm7FC6rY0
	 J/dtl7Fg66UTgYdpPG7GxkxYLWsRN/W48e6negsl98WE4R6h0GUjocVi64W2LWxFOG
	 5AniDrICzqSY9NHjTXLjaWSoqnMaK25fYgiOtkcA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbgCBISR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 03:18:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:56974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727190AbgCBIQV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 03:16:21 -0500
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58489246DF;
        Mon,  2 Mar 2020 08:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583136979;
        bh=VSYlwxOgcKmsJPmO9XgVB01Y5bYH9oETiiWJbAEWE84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JTaAzv8GDPNJB9SZmyvkuXFZp6FGwMbRh9WqXyiH4E0IDZ+9bZGG5c2i4hLdrV1K7
         IHZglUKa4yJNEJZsXbrtei6xps1TWy6UkIRbGqZL+DOeSwJufLF4o9IJ2rF3zFgJ8P
         CGDL6Ug7jHKYRFYBSa5RnG3EFa3l578T2trEhrg0=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1j8gFN-0003xa-BB; Mon, 02 Mar 2020 09:16:17 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Oliver Neukum <oliver@neukum.org>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        dc395x@twibble.org, linux-scsi@vger.kernel.org
Subject: [PATCH 13/42] docs: scsi: convert dc395x.txt to ReST
Date:   Mon,  2 Mar 2020 09:15:46 +0100
Message-Id: <3c0876df0045695185f922a0404c497a69de36a9.1583136624.git.mchehab+huawei@kernel.org>
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
 Documentation/scsi/{dc395x.txt => dc395x.rst} | 75 +++++++++++--------
 Documentation/scsi/index.rst                  |  1 +
 MAINTAINERS                                   |  2 +-
 drivers/scsi/Kconfig                          |  2 +-
 4 files changed, 48 insertions(+), 32 deletions(-)
 rename Documentation/scsi/{dc395x.txt => dc395x.rst} (64%)

diff --git a/Documentation/scsi/dc395x.txt b/Documentation/scsi/dc395x.rst
similarity index 64%
rename from Documentation/scsi/dc395x.txt
rename to Documentation/scsi/dc395x.rst
index 88219f96633d..d779e782b1cb 100644
--- a/Documentation/scsi/dc395x.txt
+++ b/Documentation/scsi/dc395x.rst
@@ -1,5 +1,8 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+======================================
 README file for the dc395x SCSI driver
-==========================================
+======================================
 
 Status
 ------
@@ -18,14 +21,14 @@ http://lists.twibble.org/mailman/listinfo/dc395x/
 
 Parameters
 ----------
-The driver uses the settings from the EEPROM set in the SCSI BIOS 
+The driver uses the settings from the EEPROM set in the SCSI BIOS
 setup. If there is no EEPROM, the driver uses default values.
 Both can be overridden by command line parameters (module or kernel
 parameters).
 
 The following parameters are available:
 
- - safe
+safe
    Default: 0, Acceptable values: 0 or 1
 
    If safe is set to 1 then the adapter will use conservative
@@ -33,52 +36,63 @@ The following parameters are available:
 
 		shortcut for dc395x=7,4,9,15,2,10
 
- - adapter_id
+adapter_id
    Default: 7, Acceptable values: 0 to 15
 
    Sets the host adapter SCSI ID.
 
- - max_speed
+max_speed
    Default: 1, Acceptable value: 0 to 7
-   0 = 20   Mhz
-   1 = 12.2 Mhz
-   2 = 10   Mhz
-   3 = 8    Mhz
-   4 = 6.7  Mhz
-   5 = 5.8  Hhz
-   6 = 5    Mhz
-   7 = 4    Mhz
 
- - dev_mode
+   ==  ========
+   0   20   Mhz
+   1   12.2 Mhz
+   2   10   Mhz
+   3   8    Mhz
+   4   6.7  Mhz
+   5   5.8  Hhz
+   6   5    Mhz
+   7   4    Mhz
+   ==  ========
+
+dev_mode
    Bitmap for device configuration
 
    DevMode bit definition:
+
+      === ======== ========  =========================================
       Bit Val(hex) Val(dec)  Meaning
-      *0    0x01       1     Parity check
-      *1    0x02       2     Synchronous Negotiation
-      *2    0x04       4     Disconnection
-      *3    0x08       8     Send Start command on startup. (Not used)
-      *4    0x10      16     Tagged Command Queueing
-      *5    0x20      32     Wide Negotiation
+      === ======== ========  =========================================
+       0    0x01       1     Parity check
+       1    0x02       2     Synchronous Negotiation
+       2    0x04       4     Disconnection
+       3    0x08       8     Send Start command on startup. (Not used)
+       4    0x10      16     Tagged Command Queueing
+       5    0x20      32     Wide Negotiation
+      === ======== ========  =========================================
 
- - adapter_mode
+adapter_mode
    Bitmap for adapter configuration
 
    AdaptMode bit definition
+
+    ===== ======== ========  ====================================================
       Bit Val(hex) Val(dec)  Meaning
-      *0    0x01       1     Support more than two drives. (Not used)
-      *1    0x02       2     Use DOS compatible mapping for HDs greater than 1GB.
-      *2    0x04       4     Reset SCSI Bus on startup.
-      *3    0x08       8     Active Negation: Improves SCSI Bus noise immunity.
+    ===== ======== ========  ====================================================
+       0    0x01       1     Support more than two drives. (Not used)
+       1    0x02       2     Use DOS compatible mapping for HDs greater than 1GB.
+       2    0x04       4     Reset SCSI Bus on startup.
+       3    0x08       8     Active Negation: Improves SCSI Bus noise immunity.
        4    0x10      16     Immediate return on BIOS seek command. (Not used)
     (*)5    0x20      32     Check for LUNs >= 1.
+    ===== ======== ========  ====================================================
 
- - tags
+tags
    Default: 3, Acceptable values: 0-5
-   
+
    The number of tags is 1<<x, if x has been specified
 
- - reset_delay
+reset_delay
    Default: 1, Acceptable values: 0-180
 
    The seconds to not accept commands after a SCSI Reset
@@ -95,8 +109,9 @@ License (GPL). Please read it, before using this driver. It should be
 included in your kernel sources and with your distribution. It carries the
 filename COPYING. If you don't have it, please ask me to send you one by
 email.
-Note: The GNU GPL says also something about warranty and liability. 
+
+Note: The GNU GPL says also something about warranty and liability.
 Please be aware the following: While we do my best to provide a working and
-reliable driver, there is a chance, that it will kill your valuable data. 
+reliable driver, there is a chance, that it will kill your valuable data.
 We refuse to take any responsibility for that. The driver is provided as-is
 and YOU USE IT AT YOUR OWN RESPONSIBILITY.
diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
index 3809213b83da..6fe00709cbce 100644
--- a/Documentation/scsi/index.rst
+++ b/Documentation/scsi/index.rst
@@ -17,5 +17,6 @@ Linux SCSI Subsystem
    bnx2fc
    BusLogic
    cxgb3i
+   dc395x
 
    scsi_transport_srp/figures
diff --git a/MAINTAINERS b/MAINTAINERS
index aac8ef48dc08..1e2ab816fe66 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4690,7 +4690,7 @@ L:	dc395x@twibble.org
 W:	http://twibble.org/dist/dc395x/
 W:	http://lists.twibble.org/mailman/listinfo/dc395x/
 S:	Maintained
-F:	Documentation/scsi/dc395x.txt
+F:	Documentation/scsi/dc395x.rst
 F:	drivers/scsi/dc395x.*
 
 DCCP PROTOCOL
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 5ec7330f82b6..9f5b2ddec6e0 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1187,7 +1187,7 @@ config SCSI_DC395x
 	  This driver works, but is still in experimental status. So better
 	  have a bootable disk and a backup in case of emergency.
 
-	  Documentation can be found in <file:Documentation/scsi/dc395x.txt>.
+	  Documentation can be found in <file:Documentation/scsi/dc395x.rst>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called dc395x.
-- 
2.21.1


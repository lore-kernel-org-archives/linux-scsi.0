Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_SBL,URIBL_SBL_A,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A23BC3F2DA
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:17:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 715C0246B4
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583137076;
	bh=Acai/1h0wAjDOmtj6Bt38+sJqxmQUtlM0h/EuXyQQJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=nQvW04bc0qZWw5kzgS1f+xKCclnGMYJoXoNjuRsrsClw3BbDpbVbRQ3WBOzFb+2gJ
	 4wFETKbHKtbD6g6YLaaD4l2q856iqOiPemMMspk8emtXwJ+Nxs+teR0kCmsWld1hcZ
	 IMLVzVecQt9uWV5P1w3F6CNYDFI0KtF6wPtjNQ3M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbgCBIRy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 03:17:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:57232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbgCBIQW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 03:16:22 -0500
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC3BA246F9;
        Mon,  2 Mar 2020 08:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583136979;
        bh=Acai/1h0wAjDOmtj6Bt38+sJqxmQUtlM0h/EuXyQQJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ON18qY/6dYhSKdJ6dVh6zC6R4cU+ztcD7PyvmTeR86g2WAn8gBeeBx0JeLBzA03Q5
         OV41jmbnKGofAaPeOE/M64ZVv8uyZd2R6rx4JN2nzySxv4cPOFezwahraa+7eEI0Lp
         Ci8BquKz5uCIXo5/kE0liWa/QU6GgUHvNM0JEt04=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1j8gFN-0003yx-Q2; Mon, 02 Mar 2020 09:16:17 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Doug Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 30/42] docs: scsi: convert scsi-generic.txt to ReST
Date:   Mon,  2 Mar 2020 09:16:03 +0100
Message-Id: <f57b8ddf30397c2c7213e49634e5e9cbd4246368.1583136624.git.mchehab+huawei@kernel.org>
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
 Documentation/scsi/index.rst                  |  1 +
 .../{scsi-generic.txt => scsi-generic.rst}    | 75 ++++++++++++-------
 MAINTAINERS                                   |  2 +-
 drivers/scsi/Kconfig                          |  2 +-
 include/scsi/sg.h                             |  2 +-
 5 files changed, 50 insertions(+), 32 deletions(-)
 rename Documentation/scsi/{scsi-generic.txt => scsi-generic.rst} (70%)

diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
index 471982ef461d..119280f26da6 100644
--- a/Documentation/scsi/index.rst
+++ b/Documentation/scsi/index.rst
@@ -34,5 +34,6 @@ Linux SCSI Subsystem
    scsi-changer
    scsi_eh
    scsi_fc_transport
+   scsi-generic
 
    scsi_transport_srp/figures
diff --git a/Documentation/scsi/scsi-generic.txt b/Documentation/scsi/scsi-generic.rst
similarity index 70%
rename from Documentation/scsi/scsi-generic.txt
rename to Documentation/scsi/scsi-generic.rst
index 51be20a6a14d..258505e557a6 100644
--- a/Documentation/scsi/scsi-generic.txt
+++ b/Documentation/scsi/scsi-generic.rst
@@ -1,6 +1,11 @@
-            Notes on Linux SCSI Generic (sg) driver
-            ---------------------------------------
+.. SPDX-License-Identifier: GPL-2.0
+
+=======================================
+Notes on Linux SCSI Generic (sg) driver
+=======================================
+
                                                         20020126
+
 Introduction
 ============
 The SCSI Generic driver (sg) is one of the four "high level" SCSI device
@@ -18,7 +23,7 @@ and examples.
 Major versions of the sg driver
 ===============================
 There are three major versions of sg found in the linux kernel (lk):
-      - sg version 1 (original) from 1992 to early 1999 (lk 2.2.5) . 
+      - sg version 1 (original) from 1992 to early 1999 (lk 2.2.5) .
 	It is based in the sg_header interface structure.
       - sg version 2 from lk 2.2.6 in the 2.2 series. It is based on
 	an extended version of the sg_header interface structure.
@@ -29,12 +34,16 @@ There are three major versions of sg found in the linux kernel (lk):
 Sg driver documentation
 =======================
 The most recent documentation of the sg driver is kept at the Linux
-Documentation Project's (LDP) site: 
-http://www.tldp.org/HOWTO/SCSI-Generic-HOWTO
+Documentation Project's (LDP) site:
+
+- http://www.tldp.org/HOWTO/SCSI-Generic-HOWTO
+
 This describes the sg version 3 driver found in the lk 2.4 series.
+
 The LDP renders documents in single and multiple page HTML, postscript
 and pdf. This document can also be found at:
-http://sg.danny.cz/sg/p/sg_v3_ho.html
+
+- http://sg.danny.cz/sg/p/sg_v3_ho.html
 
 Documentation for the version 2 sg driver found in the lk 2.2 series can
 be found at http://sg.danny.cz/sg/. A larger version
@@ -45,23 +54,27 @@ found at http://www.torque.net/sg/p/original/SCSI-Programming-HOWTO.txt
 and in the LDP archives.
 
 A changelog with brief notes can be found in the
-/usr/src/linux/include/scsi/sg.h file. Note that the glibc maintainers copy 
-and edit this file (removing its changelog for example) before placing it 
-in /usr/include/scsi/sg.h . Driver debugging information and other notes 
+/usr/src/linux/include/scsi/sg.h file. Note that the glibc maintainers copy
+and edit this file (removing its changelog for example) before placing it
+in /usr/include/scsi/sg.h . Driver debugging information and other notes
 can be found at the top of the /usr/src/linux/drivers/scsi/sg.c file.
 
-A more general description of the Linux SCSI subsystem of which sg is a 
+A more general description of the Linux SCSI subsystem of which sg is a
 part can be found at http://www.tldp.org/HOWTO/SCSI-2.4-HOWTO .
 
 
 Example code and utilities
 ==========================
 There are two packages of sg utilities:
-  - sg3_utils   for the sg version 3 driver found in lk 2.4
-  - sg_utils    for the sg version 2 (and original) driver found in lk 2.2
+
+    =========   ==========================================================
+    sg3_utils   for the sg version 3 driver found in lk 2.4
+    sg_utils    for the sg version 2 (and original) driver found in lk 2.2
                 and earlier
+    =========   ==========================================================
+
 Both packages will work in the lk 2.4 series however sg3_utils offers more
-capabilities. They can be found at: http://sg.danny.cz/sg/sg3_utils.html and 
+capabilities. They can be found at: http://sg.danny.cz/sg/sg3_utils.html and
 freecode.com
 
 Another approach is to look at the applications that use the sg driver.
@@ -72,30 +85,34 @@ Mapping of Linux kernel versions to sg driver versions
 ======================================================
 Here is a list of linux kernels in the 2.4 series that had new version
 of the sg driver:
-      lk 2.4.0 : sg version 3.1.17
-      lk 2.4.7 : sg version 3.1.19 
-      lk 2.4.10 : sg version 3.1.20  **
-      lk 2.4.17 : sg version 3.1.22 
 
-** There were 3 changes to sg version 3.1.20 by third parties in the
-   next six linux kernel versions.
+     - lk 2.4.0 : sg version 3.1.17
+     - lk 2.4.7 : sg version 3.1.19
+     - lk 2.4.10 : sg version 3.1.20 [#]_
+     - lk 2.4.17 : sg version 3.1.22
 
-For reference here is a list of linux kernels in the 2.2 series that had 
+.. [#] There were 3 changes to sg version 3.1.20 by third parties in the
+       next six linux kernel versions.
+
+For reference here is a list of linux kernels in the 2.2 series that had
 new version of the sg driver:
-      lk 2.2.0 : original sg version [with no version number]
-      lk 2.2.6 : sg version 2.1.31
-      lk 2.2.8 : sg version 2.1.32
-      lk 2.2.10 : sg version 2.1.34 [SG_GET_VERSION_NUM ioctl first appeared]
-      lk 2.2.14 : sg version 2.1.36
-      lk 2.2.16 : sg version 2.1.38
-      lk 2.2.17 : sg version 2.1.39
-      lk 2.2.20 : sg version 2.1.40
+
+     - lk 2.2.0 : original sg version [with no version number]
+     - lk 2.2.6 : sg version 2.1.31
+     - lk 2.2.8 : sg version 2.1.32
+     - lk 2.2.10 : sg version 2.1.34 [SG_GET_VERSION_NUM ioctl first appeared]
+     - lk 2.2.14 : sg version 2.1.36
+     - lk 2.2.16 : sg version 2.1.38
+     - lk 2.2.17 : sg version 2.1.39
+     - lk 2.2.20 : sg version 2.1.40
 
 The lk 2.5 development series has recently commenced and it currently
 contains sg version 3.5.23 which is functionally equivalent to sg
-version 3.1.22 found in lk 2.4.17 .
+version 3.1.22 found in lk 2.4.17.
 
 
 Douglas Gilbert
+
 26th January 2002
+
 dgilbert@interlog.com
diff --git a/MAINTAINERS b/MAINTAINERS
index 2f441cf59b4b..776de9c5b404 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14857,7 +14857,7 @@ M:	Doug Gilbert <dgilbert@interlog.com>
 L:	linux-scsi@vger.kernel.org
 W:	http://sg.danny.cz/sg
 S:	Maintained
-F:	Documentation/scsi/scsi-generic.txt
+F:	Documentation/scsi/scsi-generic.rst
 F:	drivers/scsi/sg.c
 F:	include/scsi/sg.h
 
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 6cb9abb0898d..bdf65b0bb78b 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -133,7 +133,7 @@ config CHR_DEV_SG
 	  quality digital reader of audio CDs (<http://www.xiph.org/paranoia/>).
 	  For other devices, it's possible that you'll have to write the
 	  driver software yourself. Please read the file
-	  <file:Documentation/scsi/scsi-generic.txt> for more information.
+	  <file:Documentation/scsi/scsi-generic.rst> for more information.
 
 	  To compile this driver as a module, choose M here and read
 	  <file:Documentation/scsi/scsi.txt>. The module will be called sg.
diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index 29c7ad04d2e2..7327e12f3373 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -24,7 +24,7 @@
  *	http://sg.danny.cz/sg  [alternatively check the MAINTAINERS file]
  * The documentation for the sg version 3 driver can be found at:
  *	http://sg.danny.cz/sg/p/sg_v3_ho.html
- * Also see: <kernel_source>/Documentation/scsi/scsi-generic.txt
+ * Also see: <kernel_source>/Documentation/scsi/scsi-generic.rst
  *
  * For utility and test programs see: http://sg.danny.cz/sg/sg3_utils.html
  */
-- 
2.21.1


Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04DEEC3F2D1
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C561824719
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583136981;
	bh=UUeqA613VDXAuLWp1j8Y80aqjpOlSA5wseX1Ou+T7Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=GSMsp+5AVMILVM6ZpVf+7fdkdJawnjZBD0SzHvd8kTMbSohaHV7gXivHS5fVw59Eg
	 gEJWKp3MNFs4iEipcjrw0kmar/i1Lc/VmxVDpQkc3vzjWcnfU9d/34d+H1tCyusoRI
	 2/pGMgLgzOXIg0b8tMd6eEo+3pPvmwh8AVsdpN5A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgCBIQU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 03:16:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:56682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727076AbgCBIQU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 03:16:20 -0500
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA6E6246BB;
        Mon,  2 Mar 2020 08:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583136979;
        bh=UUeqA613VDXAuLWp1j8Y80aqjpOlSA5wseX1Ou+T7Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VFfLmWAuNkxCRk0ytGY3SHL/IW+vg1V+FMLE8AgbyKFzRi7NvlXSwTuAq2Vtilseo
         q72t32u7cmavmP8Z1bC1zVz9y81qWAUgzveCT4G5vFrkBsTiL5GF0F+zLEUT5AutNO
         2n47tDr8tLh81JtUsk+ZvNamiCXLHGaB2fTtidjQ=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1j8gFN-0003wz-3J; Mon, 02 Mar 2020 09:16:17 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org
Subject: [PATCH 05/42] docs: scsi: convert advansys.txt to ReST
Date:   Mon,  2 Mar 2020 09:15:38 +0100
Message-Id: <3c697a046e641c81cdfd0784f037d41d54766931.1583136624.git.mchehab+huawei@kernel.org>
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
 .../scsi/{advansys.txt => advansys.rst}       | 129 +++++++++++-------
 Documentation/scsi/index.rst                  |   1 +
 MAINTAINERS                                   |   2 +-
 3 files changed, 81 insertions(+), 51 deletions(-)
 rename Documentation/scsi/{advansys.txt => advansys.rst} (73%)

diff --git a/Documentation/scsi/advansys.txt b/Documentation/scsi/advansys.rst
similarity index 73%
rename from Documentation/scsi/advansys.txt
rename to Documentation/scsi/advansys.rst
index 4a3db62b7424..e0367e179696 100644
--- a/Documentation/scsi/advansys.txt
+++ b/Documentation/scsi/advansys.rst
@@ -1,3 +1,9 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=====================
+AdvanSys Driver Notes
+=====================
+
 AdvanSys (Advanced System Products, Inc.) manufactures the following
 RISC-based, Bus-Mastering, Fast (10 Mhz) and Ultra (20 Mhz) Narrow
 (8-bit transfer) SCSI Host Adapters for the ISA, EISA, VL, and PCI
@@ -12,50 +18,51 @@ adapter detected. The number of CDBs used by the driver can be
 lowered in the BIOS by changing the 'Host Queue Size' adapter setting.
 
 Laptop Products:
-   ABP-480 - Bus-Master CardBus (16 CDB)
+  - ABP-480 - Bus-Master CardBus (16 CDB)
 
 Connectivity Products:
-   ABP510/5150 - Bus-Master ISA (240 CDB)
-   ABP5140 - Bus-Master ISA PnP (16 CDB)
-   ABP5142 - Bus-Master ISA PnP with floppy (16 CDB)
-   ABP902/3902 - Bus-Master PCI (16 CDB)
-   ABP3905 - Bus-Master PCI (16 CDB)
-   ABP915 - Bus-Master PCI (16 CDB)
-   ABP920 - Bus-Master PCI (16 CDB)
-   ABP3922 - Bus-Master PCI (16 CDB)
-   ABP3925 - Bus-Master PCI (16 CDB)
-   ABP930 - Bus-Master PCI (16 CDB)
-   ABP930U - Bus-Master PCI Ultra (16 CDB)
-   ABP930UA - Bus-Master PCI Ultra (16 CDB)
-   ABP960 - Bus-Master PCI MAC/PC (16 CDB)
-   ABP960U - Bus-Master PCI MAC/PC Ultra (16 CDB)
+   - ABP510/5150 - Bus-Master ISA (240 CDB)
+   - ABP5140 - Bus-Master ISA PnP (16 CDB)
+   - ABP5142 - Bus-Master ISA PnP with floppy (16 CDB)
+   - ABP902/3902 - Bus-Master PCI (16 CDB)
+   - ABP3905 - Bus-Master PCI (16 CDB)
+   - ABP915 - Bus-Master PCI (16 CDB)
+   - ABP920 - Bus-Master PCI (16 CDB)
+   - ABP3922 - Bus-Master PCI (16 CDB)
+   - ABP3925 - Bus-Master PCI (16 CDB)
+   - ABP930 - Bus-Master PCI (16 CDB)
+   - ABP930U - Bus-Master PCI Ultra (16 CDB)
+   - ABP930UA - Bus-Master PCI Ultra (16 CDB)
+   - ABP960 - Bus-Master PCI MAC/PC (16 CDB)
+   - ABP960U - Bus-Master PCI MAC/PC Ultra (16 CDB)
 
 Single Channel Products:
-   ABP542 - Bus-Master ISA with floppy (240 CDB)
-   ABP742 - Bus-Master EISA (240 CDB)
-   ABP842 - Bus-Master VL (240 CDB)
-   ABP940 - Bus-Master PCI (240 CDB)
-   ABP940U - Bus-Master PCI Ultra (240 CDB)
-   ABP940UA/3940UA - Bus-Master PCI Ultra (240 CDB)
-   ABP970 - Bus-Master PCI MAC/PC (240 CDB)
-   ABP970U - Bus-Master PCI MAC/PC Ultra (240 CDB)
-   ABP3960UA - Bus-Master PCI MAC/PC Ultra (240 CDB)
-   ABP940UW/3940UW - Bus-Master PCI Ultra-Wide (253 CDB)
-   ABP970UW - Bus-Master PCI MAC/PC Ultra-Wide (253 CDB)
-   ABP3940U2W - Bus-Master PCI LVD/Ultra2-Wide (253 CDB)
+   - ABP542 - Bus-Master ISA with floppy (240 CDB)
+   - ABP742 - Bus-Master EISA (240 CDB)
+   - ABP842 - Bus-Master VL (240 CDB)
+   - ABP940 - Bus-Master PCI (240 CDB)
+   - ABP940U - Bus-Master PCI Ultra (240 CDB)
+   - ABP940UA/3940UA - Bus-Master PCI Ultra (240 CDB)
+   - ABP970 - Bus-Master PCI MAC/PC (240 CDB)
+   - ABP970U - Bus-Master PCI MAC/PC Ultra (240 CDB)
+   - ABP3960UA - Bus-Master PCI MAC/PC Ultra (240 CDB)
+   - ABP940UW/3940UW - Bus-Master PCI Ultra-Wide (253 CDB)
+   - ABP970UW - Bus-Master PCI MAC/PC Ultra-Wide (253 CDB)
+   - ABP3940U2W - Bus-Master PCI LVD/Ultra2-Wide (253 CDB)
 
 Multi-Channel Products:
-   ABP752 - Dual Channel Bus-Master EISA (240 CDB Per Channel)
-   ABP852 - Dual Channel Bus-Master VL (240 CDB Per Channel)
-   ABP950 - Dual Channel Bus-Master PCI (240 CDB Per Channel)
-   ABP950UW - Dual Channel Bus-Master PCI Ultra-Wide (253 CDB Per Channel)
-   ABP980 - Four Channel Bus-Master PCI (240 CDB Per Channel)
-   ABP980U - Four Channel Bus-Master PCI Ultra (240 CDB Per Channel)
-   ABP980UA/3980UA - Four Channel Bus-Master PCI Ultra (16 CDB Per Chan.)
-   ABP3950U2W - Bus-Master PCI LVD/Ultra2-Wide and Ultra-Wide (253 CDB)
-   ABP3950U3W - Bus-Master PCI Dual LVD2/Ultra3-Wide (253 CDB)
+   - ABP752 - Dual Channel Bus-Master EISA (240 CDB Per Channel)
+   - ABP852 - Dual Channel Bus-Master VL (240 CDB Per Channel)
+   - ABP950 - Dual Channel Bus-Master PCI (240 CDB Per Channel)
+   - ABP950UW - Dual Channel Bus-Master PCI Ultra-Wide (253 CDB Per Channel)
+   - ABP980 - Four Channel Bus-Master PCI (240 CDB Per Channel)
+   - ABP980U - Four Channel Bus-Master PCI Ultra (240 CDB Per Channel)
+   - ABP980UA/3980UA - Four Channel Bus-Master PCI Ultra (16 CDB Per Chan.)
+   - ABP3950U2W - Bus-Master PCI LVD/Ultra2-Wide and Ultra-Wide (253 CDB)
+   - ABP3950U3W - Bus-Master PCI Dual LVD2/Ultra3-Wide (253 CDB)
 
 Driver Compile Time Options and Debugging
+=========================================
 
 The following constants can be defined in the source file.
 
@@ -88,26 +95,30 @@ The following constants can be defined in the source file.
    first three hex digits of the pseudo I/O Port must be set to
    'deb' and the fourth hex digit specifies the debug level: 0 - F.
    The following command line will look for an adapter at 0x330
-   and set the debug level to 2.
+   and set the debug level to 2::
 
       linux advansys=0x330,0,0,0,0xdeb2
 
    If the driver is built as a loadable module this variable can be
    defined when the driver is loaded. The following insmod command
-   will set the debug level to one.
+   will set the debug level to one::
 
       insmod advansys.o asc_dbglvl=1
 
    Debugging Message Levels:
-      0: Errors Only
-      1: High-Level Tracing
-      2-N: Verbose Tracing
+
+
+      ==== ==================
+      0    Errors Only
+      1    High-Level Tracing
+      2-N  Verbose Tracing
+      ==== ==================
 
    To enable debug output to console, please make sure that:
 
    a. System and kernel logging is enabled (syslogd, klogd running).
    b. Kernel messages are routed to console output. Check
-      /etc/syslog.conf for an entry similar to this:
+      /etc/syslog.conf for an entry similar to this::
 
            kern.*                  /dev/console
 
@@ -120,8 +131,11 @@ The following constants can be defined in the source file.
 
    Alternatively you can enable printk() to console with this
    program. However, this is not the 'official' way to do this.
+
    Debug output is logged in /var/log/messages.
 
+   ::
+
      main()
      {
              syscall(103, 7, 0, 0);
@@ -144,11 +158,11 @@ The following constants can be defined in the source file.
    Statistics are only available for kernels greater than or equal
    to v1.3.0 with the CONFIG_PROC_FS (/proc) file system configured.
 
-   AdvanSys SCSI adapter files have the following path name format:
+   AdvanSys SCSI adapter files have the following path name format::
 
       /proc/scsi/advansys/{0,1,2,3,...}
 
-   This information can be displayed with cat. For example:
+   This information can be displayed with cat. For example::
 
       cat /proc/scsi/advansys/0
 
@@ -156,6 +170,7 @@ The following constants can be defined in the source file.
    contain adapter and device configuration information.
 
 Driver LILO Option
+==================
 
 If init/main.c is modified as described in the 'Directions for Adding
 the AdvanSys Driver to Linux' section (B.4.) above, the driver will
@@ -167,17 +182,30 @@ affects searching for ISA and VL boards.
 
 Examples:
   1. Eliminate I/O port scanning:
-       boot: linux advansys=
-         or
-       boot: linux advansys=0x0
+
+     boot::
+
+	linux advansys=
+
+     or::
+
+	boot: linux advansys=0x0
+
   2. Limit I/O port scanning to one I/O port:
-       boot: linux advansys=0x110
+
+     boot::
+
+	linux advansys=0x110
+
   3. Limit I/O port scanning to four I/O ports:
-       boot: linux advansys=0x110,0x210,0x230,0x330
+
+     boot::
+
+	linux advansys=0x110,0x210,0x230,0x330
 
 For a loadable module the same effect can be achieved by setting
 the 'asc_iopflag' variable and 'asc_ioport' array when loading
-the driver, e.g.
+the driver, e.g.::
 
       insmod advansys.o asc_iopflag=1 asc_ioport=0x110,0x330
 
@@ -187,6 +215,7 @@ the 'Driver Compile Time Options and Debugging' section above for
 more information.
 
 Credits (Chronological Order)
+=============================
 
 Bob Frey <bfrey@turbolinux.com.cn> wrote the AdvanSys SCSI driver
 and maintained it up to 3.3F. He continues to answer questions
diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
index 2e0429d1a7a5..df526a0ceccf 100644
--- a/Documentation/scsi/index.rst
+++ b/Documentation/scsi/index.rst
@@ -9,5 +9,6 @@ Linux SCSI Subsystem
 
    53c700
    aacraid
+   advansys
 
    scsi_transport_srp/figures
diff --git a/MAINTAINERS b/MAINTAINERS
index cb6ecdbc96da..aac8ef48dc08 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -540,7 +540,7 @@ M:	Matthew Wilcox <willy@infradead.org>
 M:	Hannes Reinecke <hare@suse.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
-F:	Documentation/scsi/advansys.txt
+F:	Documentation/scsi/advansys.rst
 F:	drivers/scsi/advansys.c
 
 ADXL34X THREE-AXIS DIGITAL ACCELEROMETER DRIVER (ADXL345/ADXL346)
-- 
2.21.1


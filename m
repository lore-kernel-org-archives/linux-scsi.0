Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_SBL,URIBL_SBL_A,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF64FC3F2D6
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C3E4246B4
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583137081;
	bh=XyjwF2ioxjiZ5JUZ0SraExulaBFZymyuvfekf1/i9Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=auAQY8UM3xeIuc4BV7RDdL811oXzZTO9q0XWyd2ntjNPjk/rHB+Hb8JUHig2H3ZtM
	 PjMOURCtZZbTwRLoPcOu9N9PdNeEizJC3fIuQRNBt8AJMUB4Hg/gcLw6eCsJlAu/JX
	 HLKIX540FoeEvGBDoS4E1jt3kVTdRjL//Ck/EJ8U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbgCBIR4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 03:17:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:57208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbgCBIQW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 03:16:22 -0500
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F54E246D4;
        Mon,  2 Mar 2020 08:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583136979;
        bh=XyjwF2ioxjiZ5JUZ0SraExulaBFZymyuvfekf1/i9Ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kMvBRIm+FMBnKOiFudW5uAPkV9FCcAmZKaQt5VG+W9sLSxV5NSzVTeT6dNTf4fBlf
         FoIKotbzPsl20AWmsCLmOnRn7Mb3RIxO/LOGvSEE7cfLkwoEhPhogXjZR9ivelv9bk
         J5V9Y+8hNmJUvnlkObIj6lF6VVbcvC+cRok3Ze1Q=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1j8gFN-0003xk-Cq; Mon, 02 Mar 2020 09:16:17 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 15/42] docs: scsi: convert FlashPoint.txt to ReST
Date:   Mon,  2 Mar 2020 09:15:48 +0100
Message-Id: <e755b9644047eed6be69fcc77eb797f0801fcb99.1583136624.git.mchehab+huawei@kernel.org>
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
 .../scsi/{FlashPoint.txt => FlashPoint.rst}   | 225 +++++++++---------
 Documentation/scsi/index.rst                  |   1 +
 drivers/scsi/Kconfig                          |   2 +-
 3 files changed, 121 insertions(+), 107 deletions(-)
 rename Documentation/scsi/{FlashPoint.txt => FlashPoint.rst} (21%)

diff --git a/Documentation/scsi/FlashPoint.txt b/Documentation/scsi/FlashPoint.rst
similarity index 21%
rename from Documentation/scsi/FlashPoint.txt
rename to Documentation/scsi/FlashPoint.rst
index 5b5f29cb9f8b..ef3c07e94ad6 100644
--- a/Documentation/scsi/FlashPoint.txt
+++ b/Documentation/scsi/FlashPoint.rst
@@ -1,27 +1,34 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================================
+The BusLogic FlashPoint SCSI Driver
+===================================
+
 The BusLogic FlashPoint SCSI Host Adapters are now fully supported on Linux.
 The upgrade program described below has been officially terminated effective
 31 March 1997 since it is no longer needed.
 
+::
 
+  	  MYLEX INTRODUCES LINUX OPERATING SYSTEM SUPPORT FOR ITS
+  	      BUSLOGIC FLASHPOINT LINE OF SCSI HOST ADAPTERS
 
-	  MYLEX INTRODUCES LINUX OPERATING SYSTEM SUPPORT FOR ITS
-	      BUSLOGIC FLASHPOINT LINE OF SCSI HOST ADAPTERS
 
+  FREMONT, CA, -- October 8, 1996 -- Mylex Corporation has expanded Linux
+  operating system support to its BusLogic brand of FlashPoint Ultra SCSI
+  host adapters.  All of BusLogic's other SCSI host adapters, including the
+  MultiMaster line, currently support the Linux operating system.  Linux
+  drivers and information will be available on October 15th at
+  http://sourceforge.net/projects/dandelion/.
 
-FREMONT, CA, -- October 8, 1996 -- Mylex Corporation has expanded Linux
-operating system support to its BusLogic brand of FlashPoint Ultra SCSI
-host adapters.  All of BusLogic's other SCSI host adapters, including the
-MultiMaster line, currently support the Linux operating system.  Linux
-drivers and information will be available on October 15th at
-http://sourceforge.net/projects/dandelion/.
-
-"Mylex is committed to supporting the Linux community," says Peter Shambora,
-vice president of marketing for Mylex.  "We have supported Linux driver
-development and provided technical support for our host adapters for several
-years, and are pleased to now make our FlashPoint products available to this
-user base."
+  "Mylex is committed to supporting the Linux community," says Peter Shambora,
+  vice president of marketing for Mylex.  "We have supported Linux driver
+  development and provided technical support for our host adapters for several
+  years, and are pleased to now make our FlashPoint products available to this
+  user base."
 
 The Linux Operating System
+==========================
 
 Linux is a freely-distributed implementation of UNIX for Intel x86, Sun
 SPARC, SGI MIPS, Motorola 68k, Digital Alpha AXP and Motorola PowerPC
@@ -30,6 +37,7 @@ System, Emacs, and TCP/IP networking.  Further information is available at
 http://www.linux.org and http://www.ssc.com/.
 
 FlashPoint Host Adapters
+========================
 
 The FlashPoint family of Ultra SCSI host adapters, designed for workstation
 and file server environments, are available in narrow, wide, dual channel,
@@ -38,6 +46,7 @@ automation technology, which minimizes SCSI command overhead and reduces
 the number of interrupts generated to the CPU.
 
 About Mylex
+===========
 
 Mylex Corporation (NASDAQ/NM SYMBOL: MYLX), founded in 1983, is a leading
 producer of RAID technology and network management products.  The company
@@ -51,16 +60,20 @@ and availability.  Products are sold globally through a network of OEMs,
 major distributors, VARs, and system integrators.  Mylex Corporation is
 headquartered at 34551 Ardenwood Blvd., Fremont, CA.
 
-				   ####
-
 Contact:
+========
+
+::
+
+  Peter Shambora
+  Vice President of Marketing
+  Mylex Corp.
+  510/796-6100
+  peters@mylex.com
+
+
+::
 
-Peter Shambora
-Vice President of Marketing
-Mylex Corp.
-510/796-6100
-peters@mylex.com
-
 			       ANNOUNCEMENT
 	       BusLogic FlashPoint LT/BT-948 Upgrade Program
 			      1 February 1996
@@ -69,95 +82,95 @@ peters@mylex.com
 	       BusLogic FlashPoint LW/BT-958 Upgrade Program
 			       14 June 1996
 
-Ever since its introduction last October, the BusLogic FlashPoint LT has
-been problematic for members of the Linux community, in that no Linux
-drivers have been available for this new Ultra SCSI product.  Despite its
-officially being positioned as a desktop workstation product, and not being
-particularly well suited for a high performance multitasking operating
-system like Linux, the FlashPoint LT has been touted by computer system
-vendors as the latest thing, and has been sold even on many of their high
-end systems, to the exclusion of the older MultiMaster products.  This has
-caused grief for many people who inadvertently purchased a system expecting
-that all BusLogic SCSI Host Adapters were supported by Linux, only to
-discover that the FlashPoint was not supported and would not be for quite
-some time, if ever.
+  Ever since its introduction last October, the BusLogic FlashPoint LT has
+  been problematic for members of the Linux community, in that no Linux
+  drivers have been available for this new Ultra SCSI product.  Despite its
+  officially being positioned as a desktop workstation product, and not being
+  particularly well suited for a high performance multitasking operating
+  system like Linux, the FlashPoint LT has been touted by computer system
+  vendors as the latest thing, and has been sold even on many of their high
+  end systems, to the exclusion of the older MultiMaster products.  This has
+  caused grief for many people who inadvertently purchased a system expecting
+  that all BusLogic SCSI Host Adapters were supported by Linux, only to
+  discover that the FlashPoint was not supported and would not be for quite
+  some time, if ever.
 
-After this problem was identified, BusLogic contacted its major OEM
-customers to make sure the BT-946C/956C MultiMaster cards would still be
-made available, and that Linux users who mistakenly ordered systems with
-the FlashPoint would be able to upgrade to the BT-946C.  While this helped
-many purchasers of new systems, it was only a partial solution to the
-overall problem of FlashPoint support for Linux users.  It did nothing to
-assist the people who initially purchased a FlashPoint for a supported
-operating system and then later decided to run Linux, or those who had
-ended up with a FlashPoint LT, believing it was supported, and were unable
-to return it.
+  After this problem was identified, BusLogic contacted its major OEM
+  customers to make sure the BT-946C/956C MultiMaster cards would still be
+  made available, and that Linux users who mistakenly ordered systems with
+  the FlashPoint would be able to upgrade to the BT-946C.  While this helped
+  many purchasers of new systems, it was only a partial solution to the
+  overall problem of FlashPoint support for Linux users.  It did nothing to
+  assist the people who initially purchased a FlashPoint for a supported
+  operating system and then later decided to run Linux, or those who had
+  ended up with a FlashPoint LT, believing it was supported, and were unable
+  to return it.
 
-In the middle of December, I asked to meet with BusLogic's senior
-management to discuss the issues related to Linux and free software support
-for the FlashPoint.  Rumors of varying accuracy had been circulating
-publicly about BusLogic's attitude toward the Linux community, and I felt
-it was best that these issues be addressed directly.  I sent an email
-message after 11pm one evening, and the meeting took place the next
-afternoon.  Unfortunately, corporate wheels sometimes grind slowly,
-especially when a company is being acquired, and so it's taken until now
-before the details were completely determined and a public statement could
-be made.
+  In the middle of December, I asked to meet with BusLogic's senior
+  management to discuss the issues related to Linux and free software support
+  for the FlashPoint.  Rumors of varying accuracy had been circulating
+  publicly about BusLogic's attitude toward the Linux community, and I felt
+  it was best that these issues be addressed directly.  I sent an email
+  message after 11pm one evening, and the meeting took place the next
+  afternoon.  Unfortunately, corporate wheels sometimes grind slowly,
+  especially when a company is being acquired, and so it's taken until now
+  before the details were completely determined and a public statement could
+  be made.
 
-BusLogic is not prepared at this time to release the information necessary
-for third parties to write drivers for the FlashPoint.  The only existing
-FlashPoint drivers have been written directly by BusLogic Engineering, and
-there is no FlashPoint documentation sufficiently detailed to allow outside
-developers to write a driver without substantial assistance.  While there
-are people at BusLogic who would rather not release the details of the
-FlashPoint architecture at all, that debate has not yet been settled either
-way.  In any event, even if documentation were available today it would
-take quite a while for a usable driver to be written, especially since I'm
-not convinced that the effort required would be worthwhile.
+  BusLogic is not prepared at this time to release the information necessary
+  for third parties to write drivers for the FlashPoint.  The only existing
+  FlashPoint drivers have been written directly by BusLogic Engineering, and
+  there is no FlashPoint documentation sufficiently detailed to allow outside
+  developers to write a driver without substantial assistance.  While there
+  are people at BusLogic who would rather not release the details of the
+  FlashPoint architecture at all, that debate has not yet been settled either
+  way.  In any event, even if documentation were available today it would
+  take quite a while for a usable driver to be written, especially since I'm
+  not convinced that the effort required would be worthwhile.
 
-However, BusLogic does remain committed to providing a high performance
-SCSI solution for the Linux community, and does not want to see anyone left
-unable to run Linux because they have a Flashpoint LT.  Therefore, BusLogic
-has put in place a direct upgrade program to allow any Linux user worldwide
-to trade in their FlashPoint LT for the new BT-948 MultiMaster PCI Ultra
-SCSI Host Adapter.  The BT-948 is the Ultra SCSI successor to the BT-946C
-and has all the best features of both the BT-946C and FlashPoint LT,
-including smart termination and a flash PROM for easy firmware updates, and
-is of course compatible with the present Linux driver.  The price for this
-upgrade has been set at US $45 plus shipping and handling, and the upgrade
-program will be administered through BusLogic Technical Support, which can
-be reached by electronic mail at techsup@buslogic.com, by Voice at +1 408
-654-0760, or by FAX at +1 408 492-1542.
+  However, BusLogic does remain committed to providing a high performance
+  SCSI solution for the Linux community, and does not want to see anyone left
+  unable to run Linux because they have a Flashpoint LT.  Therefore, BusLogic
+  has put in place a direct upgrade program to allow any Linux user worldwide
+  to trade in their FlashPoint LT for the new BT-948 MultiMaster PCI Ultra
+  SCSI Host Adapter.  The BT-948 is the Ultra SCSI successor to the BT-946C
+  and has all the best features of both the BT-946C and FlashPoint LT,
+  including smart termination and a flash PROM for easy firmware updates, and
+  is of course compatible with the present Linux driver.  The price for this
+  upgrade has been set at US $45 plus shipping and handling, and the upgrade
+  program will be administered through BusLogic Technical Support, which can
+  be reached by electronic mail at techsup@buslogic.com, by Voice at +1 408
+  654-0760, or by FAX at +1 408 492-1542.
 
-As of 14 June 1996, the original BusLogic FlashPoint LT to BT-948 upgrade
-program has now been extended to encompass the FlashPoint LW Wide Ultra
-SCSI Host Adapter.  Any Linux user worldwide may trade in their FlashPoint
-LW (BT-950) for a BT-958 MultiMaster PCI Ultra SCSI Host Adapter.  The
-price for this upgrade has been set at US $65 plus shipping and handling.
+  As of 14 June 1996, the original BusLogic FlashPoint LT to BT-948 upgrade
+  program has now been extended to encompass the FlashPoint LW Wide Ultra
+  SCSI Host Adapter.  Any Linux user worldwide may trade in their FlashPoint
+  LW (BT-950) for a BT-958 MultiMaster PCI Ultra SCSI Host Adapter.  The
+  price for this upgrade has been set at US $65 plus shipping and handling.
 
-I was a beta test site for the BT-948/958, and versions 1.2.1 and 1.3.1 of
-my BusLogic driver already included latent support for the BT-948/958.
-Additional cosmetic support for the Ultra SCSI MultiMaster cards was added
-subsequent releases.  As a result of this cooperative testing process,
-several firmware bugs were found and corrected.  My heavily loaded Linux
-test system provided an ideal environment for testing error recovery
-processes that are much more rarely exercised in production systems, but
-are crucial to overall system stability.  It was especially convenient
-being able to work directly with their firmware engineer in demonstrating
-the problems under control of the firmware debugging environment; things
-sure have come a long way since the last time I worked on firmware for an
-embedded system.  I am presently working on some performance testing and
-expect to have some data to report in the not too distant future.
+  I was a beta test site for the BT-948/958, and versions 1.2.1 and 1.3.1 of
+  my BusLogic driver already included latent support for the BT-948/958.
+  Additional cosmetic support for the Ultra SCSI MultiMaster cards was added
+  subsequent releases.  As a result of this cooperative testing process,
+  several firmware bugs were found and corrected.  My heavily loaded Linux
+  test system provided an ideal environment for testing error recovery
+  processes that are much more rarely exercised in production systems, but
+  are crucial to overall system stability.  It was especially convenient
+  being able to work directly with their firmware engineer in demonstrating
+  the problems under control of the firmware debugging environment; things
+  sure have come a long way since the last time I worked on firmware for an
+  embedded system.  I am presently working on some performance testing and
+  expect to have some data to report in the not too distant future.
 
-BusLogic asked me to send this announcement since a large percentage of the
-questions regarding support for the FlashPoint have either been sent to me
-directly via email, or have appeared in the Linux newsgroups in which I
-participate.  To summarize, BusLogic is offering Linux users an upgrade
-from the unsupported FlashPoint LT (BT-930) to the supported BT-948 for US
-$45 plus shipping and handling, or from the unsupported FlashPoint LW
-(BT-950) to the supported BT-958 for $65 plus shipping and handling.
-Contact BusLogic Technical Support at techsup@buslogic.com or +1 408
-654-0760 to take advantage of their offer.
+  BusLogic asked me to send this announcement since a large percentage of the
+  questions regarding support for the FlashPoint have either been sent to me
+  directly via email, or have appeared in the Linux newsgroups in which I
+  participate.  To summarize, BusLogic is offering Linux users an upgrade
+  from the unsupported FlashPoint LT (BT-930) to the supported BT-948 for US
+  $45 plus shipping and handling, or from the unsupported FlashPoint LW
+  (BT-950) to the supported BT-958 for $65 plus shipping and handling.
+  Contact BusLogic Technical Support at techsup@buslogic.com or +1 408
+  654-0760 to take advantage of their offer.
 
-		Leonard N. Zubkoff
-		lnz@dandelion.com
+  		Leonard N. Zubkoff
+  		lnz@dandelion.com
diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
index b553dd9904bf..aad8359357e6 100644
--- a/Documentation/scsi/index.rst
+++ b/Documentation/scsi/index.rst
@@ -19,5 +19,6 @@ Linux SCSI Subsystem
    cxgb3i
    dc395x
    dpti
+   FlashPoint
 
    scsi_transport_srp/figures
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 5e834fba7934..e47498f7627e 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -503,7 +503,7 @@ config SCSI_BUSLOGIC
 	  Adapters. Consult the SCSI-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>, and the files
 	  <file:Documentation/scsi/BusLogic.rst> and
-	  <file:Documentation/scsi/FlashPoint.txt> for more information.
+	  <file:Documentation/scsi/FlashPoint.rst> for more information.
 	  Note that support for FlashPoint is only available for 32-bit
 	  x86 configurations.
 
-- 
2.21.1


Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F22FDC3F2D2
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:19:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C49BE246B6
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583137164;
	bh=IfRS/R6H+Szpiwi72smGycLsGnORNH/i9azDqozRPuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=UeKW3DpLMD/RiylM/2I0DKdmGiTgHCk6EKX6rJOmUiiFHM7WGyrLpu647Wt6cS8cU
	 jhqn5jj3M+h7UpjBMq75eFf0LZ39jk2ksTrVdvruEuLq2HeQto5Qw/6oDA63VT3mC1
	 4LeLhTH8HL+Kb8AJk4ghh7UDu26elIMfnD3NGoaA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbgCBITV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 03:19:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:56678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727059AbgCBIQU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 03:16:20 -0500
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E937E246B9;
        Mon,  2 Mar 2020 08:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583136979;
        bh=IfRS/R6H+Szpiwi72smGycLsGnORNH/i9azDqozRPuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CzV9VHYdj2Md+uBvKwr2W8pqXFNMC0teiREa9ZEjgsuqNdPGQLiPuip47nIgxChct
         YOJTFKADMnjkpNLRKORFD88zSBtOS9dyjiXI1KKY20SfOcD7zdxoOZYuoXWDPEztMK
         mG+wRybjS9E+RUyV/YOhcl9xvwbb/fIAbGuJW72s=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1j8gFN-0003wv-2Y; Mon, 02 Mar 2020 09:16:17 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 04/42] docs: scsi: convert aacraid.txt to ReST
Date:   Mon,  2 Mar 2020 09:15:37 +0100
Message-Id: <67c60ad88777c91937d49771e2a3f48cbf353e4c.1583136624.git.mchehab+huawei@kernel.org>
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
 .../scsi/{aacraid.txt => aacraid.rst}         | 59 ++++++++++++++-----
 Documentation/scsi/index.rst                  |  1 +
 MAINTAINERS                                   |  2 +-
 drivers/scsi/Kconfig                          |  2 +-
 4 files changed, 46 insertions(+), 18 deletions(-)
 rename Documentation/scsi/{aacraid.txt => aacraid.rst} (83%)

diff --git a/Documentation/scsi/aacraid.txt b/Documentation/scsi/aacraid.rst
similarity index 83%
rename from Documentation/scsi/aacraid.txt
rename to Documentation/scsi/aacraid.rst
index 30f643f611b2..1904674b94f3 100644
--- a/Documentation/scsi/aacraid.txt
+++ b/Documentation/scsi/aacraid.rst
@@ -1,7 +1,11 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================================
 AACRAID Driver for Linux (take two)
+===================================
 
 Introduction
--------------------------
+============
 The aacraid driver adds support for Adaptec (http://www.adaptec.com)
 RAID controllers. This is a major rewrite from the original
 Adaptec supplied driver. It has significantly cleaned up both the code
@@ -9,8 +13,11 @@ and the running binary size (the module is less than half the size of
 the original).
 
 Supported Cards/Chipsets
--------------------------
+========================
+
+	===================	=======	=======================================
 	PCI ID (pci.ids)	OEM	Product
+	===================	=======	=======================================
 	9005:0285:9005:0285	Adaptec	2200S (Vulcan)
 	9005:0285:9005:0286	Adaptec	2120S (Crusader)
 	9005:0285:9005:0287	Adaptec	2200S (Vulcan-2m)
@@ -117,34 +124,54 @@ Supported Cards/Chipsets
 	9005:0285:108e:0286	SUN	STK RAID INT (Cougar)
 	9005:0285:108e:0287	SUN	STK RAID EXT (Prometheus)
 	9005:0285:108e:7aae	SUN	STK RAID EM (Narvi)
+	===================	=======	=======================================
 
 People
--------------------------
+======
+
 Alan Cox <alan@lxorguk.ukuu.org.uk>
-Christoph Hellwig <hch@infradead.org>	(updates for new-style PCI probing and SCSI host registration,
-					 small cleanups/fixes)
-Matt Domsch <matt_domsch@dell.com>	(revision ioctl, adapter messages)
-Deanna Bonds                            (non-DASD support, PAE fibs and 64 bit, added new adaptec controllers
-					 added new ioctls, changed scsi interface to use new error handler,
-					 increased the number of fibs and outstanding commands to a container)
-
-					(fixed 64bit and 64G memory model, changed confusing naming convention
-					 where fibs that go to the hardware are consistently called hw_fibs and
-					 not just fibs like the name of the driver tracking structure)
-Mark Salyzyn <Mark_Salyzyn@adaptec.com> Fixed panic issues and added some new product ids for upcoming hbas. Performance tuning, card failover and bug mitigations.
+
+Christoph Hellwig <hch@infradead.org>
+
+- updates for new-style PCI probing and SCSI host registration,
+  small cleanups/fixes
+
+Matt Domsch <matt_domsch@dell.com>
+
+- revision ioctl, adapter messages
+
+Deanna Bonds
+
+- non-DASD support, PAE fibs and 64 bit, added new adaptec controllers
+  added new ioctls, changed scsi interface to use new error handler,
+  increased the number of fibs and outstanding commands to a container
+- fixed 64bit and 64G memory model, changed confusing naming convention
+  where fibs that go to the hardware are consistently called hw_fibs and
+  not just fibs like the name of the driver tracking structure
+
+Mark Salyzyn <Mark_Salyzyn@adaptec.com>
+
+- Fixed panic issues and added some new product ids for upcoming hbas.
+- Performance tuning, card failover and bug mitigations.
+
 Achim Leubner <Achim_Leubner@adaptec.com>
 
-Original Driver
+- Original Driver
+
 -------------------------
+
 Adaptec Unix OEM Product Group
 
 Mailing List
--------------------------
+============
+
 linux-scsi@vger.kernel.org (Interested parties troll here)
 Also note this is very different to Brian's original driver
 so don't expect him to support it.
+
 Adaptec does support this driver.  Contact Adaptec tech support or
 aacraid@adaptec.com
 
 Original by Brian Boerner February 2001
+
 Rewritten by Alan Cox, November 2001
diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
index 99efc77c3ac2..2e0429d1a7a5 100644
--- a/Documentation/scsi/index.rst
+++ b/Documentation/scsi/index.rst
@@ -8,5 +8,6 @@ Linux SCSI Subsystem
    :maxdepth: 1
 
    53c700
+   aacraid
 
    scsi_transport_srp/figures
diff --git a/MAINTAINERS b/MAINTAINERS
index 1552db209e69..cb6ecdbc96da 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -236,7 +236,7 @@ M:	Adaptec OEM Raid Solutions <aacraid@microsemi.com>
 L:	linux-scsi@vger.kernel.org
 W:	http://www.adaptec.com/
 S:	Supported
-F:	Documentation/scsi/aacraid.txt
+F:	Documentation/scsi/aacraid.rst
 F:	drivers/scsi/aacraid/
 
 ABI/API
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 2b882b96e0d4..a153444318fb 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -421,7 +421,7 @@ config SCSI_AACRAID
 	help
 	  This driver supports a variety of Dell, HP, Adaptec, IBM and
 	  ICP storage products. For a list of supported products, refer
-	  to <file:Documentation/scsi/aacraid.txt>.
+	  to <file:Documentation/scsi/aacraid.rst>.
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called aacraid.
-- 
2.21.1


Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE8FC3F2D8
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2AD0246BB
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583137074;
	bh=6sbFKCi8a4l1ayl3j3LXRMPY+oORPvV1Q6kKCVDtBHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=eKcQCaGbPb/XaG3P6qsSj9ZgAuMoeDjs9XiPRZuOVZoECYckXVZ20v1GoWydfxgq+
	 rlWFx0zq6Oe0Cv6jfuZSn82a8+d+2AWBCgUSvAdkd47no07EG/5Q7H8Hpo8j6a32T2
	 TSfsc8RIBuU2SBThgD/aw0YRWlVTZFWfYUDC8Jwg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbgCBIRm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 03:17:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:57062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727261AbgCBIQW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 03:16:22 -0500
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9459D246EF;
        Mon,  2 Mar 2020 08:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583136979;
        bh=6sbFKCi8a4l1ayl3j3LXRMPY+oORPvV1Q6kKCVDtBHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDeKl8gdujGQ6fnznI0yr3ojjOccyj9f3EQhcwni+2YHRMCpgVHBQoNYXHH3qZtqb
         KkCl4OoqqygLMzI00kmxPHdzIkQwyb4irU/QO8PHOFJcxmOjh2UIhieNXJSQlhq9mS
         mbtm9KS/Vp33AJwlH7QmmI8tI0Pg4ppJ+V8FAVnA=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1j8gFN-0003yl-NY; Mon, 02 Mar 2020 09:16:17 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 27/42] docs: scsi: convert scsi-changer.txt to ReST
Date:   Mon,  2 Mar 2020 09:16:00 +0100
Message-Id: <433d073fa982174a19783c2e59412b724e2cf946.1583136624.git.mchehab+huawei@kernel.org>
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
 .../{scsi-changer.txt => scsi-changer.rst}    | 36 ++++++++++---------
 drivers/scsi/Kconfig                          |  2 +-
 3 files changed, 22 insertions(+), 17 deletions(-)
 rename Documentation/scsi/{scsi-changer.txt => scsi-changer.rst} (87%)

diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
index 29e211ee9145..635a3b3c5e90 100644
--- a/Documentation/scsi/index.rst
+++ b/Documentation/scsi/index.rst
@@ -31,5 +31,6 @@ Linux SCSI Subsystem
    NinjaSCSI
    ppa
    qlogicfas
+   scsi-changer
 
    scsi_transport_srp/figures
diff --git a/Documentation/scsi/scsi-changer.txt b/Documentation/scsi/scsi-changer.rst
similarity index 87%
rename from Documentation/scsi/scsi-changer.txt
rename to Documentation/scsi/scsi-changer.rst
index ade046ea7c17..ab60e7e61a6c 100644
--- a/Documentation/scsi/scsi-changer.txt
+++ b/Documentation/scsi/scsi-changer.rst
@@ -1,4 +1,6 @@
+.. SPDX-License-Identifier: GPL-2.0
 
+========================================
 README for the SCSI media changer driver
 ========================================
 
@@ -28,15 +30,17 @@ The SCSI changer model is complex, compared to - for example - IDE-CD
 changers. But it allows to handle nearly all possible cases. It knows
 4 different types of changer elements:
 
-  media transport - this one shuffles around the media, i.e. the
+  ===============   ==================================================
+  media transport   this one shuffles around the media, i.e. the
                     transport arm.  Also known as "picker".
-  storage         - a slot which can hold a media.
-  import/export   - the same as above, but is accessible from outside,
+  storage           a slot which can hold a media.
+  import/export     the same as above, but is accessible from outside,
                     i.e. there the operator (you !) can use this to
                     fill in and remove media from the changer.
 		    Sometimes named "mailslot".
-  data transfer   - this is the device which reads/writes, i.e. the
+  data transfer     this is the device which reads/writes, i.e. the
 		    CD-ROM / Tape / whatever drive.
+  ===============   ==================================================
 
 None of these is limited to one: A huge Jukebox could have slots for
 123 CD-ROM's, 5 CD-ROM readers (and therefore 6 SCSI ID's: the changer
@@ -131,24 +135,23 @@ timeout_init=<seconds>
 timeout_move=<seconds>
 	timeout for all other commands (default: 120).
 
-dt_id=<id1>,<id2>,...
-dt_lun=<lun1>,<lun2>,...
+dt_id=<id1>,<id2>,... / dt_lun=<lun1>,<lun2>,...
 	These two allow to specify the SCSI ID and LUN for the data
 	transfer elements.  You likely don't need this as the jukebox
 	should provide this information.  But some devices don't ...
 
-vendor_firsts=
-vendor_counts=
-vendor_labels=
+vendor_firsts=, vendor_counts=, vendor_labels=
 	These insmod options can be used to tell the driver that there
 	are some vendor-specific element types.  Grundig for example
 	does this.  Some jukeboxes have a printer to label fresh burned
 	CDs, which is addressed as element 0xc000 (type 5).  To tell the
-	driver about this vendor-specific element, use this:
+	driver about this vendor-specific element, use this::
+
 		$ insmod ch			\
 			vendor_firsts=0xc000	\
 			vendor_counts=1		\
 			vendor_labels=printer
+
 	All three insmod options accept up to four comma-separated
 	values, this way you can configure the element types 5-8.
 	You likely need the SCSI specs for the device in question to
@@ -162,13 +165,15 @@ Credits
 I wrote this driver using the famous mailing-patches-around-the-world
 method.  With (more or less) help from:
 
-	Daniel Moehwald <moehwald@hdg.de>
-	Dane Jasper <dane@sonic.net>
-	R. Scott Bailey <sbailey@dsddi.eds.com>
-	Jonathan Corbet <corbet@lwn.net>
+	- Daniel Moehwald <moehwald@hdg.de>
+	- Dane Jasper <dane@sonic.net>
+	- R. Scott Bailey <sbailey@dsddi.eds.com>
+	- Jonathan Corbet <corbet@lwn.net>
 
 Special thanks go to
-	Martin Kuehne <martin.kuehne@bnbt.de>
+
+	- Martin Kuehne <martin.kuehne@bnbt.de>
+
 for a old, second-hand (but full functional) cdrom jukebox which I use
 to develop/test driver and tools now.
 
@@ -176,5 +181,4 @@ Have fun,
 
    Gerd
 
--- 
 Gerd Knorr <kraxel@bytesex.org>
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index d34c682e94cf..6cb9abb0898d 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -149,7 +149,7 @@ config CHR_DEV_SCH
 	  don't need this for those tiny 6-slot cdrom changers.  Media
 	  changers are listed as "Type: Medium Changer" in /proc/scsi/scsi.
 	  If you have such hardware and want to use it with linux, say Y
-	  here.  Check <file:Documentation/scsi/scsi-changer.txt> for details.
+	  here.  Check <file:Documentation/scsi/scsi-changer.rst> for details.
 	
 	  If you want to compile this as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want),
-- 
2.21.1


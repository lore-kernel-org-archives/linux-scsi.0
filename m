Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F4CAC3F2E1
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 463A8246B4
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583137099;
	bh=GvP4vju05kdmGtfnW2lQXLeHqLhoRjSRhWQZFPyQmYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wIpVuR7rAo5uGWHxL1bqOaNa4+P9P2dNsFkpqGU+jwM5HkT0F3fE9chVpOwzJnnwB
	 ZYiHpiKdvjXY9oP8/OdbLl6Xi7+4l2Y9IdKFm+lrrxQgis0jiT7FccCtcFMFD1N9X6
	 EJNesH9EOQ76Y/W7O6ykk+nrkRddCVGV13i3N44M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgCBISS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 03:18:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:57210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727226AbgCBIQV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 03:16:21 -0500
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A7DE246E6;
        Mon,  2 Mar 2020 08:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583136979;
        bh=GvP4vju05kdmGtfnW2lQXLeHqLhoRjSRhWQZFPyQmYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YZN5X21zTEIKDTB/Y9m+GsTynkhbbdJlzCYIekaDakbOwT+y28iFIkUAeJvZwCRu1
         zhrvOQ1QXXNiXrpo0VgbqNIU7NNPsBtkCmlhmwgASD9SpxuVUzcJ5rgODrXjoW1hcJ
         OlnPXLS1qdhPmRgM1woOYoXpf5bdlv8bEJ5Q8DzI=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1j8gFN-0003yI-JF; Mon, 02 Mar 2020 09:16:17 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH 22/42] docs: scsi: convert megaraid.txt to ReST
Date:   Mon,  2 Mar 2020 09:15:55 +0100
Message-Id: <b7ee59230c5a33ff6d60edba0d0bcf3e2aeaa88f.1583136624.git.mchehab+huawei@kernel.org>
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
 .../scsi/{megaraid.txt => megaraid.rst}       | 47 +++++++++++--------
 MAINTAINERS                                   |  2 +-
 3 files changed, 29 insertions(+), 21 deletions(-)
 rename Documentation/scsi/{megaraid.txt => megaraid.rst} (66%)

diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
index 22427511e227..37be1fc9d128 100644
--- a/Documentation/scsi/index.rst
+++ b/Documentation/scsi/index.rst
@@ -26,5 +26,6 @@ Linux SCSI Subsystem
    libsas
    link_power_management_policy
    lpfc
+   megaraid
 
    scsi_transport_srp/figures
diff --git a/Documentation/scsi/megaraid.txt b/Documentation/scsi/megaraid.rst
similarity index 66%
rename from Documentation/scsi/megaraid.txt
rename to Documentation/scsi/megaraid.rst
index 3c7cea51e687..22b75a86ba72 100644
--- a/Documentation/scsi/megaraid.txt
+++ b/Documentation/scsi/megaraid.rst
@@ -1,7 +1,10 @@
-			Notes on Management Module
-			~~~~~~~~~~~~~~~~~~~~~~~~~~
+.. SPDX-License-Identifier: GPL-2.0
 
-Overview:
+==========================
+Notes on Management Module
+==========================
+
+Overview
 --------
 
 Different classes of controllers from LSI Logic accept and respond to the
@@ -25,28 +28,32 @@ ioctl commands. But this module is envisioned to handle all user space level
 interactions. So any 'proc', 'sysfs' implementations will be localized in this
 common module.
 
-Credits:
+Credits
 -------
 
-"Shared code in a third module, a "library module", is an acceptable
-solution. modprobe automatically loads dependent modules, so users
-running "modprobe driver1" or "modprobe driver2" would automatically
-load the shared library module."
+::
 
-		- Jeff Garzik (jgarzik@pobox.com), 02.25.2004 LKML
+	"Shared code in a third module, a "library module", is an acceptable
+	solution. modprobe automatically loads dependent modules, so users
+	running "modprobe driver1" or "modprobe driver2" would automatically
+	load the shared library module."
 
-"As Jeff hinted, if your userspace<->driver API is consistent between
-your new MPT-based RAID controllers and your existing megaraid driver,
-then perhaps you need a single small helper module (lsiioctl or some
-better name), loaded by both mptraid and megaraid automatically, which
-handles registering the /dev/megaraid node dynamically. In this case,
-both mptraid and megaraid would register with lsiioctl for each
-adapter discovered, and lsiioctl would essentially be a switch,
-redirecting userspace tool ioctls to the appropriate driver."
+- Jeff Garzik (jgarzik@pobox.com), 02.25.2004 LKML
 
-		- Matt Domsch, (Matt_Domsch@dell.com), 02.25.2004 LKML
+::
 
-Design:
+	"As Jeff hinted, if your userspace<->driver API is consistent between
+	your new MPT-based RAID controllers and your existing megaraid driver,
+	then perhaps you need a single small helper module (lsiioctl or some
+	better name), loaded by both mptraid and megaraid automatically, which
+	handles registering the /dev/megaraid node dynamically. In this case,
+	both mptraid and megaraid would register with lsiioctl for each
+	adapter discovered, and lsiioctl would essentially be a switch,
+	redirecting userspace tool ioctls to the appropriate driver."
+
+- Matt Domsch, (Matt_Domsch@dell.com), 02.25.2004 LKML
+
+Design
 ------
 
 The Common Management Module is implemented in megaraid_mm.[ch] files. This
@@ -61,7 +68,7 @@ uioc_t. The management module converts the older ioctl packets from the older
 applications into uioc_t. After driver handles the uioc_t, the common module
 will convert that back into the old format before returning to applications.
 
-As new applications evolve and replace the old ones, the old packet format 
+As new applications evolve and replace the old ones, the old packet format
 will be retired.
 
 Common module dedicates one uioc_t packet to each controller registered. This
diff --git a/MAINTAINERS b/MAINTAINERS
index e2bd7911baa9..6d28bfc72259 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10699,7 +10699,7 @@ L:	megaraidlinux.pdl@broadcom.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.avagotech.com/support/
 S:	Maintained
-F:	Documentation/scsi/megaraid.txt
+F:	Documentation/scsi/megaraid.rst
 F:	drivers/scsi/megaraid.*
 F:	drivers/scsi/megaraid/
 
-- 
2.21.1


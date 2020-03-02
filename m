Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7948C3F2D5
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4939246B6
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583137026;
	bh=vy+dLGrSL8+cXX3QG/G5aDP/hpGOIVd5o6AkEw1RqEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=kJxZ7Huj1MFcR+S3r7phtuw5R9c5hSSiYaZ7xfKLlAbqo7bQhY7H59Try7Lc0iybw
	 pjXMPocTJl8Iv6qCIEz47LuQxdNr6fwdik1ilFezhQEhgRlFhQ0JFixIdU6oyvW79G
	 ypTHXNl2IDLm07zlWzB805IiR6cmJADkc8O8Rycc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgCBIRF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 03:17:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:57210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727361AbgCBIQY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 03:16:24 -0500
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F35A52470A;
        Mon,  2 Mar 2020 08:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583136980;
        bh=vy+dLGrSL8+cXX3QG/G5aDP/hpGOIVd5o6AkEw1RqEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BtT32kPtbiWjqPVZom6G1TYIToxy1bNZGAuK663aUbJcU52TcAN3z1acU/awHusCR
         VjeC5o5EqZL4pyCnIu3uErzGzpRyvArFGvIoG01zH8J3slfiIKYI7xKPqyY9/BapBY
         i3WFdWHvKiCQsuRnWD3gSj97gUjfEbAP78K4atB8=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1j8gFO-0003zo-2m; Mon, 02 Mar 2020 09:16:18 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 40/42] docs: scsi: convert ufs.txt to ReST
Date:   Mon,  2 Mar 2020 09:16:13 +0100
Message-Id: <052d45576e342a217185e91a83793b384b1592a4.1583136624.git.mchehab+huawei@kernel.org>
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
 Documentation/scsi/index.rst            |  1 +
 Documentation/scsi/{ufs.txt => ufs.rst} | 84 ++++++++++++++++---------
 MAINTAINERS                             |  2 +-
 drivers/scsi/ufs/Kconfig                |  2 +-
 4 files changed, 57 insertions(+), 32 deletions(-)
 rename Documentation/scsi/{ufs.txt => ufs.rst} (79%)

diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
index df005cb94f6b..27720d145eff 100644
--- a/Documentation/scsi/index.rst
+++ b/Documentation/scsi/index.rst
@@ -44,5 +44,6 @@ Linux SCSI Subsystem
    sym53c500_cs
    sym53c8xx_2
    tcm_qla2xxx
+   ufs
 
    scsi_transport_srp/figures
diff --git a/Documentation/scsi/ufs.txt b/Documentation/scsi/ufs.rst
similarity index 79%
rename from Documentation/scsi/ufs.txt
rename to Documentation/scsi/ufs.rst
index 81842ec3e116..a920c0a5a1f6 100644
--- a/Documentation/scsi/ufs.txt
+++ b/Documentation/scsi/ufs.rst
@@ -1,24 +1,26 @@
-                       Universal Flash Storage
-                       =======================
+.. SPDX-License-Identifier: GPL-2.0
 
+=======================
+Universal Flash Storage
+=======================
 
-Contents
---------
 
-1. Overview
-2. UFS Architecture Overview
-  2.1 Application Layer
-  2.2 UFS Transport Protocol(UTP) layer
-  2.3 UFS Interconnect(UIC) Layer
-3. UFSHCD Overview
-  3.1 UFS controller initialization
-  3.2 UTP Transfer requests
-  3.3 UFS error handling
-  3.4 SCSI Error handling
+.. Contents
+
+   1. Overview
+   2. UFS Architecture Overview
+     2.1 Application Layer
+     2.2 UFS Transport Protocol(UTP) layer
+     2.3 UFS Interconnect(UIC) Layer
+   3. UFSHCD Overview
+     3.1 UFS controller initialization
+     3.2 UTP Transfer requests
+     3.3 UFS error handling
+     3.4 SCSI Error handling
 
 
 1. Overview
------------
+===========
 
 Universal Flash Storage(UFS) is a storage specification for flash devices.
 It is aimed to provide a universal storage interface for both
@@ -28,19 +30,25 @@ is defined by JEDEC Solid State Technology Association. UFS is based
 on MIPI M-PHY physical layer standard. UFS uses MIPI M-PHY as the
 physical layer and MIPI Unipro as the link layer.
 
-The main goals of UFS is to provide,
+The main goals of UFS is to provide:
+
  * Optimized performance:
-   For UFS version 1.0 and 1.1 the target performance is as follows,
-   Support for Gear1 is mandatory (rate A: 1248Mbps, rate B: 1457.6Mbps)
-   Support for Gear2 is optional (rate A: 2496Mbps, rate B: 2915.2Mbps)
+
+   For UFS version 1.0 and 1.1 the target performance is as follows:
+
+   - Support for Gear1 is mandatory (rate A: 1248Mbps, rate B: 1457.6Mbps)
+   - Support for Gear2 is optional (rate A: 2496Mbps, rate B: 2915.2Mbps)
+
    Future version of the standard,
-   Gear3 (rate A: 4992Mbps, rate B: 5830.4Mbps)
+
+   - Gear3 (rate A: 4992Mbps, rate B: 5830.4Mbps)
+
  * Low power consumption
  * High random IOPs and low latency
 
 
 2. UFS Architecture Overview
-----------------------------
+============================
 
 UFS has a layered communication architecture which is based on SCSI
 SAM-5 architectural model.
@@ -48,16 +56,22 @@ SAM-5 architectural model.
 UFS communication architecture consists of following layers,
 
 2.1 Application Layer
+---------------------
 
   The Application layer is composed of UFS command set layer(UCS),
   Task Manager and Device manager. The UFS interface is designed to be
   protocol agnostic, however SCSI has been selected as a baseline
   protocol for versions 1.0 and 1.1 of UFS protocol  layer.
+
   UFS supports subset of SCSI commands defined by SPC-4 and SBC-3.
-  * UCS: It handles SCSI commands supported by UFS specification.
-  * Task manager: It handles task management functions defined by the
+
+  * UCS:
+     It handles SCSI commands supported by UFS specification.
+  * Task manager:
+     It handles task management functions defined by the
      UFS which are meant for command queue control.
-  * Device manager: It handles device level operations and device
+  * Device manager:
+     It handles device level operations and device
      configuration operations. Device level operations mainly involve
      device power management operations and commands to Interconnect
      layers. Device level configurations involve handling of query
@@ -65,10 +79,12 @@ UFS communication architecture consists of following layers,
      information of the device.
 
 2.2 UFS Transport Protocol(UTP) layer
+-------------------------------------
 
   UTP layer provides services for
   the higher layers through Service Access Points. UTP defines 3
   service access points for higher layers.
+
   * UDM_SAP: Device manager service access point is exposed to device
     manager for device level operations. These device level operations
     are done through query requests.
@@ -76,20 +92,23 @@ UFS communication architecture consists of following layers,
     set layer(UCS) to transport commands.
   * UTP_TM_SAP: Task management service access point is exposed to task
     manager to transport task management functions.
+
   UTP transports messages through UFS protocol information unit(UPIU).
 
 2.3 UFS Interconnect(UIC) Layer
+-------------------------------
 
   UIC is the lowest layer of UFS layered architecture. It handles
   connection between UFS host and UFS device. UIC consists of
   MIPI UniPro and MIPI M-PHY. UIC provides 2 service access points
   to upper layer,
+
   * UIC_SAP: To transport UPIU between UFS host and UFS device.
   * UIO_SAP: To issue commands to Unipro layers.
 
 
 3. UFSHCD Overview
-------------------
+==================
 
 The UFS host controller driver is based on Linux SCSI Framework.
 UFSHCD is a low level device driver which acts as an interface between
@@ -98,12 +117,14 @@ SCSI Midlayer and PCIe based UFS host controllers.
 The current UFSHCD implementation supports following functionality,
 
 3.1 UFS controller initialization
+---------------------------------
 
   The initialization module brings UFS host controller to active state
   and prepares the controller to transfer commands/response between
   UFSHCD and UFS device.
 
 3.2 UTP Transfer requests
+-------------------------
 
   Transfer request handling module of UFSHCD receives SCSI commands
   from SCSI Midlayer, forms UPIUs and issues the UPIUs to UFS Host
@@ -112,11 +133,13 @@ The current UFSHCD implementation supports following functionality,
   of the status of the command.
 
 3.3 UFS error handling
+----------------------
 
   Error handling module handles Host controller fatal errors,
   Device fatal errors and UIC interconnect layer related errors.
 
 3.4 SCSI Error handling
+-----------------------
 
   This is done through UFSHCD SCSI error handling routines registered
   with SCSI Midlayer. Examples of some of the error handling commands
@@ -129,7 +152,7 @@ In this version of UFSHCD Query requests and power management
 functionality are not implemented.
 
 4. BSG Support
-------------------
+==============
 
 This transport driver supports exchanging UFS protocol information units
 (UPIUs) with a UFS device. Typically, user space will allocate
@@ -138,7 +161,7 @@ request_upiu and reply_upiu respectively.  Filling those UPIUs should
 be done in accordance with JEDEC spec UFS2.1 paragraph 10.7.
 *Caveat emptor*: The driver makes no further input validations and sends the
 UPIU to the device as it is.  Open the bsg device in /dev/ufs-bsg and
-send SG_IO with the applicable sg_io_v4:
+send SG_IO with the applicable sg_io_v4::
 
 	io_hdr_v4.guard = 'Q';
 	io_hdr_v4.protocol = BSG_PROTOCOL_SCSI;
@@ -166,6 +189,7 @@ upiu-based protocol is available at:
 For more detailed information about the tool and its supported
 features, please see the tool's README.
 
-UFS Specifications can be found at,
-UFS - http://www.jedec.org/sites/default/files/docs/JESD220.pdf
-UFSHCI - http://www.jedec.org/sites/default/files/docs/JESD223.pdf
+UFS Specifications can be found at:
+
+- UFS - http://www.jedec.org/sites/default/files/docs/JESD220.pdf
+- UFSHCI - http://www.jedec.org/sites/default/files/docs/JESD223.pdf
diff --git a/MAINTAINERS b/MAINTAINERS
index a3bfe6813e5e..9ac2a10ca41f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17204,7 +17204,7 @@ R:	Alim Akhtar <alim.akhtar@samsung.com>
 R:	Avri Altman <avri.altman@wdc.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
-F:	Documentation/scsi/ufs.txt
+F:	Documentation/scsi/ufs.rst
 F:	drivers/scsi/ufs/
 
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER DWC HOOKS
diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index d14c2243e02a..e2005aeddc2d 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -46,7 +46,7 @@ config SCSI_UFSHCD
 	  The module will be called ufshcd.
 
 	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/scsi/ufs.txt>.
+	  <file:Documentation/scsi/ufs.rst>.
 	  However, do not compile this as a module if your root file system
 	  (the one containing the directory /) is located on a UFS device.
 
-- 
2.21.1

